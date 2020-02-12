#include "core2.h"

struct Desc packet;

int main(void){

	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors 

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x804000, 128);
	init_slots(8, 0x00000A, 16384);
	
	while (1){
		if (in_pkt_ready()){
			read_in_pkt(&packet);
			safe_pkt_send(&packet);
  	}
  }
  
  return 1;
}
