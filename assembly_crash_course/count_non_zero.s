.intel_syntax noprefix
.global _start

_start:
    mov rbx, 0
    mov rcx, 0

    cmp rdi, 0
    jne get_loop_status
    jmp done

get_loop_status:
    cmp BYTE PTR [rdi+rbx], 0
    jne loop
    jmp done

loop:
    add rbx, 1
    add rcx, 1
    jmp get_loop_status

done:
    mov rax, rcx
