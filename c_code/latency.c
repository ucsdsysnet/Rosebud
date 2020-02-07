#include "core2.h"

struct Desc send_pkt;
struct Desc recv_pkt;
struct Desc summary_pkt;

unsigned int * pkt_data[8];
unsigned int * wr_ptr;
unsigned int * rd_ptr;
unsigned int count;

void int_handler(void) {safe_pkt_send(&summary_pkt);
			interrupt_ack(0x20);}

int main(void){

  int i;
  volatile int k;
  unsigned int recv_time;

	write_timer_interval(0x17D7840);
	// Use for full rate
	// if ((core_id()&0x1)!=0)
	// 	set_masks(0x20); //enable timer


	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x104000, 128);
	init_slots(8, 0x000000, 16384);

	for (i=0;i<8;i++){
		pkt_data[i] = (unsigned int *)((8+i)*16384);
	}

	send_pkt.len = 9000;
	send_pkt.tag = 0;
	send_pkt.port = 0;

        summary_pkt.len=1500;
	summary_pkt.port=2;
	summary_pkt.tag=0;
        summary_pkt.data=((unsigned char*) 0x80200);

	rd_ptr = (unsigned int *) 0x80000;
	wr_ptr = (unsigned int *) 0x80000;

	i = 0;

	if ((core_id()&0x1)==0){
		while (1){
    			for (k=0;k<10000;k++);
			send_pkt.data = (unsigned char *) pkt_data[i];
    			pkt_data[i][0] = read_timer_low();
    			safe_pkt_send(&send_pkt);
    			i++;
    			if (i==8)
    				i=0;
		}
	} else {
		while (1) {
			if (in_pkt_ready()){
				recv_time = read_timer_low();
				read_in_pkt(&recv_pkt);
				if (recv_pkt.port!=2){
					// Write send and recv time into memory and update the pointer
					*wr_ptr = recv_time - (*((unsigned int *)recv_pkt.data)); 
					wr_ptr+=1;
					if (wr_ptr == (unsigned int *)0x100000)
						wr_ptr = (unsigned int *) 0x80000;
					
					// Use for slow rate
					count+=4;
					if (count==1500){
						summary_pkt.data=(unsigned char*) rd_ptr;
						safe_pkt_send(&summary_pkt);
						count = 0; 
						rd_ptr = wr_ptr;

					}
				}
				// Drop the packet
				recv_pkt.len=0;
				safe_pkt_done_msg (&recv_pkt); 
			}
		}
	}

  return 1;
}
