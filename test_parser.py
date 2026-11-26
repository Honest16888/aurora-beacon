# -*- coding: utf-8 -*-
"""与 java/.../NearbyQuery.java 同逻辑的解析自测（非压缩/时间戳/压缩/Mic-E/模糊位）。"""
import math
import re

NORMAL = re.compile(r'^(\d{2})([0-9 ]{2}\.[0-9 ]{2})([NnSs])([/\\0-9A-Z])'
                    r'(\d{3})([0-9 ]{2}\.[0-9 ]{2})([EeWw])([\x21-\x7e])(.*)$', re.S)
MICE_DEST = re.compile(r'^[0-9A-Z]{3}[0-9L-Z]{3}$')
MICE_TEL = re.compile(r"^('[0-9a-fA-F]{10}|`[0-9a-fA-F]{4})")
ALT = re.compile(r'/A=(-?\d{5,6})')
CST = re.compile(r'^\s*\d{3}/\d{2,3}(?![0-9])')


def clean_comment(c):
    if c is None:
        return ""
    s = ALT.sub("", c)
    s = CST.sub("", s)
    return s.strip()


def b91(s):
    n = 0
    for ch in s:
        o = ord(ch)
        if o < 0x21 or o > 0x7b:
            return -1
        n = n * 91 + (o - 33)
    return n


def parse_normal(s):
    m = NORMAL.match(s)
    if not m:
        return None
    lat_min, lon_deg, lon_min = m.group(2), m.group(5), m.group(6)
    lat_dir, lon_dir = m.group(3), m.group(7)
    amb_lat, amb_lon = lat_min.count(' '), lon_min.count(' ')
    if amb_lat != amb_lon:
        return None
    if amb_lat >= 4:
        lat_min, lon_min = "30", "30"
    elif amb_lat > 0:
        lat_min = lat_min.replace(' ', '5')
        lon_min = lon_min.replace(' ', '5')
    try:
        la = float(lat_min); lo = float(lon_min)
        lat_d = float(m.group(1)); lon_d = float(lon_deg)
    except ValueError:
        return None
    if la >= 60 or lo >= 60 or lat_d > 89 or lon_d > 179:
        return None
    lat = lat_d + la / 60.0
    lon = lon_d + lo / 60.0
    if lat_dir.lower() == 's':
        lat = -lat
    if lon_dir.lower() == 'w':
        lon = -lon
    return (lat, lon, clean_comment(m.group(9)))


def parse_compressed(s):
    if len(s) < 13:
        return None
    c0 = s[0]
    if not (c0 in '/\\' or ('A' <= c0 <= 'Z') or ('a' <= c0 <= 'j')):
        return None
    for i in range(1, 9):
        if not (0x21 <= ord(s[i]) <= 0x7c):
            return None
    if not (0x21 <= ord(s[9]) <= 0x7d):
        return None
    for i in range(10, 13):
        if not (0x20 <= ord(s[i]) <= 0x7c):
            return None
    lat_n, lon_n = b91(s[1:5]), b91(s[5:9])
    if lat_n < 0 or lon_n < 0:
        return None
    lat = 90 - lat_n / 380926.0
    lon = -180 + lon_n / 190463.0
    if not (-90 <= lat <= 90 and -180 <= lon <= 180):
        return None
    return (lat, lon, clean_comment(s[13:]))


def parse_mice(dest_field, body):
    dest0 = dest_field.split(",")[0]
    dest = dest0.split("-")[0]
    if len(dest) != 6 or not MICE_DEST.match(dest):
        return None
    info = body[1:]
    if len(info) < 8:
        return None
    sb = []
    for ch in dest:
        o = ord(ch)
        if ch in 'KLZ':
            sb.append(' ')
        elif o > 76:
            sb.append(chr(o - 32))
        elif o > 57:
            sb.append(chr(o - 17))
        else:
            sb.append(ch)
    ds = ''.join(sb)
    amb = 0
    i = 6
    while i > 0 and ds[i - 1] == ' ':
        amb += 1
        i -= 1
    if any(not d.isdigit() for d in ds[:i]):
        return None
    dl = list(ds)
    if amb >= 4 and amb > 0:
        dl[2] = '3'
    elif amb > 0:
        dl[6 - amb] = '5'
    d = ''.join(dl)
    try:
        lat_min = float(d[2:4] + '.' + d[4:6].replace(' ', '0'))
        lat = int(d[0:2]) + lat_min / 60.0
    except ValueError:
        return None
    if dest[3] <= 'L':
        lat = -lat
    lon = ord(info[0]) - 28
    if dest[4] >= 'P':
        lon += 100
    if 180 <= lon <= 189:
        lon -= 80
    if 190 <= lon <= 199:
        lon -= 190
    lon_min = ord(info[1]) - 28
    if lon_min >= 60:
        lon_min -= 60
    lon_min += (ord(info[2]) - 28) / 100.0
    if amb == 4:
        lon_min = 30
    elif amb == 3:
        lon_min = (math.floor(lon_min / 10) + 0.5) * 10
    elif amb == 2:
        lon_min = math.floor(lon_min) + 0.5
    elif amb == 1:
        lon_min = (math.floor(lon_min * 10) + 0.5) / 10.0
    lon = lon + lon_min / 60.0
    if dest[5] >= 'P':
        lon = -lon
    if not (-90 <= lat <= 90 and -180 <= lon <= 180):
        return None
    rest = info[8:]
    t = MICE_TEL.match(rest)
    if t:
        rest = rest[t.end():]
    if rest[:1] in (']', '}'):
        rest = rest[1:]
    return (lat, lon, clean_comment(rest))


def parse_body(body, dest_field):
    dti = body[0]
    if dti in "'`":
        return parse_mice(dest_field, body)
    if dti not in '!=/@':
        return None
    s = body[1:]
    if dti in '/@':
        if len(s) < 8:
            return None
        s = s[7:]
    if not s:
        return None
    c = parse_compressed(s)
    return c if c else parse_normal(s)


def parse(line):
    gt = line.find('>')
    if gt <= 0:
        return None
    call = line[:gt].strip()
    if not call:
        return None
    colon = line.find(':', gt)
    if colon < 0:
        return None
    dest = line[gt + 1:colon]
    body = line[colon + 1:]
    if not body:
        return None
    return parse_body(body, dest)


def b91enc(n, width):
    chars = []
    for _ in range(width):
        chars.append(chr(n % 91 + 33))
        n //= 91
    return ''.join(reversed(chars))


def enc_compressed(lat, lon, table='/', sym='>'):
    # 权威依据 aprslib parsing/position.py：固定段 13 字符，
    # lat = compressed[1:5]（4位），lon = compressed[5:9]（4位）
    lat_n = int(round((90 - lat) * 380926))
    lon_n = int(round((lon + 180) * 190463))
    return table + b91enc(lat_n, 4) + b91enc(lon_n, 4) + sym + '!!' + '!'


def build_mice(lat, lon, info_sym='>', info_table='/'):
    """按解码算法的逆过程构造 Mic-E 报文（仅测试用，东经/北纬）。"""
    assert lat > 0 and lon > 0
    alat, alon = abs(lat), abs(lon)
    deg = int(alat)
    minutes = (alat - deg) * 60
    ss = int(round((minutes - int(minutes)) * 100))
    if ss >= 100:
        ss = 99
    dstr = '%02d%02d%02d' % (deg, int(minutes), ss)   # ddmmss 六位
    digits = dstr[:6]
    out = []
    for idx, ch in enumerate(digits):
        n = int(ch)
        if idx <= 2:
            out.append(chr(65 + n))       # A-J → 0-9（组1允许 [0-9A-Z]）
        elif idx == 3:
            out.append(chr(80 + n) if lat > 0 else chr(48 + n))   # 北纬 P-Y(>L) / 南纬 '0'-'9'(<=L)
        elif idx == 4:
            out.append(chr(48 + n))       # 东经：<'P' → 不加 100
        else:
            out.append(chr(48 + n))
    dest = ''.join(out)
    if not MICE_DEST.match(dest):
        return None, 'dest invalid: ' + dest
    ilon = int(alon)
    info0 = ilon + 28                     # 无偏移（dest[4] < 'P'）
    lmin = (alon - ilon) * 60
    info1 = int(lmin) + 28
    if info1 - 28 >= 60:
        info1 -= 60
    frac = round((lmin - int(lmin)) * 100)
    info2 = frac + 28
    info = (chr(info0) + chr(info1) + chr(info2)
            + chr(28) + chr(28) + chr(28)   # speed/course 位
            + info_sym + info_table)
    body = "'" + info + "测试Mic-E"
    # Mic-E：编码后的目的呼号在 >之前，源呼号随便写
    return ("BG6STN>" + dest + ",TCPIP*:" + body), None


ok = fail = 0


def check(name, got, want, tol=0.002):
    global ok, fail
    if got is None:
        print('FAIL', name, '-> None')
        fail += 1
        return
    if abs(got[0] - want[0]) < tol and abs(got[1] - want[1]) < tol:
        print('OK  ', name, '-> %.4f, %.4f  cmt=%r' % (got[0], got[1], got[2]))
        ok += 1
    else:
        print('FAIL', name, 'got', got[:2], 'want', want)
        fail += 1


# 1) 非压缩
check('uncompressed', parse('BD7KFN-9>APRS,TCPIP*:!3030.50N/11419.05E>车上'),
      (30 + 30.50 / 60, 114 + 19.05 / 60))

# 2) 带时间戳 /  (跳过 7 字符)
check('timestamped', parse('BG6STN>APRS,TCPIP*:/061930z3050.78N/11415.00E>hello'),
      (30 + 50.78 / 60, 114 + 15.0 / 60))

# 3) 压缩往返
target = (30.8463, 114.3175)
pkt = 'BG6STN>APRS,TCPIP*:!' + enc_compressed(*target) + '/A=001234 测试'
r = parse(pkt)
check('compressed', r, target)
print('   raw =', enc_compressed(*target))

# 4) 压缩 + 时间戳 @
pkt2 = 'BG6STN>APRS,TCPIP*:@061930z' + enc_compressed(*target)[0:] 
# @ 后是时间戳+压缩体：body='@'+ts+compressed
pkt2 = 'BG6STN>APRS,TCPIP*:@061930z' + enc_compressed(*target) + 'cs'
check('compressed+timestamp', parse(pkt2), target)

# 5) 模糊位（lat/lon 各 1 个空格，中心取 5）
check('ambiguity', parse('BG6STN>APRS,TCPIP*:!3050. 8N/11419. 5E>x'),
      (30 + 50.58 / 60, 114 + 19.55 / 60))

# 6) Mic-E 往返
mice, err = build_mice(30.8463, 114.3175)
if err:
    print('SKIP mic-e build:', err)
else:
    print('   mic-e pkt =', mice.encode('unicode_escape').decode('ascii'))
    check('mic-e', parse(mice), (30.8463, 114.3175), tol=0.01)

# 7) 位置包拒绝
print('reject status :', parse('X1>APRS::BG6STN   :hi{01'))       # 消息不是位置包
print('reject no-pos :', parse('X1>APRS:>status text'))

print('\n== pass %d / fail %d ==' % (ok, fail))
