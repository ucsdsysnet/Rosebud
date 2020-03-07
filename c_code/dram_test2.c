#include "core.h"
	
struct Desc packet;

int main(void){

	unsigned long long dram_rd_addr = 0x000000000000BBBB;
	unsigned long long dram_wr_addr = 0x000000000000BCBB;
  volatile unsigned int * test_pmem = (volatile unsigned int *) 0x1001000;
  int i;

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x804000, 128);
	init_slots(8, 0x00000A, 16384);
	
	packet.len  = 69;
	packet.tag  = 12;
	packet.data = (unsigned char*)0x800020;
	dram_read_req(&dram_rd_addr, &packet);

	while (dram_flags()==0);
	write_dram_flags(0);

	packet.len  = 69;
	packet.tag  = 12;
	packet.data = (unsigned char*)0x800020;
	dram_write(&dram_wr_addr, &packet);
  
  * test_pmem = 0x12345678;
  
  DEBUG_OUT_L = * test_pmem;
  DEBUG_OUT_H = 0xABCDDCBA;

  for (i=0x806000;i<0x806100;i+=4)
    * ((volatile unsigned int *)i) = 0xdeadbeef;

	while (1){
		if (in_pkt_ready()){
	 		
			read_in_pkt(&packet);

			if (packet.port==0){
				packet.port = 1;
			} else {
				packet.port = 0;
			}
			pkt_send(&packet);
			// pkt_done_msg(&packet);
  	}
    // DEBUG_OUT_L = DEBUG_IN_L;
    // DEBUG_OUT_H = DEBUG_IN_H;
  }
  
  return 1;
}
