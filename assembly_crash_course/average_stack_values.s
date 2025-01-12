.intel_syntax noprefix
.global _start

_start:
    mov rax, 0
    mov rdx, 0
    mov rbx, 4
    add rax, [rsp]
    add rax, [rsp+8]
    add rax, [rsp+16]
    add rax, [rsp+24]
    div rbx
    push rax
