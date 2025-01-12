.intel_syntax noprefix
.global _start

# Input data to test the program if an error occurs.
#.section .data
#test_data:
#    .byte 0x07, 0x02, 0x07, 0x01, 0x07, 0x04

.section .text

_start:

    # Code goes along with above input data
    # for troubleshooting and debugging purposes. 
    #lea rdi, [test_data]
    #mov rsi, 6
    #call compute_most_common_byte
    #mov rdi, rax
    #mov eax, 60
    #syscall

compute_most_common_byte:    
    #lea rdi, [test_data]
    #mov rsi, 6
    mov rbp, rsp
    sub rsp, 0x200 # Allocate 256 * 2 bytes on the stack. 
    mov rcx, 0 # Loop counter for 256 words.
    mov rdx, rsp # Destination address (start of the array).

# Set every entry in the array to 0.
zero_array_loop:
    mov WORD PTR [rdx], 0
    add rdx, 2
    inc rcx
    cmp rcx, 255
    jbe zero_array_loop

mov rcx, 0 # Set loop counter to 0. 
dec rsi # Decrement size for comparison purposes.

# Iterate over the array to count the frequency of each byte.
count_byte_frequency_loop_header:
    cmp rcx, rsi
    jbe count_byte_frequency_loop_body
    jmp find_most_common_byte_setup

count_byte_frequency_loop_body:
    mov dl, BYTE PTR [rdi+rcx]
    movzx rdx, dl
    lea rax, [rsp+(rdx*2)]
    movzx rbx, WORD PTR [rax]
    inc bx
    mov [rax], bx
    inc rcx
    jmp count_byte_frequency_loop_header

find_most_common_byte_setup:
    mov r8, 0
    mov r9, 0
    mov r10, 0
    
# Iterate over all possible byte values to determine the most
# common byte.
find_most_common_byte_loop_header:
    cmp r8, 0xff
    jbe find_most_common_byte_loop_body
    jmp return

find_most_common_byte_loop_body:
    cmp WORD PTR [rsp+(r8*2)], r9w
    jg set_new_most_common_byte
    jmp find_most_common_byte_loop_incrementor

set_new_most_common_byte:
    mov r9w, WORD PTR [rsp+(r8*2)]
    mov r10, r8
    jmp find_most_common_byte_loop_incrementor

find_most_common_byte_loop_incrementor:
    inc r8
    jmp find_most_common_byte_loop_header

# Restore the stack and return the most common byte.
return:
    mov rsp, rbp
    mov rax, r10 
    ret
