#include "core.h"

// maximum number of slots (number of context objects)
#define MAX_CTX_COUNT 8

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

struct slot_context context[MAX_CTX_COUNT];

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

inline void slot_rx_packet(struct slot_context *ctx)
{
	// start regex parsing
	ACC_REGEX_START = ctx->desc.data+14;
	ACC_REGEX_LEN = 64;
	ACC_REGEX_CTRL = 1;

	// // wait for accelerator operation to complete
	// need some delay here...
	// while (!(ACC_REGEX_CTRL & 0x0100)) {};

	// swap port
	if (ctx->desc.port==0)
		ctx->desc.port = 1;
	else
		ctx->desc.port = 0;

	// wait for accelerator operation to complete
	while (!(ACC_REGEX_CTRL & 0x0100)) {};

	// check for match
	if (ACC_REGEX_CTRL & 0x0200)
	{
		// drop packet
		ctx->desc.len = 0;
	}

	pkt_send(&ctx->desc);
}

int main(void)
{
	// set slot configuration parameters
	slot_count = PMEM_SEG_COUNT;
	slot_size = PMEM_SEG_SIZE;
	header_slot_base = DMEM_BASE + (DMEM_SIZE >> 1);
	header_slot_size = 128;

	if (slot_count > MAX_SLOT_COUNT)
		slot_count = MAX_SLOT_COUNT;

	if (slot_count > MAX_CTX_COUNT)
		slot_count = MAX_CTX_COUNT;

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
