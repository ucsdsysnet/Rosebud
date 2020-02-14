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
#include <sys/ioctl.h>

#include "mqnic.h"

#define MAX_CORE_COUNT 16
#define MAX_IF_COUNT 4

static void usage(char *name)
{
    fprintf(stderr,
        "usage: %s [options]\n"
        " -d name    device to open (/sys/bus/pci/devices/.../resource0)\n"
        " -w file    file to write\n"
        " -e mask    core enable\n"
        " -r mask    core rx enable\n",
        name);
}

int main(int argc, char *argv[])
{
    char *name;
    int opt;
    int ret = 0;

    char *device = NULL;
    struct mqnic *dev;

    char *write_file_name = NULL;
    FILE *write_file = NULL;

    char action_write = 0;

    uint32_t core_enable = 0xffffffff;
    uint32_t core_rx_enable = 0xffffffff;

    name = strrchr(argv[0], '/');
    name = name ? 1+name : argv[0];

    while ((opt = getopt(argc, argv, "d:w:e:r:h?")) != EOF)
    {
        switch (opt)
        {
        case 'd':
            device = optarg;
            break;
        case 'w':
            action_write = 1;
            write_file_name = optarg;
            break;
        case 'e':
            core_enable = strtoul(optarg, NULL, 0);
            break;
        case 'r':
            core_rx_enable = strtoul(optarg, NULL, 0);
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

    core_rx_enable &= core_enable;

    printf("FW ID: 0x%08x\n", dev->fw_id);
    printf("FW version: %d.%d\n", dev->fw_ver >> 16, dev->fw_ver & 0xffff);
    printf("Board ID: 0x%08x\n", dev->board_id);
    printf("Board version: %d.%d\n", dev->board_ver >> 16, dev->board_ver & 0xffff);

    int core_count = MAX_CORE_COUNT;
    int if_count = MAX_IF_COUNT;

    int segment_size = 65536;

    if (action_write)
    {
        char *segment = calloc(segment_size, 1);
        memset(segment, 0xff, segment_size);
        size_t len;

        // read binary file
        printf("Reading binary file \"%s\"...\n", write_file_name);
        write_file = fopen(write_file_name, "rb");
        fseek(write_file, 0, SEEK_END);
        len = ftell(write_file);
        rewind(write_file);

        if (len > segment_size)
        {
            len = segment_size;
        }

        printf("Reading %lu bytes...\n", len);
        if (fread(segment, 1, len, write_file) < len)
        {
            fprintf(stderr, "Error reading file\n");
            free(segment);
            ret = -1;
            goto err;
        }

        fclose(write_file);

        printf("Disabling cores in scheduler...\n");
        mqnic_reg_write32(dev->regs, 0x000408, 0x00000000);
        mqnic_reg_write32(dev->regs, 0x00040C, 0xffffffff);

        usleep(100000);

        printf("Placing cores in reset...\n");
        for (int k=0; k<core_count; k++)
        {
            mqnic_reg_write32(dev->regs, 0x000404, (k << 1) | 1);
            usleep(1000);
            printf(".");
            fflush(stdout);
        }
        printf("\n");

        printf("Write core instruction memory...\n");
        for (int k=0; k<core_count; k++)
        {
            struct mqnic_ioctl_block_write ctl;

            ctl.addr = (k<<26) | (1<<25);
            ctl.data = segment;
            ctl.len = len;

            if (ioctl(dev->fd, MQNIC_IOCTL_BLOCK_WRITE, &ctl) != 0)
            {
                perror("MQNIC_IOCTL_BLOCK_WRITE ioctl failed");
            }

            printf(".");
            fflush(stdout);
        }
        printf("\n");

        printf("Release core resets...\n");
        for (int k=0; k<core_count; k++)
        {
            if (core_enable & (1 << k))
                mqnic_reg_write32(dev->regs, 0x000404, (k << 1) | 0);
            usleep(1000);
            printf(".");
            fflush(stdout);
        }
        printf("\n");

        usleep(100000);

        printf("Enabling cores in scheduler...\n");
        printf("Core enable mask: 0x%08x\n", core_enable);
        printf("Core RX enable mask: 0x%08x\n", core_rx_enable);
        mqnic_reg_write32(dev->regs, 0x000408, core_rx_enable);
        mqnic_reg_write32(dev->regs, 0x00040C, ~core_enable);

        printf("Done!\n");

        free(segment);
    }

err:

    mqnic_close(dev);

    return ret;
}




