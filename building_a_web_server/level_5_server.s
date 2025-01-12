.intel_syntax noprefix

.section .text
    .global _start

_start:
    # Create tcp socket.
    mov edi, DWORD PTR [DOMAIN] # Load the socket's domain (edi because of DWORD).
    mov esi, DWORD PTR [TYPE] # Load the socket's type (esi because of DWORD).
    mov edx, DWORD PTR [PROTOCOL] # Load the socket's protocol (edx because of DWORD).
    mov rax, 41 # Socket system call. 
    syscall

    # Save current state of the stack.
    mov rbp, rsp

    # Create 16-byte sock_addr struct on the stack.
    sub rsp, 16
    mov WORD PTR [rbp - 16], 2 # sin_family = AF_INET
    mov WORD PTR [rbp - 14], 0x5000 # sin_port = htons(80)
    mov DWORD PTR [rbp - 12], 0x00000000 # sin_addr = inet_aton("0.0.0.0")
    mov QWORD PTR [rbp - 8], 0 # padding for struct to equal 16 bytes 

    mov rdi, rax # sockfd = rax
    lea rsi, [rbp - 16] # addr = *sockaddr_in
    mov rdx, 16 # addrLen = 16
    mov rax, 49 # Bind system call.
    syscall

    # Free up stack memory.
    mov rsp, rbp
    
    mov rsi, 0 # backLog = 0
    mov rax, 50 # Listen system call.
    syscall

    # Accept first connection request on pending connection queue.
    mov rsi, 0 # addr = NULL
    mov rdx, 0 # addrLen = NULL
    mov rax, 43 # Accept system call.
    syscall

    # Exit with status code 0.
    mov rdi, 0 
    mov rax, 60 # Exit system call.
    syscall

# Constants that are used in the main program.
.section .data
    DOMAIN: .int 2 # domain=AF_INET
    TYPE: .int 1 # type=SOCK_STREAM
    PROTOCOL: .int 0 # protocol=IPPROTO_IP

