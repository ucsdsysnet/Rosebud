"""

Copyright (c) 2020-2021 Moein Khazraee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

"""

import re
from math import ceil

def splitter (line):
  return [x for x in re.split("\||\s+|,",line) if x]

def atoi(text):
	return int(text) if text.isdigit() else text

def natural_keys(text):
	return [atoi(c) for c in re.split('(\d+)', text)]

# extract total Gousheh resources
# LUTS, Registers, BRAM, URAM, DSP
def available (read_file):

  # vivado header per found line:
  # Site Type | Parent | Child | Non-Assigned |  Used | Fixed | Prohibited | Available | Util%

  avail = []

  with open (read_file,'r') as fh:
    while True:
      line = fh.readline()
      if line.startswith("3. CLB Logic"):
        line = fh.readline()
        if line.startswith("------------"):
          break

    while True:
      line = fh.readline()
      if line.startswith("| CLB LUTs"):
        avail.append(int(splitter(line[10:])[6]))
      elif line.startswith("| CLB Registers"):
        avail.append(int(splitter(line[15:])[6]))
        break

    while True:
      line = fh.readline()
      if line.startswith("5. BLOCKRAM"):
        break

    while True:
      line = fh.readline()
      if line.startswith("| Block RAM Tile" ):
        avail.append(int(splitter(line[17:])[6]))
      elif line.startswith("| URAM"):
        avail.append(int(splitter(line[6:])[6]))
      elif line.startswith("| DSPs"):
        avail.append(int(splitter(line[6:])[6]))
        break
  return avail

# extract first level modules
# def extract (read_file,modules,avg,tot,avg_p,tot_p):
def extract (read_file, modules, count):
  LUT       = 0
  LGCLUT    = 0
  LUTRAM    = 0
  SRL       = 0
  FF        = 0
  RAMB36    = 0
  RAMB18    = 0
  URAM      = 0
  DSP       = 0

  LUT_P     = 0.0
  LGCLUT_P  = 0.0
  LUTRAM_P  = 0.0
  SRL_P     = 0.0
  FF_P      = 0.0
  RAMB36_P  = 0.0
  RAMB18_P  = 0.0
  URAM_P    = 0.0
  DSP_P     = 0.0

  # Vivado report header
  # ['Instance', 'Module', 'PR Attribute', 'Total PPLOCs', 'Total LUTs', 'Logic LUTs',\
  #  'LUTRAMs', 'SRLs', 'FFs', 'RAMB36', 'RAMB18', 'URAM', 'DSP48 Blocks']

  for line in open (read_file,'r'):
    for m in modules:
      if re.match("^\|"+m,line):
        data = splitter(line)
        # print (data)
        data = [re.split("\(|\)|%",x) for x in data] # separate % values
        data = [(float(x[0]),float(x[1])) if len(x)==4 else x[0] for x in data]

        LUT    += data[4][0]
        LGCLUT += data[5][0]
        LUTRAM += data[6][0]
        SRL    += data[7][0]
        FF     += data[8][0]
        RAMB36 += data[9][0]
        RAMB18 += data[10][0]
        URAM   += data[11][0]
        DSP    += data[12][0]

        LUT_P    += data[4][1]
        LGCLUT_P += data[5][1]
        LUTRAM_P += data[6][1]
        SRL_P    += data[7][1]
        FF_P     += data[8][1]
        RAMB36_P += data[9][1]
        RAMB18_P += data[10][1]
        URAM_P   += data[11][1]
        DSP_P    += data[12][1]

  avg_p = [LUT_P/count, LGCLUT_P/count, LUTRAM_P/count, SRL_P/count, \
           FF_P/count, RAMB36_P/count, RAMB18_P/count, URAM_P/count, DSP_P/count]
  avg   = [ceil(LUT/count), ceil(LGCLUT/count), ceil(LUTRAM/count), ceil(SRL/count), \
           ceil(FF/count), ceil(RAMB36/count), ceil(RAMB18/count), ceil(URAM/count), \
           ceil(DSP/count)]
  tot_p = [LUT_P, LGCLUT_P, LUTRAM_P, SRL_P, FF_P, RAMB36_P, RAMB18_P, URAM_P, DSP_P]
  tot   = [int(LUT), int(LGCLUT), int(LUTRAM), int(SRL), int(FF), \
           int(RAMB36), int(RAMB18), int(URAM), int(DSP)]

  return (avg, tot, avg_p, tot_p)
