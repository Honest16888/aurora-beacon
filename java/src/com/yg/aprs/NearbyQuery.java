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

/**
 * 附近台站：用 APRS-IS 的**范围过滤**（`filter r/lat/lon/km`）订阅周边报文，
 * 读 8 秒，解析位置包，按距离排序后列出来。
 *
 * 不需要任何 API key —— 走的就是我们自己那条协议。
 * 结果只保留每个呼号最新的一次位置。
 */
public final class NearbyQuery {

    private static final int RADIUS_KM = 60;
    private static final long WINDOW_MS = 8000L;
    private static final int MAX_SHOW = 30;

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

    /** 入口：弹列表（后台线程查询）。 */
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
                final List<Station> list = query(act, lat, lon);
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

    private static List<Station> query(Context ctx, double lat, double lon) {
        final Map<String, Station> found = new HashMap<String, Station>();
        Socket socket = null;
        try {
            MsgUi.fixCallsignPrefs(ctx);
            String call = Prefs.INSTANCE.getCallsign(ctx);
            if (call == null) {
                call = "";
            }
            int ssid = Prefs.INSTANCE.getSsid(ctx);
            String host = Prefs.INSTANCE.getHost(ctx);
            int port = Prefs.INSTANCE.getPort(ctx);
            String full = AprsPasscode.INSTANCE.fullCall(call, ssid);
            int pass = AprsPasscode.INSTANCE.compute(call);
            if (call.length() == 0 || host == null || port <= 0) {
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
            w.write("user " + full + " pass " + pass + " vers AuroraBeacon 1.6.1\r\n");
            w.write(String.format(Locale.US, "filter r/%f/%f/%d\r\n", lat, lon, RADIUS_KM));
            w.flush();
            NetLog.note("nearby: query r/" + lat + "/" + lon + "/" + RADIUS_KM);

            long deadline = System.currentTimeMillis() + WINDOW_MS;
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
                Station st = parse(line, lat, lon);
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
            NetLog.note("nearby failed: " + t);
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
        NetLog.note("nearby: found " + list.size());
        return list;
    }

    /** 解析 `CALL>path:!ddmm.mmN/ dddmm.mmE>comment` 这类非压缩位置包。 */
    static Station parse(String line, double myLat, double myLon) {
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
            if (colon < 0 || line.length() < colon + 22) {
                return null;
            }
            char dti = line.charAt(colon + 1);
            if (dti != '!' && dti != '=') {
                return null; // 只处理无时间戳的位置包
            }
            int p = colon + 2;
            String latS = line.substring(p, p + 8);
            char table = line.charAt(p + 8);
            String lonS = line.substring(p + 9, p + 18);
            if (table != '/' && table != '\\') {
                return null;
            }
            double lat = dmToDeg(latS);
            double lon = dmToDeg(lonS);
            if (Double.isNaN(lat) || Double.isNaN(lon)) {
                return null;
            }
            if (lat == 0 && lon == 0) {
                return null;
            }
            String comment = line.length() > p + 19 ? line.substring(p + 19).trim() : "";
            double km = haversine(myLat, myLon, lat, lon);
            if (km > RADIUS_KM * 1.6) {
                return null;
            }
            return new Station(call, lat, lon, km, comment);
        } catch (Throwable t) {
            return null;
        }
    }

    private static double dmToDeg(String s) {
        try {
            char hemi = s.charAt(s.length() - 1);
            String num = s.substring(0, s.length() - 1);
            int dot = num.indexOf('.');
            if (dot < 0) {
                return Double.NaN;
            }
            // "ddmm.mm" 的点在索引 4，"dddmm.mm" 的点在索引 5；度数位数 = dot - 2
            int degDigits = dot - 2;
            if (degDigits <= 0) {
                return Double.NaN;
            }
            String degPart = num.substring(0, degDigits);
            double deg = Double.parseDouble(degPart);
            double min = Double.parseDouble(num.substring(degPart.length()));
            if (min >= 60) {
                return Double.NaN;
            }
            double v = deg + min / 60.0;
            if (hemi == 'S' || hemi == 'W') {
                v = -v;
            }
            return v;
        } catch (Throwable t) {
            return Double.NaN;
        }
    }

    private static double haversine(double lat1, double lon1, double lat2, double lon2) {
        double r = 6371.0;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        return 2 * r * Math.asin(Math.min(1.0, Math.sqrt(a)));
    }

    private static void showList(final Activity act, List<Station> list, double lat, double lon) {
        if (list.isEmpty()) {
            AlertDialog.Builder b = new AlertDialog.Builder(act);
            b.setTitle("附近台站");
            b.setMessage("8 秒内没有收到 " + RADIUS_KM + " 公里内的位置包。\n\n"
                    + "可能是周边确实没有活动台站，或服务器过滤未生效（换 rotate.aprs2.net 再试）。\n\n"
                    + "也可以直接看 aprs.fi 的在线地图。");
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
        int n = Math.min(list.size(), MAX_SHOW);
        final List<Station> shown = list.subList(0, n);
        String[] items = new String[n];
        for (int i = 0; i < n; i++) {
            Station st = shown.get(i);
            String note = st.comment.length() > 22 ? st.comment.substring(0, 22) + "…" : st.comment;
            items[i] = String.format(Locale.US, "%s   %.1f km %s\n%s",
                    st.call, st.km, bearing(lat, lon, st.lat, st.lon), note);
        }
        AlertDialog.Builder b = new AlertDialog.Builder(act);
        b.setTitle("附近台站（" + shown.size() + "/" + list.size() + "）");
        b.setItems(items, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface d, int which) {
                Station st = shown.get(which);
                openUrl(act, "https://aprs.fi/info/a/" + Uri.encode(st.call));
            }
        });
        b.setNegativeButton("关闭", null);
        b.show();
    }

    /** 粗略 8 方位。 */
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
