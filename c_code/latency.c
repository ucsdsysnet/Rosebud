#include "core.h"

struct Desc send_pkt;
struct Desc recv_pkt;
struct Desc summary_pkt;

unsigned int * pkt_data[8];
unsigned int * wr_ptr;
unsigned int count;

#define congestion 1

void __attribute__((interrupt)) int_handler(void) {
  safe_pkt_send(&summary_pkt);
  // Update for next time if new data doesn't roll back
  summary_pkt.data=((unsigned char*) wr_ptr);
  interrupt_ack(0x01);
}

int main(void){

  int i;
  volatile int k;
  unsigned int recv_time;

  // Do this at the beginnig, so scheduler can fill the slots while 
  // initializing other things.
  init_hdr_slots(8, 0x804000, 128);
  init_slots(8, 0x1000000, 16384);

  for (i=0;i<8;i++){
    pkt_data[i] = (unsigned int *)(0x01000000+(i*16384));
  }

  send_pkt.len = 64;
  send_pkt.tag = 0;
  // Half of the cores send, so one port is enough
  send_pkt.port = 0;

  summary_pkt.len=128;
  summary_pkt.port=2;
  summary_pkt.tag=0;

  wr_ptr = (unsigned int *) 0x1080000;
  summary_pkt.data=((unsigned char*) wr_ptr);

  i = 0;
  count = 0;
  
  // Setting timer interval to 100ms, and enable it for odd cores
  write_timer_interval(0x17D7840);
  if (congestion==1)
    if ((core_id()&0x1)!=0)
      set_masks(0x04); //enable only timer

  if ((core_id()&0x1)==0){
    while (1){
      if (congestion==0)
          for (k=0;k<1000;k++);
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
          if (wr_ptr == (unsigned int *) 0x10F0000)
            wr_ptr = (unsigned int *) 0x1080000;
          
          if (congestion==0){
            count+=4;
            if (count==1500){
              safe_pkt_send(&summary_pkt);
              count = 0; 
              wr_ptr = (unsigned int *) 0x1080000;
            }
          }
        }
        // Drop the packet
        recv_pkt.len=0;
        // Since we have interrupts we need atomic version of it.
        atomic_safe_pkt_done_msg (&recv_pkt); 
      }
    }
  }

  return 1;
}
