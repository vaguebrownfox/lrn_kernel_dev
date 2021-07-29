all:
	# assemble the code
	nasm -f bin boot.asm -o ./boot.bin 

	# write message after the boot sector (512b): boot.bin is a virtual hard-disk
	dd if=./message.txt >> ./boot.bin
	
	# fill with zeros to create next sector
	dd if=/dev/zero bs=512 count=1 >> ./boot.bin
