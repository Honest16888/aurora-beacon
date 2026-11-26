# 构建说明

本工程不是 Gradle 工程，而是一个 **apktool 反向工程 + Java 模块** 的混合构建：应用主体逻辑在
`decoded/` 的 smali 与资源里，新增功能写在 `java/src/`，编译成 `classes2.dex` 后注入 APK。

```
decoded/ (apktool 工程)  ──apktool b──►  unsigned.apk  ──┐
                                                        ├─注入──► zipalign ──► apksigner ──► 可安装 APK
java/src/ ──javac──► *.class ──d8──►  classes2.dex  ────┘
```

## 1. 前置工具

| 工具 | 版本 | 用途 | 获取 |
|---|---|---|---|
| JDK | 17 | `javac` / `d8` / `apksigner` 运行环境 | Adoptium Temurin 17 |
| Android SDK build-tools | 34.0.0 | `aapt2` / `d8` / `zipalign` / `apksigner` | Android Studio SDK Manager |
| Android SDK platform | android-34 | `android.jar`（编译 Java 模块的 bootclasspath） | 同上 |
| apktool | **3.0.3** | 反编译 / 重打包 | <https://apktool.org> |
| Python | 3.9+ | 仅重新生成 188 个图标时需要 | python.org |
| Pillow | 10.x | 同上 | `pip install pillow` |

`apktool.jar` 体积较大，不入库，请自行下载后放在工程根目录。

## 2. 准备基线 APK

`decoded/` 是对一份基线 APK 的反编译结果。**基线 APK 不随仓库分发**，你需要自备一份
（自用备份即可），然后：

```powershell
java -jar apktool.jar d baseline.apk -o decoded
```

> 已提交到仓库的 `decoded/` 就是解码后的内容，如果你只是**改代码**而不换基线，
> 直接跳过这一步即可。只有换基线或从零重建时才需要重新解码。

## 3. 一键构建

```powershell
.\\build.ps1 `
    -KeyStore my.keystore -KeyAlias mykey `
    -StorePass "yourpass" -KeyPass "yourpass"
```

脚本会依次执行：

1. `javac` 编译 `java/src/**/*.java`（`-source/--target 8`，bootclasspath 指向 `android.jar`）
2. `d8 --min-api 26 --release` 生成 `classes2.dex`
3. `apktool b decoded -o unsigned.apk`
4. 把 `classes2.dex` 注入 APK（`python inject_dex.py`，以 ZIP_STORED 写入）
5. `zipalign -p 4`
6. `apksigner sign`（v2 + v3 签名）

产物默认输出到 `dist/aurora-beacon-<version>.apk`。

### 关于 `java/stubs/`

新代码若要调用应用内已有类（`Prefs`、`AprsPasscode`、`Status` …），
在 `java/stubs/com/yg/aprs/AppStubs.java` 里写上**与 smali 完全一致**的签名，
`javac` 就能通过；这些桩只参与编译（输出到 `stubout/`），**不会**打进 `classes2.dex`，
运行时用的是 `classes.dex` 里的真实实现。

签名对不上（字段 `INSTANCE`、方法名、参数或返回类型）不会在编译期报错，
只会在运行时 `NoSuchMethodError` / `NoSuchFieldError`——加方法时务必对照 smali 核对一遍。

### 参数

| 参数 | 默认值 | 说明 |
|---|---|---|
| `-Base` | 无 | 基线 APK；给了就先 `apktool d` 覆盖重建 `decoded/` |
| `-KeyStore` | `yg.keystore` | 签名密钥路径 |
| `-KeyAlias` | `yg` | 密钥别名 |
| `-StorePass` | 必填 | keystore 口令 |
| `-KeyPass` | 同 StorePass | key 口令 |
| `-SkipJava` | 关 | 跳过 Java 编译（只改 smali/资源时更快） |
| `-OutDir` | `dist` | 产物目录 |
| `-ApktoolJar` | `apktool.jar` | apktool 路径 |

## 4. 手工构建（等价命令）

```powershell
# 1) Java 模块
javac -encoding UTF-8 -source 8 -target 8 -nowarn `
      -bootclasspath "%SDK%\platforms\android-34\android.jar" `
      -d javaout (Get-ChildItem java\src -Recurse -Filter *.java).FullName

# 2) classes2.dex
& "%SDK%\build-tools\34.0.0\d8.bat" --min-api 26 --release `
   --lib "%SDK%\platforms\android-34\android.jar" `
   --output d8out (Get-ChildItem javaout -Recurse -Filter *.class).FullName

# 3) 打包（先清缓存，否则 apktool 可能复用旧 dex）
Remove-Item decoded\build -Recurse -Force -ErrorAction Ignore
java -jar apktool.jar b decoded -o unsigned.apk

# 4) 注入 + 对齐 + 签名
python inject_dex.py unsigned.apk d8out\classes.dex unsigned2.apk classes2.dex
& "%SDK%\build-tools\34.0.0\zipalign.exe" -f -p 4 unsigned2.apk aligned.apk
& "%SDK%\build-tools\34.0.0\apksigner.bat" sign --ks my.keystore --ks-key-alias mykey `
   --ks-pass pass:yourpass --key-pass pass:yourpass --out dist\app.apk aligned.apk

# 5) 校验
& "%SDK%\build-tools\34.0.0\apksigner.bat" verify --print-certs dist\app.apk
```

## 5. 重新生成 188 个符号图标

图标已随仓库提交（`decoded/res/drawable-nodpi/sym_*.png`）。只有想换源图/改尺寸时才需要：

```powershell
# 1) 下载 aprs.fi 符号集，解压到 symex/
#    https://github.com/hessu/aprs-symbols
# 2) 按 ASCII 0x21–0x7E 逐格切分主表/副表，重采样 64×64
python make_icons.py
```

命名规则：`sym_<表hex><码hex>.png`，例如 `sym_2f3e.png` = 主表(`/`) + 符号 `>`，
对应数组 `res/values/arrays.xml` 里的 `symbol_icons` 第 `0x3E-0x21 = 29` 项（顺序必须与
`symbol_labels`、`MainActivity.SYMBOL_CHARS` 完全一致）。

## 6. 签名与升级

- 覆盖安装要求**同一个签名**。换密钥后再装会提示"签名不一致"，需先卸载（会清掉设置）
- `versionCode` 必须递增，否则系统拒绝升级——修改 `decoded/apktool.yml` 的
  `versionInfo.versionCode` / `versionName`
- Release 密钥不要入库（`.gitignore` 已排除 `*.keystore` / `*.jks`）

## 7. 常见构建 / 运行错误

| 现象 | 原因 | 处理 |
|---|---|---|
| `style attribute 'android:attr/xxx' not found` | 主题里用了当前 SDK 不存在的属性 | 删掉该 `<item>`（如 `windowBackgroundCacheHint`） |
| `unescaped apostrophe` / `unterminated string` | `arrays.xml` 里的 `'`、`\` 未转义 | 写 `\'`、`\\` |
| `Invalid register: v9` | `.registers`/`.locals` 数量不够 | 按「参数占位」重算：`p0 = v(N-P)` |
| 打包后改动没生效 | apktool 复用了 `decoded/build` 缓存 | 先删 `decoded/build` 再打包 |
| **运行即闪退，logcat 有 `VerifyError`** | 局部寄存器覆盖了参数寄存器（`this` 被改） | 见 [CONTRIBUTING.md](../CONTRIBUTING.md) 的 smali 注意事项 |
| 运行时报 `NoSuchMethodError` | 方法挂在错误的类上（如 `View.getChildAt`） | 对照 `android.jar` 确认宿主类；复杂逻辑改写进 `java/src` |
| 点某功能闪退 | 新增代码未降级 | 按本项目约定给每一步加 try-catch，失败就隐藏该功能 |
| `INSTALL_FAILED_UPDATE_INCOMPATIBLE` | 签名或 versionCode 冲突 | 用同一密钥；递增 versionCode；必要时卸载重装 |

## 8. 发布检查清单

发新版前逐项确认（漏掉会导致版本号 / 显示不一致）：

1. `decoded/apktool.yml` → `versionCode` **递增**、`versionName` 改好
2. 登录行 `vers` 版本号有两处需要同步（都不在 `apktool.yml` 里，最容易漏）：
   `java/src/com/yg/aprs/BeaconSend.java` 的 `VERS`（实际生效的那条），
   以及 `decoded/smali/com/yg/aprs/AprsClient.smali` 里的旧串
3. `CHANGELOG.md` 加一节，写清问题根因
4. 界面有改动 → `python make_previews.py` 重出 `docs/images/*.png`
5. `./build.ps1` 构建，`apksigner verify --print-certs` 确认证书指纹没变
6. 覆盖安装自测：启动 → 选图标 → 启动上报 → aprs.fi 能看到点 → 停止上报

## 9. 调试

- 崩溃栈：`/sdcard/Android/data/com.yg.aprs/files/crash.txt`（应用自带的 `CrashGuard` 写）
- 实时日志：`adb logcat -s AndroidRuntime:E`
- 看报文是否正确：状态卡显示最近坐标；或抓 `aprs.fi` 上的原始报文
