#include "core.h"

struct Desc packet;

int main(void){

  // Do this at the beginnig, so scheduler can fill the slots while
  // initializing other things.
  init_hdr_slots(8, 0x804000, 128);
  init_slots(8, 0x000000, 16384);
  DEBUG_OUT_L = 0;
  DEBUG_OUT_H = 0;

  while (1){
    if (in_pkt_ready()){

      read_in_pkt(&packet);

      if ((packet.len!=66)&&(packet.len!=1500))
        DEBUG_OUT_L= packet.len;

      pkt_done_msg(&packet);
    }
  }

  return 1;
}
