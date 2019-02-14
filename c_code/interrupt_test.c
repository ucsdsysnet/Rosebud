#include "riscv_encoding.h"
void exception(void) __attribute__ ((section ("except")));

int main(void){

set_csr(mie, MIP_MEIP);
set_csr(mstatus, MSTATUS_MIE);

volatile int * a = (volatile int *) 0x00800;
volatile int * b = (volatile int *) 0x01000;
// volatile int * c = (volatile int *) 0x10005;

for (int i=0; i<100; i++) {
       b[i] = *(((char*)&a[i])+3) + 2;
}
			 
// c[2] = c[2] + 2;

while(1);

return 1;
}

void exception(void){
	volatile int * x = (volatile int *) 0x00200;
	*x = 5;
	while(1);
};

