boot_image: mbr
	dd if=/dev/zero of=disk.img bs=512 count=2880
	mkfs.fat -F 12 -n "SYSTEM80" disk.img
	dd if=MBR/mbr of=disk.img conv=notrunc
	mcopy -i disk.img KERNEL/sysk80.bin "::sysk80.bin"
	mcopy -i disk.img KERNEL/sysk80.bin "::sysk801.bin"

mbr:
	$(MAKE) -C MBR mbr

boot80:
	$(MAKE) -C BOOT boot80
