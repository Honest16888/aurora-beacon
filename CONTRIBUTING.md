# 参与贡献

感谢你对极光信标的兴趣。这是一个个人维护的小项目，下面几条能让来回次数少很多。

## 提 Issue 前

1. 先看 [docs/FAQ.md](docs/FAQ.md) 和 [CHANGELOG.md](CHANGELOG.md)，历史上每一次闪退都写了根因
2. 确认版本号：应用内「底部版权行 → 版权页」最后会显示**版本号 + Android 版本 + API**
3. 如果是崩溃，请附上崩溃日志（下面有取法）

### 怎么取崩溃日志

**方式一：应用自带（最省事）**

```
/sdcard/Android/data/com.yg.aprs/files/crash.txt
```

用文件管理器打开这个路径，把内容复制出来贴进 Issue。
（未捕获异常都会写在这里，包含完整 `Caused by` 链。）

**方式二：adb**

```bash
adb logcat -c
# 复现一次
adb logcat -d -s AndroidRuntime:E > crash.txt
```

### Issue 模板

```
版本：1.4.1-aurora（versionCode 8）
机型/系统：Redmi K60 / Android 14（API 34）
复现步骤：1) 打开 2) 点 APRS 图标
期望：弹出图标列表
实际：闪退
日志：（贴 crash.txt 或 logcat）
```

## 提 PR

- 从 `main` 切分支：`feat/xxx`、`fix/xxx`、`docs/xxx`
- 提交信息用 `<type>: <subject>`：`fix: 修正网络制式映射` / `feat: 支持手动立即上报`
- 一次 PR 只做一件事；纯格式化改动请单独提交
- 改动涉及界面请附截图；涉及报文请附**实际发出的报文样例**
- 提交前自检：
  - `decoded/` 能被 `apktool b` 打包成功
  - `java/src` 能被 `javac` 编译成功（`build.ps1` 会一起做）
  - 真机至少跑一次启动 → 选图标 → 启动上报 → 停止上报

## 改 smali 的注意事项（重要）

本工程有大量手写 smali，最容易踩的坑是**寄存器**。请务必遵守：

1. **参数寄存器**：方法有 P 个参数、`.registers N` 时，`p0 = v(N-P)`。
   写局部寄存器时不能覆盖参数寄存器，否则 `this` 会被悄悄改掉，
   编译能过、运行时在**类加载阶段**就 `VerifyError`（表现为"一打开就闪退"）。
   - 建议：先数清楚 P，再决定 N；或直接用 `.locals` 让工具排版
2. **类型合并**：同一个寄存器在不同分支被当成不同类型（如 `int` 与 `String`）读，
   合流点会校验失败。要么分离寄存器，要么保证同一路径类型一致
3. **方法归属**：`getChildAt` 在 `ViewGroup` 上而不是 `View` 上——smali 不校验这一点，
   写错只有运行时 `NoSuchMethodError`。新增 API 调用请对照 `android.jar` 确认
4. **catch 块**：handler 首条指令用 `move-exception vX`，且 `try` 区间的嵌套要正确

需要新增较复杂逻辑时，**优先写在 `java/src/com/yg/aprs/` 里**（`javac` 会替你把关），
再通过一行 `invoke-static` 从 smali 调用，比手写几百行 smali 可靠得多。

## 不要提交的东西

`.gitignore` 已经挡住，但再强调一次：

- ❌ 签名密钥 `*.keystore` / `*.jks`
- ❌ 口令、`keystore.properties`
- ❌ 任何 token / API key（GitHub PAT、云厂商密钥……）
- ❌ 基线 APK（`*.apk`）与构建中间产物
- ❌ `decoded/build/`、`javaout/`、`d8out/`

> 如果你不小心把密钥或 token 推上去了：**先 revoke/重置**，再清历史。
> GitHub 的 PAT 一旦公开，应视为已泄露。

## 代码风格

- Java：4 空格缩进，类内顺序 `字段 → 构造 → 公开方法 → 私有方法`
- 所有对外方法都要能容忍 `null` 与异常（本项目的稳定性策略就是"降级不崩"）
- 新增字符串资源走 `res/values/strings.xml`；仅版权页这类自建页面允许内联
- 注释用中文，写「为什么」而不是「做了什么」

## 许可

提交即表示你同意以 **Apache License 2.0** 授权你的贡献。
