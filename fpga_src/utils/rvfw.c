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

#include <limits.h>
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
        " -i file    instruction memory binary\n"
        " -m file    memory map for data memory binary(ies)\n"
        " -e mask    core enable\n"
        " -r mask    core rx enable\n",
        name);
}

// We need to break the data into 16KB segments
void write_to_core (struct mqnic *dev, char* data, unsigned int addr, size_t len, int core_num) {
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
void read_from_core (struct mqnic *dev, char* data, unsigned int addr, size_t len, int core_num) {
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

int main(int argc, char *argv[])
{
    char *name;
    int opt;
    int ret = 0;

    char *device = NULL;
    struct mqnic *dev;

    char *instr_bin = NULL;
    char *data_map = NULL;
    FILE *write_file = NULL;
    FILE *map_file = NULL;

    char action_write = 0;
    char load_dmem    = 0;

    uint32_t core_enable = 0xffffffff;
    uint32_t core_rx_enable = 0xffffffff;

    name = strrchr(argv[0], '/');
    name = name ? 1+name : argv[0];

    while ((opt = getopt(argc, argv, "d:i:m:e:r:h?")) != EOF)
    {
        switch (opt)
        {
        case 'd':
            device = optarg;
            break;
        case 'i':
            action_write = 1;
            instr_bin = optarg;
            break;
        case 'm':
            action_write = 1;
            load_dmem    = 1;
            data_map = optarg;
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
    int test_pcie = 0;

    int segment_size = 512*1024;

    if (action_write)
    {
        char *i_segment = calloc(segment_size, 1);
        char *d_segment = calloc(segment_size, 1);
        char *r_segment = calloc(segment_size, 1);
        size_t ins_len;
        size_t map_len = 0;
        size_t data_len = 0;

        // read instruction binary file
        printf("Reading binary file \"%s\"...\n", instr_bin);
        write_file = fopen(instr_bin, "rb");
        fseek(write_file, 0, SEEK_END);
        ins_len = ftell(write_file);
        rewind(write_file);

        if (ins_len > segment_size)
        {
            printf("Segment size error, increase segment size\n");
            ins_len = segment_size;
        }

        printf("Reading %lu bytes...\n", ins_len);
        if (fread(i_segment, 1, ins_len, write_file) < ins_len)
        {
            fprintf(stderr, "Error reading file\n");
            free(i_segment);
            free(d_segment);
            free(r_segment);
            ret = -1;
            goto err;
        }

        fclose(write_file);

        // read data memory map file
        if (load_dmem) {
            printf("Reading memory map file \"%s\"...\n", data_map);
            map_file = fopen(data_map, "r");
            fseek(map_file, 0, SEEK_END);
            map_len = ftell(map_file);
            rewind(map_file);

            if (map_len==0) {
                printf("Empty Data mem map file\n");
                load_dmem = 0;
                fclose(map_file);
            }
        }

        printf("Disabling cores in scheduler...\n");
        mqnic_reg_write32(dev->regs, 0x000410, 0xffffffff);
        mqnic_reg_write32(dev->regs, 0x000404, 0x00000001);

        usleep(100000);

        printf("Placing cores in reset...\n");
        for (int k=0; k<core_count; k++)
        {
            mqnic_reg_write32(dev->regs, 0x000408, (k << 8) | 0xf);
            usleep(1000);
            printf(".");
            fflush(stdout);
        }
        printf("\n");

        printf("Write core instruction memories...\n");
        for (int k=0; k<core_count; k++)
        {
            write_to_core (dev, i_segment, (1<<25), ins_len, k);
            printf(".");
            fflush(stdout);
        }
        printf("\n");

        if (load_dmem) {
            printf("Write data memory files ...\n");
            char line[256];
            char path[PATH_MAX+1];
            while (fgets(line, sizeof(line), map_file)) {
                char * data_bin = strtok(line, " ");
                char * addr     = strtok(NULL, " \n");
                if (strtok(NULL, " \n")!=NULL){
                    fprintf(stderr, "Error in data map file\n");
                    free(i_segment);
                    free(d_segment);
                    free(r_segment);
                    ret = -1;
                    goto err;
                }

                if (data_bin[0] != '/')
                {
                    // relative path
                    char *ptr;
                    strncpy(path, data_map, PATH_MAX);

                    ptr = strrchr(path, '/');
                    if (ptr)
                    {
                        ptr++;
                        *ptr = 0;
                    }
                    else
                    {
                        path[0] = 0;
                    }

                    strncat(path, data_bin, PATH_MAX);

                    data_bin = path;
                }

                printf("Reading binary file \"%s\"...\n", data_bin);
                write_file = fopen(data_bin, "rb");
                fseek(write_file, 0, SEEK_END);
                data_len = ftell(write_file);
                rewind(write_file);

                if (data_len > segment_size)
                {
                    printf("Segment size error, increase segment size\n");
                    data_len = segment_size;
                }

                printf("Reading %lu bytes...\n", data_len);
                if (fread(d_segment, 1, data_len, write_file) < data_len)
                {
                    fprintf(stderr, "Error reading file\n");
                    free(i_segment);
                    free(d_segment);
                    free(r_segment);
                    ret = -1;
                    goto err;
                }

                fclose(write_file);

                printf("Writing to address %s\n", addr);
                for (int k=0; k<core_count; k++){
                    write_to_core (dev, d_segment, (int)strtol(addr, NULL, 0), data_len, k);
                    printf(".");
                    fflush(stdout);
                }
                printf("\n");
            }
        }

        if (test_pcie){
            // Host Write and Readback test

            write_to_core (dev, i_segment, 0x1000100, ins_len, 4);
            usleep(1000);
            read_from_core (dev, r_segment, 0x1000100, ins_len, 4);
            usleep(1000);

            printf("Write Buffer:\n");
            for (int k=0; k<ins_len;k+=16){
                for (int i=0; i<16;i++)
                    printf("%02x ", (int)*(i_segment+k+i) & 0xff);
                printf("\n");
            }

            printf("Read values:\n");
            for (int k=0; k<ins_len;k+=16){
                for (int i=0; i<16;i++)
                    printf("%02x ", (int)*(r_segment+k+i) & 0xff);
                printf("\n");
            }
        }

        printf("Release core resets...\n");
        mqnic_reg_write32(dev->regs, 0x000404, 0x00000000);
        usleep(100000);
        for (int k=0; k<core_count; k++)
        {
            if (core_enable & (1 << k)){
                mqnic_reg_write32(dev->regs, 0x000408, (k << 8) | 0xf);
                mqnic_reg_write32(dev->regs, 0x000408, (k << 8) | 0xf);
            }
            usleep(1000);
            printf(".");
            fflush(stdout);
        }
        printf("\n");

        usleep(1000000);

        printf("Core stats after taking out of reset\n");
        for (int k=0; k<core_count; k++){
            mqnic_reg_write32(dev->regs, 0x000414, k<<4|8);
            mqnic_reg_read32(dev->regs, 0x000424); //dummy read
            printf("core %d status: %08x\n", k, mqnic_reg_read32(dev->regs, 0x000424));
        }

        printf("Enabling cores in scheduler...\n");
        printf("Core RX enable mask: 0x%08x\n", core_rx_enable);
        mqnic_reg_write32(dev->regs, 0x00040C, core_rx_enable);
        mqnic_reg_write32(dev->regs, 0x00040C, core_rx_enable);
        mqnic_reg_read32(dev->regs, 0x00040C); //dummy read
        printf("core RX enable readback %08x\n",  mqnic_reg_read32(dev->regs, 0x00040C));

        printf("Core enable mask: 0x%08x\n", core_enable);
        mqnic_reg_write32(dev->regs, 0x000410, ~core_enable);
        mqnic_reg_write32(dev->regs, 0x000410, ~core_enable);
        mqnic_reg_read32(dev->regs, 0x000410); //dummy read
        unsigned int temp = mqnic_reg_read32(dev->regs, 0x000410);
        printf("core enable readback %08x\n",  ~temp);

        printf("Done!\n");

        free(i_segment);
        free(d_segment);
        free(r_segment);
    }

err:

    mqnic_close(dev);

    return ret;
}

