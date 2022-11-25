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

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>

#include "mqnic.h"
#include "rpu.h"

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

    // set_enable_interfaces(dev, 0);

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

        reset_all_cores(dev, 1);

        printf("Write core instruction memories...\n");
        for (int k=0; k<core_count; k++)
        {
            uint32_t core_rx_bytes_raw  = core_rd_cmd(dev, k, 0);
            uint32_t core_rx_frames_raw = core_rd_cmd(dev, k, 1);
            int bytes = 0;
            int frames = 0;
            block_write(dev, i_segment, (1<<25), ins_len, k);

            usleep(10000);
            // Making sure instruction memory is loaded
            while (1){
                bytes = (core_rd_cmd(dev, k, 0) - core_rx_bytes_raw);
                frames = (core_rd_cmd(dev, k, 1) - core_rx_frames_raw);
                if (frames>=1){
                    if (bytes!=(ins_len+(8*frames)))
                        printf("ERROR: %d bytes were sent to core %d as instructions instead of %d bytes.\n", bytes, k, (int)(ins_len+(8*frames)));
                    break;
                }
            }
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
                    uint32_t core_rx_bytes_raw  = core_rd_cmd(dev, k, 0);
                    uint32_t core_rx_frames_raw = core_rd_cmd(dev, k, 1);
                    int bytes = 0;
                    int frames = 0;
                    block_write(dev, d_segment, (int)strtol(addr, NULL, 0), data_len, k);

                    usleep(10000);
                    while (1){
                        bytes = (core_rd_cmd(dev, k, 0) - core_rx_bytes_raw);
                        frames = (core_rd_cmd(dev, k, 1) - core_rx_frames_raw);
                        if (frames>=1){
                            if (bytes!=(data_len+(8*frames)))
                                printf("ERROR: %d bytes were sent to core %d for data memory instead of %d bytes.\n", bytes, k, (int)(data_len+(8*frames)));
                            break;
                        }
                    }
                    printf(".");
                    fflush(stdout);
                }
                printf("\n");
            }
        }

        if (test_pcie){
            // Host Write and Readback test

            block_write(dev, i_segment, 0x1000100, ins_len, 4);
            usleep(1000);
            block_read(dev, r_segment, 0x1000100, ins_len, 4);
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
        usleep(100000);
        for (int k=0; k<core_count; k++)
        {
            if (core_enable & (1 << k)){
                core_wr_cmd(dev, k, 0xf, 0);
                core_wr_cmd(dev, k, 0xf, 0);
            }
            usleep(1000);
            printf(".");
            fflush(stdout);
        }
        printf("\n");

        usleep(1000000);

        printf("Core stats after taking out of reset\n");
        for (int k=0; k<core_count; k++){
            printf("core %d status: %08x\n", k, core_rd_cmd(dev, k, 8));
        }

        printf("Enabling cores in scheduler...\n");
        printf("Core enable mask: 0x%08x\n", core_enable);
        set_enable_cores(dev, core_enable);
        unsigned int temp = read_enable_cores(dev);
        printf("core enable readback %08x\n",  temp);

        printf("Core RX enable mask: 0x%08x\n", core_rx_enable);
        set_receive_cores(dev, core_rx_enable);
        printf("core RX enable readback %08x\n",  read_receive_cores(dev));

        printf("Enabling interfaces ...\n");

        // Disable in scheduler early drops
        set_interface_rx_threshold(dev, RX_FIFO_LINES+1);
        set_enable_interfaces(dev, (1<<MAX_ETH_IF_COUNT)-1);

        printf("Done!\n");

        free(i_segment);
        free(d_segment);
        free(r_segment);
    }

err:

    mqnic_close(dev);

    return ret;
}

