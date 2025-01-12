.intel_syntax noprefix
.global _start

_start:
    mov rax, [rdi]
    add rax, [rdi+8]
    mov [rsi], rax
