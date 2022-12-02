#include "core.h"

struct Desc packet;
unsigned int * pkt_data[16];

int main(void){

  int i;
  unsigned int pkt_num;
  volatile int k;

	// Do this at the beginnig, so load balancer can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x804000, 128);
	init_slots(8, 0x00000A, 16384);

	for (i=0;i<16;i++){
		pkt_data[i] = (unsigned int *)(0x01000000+i*16384);
    // MAC addresses
		pkt_data[i][0] = 0xABABABAB;
		pkt_data[i][1] = 0xCDCDABAB;
		pkt_data[i][2] = 0xCDCDCDCD;
    // optional field
		pkt_data[i][3] = 0x99809980;
		pkt_data[i][4] = 0x99809980;
	}

	pkt_num    = 0;
	packet.len = 256;
	packet.tag = 0;
	packet.port = 2;
	packet.data = (unsigned char *) pkt_data[0];

	// We expect (250000000/(1<<24))=14.9 packets per second, 
  // or slightly more since we don't check last 3 bits and rarely
  // two packets might be sent on the same higher 29 bits
  while (1){
    while (((read_timer_low())&0x00fffff8)!=0);
		pkt_send(&packet);
  }

  return 1;
}
