.class public final Lcom/yg/aprs/MainActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MainActivity.kt"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/yg/aprs/MainActivity$Companion;
    }
.end annotation

.annotation system Ldalvik/annotation/SourceDebugExtension;
    value = "SMAP\nMainActivity.kt\nKotlin\n*S Kotlin\n*F\n+ 1 MainActivity.kt\ncom/yg/aprs/MainActivity\n+ 2 ArraysJVM.kt\nkotlin/collections/ArraysKt__ArraysJVMKt\n+ 3 fake.kt\nkotlin/jvm/internal/FakeKt\n+ 4 _Arrays.kt\nkotlin/collections/ArraysKt___ArraysKt\n*L\n1#1,197:1\n37#2,2:198\n1#3:200\n12744#4,2:201\n12583#4,2:203\n*S KotlinDebug\n*F\n+ 1 MainActivity.kt\ncom/yg/aprs/MainActivity\n*L\n63#1:198,2\n166#1:201,2\n192#1:203,2\n*E\n"
.end annotation

.annotation runtime Lkotlin/Metadata;
    d1 = {
        "\u0000X\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0008\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0008\u0004\n\u0002\u0010\u0008\n\u0000\n\u0002\u0010\u0011\n\u0002\u0010\u000e\n\u0002\u0008\u0003\n\u0002\u0018\u0002\n\u0002\u0008\u0002\n\u0002\u0018\u0002\n\u0002\u0008\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0008\u0004\n\u0002\u0010\u0015\n\u0002\u0008\u0006\u0018\u0000 -2\u00020\u0001:\u0001-B\u0005\u00a2\u0006\u0002\u0010\u0002J\u0008\u0010\u001e\u001a\u00020\u001fH\u0002J\u0012\u0010 \u001a\u00020!2\u0008\u0010\"\u001a\u0004\u0018\u00010#H\u0014J-\u0010$\u001a\u00020!2\u0006\u0010%\u001a\u00020\u000b2\u000e\u0010&\u001a\n\u0012\u0006\u0008\u0001\u0012\u00020\u000e0\r2\u0006\u0010\'\u001a\u00020(H\u0016\u00a2\u0006\u0002\u0010)J\u0008\u0010*\u001a\u00020!H\u0002J\u0008\u0010+\u001a\u00020!H\u0002J\u0008\u0010,\u001a\u00020!H\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0006X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0008\u001a\u00020\u0006X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0006X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082D\u00a2\u0006\u0002\n\u0000R\u001a\u0010\u000c\u001a\u0008\u0012\u0004\u0012\u00020\u000e0\r8BX\u0082\u0004\u00a2\u0006\u0006\u001a\u0004\u0008\u000f\u0010\u0010R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0012X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0015X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0015X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0018\u001a\u00020\u0015X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0019\u001a\u00020\u0015X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u001a\u001a\u00020\u0015X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u001b\u001a\u00020\u0015X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u001c\u001a\u00020\u0015X\u0082.\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u001d\u001a\u00020\u0015X\u0082.\u00a2\u0006\u0002\n\u0000\u00a8\u0006."
    }
    d2 = {
        "Lcom/yg/aprs/MainActivity;",
        "Landroidx/appcompat/app/AppCompatActivity;",
        "()V",
        "btnToggle",
        "Landroid/widget/Button;",
        "etCall",
        "Landroid/widget/EditText;",
        "etInterval",
        "etPort",
        "etSsid",
        "permReq",
        "",
        "requiredPerms",
        "",
        "",
        "getRequiredPerms",
        "()[Ljava/lang/String;",
        "spinnerServer",
        "Landroid/widget/Spinner;",
        "spinnerSymbol",
        "tvBattery",
        "Landroid/widget/TextView;",
        "tvCell",
        "tvHomepage",
        "tvLastSent",
        "tvNet",
        "tvPasscode",
        "tvPos",
        "tvSource",
        "tvStatus",
        "missingPermission",
        "",
        "onCreate",
        "",
        "savedInstanceState",
        "Landroid/os/Bundle;",
        "onRequestPermissionsResult",
        "requestCode",
        "permissions",
        "grantResults",
        "",
        "(I[Ljava/lang/String;[I)V",
        "refreshPasscode",
        "saveConfig",
        "startAprs",
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
.field public static final Companion:Lcom/yg/aprs/MainActivity$Companion;

.field private static final SERVER_HOSTS:[Ljava/lang/String;

.field private static final SYMBOL_CHARS:[Ljava/lang/String;


# instance fields
.field private btnToggle:Landroid/widget/Button;

.field private etCall:Landroid/widget/EditText;

.field private etComment:Landroid/widget/EditText;

.field private etInterval:Landroid/widget/EditText;

.field private etPort:Landroid/widget/EditText;

.field private etSsid:Landroid/widget/EditText;

.field private final permReq:I

.field private spinnerServer:Landroid/widget/Spinner;

.field private spinnerSymbol:Landroid/widget/Spinner;

.field private tvBattery:Landroid/widget/TextView;

.field private tvCell:Landroid/widget/TextView;

.field private tvHomepage:Landroid/widget/TextView;

.field private tvLastSent:Landroid/widget/TextView;

.field private tvNet:Landroid/widget/TextView;

.field private tvPasscode:Landroid/widget/TextView;

.field private tvPos:Landroid/widget/TextView;

.field private tvSource:Landroid/widget/TextView;

.field private tvStatus:Landroid/widget/TextView;


# direct methods
.method public static synthetic $r8$lambda$ClulfJ4litvazgSQpUAETwaOVX0(Lcom/yg/aprs/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/yg/aprs/MainActivity;->onCreate$lambda$3(Lcom/yg/aprs/MainActivity;Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$aszVKzB0FXMX_kRC-ozmAKm9xzw(Lcom/yg/aprs/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/yg/aprs/MainActivity;->onCreate$lambda$5(Lcom/yg/aprs/MainActivity;Landroid/view/View;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 10

    new-instance v0, Lcom/yg/aprs/MainActivity$Companion;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lcom/yg/aprs/MainActivity$Companion;-><init>(Lkotlin/jvm/internal/DefaultConstructorMarker;)V

    sput-object v0, Lcom/yg/aprs/MainActivity;->Companion:Lcom/yg/aprs/MainActivity$Companion;

    .line 45
    const-string v2, "/!\n/\"\n/#\n/$\n/%\n/&\n/'\n/(\n/)\n/*\n/+\n/,\n/-\n/.\n//\n/0\n/1\n/2\n/3\n/4\n/5\n/6\n/7\n/8\n/9\n/:\n/;\n/<\n/=\n/>\n/?\n/@\n/A\n/B\n/C\n/D\n/E\n/F\n/G\n/H\n/I\n/J\n/K\n/L\n/M\n/N\n/O\n/P\n/Q\n/R\n/S\n/T\n/U\n/V\n/W\n/X\n/Y\n/Z\n/[\n/\\\n/]\n/^\n/_\n/`\n/a\n/b\n/c\n/d\n/e\n/f\n/g\n/h\n/i\n/j\n/k\n/l\n/m\n/n\n/o\n/p\n/q\n/r\n/s\n/t\n/u\n/v\n/w\n/x\n/y\n/z\n/{\n/|\n/}\n/~\n\\!\n\\\"\n\\#\n\\$\n\\%\n\\&\n\\'\n\\(\n\\)\n\\*\n\\+\n\\,\n\\-\n\\.\n\\/\n\\0\n\\1\n\\2\n\\3\n\\4\n\\5\n\\6\n\\7\n\\8\n\\9\n\\:\n\\;\n\\<\n\\=\n\\>\n\\?\n\\@\n\\A\n\\B\n\\C\n\\D\n\\E\n\\F\n\\G\n\\H\n\\I\n\\J\n\\K\n\\L\n\\M\n\\N\n\\O\n\\P\n\\Q\n\\R\n\\S\n\\T\n\\U\n\\V\n\\W\n\\X\n\\Y\n\\Z\n\\[\n\\\\\n\\]\n\\^\n\\_\n\\`\n\\a\n\\b\n\\c\n\\d\n\\e\n\\f\n\\g\n\\h\n\\i\n\\j\n\\k\n\\l\n\\m\n\\n\n\\o\n\\p\n\\q\n\\r\n\\s\n\\t\n\\u\n\\v\n\\w\n\\x\n\\y\n\\z\n\\{\n\\|\n\\}\n\\~"
    const-string v3, "\n"
    invoke-virtual {v2, v3}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v0

    sput-object v0, Lcom/yg/aprs/MainActivity;->SYMBOL_CHARS:[Ljava/lang/String;

    const-string v0, "noam.aprs2.net"

    const-string v1, "oceania.aprs2.net"

    const-string v2, "rotate.aprs2.net"

    const-string v3, "asia.aprs2.net"

    const-string v4, "euro.aprs2.net"

    .line 50
    filled-new-array {v2, v3, v4, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    .line 48
    sput-object v0, Lcom/yg/aprs/MainActivity;->SERVER_HOSTS:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 24
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    const/16 v0, 0x3e9

    .line 54
    iput v0, p0, Lcom/yg/aprs/MainActivity;->permReq:I

    return-void
.end method

.method public static final synthetic access$getBtnToggle$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/Button;
    .locals 0

    .line 24
    iget-object p0, p0, Lcom/yg/aprs/MainActivity;->btnToggle:Landroid/widget/Button;

    return-object p0
.end method

.method public static final synthetic access$getSERVER_HOSTS$cp()[Ljava/lang/String;
    .locals 1

    .line 24
    sget-object v0, Lcom/yg/aprs/MainActivity;->SERVER_HOSTS:[Ljava/lang/String;

    return-object v0
.end method

.method public static final synthetic access$getSYMBOL_CHARS$cp()[Ljava/lang/String;
    .locals 1

    .line 24
    sget-object v0, Lcom/yg/aprs/MainActivity;->SYMBOL_CHARS:[Ljava/lang/String;

    return-object v0
.end method

.method public static final synthetic access$getTvBattery$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;
    .locals 0

    .line 24
    iget-object p0, p0, Lcom/yg/aprs/MainActivity;->tvBattery:Landroid/widget/TextView;

    return-object p0
.end method

.method public static final synthetic access$getTvCell$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;
    .locals 0

    .line 24
    iget-object p0, p0, Lcom/yg/aprs/MainActivity;->tvCell:Landroid/widget/TextView;

    return-object p0
.end method

.method public static final synthetic access$getTvLastSent$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;
    .locals 0

    .line 24
    iget-object p0, p0, Lcom/yg/aprs/MainActivity;->tvLastSent:Landroid/widget/TextView;

    return-object p0
.end method

.method public static final synthetic access$getTvNet$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;
    .locals 0

    .line 24
    iget-object p0, p0, Lcom/yg/aprs/MainActivity;->tvNet:Landroid/widget/TextView;

    return-object p0
.end method

.method public static final synthetic access$getTvPasscode$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;
    .locals 0

    .line 24
    iget-object p0, p0, Lcom/yg/aprs/MainActivity;->tvPasscode:Landroid/widget/TextView;

    return-object p0
.end method

.method public static final synthetic access$getTvPos$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;
    .locals 0

    .line 24
    iget-object p0, p0, Lcom/yg/aprs/MainActivity;->tvPos:Landroid/widget/TextView;

    return-object p0
.end method

.method public static final synthetic access$getTvSource$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;
    .locals 0

    .line 24
    iget-object p0, p0, Lcom/yg/aprs/MainActivity;->tvSource:Landroid/widget/TextView;

    return-object p0
.end method

.method public static final synthetic access$getTvStatus$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;
    .locals 0

    .line 24
    iget-object p0, p0, Lcom/yg/aprs/MainActivity;->tvStatus:Landroid/widget/TextView;

    return-object p0
.end method

.method public static final synthetic access$refreshPasscode(Lcom/yg/aprs/MainActivity;)V
    .locals 0

    .line 24
    invoke-direct {p0}, Lcom/yg/aprs/MainActivity;->refreshPasscode()V

    return-void
.end method

.method private final getRequiredPerms()[Ljava/lang/String;
    .locals 3

    const-string v0, "android.permission.ACCESS_FINE_LOCATION"

    const-string v1, "android.permission.ACCESS_COARSE_LOCATION"

    .line 59
    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    .line 57
    invoke-static {v0}, Lkotlin/collections/CollectionsKt;->mutableListOf([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    .line 61
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x21

    if-lt v1, v2, :cond_0

    const-string v1, "android.permission.POST_NOTIFICATIONS"

    .line 62
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 60
    :cond_0
    check-cast v0, Ljava/util/Collection;

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/String;

    .line 199
    invoke-interface {v0, v1}, Ljava/util/Collection;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Ljava/lang/String;

    return-object v0
.end method

.method private final missingPermission()Z
    .locals 6

    .line 166
    invoke-direct {p0}, Lcom/yg/aprs/MainActivity;->getRequiredPerms()[Ljava/lang/String;

    move-result-object v0

    .line 201
    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v4, v0, v3

    .line 166
    move-object v5, p0

    check-cast v5, Landroid/content/Context;

    invoke-static {v5, v4}, Landroidx/core/app/ActivityCompat;->checkSelfPermission(Landroid/content/Context;Ljava/lang/String;)I

    move-result v4

    const/4 v5, 0x1

    if-eqz v4, :cond_0

    move v4, v5

    goto :goto_1

    :cond_0
    move v4, v2

    :goto_1
    if-eqz v4, :cond_1

    move v2, v5

    goto :goto_2

    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    :goto_2
    return v2
.end method

.method private static final onCreate$lambda$3(Lcom/yg/aprs/MainActivity;Landroid/view/View;)V
    .locals 2

    const-string p1, "this$0"

    invoke-static {p0, p1}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    .line 116
    new-instance p1, Landroid/content/Intent;

    const-string v0, "https://aprs.fi"

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    const-string v1, "android.intent.action.VIEW"

    invoke-direct {p1, v1, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method private static final onCreate$lambda$5(Lcom/yg/aprs/MainActivity;Landroid/view/View;)V
    .locals 2

    const-string p1, "this$0"

    invoke-static {p0, p1}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    .line 129
    sget-object p1, Lcom/yg/aprs/ServiceBus;->INSTANCE:Lcom/yg/aprs/ServiceBus;

    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus;->getState()Lkotlinx/coroutines/flow/StateFlow;

    move-result-object p1

    invoke-interface {p1}, Lkotlinx/coroutines/flow/StateFlow;->getValue()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/yg/aprs/ServiceBus$UiState;

    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getRunning()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 130
    new-instance p1, Landroid/content/Intent;

    move-object v0, p0

    check-cast v0, Landroid/content/Context;

    const-class v1, Lcom/yg/aprs/AprsService;

    invoke-direct {p1, v0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v0, "com.yg.aprs.STOP"

    invoke-virtual {p1, v0}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->stopService(Landroid/content/Intent;)Z

    goto :goto_0

    .line 132
    :cond_0
    invoke-direct {p0}, Lcom/yg/aprs/MainActivity;->saveConfig()V

    .line 133
    invoke-direct {p0}, Lcom/yg/aprs/MainActivity;->missingPermission()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 134
    move-object p1, p0

    check-cast p1, Landroid/app/Activity;

    invoke-direct {p0}, Lcom/yg/aprs/MainActivity;->getRequiredPerms()[Ljava/lang/String;

    move-result-object v0

    iget p0, p0, Lcom/yg/aprs/MainActivity;->permReq:I

    invoke-static {p1, v0, p0}, Landroidx/core/app/ActivityCompat;->requestPermissions(Landroid/app/Activity;[Ljava/lang/String;I)V

    goto :goto_0

    .line 136
    :cond_1
    invoke-direct {p0}, Lcom/yg/aprs/MainActivity;->startAprs()V

    :goto_0
    return-void
.end method

.method private final refreshPasscode()V
    .locals 3

    .line 161
    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->etCall:Landroid/widget/EditText;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    const-string v0, "etCall"

    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v0, v1

    :cond_0
    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    .line 162
    iget-object v2, p0, Lcom/yg/aprs/MainActivity;->tvPasscode:Landroid/widget/TextView;

    if-nez v2, :cond_1

    const-string v2, "tvPasscode"

    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    move-object v1, v2

    :goto_0
    move-object v2, v0

    check-cast v2, Ljava/lang/CharSequence;

    invoke-static {v2}, Lkotlin/text/StringsKt;->isBlank(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_2

    const-string v0, "--"

    goto :goto_1

    :cond_2
    sget-object v2, Lcom/yg/aprs/AprsPasscode;->INSTANCE:Lcom/yg/aprs/AprsPasscode;

    invoke-virtual {v2, v0}, Lcom/yg/aprs/AprsPasscode;->compute(Ljava/lang/String;)I

    move-result v0

    invoke-static {v0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    :goto_1
    check-cast v0, Ljava/lang/CharSequence;

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method private final saveConfig()V
    .locals 5

    .line 169
    sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    move-object v1, p0

    check-cast v1, Landroid/content/Context;

    iget-object v2, p0, Lcom/yg/aprs/MainActivity;->etCall:Landroid/widget/EditText;

    const/4 v3, 0x0

    if-nez v2, :cond_0

    const-string v2, "etCall"

    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v2, v3

    :cond_0
    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/yg/aprs/Prefs;->setCallsign(Landroid/content/Context;Ljava/lang/String;)V

    .line 170
    sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    iget-object v2, p0, Lcom/yg/aprs/MainActivity;->etSsid:Landroid/widget/EditText;

    if-nez v2, :cond_1

    const-string v2, "etSsid"

    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v2, v3

    :cond_1
    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lkotlin/text/StringsKt;->toIntOrNull(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v2

    if-eqz v2, :cond_2

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    goto :goto_0

    :cond_2
    const/16 v2, 0xf

    :goto_0
    invoke-virtual {v0, v1, v2}, Lcom/yg/aprs/Prefs;->setSsid(Landroid/content/Context;I)V

    .line 171
    sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    sget-object v2, Lcom/yg/aprs/MainActivity;->SERVER_HOSTS:[Ljava/lang/String;

    iget-object v4, p0, Lcom/yg/aprs/MainActivity;->spinnerServer:Landroid/widget/Spinner;

    if-nez v4, :cond_3

    const-string v4, "spinnerServer"

    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v4, v3

    :cond_3
    invoke-virtual {v4}, Landroid/widget/Spinner;->getSelectedItemPosition()I

    move-result v4

    aget-object v2, v2, v4

    invoke-virtual {v0, v1, v2}, Lcom/yg/aprs/Prefs;->setHost(Landroid/content/Context;Ljava/lang/String;)V

    .line 172
    sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    iget-object v2, p0, Lcom/yg/aprs/MainActivity;->etPort:Landroid/widget/EditText;

    if-nez v2, :cond_4

    const-string v2, "etPort"

    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v2, v3

    :cond_4
    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lkotlin/text/StringsKt;->toIntOrNull(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v2

    if-eqz v2, :cond_5

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    goto :goto_1

    :cond_5
    const/16 v2, 0x38f4

    :goto_1
    invoke-virtual {v0, v1, v2}, Lcom/yg/aprs/Prefs;->setPort(Landroid/content/Context;I)V

    .line 173
    sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    iget-object v2, p0, Lcom/yg/aprs/MainActivity;->etInterval:Landroid/widget/EditText;

    if-nez v2, :cond_6

    const-string v2, "etInterval"

    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v2, v3

    :cond_6
    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lkotlin/text/StringsKt;->toIntOrNull(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v2

    if-eqz v2, :cond_7

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    goto :goto_2

    :cond_7
    const/16 v2, 0x3c

    :goto_2
    invoke-virtual {v0, v1, v2}, Lcom/yg/aprs/Prefs;->setInterval(Landroid/content/Context;I)V

    .line 174
    sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    sget-object v2, Lcom/yg/aprs/MainActivity;->SYMBOL_CHARS:[Ljava/lang/String;

    iget-object v4, p0, Lcom/yg/aprs/MainActivity;->spinnerSymbol:Landroid/widget/Spinner;

    if-nez v4, :cond_8

    const-string v4, "spinnerSymbol"

    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    goto :goto_3

    :cond_8
    move-object v3, v4

    :goto_3
    invoke-virtual {v3}, Landroid/widget/Spinner;->getSelectedItemPosition()I

    move-result v3

    aget-object v2, v2, v3

    invoke-virtual {v0, v1, v2}, Lcom/yg/aprs/Prefs;->setSymbol(Landroid/content/Context;Ljava/lang/String;)V

        sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;
    iget-object v2, p0, Lcom/yg/aprs/MainActivity;->etComment:Landroid/widget/EditText;
    const-string v4, "etComment"
    if-nez v2, :cond_9
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V
    :cond_9
    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;
    move-result-object v2
    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v0, v1, v2}, Lcom/yg/aprs/Prefs;->setComment(Landroid/content/Context;Ljava/lang/String;)V
return-void
.end method

.method private final startAprs()V
    .locals 3

    .line 178
    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->etCall:Landroid/widget/EditText;

    if-nez v0, :cond_0

    const-string v0, "etCall"

    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    const/4 v0, 0x0

    :cond_0
    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    check-cast v0, Ljava/lang/CharSequence;

    invoke-static {v0}, Lkotlin/text/StringsKt;->trim(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    .line 179
    check-cast v0, Ljava/lang/CharSequence;

    invoke-interface {v0}, Ljava/lang/CharSequence;->length()I

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_1

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    move v0, v1

    :goto_0
    if-eqz v0, :cond_2

    .line 180
    move-object v0, p0

    check-cast v0, Landroid/content/Context;

    const-string v2, "\u8bf7\u5148\u8f93\u5165\u547c\u53f7"

    check-cast v2, Ljava/lang/CharSequence;

    invoke-static {v0, v2, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void

    .line 183
    :cond_2
    new-instance v0, Landroid/content/Intent;

    move-object v1, p0

    check-cast v1, Landroid/content/Context;

    const-class v2, Lcom/yg/aprs/AprsService;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.yg.aprs.START"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 184
    invoke-virtual {p0, v0}, Lcom/yg/aprs/MainActivity;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 9

    .line 66
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    invoke-static {p0}, Lcom/yg/aprs/CrashGuard;->install(Landroid/content/Context;)V

    const p1, 0x7f0c001c

    .line 67
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->setContentView(I)V

    const p1, 0x7f0900b3

    .line 69
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.etCall)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/EditText;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->etCall:Landroid/widget/EditText;

    const p1, 0x7f0900b6

    .line 70
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.etSsid)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/EditText;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->etSsid:Landroid/widget/EditText;

    const p1, 0x7f0901e2

    .line 71
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.tvPasscode)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->tvPasscode:Landroid/widget/TextView;

    const p1, 0x7f0900b4

    .line 72
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.etInterval)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/EditText;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->etInterval:Landroid/widget/EditText;
const p1, 0x7f0901fd

    .line 72
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.etComment)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/EditText;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->etComment:Landroid/widget/EditText;

    const p1, 0x7f090198

    .line 73
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.spinnerServer)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/Spinner;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->spinnerServer:Landroid/widget/Spinner;

    const p1, 0x7f0900b5

    .line 74
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.etPort)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/EditText;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->etPort:Landroid/widget/EditText;

    const p1, 0x7f0901df

    .line 75
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.tvHomepage)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->tvHomepage:Landroid/widget/TextView;

    const p1, 0x7f0901e5

    .line 76
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.tvStatus)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->tvStatus:Landroid/widget/TextView;

    const p1, 0x7f0901e3

    .line 77
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.tvPos)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->tvPos:Landroid/widget/TextView;

    const p1, 0x7f0901e4

    .line 78
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.tvSource)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->tvSource:Landroid/widget/TextView;

    const p1, 0x7f0901de

    .line 79
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.tvCell)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->tvCell:Landroid/widget/TextView;

    const p1, 0x7f0901e1

    .line 80
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.tvNet)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->tvNet:Landroid/widget/TextView;

    const p1, 0x7f0901dd

    .line 81
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.tvBattery)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->tvBattery:Landroid/widget/TextView;

    const p1, 0x7f0901e0

    .line 82
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.tvLastSent)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->tvLastSent:Landroid/widget/TextView;

    const p1, 0x7f090199

    .line 83
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.spinnerSymbol)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/Spinner;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->spinnerSymbol:Landroid/widget/Spinner;

    const p1, 0x7f090062

    .line 84
    invoke-virtual {p0, p1}, Lcom/yg/aprs/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    const-string v0, "findViewById(R.id.btnToggle)"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast p1, Landroid/widget/Button;

    iput-object p1, p0, Lcom/yg/aprs/MainActivity;->btnToggle:Landroid/widget/Button;

    .line 88
    move-object p1, p0

    check-cast p1, Landroid/content/Context;

    const v0, 0x7f030001

    const v1, 0x7f0c006a

    .line 87
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v7

    invoke-virtual {v7, v0}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v7

    new-instance v0, Lcom/yg/aprs/SymbolAdapter;

    invoke-direct {v0, p1, v7}, Lcom/yg/aprs/SymbolAdapter;-><init>(Landroid/content/Context;[Ljava/lang/String;)V

    const-string v2, "createFromResource(\n    \u2026ut.spinner_item\n        )"

    invoke-static {v0, v2}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    const v3, 0x7f0c0069

    .line 90
    nop

    .line 91
    iget-object v4, p0, Lcom/yg/aprs/MainActivity;->spinnerSymbol:Landroid/widget/Spinner;

    const-string v5, "spinnerSymbol"

    const/4 v6, 0x0

    if-nez v4, :cond_0

    invoke-static {v5}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v4, v6

    :cond_0
    check-cast v0, Landroid/widget/SpinnerAdapter;

    invoke-virtual {v4, v0}, Landroid/widget/Spinner;->setAdapter(Landroid/widget/SpinnerAdapter;)V

    .line 92
    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->spinnerSymbol:Landroid/widget/Spinner;

    if-nez v0, :cond_1

    invoke-static {v5}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v0, v6

    :cond_1
    const v4, 0x7f080079

    invoke-virtual {v0, v4}, Landroid/widget/Spinner;->setPopupBackgroundResource(I)V

    .line 93
    sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v0, p1}, Lcom/yg/aprs/Prefs;->getSymbol(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/String;->length()I
    move-result v7
    const/4 v8, 0x1
    if-ne v7, v8, :sym_old_done
    const-string v7, "/"
    invoke-virtual {v7, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    :sym_old_done

    .line 94
    sget-object v7, Lcom/yg/aprs/MainActivity;->SYMBOL_CHARS:[Ljava/lang/String;

    invoke-static {v7, v0}, Lkotlin/collections/ArraysKt;->indexOf([Ljava/lang/Object;Ljava/lang/Object;)I

    move-result v0

    const/4 v7, 0x0

    if-gez v0, :cond_2

    move v0, v7

    .line 95
    :cond_2
    iget-object v8, p0, Lcom/yg/aprs/MainActivity;->spinnerSymbol:Landroid/widget/Spinner;

    if-nez v8, :cond_3

    invoke-static {v5}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v8, v6

    :cond_3
    invoke-virtual {v8, v0}, Landroid/widget/Spinner;->setSelection(I)V

    const/high16 v0, 0x7f030000

    .line 98
    invoke-static {p1, v0, v1}, Landroid/widget/ArrayAdapter;->createFromResource(Landroid/content/Context;II)Landroid/widget/ArrayAdapter;

    move-result-object v0

    invoke-static {v0, v2}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    .line 101
    invoke-virtual {v0, v3}, Landroid/widget/ArrayAdapter;->setDropDownViewResource(I)V

    .line 102
    iget-object v1, p0, Lcom/yg/aprs/MainActivity;->spinnerServer:Landroid/widget/Spinner;

    const-string v2, "spinnerServer"

    if-nez v1, :cond_4

    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v1, v6

    :cond_4
    check-cast v0, Landroid/widget/SpinnerAdapter;

    invoke-virtual {v1, v0}, Landroid/widget/Spinner;->setAdapter(Landroid/widget/SpinnerAdapter;)V

    .line 103
    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->spinnerServer:Landroid/widget/Spinner;

    if-nez v0, :cond_5

    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v0, v6

    :cond_5
    invoke-virtual {v0, v4}, Landroid/widget/Spinner;->setPopupBackgroundResource(I)V

    .line 104
    sget-object v0, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v0, p1}, Lcom/yg/aprs/Prefs;->getHost(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 105
    sget-object v1, Lcom/yg/aprs/MainActivity;->SERVER_HOSTS:[Ljava/lang/String;

    invoke-static {v1, v0}, Lkotlin/collections/ArraysKt;->indexOf([Ljava/lang/Object;Ljava/lang/Object;)I

    move-result v0

    if-gez v0, :cond_6

    goto :goto_0

    :cond_6
    move v7, v0

    .line 106
    :goto_0
    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->spinnerServer:Landroid/widget/Spinner;

    if-nez v0, :cond_7

    invoke-static {v2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v0, v6

    :cond_7
    invoke-virtual {v0, v7}, Landroid/widget/Spinner;->setSelection(I)V

    .line 109
    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->etCall:Landroid/widget/EditText;

    const-string v1, "etCall"

    if-nez v0, :cond_8

    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v0, v6

    :cond_8
    sget-object v2, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v2, p1}, Lcom/yg/aprs/Prefs;->getCallsign(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    check-cast v2, Ljava/lang/CharSequence;

    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 110
    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->etSsid:Landroid/widget/EditText;

    if-nez v0, :cond_9

    const-string v0, "etSsid"

    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v0, v6

    :cond_9
    sget-object v2, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v2, p1}, Lcom/yg/aprs/Prefs;->getSsid(Landroid/content/Context;)I

    move-result v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v2

    check-cast v2, Ljava/lang/CharSequence;

    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 111
    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->etInterval:Landroid/widget/EditText;

    if-nez v0, :cond_a

    const-string v0, "etInterval"

    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v0, v6

    :cond_a
    sget-object v2, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v2, p1}, Lcom/yg/aprs/Prefs;->getInterval(Landroid/content/Context;)I

    move-result v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v2

    check-cast v2, Ljava/lang/CharSequence;

    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V
    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->etComment:Landroid/widget/EditText;
    if-nez v0, :cmt_rnull
    const-string v1, "etComment"
    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V
    :cmt_rnull
    sget-object v2, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;
    invoke-virtual {v2, p1}, Lcom/yg/aprs/Prefs;->getComment(Landroid/content/Context;)Ljava/lang/String;
    move-result-object v2
    check-cast v2, Ljava/lang/CharSequence;
    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 112
    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->etPort:Landroid/widget/EditText;

    if-nez v0, :cond_b

    const-string v0, "etPort"

    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object v0, v6

    :cond_b
    sget-object v2, Lcom/yg/aprs/Prefs;->INSTANCE:Lcom/yg/aprs/Prefs;

    invoke-virtual {v2, p1}, Lcom/yg/aprs/Prefs;->getPort(Landroid/content/Context;)I

    move-result p1

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p1

    check-cast p1, Ljava/lang/CharSequence;

    invoke-virtual {v0, p1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 115
    iget-object p1, p0, Lcom/yg/aprs/MainActivity;->tvHomepage:Landroid/widget/TextView;

    if-nez p1, :cond_c

    const-string p1, "tvHomepage"

    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p1, v6

    :cond_c
    new-instance v0, Lcom/yg/aprs/MainActivity$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0}, Lcom/yg/aprs/MainActivity$$ExternalSyntheticLambda0;-><init>(Lcom/yg/aprs/MainActivity;)V

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 119
    invoke-direct {p0}, Lcom/yg/aprs/MainActivity;->refreshPasscode()V

    .line 122
    iget-object p1, p0, Lcom/yg/aprs/MainActivity;->etCall:Landroid/widget/EditText;

    if-nez p1, :cond_d

    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p1, v6

    :cond_d
    new-instance v0, Lcom/yg/aprs/MainActivity$onCreate$2;

    invoke-direct {v0, p0}, Lcom/yg/aprs/MainActivity$onCreate$2;-><init>(Lcom/yg/aprs/MainActivity;)V

    check-cast v0, Landroid/text/TextWatcher;

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 128
    iget-object p1, p0, Lcom/yg/aprs/MainActivity;->btnToggle:Landroid/widget/Button;

    if-nez p1, :cond_e

    const-string p1, "btnToggle"

    invoke-static {p1}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p1, v6

    :cond_e
    new-instance v0, Lcom/yg/aprs/MainActivity$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0}, Lcom/yg/aprs/MainActivity$$ExternalSyntheticLambda1;-><init>(Lcom/yg/aprs/MainActivity;)V

    invoke-virtual {p1, v0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 142
    move-object p1, p0

    check-cast p1, Landroidx/lifecycle/LifecycleOwner;

    invoke-static {p1}, Landroidx/lifecycle/LifecycleOwnerKt;->getLifecycleScope(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    move-result-object p1

    move-object v0, p1

    check-cast v0, Lkotlinx/coroutines/CoroutineScope;

    const/4 v1, 0x0

    const/4 v2, 0x0

    new-instance p1, Lcom/yg/aprs/MainActivity$onCreate$4;

    invoke-direct {p1, p0, v6}, Lcom/yg/aprs/MainActivity$onCreate$4;-><init>(Lcom/yg/aprs/MainActivity;Lkotlin/coroutines/Continuation;)V

    move-object v3, p1

    check-cast v3, Lkotlin/jvm/functions/Function2;

    const/4 v4, 0x3

    const/4 v5, 0x0

    invoke-static/range {v0 .. v5}, Lkotlinx/coroutines/BuildersKt;->launch$default(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->tvHomepage:Landroid/widget/TextView;

    iget-object v1, p0, Lcom/yg/aprs/MainActivity;->etCall:Landroid/widget/EditText;

    iget-object v2, p0, Lcom/yg/aprs/MainActivity;->etSsid:Landroid/widget/EditText;

    invoke-static {p0, v0, v1, v2}, Lcom/yg/aprs/Ui;->aprsFiLink(Landroid/app/Activity;Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->tvPasscode:Landroid/widget/TextView;

    const-string v1, "APRS \u5bc6\u7801\u5df2\u590d\u5236"

    invoke-static {v0, v1}, Lcom/yg/aprs/Ui;->copyOnClick(Landroid/widget/TextView;Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/yg/aprs/MainActivity;->etCall:Landroid/widget/EditText;

    const-string v1, "BH6RGQ"

    invoke-static {v0, v1}, Lcom/yg/aprs/Ui;->defaultCall(Landroid/widget/TextView;Ljava/lang/String;)V

    return-void
.end method

.method public onCopyrightClick(Landroid/view/View;)V
    .registers 4

    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/yg/aprs/CopyrightActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Lcom/yg/aprs/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 3

    const-string v0, "permissions"

    invoke-static {p2, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    const-string v0, "grantResults"

    invoke-static {p3, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    .line 190
    invoke-super {p0, p1, p2, p3}, Landroidx/appcompat/app/AppCompatActivity;->onRequestPermissionsResult(I[Ljava/lang/String;[I)V

    .line 191
    iget p2, p0, Lcom/yg/aprs/MainActivity;->permReq:I

    if-ne p1, p2, :cond_4

    .line 203
    array-length p1, p3

    const/4 p2, 0x0

    move v0, p2

    :goto_0
    const/4 v1, 0x1

    if-ge v0, p1, :cond_2

    aget v2, p3, v0

    if-nez v2, :cond_0

    move v2, v1

    goto :goto_1

    :cond_0
    move v2, p2

    :goto_1
    if-nez v2, :cond_1

    goto :goto_2

    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_2
    move p2, v1

    :goto_2
    if-eqz p2, :cond_3

    .line 192
    invoke-direct {p0}, Lcom/yg/aprs/MainActivity;->startAprs()V

    goto :goto_3

    .line 193
    :cond_3
    move-object p1, p0

    check-cast p1, Landroid/content/Context;

    const-string p2, "\u7f3a\u5c11\u5b9a\u4f4d/\u901a\u77e5\u6743\u9650\uff0c\u65e0\u6cd5\u540e\u53f0\u4e0a\u62a5"

    check-cast p2, Ljava/lang/CharSequence;

    invoke-static {p1, p2, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    :cond_4
    :goto_3
    return-void
.end method

.method public onSendMessage(Landroid/view/View;)V
    .registers 4

    invoke-static {p0}, Lcom/yg/aprs/MsgUi;->sendFromFields(Landroid/app/Activity;)V

    return-void
.end method

.method public onOpenMap(Landroid/view/View;)V
    .registers 4

    invoke-static {p0}, Lcom/yg/aprs/MapActivity;->show(Landroid/app/Activity;)V

    return-void
.end method

.method public onRefreshInbox(Landroid/view/View;)V
    .registers 4

    invoke-static {p0}, Lcom/yg/aprs/MsgUi;->showInbox(Landroid/app/Activity;)V

    return-void
.end method
