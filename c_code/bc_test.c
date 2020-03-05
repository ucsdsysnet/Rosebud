#include "core.h"

volatile unsigned int * bc_read;
volatile unsigned int * bc_write;
unsigned int * wr_ptr;
struct Desc summary_pkt;

int main(void){
	volatile int k;
	int count = 0;
	int temp, temp2;
	int i, time;

	init_hdr_slots(8, 0x804000, 128);
	init_slots(8, 0x1000000, 16384);

	bc_read = (volatile unsigned int *)(0x806000+(core_id()<<2));
	if (core_id()==15)
		bc_write = (volatile unsigned int *)(0x806000);
	else
		bc_write = (volatile unsigned int *)(0x806000+((core_id()+1)<<2));
	wr_ptr = (unsigned int *) 0x1080000;
        
	summary_pkt.len=1500;
	summary_pkt.port=2;
	summary_pkt.tag=0;
        summary_pkt.data=((unsigned char*) wr_ptr);

	if (core_id()==0){
		while (1){
			// for(k=0;k<20;k++);
			// while(!core_msg_ready());
			* bc_write = read_timer_low();
		}
	} else {
		while(1){
			temp = * bc_read;
			while (1){
			  time  = read_timer_low();
        temp2 = *bc_read;
        if (temp!=temp2) break;
      }

			* wr_ptr = time - temp2;
			// while(!core_msg_ready());
			* bc_write = read_timer_low();

			count++;
			wr_ptr++;
			if (count==1500){
				safe_pkt_send(&summary_pkt);
				count = 0; 
				wr_ptr = (unsigned int *) 0x1080000;
			}
		}
	}
  
  return 1;
}
