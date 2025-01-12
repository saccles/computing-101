.intel_syntax noprefix
.global _start

_start:
    mov rax, [0x404000] 
    add QWORD PTR [0x404000], 0x1337



