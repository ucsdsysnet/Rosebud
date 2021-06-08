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

// We need to break the data into 16KB segments
void block_write(struct mqnic *dev, char* data, unsigned int addr, size_t len, int core_num) {
    struct mqnic_ioctl_block_write ctl;
    int left = len;

    ctl.addr = (core_num<<26) | addr;
    ctl.data = data;

    while (left>0){
      if (left<16384)
        ctl.len = left;
      else
        ctl.len = 16384;

      if (ioctl(dev->fd, MQNIC_IOCTL_BLOCK_WRITE, &ctl) != 0){
          perror("MQNIC_IOCTL_BLOCK_WRITE ioctl failed");
      }

      left    -=16384;
      ctl.data+=16384;
      ctl.addr+=16384;
    }

    return;
}

// We need to break the data into 16KB segments
void block_read(struct mqnic *dev, char* data, unsigned int addr, size_t len, int core_num) {
    struct mqnic_ioctl_block_write ctl;
    int left = len;

    ctl.addr = (core_num<<26) | addr;
    ctl.data = data;


    while (left>0){
      if (left<16384)
        ctl.len = left;
      else
        ctl.len = 16384;

      if (ioctl(dev->fd, MQNIC_IOCTL_BLOCK_READ, &ctl) != 0){
          perror("MQNIC_IOCTL_BLOCK_READ ioctl failed");
      }

      left    -=16384;
      ctl.data+=16384;
      ctl.addr+=16384;
    }

    return;
}


void write_cmd(struct mqnic *dev, uint32_t addr, uint32_t data){
    mqnic_reg_write32(dev->regs, 0x000404, data);
    mqnic_reg_write32(dev->regs, 0x000404, data);
    usleep(10);
    mqnic_reg_write32(dev->regs, 0x000408, (1<<29)|addr);
    return;
}

uint32_t read_cmd(struct mqnic *dev, uint32_t addr){
    mqnic_reg_write32(dev->regs, 0x000408, addr);
    mqnic_reg_write32(dev->regs, 0x000408, addr);
    usleep(10);
    mqnic_reg_read32(dev->regs, 0x000404); //dummy read
    usleep(10);
    return mqnic_reg_read32(dev->regs, 0x000404);
}


void core_wr_cmd(struct mqnic *dev, uint32_t core, uint32_t reg, uint32_t data){
    write_cmd(dev, SYS_CORE_ZONE |  core << REG_WIDTH | reg, data);
}

uint32_t core_rd_cmd(struct mqnic *dev, uint32_t core, uint32_t reg){
    return read_cmd(dev, SYS_CORE_ZONE | core << REG_WIDTH | reg);
}

void set_enable_interfaces(struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SYS_INT_ZONE | INT_RX_EN, onehot);
}

uint32_t read_enable_interfaces(struct mqnic *dev){
    return read_cmd(dev, SYS_INT_ZONE | INT_RX_EN);
}

uint32_t read_rx_fifo_lines(struct mqnic *dev, uint32_t interface){
    return read_cmd(dev, SYS_INT_ZONE | interface << REG_WIDTH | INT_RX_FIFO_LINES);
}

uint32_t interface_stat_rd (struct mqnic *dev, uint32_t interface, uint32_t direction, uint32_t reg){
    if (direction) //TX 
        return read_cmd(dev, SYS_INT_ZONE | interface << REG_WIDTH | INT_TX_STAT | reg);
    else
        return read_cmd(dev, SYS_INT_ZONE | interface << REG_WIDTH | INT_RX_STAT | reg);
}

void set_enable_cores(struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_CORE_ZONE | SCHED_CORE_EN, onehot);
}

uint32_t read_enable_cores(struct mqnic *dev){
    return read_cmd(dev, SCHED_CORE_ZONE | SCHED_CORE_EN);
}

void set_receive_cores(struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_CORE_ZONE | SCHED_CORE_RECV, onehot);
}

uint32_t read_receive_cores(struct mqnic *dev){
    return read_cmd(dev, SCHED_CORE_ZONE | SCHED_CORE_RECV);
}

void release_core_slots(struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_CORE_ZONE | SCHED_CORE_FLUSH, onehot);
}

uint32_t read_core_slots(struct mqnic *dev, uint32_t core){
    return read_cmd(dev, SCHED_CORE_ZONE | core << REG_WIDTH | SCHED_CORE_SLOT);
}

void release_interface_desc(struct mqnic *dev, uint32_t onehot){
    write_cmd(dev, SCHED_INT_ZONE | SCHED_INT_DROP_DESC, onehot);
}
    
uint32_t read_interface_desc(struct mqnic *dev, uint32_t interface){
    return read_cmd(dev, SCHED_INT_ZONE | interface << REG_WIDTH | SCHED_INT_DESC);
}

uint32_t read_interface_drops(struct mqnic *dev, uint32_t interface){
    return read_cmd(dev, SCHED_INT_ZONE | interface << REG_WIDTH | SCHED_INT_DROP_CNT);
}

void set_interface_rx_threshold(struct mqnic *dev, uint32_t limit){
    write_cmd(dev, SCHED_INT_ZONE | SCHED_INT_DROP_LMT, limit);
}


void evict_core(struct mqnic *dev, uint32_t core){
    printf("Evicting core %d.\n", core);

    // Take core out of reset if necessary
    // if(core_rd_cmd(dev, core, 8) & (1<<17))
    //     core_wr_cmd(dev, core, 0xF, 0);

    // Send evict interrupt
    core_wr_cmd(dev, core, 0xD, 1);
    // Wait for ready_to_evict signal
    while (((core_rd_cmd(dev, core, 8)>>16) & 1)==0);
    return;
}

void print_scheduler_status(struct mqnic *dev){
    printf("recv_cores %d, enable_cores %d \n",
            read_receive_cores(dev), read_enable_cores(dev));

    for (int i=0; i< MAX_ETH_IF_COUNT; i++)
        printf("interface %d has reserved a desc from core %d in the schecduler\n",
                i, (read_interface_desc (dev, i) >> 8) & 0xFF);

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
            if (core_rd_cmd(dev, i, 0xA) !=0){
                // printf("Core %d has slots stuck: %X\n", i, core_rd_cmd(dev, i, 0xA));
                evict_core(dev, i);
            }

    // Wait for the on the fly packets
    usleep(10000);

    printf("Flushing scheduler...\n");

    release_interface_desc(dev, (1<<MAX_ETH_IF_COUNT)-1);
    release_core_slots(dev, (1<<MAX_CORE_COUNT)-1);
    usleep(100);

    printf("Placing cores in reset...\n");
    for (int i=0; i< MAX_CORE_COUNT; i++){
        core_wr_cmd(dev, i, 0xF, 1);
        usleep(1000);
        printf(".");
        fflush(stdout);
    }
    printf("\n");
}

void reset_single_core(struct mqnic *dev, uint32_t core, uint32_t num_slots, int evict){
    uint32_t cur = read_enable_cores(dev);
    set_enable_cores(dev, cur & ~(1 << core));
    cur = read_receive_cores(dev);
    set_receive_cores(dev, cur & ~(1 << core));

    if (evict==1)
        // Check if there is any active slots in the core
        if (core_rd_cmd(dev, core, 0xA) !=0)
            evict_core(dev,core);
    usleep(10000);

    uint32_t slots = read_core_slots(dev,core);

    // All slots are recovered, reset the core and flush the slots
    if (slots == num_slots){
        goto reset_ready;
    } else {
        usleep(10000);
        // After some wait all slots are recovered
        if (slots == num_slots){
            goto reset_ready;
        } else {

            // check interfaces for hung slots
            uint32_t desc = read_interface_desc(dev,0);
            int descs_released = 0;
            if (desc!=0xFEFEFEFE){ // There is desc read back
                for (int i=0; i< MAX_ETH_IF_COUNT; i++){
                    desc = read_interface_desc(dev,i);
                    if ((((desc>>8) & 0xFF) == core) && (((desc>>16) & 0xFF) == 1)){
                        printf("Dropping scheduler desc on interface %d for core %d.\n",i,core);
                        // disable the interface, wait, check if still it's the same
                        // desc drop it, enable the interface back
                        cur = read_enable_interfaces(dev);
                        set_enable_interfaces(dev, cur & ~(1 << i));
                        desc = read_interface_desc(dev,i);
                        if ((((desc>>8) & 0xFF) == core) && (((desc>>16) & 0xFF) == 1)){
                            release_interface_desc(dev, 1<<i);
                            descs_released += 1;
                        }
                        set_enable_interfaces(dev, cur);
                    }
                }
            }

            // Read the recovered slots again just in case
            slots = read_core_slots(dev,core);

            // If all the slots were hung in scheduler proceed
            if ((slots+descs_released) == num_slots){
                goto reset_ready;
            } else {
                // If still missing slots, warn of stuck packet in a core
                printf("WARNING: Placing core %d in reset which still has %d slots.\n", core, num_slots-(slots+descs_released));
                core_wr_cmd(dev, core, 0xF, 1);
                release_core_slots(dev, 1<<core);
                usleep(1000);
                return;
            }
        }
    }

reset_ready:
    printf("Placing core %d in reset.\n", core);
    core_wr_cmd(dev, core, 0xF, 1);
    release_core_slots(dev, 1<<core);
    usleep(1000);
    return;
}

