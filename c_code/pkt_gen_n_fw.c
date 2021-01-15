#include "core.h"

struct Desc packet;
struct Desc recv_pkt;

unsigned char * pkt_data[16];
unsigned int pkt_len[16] = {128, 1024, 128, 1500, 256, 1024, 512, 1500, 1024, 1500, 256, 2048, 512, 4096, 1500, 9000};
// unsigned int pkt_len[16] = {[0 ... 15] = 1500};

char udp_hdr [42] = "\xAB\xAB\xAB\xAB\xAB\xAB\xCD\xCD\xCD\xCD\xCD\xCD\x08\x00" //Ethernet header
                    "\x45\x00\x05\xCE\x00\x00\x00\x00\x00\x11\x00\x00"  // IP hedaer for UDP and packet size 1500, crc=0
                    "\xC0\xA8\x01\x01\xC0\xA8\x01\x02"  //IP addresses 192.168.1.1,2
                    "\xAA\xAA\xBB\xBB\x05\xBA\x00\x00"; //UDP header for packet size 1500, crc=0, 0xAAAA and 0xBBBB ports

char hdr1[60] = "    page.php?id=%27%3B%20SELECT%20%2A%20FROM%20users%3B%20--";
char hdr2[60] = "    page.php?id=%27%3B%20DELETE%20FROM%20prod_data%3B%20--  ";

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
    pkt_data[i] = (unsigned char *)(0x01040000+i*16384);
    basic_memcpy(pkt_data[i], udp_hdr, 42);
    if ((i&0x1)==0)
      basic_memcpy(pkt_data[i]+60, hdr1, 60);
    else
      basic_memcpy(pkt_data[i]+60, hdr2, 60);
    pkt_data[i][35]+=core_id();
    pkt_data[i][37]+=core_id();
  }

  // packet.len = 64;
  packet.tag = 0;
  if ((core_id()&0x4)!=0){
    packet.port = 1;
		while (1){
			for (i=0;i<16;i++) {
        // pkt_data[i][35]++;
        // pkt_data[i][37]--;
				packet.data = pkt_data[i];
      	packet.len  = pkt_len[i];
      	pkt_send(&packet);
			}
		}
	} else {
		while (1){
			if(in_pkt_ready()){
				read_in_pkt(&recv_pkt);
				packet.port = 0;
				pkt_send(&recv_pkt);
			}
		}
	}

  return 1;
}
