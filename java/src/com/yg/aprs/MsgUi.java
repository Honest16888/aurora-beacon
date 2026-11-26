package com.yg.aprs;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.text.InputType;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.util.List;
import java.util.Locale;

/**
 * 消息相关界面：收件箱列表 → 详情 → 快捷回复 / 复制。
 *
 * 用系统 AlertDialog（不依赖 androidx，编译期只需 android.jar），
 * 布局不需要任何改动，所有交互都在这里闭环。
 */
public final class MsgUi {

    private MsgUi() {
    }

    /** 「收件箱」按钮：弹出消息列表，点某条看详情。 */
    public static void showInbox(final Activity act) {
        if (act == null) {
            return;
        }
        MsgCenter.ensureLoaded(act);
        // 顺便把卡片下方的摘要刷新一下
        try {
            TextView summary = find(act, "tvInbox");
            if (summary != null) {
                summary.setText(MsgCenter.render());
            }
        } catch (Throwable ignored) {
        }
        final List<MsgCenter.Item> list = MsgCenter.inboxSnapshot();
        if (list.isEmpty()) {
            toast(act, "暂无收到的消息");
            return;
        }
        final String[] titles = new String[list.size()];
        for (int i = 0; i < list.size(); i++) {
            MsgCenter.Item it = list.get(i);
            titles[i] = it.time + "  " + it.from + "\n" + clip(it.text, 40);
        }
        try {
            AlertDialog.Builder b = new AlertDialog.Builder(act);
            b.setTitle("收件箱（" + list.size() + " 条）");
            b.setItems(titles, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface d, int which) {
                    if (which >= 0 && which < list.size()) {
                        showDetail(act, list.get(which));
                    }
                }
            });
            b.setNeutralButton("清空", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface d, int w) {
                    MsgCenter.clearInbox();
                    toast(act, "收件箱已清空");
                }
            });
            b.setNegativeButton("关闭", null);
            b.show();
        } catch (Throwable t) {
            toast(act, "打开收件箱失败：" + t);
        }
    }

    private static void showDetail(final Activity act, final MsgCenter.Item it) {
        try {
            AlertDialog.Builder b = new AlertDialog.Builder(act);
            b.setTitle("来自 " + it.from);
            b.setMessage(it.time + "\n\n" + it.text);
            b.setPositiveButton("快捷回复", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface d, int w) {
                    askReply(act, it.from);
                }
            });
            b.setNeutralButton("复制正文", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface d, int w) {
                    copy(act, it.text);
                }
            });
            b.setNegativeButton("关闭", null);
            b.show();
        } catch (Throwable t) {
            toast(act, "打开消息失败：" + t);
        }
    }

    private static void askReply(final Activity act, final String dst) {
        try {
            final EditText input = new EditText(act);
            input.setHint("回复 " + dst + "（≤67 字符）");
            input.setInputType(InputType.TYPE_CLASS_TEXT);
            input.setTextSize(15f);

            AlertDialog.Builder b = new AlertDialog.Builder(act);
            b.setTitle("回复 " + dst);
            b.setView(input);
            b.setPositiveButton("发送", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface d, int w) {
                    sendTo(act, dst, input.getText().toString());
                }
            });
            b.setNegativeButton("取消", null);
            b.show();
        } catch (Throwable t) {
            toast(act, "打开回复框失败：" + t);
        }
    }

    /** 消息卡「发送」：读两个输入框，交给 sendTo。 */
    public static void sendFromFields(Activity act) {
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
            String dst = normalizeCall(to.getText().toString());
            String msg = body.getText().toString().trim();
            if (dst.length() == 0) {
                toast(act, "请填写收件呼号（可带 -SSID）");
                return;
            }
            if (msg.length() == 0) {
                toast(act, "请填写消息内容");
                return;
            }
            to.setText(dst);
            if (sendTo(act, dst, msg)) {
                body.setText("");
            }
        } catch (Throwable t) {
            toast(act, "发送失败：" + t);
        }
    }

    /** 真正的发送：常驻连接在跑就进队列，否则一次性连接直接发。 */
    public static boolean sendTo(Activity act, String dstRaw, String textRaw) {
        if (act == null) {
            return false;
        }
        try {
            MsgCenter.ensureLoaded(act);
            String dst = normalizeCall(dstRaw);
            String text = (textRaw == null) ? "" : textRaw.trim();
            if (dst.length() == 0) {
                toast(act, "收件呼号无效");
                return false;
            }
            if (text.length() == 0) {
                toast(act, "消息内容为空");
                return false;
            }
            if (text.length() > 67) {
                text = text.substring(0, 67);
            }
            fixCallsignPrefs(act);

            String call = Prefs.INSTANCE.getCallsign(act);
            if (call == null) {
                call = "";
            }
            int ssid = Prefs.INSTANCE.getSsid(act);
            String host = Prefs.INSTANCE.getHost(act);
            int port = Prefs.INSTANCE.getPort(act);
            String full = AprsPasscode.INSTANCE.fullCall(call, ssid);
            int pass = AprsPasscode.INSTANCE.compute(call);

            if (MsgAgent.isConnected()) {
                MsgCenter.enqueue(dst, text);
                NetLog.note("message queued -> " + dst + " len=" + text.length());
                toast(act, "已加入发送队列：" + dst);
                return true;
            }

            String packet = full + ">APRGQ,TCPIP*::" + MsgCenter.pad(dst, 9) + ":" + text
                    + String.format(Locale.US, "{%02d", MsgCenter.nextSeq());
            BeaconSend.configure(act, host, port, full, pass);
            boolean ok = BeaconSend.send(packet);
            NetLog.note("message -> " + dst + " ok=" + ok + " len=" + text.length());
            toast(act, ok ? "消息已提交给 APRS-IS：" + dst : "发送失败，详见 net.log");
            return ok;
        } catch (Throwable t) {
            NetLog.note("message failed: " + t);
            toast(act, "发送失败：" + t);
            return false;
        }
    }

    /**
     * 收件呼号规范化：大写、去空格、全角转半角、`_`→`-`、SSID 最多 2 位。
     * 支持 `BG6STN`、`BG6STN-9`、`bg6stn－15`（全角）这几种写法。
     */
    public static String normalizeCall(String raw) {
        if (raw == null) {
            return "";
        }
        String s = raw.trim().toUpperCase(Locale.US);
        s = s.replace(" ", "").replace("\t", "");
        s = s.replace('－', '-').replace('—', '-').replace('_', '-').replace('–', '-');
        while (s.indexOf("--") >= 0) {
            s = s.replace("--", "-");
        }
        int dash = s.indexOf('-');
        if (dash > 0) {
            String base = s.substring(0, dash);
            String tail = s.substring(dash + 1);
            if (tail.length() > 2) {
                tail = tail.substring(0, 2);
            }
            s = base + "-" + tail;
        }
        if (s.length() > 12) {
            s = s.substring(0, 12);
        }
        return s;
    }

    /**
     * 如果主呼号框里被填成了 `BH6RGQ-15` 这种形式，拆成 base + SSID 并写回设置，
     * 避免出现 `BH6RGQ-15-15` 这种错误源地址。
     */
    public static void fixCallsignPrefs(Context ctx) {
        try {
            if (ctx == null) {
                return;
            }
            String raw = Prefs.INSTANCE.getCallsign(ctx);
            if (raw == null) {
                return;
            }
            String s = raw.trim().toUpperCase(Locale.US).replace(" ", "");
            int dash = s.indexOf('-');
            if (dash <= 0) {
                return;
            }
            String base = s.substring(0, dash);
            String tail = s.substring(dash + 1);
            if (base.length() == 0) {
                return;
            }
            Prefs.INSTANCE.setCallsign(ctx, base);
            try {
                int ssid = Integer.parseInt(tail);
                if (ssid >= 0 && ssid <= 15) {
                    Prefs.INSTANCE.setSsid(ctx, ssid);
                }
            } catch (Throwable ignored) {
            }
            NetLog.note("callsign normalized: " + raw + " -> " + base + " ssid=" + tail);
        } catch (Throwable ignored) {
        }
    }

    // ------------------------------------------------------------------

    private static String clip(String s, int n) {
        if (s == null) {
            return "";
        }
        String one = s.replace('\n', ' ').trim();
        return one.length() <= n ? one : one.substring(0, n) + "…";
    }

    private static void copy(Context ctx, String text) {
        try {
            ClipboardManager cm = (ClipboardManager) ctx.getSystemService(Context.CLIPBOARD_SERVICE);
            if (cm == null) {
                return;
            }
            cm.setPrimaryClip(ClipData.newPlainText("aprs-msg", text));
            toast(ctx, "已复制");
        } catch (Throwable ignored) {
        }
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
