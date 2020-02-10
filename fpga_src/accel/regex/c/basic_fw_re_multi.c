#include "core2.h"

#define SLOT_COUNT 8
#define SLOT_SIZE 16384
#define SLOT_BASE 0x000000
#define SLOT_OFFSET 0x00000A
#define SLOT_HEADER_SIZE 128
#define SLOT_HEADER_BASE 0x104000

#define ACC_REGEX_STATUS (*((volatile unsigned int *)(IO_START_EXT + 0x0080)))

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

struct slot_context context[SLOT_COUNT];

unsigned int active_accel_mask;

inline void slot_rx_packet(struct slot_context *ctx)
{
	// start regex parsing
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

	active_accel_mask = 0;

	// init slot context structures
	for (int i = 0; i < SLOT_COUNT; i++)
	{
		context[i].index = i;
		context[i].desc.tag = i+1;
		context[i].desc.data = (unsigned char *)(SLOT_BASE + SLOT_OFFSET + i*SLOT_SIZE);
		context[i].header = (unsigned char *)(SLOT_HEADER_BASE + SLOT_OFFSET + i*SLOT_HEADER_SIZE);
		context[i].regex_accel = (struct regex_accel_regs *)(IO_START_EXT + i*16);
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
			for (int i = 0; i < SLOT_COUNT; i++)
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
