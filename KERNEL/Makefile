TC=../Toolchain/i386-elf/bin/i386-elf

CC=$(TC)-gcc
CFLAGS=-std=c89 -O2 -Wall -Wextra -Werror -ansi -nostdlib -ffreestanding

AS=$(TC)-as
ASFLAGS=-mx86-used-note=no

LD=$(TC)-ld
LDFLAGS=-T linker.ld -nostdlib

OBJ=\
k_boot.o \
k_main.o \
k_x86.o

%.o: %.S
	$(AS) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel: $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o sysk80.bin

clean:
	rm $(OBJ) sysk80.bin
