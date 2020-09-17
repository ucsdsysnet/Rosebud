#include "core.h"
#include "packet_headers.h"

#define bswap_16(x) \
	(((x & 0xff00) >> 8) | ((x & 0x00ff) << 8))

#define bswap_32(x) \
	(((x & 0xff000000) >> 24) | ((x & 0x00ff0000) >>  8) | \
	 ((x & 0x0000ff00) <<  8) | ((x & 0x000000ff) << 24))

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

#define ACC_IP_MATCH_CTL (*((volatile unsigned int *)(IO_EXT_BASE + 0x0200)))

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

struct accel_group;
struct accel_context;

// Accelerator groups
struct accel_group {
	unsigned int accel_count;
	unsigned int accel_mask;
	unsigned int accel_active_mask;

	struct accel_group *list_next;

	struct accel_context *member_list_head;
	struct accel_context *member_list_tail;

	char slot_waiting_head;
	char slot_waiting_tail;
	char waiting;
	struct slot_context *slot_waiting_queue[MAX_CTX_COUNT];
};

struct accel_group accel_group[MAX_ACCEL_GROUP_COUNT];

// Accelerator contexts
struct accel_context {
	struct sme_accel_regs *sme_accel;

	unsigned int index;
	unsigned int mask;

	struct accel_group *group;

	struct accel_context *list_next;
	struct accel_context *group_list_next;

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
	// set group
	ctx->group = grp;

	// append to linked list
	if (grp->member_list_head)
	{
		grp->member_list_head->group_list_next = ctx;
	}
	else
	{
		grp->member_list_tail = ctx;
	}

	grp->member_list_head = ctx;

	grp->accel_mask |= ctx->mask;
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
	accel_active_mask |= ctx->mask;
	ctx->group->accel_active_mask |= ctx->mask;
	ctx->active_slot = slot;
}

inline void release_accel(struct accel_context *ctx)
{
	accel_active_mask &= ~ctx->mask;
	ctx->group->accel_active_mask &= ~ctx->mask;
	ctx->active_slot = 0;
}

inline void handle_slot_rx_packet(struct slot_context *ctx);
inline void handle_accel_start(struct slot_context *ctx, struct accel_context *acc_ctx);
inline void handle_accel_done(struct slot_context *ctx, struct accel_context *acc_ctx);

inline void call_accel(struct accel_group *grp, struct slot_context *slot)
{
	if (~grp->accel_active_mask & grp->accel_mask)
	{
		// group has idle accelerators
		for (struct accel_context *accel = grp->member_list_tail; accel; accel = accel->group_list_next)
		{
			if (!accel->active_slot)
			{
				// handle packet
				handle_accel_start(slot, accel);
				return;
			}
		}
	}

	// no idle accelerators
	reserve_accel(grp, slot);
}

inline void handle_slot_rx_packet(struct slot_context *ctx)
{
	// check eth type
	if (ctx->eth_hdr->type == bswap_16(0x0800))
	{
		// IPv4 packet
		ctx->l3_header.ipv4_hdr = (struct ipv4_header*)(ctx->header+sizeof(struct eth_header));

		// start IP check
		ACC_IP_MATCH_CTL = ctx->l3_header.ipv4_hdr->src_ip;

		// check IHL
		if (ctx->l3_header.ipv4_hdr->version_ihl != 0x45)
		{
			// invalid IHL, drop it
			goto drop;
		}

		ctx->l4_header.tcp_hdr = (struct tcp_header*)(((unsigned char *)ctx->l3_header.ipv4_hdr)+sizeof(struct ipv4_header));

		// check IP
		if (ACC_IP_MATCH_CTL)
		{
			// it's a match, drop it
			goto drop;
		}

		// check protocol
		switch (ctx->l3_header.ipv4_hdr->protocol)
		{
			case 0x06:
				// TCP
				ctx->payload_offset = sizeof(struct eth_header)+sizeof(struct ipv4_header)+sizeof(struct tcp_header);
				if (ctx->l4_header.tcp_hdr->src_port == bswap_16(80) || ctx->l4_header.tcp_hdr->dest_port == bswap_16(80))
				{
					// HTTP
					call_accel(&ACCEL_GROUP_HTTP, ctx);
					return;
				}
				else
				{
					// other TCP
					call_accel(&ACCEL_GROUP_TCP, ctx);
					return;
				}
				break;
			case 0x11:
				// UDP
				ctx->payload_offset = sizeof(struct eth_header)+sizeof(struct ipv4_header)+sizeof(struct udp_header);
				call_accel(&ACCEL_GROUP_UDP, ctx);
				return;
		}
	}

drop:
	ctx->desc.len = 0;
	pkt_send(&ctx->desc);
}

inline void handle_accel_start(struct slot_context *ctx, struct accel_context *acc_ctx)
{
	// start SME
	acc_ctx->sme_accel->start = (unsigned int)(ctx->desc.data)+ctx->payload_offset;
	acc_ctx->sme_accel->len = ctx->desc.len-ctx->payload_offset;
	acc_ctx->sme_accel->ctrl = 1;

	// mark accelerator in use
	take_accel(acc_ctx, ctx);
}

inline void handle_accel_done(struct slot_context *ctx, struct accel_context *acc_ctx)
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
	struct slot_context *slot;
	struct accel_context *accel;
	struct accel_group *grp;

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
	accel = 0;
	for (int i = 0; i < accel_count; i++)
	{
		accel_context[i].index = i;
		accel_context[i].mask = 1 << i;
		accel_context[i].sme_accel = (struct sme_accel_regs *)(IO_EXT_BASE + i*16);
		accel_context[i].group = 0;
		accel_context[i].list_next = 0;
		accel_context[i].group_list_next = 0;
		accel_context[i].active_slot = 0;

		if (accel)
		{
			accel->list_next = &accel_context[i];
		}

		accel = &accel_context[i];
	}

	// init accelerator group structures
	grp = 0;
	for (int i = 0; i < accel_group_count; i++)
	{
		accel_group[i].accel_count = 0;
		accel_group[i].accel_mask = 0;
		accel_group[i].accel_active_mask = 0;
		accel_group[i].slot_waiting_head = 0;
		accel_group[i].slot_waiting_tail = 0;

		if (grp)
		{
			grp->list_next = &accel_group[i];
		}
		grp = &accel_group[i];
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
		while (in_pkt_ready())
		{
			struct Desc desc;

			// read descriptor
			read_in_pkt(&desc);

			// compute index
			slot = &context[desc.tag-1];

			// copy descriptor into context
			slot->desc = desc;

			// handle packet
			handle_slot_rx_packet(slot);
		}

		// handle accelerator done
		temp = ACC_SME_STATUS & accel_active_mask;
		if (temp)
		{
			for (accel = &accel_context[0]; accel; accel = accel->list_next)
			{
				if (temp & accel->mask)
				{
					// handle packet
					handle_accel_done(accel->active_slot, accel);

					// release accelerator
					release_accel(accel);

					// try to restart accelerator
					if (accel->group->waiting)
					{
						// pop from waiting list
						slot = accel_pop_slot(accel->group);

						// handle packet
						handle_accel_start(slot, accel);
					}
				}
			}
		}
	}

	return 1;
}
