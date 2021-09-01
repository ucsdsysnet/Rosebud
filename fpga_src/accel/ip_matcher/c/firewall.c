#include "core.h"

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

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10
// PMEM in 8 blocks of 128 KB
// accelerators only connected to upper 2 blocks
#define PKTS_START (6*128*1024)

// Accel wrapper registers mapping
#define ACC_SRC_IP   (*((volatile unsigned int  *)(IO_EXT_BASE + 0x00)))
#define ACC_FW_MATCH (*((volatile unsigned char *)(IO_EXT_BASE + 0x04)))

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

static inline void slot_rx_packet(struct Desc* desc)
{

  unsigned short eth_type = *((unsigned short *) (desc->data + 12));
  unsigned short ip_v_ihl = *((unsigned char  *) (desc->data + 14));
  unsigned int   src_ip   = *((unsigned int   *) (desc->data + 14 + 12)); 

  // check eth type
  PROFILE_B(0xF0010000 | eth_type);
  
  if (eth_type == bswap_16(0x0800))
  {
    PROFILE_B(0x00010001);
    // IPv4 packet
    if ((ip_v_ihl & 0xF0) != 0x40)
    {
      // invalid version, drop it
      PROFILE_B(0x00010009);
      goto drop;
    }
    
    // start CDN IP check
    ACC_SRC_IP = src_ip;
    if (ACC_FW_MATCH) 
    {
      PROFILE_B(0x0001000a);
      goto drop;
    } 
    else 
    {
      PROFILE_B(0x0001cccc);
      // desc->port ^= 1;
      pkt_send(desc);
      return;
    }
  }

drop: //Non IPV4 or in firewall list
  desc->len = 0;
  pkt_send(desc);
}

int main(void)
{
  DEBUG_OUT_L = 0;
  DEBUG_OUT_H = 0;

  // set slot configuration parameters
  slot_count       = 16;
  slot_size        = 16*1024;
  header_slot_base = DMEM_BASE + (DMEM_SIZE >> 1);
  header_slot_size = 128;

  if (slot_count > MAX_SLOT_COUNT)
    slot_count = MAX_SLOT_COUNT;

  // Do this at the beginning, so scheduler can fill the slots while
  // initializing other things.
  init_hdr_slots(slot_count, header_slot_base, header_slot_size);
  init_slots(slot_count, PKTS_START+PKT_OFFSET, slot_size);
  set_masks(0xD0); //enable evict

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
      slot_rx_packet(&desc);
    }
  }

  return 1;
}
