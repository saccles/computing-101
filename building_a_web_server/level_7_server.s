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

    # Read data from connection into buffer.
    mov rdi, rax # fd = rax

    mov r10, rdi # Save file descriptor referring to connection.

    # Save current stack state 
    # and allocate space for a 256-byte buffer.
    mov rbp, rsp
    sub rsp, 256

    lea rsi, [rbp - 256] # buf = rsi
    mov rdx, 256 # count = 256
    mov rax, 0 # Read system call.
    syscall

    # Open file specified in get request.  
    # These instructions parse the file path from the get request
    # and use the open system call to open the file at the file path.
    lea rdi, [rbp - 252] # *pathname = data in buffer starting at offset [rbp - 252]
    mov BYTE PTR [rbp - 236], 0x00 # Stop reading data from buffer after 20 bytes (null-byte).
    mov rsi, 0x00000000 # mode = O_RDONLY
    mov rax, 2 # Open system call.
    syscall

    # Free up stack memory and create a 256-byte buffer for 
    # reading in data from the file in the get request.
    mov rsp, rbp # Free up stack memory.
    sub rsp, 256 # Allocate 256 bytes of memory on the stack. 

    # Read file specified in get request into buffer.
    mov rdi, rax # fd = file descriptor of opened file specified in get request
    lea rsi, [rbp - 256] # buf = [rbp - 256]
    mov rdx, 256 # count = 256
    mov rax, 0 # Read system call.
    syscall

    mov r8, rax # Save number of bytes read in from file descriptor specified in get request.

    # Close file descriptor referring to specified file in get request.
    mov rax, 3 # Close system call.
    syscall

    # Write static http response message over connection.
    mov rdi, r10 # fd = file descriptor referring to connection
    lea rsi, [HTTP_RESPONSE] # buf = [HTTP_RESPONSE]
    mov rdx, 19 # count = 19
    mov rax, 1 # Write system call.
    syscall

    # Write contents of requested file over connection.
    lea rsi, [rbp - 256] # buf = [rbp - 256]
    mov rdx, r8 # count = r8 (number of bytes read in from specified file)
    mov rax, 1 # Write system call.
    syscall

    # Free up stack memory.
    mov rsp, rbp

    # Close file descriptor referring to connection.
    mov rax, 3 # Close system call.
    syscall

    # Exit with status code 0.
    mov rdi, 0 
    mov rax, 60 # Exit system call.
    syscall

# Constants that are used in the main program.
.section .data
    DOMAIN: 
        .int 2 # domain=AF_INET
    TYPE: 
        .int 1 # type=SOCK_STREAM
    PROTOCOL: 
        .int 0 # protocol=IPPROTO_IP
    HTTP_RESPONSE:
        .string "HTTP/1.0 200 OK\r\n\r\n" # Static response to an http request.
