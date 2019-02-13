int main(void){
volatile unsigned int * a = (volatile unsigned int *) 0x00100;
volatile unsigned int * stat = (volatile unsigned int *) 0x08000;
unsigned int* b;
unsigned int c;
unsigned int d;

while(1){
	while ((*a)==0);
	c = *a;
	b = (unsigned int*)(*(a+1));
	*stat = *stat & (~c);
	*a = 0;
	b[6] = b[6]+b[6];
	b[7] = b[7]+b[7];
	*stat = *stat | c;
}

return 1;
}
