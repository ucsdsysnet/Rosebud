/*

Copyright (c) 2020-2021 Moein Khazraee

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
#include <getopt.h>
#include <time.h>

#include "mqnic.h"
#include "rpu.h"
#include "mcap_lib.h"
#include "timespec.h"

static void usage(char *name)
{
    fprintf(stderr,
        "usage: %s [options]\n"
        " -d name    device to open (/sys/bus/pci/devices/.../resource0)\n"
        " -i file    instruction memory binary\n"
        " -m file    memory map for data memory binary(ies)\n"
        " -e mask    core enable\n"
        " -r mask    core rx enable\n"
        " -p path    partial bitstream directory\n",
        name);
}

unsigned long long timespec_to_ns(struct timespec ts)
{
    return (ts.tv_sec*1000000000) + ts.tv_nsec;
}

char * get_pcie_path(char *device){
    // determine sysfs path of PCIe device
    // first, try to find via miscdevice
    char *ptr;
    char path[PATH_MAX+32];
    char device_path[PATH_MAX];
    char *bus_dev_func = malloc (sizeof (char) * 16);

    ptr = strrchr(device, '/');
    ptr = ptr ? ptr+1 : device;

    snprintf(path, sizeof(path), "/sys/class/misc/%s/device", ptr);

    if (!realpath(path, device_path))
    {
        // that failed, perhaps it was a PCIe resource
        strcpy(path, device);
        ptr = strrchr(path, '/');
        if (ptr)
            *ptr = 0;

        if (!realpath(path, device_path))
        {
            fprintf(stderr, "failed to determine device path\n");
            return NULL;
        }
    }

    // PCIe device will have a config space, so check for that
    snprintf(path, sizeof(path), "%s/config", device_path);

    if (access(path, F_OK) == -1)
    {
        fprintf(stderr, "failed to determine device path\n");
        return NULL;
    }

    strncpy (device_path, path, strrchr(path, '/')-path-1);
    ptr = strchr(strrchr(device_path, '/'),':');
    strcpy(bus_dev_func, ptr+1);
    return(bus_dev_func);
}

int main(int argc, char *argv[])
{
    char *name;
    int opt;
    int ret = 0;

    char *device = NULL;
    struct mqnic *dev;
    struct mcap_dev *mdev;

    char *instr_bin = NULL;
    char *data_map = NULL;
    FILE *write_file = NULL;
    FILE *map_file = NULL;
    char *PR_bitfiles = NULL;

    char action_write = 0;
    char load_dmem    = 0;

    uint32_t core_enable = 0xffffffff;
    uint32_t core_rx_enable = 0xffffffff;

    unsigned long long pr_time = 0;

    name = strrchr(argv[0], '/');
    name = name ? 1+name : argv[0];

    while ((opt = getopt(argc, argv, "d:i:m:p:e:r:h?")) != EOF)
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
        case 'p':
            PR_bitfiles = optarg;
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

    mdev = MCapLibInit_w_bus((int) strtol("1001", NULL, 16), get_pcie_path(device));

    core_rx_enable &= core_enable;

    printf("FW ID: 0x%08x\n", dev->fw_id);
    printf("FW version: %d.%d\n", dev->fw_ver >> 16, dev->fw_ver & 0xffff);
    printf("Board ID: 0x%08x\n", dev->board_id);
    printf("Board version: %d.%d\n", dev->board_ver >> 16, dev->board_ver & 0xffff);

    int core_count = RPU_COUNT;
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

        for (int o=0; o<20; o++){
        for (int k=0; k<core_count; k++)
        {
            printf("Putting core %d into reset.\n", k);
            reset_single_core(dev, k, SLOTS, 1);

            struct timespec start_time, end_time;

            char bitfile[100];
            snprintf(bitfile, sizeof(bitfile), "%s/fpga_pblock_%d_partial.bit", PR_bitfiles, k+1);
            clock_gettime(CLOCK_MONOTONIC, &start_time);
            MCapConfigureFPGA(mdev, bitfile, EMCAP_CONFIG_FILE);
            clock_gettime(CLOCK_MONOTONIC, &end_time);
            pr_time += (timespec_to_ns(end_time)-timespec_to_ns(start_time));
            // MCapReset(mdev);
            // MCapModuleReset(mdev);
            // MCapFullReset(mdev);
            usleep(10000);

            core_rd_cmd(dev, k, 0);
            core_rd_cmd(dev, k, 1);
            uint32_t core_rx_bytes_raw  = core_rd_cmd(dev, k, 0);
            uint32_t core_rx_frames_raw = core_rd_cmd(dev, k, 1);
            int bytes = 0;
            int frames = 0;
            block_write(dev, i_segment, (1<<25), ins_len, k);

            usleep(10000);
            // Making sure instruction memory is loaded
            while (1){
                core_rd_cmd(dev, k, 0);
                core_rd_cmd(dev, k, 1);
                bytes = (core_rd_cmd(dev, k, 0) - core_rx_bytes_raw);
                frames = (core_rd_cmd(dev, k, 1) - core_rx_frames_raw);
                if (frames>=1){
                    if (bytes!=(ins_len+(8*frames)))
                        printf("ERROR: %d bytes were sent to core %d as instructions instead of %d bytes.\n", bytes, k, (int)(ins_len+(8*frames)));
                    break;
                }
            }

            printf("Core %d instruction load complete.\n", k);
            usleep(10000);

            if (core_enable & (1 << k)){
                core_wr_cmd(dev, k, 0xf, 0);
                core_wr_cmd(dev, k, 0xf, 0);
            }

            usleep(1000000);
    
            uint32_t cur = read_enable_cores(dev);
            set_enable_cores(dev, cur | (1 << k));
            cur = read_receive_cores(dev);
            set_receive_cores(dev, cur | (1 << k));

            usleep(10000);

            printf("Core %d reloaded.\n", k);
        }
        }

        printf("Core %d reloaded.\n", (int)(pr_time/(16*20)));

        free(i_segment);
        free(d_segment);
        free(r_segment);
    }

err:

    mqnic_close(dev);

    return ret;
}

