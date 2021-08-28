#include "core.h"
#include "packet_headers.h"

#if 1
#define PROFILE_A(x) do {DEBUG_OUT_L = (x);} while (0)
#define PROFILE_B(x) do {DEBUG_OUT_H = (x);} while (0)
#else
#define PROFILE_A(x) do {} while (0)
#define PROFILE_B(x) do {} while (0)
#endif

#define bswap_16(x) \
  (((x & 0xff00) >> 8) | ((x & 0x00ff) << 8))

#define bswap_32(x) \
  (((x & 0xff000000) >> 24) | ((x & 0x00ff0000) >>  8) | \
   ((x & 0x0000ff00) <<  8) | ((x & 0x000000ff) << 24))

// maximum number of slots (number of context objects)
#define MAX_CTX_COUNT 16

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10
// PMEM in 8 blocks of 128 KB
// accelerators only connected to upper 2 blocks
#define PKTS_START (6*128*1024)

// Accel wrapper registers mapping
#define ACC_SRC_IP   (*((volatile unsigned int  *)(IO_EXT_BASE + 0x00)))
#define ACC_FW_MATCH (*((volatile unsigned char *)(IO_EXT_BASE + 0x01)))

struct slot_context {
  struct Desc desc;
  unsigned char *packet;
  unsigned char *header;

  struct eth_header *eth_hdr;
  union {
    struct ipv4_header *ipv4_hdr;
  } l3_header;
  union {
    struct tcp_header *tcp_hdr;
    struct udp_header *udp_hdr;
  } l4_header;
};

struct slot_context context[MAX_CTX_COUNT];

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

static inline void slot_rx_packet(struct slot_context *slot)
{
  // check eth type
  PROFILE_B(0xF0010000 | slot->eth_hdr->type);
  if (slot->eth_hdr->type == bswap_16(0x0800))
  {
    PROFILE_B(0x00010001);
    // IPv4 packet
    slot->l3_header.ipv4_hdr = (struct ipv4_header*)(slot->header+ETH_HEADER_SIZE);

    // start CDN IP check
    ACC_SRC_IP = slot->l3_header.ipv4_hdr->src_ip;
    if (ACC_FW_MATCH) {
      PROFILE_B(0x0001000a);
      goto drop;
    } else {
      PROFILE_B(0x0001cccc);
      slot->desc.len ^= 1;
      pkt_send(&slot->desc);
    }
  }

drop: //Non IPV4 or in firewall list
  slot->desc.len = 0;
  pkt_send(&slot->desc);
}

int main(void)
{
  struct slot_context *slot;

  DEBUG_OUT_L = 0;
  DEBUG_OUT_H = 0;

  // set slot configuration parameters
  slot_count       = 16;
  slot_size        = 16*1024;
  header_slot_base = DMEM_BASE + (DMEM_SIZE >> 1);
  header_slot_size = 128;

  if (slot_count > MAX_SLOT_COUNT)
    slot_count = MAX_SLOT_COUNT;

  if (slot_count > MAX_CTX_COUNT)
    slot_count = MAX_CTX_COUNT;

  // Do this at the beginning, so scheduler can fill the slots while
  // initializing other things.
  init_hdr_slots(slot_count, header_slot_base, header_slot_size);
  init_slots(slot_count, PKTS_START+PKT_OFFSET, slot_size);
  set_masks(0xD0); //enable evict

  // init slot context structures
  for (int i = 0; i < slot_count; i++)
  {
    context[i].desc.tag = i+1;
    context[i].desc.data = (unsigned char *)(PMEM_BASE + PKTS_START + PKT_OFFSET + i*slot_size);
    context[i].packet = (unsigned char *)(PMEM_BASE + PKTS_START + PKT_OFFSET + i*slot_size);
    context[i].header = (unsigned char *)(header_slot_base + PKT_OFFSET + i*header_slot_size);
    context[i].eth_hdr = (struct eth_header*)(context[i].header);
  }

  PROFILE_A(0x00000005);

  while (1)
  {
    // check for new packets
    if (in_pkt_ready())
    {
      struct Desc desc;

      PROFILE_A(0x00010001);

      // read descriptor
      read_in_pkt(&desc);
      
      // compute index
      slot = &context[desc.tag-1];
      
      // copy descriptor into context
      slot->desc = desc;

      PROFILE_A(0x00010002);

      slot_rx_packet(slot);
    }

  }

  return 1;
}
