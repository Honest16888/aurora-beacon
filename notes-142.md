## 极光信标 1.4.2-aurora

versionCode 9 · Android 8.0+ · 覆盖安装即可（同一签名）

### 修复

- **aprs.fi「设备」显示 `Unknown: Unknown`**
  报文目的地址（TOCALL）原本是泛用的 `APRS`，aprs.fi 查软件表查不到 → Unknown。
  本版改为专属标识 **`APRGQ`**：

  ```
  旧： BH6RGQ-15>APRS,TCPIP*:!3050.78N/11419.05E>AURORA GPS 4G
  新： BH6RGQ-15>APRGQ,TCPIP*:!3050.78N/11419.05E>AURORA GPS 4G
  ```

  要让「设备」显示成「极光信标」，还需把 `APRGQ` 登记到软件标识表（aprs.fi 侧数据，
  改代码改不出来）。申请邮件文本已写在
  [docs/APRS.md](https://github.com/Honest16888/aurora-beacon/blob/main/docs/APRS.md#8-设备名aprsfi-的设备字段)，
  复制发出即可；登记通过前后都不影响上报与轨迹。

### 文档

- 补齐三张界面截图：主界面 / 图标选择 / 版权页
- 新增 `make_previews.py`：从 `decoded/res` 读取配色、圆角、间距和符号 PNG 生成预览页，
  界面改版后一条命令就能重出截图

### 安装

1. 下载 `aurora-beacon-1.4.2-aurora.apk`
2. 覆盖安装（14 天内的旧版可直接升级，设置保留）
3. 启动后确认顶部呼号为 `BH6RGQ`，点「启动上报」

签名证书 SHA-256：`5b20e07a07d3272e542a0c9d5e9d2259ce6177997daebb4f57db01f8c88153ab`
