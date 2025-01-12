.intel_syntax noprefix
.global _start

_start:
    mov rax, 0xdeadbeef00001337
    mov [rdi], rax
    mov rax, 0xc0ffee0000
    mov [rsi], rax
