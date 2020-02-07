#include "core2.h"
struct Desc packet;
unsigned int start_time, end_time;
volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;

#define ACC_REGEX_CTRL (*((volatile unsigned int *)(IO_START_EXT + 0x0000)))
#define ACC_REGEX_LEN (*((volatile unsigned int *)(IO_START_EXT + 0x0004)))
#define ACC_REGEX_START (*((volatile unsigned int *)(IO_START_EXT + 0x0008)))

int main(void){

	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors 

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x104000, 128);
	init_slots(8, 0x00000A, 16384);
	
	while (1){
		if (in_pkt_ready()){
	 		
			read_in_pkt(&packet);

			// start regex parsing
			ACC_REGEX_START = packet.data+14;
			ACC_REGEX_LEN = 64;
			ACC_REGEX_CTRL = 1;

			// // wait for accelerator operation to complete
			// need some delay here...
			// while (!(ACC_REGEX_CTRL & 0x0100)) {};

			// swap port
			if (packet.port==0)
				packet.port = 1;
			else
				packet.port = 0;

			// wait for accelerator operation to complete
			while (!(ACC_REGEX_CTRL & 0x0100)) {};

			// check for match
			if (ACC_REGEX_CTRL & 0x0200)
			{
				// drop packet
				packet.len = 0;
			}
			
			safe_pkt_done_msg(&packet);
  	}
  }
  
  return 1;
}
