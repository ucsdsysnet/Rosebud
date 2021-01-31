#include "core.h"

// maximum number of slots (number of context objects)
#define MAX_CTX_COUNT 8

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10
#define PKTS_START (7*128*1024)

// Regex accelerator control registers
#define ACC_REGEX_STATUS (*((volatile unsigned int *)(IO_EXT_BASE + 0x0080)))

struct regex_accel_regs {
  volatile unsigned int ctrl;
  volatile unsigned int len;
  volatile unsigned int start;
};

struct slot_context {
  int index;
  struct Desc desc;
  unsigned char *header;
  struct regex_accel_regs *regex_accel;
};

struct slot_context context[MAX_CTX_COUNT];

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

unsigned int active_accel_mask;

inline void slot_rx_packet(struct slot_context *ctx)
{
  // start regex parsing, skip Ethernet header
  ctx->regex_accel->start = ctx->desc.data+14;
  ctx->regex_accel->len = ctx->desc.len-14;
  ctx->regex_accel->ctrl = 1;

  active_accel_mask |= 1 << ctx->index;

  // swap port
  if (ctx->desc.port==0)
    ctx->desc.port = 1;
  else
    ctx->desc.port = 0;
}

inline void regex_done(struct slot_context *ctx)
{
  active_accel_mask &= ~(1 << ctx->index);

  // check for match
  if (ctx->regex_accel->ctrl & 0x0200)
  {
    // drop packet
    ctx->desc.len = 0;
  }

  ctx->regex_accel->ctrl = 1<<4;
  pkt_send(&ctx->desc);
}

int main(void)
{
  // set slot configuration parameters
  slot_count = 8;
  slot_size = 16*1024;
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

  active_accel_mask = 0;

  // init slot context structures
  for (int i = 0; i < slot_count; i++)
  {
    context[i].index = i;
    context[i].desc.tag = i+1;
    context[i].desc.data = (unsigned char *)(PMEM_BASE + PKTS_START + PKT_OFFSET + i*slot_size);
    context[i].header = (unsigned char *)(header_slot_base + PKT_OFFSET + i*header_slot_size);
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
