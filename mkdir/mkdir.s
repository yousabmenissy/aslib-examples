.include "aslib/aslib.s"

.section .text
.global _start
_start:
    movq  %rsp, %rbp
    subq  $32, %rsp

    movq  (%rbp), %rax
    movq  %rax, -8(%rbp)

    movq  $0777, -16(%rbp)
    movq  $0, -24(%rbp)

    cmpq  $1, -8(%rbp)
    je    2f

    cmpq  $2, -8(%rbp)
    jne   .LS0

    leaq   hflags(%rip), %rdi
    leaq   16(%rbp), %rsi
    call   vflagb
    testq  %rax, %rax
    jns    2f

    .LS0:
    leaq   mflag(%rip), %rdi
    leaq   16(%rbp), %rsi
    call   vflags
    testq  %rax, %rax
    js     .LS1

    movq  %rax, %rdi
    call  getmode

    movq  %rax, -16(%rbp)
    .LS1:
    movq  -8(%rbp), %rdi
    leaq  8(%rbp), %rsi
    leaq  mflag(%rip), %rdx
    leaq  hflags(%rip), %rcx
    call  parseargs

    testq  %rax, %rax
    js     3f

    movq  %rax, %rbx
    addq  $8, %rbx

    movq  $-1, %r12

    .LP0:
    incq  %r12
    movq  (%rbx, %r12, 8), %rdi
    cmpq  $0, %rdi
    je    .LS2

    MKDIR  (%rdi), -16(%rbp)

    testq  %rax, %rax
    jns    .LP0

    pushq  $0
    pushq  %rdi
    movq   $1, %rdi
    leaq   mkdirErr(%rip), %rsi
    call   printf

    jmp  .LP0

    .LS2:
    MUNMAP  -8(%rbx), $PAGE_SIZE
    EXIT    %rax

    2:
    WRITE  $1, usage(%rip), usage_len(%rip)
    EXIT   $0

    3:
    EXIT  $-1

