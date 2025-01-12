.intel_syntax noprefix
.global _start

_start:
    pop rax
    sub rax, rdi
    push rax
