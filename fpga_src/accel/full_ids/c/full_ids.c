#include "core.h"
#include "packet_headers.h"

// maximum number of slots (number of context objects)
#define MAX_CTX_COUNT 8

// maximum number of accelerators (number of accelerator context objects)
#define MAX_ACCEL_COUNT 8

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10
#define PKTS_START (7*128*1024)

// Regex accelerator control registers
#define ACC_SME_STATUS (*((volatile unsigned int *)(IO_EXT_BASE + 0x0080)))

struct sme_accel_regs {
	volatile unsigned int ctrl;
	volatile unsigned int len;
	volatile unsigned int start;
};

struct slot_context {
	int index;
	struct Desc desc;
	unsigned char *header;

	struct eth_header *eth_hdr;
	union {
		struct ipv4_header *ipv4_hdr;
	} l3_header;
	union {
		struct tcp_header *tcp_hdr;
		struct udp_header *udp_hdr;
	} l4_header;

	unsigned int payload_offset;
};

struct slot_context context[MAX_CTX_COUNT];

struct accel_context {
	struct sme_accel_regs *sme_accel;

	int index;

	char active;
	struct slot_context *active_slot;

	char slot_waiting_head;
	char slot_waiting_tail;
	struct slot_context *slot_waiting_queue[MAX_CTX_COUNT];
};

struct accel_context accel_context[MAX_ACCEL_COUNT];

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

unsigned int accel_count;
unsigned int accel_waiting_mask;
unsigned int accel_active_mask;

inline void reserve_accel(struct accel_context *ctx, struct slot_context *slt_ctx)
{
	ctx->slot_waiting_queue[ctx->slot_waiting_head] = slt_ctx;

	ctx->slot_waiting_head++;
	if (ctx->slot_waiting_head >= slot_count)
		ctx->slot_waiting_head = 0;

	accel_waiting_mask |= 1 << ctx->index;
}

inline struct slot_context *accel_pop_slot(struct accel_context *ctx)
{
	struct slot_context *slot = ctx->slot_waiting_queue[ctx->slot_waiting_tail];

	ctx->slot_waiting_tail++;
	if (ctx->slot_waiting_tail >= slot_count)
		ctx->slot_waiting_tail = 0;

	if (ctx->slot_waiting_head == ctx->slot_waiting_tail)
		accel_waiting_mask &= ~(1 << ctx->index);

	return slot;
}

inline void take_accel(struct accel_context *ctx, struct slot_context *slt_ctx)
{
	accel_active_mask |= 1 << ctx->index;
	ctx->active_slot = slt_ctx;
	ctx->active = 1;
}

inline void release_accel(struct accel_context *ctx)
{
	accel_active_mask &= ~(1 << ctx->index);
	ctx->active = 0;
}

inline int is_accel_free(struct accel_context *ctx)
{
	return !ctx->active && ctx->slot_waiting_head != ctx->slot_waiting_tail;
}

inline void slot_rx_packet(struct slot_context *ctx)
{
	// check eth type
	if (ctx->eth_hdr->type == 0x0008)
	{
		// IPv4 packet
		ctx->l3_header.ipv4_hdr = (struct ipv4_header*)(ctx->header+sizeof(struct eth_header));

		// check IHL
		if (ctx->l3_header.ipv4_hdr->version_ihl != 0x45)
			goto drop;

		ctx->l4_header.tcp_hdr = (struct tcp_header*)(((unsigned char *)ctx->l3_header.ipv4_hdr)+sizeof(struct ipv4_header));

		// check protocol
		switch (ctx->l3_header.ipv4_hdr->protocol)
		{
			case 0x06:
				// TCP
				ctx->payload_offset = sizeof(struct eth_header)+sizeof(struct ipv4_header)+sizeof(struct tcp_header);
				if (ctx->l4_header.tcp_hdr->src_port == 80 || ctx->l4_header.tcp_hdr->dest_port == 80)
				{
					// HTTP
					reserve_accel(&accel_context[2], ctx);
					return;
				}
				else
				{
					// other TCP
					reserve_accel(&accel_context[0], ctx);
					return;
				}
				break;
			case 0x11:
				// UDP
				ctx->payload_offset = sizeof(struct eth_header)+sizeof(struct ipv4_header)+sizeof(struct udp_header);
				reserve_accel(&accel_context[1], ctx);
				return;
		}
	}

drop:
	ctx->desc.len = 0;
	pkt_send(&ctx->desc);
}

inline void sme_start(struct slot_context *ctx, struct accel_context *acc_ctx)
{
	// start SME
	acc_ctx->sme_accel->start = ctx->desc.data+ctx->payload_offset;
	acc_ctx->sme_accel->len = ctx->desc.len-ctx->payload_offset;
	acc_ctx->sme_accel->ctrl = 1;

	// mark accelerator in use
	take_accel(acc_ctx, ctx);
}

inline void sme_done(struct slot_context *ctx, struct accel_context *acc_ctx)
{
	int match = 0;

	// check for match
	if (acc_ctx->sme_accel->ctrl & 0x0200)
	{
		match = 1;
	}

	acc_ctx->sme_accel->ctrl = 1<<4;

	if (!match)
	{
		// no match; drop packet
		ctx->desc.len = 0;
	}

	// send packet to host
	ctx->desc.port = 2;
	pkt_send(&ctx->desc);
}

int main(void)
{
	// set slot configuration parameters
	slot_count = 8;
	slot_size = 16*1024;
	header_slot_base = DMEM_BASE + (DMEM_SIZE >> 1);
	header_slot_size = 128;

	accel_count = 3;

	if (slot_count > MAX_SLOT_COUNT)
		slot_count = MAX_SLOT_COUNT;

	if (slot_count > MAX_CTX_COUNT)
		slot_count = MAX_CTX_COUNT;

	if (accel_count > MAX_ACCEL_COUNT)
		accel_count = MAX_ACCEL_COUNT;

	// Do this at the beginning, so scheduler can fill the slots while
	// initializing other things.
	init_hdr_slots(slot_count, header_slot_base, header_slot_size);
	init_slots(slot_count, PKTS_START+PKT_OFFSET, slot_size);

	accel_waiting_mask = 0;
	accel_active_mask = 0;

	// init slot context structures
	for (int i = 0; i < slot_count; i++)
	{
		context[i].index = i;
		context[i].desc.tag = i+1;
		context[i].desc.data = (unsigned char *)(PMEM_BASE + PKTS_START + PKT_OFFSET + i*slot_size);
		context[i].header = (unsigned char *)(header_slot_base + PKT_OFFSET + i*header_slot_size);

		context[i].eth_hdr = (struct eth_header*)context[i].header;
	}

	// init accelerator context structures
	for (int i = 0; i < accel_count; i++)
	{
		accel_context[i].index = i;
		accel_context[i].sme_accel = (struct sme_accel_regs *)(IO_EXT_BASE + i*16);
		accel_context[i].active = 0;
		accel_context[i].slot_waiting_head = 0;
		accel_context[i].slot_waiting_tail = 0;
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

		// handle accelerator done
		temp = ACC_SME_STATUS & accel_active_mask;
		if (temp)
		{
			for (int i = 0; i < accel_count; i++)
			{
				if (temp & (1 << i))
				{
					// handle packet
					sme_done(accel_context[i].active_slot, &accel_context[i]);

					// release accelerator
					release_accel(&accel_context[i]);
				}
			}
		}

		// handle slots waiting on accelerators
		temp = ~accel_active_mask & accel_waiting_mask;
		if (temp)
		{
			for (int i = 0; i < accel_count; i++)
			{
				if (temp & (1 << i))
				{
					// pop from waiting list
					struct slot_context *slot = accel_pop_slot(&accel_context[i]);

					// handle packet
					sme_start(slot, &accel_context[i]);
				}
			}
		}
	}

	return 1;
}
