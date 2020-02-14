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

#define RECV_DESC         (*((volatile struct Desc*)(IO_INT_BASE + 0x0040)))
#define DRAM_FLAGS        (*((volatile unsigned int *)(IO_INT_BASE + 0x0048)))
#define CORE_ID           (*((unsigned int *)(IO_INT_BASE + 0x0050)))
#define TIMER_32_L        (*((volatile unsigned int *)(IO_INT_BASE + 0x0054)))
#define TIMER_32_H        (*((volatile unsigned int *)(IO_INT_BASE + 0x0058)))
#define INTERRUPT_FLAGS   (*((volatile unsigned char *)(IO_INT_BASE + 0x005C)))
#define MASK_READ         (*((volatile unsigned char *)(IO_INT_BASE + 0x005D)))
#define ACTIVE_SLOTS      (*((volatile unsigned int *)(IO_INT_BASE + 0x0060)))
#define IMEM_SIZE         (*((unsigned int *)(IO_INT_BASE + 0x0064)))
#define DMEM_SIZE         (*((unsigned int *)(IO_INT_BASE + 0x0068)))
#define PMEM_SIZE         (*((unsigned int *)(IO_INT_BASE + 0x006C)))
#define PMEM_SEG_SIZE     (*((unsigned int *)(IO_INT_BASE + 0x0070)))
#define PMEM_SEG_COUNT    (*((unsigned int *)(IO_INT_BASE + 0x0074)))
#define BC_REGION_SIZE    (*((unsigned int *)(IO_INT_BASE + 0x0078)))

#define SEND_DESC_TYPE    (*((volatile unsigned char*)(IO_INT_BASE + 0x0004)))
#define SEND_DESC         (*((volatile struct   Desc*)(IO_INT_BASE + 0x0008)))
#define DRAM_ADDR         (*((volatile unsigned long long *)(IO_INT_BASE + 0x0010)))
#define SLOT_ADDR         (*((volatile unsigned int *)(IO_INT_BASE + 0x0018)))
#define TIMER_INTERVAL    (*((volatile unsigned int *)(IO_INT_BASE + 0x001C)))
#define DRAM_FLAG_WR      (*((volatile unsigned int *)(IO_INT_BASE + 0x0020)))
#define DEBUG_REG         (*((volatile unsigned int *)(IO_INT_BASE + 0x0024)))

#define DATA_DESC_SEND    (*((volatile unsigned char *)(IO_INT_BASE + 0x0028)))
#define RECV_DESC_RELEASE (*((volatile unsigned char *)(IO_INT_BASE + 0x002C)))
#define DRAM_FLAG_RST     (*((volatile unsigned char *)(IO_INT_BASE + 0x0030)))
#define UPDATE_SLOT       (*((volatile unsigned char *)(IO_INT_BASE + 0x0034)))
#define MASK_WRITE        (*((volatile unsigned char *)(IO_INT_BASE + 0x0038)))
#define INTERRUPT_ACK     (*((volatile unsigned char *)(IO_INT_BASE + 0x003C)))

#define STATUS_RD         (IO_INT_BASE + 0x004C)
#define IN_PKT_READY      (*((volatile unsigned char *)(IO_INT_BASE + 0x004C))==1)
#define DATA_DESC_READY   (*((volatile unsigned char *)(IO_INT_BASE + 0x004D))==1)
#define UPDATE_SLOT_READY (*((volatile unsigned char *)(IO_INT_BASE + 0x004E))==1)
#define CORE_MSG_READY    (*((volatile unsigned char *)(IO_INT_BASE + 0x004F))==1)

struct Desc {
	unsigned short len;
	unsigned char  tag;
	unsigned char  port;
	unsigned char* data;
};

// Reads

inline _Bool in_pkt_ready () {return IN_PKT_READY;}
inline _Bool update_slot_ready () {return UPDATE_SLOT_READY;}
inline _Bool core_msg_ready () {return CORE_MSG_READY;}
inline unsigned int core_id () {return CORE_ID;}
inline unsigned int dram_flags () {return DRAM_FLAGS;}
inline unsigned int active_slots () {return ACTIVE_SLOTS;}
inline unsigned char interrupt_flags () {return INTERRUPT_FLAGS;}
inline unsigned char read_masks () {return MASK_READ;}
inline unsigned int read_timer_low () {return TIMER_32_L;}
inline unsigned int read_timer_high () {return TIMER_32_H;}

inline void read_in_pkt (struct Desc* input_desc){
	*input_desc = RECV_DESC;
	asm volatile("" ::: "memory");
	RECV_DESC_RELEASE = 1;
	return;
}

// Writes

inline void init_slots (const unsigned int slot_count,
	                    const unsigned int start_addr,
	                    const unsigned int addr_step) {

	for (int i=1; i<=slot_count; i++){
		SLOT_ADDR = (i<<24) + (start_addr&0x00ffffff) + ((i-1)*addr_step);
		asm volatile("" ::: "memory");
		UPDATE_SLOT = 1;
	}

	SEND_DESC.len  = (unsigned short) addr_step;
	SEND_DESC.tag  = (unsigned char)  slot_count;
	SEND_DESC_TYPE = 3;
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

inline void init_hdr_slots (const unsigned int slot_count,
	                        const unsigned int start_hdr_addr,
	                        const unsigned int hdr_addr_step) {

	// TODO: Add checks for range and hdr_addr_step

	for (int i=1; i<=slot_count; i++){
		SLOT_ADDR = (1<<31) + (i<<24) + (start_hdr_addr&0x00ffffff) + ((i-1)*hdr_addr_step);
		asm volatile("" ::: "memory");
		UPDATE_SLOT = 1;
	}

	return;
}

inline void write_timer_interval (const unsigned int val){
	TIMER_INTERVAL=val;
	return;
}

inline void write_dram_flags (const unsigned int val){
	DRAM_FLAG_WR=val;
	return;
}

inline void write_debug (const unsigned int val){
	DEBUG_REG=val;
	return;
}

inline void interrupt_ack (const unsigned char interrupt_ack){
	INTERRUPT_ACK = interrupt_ack;
	return;
}

inline void dram_flag_reset (const unsigned char num){
	DRAM_FLAG_RST = num;
	return;
}

inline void set_masks (const unsigned char masks){
	MASK_WRITE = masks;
	return;
}

inline void pkt_done_msg (const struct Desc* output_desc){
	SEND_DESC      = *output_desc;
	SEND_DESC_TYPE = 1;
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

inline void safe_pkt_done_msg (const struct Desc* output_desc){
	SEND_DESC      = *output_desc;
	SEND_DESC_TYPE = 1;
	while(!DATA_DESC_READY);
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

inline void pkt_send (const struct Desc* output_desc){
	SEND_DESC = *output_desc;
	SEND_DESC_TYPE = 0;
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

inline void safe_pkt_send (const struct Desc* output_desc){
	SEND_DESC = *output_desc;
	SEND_DESC_TYPE = 0;
	while(!DATA_DESC_READY);
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

// port would get overwritten by hardware
inline void dram_write (const unsigned long long * dram_addr, const struct Desc* output_desc){
	DRAM_ADDR      = * dram_addr;
	SEND_DESC      = *output_desc;
	SEND_DESC_TYPE = 4;
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

// port would get overwritten by hardware
inline void safe_dram_write (const unsigned long long * dram_addr, const struct Desc* output_desc){
	DRAM_ADDR      = * dram_addr;
	SEND_DESC      = *output_desc;
	SEND_DESC_TYPE = 4;
	while(!DATA_DESC_READY);
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

// There is no port for DRAM request.
inline void dram_read_req (const unsigned long long * dram_addr, const struct Desc* output_desc){
	DRAM_ADDR      = * dram_addr;
	SEND_DESC      = *output_desc;
	SEND_DESC_TYPE = 5;
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

// There is no port for DRAM request. 	
inline void safe_dram_read_req (const unsigned long long * dram_addr, const struct Desc* output_desc){
	DRAM_ADDR      = * dram_addr;
	SEND_DESC      = *output_desc;
	SEND_DESC_TYPE = 5;
	while(!DATA_DESC_READY);
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

inline void send_to_core (const struct Desc* output_desc){
	SEND_DESC      = *output_desc;
	SEND_DESC_TYPE = 2;
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

inline void safe_send_to_core (const struct Desc* output_desc){
	SEND_DESC      = *output_desc;
	SEND_DESC_TYPE = 2;
	while(!DATA_DESC_READY);
	asm volatile("" ::: "memory");
	DATA_DESC_SEND = 1;
	return;
}

#endif /* CORE_H */
