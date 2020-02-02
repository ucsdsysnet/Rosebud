#include "core.h"

void int_handler(void) {
	int cause = read_csr(mcause);
	char int_flag = interrupt_flags();
	if(cause < 0){ //interrupt
		if(cause & IRQ_M_TIMER){
			// write_debug (0xDEADDEAD);
			interrupt_ack(0x20); 
		}
		if (cause & IRQ_M_EXT) {
			if (int_flag & 0x80) { // incoming_pkt_interrupt
			
			// unsigned int start_time, end_time;
			struct Desc packet;

			// start_time = read_timer_low();
			read_in_pkt(&packet);
			if (packet.port==0)
				packet.port = 2;
			else if (packet.port==1)
				packet.port = 3;
			else if (packet.port==2)
				packet.port = 0;
			else
				packet.port = 1;

			safe_pkt_done_msg(&packet);
	 		// end_time = read_timer_low();
			// write_debug (end_time - start_time);

			} else if (int_flag & 0x40) { // dram_interrupt
				// write_debug (dram_flags());
				write_dram_flags(0x00000000);
			} else { // ext mem address error
				// write_debug (0x3B3B3B3B);
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

