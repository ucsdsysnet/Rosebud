#include "core.h"

struct Desc packet;

int main(void){

  // Do this at the beginnig, so scheduler can fill the slots while
  // initializing other things.
  init_hdr_slots(16, 0x804000, 128);
  init_slots(16, 0x000000, 16384);
  set_masks(0x00);

  DEBUG_OUT_L = 0x12345678;
  DEBUG_OUT_H = 0xABCDEFAB;

  while (1){
    if (in_pkt_ready()){
      SEND_DESC = RECV_DESC;
      asm volatile("" ::: "memory");
      RECV_DESC_RELEASE = 1;
      asm volatile("" ::: "memory");
      SEND_DESC_TYPE = 0;
    }
  }

  return 1;
}
