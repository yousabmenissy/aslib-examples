.include "aslib/aslib.s"
.section .text
.global _start
_start:
    movq  %rsp, %rbp
    subq  $16, %rsp

    movq  (%rbp), %rax
    movq  %rax, -8(%rbp)
    movq  %rbp, %rbx
    addq  $8, %rbx
    movq  $SIGTERM, %r14

    cmpq  $1, -8(%rbp)
    je    2f

    cmpq  $2, -8(%rbp)
    jne   .LS0

    leaq   help_flags(%rip), %rdi
    leaq   8(%rbx), %rsi
    call   vflagb
    testq  %rax, %rax
    jns    2f

    leaq   list_flags(%rip), %rdi
    leaq   8(%rbx), %rsi
    call   vflagb
    testq  %rax, %rax
    jns    3f

    .LS0:
    leaq   signum_flags(%rip), %rdi
    leaq   8(%rbx), %rsi
    call   vflags
    testq  %rax, %rax
    js     .LS1

    movq  %rax, %rdi
    call  isSig

    .LS1:
    movq  -8(%rbp), %rdi
    movq  %rbx, %rsi
    leaq  signum_flags(%rip), %rdx
    leaq  bool_flags(%rip), %rcx
    call  parseargs

    testq  %rax, %rax
    js     1f
    movq   %rax, -16(%rbp)
    movq   -16(%rbp), %rbx
    addq   $8, %rbx

    movq  $-1, %r12

    .LP0:
    incq  %r12
    movq  (%rbx, %r12, 8), %rdi
    cmpq  $0, %rdi
    je    .LS2

    call   isPID
    testq  %rax, %rax
    cmovs  %rax, %r13   # Invalid flag

    jmp  .LP0

    .LS2:
    testq  %r13, %r13
    js     1f   # If invalid end it here

    movq  $-1, %r12

    .LP1:
    incq  %r12
    movq  (%rbx, %r12, 8), %rdi
    cmpq  $0, %rdi
    je    .LS3

    movq   %rdi, %r13
    call   atoi
    KILL   %rax, %r14  # Show time!
    testq  %rax, %rax
    jns    .LP1

    movq  %r13, %rdi
    call  strlen
    movq  %rax, %rsi
    movq  %r13, %rdi
    call  pid_non

    jmp  .LP1

    .LS3:
    MUNMAP  -16(%rbp), $PAGE_SIZE
    EXIT    %rax

    1:
    EXIT  $-1

    2:
    WRITE  $1, usage(%rip), usage_len(%rip)
    EXIT   $0

    3:
    WRITE  $1, signums(%rip), signums_len(%rip)
    EXIT   $0

