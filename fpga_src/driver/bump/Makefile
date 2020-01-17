
# object files to build
obj-m += example.o
example-objs += example_driver.o

all:
	xxd -i test.bin > ins.c
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm -f example_driver.o.ur-safe ins.c

update: clean all
	sudo rmmod -s example
	sudo insmod example.ko	
	sudo ./pcie_hot_reset.sh 02:00.0

load: clean all
	sudo insmod example.ko	
	sudo ./pcie_hot_reset.sh 02:00.0

reset: 
	sudo ./pcie_hot_reset.sh 02:00.0
