int main(void){
volatile unsigned int * a = (volatile unsigned int *) 0x00100;
volatile unsigned int * stat = (volatile unsigned int *) 0x08000;
unsigned int* b;
unsigned int c;
unsigned int flag;
unsigned int d;
int i;

while(1){
	for (i=0; i<32; i+=2){
		if (a[i]!=0){
			c = a[i];
		  flag = c | 0xFFFF0000;
			b = (unsigned int*)(a[i+1]);
			*stat = *stat & (~flag);
			a[i] = 0;
			b[6] = b[6]+0x05050505;
			b[7] = b[7]+0x05050505;
			*stat = *stat | c;
			*(stat+1) = 0;
		}
	}
}

return 1;
}
