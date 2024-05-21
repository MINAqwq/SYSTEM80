.globl kernel_hlt

/* 
 * KERNEL HALT
 * Disable interrupts and try to halt the cpu
 * Args: None
 */
kernel_hlt:
        cli   /* disable interrupts */
        hlt   /* try to halt */
        jmp . /* last try is a busy wait haha */        
        ret   /* and here we give up, computer won... */
