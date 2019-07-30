inline void process (unsigned short* len, unsigned char* port, unsigned int* offset, unsigned int* data);
int main(void){
  volatile unsigned int * rd_desc    = (volatile unsigned int *) 0x08000;
  volatile unsigned int * wr_desc    = (volatile unsigned int *) 0x08008;
	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;
  unsigned int* data;
  unsigned short len;
  unsigned char port;
  unsigned char slot;
	int offset; 

  // volatile unsigned int * seen_first = (volatile unsigned int *) 0x00304;
	// *seen_first = 0;
 
  while(1){
		if((*rd_desc)!=0){
  		len  = *((unsigned short*)rd_desc);
  		slot = *(((unsigned char*)rd_desc)+2);
  		port = *(((unsigned char*)rd_desc)+3);
			asm volatile("" ::: "memory");
  		data = (unsigned int*)(*(rd_desc+1));
			offset = 0;

			*sh_test += 1;

  		process (&len, &port, &offset, data);
  		// Order of writing to stat is important, last two should 
  		// be to stat and then stat+1 and it should not happen before that. 
  		// there is 10 byte offset when DMA writes and we did not change it,
  		// so that would be the start address of packet. 
  		*wr_desc = (int)len;
  		*((unsigned char*)wr_desc+2) = slot;
  		*((unsigned char*)wr_desc+3) = port;
			asm volatile("" ::: "memory");
  		*(wr_desc+1) = ((unsigned int)data)+offset;
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
		// *len = 0;
		// *saved_MAC_byte = *((unsigned char*)(&data[5])+1);
		// *seen_first = 1;
		// * ((unsigned char*)(&data[5])+1) = 0xEE;
	}
	// *offset = -4;
	return;
}

