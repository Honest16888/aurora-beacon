# 更新日志

本文件记录所有值得注意的变更。
格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，
版本遵守 [语义化版本](https://semver.org/lang/zh-CN/)。

版本号后缀含义：`-yg`（早期个人版）、`-glass`（磨砂玻璃界面）、`-beacon`（改名过渡）、
`-aurora`（当前"极光信标"命名）。

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
