/*

Copyright (c) 2019-2021 Moein Khazraee

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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mqnic.h"
#include "rpu.h"

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

    int core_count = RPU_COUNT;
    int if_count = MAX_TOT_IF_COUNT;

    printf("DMA enable: %u\n", mqnic_reg_read32(dev->regs, 0x000400));

    for (int k=0; k<core_count; k++)
    {
        mqnic_reg_write32(dev->regs, 0x000410, k);
        printf("core %d slots: %u\n",     k, read_core_slots(dev, k));
        printf("core %d rx bytes: %u\n",  k, core_rd_cmd(dev, k, 0));
        printf("core %d tx bytes: %u\n",  k, core_rd_cmd(dev, k, 3));
        printf("core %d rx frames: %u\n", k, core_rd_cmd(dev, k, 1));
        printf("core %d tx frames: %u\n", k, core_rd_cmd(dev, k, 4));
    }

    for (int k=0; k<if_count; k++)
    {
        mqnic_reg_write32(dev->regs, 0x000414, k);
        printf("interface %d rx bytes: %u\n",  k, interface_stat_rd(dev, k, 0, 0));
        printf("interface %d tx bytes: %u\n",  k, interface_stat_rd(dev, k, 1, 0));
        printf("interface %d rx frames: %u\n", k, interface_stat_rd(dev, k, 0, 1));
        printf("interface %d tx frames: %u\n", k, interface_stat_rd(dev, k, 1, 1));
        printf("interface %d rx drops: %u\n",  k, interface_stat_rd(dev, k, 0, 2));
    }

err:

    mqnic_close(dev);

    return ret;
}
