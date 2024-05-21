boot_image: mbr sysk80
	dd if=/dev/zero of=disk.img bs=512 count=2880
	mkfs.fat -F 12 -n "SYSTEM80" disk.img
	dd if=MBR/mbr of=disk.img conv=notrunc
	mcopy -i disk.img KERNEL/sysk80.bin "::sysk80.bin"

mbr:
	$(MAKE) -C MBR mbr

sysk80:
	$(MAKE) -C KERNEL kernel

.PHONY:
clean:
	$(MAKE) -C MBR clean
	$(MAKE) -C KERNEL clean
