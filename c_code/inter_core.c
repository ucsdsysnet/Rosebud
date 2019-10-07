#include "core.h"

int main(void){

	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;

	struct Desc packet;
	unsigned int start_time, end_time;
	int offset = 0; 
	
	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_slots(8, 0x200A, 2048);
			
	while (1){
		if (in_pkt_ready()){
	 		
			read_in_pkt(&packet);

			if (packet.port<2){
				packet.data = (unsigned int *)(((unsigned int)packet.data)-4);
				*(unsigned short *)(packet.data) = (unsigned short)(packet.port);
				*((unsigned short *)(packet.data)+1) = 1;
				packet.len += 4;
				packet.port = (char)(core_id()+4); // there are 16 cores, system would cut overflow
				safe_send_to_core(&packet);
			}
			else {
				*((unsigned short *)(packet.data)+1) += 1;
				if ((*((unsigned short *)(packet.data)+1))==4){
					if (*(unsigned short*)(packet.data)==0){
						packet.port = 1;
					} else {
						packet.port = 0;
					}
					packet.data = (unsigned int *)(((unsigned int)packet.data)+4);
					packet.len -= 4;
					safe_pkt_send(&packet);
				} else {
					packet.port = (char)(core_id()+4); // there are 16 cores, system would cut overflow
					safe_send_to_core(&packet);
				}
			}
  	}
  }
  
  return 1;
}
