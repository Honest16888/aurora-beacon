# 工程结构

## 为什么是"双 dex"

基线 APK 是编译产物，只有 `classes.dex`。直接改 smali 能做，但每写错一个方法名或寄存器，
就要等到真机运行才炸（本项目历史上三次闪退有两次是这么来的）。所以本工程采用混合策略：

```
┌─────────────────────────── APK ───────────────────────────┐
│  classes.dex        ← apktool 由 decoded/smali 组装        │
│                        · MainActivity / AprsService / …    │
│                        · 只做少量、机械的 smali 改动         │
│  classes2.dex       ← javac + d8 由 java/src 编译          │
│                        · SymbolAdapter / Ui / CrashGuard    │
│                        · 复杂逻辑，API 由编译器核对          │
│  resources.arsc     ← apktool/aapt2 由 decoded/res 生成     │
└────────────────────────────────────────────────────────────┘
```

Android 5.0+ 原生支持多 dex（APK 内 `classes*.dex` 会被一起加载），因此不需要 multidex 库。
跨 dex 相互引用没有问题：`classes.dex` 里的 `MainActivity` 直接 `invoke-static` 调
`classes2.dex` 里的 `Ui.aprsFiLink(...)`。

**判断标准**：能写 Java 就写 Java，smali 只用于"改几个字符串 / 换一个调用 / 塞一段桩"。

## 目录

| 路径 | 说明 |
|---|---|
| `decoded/AndroidManifest.xml` | 权限、Activity、Service、启动项 |
| `decoded/apktool.yml` | 版本号（`versionCode` / `versionName`）、sdk 信息 |
| `decoded/smali/com/yg/aprs/` | 应用主体逻辑（39 个类 + 内部类） |
| `decoded/res/layout/activity_main.xml` | 唯一主界面布局（玻璃卡片、磁贴） |
| `decoded/res/drawable-nodpi/sym_*.png` | 188 个 APRS 符号（64×64） |
| `decoded/res/values/arrays.xml` | `symbol_labels`（188 条）、`symbol_icons`（188 条 drawable 引用）、服务器列表 |
| `decoded/res/values/styles.xml` | `Theme.YGAPRS`（深色极光 + 无 ActionBar） |
| `java/src/com/yg/aprs/` | Java 模块源码（编译进 `classes2.dex`） |
| `docs/` | 构建、结构、协议、FAQ |

## 关键类

### `classes.dex`（smali）

| 类 | 职责 |
|---|---|
| `MainActivity` | 唯一界面：读设置 → 填控件 → 组装适配器 → 启停服务 → 展示状态 |
| `MainActivity$onCreate$N…` | 协程回调（状态广播 → 更新磁贴） |
| `AprsService` | 前台服务：`startLoop` 定时循环、取位置、拼报文、调 `AprsClient` |
| `AprsClient` | APRS-IS TCP 客户端：连接、登录行、发送报文 |
| `AprsPasscode` | 呼号 → APRS 校验码 |
| `LocationHelper` | 定位与坐标格式化（`aprsLat` / `aprsLon`）、基站辅助定位 |
| `SystemInfoHelper` | 网络制式、电量电压、基站小区等状态字符串 |
| `Prefs` | `SharedPreferences` 封装（`yg_aprs_prefs`） |

### `classes2.dex`（Java）

| 类 | 职责 |
|---|---|
| `SymbolAdapter` | 188 符号的 Spinner 适配器；行由代码构建，全链路 try-catch 降级 |
| `CopyrightActivity` | 版权页（内容全代码构建，不依赖资源 id） |
| `Ui` | 小功能集合：复制密码、按呼号打开 aprs.fi、空呼号补默认值 |
| `CrashGuard` | 未捕获异常 → `crash.txt` |

## 启动流程

```
Application
└─ MainActivity.onCreate
   ├─ CrashGuard.install(this)            // 先装崩溃日志
   ├─ setContentView(activity_main)
   ├─ findViewById × 17                  // 全部控件（null 会立刻暴露）
   ├─ SymbolAdapter(Context, labels[188])// 图标下拉
   ├─ Spinner.setAdapter / setSelection   // 按已存符号定位
   ├─ 服务器 Spinner（ArrayAdapter）
   ├─ Prefs → 各输入框
   ├─ 状态广播协程（onCreate$4）           // 服务状态 → 磁贴
   └─ Ui.aprsFiLink / Ui.copyOnClick / Ui.defaultCall   // 交互增强
```

## 上报流程

```
[启动上报] → MainActivity.savePrefs()（呼号/SSID/间隔/符号/备注/服务器/端口）
          → startForegroundService(AprsService, ACTION_START)
AprsService.onCreate → 通知渠道 + WakeLock
AprsService.startLoop → repeat(interval):
      LocationHelper.lastKnown()            // GPS 优先，退化到网络/基站
      SystemInfoHelper.networkInfo()        // "WiFi" 或 "运营商 4G"
      buildPacket(call, loc, table+code, comment)
      AprsClient.send(packet)               // user/pass 登录后逐行发送
      broadcast(Status(...))                // 回填界面磁贴
```

报文拼装（`AprsService.buildPacket`）：

```
<call>-<ssid> >APRS,TCPIP*:! <lat> <table> <lon> <code> <comment>
```

## 资源体系

### 188 个符号

- 源图：aprs.fi symbol set（矢量 → 64px 精灵表，16 列 × 6 行，96 格）
- 索引：`格位 = ASCII码 - 0x21`（`!`=0 … `~`=93），主表在 artboard 0，副表在 artboard 1
- 命名：`sym_<表hex><码hex>.png`，如 `sym_2f3e` = `/` + `>`
- 引用：`res/values/arrays.xml` 的 `symbol_icons`（188 条 `@drawable/...`），
  运行时 `obtainTypedArray` + `getResourceId(i, 0)`，与 `symbol_labels` 一一对应
- 布局/数组都通过名字解析（`getIdentifier`），所以新增资源**不需要**改 `public.xml`

### 玻璃拟态

| 资源 | 作用 |
|---|---|
| `drawable/bg_aurora.xml` | 315° 三段线性渐变（深蓝→墨绿→夜黑） |
| `drawable/glow_teal.xml` / `glow_violet.xml` | 径向光斑（圆形，边缘衰减到全透明） |
| `drawable/glass_card.xml` | 卡片：22dp 圆角 + 白 16%→5% 渐变 + 1dp 高光描边 |
| `drawable/glass_tile.xml` | 磁贴：16dp 圆角，更淡的填充 |
| `drawable/glass_input.xml` | 输入框：14dp 圆角 + 细描边 |
| `drawable/glass_pill.xml` | 胶囊标签（密码、状态） |
| `drawable/btn_pill.xml` | 主按钮：青→蓝→紫渐变 + 白色 ripple |

为什么不真模糊：`RenderEffect` 要 API 31+，而 `minSdk` 是 26。用"渐变底 + 半透明白 + 高光边"
近似磨砂，全版本一致。

## 关键实现决策（以及踩过的坑）

1. **参数寄存器不可覆盖**
   `.registers N` + P 个参数时 `p0 = v(N-P)`。曾经写
   `const-class v1` 覆盖了 `p0`（`this`），编译通过、类加载时 `VerifyError` → 一打开就闪退。
2. **`getChildAt` 属于 `ViewGroup`**
   错写成 `Landroid/view/View;->getChildAt` 时 smali 不报错，运行时 `NoSuchMethodError`，
   表现为点开下拉就闪退。现改为代码构建行，彻底不需要 `getChildAt`。
3. **`ArrayAdapter` 与自定义 `SpinnerAdapter` 不能混用**
   换成自定义适配器后，原代码里的 `setDropDownViewResource(...)` 必须 `nop` 掉，
   否则对 `SymbolAdapter` 调用 `ArrayAdapter` 的方法 → `NoSuchMethodError`。
4. **`ACCESS_NETWORK_STATE` 是 `getActiveNetwork()` 的前提**
   缺权限 → `SecurityException` → 被 catch 吞掉 → 状态永远显示"未知"。
5. **`getDataNetworkType()` 需要 `READ_PHONE_STATE`**
   没有运行时授予就抛异常。必须把这次调用单独 try-catch，否则连运营商名一起丢。
6. **apktool 增量构建会复用 `decoded/build`**
   改完 smali 不生效时，先删缓存目录。

## 想加功能改哪里

| 需求 | 落点 |
|---|---|
| 新按钮 / 新控件 | `res/layout/activity_main.xml` + `MainActivity` 里 `findViewById` |
| 新交互逻辑（复制、跳转、提示） | `java/src/.../Ui.java`，smali 里一行 `invoke-static` |
| 报文内容 / 备注格式 | `AprsService.buildPacket` |
| APRS-IS 行为（重连、过滤器） | `AprsClient` |
| 新增独立页面 | 仿 `CopyrightActivity`（代码建界面，免资源 id），记得在清单里注册 |
| 改符号集 | 重新跑 `make_icons.py` + 更新 `symbol_icons` |
