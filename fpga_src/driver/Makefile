
# object files to build
obj-m += example.o
example-objs += example_driver.o

all:
	xxd -i test.bin > ins.c
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

