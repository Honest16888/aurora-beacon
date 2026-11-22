.class public final Lcom/yg/aprs/LocationHelper;
.super Ljava/lang/Object;
.source "LocationHelper.kt"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/yg/aprs/LocationHelper$Companion;
    }
.end annotation

.annotation system Ldalvik/annotation/SourceDebugExtension;
    value = "SMAP\nLocationHelper.kt\nKotlin\n*S Kotlin\n*F\n+ 1 LocationHelper.kt\ncom/yg/aprs/LocationHelper\n+ 2 fake.kt\nkotlin/jvm/internal/FakeKt\n*L\n1#1,151:1\n1#2:152\n*E\n"
.end annotation

.annotation runtime Lkotlin/Metadata;
    d1 = {
        "\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0008\u0002\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\u0008\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0008\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\u0008\u0005\u0018\u0000 \u00152\u00020\u0001:\u0001\u0015B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\n\u0010\r\u001a\u0004\u0018\u00010\u0007H\u0007J\u0008\u0010\u000e\u001a\u00020\u000fH\u0007J\u0010\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0007H\u0002J\u0008\u0010\u0013\u001a\u00020\u0011H\u0003J\u0008\u0010\u0014\u001a\u00020\u0011H\u0007R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0018\u0010\u0005\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00070\u0006X\u0082\u0004\u00a2\u0006\u0004\n\u0002\u0010\u0008R\u0010\u0010\t\u001a\u0004\u0018\u00010\nX\u0082\u000e\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\u000cX\u0082\u0004\u00a2\u0006\u0002\n\u0000\u00a8\u0006\u0016"
    }
    d2 = {
        "Lcom/yg/aprs/LocationHelper;",
        "",
        "ctx",
        "Landroid/content/Context;",
        "(Landroid/content/Context;)V",
        "latest",
        "",
        "Landroid/location/Location;",
        "[Landroid/location/Location;",
        "listener",
        "Landroid/location/LocationListener;",
        "lm",
        "Landroid/location/LocationManager;",
        "bestLocation",
        "cellTowerInfo",
        "",
        "keepNewer",
        "",
        "loc",
        "startContinuousUpdates",
        "stop",
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
.field public static final Companion:Lcom/yg/aprs/LocationHelper$Companion;


# instance fields
.field private final ctx:Landroid/content/Context;

.field private final latest:[Landroid/location/Location;

.field private listener:Landroid/location/LocationListener;

.field private final lm:Landroid/location/LocationManager;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    new-instance v0, Lcom/yg/aprs/LocationHelper$Companion;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lcom/yg/aprs/LocationHelper$Companion;-><init>(Lkotlin/jvm/internal/DefaultConstructorMarker;)V

    sput-object v0, Lcom/yg/aprs/LocationHelper;->Companion:Lcom/yg/aprs/LocationHelper$Companion;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    const-string v0, "ctx"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/yg/aprs/LocationHelper;->ctx:Landroid/content/Context;

    const-string v0, "location"

    .line 22
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    const-string v0, "null cannot be cast to non-null type android.location.LocationManager"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNull(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/location/LocationManager;

    iput-object p1, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    const/4 p1, 0x1

    new-array p1, p1, [Landroid/location/Location;

    .line 23
    iput-object p1, p0, Lcom/yg/aprs/LocationHelper;->latest:[Landroid/location/Location;

    .line 27
    invoke-direct {p0}, Lcom/yg/aprs/LocationHelper;->startContinuousUpdates()V

    return-void
.end method

.method public static final synthetic access$keepNewer(Lcom/yg/aprs/LocationHelper;Landroid/location/Location;)V
    .locals 0

    .line 20
    invoke-direct {p0, p1}, Lcom/yg/aprs/LocationHelper;->keepNewer(Landroid/location/Location;)V

    return-void
.end method

.method private final keepNewer(Landroid/location/Location;)V
    .locals 6

    .line 31
    iget-object v0, p0, Lcom/yg/aprs/LocationHelper;->latest:[Landroid/location/Location;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    if-eqz v0, :cond_0

    .line 32
    invoke-virtual {p1}, Landroid/location/Location;->getTime()J

    move-result-wide v2

    invoke-virtual {v0}, Landroid/location/Location;->getTime()J

    move-result-wide v4

    cmp-long v0, v2, v4

    if-ltz v0, :cond_1

    :cond_0
    iget-object v0, p0, Lcom/yg/aprs/LocationHelper;->latest:[Landroid/location/Location;

    aput-object p1, v0, v1

    :cond_1
    return-void
.end method

.method private final startContinuousUpdates()V
    .locals 9

    .line 39
    :try_start_0
    new-instance v0, Lcom/yg/aprs/LocationHelper$startContinuousUpdates$li$1;

    invoke-direct {v0, p0}, Lcom/yg/aprs/LocationHelper$startContinuousUpdates$li$1;-><init>(Lcom/yg/aprs/LocationHelper;)V

    .line 45
    move-object v1, v0

    check-cast v1, Landroid/location/LocationListener;

    iput-object v1, p0, Lcom/yg/aprs/LocationHelper;->listener:Landroid/location/LocationListener;

    .line 47
    iget-object v1, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    const-string v2, "gps"

    invoke-virtual {v1, v2}, Landroid/location/LocationManager;->isProviderEnabled(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 48
    iget-object v2, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    const-string v3, "gps"

    const-wide/16 v4, 0x3e8

    const/4 v6, 0x0

    move-object v7, v0

    check-cast v7, Landroid/location/LocationListener;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v8

    invoke-virtual/range {v2 .. v8}, Landroid/location/LocationManager;->requestLocationUpdates(Ljava/lang/String;JFLandroid/location/LocationListener;Landroid/os/Looper;)V

    .line 50
    :cond_0
    iget-object v1, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    const-string v2, "network"

    invoke-virtual {v1, v2}, Landroid/location/LocationManager;->isProviderEnabled(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 51
    iget-object v2, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    const-string v3, "network"

    const-wide/16 v4, 0x3e8

    const/4 v6, 0x0

    move-object v7, v0

    check-cast v7, Landroid/location/LocationListener;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v8

    invoke-virtual/range {v2 .. v8}, Landroid/location/LocationManager;->requestLocationUpdates(Ljava/lang/String;JFLandroid/location/LocationListener;Landroid/os/Looper;)V

    .line 54
    :cond_1
    iget-object v0, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/location/LocationManager;->getProviders(Z)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_2
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 55
    iget-object v2, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    invoke-virtual {v2, v1}, Landroid/location/LocationManager;->getLastKnownLocation(Ljava/lang/String;)Landroid/location/Location;

    move-result-object v1

    if-eqz v1, :cond_2

    invoke-direct {p0, v1}, Lcom/yg/aprs/LocationHelper;->keepNewer(Landroid/location/Location;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    :cond_3
    return-void
.end method


# virtual methods
.method public final bestLocation()Landroid/location/Location;
    .locals 7

    .line 70
    iget-object v0, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    const-string v1, "gps"

    invoke-virtual {v0, v1}, Landroid/location/LocationManager;->isProviderEnabled(Ljava/lang/String;)Z

    move-result v0

    const/4 v2, 0x0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 71
    :cond_0
    iget-object v0, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    const-string v1, "network"

    invoke-virtual {v0, v1}, Landroid/location/LocationManager;->isProviderEnabled(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 76
    :goto_0
    new-instance v0, Ljava/util/concurrent/CountDownLatch;

    const/4 v3, 0x1

    invoke-direct {v0, v3}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 77
    new-instance v3, Lcom/yg/aprs/LocationHelper$bestLocation$oneShot$1;

    invoke-direct {v3, p0, v0}, Lcom/yg/aprs/LocationHelper$bestLocation$oneShot$1;-><init>(Lcom/yg/aprs/LocationHelper;Ljava/util/concurrent/CountDownLatch;)V

    .line 87
    :try_start_0
    iget-object v4, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    move-object v5, v3

    check-cast v5, Landroid/location/LocationListener;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v6

    invoke-virtual {v4, v1, v5, v6}, Landroid/location/LocationManager;->requestSingleUpdate(Ljava/lang/String;Landroid/location/LocationListener;Landroid/os/Looper;)V

    .line 88
    sget-object v1, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v4, 0x4

    invoke-virtual {v0, v4, v5, v1}, Ljava/util/concurrent/CountDownLatch;->await(JLjava/util/concurrent/TimeUnit;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 92
    :catch_0
    :try_start_1
    iget-object v0, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    check-cast v3, Landroid/location/LocationListener;

    invoke-virtual {v0, v3}, Landroid/location/LocationManager;->removeUpdates(Landroid/location/LocationListener;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 94
    :catch_1
    iget-object v0, p0, Lcom/yg/aprs/LocationHelper;->latest:[Landroid/location/Location;

    aget-object v0, v0, v2

    return-object v0

    .line 72
    :cond_1
    iget-object v0, p0, Lcom/yg/aprs/LocationHelper;->latest:[Landroid/location/Location;

    aget-object v0, v0, v2

    return-object v0
.end method

.method public final cellTowerInfo()Ljava/lang/String;
    .locals 12

    .line 108
    :try_start_0
    iget-object v0, p0, Lcom/yg/aprs/LocationHelper;->ctx:Landroid/content/Context;

    const-string v1, "phone"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    const-string v1, "null cannot be cast to non-null type android.telephony.TelephonyManager"

    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->checkNotNull(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast v0, Landroid/telephony/TelephonyManager;

    .line 109
    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getAllCellInfo()Ljava/util/List;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const-string v1, "\u65e0\u57fa\u7ad9\u4fe1\u606f"

    if-nez v0, :cond_0

    return-object v1

    .line 110
    :cond_0
    :try_start_1
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    check-cast v2, Ljava/util/List;

    .line 111
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_1
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/CellInfo;

    .line 113
    instance-of v4, v3, Landroid/telephony/CellInfoGsm;
    :try_end_1
    .catch Ljava/lang/SecurityException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    const-string v5, "/"

    const-string v6, "c.cellIdentity"

    if-eqz v4, :cond_2

    .line 114
    :try_start_2
    check-cast v3, Landroid/telephony/CellInfoGsm;

    invoke-virtual {v3}, Landroid/telephony/CellInfoGsm;->getCellIdentity()Landroid/telephony/CellIdentityGsm;

    move-result-object v3

    invoke-static {v3, v6}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    .line 115
    invoke-virtual {v3}, Landroid/telephony/CellIdentityGsm;->getMcc()I

    move-result v4

    invoke-virtual {v3}, Landroid/telephony/CellIdentityGsm;->getMnc()I

    move-result v6

    invoke-virtual {v3}, Landroid/telephony/CellIdentityGsm;->getLac()I

    move-result v7

    invoke-virtual {v3}, Landroid/telephony/CellIdentityGsm;->getCid()I

    move-result v3

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v8, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " LAC"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " CID"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v2, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 117
    :cond_2
    instance-of v4, v3, Landroid/telephony/CellInfoLte;

    if-eqz v4, :cond_1

    .line 118
    check-cast v3, Landroid/telephony/CellInfoLte;

    invoke-virtual {v3}, Landroid/telephony/CellInfoLte;->getCellIdentity()Landroid/telephony/CellIdentityLte;

    move-result-object v3

    invoke-static {v3, v6}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    .line 119
    invoke-virtual {v3}, Landroid/telephony/CellIdentityLte;->getMcc()I

    move-result v4

    invoke-virtual {v3}, Landroid/telephony/CellIdentityLte;->getMnc()I

    move-result v6

    invoke-virtual {v3}, Landroid/telephony/CellIdentityLte;->getCi()I

    move-result v3

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " ECI"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v2, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto/16 :goto_0

    .line 123
    :cond_3
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    goto :goto_1

    :cond_4
    move-object v3, v2

    check-cast v3, Ljava/lang/Iterable;

    const-string v0, "; "

    move-object v4, v0

    check-cast v4, Ljava/lang/CharSequence;

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/16 v10, 0x3e

    const/4 v11, 0x0

    invoke-static/range {v3 .. v11}, Lkotlin/collections/CollectionsKt;->joinToString$default(Ljava/lang/Iterable;Ljava/lang/CharSequence;Ljava/lang/CharSequence;Ljava/lang/CharSequence;ILjava/lang/CharSequence;Lkotlin/jvm/functions/Function1;ILjava/lang/Object;)Ljava/lang/String;

    move-result-object v1
    :try_end_2
    .catch Ljava/lang/SecurityException; {:try_start_2 .. :try_end_2} :catch_1
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_1

    :catch_0
    const-string v1, "\u57fa\u7ad9\u4fe1\u606f\u4e0d\u53ef\u7528"

    goto :goto_1

    :catch_1
    const-string v1, "\u65e0\u57fa\u7ad9\u6743\u9650"

    :goto_1
    return-object v1
.end method

.method public final stop()V
    .locals 2

    .line 100
    iget-object v0, p0, Lcom/yg/aprs/LocationHelper;->listener:Landroid/location/LocationListener;

    if-eqz v0, :cond_0

    :try_start_0
    iget-object v1, p0, Lcom/yg/aprs/LocationHelper;->lm:Landroid/location/LocationManager;

    invoke-virtual {v1, v0}, Landroid/location/LocationManager;->removeUpdates(Landroid/location/LocationListener;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_0
    const/4 v0, 0x0

    .line 101
    iput-object v0, p0, Lcom/yg/aprs/LocationHelper;->listener:Landroid/location/LocationListener;

    return-void
.end method
