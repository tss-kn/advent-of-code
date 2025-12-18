; Boot sector code based on @DaedalusCommunity's "Making an OS" tutorial

[org 0x7c00]                        ; BIOS loads bootloader to memory address 0x7C00
KERNEL_LOCATION equ 0x1000          ; Kernel will be loaded starting at memory location 0x1000

mov [BOOT_DISK], dl                 ; Save boot disk number (BIOS passed this via DL)

; --- Segment setup ---
xor ax, ax                          ; Set AX = 0 for initializing segment registers
mov es, ax                          ; ES = 0: used by INT 13h for disk read buffer
mov ds, ax                          ; DS = 0: default data segment
mov bp, 0x8000                      ; Base pointer for the stack
mov sp, bp                          ; Set up stack pointer

; --- BIOS Disk Read ---
mov bx, KERNEL_LOCATION             ; Target location in memory to load the kernel
mov dh, 2                           ; Number of sectors to read

mov ah, 0x02                        ; INT 13h function: Read sectors
mov al, dh                          ; Number of sectors to read (AL = DH = 2)
mov ch, 0x00                        ; Cylinder = 0
mov dh, 0x00                        ; Head = 0
mov cl, 0x02                        ; Sector number (starts at 1)
mov dl, [BOOT_DISK]                 ; Load the saved boot disk value into DL
int 0x13                            ; BIOS disk interrupt 
; jc disk_error

; --- Set video mode ---
mov ah, 0x0                         ; INT 10h function: Set video mode
mov al, 0x3                         ; Mode 13: 320x200 256 color graphics mode
; Mode 3: 80x25 text mode
; mov ax, 12h                         ; 640x480x16 VGA Mode
int 0x10                            ; BIOS video interrupt

; --- GDT Setup ---
CODE_SEG equ GDT_code - GDT_start  ; Segment offset for code segment
DATA_SEG equ GDT_data - GDT_start  ; Segment offset for data segment

cli                                 ; Disable interrupts before switching to protected mode
lgdt [GDT_descriptor]               ; Load Global Descriptor Table

mov eax, cr0                        ; Load control register 0
or eax, 1                           ; Set PE (Protection Enable) bit
mov cr0, eax                        ; Write back to CR0 to enable protected mode

jmp CODE_SEG:start_protected_mode  ; Far jump to flush pipeline and enter protected mode

jmp $                               ; Infinite loop (this never executes due to jump above)

disk_error:
    mov si, disk_error_txt     ; Load pointer to the error message string

.print_char:
    lodsb                      ; Load byte at DS:SI into AL, advance SI
    cmp al, 0                  ; Check for null terminator
    je hang                   ; Jump to end if zero

    mov ah, 0x0E               ; BIOS teletype function
    int 0x10                   ; Print character in AL
    jmp .print_char            ; Loop for next character

hang:
    jmp hang          ; Infinite loop after showing error


; --- Variables and Tables ---
BOOT_DISK: db 0                     ; 1-byte variable to store boot disk number

GDT_start:
    GDT_null:
        dd 0x0                      ; Null descriptor (required as first entry)
        dd 0x0

    GDT_code:
        dw 0xffff                  ; Limit (low 16 bits)
        dw 0x0                     ; Base (low 16 bits)
        db 0x0                     ; Base (middle 8 bits)
        db 0b10011010              ; Access byte (Code segment descriptor)
        db 0b11001111              ; Flags and limit (high 4 bits)
        db 0x0                     ; Base (high 8 bits)

    GDT_data:
        dw 0xffff                  ; Same structure as code segment
        dw 0x0
        db 0x0
        db 0b10010010              ; Access byte (Data segment descriptor)
        db 0b11001111
        db 0x0

GDT_end:

GDT_descriptor:
    dw GDT_end - GDT_start - 1     ; Size of GDT minus 1
    dd GDT_start                   ; Address of the GDT

disk_error_txt db "There was an error reading the disk", 0xa, 0x0

; --- Protected Mode Code ---
[bits 32]
start_protected_mode:
    mov ax, DATA_SEG               ; Set all segment registers to data segment
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    mov ebp, 0x90000               ; 32-bit stack base
    mov esp, ebp                   ; Set up stack pointer

    jmp KERNEL_LOCATION            ; Jump to loaded kernel!

; --- Boot Signature ---
times 510-($-$$) db 0              ; Fill remaining space with zeros
dw 0xaa55                          ; Boot signature to mark as valid bootable sector
