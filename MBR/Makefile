AS=as
ASFLAGS=-mx86-used-note=no

LD=ld
LDFLAGS=-T linker.ld


mbr: mbr.o
	$(LD) $(LDFLAGS) $< -o $@

.PHONY:
mbr.o: mbr.S
	$(AS) $(ASFLAGS) $< -o $@

.PHONY:
clean:
	rm mbr mbr.o
