/*

Copyright (c) 2021 Moein Khazraee

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

*/

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>

#include "mqnic.h"

#ifndef RPU_COUNT
	#define RPU_COUNT   16
#endif

#define MAX_ETH_IF_COUNT 3
#define MAX_TOT_IF_COUNT 5
#define SLOTS            16
#define RX_FIFO_LINES    (1<<12)

#define REG_WIDTH 4

#define SYS_CORE_ZONE    (0 << 29)
#define SYS_INT_ZONE     (1 << 29)
#define LB_CORE_ZONE     (2 << 29)
#define LB_INT_ZONE      (3 << 29)

// INTERFACE REGISTER ADDRESSES, FIXED
#define INT_RX_EN           0
#define INT_RX_FIFO_LINES   4  // RD_ONLY
#define INT_RX_STAT         8  // RD_ONLY, 4 addresses
#define INT_TX_STAT         12 // RD_ONLY, 4 addresses

// REGISTERS CHOSEN FOR CURRENT LBULER
#define LB_CORE_EN       0
#define LB_CORE_RECV     1
#define LB_CORE_FLUSH    2 // WR_ONLY
#define LB_CORE_SLOT     3 // RD_ONLY

#define LB_INT_DESC      0 // RD_ONLY, RR LB
#define LB_INT_DROP_DESC 1 // WR_ONLY, RR LB
#define LB_INT_DROP_CNT  2 // RD_ONLY, HASH LB
#define LB_INT_DROP_LMT  3 // WR_ONLY

// DMA operations
void block_write(struct mqnic *dev, char* data, unsigned int addr, size_t len, int core_num);
void block_read (struct mqnic *dev, char* data, unsigned int addr, size_t len, int core_num);

// Commands
void     write_cmd(struct mqnic *dev, uint32_t addr, uint32_t data);
uint32_t read_cmd (struct mqnic *dev, uint32_t addr);

// Between the host and the cores
void     core_wr_cmd(struct mqnic *dev, uint32_t core, uint32_t reg, uint32_t data);
uint32_t core_rd_cmd(struct mqnic *dev, uint32_t core, uint32_t reg);

// Between the host and the interfaces
void     set_enable_interfaces (struct mqnic *dev, uint32_t onehot);
uint32_t read_enable_interfaces(struct mqnic *dev);

uint32_t read_rx_fifo_lines(struct mqnic *dev, uint32_t interface);
uint32_t interface_stat_rd (struct mqnic *dev, uint32_t interface, uint32_t direction, uint32_t reg);

// Between the host and the LB
void     set_enable_cores  (struct mqnic *dev, uint32_t onehot);
uint32_t read_enable_cores (struct mqnic *dev);
void     set_receive_cores (struct mqnic *dev, uint32_t onehot);
uint32_t read_receive_cores(struct mqnic *dev);

uint32_t read_core_slots     (struct mqnic *dev, uint32_t core);
uint32_t read_interface_desc (struct mqnic *dev, uint32_t interface);
uint32_t read_interface_drops(struct mqnic *dev, uint32_t interface);

void release_core_slots    (struct mqnic *dev, uint32_t onehot);
void release_interface_desc(struct mqnic *dev, uint32_t onehot);

void set_interface_rx_threshold(struct mqnic *dev, uint32_t limit);

// Load balancer status and evict and reset functions
void print_lb_status(struct mqnic *dev);
void evict_core(struct mqnic *dev, uint32_t core);
void reset_all_cores(struct mqnic *dev, int evict);
void reset_single_core(struct mqnic *dev, uint32_t core, uint32_t num_slots, int evict);
