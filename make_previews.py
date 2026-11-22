# -*- coding: utf-8 -*-
"""生成界面预览 HTML（用于文档截图）。

数值全部取自 decoded/res/layout/activity_main.xml 与 drawable/*.xml，
符号图标直接用 decoded/res/drawable-nodpi/sym_*.png，标签取自 arrays.xml，
所以预览与实际界面一致。
"""
import io, os, re
from xml.sax.saxutils import escape
from html import unescape

ROOT = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(ROOT, 'docs', 'images', 'preview')
os.makedirs(OUT, exist_ok=True)

# ---------- 读取真实标签 ----------
arrays = io.open(os.path.join(ROOT, 'decoded', 'res', 'values', 'arrays.xml'),
                 encoding='utf-8').read()
m = re.search(r'<string-array name="symbol_labels">(.*?)</string-array>', arrays, re.S)
labels = [escape(unescape(re.sub(r'\\', '', x).strip())) for x in
          re.findall(r'<item>(.*?)</item>', m.group(1), re.S)]

# ---------- APRS 校验码 ----------
def passcode(call):
    h = 0x73E2
    for i, ch in enumerate(call.upper()):
        h ^= (ord(ch) << 8) if i % 2 == 0 else ord(ch)
    return h & 0x7FFF

CALL = 'BH6RGQ'
CODE = passcode(CALL)

# 主表前 10 个符号（/! /" /# /$ /% /& /' /( /) /*）
SYMS = [('/%02x' % c) for c in range(0x21, 0x21 + 12)]

def sym_png(table, code):
    return '../../../decoded/res/drawable-nodpi/sym_%02x%02x.png' % (ord(table), ord(code))

CSS = """
*{box-sizing:border-box;margin:0;padding:0}
html,body{background:#05080f}
body{font-family:"Microsoft YaHei","PingFang SC",Roboto,sans-serif;-webkit-font-smoothing:antialiased}
.phone{width:412px;position:relative;overflow:hidden;
  background:linear-gradient(315deg,#070B14 0%,#0C1B2E 50%,#061320 100%)}
.glow{position:absolute;border-radius:50%;pointer-events:none}
.g1{width:320px;height:320px;right:-90px;top:-110px;
  background:radial-gradient(circle at center,rgba(45,212,191,.34) 0%,rgba(45,212,191,.12) 45%,rgba(45,212,191,0) 70%)}
.g2{width:300px;height:300px;left:-100px;bottom:-90px;
  background:radial-gradient(circle at center,rgba(124,108,246,.30) 0%,rgba(124,108,246,.10) 45%,rgba(124,108,246,0) 70%)}
.wrap{position:relative;padding:26px 18px 22px}
.head{display:flex;align-items:center}
.title{font-size:32px;font-weight:800;color:#2DD4BF;letter-spacing:.5px;line-height:1}
.badge{font-size:14px;font-weight:800;color:#93A4BC;letter-spacing:.28em;margin-left:8px;align-self:flex-end;padding-bottom:3px}
.pill{margin-left:auto;font-family:Consolas,monospace;font-weight:700;font-size:13px;color:#2DD4BF;
  letter-spacing:.06em;background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.25);
  border-radius:100px;padding:7px 14px}
.sub{margin-top:8px;font-size:11px;color:#7B8CA6;letter-spacing:.06em}
.card{margin-top:16px;border-radius:22px;padding:14px;
  background:linear-gradient(180deg,rgba(255,255,255,.16),rgba(255,255,255,.05));
  border:1px solid rgba(255,255,255,.24)}
.card+.card{margin-top:12px}
.lab{font-size:11px;color:#8FA2BC;letter-spacing:.12em}
.row{display:flex;align-items:center;gap:10px;margin-top:8px}
.input{height:46px;border-radius:14px;background:rgba(255,255,255,.078);
  border:1px solid rgba(255,255,255,.20);display:flex;align-items:center;
  padding:0 12px;font-size:17px;color:#E8EEF6}
.input.hint{color:#5C6E88}
.grow{flex:1}
.w66{width:66px;justify-content:center}
.w86{width:86px;justify-content:center}
.w94{width:94px;justify-content:center}
.mt12{margin-top:12px}
.mt6{margin-top:6px}
.sel{height:46px;border-radius:14px;background:rgba(255,255,255,.078);
  border:1px solid rgba(255,255,255,.20);display:flex;align-items:center;padding:0 10px;gap:10px}
.sel img{width:30px;height:30px;object-fit:contain}
.sel .t{font-size:14px;color:#E8EEF6;flex:1;overflow:hidden;white-space:nowrap;text-overflow:ellipsis}
.caret{color:#93A4BC;font-size:11px}
.sthead{display:flex;align-items:center}
.sthead .lab{flex:1}
.status{font-size:12px;font-weight:700;color:#2DD4BF;background:rgba(255,255,255,.12);
  border:1px solid rgba(255,255,255,.25);border-radius:100px;padding:5px 12px}
.pos{margin-top:10px;font-family:Consolas,monospace;font-size:12px;color:#D7E3F2;line-height:1.7}
.grid{display:flex;gap:10px;margin-top:10px}
.tile{flex:1;border-radius:16px;padding:10px;
  background:linear-gradient(180deg,rgba(255,255,255,.12),rgba(255,255,255,.04));
  border:1px solid rgba(255,255,255,.18)}
.tile .k{font-size:10px;color:#7E90AB;letter-spacing:.14em}
.tile .v{font-size:13px;color:#E8EEF6;margin-top:3px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.wide{display:flex;align-items:center;gap:12px;margin-top:10px;border-radius:16px;padding:10px;
  background:linear-gradient(180deg,rgba(255,255,255,.12),rgba(255,255,255,.04));
  border:1px solid rgba(255,255,255,.18)}
.wide .k{font-size:10px;color:#7E90AB;letter-spacing:.14em}
.wide .v{margin-left:auto;font-family:Consolas,monospace;font-size:12px;color:#E8EEF6}
.btn{margin-top:16px;height:52px;border-radius:100px;display:flex;align-items:center;justify-content:center;
  font-size:16px;font-weight:800;color:#07131A;letter-spacing:.08em;
  background:linear-gradient(90deg,#2DD4BF,#25B9C9 50%,#7C6CF6)}
.link{margin-top:6px;padding:10px;text-align:center;font-size:12px;color:#2DD4BF;letter-spacing:.06em}
.foot{margin-top:2px;padding:10px 0 6px;text-align:center}
.foot .l1{font-size:11px;color:#7E90AB;letter-spacing:.04em}
.foot .l2{margin-top:3px;font-size:10px;color:#2DD4BF;letter-spacing:.10em}
.dd{margin-top:6px;border-radius:14px;background:#F21B2537;overflow:hidden;
  border:1px solid rgba(255,255,255,.22)}
.dd .item{display:flex;align-items:center;gap:10px;padding:8px 10px;background:rgba(20,28,44,.92)}
.dd .item img{width:30px;height:30px;object-fit:contain}
.dd .item .t{font-size:14px;color:#E8EEF6;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.dd .item.sel2{background:rgba(45,212,191,.16)}
.page{width:412px;padding:20px;background:linear-gradient(315deg,#070B14 0%,#0C1B2E 50%,#061320 100%)}
.page h1{font-size:15px;color:#2DD4BF;font-weight:800;letter-spacing:.04em}
.page h2{font-size:13px;color:#E8EEF6;font-weight:700;margin-top:14px}
.page p{font-size:12.5px;color:#D7E3F2;line-height:1.85;margin-top:6px}
.page .dim{color:#8FA2BC}
.page .mono{font-family:Consolas,monospace;font-size:11.5px;color:#93A4BC}
"""

def head():
    return ('<!doctype html><meta charset="utf-8"><style>%s</style>' % CSS)

# ---------------- 主界面 ----------------
main = head() + """
<div class="phone">
  <div class="glow g1"></div><div class="glow g2"></div>
  <div class="wrap">
    <div class="head">
      <div class="title">极光信标</div>
      <div class="badge">BH6RGQ</div>
      <div class="pill">%d</div>
    </div>
    <div class="sub">APRS-IS 自动定位信标 · 个人专属</div>

    <div class="card">
      <div class="lab">呼号 / SSID</div>
      <div class="row">
        <div class="input grow">BH6RGQ</div>
        <div class="input w66">15</div>
      </div>
    </div>

    <div class="card">
      <div class="row" style="margin-top:0">
        <div class="lab" style="flex:1">上报间隔（秒）</div>
        <div class="input w86" style="height:40px;font-size:15px">60</div>
      </div>
      <div class="lab mt12">APRS 图标</div>
      <div class="sel mt6">
        <img src="%s">
        <div class="t">汽车 /&gt;</div>
        <div class="caret">▼</div>
      </div>
      <div class="lab mt12">包备注（留空 = 自动状态）</div>
      <div class="input mt6" style="font-size:15px">BH6RGQ 在路上</div>
    </div>

    <div class="card">
      <div class="lab">APRS-IS 服务器</div>
      <div class="row">
        <div class="sel grow"><div class="t">亚洲 asia.aprs2.net</div><div class="caret">▼</div></div>
        <div class="input w94" style="font-size:15px">14580</div>
      </div>
    </div>

    <div class="card">
      <div class="sthead"><div class="lab">运行状态</div><div class="status">运行中</div></div>
      <div class="pos">3050.78N 11419.05E</div>
      <div class="grid">
        <div class="tile"><div class="k">定位源</div><div class="v">GPS</div></div>
        <div class="tile"><div class="k">网络</div><div class="v">中国移动 4G</div></div>
      </div>
      <div class="grid">
        <div class="tile"><div class="k">电量 / 电压</div><div class="v">82%% · 4.05V</div></div>
        <div class="tile"><div class="k">基站小区</div><div class="v">460-00-1234</div></div>
      </div>
      <div class="wide"><div class="k">最近上报</div><div class="v">21:42:07</div></div>
    </div>

    <div class="btn">停止上报</div>
    <div class="link">aprs.fi 轨迹查询 →</div>
    <div class="foot">
      <div class="l1">© 2026 BH6RGQ · 极光信标 · 保留所有权利</div>
      <div class="l2">版权 · 免责声明 · 开源许可 →</div>
    </div>
  </div>
</div>
""" % (CODE, sym_png('/', '>'))

# ---------------- 图标下拉 ----------------
rows = []
for i, code in enumerate(range(0x21, 0x21 + 9)):
    lab = labels[i]
    cls = 'item sel2' if i == 7 else 'item'
    rows.append('<div class="%s"><img src="%s"><div class="t">%s</div></div>'
                % (cls, sym_png('/', chr(code)), lab))
dropdown = head() + """
<div class="phone" style="height:915px">
  <div class="glow g1"></div><div class="glow g2"></div>
  <div class="wrap">
    <div class="head">
      <div class="title">极光信标</div>
      <div class="badge">BH6RGQ</div>
      <div class="pill">%d</div>
    </div>
    <div class="sub">APRS-IS 自动定位信标 · 个人专属</div>

    <div class="card">
      <div class="lab">呼号 / SSID</div>
      <div class="row">
        <div class="input grow">BH6RGQ</div>
        <div class="input w66">15</div>
      </div>
    </div>

    <div class="card">
      <div class="row" style="margin-top:0">
        <div class="lab" style="flex:1">上报间隔（秒）</div>
        <div class="input w86" style="height:40px;font-size:15px">60</div>
      </div>
      <div class="lab mt12">APRS 图标</div>
      <div class="sel mt6" style="border-color:rgba(45,212,191,.55)">
        <img src="%s">
        <div class="t">汽车 /&gt;</div>
        <div class="caret">▲</div>
      </div>
      <div class="dd">%s</div>
    </div>
  </div>
</div>
""" % (CODE, sym_png('/', '>'), ''.join(rows))

# ---------------- 版权页 ----------------
about = head() + """
<div class="page" style="height:915px">
  <h1>极光信标　(Aurora Beacon)</h1>
  <p class="dim">BH6RGQ 的个人 APRS-IS 定位信标</p>

  <h2>版权</h2>
  <p>© 2026 BH6RGQ。保留所有权利。</p>
  <p class="dim">本程序为个人定制的派生版本，由作者本人分发与维护。</p>

  <h2>免责声明</h2>
  <p>1. 使用前请确认你持有合法呼号，并遵守所在国家或地区的业余无线电法规、以及 APRS-IS 的使用条款（含速率与路径限制）。</p>
  <p>2. 本软件按「现状」提供，不附带任何明示或暗示的担保。因使用本软件产生的任何直接或间接损失，作者不承担责任。</p>
  <p>3. 上报的位置信息会通过 APRS-IS 公开发布，请自行判断是否适合公开。</p>
  <p>4. 请勿将本软件用于任何违法用途。</p>

  <h2>隐私</h2>
  <p>本软件不收集、不上传个人信息；设置仅保存在本机，仅按照你配置的服务器与间隔发送位置与状态。</p>

  <h2>第三方组件与致谢</h2>
  <p class="mono">· Material Components for Android — Apache License 2.0<br>
  · AndroidX — Apache License 2.0<br>
  · Kotlin / kotlinx.coroutines — Apache License 2.0<br>
  · APRS 符号图形 — aprs.fi symbol set (Heikki Hannikainen, OH7LZB), CC BY 4.0<br>
  · APRS-IS 网络 — 由全球爱好者共同维护</p>

  <h2>运行环境</h2>
  <p class="mono">· Android 14 (API 34)<br>· 版本 1.4.2-aurora</p>
</div>
"""

for name, html in (('main.html', main), ('symbols.html', dropdown), ('about.html', about)):
    io.open(os.path.join(OUT, name), 'w', encoding='utf-8', newline='\n').write(html)
    print('wrote', name, len(html), 'bytes')
print('passcode(%s) = %d' % (CALL, CODE))
