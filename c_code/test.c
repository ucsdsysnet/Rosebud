int main(void){
volatile int * a = (volatile int *) 0x00800;
volatile int * b = (volatile int *) 0x01000;
volatile int * stat = (volatile int *) 0x08000;
char c;

*stat = 0xFFFFFFFF;
for (int i=0; i<100; i++) {
	b[i] = *(((char*)&a[i])+3) + 2;
	c = *(((char*)stat)+1);
	c--;
	*(((char*)stat)+1) = c;
	// b[i] = a[i] + 2;
	// *(((short*)&b[i])+1) = i*2;
	// c = *(((char*)&b[i])+2);
	// c = c + 5;
	// *(((char*)&b[i])+3) = c;

}

while(1){}

return 1;
}
