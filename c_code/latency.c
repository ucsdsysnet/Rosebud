#include "core2.h"

#define two_ports 1

struct Desc send_pkt;
struct Desc recv_pkt;
unsigned int * pkt_data[8];
unsigned int * wr_ptr;

int main(void){

  int i;
  int k;
  unsigned int recv_time;

	write_timer_interval(0x00000200);
	set_masks(0x1F); //enable just errors 

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_hdr_slots(8, 0x104000, 128);
	init_slots(8, 0x000000, 16384);

	for (i=0;i<8;i++){
		pkt_data[i] = (unsigned int *)((8+i)*16384);
	}

	send_pkt.len = 2048;
	send_pkt.tag = 0;

	if (two_ports==1)
		if ((core_id() & 0x4)==0)
			send_pkt.port = 0;
		else
			send_pkt.port = 1;
	else
		send_pkt.port = 0;
	
	wr_ptr = (unsigned int *) 0x80000;
	i = 0;

	if (core_id()<8){
		while (1){

    		send_pkt.data = (unsigned char *) pkt_data[i];
    		pkt_data[i][0] = read_timer_low();
    		safe_pkt_send(&send_pkt);
    		i++;
    		if (i==8)
    			i=0;
		}
	} else {
		while (1){ 
			if (in_pkt_ready()){
				recv_time = read_timer_low();
				read_in_pkt(&recv_pkt);
				// 
				// Write send and recv time into memory and update the pointer
				*wr_ptr = recv_time - (*((unsigned int *)recv_pkt.data)); 
				wr_ptr+=1;
				if (wr_ptr == (unsigned int *)0x100000)
					wr_ptr = (unsigned int *) 0x80000;

				// Drop the packet
				recv_pkt.len=0;
				safe_pkt_done_msg (&recv_pkt); 
			}
		}
	}

  return 1;
}
