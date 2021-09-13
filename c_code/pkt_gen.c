#include "core.h"
#include "packet_headers.h"
#include "pcg_basic.h"

#define ARRAY_SIZE(arr) \
    (sizeof(arr) / sizeof((arr)[0]))

#define bswap_16(x) \
  (((x & 0xff00) >> 8) | ((x & 0x00ff) << 8))

#define bswap_32(x) \
  (((x & 0xff000000) >> 24) | ((x & 0x00ff0000) >>  8) | \
   ((x & 0x0000ff00) <<  8) | ((x & 0x000000ff) << 24))

// #define HASH_SCHED
#define FORWARD 0

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10
// #define PKTS_START (6*128*1024)
#define PKTS_START 0

#ifdef HASH_SCHED
  #define DATA_OFFSET 4
#else
  #define DATA_OFFSET 0
#endif

char *pkt_data[16];
// unsigned int pkt_len[16] = {128, 1024, 128, 1500, 256, 1024, 512, 1500, 1024, 1500, 256, 2048, 512, 4096, 1500, 9000};
// unsigned int pkt_len[16] = {128, 1024, 128, 1500, 256, 1024, 512, 1500, 1024, 1500, 256, 1500, 512, 1500, 1500, 1500};
// unsigned int pkt_len[16] = {60, 60, 60, 100, 128, 200, 256, 512, 1024, 1024, 1024, 1500, 1500, 1500, 1500, 1500};
// unsigned int pkt_len[16] = {60, 256, 1024, 1514, 1514, 1514, 1514, 1514, 1514, 1514, 1514, 1514, 1514, 1514, 1514, 1514};
unsigned int pkt_len[16] = {[0 ... 15] = 1514};
char *rand_array;

struct __attribute__((__packed__)) udp_packet_header {
  struct eth_header eth;
  struct ipv4_header ip;
  struct udp_header udp;
};

struct __attribute__((__packed__)) tcp_packet_header {
  struct eth_header eth;
  struct ipv4_header ip;
  struct tcp_header tcp;
};

struct segment {
  char *data;
  int len;
};

#define SEG(x) {((char *)&x), sizeof(x)}

struct udp_packet_header udp_hdr = {
  .eth = {
    .dest_mac = "\xFF\xFF\xFF\xFF\xFF\xFF",
    .src_mac = "\xCD\xCD\xCD\xCD\xCD\xCD",
    .type = bswap_16(0x0800)
  },
  .ip = {
    .version_ihl = 0x45,
    .dscp_ecn = 0,
    .total_length = bswap_16(1500-ETH_HEADER_SIZE),
    .id = bswap_16(0),
    .flags_fragment_offset = bswap_16(0),
    .ttl = 64,
    .protocol = 0x11,
    .hdr_sum = bswap_16(0),
    .src_ip = bswap_32(0xC0A80101),
    .dest_ip = bswap_32(0xC0A80102)
  },
  .udp = {
    .src_port = bswap_16(0xAAAA),
    .dest_port = bswap_16(0xBBBB),
    .length = bswap_16(1500-ETH_HEADER_SIZE-IPV4_HEADER_SIZE),
    .checksum = bswap_16(0)
  }
};

struct tcp_packet_header tcp_hdr = {
  .eth = {
    .dest_mac = "\xFF\xFF\xFF\xFF\xFF\xFF",
    .src_mac = "\xCD\xCD\xCD\xCD\xCD\xCD",
    .type = bswap_16(0x0800)
  },
  .ip = {
    .version_ihl = 0x45,
    .dscp_ecn = 0,
    .total_length = bswap_16(1500-ETH_HEADER_SIZE),
    .id = bswap_16(0),
    .flags_fragment_offset = bswap_16(0x0001), // FIN
    .ttl = 64,
    .protocol = 0x06,
    .hdr_sum = bswap_16(0),
    .src_ip = bswap_32(0xC0A80101),
    .dest_ip = bswap_32(0xC0A80102)
  },
  .tcp = {
    .src_port = bswap_16(0xAAAA),
    .dest_port = bswap_16(0xBBBB),
    .seq = bswap_32(0),
    .ack = bswap_32(0),
    .flags = bswap_16(0x5000),
    .window = bswap_16(0),
    .checksum = bswap_16(0),
    .urgent_ptr = bswap_16(0)
  }
};

struct tcp_packet_header http_hdr = {
  .eth = {
    .dest_mac = "\xFF\xFF\xFF\xFF\xFF\xFF",
    .src_mac = "\xCD\xCD\xCD\xCD\xCD\xCD",
    .type = bswap_16(0x0800)
  },
  .ip = {
    .version_ihl = 0x45,
    .dscp_ecn = 0,
    .total_length = bswap_16(1500-ETH_HEADER_SIZE),
    .id = bswap_16(0),
    .flags_fragment_offset = bswap_16(0),
    .ttl = 64,
    .protocol = 0x06,
    .hdr_sum = bswap_16(0),
    .src_ip = bswap_32(0xC0A80101),
    .dest_ip = bswap_32(0xC0A80102)
  },
  .tcp = {
    .src_port = bswap_16(0xAAAA),
    .dest_port = bswap_16(80),
    .seq = bswap_32(0),
    .ack = bswap_32(0),
    .flags = bswap_16(0x5000),
    .window = bswap_16(0),
    .checksum = bswap_16(0),
    .urgent_ptr = bswap_16(0)
  }
};

struct segment pkt_headers[] = {
  SEG(udp_hdr),
  SEG(tcp_hdr),
  SEG(http_hdr)
};

char pattern0[10240] = {[0 ... 10239] = 0xFF}; // For Pigasus not to match
char pattern1[] = "page.php?id=%27%3B%20SELECT%20%2A%20FROM%20users%3B%20--";
char pattern2[] = "page.php?id=%27%3B%20DELETE%20FROM%20prod_data%3B%20--";
char pattern3[] = "GET AAAAAAAA HTTP/1.1";
char pattern4[] = "GET / HTTP/1.1\r\n\r\n\r\n";
char pattern5[] = "HTTP/1.0\r\nAccept: */*\r\nAccept-Language: ";

struct segment pkt_payloads[] = {
  SEG(pattern0),
  SEG(pattern0),
  // SEG(pattern3),
  // SEG(pattern4),
  // SEG(pattern5)
};

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

struct Desc packet;
struct Desc recv_pkt;

void basic_memcpy(char *dest, char *src, int n)
{
  for (int i=0; i<n; i++)
    dest[i] = src[i];
}


void init_packets()
{
  int i;

  char *ptr = (char *)(0x01040000);

  int hdr_index = 0;
  int data_index = 0;
  struct segment data_seg;
  pcg32_random_t rng;

  pcg32_srandom_r(&rng, 12345u, core_id());

  for (i=0; i<ARRAY_SIZE(pkt_data); i++){
    struct tcp_packet_header temp_tcp_hdr = {
      .eth = {
        .dest_mac = "\xFF\xFF\xFF\xFF\xFF\xFF",
        .src_mac = "\xCD\xCD\xCD\xCD\xCD\xCD",
        .type = bswap_16(0x0800)
      },
      .ip = {
        .version_ihl = 0x45,
        .dscp_ecn = 0,
        .total_length = bswap_16(1500-ETH_HEADER_SIZE),
        .id = bswap_16(0),
        .flags_fragment_offset = bswap_16(0x0),
        .ttl = 64,
        .protocol = 0x06,
        .hdr_sum = bswap_16(0),
        .src_ip =  pcg32_boundedrand_r(&rng, 1<<32 - 1),
        .dest_ip =  pcg32_boundedrand_r(&rng, 1<<32 - 1),
      },
      .tcp = {
        .src_port = pcg32_boundedrand_r(&rng, 1<<16),
        .dest_port = pcg32_boundedrand_r(&rng, 1<<16),
        .seq = bswap_32(0),
        .ack = bswap_32(0),
        .flags = bswap_16(0x5001), //FIN
        .window = bswap_16(0),
        .checksum = bswap_16(0),
        .urgent_ptr = bswap_16(0)
      }
    };
    struct udp_packet_header temp_udp_hdr = {
      .eth = {
        .dest_mac = "\xFF\xFF\xFF\xFF\xFF\xFF",
        .src_mac = "\xCD\xCD\xCD\xCD\xCD\xCD",
        .type = bswap_16(0x0800)
      },
      .ip = {
        .version_ihl = 0x45,
        .dscp_ecn = 0,
        .total_length = bswap_16(1500-ETH_HEADER_SIZE),
        .id = bswap_16(0),
        .flags_fragment_offset = bswap_16(0),
        .ttl = 64,
        .protocol = 0x11,
        .hdr_sum = bswap_16(0),
        .src_ip =  pcg32_boundedrand_r(&rng, 1<<32 - 1),
        .dest_ip =  pcg32_boundedrand_r(&rng, 1<<32 - 1),
      },
      .udp = {
        .src_port = pcg32_boundedrand_r(&rng, 1<<16),
        .dest_port = pcg32_boundedrand_r(&rng, 1<<16),
        .length = bswap_16(1500-ETH_HEADER_SIZE-IPV4_HEADER_SIZE),
        .checksum = bswap_16(0)
      }
    };

    data_seg = pkt_payloads[data_index];

    if (i%2==0) {
      basic_memcpy(ptr, (char*)&temp_tcp_hdr, sizeof(temp_tcp_hdr));
      basic_memcpy(ptr+sizeof(temp_tcp_hdr), data_seg.data, data_seg.len);
    } else {
      basic_memcpy(ptr, (char*)&temp_udp_hdr, sizeof(temp_udp_hdr));
      basic_memcpy(ptr+sizeof(temp_udp_hdr), data_seg.data, data_seg.len);
    }

    // LSB of source IP is core ID
    ptr[29] = core_id();

    pkt_data[i] = ptr;
    ptr += 10240;

    hdr_index += 1;
    if (hdr_index >= ARRAY_SIZE(pkt_headers))
      hdr_index = 0;
    data_index += 1;
    if (data_index >= ARRAY_SIZE(pkt_payloads))
      data_index = 0;
  }

  // precompute random array for packet sizes
  rand_array = ptr;


  for (i = 0; i < 10240; i++)
  {
    rand_array[i] = pcg32_boundedrand_r(&rng, ARRAY_SIZE(pkt_len));
  }
}

int main(void){
  int i;
  int pkt_num, len_num;
  int fw_port;

  // set slot configuration parameters
  slot_count = 16;
  slot_size = 10*1024;
  header_slot_base = DMEM_BASE + (DMEM_SIZE >> 1);
  header_slot_size = 128;

  // Do this at the beginning, so scheduler can fill the slots while
  // initializing other things.
  init_hdr_slots(slot_count, header_slot_base, header_slot_size);
  init_slots(slot_count, PKTS_START+PKT_OFFSET, slot_size);
  set_masks(0x30); // Enable only Evict + Poke

  init_packets();

  packet.tag = 0;
  if ((core_id()&0x4)!=0) {
    packet.port = 1;
    fw_port = 1;
  } else {
    packet.port = 0;
    fw_port = 0;
  }

  // packet.len = 1000;

  while (1){
    for (i=0; i<10240; i+=2) {
      pkt_num = rand_array[i];
      len_num = rand_array[i+1];
      pkt_data[pkt_num][35]++; // change source port
      packet.data = pkt_data[pkt_num];
      packet.len  = pkt_len[len_num];
      pkt_send(&packet);

      if (FORWARD) {
        // forward packet
        if (in_pkt_ready()){
          read_in_pkt(&recv_pkt);
          if (recv_pkt.port == 2) {
            // packet from host, send to network
            recv_pkt.port = fw_port;
          } else {
            // packet from network, send to host
            recv_pkt.port = 2;
          }
          if (DATA_OFFSET)
            recv_pkt.data += DATA_OFFSET;
          pkt_send(&recv_pkt);
        }
      }
    }
  }

  return 1;
}
