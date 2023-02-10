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

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "mqnic.h"
#include "rpu.h"
#include "timespec.h"

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

    int core_count = RPU_COUNT;
    int if_count = MAX_ETH_IF_COUNT; // To be updated

    char need_comma;

    uint64_t core_slots[RPU_COUNT];
    bool extra_slot_count = false;

    uint32_t temp, temp2;
    uint32_t updates = 0;

    uint64_t core_rx_bytes [RPU_COUNT];
    uint64_t core_rx_frames[RPU_COUNT];
    uint64_t core_rx_stalls[RPU_COUNT];
    uint64_t core_tx_bytes [RPU_COUNT];
    uint64_t core_tx_frames[RPU_COUNT];
    uint64_t core_tx_stalls[RPU_COUNT];

    uint64_t total_core_rx_bytes [RPU_COUNT];
    uint64_t total_core_rx_frames[RPU_COUNT];
    uint64_t total_core_rx_stalls[RPU_COUNT];
    uint64_t total_core_tx_bytes [RPU_COUNT];
    uint64_t total_core_tx_frames[RPU_COUNT];
    uint64_t total_core_tx_stalls[RPU_COUNT];

    uint32_t core_rx_bytes_raw [RPU_COUNT];
    uint32_t core_rx_frames_raw[RPU_COUNT];
    uint32_t core_rx_stalls_raw[RPU_COUNT];
    uint32_t core_tx_bytes_raw [RPU_COUNT];
    uint32_t core_tx_frames_raw[RPU_COUNT];
    uint32_t core_tx_stalls_raw[RPU_COUNT];

    uint64_t if_rx_bytes [MAX_TOT_IF_COUNT];
    uint64_t if_rx_frames[MAX_TOT_IF_COUNT];
    uint64_t if_rx_stalls[MAX_TOT_IF_COUNT];
    uint64_t if_rx_drops [MAX_TOT_IF_COUNT];
    uint64_t if_tx_bytes [MAX_TOT_IF_COUNT];
    uint64_t if_tx_frames[MAX_TOT_IF_COUNT];
    uint64_t if_tx_stalls[MAX_TOT_IF_COUNT];
    uint64_t if_lb_drop  [MAX_ETH_IF_COUNT];

    uint64_t total_if_rx_bytes [MAX_TOT_IF_COUNT];
    uint64_t total_if_rx_frames[MAX_TOT_IF_COUNT];
    uint64_t total_if_rx_drops [MAX_TOT_IF_COUNT];
    uint64_t total_if_tx_bytes [MAX_TOT_IF_COUNT];
    uint64_t total_if_tx_frames[MAX_TOT_IF_COUNT];
    uint64_t total_if_lb_drop  [MAX_ETH_IF_COUNT];

    uint32_t if_rx_bytes_raw [MAX_TOT_IF_COUNT];
    uint32_t if_rx_frames_raw[MAX_TOT_IF_COUNT];
    uint32_t if_rx_stalls_raw[MAX_TOT_IF_COUNT];
    uint32_t if_rx_drops_raw [MAX_TOT_IF_COUNT];
    uint32_t if_tx_bytes_raw [MAX_TOT_IF_COUNT];
    uint32_t if_tx_frames_raw[MAX_TOT_IF_COUNT];
    uint32_t if_tx_stalls_raw[MAX_TOT_IF_COUNT];
    uint32_t if_lb_drop_raw  [MAX_ETH_IF_COUNT];

    uint64_t total_rx_bytes;
    uint64_t total_rx_frames;
    uint64_t total_rx_stalls;
    uint64_t total_rx_drops;
    uint64_t total_tx_bytes;
    uint64_t total_tx_frames;
    uint64_t total_tx_stalls;

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
        core_rx_bytes [k]       = 0;
        core_rx_frames[k]       = 0;
        core_tx_bytes [k]       = 0;
        core_tx_frames[k]       = 0;
        total_core_rx_bytes [k] = 0;
        total_core_rx_frames[k] = 0;
        total_core_tx_bytes [k] = 0;
        total_core_tx_frames[k] = 0;

        core_rx_bytes_raw [k] = core_rd_cmd(dev, k, 0);
        core_rx_frames_raw[k] = core_rd_cmd(dev, k, 1);
        core_rx_stalls_raw[k] = core_rd_cmd(dev, k, 2);
        core_tx_bytes_raw [k] = core_rd_cmd(dev, k, 3);
        core_tx_frames_raw[k] = core_rd_cmd(dev, k, 4);
        core_tx_stalls_raw[k] = core_rd_cmd(dev, k, 5);
    }

    for (int k=0; k<if_count; k++)
    {
        if_rx_bytes       [k] = 0;
        if_rx_frames      [k] = 0;
        if_rx_stalls      [k] = 0;
        if_rx_drops       [k] = 0;
        if_tx_bytes       [k] = 0;
        if_tx_frames      [k] = 0;
        if_tx_stalls      [k] = 0;
        if_lb_drop        [k] = 0;
        total_if_rx_bytes [k] = 0;
        total_if_rx_frames[k] = 0;
        total_if_rx_drops [k] = 0;
        total_if_tx_bytes [k] = 0;
        total_if_tx_frames[k] = 0;
        total_if_lb_drop  [k] = 0;

        if_rx_bytes_raw [k] = interface_stat_rd(dev, k, 0, 0);
        if_rx_frames_raw[k] = interface_stat_rd(dev, k, 0, 1);
        if_rx_drops_raw [k] = interface_stat_rd(dev, k, 0, 2);
        if_rx_stalls_raw[k] = interface_stat_rd(dev, k, 0, 3);
        if_tx_bytes_raw [k] = interface_stat_rd(dev, k, 1, 0);
        if_tx_frames_raw[k] = interface_stat_rd(dev, k, 1, 1);
        if_tx_stalls_raw[k] = interface_stat_rd(dev, k, 1, 3);
        if_lb_drop_raw  [k] = read_interface_drops(dev, k);

        // When LB doesn't report drops
        if (if_lb_drop_raw[k]==0xFEFEFEFE) if_lb_drop_raw[k]=0;
    }

    while (keep_running)
    {
        for (int k=0; k<core_count; k++)
        {
            core_rx_bytes [k] = 0;
            core_rx_frames[k] = 0;
            core_rx_stalls[k] = 0;
            core_tx_bytes [k] = 0;
            core_tx_frames[k] = 0;
            core_tx_stalls[k] = 0;
        }

        for (int k=0; k<if_count; k++)
        {
            if_rx_bytes [k] = 0;
            if_rx_frames[k] = 0;
            if_rx_stalls[k] = 0;
            if_rx_drops [k] = 0;
            if_tx_bytes [k] = 0;
            if_tx_frames[k] = 0;
            if_tx_stalls[k] = 0;
            if_lb_drop  [k] = 0;
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
                temp = core_rd_cmd(dev, k, 0);
                core_rx_bytes[k] += temp - core_rx_bytes_raw[k];
                core_rx_bytes_raw[k] = temp;

                temp = core_rd_cmd(dev, k, 1);
                core_rx_frames[k] += temp - core_rx_frames_raw[k];
                core_rx_frames_raw[k] = temp;

                temp = core_rd_cmd(dev, k, 2);
                core_rx_stalls[k] += temp - core_rx_stalls_raw[k];
                core_rx_stalls_raw[k] = temp;

                temp = core_rd_cmd(dev, k, 3);
                core_tx_bytes[k] += temp - core_tx_bytes_raw[k];
                core_tx_bytes_raw[k] = temp;

                temp = core_rd_cmd(dev, k, 4);
                core_tx_frames[k] += temp - core_tx_frames_raw[k];
                core_tx_frames_raw[k] = temp;

                temp = core_rd_cmd(dev, k, 5);
                core_tx_stalls[k] += temp - core_tx_stalls_raw[k];
                core_tx_stalls_raw[k] = temp;

                core_slots[k] = read_core_slots(dev, k);

                if (extra_slot_count){
                    printf("core %d has %ld slots in LB. ", k, core_slots[k]);
                }

            }

            for (int k=0; k<if_count; k++)
            {

                temp = interface_stat_rd(dev, k, 0, 0);
                if_rx_bytes[k] += temp - if_rx_bytes_raw[k];
                if_rx_bytes_raw[k] = temp;

                temp = interface_stat_rd(dev, k, 0, 1);
                if_rx_frames[k] += temp - if_rx_frames_raw[k];
                if_rx_frames_raw[k] = temp;

                temp = interface_stat_rd(dev, k, 0, 2);
                if_rx_drops[k] += temp - if_rx_drops_raw[k];
                if_rx_drops_raw[k] = temp;

                temp = interface_stat_rd(dev, k, 0, 3);
                if_rx_stalls[k] += temp - if_rx_stalls_raw[k];
                if_rx_stalls_raw[k] = temp;

                temp = interface_stat_rd(dev, k, 1, 0);
                if_tx_bytes[k] += temp - if_tx_bytes_raw[k];
                if_tx_bytes_raw[k] = temp;

                temp = interface_stat_rd(dev, k, 1, 1);
                if_tx_frames[k] += temp - if_tx_frames_raw[k];
                if_tx_frames_raw[k] = temp;

                temp = interface_stat_rd(dev, k, 1, 3);
                if_tx_stalls[k] += temp - if_tx_stalls_raw[k];
                if_tx_stalls_raw[k] = temp;

                temp = read_interface_drops(dev, k);
                // When LB doesn't drop reports
                if (temp==0xFEFEFEFE) temp=0;
                if_lb_drop[k] += temp - if_lb_drop_raw[k];
                if_lb_drop_raw[k] = temp;

            }

            if (!keep_running)
                break;
        }

        // read core status
        if (debug_reg>=8) {
            for (int k=0; k<core_count; k++) {
                temp  = core_rd_cmd(dev, k, debug_reg);
                if (temp!=0)
                  printf("core %d status: %08x \n", k, temp);
            }
        } else if ((debug_reg==6) || (debug_reg==7)){
            for (int k=0; k<core_count; k++) {
                temp  = core_rd_cmd(dev, k, 6);
                temp2 = core_rd_cmd(dev, k, 7);
                if ((temp!=0)||(temp2!=0))
                    printf("core %d debug_h: %08x, debug_l: %08x\n", k, temp2, temp);
            }
        }

        if (!keep_running)
            break;

        printf("\n");
        printf("             RX bytes      TX bytes     RX frames     TX frames      RX drops      RX stalls      TX stalls    Avail slots\n");

        total_rx_bytes  = 0;
        total_rx_frames = 0;
        total_rx_stalls = 0;
        total_tx_bytes  = 0;
        total_tx_frames = 0;
        total_tx_stalls = 0;

        for (int k=0; k<core_count; k++)
        {
            printf("core %2d  %12ld  %12ld  %12ld  %12ld                 %12ld   %12ld   %12ld\n", k, core_rx_bytes[k], core_tx_bytes[k], core_rx_frames[k], core_tx_frames[k], core_rx_stalls[k], core_tx_stalls[k], core_slots[k]);
            total_core_rx_bytes [k] += core_rx_bytes [k];
            total_core_rx_frames[k] += core_rx_frames[k];
            total_core_rx_stalls[k] += core_rx_stalls[k];
            total_core_tx_bytes [k] += core_tx_bytes [k];
            total_core_tx_frames[k] += core_tx_frames[k];
            total_core_tx_stalls[k] += core_tx_stalls[k];
            total_rx_bytes  += core_rx_bytes [k];
            total_rx_frames += core_rx_frames[k];
            total_rx_stalls += core_rx_stalls[k];
            total_tx_bytes  += core_tx_bytes [k];
            total_tx_frames += core_tx_frames[k];
            total_tx_stalls += core_tx_stalls[k];
        }

        printf("total    %12ld  %12ld  %12ld  %12ld                 %12ld   %12ld\n", total_rx_bytes, total_tx_bytes, total_rx_frames, total_tx_frames, total_rx_stalls, total_tx_stalls);

        total_rx_bytes  = 0;
        total_rx_frames = 0;
        total_rx_drops  = 0;
        total_tx_bytes  = 0;
        total_tx_frames = 0;

        for (int k=0; k<if_count; k++)
        {
            printf("if   %2d  %12ld  %12ld  %12ld  %12ld  %12ld   %12ld   %12ld   %12ld\n", k, if_rx_bytes[k], if_tx_bytes[k], if_rx_frames[k], if_tx_frames[k], if_rx_drops[k], if_rx_stalls[k], if_tx_stalls[k], if_lb_drop[k]);
            total_if_rx_bytes [k] += if_rx_bytes  [k];
            total_if_rx_frames[k] += if_rx_frames [k];
            total_if_rx_drops [k] += if_rx_drops  [k];
            total_if_tx_bytes [k] += if_tx_bytes  [k];
            total_if_tx_frames[k] += if_tx_frames [k];
            total_if_lb_drop  [k] += if_lb_drop[k];
            total_rx_bytes  += if_rx_bytes [k];
            total_rx_frames += if_rx_frames[k];
            total_rx_stalls += if_rx_stalls[k];
            total_rx_drops  += (if_rx_drops[k]+if_lb_drop[k]);
            total_tx_bytes  += if_tx_bytes [k];
            total_tx_frames += if_tx_frames[k];
            total_tx_stalls += if_tx_stalls[k];
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
                fprintf(output_file, "%ld,%ld,%ld,%ld,%ld,%ld", if_rx_bytes[k], if_tx_bytes[k], if_rx_frames[k], if_tx_frames[k], if_rx_drops[k], if_lb_drop[k]);
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
        total_rx_bytes  += total_core_rx_bytes [k];
        total_rx_frames += total_core_rx_frames[k];
        total_tx_bytes  += total_core_tx_bytes [k];
        total_tx_frames += total_core_tx_frames[k];
    }

    printf("total    %12ld  %12ld %12ld   %12ld\n", total_rx_bytes, total_tx_bytes, total_rx_frames, total_tx_frames);

    total_rx_bytes  = 0;
    total_rx_frames = 0;
    total_rx_drops  = 0;
    total_tx_bytes  = 0;
    total_tx_frames = 0;

    for (int k=0; k<if_count; k++)
    {
        printf("if   %2d  %12ld  %12ld  %12ld  %12ld  %12ld  %12ld\n", k, total_if_rx_bytes[k], total_if_tx_bytes[k], total_if_rx_frames[k], total_if_tx_frames[k], total_if_rx_drops[k], total_if_lb_drop[k]);
        total_rx_bytes  += total_if_rx_bytes [k];
        total_rx_frames += total_if_rx_frames[k];
        total_rx_drops  += (total_if_rx_drops[k]+total_if_lb_drop[k]);
        total_tx_bytes  += total_if_tx_bytes [k];
        total_tx_frames += total_if_tx_frames[k];
    }

    printf("total    %12ld  %12ld  %12ld  %12ld  %12ld\n", total_rx_bytes, total_tx_bytes, total_rx_frames, total_tx_frames, total_rx_drops);

    printf("\n");
    printf("Averages (%d seconds):\n", updates);

    printf("\n");
    printf("             RX bytes      TX bytes     RX frames     TX frames      RX drops\n");

    total_rx_bytes  = 0;
    total_rx_frames = 0;
    total_tx_bytes  = 0;
    total_tx_frames = 0;

    for (int k=0; k<core_count; k++)
    {
        printf("core %2d  %12ld  %12ld  %12ld  %12ld\n", k, total_core_rx_bytes[k]/updates, total_core_tx_bytes[k]/updates, total_core_rx_frames[k]/updates, total_core_tx_frames[k]/updates);
        total_rx_bytes  += total_core_rx_bytes [k];
        total_rx_frames += total_core_rx_frames[k];
        total_tx_bytes  += total_core_tx_bytes [k];
        total_tx_frames += total_core_tx_frames[k];
    }

    printf("total    %12ld  %12ld  %12ld  %12ld\n", total_rx_bytes/updates, total_tx_bytes/updates, total_rx_frames/updates, total_tx_frames/updates);

    total_rx_bytes  = 0;
    total_rx_frames = 0;
    total_rx_drops  = 0;
    total_tx_bytes  = 0;
    total_tx_frames = 0;

    for (int k=0; k<if_count; k++)
    {
        printf("if   %2d  %12ld  %12ld  %12ld  %12ld %12ld %12ld\n", k, total_if_rx_bytes[k]/updates, total_if_tx_bytes[k]/updates, total_if_rx_frames[k]/updates, total_if_tx_frames[k]/updates, total_if_rx_drops[k]/updates, total_if_lb_drop[k]/updates);
        total_rx_bytes  += total_if_rx_bytes [k];
        total_rx_frames += total_if_rx_frames[k];
        total_tx_bytes  += total_if_tx_bytes [k];
        total_rx_drops  += total_if_rx_drops [k]+total_if_lb_drop[k];
        total_tx_frames += total_if_tx_frames[k];
    }

    printf("total    %12ld  %12ld  %12ld  %12ld %12ld\n", total_rx_bytes/updates, total_tx_bytes/updates, total_rx_frames/updates, total_tx_frames/updates, total_rx_drops/updates);

err:

    mqnic_close(dev);

    return ret;
}

