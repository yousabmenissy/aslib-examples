.section .data
    mflag: 
        .string "-m"
        .string "--mode"
        .quad 0

    hflags:
        .string "-h"
        .string "--help"
        .quad 0

    usage: 
        .ascii "Usage: mkdir <dirname>... [-m | --mode]\n"
        .ascii "     Create the DIRECTORY(ies), if they do not already exist.\n\n"
        .ascii "     Options:\n"
        .ascii "     -m, --mode     set file mode. default is 0777\n"
        .ascii "     -h, --help      show this message\n\n"
        .ascii "     this is a simple assembly clone of the gnu mkdir utility.\n"
        .ascii "     It's meant to serve as a working example for how to use the aslib library\n\0"
    usage_len: .quad . - usage

    modeErr: .string "mkdir: invalid mode '{s}'\n"
    mkdirErr: .string "mkdir: could not create directory '{s}'\n"
    