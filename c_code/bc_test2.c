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
        
  summary_pkt.len=1496;
  summary_pkt.port=2;
  summary_pkt.tag=0;
  summary_pkt.data=(unsigned char*) 0x1083498;

  while(1){
    temp = * bc_read;
    temp2 = read_timer_low();
    * bc_write = temp2; 
    * wr_ptr = temp;
    * (wr_ptr+1) = temp2;

    count+=8;
    wr_ptr+=2;

    // Sending 1 in 10 packets
    if (count==14960){
      pkt_send(&summary_pkt);
      count = 0; 
      wr_ptr = (unsigned int *) 0x1080000;
    }
  }
  
  return 1;
}
