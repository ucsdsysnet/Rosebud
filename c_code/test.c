#include "core.h"

int main(void){

	// set_csr(mie, MIP_MEIP);
	// set_csr(mstatus, MSTATUS_MIE);
	
	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;

	struct Desc packet;
	unsigned int start_time, end_time;
	unsigned int setting_high, setting_low;
	int offset = 0; 
	
	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things. 
	init_slots(8, 0x200A, 2048);

	while (1){
		if (in_pkt_ready()){
	 		
			start_time = read_timer();
			read_in_pkt(&packet);
			packet.data = (unsigned int *)(((unsigned int)packet.data)+offset);
	
			if (packet.port==0){
				packet.port = 1;
				*sh_test += 1;
			} else {
				packet.port = 0;
				*(sh_test+1) += 1;
			}

		  safe_pkt_done_msg(&packet);
			safe_dram_write(0xAAAAAAAA, 0xBBBBBBBB, &packet);

	 		end_time = read_timer();
			write_setting (end_time, start_time);

  	}
  }
  
  return 1;
}

void exception(void){
	int cause = csr_read(mcause);
	if(cause < 0){ //interrupt
		switch(cause & 0xFF){
			case CAUSE_MACHINE_TIMER:{
				write_setting (0xDEADDEAD, 0xBEEFBEEF);
			} break;
			case CAUSE_MACHINE_EXT_INT: {
				write_setting (0x5A5A5A5A, 0xAAAA5555);
			} break;
			default: break;
		}
	} else { //exception
		write_setting (0xABABABAB, 0xCDCDCDCD);
	}
	reset_timer();
	csr_set(mstatus, MSTATUS_MIE);
	return;
};

