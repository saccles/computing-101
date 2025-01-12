.intel_syntax noprefix
.global _start

_start:
    jmp new_location
    .rept 0x51
    nop
    .endr
    
new_location:
    pop rdi
    mov rax, 0x403000
    jmp rax
