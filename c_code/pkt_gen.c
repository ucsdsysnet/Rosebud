#include "core2.h"

int main(void){

	struct Desc packet;
	unsigned int pkt_num;
	unsigned int * pkt_data[16];
	int i;

	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors 

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x104000, 128);
	init_slots(8, 0x00000A, 16384);

  for (i=0;i<16;i++){
		pkt_data[i] = (unsigned int *)(0+i*16384);
		pkt_data[i][0] = core_id();
	}

	pkt_num = 0;

	packet.len  = 1024;
	packet.tag  = 0;

	while (1){
    for (i=0;i<16;i++) {
			pkt_data[i][1] = pkt_num;
		  packet.port = i & 0x1;
			packet.data = (unsigned char *) pkt_data[i];
		  safe_pkt_send(&packet);
			pkt_num++;
	  } 
  }
  
  return 1;
}
