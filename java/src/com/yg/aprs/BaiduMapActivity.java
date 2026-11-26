package com.yg.aprs;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.baidu.mapapi.SDKInitializer;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.model.LatLng;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * 百度地图 SDK 内置地图页。
 *
 * 关键点：
 * 1. 初始化的**顺序**不能错——必须先 `setAgreePrivacy(true)` 再 `initialize()`，
 *    否则百度 SDK 会拒绝工作（地图白屏，日志里是 privacy 未同意）。
 * 2. 坐标系：APRS 是 WGS-84，百度要 BD-09，所以 WGS→GCJ-02→BD-09 两步转换。
 * 3. 任何一步失败（AK 不对、签名不匹配、.so 缺失、设备不支持）都不崩：
 *    降级到 WebView 网页地图（{@link MapActivity}）。
 */
public class BaiduMapActivity extends Activity {

    private MapView mapView;
    private boolean ready;
    private BitmapDescriptor myIcon;
    private BitmapDescriptor otherIcon;

    public static void show(Activity from) {
        try {
            if (from == null) {
                return;
            }
            if (!BeaconUi.LastFix.has()) {
                Toast.makeText(from, "还没有定位数据，先启动上报", Toast.LENGTH_SHORT).show();
                return;
            }
            if (!preflightOk(from)) {
                Toast.makeText(from, "当前设备不支持百度地图 SDK，已打开网页地图",
                        Toast.LENGTH_LONG).show();
                MapActivity.show(from);
                return;
            }
            from.startActivity(new Intent(from, BaiduMapActivity.class));
        } catch (Throwable t) {
            try {
                MapActivity.show(from);
            } catch (Throwable ignored) {
            }
        }
    }

    /**
     * 进百度地图前的预检：设备 ABI 是否在打包范围内、原生库是否真的被解压出来。
     * 这两项不满足时强行进去只有两种结果：白屏或 native 崩溃，所以先拦下来走网页地图。
     */
    private static boolean preflightOk(Activity act) {
        try {
            String[] abis = android.os.Build.SUPPORTED_ABIS;
            boolean abiOk = false;
            if (abis != null) {
                for (int i = 0; i < abis.length; i++) {
                    if ("arm64-v8a".equals(abis[i]) || "armeabi-v7a".equals(abis[i])) {
                        abiOk = true;
                        break;
                    }
                }
            }
            if (!abiOk) {
                NetLog.note("baidu preflight: unsupported abi " + (abis == null ? "?" : abis[0]));
                return false;
            }
            String libDir = act.getApplicationInfo().nativeLibraryDir;
            if (libDir == null) {
                NetLog.note("baidu preflight: nativeLibraryDir null");
                return false;
            }
            java.io.File f = new java.io.File(libDir, "libBaiduMapSDK_base_v7_5_2.so");
            if (!f.exists()) {
                NetLog.note("baidu preflight: missing " + f);
                return false;
            }
            return true;
        } catch (Throwable t) {
            NetLog.note("baidu preflight failed: " + t);
            return false;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setTitle("地图");

        final double la = BeaconUi.LastFix.lat();
        final double lo = BeaconUi.LastFix.lon();
        String err = null;

        try {
            // 1) 隐私合规（必须在 initialize 之前）
            SDKInitializer.setAgreePrivacy(getApplicationContext(), true);
            SDKInitializer.initialize(getApplicationContext());

            // 2) Show
            mapView = new MapView(this);
            BaiduMap map = mapView.getMap();
            map.setMapType(BaiduMap.MAP_TYPE_NORMAL);
            map.setMyLocationEnabled(true);
            // MapView 建出来就算成功；marker 失败只影响标记，不应该把整张地图干掉
            ready = true;

            // 百度 SDK 要求 marker 必须带 icon（不设会抛 BDMapSDKException）
            myIcon = makeDot(0xFF2DD4BF, dp(14));
            otherIcon = makeDot(0xFFFF8A3D, dp(8));

            double[] gcj = BeaconUi.wgs2gcj(la, lo);
            double[] bd = gcj2bd(gcj[0], gcj[1]);
            LatLng ll = new LatLng(bd[0], bd[1]);
            try {
                map.addOverlay(new MarkerOptions().position(ll).icon(myIcon).title("极光信标"));
            } catch (Throwable mt) {
                NetLog.note("own marker failed: " + mt);
            }
            map.setMapStatus(MapStatusUpdateFactory.newLatLngZoom(ll, 16.0f));
        } catch (Throwable t) {
            err = String.valueOf(t);
            NetLog.note("baidu map init failed: " + err);
        }

        if (!ready) {
            NetLog.note("baidu init failed, redirect to web map: " + err);
            try {
                MapActivity.show(this);
            } catch (Throwable ignored) {
            }
            finish();
            return;
        }

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);

        TextView hint = new TextView(this);
        hint.setTextSize(11f);
        hint.setTextColor(0xFF93A4BC);
        hint.setPadding(dp(14), dp(8), dp(14), dp(6));
        hint.setText(String.format(Locale.US, "百度地图 · 最近上报 %.6f, %.6f", la, lo));
        root.addView(hint, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        ViewGroup parent = (ViewGroup) mapView.getParent();
        if (parent != null) {
            parent.removeView(mapView);
        }
        root.addView(mapView, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f));

        LinearLayout bar = new LinearLayout(this);
        bar.setOrientation(LinearLayout.HORIZONTAL);
        bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding(dp(10), dp(8), dp(10), dp(12));
        bar.addView(button("回中", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                recenter(la, lo);
            }
        }), lp(1f, 0));
        bar.addView(button("附近台站", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                NearbyQuery.run(BaiduMapActivity.this);
            }
        }), lp(1f, dp(8)));
        bar.addView(button("全国台站", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadNationwide();
            }
        }), lp(1f, dp(8)));
        bar.addView(button("网页地图", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MapActivity.show(BaiduMapActivity.this);
            }
        }), lp(1f, dp(8)));
        bar.addView(button("关闭", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        }), lp(1f, dp(8)));
        root.addView(bar, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        setContentView(root);
    }

    /** 自己画一个圆点当 marker 图标（百度 SDK 不带默认图标，必须给）。 */
    private BitmapDescriptor makeDot(int color, int sizePx) {
        try {
            int s = Math.max(sizePx, 8);
            Bitmap bmp = Bitmap.createBitmap(s, s, Bitmap.Config.ARGB_8888);
            Canvas c = new Canvas(bmp);
            Paint fill = new Paint(Paint.ANTI_ALIAS_FLAG);
            fill.setColor(color);
            c.drawCircle(s / 2f, s / 2f, s / 2f - Math.max(1f, s / 10f), fill);
            Paint ring = new Paint(Paint.ANTI_ALIAS_FLAG);
            ring.setStyle(Paint.Style.STROKE);
            ring.setStrokeWidth(Math.max(1f, s / 10f));
            ring.setColor(0xFFFFFFFF);
            c.drawCircle(s / 2f, s / 2f, s / 2f - Math.max(1f, s / 10f), ring);
            return BitmapDescriptorFactory.fromBitmap(bmp);
        } catch (Throwable t) {
            NetLog.note("makeDot failed: " + t);
            return null;
        }
    }

    /** 全国台站：拉 APRS-IS 的中国范围矩形，批量打点到地图上。 */
    private void loadNationwide() {
        if (mapView == null) {
            return;
        }
        Toast.makeText(this, "正在获取全国台站（约 12 秒）…", Toast.LENGTH_SHORT).show();
        final BaiduMap map = mapView.getMap();
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                final List<NearbyQuery.Station> list = NearbyQuery.queryChina(BaiduMapActivity.this);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        plotStations(map, list);
                    }
                });
            }
        }, "yg-china");
        t.setDaemon(true);
        t.start();
    }

    /** 批量加 marker（WGS-84 → GCJ-02 → BD-09），并把视野拉到全国。 */
    private void plotStations(BaiduMap map, List<NearbyQuery.Station> list) {
        try {
            if (map == null) {
                return;
            }
            if (list == null || list.isEmpty()) {
                Toast.makeText(this, "12 秒内没有收到国内台站的位置包", Toast.LENGTH_SHORT).show();
                return;
            }
            ArrayList<OverlayOptions> opts = new ArrayList<OverlayOptions>();
            int n = Math.min(list.size(), 300);
            for (int i = 0; i < n; i++) {
                NearbyQuery.Station st = list.get(i);
                double[] gcj = BeaconUi.wgs2gcj(st.lat, st.lon);
                double[] bd = gcj2bd(gcj[0], gcj[1]);
                if (otherIcon == null) {
                    otherIcon = makeDot(0xFFFF8A3D, dp(8));
                }
                opts.add(new MarkerOptions()
                        .position(new LatLng(bd[0], bd[1]))
                        .icon(otherIcon)
                        .title(st.call));
            }
            map.addOverlays(opts);
            double[] centerGcj = BeaconUi.wgs2gcj(35.0, 105.0);
            double[] centerBd = gcj2bd(centerGcj[0], centerGcj[1]);
            map.setMapStatus(MapStatusUpdateFactory.newLatLngZoom(
                    new LatLng(centerBd[0], centerBd[1]), 4.5f));
            Toast.makeText(this, "已标出 " + opts.size() + " 个台站（点标记看呼号）",
                    Toast.LENGTH_LONG).show();
            NetLog.note("plotted " + opts.size() + " stations from " + list.size());
        } catch (Throwable t) {
            NetLog.note("plot stations failed: " + t);
            Toast.makeText(this, "标注台站失败：" + t, Toast.LENGTH_SHORT).show();
        }
    }

    private void recenter(double la, double lo) {        try {
            double[] gcj = BeaconUi.wgs2gcj(la, lo);
            double[] bd = gcj2bd(gcj[0], gcj[1]);
            LatLng ll = new LatLng(bd[0], bd[1]);
            mapView.getMap().setMapStatus(MapStatusUpdateFactory.newLatLngZoom(ll, 16.0f));
        } catch (Throwable ignored) {
        }
    }

    /** SDK 起不来时的降级界面：说明原因 + 一键打开网页地图。 */
    private View fallback(String err, final double la, final double lo) {
        LinearLayout box = new LinearLayout(this);
        box.setOrientation(LinearLayout.VERTICAL);
        box.setGravity(Gravity.CENTER);
        box.setPadding(dp(24), dp(24), dp(24), dp(24));
        box.setBackgroundColor(0xFF0A1020);

        TextView tv = new TextView(this);
        tv.setTextSize(13f);
        tv.setTextColor(0xFFD7E3F2);
        tv.setGravity(Gravity.CENTER);
        tv.setText("百度地图初始化失败，已自动降级为网页地图。\n\n"
                + String.format(Locale.US, "坐标：%.6f, %.6f\n\n", la, lo)
                + "常见原因：AK 与「包名 + 签名 SHA1」不匹配、设备 ABI 不支持、或未同意隐私。\n\n"
                + "错误：" + (err == null ? "-" : err));
        box.addView(tv, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        Button b = button("打开网页地图", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MapActivity.show(BaiduMapActivity.this);
            }
        });
        LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        p.topMargin = dp(18);
        box.addView(b, p);
        return box;
    }

    /** GCJ-02 → BD-09（百度自己的偏移）。 */
    static double[] gcj2bd(double ggLat, double ggLon) {
        double x = ggLon;
        double y = ggLat;
        double z = Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * Math.PI);
        double theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * Math.PI);
        return new double[]{z * Math.sin(theta) + 0.006, z * Math.cos(theta) + 0.0065};
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
    protected void onResume() {
        super.onResume();
        try {
            if (mapView != null) {
                mapView.onResume();
            }
        } catch (Throwable ignored) {
        }
    }

    @Override
    protected void onPause() {
        try {
            if (mapView != null) {
                mapView.onPause();
            }
        } catch (Throwable ignored) {
        }
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        try {
            if (mapView != null) {
                mapView.onDestroy();
                mapView = null;
            }
        } catch (Throwable ignored) {
        }
        super.onDestroy();
    }
}
