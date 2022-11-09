SECTION .data
    string db "Enter your string:", 0h;     # Gets string from user

section .text
global_start

_start:
    mov rsi, string; # rsi = offset address of string
    call reverse_in_place_asm; # Calls method

    mov rdx, rcx; # rdx = string length
    mov rsi, string; # rsi = offset address of string
    mov rdi, 1; # rdi = 1 (stdout)  
    mov rax, 1; # rax = write system call number
    sys call; # exit program

    mov rdi, 0
    mov rax, 60
    syscall

reverse_in_place_asm:
    push rsi
    push rdi
    push rdx
    push rax; # pushing all registers to stack
    call strlen_asm; # call strlen_asm for finding length of the string pointed by rsi

    mov rdi, rsi; # rdi = offset address of string
    mov rax, rcx; # rax = length of string
    add rdi, rcx; # rdi = rdi + rcx, mkaes rdi point to the last character of the string
    dec rdi; rdi = rdi -1;
    shr rax, 1; # rax = rax/2

loop1:
    mov dl, [rsi]; # dl = character at rsi
    mov dh, [rdi]; # dh = character at rdi
    mov [rsi], dh
    mov [rdi], dl; # swap characters
    inc rsi; # increment rsi
    dec rdi; # decrement rdi
    dec rax; # decrement rax
    jnz loop1; # if rax != 0, keep looping
    pop rax; # restore register values
    pop rdx
    pop rdi
    pop rsi
    ret

strlen_asm:
    push rsi; # push all working registers to stack
    push rax
    mov rcx, 0; # set rcx = 0
L2:    mov al, [rsi]; # al = character at rsi
    cmp al, 0; # if al = NULL, then return
    je L1
    inc rcx
    inc rsi
    jmp L2  ;# recursive
L1:
    pop rax
    pop rsi
    ret

add_arrays:
; # Code in C (Reference)
; unsigned long sum = 0;
; int i = 0;
; while(i<num){
;result[i] = arr1[i] + arr2[i];
;sum = sum + result[i]
;i++;
;}
;return sum;

    push rbp
    mov rbp, rsp
    mov QWORD PTR [rbp-24], rdi
    mov QWORD PTR [rbp-32], rsi
    mov QWORD PTR [rbp-40], rdx
    mov QWORD PTR [rbp-48], rcx
    mov QWORD PTR [rbp-8], 0
    mov QWORD PTR [rbp-16], 0
    jmp L3

L3:
    mov rax, QWORD PTR [rbp-48]
    cmp rax, QWORD PTR [rbp-40]
    jb L4
    mov rax, QWORD PTR [rbp-8]
    pop rbp
    ret

L4:
    mov rax, QWORD PTR [rbp-16]
    lea rdx, [0+rax*8]
    mov rax, QWORD PTR [rbp-24]
    add rax, rdx
    mov rcx, QWORD PTR [rax]
    mov rax, QWORD PTR [rax]
    lea rdx, [0+rax*8]
    mov rax, QWORD PTR [rbp-32]
    add rax, rdx
    mov rdx, QWORD PTR [rax]
    mov rax, QWORD PTR [rbp-16]
    lea rsi,[0+rax*8]
    mov rax, QWORD PTR [rbp-48]
    add rax, rsi
    add rdx, rcx
    mov QWORD PTR [rax], rdx
    mov rax, QWORD PTR [rbp-16]
    lea rdx, [0+rax*8]
    mov rax, QWORD PTR [rbp-48]
    add rax, rdx
    mov rax, QWORD PTR [rbp-48]
    add QWORD PTR [rbp-8], rax
    add QWORD PTR [rbp-16], 1


