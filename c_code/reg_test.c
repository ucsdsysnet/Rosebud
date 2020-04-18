#include "core.h"

struct Desc packet;
unsigned char * pkt_data[16];
unsigned int pkt_len[16] = {64, 1024, 128, 1500, 256, 1024, 512, 1500, 1024, 1500, 65, 2048, 512, 4096, 1500, 9000};
// unsigned int pkt_len[16] = {[0 ... 15] = 825};

char hdr1[60] = "    page.php?id=%27%3B%20SELECT%20%2A%20FROM%20users%3B%20--";
char hdr2[60] = "    page.php?id=%27%3B%20DELETE%20FROM%20prod_data%3B%20--  ";
char hdr3[60] = "    page.php?id=                                          --";

void basic_memcpy(char *dest, char *src, int n) 
{ 
  // unsigned int *csrc  = (unsigned int *)src; 
  // unsigned int *cdest = (unsigned int *)dest; 
             
  for (int i=0; i<n; i++) 
    dest[i] = src[i]; 
} 

int main(void){


  int i;
  unsigned int pkt_num;
  volatile int k;

  // Do this at the beginnig, so scheduler can fill the slots while 
  // initializing other things.
  init_hdr_slots(8, 0x804000, 128);
  init_slots(8, 0x00000A, 16384);

  for (i=0;i<16;i++){
    pkt_data[i] = (unsigned char *)(0x01000000+i*16384);
    if ((i&0x1)==0)
      basic_memcpy(pkt_data[i]+pkt_len[i]-60, hdr2, 60);
      // basic_memcpy(pkt_data[i], hdr2, 60);
    else
      basic_memcpy(pkt_data[i]+pkt_len[i]-60, hdr2, 60);
      // basic_memcpy(pkt_data[i], hdr2, 60);
    pkt_data[i][0] = (char) core_id();
    
  }

  pkt_num    = 0;
  // packet.len = 64;
  packet.tag = 0;
  if ((core_id()&0x4)!=0)
    packet.port = 1;
  else
    packet.port = 0;

  while (1){
    for (i=0;i<16;i++) {
      // for (k=0; k<10000; k++);
      packet.data = pkt_data[i];
      packet.len = pkt_len[i];
      pkt_send(&packet);
    } 
  }

  return 1;
}
