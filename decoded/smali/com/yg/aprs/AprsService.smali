.class public final Lcom/yg/aprs/AprsService;
.super Landroid/app/Service;
.source "AprsService.kt"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/yg/aprs/AprsService$Companion;
    }
.end annotation

.annotation system Ldalvik/annotation/SourceDebugExtension;
    value = "SMAP\nAprsService.kt\nKotlin\n*S Kotlin\n*F\n+ 1 AprsService.kt\ncom/yg/aprs/AprsService\n+ 2 fake.kt\nkotlin/jvm/internal/FakeKt\n*L\n1#1,200:1\n1#2:201\n*E\n"
.end annotation

.annotation runtime Lkotlin/Metadata;
    d1 = {
        "\u0000Z\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0008\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\u0008\u0002\n\u0002\u0018\u0002\n\u0002\u0008\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0008\u0003\n\u0002\u0010\u0008\n\u0002\u0008\u0008\u0018\u0000 (2\u00020\u0001:\u0001(B\u0005\u00a2\u0006\u0002\u0010\u0002J\u0008\u0010\u000e\u001a\u00020\u000fH\u0002J8\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00112\u0006\u0010\u0016\u001a\u00020\u00112\u0006\u0010\u0017\u001a\u00020\u00112\u0006\u0010\u0018\u001a\u00020\u0011H\u0002J\u0008\u0010\u0019\u001a\u00020\u000fH\u0002J\u0014\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\u0008\u0010\u001c\u001a\u0004\u0018\u00010\u001dH\u0016J\u0008\u0010\u001e\u001a\u00020\u000fH\u0016J\u0008\u0010\u001f\u001a\u00020\u000fH\u0016J\"\u0010 \u001a\u00020!2\u0008\u0010\u001c\u001a\u0004\u0018\u00010\u001d2\u0006\u0010\"\u001a\u00020!2\u0006\u0010#\u001a\u00020!H\u0016J\u0010\u0010$\u001a\u00020\u000f2\u0006\u0010%\u001a\u00020!H\u0002J\u0008\u0010&\u001a\u00020\u000fH\u0002J\u0008\u0010\'\u001a\u00020\u000fH\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u000e\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0008X\u0082.\u00a2\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\u0008\u0018\u00010\nR\u00020\u000bX\u0082\u000e\u00a2\u0006\u0002\n\u0000R\u0010\u0010\u000c\u001a\u0004\u0018\u00010\rX\u0082\u000e\u00a2\u0006\u0002\n\u0000\u00a8\u0006)"
    }
    d2 = {
        "Lcom/yg/aprs/AprsService;",
        "Landroid/app/Service;",
        "()V",
        "helper",
        "Lcom/yg/aprs/LocationHelper;",
        "stopped",
        "",
        "sysInfo",
        "Lcom/yg/aprs/SystemInfoHelper;",
        "wakeLock",
        "Landroid/os/PowerManager$WakeLock;",
        "Landroid/os/PowerManager;",
        "worker",
        "Ljava/lang/Thread;",
        "acquireWakeLock",
        "",
        "buildPacket",
        "",
        "call",
        "loc",
        "Landroid/location/Location;",
        "source",
        "net",
        "battery",
        "symbol",
        "createChannel",
        "onBind",
        "Landroid/os/IBinder;",
        "intent",
        "Landroid/content/Intent;",
        "onCreate",
        "onDestroy",
        "onStartCommand",
        "",
        "flags",
        "startId",
        "sleepSlice",
        "seconds",
        "startForegroundCompat",
        "startLoop",
        "Companion",
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


# static fields
.field public static final ACTION_START:Ljava/lang/String; = "com.yg.aprs.START"

.field public static final ACTION_STOP:Ljava/lang/String; = "com.yg.aprs.STOP"

.field private static final CH_ID:Ljava/lang/String; = "yg_aprs_channel"

.field public static final Companion:Lcom/yg/aprs/AprsService$Companion;

.field private static final NOTIF_ID:I = 0x3e9


# instance fields
.field private helper:Lcom/yg/aprs/LocationHelper;

.field private volatile stopped:Z

.field private sysInfo:Lcom/yg/aprs/SystemInfoHelper;

.field private wakeLock:Landroid/os/PowerManager$WakeLock;

.field private worker:Ljava/lang/Thread;


# direct methods
.method public static synthetic $r8$lambda$SlRmSUD3nYAlE5yDMZCy5IkhrQs(Lcom/yg/aprs/AprsService;)V
    .locals 0

    invoke-static {p0}, Lcom/yg/aprs/AprsService;->startLoop$lambda$2(Lcom/yg/aprs/AprsService;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 2

    new-instance v0, Lcom/yg/aprs/AprsService$Companion;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lcom/yg/aprs/AprsService$Companion;-><init>(Lkotlin/jvm/internal/DefaultConstructorMarker;)V

    sput-object v0, Lcom/yg/aprs/AprsService;->Companion:Lcom/yg/aprs/AprsService$Companion;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 20
    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    const/4 v0, 0x1

    .line 30
    iput-boolean v0, p0, Lcom/yg/aprs/AprsService;->stopped:Z

    return-void
.end method

.method private final acquireWakeLock()V
    .locals 3

    const-string v0, "power"

    .line 95
    invoke-virtual {p0, v0}, Lcom/yg/aprs/AprsService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    const-string v1, "null cannot be cast to non-null type android.os.PowerManager"

    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->checkNotNull(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast v0, Landroid/os/PowerManager;

    const/4 v1, 0x1

    const-string v2, "YG-APRS:wakelock"

    .line 96
    invoke-virtual {v0, v1, v2}, Landroid/os/PowerManager;->newWakeLock(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;

    move-result-object v0

    iput-object v0, p0, Lcom/yg/aprs/AprsService;->wakeLock:Landroid/os/PowerManager$WakeLock;

    if-eqz v0, :cond_0

    const/4 v1, 0x0

    .line 97
    invoke-virtual {v0, v1}, Landroid/os/PowerManager$WakeLock;->setReferenceCounted(Z)V

    .line 98
    :cond_0
    iget-object v0, p0, Lcom/yg/aprs/AprsService;->wakeLock:Landroid/os/PowerManager$WakeLock;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->acquire()V

    :cond_1
    return-void
.end method

.method private final buildPacket(Ljava/lang/String;Landroid/location/Location;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    sget-object v0, Lcom/yg/aprs/LocationHelper;->Companion:Lcom/yg/aprs/LocationHelper$Companion;

    invoke-virtual {p2}, Landroid/location/Location;->getLatitude()D

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Lcom/yg/aprs/LocationHelper$Companion;->aprsLat(D)Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcom/yg/aprs/LocationHelper;->Companion:Lcom/yg/aprs/LocationHelper$Companion;

    invoke-virtual {p2}, Landroid/location/Location;->getLongitude()D

    move-result-wide v3

    invoke-virtual {v1, v3, v4}, Lcom/yg/aprs/LocationHelper$Companion;->aprsLon(D)Ljava/lang/String;

    move-result-object p2

    sget-object v1, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v1, p0}, Lcom/yg/aprs/Prefs;->getComment(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    if-lez v2, :bp_auto

    move-object p3, v1

    goto :bp_cd

    :bp_auto

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "AURORA "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    const-string v1, " "

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    :bp_cd

    invoke-virtual {p6}, Ljava/lang/String;->length()I

    move-result v1

    const/4 v2, 0x2

    if-ne v1, v2, :bp_l1

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {p6, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p6, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    goto :bp_sd

    :bp_l1

    const/4 v2, 0x1

    if-ne v1, v2, :bp_df

    const-string v1, "/"

    move-object v2, p6

    goto :bp_sd

    :bp_df

    const-string v1, "/"

    const-string v2, ">"

    :bp_sd

    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p4, ">APRS,TCPIP*:!"

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method private final createChannel()V
    .locals 4

    .line 103
    new-instance v0, Landroid/app/NotificationChannel;

    const-string v1, "\u6781\u5149\u4fe1\u6807 \u540e\u53f0\u670d\u52a1"

    .line 104
    check-cast v1, Ljava/lang/CharSequence;

    const/4 v2, 0x2

    const-string v3, "yg_aprs_channel"

    .line 103
    invoke-direct {v0, v3, v1, v2}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    const-string v1, "APRS \u5b9a\u65f6\u4e0a\u62a5\u4fdd\u6d3b\u901a\u77e5"

    .line 106
    invoke-virtual {v0, v1}, Landroid/app/NotificationChannel;->setDescription(Ljava/lang/String;)V

    const-string v1, "notification"

    .line 107
    invoke-virtual {p0, v1}, Lcom/yg/aprs/AprsService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    const-string v2, "null cannot be cast to non-null type android.app.NotificationManager"

    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->checkNotNull(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast v1, Landroid/app/NotificationManager;

    invoke-virtual {v1, v0}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    return-void
.end method

.method private final sleepSlice(I)V
    .locals 3

    const/4 v0, 0x5

    .line 194
    invoke-static {p1, v0}, Lkotlin/ranges/RangesKt;->coerceAtLeast(II)I

    move-result p1

    :goto_0
    add-int/lit8 v0, p1, -0x1

    if-lez p1, :cond_0

    .line 195
    iget-boolean p1, p0, Lcom/yg/aprs/AprsService;->stopped:Z

    if-nez p1, :cond_0

    const-wide/16 v1, 0x3e8

    .line 196
    :try_start_0
    invoke-static {v1, v2}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    move p1, v0

    goto :goto_0

    :catch_0
    :cond_0
    return-void
.end method

.method private final startForegroundCompat()V
    .locals 4

    .line 76
    move-object v0, p0

    check-cast v0, Landroid/content/Context;

    new-instance v1, Landroid/content/Intent;

    const-class v2, Lcom/yg/aprs/MainActivity;

    invoke-direct {v1, v0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const/high16 v2, 0x4000000

    const/4 v3, 0x0

    .line 75
    invoke-static {v0, v3, v1, v2}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v1

    .line 79
    new-instance v2, Landroid/app/Notification$Builder;

    const-string v3, "yg_aprs_channel"

    invoke-direct {v2, v0, v3}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    const-string v0, "\u6781\u5149\u4fe1\u6807 \u8fd0\u884c\u4e2d"

    .line 80
    check-cast v0, Ljava/lang/CharSequence;

    invoke-virtual {v2, v0}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v0

    const-string v2, "\u6b63\u5728\u540e\u53f0\u5b9a\u65f6\u4e0a\u62a5\u5b9a\u4f4d\u5230 APRS-IS"

    .line 81
    check-cast v2, Ljava/lang/CharSequence;

    invoke-virtual {v0, v2}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v0

    const v2, 0x1080088

    .line 82
    invoke-virtual {v0, v2}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 83
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;

    move-result-object v0

    const/4 v1, 0x1

    .line 84
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;

    move-result-object v0

    .line 85
    invoke-virtual {v0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v0

    const-string v1, "Builder(this, CH_ID)\n   \u2026rue)\n            .build()"

    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    .line 87
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1d

    const/16 v3, 0x3e9

    if-lt v1, v2, :cond_0

    const/16 v1, 0x8

    .line 88
    invoke-virtual {p0, v3, v0, v1}, Lcom/yg/aprs/AprsService;->startForeground(ILandroid/app/Notification;I)V

    goto :goto_0

    .line 90
    :cond_0
    invoke-virtual {p0, v3, v0}, Lcom/yg/aprs/AprsService;->startForeground(ILandroid/app/Notification;)V

    :goto_0
    return-void
.end method

.method private final startLoop()V
    .locals 2

    .line 112
    iget-object v0, p0, Lcom/yg/aprs/AprsService;->worker:Ljava/lang/Thread;

    if-eqz v0, :cond_0

    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNull(Ljava/lang/Object;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x0

    .line 113
    iput-boolean v0, p0, Lcom/yg/aprs/AprsService;->stopped:Z

    .line 114
    new-instance v0, Ljava/lang/Thread;

    .line 177
    new-instance v1, Lcom/yg/aprs/AprsService$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/yg/aprs/AprsService$$ExternalSyntheticLambda0;-><init>(Lcom/yg/aprs/AprsService;)V

    .line 114
    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 177
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 114
    iput-object v0, p0, Lcom/yg/aprs/AprsService;->worker:Ljava/lang/Thread;

    return-void
.end method

.method private static final startLoop$lambda$2(Lcom/yg/aprs/AprsService;)V
    .locals 24

    move-object/from16 v8, p0

    const-string v0, "this$0"

    invoke-static {v8, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    .line 115
    new-instance v9, Lcom/yg/aprs/AprsClient;

    invoke-direct {v9}, Lcom/yg/aprs/AprsClient;-><init>()V

    .line 116
    sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    move-object v1, v8

    check-cast v1, Landroid/content/Context;

    invoke-virtual {v0, v1}, Lcom/yg/aprs/Prefs;->getCallsign(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 117
    sget-object v2, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v2, v1}, Lcom/yg/aprs/Prefs;->getSsid(Landroid/content/Context;)I

    move-result v2

    .line 118
    sget-object v3, Lcom/yg/aprs/AprsPasscode;->INSTANCE:Lcom/yg/aprs/AprsPasscode;

    invoke-virtual {v3, v0, v2}, Lcom/yg/aprs/AprsPasscode;->fullCall(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v10

    .line 119
    sget-object v2, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v2, v1}, Lcom/yg/aprs/Prefs;->getHost(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v11

    .line 120
    sget-object v2, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v2, v1}, Lcom/yg/aprs/Prefs;->getPort(Landroid/content/Context;)I

    move-result v12

    .line 121
    sget-object v2, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v2, v1}, Lcom/yg/aprs/Prefs;->getInterval(Landroid/content/Context;)I

    move-result v13

    .line 122
    sget-object v2, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v2, v1}, Lcom/yg/aprs/Prefs;->getSymbol(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v14

    .line 123
    sget-object v1, Lcom/yg/aprs/AprsPasscode;->INSTANCE:Lcom/yg/aprs/AprsPasscode;

    invoke-virtual {v1, v0}, Lcom/yg/aprs/AprsPasscode;->compute(Ljava/lang/String;)I

    move-result v15

    .line 125
    sget-object v0, Lcom/yg/aprs/ServiceBus;->INSTANCE:Lcom/yg/aprs/ServiceBus;

    new-instance v1, Lcom/yg/aprs/AprsService$startLoop$1$1;

    invoke-direct {v1, v11, v12, v15}, Lcom/yg/aprs/AprsService$startLoop$1$1;-><init>(Ljava/lang/String;II)V

    check-cast v1, Lkotlin/jvm/functions/Function1;

    invoke-virtual {v0, v1}, Lcom/yg/aprs/ServiceBus;->update(Lkotlin/jvm/functions/Function1;)V

    .line 127
    :goto_0
    iget-boolean v0, v8, Lcom/yg/aprs/AprsService;->stopped:Z

    if-nez v0, :cond_8

    .line 129
    :try_start_0
    invoke-virtual {v9}, Lcom/yg/aprs/AprsClient;->getConnected()Z

    move-result v0

    if-nez v0, :cond_0

    .line 130
    invoke-virtual {v9, v11, v12, v10, v15}, Lcom/yg/aprs/AprsClient;->connect(Ljava/lang/String;ILjava/lang/String;I)Z

    move-result v0

    if-nez v0, :cond_0

    .line 132
    sget-object v0, Lcom/yg/aprs/ServiceBus;->INSTANCE:Lcom/yg/aprs/ServiceBus;

    new-instance v1, Lcom/yg/aprs/AprsService$startLoop$1$2;

    invoke-direct {v1, v13}, Lcom/yg/aprs/AprsService$startLoop$1$2;-><init>(I)V

    check-cast v1, Lkotlin/jvm/functions/Function1;

    invoke-virtual {v0, v1}, Lcom/yg/aprs/ServiceBus;->update(Lkotlin/jvm/functions/Function1;)V

    .line 133
    invoke-direct {v8, v13}, Lcom/yg/aprs/AprsService;->sleepSlice(I)V

    goto :goto_0

    .line 138
    :cond_0
    iget-object v0, v8, Lcom/yg/aprs/AprsService;->helper:Lcom/yg/aprs/LocationHelper;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const-string v1, "helper"

    const/4 v2, 0x0

    if-nez v0, :cond_1

    :try_start_1
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v0, v2

    :cond_1
    invoke-virtual {v0}, Lcom/yg/aprs/LocationHelper;->bestLocation()Landroid/location/Location;

    move-result-object v18

    .line 139
    iget-object v0, v8, Lcom/yg/aprs/AprsService;->helper:Lcom/yg/aprs/LocationHelper;

    if-nez v0, :cond_2

    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v0, v2

    :cond_2
    invoke-virtual {v0}, Lcom/yg/aprs/LocationHelper;->cellTowerInfo()Ljava/lang/String;

    move-result-object v0

    .line 140
    iget-object v1, v8, Lcom/yg/aprs/AprsService;->sysInfo:Lcom/yg/aprs/SystemInfoHelper;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    const-string v3, "sysInfo"

    if-nez v1, :cond_3

    :try_start_2
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v1, v2

    :cond_3
    invoke-virtual {v1}, Lcom/yg/aprs/SystemInfoHelper;->networkInfo()Ljava/lang/String;

    move-result-object v7

    .line 141
    iget-object v1, v8, Lcom/yg/aprs/AprsService;->sysInfo:Lcom/yg/aprs/SystemInfoHelper;

    if-nez v1, :cond_4

    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    goto :goto_1

    :cond_4
    move-object v2, v1

    :goto_1
    invoke-virtual {v2}, Lcom/yg/aprs/SystemInfoHelper;->batteryInfo()Ljava/lang/String;

    move-result-object v6

    if-nez v18, :cond_5

    .line 144
    sget-object v1, Lcom/yg/aprs/ServiceBus;->INSTANCE:Lcom/yg/aprs/ServiceBus;

    new-instance v2, Lcom/yg/aprs/AprsService$startLoop$1$3;

    invoke-direct {v2, v0, v7, v6}, Lcom/yg/aprs/AprsService$startLoop$1$3;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    check-cast v2, Lkotlin/jvm/functions/Function1;

    invoke-virtual {v1, v2}, Lcom/yg/aprs/ServiceBus;->update(Lkotlin/jvm/functions/Function1;)V

    goto/16 :goto_3

    .line 146
    :cond_5
    invoke-virtual/range {v18 .. v18}, Landroid/location/Location;->getProvider()Ljava/lang/String;

    move-result-object v1

    const-string v2, "gps"

    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->areEqual(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_6

    const-string v1, "GPS"

    goto :goto_2

    :cond_6
    const-string v1, "\u57fa\u7ad9/\u7f51\u7edc"

    :goto_2
    move-object/from16 v19, v1

    move-object/from16 v1, p0

    move-object v2, v10

    move-object/from16 v3, v18

    move-object/from16 v4, v19

    move-object v5, v7

    move-object/from16 v22, v6

    move-object/from16 v21, v7

    move-object v7, v14

    .line 147
    invoke-direct/range {v1 .. v7}, Lcom/yg/aprs/AprsService;->buildPacket(Ljava/lang/String;Landroid/location/Location;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 148
    invoke-virtual {v9, v1}, Lcom/yg/aprs/AprsClient;->sendLine(Ljava/lang/String;)Z

    move-result v2

    .line 149
    new-instance v3, Ljava/text/SimpleDateFormat;

    const-string v4, "HH:mm:ss"

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v5

    invoke-direct {v3, v4, v5}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    new-instance v4, Ljava/util/Date;

    invoke-direct {v4}, Ljava/util/Date;-><init>()V

    invoke-virtual {v3, v4}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v17

    if-eqz v2, :cond_7

    .line 151
    sget-object v2, Lcom/yg/aprs/ServiceBus;->INSTANCE:Lcom/yg/aprs/ServiceBus;

    new-instance v3, Lcom/yg/aprs/AprsService$startLoop$1$4;

    move-object/from16 v16, v3

    move-object/from16 v20, v0

    move-object/from16 v23, v1

    invoke-direct/range {v16 .. v23}, Lcom/yg/aprs/AprsService$startLoop$1$4;-><init>(Ljava/lang/String;Landroid/location/Location;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    check-cast v3, Lkotlin/jvm/functions/Function1;

    invoke-virtual {v2, v3}, Lcom/yg/aprs/ServiceBus;->update(Lkotlin/jvm/functions/Function1;)V

    goto :goto_3

    .line 165
    :cond_7
    sget-object v1, Lcom/yg/aprs/ServiceBus;->INSTANCE:Lcom/yg/aprs/ServiceBus;

    new-instance v2, Lcom/yg/aprs/AprsService$startLoop$1$5;

    move-object/from16 v3, v21

    move-object/from16 v4, v22

    invoke-direct {v2, v0, v3, v4}, Lcom/yg/aprs/AprsService$startLoop$1$5;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    check-cast v2, Lkotlin/jvm/functions/Function1;

    invoke-virtual {v1, v2}, Lcom/yg/aprs/ServiceBus;->update(Lkotlin/jvm/functions/Function1;)V

    .line 166
    invoke-virtual {v9}, Lcom/yg/aprs/AprsClient;->disconnect()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_3

    :catch_0
    move-exception v0

    .line 170
    sget-object v1, Lcom/yg/aprs/ServiceBus;->INSTANCE:Lcom/yg/aprs/ServiceBus;

    new-instance v2, Lcom/yg/aprs/AprsService$startLoop$1$6;

    invoke-direct {v2, v0}, Lcom/yg/aprs/AprsService$startLoop$1$6;-><init>(Ljava/lang/Exception;)V

    check-cast v2, Lkotlin/jvm/functions/Function1;

    invoke-virtual {v1, v2}, Lcom/yg/aprs/ServiceBus;->update(Lkotlin/jvm/functions/Function1;)V

    .line 171
    invoke-virtual {v9}, Lcom/yg/aprs/AprsClient;->disconnect()V

    .line 173
    :goto_3
    invoke-direct {v8, v13}, Lcom/yg/aprs/AprsService;->sleepSlice(I)V

    goto/16 :goto_0

    .line 176
    :cond_8
    invoke-virtual {v9}, Lcom/yg/aprs/AprsClient;->disconnect()V

    return-void
.end method


# virtual methods
.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 0

    const/4 p1, 0x0

    return-object p1
.end method

.method public onCreate()V
    .locals 2

    .line 36
    invoke-super {p0}, Landroid/app/Service;->onCreate()V

    .line 37
    new-instance v0, Lcom/yg/aprs/LocationHelper;

    move-object v1, p0

    check-cast v1, Landroid/content/Context;

    invoke-direct {v0, v1}, Lcom/yg/aprs/LocationHelper;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/yg/aprs/AprsService;->helper:Lcom/yg/aprs/LocationHelper;

    .line 38
    new-instance v0, Lcom/yg/aprs/SystemInfoHelper;

    invoke-direct {v0, v1}, Lcom/yg/aprs/SystemInfoHelper;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/yg/aprs/AprsService;->sysInfo:Lcom/yg/aprs/SystemInfoHelper;

    .line 39
    invoke-direct {p0}, Lcom/yg/aprs/AprsService;->createChannel()V

    return-void
.end method

.method public onDestroy()V
    .locals 3

    const/4 v0, 0x1

    .line 63
    iput-boolean v0, p0, Lcom/yg/aprs/AprsService;->stopped:Z

    .line 64
    iget-object v0, p0, Lcom/yg/aprs/AprsService;->worker:Ljava/lang/Thread;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    .line 65
    :cond_0
    sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    move-object v1, p0

    check-cast v1, Landroid/content/Context;

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Lcom/yg/aprs/Prefs;->setWantRunning(Landroid/content/Context;Z)V

    .line 66
    iget-object v0, p0, Lcom/yg/aprs/AprsService;->wakeLock:Landroid/os/PowerManager$WakeLock;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->isHeld()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->release()V

    .line 67
    :cond_1
    iget-object v0, p0, Lcom/yg/aprs/AprsService;->helper:Lcom/yg/aprs/LocationHelper;

    if-eqz v0, :cond_3

    if-nez v0, :cond_2

    const-string v0, "helper"

    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    const/4 v0, 0x0

    :cond_2
    invoke-virtual {v0}, Lcom/yg/aprs/LocationHelper;->stop()V

    .line 68
    :cond_3
    sget-object v0, Lcom/yg/aprs/ServiceBus;->INSTANCE:Lcom/yg/aprs/ServiceBus;

    sget-object v1, Lcom/yg/aprs/AprsService$onDestroy$3;->INSTANCE:Lcom/yg/aprs/AprsService$onDestroy$3;

    check-cast v1, Lkotlin/jvm/functions/Function1;

    invoke-virtual {v0, v1}, Lcom/yg/aprs/ServiceBus;->update(Lkotlin/jvm/functions/Function1;)V

    .line 69
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 0

    if-eqz p1, :cond_0

    .line 43
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    const-string p2, "com.yg.aprs.STOP"

    invoke-static {p1, p2}, Lkotlin/jvm/internal/Intrinsics;->areEqual(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p1

    const/4 p2, 0x2

    if-eqz p1, :cond_1

    .line 44
    invoke-virtual {p0}, Lcom/yg/aprs/AprsService;->stopSelf()V

    return p2

    .line 48
    :cond_1
    sget-object p1, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    move-object p3, p0

    check-cast p3, Landroid/content/Context;

    invoke-virtual {p1, p3}, Lcom/yg/aprs/Prefs;->getCallsign(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p1

    .line 49
    check-cast p1, Ljava/lang/CharSequence;

    invoke-static {p1}, Lkotlin/text/StringsKt;->isBlank(Ljava/lang/CharSequence;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 50
    sget-object p1, Lcom/yg/aprs/ServiceBus;->INSTANCE:Lcom/yg/aprs/ServiceBus;

    sget-object p3, Lcom/yg/aprs/AprsService$onStartCommand$1;->INSTANCE:Lcom/yg/aprs/AprsService$onStartCommand$1;

    check-cast p3, Lkotlin/jvm/functions/Function1;

    invoke-virtual {p1, p3}, Lcom/yg/aprs/ServiceBus;->update(Lkotlin/jvm/functions/Function1;)V

    .line 51
    invoke-virtual {p0}, Lcom/yg/aprs/AprsService;->stopSelf()V

    return p2

    .line 55
    :cond_2
    invoke-direct {p0}, Lcom/yg/aprs/AprsService;->startForegroundCompat()V

    .line 56
    invoke-direct {p0}, Lcom/yg/aprs/AprsService;->acquireWakeLock()V

    .line 57
    sget-object p1, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    const/4 p2, 0x1

    invoke-virtual {p1, p3, p2}, Lcom/yg/aprs/Prefs;->setWantRunning(Landroid/content/Context;Z)V

    .line 58
    invoke-direct {p0}, Lcom/yg/aprs/AprsService;->startLoop()V

    return p2
.end method
