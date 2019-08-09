inline void process (unsigned short* len, unsigned char* port, unsigned int* offset, unsigned int* data);
int main(void){
  volatile unsigned int * rd_desc    = (volatile unsigned int *) 0x8040;
  volatile unsigned int * wr_desc    = (volatile unsigned int *) 0x8000;
  volatile unsigned char * wr_desc_send = (volatile unsigned char *) 0x8038;
  volatile unsigned char * rd_desc_done = (volatile unsigned char *) 0x803c;

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
  		data = (unsigned int*)(*(rd_desc+1));
			asm volatile("" ::: "memory");
			* rd_desc_done = 1;
			offset = 0;

  		process (&len, &port, &offset, data);
  		// Order of writing to stat is important, last two should 
  		// be to stat and then stat+1 and it should not happen before that. 
  		// there is 10 byte offset when DMA writes and we did not change it,
  		// so that would be the start address of packet. 
  		*wr_desc = (int)len;
  		*((unsigned char*)wr_desc+2) = slot;
  		*((unsigned char*)wr_desc+3) = port;
  		*(wr_desc+1) = ((unsigned int)data)+offset;
			asm volatile("" ::: "memory");
			* wr_desc_send = 1;
  	}
  }
  
  return 1;
}

inline void process (unsigned short* len, unsigned char* port, unsigned int *offset, unsigned int* data) {
	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;
  // volatile unsigned char * saved_MAC_byte = (volatile unsigned char *) 0x00300;
  // volatile unsigned int * seen_first = (volatile unsigned int *) 0x00304;
	// change sender's mac address
	// data[6] = data[6]+0x05050505;
	// data[7] = data[7]+0x05050505;
	// *offset = 6;
	if (*port==0){
		*port = 1;
		*sh_test += 1;
		// if (*seen_first)
		// * ((unsigned char*)(&data[3])+3) = 0xEE; //*saved_MAC_byte;
	} else {
		*port = 0;
		*(sh_test+1) += 1;
		// *len = 0;
		// *saved_MAC_byte = *((unsigned char*)(&data[5])+1);
		// *seen_first = 1;
		// * ((unsigned char*)(&data[5])+1) = 0xEE;
	}
	// *offset = -4;
	return;
}

