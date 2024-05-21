#ifndef KERNEL_X86_H
#define KERNEL_X86_H

#include "types.h"

/* disable interrupts and try to halt the cpu */
extern void cpu_hlt();

/* =================== BIOS 16 =================== */

/* ==================== PORTS ==================== */

/* write a 8bit value to a 16bit hardware port */
extern void cpu_outb(u16 port, u8 value);

/* read a byte from a 16bit hardware port */
extern void cpu_inb(u16 port, u8 *value);

#endif
