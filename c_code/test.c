#include "core.h"

int main(void){

	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;

  unsigned int* data;
  unsigned short len;
  unsigned char port;
  unsigned char slot;
	unsigned int start_time, end_time;
	unsigned int setting_high, setting_low;
	int offset; 
	
	init_slots(8, 0x200A, 2048);

	while (1){
		if (in_pkt_ready()){
	 		
			start_time = read_timer();
			read_in_pkt(&len, &slot, &port, &data);
			offset = 0;
	
			if (port==0){
				port = 1;
				*sh_test += 1;
			} else {
				port = 0;
				*(sh_test+1) += 1;
			}

			data = (unsigned int *)(((unsigned int)data)+offset);
		  // safe_pkt_send(&len, &slot, &port, data);
		  safe_pkt_done_msg(&len, &slot, &port, data);
			
			safe_dmem_write(0xAAAAAAAA, 0xBBBBBBBB, &len, &slot, &port, data);
			dmem_read_req(0x50505050, 0x05050505, &len, &slot, &port, data);

	 		end_time = read_timer();
			write_setting (0, end_time-start_time);

  	}
  }
  
  return 1;
}

