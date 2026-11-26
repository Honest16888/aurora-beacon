package com.yg.aprs;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Locale;

/**
 * 界面侧的两个新动作：
 *   openMap(Activity)      —— 用系统地图打开最近一次上报的位置（无地图 App 时退到 OSM 网页）
 *   sendMessage(Activity)  —— 发送一条标准 APRS 消息报文
 *
 * 位置来源不新建状态：直接解析自己发出去的报文（{@link LastFix#parse}），
 * 保证"地图上的点"和"APRS-IS 上的点"完全一致。
 */
public final class BeaconUi {

    private BeaconUi() {
    }

    /** 最近一次成功上报的位置（从报文解析）。 */
    public static final class LastFix {

        private static volatile double lat;
        private static volatile double lon;
        private static volatile long time;
        private static volatile boolean has;
        private static volatile int seq;

        static void parse(String packet) {
            try {
                if (packet == null) {
                    return;
                }
                int i = packet.indexOf(":!");
                if (i < 0) {
                    return; // 不是位置报文（比如消息 "::"），不动
                }
                int p = i + 2;
                if (packet.length() < p + 18) {
                    return;
                }
                String latS = packet.substring(p, p + 8);       // ddmm.mmN
                String lonS = packet.substring(p + 9, p + 18);  // dddmm.mmE
                lat = dmToDeg(latS);
                lon = dmToDeg(lonS);
                time = System.currentTimeMillis();
                has = true;
            } catch (Throwable ignored) {
            }
        }

        private static double dmToDeg(String s) {
            char hemi = s.charAt(s.length() - 1);
            String num = s.substring(0, s.length() - 1);
            int dot = num.indexOf('.');
            String degPart = (dot == 2) ? num.substring(0, 2) : num.substring(0, 3);
            double deg = Double.parseDouble(degPart);
            double min = Double.parseDouble(num.substring(degPart.length()));
            double v = deg + min / 60.0;
            if (hemi == 'S' || hemi == 'W') {
                v = -v;
            }
            return v;
        }

        public static boolean has() {
            return has;
        }

        public static double lat() {
            return lat;
        }

        public static double lon() {
            return lon;
        }

        public static long time() {
            return time;
        }

        static int nextSeq() {
            seq = (seq >= 99) ? 1 : seq + 1;
            return seq;
        }
    }

    /**
     * 在地图上查看最近一次上报的位置。
     *
     * 顺序：百度地图 App → 高德地图 App → 系统地图选择器 → 高德网页(免 key) → OpenStreetMap。
     * 坐标系处理：APRS 用的是 WGS-84；百度用 `coord_type=wgs84` 直接给原始值，
     * 高德 App 的 scheme 只认 GCJ-02，所以先做一次 WGS→GCJ 纠偏（否则在国内会偏 300–600 米）。
     */
    public static void openMap(Activity act) {
        if (act == null) {
            return;
        }
        if (!LastFix.has()) {
            toast(act, "还没有定位数据，先启动上报");
            return;
        }
        final double la = LastFix.lat();
        final double lo = LastFix.lon();
        final String label = "极光信标";
        final String coord = String.format(Locale.US, "%.6f,%.6f", la, lo);

        // 1) 百度地图 App（原生支持 wgs84）
        if (tryOpen(act, "baidumap://map/marker?location=" + coord
                + "&title=" + Uri.encode(label)
                + "&content=" + Uri.encode(coord)
                + "&coord_type=wgs84&src=android.ygaprs")) {
            return;
        }
        // 2) 高德地图 App（需要 GCJ-02）
        double[] gcj = wgs2gcj(la, lo);
        String gcjLat = String.format(Locale.US, "%.6f", gcj[0]);
        String gcjLon = String.format(Locale.US, "%.6f", gcj[1]);
        if (tryOpen(act, "androidamap://viewMap?sourceApplication=ygaprs&poiname="
                + Uri.encode(label) + "&lat=" + gcjLat + "&lon=" + gcjLon + "&dev=0")) {
            return;
        }
        // 3) 系统地图选择器（Google/华为/其他，按 WGS-84）
        if (tryOpen(act, "geo:" + coord + "?q=" + coord + "(" + Uri.encode(label) + ")")) {
            return;
        }
        // 4) 高德网页版（免 key，coordinate=wgs84）
        if (tryOpen(act, "https://uri.amap.com/marker?position="
                + String.format(Locale.US, "%.6f,%.6f", lo, la)
                + "&name=" + Uri.encode(label) + "&coordinate=wgs84&callnative=0")) {
            return;
        }
        // 5) OpenStreetMap
        if (tryOpen(act, "https://www.openstreetmap.org/?mlat=" + la + "&mlon=" + lo
                + "#map=16/" + la + "/" + lo)) {
            return;
        }
        toast(act, "没有可用的地图应用");
    }

    private static boolean tryOpen(Activity act, String uri) {
        try {
            act.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(uri)));
            return true;
        } catch (ActivityNotFoundException e) {
            return false;
        } catch (Throwable t) {
            return false;
        }
    }

    /** WGS-84 → GCJ-02（高德/腾讯用）。国内范围外原样返回。 */
    static double[] wgs2gcj(double lat, double lon) {
        if (outOfChina(lat, lon)) {
            return new double[]{lat, lon};
        }
        final double a = 6378245.0;
        final double ee = 0.00669342162296594323;
        double dLat = transformLat(lon - 105.0, lat - 35.0);
        double dLon = transformLon(lon - 105.0, lat - 35.0);
        double radLat = lat / 180.0 * Math.PI;
        double magic = Math.sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = Math.sqrt(magic);
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * Math.PI);
        dLon = (dLon * 180.0) / (a / sqrtMagic * Math.cos(radLat) * Math.PI);
        return new double[]{lat + dLat, lon + dLon};
    }

    private static boolean outOfChina(double lat, double lon) {
        return lon < 72.004 || lon > 137.8347 || lat < 0.8293 || lat > 55.8271;
    }

    private static double transformLat(double x, double y) {
        double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y
                + 0.2 * Math.sqrt(Math.abs(x));
        ret += (20.0 * Math.sin(6.0 * x * Math.PI) + 20.0 * Math.sin(2.0 * x * Math.PI)) * 2.0 / 3.0;
        ret += (20.0 * Math.sin(y * Math.PI) + 40.0 * Math.sin(y / 3.0 * Math.PI)) * 2.0 / 3.0;
        ret += (160.0 * Math.sin(y / 12.0 * Math.PI) + 320 * Math.sin(y * Math.PI / 30.0)) * 2.0 / 3.0;
        return ret;
    }

    private static double transformLon(double x, double y) {
        double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y
                + 0.1 * Math.sqrt(Math.abs(x));
        ret += (20.0 * Math.sin(6.0 * x * Math.PI) + 20.0 * Math.sin(2.0 * x * Math.PI)) * 2.0 / 3.0;
        ret += (20.0 * Math.sin(x * Math.PI) + 40.0 * Math.sin(x / 3.0 * Math.PI)) * 2.0 / 3.0;
        ret += (150.0 * Math.sin(x / 12.0 * Math.PI) + 300.0 * Math.sin(x / 30.0 * Math.PI)) * 2.0 / 3.0;
        return ret;
    }

    /** 发送一条 APRS 消息：CALL-SSID>APRGQ,TCPIP*::ADDRESSEE:text{NN */
    public static void sendMessage(Activity act) {
        if (act == null) {
            return;
        }
        try {
            TextView to = find(act, "etMsgTo");
            TextView body = find(act, "etMsgText");
            if (to == null || body == null) {
                toast(act, "消息输入框未找到");
                return;
            }
            String dst = to.getText().toString().trim().toUpperCase(Locale.US);
            String msg = body.getText().toString().trim();
            if (dst.length() == 0) {
                toast(act, "请填写收件呼号");
                return;
            }
            if (msg.length() == 0) {
                toast(act, "请填写消息内容");
                return;
            }
            if (msg.length() > 67) {
                msg = msg.substring(0, 67);
            }

            String call = Prefs.INSTANCE.getCallsign(act);
            if (call == null) {
                call = "";
            }
            int ssid = Prefs.INSTANCE.getSsid(act);
            String host = Prefs.INSTANCE.getHost(act);
            int port = Prefs.INSTANCE.getPort(act);
            String full = AprsPasscode.INSTANCE.fullCall(call, ssid);
            int pass = AprsPasscode.INSTANCE.compute(call);

            String packet = full + ">APRGQ,TCPIP*::" + pad(dst, 9) + ":" + msg
                    + String.format(Locale.US, "{%02d", LastFix.nextSeq());

            BeaconSend.configure(act, host, port, full, pass);
            if (MsgAgent.isConnected()) {
                // 常驻连接在跑：进队列，由 MsgAgent 负责发送/重试/收 ack
                MsgCenter.enqueue(dst, msg);
                NetLog.note("message queued -> " + dst + " len=" + msg.length());
                toast(act, "已加入发送队列：" + dst);
                body.setText("");
                return;
            }
            // 常驻连接没起来（例如服务未启动）：仍然用一次性连接发掉
            boolean ok = BeaconSend.send(packet);
            NetLog.note("message -> " + dst + " ok=" + ok + " len=" + msg.length());
            toast(act, ok ? "消息已提交给 APRS-IS：" + dst : "发送失败，详见 net.log");
            if (ok) {
                body.setText("");
            }
        } catch (Throwable t) {
            NetLog.note("message failed: " + t);
            toast(act, "发送失败：" + t);
        }
    }

    /** 把收件箱/发件箱快照刷到界面上。 */
    public static void refreshInbox(Activity act) {
        if (act == null) {
            return;
        }
        try {
            TextView tv = find(act, "tvInbox");
            if (tv == null) {
                toast(act, "收件箱控件未找到");
                return;
            }
            tv.setText(MsgCenter.render());
        } catch (Throwable t) {
            toast(act, "刷新失败：" + t);
        }
    }

    private static String pad(String s, int len) {
        if (s.length() >= len) {
            return s.substring(0, len);
        }
        StringBuilder sb = new StringBuilder(s);
        while (sb.length() < len) {
            sb.append(' ');
        }
        return sb.toString();
    }

    private static TextView find(Activity act, String name) {
        try {
            int id = act.getResources().getIdentifier(name, "id", act.getPackageName());
            if (id == 0) {
                return null;
            }
            View v = act.findViewById(id);
            return (v instanceof TextView) ? (TextView) v : null;
        } catch (Throwable t) {
            return null;
        }
    }

    private static void toast(Context c, String msg) {
        try {
            Toast.makeText(c, msg, Toast.LENGTH_SHORT).show();
        } catch (Throwable ignored) {
        }
    }
}
