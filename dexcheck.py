# -*- coding: utf-8 -*-
"""Minimal DEX reader: list method refs matching a filter, proving which
owner class a name was resolved against."""
import struct, sys, zipfile, io

def uleb(data, off):
    result = 0
    shift = 0
    while True:
        b = data[off]
        off += 1
        result |= (b & 0x7f) << shift
        if not (b & 0x80):
            return result, off
        shift += 7

def read_dex(data):
    (magic, checksum, sig,
     file_size, header_size, endian,
     link_size, link_off, map_off,
     string_ids_size, string_ids_off,
     type_ids_size, type_ids_off,
     proto_ids_size, proto_ids_off,
     field_ids_size, field_ids_off,
     method_ids_size, method_ids_off,
     class_defs_size, class_defs_off,
     data_size, data_off) = struct.unpack_from('<8sI20s' + 'I' * 20, data, 0)
    print('magic', magic, 'file_size', file_size, 'strings', string_ids_size, 'methods', method_ids_size)

    strings = []
    for i in range(string_ids_size):
        off = struct.unpack_from('<I', data, string_ids_off + 4 * i)[0]
        # uleb128 utf16 length then MUTF-8 bytes
        _, p = uleb(data, off)
        end = data.index(b'\x00', p)
        strings.append(data[p:end].decode('utf-8', 'replace'))

    types = []
    for i in range(type_ids_size):
        idx = struct.unpack_from('<I', data, type_ids_off + 4 * i)[0]
        types.append(strings[idx])

    methods = []
    for i in range(method_ids_size):
        cls_idx, proto_idx, name_idx = struct.unpack_from('<HHI', data, method_ids_off + 8 * i)
        methods.append((types[cls_idx], strings[name_idx]))
    return methods, types

def main():
    apk = sys.argv[1]
    data = zipfile.ZipFile(apk).read('classes.dex')
    methods, types = read_dex(data)
    print('method refs:', len(methods), 'types:', len(types))
    hits = [(c, n) for c, n in methods if n == 'getChildAt']
    print('getChildAt owners:', [c for c, n in hits])
    for target in ('Lcom/yg/aprs/SymbolAdapter;', 'Lcom/yg/aprs/MainActivity;'):
        print(target, 'in type table:', target in types)
    # all refs whose owner is one of our own classes
    own = sorted(set(c for c, n in methods if c.startswith('Lcom/yg/aprs/')))
    print('own owner classes:', len(own), own[:12])

if __name__ == '__main__':
    main()
