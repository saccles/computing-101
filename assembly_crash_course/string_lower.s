.intel_syntax noprefix
.global _start

_start:
string_to_lowercase:
    mov rsi, 0

    cmp rdi, 0
    jne if_body 
    jmp return

if_body:
    jmp while_loop_header

while_loop_header:
    mov rdx, rdi
    cmp BYTE PTR [rdi], 0x00
    jne while_loop_body
    jmp return

while_loop_body:
    cmp BYTE PTR [rdi], 0x5a
    jle nested_if_body
    add rdi, 1
    jmp while_loop_header

nested_if_body:
    mov dil, BYTE PTR [rdi]
    mov rax, 0x403000
    call rax
    mov BYTE PTR [rdx], al
    mov rdi, rdx
    add rsi, 1
    add rdi, 1
    jmp while_loop_header

return:
    mov rax, rsi
    ret
    
