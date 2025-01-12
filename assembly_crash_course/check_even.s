.intel_syntax noprefix
.global _start

_start:
    and rax, 0
    or rax, 1
    and rdi, 1
    xor rax, rdi
