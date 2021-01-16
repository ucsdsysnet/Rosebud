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

#include "gousheh.h"

void write_cmd (struct mqnic *dev, uint32_t addr, uint32_t data){
    mqnic_reg_write32(dev->regs, 0x000404, data);
    usleep(10);
    mqnic_reg_write32(dev->regs, 0x000408, (1<<31)|addr);
    return;
}

uint32_t read_cmd (struct mqnic *dev, uint32_t addr){
    mqnic_reg_write32(dev->regs, 0x000408, addr);
    usleep(10);
    mqnic_reg_read32 (dev->regs, 0x000404); //dummy read
    usleep(10);
    return mqnic_reg_read32(dev->regs, 0x000404);
}


void core_wr_cmd (struct mqnic *dev, uint32_t core, uint32_t reg, uint32_t data){
    write_cmd(dev, SYS_ZONE | SYS_CORE | core<<CORE_REG_WIDTH | reg, data);
    return;
}

uint32_t core_rd_cmd (struct mqnic *dev, uint32_t core, uint32_t reg){
    return read_cmd(dev, SYS_ZONE | SYS_CORE | core<<CORE_REG_WIDTH | reg);
}

uint32_t interface_rd_cmd (struct mqnic *dev, uint32_t interface, uint32_t direction, uint32_t reg){
    return read_cmd(dev, SYS_ZONE | SYS_INT | interface<<(INT_REG_WIDTH+1) | direction<<INT_DIR_BIT | reg);
}

void set_receive_cores (struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_ZONE | SCHED_RECEIVE, onehot);
    return;
}

void set_disable_cores (struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_ZONE | SCHED_DISABLE, onehot);
    return;
}

uint32_t read_receive_cores (struct mqnic *dev){
    return read_cmd(dev, SCHED_ZONE | SCHED_RECEIVE);
}

uint32_t read_disable_cores (struct mqnic *dev){
    return read_cmd(dev, SCHED_ZONE | SCHED_DISABLE);
}

uint32_t read_core_slots (struct mqnic *dev, uint32_t core){
    return read_cmd(dev, SCHED_ZONE | SCHED_SLOT | core);
}

uint32_t read_interface_desc (struct mqnic *dev, uint32_t interface){
    return read_cmd(dev, SCHED_ZONE | SCHED_DESC | interface);
}
