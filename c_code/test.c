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
			
	// packet.len  = 69;
	// packet.tag  = 12;
	// packet.data = (unsigned int*)0x220;
	// safe_dram_read_req(0x0, 0x0000BBBB, &packet);

	while (1){
		if (in_pkt_ready()){
	 		
			start_time = read_timer_low();
			read_in_pkt(&packet);

			// if (packet.port==0){
			// 	packet.port = 1;
			// 	*sh_test += 1;
			// } else {
			// 	packet.port = 0;
			// 	*(sh_test+1) += 1;
			// }
			// safe_pkt_send(&packet);

			if (packet.port<2){
				packet.data = (unsigned int *)(((unsigned int)packet.data)-2);
				*(unsigned short *)(packet.data) = (unsigned short)(packet.port);
				packet.len += 2;
			}
			
			if (core_id()==15){

				if (*(unsigned short*)(packet.data)==0){
					packet.port = 1;
				} else {
					packet.port = 0;
				}
				packet.data = (unsigned int *)(((unsigned int)packet.data)+2);
				packet.len -= 2;
				safe_pkt_send(&packet);
			
			} else {

				packet.port = (char)(core_id()+1);
				safe_send_to_core(&packet);
			
			}

			// safe_dram_write(0xAAAAAAAA, 0xBBBBBBBB, &packet);

	 		end_time = read_timer_low();
			write_debug (end_time - start_time);

  	}
  }
  
  return 1;
}
