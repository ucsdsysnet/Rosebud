#!/usr/bin/env python3

data = (256*1024//8)*[1,0,0,0,0,0,0,0]
# print (data)
with open('table.bin', 'wb') as f:
    f.write(bytes(data))
f.close()

data = (256*1024//4)*[1,0,0,0]
with open('table_qtr1.bin', 'wb') as f:
    f.write(bytes(data))
f.close()

data = (32*1024)*[0]
with open('empty_dmem.bin', 'wb') as f:
    f.write(bytes(data))
f.close()

data = (1024*1024)*[0]
with open('empty_pmem.bin', 'wb') as f:
    f.write(bytes(data))
f.close()
