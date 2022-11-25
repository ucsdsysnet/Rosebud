#include "core.h"

#define bswap_16(x) \
  (((x & 0xff00) >> 8) | ((x & 0x00ff) << 8))

// Accel wrapper registers mapping
#define ACC_SRC_IP   (*((volatile unsigned int  *)(IO_EXT_BASE + 0x00)))
#define ACC_FW_MATCH (*((volatile unsigned char *)(IO_EXT_BASE + 0x04)))

static inline void slot_rx_packet(struct Desc* desc)
{
  unsigned short eth_type = *((unsigned short *) (desc->data + 12));
  unsigned int   src_ip   = *((unsigned int   *) (desc->data + 14 + 12));

  // check eth type
  if (eth_type == bswap_16(0x0800))
  {
    // start Firewall IP check
    ACC_SRC_IP = src_ip;
    if (ACC_FW_MATCH)
    {
      goto drop;
    }
    else
    {
      desc->port ^= 1;
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
  // Initializing scheduler and interconnect
  init_hdr_slots(16, 0x804000, 128);
  init_slots(16, 0x0C000A, 16384);

  // Enable only Evict and Poke Interrupts
	set_masks(0x30);

  while (1)
  {
    // check for new packets
    if (in_pkt_ready())
    {
      struct Desc desc;
      // read descriptor
      read_in_pkt(&desc);
      slot_rx_packet(&desc);
    }
  }

  return 1;
}
