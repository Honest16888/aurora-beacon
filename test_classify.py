# -*- coding: utf-8 -*-
"""countryOf/kindOf 逻辑复刻自测（与 Java 实现同规则）。"""
import io
import re

RULES = [
    ("VR", "香港"), ("XX", "澳门"),
    ("JA", "日本"), ("JE", "日本"), ("JF", "日本"), ("JG", "日本"), ("JH", "日本"),
    ("JI", "日本"), ("JJ", "日本"), ("JK", "日本"), ("JL", "日本"), ("JM", "日本"),
    ("JN", "日本"), ("JO", "日本"), ("JP", "日本"), ("JQ", "日本"), ("JR", "日本"),
    ("JS", "日本"), ("7J", "日本"), ("7N", "日本"),
    ("HL", "韩国"), ("DS", "韩国"), ("DT", "韩国"),
    ("9V", "新加坡"), ("9M", "马来西亚"), ("3W", "越南"),
    ("HS", "泰国"), ("E2", "泰国"),
    ("DU", "菲律宾"), ("DV", "菲律宾"), ("DW", "菲律宾"), ("DX", "菲律宾"),
    ("DY", "菲律宾"), ("DZ", "菲律宾"),
    ("YB", "印尼"), ("YC", "印尼"), ("YD", "印尼"), ("YE", "印尼"),
    ("YF", "印尼"), ("YG", "印尼"), ("YH", "印尼"),
    ("UA", "俄罗斯"), ("UB", "俄罗斯"), ("UC", "俄罗斯"), ("UD", "俄罗斯"),
    ("UE", "俄罗斯"), ("UF", "俄罗斯"), ("UG", "俄罗斯"), ("UH", "俄罗斯"),
    ("UI", "俄罗斯"),
    ("VK", "澳大利亚"), ("VL", "澳大利亚"), ("ZL", "新西兰"),
    ("ON", "比利时"),
    ("PA", "荷兰"), ("PB", "荷兰"), ("PC", "荷兰"), ("PD", "荷兰"), ("PE", "荷兰"),
    ("PF", "荷兰"), ("PG", "荷兰"), ("PH", "荷兰"), ("PI", "荷兰"),
    ("LA", "挪威"), ("LB", "挪威"), ("LC", "挪威"), ("LD", "挪威"), ("LE", "挪威"),
    ("LF", "挪威"), ("LG", "挪威"), ("LH", "挪威"), ("LI", "挪威"), ("LJ", "挪威"),
    ("LK", "挪威"), ("LL", "挪威"), ("LM", "挪威"), ("LN", "挪威"),
    ("SA", "瑞典"), ("SB", "瑞典"), ("SC", "瑞典"), ("SD", "瑞典"), ("SE", "瑞典"),
    ("SF", "瑞典"), ("SG", "瑞典"), ("SH", "瑞典"), ("SI", "瑞典"), ("SJ", "瑞典"),
    ("SK", "瑞典"), ("SL", "瑞典"), ("SM", "瑞典"),
    ("OZ", "丹麦"), ("OX", "丹麦"), ("SP", "波兰"), ("SQ", "波兰"),
    ("OK", "捷克"), ("OL", "捷克"), ("HB", "瑞士"), ("OE", "奥地利"),
    ("CT", "葡萄牙"), ("CU", "葡萄牙"), ("SV", "希腊"), ("SW", "希腊"),
    ("SZ", "希腊"), ("PP", "巴西"), ("PY", "巴西"),
    ("G", "英国"), ("M", "英国"), ("2E", "英国"),
    ("W", "美国"), ("K", "美国"), ("N", "美国"), ("A", "美国"),
    ("F", "法国"), ("I", "意大利"), ("D", "德国"), ("E", "西班牙"),
    ("R", "俄罗斯"), ("B", "中国大陆"),
]


def country_of(call):
    base = call.split("-")[0].upper()
    for k, v in RULES:
        if base.startswith(k):
            return v
    return "其他"


s = io.open('decoded/res/values/arrays.xml', encoding='utf-8').read()
m = re.search(r'<string-array name="symbol_labels">(.*?)</string-array>', s, re.S)
LABELS = [x.replace('\\\\', '').strip() for x in re.findall(r'<item>(.*?)</item>', m.group(1), re.S)]


def label_of(table, sym):
    code = ord(sym)
    if code < 0x21 or code > 0x7e:
        return ""
    idx = code - 0x21
    if table == "\\":
        idx += 94
    return LABELS[idx] if 0 <= idx < len(LABELS) else ""


def has(text, *keys):
    return any(k in text for k in keys)


def kind_of(dti, table, sym, dest, comment):
    if comment and ("APRSLocus" in comment or "FMO" in comment):
        return "FMO"
    if dti == ";":
        return "对象"
    label = label_of(table, sym)
    if has(label, "气象", "雨", "雪"):
        return "气象"
    if has(label, "警察", "消防", "救护", "中继", "信标", "网关", "集群", "存储", "雷达"):
        return "专业站"
    if has(label, "飞机", "直升", "气球", "卫星", "航天", "机场"):
        return "航空"
    if has(label, "船", "帆", "快艇", "潜艇"):
        return "船舶"
    if has(label, "车", "摩托", "自行", "步行", "火车", "人"):
        return "移动"
    if has(label, "住宅", "房屋", "家", "学校", "教堂", "俱乐部", "建筑", "公园", "邮局", "天线", "塔"):
        return "固定站"
    if dti in "'`":
        return "移动"
    if dest and dest.startswith("APZ"):
        return "App"
    return "电台"


ok = fail = 0


def eq(name, got, want):
    global ok, fail
    if got == want:
        print('OK  ', name, '->', got)
        ok += 1
    else:
        print('FAIL', name, 'got', got, 'want', want)
        fail += 1


for call, want in [
    ("BH8WWP-12", "中国大陆"), ("BG6STN", "中国大陆"), ("JA1ABC-9", "日本"),
    ("W1AW", "美国"), ("VR2HK", "香港"), ("HL2ABC", "韩国"),
    ("DL1ABC", "德国"), ("DS1ABC", "韩国"), ("E2ABC", "泰国"),
    ("DU0ABC", "菲律宾"), ("UA3ABC", "俄罗斯"), ("ZL1ABC", "新西兰"),
    ("F5ABC", "法国"), ("9V1ABC", "新加坡"), ("XX8ABC", "澳门"),
    ("XY9ZZ", "其他"),
]:
    eq("country " + call, country_of(call), want)

# kind：用真实标签核对
eq("kind 汽车 />", kind_of('!', '/', '>', 'APRS', ''), "移动")
eq("kind 气象站 /_", kind_of('!', '/', '_', 'APRS', ''), "气象")
eq("kind 警察 /!", kind_of('!', '/', '!', 'APRS', ''), "专业站")
eq("kind 数字中继 /#", kind_of('!', '/', '#', 'APRS', ''), "专业站")
eq("kind 房屋 /-", kind_of('!', '/', '-', 'APRS', ''), "固定站")
eq("kind 小飞机 /'", kind_of('!', '/', "'", 'APRS', ''), "航空")
eq("kind Mic-E 移动", kind_of('\'', '/', '>', 'TY2P0P', ''), "移动")
eq("kind 对象 ;", kind_of(';', '/', '>', 'APRS', ''), "对象")
eq("kind FMO 备注", kind_of('!', '/', '>', 'APRS', 'APRSLocus v1.2'), "FMO")
eq("kind 未知", kind_of('!', '/', '~', 'APRS', ''), "电台")

print('\n== pass %d / fail %d ==' % (ok, fail))
