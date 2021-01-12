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

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "mqnic.h"
#include "timespec.h"

#define MAX_CORE_COUNT 16
#define MAX_IF_COUNT 3

static volatile sig_atomic_t keep_running = 1;

static void sig_handler(int _)
{
    keep_running = 0;
}

static void usage(char *name)
{
    fprintf(stderr,
        "usage: %s [options]\n"
        " -d name    device to open (/sys/bus/pci/devices/.../resource0)\n"
        " -o file    output CSV file name (output.csv)\n"
        " -g reg     debug register number (8)\n",
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

    int debug_reg = 0x0;

    name = strrchr(argv[0], '/');
    name = name ? 1+name : argv[0];

    signal(SIGINT, sig_handler);

    while ((opt = getopt(argc, argv, "d:o:g:h?")) != EOF)
    {
        switch (opt)
        {
        case 'd':
            device = optarg;
            break;
        case 'o':
            output_file_name = optarg;
            break;
        case 'g':
            debug_reg = atoi(optarg);
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

    uint64_t core_slots[MAX_CORE_COUNT];
    bool extra_slot_count = false;
    bool scheduler_drop = false;

    uint32_t temp, temp2;
    uint32_t updates = 0;

    uint64_t core_rx_bytes[MAX_CORE_COUNT];
    uint64_t core_tx_bytes[MAX_CORE_COUNT];
    uint64_t core_rx_frames[MAX_CORE_COUNT];
    uint64_t core_tx_frames[MAX_CORE_COUNT];
    uint64_t core_rx_stalls[MAX_CORE_COUNT];
    uint64_t core_tx_stalls[MAX_CORE_COUNT];

    uint64_t total_core_rx_bytes[MAX_CORE_COUNT];
    uint64_t total_core_tx_bytes[MAX_CORE_COUNT];
    uint64_t total_core_rx_frames[MAX_CORE_COUNT];
    uint64_t total_core_tx_frames[MAX_CORE_COUNT];
    uint64_t total_core_rx_stalls[MAX_CORE_COUNT];
    uint64_t total_core_tx_stalls[MAX_CORE_COUNT];

    uint32_t core_rx_bytes_raw[MAX_CORE_COUNT];
    uint32_t core_tx_bytes_raw[MAX_CORE_COUNT];
    uint32_t core_rx_frames_raw[MAX_CORE_COUNT];
    uint32_t core_tx_frames_raw[MAX_CORE_COUNT];
    uint32_t core_rx_stalls_raw[MAX_CORE_COUNT];
    uint32_t core_tx_stalls_raw[MAX_CORE_COUNT];

    uint64_t if_rx_bytes[MAX_IF_COUNT];
    uint64_t if_tx_bytes[MAX_IF_COUNT];
    uint64_t if_rx_frames[MAX_IF_COUNT];
    uint64_t if_tx_frames[MAX_IF_COUNT];
    uint64_t if_rx_stalls[MAX_IF_COUNT];
    uint64_t if_tx_stalls[MAX_IF_COUNT];
    uint64_t if_rx_drops[MAX_IF_COUNT];
    uint64_t if_sched_stat[MAX_IF_COUNT];

    uint64_t total_if_rx_bytes[MAX_IF_COUNT];
    uint64_t total_if_tx_bytes[MAX_IF_COUNT];
    uint64_t total_if_rx_frames[MAX_IF_COUNT];
    uint64_t total_if_tx_frames[MAX_IF_COUNT];
    uint64_t total_if_rx_drops[MAX_IF_COUNT];
    uint64_t total_if_sched_stat[MAX_IF_COUNT];

    uint32_t if_rx_bytes_raw[MAX_IF_COUNT];
    uint32_t if_tx_bytes_raw[MAX_IF_COUNT];
    uint32_t if_rx_frames_raw[MAX_IF_COUNT];
    uint32_t if_tx_frames_raw[MAX_IF_COUNT];
    uint32_t if_rx_stalls_raw[MAX_IF_COUNT];
    uint32_t if_tx_stalls_raw[MAX_IF_COUNT];
    uint32_t if_rx_drops_raw[MAX_IF_COUNT];
    uint32_t if_sched_stat_raw[MAX_IF_COUNT];

    uint64_t total_rx_bytes;
    uint64_t total_tx_bytes;
    uint64_t total_rx_frames;
    uint64_t total_tx_frames;
    uint64_t total_rx_stalls;
    uint64_t total_tx_stalls;
    uint64_t total_rx_drops;

    struct timespec desired_time;
    struct timespec current_time;
    struct timespec sleep_time;

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
            fprintf(output_file, "if_%d_rx_b,if_%d_tx_b,if_%d_rx_f,if_%d_tx_f,if_%d_rx_drop", k, k, k, k, k);
            need_comma = 1;
        }

        fprintf(output_file, "\n");
        fflush(output_file);
    }

    clock_gettime(CLOCK_MONOTONIC, &desired_time);

    for (int k=0; k<core_count; k++)
    {
        core_rx_bytes[k] = 0;
        core_tx_bytes[k] = 0;
        core_rx_frames[k] = 0;
        core_tx_frames[k] = 0;
        total_core_rx_bytes[k] = 0;
        total_core_tx_bytes[k] = 0;
        total_core_rx_frames[k] = 0;
        total_core_tx_frames[k] = 0;

        mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x0);
        core_rx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
        core_rx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x000424);
        mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x2);
        core_tx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
        core_tx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x000424);
        mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x1);
        core_rx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
        core_rx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x000424);
        mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x3);
        core_tx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
        core_tx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x000424);
        mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x6);
        core_rx_stalls_raw[k] = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
        core_rx_stalls_raw[k] = mqnic_reg_read32(dev->regs, 0x000424);
        mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x7);
        core_tx_stalls_raw[k] = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
        core_tx_stalls_raw[k] = mqnic_reg_read32(dev->regs, 0x000424);
    }

    for (int k=0; k<if_count; k++)
    {
        if_rx_bytes[k] = 0;
        if_tx_bytes[k] = 0;
        if_rx_frames[k] = 0;
        if_tx_frames[k] = 0;
        if_rx_stalls[k] = 0;
        if_tx_stalls[k] = 0;
        if_rx_drops[k] = 0;
        if_sched_stat[k] = 0;
        total_if_rx_bytes[k] = 0;
        total_if_tx_bytes[k] = 0;
        total_if_rx_frames[k] = 0;
        total_if_tx_frames[k] = 0;
        total_if_rx_drops[k] = 0;
        total_if_sched_stat[k] = 0;

        mqnic_reg_write32(dev->regs, 0x000418, k<<8|0);
        if_rx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x000428); // dummy read
        if_rx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x000428);
        if_tx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x00042C); // dummy read
        if_tx_bytes_raw[k] = mqnic_reg_read32(dev->regs, 0x00042C);
        mqnic_reg_write32(dev->regs, 0x000418, k<<8|1);
        if_rx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x000428); // dummy read
        if_rx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x000428);
        if_tx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x00042C); // dummy read
        if_tx_frames_raw[k] = mqnic_reg_read32(dev->regs, 0x00042C);
        mqnic_reg_write32(dev->regs, 0x000418, k<<8|3);
        if_rx_stalls_raw[k] = mqnic_reg_read32(dev->regs, 0x000428); // dummy read
        if_rx_stalls_raw[k] = mqnic_reg_read32(dev->regs, 0x000428);
        if_tx_stalls_raw[k] = mqnic_reg_read32(dev->regs, 0x00042C); // dummy read
        if_tx_stalls_raw[k] = mqnic_reg_read32(dev->regs, 0x00042C);
        mqnic_reg_write32(dev->regs, 0x000418, k<<8|2);
        if_rx_drops_raw[k] = mqnic_reg_read32(dev->regs, 0x000428); // dummy read
        if_rx_drops_raw[k] = mqnic_reg_read32(dev->regs, 0x000428);
        mqnic_reg_write32(dev->regs, 0x000418, k<<8);
        if_sched_stat_raw[k] = mqnic_reg_read32(dev->regs, 0x000430); // dummy read
        if_sched_stat_raw[k] = mqnic_reg_read32(dev->regs, 0x000430);

    }

    while (keep_running)
    {
        for (int k=0; k<core_count; k++)
        {
            core_rx_bytes[k] = 0;
            core_tx_bytes[k] = 0;
            core_rx_frames[k] = 0;
            core_tx_frames[k] = 0;
            core_rx_stalls[k] = 0;
            core_tx_stalls[k] = 0;
        }

        for (int k=0; k<if_count; k++)
        {
            if_rx_bytes[k] = 0;
            if_tx_bytes[k] = 0;
            if_rx_frames[k] = 0;
            if_tx_frames[k] = 0;
            if_rx_stalls[k] = 0;
            if_tx_stalls[k] = 0;
            if_rx_drops[k] = 0;
            if_sched_stat[k] = 0;
        }

        for (int n=0; n < 10; n++)
        {

            desired_time = timespec_add(timespec_from_ms(100), desired_time);
            clock_gettime(CLOCK_MONOTONIC, &current_time);
            // printf("Current time: %ld\n", timespec_to_ms(current_time));
            sleep_time = timespec_sub(desired_time, current_time);
            nanosleep(&sleep_time, NULL);

            for (int k=0; k<core_count; k++)
            {
                mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x0);
                temp = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000424);
                core_rx_bytes[k] += temp - core_rx_bytes_raw[k];
                core_rx_bytes_raw[k] = temp;

                mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x2);
                temp = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000424);
                core_tx_bytes[k] += temp - core_tx_bytes_raw[k];
                core_tx_bytes_raw[k] = temp;

                mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x1);
                temp = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000424);
                core_rx_frames[k] += temp - core_rx_frames_raw[k];
                core_rx_frames_raw[k] = temp;

                mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x3);
                temp = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000424);
                core_tx_frames[k] += temp - core_tx_frames_raw[k];
                core_tx_frames_raw[k] = temp;

                mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x6);
                temp = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000424);
                core_rx_stalls[k] += temp - core_rx_stalls_raw[k];
                core_rx_stalls_raw[k] = temp;

                mqnic_reg_write32(dev->regs, 0x000414, k<<4|0x7);
                temp = mqnic_reg_read32(dev->regs, 0x000424); //dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000424);
                core_tx_stalls[k] += temp - core_tx_stalls_raw[k];
                core_tx_stalls_raw[k] = temp;

                mqnic_reg_write32(dev->regs, 0x000414, k<<4);
                mqnic_reg_read32(dev->regs, 0x000420); //dummy read
                core_slots[k] = mqnic_reg_read32(dev->regs, 0x000420);

                if (extra_slot_count){
                    printf("core %d has %ld slots in scheduler. ", k, core_slots[k]);
                }

            }

            for (int k=0; k<if_count; k++)
            {
                mqnic_reg_write32(dev->regs, 0x000418, k<<8|0);
                temp = mqnic_reg_read32(dev->regs, 0x000428); // dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000428);
                if_rx_bytes[k] += temp - if_rx_bytes_raw[k];
                if_rx_bytes_raw[k] = temp;

                temp = mqnic_reg_read32(dev->regs, 0x00042C); // dummy read
                temp = mqnic_reg_read32(dev->regs, 0x00042C);
                if_tx_bytes[k] += temp - if_tx_bytes_raw[k];
                if_tx_bytes_raw[k] = temp;

                mqnic_reg_write32(dev->regs, 0x000418, k<<8|1);
                temp = mqnic_reg_read32(dev->regs, 0x000428); // dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000428);
                if_rx_frames[k] += temp - if_rx_frames_raw[k];
                if_rx_frames_raw[k] = temp;

                temp = mqnic_reg_read32(dev->regs, 0x00042C); // dummy read
                temp = mqnic_reg_read32(dev->regs, 0x00042C);
                if_tx_frames[k] += temp - if_tx_frames_raw[k];
                if_tx_frames_raw[k] = temp;

                mqnic_reg_write32(dev->regs, 0x000418, k<<8|3);
                temp = mqnic_reg_read32(dev->regs, 0x000428); // dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000428);
                if_rx_stalls[k] += temp - if_rx_stalls_raw[k];
                if_rx_stalls_raw[k] = temp;

                temp = mqnic_reg_read32(dev->regs, 0x00042C); // dummy read
                temp = mqnic_reg_read32(dev->regs, 0x00042C);
                if_tx_stalls[k] += temp - if_tx_stalls_raw[k];
                if_tx_stalls_raw[k] = temp;

                mqnic_reg_write32(dev->regs, 0x000418, k<<8|2);
                temp = mqnic_reg_read32(dev->regs, 0x000428); // dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000428);
                if_rx_drops[k] += temp - if_rx_drops_raw[k];
                if_rx_drops_raw[k] = temp;

                mqnic_reg_write32(dev->regs, 0x000418, k<<8);
                temp = mqnic_reg_read32(dev->regs, 0x000430); // dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000430);
                if (scheduler_drop)
                  if_sched_stat[k] += temp - if_sched_stat_raw[k];
                if_sched_stat_raw[k] = temp;

            }

            if (!keep_running)
                break;
        }

        // read core status
        if (debug_reg>=8) {
	    for (int k=0; k<core_count; k++) {
                mqnic_reg_write32(dev->regs, 0x000414, k<<4|debug_reg);
                mqnic_reg_read32(dev->regs, 0x000424); //dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000424);
                if (temp!=0)
                  printf("core %d status: %08x \n", k, temp);
	    }
	} else if ((debug_reg==4) || (debug_reg==5)){
	    for (int k=0; k<core_count; k++) {
                mqnic_reg_write32(dev->regs, 0x000414, k<<4|4);
                mqnic_reg_read32(dev->regs, 0x000424); //dummy read
                temp = mqnic_reg_read32(dev->regs, 0x000424);
                mqnic_reg_write32(dev->regs, 0x000414, k<<4|5);
                mqnic_reg_read32(dev->regs, 0x000424); //dummy read
                temp2 = mqnic_reg_read32(dev->regs, 0x000424);
                if ((temp!=0)||(temp2!=0))
                  printf("core %d debug_l: %08x, debug_h: %08x\n", k, temp, temp2);
	    }
	}

        if (!keep_running)
            break;

        printf("\n");
        printf("             RX bytes      TX bytes     RX frames     TX frames      RX drops      RX stalls      TX stalls    Avail slots\n");

        total_rx_bytes = 0;
        total_tx_bytes = 0;
        total_rx_frames = 0;
        total_tx_frames = 0;
        total_rx_stalls = 0;
        total_tx_stalls = 0;

        for (int k=0; k<core_count; k++)
        {
            printf("core %2d  %12ld  %12ld  %12ld  %12ld                 %12ld   %12ld   %12ld\n", k, core_rx_bytes[k], core_tx_bytes[k], core_rx_frames[k], core_tx_frames[k], core_rx_stalls[k], core_tx_stalls[k], core_slots[k]);
            total_core_rx_bytes[k] += core_rx_bytes[k];
            total_core_tx_bytes[k] += core_tx_bytes[k];
            total_core_rx_frames[k] += core_rx_frames[k];
            total_core_tx_frames[k] += core_tx_frames[k];
            total_core_rx_stalls[k] += core_rx_stalls[k];
            total_core_tx_stalls[k] += core_tx_stalls[k];
            total_rx_bytes += core_rx_bytes[k];
            total_tx_bytes += core_tx_bytes[k];
            total_rx_frames += core_rx_frames[k];
            total_tx_frames += core_tx_frames[k];
            total_rx_stalls += core_rx_stalls[k];
            total_tx_stalls += core_tx_stalls[k];
        }

        printf("total    %12ld  %12ld  %12ld  %12ld                 %12ld   %12ld\n", total_rx_bytes, total_tx_bytes, total_rx_frames, total_tx_frames, total_rx_stalls, total_tx_stalls);

        total_rx_bytes = 0;
        total_tx_bytes = 0;
        total_rx_frames = 0;
        total_tx_frames = 0;
        total_rx_drops = 0;

        for (int k=0; k<if_count; k++)
        {
            printf("if   %2d  %12ld  %12ld  %12ld  %12ld  %12ld   %12ld   %12ld   %12ld\n", k, if_rx_bytes[k], if_tx_bytes[k], if_rx_frames[k], if_tx_frames[k], if_rx_drops[k], if_rx_stalls[k], if_tx_stalls[k], if_sched_stat[k]);
            total_if_rx_bytes[k] += if_rx_bytes[k];
            total_if_tx_bytes[k] += if_tx_bytes[k];
            total_if_rx_frames[k] += if_rx_frames[k];
            total_if_tx_frames[k] += if_tx_frames[k];
            total_if_rx_drops[k] += if_rx_drops[k];
            total_if_sched_stat[k] += if_sched_stat[k];
            total_rx_bytes += if_rx_bytes[k];
            total_tx_bytes += if_tx_bytes[k];
            total_rx_frames += if_rx_frames[k];
            total_tx_frames += if_tx_frames[k];
            total_rx_stalls += if_rx_stalls[k];
            total_tx_stalls += if_tx_stalls[k];
            total_rx_drops += (if_rx_drops[k]+if_sched_stat[k]);
        }

        updates++;

        printf("total    %12ld  %12ld  %12ld  %12ld  %12ld   %12ld   %12ld\n", total_rx_bytes, total_tx_bytes, total_rx_frames, total_tx_frames, total_rx_drops, total_rx_stalls, total_tx_stalls);

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
                fprintf(output_file, "%ld,%ld,%ld,%ld,%ld,%ld", if_rx_bytes[k], if_tx_bytes[k], if_rx_frames[k], if_tx_frames[k], if_rx_drops[k], if_sched_stat[k]);
                need_comma = 1;
            }

            fprintf(output_file, "\n");
            fflush(output_file);
        }
    }

    printf("\n");
    printf("Totals (%d seconds):\n", updates);

    printf("\n");
    printf("             RX bytes      TX bytes     RX frames     TX frames      RX drops\n");

    total_rx_bytes = 0;
    total_tx_bytes = 0;
    total_rx_frames = 0;
    total_tx_frames = 0;

    for (int k=0; k<core_count; k++)
    {
        printf("core %2d  %12ld  %12ld  %12ld  %12ld\n", k, total_core_rx_bytes[k], total_core_tx_bytes[k], total_core_rx_frames[k], total_core_tx_frames[k]);
        total_rx_bytes += total_core_rx_bytes[k];
        total_tx_bytes += total_core_tx_bytes[k];
        total_rx_frames += total_core_rx_frames[k];
        total_tx_frames += total_core_tx_frames[k];
    }

    printf("total    %12ld  %12ld %12ld   %12ld\n", total_rx_bytes, total_tx_bytes, total_rx_frames, total_tx_frames);

    total_rx_bytes = 0;
    total_tx_bytes = 0;
    total_rx_frames = 0;
    total_tx_frames = 0;
    total_rx_drops = 0;

    for (int k=0; k<if_count; k++)
    {
        printf("if   %2d  %12ld  %12ld  %12ld  %12ld  %12ld  %12ld\n", k, total_if_rx_bytes[k], total_if_tx_bytes[k], total_if_rx_frames[k], total_if_tx_frames[k], total_if_rx_drops[k], total_if_sched_stat[k]);
        total_rx_bytes += total_if_rx_bytes[k];
        total_tx_bytes += total_if_tx_bytes[k];
        total_rx_frames += total_if_rx_frames[k];
        total_tx_frames += total_if_tx_frames[k];
        total_rx_drops += (total_if_rx_drops[k]+total_if_sched_stat[k]);
    }

    printf("total    %12ld  %12ld  %12ld  %12ld  %12ld\n", total_rx_bytes, total_tx_bytes, total_rx_frames, total_tx_frames, total_rx_drops);

    printf("\n");
    printf("Averages (%d seconds):\n", updates);

    printf("\n");
    printf("             RX bytes      TX bytes     RX frames     TX frames      RX drops\n");

    total_rx_bytes = 0;
    total_tx_bytes = 0;
    total_rx_frames = 0;
    total_tx_frames = 0;

    for (int k=0; k<core_count; k++)
    {
        printf("core %2d  %12ld  %12ld  %12ld  %12ld\n", k, total_core_rx_bytes[k]/updates, total_core_tx_bytes[k]/updates, total_core_rx_frames[k]/updates, total_core_tx_frames[k]/updates);
        total_rx_bytes += total_core_rx_bytes[k];
        total_tx_bytes += total_core_tx_bytes[k];
        total_rx_frames += total_core_rx_frames[k];
        total_tx_frames += total_core_tx_frames[k];
    }

    printf("total    %12ld  %12ld  %12ld  %12ld\n", total_rx_bytes/updates, total_tx_bytes/updates, total_rx_frames/updates, total_tx_frames/updates);

    total_rx_bytes = 0;
    total_tx_bytes = 0;
    total_rx_frames = 0;
    total_tx_frames = 0;
    total_rx_drops = 0;

    for (int k=0; k<if_count; k++)
    {
        printf("if   %2d  %12ld  %12ld  %12ld  %12ld %12ld %12ld\n", k, total_if_rx_bytes[k]/updates, total_if_tx_bytes[k]/updates, total_if_rx_frames[k]/updates, total_if_tx_frames[k]/updates, total_if_rx_drops[k]/updates, total_if_sched_stat[k]/updates);
        total_rx_bytes += total_if_rx_bytes[k];
        total_tx_bytes += total_if_tx_bytes[k];
        total_rx_frames += total_if_rx_frames[k];
        total_tx_frames += total_if_tx_frames[k];
        total_rx_drops += total_if_rx_drops[k]+total_if_sched_stat[k];
    }

    printf("total    %12ld  %12ld  %12ld  %12ld %12ld\n", total_rx_bytes/updates, total_tx_bytes/updates, total_rx_frames/updates, total_tx_frames/updates, total_rx_drops/updates);

err:

    mqnic_close(dev);

    return ret;
}




