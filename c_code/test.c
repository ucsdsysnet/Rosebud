#include "core.h"

int main(void){

	
	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;

	struct Desc packet;
	unsigned int start_time, end_time;
	unsigned int setting_high, setting_low;
	int offset; 
	
	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things. 
	init_slots(8, 0x200A, 2048);

	struct Desc info;
	unsigned char mac_header_0 [14] = {0x5A,0x51,0x52,0x53,0x54,0x55, 
															       0xDA,0xD1,0xD2,0xD3,0xD4,0xD5, 
															       0x80,0x00};

	unsigned char mac_header_1 [14] = {0xDA,0xD1,0xD2,0xD3,0xD4,0xD5, 
															       0x5A,0x51,0x52,0x53,0x54,0x55, 
															       0x80,0x00};

	unsigned char dummy_data_0 [64+14]; 
	unsigned char dummy_data_1 [64+14]; 
	for (int i=0; i<14; i++){
		dummy_data_0[i] = mac_header_1[i];
		dummy_data_1[i] = mac_header_0[i];
	}
	for (int i=14; i<(64+14); i++){
		dummy_data_0[i] = 64-(i-14);
		dummy_data_1[i] = 64-(i-14);
	}
	
	info.len=64+14;
	info.slot=0;
	
	while (1){
		if (in_pkt_ready()){
	 		
			start_time = read_timer();
			read_in_pkt(&packet);
			offset = 0;
	
			if (packet.port==0){
				packet.port = 1;
				info.port = 0;
				info.data=(unsigned int *)&dummy_data_0;
				*sh_test += 1;
			} else {
				packet.port = 0;
				info.port = 1;
				info.data=(unsigned int *)&dummy_data_1;
				*(sh_test+1) += 1;
			}

			packet.data = (unsigned int *)(((unsigned int)packet.data)+offset);

		  safe_pkt_done_msg(&packet);
		  safe_pkt_send(&info); 
			safe_dram_write(0xAAAAAAAA, 0xBBBBBBBB, &packet);

	 		end_time = read_timer();
			write_setting (0, end_time-start_time);

  	}
  }
  
  return 1;
}

