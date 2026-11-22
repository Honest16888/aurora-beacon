package com.yg.aprs;

import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

/** 小功能集合：复制密码、按呼号直达 aprs.fi。全部容错，不抛异常。 */
public final class Ui {

    private Ui() {
    }

    /** 点一下就把文本复制到剪贴板并提示。 */
    public static void copyOnClick(final TextView source, final CharSequence toast) {
        if (source == null) {
            return;
        }
        source.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    CharSequence text = source.getText();
                    if (text == null || text.length() == 0) {
                        return;
                    }
                    ClipboardManager cm = (ClipboardManager)
                            source.getContext().getSystemService(Context.CLIPBOARD_SERVICE);
                    if (cm == null) {
                        return;
                    }
                    cm.setPrimaryClip(ClipData.newPlainText("yg", text));
                    Toast.makeText(source.getContext(), toast, Toast.LENGTH_SHORT).show();
                } catch (Throwable ignored) {
                }
            }
        });
    }

    /** 用当前呼号 + SSID 打开 aprs.fi 轨迹页，而不是固定首页。 */
    public static void aprsFiLink(final Activity act, View link, final View call, final View ssid) {
        if (act == null || link == null) {
            return;
        }
        link.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String url = "https://aprs.fi/";
                try {
                    String c = read(call);
                    String s = read(ssid);
                    if (c.length() > 0) {
                        if (s.length() > 0) {
                            url = "https://aprs.fi/?callsign=" + Uri.encode(c + "-" + s);
                        } else {
                            url = "https://aprs.fi/?callsign=" + Uri.encode(c);
                        }
                    }
                } catch (Throwable ignored) {
                    url = "https://aprs.fi/";
                }
                try {
                    act.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
                } catch (Throwable t) {
                    try {
                        Toast.makeText(act, "没有可用的浏览器", Toast.LENGTH_SHORT).show();
                    } catch (Throwable ignored) {
                    }
                }
            }
        });
    }

    /** 呼号框为空时填入默认呼号（BH6RGQ）。 */
    public static void defaultCall(final TextView call, final String fallback) {
        try {
            if (call == null || fallback == null) {
                return;
            }
            CharSequence cs = call.getText();
            if (cs == null || cs.toString().trim().length() == 0) {
                call.setText(fallback);
            }
        } catch (Throwable ignored) {
        }
    }

    private static String read(View v) {        try {
            if (v instanceof TextView) {
                CharSequence cs = ((TextView) v).getText();
                if (cs != null) {
                    return cs.toString().trim().toUpperCase();
                }
            }
        } catch (Throwable ignored) {
        }
        return "";
    }
}
