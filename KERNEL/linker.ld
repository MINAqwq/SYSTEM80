ENTRY(_kernel_entry)
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

SECTIONS
{
        . = 0x500;
        .text : {
                *(.meta)
                *(.gdt)
                *(.text)
        }

        .rodata : {
		*(.rodata)
	}
 
	.data : {
		*(.data)
	}
 
	.bss : {
		*(COMMON)
		*(.bss)
	}
}
