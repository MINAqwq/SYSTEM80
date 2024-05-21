.code16
.globl _kernel_entry

.section .meta
_kernel_entry:
/* kernel magic */
.word 0x6969
        /* just to be sure */
        jmp protected_mode

.text
protected_mode:
        call a20_enable
        hlt

a20_failed:
        hlt

a20_enable:
        mov  $0x2403, %ax
        int  $0x15
        jb   a20_failed
        test %ah, %ah
        jnz  a20_failed
        
        mov  $0x2402, %ax
        int  $0x15
        jb   a20_failed
        test %ah, %ah
        jnz  a20_failed
        
        test %ah, %ah
        jz   a20_activated
        
        mov  $0x2401, %ax
        int  $0x15
        jb   a20_failed
        test %ah, %ah
        jnz  a20_failed
 
a20_activated:
        ret
