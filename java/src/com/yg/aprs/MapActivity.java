package com.yg.aprs;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;

/**
 * 地图页：本地 Leaflet（assets/map/map.html）+ 高德/CARTO/OSM 瓦片。
 *
 * 台站数据是**实时快照 + 持续累加**：12 秒窗口只能抓到"此刻在发"的台站
 * （5 分钟一报的台站只有约 4% 概率落在窗口里），所以每轮把结果按呼号合并进
 * cache，约 20 秒一轮地累加 —— 挂一两分钟即可覆盖当前所有活跃台站。
 *
 * 页面里的 JS 对象：window.YG = { setMe, addStations, clearStations, fitChina, zoomToMe, nextBase }
 */
public class MapActivity extends Activity {

    private WebView web;
    private TextView hint;
    private double lat;
    private double lon;
    private boolean pageReady;
    private volatile boolean stopped;
    private volatile boolean loopRunning;
    private boolean fitted;
    private String pendingStations;   // 页面还没 ready 时先攒着
    /** 累计台站：每轮查询按呼号合并（只在后台线程写，UI 线程拿快照）。 */
    private final LinkedHashMap<String, NearbyQuery.Station> cache =
            new LinkedHashMap<String, NearbyQuery.Station>();

    /** 入口：主界面「地图」按钮。 */
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
                Toast.makeText(from, "打开地图失败：" + t, Toast.LENGTH_SHORT).show();
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
        hint.setTextSize(11f);
        hint.setTextColor(0xFF93A4BC);
        hint.setPadding(dp(14), dp(8), dp(14), dp(6));
        hint.setText(String.format(Locale.US, "最近上报 %.6f, %.6f · 正在获取台站…", lat, lon));
        root.addView(hint, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        web = new WebView(this);
        try {
            WebSettings s = web.getSettings();
            s.setJavaScriptEnabled(true);
            s.setDomStorageEnabled(true);
            s.setAllowFileAccess(true);              // API 30+ 默认 false，必须显式开
            s.setAllowContentAccess(true);
            s.setLoadWithOverviewMode(true);
            s.setUseWideViewPort(true);
            s.setBuiltInZoomControls(false);
            s.setSupportZoom(true);
            s.setMediaPlaybackRequiresUserGesture(true);
        } catch (Throwable ignored) {
        }
        web.setBackgroundColor(0xFF0A1020);
        web.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                pageReady = true;
                pushMe();
                if (pendingStations != null) {
                    pushStations(pendingStations);
                    pendingStations = null;
                }
                startNationLoop();
            }
        });
        root.addView(web, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f));

        LinearLayout bar = new LinearLayout(this);
        bar.setOrientation(LinearLayout.HORIZONTAL);
        bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding(dp(8), dp(8), dp(8), dp(4));
        bar.addView(button("全国台站", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (loopRunning) {
                    Toast.makeText(MapActivity.this,
                            "自动累加中，每 ~20 秒补一批", Toast.LENGTH_SHORT).show();
                } else {
                    startNationLoop();
                }
            }
        }), lp(1f, 0));
        bar.addView(button("附近台站", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                queryNearbyList();
            }
        }), lp(1f, dp(8)));
        bar.addView(button("我的位置", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                lat = BeaconUi.LastFix.lat();
                lon = BeaconUi.LastFix.lon();
                pushMe();
                hint.setText(String.format(Locale.US, "最近上报 %.6f, %.6f", lat, lon));
            }
        }), lp(1f, dp(8)));
        root.addView(bar, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        LinearLayout bar2 = new LinearLayout(this);
        bar2.setOrientation(LinearLayout.HORIZONTAL);
        bar2.setGravity(Gravity.CENTER_VERTICAL);
        bar2.setPadding(dp(8), 0, dp(8), dp(12));
        bar2.addView(button("百度SDK", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                BaiduMapActivity.show(MapActivity.this);
            }
        }), lp(1f, 0));
        bar2.addView(button("回全国", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                eval("YG.fitChina()");
            }
        }), lp(1f, dp(8)));
        bar2.addView(button("关闭", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        }), lp(1f, dp(8)));
        root.addView(bar2, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        setContentView(root);

        try {
            web.loadUrl("file:///android_asset/map/map.html");
        } catch (Throwable t) {
            hint.setText("地图页加载失败：" + t);
        }
    }

    // ------------------------------------------------------------------

    private void pushMe() {
        eval(String.format(Locale.US, "YG.setMe(%f,%f)", lat, lon));
    }

    private void pushStations(String jsonArray) {
        eval("YG.addStations(" + jsonArray + ")");
    }

    private void eval(String js) {
        try {
            if (web != null) {
                web.evaluateJavascript(js, null);
            }
        } catch (Throwable ignored) {
        }
    }

    /**
     * 全国台站**累加**循环。
     *
     * 12 秒窗口只是"此刻正在发"的台站的快照，所以每轮把结果按呼号合并进 cache，
     * 约 20 秒一轮持续累加 —— 挂一两分钟就能覆盖当前所有活跃台站。
     */
    private void startNationLoop() {
        if (loopRunning || stopped || !BeaconUi.LastFix.has()) {
            return;
        }
        loopRunning = true;
        hint.setText("正在获取全国台站（约 12 秒/轮，持续累加）…");
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                while (!stopped) {
                    List<NearbyQuery.Station> got = NearbyQuery.queryChina(MapActivity.this);
                    String json;
                    int total;
                    synchronized (cache) {
                        if (got != null) {
                            for (int i = 0; i < got.size(); i++) {
                                NearbyQuery.Station st = got.get(i);
                                cache.put(st.call, st);   // 每轮刷新该台最新位置
                            }
                        }
                        json = toJson(new java.util.ArrayList<NearbyQuery.Station>(
                                cache.values()), 400);
                        total = cache.size();
                    }
                    final String j = json;
                    final int n = total;
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            if (stopped) {
                                return;
                            }
                            if (pageReady) {
                                pushStations(j);
                                if (!fitted) {
                                    fitted = true;
                                    eval("YG.fitChina()");
                                }
                            } else {
                                pendingStations = j;
                            }
                            hint.setText(String.format(Locale.US,
                                    "最近上报 %.6f, %.6f · 全国台站累计 %d（每 ~20 秒自动累加）",
                                    lat, lon, n));
                        }
                    });
                    for (int i = 0; i < 8 && !stopped; i++) {
                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException ie) {
                            Thread.currentThread().interrupt();
                            break;
                        }
                    }
                }
                loopRunning = false;
            }
        }, "yg-china-loop");
        t.setDaemon(true);
        t.start();
    }

    /** 周边 60 公里：弹列表，结果同时并入全国累计。 */
    private void queryNearbyList() {
        if (!BeaconUi.LastFix.has()) {
            Toast.makeText(this, "还没有定位数据", Toast.LENGTH_SHORT).show();
            return;
        }
        hint.setText("正在查询 60 公里内的台站（约 8 秒）…");
        final double la = BeaconUi.LastFix.lat();
        final double lo = BeaconUi.LastFix.lon();
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                final List<NearbyQuery.Station> list =
                        NearbyQuery.queryRadius(MapActivity.this, la, lo);
                String json;
                int total;
                synchronized (cache) {
                    if (list != null) {
                        for (int i = 0; i < list.size(); i++) {
                            cache.put(list.get(i).call, list.get(i));
                        }
                    }
                    json = toJson(new java.util.ArrayList<NearbyQuery.Station>(
                            cache.values()), 400);
                    total = cache.size();
                }
                final String j = json;
                final int n = total;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        hint.setText(String.format(Locale.US,
                                "最近上报 %.6f, %.6f · 周边 %d / 全国累计 %d",
                                la, lo, list == null ? 0 : list.size(), n));
                        if (pageReady) {
                            pushStations(j);
                        } else {
                            pendingStations = j;
                        }
                        NearbyQuery.showDetailList(MapActivity.this, list);
                    }
                });
            }
        }, "yg-nearby");
        t.setDaemon(true);
        t.start();
    }

    /** List<Station> -> JSONArray 字符串（上限 n 条）。 */
    static String toJson(List<NearbyQuery.Station> list, int n) {
        try {
            JSONArray arr = new JSONArray();
            int m = Math.min(list.size(), n);
            for (int i = 0; i < m; i++) {
                NearbyQuery.Station st = list.get(i);
                JSONObject o = new JSONObject();
                o.put("call", st.call);
                o.put("lat", Math.round(st.lat * 1e6) / 1e6);
                o.put("lon", Math.round(st.lon * 1e6) / 1e6);
                o.put("cmt", st.comment == null ? "" : st.comment);
                arr.put(o);
            }
            return arr.toString();
        } catch (Throwable t) {
            return "[]";
        }
    }

    // ------------------------------------------------------------------

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
    protected void onPause() {
        try {
            if (web != null) {
                web.onPause();
            }
        } catch (Throwable ignored) {
        }
        super.onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
        try {
            if (web != null) {
                web.onResume();
            }
        } catch (Throwable ignored) {
        }
    }

    @Override
    protected void onDestroy() {
        stopped = true;
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
