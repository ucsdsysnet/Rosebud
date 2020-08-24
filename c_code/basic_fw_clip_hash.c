#include "core.h"
struct Desc packet;

int main(void){

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x804000, 128);
	init_slots(8, 0x000000, 16384);
	
	while (1){
		if (in_pkt_ready()){
			read_in_pkt(&packet);
      
      packet.data = packet.data+4;
      packet.len  = packet.len-4;
			
      pkt_send(&packet);
  	}
  }
  
  return 1;
}
