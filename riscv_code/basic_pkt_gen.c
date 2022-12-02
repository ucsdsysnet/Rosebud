#include "core.h"

struct Desc packet;
unsigned int * pkt_data[16];

int main(void){

  int i;
  unsigned int pkt_num;
  volatile int k;

  // Do this at the beginnig, so load balancer can fill the slots while 
  // initializing other things.
  init_hdr_slots(16, 0x804000, 128);
  init_slots(16, 0x00000A, 16384);
  set_masks(0x30); // Enable only Evict + Poke

  for (i=0;i<16;i++){
    pkt_data[i] = (unsigned int *)(0x01000000+i*16384);
    pkt_data[i][0] = core_id();
  }

  pkt_num    = 0;
  packet.len = 4096;
  packet.tag = 0;
  if ((core_id()&0x4)!=0)
    packet.port = 1;
  else
    packet.port = 0;

  while (1){
    for (i=0;i<16;i++) {
      // for (k=0; k<10000; k++);
      // For max performance with unimportant data, comment out the next 2 lines
      pkt_data[i][1] = pkt_num;
      packet.data = (unsigned char *) pkt_data[i];
      pkt_send(&packet);
      pkt_num++;
    } 
  }

  return 1;
}
