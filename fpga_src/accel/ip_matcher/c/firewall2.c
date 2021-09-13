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
unsigned int header_slot_base;

const unsigned int slot_size        = 16*1024;
const unsigned int header_slot_size = 128;

int main(void)
{
  unsigned short eth_type;
  unsigned int   src_ip;

  DEBUG_OUT_L = 0;
  DEBUG_OUT_H = 0;

  // set slot configuration parameters
  slot_count       = 16;
  header_slot_base = DMEM_BASE + (DMEM_SIZE >> 1);

  if (slot_count > MAX_SLOT_COUNT)
    slot_count = MAX_SLOT_COUNT;

  // Do this at the beginning, so scheduler can fill the slots while
  // initializing other things.
  init_hdr_slots(slot_count, header_slot_base, header_slot_size);
  init_slots(slot_count, PKTS_START+PKT_OFFSET, slot_size);
	set_masks(0x30); // Enable only Evict + Poke

  while (1)
  {
    // check for new packets
    if (in_pkt_ready())
    {
      eth_type = *((unsigned short *) (RECV_DESC.data + 12));
      src_ip   = *((unsigned int   *) (RECV_DESC.data + 14 + 12));
      SEND_DESC = RECV_DESC;
      asm volatile("" ::: "memory");
      RECV_DESC_RELEASE = 1;

      // check eth type
      if (eth_type == bswap_16(0x0800))
      {
        // start Firewall IP check
        ACC_SRC_IP = src_ip;
        if (ACC_FW_MATCH)
          SEND_DESC.len = 0;
        // else
        //   desc->port ^= 1;
      } else {
          SEND_DESC.len = 0;
      }

      asm volatile("" ::: "memory");
      SEND_DESC_TYPE = 0;
    }
  }

  return 1;
}
