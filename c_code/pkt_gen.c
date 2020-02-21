#include "core.h"

struct Desc packet;
unsigned int * pkt_data[16];

int main(void){

  int i;
  unsigned int pkt_num;

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x804000, 128);
	init_slots(8, 0x00000A, 16384);

	for (i=0;i<16;i++){
		pkt_data[i] = (unsigned int *)(0x01000000+i*16384);
		pkt_data[i][0] = core_id();
	}

	pkt_num    = 0;
	packet.len = 64;
	packet.tag = 0;
	if ((core_id()&0x4)!=0)
		packet.port = 1;
	else
		packet.port = 0;

	while (1){
		for (i=0;i<16;i++) {
			pkt_data[i][1] = pkt_num;
			packet.data = (unsigned char *) pkt_data[i];
			safe_pkt_send(&packet);
			pkt_num++;
		} 
	}

  return 1;
}
