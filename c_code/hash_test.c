#include "core.h"

struct Desc packet;
unsigned char * pkt_data[16];
// unsigned int pkt_len[16] = {65,128,256,512,1024,2048,4096,9000,9000,2048,4096,1024,1500,256,128,1024};
unsigned int pkt_len[16] = {[0 ... 15] = 1500};

char udp_hdr [42] = "\xAB\xAB\xAB\xAB\xAB\xAB\xCD\xCD\xCD\xCD\xCD\xCD\x08\x00" //Ethernet header
                    "\x45\x00\x05\xCE\x00\x00\x00\x00\x00\x11\x00\x00"  // IP hedaer for UDP and packet size 1500, crc=0
                    "\xC0\xA8\x01\x01\xC0\xA8\x01\x02"  //IP addresses 192.168.1.1,2
                    "\xAA\xAA\xBB\xBB\x05\xBA\x00\x00"; //UDP header for packet size 1500, crc=0, 0xAAAA and 0xBBBB ports

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
    basic_memcpy(pkt_data[i], udp_hdr, 42);
  }

  pkt_num    = 0;
  packet.len = 1500;
  packet.tag = 0;
  if ((core_id()&0x4)!=0)
    packet.port = 1;
  else
    packet.port = 0;

  while (1){
    for (i=0;i<16;i++) {
      packet.data = pkt_data[i];
      // packet.len = pkt_len[i];
      pkt_send(&packet);
    } 
  }

  return 1;
}
