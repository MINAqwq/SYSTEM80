.globl cpu_hlt
.globl cpu_outb

/* 
 * KERNEL HALT
 * Disable interrupts and try to halt the cpu
 * Args: None
 */
cpu_hlt:
        cli   /* disable interrupts */
        hlt   /* try to halt */
        jmp . /* last try is a busy wait haha */
        
        ret   /* and here we give up, computer won... */

cpu_outb:
        movw 8(%esp), %dx
        movb 0xc(%esp), %al

        outb %al, %dx
        ret

cpu_inb:
        mov 8(%esp), %dx
        mov 0xc(%esp), %eax

        inb %dx, %al
        mov %al, (%eax)
        ret
