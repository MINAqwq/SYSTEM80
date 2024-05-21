.bss

.macro IDT_ENTRY_UNUSED
.quad 0
.endm

.macro IDT_ENTRY addr
.word (\addr & 0xFFFF)         /* base low */
.word 0x08                    /* segment selector  */
.byte 0x00                    /* reserved */
.byte 0x8E                    /* present 32bit interrupt in ring 0 */
.word ((\addr >> 16) & 0xFFFF) /* base high */
.endm

.macro IDT_ROUTINE num
        cli
        pusha
        push $\num
        jmp _internal_isr
        mov
.endm

_idt_start:
IDT_ENTRY
_idt_end:

/* interrupt subroutine */
_internal_isr:
        popa
        iret


.text
idt_setup:
        ret
