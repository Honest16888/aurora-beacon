package com.yg.aprs;

import android.content.Context;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * 崩溃兜底记录：把未捕获异常的堆栈写进
 * /sdcard/Android/data/com.yg.aprs/files/crash.txt
 * 方便定位“点一下就闪退”这类问题。
 */
public final class CrashGuard {

    private static Context appCtx;
    private static boolean installed;

    private CrashGuard() {
    }

    public static void install(Context context) {
        try {
            if (installed) {
                return;
            }
            installed = true;
            appCtx = context.getApplicationContext();
            final Thread.UncaughtExceptionHandler prev =
                    Thread.getDefaultUncaughtExceptionHandler();
            Thread.setDefaultUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {
                @Override
                public void uncaughtException(Thread thread, Throwable error) {
                    try {
                        write(error);
                    } catch (Throwable ignored) {
                    }
                    if (prev != null) {
                        prev.uncaughtException(thread, error);
                    }
                }
            });
        } catch (Throwable ignored) {
        }
    }

    static void write(Throwable error) {
        try {
            if (appCtx == null) {
                return;
            }
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            error.printStackTrace(pw);
            pw.flush();
            String ts = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US)
                    .format(new Date());
            String text = ts + "\n" + sw.toString();
            File dir = appCtx.getExternalFilesDir(null);
            if (dir == null) {
                dir = appCtx.getFilesDir();
            }
            if (dir == null) {
                return;
            }
            File out = new File(dir, "crash.txt");
            FileOutputStream fos = new FileOutputStream(out, false);
            try {
                fos.write(text.getBytes("UTF-8"));
                fos.flush();
            } finally {
                fos.close();
            }
        } catch (Throwable ignored) {
        }
    }
}
