#include "core.h"
struct Desc packet;

int main(void){

  int fw_port;

  // Do this at the beginnig, so scheduler can fill the slots while
  // initializing other things.
  init_hdr_slots(16, 0x804000, 128);
  init_slots(16, 0x00000A, 16384);
  set_masks(0x30); // Enable only Evict + Poke

  if ((core_id()&0x4)!=0){
    fw_port = 1;
  } else {
    fw_port = 0;
  }

  while (1){
    if (in_pkt_ready()){

      read_in_pkt(&packet);

      if (packet.port==2)
        packet.port = fw_port;
      else
        packet.len = 0;

      pkt_done_msg(&packet);
    }
  }

  return 1;
}
