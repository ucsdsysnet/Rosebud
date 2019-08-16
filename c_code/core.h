#ifndef CORE_H
#define CORE_H

#define IO_START					0x8000
// update slot start addr and step, and ctrl msg code for slot init
// Setting is byte addressable for read and write, no function for it though

#define RECV_DESC					(IO_START + 0x0040) 
#define SETTING_RD  			(IO_START + 0x0048) 
#define STATUS_RD   			(IO_START + 0x0050) 
#define CORE_ID     			(IO_START + 0x0054) 
#define TIMER_32    			(IO_START + 0x0058)

#define DATA_DESC				  (IO_START + 0x0000)
#define DRAM_WR_ADDR   	  (IO_START + 0x0008) 
#define SETTING_WR 			  (IO_START + 0x0010) 
#define SLOT_ADDR  			  (IO_START + 0x0018) 

#define DATA_DESC_SEND		(IO_START + 0x0038)
#define RECV_DESC_RELEASE (IO_START + 0x0039) 
#define SETTING_APPLY  		(IO_START + 0x003A) 
#define UPDATE_SLOT       (IO_START + 0x003B) 
#define RESET_TIMER 		  (IO_START + 0x003C) 
#define ERROR_CLEAR			  (IO_START + 0x003D)

struct Desc {
	unsigned int*  data;
	unsigned char  port; 
	unsigned char  slot;; 
	unsigned short len;
};

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

  *data_desc = slot_count;
  *(data_desc+1) = (3<<28);
  asm volatile("" ::: "memory");
  * data_desc_send = 1;
	return;
}

inline int core_id () {
	volatile unsigned int * core_id = (volatile unsigned int *) CORE_ID;
	return (*core_id);
}

inline _Bool data_desc_ready () {
	volatile unsigned int * status = (volatile unsigned int *) STATUS_RD;
	return ((*((volatile unsigned char *)status)==1));
}

inline _Bool update_slot_ready (){
	volatile unsigned int * status = (volatile unsigned int *) STATUS_RD;
	return ((*(((volatile unsigned char *)status)+2))==1);
}

inline _Bool core_msg_ready (){
	volatile unsigned int * status = (volatile unsigned int *) STATUS_RD;
	return ((*(((volatile unsigned char *)status)+3))==1);
}

// Maybe make high and low to be int*
inline void write_setting (const unsigned int high, const unsigned int low){
	volatile unsigned int  * setting_wr    = (volatile unsigned int *)  SETTING_WR;
	volatile unsigned char * setting_apply = (volatile unsigned char *) SETTING_APPLY;
	* setting_wr    = low;
	*(setting_wr+1) = high;
  asm volatile("" ::: "memory");
  * setting_apply = 1;
	return;
}

inline void read_setting (unsigned int * high, unsigned int * low){
	volatile unsigned int * setting_rd = (volatile unsigned int *)  SETTING_RD;
	*low  = * setting_rd;
	*high = * (setting_rd+1);
	return;
}

inline volatile _Bool in_pkt_ready (){
	volatile unsigned int * recv_desc = (volatile unsigned int *) RECV_DESC;
	return ((*recv_desc)!=0);
}

inline void read_in_pkt (struct Desc* input_desc){
	volatile unsigned int  * recv_desc       = (volatile unsigned int *)  RECV_DESC;
  volatile unsigned char * rd_desc_release = (volatile unsigned char *) RECV_DESC_RELEASE;
	input_desc->len  = *((unsigned short*)recv_desc);
  input_desc->slot = *(((unsigned char*)recv_desc)+2);
  input_desc->port = *(((unsigned char*)recv_desc)+3);
  input_desc->data = (unsigned int *)(*(recv_desc+1));
  asm volatile("" ::: "memory");
	* rd_desc_release = 1;
	return;
}

inline void pkt_done_msg (struct Desc* output_desc){
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->slot;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (1<<4);
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void pkt_send (struct Desc* output_desc){ 
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->slot;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void safe_pkt_done_msg (struct Desc* output_desc){ 
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->slot;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (1<<4);
	while(!data_desc_ready());
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void safe_pkt_send (struct Desc* output_desc){
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->slot;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
	while(!data_desc_ready());
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline int read_timer () {
	volatile unsigned int * timer_32 = (volatile unsigned int *) TIMER_32;
	return (*timer_32); 
}

inline void reset_timer (){
	volatile unsigned char * rst_timer = (volatile unsigned char *) RESET_TIMER;
	*rst_timer = 1;
	return;
}

inline void reset_error (){
	volatile unsigned char * err_clear = (volatile unsigned char *) ERROR_CLEAR;
	*err_clear = 1;
	return;
}

// make dram_addr_high int* 
inline void dmem_write (const unsigned int dram_addr_high, const unsigned int dram_addr_low,
											  struct Desc* output_desc){ 
	volatile unsigned int  * dram_addr_wr   = (volatile unsigned int *)  DRAM_WR_ADDR;
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	* dram_addr_wr    = dram_addr_low;
	*(dram_addr_wr+1) = dram_addr_high;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->slot;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (4<<4);
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void safe_dmem_write (const unsigned int dram_addr_high, const unsigned int dram_addr_low,
														 struct Desc* output_desc){ 
	volatile unsigned int  * dram_addr_wr   = (volatile unsigned int *)  DRAM_WR_ADDR;
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	* dram_addr_wr    = dram_addr_low;
	*(dram_addr_wr+1) = dram_addr_high;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->slot;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (4<<4);
	while(!data_desc_ready());
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void dmem_read_req (const unsigned int dram_addr_high, const unsigned int dram_addr_low,
													 struct Desc* output_desc){ 
	volatile unsigned int  * dram_addr_wr   = (volatile unsigned int *)  DRAM_WR_ADDR;
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	* dram_addr_wr    = dram_addr_low;
	*(dram_addr_wr+1) = dram_addr_high;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->slot;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (5<<4);
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

inline void safe_dmem_read_req (const unsigned int dram_addr_high, const unsigned int dram_addr_low,
															  struct Desc* output_desc){ 
	volatile unsigned int  * dram_addr_wr   = (volatile unsigned int *)  DRAM_WR_ADDR;
  volatile unsigned int  * data_desc      = (volatile unsigned int *)  DATA_DESC;
  volatile unsigned char * data_desc_send = (volatile unsigned char *) DATA_DESC_SEND;
	* dram_addr_wr    = dram_addr_low;
	*(dram_addr_wr+1) = dram_addr_high;
	*data_desc = (int)(output_desc->len);
  *((unsigned char*)data_desc+2) = output_desc->slot;
  *((unsigned char*)data_desc+3) = output_desc->port;
  *(data_desc+1) = (unsigned int) (output_desc->data);
  *((unsigned char*)data_desc+7) = (5<<4);
	while(!data_desc_ready());
	asm volatile("" ::: "memory");
	* data_desc_send = 1;
	return;
}

#endif /* CORE_H */
