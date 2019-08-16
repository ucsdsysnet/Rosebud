#include "core.h"

int main(void){

	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;

  // unsigned int* data;
  // unsigned short len;
  // unsigned char port;
  // unsigned char slot;
	struct Desc packet;
	unsigned int start_time, end_time;
	unsigned int setting_high, setting_low;
	int offset; 
	
	init_slots(8, 0x200A, 2048);

	while (1){
		if (in_pkt_ready()){
	 		
			start_time = read_timer();
			read_in_pkt(&packet); // &len, &slot, &port, &data);
			offset = 0;
	
			if (packet.port==0){
				packet.port = 1;
				*sh_test += 1;
			} else {
				packet.port = 0;
				*(sh_test+1) += 1;
			}

			packet.data = (unsigned int *)(((unsigned int)packet.data)+offset);
		  // safe_pkt_send(&len, &slot, &port, data);
		  safe_pkt_done_msg(&packet); // &len, &slot, &port, data);
			
			safe_dmem_write(0xAAAAAAAA, 0xBBBBBBBB, &packet);
			dmem_read_req(0x50505050, 0x05050505, &packet);

	 		end_time = read_timer();
			write_setting (0, end_time-start_time);

  	}
  }
  
  return 1;
}

