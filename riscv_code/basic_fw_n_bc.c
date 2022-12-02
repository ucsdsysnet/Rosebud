#include "core.h"

struct Desc packet;
unsigned int* bc_addr;
unsigned int i;
volatile int k;

int main(void){

  // Do this at the beginnig, so load balancer can fill the slots while
  // initializing other things.
  init_hdr_slots(16, 0x804000, 128);
  init_slots(16, 0x000000, 16384);

  bc_addr = (int*) (0x00800000  + DMEM_SIZE - BC_REGION_SIZE);
  i = 23;
  set_bc_filter (0xF0,0x10);

  while (1){
    if (in_pkt_ready()){
      SEND_DESC = RECV_DESC;
      asm volatile("" ::: "memory");
      RECV_DESC_RELEASE = 1;
      asm volatile("" ::: "memory");
      SEND_DESC_TYPE = 0;
    }

    *bc_addr = i;
    bc_addr += 4;
    i+=5;
    for (k=0;k<10;k++);

  }

  return 1;
}
