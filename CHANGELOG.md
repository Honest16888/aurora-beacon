# 更新日志

本文件记录所有值得注意的变更。
格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，
版本遵守 [语义化版本](https://semver.org/lang/zh-CN/)。

版本号后缀含义：`-yg`（早期个人版）、`-glass`（磨砂玻璃界面）、`-beacon`（改名过渡）、
`-aurora`（当前"极光信标"命名）。

---

## [1.8.2] - 2026-11-26

### 修复：台站查询 0 结果的真正根因（实测定案）

对着真实 aprsc 3.0 服务器逐项实验，三个事实：

| 实验 | 结果 |
|---|---|
| 登录行后**单独发一行** `filter r/35.6/139.7/300`（东京，必有流量） | **0 数据** —— 单独的 filter 行被 aprsc 忽略 |
| 把 filter **写进登录行**：`user ... vers X filter r/...` | **6 行/8 秒** ✓（aprslib 0.7.2 正是这么做的） |
| `b/17.5/73.0/54.5/135.5`（中国矩形，登录行内联） | 45 秒 **0 数据** —— aprsc 3.0 的 `b/` 在此配置下不产出 |
| `r/35.0/105.0/2500`（同窗口半径） | 30 秒 **215 行、153 台** ✓（含 BR2AG、BD1AMC 等国内台站） |

改动：

1. **filter 全部内联到登录行**（`NearbyQuery`）
   ```
   user BH6RGQ pass 16553 vers AuroraBeacon 1.8.2 filter r/35.0/105.0/3500
   ```
2. **全国查询由 `b/` 矩形改为 `r/` 半径**：以武汉(35,105)为圆心 **3500km** 覆盖中国全境
3. **收消息常驻连接补上 filter**（`filter m/BH6RGQ,m/BH6RGQ-15`）——
   实测 aprsc **不带 filter 一条数据都不发**，这正是"收件箱从来收不到东西"的原因；
   同样内联到登录行
4. 登录行 `vers` 同步为 `AuroraBeacon 1.8.2`

### 端到端实测（真实服务器，改动后的登录行）

```
全国 r/35,105,3500   → 12 秒 data=101, parsed=71（BH8WWP-12 云南、BG4BPN-11 上海…）
周边 r/30.5,114.2,60 → 10 秒 data=2,   parsed=2（BH6QHK 武汉近郊）
消息 m/BH6RGQ,...    → 过滤器接受、连接稳定（无人发消息时0 条属正常）
```

---

## [1.8.1] - 2026-11-26

### 修复

- **地图瓦片加载不出来（黑屏只剩圆点）**：默认底图换成**高德街道瓦片**
  （国内直达、无需 key），连续失败自动切 CARTO 深色 → OSM；右上角新增「底图」按钮手动切换。
  高德瓦片是 GCJ-02 坐标系，页面内置 WGS-84↔GCJ-02 双向转换，**切换底图时标记自动重投影**，
  不会出现"点位偏 500 米"。

- **全国台站 0 个**：位置解析只有 `!`/`=` 非压缩一种，漏掉了真实流量里的大部分格式。
  按 aprslib 0.7.2（Python 权威实现，已下载源码核实）与 APRSLocus 的参考实现重写：

  | 格式 | 说明 |
  |---|---|
  | 非压缩 | `DDMM.mmN/DDDMM.mmE`，含位置模糊（空格位取中） |
  | **压缩 Base91** | 固定段 **13 字符**：表(1)+纬(4)+经(4)+符号(1)+csT(2)；`90-lat/380926`、`-180+lon/190463` |
  | 带时间戳 | `/` 与 `@` 包先跳过 7 字符时间戳再解析 |
  | **Mic-E** | 位置编码在目的呼号 + 信息字段（手持台常用） |

  > 澄清：压缩格式经度是 **4 位 Base91**（总长 13），不是 5 位 —— 已用 aprslib 0.7.2
  > 源码 `parse_compressed` 核对：`longitude = -180 + base91(body[5:9]) / 190463.0`。
  > 我最初的测试编码器按 5 位写，导致自测误报，编码器已改。

- 查询日志增强：`query <host> filter ...` 与 `query done lines=N stations=M`，
  台站为 0 时能直接从 `net.log` 分清"没收到包"还是"收到但没解析出来"。

### 测试

`test_parser.py`（随仓库）覆盖 6 组真实报文格式：非压缩 / 时间戳 / 压缩往返 /
压缩+时间戳 / 位置模糊 / Mic-E 往返 + 2 组应拒绝样本，**6/6 通过**。

---

## [1.8.0] - 2026-11-26

### 新增

- **地图完全重做：本地 Leaflet（参考 APRSlocus 的做法）**

  对照参考 app（APRSlocus，Flutter + flutter_map + OSM 瓦片）的思路，
  把地图换成 **本地 Leaflet + OSM/CARTO 瓦片**，不再依赖外网页、不再依赖地图 SDK：

  | 项 | 内容 |
  |---|---|
  | 页面 | `assets/map/map.html` + `leaflet.js` + `leaflet.css`（随 APK 打包，离线可开） |
  | 瓦片 | CARTO 深色底图（跟界面风格一致），连续 4 张失败自动切 OpenStreetMap |
  | 自己的位置 | 青色圆点（17dp），点击显示"极光信标" |
  | 台站 | 橙色圆点，点击弹呼号 + 备注 |
  | 操作 | 底图上双指缩放/拖动、`全国台站 / 附近台站 / 我的位置 / 百度SDK / 回全国 / 关闭` |
  | 数据 | 打开地图自动拉一次全国台站（12 秒窗口），页面 ready 前到达的数据会缓存再补画 |

  为什么这样不会崩：Leaflet 是纯 JS 渲染，没有原生库、没有 AK、没有 ABI 问题。

### 修复

- **收件箱重启后消失**：消息改为持久化到 `SharedPreferences`（`msg_store`），
  服务启动 / 打开收件箱 / 发消息时都会加载，重启 App、杀进程都不丢；清空才删。
- **收到的消息内容有 bug**：原解析假设收件人字段固定 9 字符（服务端补空格），
  遇到不补空格的客户端会把正文切错。现在以「收件人后第一个冒号」为准，
  补空格/不补空格都能正确解析；`{序号` 剥离后存正文。
- **重复投递去重**：同一来源 + 同一正文 60 秒内只记一次。
- 附近台站列表点条目改为**详情对话框**（距离/方位/坐标/备注/时间 + 复制呼号），
  不再跳外部浏览器。

---

## [1.7.3] - 2026-11-26

### 修复

- **点「地图」直接闪退**

  1.7.2 修掉 marker 异常之后，`MapView` 第一次真正渲染，暴露出**原生层崩溃**
  （不是 Java 异常，`catch` 拦不住，所以连降级页都没出来）。

  处理方式：

  1. **主入口回退到网页地图**（`MapActivity`，已知稳定）：点「地图」不再直接进百度地图
  2. 百度地图改为**网页地图页里的「百度SDK」按钮**，且进入前做预检：
     - 设备 ABI 必须在打包范围（`arm64-v8a` / `armeabi-v7a`）
     - `nativeLibraryDir` 里必须真的存在 `libBaiduMapSDK_base_v7_5_2.so`
     - 任一不满足 → 提示「当前设备不支持百度地图 SDK」并留在网页地图，**不会进去崩**
  3. 百度页初始化失败时不再显示错误页，而是直接跳回网页地图并 `finish()`，
     日志里留 `baidu init failed, redirect to web map: ...`

### 说明

- 原生崩溃堆栈不会进 `crash.txt`（那是 `Thread.UncaughtExceptionHandler`，只管 Java 异常）。
  要定位需要 `adb logcat -b crash`，关键行是 `Fatal signal 11 (SIGSEGV)` 与
  `libBaiduMapSDK_*.so` / `libgnustl_shared.so` 的 backtrace
- 想继续用真 SDK 渲染，下一步应换成地图页 `MapFragment` 或改 `BaiduMapOptions` 的
  GL 参数；也可以直接换高德 SDK 对比

---

## [1.7.2] - 2026-11-26

### 修复

- **百度地图一打开就降级成网页地图**

  真机错误：

  ```
  java.lang.IllegalStateException: BDMapSDKException:
  when you add marker, you must set the icon or icons
  ```

  两个问题叠加：

  1. 百度 SDK **没有默认 marker 图标**，`MarkerOptions` 不带 `icon()` 会直接抛异常
     （高德有默认图标，所以容易想当然）
  2. 我把加 marker 的代码放在了初始化的同一个 try 块里，于是 marker 抛异常被当成
     "SDK 初始化失败"，整张地图被放弃、降级到网页地图 —— 提示文案也因此误导

  修法：

  - 用 `Canvas` 现画圆点当图标：自己 = 青色 14dp、其它台站 = 橙色 8dp，
    `BitmapDescriptorFactory.fromBitmap(...)`，**两处 marker 都带 icon**
  - 把 `ready = true` 提前到 `MapView` 建好之后；加 marker 单独 try-catch，
    **marker 失败只记日志，不再拖垮整张地图**

### 说明

- 若之后再看到"百度地图初始化失败"，那才是真的初始化问题（AK/签名/ABI/隐私），
  页面上的错误文本和 `net.log` 里的 `baidu map init failed:` 会对得上

---

## [1.7.1] - 2026-11-26

### 新增

- **地图上标出全国台站**：百度地图页新增「全国台站」按钮

  ```
  filter b/17.5/73.0/54.5/135.5      ← 中国范围外接矩形
  读 12 秒 → 去重（每台站取最新）→ 批量 addOverlays
  视野拉到全国（zoom 4.5），点标记看呼号
  ```

  - 坐标系：每个台站都做 WGS-84 → GCJ-02 → BD-09，避免整体偏移
  - 上限 300 个标记，避免一次画太多卡顿
  - 12 秒窗口内没收到包会明确提示，不会"点了没反应"

- `NearbyQuery` 重构出通用查询：`queryWithFilter(ctx, filterLine, refLat, refLon, windowMs)`，
  周边（`queryRadius`）与全国（`queryChina`）共用一套连接/解析/去重逻辑

### 说明

- 全国取的是 **APRS-IS 上正在上报的台站**（含 igate、中继、气象站等所有设备），
  不是"历史数据库"，所以某地安静时就真的没有点
- 想看得更全：把窗口期重复点几次，或直接看 aprs.fi（数据同源，它缓存更久）

---

## [1.7.0] - 2026-11-26

### 新增

- **接入百度地图 SDK（真·内置地图）**

  | 项 | 内容 |
  |---|---|
  | SDK | 百度 LBS Android **v7.5.2**（官方 AAR：`BaiduLBS_aar_Android_V7.5.2.aar`） |
  | Java 类 | `classes.jar` 经 d8 进入 `classes2.dex`（共 1143 个 `com.baidu.*` 类） |
  | 原生库 | `lib/arm64-v8a/` 与 `lib/armeabi-v7a/` 各 4 个 `.so`（约 14.2 MB） |
  | 清单 | 新增 `ACCESS_WIFI_STATE`、`CHANGE_WIFI_STATE`、`READ/WRITE_EXTERNAL_STORAGE`、`BaiduMapActivity`，`extractNativeLibs` 改为 `true` |
  | AK | `com.baidu.lbsapi.API_KEY` meta-data |

  `BaiduMapActivity` 的关键处理：
  - **初始化顺序**：先 `SDKInitializer.setAgreePrivacy(ctx, true)` 再 `initialize(ctx)`
    （反了就白屏）
  - **坐标系**：APRS 是 WGS-84 → 先转 GCJ-02 → 再转 BD-09，否则在百度地图上会偏 ~500 米
  - **不崩**：`MapView` 创建/初始化/加 marker 全在 try-catch 里，任何一步失败
    （AK 与签名不匹配、ABI 不支持、隐私未同意）都降级到网页地图，并显示错误原因
  - 页内按钮：`回中 / 附近台站 / 网页地图 / 关闭`

- 主界面「地图」改为进入百度地图页；SDK 起不来时自动落到 1.6.x 的 WebView 地图页。

### 变更

- APK 体积：**4.9 MB → 12.7 MB**（SDK 原生库所致）
- `build.ps1`：自动把 `libs/**/*.jar` 加入 javac classpath 与 d8 输入；
  `$ErrorActionPreference` 改为 `Continue`（javac 的 Note 走 stderr，`Stop` 会误判为失败）

### 说明

- SDK 二进制（`libs/*.jar`、`decoded/lib/*.so`）**不入库**，`.gitignore` 已排除；
  自己构建请按 [docs/BUILD.md](docs/BUILD.md) 的「接入百度地图 SDK」一节下载 AAR 并解压
- AK 已按「包名 `com.yg.aprs` + 签名 SHA1 `87:92:…:0A`」预置；换签名需重新申请

---

## [1.6.1] - 2026-11-26

### 新增

- **附近台站**：地图页新增「附近台站」按钮，用 APRS-IS 的**范围过滤** `filter r/lat/lon/km`
  订阅周边 60 公里的报文，读 8 秒后按距离列出：

  ```
  附近台站（3/12）
  BD7KFN-9   1.8 km NE
  车上
  BG6STN     5.2 km S
  hello
  ```

  点条目可直接打开该台站的 aprs.fi 页面。**不需要任何 API key**，走的就是本机已有的 APRS-IS 连接参数。
- 地图页新增「aprs.fi」按钮：直接加载以当前位置为中心的 aprs.fi 在线地图，能看到**周边所有设备**
  （包括不用本软件的电台、igate、中继）。
- 地图页布局改为两行按钮：`刷新 / 附近台站 / aprs.fi` + `百度页 / 地图App / 关闭`。

### 修复

- **坐标换算错误（重要）**：`ddmm.mm` 的度数位数算错了，
  `3050.78N` 被解析成 **305.013°**（纬度飘到几百上千度），导致地图中心点错误、附近台站距离全乱。

  | 输入 | 修复前 | 修复后 |
  |---|---|---|
  | `3050.78N` | 305.013 | **30.8463** |
  | `11419.05E` | 114.3175 | 114.3175（经度本来就对） |

  现在按「小数点的位置 − 2」取度数位数（`ddmm.mm` 点在 4 → 2 位；`dddmm.mm` 点在 5 → 3 位），
  并对分钟 ≥ 60 做非法值丢弃。同时修了台站备注起始位置差一个字符（`p+20` → `p+19`）。

---

## [1.6.0] - 2026-11-26

### 新增

- **内置地图页**（`MapActivity`，WebView 实现，**不依赖地图 SDK、不需要 AK**）
  - 主界面「地图」→ 应用内直接看位置：高德网页版 URI（`uri.amap.com`，官方免 key，`coordinate=wgs84`）
  - 页内三个按钮：**刷新**（重新加载）、**百度页**（`api.map.baidu.com/marker`，免 key）、
    **地图App**（走 1.5.1 的外呼链：百度 App → 高德 App → 系统地图 → OSM）
  - 没有定位数据时直接提示，不跳转；`onDestroy` 主动 `destroy()` WebView，避免泄漏

- 清单预置百度 SDK 的 AK：`<meta-data name="com.baidu.lbsapi.API_KEY" value="…"/>`
  （先把配置放好，等 `BaiduLBS_Android.jar` + `libBaiduMapSDK*.so` 到位即可接真 SDK）

### 说明

- 为什么还不上真 SDK：百度/高德的 Android SDK 需要原生 `.so`（每 ABI 十几 MB）、
  绑定包名+签名的 AK、隐私合规初始化（`SDKInitializer.setAgreePrivacy` 等），
  且 **SDK 压缩包在官网下载页后面，脚本抓不到**（返回的是 HTML 页面，不是 zip）。
  体积会从 4.9MB 涨到 20MB+，必须真机验证是否白屏。

---

## [1.5.2] - 2026-11-26

### 新增

- **消息详情 + 快捷回复**：点「收件箱」弹出消息列表 → 点某一条看详情（时间 / 来源呼号 / 完整正文），
  详情里可以直接【快捷回复】【复制正文】，列表本身还支持【清空】。
  （1.5.0 的收件箱只是一段不可点的文本，这次补上了完整交互）

### 修复

- **收件呼号填不了后缀**：输入框 `maxLength` 从 9 提到 12，输入类型改为
  `textCapCharacters|textNoSuggestions`（中文输入法也能敲出 `-`）；发送时统一规范化：
  - 全角 `－`、`—`、`–`、下划线 `_` 一律按 `-` 处理
  - 去掉空格、连续 `-` 合并、SSID 最多保留 2 位
  - 例：`bg6stn－15` → `BG6STN-15`
- **主呼号填成 `CALL-SSID` 会拼成 `CALL-SSID-SSID`**：新增 `MsgUi.fixCallsignPrefs()`，
  服务启动与每次发消息前自动把 `BH6RGQ-15` 拆成 base=`BH6RGQ` + SSID=`15` 并写回设置，

---

## [1.5.1] - 2026-11-26

### 改进

- **「地图」按钮改为国产地图优先的唤起链**

  ```
  百度地图 App → 高德地图 App → 系统地图（geo:）→ 高德网页（免 key）→ OpenStreetMap
  ```

  依次尝试，哪个能起来就用哪个；全部失败才提示"没有可用的地图应用"。

- **坐标系纠偏**：APRS 报文是 **WGS-84**。

  | 目标 | 处理 |
  |---|---|
  | 百度地图 | 传 `coord_type=wgs84`，直接用原始值 |
  | 高德地图 App | scheme 只认 **GCJ-02**，先做 WGS→GCJ 转换（否则在国内会偏 300–600 米） |
  | `geo:` | 系统地图按 WGS-84，直接用原始值 |
  | 高德网页 | `uri.amap.com/...&coordinate=wgs84`，官方免 key 的 URI API |

### 说明

- 仍未内置地图 SDK（高德/百度/腾讯 SDK 需要 `.so`、API Key 绑定包名+签名、隐私合规初始化，
  体积与维护成本都高），详见 [docs/FAQ.md](docs/FAQ.md) 的「能不能接入高德/百度 SDK」

---

## [1.5.0] - 2026-11-26

### 新增

- **接收 APRS 消息 + 重试队列**（新增 `MsgAgent` 常驻连接线程）

  | 能力 | 实现 |
  |---|---|
  | 保持连接 | 服务 `onCreate` 启动、`onDestroy` 停止；登录后订阅 `filter m/<呼号>` |
  | 收消息 | 解析 `::ADDRESSEE :text{seq`，addressee 是自己 → 存收件箱 |
  | 回 ack | 自动回 `CALL>APRGQ,TCPIP*::SENDER :ack{seq` |
  | 重试队列 | 发送进队列，30 秒未收到 ack 重发，最多 3 次；收到 `ackNN` 标记已确认 |
  | 少一次握手 | 位置报文也走这条常驻连接；连接不可用时自动回退到「连一次发一条」 |

- 界面：消息卡改为「收件呼号 + 内容 + **发送 / 收件箱 / 地图**」，卡片下方直接显示
  收件箱内容与发送状态（`待确认 BG6STN #03 (1/3)` 这种）

### 说明

- 收件箱与发件箱都在**内存**里，进程被系统回收后清空（不做持久化，避免额外权限与迁移）
- **没有通知提醒**：新消息不会弹通知，点「收件箱」查看（通知会与前台服务通知抢注意力，
  留到下一版做静默汇总通知）
- APRS 消息本身没有服务器端排队：**对端离线时消息会丢**；本机的重试只覆盖
  "连接抖动 / 重连后补发"，不能替代离线投递
- 收到的消息只显示，不会进入系统通知或转发

---

## [1.4.4] - 2026-11-26

### 修复

- **同一位置可能被发两遍**：`BeaconSend` 在报文已经 flush 之后才出现的异常也会触发整轮重试，
  网络抖动时一条位置报文会被送出两次（现象就是 aprs.fi 上「平均 32 秒一个数据包」、点位来回跳）。
  现在**写入成功后任何异常都不再重试**——宁可丢一包，也不重复两包。

### 新增

- **APRS 消息（发送）**：界面新增「收件呼号 + 消息内容 + 发送消息」玻璃卡，按标准格式发出

  ```
  BH6RGQ-15>APRGQ,TCPIP*::BG6STN   :你好，这条来自极光信标{01
  ```

  收件呼号补齐 9 字符、序列号 `{01`–`{99` 自动轮转、内容按 67 字符截断。
  通过同一个 `BeaconSend` 通道（登录 → 发一条 → 断开），不额外占连接。
  **当前只发不收**（收消息需要长连接常驻读取 + 通知，列入路线图）。

- **在地图上查看**：按最近一次成功上报的坐标打开系统地图（`geo:` Intent，会给出
  Google Maps / 高德 / 华为地图等选择），设备上没有地图 App 时自动退到 OpenStreetMap 网页。
  坐标直接解析自本机发出的那条报文，因此**与 APRS-IS 上的点位完全一致**。

- 构建：新增 `java/stubs/`（编译期桩）。新 Java 代码可以直接调用 `Prefs`、`AprsPasscode`
  这类应用内类；桩只参与 javac，不会打进 `classes2.dex`。

---

## [1.4.3] - 2026-11-22

### 修复

- **切到后台后停止上报 / 一直显示上报失败**
  1. 上报方式改为「**每个周期独立建连 → 登录 → 发一条 → 断开**」（`BeaconSend`），
     不再复用长连接。原实现后台时遇到移动网络切换、Wi-Fi 休眠、运营商 NAT 超时，
     socket 会变成半死状态：写入仍返回成功，但服务器收不到 —— 界面显示正常，
     aprs.fi 上却没有点。现在每轮都是新连接，失败立即重试一次（间隔 3 秒）。
  2. `AprsClient.getConnected()` 恒为 `true`，轮询不再进入旧的持久连接分支。
     原逻辑里那条连接一旦握手失败就会**整轮跳过**，白等一个上报周期。
  3. `bestLocation()` 返回空时，用 `LocationFallback` 补一个 10 分钟内的
     `getLastKnownLocation()`，避免「没定位就整轮不发」。超过 10 分钟的一律丢弃，
     防止把几小时前的位置当当前位置发出去。

### 新增

- 网络日志：`/sdcard/Android/data/com.yg.aprs/files/net.log`
  记录每轮连接结果、服务器 `logresp`、发送字节数；超过 256KB 自动重建；不联网、不上传。

### 说明

- 前台服务类型核对无误（`foregroundServiceType="location"`，`startForeground` 第三参数
  传 `FOREGROUND_SERVICE_TYPE_LOCATION`），所以后台定位权限本身没问题，
  本次修的是**连接复用**与**定位兜底**。
- 国产 ROM 的省电策略仍可能杀掉后台，建议按 [FAQ](docs/FAQ.md) 把应用加入
  「不受限制 / 允许自启动」。

---

## [1.4.2] - 2026-11-22

### 修复

- **aprs.fi 设备显示 `Unknown: Unknown`**：报文目的地址（TOCALL）原为泛用的 `APRS`，
  aprs.fi 查不到对应软件，故显示 Unknown。现改为专属标识 **`APRGQ`**。
  > 完整显示为「极光信标」需要把 TOCALL 登记到软件标识表（aprs.fi 侧的数据），
  > 申请文本见 [docs/APRS.md](docs/APRS.md#8-设备名aprsfi-的设备字段)。

### 文档

- 补充界面截图（主界面 / 图标选择 / 版权页），由 `docs/images/preview/*.html` 按实际布局数值渲染
- 新增 `make_previews.py`：从 `decoded/res` 读取颜色、间距与符号图标生成预览页，便于随版本更新截图

---

## [1.4.1] - 2026-11-22

### 变更

- 报文默认备注前缀由 `YG-APRS` 改为 `AURORA`（自定义备注不受影响）
- 前台通知文案改为「极光信标 后台服务 / 极光信标 运行中」
- APRS-IS 登录行 `vers` 更新为 `AuroraBeacon 1.4.1`

---

## [1.4.0] - 2026-11-22

### 新增

- 默认呼号预置为 `BH6RGQ`（`Prefs` 默认值 + 空值自动填入 + 输入框提示）
- 应用更名为 **极光信标 (Aurora Beacon)**，顶部改为「极光信标 + BH6RGQ」

### 修复

- **启动即闪退**：新增的 `onCopyrightClick` 用 `.registers 3` 声明了 2 个参数，
  `p0` 恰好落在 `v1` 上，随后的 `const-class v1` 把 `this` 覆盖成了 `Class`，
  类校验阶段直接 `VerifyError`。改为 `.registers 4` 修复。
  > 结论：`p0 = v(寄存器总数 - 参数个数)`，写局部寄存器前必须确认不与参数重叠。

---

## [1.3.0] - 2026-11-22 — ⚠️ 已知会启动闪退

### 新增

- 底部版权页（`CopyrightActivity`）：版权、免责声明、隐私说明、第三方组件、运行环境
- 点击密码胶囊复制 APRS 密码（Toast 提示）
- 「aprs.fi 轨迹查询」改为按当前呼号 + SSID 直达轨迹页
- 底部品牌区显示版权行，整块可点进版权页

### 变更

- 应用更名为 **YG 信标**（桌面名、顶部标题、底部版权行同步）

### 已知问题

- **启动闪退**（寄存器覆盖 `this`，见 1.4.0 修复说明）

---

## [1.2.2] - 2026-11-22

### 修复

- **状态卡"网络"永远显示未知**：清单缺少 `ACCESS_NETWORK_STATE`，
  `ConnectivityManager.getActiveNetwork()` 抛 `SecurityException` 被外层 catch 吞掉。
  现已补上该普通权限（安装即生效，无需弹窗）。
- **网络制式映射表错位**：原 `packed-switch` 表与 `NETWORK_TYPE_*` 常量不对应
  （LTE→2G、HSPA→4G、TD-SCDMA→5G、NR 落到默认"蜂窝"）。已按 1–20 全部重排：
  2G={GPRS,EDGE,CDMA,1xRTT,IDEN,GSM}、3G={UMTS,EVDO_0,EVDO_A,HSDPA,HSUPA,HSPA,EVDO_B,EHRPD,HSPAP,TD_SCDMA}、
  4G={LTE,IWLAN,LTE_CA}、5G={NR}
- **制式获取失败连带丢运营商**：`getDataNetworkType()` 需要 `READ_PHONE_STATE`（危险权限，
  本应用未做运行时申请），抛异常会把整串打成"未知"。现已单独 try/catch，降级为
  「运营商 + 蜂窝」。

---

## [1.2.1] - 2026-11-22

### 修复

- **点击 APRS 图标闪退**：图标行渲染改为纯代码构建（`LinearLayout` + `ImageView` + `TextView`），
  不再依赖 XML inflate 与 `getChildAt`；每一步 try-catch 降级
- 图标适配器改为 **Java 源码 + `javac`/`d8` 编译**，作为 `classes2.dex` 打包，
  由编译器核对每个 Android API，杜绝手写 smali 的方法归属错误

### 新增

- `CrashGuard`：未捕获异常写入
  `/sdcard/Android/data/com.yg.aprs/files/crash.txt`

---

## [1.2.0] - 2026-11-22 — ⚠️ 已知点击图标会闪退

### 新增

- 磨砂玻璃界面整体重构：极光渐变背景 + 双光斑 + 22dp 圆角半透明卡片 + 1dp 高光描边
- 状态区改为 2×2 磁贴（定位源/网络/电量/基站）+ 通栏"最近上报"
- 顶部 `YG` + `APRS` 标题与密码胶囊；底部品牌行
- 状态栏/导航栏配色、强制深色主题

### 修复

- `SymbolAdapter` 中误用 `Landroid/view/View;->getChildAt`（该方法在 `ViewGroup` 上），
  改为 `check-cast` 到 `ViewGroup` 后调用

### 已知问题

- 点击图标下拉仍会闪退（1.2.1 用 Java 重写解决）

---

## [1.1.0] - 2026-11-20

### 新增

- 报文备注可自定义（留空则自动生成状态备注）
- 188 个 APRS 符号列表（仅文字，尚无图标）
- `Prefs.getComment/setComment`

### 修复

- **启动闪退（VerifyError）**：适配器初始化块用 `const/4 v5` 覆盖了仍被当作
  字符串读取的 `v5`。改为使用未被占用的 `v8`
- 报文格式错误：纬度与符号表之间多了一个 `/`，修正为
  `!LAT<表>LON<码>COMMENT`

---

## [1.0.0] - 2026-11-19

### 新增（基于上游 APK 的个性化首版）

- 包名重命名 `com.stn.aprs` → `com.yg.aprs`
- 呼号 / SSID / 上报间隔 / APRS 服务器 / 端口 配置项
- APRS 密码自动计算与展示
- APRS 图标选择、自定义备注
- 状态面板：状态、坐标、定位源、网络、电量电压、基站小区、最近上报
- 启停按钮 + 前台服务 + WakeLock
- aprs.fi 轨迹查询入口

---

[1.4.1]: #141---2026-11-22
[1.4.0]: #140---2026-11-22
[1.3.0]: #130---2026-11-22--已知会启动闪退
[1.2.2]: #122---2026-11-22
[1.2.1]: #121---2026-11-22
[1.2.0]: #120---2026-11-22--已知点击图标会闪退
[1.1.0]: #110---2026-11-20
[1.0.0]: #100---2026-11-19
