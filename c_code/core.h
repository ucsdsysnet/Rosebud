#ifndef CORE_H

#define CORE_H

#include "riscv_encoding.h"
// time read is not supported by Vexriscv

#define ctz(src) ({ unsigned int __tmp; \
  asm volatile ("TAIL_ZERO(%0,%1)": "=r"(__tmp) : "r" (src)); \
  __tmp; })

#define IO_BASE           0x00000000
#define IO_INT_BASE       0x00000000
#define IO_EXT_BASE       0x00400000
#define DMEM_BASE         0x00800000
#define PMEM_BASE         0x01000000

#define RECV_DESC         (*((volatile struct Desc*)        (IO_INT_BASE + 0x0080)))
#define DRAM_FLAGS        (*((volatile unsigned int *)      (IO_INT_BASE + 0x0088)))
#define CORE_ID           (*((unsigned int *)               (IO_INT_BASE + 0x0090)))
#define TIMER_32_L        (*((volatile unsigned int *)      (IO_INT_BASE + 0x0094)))
#define TIMER_32_H        (*((volatile unsigned int *)      (IO_INT_BASE + 0x0098)))
#define FLAGS_REG         (*((volatile unsigned int *)      (IO_INT_BASE + 0x009C)))
#define ERROR_FLAGS       (*((volatile unsigned char *)     (IO_INT_BASE + 0x009C)))
#define MASK_READ         (*((volatile unsigned char *)     (IO_INT_BASE + 0x009D)))
#define INTERRUPT_FLAGS   (*((volatile unsigned char *)     (IO_INT_BASE + 0x009E)))
#define ACTIVE_SLOTS      (*((volatile unsigned int *)      (IO_INT_BASE + 0x00A0)))
#define IMEM_SIZE         (*((unsigned int *)               (IO_INT_BASE + 0x00A4)))
#define DMEM_SIZE         (*((unsigned int *)               (IO_INT_BASE + 0x00A8)))
#define PMEM_SIZE         (*((unsigned int *)               (IO_INT_BASE + 0x00AC)))
#define PMEM_SEG_SIZE     (*((unsigned int *)               (IO_INT_BASE + 0x00B0)))
#define PMEM_SEG_COUNT    (*((unsigned int *)               (IO_INT_BASE + 0x00B4)))
#define BC_REGION_SIZE    (*((unsigned int *)               (IO_INT_BASE + 0x00B8)))
#define MAX_SLOT_COUNT    (*((unsigned int *)               (IO_INT_BASE + 0x00BC)))
#define DEBUG_IN_L        (*((unsigned int *)               (IO_INT_BASE + 0x00C0)))
#define DEBUG_IN_H        (*((unsigned int *)               (IO_INT_BASE + 0x00C4)))
#define RD_BC_MASK        (*((unsigned int *)               (IO_INT_BASE + 0x00C8)))
#define RD_BC_EQUAL       (*((unsigned int *)               (IO_INT_BASE + 0x00CC)))
#define RECV_BC_ADDR      (*((unsigned int *)               (IO_INT_BASE + 0x00D0)))

#define SEND_DESC         (*((volatile struct   Desc*)      (IO_INT_BASE + 0x0008)))
#define DRAM_ADDR         (*((volatile unsigned long long *)(IO_INT_BASE + 0x0010)))
#define SLOT_ADDR         (*((volatile unsigned int *)      (IO_INT_BASE + 0x0018)))
#define TIMER_INTERVAL    (*((volatile unsigned int *)      (IO_INT_BASE + 0x001C)))
#define DRAM_FLAG_WR      (*((volatile unsigned int *)      (IO_INT_BASE + 0x0020)))
#define READY_TO_EVICT    (*((volatile unsigned int *)      (IO_INT_BASE + 0x0024)))
#define SEND_DESC_TYPE    (*((volatile unsigned char *)     (IO_INT_BASE + 0x0028)))
#define RECV_DESC_RELEASE (*((volatile unsigned char *)     (IO_INT_BASE + 0x002C)))
#define DRAM_FLAG_RST     (*((volatile unsigned char *)     (IO_INT_BASE + 0x0030)))
#define UPDATE_SLOT       (*((volatile unsigned char *)     (IO_INT_BASE + 0x0034)))
#define MASK_WRITE        (*((volatile unsigned char *)     (IO_INT_BASE + 0x0038)))
#define INTERRUPT_ACK     (*((volatile unsigned int  *)     (IO_INT_BASE + 0x003C)))
#define DEBUG_OUT         (*((volatile unsigned long long *)(IO_INT_BASE + 0x0040)))
#define DEBUG_OUT_L       (*((volatile unsigned int *)      (IO_INT_BASE + 0x0040)))
#define DEBUG_OUT_H       (*((volatile unsigned int *)      (IO_INT_BASE + 0x0044)))
#define BC_MASK_WR        (*((volatile unsigned int *)      (IO_INT_BASE + 0x0048)))
#define BC_EQUAL_WR       (*((volatile unsigned int *)      (IO_INT_BASE + 0x004C)))
#define BC_INT_EN         (*((volatile unsigned int *)      (IO_INT_BASE + 0x0050)))

#define STATUS_RD                                           (IO_INT_BASE + 0x008C)
#define IN_PKT_READY      (*((volatile unsigned char *)     (IO_INT_BASE + 0x008C))==1)
#define DATA_DESC_READY   (*((volatile unsigned char *)     (IO_INT_BASE + 0x008D))==1)
#define UPDATE_SLOT_READY (*((volatile unsigned char *)     (IO_INT_BASE + 0x008E))==1)
#define CORE_MSG_READY    (*((volatile unsigned char *)     (IO_INT_BASE + 0x008F))==1)

// MASK BITS:    DATA_MEM_ERR | IMEM_ERR | EXT_IO_ERR | EVICT_INT | POKE_INT | TIMER_INT | RECV_DRAM_DATA_INT | PACKET_INT
// FLAGS BITS:   8 BITS RESERVED
//               - | - | EXT_IO_ERR | EVICT_INT | POKE_INT | TIMER | DRAM_DATA_ARRIVED | PACKET_ARRIVED
//               MASK READ BACK
//               - | - | - | - | INT_IO_ACCESS_ERR | PMEM_ACCESS_ERR | DMEM_ACCESS_ERR | IMEM_ACCESS_ERR
// INT ACK BITS: INT_IO_ACCESS_ERR | PMEM_ACCESS_ERR | DMEM_ACCESS_ERR | IMEM_ACCESS_ERR | EXT_IO_ERR | EVICT_INT | POKE_INT | TIMER

struct Desc {
	unsigned short len;
	unsigned char  tag;
	unsigned char  port;
	unsigned char* data;
};

// Reads

static inline _Bool in_pkt_ready() { return IN_PKT_READY; }
static inline _Bool update_slot_ready() { return UPDATE_SLOT_READY; }
static inline _Bool core_msg_ready() { return CORE_MSG_READY; }
static inline unsigned int core_id() { return CORE_ID; }
static inline unsigned int dram_flags() { return DRAM_FLAGS; }
static inline unsigned int active_slots() { return ACTIVE_SLOTS; }
static inline unsigned char interrupt_flags() { return INTERRUPT_FLAGS; }
static inline unsigned char error_flags() { return ERROR_FLAGS; }
static inline unsigned char read_masks() { return MASK_READ; }
static inline unsigned int read_timer_low() { return TIMER_32_L; }
static inline unsigned int read_timer_high() { return TIMER_32_H; }
static inline unsigned int read_bc_mask() { return RD_BC_MASK; }
static inline unsigned int read_bc_equal() { return RD_BC_EQUAL; }
static inline unsigned int recv_bc_msg_addr() { return RECV_BC_ADDR; }

static inline void read_in_pkt (struct Desc* input_desc) {
	*input_desc = RECV_DESC;
	asm volatile("" ::: "memory");
	RECV_DESC_RELEASE = 1;
}

// Writes

static inline void init_slots(const unsigned int slot_count,
                              const unsigned int start_addr,
                              const unsigned int addr_step) {

	unsigned int addr = start_addr & 0x00ffffff;
	for (int i=1; i<=slot_count; i++) {
		SLOT_ADDR = (i<<24) + addr;
		asm volatile("" ::: "memory");
		UPDATE_SLOT = 1;
		addr += addr_step;
	}

	SEND_DESC.len  = (unsigned short) addr_step;
	SEND_DESC.tag  = (unsigned char)  slot_count;
	asm volatile("" ::: "memory");
	SEND_DESC_TYPE = 3;
}

static inline void init_hdr_slots(const unsigned int slot_count,
                                  const unsigned int start_hdr_addr,
                                  const unsigned int hdr_addr_step) {

	// TODO: Add checks for range and hdr_addr_step

	unsigned int addr = start_hdr_addr & 0x00ffffff;
	for (int i=1; i<=slot_count; i++) {
		SLOT_ADDR = (1<<31) + (i<<24) + addr;
		asm volatile("" ::: "memory");
		UPDATE_SLOT = 1;
		addr += hdr_addr_step;
	}
}

static inline void set_bc_filter(const unsigned int bc_mask,
                                 const unsigned int bc_equal) {
	BC_MASK_WR  = bc_mask;
	BC_EQUAL_WR = bc_equal;
	BC_INT_EN   = 1;
	MASK_WRITE  = MASK_READ | 8;
}


// static inline void init_desc_slots (const unsigned int slot_count,
// 	                          const unsigned int start_desc_addr,
// 	                          const unsigned int desc_addr_step) {
//
// 	// TODO: Add checks for range and hdr_addr_step
//
// 	for (int i=1; i<=slot_count; i++) {
// 		SLOT_ADDR = (3<<30) + (i<<24) + (start_desc_addr&0x00ffffff) + ((i-1)*desc_addr_step);
// 		asm volatile("" ::: "memory");
// 		UPDATE_SLOT = 1;
// 	}
//
// 	return;
// }

static inline void write_timer_interval(const unsigned int val) {
	TIMER_INTERVAL = val;
}

static inline void write_dram_flags(const unsigned int val) {
	DRAM_FLAG_WR = val;
}

static inline void write_debug(const unsigned long long val) {
	DEBUG_OUT = val;
}

static inline void interrupt_ack(const unsigned int interrupt_ack) {
	INTERRUPT_ACK = interrupt_ack;
}

static inline void dram_flag_reset(const unsigned char num) {
	DRAM_FLAG_RST = num;
}

static inline void set_masks(const unsigned char masks) {
	MASK_WRITE = masks;
}

static inline void pkt_done_msg(const struct Desc* output_desc) {
	SEND_DESC      = *output_desc;
	asm volatile("" ::: "memory");
	SEND_DESC_TYPE = 1;
}

static inline void pkt_send(const struct Desc* output_desc) {
	SEND_DESC = *output_desc;
	asm volatile("" ::: "memory");
	SEND_DESC_TYPE = 0;
}

static inline void atomic_pkt_send(const struct Desc* output_desc) {
	unsigned char m = MASK_READ;
	MASK_WRITE = 0;
	SEND_DESC = *output_desc;
	asm volatile("" ::: "memory");
	SEND_DESC_TYPE = 0;
	MASK_WRITE = m;
}

// port would get overwritten by hardware
static inline void dram_write(const unsigned long long * dram_addr, const struct Desc* output_desc) {
	DRAM_ADDR      = * dram_addr;
	SEND_DESC      = *output_desc;
	asm volatile("" ::: "memory");
	SEND_DESC_TYPE = 4;
}

// There is no port for DRAM request.
static inline void dram_read_req(const unsigned long long * dram_addr, const struct Desc* output_desc) {
	DRAM_ADDR      = * dram_addr;
	SEND_DESC      = *output_desc;
	asm volatile("" ::: "memory");
	SEND_DESC_TYPE = 5;
}

static inline void send_to_core(const struct Desc* output_desc) {
	SEND_DESC      = *output_desc;
	asm volatile("" ::: "memory");
	SEND_DESC_TYPE = 2;
}

#endif /* CORE_H */
