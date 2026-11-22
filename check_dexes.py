# -*- coding: utf-8 -*-
"""Check dex class definitions across all classes*.dex in an APK."""
import struct, sys, zipfile


def uleb(data, off):
    r = 0
    s = 0
    while True:
        b = data[off]
        off += 1
        r |= (b & 0x7f) << s
        if not (b & 0x80):
            return r, off
        s += 7


def parse(data):
    (magic, checksum, sig, file_size, header_size, endian, link_size, link_off,
     map_off, string_ids_size, string_ids_off, type_ids_size, type_ids_off,
     proto_ids_size, proto_ids_off, field_ids_size, field_ids_off,
     method_ids_size, method_ids_off, class_defs_size, class_defs_off,
     data_size, data_off) = struct.unpack_from('<8sI20s' + 'I' * 20, data, 0)
    strings = []
    for i in range(string_ids_size):
        off = struct.unpack_from('<I', data, string_ids_off + 4 * i)[0]
        _, p = uleb(data, off)
        end = data.index(b'\x00', p)
        strings.append(data[p:end].decode('utf-8', 'replace'))
    types = [strings[struct.unpack_from('<I', data, type_ids_off + 4 * i)[0]]
             for i in range(type_ids_size)]
    classes = [types[struct.unpack_from('<I', data, class_defs_off + 32 * i)[0]]
               for i in range(class_defs_size)]
    methods = []
    for i in range(method_ids_size):
        cls_idx, proto_idx, name_idx = struct.unpack_from('<HHI', data,
                                                          method_ids_off + 8 * i)
        methods.append((types[cls_idx], strings[name_idx]))
    return classes, methods


apk = sys.argv[1]
z = zipfile.ZipFile(apk)
dexes = sorted(n for n in z.namelist() if n.startswith('classes') and n.endswith('.dex'))
print('dex files:', dexes)
allclasses = {}
for name in dexes:
    classes, methods = parse(z.read(name))
    print(name, 'classes:', len(classes), 'method refs:', len(methods))
    allclasses[name] = classes
    if name == 'classes2.dex':
        for c in classes:
            print('  def:', c)

want = ['Lcom/yg/aprs/SymbolAdapter;', 'Lcom/yg/aprs/CrashGuard;',
        'Lcom/yg/aprs/CrashGuard$1;']
for w in want:
    holders = [n for n, cs in allclasses.items() if w in cs]
    print(w, '->', holders)

# method refs to our own classes must exist in some dex-class-def set
allset = set()
for cs in allclasses.values():
    allset.update(cs)
for name in dexes:
    classes, methods = parse(z.read(name))
    for owner, mname in methods:
        if owner.startswith('Lcom/yg/aprs/'):
            if owner not in allset:
                print('MISSING OWNER', owner, mname)
print('own-class refs checked')
