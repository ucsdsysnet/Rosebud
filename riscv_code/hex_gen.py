#!/usr/bin/python3

import sys
from optparse import OptionParser

if __name__ == '__main__':
  parser = OptionParser() # option_class=eng_option, usage=usage)
  parser.add_option("-i", "--NAME", type="string", default="default.bin", help="input binary file name, [default=default.bin]")
  parser.add_option("-w", "--WIDTH", type="int", default=64, help="line width in bits, [default=64]")
  (options, args) = parser.parse_args()

  BYTE_COUNT = int(options.WIDTH/8)
  ins = bytearray(open(options.NAME, "rb").read())

  remainder = (len(ins)%BYTE_COUNT)
  if (remainder!=0):
    to_add = BYTE_COUNT-remainder
    ins[len(ins):len(ins)+to_add] = to_add*[0]

  for i in range (0,len(ins),BYTE_COUNT):
    print (''.join(format(x, '02x') for x in ins[i:i+BYTE_COUNT][::-1]))
