package com.yg.aprs;

import android.content.Context;
import android.location.Location;
import android.location.LocationManager;

/**
 * 位置兜底：进入后台后，一次性定位请求（requestSingleUpdate）可能因为
 * 省电策略、GPS 冷启动、ROM 限制而拿不到结果，导致整轮上报被跳过。
 * 这里用系统缓存的 lastKnownLocation 补一个「足够新」的定位，
 * 超过 10 分钟的一律丢弃（避免把几小时前的位置当当前位置发出去）。
 */
public final class LocationFallback {

    private static final long MAX_AGE_MS = 10L * 60L * 1000L;

    private LocationFallback() {
    }

    public static Location fresh(Context context) {
        return fresh(context, MAX_AGE_MS);
    }

    public static Location fresh(Context context, long maxAgeMs) {
        try {
            if (context == null) {
                return null;
            }
            LocationManager lm = (LocationManager)
                    context.getSystemService(Context.LOCATION_SERVICE);
            if (lm == null) {
                return null;
            }
            long now = System.currentTimeMillis();
            Location best = null;
            String[] providers = new String[]{"gps", "network", "passive"};
            for (String p : providers) {
                Location l;
                try {
                    if (!lm.isProviderEnabled(p)) {
                        continue;
                    }
                    l = lm.getLastKnownLocation(p);
                } catch (Throwable ignored) {
                    continue;
                }
                if (l == null) {
                    continue;
                }
                long age = now - l.getTime();
                if (age < 0) {
                    age = 0; // 时钟被调整过
                }
                if (age > maxAgeMs) {
                    continue;
                }
                if (best == null || l.getTime() > best.getTime()) {
                    best = l;
                }
            }
            return best;
        } catch (Throwable t) {
            return null;
        }
    }
}
