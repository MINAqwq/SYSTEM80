.globl _kernel_entry

.section .meta
_kernel_entry:
        /* kernel magic */
        .word 0x6969
        hlt

.text
