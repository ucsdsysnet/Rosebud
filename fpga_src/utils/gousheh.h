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

#define MAX_CORE_COUNT 16
#define MAX_IF_COUNT   3

#define SYS_ZONE            (0<<30)
#define SCHED_ZONE          (1<<30)

#define SYS_CORE            (0<<29)
#define SYS_INT             (1<<29) // RD_ONLY

#define SCHED_CORE_RECV     (0<<27)
#define SCHED_CORE_EN       (1<<27)
#define SCHED_CORE_SLOT     (2<<27) // RD_ONLY
#define SCHED_CORE_FLUSH    (3<<27) // RD_ONLY

#define SCHED_INT_DESC      (4<<27) // RD_ONLY
#define SCHED_INT_EN        (5<<27)
#define SCHED_INT_DROP_DESC (6<<27) // WR_ONLY, RR SCHED
#define SCHED_INT_DROP_CNT  (7<<27) // RD_ONLY, HASH SCHED

#define CORE_REG_WIDTH      4
#define INT_REG_WIDTH       2
#define INT_DIR_BIT         (INT_REG_WIDTH+1-1)

void write_cmd(struct mqnic *dev, uint32_t addr, uint32_t data);
uint32_t read_cmd(struct mqnic *dev, uint32_t addr);

void core_wr_cmd(struct mqnic *dev, uint32_t core, uint32_t reg, uint32_t data);
uint32_t core_rd_cmd(struct mqnic *dev, uint32_t core, uint32_t reg);
uint32_t interface_rd_cmd(struct mqnic *dev, uint32_t interface, uint32_t direction, uint32_t reg);

void set_receive_cores(struct mqnic *dev, uint32_t onehot);
void set_enable_cores(struct mqnic *dev, uint32_t onehot);
void release_core_slots(struct mqnic *dev, uint32_t onehot);
void set_enable_interfaces(struct mqnic *dev, uint32_t onehot);
void release_interface_desc(struct mqnic *dev, uint32_t onehot);

uint32_t read_receive_cores(struct mqnic *dev);
uint32_t read_enable_cores(struct mqnic *dev);
uint32_t read_enable_interfaces(struct mqnic *dev);
uint32_t read_core_slots(struct mqnic *dev, uint32_t core);
uint32_t read_interface_desc(struct mqnic *dev, uint32_t interface);
uint32_t read_interface_drops(struct mqnic *dev, uint32_t interface);

void reset_all_cores(struct mqnic *dev);

