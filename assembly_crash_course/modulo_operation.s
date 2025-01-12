.intel_syntax noprefix
.global _start

_start:
    mov rax, rdi
    mov rdx, 0
    div rsi
    mov rax, rdx
