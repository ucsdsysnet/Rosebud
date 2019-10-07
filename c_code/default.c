#include "core.h"

int main(void){

	volatile unsigned short * sh_test  = (volatile unsigned short *) 0x0700A;
	
	write_timer_interval(0x00000200);
	set_masks(0x9F); //enable errors and incoming packet interrupt 

	// Do this at the beginnig, so scheduler can fill the slots while 
	// initializing other things.
	init_slots(8, 0x200A, 2048);
			
	while (1);
  
  return 1;
}
