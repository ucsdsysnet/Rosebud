data = (256*1024/8)*[1,0,0,0,0,0,0,0]
# print (data)
with open('table.bin', 'wb') as f:
  f.write(str(bytearray(data)))
f.close()

data = (32*1024)*[0]
with open('empty_dmem.bin', 'wb') as f:
  f.write(str(bytearray(data)))
f.close()

data = (1024*1024)*[0]
with open('empty_pmem.bin', 'wb') as f:
  f.write(str(bytearray(data)))
f.close()
