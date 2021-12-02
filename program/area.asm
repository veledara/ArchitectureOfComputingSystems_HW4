%define BALL 1
%define PARALLELEPIPED 2
%define TETRAHEDRON 3

global ball_surface_area
ball_surface_area:
section .data
    .pi    dq  3.1415
    .four   dq  4.0
section .text
push rbp
mov rbp, rsp

    mov eax, [rel rdi]
    cvtsi2sd   xmm2, eax
    movsd xmm0, xmm2
    mulsd xmm0, xmm0
    mulsd xmm0, [rel .pi]
    mulsd xmm0, [rel .four]

leave
ret

global tetrahedron_surface_area
tetrahedron_surface_area:
section .data
    .h    dq  1.73205 ; ~ sqrt(3)
section .text
push rbp
mov rbp, rsp

    mov eax, [rel rdi]
    cvtsi2sd   xmm2, eax
    movsd xmm0, xmm2
    mulsd xmm0, xmm2
    mulsd xmm0, [rel .h]

leave
ret

global parallelepiped_surface_area
parallelepiped_surface_area:
section .data
    .s1    dq  0.0
    .s2    dq  0.0
    .two   dq  2.0
section .text
push rbp
mov rbp, rsp

    mov eax, [rel rdi]
    cvtsi2sd   xmm0, eax
    mov eax, [rel rdi+8]
    cvtsi2sd   xmm2, eax
    mulsd xmm0, xmm2
    movsd [rel .s1], xmm0

    mov eax, [rel rdi+4]
    cvtsi2sd   xmm0, eax
    mov eax, [rel rdi+8]
    cvtsi2sd   xmm2, eax
    mulsd xmm0, xmm2
    movsd [rel .s2], xmm0

    mov eax, [rel rdi]
    cvtsi2sd   xmm0, eax
    mov eax, [rel rdi+4]
    cvtsi2sd   xmm2, eax
    mulsd xmm0, xmm2

    movsd xmm2, [rel .s1]
    addsd xmm0, xmm2
    movsd xmm2, [rel .s2]
    addsd xmm0, xmm2
    movsd xmm2, [rel .two]
    mulsd xmm0, xmm2

leave
ret

global figure_surface_area
figure_surface_area:
section .text
push rbp
mov rbp, rsp

    mov eax, [rel rdi]
    cmp eax, [rel BALL]
    je .ball_area
    cmp eax, [rel PARALLELEPIPED]
    je .par_area
    cmp eax, [rel TETRAHEDRON]
    je .tetr_area
    xor eax, eax
    cvtsi2sd    xmm0, eax
    jmp     .return
.ball_area:
    add     rdi, 4
    call    ball_surface_area
    jmp     .return
.par_area:
    add     rdi, 4
    call    parallelepiped_surface_area
    jmp     .return
.tetr_area:
    add     rdi, 4
    call    tetrahedron_surface_area
.return:
leave
ret


global average_area
average_area:
section .data
    .sum    dq  0.0
section .text
push rbp
mov rbp, rsp
    mov rbx, rsi
    xor rcx, rcx
    movsd xmm1, [rel .sum]
.loop:
    cmp rcx, rbx
    jge .return

    mov r10, rdi
    call figure_surface_area
    addsd xmm1, xmm0
    
    inc rcx
    add r10, 20
    mov rdi, r10
    jmp .loop
.return:
    movsd xmm0, xmm1
    cvtsi2sd xmm1, rbx
    divsd xmm0, xmm1
leave
ret

global sort_container
sort_container:
section .data
    .sum    dq  0.0
section .text
push rbp
mov rbp, rsp
    mov rbx, rsi
    xor r13, r13
    xor rcx, rcx
    movsd xmm1, [rel .sum]
    mov r11, rdi
    mov r12, rdi
.loop:
    cmp rcx, rbx
    jge .avg_area

    mov r10, rdi
    call figure_surface_area
    addsd xmm1, xmm0
    
    inc rcx
    add r10, 20
    mov rdi, r10
    jmp .loop
.avg_area:
    movsd xmm0, xmm1
    cvtsi2sd xmm1, rbx
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    xor rcx, rcx
    mov rdi, r11
.return:
    ;
leave
ret
