#include "core.h"

#define SEND_LEN (*((volatile short *)(IO_INT_BASE + 0x0008)))

struct Desc recv_pkt;

int main(void){

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(16, 0x804000, 128);
	init_slots(16, 0x1000000, 16384);

		while (1) {
			if (in_pkt_ready()){
	    SEND_DESC = RECV_DESC;
	    asm volatile("" ::: "memory");
	    RECV_DESC_RELEASE = 1;
      SEND_LEN = 0;
	    asm volatile("" ::: "memory");
	    SEND_DESC_TYPE = 0;
				
        // Drop the packet
				// read_in_pkt(&recv_pkt);
				// recv_pkt.len=0;
				// pkt_send (&recv_pkt); 
			}
    }

  return 1;
}
