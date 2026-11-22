.class final Lcom/yg/aprs/MainActivity$onCreate$4$1;
.super Ljava/lang/Object;
.source "MainActivity.kt"

# interfaces
.implements Lkotlinx/coroutines/flow/FlowCollector;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/yg/aprs/MainActivity$onCreate$4;->invokeSuspend(Ljava/lang/Object;)Ljava/lang/Object;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "<T:",
        "Ljava/lang/Object;",
        ">",
        "Ljava/lang/Object;",
        "Lkotlinx/coroutines/flow/FlowCollector;"
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
    d1 = {
        "\u0000\u0010\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0008\u0002\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u008a@\u00a2\u0006\u0004\u0008\u0004\u0010\u0005"
    }
    d2 = {
        "<anonymous>",
        "",
        "st",
        "Lcom/yg/aprs/ServiceBus$UiState;",
        "emit",
        "(Lcom/yg/aprs/ServiceBus$UiState;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;"
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
.field final synthetic this$0:Lcom/yg/aprs/MainActivity;


# direct methods
.method constructor <init>(Lcom/yg/aprs/MainActivity;)V
    .locals 0

    iput-object p1, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final emit(Lcom/yg/aprs/ServiceBus$UiState;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/yg/aprs/ServiceBus$UiState;",
            "Lkotlin/coroutines/Continuation<",
            "-",
            "Lkotlin/Unit;",
            ">;)",
            "Ljava/lang/Object;"
        }
    .end annotation

    .line 144
    iget-object p2, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-static {p2}, Lcom/yg/aprs/MainActivity;->access$getTvStatus$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;

    move-result-object p2

    const/4 v0, 0x0

    if-nez p2, :cond_0

    const-string p2, "tvStatus"

    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p2, v0

    :cond_0
    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getStatus()Ljava/lang/String;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    invoke-virtual {p2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 145
    iget-object p2, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-static {p2}, Lcom/yg/aprs/MainActivity;->access$getTvLastSent$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;

    move-result-object p2

    if-nez p2, :cond_1

    const-string p2, "tvLastSent"

    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p2, v0

    :cond_1
    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getLastSentTime()Ljava/lang/String;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    invoke-virtual {p2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 146
    iget-object p2, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-static {p2}, Lcom/yg/aprs/MainActivity;->access$getTvSource$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;

    move-result-object p2

    if-nez p2, :cond_2

    const-string p2, "tvSource"

    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p2, v0

    :cond_2
    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getSource()Ljava/lang/String;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    invoke-virtual {p2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 147
    iget-object p2, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-static {p2}, Lcom/yg/aprs/MainActivity;->access$getTvCell$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;

    move-result-object p2

    if-nez p2, :cond_3

    const-string p2, "tvCell"

    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p2, v0

    :cond_3
    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getCell()Ljava/lang/String;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    invoke-virtual {p2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 148
    iget-object p2, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-static {p2}, Lcom/yg/aprs/MainActivity;->access$getTvNet$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;

    move-result-object p2

    if-nez p2, :cond_4

    const-string p2, "tvNet"

    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p2, v0

    :cond_4
    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getNet()Ljava/lang/String;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    invoke-virtual {p2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 149
    iget-object p2, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-static {p2}, Lcom/yg/aprs/MainActivity;->access$getTvBattery$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;

    move-result-object p2

    if-nez p2, :cond_5

    const-string p2, "tvBattery"

    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p2, v0

    :cond_5
    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getBattery()Ljava/lang/String;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    invoke-virtual {p2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 150
    iget-object p2, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-static {p2}, Lcom/yg/aprs/MainActivity;->access$getTvPos$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;

    move-result-object p2

    if-nez p2, :cond_6

    const-string p2, "tvPos"

    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p2, v0

    :cond_6
    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getLatitude()D

    move-result-wide v1

    const-wide/16 v3, 0x0

    cmpg-double v1, v1, v3

    const/4 v2, 0x1

    const/4 v5, 0x0

    if-nez v1, :cond_7

    move v1, v2

    goto :goto_0

    :cond_7
    move v1, v5

    :goto_0
    if-eqz v1, :cond_a

    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getLongitude()D

    move-result-wide v6

    cmpg-double v1, v6, v3

    if-nez v1, :cond_8

    move v1, v2

    goto :goto_1

    :cond_8
    move v1, v5

    :goto_1
    if-nez v1, :cond_9

    goto :goto_2

    :cond_9
    const-string v1, "--"

    .line 152
    check-cast v1, Ljava/lang/CharSequence;

    goto :goto_3

    .line 151
    :cond_a
    :goto_2
    sget-object v1, Lkotlin/jvm/internal/StringCompanionObject;->INSTANCE:Lkotlin/jvm/internal/StringCompanionObject;

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v1

    const/4 v3, 0x2

    new-array v4, v3, [Ljava/lang/Object;

    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getLatitude()D

    move-result-wide v6

    invoke-static {v6, v7}, Lkotlin/coroutines/jvm/internal/Boxing;->boxDouble(D)Ljava/lang/Double;

    move-result-object v6

    aput-object v6, v4, v5

    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getLongitude()D

    move-result-wide v5

    invoke-static {v5, v6}, Lkotlin/coroutines/jvm/internal/Boxing;->boxDouble(D)Ljava/lang/Double;

    move-result-object v5

    aput-object v5, v4, v2

    invoke-static {v4, v3}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object v2

    const-string v3, "%.5f, %.5f"

    invoke-static {v1, v3, v2}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "format(locale, format, *args)"

    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->checkNotNullExpressionValue(Ljava/lang/Object;Ljava/lang/String;)V

    check-cast v1, Ljava/lang/CharSequence;

    .line 150
    :goto_3
    invoke-virtual {p2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 153
    iget-object p2, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-static {p2}, Lcom/yg/aprs/MainActivity;->access$getBtnToggle$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/Button;

    move-result-object p2

    const-string v1, "btnToggle"

    if-nez p2, :cond_b

    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p2, v0

    :cond_b
    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getRunning()Z

    move-result v2

    if-eqz v2, :cond_c

    const-string v2, "\u505c\u6b62\u4e0a\u62a5"

    goto :goto_4

    :cond_c
    const-string v2, "\u542f\u52a8\u4e0a\u62a5"

    :goto_4
    check-cast v2, Ljava/lang/CharSequence;

    invoke-virtual {p2, v2}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 154
    iget-object p2, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-static {p2}, Lcom/yg/aprs/MainActivity;->access$getBtnToggle$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/Button;

    move-result-object p2

    if-nez p2, :cond_d

    invoke-static {v1}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    move-object p2, v0

    :cond_d
    iget-object v1, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getRunning()Z

    move-result v2

    if-eqz v2, :cond_e

    const v2, 0x7f06002a

    goto :goto_5

    :cond_e
    const v2, 0x7f060029

    :goto_5
    invoke-virtual {v1, v2}, Lcom/yg/aprs/MainActivity;->getColor(I)I

    move-result v1

    invoke-virtual {p2, v1}, Landroid/widget/Button;->setBackgroundColor(I)V

    .line 155
    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getPasscode()I

    move-result p2

    if-eqz p2, :cond_10

    iget-object p2, p0, Lcom/yg/aprs/MainActivity$onCreate$4$1;->this$0:Lcom/yg/aprs/MainActivity;

    invoke-static {p2}, Lcom/yg/aprs/MainActivity;->access$getTvPasscode$p(Lcom/yg/aprs/MainActivity;)Landroid/widget/TextView;

    move-result-object p2

    if-nez p2, :cond_f

    const-string p2, "tvPasscode"

    invoke-static {p2}, Lkotlin/jvm/internal/Intrinsics;->throwUninitializedPropertyAccessException(Ljava/lang/String;)V

    goto :goto_6

    :cond_f
    move-object v0, p2

    :goto_6
    invoke-virtual {p1}, Lcom/yg/aprs/ServiceBus$UiState;->getPasscode()I

    move-result p1

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p1

    check-cast p1, Ljava/lang/CharSequence;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 156
    :cond_10
    sget-object p1, Lkotlin/Unit;->INSTANCE:Lkotlin/Unit;

    return-object p1
.end method

.method public bridge synthetic emit(Ljava/lang/Object;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;
    .locals 0

    .line 143
    check-cast p1, Lcom/yg/aprs/ServiceBus$UiState;

    invoke-virtual {p0, p1, p2}, Lcom/yg/aprs/MainActivity$onCreate$4$1;->emit(Lcom/yg/aprs/ServiceBus$UiState;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;

    move-result-object p1

    return-object p1
.end method
