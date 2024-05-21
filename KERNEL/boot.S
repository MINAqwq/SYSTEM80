.code16
.globl _kernel_entry
.globl _gdtr
.globl _gdt_load

.extern kernel_main

.section .meta
_kernel_entry:
/* kernel magic */
.word 0x6969
        cli

        /* stack setup */
        mov $0x7BFE, %sp

        /* just to be sure */
        jmp protected_mode

.text
protected_mode:
        call a20_enable
        call gdt_load

        /* enable protected mode */
        mov  %cr0, %eax
        or   $1, %al
        mov  %eax, %cr0

        /* use a far jump to reload cs */
        jmp  $0x08, $.reload

.reload:
        /* reload segment register */
        mov  $0x10, %ax
        mov  %ax, %ds
        mov  %ax, %es
        mov  %ax, %fs
        mov  %ax, %gs
        mov  %ax, %ss

.code32
        /* green a indicates everything's sane */
        movw $0x0241, 0xB8000
        call kernel_main
        hlt

.code16
a20_failed:
        hlt

a20_enable:
        /* A20-Gate support */
        mov  $0x2403, %ax
        int  $0x15
        jb   a20_failed
        test %ah, %ah
        jnz  a20_failed
        
        /* A20-Gate status */
        mov  $0x2402, %ax
        int  $0x15
        jb   a20_failed
        test %ah, %ah
        jnz  a20_failed
        
        /* check if already activated */
        test %ah, %ah
        jz   a20_activated
        
        /* activate */
        mov  $0x2401, %ax
        int  $0x15
        jb   a20_failed
        test %ah, %ah
        jnz  a20_failed
 
a20_activated:
        ret

/* global descriptor table */
.section .gdt

_gdt_start:

/* null descriptor */
_gdt_kernel_nullseg:
.quad 0

/* flat kerne code segment
 * Base = 0
 * Limit = 0xFFFFF
 * Access Byte = 0x9A
 * Flags = 0xC
*/

_gdt_kernel_codeseg:
.short 0xFFFF
.short 0x0000
.byte  0x00
.byte  0x9A
.byte  0xCF
.byte  0x00

/* flat kernel data segment
 * Base = 0
 * Limit = 0xFFFFF
 * Access Byte = 0x92
 * Flags = 0xC
*/

_gdt_kernel_dataseg:

.short 0xFFFF
.short 0x0000
.byte  0x00
.byte  0x92
.byte  0xCF
.byte  0x00

/* flat user code segment
 * Base = 0
 * Limit = 0xFFFFF
 * Access Byte = 0xFA
 * Flags = 0xC
*/

_gdt_user_codeseg:
.short 0xFFFF
.short 0x0000
.byte  0x00
.byte  0xFA
.byte  0xCF
.byte  0x00

/* flat user data segment
 * Base = 0
 * Limit = 0xFFFFF
 * Access Byte = 0xF2
 * Flags = 0xC
*/

_gdt_user_dataseg:
.short 0xFFFF
.short 0x0000
.byte  0x00
.byte  0xF2
.byte  0xCF
.byte  0x00
_gdt_end:
_gdtr:
    .short (_gdt_end - _gdt_start)
    .long _gdt_start

/* tell cpu where the gdt is located */
.type _gdt_load, @function
gdt_load:
    lgdt (_gdtr)
    ret

