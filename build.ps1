<#
.SYNOPSIS
    极光信标（Aurora Beacon）一键构建脚本。

.DESCRIPTION
    流程：javac 编译 java/src → d8 生成 classes2.dex → apktool 打包 decoded/
          → 注入 classes2.dex → zipalign → apksigner 签名 → 校验

.PARAMETER Base
    基线 APK。提供时会先执行 apktool d 覆盖重建 decoded/。

.PARAMETER KeyStore
    签名密钥路径（*.keystore / *.jks）。不会入库，见 .gitignore。

.PARAMETER KeyAlias
    密钥别名。

.PARAMETER StorePass
    keystore 口令。

.PARAMETER KeyPass
    key 口令，省略时与 StorePass 相同。

.PARAMETER SkipJava
    跳过 Java 模块编译（只改 smali/资源时更快）。

.PARAMETER OutDir
    产物目录，默认 dist。

.PARAMETER ApktoolJar
    apktool 路径，默认工程根目录下 apktool.jar。

.PARAMETER JavaHome
    JDK 根目录。默认取 $env:JAVA_HOME。

.PARAMETER BuildTools
    Android SDK build-tools 目录（含 d8.bat / zipalign.exe / apksigner.bat）。

.PARAMETER PlatformJar
    android.jar（编译 Java 模块用的 bootclasspath）。

.EXAMPLE
    pwsh -File build.ps1 -KeyStore my.keystore -KeyAlias mykey -StorePass pass

.EXAMPLE
    pwsh -File build.ps1 -SkipJava -KeyStore my.keystore -KeyAlias mykey -StorePass pass
#>

[CmdletBinding()]
param(
    [string]$Base,
    [string]$KeyStore = 'yg.keystore',
    [string]$KeyAlias = 'yg',
    [string]$StorePass,
    [string]$KeyPass,
    [switch]$SkipJava,
    [string]$OutDir = 'dist',
    [string]$ApktoolJar = 'apktool.jar',
    [string]$JavaHome = $env:JAVA_HOME,
    [string]$BuildTools = "$env:LOCALAPPDATA\Android\Sdk\build-tools\34.0.0",
    [string]$PlatformJar = "$env:LOCALAPPDATA\Android\Sdk\platforms\android-34\android.jar"
)

$ErrorActionPreference = 'Stop'
$Root = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
Set-Location $Root

function Info($m) { Write-Host "==> $m" -ForegroundColor Cyan }
function Die($m) { Write-Host "!!  $m" -ForegroundColor Red; exit 1 }

# ---------- 工具检查 ----------
if (-not $JavaHome) { $JavaHome = 'C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot' }
$java = Join-Path $JavaHome 'bin\java.exe'
$javac = Join-Path $JavaHome 'bin\javac.exe'
$d8 = Join-Path $BuildTools 'd8.bat'
$zipalign = Join-Path $BuildTools 'zipalign.exe'
$apksigner = Join-Path $BuildTools 'apksigner.bat'

foreach ($p in @(
        @{ n = 'java'; p = $java }, @{ n = 'javac'; p = $javac },
        @{ n = 'd8'; p = $d8 }, @{ n = 'zipalign'; p = $zipalign },
        @{ n = 'apksigner'; p = $apksigner }, @{ n = 'android.jar'; p = $PlatformJar },
        @{ n = 'apktool'; p = (Join-Path $Root $ApktoolJar) }
    )) {
    if (-not (Test-Path $p.p)) { Die "找不到 $($p.n)：$($p.p)（可用参数指定）" }
}
if (-not $StorePass) { Die '缺少 -StorePass（keystore 口令）' }
if (-not $KeyPass) { $KeyPass = $StorePass }
if (-not (Test-Path $KeyStore)) { Die "找不到签名密钥：$KeyStore" }

$versionCode = '0'
$versionName = 'unknown'
$yml = Join-Path $Root 'decoded\apktool.yml'
if (Test-Path $yml) {
    $y = Get-Content $yml -Raw
    if ($y -match 'versionCode:\s*(\S+)') { $versionCode = $Matches[1] }
    if ($y -match 'versionName:\s*(\S+)') { $versionName = $Matches[1].Trim("'", '"') }
}

# ---------- 0) 可选：重新解码基线 ----------
if ($Base) {
    if (-not (Test-Path $Base)) { Die "找不到基线 APK：$Base" }
    Info "解码基线 APK：$Base"
    & $java -jar (Join-Path $Root $ApktoolJar) d -f $Base -o decoded
    if ($LASTEXITCODE -ne 0) { Die 'apktool d 失败' }
}

# ---------- 1) Java 模块 ----------
$d8out = Join-Path $Root 'd8out'
$classes2 = Join-Path $d8out 'classes.dex'
if ($SkipJava) {
    Info '跳过 Java 编译（-SkipJava）'
    if (-not (Test-Path $classes2)) { Die "需要已有的 $classes2，但不存在" }
}
else {
    $srcDir = Join-Path $Root 'java\src'
    if (-not (Test-Path $srcDir)) { Die "找不到 Java 源码目录：$srcDir" }
    $javaout = Join-Path $Root 'javaout'
    Remove-Item $javaout -Recurse -Force -ErrorAction Ignore
    New-Item -ItemType Directory $javaout | Out-Null

    $sources = Get-ChildItem $srcDir -Recurse -Filter *.java | ForEach-Object { $_.FullName }
    Info "javac：$($sources.Count) 个源文件"
    & $javac -encoding UTF-8 -source 8 -target 8 -nowarn `
        -bootclasspath $PlatformJar -d $javaout $sources
    if ($LASTEXITCODE -ne 0) { Die 'javac 编译失败（API 调用有误，先看这里的报错）' }

    Remove-Item $d8out -Recurse -Force -ErrorAction Ignore
    New-Item -ItemType Directory $d8out | Out-Null
    $classes = Get-ChildItem $javaout -Recurse -Filter *.class | ForEach-Object { $_.FullName }
    Info "d8：$($classes.Count) 个 class → classes2.dex"
    & $d8 --min-api 26 --lib $PlatformJar --release --output $d8out $classes
    if ($LASTEXITCODE -ne 0) { Die 'd8 失败' }
}

# ---------- 2) apktool 打包 ----------
$buildCache = Join-Path $Root 'decoded\build'
if (Test-Path $buildCache) {
    Info '清理 apktool 缓存 decoded\build'
    Remove-Item $buildCache -Recurse -Force
}
$unsigned = Join-Path $Root 'unsigned.apk'
Info 'apktool 打包'
& $java -jar (Join-Path $Root $ApktoolJar) b (Join-Path $Root 'decoded') -o $unsigned
if ($LASTEXITCODE -ne 0) { Die 'apktool b 失败' }

# ---------- 3) 注入 classes2.dex ----------
$unsigned2 = Join-Path $Root 'unsigned2.apk'
$injector = Join-Path $Root 'inject_dex.py'
if (Test-Path $injector) {
    Info '注入 classes2.dex'
    python $injector $unsigned $classes2 $unsigned2 'classes2.dex'
    if ($LASTEXITCODE -ne 0) { Die '注入失败（需要 python 与 inject_dex.py）' }
}
else {
    Info '未找到 inject_dex.py，直接把 classes.dex 当产物（不含 Java 模块）'
    Copy-Item $unsigned $unsigned2 -Force
}

# ---------- 4) 对齐 ----------
$aligned = Join-Path $Root 'aligned.apk'
Info 'zipalign -p 4'
Remove-Item $aligned -Force -ErrorAction Ignore
& $zipalign -f -p 4 $unsigned2 $aligned
if ($LASTEXITCODE -ne 0) { Die 'zipalign 失败' }

# ---------- 5) 签名 ----------
$out = Join-Path $Root $OutDir
New-Item -ItemType Directory $out -Force | Out-Null
$apkOut = Join-Path $out ("aurora-beacon-$versionName.apk")
Remove-Item $apkOut -Force -ErrorAction Ignore
Info "apksigner 签名 → $apkOut"
& $apksigner sign --ks $KeyStore --ks-key-alias $KeyAlias `
    --ks-pass "pass:$StorePass" --key-pass "pass:$KeyPass" `
    --out $apkOut $aligned
if ($LASTEXITCODE -ne 0) { Die 'apksigner sign 失败' }

# ---------- 6) 校验 ----------
Info '校验签名'
& $apksigner verify --print-certs $apkOut
if ($LASTEXITCODE -ne 0) { Die '签名校验失败' }

$size = [math]::Round((Get-Item $apkOut).Length / 1MB, 2)
Write-Host ''
Write-Host "构建完成：$apkOut" -ForegroundColor Green
Write-Host "  版本    $versionName (code $versionCode)"
Write-Host "  大小    $size MB"
Write-Host "  安装    adb install -r `"$apkOut`""
