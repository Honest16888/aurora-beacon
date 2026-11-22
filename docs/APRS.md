# APRS / APRS-IS 参考

本文件说明极光信标实际发给 APRS-IS 的内容，以及自己想写客户端/抓包核对时需要的知识。

## 1. 一次上报的完整报文

```
BH6RGQ-15>APRGQ,TCPIP*:!3050.78N/11419.05E>汽车 在二环
```

| 字段 | 值 | 说明 |
|---|---|---|
| 源地址 | `BH6RGQ-15` | 呼号 + SSID（`0–15`） |
| 目的地址（TOCALL） | `APRGQ` | 软件标识，见 [§8](#8-设备名aprsfi-的设备字段)；必须是 `AP` 前缀 |
| 路径 | `TCPIP*` | 已由 APRS-IS 服务器注入（`*` 表示已中继）；直连 APRS-IS 不要写 RF 路径 |
| DTI | `!` | 位置报文，无时间戳（`/` 也可以是时间戳格式，本项目不用） |
| 纬度 | `3050.78N` | `ddmm.mmN`：30°50.78′N |
| 符号表 | `/` | `/`=主表，`\`=副表 |
| 经度 | `11419.05E` | `dddmm.mmE`：114°19.05′E |
| 符号码 | `>` | 与符号表组成图标（`/>`=汽车） |
| 备注 | `汽车 在二环` | 最长 40 字符（本项目限制）；UTF-8 |

### 备注的自动模式

备注留空时，App 自动生成：

```
AURORA <定位源> <网络> <电量>
```

例如：`AURORA GPS 中国移动 4G 82%`。
填写自定义备注后完全覆盖自动内容（可能是"呼号 + 位置 + 状态"这类无线电礼仪写法）。

### 坐标精度

`ddmm.mm` 的两位小数 = 0.01 分 ≈ **18.5 米**（纬度）/ 约 15–18 米（经度，随纬度变化）。
这是 APRS 非压缩格式的固有精度，不是本项目截断的。

## 2. APRS 校验码（passcode）

```
passcode = (hash & 0x7fff),  hash 初值 0x73e2
对呼号（大写、不含 SSID）逐字符：
  下标为偶数：hash ^= (char << 8)
  下标为奇数：hash ^= char
```

Java：

```java
static int passcode(String call) {
    String c = call.toUpperCase();          // SSID 不参与计算
    int hash = 0x73e2;
    for (int i = 0; i < c.length(); i++) {
        hash ^= (i % 2 == 0) ? (c.charAt(i) << 8) : c.charAt(i);
    }
    return hash & 0x7fff;
}
```

样例：

| 呼号 | passcode |
|---|---|
| `N0CALL` | `13023` |
| `BH6RGQ` | 由 App 顶部胶囊显示（点一下可复制） |

> 这个数字**不是加密**，只是防止匿名灌包的弱校验；对上密码就等于"声称自己是这个呼号"，
> 所以别把别人的呼号填进去。

## 3. 连接与登录

```
$ nc rotate.aprs2.net 14580
user BH6RGQ-15 pass 12345 vers AuroraBeacon 1.4.1

# server 返回
# aprsc 2.1.15-g3bf7b0a
# logresp BH6RGQ-15 verified, server T2ROTATE
```

登录行格式：`user <call-ssid> pass <passcode> vers <软件名> <版本>`

未通过校验（密码错）时服务器返回 `unverified`，此时**只能收，不能发**——表现就是
"App 显示在跑，aprs.fi 上却没有我"。这是最常见的问题。

### 本项目内置的服务器

| 显示名 | 主机 |
|---|---|
| 全球 | `rotate.aprs2.net` |
| 亚洲 | `asia.aprs2.net` |
| 欧洲 | `euro.aprs2.net` |
| 北美 | `noam.aprs2.net` |
| 大洋洲 | `oceania.aprs2.net` |

端口默认 `14580`（可发可收的全双工端口）。`14580` 之外的常用端口：`14580` 过滤端口、
`10152` 只读、`23` telnet。

## 4. 上报速率与礼仪

APRS-IS 不是遥测通道，请遵守社区惯例：

- **固定台 ≤ 每 30 分钟一次**；移动台按速度 1–5 分钟；本项目默认 **60 秒**，静止时也建议 ≥ 60 秒
- 不要用 `WIDE1-1,WIDE2-2` 这类 RF 路径直连 APRS-IS（会被服务器丢弃）；本项目固定 `TCPIP*`
- 不要伪造他人呼号；不要发与位置无关的广播
- 详细规则：<http://www.aprs-is.net/>

## 5. 符号（Symbol）

- 主表 94 个（ASCII `!`(0x21) … `~`(0x7E)），副表 94 个，共 **188**
- 索引公式：`index = code - 0x21`
- 常用：`/>` 汽车、`/v` 货车、`/[` 行人、`/b` 自行车、`/-` 房屋、`/_` 气象站、
  `/S` 航天飞机、`\>` 汽车（副表）、`/!` 警车
- 图形来源：aprs.fi symbol set（CC BY 4.0），见 [NOTICE](../NOTICE)

## 6. 自己核对报文

**方式 A：aprs.fi**

```
https://aprs.fi/?callsign=BH6RGQ-15
```

点某个点位的「info」可看到原始报文（Raw packet），与 App 里显示的一致即可。

**方式 B：直连 APRS-IS 观察**

```bash
# 只读观察（用 -1 表示只收不发）
nc rotate.aprs2.net 14580
user N0CALL pass -1 vers test 1.0
filter m/200          # 以某点为中心 200km 范围
```

**方式 C：本地假服务器**

把 App 的服务器改成你的机器 IP、端口 `14580`，用 `nc -l 14580` 接收，
就能看到 App 发出的原始报文（含登录行），便于排查格式问题。
（注意：手机与电脑需同一网段，且电脑防火墙放行。）

## 7. 常见协议层面"看不到我"的原因

| 现象 | 原因 |
|---|---|
| 服务器返回 `unverified` | 密码错（呼号写错、用了别人的密码、呼号带 SSID 计算） |
| 报文发出但 aprs.fi 无点 | 位置格式非法（纬度分钟 ≥ 60、经度 > 180）、符号表不是 `/` 或 `\` |
| 点位在但不动 | 位置没更新（GPS 无信号、定位权限被拒、间隔太长） |
| 点位乱跳 | 基站/网络定位精度差（精度 = 数百米～数公里），属正常 |
| 点位过几小时消失 | aprs.fi 的显示时间窗（默认 3 小时）——用 `timerange` 参数调整 |
| 被服务器踢 | 上报过快（< 30 秒）、重复包、路径写了 RF 路径 |

## 8. 设备名（aprs.fi 的「设备」字段）

aprs.fi 站点页上的 **Device / 设备** 一行，**只取决于报文的 TOCALL（目的地址）**，
它拿 TOCALL 去查一张软件登记表，查不到就显示 `Unknown: Unknown`。

所以：

| 报文目的地址 | aprs.fi 显示 |
|---|---|
| `APRS`（泛用，旧版用的就是这个） | `Unknown: Unknown` |
| `APRGQ`（本版，未登记） | 仍可能显示 Unknown，但报文里已带专属标识 |
| `APRGQ`（**已登记**后） | `极光信标 (APRGQ)` 或登记表里的名称 |

改代码无法凭空让 aprs.fi 认识一个新软件——需要把 TOCALL **登记到软件标识表**里
（aprs.fi 会同步这张表）。本项目的申请文本已经写好，直接发出去即可：

> **收件人**：Hessu（aprs.fi 作者，OH7LZB）— `hessu@aprs.fi`，
> 或发到 aprs.fi 的 Google Group。
>
> **主题**：New TOCALL registration request: APRGQ
>
> **正文**：
>
> ```
> Hello,
>
> I would like to register a new TOCALL for an open-source Android APRS-IS
> client, so that aprs.fi shows a proper device name instead of "Unknown".
>
>   TOCALL      : APRGQ
>   Software    : Aurora Beacon (极光信标)
>   Description : Android APRS-IS position beacon; uploads position reports
>                 to APRS-IS over TCP (no RF), 188 APRS symbols, glass UI.
>   Author      : BH6RGQ
>   Source code : https://github.com/Honest16888/aurora-beacon
>   License     : Apache-2.0
>   Example pkt : BH6RGQ-15>APRGQ,TCPIP*:!3050.78N/11419.05E>AURORA GPS 4G
>
> Please add it to the APRS device identification list.
>
> 73, BH6RGQ
> ```

登记通过前，别人看到的设备名仍是 Unknown —— 这属于 aprs.fi 侧的数据，不是报文错误；
报文的其它部分（呼号、位置、符号、备注）都是正常的。

