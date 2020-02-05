/*

Copyright 2019, The Regents of the University of California.
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mqnic.h"

#define MAX_CORE_COUNT 16
#define MAX_IF_COUNT 4

static void usage(char *name)
{
    fprintf(stderr,
        "usage: %s [options]\n"
        " -d name    device to open (/sys/bus/pci/devices/.../resource0)\n",
        name);
}

int main(int argc, char *argv[])
{
    char *name;
    int opt;
    int ret = 0;

    char *device = NULL;
    struct mqnic *dev;

    name = strrchr(argv[0], '/');
    name = name ? 1+name : argv[0];

    while ((opt = getopt(argc, argv, "d:h?")) != EOF)
    {
        switch (opt)
        {
        case 'd':
            device = optarg;
            break;
        case 'h':
        case '?':
            usage(name);
            return 0;
        default:
            usage(name);
            return -1;
        }
    }

    if (!device)
    {
        fprintf(stderr, "Device not specified\n");
        usage(name);
        return -1;
    }

    dev = mqnic_open(device);

    if (!dev)
    {
        fprintf(stderr, "Failed to open device\n");
        return -1;
    }

    printf("FW ID: 0x%08x\n", dev->fw_id);
    printf("FW version: %d.%d\n", dev->fw_ver >> 16, dev->fw_ver & 0xffff);
    printf("Board ID: 0x%08x\n", dev->board_id);
    printf("Board version: %d.%d\n", dev->board_ver >> 16, dev->board_ver & 0xffff);
    printf("PHC count: %d\n", dev->phc_count);
    printf("PHC offset: 0x%08x\n", dev->phc_offset);
    printf("PHC stride: 0x%08x\n", dev->phc_stride);
    printf("IF count: %d\n", dev->if_count);
    printf("IF stride: 0x%08x\n", dev->if_stride);
    printf("IF CSR offset: 0x%08x\n", dev->if_csr_offset);

    int core_count = MAX_CORE_COUNT;
    int if_count = MAX_IF_COUNT;

    printf("DMA enable: %u\n", mqnic_reg_read32(dev->regs, 0x000400));

    for (int k=0; k<core_count; k++)
    {
        mqnic_reg_write32(dev->regs, 0x000410, k);
        printf("core %d slots: %u\n", k, mqnic_reg_read32(dev->regs, 0x000410));
        printf("core %d rx bytes: %u\n", k, mqnic_reg_read32(dev->regs, 0x000414));
        printf("core %d tx bytes: %u\n", k, mqnic_reg_read32(dev->regs, 0x000418));
        printf("core %d rx frames: %u\n", k, mqnic_reg_read32(dev->regs, 0x00041C));
        printf("core %d tx frames: %u\n", k, mqnic_reg_read32(dev->regs, 0x000420));
    }

    for (int k=0; k<if_count; k++)
    {
        mqnic_reg_write32(dev->regs, 0x000414, k);
        printf("interface %d rx bytes: %u\n", k, mqnic_reg_read32(dev->regs, 0x000424));
        printf("interface %d tx bytes: %u\n", k, mqnic_reg_read32(dev->regs, 0x000428));
        printf("interface %d rx frames: %u\n", k, mqnic_reg_read32(dev->regs, 0x00042C));
        printf("interface %d tx frames: %u\n", k, mqnic_reg_read32(dev->regs, 0x000430));
    }

err:

    mqnic_close(dev);

    return ret;
}




