.intel_syntax noprefix
.global _start

_start:
    mov rax, 0x403000
    jmp rax
