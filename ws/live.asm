global _start

%define SYS_SOCKET 41
%define SYS_bind 49
%define SYS_listen 50
%define SYS_accept4 288
%define SYS_write 1
%define SYS_close 3
%define SYS_futex 202

%define SYS_nanosleep 35
%define SYS_clone 56
%define SYS_brk 12
%define SYS_exit 60

%define AF_INET 2
%define SOCK_STREAM 1
%define SOCK_PROTOCOL 0
%define BACKLOG 2
%define CR 0xD
%define LF 0xA

%define CHILD_STACK_SIZE 4096
%define CLONE_VM 0x00000100
%define CLONE_FS 0x00000200
%define CLONE_FILES 0x00000400
%define CLONE_PARENT 0x00008000
%define CLONE_THREAD 0x00010000
%define CLONE_IO 0x80000000
%define CLONE_SIGHAND 0x00000800
%define FUTEX_WAIT 0
%define FUTEX_WAKE 1
%define FUTEX_PRIVATE_FLAG 128

section .data
sockaddr:
    family: dw AF_INET
    port: dw 0xB80B     ; 3000 port (bytes reversed for internet byte order big-endian)
    ip_address: dd 0
    sin_zero: dq 0
response:
    headline: db "HTTP/1.1 200 OK", CR, LF              ; CR and LF represents \r\n
    content_type: db "Content-Type: text/html", CR, LF
    content_length: db "Content-Length: 22", CR, LF
    crlf: db CR, LF
    body: db "<h1>Hello, World!</h1>"
responseLen: equ $ - response
timespec:
    tv_sec: dq 1
    tv_nsec: dq 0
queuePtr: db 0
section .bss
sockfd: resb 8
queue: resb 8
condvar: resb 8

section .text
_start:
.initialize_pool:
    mov r8, 0
.pool:
    call thread
    inc r8
    cmp r8, 5
    je .socket
    jmp .pool
.socket:
    ; int socket(int domain. int type, int protocol)
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, SOCK_PROTOCOL
    mov rax, SYS_SOCKET
    syscall
    mov [sockfd], rax
.bind:
    ; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
    mov rdi, [sockfd]
    mov rsi, sockaddr
    mov rdx, 16
    mov rax, SYS_bind
    syscall
.listen:
    ; int listen(int sockfd, int backlog)
    mov rdi, [sockfd]
    mov rsi, BACKLOG
    mov rax, SYS_listen
    syscall
.accept:
    ; int accept(int sockfd, struct *addr, int addrlen, int flags)
    mov rdi, [sockfd]
    mov rsi, 0
    mov rdx, 0
    mov r10, 0
    mov rax, SYS_accept4
    syscall
    
    mov r8, rax          ; client socket
    call enqueue

    jmp .accept
enqueue:
    xor rdx, rdx           ; clear (0) rdx register
    mov dl, [queuePtr]
    mov [queue + rdx], r8
    inc byte [queuePtr]

    call emit_signal
    ret
emit_signal:
    mov rdi, condvar
    mov rsi, FUTEX_WAKE | FUTEX_PRIVATE_FLAG
    
    xor rdx, rdx
    xor r10, r10
    xor r8, r8

    mov rax, SYS_futex
    syscall
    ret
thread:
    mov rdi, 0
    mov rax, SYS_brk
    syscall
    mov rdx, rax

    mov rdi, rax
    add rdi, CHILD_STACK_SIZE
    mov rax, SYS_brk
    syscall

    mov rdi, CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_PARENT|CLONE_THREAD|CLONE_IO
    lea rsi, [rdx + CHILD_STACK_SIZE - 8]
    mov qword [rsi], handle ; Return address when thread starts. When the thread start, it'll jump to handle
    mov rax, SYS_clone
    syscall
    ret
handle:
    cmp byte [queuePtr], 0
    je .wait

    call dequeue
    mov r10, rax

    lea rdi, [timespec]
    mov rax, SYS_nanosleep
    syscall

    ; write
    mov rdi, r10
    mov rsi, response
    mov rdx, responseLen
    mov rax, SYS_write
    syscall

    ; close
    mov rdi, r10
    mov rax, SYS_close
    syscall

    jmp handle
.wait:
    call wait_condvar
    jmp handle
wait_condvar:
    mov rdi, condvar

    mov rsi, FUTEX_WAIT | FUTEX_PRIVATE_FLAG
   xor rdx, rdx
   xor r10, r10              
   xor r8, r8               
   mov rax, SYS_futex
   syscall

   test rax, rax
   jz .done_condvar
.done_condvar:
   ret
dequeue:
    xor rax, rax
    xor rsi, rsi

    mov al, [queue]
    mov rcx, 0
.loop_dequeue:
    cmp byte [queuePtr], 0
    je .return_dequeue

    cmp cl, [queuePtr]
    je .done_dequeue

    ; shift
    xor r10, r10
    mov r10b, [queue + rcx + 1]
    mov byte [queue + rcx], r10b

    inc rcx
    jmp .loop_dequeue
.done_dequeue:
    dec byte [queuePtr]
.return_dequeue:
    ret
.exit:
    mov rdi, 0
    mov rax, 60
    syscall