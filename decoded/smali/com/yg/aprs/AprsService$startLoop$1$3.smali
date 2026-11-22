.class final Lcom/yg/aprs/AprsService$startLoop$1$3;
.super Lkotlin/jvm/internal/Lambda;
.source "AprsService.kt"

# interfaces
.implements Lkotlin/jvm/functions/Function1;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/yg/aprs/AprsService;->startLoop()V
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


# instance fields
.field final synthetic $battery:Ljava/lang/String;

.field final synthetic $cell:Ljava/lang/String;

.field final synthetic $net:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/yg/aprs/AprsService$startLoop$1$3;->$cell:Ljava/lang/String;

    iput-object p2, p0, Lcom/yg/aprs/AprsService$startLoop$1$3;->$net:Ljava/lang/String;

    iput-object p3, p0, Lcom/yg/aprs/AprsService$startLoop$1$3;->$battery:Ljava/lang/String;

    const/4 p1, 0x1

    invoke-direct {p0, p1}, Lkotlin/jvm/internal/Lambda;-><init>(I)V

    return-void
.end method


# virtual methods
.method public final invoke(Lcom/yg/aprs/ServiceBus$UiState;)Lcom/yg/aprs/ServiceBus$UiState;
    .locals 18

    move-object/from16 v0, p0

    const-string v1, "$this$update"

    move-object/from16 v2, p1

    invoke-static {v2, v1}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    const/4 v3, 0x0

    const-string v4, "\u5b9a\u4f4d\u5931\u8d25\uff0c\u7b49\u5f85\u91cd\u8bd5"

    const/4 v5, 0x0

    const/4 v6, 0x0

    const-wide/16 v7, 0x0

    const-wide/16 v9, 0x0

    const/4 v11, 0x0

    .line 144
    iget-object v12, v0, Lcom/yg/aprs/AprsService$startLoop$1$3;->$cell:Ljava/lang/String;

    iget-object v13, v0, Lcom/yg/aprs/AprsService$startLoop$1$3;->$net:Ljava/lang/String;

    iget-object v14, v0, Lcom/yg/aprs/AprsService$startLoop$1$3;->$battery:Ljava/lang/String;

    const/4 v15, 0x0

    const/16 v16, 0x47d

    const/16 v17, 0x0

    invoke-static/range {v2 .. v17}, Lcom/yg/aprs/ServiceBus$UiState;->copy$default(Lcom/yg/aprs/ServiceBus$UiState;ZLjava/lang/String;ILjava/lang/String;DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/Object;)Lcom/yg/aprs/ServiceBus$UiState;

    move-result-object v1

    return-object v1
.end method

.method public bridge synthetic invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    .line 144
    check-cast p1, Lcom/yg/aprs/ServiceBus$UiState;

    invoke-virtual {p0, p1}, Lcom/yg/aprs/AprsService$startLoop$1$3;->invoke(Lcom/yg/aprs/ServiceBus$UiState;)Lcom/yg/aprs/ServiceBus$UiState;

    move-result-object p1

    return-object p1
.end method
