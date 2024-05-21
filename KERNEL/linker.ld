ENTRY(_kernel_entry)
OUTPUT_FORMAT(binary)

SECTIONS
{
        . = 0x500;
        .text :
        {
                *(.meta)
                *(.gdt)
                *(.text)
                *(.data)
        }
}
