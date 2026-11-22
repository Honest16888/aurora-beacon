# -*- coding: utf-8 -*-
import os, re, sys
from PIL import Image

ROOT = os.path.dirname(os.path.abspath(__file__))
PNG = os.path.join(ROOT, 'symex', 'aprs-symbols-master', 'png')
DEST = os.path.join(ROOT, 'decoded', 'res', 'drawable-nodpi')
os.makedirs(DEST, exist_ok=True)

# pick best source sprite per table
def best_sheet(table):
    for size in (64, 128, 48, 32, 24):
        p = os.path.join(PNG, 'aprs-symbols-%d-%d.png' % (size, table))
        if os.path.exists(p):
            return p
    raise SystemExit('no sheet for table %d' % table)

TABLES = [('/', 0), ('\\', 1)]
CODES = list(range(0x21, 0x7f))  # 94

made = []
for tchar, tid in TABLES:
    path = best_sheet(tid)
    im = Image.open(path).convert('RGBA')
    cols = 16
    cw = im.width // cols
    rows = im.height // cw
    print(path, im.size, 'cell', cw, 'rows', rows, 'cells', cols * rows)
    for i, code in enumerate(CODES):
        col = i % cols
        row = i // cols
        if row >= rows:
            print('!! cell out of range', code); continue
        box = (col * cw, row * cw, col * cw + cw, row * cw + cw)
        cell = im.crop(box)
        cell = cell.resize((64, 64), Image.LANCZOS)
        name = 'sym_%02x%02x.png' % (ord(tchar), code)
        cell.save(os.path.join(DEST, name))
        made.append(name)

print('written', len(made))

# test crops for visual verification
t = Image.open(os.path.join(DEST, 'sym_2f3e.png'))
t.save(os.path.join(ROOT, 'check_2f3e.png'))
t2 = Image.open(os.path.join(DEST, 'sym_2f21.png'))
t2.save(os.path.join(ROOT, 'check_2f21.png'))

# montage: first 24 symbols of primary table
sheet = Image.new('RGBA', (6 * 68, 4 * 68), (30, 30, 40, 255))
for i in range(24):
    c = Image.open(os.path.join(DEST, 'sym_%02x%02x.png' % (0x2f, 0x21 + i)))
    sheet.paste(c, ((i % 6) * 68 + 2, (i // 6) * 68 + 2), c)
sheet.save(os.path.join(ROOT, 'check_montage.png'))
print('ok')
