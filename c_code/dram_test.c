#include "core.h"

int main(void){

	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;

	struct Desc packet;
	unsigned int start_time, end_time;
	
	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors 

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_slots(8, 0x200A, 2048);
	
	packet.len  = 69;
	packet.tag  = 12;
	packet.data = (unsigned int*)0x220;
	safe_dram_read_req(0x0, 0x0000BBBB, &packet);

	while (dram_flags()==0);
	write_dram_flags(0);

	packet.len  = 69;
	packet.tag  = 12;
	packet.data = (unsigned int*)0x220;
	safe_dram_write(0x0, 0x0000BCBB, &packet);

	while (1){
		if (in_pkt_ready()){
	 		
			start_time = read_timer_low();
			read_in_pkt(&packet);

			if (packet.port==0){
				packet.port = 1;
				*sh_test += 1;
			} else {
				packet.port = 0;
				*(sh_test+1) += 1;
			}
			safe_pkt_done_msg(&packet);

	 		end_time = read_timer_low();
			write_debug (end_time - start_time);

  	}
  }
  
  return 1;
}
