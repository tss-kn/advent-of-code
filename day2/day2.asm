[bits 32]

VMEM equ 0xB8000

section .text
global _start

; set up for sequential strchr calls
; strchr_prologue(str, chr)
%macro strchr_prologue 2
    mov ecx, %1.len
    mov edi, %1
    mov esi, edi ; set to string base pointer
    mov al, %2
%endmacro

_start:
    mov esi, hello
    call puts

    strchr_prologue hello2, '-'

    call strchr
    
    mov dl, bl
    add dl, '0'
    mov [VMEM + hello2.len * 2], dl

    call strchr

    mov dl, bl
    add dl, '0'
    mov [VMEM + (hello2.len * 2) + 4], dl

halt:
    hlt
    jmp $

strchr:
    ; call strchr
    repne scasb
    mov ebx, edi
    sub ebx, esi
    ret

; Print a string, esi is the source of the string
; puts str [esi] -> void
puts:
    push eax
    mov edi, VMEM
.putc:
    mov al, [esi]
    cmp al, 0
    je .done

    movsb ; move character into vram
    mov [edi], 0x0F
    inc edi
    jmp .putc
.done:
    pop eax
    ret


section .data
; Strings
hello db "Hello, world!", 0
hello.len equ $ - hello

hello2 db "Haljm-ark-bc", 0
hello2.len equ $ - hello2

section .bss
temp: resb 16