CC=cc
CFLAGS=-std=c89 -O2 -Wall -Wextra -Werror -ansi -nostdlib -ffreestanding

AS=as
ASFLAGS=-mx86-used-note=no

LD=ld
LDFLAGS=-T linker.ld -nostdlib

OBJ=\
boot.o \
k_main.o \
x86.o

%.o: %.S
	$(AS) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel: $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o sysk80.bin

clean:
	rm $(OBJ) sysk80.bin
