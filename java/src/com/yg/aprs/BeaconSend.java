package com.yg.aprs;

import android.content.Context;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.Locale;

/**
 * 「连一次、发一条、断开」的上报方式。
 *
 * 原来的实现复用一条长连接：切后台后移动网络切换 / NAT 超时 / Wi-Fi 休眠会把
 * socket 变成半死状态，写入仍然"成功"但服务器收不到，于是表现为后台静默失联。
 * 改成每个周期独立建连，失败立即重试一次，就不存在"陈旧连接"问题。
 *
 * 参数用 configure(...) 先放进来，这样 smali 侧只要 5 个参数（invoke 上限），
 * 真正发送只需要传报文一行。
 */
public final class BeaconSend {

    private static final String VERS = "AuroraBeacon 1.8.2";
    private static final int CONNECT_TIMEOUT_MS = 12000;
    private static final int READ_TIMEOUT_MS = 6000;
    private static final int MAX_ATTEMPTS = 2;
    private static final long RETRY_DELAY_MS = 3000L;

    private static volatile Context ctx;
    private static volatile String host = "";
    private static volatile int port = 0;
    private static volatile String call = "";
    private static volatile int passcode = -1;

    private BeaconSend() {
    }

    public static void configure(Context context, String hostName, int portNumber,
                                 String callsign, int pass) {
        try {
            ctx = context;
            host = hostName == null ? "" : hostName;
            port = portNumber;
            call = callsign == null ? "" : callsign;
            passcode = pass;
            NetLog.init(context);
        } catch (Throwable ignored) {
        }
    }

    public static boolean send(String line) {
        if (line == null || line.length() == 0) {
            NetLog.note("skip: empty line");
            return false;
        }
        if (host.length() == 0 || call.length() == 0 || port <= 0) {
            NetLog.note("skip: config incomplete host=" + host + " port=" + port + " call=" + call);
            return false;
        }
        // 常驻连接（MsgAgent）在跑就走它，省一次握手，也让下行消息有地方收
        if (MsgAgent.submit(line)) {
            NetLog.note("sent via msg agent: " + line);
            BeaconUi.LastFix.parse(line);
            return true;
        }
        for (int attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
            Socket socket = null;
            boolean wrote = false;
            try {
                socket = new Socket();
                socket.setKeepAlive(true);
                socket.setTcpNoDelay(true);
                socket.connect(new InetSocketAddress(host, port), CONNECT_TIMEOUT_MS);
                socket.setSoTimeout(READ_TIMEOUT_MS);

                BufferedWriter writer = new BufferedWriter(
                        new OutputStreamWriter(socket.getOutputStream(), "UTF-8"));
                BufferedReader reader = new BufferedReader(
                        new InputStreamReader(socket.getInputStream(), "UTF-8"));

                writer.write(String.format(Locale.US, "user %s pass %d vers %s\r\n",
                        call, passcode, VERS));
                writer.flush();

                String banner = null;
                String logresp = null;
                try {
                    banner = reader.readLine();
                    logresp = reader.readLine();
                } catch (SocketTimeoutException ignored) {
                    // 服务器暂时不回应也不影响发送
                }
                NetLog.note(String.format(Locale.US,
                        "connected %s:%d try=%d banner=%s logresp=%s",
                        host, port, attempt, trim(banner), trim(logresp)));

                writer.write(line);
                if (!line.endsWith("\n")) {
                    writer.write("\r\n");
                }
                writer.flush();
                // 已经冲刷到内核缓冲区：此后任何异常都不再重试，
                // 否则网络抖动时同一包会被发两遍（拉高速率、点位乱跳）。
                wrote = true;
                NetLog.note("sent " + line.length() + "B: " + line);
                BeaconUi.LastFix.parse(line);

                closeQuietly(socket);
                return true;
            } catch (Throwable t) {
                NetLog.note("attempt " + attempt + " failed: " + t);
                closeQuietly(socket);
                if (wrote) {
                    NetLog.note("already flushed, skip retry to avoid duplicate packet");
                    return true;
                }
                if (attempt < MAX_ATTEMPTS) {
                    try {
                        Thread.sleep(RETRY_DELAY_MS);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        return false;
                    }
                }
            }
        }
        return false;
    }

    private static String trim(String s) {
        if (s == null) {
            return "-";
        }
        String t = s.trim();
        return t.length() > 80 ? t.substring(0, 80) + "..." : t;
    }

    private static void closeQuietly(Socket s) {
        try {
            if (s != null) {
                s.close();
            }
        } catch (Throwable ignored) {
        }
    }
}
