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
        " -d name    device to open (/sys/bus/pci/devices/.../resource0)\n"
        " -o file    output CSV file name (output.csv)\n",
        name);
}

int main(int argc, char *argv[])
{
    char *name;
    int opt;
    int ret = 0;

    char *device = NULL;
    struct mqnic *dev;

    char *output_file_name = NULL;
    FILE *output_file = NULL;

    name = strrchr(argv[0], '/');
    name = name ? 1+name : argv[0];

    while ((opt = getopt(argc, argv, "d:o:h?")) != EOF)
    {
        switch (opt)
        {
        case 'd':
            device = optarg;
            break;
        case 'o':
            output_file_name = optarg;
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

    int core_count = MAX_CORE_COUNT;
    int if_count = MAX_IF_COUNT;

    char need_comma;

    uint32_t temp;

    uint64_t core_rx_bytes[MAX_CORE_COUNT];
    uint64_t core_tx_bytes[MAX_CORE_COUNT];
    uint64_t core_rx_frames[MAX_CORE_COUNT];
    uint64_t core_tx_frames[MAX_CORE_COUNT];

    uint32_t core_rx_bytes_raw[MAX_CORE_COUNT];
    uint32_t core_tx_bytes_raw[MAX_CORE_COUNT];
    uint32_t core_rx_frames_raw[MAX_CORE_COUNT];
    uint32_t core_tx_frames_raw[MAX_CORE_COUNT];

    uint64_t if_rx_bytes[MAX_IF_COUNT];
    uint64_t if_tx_bytes[MAX_IF_COUNT];
    uint64_t if_rx_frames[MAX_IF_COUNT];
    uint64_t if_tx_frames[MAX_IF_COUNT];

    uint32_t if_rx_bytes_raw[MAX_IF_COUNT];
    uint32_t if_tx_bytes_raw[MAX_IF_COUNT];
    uint32_t if_rx_frames_raw[MAX_IF_COUNT];
    uint32_t if_tx_frames_raw[MAX_IF_COUNT];

    uint64_t total_rx_bytes;
    uint64_t total_tx_bytes;
    uint64_t total_rx_frames;
    uint64_t total_tx_frames;

    if (output_file_name)
    {
        output_file = fopen(output_file_name, "w");

        if (!output_file)
        {
            perror("failed to open file");
            ret = -1;
            goto err;
        }

        need_comma = 0;

        for (int k=0; k<core_count; k++)
        {
            if (need_comma)
                fprintf(output_file, ",");
            fprintf(output_file, "core_%d_rx_b,core_%d_tx_b,core_%d_rx_f,core_%d_tx_f", k, k, k, k);
            need_comma = 1;
        }

        for (int k=0; k<if_count; k++)
        {
            if (need_comma)
                fprintf(output_file, ",");
            fprintf(output_file, "if_%d_rx_b,if_%d_tx_b,if_%d_rx_f,if_%d_tx_f", k, k, k, k);
            need_comma = 1;
        }

        fprintf(output_file, "\n");
        fflush(output_file);
    }

    for (int k=0; k<core_count; k++)
    {
        mqnic_reg_write32(dev->regs, 0x000410, k);
        core_rx_bytes[k] = 0;
        core_tx_bytes[k] = 0;
        core_rx_frames[k] = 0;
        core_tx_frames[k] = 0;
        core_rx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x000414);
        core_tx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x000418);
        core_rx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x00041C);
        core_tx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x000420);
    }

    for (int k=0; k<if_count; k++)
    {
        mqnic_reg_write32(dev->regs, 0x000414, k);
        if_rx_bytes[k] = 0;
        if_tx_bytes[k] = 0;
        if_rx_frames[k] = 0;
        if_tx_frames[k] = 0;
        if_rx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x000424);
        if_tx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x000428);
        if_rx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x00042C);
        if_tx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x000430);
    }

    while (1)
    {
        sleep(1);

        for (int k=0; k<core_count; k++)
        {
            mqnic_reg_write32(dev->regs, 0x000410, k);

            temp = mqnic_reg_read32(dev->regs, 0x000414);
            core_rx_bytes[k] = temp - core_rx_bytes_raw[k];
            core_rx_bytes_raw[k] = temp;

            temp = mqnic_reg_read32(dev->regs, 0x000418);
            core_tx_bytes[k] = temp - core_tx_bytes_raw[k];
            core_tx_bytes_raw[k] = temp;

            temp = mqnic_reg_read32(dev->regs, 0x00041C);
            core_rx_frames[k] = temp - core_rx_frames_raw[k];
            core_rx_frames_raw[k] = temp;

            temp = mqnic_reg_read32(dev->regs, 0x000420);
            core_tx_frames[k] = temp - core_tx_frames_raw[k];
            core_tx_frames_raw[k] = temp;
        }

        for (int k=0; k<if_count; k++)
        {
            mqnic_reg_write32(dev->regs, 0x000414, k);

            temp = mqnic_reg_read32(dev->regs, 0x000424);
            if_rx_bytes[k] = temp - if_rx_bytes_raw[k];
            if_rx_bytes_raw[k] = temp;

            temp = mqnic_reg_read32(dev->regs, 0x000428);
            if_tx_bytes[k] = temp - if_tx_bytes_raw[k];
            if_tx_bytes_raw[k] = temp;

            temp = mqnic_reg_read32(dev->regs, 0x00042C);
            if_rx_frames[k] = temp - if_rx_frames_raw[k];
            if_rx_frames_raw[k] = temp;

            temp = mqnic_reg_read32(dev->regs, 0x000430);
            if_tx_frames[k] = temp - if_tx_frames_raw[k];
            if_tx_frames_raw[k] = temp;
        }

        printf("             RX bytes      TX bytes     RX frames     TX frames\n");

        total_rx_bytes = 0;
        total_tx_bytes = 0;
        total_rx_frames = 0;
        total_tx_frames = 0;

        for (int k=0; k<core_count; k++)
        {
            printf("core %2d  %12ld  %12ld  %12ld  %12ld\n", k, core_rx_bytes[k], core_tx_bytes[k], core_rx_frames[k], core_tx_frames[k]);
            total_rx_bytes += core_rx_bytes[k];
            total_tx_bytes += core_tx_bytes[k];
            total_rx_frames += core_rx_frames[k];
            total_tx_frames += core_tx_frames[k];
        }

        printf("total    %12ld  %12ld  %12ld  %12ld\n", total_rx_bytes, total_tx_bytes, total_rx_frames, total_tx_frames);

        total_rx_bytes = 0;
        total_tx_bytes = 0;
        total_rx_frames = 0;
        total_tx_frames = 0;

        for (int k=0; k<if_count; k++)
        {
            printf("if   %2d  %12ld  %12ld  %12ld  %12ld\n", k, if_rx_bytes[k], if_tx_bytes[k], if_rx_frames[k], if_tx_frames[k]);
            total_rx_bytes += if_rx_bytes[k];
            total_tx_bytes += if_tx_bytes[k];
            total_rx_frames += if_rx_frames[k];
            total_tx_frames += if_tx_frames[k];
        }

        printf("total    %12ld  %12ld  %12ld  %12ld\n", total_rx_bytes, total_tx_bytes, total_rx_frames, total_tx_frames);

        if (output_file)
        {
            need_comma = 0;

            for (int k=0; k<core_count; k++)
            {
                if (need_comma)
                    fprintf(output_file, ",");
                fprintf(output_file, "%ld,%ld,%ld,%ld", core_rx_bytes[k], core_tx_bytes[k], core_rx_frames[k], core_tx_frames[k]);
                need_comma = 1;
            }

            for (int k=0; k<if_count; k++)
            {
                if (need_comma)
                    fprintf(output_file, ",");
                fprintf(output_file, "%ld,%ld,%ld,%ld", if_rx_bytes[k], if_tx_bytes[k], if_rx_frames[k], if_tx_frames[k]);
                need_comma = 1;
            }

            fprintf(output_file, "\n");
            fflush(output_file);
        }
    }

err:

    mqnic_close(dev);

    return ret;
}




