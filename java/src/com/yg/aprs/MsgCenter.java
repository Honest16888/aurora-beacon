package com.yg.aprs;

import android.content.Context;
import android.content.SharedPreferences;

import org.json.JSONArray;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * APRS 消息存储：收件箱（收到的消息）+ 发件箱（待确认 / 已确认 / 未确认）。
 * 全部在内存里，进程存活期间有效；进程被回收后清空（不写数据库，避免权限与迁移问题）。
 */
public final class MsgCenter {

    /** 一条待发送的消息。 */
    public static final class Out {
        public final String dst;
        public final String text;
        public final int seq;
        public int tries;
        public long nextTryAt;
        public boolean done;
        public boolean failed;

        Out(String dst, String text, int seq) {
            this.dst = dst;
            this.text = text;
            this.seq = seq;
        }
    }

    /** 收件箱里的一条消息（给界面用）。 */
    public static final class Item {
        public final String time;
        public final String from;
        public final String text;

        Item(String time, String from, String text) {
            this.time = time;
            this.from = from;
            this.text = text;
        }
    }

    private static final int MAX_INBOX = 50;
    private static final int MAX_OUTBOX = 30;

    private static final List<String[]> INBOX = new ArrayList<String[]>();
    private static final List<Out> OUTBOX = new ArrayList<Out>();
    private static int seq;

    private static volatile Context storeCtx;
    private static volatile boolean loaded;

    private MsgCenter() {
    }

    static synchronized int nextSeq() {
        seq = (seq >= 99) ? 1 : seq + 1;
        return seq;
    }

    /** 收件人字段固定 9 字符。 */
    public static String pad(String s, int len) {
        String v = (s == null) ? "" : s;
        if (v.length() >= len) {
            return v.substring(0, len);
        }
        StringBuilder sb = new StringBuilder(v);
        while (sb.length() < len) {
            sb.append(' ');
        }
        return sb.toString();
    }

    /** 绑定持久化上下文并加载已存消息（幂等）。 */
    public static synchronized void ensureLoaded(Context ctx) {
        if (ctx != null && storeCtx == null) {
            storeCtx = ctx.getApplicationContext();
        }
        if (loaded || storeCtx == null) {
            return;
        }
        loaded = true;
        try {
            SharedPreferences sp = storeCtx.getSharedPreferences("msg_store", Context.MODE_PRIVATE);
            String raw = sp.getString("inbox", "");
            if (raw.length() > 0) {
                JSONArray arr = new JSONArray(raw);
                for (int i = 0; i < arr.length(); i++) {
                    JSONArray row = arr.getJSONArray(i);
                    if (row.length() >= 3) {
                        INBOX.add(new String[]{row.getString(0), row.getString(1), row.getString(2)});
                    }
                }
            }
        } catch (Throwable t) {
            // 解析失败就当空收件箱，不崩
        }
    }

    private static void persist() {
        try {
            if (storeCtx == null) {
                return;
            }
            JSONArray arr = new JSONArray();
            for (int i = 0; i < INBOX.size(); i++) {
                String[] m = INBOX.get(i);
                JSONArray row = new JSONArray();
                row.put(m[0]).put(m[1]).put(m[2]);
                arr.put(row);
            }
            storeCtx.getSharedPreferences("msg_store", Context.MODE_PRIVATE)
                    .edit().putString("inbox", arr.toString()).apply();
        } catch (Throwable ignored) {
        }
    }

    public static synchronized void addInbox(String from, String text) {
        String f = from == null ? "?" : from;
        String t2 = text == null ? "" : text;
        // 去重：同一来源 + 同一正文 60 秒内只记一次（服务器可能重复投递）
        long now = System.currentTimeMillis();
        for (int i = INBOX.size() - 1; i >= 0 && i >= INBOX.size() - 5; i--) {
            String[] m = INBOX.get(i);
            if (m[1].equals(f) && m[2].equals(t2)) {
                return;
            }
        }
        String ts = new SimpleDateFormat("HH:mm", Locale.US).format(new Date(now));
        INBOX.add(new String[]{ts, f, t2});
        while (INBOX.size() > MAX_INBOX) {
            INBOX.remove(0);
        }
        persist();
    }

    /** 收件箱快照，最新在前。 */
    public static synchronized List<Item> inboxSnapshot() {
        List<Item> r = new ArrayList<Item>();
        for (int i = INBOX.size() - 1; i >= 0; i--) {
            String[] m = INBOX.get(i);
            r.add(new Item(m[0], m[1], m[2]));
        }
        return r;
    }

    public static synchronized void clearInbox() {
        INBOX.clear();
        persist();
    }

    public static synchronized Out enqueue(String dst, String text) {
        Out o = new Out(dst, text, nextSeq());
        OUTBOX.add(o);
        while (OUTBOX.size() > MAX_OUTBOX) {
            OUTBOX.remove(0);
        }
        return o;
    }

    /** 当前该发的（未确认、未失败、到了重试时间）。 */
    public static synchronized List<Out> pending(long now) {
        List<Out> r = new ArrayList<Out>();
        for (int i = 0; i < OUTBOX.size(); i++) {
            Out o = OUTBOX.get(i);
            if (o.done || o.failed || o.nextTryAt > now) {
                continue;
            }
            r.add(o);
        }
        return r;
    }

    public static synchronized void markAcked(int s) {
        for (int i = 0; i < OUTBOX.size(); i++) {
            Out o = OUTBOX.get(i);
            if (o.seq == s && !o.done) {
                o.done = true;
                o.failed = false;
            }
        }
    }

    public static synchronized int inboxCount() {
        return INBOX.size();
    }

    /** 给界面用的纯文本快照。 */
    public static synchronized String render() {
        StringBuilder sb = new StringBuilder();
        if (INBOX.isEmpty()) {
            sb.append("尚无收到的消息\n");
        } else {
            sb.append("收件箱（").append(INBOX.size()).append("）\n");
            int from = Math.max(0, INBOX.size() - 12);
            for (int i = INBOX.size() - 1; i >= from; i--) {
                String[] m = INBOX.get(i);
                sb.append(m[0]).append(' ').append(m[1]).append(": ").append(m[2]).append('\n');
            }
        }
        boolean header = false;
        for (int i = 0; i < OUTBOX.size(); i++) {
            Out o = OUTBOX.get(i);
            if (o.done) {
                continue;
            }
            if (!header) {
                sb.append("\n发送状态\n");
                header = true;
            }
            sb.append(o.failed ? "未确认 " : "待确认 ")
              .append(o.dst).append(" #").append(String.format(Locale.US, "%02d", o.seq))
              .append(" (").append(o.tries).append("/3)\n");
        }
        return sb.toString();
    }
}
