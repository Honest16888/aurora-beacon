# -*- coding: utf-8 -*-
"""Inject a second dex file (classes2.dex) into a built APK, then the caller
runs zipalign + apksigner."""
import io, sys, os, zipfile

src = sys.argv[1]
dex = sys.argv[2]
dst = sys.argv[3]
extra_name = sys.argv[4] if len(sys.argv) > 4 else 'classes2.dex'

with zipfile.ZipFile(src) as zin:
    infos = zin.infolist()
    names = set(i.filename for i in infos)
    if extra_name in names:
        raise SystemExit('already contains ' + extra_name)
    with zipfile.ZipFile(dst, 'w') as zout:
        for info in infos:
            data = zin.read(info.filename)
            ni = zipfile.ZipInfo(info.filename, date_time=info.date_time)
            ni.compress_type = info.compress_type
            ni.external_attr = info.external_attr
            ni.create_system = info.create_system
            zout.writestr(ni, data)
        with open(dex, 'rb') as f:
            blob = f.read()
        zout.writestr(extra_name, blob, compress_type=zipfile.ZIP_STORED)
print('injected', extra_name, len(blob), 'bytes ->', dst)
