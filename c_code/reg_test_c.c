// Linux GCC test 

// #include "core.h"

#include <stdio.h>
#include <stdlib.h>

struct Desc {
	unsigned short len;
	unsigned char  tag;
	unsigned char  port;
	unsigned char* data;
};

struct Desc packet;
unsigned char * pkt_data[16];
const char* hdr = "    page.php?id=%27%3B%20SELECT%20%2A%20FROM%20users%3B%20--";

void basic_memcpy(char *dest, const char *src, int n) 
{ 
  unsigned int *csrc  = (unsigned int *)src; 
  unsigned int *cdest = (unsigned int *)dest; 
             
  for (int i=0; i<(n>>2); i++) 
    cdest[i] = csrc[i]; 
} 

int main(void){

  int i;
  unsigned int pkt_num;
  volatile int k;

  // Do this at the beginnig, so scheduler can fill the slots while 
  // initializing other things.
  // init_hdr_slots(8, 0x804000, 128);
  // init_slots(8, 0x00000A, 16384);

  for (i=0;i<16;i++){
    // pkt_data[i] = (unsigned char *)(0x01000000+i*16384);
    // basic_memcpy(pkt_data[i], hdr, 100);
    // pkt_data[i][0] = core_id();
    
    pkt_data[i] = (unsigned char *) malloc (100*sizeof(char));
    basic_memcpy(pkt_data[i], hdr, 100);
    // // memcpy(pkt_data[i], hdr, 100);
    pkt_data[i][0] = (char) (i+48); 
  }

  pkt_num    = 0;
  packet.len = 1024;
  packet.tag = 0;
  // if ((core_id()&0x4)!=0)
  //   packet.port = 1;
  // else
    packet.port = 0;

  // while (1){
    for (i=0;i<16;i++) {
      // for (k=0; k<10000; k++);
      packet.data = pkt_data[i];
      //pkt_send(&packet);
      printf("%s\n",pkt_data[i]);
    } 
  // }

  return 1;
}
