#include "core.h"

#define HASH_SCHED
struct Desc packet;

#ifdef HASH_SCHED
  #define DATA_OFFSET 4
#else
  #define DATA_OFFSET 0
#endif

int main(void){

  // Do this at the beginnig, so scheduler can fill the slots while
  // initializing other things.
  init_hdr_slots(16, 0x804000, 128);
  init_slots(16, 0x000000, 16384);
  set_masks(0x30); // Enable only Evict + Poke

  DEBUG_OUT_L = 0x12345678;
  DEBUG_OUT_H = 0xABCDEFAB;

  while (1){
    if (in_pkt_ready()){
      SEND_DESC = RECV_DESC;
      if (DATA_OFFSET) {
        SEND_DESC.len  = RECV_DESC.len  - 4;
        SEND_DESC.data = RECV_DESC.data + 4;
      }
      asm volatile("" ::: "memory");
      RECV_DESC_RELEASE = 1;
      asm volatile("" ::: "memory");
      SEND_DESC_TYPE = 0;
    }
  }

  return 1;
}
