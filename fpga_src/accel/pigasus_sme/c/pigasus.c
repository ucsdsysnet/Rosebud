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

// #define HASH_SCHED

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10
// PMEM in 8 blocks of 128 KB
// accelerators only connected to upper 2 blocks
#define PKTS_START (6*128*1024)

#ifdef HASH_SCHED
  #define DATA_OFFSET 4
#else
  #define DATA_OFFSET 0
#endif

// Accel wrapper registers mapping
#define ACC_PIG_CTRL     (*((volatile unsigned char      *)(IO_EXT_BASE + 0x00)))
#define ACC_PIG_MATCH    (*((volatile unsigned char      *)(IO_EXT_BASE + 0x00)))
#define ACC_PIG_STATE    (*((volatile unsigned long long *)(IO_EXT_BASE + 0x10)))
#define ACC_PIG_STATE_L  (*((volatile unsigned int       *)(IO_EXT_BASE + 0x10)))
#define ACC_PIG_STATE_H  (*((volatile unsigned int       *)(IO_EXT_BASE + 0x14)))
#define ACC_PIG_PORTS    (*((volatile unsigned int       *)(IO_EXT_BASE + 0x0c)))
#define ACC_PIG_SRC_PORT (*((volatile unsigned short     *)(IO_EXT_BASE + 0x0c))) //!
#define ACC_PIG_DST_PORT (*((volatile unsigned short     *)(IO_EXT_BASE + 0x0e))) //!
#define ACC_PIG_SLOT     (*((volatile unsigned char      *)(IO_EXT_BASE + 0x18)))
#define ACC_PIG_RULE_ID  (*((volatile unsigned short     *)(IO_EXT_BASE + 0x1c)))

#define ACC_SRC_IP       (*((volatile unsigned int       *)(IO_EXT_BASE + 0x40)))
#define ACC_DST_IP       (*((volatile unsigned int       *)(IO_EXT_BASE + 0x50)))
#define ACC_CDN_MATCH    (*((volatile unsigned char      *)(IO_EXT_BASE + 0x60)))
#define ACC_DOS_ATTACK   (*((volatile unsigned char      *)(IO_EXT_BASE + 0x6c)))
#define ACC_FROM_ATTACK  (*((volatile unsigned char      *)(IO_EXT_BASE + 0x68)))
#define ACC_SRC_DOS      (*((volatile unsigned char      *)(IO_EXT_BASE + 0x68)))
#define ACC_DST_DOS      (*((volatile unsigned char      *)(IO_EXT_BASE + 0x69)))
#define ACC_LEN_DOS      (*((volatile unsigned char      *)(IO_EXT_BASE + 0x6a)))

#define ACC_DMA_LEN      (*((volatile unsigned int       *)(IO_EXT_BASE + 0x04)))
#define ACC_DMA_ADDR     (*((volatile unsigned int       *)(IO_EXT_BASE + 0x08)))
#define ACC_DMA_STAT     (*((volatile unsigned int       *)(IO_EXT_BASE + 0x70)))
#define ACC_DMA_BUSY     (*((volatile unsigned char      *)(IO_EXT_BASE + 0x70)))
#define ACC_DMA_DONE     (*((volatile unsigned char      *)(IO_EXT_BASE + 0x71)))
#define ACC_DMA_DESC_ERR (*((volatile unsigned char      *)(IO_EXT_BASE + 0x73)))
#define ACC_DMA_DONE_ERR (*((volatile unsigned char      *)(IO_EXT_BASE + 0x72)))

// flows
struct flow {
  unsigned int hash;
  unsigned int state;
  union {
    volatile unsigned long long state_64;
    volatile unsigned int       states_32[2];
  } sme_state;
};

// Slot contexts
struct slot_context {
  int index;
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

  unsigned int payload_offset;
  struct flow *flow;
  unsigned int state;
};

// #define FLOW_TABLE_SIZE 32768
#define FLOW_TABLE_SIZE 1024

unsigned char *flow_table;


struct slot_context context[MAX_CTX_COUNT];

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

static inline void slot_rx_packet(struct slot_context *slot)
{
  char ch;
  unsigned int payload_offset = ETH_HEADER_SIZE + DATA_OFFSET;
  unsigned int packet_length = slot->desc.len;
  unsigned int payload_length;

  PROFILE_B(0x00010000);

  // check eth type
  PROFILE_B(0xF0010000 | slot->eth_hdr->type);
  if (slot->eth_hdr->type == bswap_16(0x0800))
  {
    PROFILE_B(0x00010001);
    // IPv4 packet
    slot->l3_header.ipv4_hdr = (struct ipv4_header*)(slot->header+payload_offset);

    // start CDN IP check
    ACC_SRC_IP = slot->l3_header.ipv4_hdr->src_ip;

    // check version
    ch = slot->l3_header.ipv4_hdr->version_ihl;
    if ((ch & 0xF0) != 0x40)
    {
      // invalid version, drop it
      PROFILE_B(0x00010009);
      goto drop;
    }

    // header size from IHL
    payload_offset += (ch & 0xf) << 2;
    slot->l4_header.tcp_hdr = (struct tcp_header*)(slot->header+payload_offset);

    // check IP
    if (ACC_CDN_MATCH)
    {
      // it's a match, drop it
      PROFILE_B(0x0001000a);
      goto drop;
    }

    PROFILE_B(0x00010002);
    // check protocol
    switch (slot->l3_header.ipv4_hdr->protocol)
    {
      case 0x06: // TCP
        PROFILE_B(0xF0010000 | slot->l4_header.tcp_hdr->dest_port);
        // header size from flags field
        ch = ((char *)slot->l4_header.tcp_hdr)[12];
        payload_offset += (ch & 0xF0) >> 2;

        if (payload_offset >= packet_length)
          // no payload
          goto drop;

        payload_length = packet_length - payload_offset;
        slot->payload_offset = payload_offset;

        // TODO: flow hash processing

        ACC_DMA_ADDR  = (unsigned int)(slot->desc.data)+slot->payload_offset;
        ACC_DMA_LEN   = slot->desc.len-slot->payload_offset;
        ACC_PIG_PORTS = 1025*65536 + 1024;
        // ACC_PIG_SRC_PORT = slot->l4_header.udp_hdr->src_port;
        // ACC_PIG_DST_PORT = slot->l4_header.udp_hdr->dest_port;
        // ACC_PIG_STATE = (unsigned long long )0x11FEFEFEFEFEFEFE;
        ACC_PIG_STATE_L = 0xFEFEFEFE;
        ACC_PIG_STATE_H = 0x11FEFEFE;
        ACC_PIG_SLOT  = slot->index;
        ACC_PIG_CTRL  = 1;

        return;

      case 0x11: // UDP
        PROFILE_B(0x00010006);
        payload_offset += UDP_HEADER_SIZE;

        if (payload_offset >= packet_length)
          // no payload
          goto drop;

        payload_length = packet_length - payload_offset;
        slot->payload_offset = payload_offset;

        slot->flow = 0;

        ACC_DMA_ADDR  = (unsigned int)(slot->desc.data)+slot->payload_offset;
        ACC_DMA_LEN   = slot->desc.len-slot->payload_offset;
        ACC_PIG_PORTS = 1025*65536 + 1024;
        // ACC_PIG_SRC_PORT = slot->l4_header.udp_hdr->src_port;
        // ACC_PIG_DST_PORT = slot->l4_header.udp_hdr->dest_port;
        ACC_PIG_STATE = 0;
        ACC_PIG_SLOT  = slot->index;
        ACC_PIG_CTRL  = 1;

        return;
    }
  }

drop:
  slot->desc.len = 0;
  pkt_send(&slot->desc);
}

static inline void slot_match(struct slot_context *slot){
  short rule_id = ACC_PIG_RULE_ID;
  PROFILE_A(rule_id);
  // Save ACC_PIG_STATE to flow table if not already saved!

  // If it's end of packet drop it for now
  if (rule_id==0){
    slot->desc.len = 0;
    pkt_send(&slot->desc);
  }

  // release the match/EoP
  ACC_PIG_CTRL = 2;

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
    context[i].index = i;
    context[i].desc.tag = i+1;
    context[i].desc.data = (unsigned char *)(PMEM_BASE + PKTS_START + PKT_OFFSET + i*slot_size);
    context[i].packet = (unsigned char *)(PMEM_BASE + PKTS_START + PKT_OFFSET + i*slot_size);
    context[i].header = (unsigned char *)(header_slot_base + PKT_OFFSET + i*header_slot_size);
    context[i].eth_hdr = (struct eth_header*)(context[i].header + DATA_OFFSET);
  }

  // init flow table
  flow_table = (unsigned char *)PMEM_BASE;

  for (int i = 0; i < FLOW_TABLE_SIZE; i++)
  {
    struct flow* flow = (struct flow *)(flow_table + (i << 4));

    flow->hash = 0;
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
      // handle packet
      // if (ACC_DOS_ATTACK)
      //   slot_rx_packet_dos(slot);
      // else
      slot_rx_packet(slot);
    }

    PROFILE_A(0x00020000);

    if (ACC_PIG_MATCH) {
      slot = &context[ACC_PIG_SLOT];
      slot_match(slot);
    }

  }

  return 1;
}
