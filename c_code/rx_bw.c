#include "core2.h"

struct Desc packet;
struct Desc recv_pkt;
unsigned int * pkt_data[16];

int main(void){

  int i;
  unsigned int pkt_num;
  volatile int k;

	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors 

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(5, 0x104000, 128);
	init_slots(5, 0x00000A, 16384);

	for (i=0;i<16;i++){
		pkt_data[i] = (unsigned int *)(0+i*16384);
		pkt_data[i][0] = core_id();
		pkt_data[i][2] = 0xdeadbeef;
		pkt_data[i][3] = 0xdeadbeef;
		pkt_data[i][4] = 0xdeadbeef;
	}

	pkt_num    = 0;
	packet.len = 9000;
	packet.tag = 0;
	packet.port = 0;

	if (core_id()<8) {
		while (1){
			for (i=0;i<16;i++) {
				for(k=0;k<250;k++);
				pkt_data[i][1] = pkt_num;
				packet.data = (unsigned char *) pkt_data[i];
				safe_pkt_send(&packet);
				pkt_num++;
			} 
		}
	} else {
		while (1) {
			if (in_pkt_ready()){
				// Drop the packet
				read_in_pkt(&recv_pkt);
				recv_pkt.len=0;
				safe_pkt_done_msg (&recv_pkt); 
			}
		}

	}


  return 1;
}
