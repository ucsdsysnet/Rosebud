#include "core.h"
#include "packet_headers.h"

// maximum number of slots (number of context objects)
#define MAX_CTX_COUNT 8

// maximum number of accelerators (number of accelerator context objects)
#define MAX_ACCEL_COUNT 16

// maximum number of accelerator groups (number of accelerator group objects)
#define MAX_ACCEL_GROUP_COUNT 8

// maximum number of accelerators per group
#define MAX_ACCEL_PER_GROUP 4

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10
#define PKTS_START (7*128*1024)

// SME accelerator control registers
#define ACC_SME_STATUS (*((volatile unsigned int *)(IO_EXT_BASE + 0x0100)))

struct sme_accel_regs {
	volatile unsigned int ctrl;
	volatile unsigned int len;
	volatile unsigned int start;
};

// Slot contexts
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

struct accel_context;

// Accelerator groups
struct accel_group {
	unsigned int accel_count;
	unsigned int accel_mask;
	unsigned int accel_active_mask;

	char slot_waiting_head;
	char slot_waiting_tail;
	char waiting;
	struct slot_context *slot_waiting_queue[MAX_CTX_COUNT];

	struct accel_context *members[MAX_ACCEL_PER_GROUP];
};

struct accel_group accel_group[MAX_ACCEL_GROUP_COUNT];

// Accelerator contexts
struct accel_context {
	struct sme_accel_regs *sme_accel;

	int index;

	struct accel_group *group;

	struct slot_context *active_slot;
};

struct accel_context accel_context[MAX_ACCEL_COUNT];

#define ACCEL_GROUP_TCP_INDEX 0
#define ACCEL_GROUP_UDP_INDEX 1
#define ACCEL_GROUP_HTTP_INDEX 2
#define ACCEL_GROUP_FIXED_INDEX 3

#define ACCEL_GROUP_TCP accel_group[ACCEL_GROUP_TCP_INDEX]
#define ACCEL_GROUP_UDP accel_group[ACCEL_GROUP_UDP_INDEX]
#define ACCEL_GROUP_HTTP accel_group[ACCEL_GROUP_HTTP_INDEX]
#define ACCEL_GROUP_FIXED accel_group[ACCEL_GROUP_FIXED_INDEX]

inline void add_accel_to_group(struct accel_group *grp, struct accel_context *ctx)
{
	ctx->group = grp;
	grp->members[grp->accel_count] = ctx;
	grp->accel_mask |= (1 << ctx->index);
	grp->accel_count++;
}

unsigned int slot_count;
unsigned int slot_size;
unsigned int header_slot_base;
unsigned int header_slot_size;

unsigned int accel_count;
unsigned int accel_group_count;
unsigned int accel_waiting_mask;
unsigned int accel_active_mask;

inline void reserve_accel(struct accel_group *grp, struct slot_context *slot)
{
	grp->slot_waiting_queue[grp->slot_waiting_head] = slot;

	grp->slot_waiting_head++;
	if (grp->slot_waiting_head >= slot_count)
		grp->slot_waiting_head = 0;

	grp->waiting = 1;
}

inline struct slot_context *accel_pop_slot(struct accel_group *grp)
{
	struct slot_context *slot = grp->slot_waiting_queue[grp->slot_waiting_tail];

	grp->slot_waiting_tail++;
	if (grp->slot_waiting_tail >= slot_count)
		grp->slot_waiting_tail = 0;

	if (grp->slot_waiting_head == grp->slot_waiting_tail)
		grp->waiting = 0;

	return slot;
}

inline void take_accel(struct accel_context *ctx, struct slot_context *slot)
{
	accel_active_mask |= 1 << ctx->index;
	ctx->group->accel_active_mask |= 1 << ctx->index;
	ctx->active_slot = slot;
}

inline void release_accel(struct accel_context *ctx)
{
	accel_active_mask &= ~(1 << ctx->index);
	ctx->group->accel_active_mask &= ~(1 << ctx->index);
	ctx->active_slot = 0;
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
					reserve_accel(&ACCEL_GROUP_HTTP, ctx);
					return;
				}
				else
				{
					// other TCP
					reserve_accel(&ACCEL_GROUP_TCP, ctx);
					return;
				}
				break;
			case 0x11:
				// UDP
				ctx->payload_offset = sizeof(struct eth_header)+sizeof(struct ipv4_header)+sizeof(struct udp_header);
				reserve_accel(&ACCEL_GROUP_UDP, ctx);
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
	acc_ctx->sme_accel->start = (unsigned int)(ctx->desc.data)+ctx->payload_offset;
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

	accel_count = 4+4+4+1;
	accel_group_count = 4;

	if (slot_count > MAX_SLOT_COUNT)
		slot_count = MAX_SLOT_COUNT;

	if (slot_count > MAX_CTX_COUNT)
		slot_count = MAX_CTX_COUNT;

	if (accel_count > MAX_ACCEL_COUNT)
		accel_count = MAX_ACCEL_COUNT;

	if (accel_group_count > MAX_ACCEL_GROUP_COUNT)
		accel_group_count = MAX_ACCEL_GROUP_COUNT;

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
		accel_context[i].active_slot = 0;
	}

	// init accelerator group structures
	for (int i = 0; i < accel_group_count; i++)
	{
		accel_group[i].accel_count = 0;
		accel_group[i].accel_mask = 0;
		accel_group[i].accel_active_mask = 0;
		accel_group[i].slot_waiting_head = 0;
		accel_group[i].slot_waiting_tail = 0;
	}

	add_accel_to_group(&ACCEL_GROUP_TCP, &accel_context[0]);
	add_accel_to_group(&ACCEL_GROUP_TCP, &accel_context[1]);
	add_accel_to_group(&ACCEL_GROUP_TCP, &accel_context[2]);
	add_accel_to_group(&ACCEL_GROUP_TCP, &accel_context[3]);
	add_accel_to_group(&ACCEL_GROUP_UDP, &accel_context[4]);
	add_accel_to_group(&ACCEL_GROUP_UDP, &accel_context[5]);
	add_accel_to_group(&ACCEL_GROUP_UDP, &accel_context[6]);
	add_accel_to_group(&ACCEL_GROUP_UDP, &accel_context[7]);
	add_accel_to_group(&ACCEL_GROUP_HTTP, &accel_context[8]);
	add_accel_to_group(&ACCEL_GROUP_HTTP, &accel_context[9]);
	add_accel_to_group(&ACCEL_GROUP_HTTP, &accel_context[10]);
	add_accel_to_group(&ACCEL_GROUP_HTTP, &accel_context[11]);
	add_accel_to_group(&ACCEL_GROUP_FIXED, &accel_context[12]);

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
		for (int i = 0; i < accel_group_count; i++)
		{
			struct accel_group *grp = &accel_group[i];

			if (grp->waiting && (~grp->accel_active_mask & grp->accel_mask))
			{
				for (int j = 0; j < grp->accel_count; j++)
				{
					struct accel_context *ctx = grp->members[j];

					if (grp->waiting && !ctx->active_slot)
					{
						// pop from waiting list
						struct slot_context *slot = accel_pop_slot(grp);

						// handle packet
						sme_start(slot, ctx);
					}
				}
			}
		}
	}

	return 1;
}
