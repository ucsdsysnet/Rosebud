#include "core.h"

// maximum number of slots (number of context objects)
#define MAX_SLOT_COUNT 8

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10

// Regex accelerator control registers
#define ACC_REGEX_CTRL (*((volatile unsigned int *)(IO_EXT_BASE + 0x0000)))
#define ACC_REGEX_LEN (*((volatile unsigned int *)(IO_EXT_BASE + 0x0004)))
#define ACC_REGEX_START (*((volatile unsigned int *)(IO_EXT_BASE + 0x0008)))

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

char accel_active_slot;
char accel_active;

int accel_slot_waiting_queue[MAX_SLOT_COUNT];
int accel_slot_waiting_head;
int accel_slot_waiting_tail;

inline void slot_rx_packet(struct slot_context *ctx)
{
	// swap port
	if (ctx->desc.port==0)
		ctx->desc.port = 1;
	else
		ctx->desc.port = 0;

	// need accelerator
	accel_slot_waiting_queue[accel_slot_waiting_head] = ctx->index;

	accel_slot_waiting_head++;
	if (accel_slot_waiting_head >= slot_count)
		accel_slot_waiting_head = 0;
}

inline void regex_start(struct slot_context *ctx)
{
	// start regex parsing
	ACC_REGEX_START = ctx->desc.data+14;
	ACC_REGEX_LEN = 64;
	ACC_REGEX_CTRL = 1;

	// mark accelerator active on this slot
	accel_active_slot = ctx->index;
	accel_active = 1;
}

inline void regex_done(struct slot_context *ctx)
{
	// release accelerator
	accel_active = 0;

	// check for match
	if (ACC_REGEX_CTRL & 0x0200)
	{
		// drop packet
		ctx->desc.len = 0;
	}

	safe_pkt_done_msg(&ctx->desc);
}

int main(void)
{
	// set slot configuration parameters
	slot_count = 8;
	slot_size = 0x20000;
	header_slot_base = DMEM_BASE+0x4000;
	header_slot_size = 128;

	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors 

	// Do this at the beginning, so scheduler can fill the slots while
	// initializing other things.
	init_hdr_slots(slot_count, header_slot_base, header_slot_size);
	init_slots(slot_count, PKT_OFFSET, slot_size);

	accel_active_slot = 0;
	accel_active = 0;
	accel_slot_waiting_head = 0;
	accel_slot_waiting_tail = 0;

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

		// handle accelerator done
		if (accel_active && ACC_REGEX_CTRL & 0x0100)
		{
			// done
			accel_active = 0;
			regex_done(&context[accel_active_slot]);
		}

		// handle slots waiting for the accelerator
		if (!accel_active && accel_slot_waiting_head != accel_slot_waiting_tail)
		{
			regex_start(&context[accel_slot_waiting_queue[accel_slot_waiting_tail]]);

			accel_slot_waiting_tail++;
			if (accel_slot_waiting_tail >= slot_count)
				accel_slot_waiting_tail = 0;
		}
	}

	return 1;
}
