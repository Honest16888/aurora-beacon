package com.yg.aprs;

import android.content.Context;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * 轻量网络日志：只记录连接/发送结果，写在本应用私有外部目录，
 * 超过 256KB 自动重建，便于排查"切后台后不再上报"这类问题。
 * 不联网，不上传。
 */
public final class NetLog {

    private static final long MAX_BYTES = 256L * 1024L;
    private static Context appCtx;

    private NetLog() {
    }

    public static synchronized void init(Context context) {
        try {
            if (context != null && appCtx == null) {
                appCtx = context.getApplicationContext();
            }
        } catch (Throwable ignored) {
        }
    }

    public static synchronized void note(String message) {
        try {
            if (appCtx == null) {
                return;
            }
            File dir = appCtx.getExternalFilesDir(null);
            if (dir == null) {
                return;
            }
            File f = new File(dir, "net.log");
            if (f.length() > MAX_BYTES) {
                //noinspection ResultOfMethodCallIgnored
                f.delete();
            }
            String ts = new SimpleDateFormat("MM-dd HH:mm:ss", Locale.US).format(new Date());
            FileOutputStream fos = new FileOutputStream(f, true);
            try {
                fos.write((ts + "  " + message + "\n").getBytes("UTF-8"));
                fos.flush();
            } finally {
                fos.close();
            }
        } catch (Throwable ignored) {
        }
    }
}
