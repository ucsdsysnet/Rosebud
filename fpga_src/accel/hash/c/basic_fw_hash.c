#include "core2.h"
struct Desc packet;
unsigned int start_time, end_time;
volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;

#define ACC_HASH_CTRL  (*((volatile unsigned int *)(IO_START_EXT + 0x0000)))
#define ACC_HASH_BYTE  (*((volatile unsigned int *)(IO_START_EXT + 0x0004)))
#define ACC_HASH_WORD  (*((volatile unsigned int *)(IO_START_EXT + 0x0008)))
#define ACC_HASH_DWORD (*((volatile unsigned int *)(IO_START_EXT + 0x000C)))

int main(void){

	long int hash;

	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors 

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x104000, 128);
	init_slots(8, 0x00000A, 16384);

	ACC_HASH_CTRL = 0;
	ACC_HASH_DWORD = 0xbb950942;
	ACC_HASH_DWORD = 0x50648ea1;
	ACC_HASH_WORD = 0xea0a;
	ACC_HASH_WORD = 0xe606;
	hash = ACC_HASH_CTRL;
	hash = ACC_HASH_CTRL;
	hash = ACC_HASH_CTRL;

	while (1){
		if (in_pkt_ready()){
	 		
			read_in_pkt(&packet);

			// parse header and compute flow hash
			// check eth type
			if (*((unsigned short *)(packet.data+12)) == 0x0008)
			{
				// IPv4 packet
				ACC_HASH_CTRL = 0;
				// IPv4 addresses
				ACC_HASH_DWORD = *((unsigned long *)(packet.data+26));
				ACC_HASH_DWORD = *((unsigned long *)(packet.data+30));

				// check IHL and protocol
				if (packet.data[14] == 0x45 && (packet.data[23] == 0x06 || packet.data[23] == 0x11))
				{
					// TCP or UDP ports
					ACC_HASH_DWORD = *((unsigned long *)(packet.data+34));
				}

				hash = ACC_HASH_CTRL;
				hash = ACC_HASH_CTRL;
				hash = ACC_HASH_CTRL;
			}


			// swap port
			if (packet.port==0)
				packet.port = 1;
			else
				packet.port = 0;
			
			safe_pkt_done_msg(&packet);
  	}
  }
  
  return 1;
}
