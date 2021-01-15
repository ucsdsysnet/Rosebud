#include "core.h"
#include "packet_headers.h"

#if 0
#define PROFILE_A(x) do {DEBUG_OUT_L = (x);} while (0)
#define PROFILE_B(x) do {DEBUG_OUT_H = (x);} while (0)
#else
#define PROFILE_A(x) do {} while (0)
#define PROFILE_B(x) do {} while (0)
#endif

#define bswap_16(x) \
	(((x & 0xff00) >> 8) | ((x & 0x00ff) << 8))

#define bswap_32(x) \
	(((x & 0xff000000) >> 24) | ((x & 0x00ff0000) >>  8) | \
	 ((x & 0x0000ff00) <<  8) | ((x & 0x000000ff) << 24))

// maximum number of slots (number of context objects)
#define MAX_CTX_COUNT 16

// maximum number of accelerators (number of accelerator context objects)
#define MAX_ACCEL_COUNT 16

// maximum number of accelerator groups (number of accelerator group objects)
#define MAX_ACCEL_GROUP_COUNT 8

// packet start offset
// DWORD align Ethernet payload
// provide space for header modifications
#define PKT_OFFSET 10
#define PKTS_START (6*128*1024)

// SME accelerator control registers
#define ACC_SME_STATUS (*((volatile unsigned int *)(IO_EXT_BASE + 0x0100)))
#define ACC_SME_STATUS_DONE (*((volatile unsigned int *)(IO_EXT_BASE + 0x0104)))
#define ACC_SME_STATUS_MATCH (*((volatile unsigned int *)(IO_EXT_BASE + 0x0108)))
#define ACC_SME_STATUS_BUSY (*((volatile unsigned int *)(IO_EXT_BASE + 0x010C)))
#define ACC_SME_DESC_ERROR (*((volatile unsigned int *)(IO_EXT_BASE + 0x0110)))
#define ACC_SME_DONE_ERROR (*((volatile unsigned int *)(IO_EXT_BASE + 0x0114)))

#define ACC_IP_MATCH_CTL (*((volatile unsigned int *)(IO_EXT_BASE + 0x0200)))

struct sme_accel_regs {
	volatile unsigned int ctrl;
	volatile unsigned int len;
	volatile unsigned int start;
	volatile unsigned int match_1hot;
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
	PROFILE_B(0x00010000);

	// check eth type
	PROFILE_B(0xF0010000 | ctx->eth_hdr->type);
	if (ctx->eth_hdr->type == bswap_16(0x0800))
	{
		PROFILE_B(0x00010001);
		// IPv4 packet
		ctx->l3_header.ipv4_hdr = (struct ipv4_header*)(ctx->header+sizeof(struct eth_header));

		// start IP check
		ACC_IP_MATCH_CTL = ctx->l3_header.ipv4_hdr->src_ip;

		// check IHL
		if (ctx->l3_header.ipv4_hdr->version_ihl != 0x45)
		{
			// invalid IHL, drop it
			PROFILE_B(0x00010009);
			goto drop;
		}

		ctx->l4_header.tcp_hdr = (struct tcp_header*)(((unsigned char *)ctx->l3_header.ipv4_hdr)+sizeof(struct ipv4_header));

		// check IP
		if (ACC_IP_MATCH_CTL)
		{
			// it's a match, drop it
			PROFILE_B(0x0001000a);
			goto drop;
		}

		PROFILE_B(0x00010002);
		// check protocol
		switch (ctx->l3_header.ipv4_hdr->protocol)
		{
			case 0x06:
				PROFILE_B(0x00010003);
				// TCP
				PROFILE_B(0xF0010000 | ctx->l4_header.tcp_hdr->dest_port);
				ctx->payload_offset = sizeof(struct eth_header)+sizeof(struct ipv4_header)+sizeof(struct tcp_header);
				if (ctx->l4_header.tcp_hdr->src_port == bswap_16(80) || ctx->l4_header.tcp_hdr->dest_port == bswap_16(80))
				{
					PROFILE_B(0x00010004);
					// HTTP
					call_accel(&ACCEL_GROUP_HTTP, ctx);
					return;
				}
				else
				{
					PROFILE_B(0x00010005);
					// other TCP
					call_accel(&ACCEL_GROUP_TCP, ctx);
					return;
				}
				break;
			case 0x11:
				PROFILE_B(0x00010006);
				// UDP
				ctx->payload_offset = sizeof(struct eth_header)+sizeof(struct ipv4_header)+sizeof(struct udp_header);
				call_accel(&ACCEL_GROUP_UDP, ctx);
				return;
		}
	}

	PROFILE_B(0x00010007);
drop:
	PROFILE_B(0x00010008);
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

	DEBUG_OUT_L = 0;
	DEBUG_OUT_H = 0;

	// set slot configuration parameters
	slot_count = 16;
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

	PROFILE_A(0x00000001);

	// Do this at the beginning, so scheduler can fill the slots while
	// initializing other things.
	init_hdr_slots(slot_count, header_slot_base, header_slot_size);
	init_slots(slot_count, PKTS_START+PKT_OFFSET, slot_size);

	PROFILE_A(0x00000002);

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

	PROFILE_A(0x00000003);

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

	PROFILE_A(0x00000004);

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

		if (i < 4)
		{
			grp = &ACCEL_GROUP_TCP;
		}
		else if (i < 8)
		{
			grp = &ACCEL_GROUP_UDP;
		}
		else if (i < 12)
		{
			grp = &ACCEL_GROUP_HTTP;
		}
		else if (i < 13)
		{
			grp = &ACCEL_GROUP_FIXED;
		}
		else
		{
			continue;
		}

		add_accel_to_group(grp, &accel_context[i]);
	}

	PROFILE_A(0x00000005);

	while (1)
	{
		unsigned int temp;
		DEBUG_OUT_H = (ACC_SME_STATUS_BUSY<<16)  | accel_active_mask;
		DEBUG_OUT_L = (ACC_SME_DESC_ERROR << 16) | ACC_SME_DONE_ERROR;

		PROFILE_A(0x00010000);

		// check for new packets
		while (in_pkt_ready())
		{
			struct Desc desc;

			PROFILE_A(0x00010001);

			// read descriptor
			read_in_pkt(&desc);

			// compute index
			slot = &context[desc.tag-1];

			// copy descriptor into context
			slot->desc = desc;

			PROFILE_A(0x00010002);
			// handle packet
			handle_slot_rx_packet(slot);
			PROFILE_A(0x00010003);
		}

		PROFILE_A(0x00020000);

		// handle accelerator done
		temp = ACC_SME_STATUS & accel_active_mask;
		if (temp)
		{
			PROFILE_A(0x00020001);
			for (accel = &accel_context[0]; accel; accel = accel->list_next)
			{
				PROFILE_A(0x00020002);
				if (temp & accel->mask)
				{
					PROFILE_A(0x00020003);
					// handle packet
					handle_accel_done(accel->active_slot, accel);
					PROFILE_A(0x00020004);

					// release accelerator
					release_accel(accel);
					PROFILE_A(0x00020005);

					// try to restart accelerator
					if (accel->group->waiting)
					{
						// pop from waiting list
						slot = accel_pop_slot(accel->group);
						PROFILE_A(0x00020006);

						// handle packet
						handle_accel_start(slot, accel);
						PROFILE_A(0x00020007);
					}
				}
			}
		}
	}

	return 1;
}
