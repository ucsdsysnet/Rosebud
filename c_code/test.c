inline void process (unsigned short* len, unsigned char* port, unsigned int* offset, unsigned int* data);
int main(void){
  volatile unsigned int  * rd_desc      = (volatile unsigned int *) 0x8040;
  volatile unsigned int  * rd_setting   = (volatile unsigned int *) 0x8048;
  volatile unsigned int  * rd_stat      = (volatile unsigned int *) 0x8050;
  volatile unsigned int  * core_id      = (volatile unsigned int *) 0x8054;

  volatile unsigned int  * wr_desc      = (volatile unsigned int *) 0x8000;
  volatile unsigned int  * wr_desc_ctrl = (volatile unsigned int *) 0x8008;
  volatile unsigned int  * wr_setting   = (volatile unsigned int *) 0x8010;
  volatile unsigned int  * wr_slot_addr = (volatile unsigned int *) 0x8018;

  volatile unsigned char * wr_desc_send = (volatile unsigned char *) 0x8038;
  volatile unsigned char * wr_desc_ctrl_send = (volatile unsigned char *) 0x8039;
  volatile unsigned char * setting_apply = (volatile unsigned char *) 0x803A;
  volatile unsigned char * update_slot   = (volatile unsigned char *) 0x803B;
  volatile unsigned char * rd_desc_done = (volatile unsigned char *) 0x803C;

	const unsigned int slot_count = 8;

  unsigned int* data;
  unsigned short len;
  unsigned char port;
  unsigned char slot;
	int offset; 

  // volatile unsigned int * seen_first = (volatile unsigned int *) 0x00304;
	// *seen_first = 0;
	unsigned int id = *core_id;

	for (int i=1; i<=slot_count; i++){
		*wr_slot_addr = (i<<24) + 0x200A + ((i-1)<<11);
		asm volatile("" ::: "memory");
		*update_slot  = 1;
	}
 
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
  		*wr_desc_ctrl = (int)len;
  		*((unsigned char*)wr_desc_ctrl+2) = slot;
  		*((unsigned char*)wr_desc_ctrl+3) = port;
  		*(wr_desc_ctrl+1) = ((unsigned int)data)+offset;
  		*((unsigned char*)wr_desc_ctrl+6) = (char)id;
  		*((unsigned char*)wr_desc_ctrl+7) = 1;
			asm volatile("" ::: "memory");
			* wr_desc_ctrl_send = 1;
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

