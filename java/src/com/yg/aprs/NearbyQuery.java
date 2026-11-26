package com.yg.aprs;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 台站查询：用 APRS-IS 过滤捞周边 / 全国的台站。
 *
 * 位置解析对齐 APRS101 + aprslib/APRSLocus 的参考实现：
 *   - 非压缩 DDMM.mmN（含位置模糊空格）
 *   - 压缩 Base91（固定段 13 字符：表(1)+纬(4)+经(4)+符号(1)+csT(2)，已对 aprslib 0.7.2 核实）
 *   - 带时间戳的 / 与 @（跳过 7 字符时间戳）
 *   - Mic-E（位置编码在目的呼号 + 信息字段）
 */
public final class NearbyQuery {

    private static final int RADIUS_KM = 60;
    private static final long WINDOW_MS = 8000L;
    private static final int MAX_SHOW = 30;

    private static final double CN_LAT1 = 17.5;
    private static final double CN_LON1 = 73.0;
    private static final double CN_LAT2 = 54.5;
    private static final double CN_LON2 = 135.5;

    /**
     * 全国范围用**半径过滤**而不是 b/ 矩形：实测 aprsc 3.0 对
     * `b/17.5/73.0/54.5/135.5` 45 秒 0 流量，而 `r/35.0/105.0/2500` 同时段 215 行。
     * 以武汉为圆心 3500km 覆盖中国全境（含新疆边缘）。
     */
    private static final String CN_FILTER = "r/35.0/105.0/3500";

    private NearbyQuery() {
    }

    public static final class Station {
        public final String call;
        public final double lat;
        public final double lon;
        public final double km;
        public final String comment;
        public final long time;

        Station(String call, double lat, double lon, double km, String comment) {
            this.call = call;
            this.lat = lat;
            this.lon = lon;
            this.km = km;
            this.comment = comment;
            this.time = System.currentTimeMillis();
        }
    }

    /** 解析出的裸坐标 + 备注。 */
    private static final class Pos {
        final double lat;
        final double lon;
        final String comment;

        Pos(double lat, double lon, String comment) {
            this.lat = lat;
            this.lon = lon;
            this.comment = comment == null ? "" : comment;
        }
    }

    // ------------------------------------------------------------------
    // 查询
    // ------------------------------------------------------------------

    /** 入口：周边台站列表（详情对话框）。 */
    public static void run(final Activity act) {
        if (act == null) {
            return;
        }
        if (!BeaconUi.LastFix.has()) {
            toast(act, "还没有定位数据，先启动上报");
            return;
        }
        final double lat = BeaconUi.LastFix.lat();
        final double lon = BeaconUi.LastFix.lon();
        toast(act, "正在查询 " + RADIUS_KM + " 公里内的台站（约 8 秒）…");
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                final List<Station> list = queryRadius(act, lat, lon);
                act.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        showList(act, list, lat, lon);
                    }
                });
            }
        }, "yg-nearby");
        t.setDaemon(true);
        t.start();
    }

    public static List<Station> queryRadius(Context ctx, double lat, double lon) {
        String filter = String.format(Locale.US, "r/%f/%f/%d", lat, lon, RADIUS_KM);
        return queryWithFilter(ctx, filter, lat, lon, WINDOW_MS);
    }

    /** 全国：中国范围（半径 3500km，见 CN_FILTER 注释）。 */
    public static List<Station> queryChina(Context ctx) {
        double refLat = (CN_LAT1 + CN_LAT2) / 2.0;
        double refLon = (CN_LON1 + CN_LON2) / 2.0;
        return queryWithFilter(ctx, CN_FILTER, refLat, refLon, 12000L);
    }

    public static List<Station> queryWithFilter(Context ctx, String filterLine,
                                                double refLat, double refLon, long windowMs) {
        String host = Prefs.INSTANCE.getHost(ctx);
        int port = Prefs.INSTANCE.getPort(ctx);
        return queryOnce(ctx, host, port, filterLine, refLat, refLon, windowMs);
    }

    /** 连一次、登录、发 filter、读到窗口结束、断开。 */
    private static List<Station> queryOnce(Context ctx, String host, int port,
                                           String filterLine, double refLat, double refLon,
                                           long windowMs) {
        final Map<String, Station> found = new HashMap<String, Station>();
        int lines = 0;
        Socket socket = null;
        try {
            MsgUi.fixCallsignPrefs(ctx);
            String call = Prefs.INSTANCE.getCallsign(ctx);
            if (call == null) {
                call = "";
            }
            int ssid = Prefs.INSTANCE.getSsid(ctx);
            String full = AprsPasscode.INSTANCE.fullCall(call, ssid);
            int pass = AprsPasscode.INSTANCE.compute(call);
            if (call.length() == 0 || host == null || host.length() == 0 || port <= 0) {
                NetLog.note("query skip: config incomplete");
                return new ArrayList<Station>();
            }

            socket = new Socket();
            socket.setKeepAlive(true);
            socket.connect(new InetSocketAddress(host, port), 12000);
            socket.setSoTimeout(1200);
            BufferedWriter w = new BufferedWriter(
                    new OutputStreamWriter(socket.getOutputStream(), "UTF-8"));
            BufferedReader r = new BufferedReader(
                    new InputStreamReader(socket.getInputStream(), "UTF-8"));
            w.write("user " + full + " pass " + pass + " vers AuroraBeacon 1.8.2 filter "
                    + filterLine + "\r\n");
            w.flush();
            NetLog.note("query " + host + ":" + port + " filter " + filterLine + " (inline)");

            long deadline = System.currentTimeMillis() + windowMs;
            while (System.currentTimeMillis() < deadline) {
                String line;
                try {
                    line = r.readLine();
                } catch (SocketTimeoutException te) {
                    continue;
                }
                if (line == null) {
                    break;
                }
                lines++;
                Station st = parse(line, refLat, refLon);
                if (st == null) {
                    continue;
                }
                if (st.call.equalsIgnoreCase(full) || st.call.equalsIgnoreCase(call)) {
                    continue;
                }
                Station old = found.get(st.call);
                if (old == null || st.time >= old.time) {
                    found.put(st.call, st);
                }
            }
        } catch (Throwable t) {
            NetLog.note("query failed: " + t);
        } finally {
            try {
                if (socket != null) {
                    socket.close();
                }
            } catch (Throwable ignored) {
            }
        }
        List<Station> list = new ArrayList<Station>(found.values());
        Collections.sort(list, new Comparator<Station>() {
            @Override
            public int compare(Station a, Station b) {
                return Double.compare(a.km, b.km);
            }
        });
        NetLog.note("query done lines=" + lines + " stations=" + list.size());
        return list;
    }

    // ------------------------------------------------------------------
    // 位置解析（对齐 APRS101 / APRSLocus 参考实现）
    // ------------------------------------------------------------------

    static Station parse(String line, double refLat, double refLon) {
        try {
            int gt = line.indexOf('>');
            if (gt <= 0) {
                return null;
            }
            String call = line.substring(0, gt).trim();
            if (call.length() == 0) {
                return null;
            }
            int colon = line.indexOf(':', gt);
            if (colon < 0) {
                return null;
            }
            String destField = line.substring(gt + 1, colon);
            String body = line.substring(colon + 1);
            if (body.length() == 0) {
                return null;
            }

            Pos pos = parseBody(body, destField);
            if (pos == null) {
                return null;
            }
            if (pos.lat < -90 || pos.lat > 90 || pos.lon < -180 || pos.lon > 180) {
                return null;
            }
            if (pos.lat == 0 && pos.lon == 0) {
                return null;
            }
            double km = haversine(refLat, refLon, pos.lat, pos.lon);
            return new Station(call, pos.lat, pos.lon, km, pos.comment);
        } catch (Throwable t) {
            return null;
        }
    }

    private static Pos parseBody(String body, String destField) {
        char dti = body.charAt(0);
        if (dti == '\'' || dti == '`') {
            return parseMicE(destField, body);
        }
        if (dti != '!' && dti != '=' && dti != '/' && dti != '@') {
            return null;
        }
        String s = body.substring(1);
        if (dti == '/' || dti == '@') {
            if (s.length() < 8) {
                return null;
            }
            s = s.substring(7);   // 跳过 7 字符时间戳
        }
        if (s.length() == 0) {
            return null;
        }
        Pos c = parseCompressed(s);
        if (c != null) {
            return c;
        }
        return parseNormal(s);
    }

    // ---------- 非压缩 ----------
    private static final Pattern NORMAL = Pattern.compile(
            "^(\\d{2})([0-9 ]{2}\\.[0-9 ]{2})([NnSs])([/\\\\0-9A-Z])"
                    + "(\\d{3})([0-9 ]{2}\\.[0-9 ]{2})([EeWw])([\\x21-\\x7e])(.*)$",
            Pattern.DOTALL);

    private static Pos parseNormal(String s) {
        Matcher m = NORMAL.matcher(s);
        if (!m.find()) {
            return null;
        }
        // group: 1 latDeg, 2 latMin, 3 latDir, 4 table,
        //        5 lonDeg, 6 lonMin, 7 lonDir, 8 symbol, 9 comment
        String latMin = m.group(2);
        String lonDegStr = m.group(5);
        String lonMin = m.group(6);
        String latDir = m.group(3);
        String lonDir = m.group(7);

        int ambLat = countSpaces(latMin);
        int ambLon = countSpaces(lonMin);
        if (ambLat != ambLon) {
            return null;
        }
        if (ambLat >= 4) {
            latMin = "30";
            lonMin = "30";
        } else if (ambLat > 0) {
            latMin = latMin.replace(' ', '5');
            lonMin = lonMin.replace(' ', '5');
        }
        double latDeg = parseD(m.group(1));
        double lonDeg = parseD(lonDegStr);
        double la = parseD(latMin);
        double lo = parseD(lonMin);
        if (Double.isNaN(la) || Double.isNaN(lo) || la >= 60 || lo >= 60) {
            return null;
        }
        if (latDeg > 89 || lonDeg > 179) {
            return null;
        }
        double lat = latDeg + la / 60.0;
        double lon = lonDeg + lo / 60.0;
        if (latDir.equalsIgnoreCase("S")) {
            lat = -lat;
        }
        if (lonDir.equalsIgnoreCase("W")) {
            lon = -lon;
        }
        String comment = cleanComment(m.group(9));
        return new Pos(lat, lon, comment);
    }

    // ---------- 压缩（Base91） ----------
    private static Pos parseCompressed(String s) {
        if (s.length() < 13) {
            return null;
        }
        char c0 = s.charAt(0);
        boolean tableOk = c0 == '/' || c0 == '\\'
                || (c0 >= 'A' && c0 <= 'Z') || (c0 >= 'a' && c0 <= 'j');
        if (!tableOk) {
            return null;
        }
        for (int i = 1; i <= 8; i++) {          // [!-|]
            char c = s.charAt(i);
            if (c < 0x21 || c > 0x7c) {
                return null;
            }
        }
        char sym = s.charAt(9);                 // [!-{}]
        if (sym < 0x21 || sym > 0x7d) {
            return null;
        }
        for (int i = 10; i <= 12; i++) {        // [ -|]
            char c = s.charAt(i);
            if (c < 0x20 || c > 0x7c) {
                return null;
            }
        }
        long latN = b91(s.substring(1, 5));
        long lonN = b91(s.substring(5, 9));
        if (latN < 0 || lonN < 0) {
            return null;
        }
        double lat = 90 - latN / 380926.0;
        double lon = -180 + lonN / 190463.0;
        if (lat < -90 || lat > 90 || lon < -180 || lon > 180) {
            return null;
        }
        String rest = s.length() > 13 ? s.substring(13) : "";
        return new Pos(lat, lon, cleanComment(rest));
    }

    /** APRS Base91：取值 = ASCII - 33；非法字符返回 -1。 */
    private static long b91(String s) {
        long n = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c < 0x21 || c > 0x7b) {
                return -1;
            }
            n = n * 91 + (c - 33);
        }
        return n;
    }

    // ---------- Mic-E ----------
    private static final Pattern MICE_DEST = Pattern.compile("^[0-9A-Z]{3}[0-9L-Z]{3}$");
    private static final Pattern MICE_TEL = Pattern.compile("^('[0-9a-fA-F]{10}|`[0-9a-fA-F]{4})");

    private static Pos parseMicE(String destField, String body) {
        try {
            String dest0 = destField.split(",")[0];
            String dest = dest0.split("-")[0];
            if (dest.length() != 6 || !MICE_DEST.matcher(dest).find()) {
                return null;
            }
            String info = body.substring(1);
            if (info.length() < 8) {
                return null;
            }

            // 纬度：目的呼号 6 字符各映射 1 位数字
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 6; i++) {
                char ch = dest.charAt(i);
                int o = ch;
                if (ch == 'K' || ch == 'L' || ch == 'Z') {
                    sb.append(' ');
                } else if (o > 76) {          // M-Z → P=0..Y=9
                    sb.append((char) (o - 32));
                } else if (o > 57) {          // A-J → 0-9
                    sb.append((char) (o - 17));
                } else {
                    sb.append(ch);
                }
            }
            String ds = sb.toString();
            int amb = 0;
            int i = 6;
            while (i > 0 && ds.charAt(i - 1) == ' ') {
                amb++;
                i--;
            }
            for (int j = 0; j < i; j++) {
                if (!Character.isDigit(ds.charAt(j))) {
                    return null;              // 空格不在末尾，格式不合法
                }
            }
            char[] dl = ds.toCharArray();
            if (amb >= 4 && amb > 0) {
                dl[2] = '3';
            } else if (amb > 0) {
                dl[6 - amb] = '5';
            }
            String d = new String(dl);
            double latMin = parseD(d.substring(2, 4) + "." + d.substring(4, 6).replace(' ', '0'));
            if (Double.isNaN(latMin)) {
                return null;
            }
            double lat = Integer.parseInt(d.substring(0, 2)) + latMin / 60.0;
            if (dest.charAt(3) <= 'L') {
                lat = -lat;
            }

            // 经度
            double lon = info.charAt(0) - 28;
            if (dest.charAt(4) >= 'P') {
                lon += 100;
            }
            if (lon >= 180 && lon <= 189) {
                lon -= 80;
            }
            if (lon >= 190 && lon <= 199) {
                lon -= 190;
            }
            double lonMin = info.charAt(1) - 28;
            if (lonMin >= 60) {
                lonMin -= 60;
            }
            lonMin += (info.charAt(2) - 28) / 100.0;
            if (amb == 4) {
                lonMin = 30;
            } else if (amb == 3) {
                lonMin = (Math.floor(lonMin / 10) + 0.5) * 10;
            } else if (amb == 2) {
                lonMin = Math.floor(lonMin) + 0.5;
            } else if (amb == 1) {
                lonMin = (Math.floor(lonMin * 10) + 0.5) / 10.0;
            }
            lon = lon + lonMin / 60.0;
            if (dest.charAt(5) >= 'P') {
                lon = -lon;
            }
            if (lat < -90 || lat > 90 || lon < -180 || lon > 180) {
                return null;
            }

            // 备注
            String rest = info.substring(8);
            Matcher tel = MICE_TEL.matcher(rest);
            if (tel.find()) {
                rest = rest.substring(tel.end());
            }
            if (rest.length() > 0 && (rest.charAt(0) == ']' || rest.charAt(0) == '}')) {
                rest = rest.substring(1);
            }
            return new Pos(lat, lon, cleanComment(rest));
        } catch (Throwable t) {
            return null;
        }
    }

    // ---------- 备注清理 ----------
    private static final Pattern ALT = Pattern.compile("/A=(-?\\d{5,6})");
    private static final Pattern CST = Pattern.compile("^\\s*\\d{3}/\\d{2,3}(?![0-9])");

    private static String cleanComment(String c) {
        if (c == null) {
            return "";
        }
        String s = c;
        s = ALT.matcher(s).replaceAll("");
        s = CST.matcher(s).replaceFirst("");
        s = s.trim();
        return s;
    }

    private static int countSpaces(String s) {
        int n = 0;
        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == ' ') {
                n++;
            }
        }
        return n;
    }

    private static double parseD(String s) {
        try {
            return Double.parseDouble(s);
        } catch (Throwable t) {
            return Double.NaN;
        }
    }

    static double haversine(double lat1, double lon1, double lat2, double lon2) {
        double r = 6371.0;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        return 2 * r * Math.asin(Math.min(1.0, Math.sqrt(a)));
    }

    // ------------------------------------------------------------------
    // 界面
    // ------------------------------------------------------------------

    private static void showList(final Activity act, List<Station> list, double lat, double lon) {
        if (list.isEmpty()) {
            AlertDialog.Builder b = new AlertDialog.Builder(act);
            b.setTitle("附近台站");
            b.setMessage("窗口内没有收到位置包。\n\n"
                    + "net.log 里有 query 行可判断是连不上还是没解析出位置。");
            b.setPositiveButton("看 aprs.fi", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface d, int w) {
                    openUrl(act, String.format(Locale.US,
                            "https://aprs.fi/#!lat=%.6f&lng=%.6f&z=12", lat, lon));
                }
            });
            b.setNegativeButton("关闭", null);
            b.show();
            return;
        }
        showDetailList(act, list);
    }

    /** 详情列表：点条目看详情对话框，不跳外部浏览器。 */
    public static void showDetailList(final Activity act, List<Station> list) {
        if (act == null) {
            return;
        }
        if (list == null || list.isEmpty()) {
            AlertDialog.Builder b = new AlertDialog.Builder(act);
            b.setTitle("台站");
            b.setMessage("没有收到位置包。");
            b.setPositiveButton("关闭", null);
            b.show();
            return;
        }
        int n = Math.min(list.size(), MAX_SHOW);
        final List<Station> shown = list.subList(0, n);
        String[] items = new String[n];
        for (int i = 0; i < n; i++) {
            Station st = shown.get(i);
            String note = st.comment.length() > 22 ? st.comment.substring(0, 22) + "…" : st.comment;
            items[i] = String.format(Locale.US, "%s   %.1f km %s\n%s",
                    st.call, st.km, bearing(beaconLat(), beaconLon(), st.lat, st.lon), note);
        }
        AlertDialog.Builder b = new AlertDialog.Builder(act);
        b.setTitle("台站（" + shown.size() + "/" + list.size() + "）");
        b.setItems(items, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface d, int which) {
                showStationDetail(act, shown.get(which));
            }
        });
        b.setNegativeButton("关闭", null);
        b.show();
    }

    private static double beaconLat() {
        return BeaconUi.LastFix.has() ? BeaconUi.LastFix.lat() : 0;
    }

    private static double beaconLon() {
        return BeaconUi.LastFix.has() ? BeaconUi.LastFix.lon() : 0;
    }

    private static void showStationDetail(final Activity act, final Station st) {
        try {
            AlertDialog.Builder b = new AlertDialog.Builder(act);
            b.setTitle(st.call);
            b.setMessage(String.format(Locale.US,
                    "距离：%.1f km（%s）\n坐标：%.5f, %.5f\n备注：%s\n最后出现：%s",
                    st.km,
                    bearing(beaconLat(), beaconLon(), st.lat, st.lon),
                    st.lat, st.lon,
                    st.comment.length() == 0 ? "-" : st.comment,
                    new java.text.SimpleDateFormat("MM-dd HH:mm", Locale.US)
                            .format(new java.util.Date(st.time))));
            b.setPositiveButton("复制呼号", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface d, int w) {
                    try {
                        android.content.ClipboardManager cm = (android.content.ClipboardManager)
                                act.getSystemService(Context.CLIPBOARD_SERVICE);
                        if (cm != null) {
                            cm.setPrimaryClip(android.content.ClipData.newPlainText("call", st.call));
                        }
                        toast(act, "已复制 " + st.call);
                    } catch (Throwable ignored) {
                    }
                }
            });
            b.setNegativeButton("关闭", null);
            b.show();
        } catch (Throwable ignored) {
        }
    }

    private static String bearing(double lat1, double lon1, double lat2, double lon2) {
        try {
            double y = Math.sin(Math.toRadians(lon2 - lon1)) * Math.cos(Math.toRadians(lat2));
            double x = Math.cos(Math.toRadians(lat1)) * Math.sin(Math.toRadians(lat2))
                    - Math.sin(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                    * Math.cos(Math.toRadians(lon2 - lon1));
            double deg = Math.toDegrees(Math.atan2(y, x));
            if (deg < 0) {
                deg += 360;
            }
            String[] names = {"N", "NE", "E", "SE", "S", "SW", "W", "NW"};
            return names[(int) Math.round(deg / 45.0) % 8];
        } catch (Throwable t) {
            return "";
        }
    }

    private static void openUrl(Activity act, String url) {
        try {
            act.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
        } catch (Throwable t) {
            toast(act, "无法打开链接");
        }
    }

    private static void toast(Context c, String m) {
        try {
            Toast.makeText(c, m, Toast.LENGTH_SHORT).show();
        } catch (Throwable ignored) {
        }
    }
}
