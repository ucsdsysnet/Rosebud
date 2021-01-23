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

void write_cmd(struct mqnic *dev, uint32_t addr, uint32_t data){
    mqnic_reg_write32(dev->regs, 0x000404, data);
    mqnic_reg_write32(dev->regs, 0x000404, data);
    usleep(10);
    mqnic_reg_write32(dev->regs, 0x000408, (1<<31)|addr);
    return;
}

uint32_t read_cmd(struct mqnic *dev, uint32_t addr){
    mqnic_reg_write32(dev->regs, 0x000408, addr);
    usleep(10);
    mqnic_reg_read32(dev->regs, 0x000404); //dummy read
    usleep(10);
    return mqnic_reg_read32(dev->regs, 0x000404);
}


void core_wr_cmd(struct mqnic *dev, uint32_t core, uint32_t reg, uint32_t data){
    write_cmd(dev, SYS_ZONE | SYS_CORE | core<<CORE_REG_WIDTH | reg, data);
}

uint32_t core_rd_cmd(struct mqnic *dev, uint32_t core, uint32_t reg){
    return read_cmd(dev, SYS_ZONE | SYS_CORE | core<<CORE_REG_WIDTH | reg);
}

uint32_t interface_rd_cmd(struct mqnic *dev, uint32_t interface, uint32_t direction, uint32_t reg){
    return read_cmd(dev, SYS_ZONE | SYS_INT | interface<<(INT_REG_WIDTH+1) | direction<<INT_DIR_BIT | reg);
}

void set_receive_cores(struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_ZONE | SCHED_CORE_RECV, onehot);
}

void set_enable_cores(struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_ZONE | SCHED_CORE_EN, onehot);
}

void release_core_slots(struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_ZONE | SCHED_CORE_FLUSH, onehot);
}

void set_enable_interfaces(struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_ZONE | SCHED_INT_EN, onehot);
}

void release_interface_desc(struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_ZONE | SCHED_INT_DROP_DESC, onehot);
}

uint32_t read_receive_cores(struct mqnic *dev){
    return read_cmd(dev, SCHED_ZONE | SCHED_CORE_RECV);
}

uint32_t read_enable_cores(struct mqnic *dev){
    return read_cmd(dev, SCHED_ZONE | SCHED_CORE_EN);
}

uint32_t read_enable_interfaces(struct mqnic *dev){
    return read_cmd(dev, SCHED_ZONE | SCHED_INT_EN);
}

uint32_t read_core_slots(struct mqnic *dev, uint32_t core){
    return read_cmd(dev, SCHED_ZONE | SCHED_CORE_SLOT | core);
}

uint32_t read_interface_desc(struct mqnic *dev, uint32_t interface){
    return read_cmd(dev, SCHED_ZONE | SCHED_INT_DESC | interface);
}

uint32_t read_interface_drops(struct mqnic *dev, uint32_t interface){
    return read_cmd(dev, SCHED_ZONE | SCHED_INT_DROP_CNT | interface);
}


void evict_core(struct mqnic *dev, uint32_t core){
    printf("Evicting core %d.\n", core);
    core_wr_cmd(dev, core, 0xD, 1);
    // Wait for ready_to_evict signal
    while (!(core_rd_cmd(dev, core, 8) & (1<<16)));
    return;
}

void print_scheduler_status(struct mqnic *dev){
    printf("recv_cores %d, enable_cores %d, enable interfaces %d",
            read_receive_cores(dev), read_enable_cores(dev), read_enable_interfaces(dev));

    for (int i=0; i< MAX_IF_COUNT; i++)
        printf("interface %d has reserved a desc from core %d in the schecduler\n",
                i, read_interface_desc (dev, i) >> 5);

    for (int i=0; i< MAX_CORE_COUNT; i++)
        printf("Core %d has %d slots in the scheduer.\n",
                i, read_core_slots (dev, i));
    return;
}

void reset_all_cores(struct mqnic *dev, int evict){
    printf("Disabling cores in scheduler...\n");
    set_enable_cores(dev, 0);
    set_receive_cores(dev,0);

    if (evict==1)
        for (int i=0; i< MAX_CORE_COUNT; i++)
            if (core_rd_cmd(dev, i, 9) !=0)
                evict_core(dev,i);

    // Wait for the on the fly packets
    usleep(10000);

    printf("Flushing scheduler...\n");

    release_interface_desc(dev, (1<<MAX_IF_COUNT)-1);
    release_core_slots(dev, (1<<MAX_CORE_COUNT)-1);
    usleep(100);

    printf("Placing cores in reset...\n");
    for (int i=0; i< MAX_CORE_COUNT; i++){
        core_wr_cmd(dev, i, 0xf, 1);
        usleep(1000);
        printf(".");
        fflush(stdout);
    }
    printf("\n");
}
