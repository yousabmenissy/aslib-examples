.include "aslib/aslib.s"

.section .data
err: .string "sum: ignored bad input '{s}' \n"

.section .text
.global _start

_start:
    movq  %rsp, %rbp

    pxor  %xmm1, %xmm1
    cmpq  $1, (%rbp)
    jne   .LP0
    EXIT  $0

    .LP0:
    incq  %rbx
    movq  8(%rbp, %rbx, 8), %rdi
    cmpq  $0, %rdi
    je    2f

    ATOD
    testq  %rdx, %rdx
    jns    1f

    pushq  $0
    pushq  8(%rbp, %rbx, 8)
    movq   $1, %rdi
    leaq   err(%rip), %rsi
    call   printf
    jmp    .LP0

    1:
    DADD
    movaps  %xmm0, %xmm1
    pxor    %xmm0, %xmm0
    jmp     .LP0

    2:
    movaps  %xmm1, %xmm0
    PUTD    $1
    NEWLN   $1
    EXIT    $0
