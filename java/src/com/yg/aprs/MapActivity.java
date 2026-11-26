package com.yg.aprs;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Locale;

/**
 * 内置地图页（不依赖任何地图 SDK）：
 * 用 WebView 打开高德/百度的**免 key** 网页地图，直接标出最近一次上报的位置。
 *
 * 为什么这样做：高德/百度/腾讯的 Android SDK 需要原生 .so、绑定包名+签名的 AK、
 * 隐私合规初始化，APK 会从 5MB 涨到 20MB+；而这个页面能立刻给出"应用内看地图"的体验，
 * 体积增加 0，也不需要 AK。真 SDK 的接入留到拿到 jar + so 之后再做。
 */
public class MapActivity extends Activity {

    private WebView web;
    private TextView hint;
    private double lat;
    private double lon;

    /** 入口：主界面「地图」按钮。没有定位数据就不跳。 */
    public static void show(Activity from) {
        try {
            if (from == null) {
                return;
            }
            if (!BeaconUi.LastFix.has()) {
                Toast.makeText(from, "还没有定位数据，先启动上报", Toast.LENGTH_SHORT).show();
                return;
            }
            from.startActivity(new Intent(from, MapActivity.class));
        } catch (Throwable t) {
            try {
                Toast.makeText(from, "打开地图失败", Toast.LENGTH_SHORT).show();
            } catch (Throwable ignored) {
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        lat = BeaconUi.LastFix.lat();
        lon = BeaconUi.LastFix.lon();
        setTitle("地图");

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0A1020);

        hint = new TextView(this);
        hint.setTextSize(12f);
        hint.setTextColor(0xFF93A4BC);
        hint.setPadding(dp(14), dp(10), dp(14), dp(8));
        hint.setText(String.format(Locale.US, "最近上报：%.6f, %.6f", lat, lon));
        root.addView(hint, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        web = new WebView(this);
        web.setBackgroundColor(Color.TRANSPARENT);
        try {
            WebSettings s = web.getSettings();
            s.setJavaScriptEnabled(true);
            s.setDomStorageEnabled(true);
            s.setLoadWithOverviewMode(true);
            s.setUseWideViewPort(true);
            s.setBuiltInZoomControls(true);
            s.setDisplayZoomControls(false);
        } catch (Throwable ignored) {
        }
        web.setWebViewClient(new WebViewClient());
        root.addView(web, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f));

        LinearLayout bar = new LinearLayout(this);
        bar.setOrientation(LinearLayout.HORIZONTAL);
        bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding(dp(10), dp(8), dp(10), dp(12));

        bar.addView(button("刷新", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadAmap();
            }
        }), lp(1f, 0));
        bar.addView(button("附近台站", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                NearbyQuery.run(MapActivity.this);
            }
        }), lp(1f, dp(8)));
        bar.addView(button("aprs.fi", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadAprsFi();
            }
        }), lp(1f, dp(8)));

        LinearLayout bar2 = new LinearLayout(this);
        bar2.setOrientation(LinearLayout.HORIZONTAL);
        bar2.setGravity(Gravity.CENTER_VERTICAL);
        bar2.setPadding(dp(10), 0, dp(10), dp(12));

        bar2.addView(button("百度页", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadBaidu();
            }
        }), lp(1f, 0));
        bar2.addView(button("地图App", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                BeaconUi.openMap(MapActivity.this);
            }
        }), lp(1f, dp(8)));
        bar2.addView(button("关闭", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        }), lp(1f, dp(8)));
        root.addView(bar, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        root.addView(bar2, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        setContentView(root);
        loadAmap();
    }

    /** 高德网页版：官方免 key 的 URI API，坐标按 WGS-84。 */
    private void loadAmap() {
        try {
            String url = "https://uri.amap.com/marker?position="
                    + String.format(Locale.US, "%.6f,%.6f", lon, lat)
                    + "&name=" + android.net.Uri.encode("极光信标")
                    + "&coordinate=wgs84&callnative=0";
            load(url, "高德网页");
        } catch (Throwable t) {
            hint.setText("加载失败：" + t);
        }
    }

    /** aprs.fi 在线地图，能看到周边所有台站（包括非本软件的设备）。 */
    private void loadAprsFi() {
        try {
            String url = String.format(Locale.US,
                    "https://aprs.fi/#!lat=%.6f&lng=%.6f&z=12", lat, lon);
            load(url, "aprs.fi 周边");
        } catch (Throwable t) {
            hint.setText("加载失败：" + t);
        }
    }

    /** 百度网页版 marker 页面（无需 key）。 */
    private void loadBaidu() {
        try {
            String url = "https://api.map.baidu.com/marker?location="
                    + String.format(Locale.US, "%.6f,%.6f", lat, lon)
                    + "&title=" + android.net.Uri.encode("极光信标")
                    + "&content=" + android.net.Uri.encode("最近上报位置")
                    + "&output=html&coord_type=wgs84&zoom=16&src=android.ygaprs";
            load(url, "百度网页");
        } catch (Throwable t) {
            hint.setText("加载失败：" + t);
        }
    }

    private void load(String url, String label) {
        try {
            hint.setText(String.format(Locale.US, "%s · %.6f, %.6f", label, lat, lon));
            web.loadUrl(url);
        } catch (Throwable t) {
            hint.setText("加载失败：" + t);
        }
    }

    private Button button(String text, View.OnClickListener l) {
        Button b = new Button(this);
        b.setText(text);
        b.setTextSize(13f);
        b.setAllCaps(false);
        b.setOnClickListener(l);
        return b;
    }

    private LinearLayout.LayoutParams lp(float weight, int marginStart) {
        LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(0,
                ViewGroup.LayoutParams.WRAP_CONTENT, weight);
        p.setMarginStart(marginStart);
        return p;
    }

    private int dp(float v) {
        float d = getResources().getDisplayMetrics().density;
        if (d <= 0f) {
            d = 2f;
        }
        return (int) (v * d + 0.5f);
    }

    @Override
    protected void onDestroy() {
        try {
            if (web != null) {
                web.stopLoading();
                web.destroy();
                web = null;
            }
        } catch (Throwable ignored) {
        }
        super.onDestroy();
    }
}
