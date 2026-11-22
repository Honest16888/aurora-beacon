package com.yg.aprs;

import android.app.Activity;
import android.content.pm.PackageInfo;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.ViewGroup;
import android.widget.ScrollView;
import android.widget.TextView;

/** 版权与关于页：界面全部代码构建，不依赖任何资源 id。 */
public class CopyrightActivity extends Activity {

    private static final String COPYRIGHT_TEXT =
            "极光信标  (Aurora Beacon)\n"
            + "BH6RGQ 的个人 APRS-IS 定位信标\n\n"
            + "版权\n"
            + "© 2026 BH6RGQ。保留所有权利。\n"
            + "本程序为个人定制的派生版本，由作者本人分发与维护。\n\n"
            + "免责声明\n"
            + "1. 使用前请确认你持有合法呼号，并遵守所在国家或地区的业余无线电法规、"
            + "以及 APRS-IS 的使用条款（含速率与路径限制）。\n"
            + "2. 本软件按「现状」提供，不附带任何明示或暗示的担保。"
            + "因使用本软件产生的任何直接或间接损失，作者不承担责任。\n"
            + "3. 上报的位置信息会通过 APRS-IS 公开发布，请自行判断是否适合公开。\n"
            + "4. 请勿将本软件用于任何违法用途。\n\n"
            + "隐私\n"
            + "本软件不收集、不上传个人信息；设置仅保存在本机，"
            + "仅按照你配置的服务器与间隔发送位置与状态。\n\n"
            + "第三方组件与致谢\n"
            + "· Material Components for Android — Apache License 2.0\n"
            + "· AndroidX — Apache License 2.0\n"
            + "· Kotlin / kotlinx.coroutines — Apache License 2.0\n"
            + "· APRS 符号图形 — aprs.fi symbol set (Heikki Hannikainen, OH7LZB), CC BY 4.0\n"
            + "· APRS-IS 网络 — 由全球爱好者共同维护\n\n";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        float d = 1f;
        try {
            setTitle("版权与关于");
        } catch (Throwable ignored) {
        }
        try {
            d = getResources().getDisplayMetrics().density;
            if (d <= 0f) {
                d = 2f;
            }
        } catch (Throwable ignored) {
        }
        int pad = (int) (20f * d + 0.5f);
        try {
            ScrollView sv = new ScrollView(this);
            sv.setFillViewport(true);

            TextView tv = new TextView(this);
            tv.setPadding(pad, pad, pad, pad);
            tv.setTextSize(13f);
            tv.setTextColor(0xFFD7E3F2);
            tv.setLineSpacing(5f * d, 1f);
            tv.setText(buildText());
            tv.setTextIsSelectable(true);
            sv.addView(tv, new ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT));

            try {
                int bg = getResources().getIdentifier("bg_aurora", "drawable", getPackageName());
                if (bg != 0) {
                    sv.setBackgroundResource(bg);
                }
            } catch (Throwable ignored) {
            }

            setContentView(sv);
        } catch (Throwable t) {
            TextView tv = new TextView(this);
            tv.setPadding(pad, pad, pad, pad);
            tv.setTextSize(13f);
            tv.setText("YG 信标 · 版权页加载失败");
            setContentView(tv);
        }
    }

    private String buildText() {
        String version = "";
        try {
            PackageInfo pi = getPackageManager().getPackageInfo(getPackageName(), 0);
            version = pi.versionName == null ? "" : pi.versionName;
        } catch (Throwable ignored) {
        }
        StringBuilder sb = new StringBuilder();
        sb.append(COPYRIGHT_TEXT);
        sb.append("运行环境\n");
        sb.append("· Android ").append(Build.VERSION.RELEASE)
          .append(" (API ").append(Build.VERSION.SDK_INT).append(")\n");
        if (!TextUtils.isEmpty(version)) {
            sb.append("· 版本 ").append(version).append('\n');
        }
        return sb.toString();
    }
}
