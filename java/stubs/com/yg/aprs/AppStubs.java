// 仅用于编译的“桩”：给出应用内已有类的签名，让最新的 Java 代码能通过 javac。
// 这个文件编译出的 class **不会**打进 classes2.dex（build.ps1 只打包 java/src 的产物），
// 运行时会用到 classes.dex 里真正的实现。
package com.yg.aprs;

import android.content.Context;

final class Prefs {
    static final Prefs INSTANCE = null;

    String getCallsign(Context c) {
        return null;
    }

    int getSsid(Context c) {
        return 0;
    }

    String getHost(Context c) {
        return null;
    }

    int getPort(Context c) {
        return 0;
    }

    String getComment(Context c) {
        return null;
    }

    int getInterval(Context c) {
        return 0;
    }
}

final class AprsPasscode {
    static final AprsPasscode INSTANCE = null;

    int compute(String callsign) {
        return 0;
    }

    String fullCall(String callsign, int ssid) {
        return null;
    }
}
