#include "core2.h"

#define SLOT_COUNT 8
#define SLOT_SIZE 16384
#define SLOT_BASE 0x000000
#define SLOT_OFFSET 0x00000A
#define SLOT_HEADER_SIZE 128
#define SLOT_HEADER_BASE 0x104000

#define ACC_HASH_CTRL  (*((volatile unsigned int *)(IO_START_EXT + 0x0000)))
#define ACC_HASH_BYTE  (*((volatile unsigned int *)(IO_START_EXT + 0x0004)))
#define ACC_HASH_WORD  (*((volatile unsigned int *)(IO_START_EXT + 0x0008)))
#define ACC_HASH_DWORD (*((volatile unsigned int *)(IO_START_EXT + 0x000C)))

struct slot_context {
	int index;
	struct Desc desc;
	unsigned char *header;
};

struct slot_context context[SLOT_COUNT];

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
	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors 

	// Do this at the beginning, so scheduler can fill the slots while
	// initializing other things.
	init_hdr_slots(SLOT_COUNT, SLOT_HEADER_BASE, SLOT_HEADER_SIZE);
	init_slots(SLOT_COUNT, SLOT_BASE+SLOT_OFFSET, SLOT_SIZE);

	// init slot context structures
	for (int i = 0; i < SLOT_COUNT; i++)
	{
		context[i].index = i;
		context[i].desc.tag = i+1;
		context[i].desc.data = (unsigned char *)(SLOT_BASE + SLOT_OFFSET + i*SLOT_SIZE);
		context[i].header = (unsigned char *)(SLOT_HEADER_BASE + SLOT_OFFSET + i*SLOT_HEADER_SIZE);
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
