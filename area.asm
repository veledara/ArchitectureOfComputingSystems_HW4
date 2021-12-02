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


global AreaAverageContainer
AreaAverageContainer:
section .data
    .sum    dq  0.0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фигур
    xor rcx, rcx            ; счетчик фигур
    movsd xmm1, [rel .sum]      ; перенос накопителя суммы в регистр 1
.loop:
    cmp rcx, rbx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    mov r10, rdi            ; сохранение начала фигуры
    call figure_surface_area          ; Получение периметра первой фигуры
    addsd xmm1, xmm0        ; накопление суммы
    
    inc rcx                 ; индекс следующей фигуры
    add r10, 16             ; адрес следующей фигуры
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop
.return:
    movsd xmm0, xmm1
    cvtsi2sd xmm1, rbx
    divsd xmm0, xmm1
leave
ret

global DeleteLessAverageContainer
DeleteLessAverageContainer:
section .data
    .sum    dq  0.0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фигур
    xor r13, r13            ; счетчик оставленных фигур
    xor rcx, rcx            ; счетчик фигур
    movsd xmm1, [rel .sum]      ; перенос накопителя суммы в регистр 1
    mov r11, rdi            ; сохранение начала первой фигуры
    mov r12, rdi            ; сохранение начала последней сохранённой фигуры
.loop:
    cmp rcx, rbx            ; проверка на окончание цикла
    jge .delete             ; Перебрали все фигуры

    mov r10, rdi            ; сохранение начала фигуры
    call figure_surface_area          ; Получение периметра первой фигуры
    addsd xmm1, xmm0        ; накопление суммы
    
    inc rcx                 ; индекс следующей фигуры
    add r10, 16             ; адрес следующей фигуры
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop
.delete:
    movsd xmm0, xmm1
    cvtsi2sd xmm1, rbx
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    ; xmm1 хранит среднюю площадь.
    xor rcx, rcx
    mov rdi, r11
.loop2:
    cmp rcx, rbx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    mov r10, rdi            ; сохранение начала фигуры
    call figure_surface_area          ; Получение периметра первой фигуры
    comisd xmm0, xmm1
    jb .removeShape
    inc r13
    mov rsi, r12
    ; move to last free spot.
    mov rdi, [rel r10]
    mov [rel rsi], rdi
    mov rdi, [rel r10+4]
    mov [rel rsi+4], rdi
    mov rdi, [rel r10+8]
    mov [rel rsi+8], rdi
    mov rdi, [rel r10+12]
    mov [rel rsi+12], rdi
    
    add r12, 16
.removeShape:
    inc rcx                 ; индекс следующей фигуры
    add r10, 16             ; адрес следующей фигуры
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop2
.return:
    mov rax, r13
leave
ret
