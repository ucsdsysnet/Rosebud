#include "core.h"

void int_handler(void) {
	int cause = read_csr(mcause);
	if(cause < 0){ //interrupt
	  char int_flag = interrupt_flags();
		if(cause & IRQ_M_TIMER){
			interrupt_ack(0x01); 
		}
		if (cause & IRQ_M_EXT) {
			if (int_flag & 0x01) { // incoming packet interrupt
			
			// Drop example
			struct Desc packet;
			read_in_pkt(&packet);
			packet.len=0;
			safe_pkt_done_msg(&packet);

			} else if (int_flag & 0x02) { // dram interrupt
				write_debug (dram_flags());
				write_dram_flags(0x00000000);
			} else if (int_flag & 0x08){ // poke interrupt
				interrupt_ack(0x02); 
			} else if (int_flag & 0x10){ // evict interrupt
				interrupt_ack(0x04); 
			} else if (int_flag & 0x10){ // external io error interrupt
				interrupt_ack(0x08); 
			}
		}
	} else { //exception
	    char err_flag = error_flags();

			if (err_flag & 0x01) { // imem addr err
				interrupt_ack(0x10); 
			} else if (err_flag & 0x02) { // dmem addr err
				interrupt_ack(0x20); 
			} else if (err_flag & 0x04) { // pmem addr err
				interrupt_ack(0x40); 
			} else if (err_flag & 0x08) { // internal io addr err
				interrupt_ack(0x80); 
			} 
	}
};

