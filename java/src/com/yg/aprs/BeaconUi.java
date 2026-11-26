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

    /** 在地图上查看最近一次上报的位置。 */
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
        try {
            String geo = String.format(Locale.US, "geo:%.6f,%.6f?q=%.6f,%.6f(YG%%)", la, lo, la, lo);
            act.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(geo)));
            return;
        } catch (ActivityNotFoundException e) {
            // 没有地图 App，退到网页地图
        } catch (Throwable ignored) {
        }
        try {
            String url = String.format(Locale.US,
                    "https://www.openstreetmap.org/?mlat=%.6f&mlon=%.6f#map=16/%.6f/%.6f",
                    la, lo, la, lo);
            act.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
        } catch (Throwable t) {
            toast(act, "没有可用的地图应用");
        }
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
