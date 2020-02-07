#include "core2.h"

struct Desc recv_pkt;

int main(void){

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x104000, 128);
	init_slots(8, 0x000000, 16384);

	if (core_id()==0)
		while (1) {
			if (in_pkt_ready()){
				// Drop the packet
				read_in_pkt(&recv_pkt);
				safe_pkt_send(&recv_pkt); 
			}
		}
	else
		while (1) {
			if (in_pkt_ready()){
				// Drop the packet
				read_in_pkt(&recv_pkt);
				recv_pkt.len=0;
				safe_pkt_done_msg (&recv_pkt); 
			}
		}

  return 1;
}
