data = (256*1024/2)*[0,1]
# print (data)

with open('table.bin', 'wb') as f:
  f.write(str(bytearray(data)))

f.close()
