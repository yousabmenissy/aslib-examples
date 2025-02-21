.section .text
.type pid_invalid, @function
pid_invalid: #  pid_invalid(str, len)
    pushq  %rdi
    pushq  %rsi
    WRITE  $1, progPrefix(%rip), progPrefix_len(%rip)
    popq   %rdx
    popq   %rsi
    WRITE  $1
    WRITE  $1, invalid_pid(%rip), invalid_pid_len(%rip)
    ret

.type pid_non, @function
pid_non: #  pid_non(str, len)
    pushq  %rdi
    pushq  %rsi
    WRITE  $1, progPrefix(%rip), progPrefix_len(%rip)
    WRITE  $1, non_pid(%rip), non_pid_len(%rip)
    popq   %rdx
    popq   %rsi
    WRITE  $1
    NEWLN  $1
    ret

.type signum_invalid, @function
signum_invalid: #  signum_invalid(str, len)
    pushq  %rdi
    pushq  %rsi
    WRITE  $1, progPrefix(%rip), progPrefix_len(%rip)
    popq   %rdx
    popq   %rsi
    WRITE  $1
    WRITE  $1, invalid_signum(%rip), invalid_signum_len(%rip)
    ret

.type isSig, @function
isSig: #  isSig(str)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $16, %rsp

    movq  %rdi, -8(%rbp)
    call  strlen
    movq  %rax, %r12
    movq  %rax, -16(%rbp)

    movq   $10, %rsi
    call   isbase
    testq  %rax, %rax
    js     1f

    call   atoi
    testq  %rax, %rax
    js     1f

    cmpq  $1, %rdi
    jb    1f
    cmpq  $64, %rdi
    ja    1f

    leave
    ret

    1:
    movq  -8(%rbp), %rdi
    movq  -16(%rbp), %rsi
    call  signum_invalid
    EXIT  $-1

.type isPID, @function
isPID: #  isPID(str)
    movq   $10, %rsi
    call   isbase
    testq  %rax, %rax
    jns    1f

    call  strlen
    movq  %rax, %rsi
    call  pid_invalid
    movq  $-1, %rax

    1:
    ret
