# 安全策略

## 支持范围

| 版本 | 状态 |
|---|---|
| 1.4.x | ✅ 接收安全与崩溃报告 |
| 1.3.x 及更早 | ❌ 不再维护（1.3.0 本身存在启动闪退） |

## 报告问题

- 一般崩溃/异常：走 [Issues](../../issues)，附 `crash.txt` 或 logcat
- 涉及凭证、隐私、可被静默利用的问题：请**不要**直接开公开 Issue，
  通过仓库的「Security → Report a vulnerability」私密报告，或邮件联系维护者
- 收到确认后 7 天内给出处理计划

## 应用的数据行为（可自行审计）

- 只与你在设置里指定的 APRS-IS 服务器建立 TCP 连接（默认端口 14580）
- 发送内容：呼号、位置、符号、备注、网络制式、电量——全部是 APRS 报文本身
- 不包含任何设备标识（IMEI / Android ID / 广告 ID / 账号）
- 设置仅存本机 `SharedPreferences`（`yg_aprs_prefs`）
- 崩溃堆栈仅写到应用私有外部目录，**不自动上传**

## 凭证管理（给贡献者）

- 签名密钥、口令、GitHub token 一律不进仓库；`.gitignore` 已排除 `*.keystore`、`*.jks`、`keystore.properties`
- GitHub Personal Access Token 一旦出现在任何公开位置（Issue、PR、commit、截图、聊天记录），
  请立即到 **Settings → Developer settings → Personal access tokens** 撤销并重新生成，
  同时开启过期时间与最小权限（只勾选需要的 repo 权限）
- 推荐改用 SSH key 或 `gh auth login` 推送，避免长寿命 PAT

## 发布签名

- Release 包使用维护者本地密钥签名，密钥不入库
- 校验下载来源：只从本仓库 Releases 下载；可用 `apksigner verify --print-certs` 比对证书指纹
