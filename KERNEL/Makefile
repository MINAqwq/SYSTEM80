CC=cc
CFLAGS=-std=c89 -O2 -Wall -Wextra -Werror -ansi

AS=as
ASFLAGS=-mx86-used-note=no

LD=ld
LDFLAGS=-T linker.ld

OBJ=\
boot.o

%.o: %.S
	$(AS) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

kernel: $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o sysk80.bin

clean:
	rm $(OBJ)
