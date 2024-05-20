.code16
.text

.globl _mbr_entry
.globl print_str


_mbr_entry:
/*
 * BOOTSECTOR 
 */
        jmp _mbr_real_entry
        nop

                .ascii "SYSTEM80" /* OEM Name */
fat_header_bps: .word 512         /* Byte per sector */
fat_header_spc: .byte 2           /* Sector per cluster */
fat_header_rss: .word 1           /* Number of reserved sector */
fat_header_fco: .byte 2           /* Number of FAT copies */
fat_header_mre: .word 224         /* MAX root directory entries */
fat_header_sec: .word 2880        /* Total sectors*/
fat_header_mbd: .byte 0xF0        /* Media byte descirptor */
fat_header_spf: .word 9           /* Number of sector per FAT */
fat_header_spt: .word 18          /* Number of sector per track */
                .word 2           /* idc */
                .long 0           /* Hidden `sector before bootsector */
                .long 0           /* Unused */

/*
 * EXTENDED BOOT RECORD 
 */
.byte 0              /* Drive number (0 = floppy) */
.byte 0              /* Filesystem fucked flag */
.byte 0x29           /* Boot signature */
.long 0x69696969     /* Serial number */
.ascii "SYSTEM 80  " /* Volume label */
.ascii "FAT12   "    /* FAT Type */

/*
 * MACHINE CODE (BOOTLOADER)
 */
_mbr_real_entry:
        cli

        /* setup stack (grows downwards) */
        mov $_mbr_entry, %sp

        /* set datasegment right */
        push %cs
        pop %ds

        /* save boot drive number */
        push %dx
        mov %dx, data_drive_number

        /* print loading string */
        mov $str_loading, %si
        call print_str

        /* check if reading with lba
         * in extended mode is supported */

        mov $0x41, %ah
        mov $0xAA55, %bx
        int $0x13
        jnc .lbd_sec_check

lbd_not_supported:
        /* print error */
        mov $str_err_lba_ext, %si
        call print_str
        hlt

err_no_fat12:
        mov $str_err_no_fat12, %si
        call print_str
        hlt

err_failed_reading:
        mov $str_err_load, %si
        call print_str
        hlt

err_failed_kernel:
        mov $str_err_kernel, %si
        call print_str
        hlt   

.lbd_sec_check:
        cmp $0xAA55, %bx
        jne  lbd_not_supported

.lbd_ext_supported:
        /* load first sector */        

        pop %dx
        push %dx

        mov $disk_address_packet, %si
        mov $0xAA55, %bx
        mov $0x42, %ah

        push %ax

        int $0x13
        jc lbd_not_supported

        movb 0x500, %al
        cmpb $0xF0, %al
        jne err_no_fat12

fat_load_root_dir:
        mov $str_load_root, %si
        call print_str

        /* fat count * sector per fat = sector of root */
        //movb (fat_header_fco), %al

        //mul (fat_header_spf)

        //add (fat_header_rss), %al

        //movw %ax, disk_address_packet_lower_lba

        movw $19, disk_address_packet_lower_lba

        mov $disk_address_packet, %si

        pop %ax
        pop %dx

        int $0x13
        jc err_failed_reading

        /* find and load kernel (sys80k.bin) */
        /* (root_dir_sector * sizof(sector)) + (sizof(sector) * offset_byte) + (root_dir_entries * sizeof(dir_entry)) */

        /* load file from entry 0 */
        xor %cl, %cl
        movw disk_address_packet_store_addr, %bx
        mov $20, %dx
        call fat_load_file

        mov $str_load_kernel, %si
        call print_str

        cmpw $0x6969, 0x500
        jne err_failed_kernel

        jmp 0x502

        hlt
        
/* Load a file from the root directory
 * %bx = load address
 * %cl = index
 * %dx = data region sector
 */
fat_load_file:
        pusha

        mov $32, %al
        mul %cl

        /* calc dir entry address */
        add %ax, %bx
        
        /* skip directory */
        add $32, %bx

        /* read file size */
        mov 0x1C(%bx), %cx
        push %cx

        /* read sector offset */
        mov 0x1A(%bx), %cx

        xor %ax, %ax
        movb (fat_header_spc), %al
        sub $2, %cl
        mul %cl
        
        /* skip to data region */
        add $0x0D, %dx

        /* dx is now the lbs where the kernel starts */
        add %ax, %dx

        /* load */
        movw %dx, disk_address_packet_lower_lba

        mov $disk_address_packet, %si
        mov $0xAA55, %bx
        mov $0x42, %ah
        mov (data_drive_number), %dx

        int $0x13
        jc err_failed_reading
        
        /* pop size */
        pop %cx

        popa
        ret


/* print string in dx */
print_str:
        pusha
        lodsb
.mbp_loop:
        xor %bx, %bx
        mov $0x0E, %ah
        int $0x10
        lodsb

        test %al, %al
        jnz .mbp_loop

        popa
        ret

data_drive_number:
.word 0x0000

str_loading:
.asciz "======= Loading SYSTEM 80 =======\r\n"

str_load_root:
.asciz "> Enter root directory...\r\n"

str_load_kernel:
.asciz "> Loading kernel...\r\n"

str_err_lba_ext:
.asciz "ERR: LBA EXT RD not supported!\r\n"

str_err_no_fat12:
.asciz "ERR: Boot FS is not FAT12\r\n"

str_err_load:
.asciz "ERR: INT 13 failed\r\n"

str_err_kernel:
.asciz "ERR: Loaded kernel is not a valid image\r\n"

disk_address_packet:
.byte 0x10       /* size of packet */
.byte 0x00       /* padding ig */
.word 0x0004     /* number of sectors to transfer */
disk_address_packet_store_addr:
.long 0x0500     /* address where our shit gets stored */
disk_address_packet_lower_lba:
.long 0x00000001 /* LBA */
disk_address_packet_higher_lba:
.word 0x0000

.org 510, 0
.word 0xAA55
