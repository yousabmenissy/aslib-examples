.include "aslib/aslib.s"

.section .text
.global _start
_start:
    movq  %rsp, %rbp
    subq  $32, %rsp

    movq  (%rbp), %rax
    movq  %rax, -8(%rbp)

    cmpq  $1, -8(%rbp)
    je    2f

    cmpq  $2, -8(%rbp)
    jne   LS0

    leaq   hflags(%rip), %rdi
    leaq   16(%rbp), %rsi
    call   vflagb
    testq  %rax, %rax
    jns    2f

LS0:
    leaq   veflags(%rip), %rdi
    leaq   16(%rbp), %rsi
    call   vflagb
    testq  %rax, %rax
    js     1f

    movb  $-1, VFLAG(%rip) # -v flag

    1:
    leaq   rflags(%rip), %rdi
    leaq   16(%rbp), %rsi
    call   vflagb
    testq  %rax, %rax
    js     1f

    movb  $-1, RFLAG(%rip) # -r flag

    1:
    leaq   fflags(%rip), %rdi
    leaq   16(%rbp), %rsi
    call   vflagb
    testq  %rax, %rax
    js     LS1

    movb  $-1, FFLAG(%rip) # -f flag

LS1:
    movq  -8(%rbp), %rdi
    leaq  8(%rbp), %rsi
    xor   %rdx, %rdx
    leaq  bflags(%rip), %rcx
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

    cmpb  $-1, RFLAG(%rip)
    jne   1f

    call   rrm # -r flag is set
    testq  %rax, %rax
    js     3f
    jmp    .LP0

    1:
    movq   %rdi, -24(%rbp)
    call   delete
    testq  %rax, %rax
    jns    .LP0

    cmpb  $-1, FFLAG(%rip)
    je    .LP0

    pushq  $0
    pushq  -24(%rbp)
    leaq   errFailure(%rip), %rax
    pushq  %rax
    movq   $1, %rdi
    call   println
    jmp    .LP0

    .LS2:
    MUNMAP  -8(%rbx), $PAGE_SIZE
    EXIT    %rax

    2:
    WRITE  $1, usage(%rip), usage_len(%rip)
    EXIT   $0

    3:
    EXIT  $-1

