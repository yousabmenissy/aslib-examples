.global getmode
.type getmode, @function
getmode: # getmode(str)
    pushq  %rbp
    movq   %rsp, %rbp

    pushq  %rdi
    movq   $0, %rsi
    call   xtoi
    popq   %rdi

    testq  %rax, %rax
    js     2f
    cmpq   $0777, %rax
    jna    2f

    1:
    pushq  $0
    pushq  %rdi
    movq   $1, %rdi
    leaq   modeErr(%rip), %rsi
    call   printf
    EXIT   $-1

    2:
    leave
    ret
