package com.yg.aprs;

import android.content.Context;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.List;
import java.util.Locale;

/**
 * 常驻 APRS-IS 连接：负责「收消息 / 回 ack / 发队列 / 发位置」。
 *
 * 服务启动时 start()，停止时 stop()。连上以后：
 *   - 每读到一行就尝试解析 `::ADDRESSEE:body{seq`
 *   - addressee 是自己 → 存进收件箱并回 `ack{seq`
 *   - 是我的 ack（正文 `ackNN`）→ 标记对应消息已确认
 *   - 每个 2 秒 tick 检查待发队列，30 秒未确认重发，最多 3 次
 * 位置报文由 {@link BeaconSend#send} 转交到这里发送（submit），
 * 连接不可用时它返回 false，调用方自动回退到"临时连一次"。
 */
public final class MsgAgent {

    private static final String VERS = "AuroraBeacon 1.8.2";
    private static final int CONNECT_TIMEOUT_MS = 12000;
    private static final int READ_TIMEOUT_MS = 2000;
    private static final long RETRY_MS = 30000L;
    private static final int MAX_TRIES = 3;
    private static final Object WRITE_LOCK = new Object();

    private static volatile Thread thread;
    private static volatile boolean running;
    private static volatile boolean connected;
    private static volatile Socket socket;
    private static volatile BufferedWriter writer;
    private static volatile BufferedReader reader;

    private static volatile String host = "";
    private static volatile int port;
    private static volatile String fullCall = "";
    private static volatile String baseCall = "";
    private static volatile int passcode;

    private MsgAgent() {
    }

    public static synchronized void start(Context context) {
        if (running || context == null) {
            return;
        }
        try {
            // 呼号框若被填成 CALL-SSID，先拆开写回设置，避免出现 CALL-SSID-SSID
            MsgUi.fixCallsignPrefs(context);
            baseCall = Prefs.INSTANCE.getCallsign(context);
            if (baseCall == null) {
                baseCall = "";
            }
            int ssid = Prefs.INSTANCE.getSsid(context);
            fullCall = AprsPasscode.INSTANCE.fullCall(baseCall, ssid);
            passcode = AprsPasscode.INSTANCE.compute(baseCall);
            host = Prefs.INSTANCE.getHost(context);
            if (host == null) {
                host = "";
            }
            port = Prefs.INSTANCE.getPort(context);
            NetLog.init(context);
            MsgCenter.ensureLoaded(context);
        } catch (Throwable t) {
            NetLog.note("msg agent config failed: " + t);
            return;
        }
        if (baseCall.length() == 0 || host.length() == 0 || port <= 0) {
            NetLog.note("msg agent not started: config incomplete");
            return;
        }
        running = true;
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                loop();
            }
        }, "yg-msg-agent");
        t.setDaemon(true);
        thread = t;
        t.start();
        NetLog.note("msg agent started as " + fullCall + " via " + host + ":" + port);
    }

    public static synchronized void stop() {
        if (!running && thread == null) {
            return;
        }
        running = false;
        close();
        Thread t = thread;
        thread = null;
        if (t != null) {
            try {
                t.interrupt();
            } catch (Throwable ignored) {
            }
        }
        NetLog.note("msg agent stopped");
    }

    public static boolean isConnected() {
        return connected;
    }

    /** 用常驻连接发一条报文；不可用时返回 false（调用方回退一次性连接）。 */
    public static boolean submit(String line) {
        if (!connected || line == null) {
            return false;
        }
        try {
            writeLine(line);
            return true;
        } catch (Throwable t) {
            connected = false;
            NetLog.note("msg agent submit failed: " + t);
            return false;
        }
    }

    // ------------------------------------------------------------------

    private static void loop() {
        while (running) {
            try {
                if (!connected && !open()) {
                    sleepQuiet(15000L);
                    continue;
                }
                sendPending();
                String line = readLine();
                if (line != null) {
                    handle(line);
                }
            } catch (SocketTimeoutException te) {
                try {
                    sendPending();
                } catch (Throwable ignored) {
                }
            } catch (Throwable t) {
                NetLog.note("msg agent error: " + t);
                close();
                sleepQuiet(5000L);
            }
        }
        close();
    }

    private static boolean open() {
        Socket s = null;
        try {
            s = new Socket();
            s.setKeepAlive(true);
            s.connect(new InetSocketAddress(host, port), CONNECT_TIMEOUT_MS);
            s.setSoTimeout(READ_TIMEOUT_MS);
            synchronized (WRITE_LOCK) {
                writer = new BufferedWriter(new OutputStreamWriter(s.getOutputStream(), "UTF-8"));
                reader = new BufferedReader(new InputStreamReader(s.getInputStream(), "UTF-8"));
                socket = s;
                // 实测 aprsc 3.0：不带 filter 一条数据都不发（收消息一直是空的根因），
                // 且 filter 必须写在登录行里，单独发一行会被忽略。
                String msgFilter = "filter m/" + baseCall;
                if (fullCall != null && fullCall.length() > 0 && !fullCall.equals(baseCall)) {
                    msgFilter = msgFilter + "," + fullCall;
                }
                writer.write("user " + fullCall + " pass " + passcode + " vers " + VERS
                        + " " + msgFilter + "\r\n");
                writer.flush();
            }
            connected = true;
            NetLog.note("msg agent connected " + host + ":" + port);
            return true;
        } catch (Throwable t) {
            NetLog.note("msg agent connect failed: " + t);
            closeQuietly(s);
            return false;
        }
    }

    private static void close() {
        synchronized (WRITE_LOCK) {
            connected = false;
            closeQuietly(socket);
            socket = null;
            writer = null;
            reader = null;
        }
    }

    private static void closeQuietly(Socket s) {
        try {
            if (s != null) {
                s.close();
            }
        } catch (Throwable ignored) {
        }
    }

    private static void writeLine(String line) throws IOException {
        synchronized (WRITE_LOCK) {
            BufferedWriter w = writer;
            if (w == null) {
                throw new IOException("not connected");
            }
            w.write(line);
            if (!line.endsWith("\n")) {
                w.write("\r\n");
            }
            w.flush();
        }
    }

    private static String readLine() throws IOException {
        BufferedReader r = reader;
        if (r == null) {
            throw new IOException("not connected");
        }
        return r.readLine();
    }

    private static void sendPending() {
        List<MsgCenter.Out> list = MsgCenter.pending(System.currentTimeMillis());
        for (int i = 0; i < list.size(); i++) {
            MsgCenter.Out o = list.get(i);
            String pkt = fullCall + ">APRGQ,TCPIP*::" + MsgCenter.pad(o.dst, 9) + ":" + o.text
                    + String.format(Locale.US, "{%02d", o.seq);
            try {
                writeLine(pkt);
                o.tries++;
                o.nextTryAt = System.currentTimeMillis() + RETRY_MS;
                if (o.tries >= MAX_TRIES) {
                    o.failed = true;
                }
                NetLog.note("msg out #" + o.seq + " -> " + o.dst + " try=" + o.tries);
            } catch (Throwable t) {
                connected = false;
                NetLog.note("msg out failed: " + t);
                return;
            }
        }
    }

    private static void handle(String line) {
        try {
            int sep = line.indexOf("::");
            if (sep < 0 || line.length() < sep + 4) {
                return;
            }
            // 收件人字段固定 9 字符，但部分客户端不补空格：以「收件人后第一个冒号」为准
            int colon = line.indexOf(':', sep + 2);
            if (colon < 0 || colon - (sep + 2) > 9 || line.length() <= colon + 1) {
                return;
            }
            String addr = line.substring(sep + 2, colon).trim();
            if (!isForMe(addr)) {
                return;
            }
            String body = line.substring(colon + 1);
            String from = line.substring(0, Math.max(0, line.indexOf('>')));
            if (from.length() == 0) {
                from = "?";
            }

            String seq = "";
            int brace = body.lastIndexOf('{');
            if (brace >= 0 && body.length() - brace <= 3) {
                seq = body.substring(brace + 1).trim();
                body = body.substring(0, brace);
            }
            body = body.trim();

            if (body.startsWith("ack")) {
                int s = parseInt(body.substring(3).trim());
                if (s > 0) {
                    MsgCenter.markAcked(s);
                    NetLog.note("msg ack #" + s + " from " + from);
                }
                return;
            }
            if (body.length() == 0) {
                return;
            }

            MsgCenter.addInbox(from, body);
            NetLog.note("msg in from " + from + ": " + body);
            if (seq.length() > 0) {
                String ack = fullCall + ">APRGQ,TCPIP*::" + MsgCenter.pad(from, 9) + ":ack" + seq;
                try {
                    writeLine(ack);
                    NetLog.note("msg ack sent to " + from + " for #" + seq);
                } catch (Throwable ignored) {
                }
            }
        } catch (Throwable t) {
            NetLog.note("msg parse failed: " + t + " line=" + line);
        }
    }

    private static boolean isForMe(String addr) {
        if (addr.length() == 0) {
            return false;
        }
        return addr.equalsIgnoreCase(baseCall) || addr.equalsIgnoreCase(fullCall);
    }

    private static int parseInt(String s) {
        try {
            return Integer.parseInt(s);
        } catch (Throwable t) {
            return -1;
        }
    }

    private static void sleepQuiet(long ms) {
        try {
            Thread.sleep(ms);
        } catch (InterruptedException ie) {
            Thread.currentThread().interrupt();
        } catch (Throwable ignored) {
        }
    }
}
