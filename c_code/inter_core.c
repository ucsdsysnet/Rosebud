#include "core.h"

int main(void){

	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;

	struct Desc packet;
	unsigned int start_time, end_time;
	int offset = 0; 
	int id=core_id();

	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(4, 0x5C00, 128);
	init_slots(8, 0x000A, 2048);

	while (1){
		if (in_pkt_ready()){
	 		
			read_in_pkt(&packet);

			if (packet.port<2){
				packet.data = (unsigned char *)(((unsigned int)packet.data)-4);
				*(unsigned short *)(packet.data) = (unsigned short)(packet.port);
				*((unsigned short *)(packet.data)+1) = 1;
				packet.len += 4;
				packet.port = (char)(id+4); 
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
					packet.data = (unsigned char *)(((unsigned int)packet.data)+4);
					packet.len -= 4;
					safe_pkt_send(&packet);
				} else {
					packet.port = (char)(id+4);
					safe_send_to_core(&packet);
				}
			}
  	}
  }
  
  return 1;
}
