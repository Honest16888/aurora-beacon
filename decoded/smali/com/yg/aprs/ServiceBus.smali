.class public final Lcom/yg/aprs/ServiceBus;
.super Ljava/lang/Object;
.source "ServiceBus.kt"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/yg/aprs/ServiceBus$UiState;
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
    d1 = {
        "\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0008\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0008\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0008\u0002\u0008\u00c6\u0002\u0018\u00002\u00020\u0001:\u0001\u000fB\u0007\u0008\u0002\u00a2\u0006\u0002\u0010\u0002J\u001f\u0010\n\u001a\u00020\u000b2\u0017\u0010\u000c\u001a\u0013\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\r\u00a2\u0006\u0002\u0008\u000eR\u0014\u0010\u0003\u001a\u0008\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\u0006\u001a\u0008\u0012\u0004\u0012\u00020\u00050\u0007\u00a2\u0006\u0008\n\u0000\u001a\u0004\u0008\u0008\u0010\t\u00a8\u0006\u0010"
    }
    d2 = {
        "Lcom/yg/aprs/ServiceBus;",
        "",
        "()V",
        "_state",
        "Lkotlinx/coroutines/flow/MutableStateFlow;",
        "Lcom/yg/aprs/ServiceBus$UiState;",
        "state",
        "Lkotlinx/coroutines/flow/StateFlow;",
        "getState",
        "()Lkotlinx/coroutines/flow/StateFlow;",
        "update",
        "",
        "block",
        "Lkotlin/Function1;",
        "Lkotlin/ExtensionFunctionType;",
        "UiState",
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
.field public static final INSTANCE:Lcom/yg/aprs/ServiceBus;

.field private static final _state:Lkotlinx/coroutines/flow/MutableStateFlow;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lkotlinx/coroutines/flow/MutableStateFlow<",
            "Lcom/yg/aprs/ServiceBus$UiState;",
            ">;"
        }
    .end annotation
.end field

.field private static final state:Lkotlinx/coroutines/flow/StateFlow;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lkotlinx/coroutines/flow/StateFlow<",
            "Lcom/yg/aprs/ServiceBus$UiState;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 17

    new-instance v0, Lcom/yg/aprs/ServiceBus;

    invoke-direct {v0}, Lcom/yg/aprs/ServiceBus;-><init>()V

    sput-object v0, Lcom/yg/aprs/ServiceBus;->INSTANCE:Lcom/yg/aprs/ServiceBus;

    .line 24
    new-instance v0, Lcom/yg/aprs/ServiceBus$UiState;

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const-wide/16 v6, 0x0

    const-wide/16 v8, 0x0

    const/4 v10, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/16 v15, 0x7ff

    const/16 v16, 0x0

    move-object v1, v0

    invoke-direct/range {v1 .. v16}, Lcom/yg/aprs/ServiceBus$UiState;-><init>(ZLjava/lang/String;ILjava/lang/String;DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    invoke-static {v0}, Lkotlinx/coroutines/flow/StateFlowKt;->MutableStateFlow(Ljava/lang/Object;)Lkotlinx/coroutines/flow/MutableStateFlow;

    move-result-object v0

    sput-object v0, Lcom/yg/aprs/ServiceBus;->_state:Lkotlinx/coroutines/flow/MutableStateFlow;

    .line 25
    invoke-static {v0}, Lkotlinx/coroutines/flow/FlowKt;->asStateFlow(Lkotlinx/coroutines/flow/MutableStateFlow;)Lkotlinx/coroutines/flow/StateFlow;

    move-result-object v0

    sput-object v0, Lcom/yg/aprs/ServiceBus;->state:Lkotlinx/coroutines/flow/StateFlow;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final getState()Lkotlinx/coroutines/flow/StateFlow;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Lkotlinx/coroutines/flow/StateFlow<",
            "Lcom/yg/aprs/ServiceBus$UiState;",
            ">;"
        }
    .end annotation

    .line 25
    sget-object v0, Lcom/yg/aprs/ServiceBus;->state:Lkotlinx/coroutines/flow/StateFlow;

    return-object v0
.end method

.method public final update(Lkotlin/jvm/functions/Function1;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lkotlin/jvm/functions/Function1<",
            "-",
            "Lcom/yg/aprs/ServiceBus$UiState;",
            "Lcom/yg/aprs/ServiceBus$UiState;",
            ">;)V"
        }
    .end annotation

    const-string v0, "block"

    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullParameter(Ljava/lang/Object;Ljava/lang/String;)V

    .line 28
    sget-object v0, Lcom/yg/aprs/ServiceBus;->_state:Lkotlinx/coroutines/flow/MutableStateFlow;

    invoke-interface {v0}, Lkotlinx/coroutines/flow/MutableStateFlow;->getValue()Ljava/lang/Object;

    move-result-object v1

    invoke-interface {p1, v1}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    invoke-interface {v0, p1}, Lkotlinx/coroutines/flow/MutableStateFlow;->setValue(Ljava/lang/Object;)V

    return-void
.end method
