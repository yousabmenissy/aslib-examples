.section .data
veflags:
.string "-v"
.string "--verbose"
.quad 0

hflags:
.string "-h"
.string "--help"
.quad 0

rflags:
.string "-r"
.string "--recursive"
.quad 0

fflags:
.string "-f"
.string "--force"
.quad 0

bflags:
.string "-v"
.string "--verbose"
.string "-h"
.string "--help"
.string "-r"
.string "--recursive"
.string "-f"
.string "--force"
.quad 0

VFLAG: .byte 0
RFLAG: .byte 0
FFLAG: .byte 0
log_rm: .string "removed"
log_rm_len: .quad .-log_rm

errFailure: .string "rm: could not remove"
errFailure_len: .quad .-errFailure

usage: .string "Usage: rm [options] file...\n"
usage_len: .quad . - usage

.section .bss
.lcomm statbuff, 144
