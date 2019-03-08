inline void process (unsigned short* len, unsigned char* port, unsigned int* offset, unsigned int* data);
#define SLOT_COUNT 12
int main(void){
  volatile unsigned int * trigger = (volatile unsigned int *) 0x00100;
  volatile unsigned int * stat    = (volatile unsigned int *) 0x08000;
  unsigned int* data;
  unsigned int c;
  unsigned short len;
  unsigned char port;
  unsigned char slot;
	unsigned int offset=8; //10;
  int i;

  // volatile unsigned int * seen_first = (volatile unsigned int *) 0x00304;
	// *seen_first = 0;
  
  while(1){
  	for (i=0; i<2*SLOT_COUNT; i+=2){
  		if (trigger[i]!=0){
  			len  = *((unsigned short*)&trigger[i]);
  			port = *(((unsigned char*)&trigger[i])+2);
  			slot = *(((unsigned char*)&trigger[i])+3);
  			data = (unsigned int*)(trigger[i+1]);
  			trigger[i] = 0;
  			process (&len, &port, &offset, data);
  			// Order of writing to stat is important, last two should 
  			// be to stat and then stat+1 and it should not happen before that. 
  			// there is 10 byte offset when DMA writes and we did not change it,
  			// so that would be the start address of packet. 
  			*(stat+1) = (unsigned int)data+offset;
  			*stat = (int)len;
  			*((unsigned char*)stat+2) = port;
  			*((unsigned char*)stat+3) = slot;
  			*((unsigned char*)stat+7) = 0; // no error
  		}
  	}
  }
  
  return 1;
}

inline void process (unsigned short* len, unsigned char* port, unsigned int *offset, unsigned int* data) {
  // volatile unsigned char * saved_MAC_byte = (volatile unsigned char *) 0x00300;
  // volatile unsigned int * seen_first = (volatile unsigned int *) 0x00304;
	// change sender's mac address
	// data[6] = data[6]+0x05050505;
	// data[7] = data[7]+0x05050505;
	// *offset = 6;
	if (*port==0){
		*port = 1;
		// if (*seen_first)
		// * ((unsigned char*)(&data[3])+3) = 0xEE; //*saved_MAC_byte;
	} else {
		*port = 0;
		// *saved_MAC_byte = *((unsigned char*)(&data[5])+1);
		// *seen_first = 1;
		// * ((unsigned char*)(&data[5])+1) = 0xEE;
	}

	return;
}

