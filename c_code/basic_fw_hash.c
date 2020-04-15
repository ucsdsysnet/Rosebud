#include "core.h"

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10

// Hash accelerator control registers
#define ACC_HASH_CTRL  (*((volatile unsigned int *)(IO_EXT_BASE + 0x0100)))
#define ACC_HASH_BYTE  (*((volatile unsigned int *)(IO_EXT_BASE + 0x0104)))
#define ACC_HASH_WORD  (*((volatile unsigned int *)(IO_EXT_BASE + 0x0108)))
#define ACC_HASH_DWORD (*((volatile unsigned int *)(IO_EXT_BASE + 0x010C)))
#define ACC_HASH_READ  (*((volatile unsigned int *)(IO_EXT_BASE + 0x0110)))

#define IP_table  (volatile char *) 0x01040000
#define UDP_table (volatile char *) 0x01080000
#define TCP_table (volatile char *) 0x010C0000

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

unsigned char * pkt_header [8];
struct Desc desc;

inline void slot_rx_packet() {
  unsigned int hash;
  char act = 0;
  unsigned char* header;

  // parse header and compute flow hash

  // reset hash module
  header = pkt_header[(desc.tag)-1];
  ACC_HASH_CTRL  = 0;

  // check eth type
  if (*((unsigned short *)(header+12)) == 0x0008){
    // IPv4 packet
    // IPv4 addresses
    ACC_HASH_DWORD = *((unsigned int *)(header+26));
    ACC_HASH_DWORD = *((unsigned int *)(header+30));

    // check IHL and protocol
    if (header[14] == 0x45){
      if(header[23]==0x06){
          // TCP or UDP ports
          ACC_HASH_DWORD = *((unsigned int *)(header+34));
          // read hash
          hash = ACC_HASH_READ;
          act = *(TCP_table+(hash&0x0003ffff));
      } else if (header[23]==0x11){
          ACC_HASH_DWORD = *((unsigned int *)(header+34));
          hash = ACC_HASH_READ;
          act = *(UDP_table+(hash&0x0003ffff));
      } else {
          hash = ACC_HASH_READ;
          act = *(IP_table+(hash&0x0003ffff));
      }
    }
  }
    
  if (act==0)
    desc.len = 0;
  else
    desc.port = 2;

  pkt_send(&desc);
}

int main(void)
{
  // set slot configuration parameters
  slot_count = PMEM_SEG_COUNT;
  slot_size = 16384;
  header_slot_base = DMEM_BASE + (DMEM_SIZE >> 1);
  header_slot_size = 128;

  if (slot_count > MAX_SLOT_COUNT)
    slot_count = MAX_SLOT_COUNT;

  // Do this at the beginning, so scheduler can fill the slots while
  // initializing other things.
  init_hdr_slots(slot_count, header_slot_base, header_slot_size);
  init_slots(slot_count, PKT_OFFSET, slot_size);

  write_debug(0);
    
  for (int i = 0; i < slot_count; i++)
    pkt_header[i] = (unsigned char *)(header_slot_base + PKT_OFFSET + i*header_slot_size);

  while(1) {

    // check for new packets
    if (in_pkt_ready())
    {
      // read descriptor
      read_in_pkt(&desc);

      slot_rx_packet();
    }
  }

  return 1;
}
