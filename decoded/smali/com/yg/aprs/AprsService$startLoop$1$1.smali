.class final Lcom/yg/aprs/AprsService$startLoop$1$1;
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
.field final synthetic $host:Ljava/lang/String;

.field final synthetic $passcode:I

.field final synthetic $port:I


# direct methods
.method constructor <init>(Ljava/lang/String;II)V
    .locals 0

    iput-object p1, p0, Lcom/yg/aprs/AprsService$startLoop$1$1;->$host:Ljava/lang/String;

    iput p2, p0, Lcom/yg/aprs/AprsService$startLoop$1$1;->$port:I

    iput p3, p0, Lcom/yg/aprs/AprsService$startLoop$1$1;->$passcode:I

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

    .line 125
    iget-object v1, v0, Lcom/yg/aprs/AprsService$startLoop$1$1;->$host:Ljava/lang/String;

    iget v3, v0, Lcom/yg/aprs/AprsService$startLoop$1$1;->$port:I

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "\u8fde\u63a5 "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, ":"

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, " ..."

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const/4 v3, 0x1

    iget v5, v0, Lcom/yg/aprs/AprsService$startLoop$1$1;->$passcode:I

    const/4 v6, 0x0

    const-wide/16 v7, 0x0

    const-wide/16 v9, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    const/16 v16, 0x7f8

    const/16 v17, 0x0

    invoke-static/range {v2 .. v17}, Lcom/yg/aprs/ServiceBus$UiState;->copy$default(Lcom/yg/aprs/ServiceBus$UiState;ZLjava/lang/String;ILjava/lang/String;DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/Object;)Lcom/yg/aprs/ServiceBus$UiState;

    move-result-object v1

    return-object v1
.end method

.method public bridge synthetic invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    .line 125
    check-cast p1, Lcom/yg/aprs/ServiceBus$UiState;

    invoke-virtual {p0, p1}, Lcom/yg/aprs/AprsService$startLoop$1$1;->invoke(Lcom/yg/aprs/ServiceBus$UiState;)Lcom/yg/aprs/ServiceBus$UiState;

    move-result-object p1

    return-object p1
.end method
