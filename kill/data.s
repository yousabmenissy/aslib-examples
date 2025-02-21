.section .data
    usage: 
        .ascii "Usage: kill <PID>... [-n | --signum] | kill [-l | --list]\n"
        .ascii "     Send a signal to a job.\n\n"
        .ascii "     Send the processes identified by PID the signal named by SIGNUM or list all signals.\n"
        .ascii "     SIGNUM can be specified by [-n  | --signum]. SIGTERM is the default\n\n"
        .ascii "     Options:\n"
        .ascii "     -n, --signum    the signal number\n"
        .ascii "     -l, --list      list all signals\n"
        .ascii "     -h, --help      show this message\n\n"
        .ascii "     this is a simple assembly clone of the gnu kill utility.\n"
        .ascii "     It's meant to serve as a working example for how to use the aslib library\n\0"
    usage_len: .quad .-usage

    signums:
        .ascii " 1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP\n"
        .ascii " 6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1\n"
        .ascii "11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM\n"
        .ascii "16) SIGSTKFLT	17) SIGCHLD	18) SIGCONT	19) SIGSTOP	20) SIGTSTP\n"
        .ascii "21) SIGTTIN	22) SIGTTOU	23) SIGURG	24) SIGXCPU	25) SIGXFSZ\n"
        .ascii "26) SIGVTALRM	27) SIGPROF	28) SIGWINCH	29) SIGIO	30) SIGPWR\n"
        .ascii "31) SIGSYS	34) SIGRTMIN	35) SIGRTMIN+1	36) SIGRTMIN+2	37) SIGRTMIN+3\n"
        .ascii "38) SIGRTMIN+4	39) SIGRTMIN+5	40) SIGRTMIN+6	41) SIGRTMIN+7	42) SIGRTMIN+8\n"
        .ascii "43) SIGRTMIN+9	44) SIGRTMIN+10	45) SIGRTMIN+11	46) SIGRTMIN+12	47) SIGRTMIN+13\n"
        .ascii "48) SIGRTMIN+14	49) SIGRTMIN+15	50) SIGRTMAX-14	51) SIGRTMAX-13	52) SIGRTMAX-12\n"
        .ascii "53) SIGRTMAX-11	54) SIGRTMAX-10	55) SIGRTMAX-9	56) SIGRTMAX-8	57) SIGRTMAX-7\n"
        .ascii "58) SIGRTMAX-6	59) SIGRTMAX-5	60) SIGRTMAX-4	61) SIGRTMAX-3	62) SIGRTMAX-2\n"
        .ascii "63) SIGRTMAX-1	64) SIGRTMAX\n\0"
    signums_len: .quad .-signums

    progPrefix:         .string "kill: "
    progPrefix_len:     .quad .-progPrefix

    invalid_pid:        .string " is not a proccess id\n"
    invalid_pid_len:    .quad .-invalid_pid

    non_pid:            .string "could not find process with id "
    non_pid_len:        .quad .-non_pid

    invalid_signum:     .string " is not a signal number\n"
    invalid_signum_len: .quad .-invalid_signum

    signum_flags:
        .string "-n"
        .string "--signum"
        .quad 0

    bool_flags:
        .string "-h"
        .string "--help"
        .string "-l"
        .string "--list"
        .string "-L"
        .quad 0

    help_flags:
        .string "-h"
        .string "--help"
        .quad 0

    list_flags:
        .string "-l"
        .string "--list"
        .string "-L"
        .quad 0

