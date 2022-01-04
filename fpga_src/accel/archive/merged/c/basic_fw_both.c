#include "core.h"

// maximum number of slots (number of context objects)
#define MAX_CTX_COUNT 4

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

// Regex accelerator control registers
#define ACC_REGEX_STATUS (*((volatile unsigned int *)(IO_EXT_BASE + 0x0080)))

// Hash lookup tables
#define UDP_table (volatile char *) 0x01080000
#define TCP_table (volatile char *) 0x010C0000

struct regex_accel_regs {
  volatile unsigned int ctrl;
  volatile unsigned int len;
  volatile unsigned int start;
};

struct slot_context {
  int index;
  struct Desc desc;
  struct regex_accel_regs *regex_accel;
};

struct slot_context context[MAX_CTX_COUNT];

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

unsigned char * pkt_header [8];
unsigned int active_accel_mask;

inline void slot_rx_packet(struct slot_context *ctx)
{
  long int hash;
  char act = 0;
  unsigned char* header;

  // reset hash module
  header = pkt_header[(ctx->desc.tag)-1];
  ACC_HASH_CTRL = 0;

  // check eth type
  if (*((unsigned short *)(header+12)) == 0x0008){
    // IPv4 packet
    // IPv4 addresses
    ACC_HASH_DWORD = *((unsigned int *)(header+26));
    ACC_HASH_DWORD = *((unsigned int *)(header+30));

    // check IHL and protocol
    if (header[14] == 0x45){
      if(header[23] == 0x06){
        // TCP or UDP ports
        ACC_HASH_DWORD = *((unsigned int *)(header+34));
        // read hash
        hash = ACC_HASH_READ;
        act = *(TCP_table+(hash&0x0003ffff));
      } else if (header[23] == 0x11){
        ACC_HASH_DWORD = *((unsigned int *)(header+34));
        hash = ACC_HASH_READ;
        act = *(UDP_table+(hash&0x0003ffff));
      } 
    }
  }
  
  if (act==0){
    ctx->desc.len = 0;
    pkt_send(&ctx->desc);
  } else { 
  //   ctx->desc.port = 2;
  //   pkt_send(&ctx->desc);
  // }
    // start regex parsing, skip Ethernet header
    ctx->regex_accel->start = ctx->desc.data+14;
    ctx->regex_accel->len = ctx->desc.len-14;
    ctx->regex_accel->ctrl = 1;

    active_accel_mask |= 1 << ctx->index;
  }
}

inline void regex_done(struct slot_context *ctx)
{
  active_accel_mask &= ~(1 << ctx->index);

  // check for match and forward to host
  if (ctx->regex_accel->ctrl & 0x0200)
    ctx->desc.port = 2;
  else
    ctx->desc.len = 0;

  ctx->regex_accel->ctrl = 1<<4;
  pkt_send(&ctx->desc);
}

int main(void)
{
  // set slot configuration parameters
  slot_count = 4; // PMEM_SEG_COUNT;
  slot_size = PMEM_SEG_SIZE;
  header_slot_base = DMEM_BASE + (DMEM_SIZE >> 1);
  header_slot_size = 128;

  if (slot_count > MAX_SLOT_COUNT)
    slot_count = MAX_SLOT_COUNT;

  // if (slot_count > MAX_CTX_COUNT)
  //   slot_count = MAX_CTX_COUNT;

  // Do this at the beginning, so scheduler can fill the slots while
  // initializing other things.
  init_hdr_slots(slot_count, header_slot_base, header_slot_size);
  init_slots(slot_count, PKT_OFFSET, slot_size);

  active_accel_mask = 0;

  for (int i = 0; i < slot_count; i++)
    pkt_header[i] = (unsigned char *)(header_slot_base + PKT_OFFSET + i*header_slot_size);

  // init slot context structures
  for (int i = 0; i < MAX_CTX_COUNT; i++)
  {
    context[i].index = i;
    context[i].regex_accel = (struct regex_accel_regs *)(IO_EXT_BASE + i*16);
  }

  while (1)
  {
    unsigned int temp;

    // check for new packets
    if (in_pkt_ready())
    {
      struct Desc desc;
      int index;

      // read descriptor
      read_in_pkt(&desc);

      // compute index
      index = desc.tag-1;

      // copy descriptor into context
      context[index].desc = desc;

      // handle packet
      slot_rx_packet(&context[index]);
    }

    // check accelerators
    temp = ACC_REGEX_STATUS & active_accel_mask;
    if (temp)
    {
      for (int i = 0; i < slot_count; i++)
      {
        if (temp & (1 << i))
        {
          // handle packet
          regex_done(&context[i]);
        }
      }
    }
  }

  return 1;
}
