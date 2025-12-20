[bits 32]

VMEM equ 0xB8000

section .text
global _start

; set up for sequential strchr calls
; strchr_prologue(str, chr)
; %macro strchr_prologue 2
;     mov ecx, %1.len
;     mov edi, %1
;     mov esi, edi ; set to string base pointer
;     mov al, %2
; %endmacro

_start:
    cld

    mov edi, input


.clear_min_max:
    push edi

    mov ecx, 6 ; reset mem to zero
    mov edi, min
    xor eax, eax
    rep stosb

    mov ecx, 6
    mov edi, max
    xor eax, eax
    rep stosb

    pop edi

    ; check if invalid id for n and m
.push_range_min_max: ; process n-m
    mov ecx, 64     ; prevent repne from stopping for proper strchr
    mov al, '-'
    mov esi, edi    
    repne scasb     ; nnnnn-
    ; (increments edi)
    mov edx, min + 5
    call push_min_max

    mov al, ','
    mov esi, edi
    repne scasb     ; mmmmm,

    mov edx, max + 5
    call push_min_max

.check_invalid_min:
    mov esi, min
    call check_invalid

.check_invalid_max:
    mov esi, max
    call check_invalid

.check_invalid_range:
    mov edi, min+5
    call bcd_inc

    mov edi, min
    mov esi, max
    mov ecx, 5

    call check_invalid

    ; mov eax, [esi]
    ; cmp eax, [edi]
    mov edi, min
    mov esi, max
    repe cmpsb
    jne .check_invalid_range


    jmp $

; input
; esi -> source number (packed BCD)
check_invalid:
    call get_num_digits

    push ecx

    mov edi, temp
.store:
    call bcd_to_numstring
    xor al, ah
    xor ah, al
    xor al, ah
    stosw
    inc esi
    loop .store
.compare_halves:
    mov cl, dl

    mov esi, temp
    cmp [esi], '0'
    jne .offset
    inc esi
.offset:
    mov edi, esi
    add edi, edx

    repe cmpsb
    jne .skip_add_to_total

.add_to_total:
    clc
    mov edi, running_total + running_total.len
    mov al, [esi]
    adc [edi], esi
    daa
    dec edi


.skip_add_to_total:
    ret



; input
; esi -> base pointer of SCASB comparison
; edi -> result pointer of SCASB comparison
; output
; buffer -> packed BCD of [edi]-[esi]
push_min_max:
    pusha
    mov ecx, 0
    mov eax, 0
    ; flip esi and edi (thank you primagen)
    xor esi, edi
    xor edi, esi
    xor esi, edi
.extract_number:
    mov al, [esi-2]
    sub al, '0'
    shl al, cl
    or [edx], al ; move into min or max (as BCD) depending on edx offset
.skip_zero:
    add cl, 4
    dec esi

.decr_numptr:
    test cl, 7
    jnz .skip
    mov cl, 0
    dec edx
.skip:
    mov ebx, esi
    sub ebx, 2
    cmp ebx, edi
    jae .extract_number

.ex_done:
    popa
    ret

; input
; esi -> source buffer (packed BCD)
; output
; cl -> num of bytes used by number
; dl -> num of digits in BCD number
; esi -> start of first available BCD byte
get_num_digits:
    mov ecx, 6
    mov edx, 0
.get_num_bytes:
    mov al, [esi]
    test al, al
    jnz .done
    dec cl
    jz .done
    inc esi
    jmp .get_num_bytes
.done:
    mov dl, cl        ; al = bytes used
    shl dl, 1         ; multiply by 2 → digit count

    ret


; esi -> source buffer (packed BCD)
; edi -> destination buffer (packed BCD)
; ecx -> number of bytes
bcd_add:
    clc                     ; clear carry
    add esi, ecx            ; point to last byte
    add edi, ecx
    dec esi
    dec edi

.loop:
    mov al, [edi]           ; load dest byte
    adc al, [esi]           ; add src + carry
    daa                     ; adjust AL to valid BCD
    mov [edi], al           ; store back

    dec esi
    dec edi
    loop .loop
    ret


; Increment a packed BCD buffer by 1
; edi -> buffer end (least significant byte)
; ecx -> number of bytes

bcd_inc:
    clc                 ; clear carry
    add edi, ecx        ; point to end
    dec edi

.loop:
    mov al, [edi]       ; load current byte
    adc al, 0           ; add carry (first iteration = 1)
    daa                 ; adjust AL to valid BCD
    mov [edi], al       ; store back

    jc .carry           ; if carry out, cascade left
    ret

.carry:
    dec edi
    loop .loop
    ret


; input
; esi -> source buffer (packed BCD)
; cl -> shift counter
bcd_shl:
    mov al, [esi]
    shl al, 4

    mov bl, [esi + 1]
    shr bl, 4

    or al, bl
    mov [esi], al
    inc esi
    dec cl
    jnz bcd_shl
    ret

; input
; esi -> source buffer (packed BCD)
; cl -> shift counter
bcd_shr:
    mov al, [esi]        ; load current byte
    shr al, 4            ; keep low nibble (digit shifted right)
    
    mov bl, [esi-1]      ; load next byte
    shl bl, 4            ; bring its high nibble down
    
    or al, bl            ; combine into one packed BCD
    mov [esi], al        ; store result
    
    dec esi              ; advance pointer
    dec cl               ; decrement counter
    jnz bcd_shr          ; loop until done
    ret


; input
; esi -> start byte to swap
; swap_bytes:
;     pop esi
;     mov al, [esi + 1]
;     mov ah, [esi]
;     mov [esi], ax
;     dec esi
;     cmp esi, edi
;     jne swap_bytes

;     ret


; input
; esi -> source of packed BCD
; output
; ax -> unpacked BCD
bcd_to_numstring: 
    mov eax, 0
    mov al, [esi]
    mov ah, [esi]

    and al, 0xF
    and ah, 0xF0

    shr ah, 4

    add al, '0'
    add ah, '0'
    ret

; input
; ax -> unpacked BCD
; output
; ax -> packed BCD
numstring_to_bcd:
    sub ah, '0'
    sub al, '0'
    shl ah, 4
    or ah, al
    ret


; Print a string to the screen
; input
; esi -> source string
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
    incbin "../input.txt"
input.len equ $ - input

test_bcd_num db 0x02, 0x12, 0x56, 0x22, 0x34 ; 222 with pad zero

section .bss
min: resb 6 ; bcd big endian
min.len equ $ - min

max: resb 6 ; bcd big endian
max.len equ $ - max

running_total: resb 10 ; bcd little endian
running_total.len equ $ - running_total
temp: resb 64