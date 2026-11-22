.class final Lcom/yg/aprs/AprsService$startLoop$1$2;
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
.field final synthetic $interval:I


# direct methods
.method constructor <init>(I)V
    .locals 0

    iput p1, p0, Lcom/yg/aprs/AprsService$startLoop$1$2;->$interval:I

    const/4 p1, 0x1

    invoke-direct {p0, p1}, Lkotlin/jvm/internal/Lambda;-><init>(I)V

    return-void
.end method


# virtual methods
.method public final invoke(Lcom/yg/aprs/ServiceBus$UiState;)Lcom/yg/aprs/ServiceBus$UiState;
    .locals 17

    const-string v0, "$this$update"

    move-object/from16 v1, p1

    invoke-static {v1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    const/4 v2, 0x0

    move-object/from16 v0, p0

    .line 132
    iget v3, v0, Lcom/yg/aprs/AprsService$startLoop$1$2;->$interval:I

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "\u8fde\u63a5\u5931\u8d25\uff0c"

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "s \u540e\u91cd\u8bd5"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

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

    invoke-static/range {v1 .. v16}, Lcom/yg/aprs/ServiceBus$UiState;->copy$default(Lcom/yg/aprs/ServiceBus$UiState;ZLjava/lang/String;ILjava/lang/String;DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/Object;)Lcom/yg/aprs/ServiceBus$UiState;

    move-result-object v1

    return-object v1
.end method

.method public bridge synthetic invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    .line 132
    check-cast p1, Lcom/yg/aprs/ServiceBus$UiState;

    invoke-virtual {p0, p1}, Lcom/yg/aprs/AprsService$startLoop$1$2;->invoke(Lcom/yg/aprs/ServiceBus$UiState;)Lcom/yg/aprs/ServiceBus$UiState;

    move-result-object p1

    return-object p1
.end method
