#include "core.h"
struct Desc packet;

int main(void){
  // Do this at the beginnig, so load balancer can fill the slots while
  // initializing other things.
  init_hdr_slots(16, 0x804000, 128);
  init_slots(16, 0x00000A, 16384);
  set_masks(0x30); // Enable only Evict + Poke

  while (1){
    if (in_pkt_ready()){

      read_in_pkt(&packet);

      if (packet.port==2)
        packet.port = 0;
      else
        packet.port = 2;

      pkt_done_msg(&packet);
    }
  }

  return 1;
}
