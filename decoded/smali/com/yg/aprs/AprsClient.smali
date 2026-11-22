.class public final Lcom/yg/aprs/AprsClient;
.super Ljava/lang/Object;
.source "AprsClient.kt"


# annotations
.annotation runtime Lkotlin/Metadata;
    d1 = {
        "\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0008\u0002\n\u0002\u0010\u000b\n\u0002\u0008\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0008\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0008\n\u0002\u0008\u0003\n\u0002\u0010\u0002\n\u0002\u0008\u0003\u0018\u00002\u00020\u0001B\u0005\u00a2\u0006\u0002\u0010\u0002J&\u0010\r\u001a\u00020\u00042\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u000f2\u0006\u0010\u0013\u001a\u00020\u0011J\u0006\u0010\u0014\u001a\u00020\u0015J\u000e\u0010\u0016\u001a\u00020\u00042\u0006\u0010\u0017\u001a\u00020\u000fR\u0011\u0010\u0003\u001a\u00020\u00048F\u00a2\u0006\u0006\u001a\u0004\u0008\u0005\u0010\u0006R\u0010\u0010\u0007\u001a\u0004\u0018\u00010\u0008X\u0082\u000e\u00a2\u0006\u0002\n\u0000R\u0010\u0010\t\u001a\u0004\u0018\u00010\nX\u0082\u000e\u00a2\u0006\u0002\n\u0000R\u0010\u0010\u000b\u001a\u0004\u0018\u00010\u000cX\u0082\u000e\u00a2\u0006\u0002\n\u0000\u00a8\u0006\u0018"
    }
    d2 = {
        "Lcom/yg/aprs/AprsClient;",
        "",
        "()V",
        "connected",
        "",
        "getConnected",
        "()Z",
        "reader",
        "Ljava/io/BufferedReader;",
        "socket",
        "Ljava/net/Socket;",
        "writer",
        "Ljava/io/BufferedWriter;",
        "connect",
        "host",
        "",
        "port",
        "",
        "callsign",
        "passcode",
        "disconnect",
        "",
        "sendLine",
        "line",
        "app_release"
    }
    k = 0x1
    mv = {
        0x1,
        0x8,
        0x0
    }
    xi = 0x30
.end annotation


# instance fields
.field private reader:Ljava/io/BufferedReader;

.field private socket:Ljava/net/Socket;

.field private writer:Ljava/io/BufferedWriter;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final declared-synchronized connect(Ljava/lang/String;ILjava/lang/String;I)Z
    .locals 5

    const-string v0, "user "

    monitor-enter p0

    :try_start_0
    const-string v1, "host"

    invoke-static {p1, v1}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    const-string v1, "callsign"

    invoke-static {p3, v1}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    .line 23
    invoke-virtual {p0}, Lcom/yg/aprs/AprsClient;->disconnect()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v1, 0x0

    .line 25
    :try_start_1
    new-instance v2, Ljava/net/Socket;

    invoke-direct {v2}, Ljava/net/Socket;-><init>()V

    .line 26
    new-instance v3, Ljava/net/InetSocketAddress;

    invoke-direct {v3, p1, p2}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;I)V

    check-cast v3, Ljava/net/SocketAddress;

    const/16 p1, 0x2710

    invoke-virtual {v2, v3, p1}, Ljava/net/Socket;->connect(Ljava/net/SocketAddress;I)V

    .line 27
    invoke-virtual {v2, p1}, Ljava/net/Socket;->setSoTimeout(I)V

    .line 28
    iput-object v2, p0, Lcom/yg/aprs/AprsClient;->socket:Ljava/net/Socket;

    .line 29
    new-instance p1, Ljava/io/BufferedWriter;

    new-instance p2, Ljava/io/OutputStreamWriter;

    invoke-virtual {v2}, Ljava/net/Socket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v3

    sget-object v4, Lkotlin/text/Charsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {p2, v3, v4}, Ljava/io/OutputStreamWriter;-><init>(Ljava/io/OutputStream;Ljava/nio/charset/Charset;)V

    check-cast p2, Ljava/io/Writer;

    invoke-direct {p1, p2}, Ljava/io/BufferedWriter;-><init>(Ljava/io/Writer;)V

    iput-object p1, p0, Lcom/yg/aprs/AprsClient;->writer:Ljava/io/BufferedWriter;

    .line 30
    new-instance p1, Ljava/io/BufferedReader;

    new-instance p2, Ljava/io/InputStreamReader;

    invoke-virtual {v2}, Ljava/net/Socket;->getInputStream()Ljava/io/InputStream;

    move-result-object v2

    sget-object v3, Lkotlin/text/Charsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {p2, v2, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/nio/charset/Charset;)V

    check-cast p2, Ljava/io/Reader;

    invoke-direct {p1, p2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    iput-object p1, p0, Lcom/yg/aprs/AprsClient;->reader:Ljava/io/BufferedReader;

    .line 32
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " pass "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " vers AuroraBeacon 1.4.1\r\n"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 33
    iget-object p2, p0, Lcom/yg/aprs/AprsClient;->writer:Ljava/io/BufferedWriter;

    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->checkNotNull(Ljava/lang/Object;)V

    invoke-virtual {p2, p1}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 34
    iget-object p1, p0, Lcom/yg/aprs/AprsClient;->writer:Ljava/io/BufferedWriter;

    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->checkNotNull(Ljava/lang/Object;)V

    invoke-virtual {p1}, Ljava/io/BufferedWriter;->flush()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :goto_0
    const/4 p1, 0x3

    if-ge v1, p1, :cond_2

    .line 38
    :try_start_2
    iget-object p1, p0, Lcom/yg/aprs/AprsClient;->reader:Ljava/io/BufferedReader;

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object p1

    goto :goto_1

    :cond_0
    const/4 p1, 0x0

    :goto_1
    if-nez p1, :cond_1

    goto :goto_2

    :cond_1
    const-string p2, "reader?.readLine() ?: return@repeat"

    invoke-static {p1, p2}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :catch_0
    :goto_2
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_2
    const/4 v1, 0x1

    goto :goto_3

    .line 42
    :catch_1
    :try_start_3
    invoke-virtual {p0}, Lcom/yg/aprs/AprsClient;->disconnect()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 24
    :goto_3
    monitor-exit p0

    return v1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public final declared-synchronized disconnect()V
    .locals 1

    monitor-enter p0

    .line 64
    :try_start_0
    iget-object v0, p0, Lcom/yg/aprs/AprsClient;->reader:Ljava/io/BufferedReader;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v0

    goto :goto_1

    .line 65
    :catch_0
    :cond_0
    :goto_0
    :try_start_1
    iget-object v0, p0, Lcom/yg/aprs/AprsClient;->writer:Ljava/io/BufferedWriter;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/io/BufferedWriter;->close()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 66
    :catch_1
    :cond_1
    :try_start_2
    iget-object v0, p0, Lcom/yg/aprs/AprsClient;->socket:Ljava/net/Socket;

    if-eqz v0, :cond_2

    invoke-virtual {v0}, Ljava/net/Socket;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :catch_2
    :cond_2
    const/4 v0, 0x0

    .line 67
    :try_start_3
    iput-object v0, p0, Lcom/yg/aprs/AprsClient;->reader:Ljava/io/BufferedReader;

    .line 68
    iput-object v0, p0, Lcom/yg/aprs/AprsClient;->writer:Ljava/io/BufferedWriter;

    .line 69
    iput-object v0, p0, Lcom/yg/aprs/AprsClient;->socket:Ljava/net/Socket;
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 70
    monitor-exit p0

    return-void

    :goto_1
    monitor-exit p0

    throw v0
.end method

.method public final getConnected()Z
    .locals 3

    .line 18
    iget-object v0, p0, Lcom/yg/aprs/AprsClient;->socket:Ljava/net/Socket;

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/net/Socket;->isConnected()Z

    move-result v0

    if-ne v0, v1, :cond_0

    move v0, v1

    goto :goto_0

    :cond_0
    move v0, v2

    :goto_0
    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/yg/aprs/AprsClient;->socket:Ljava/net/Socket;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/net/Socket;->isClosed()Z

    move-result v0

    if-nez v0, :cond_1

    move v0, v1

    goto :goto_1

    :cond_1
    move v0, v2

    :goto_1
    if-eqz v0, :cond_2

    goto :goto_2

    :cond_2
    move v1, v2

    :goto_2
    return v1
.end method

.method public final declared-synchronized sendLine(Ljava/lang/String;)Z
    .locals 2

    monitor-enter p0

    :try_start_0
    const-string v0, "line"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    .line 50
    iget-object v0, p0, Lcom/yg/aprs/AprsClient;->writer:Ljava/io/BufferedWriter;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    monitor-exit p0

    return v1

    .line 52
    :cond_0
    :try_start_1
    check-cast p1, Ljava/lang/CharSequence;

    invoke-static {p1}, Lkotlin/text/StringsKt;->trimEnd(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    const-string p1, "\r\n"

    .line 53
    invoke-virtual {v0, p1}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 54
    invoke-virtual {v0}, Ljava/io/BufferedWriter;->flush()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    const/4 v1, 0x1

    goto :goto_0

    .line 57
    :catch_0
    :try_start_2
    invoke-virtual {p0}, Lcom/yg/aprs/AprsClient;->disconnect()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 51
    :goto_0
    monitor-exit p0

    return v1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
