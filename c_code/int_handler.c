#include "core.h"

void int_handler(void) {
	int cause = read_csr(mcause);
	char int_flag = interrupt_flags();
	if(cause < 0){ //interrupt
		if(cause & IRQ_M_TIMER){
			interrupt_ack(0x20); 
		}
		if (cause & IRQ_M_EXT) {
			if (int_flag & 0x80) { // incoming_pkt_interrupt
			
			// Drop example
			struct Desc packet;
			read_in_pkt(&packet);
			packet.len=0;
			safe_pkt_done_msg(&packet);

			} else if (int_flag & 0x40) { // dram_interrupt
				write_debug (dram_flags());
				write_dram_flags(0x00000000);
			} else { // ext mem address error
				interrupt_ack(0x10); 
			}
		}
	} else { //exception,
			if (int_flag & 0x01) { // ins mem addr err
				// write_debug (0xBEEF0000);
				interrupt_ack(0x01); 
			} else if (int_flag & 0x02) { // data mem addr err
				// write_debug (0xBEEF1111);
				interrupt_ack(0x02); 
			} else if (int_flag & 0x04) { // io addr err
				// write_debug (0xBEEF2222);
				interrupt_ack(0x04); 
			} else if (int_flag & 0x08) { // io byte err
				// write_debug (0xBEEF3333);
				interrupt_ack(0x08); 
			}
	}
};

