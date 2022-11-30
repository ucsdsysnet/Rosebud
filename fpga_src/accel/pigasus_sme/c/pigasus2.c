#include "core.h"
#include "packet_headers.h"

#if 0
#define PROFILE_A(x) do {DEBUG_OUT_L = (x);} while (0)
#else
#define PROFILE_A(x) do {} while (0)
#endif

#if 0
#define PROFILE_B(x) do {DEBUG_OUT_H = (x);} while (0)
#else
#define PROFILE_B(x) do {} while (0)
#endif

#define bswap_16(x) \
  (((x & 0xff00) >> 8) | ((x & 0x00ff) << 8))

#define bswap_32(x) \
  (((x & 0xff000000) >> 24) | ((x & 0x00ff0000) >>  8) | \
   ((x & 0x0000ff00) <<  8) | ((x & 0x000000ff) << 24))

// maximum number of slots (number of context objects)
#define MAX_CTX_COUNT 32
#define REORDER_LIMIT 8
// #define HASH_SCHED

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10
// PMEM in 8 blocks of 128 KB
// accelerators only connected to upper 2 blocks
#define PKTS_START ((8-(MAX_CTX_COUNT/8))*128*1024)

#ifdef HASH_SCHED
  #define DATA_OFFSET 4
#else
  #define DATA_OFFSET 0
#endif

#define mem_align(x) (((unsigned int)x+3) & 0xFFFFFFFC)

// Accel wrapper registers mapping
#define ACC_PIG_CTRL     (*((volatile unsigned char      *)(IO_EXT_BASE + 0x00)))
#define ACC_PIG_MATCH    (*((volatile unsigned char      *)(IO_EXT_BASE + 0x00)))
#define ACC_PIG_STATE    (*((volatile unsigned long long *)(IO_EXT_BASE + 0x10)))
#define ACC_PIG_STATE_L  (*((volatile unsigned int       *)(IO_EXT_BASE + 0x10)))
#define ACC_PIG_STATE_H  (*((volatile unsigned int       *)(IO_EXT_BASE + 0x14)))
#define ACC_PIG_PORTS    (*((volatile unsigned int       *)(IO_EXT_BASE + 0x0c)))
#define ACC_PIG_SRC_PORT (*((volatile unsigned short     *)(IO_EXT_BASE + 0x0c)))
#define ACC_PIG_DST_PORT (*((volatile unsigned short     *)(IO_EXT_BASE + 0x0e)))
#define ACC_PIG_SLOT     (*((volatile unsigned char      *)(IO_EXT_BASE + 0x18)))
#define ACC_PIG_RULE_ID  (*((volatile unsigned int       *)(IO_EXT_BASE + 0x1c)))

#define HASH_LOOKUP      (*((volatile unsigned short     *)(IO_EXT_BASE + 0x60)))
#define HASH_BLOCK_32B   (*((volatile unsigned char      *)(IO_EXT_BASE + 0x64)))

#define ACC_DMA_LEN      (*((volatile unsigned int       *)(IO_EXT_BASE + 0x04)))
#define ACC_DMA_ADDR     (*((volatile unsigned int       *)(IO_EXT_BASE + 0x08)))
#define ACC_DMA_STAT     (*((volatile unsigned int       *)(IO_EXT_BASE + 0x78)))
#define ACC_DMA_BUSY     (*((volatile unsigned char      *)(IO_EXT_BASE + 0x78)))
#define ACC_DMA_DONE     (*((volatile unsigned char      *)(IO_EXT_BASE + 0x79)))
#define ACC_DMA_DONE_ERR (*((volatile unsigned char      *)(IO_EXT_BASE + 0x7a)))

// Slot contexts
struct slot_context {
  struct Desc desc;
  int index;

  // Pointers
  unsigned char  *eop;
  unsigned char  *header;

  struct eth_header *eth_hdr;
  union {
    struct ipv4_header *ipv4_hdr;
  } l3_header;
  union {
    struct tcp_header *tcp_hdr;
    struct udp_header *udp_hdr;
  } l4_header;
};

struct slot_context context[MAX_CTX_COUNT+1];

unsigned int pkt_num;
unsigned int slot_count;
unsigned int header_slot_base;

const unsigned int slot_size        = 16*1024;
const unsigned int header_slot_size = 128;

static inline void slot_rx_packet(struct slot_context *slot)
{
  unsigned int   payload_offset;
  unsigned int   packet_length  = slot->desc.len;

  // check eth type
  if (slot->eth_hdr->type == bswap_16(0x0800))
  {
    // IPv4 packet

    // check protocol
    if (slot->l3_header.ipv4_hdr->protocol == 0x06) // TCP
    {
      PROFILE_B(0x00010007);
      payload_offset = ETH_HEADER_SIZE + IPV4_HEADER_SIZE + TCP_HEADER_SIZE;

      ACC_DMA_ADDR  = (unsigned int)(slot->desc.data)+payload_offset;
      ACC_DMA_LEN   = packet_length - payload_offset;
      ACC_PIG_PORTS = * (unsigned int *) slot->l4_header.tcp_hdr; // both ports
      ACC_PIG_STATE_H = 0x01FFFFFF;
      // ACC_PIG_STATE_L = 0xFFFFFFFF;
      ACC_PIG_SLOT  = slot->index;
      ACC_PIG_CTRL  = 1;
      return;
    }
    else // UDP
    {
      PROFILE_B(0x00010006);
      payload_offset = ETH_HEADER_SIZE + IPV4_HEADER_SIZE + UDP_HEADER_SIZE;

      ACC_DMA_ADDR  = (unsigned int)(slot->desc.data)+payload_offset;
      ACC_DMA_LEN   = packet_length - payload_offset;
      ACC_PIG_PORTS = * (unsigned int *) slot->l4_header.udp_hdr; // both ports
      ACC_PIG_STATE_H = 0;
      ACC_PIG_SLOT  = slot->index;
      ACC_PIG_CTRL  = 1;
      return;
    }
  }

  slot->desc.len = 0;
  pkt_send(&slot->desc);
}

static inline void slot_match(struct slot_context *slot){
  unsigned int rule_id;
  PROFILE_B(0xDEAD6666);

  while (1){
    rule_id = ACC_PIG_RULE_ID;
    asm volatile("" ::: "memory");

    if (rule_id!=0){
      ACC_PIG_CTRL = 2; // release the match
      asm volatile("" ::: "memory");
      // Add rule IDs to the end of the packet
      slot->eop = (unsigned char *) mem_align(slot->desc.data + slot->desc.len);
      * (unsigned int *) slot->eop = rule_id;
      slot->desc.len = (unsigned int) slot->eop - (unsigned int) slot->desc.data + 4;
      slot->desc.port = 2;
      PROFILE_B(0xDEAD0001);
    } else { // EoP

      // pkt_num ++;
      // PROFILE_A(pkt_num);

      ACC_PIG_CTRL    = 2; // release the EoP
      asm volatile("" ::: "memory");
      pkt_send(&slot->desc);
      return; // Go back to main loop when done with a packet
    }

    if (ACC_PIG_MATCH) // continue draining FIFO
      slot = &context[ACC_PIG_SLOT];
    else
      break;
  }

}

int main(void)
{
  struct slot_context *slot;
  unsigned int reorder_mask;
  unsigned int reorder_left_mask;
  unsigned int init_left_mask;

  DEBUG_OUT_L = 0;
  DEBUG_OUT_H = 0;

  // set slot configuration parameters
  slot_count       = 32;
  header_slot_base = DMEM_BASE + (DMEM_SIZE >> 1);

  if (slot_count > MAX_SLOT_COUNT)
    slot_count = MAX_SLOT_COUNT;

  if (slot_count > MAX_CTX_COUNT)
    slot_count = MAX_CTX_COUNT;

  // Do this at the beginning, so LB can fill the slots while
  // initializing other things.
  init_hdr_slots(slot_count, header_slot_base, header_slot_size);
  init_slots(slot_count, PKTS_START+PKT_OFFSET, slot_size);
  set_masks(0x30); // Enable only Evict + Poke
  set_sched_offset(DATA_OFFSET);

  // init slot context structures
  for (int i = 1; i <= slot_count; i++)
  {
    context[i].index     = i;
    context[i].desc.tag  = i;
    context[i].desc.data = (unsigned char *)(PMEM_BASE + PKTS_START + PKT_OFFSET + DATA_OFFSET + (i-1)*slot_size);
    context[i].header    = (unsigned char *)(header_slot_base + PKT_OFFSET + DATA_OFFSET + (i-1)*header_slot_size);
    context[i].eth_hdr   = (struct eth_header*)(context[i].header);

    context[i].l3_header.ipv4_hdr = (struct ipv4_header*)(context[i].header +
                                     ETH_HEADER_SIZE);
    context[i].l4_header.tcp_hdr  = (struct tcp_header*) (context[i].header +
                                     ETH_HEADER_SIZE + IPV4_HEADER_SIZE);
  }

  ACC_PIG_STATE_L = 0xFFFFFFFF;
  // pkt_num = 0;

  while (1)
  {
    // check for new packets
    if (in_pkt_ready())
    {
      // compute index
      slot = &context[RECV_DESC.tag];

      // copy descriptor into context, we already know the data pointer
      slot->desc.desc_low = RECV_DESC.desc_low;
      asm volatile("" ::: "memory");
      RECV_DESC_RELEASE = 1;

      // handle packet
      slot_rx_packet(slot);
    }

    if (ACC_PIG_MATCH) {
      slot_match(&context[ACC_PIG_SLOT]);
    }

  }

  return 1;
}
