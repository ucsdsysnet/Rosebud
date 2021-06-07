/*

Copyright 2021, The Regents of the University of California.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE REGENTS OF THE UNIVERSITY OF CALIFORNIA ''AS
IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS OF THE UNIVERSITY OF CALIFORNIA OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of The Regents of the University of California.

*/

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>

#include "mqnic.h"

#define MAX_CORE_COUNT   16
#define MAX_ETH_IF_COUNT 3
#define MAX_TOT_IF_COUNT 5


#define REG_WIDTH 4

#define SYS_CORE_ZONE       (0 << 30)
#define SYS_INT_ZONE        (1 << 30)
#define SCHED_CORE_ZONE     (2 << 30)
#define SCHED_INT_ZONE      (3 << 30)

// INTERFACE REGISTER ADDRESSES, FIXED
#define INT_RX_EN           0
#define INT_RX_FIFO_LINES   4  // RD_ONLY
#define INT_RX_STAT         8  // RD_ONLY, 4 addresses
#define INT_TX_STAT         12 // RD_ONLY, 4 addresses

// REGISTERS CHOSEN FOR CURRENT SCHEDULER
#define SCHED_CORE_EN       0
#define SCHED_CORE_RECV     1
#define SCHED_CORE_FLUSH    2 // WR_ONLY
#define SCHED_CORE_SLOT     3 // RD_ONLY

#define SCHED_INT_DESC      0 // RD_ONLY, RR SCHED
#define SCHED_INT_DROP_DESC 1 // WR_ONLY, RR SCHED
#define SCHED_INT_DROP_CNT  2 // RD_ONLY, HASH SCHED
#define SCHED_INT_DROP_LMT  3 // WR_ONLY

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

// Between the host and the scheduler
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

// Scheduler status and evict and reset functions
void print_scheduler_status(struct mqnic *dev);
void evict_core(struct mqnic *dev, uint32_t core);
void reset_all_cores(struct mqnic *dev, int evict);
void reset_single_core(struct mqnic *dev, uint32_t core, uint32_t num_slots, int evict);
