GPPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
ASPARAMS = --32
object = loader.o kernel.o
LDPARAMS = -melf_i386

%.o : %.cpp
	g++ $(GPPPARAMS) -o $@ -c $<

%.o : %.s 
	as $(ASPARAMS) -o $@ $<

mykernel.bin: linker.ld $(object)
	ld $(LDPARAMS) -T $< -o $@ $(object)

install: mykernel.bin	
	sudo cp $< /boot/mykernel.bin