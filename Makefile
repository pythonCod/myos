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

mykernel.iso: mykernel.bin
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp  $< iso/boot/
	echo 'set timeout =0'  >> iso/boot/grub/grub.cfg
	echo 'set default =0'  >> iso/boot/grub/grub.cfg
	echo ''  >> iso/boot/grub/grub.cfg
	echo 'menuentry "AhmedOS" {'  >> iso/boot/grub/grub.cfg
	echo '	multiboot /boot/mykernel.bin'  >> iso/boot/grub/grub.cfg
	echo '	boot'  >> iso/boot/grub/grub.cfg
	echo '	}'  >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	rm -rf iso
