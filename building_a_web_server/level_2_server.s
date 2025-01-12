.intel_syntax noprefix
.global _start

.section .text

_start:
    # Create tcp socket.
    mov edi, DWORD PTR [DOMAIN] # Load the socket's domain (edi because of DWORD).
    mov esi, DWORD PTR [TYPE] # Load the socket's type (esi because of DWORD).
    mov edx, DWORD PTR [PROTOCOL] # Load the socket's protocol (edx because of DWORD).
    mov rax, 41 # Socket system call. 
    syscall

    # Exit with status code 0.
    mov rdi, 0 
    mov rax, 60 # Exit system call.
    syscall

# Constants that are used in the main program.
.section .data
    DOMAIN: .int 2 # AF_INET
    TYPE: .int 1 # SOCK_STREAM
    PROTOCOL: .int 0 # IPPROTO_IP

