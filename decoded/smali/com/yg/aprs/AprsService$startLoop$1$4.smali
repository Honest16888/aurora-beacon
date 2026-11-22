.class final Lcom/yg/aprs/AprsService$startLoop$1$4;
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

.field final synthetic $loc:Landroid/location/Location;

.field final synthetic $net:Ljava/lang/String;

.field final synthetic $now:Ljava/lang/String;

.field final synthetic $packet:Ljava/lang/String;

.field final synthetic $source:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Landroid/location/Location;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$now:Ljava/lang/String;

    iput-object p2, p0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$loc:Landroid/location/Location;

    iput-object p3, p0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$source:Ljava/lang/String;

    iput-object p4, p0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$cell:Ljava/lang/String;

    iput-object p5, p0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$net:Ljava/lang/String;

    iput-object p6, p0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$battery:Ljava/lang/String;

    iput-object p7, p0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$packet:Ljava/lang/String;

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

    const-string v4, "\u5df2\u4e0a\u62a5"

    const/4 v5, 0x0

    .line 154
    iget-object v6, v0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$now:Ljava/lang/String;

    const-string v1, "now"

    invoke-static {v6, v1}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    .line 155
    iget-object v1, v0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$loc:Landroid/location/Location;

    invoke-virtual {v1}, Landroid/location/Location;->getLatitude()D

    move-result-wide v7

    .line 156
    iget-object v1, v0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$loc:Landroid/location/Location;

    invoke-virtual {v1}, Landroid/location/Location;->getLongitude()D

    move-result-wide v9

    .line 157
    iget-object v11, v0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$source:Ljava/lang/String;

    .line 158
    iget-object v12, v0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$cell:Ljava/lang/String;

    .line 159
    iget-object v13, v0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$net:Ljava/lang/String;

    .line 160
    iget-object v14, v0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$battery:Ljava/lang/String;

    .line 161
    iget-object v15, v0, Lcom/yg/aprs/AprsService$startLoop$1$4;->$packet:Ljava/lang/String;

    const/16 v16, 0x5

    const/16 v17, 0x0

    .line 152
    invoke-static/range {v2 .. v17}, Lcom/yg/aprs/ServiceBus$UiState;->copy$default(Lcom/yg/aprs/ServiceBus$UiState;ZLjava/lang/String;ILjava/lang/String;DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/Object;)Lcom/yg/aprs/ServiceBus$UiState;

    move-result-object v1

    return-object v1
.end method

.method public bridge synthetic invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    .line 151
    check-cast p1, Lcom/yg/aprs/ServiceBus$UiState;

    invoke-virtual {p0, p1}, Lcom/yg/aprs/AprsService$startLoop$1$4;->invoke(Lcom/yg/aprs/ServiceBus$UiState;)Lcom/yg/aprs/ServiceBus$UiState;

    move-result-object p1

    return-object p1
.end method
