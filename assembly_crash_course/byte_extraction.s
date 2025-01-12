.intel_syntax noprefix
.global _start

_start:
    mov rax, 0
    shr rdi, 32
    mov al, dil

