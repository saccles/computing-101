.intel_syntax noprefix
.global _start

_start:
    jmp new_location
    .rept 0x51
    nop
    .endr

new_location:
    mov rax, 0x1
