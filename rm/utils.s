.global rrm
.type rrm, @function
rrm: # rrm(str)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $16, %rsp

    movq  %rdi, -8(%rbp)

    STAT   (%rdi), statbuff(%rip)
    testq  %rax, %rax
    js     2f

    leaq     statbuff(%rip), %rax
    movq     24(%rax), %rax
    S_ISDIR  %rax
    testq    %rax, %rax
    jns      1f

    movq  -8(%rbp), %rdi
    UNLINK
    jmp   2f

    1:
    movq    -8(%rbp), %rsi
    OPENAT  $AT_FDCWD, (%rsi), $O_DIRECTORY
    movq    %rax, -16(%rbp)
    movq    %rax, %rdi
    call    rrmdir

    movq      -8(%rbp), %rsi
    UNLINKAT  $AT_FDCWD, (%rsi), $AT_REMOVEDIR

    2:
    leave
    ret

.global rrmdir
.type rrmdir, @function
rrmdir: # rrmdir(dirfd)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $4112, %rsp
    pushq  %rbx
    movq   %rdi, -4112(%rbp)

    GETDENTS  %rdi, -4096(%rbp), $4096
    testq     %rax, %rax
    jz        3f

    movq  %rax, %r8

    leaq  -4096(%rbp), %rbx
    addq  $48, %rbx  # Skip the special entries '.' and '..'
    subq  $48, %r8

    .LPRRM0:
    cmpq  $0, %r8
    je    3f

    movzwq  16(%rbx), %rdx
    movzbq  18(%rbx), %rax
    leaq    19(%rbx), %rdi

    addq  %rdx, %rbx
    subq  %rdx, %r8

    cmpq  $(S_IFDIR >> 12), %rax  # Is it a directory?
    jne   2f

    movq    %rdi, -4104(%rbp)
    movq    %rdi, %rsi
    OPENAT  -4112(%rbp), (%rsi), $O_DIRECTORY
    movq    %rax, %rdi
    pushq   %r8
    call    rrmdir
    popq    %r8

    movq      -4104(%rbp), %rsi
    UNLINKAT  -4112(%rbp), (%rsi), $AT_REMOVEDIR
    testq     %rax, %rax
    jns       1f
    cmpb      $-1, FFLAG(%rip)
    je        .LPRRM0

    pushq  $0
    leaq   errFailure(%rip), %rax
    pushq  %rax
    pushq  %rsi
    movq   $1, %rdi
    call   println

    1:
    cmpb   $-1, VFLAG(%rip)
    jne    .LPRRM0
    movq   %rsi, %rdi
    pushq  %r8
    call   log
    popq   %r8
    jmp    .LPRRM0

    2:
    movq      %rdi, %rsi
    UNLINKAT  -4112(%rbp), (%rsi), $0
    testq     %rax, %rax
    jns       1f
    cmpb      $-1, FFLAG(%rip)
    je        .LPRRM0

    pushq  $0
    leaq   errFailure(%rip), %rax
    pushq  %rax
    pushq  %rsi
    movq   $1, %rdi
    call   println

    1:
    cmpb   $-1, VFLAG(%rip)
    jne    .LPRRM0
    movq   %rsi, %rdi
    pushq  %r8
    call   log
    popq   %r8

    jmp  .LPRRM0

    3:
    popq  %rbx
    leave
    ret

.global delete
.type delete, @function
delete: # delete(str)
    pushq  %rbp
    movq   %rsp, %rbp

    movq  %rdi, -8(%rsp)
    movq  $0, -16(%rsp)

    STAT   (%rdi), statbuff(%rip)
    testq  %rax, %rax
    js     2f

    leaq     statbuff(%rip), %rax
    movq     24(%rax), %rax
    S_ISDIR  %rax
    testq    %rax, %rax
    js       1f
    movq     $AT_REMOVEDIR, -16(%rsp)

    1:
    movq      -8(%rsp), %rsi
    UNLINKAT  $AT_FDCWD, (%rsi), -16(%rsp)

    cmpb   $-1, VFLAG(%rip)
    jne    .LPRRM0
    movq   %rsi, %rdi
    pushq  %r8
    call   log
    popq   %r8

    2:
    leave
    ret

.global log
.type log, @function
log: # log(str)
    pushq  %rbp
    movq   %rsp, %rbp

    leaq   log_rm(%rip), %rax
    pushq  $0
    pushq  %rdi
    pushq  %rax
    movq   $1, %rdi
    call   println
    leave
    ret
