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
    mov al, 'a'
    mov edi, VMEM
    mov [edi], al
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
input:
    incbin "input.txt"
input_end equ $ - input

section .bss
temp: resb 16