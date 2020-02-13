#include "core.h"

// maximum number of slots (number of context objects)
#define MAX_SLOT_COUNT 8

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10

// Hash accelerator control registers
#define ACC_HASH_CTRL  (*((volatile unsigned int *)(IO_EXT_BASE + 0x0000)))
#define ACC_HASH_BYTE  (*((volatile unsigned int *)(IO_EXT_BASE + 0x0004)))
#define ACC_HASH_WORD  (*((volatile unsigned int *)(IO_EXT_BASE + 0x0008)))
#define ACC_HASH_DWORD (*((volatile unsigned int *)(IO_EXT_BASE + 0x000C)))

struct slot_context {
	int index;
	struct Desc desc;
	unsigned char *header;
};

struct slot_context context[MAX_SLOT_COUNT];

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

inline void slot_rx_packet(struct slot_context *ctx)
{
	long int hash;

	// parse header and compute flow hash
	
	// reset hash module
	ACC_HASH_CTRL = 0;

	// check eth type
	if (*((unsigned short *)(ctx->header+12)) == 0x0008)
	{
		// IPv4 packet
		// IPv4 addresses
		ACC_HASH_DWORD = *((unsigned long *)(ctx->header+26));
		ACC_HASH_DWORD = *((unsigned long *)(ctx->header+30));

		// check IHL and protocol
		if (ctx->header[14] == 0x45 && (ctx->header[23] == 0x06 || ctx->header[23] == 0x11))
		{
			// TCP or UDP ports
			ACC_HASH_DWORD = *((unsigned long *)(ctx->header+34));
		}
	}

	// read hash
	hash = ACC_HASH_CTRL;

	// swap port
	if (ctx->desc.port==0)
		ctx->desc.port = 1;
	else
		ctx->desc.port = 0;
	
	safe_pkt_done_msg(&ctx->desc);
}

int main(void)
{
	// set slot configuration parameters
	slot_count = 8;
	slot_size = 32768;
	header_slot_base = DMEM_BASE+0x4000;
	header_slot_size = 128;

	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors 

	// Do this at the beginning, so scheduler can fill the slots while
	// initializing other things.
	init_hdr_slots(slot_count, header_slot_base, header_slot_size);
	init_slots(slot_count, PKT_OFFSET, slot_size);

	// init slot context structures
	for (int i = 0; i < slot_count; i++)
	{
		context[i].index = i;
		context[i].desc.tag = i+1;
		context[i].desc.data = (unsigned char *)(PMEM_BASE + PKT_OFFSET + i*slot_size);
		context[i].header = (unsigned char *)(header_slot_base + PKT_OFFSET + i*header_slot_size);
	}

	while (1)
	{
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
	}

	return 1;
}
