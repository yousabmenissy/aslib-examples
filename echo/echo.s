.include "aslib/aslib.s"

.section .text
.global _start
_start:
    movq  %rsp, %rbp
    movq  (%rbp), %r8

    .LP0:
    incq   %rbx
    movq   8(%rbp, %rbx, 8), %rdi
    call   strlen
    movq   %rdi, %rdx
    WRITE  $1, (%rdx), %rax
    movq   $1, %rdi
    movq   $' ', %rsi
    call   putc

    decq  %r8
    cmpq  $1, %r8
    jne   .LP0

    NEWLN  $1
    EXIT   $0
