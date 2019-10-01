#include "core.h"

int main(void){

	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;

	struct Desc packet;
	unsigned int start_time, end_time;
	int offset = 0; 
	
	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable all, these masks occur before riscv masks

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_slots(8, 0x200A, 2048);
			
	packet.len  = 69;
	packet.tag  = 12;
	packet.data = (unsigned int*)0x220;
	safe_dram_read_req(0x0, 0x0000BBBB, &packet);

	while (1){
		if (in_pkt_ready()){
	 		
			start_time = read_timer_low();
			read_in_pkt(&packet);
			packet.data = (unsigned int *)(((unsigned int)packet.data)+offset);
	
			// if (packet.port==0)
			//  	packet.port = 2;
			// else if (packet.port==2)
			//  	packet.port = 0;
			// else if (packet.port==1)
			//  	packet.port = 3;
			// else if (packet.port==3)
			//  	packet.port = 1;

			if (packet.port==0){
				packet.port = 1;
				*sh_test += 1;
			} else {
				packet.port = 0;
				*(sh_test+1) += 1;
			}

		  safe_pkt_done_msg(&packet);
			// safe_dram_write(0xAAAAAAAA, 0xBBBBBBBB, &packet);

	 		end_time = read_timer_low();
			write_debug (end_time - start_time);

  	}
  }
  
  return 1;
}
