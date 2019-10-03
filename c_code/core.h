#ifndef CORE_H

#define CORE_H

#include "riscv_encoding.h"
// time read is not supported by Vexriscv

#define IO_START					0x8000

#define RECV_DESC					(IO_START + 0x0040) 
#define DRAM_FLAGS  			(IO_START + 0x0048) 
#define STATUS_RD   			(IO_START + 0x004C) 
#define CORE_ID     			(IO_START + 0x0050) 
#define TIMER_32_L   			(IO_START + 0x0054)
#define TIMER_32_H   			(IO_START + 0x0058)
#define INTERRUPT_FLAGS		(IO_START + 0x005C)
#define MASK_READ      		(IO_START + 0x005D)

#define DATA_DESC				  (IO_START + 0x0000)
#define DRAM_WR_ADDR   	  (IO_START + 0x0008) 
#define SLOT_ADDR  			  (IO_START + 0x0010) 
#define TIMER_INTERVAL   	(IO_START + 0x0014) 
#define DRAM_FLAG_WR   		(IO_START + 0x0018) 
#define DEBUG_REG     		(IO_START + 0x001C) 

#define DATA_DESC_SEND		(IO_START + 0x0038)
#define RECV_DESC_RELEASE (IO_START + 0x0039) 
#define DRAM_FLAG_RST  		(IO_START + 0x003A) 
#define UPDATE_SLOT       (IO_START + 0x003B) 
#define MASK_WRITE  		  (IO_START + 0x003C) 
#define INTERRUPT_ACK		  (IO_START + 0x003D)
#define RESET_TIMER 		  (IO_START + 0x003E) 

struct Desc {
	unsigned int*  data;
	unsigned char  port; 
	unsigned char  tag;
	unsigned short len;
};

extern void int_handler(void) __attribute__ ((section ("except"))) __attribute__((interrupt));

// Reads

inline _Bool in_pkt_ready (){
	volatile unsigned int * status = (volatile unsigned int *) STATUS_RD;
	return ((*((volatile unsigned char *)status)==1));
}

inline _Bool data_desc_ready () {
	volatile unsigned int * status = (volatile unsigned int *) STATUS_RD;
	return ((*(((volatile unsigned char *)status)+1))==1);
}

inline _Bool update_slot_ready (){
	volatile unsigned int * status = (volatile unsigned int *) STATUS_RD;
	return ((*(((volatile unsigned char *)status)+2))==1);
}

inline _Bool core_msg_ready (){
	volatile unsigned int * status = (volatile unsigned int *) STATUS_RD;
	return ((*(((volatile unsigned char *)status)+3))==1);
}

inline int core_id () {
	volatile unsigned int * core_id = (volatile unsigned int *) CORE_ID;
	return (*core_id);
}

inline int dram_flags () {
	volatile unsigned int * dram_flags_val = (volatile unsigned int *) DRAM_FLAGS;
	return (*dram_flags_val);
}

inline unsigned char interrupt_flags () {
	volatile unsigned char * interrupt_flags_val = (volatile unsigned char *) INTERRUPT_FLAGS;
	return (*interrupt_flags_val);
}

inline unsigned char read_masks (){
	volatile unsigned char * masks = (volatile unsigned char *) MASK_READ;
	return (*masks);
}

inline int read_timer_low () {
	volatile unsigned int * timer_32 = (volatile unsigned int *) TIMER_32_L;
	return (*timer_32); 
}

inline int read_timer_high () {
	volatile unsigned int * timer_32 = (volatile unsigned int *) TIMER_32_H;
	return (*timer_32); 
}

inline void read_in_pkt (struct Desc* input_desc){
	volatile unsigned int  * recv_desc       = (volatile unsigned int *)  RECV_DESC;
  volatile unsigned char * rd_desc_release = (volatile unsigned char *) RECV_DESC_RELEASE;
	input_desc->len  = *((unsigned short*)recv_desc);
  input_desc->tag = *(((unsigned char*)recv_desc)+2);
  input_desc->port = *(((unsigned char*)recv_desc)+3);
  input_desc->data = (unsigned int *)(*(recv_desc+1));
  asm volatile("" ::: "memory");
	* rd_desc_release = 1;
	return;
}


// Writes

inline void init_slots (const unsigned int slot_count, 
											  const unsigned int start_addr, 
												const unsigned int addr_step) {
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	volatile unsigned int  * slot_addr      = (volatile unsigned int *)  SLOT_ADDR;
	volatile unsigned char * update_slot    = (volatile unsigned char *) UPDATE_SLOT;

	for (int i=1; i<=slot_count; i++){
		*slot_addr = (i<<24) + start_addr + ((i-1)*addr_step);
		asm volatile("" ::: "memory");
		*update_slot  = 1;
	}

  *data_desc = addr_step;
  *(((unsigned char*)data_desc)+2) = (unsigned char) slot_count;
  *(data_desc+1) = (3<<28);
  asm volatile("" ::: "memory");
  * data_desc_send = 1;
	return;
}

inline void write_timer_interval (const unsigned int val){
	volatile unsigned int  * timer_interval = (volatile unsigned int *)  TIMER_INTERVAL;
	* timer_interval = val;
	return;
}

inline void write_dram_flags (const unsigned int val){
	volatile unsigned int  * dram_flag = (volatile unsigned int *)  DRAM_FLAG_WR;
	* dram_flag = val;
	return;
}

inline void write_debug (const unsigned int val){
	volatile unsigned int  * debug_reg = (volatile unsigned int *)  DEBUG_REG;
	* debug_reg = val;
	return;
}

inline void interrupt_ack (const unsigned char interrupt_ack){
	volatile unsigned char * int_ack = (volatile unsigned char *) INTERRUPT_ACK;
	* int_ack = interrupt_ack;
	return;
}

inline void reset_timer (){
	volatile unsigned char * rst_timer = (volatile unsigned char *) RESET_TIMER;
	*rst_timer = 1;
	return;
}

inline void dram_flag_reset (const unsigned char num){
  volatile unsigned char * dram_flag_rst = (volatile unsigned char *) DRAM_FLAG_RST;
	* dram_flag_rst = num;
	return;
}

inline void set_masks (const unsigned char masks){
  volatile unsigned char * masks_wr = (volatile unsigned char *) MASK_WRITE;
	* masks_wr = masks;
	return;
}

inline void pkt_done_msg (struct Desc* output_desc){
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->tag;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (1<<4);
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void safe_pkt_done_msg (struct Desc* output_desc){ 
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->tag;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (1<<4);
	while(!data_desc_ready());
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void pkt_send (struct Desc* output_desc){ 
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->tag;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void safe_pkt_send (struct Desc* output_desc){
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->tag;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
	while(!data_desc_ready());
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

// make dram_addr_high int* 
inline void dram_write (const unsigned int dram_addr_high, const unsigned int dram_addr_low,
											  struct Desc* output_desc){ 
	volatile unsigned int  * dram_addr_wr   = (volatile unsigned int *)  DRAM_WR_ADDR;
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	* dram_addr_wr    = dram_addr_low;
	*(dram_addr_wr+1) = dram_addr_high;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->tag;
  // port would get overwritten by hardware 
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (4<<4);
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void safe_dram_write (const unsigned int dram_addr_high, const unsigned int dram_addr_low,
														 struct Desc* output_desc){ 
	volatile unsigned int  * dram_addr_wr   = (volatile unsigned int *)  DRAM_WR_ADDR;
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	* dram_addr_wr    = dram_addr_low;
	*(dram_addr_wr+1) = dram_addr_high;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->tag;
  // port would get overwritten by hardware 
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (4<<4);
	while(!data_desc_ready());
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void dram_read_req (const unsigned int dram_addr_high, const unsigned int dram_addr_low,
													 struct Desc* output_desc){ 
	volatile unsigned int  * dram_addr_wr   = (volatile unsigned int *)  DRAM_WR_ADDR;
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	* dram_addr_wr    = dram_addr_low;
	*(dram_addr_wr+1) = dram_addr_high;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->tag;
  // There is no port for DRAM request. 
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (5<<4);
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void safe_dram_read_req (const unsigned int dram_addr_high, const unsigned int dram_addr_low,
															  struct Desc* output_desc){ 
	volatile unsigned int  * dram_addr_wr   = (volatile unsigned int *)  DRAM_WR_ADDR;
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	* dram_addr_wr    = dram_addr_low;
	*(dram_addr_wr+1) = dram_addr_high;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->tag;
  // There is no port for DRAM request. 
	*(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (5<<4);
	while(!data_desc_ready());
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void send_to_core (struct Desc* output_desc){
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->tag;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (2<<4);
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void safe_send_to_core (struct Desc* output_desc){ 
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->tag;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (2<<4);
	while(!data_desc_ready());
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

#endif /* CORE_H */
