.class final Lcom/yg/aprs/AprsService$onStartCommand$1;
.super Lkotlin/jvm/internal/Lambda;
.source "AprsService.kt"

# interfaces
.implements Lkotlin/jvm/functions/Function1;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/yg/aprs/AprsService;->onStartCommand(Landroid/content/Intent;II)I
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lkotlin/jvm/internal/Lambda;",
        "Lkotlin/jvm/functions/Function1<",
        "Lcom/yg/aprs/ServiceBus$UiState;",
        "Lcom/yg/aprs/ServiceBus$UiState;",
        ">;"
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
    d1 = {
        "\u0000\u0008\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001*\u00020\u0001H\n\u00a2\u0006\u0002\u0008\u0002"
    }
    d2 = {
        "<anonymous>",
        "Lcom/yg/aprs/ServiceBus$UiState;",
        "invoke"
    }
    k = 0x3
    mv = {
        0x1,
        0x8,
        0x0
    }
    xi = 0x30
.end annotation


# static fields
.field public static final INSTANCE:Lcom/yg/aprs/AprsService$onStartCommand$1;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, Lcom/yg/aprs/AprsService$onStartCommand$1;

    invoke-direct {v0}, Lcom/yg/aprs/AprsService$onStartCommand$1;-><init>()V

    sput-object v0, Lcom/yg/aprs/AprsService$onStartCommand$1;->INSTANCE:Lcom/yg/aprs/AprsService$onStartCommand$1;

    return-void
.end method

.method constructor <init>()V
    .locals 1

    const/4 v0, 0x1

    invoke-direct {p0, v0}, Lkotlin/jvm/internal/Lambda;-><init>(I)V

    return-void
.end method


# virtual methods
.method public final invoke(Lcom/yg/aprs/ServiceBus$UiState;)Lcom/yg/aprs/ServiceBus$UiState;
    .locals 17

    const-string v0, "$this$update"

    move-object/from16 v1, p1

    invoke-static {v1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    const/4 v2, 0x0

    const-string v3, "\u8bf7\u5148\u8f93\u5165\u547c\u53f7"

    const/4 v4, 0x0

    const/4 v5, 0x0

    const-wide/16 v6, 0x0

    const-wide/16 v8, 0x0

    const/4 v10, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/16 v15, 0x7fd

    const/16 v16, 0x0

    .line 50
    invoke-static/range {v1 .. v16}, Lcom/yg/aprs/ServiceBus$UiState;->copy$default(Lcom/yg/aprs/ServiceBus$UiState;ZLjava/lang/String;ILjava/lang/String;DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/Object;)Lcom/yg/aprs/ServiceBus$UiState;

    move-result-object v0

    return-object v0
.end method

.method public bridge synthetic invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    .line 50
    check-cast p1, Lcom/yg/aprs/ServiceBus$UiState;

    invoke-virtual {p0, p1}, Lcom/yg/aprs/AprsService$onStartCommand$1;->invoke(Lcom/yg/aprs/ServiceBus$UiState;)Lcom/yg/aprs/ServiceBus$UiState;

    move-result-object p1

    return-object p1
.end method
