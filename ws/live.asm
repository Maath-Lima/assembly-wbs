global _start

%define SYS_SOCKET 41
%define AF_INET 2
%define SOCK_STREAM 1
%define SOCK_PROTOCOL 0

%define SYS_BIND 49

%define SYS_listen 50
%define BACKLOG 2

%define SYS_accept 288

%define SYS_write 1
%define CR 0XD
%define LF 0XA

%define SYS_close 3

%define SYS_nanosleep 35

%define SYS_fork 57

section .bss ; not-initialized data
sockfd: resb 1

; Data types in asm
; (db) byte => 1 byte
; (dw) word => 2 bytes
; (dd) doubleword => 4 bytes
; (dq) quadword => 8 bytes

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

section .text
_start:
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
    mov rax, SYS_BIND
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
    mov rax, SYS_accept
    syscall
    mov r8, rax          ; client socket

    ; process SYS_fork
    mov rax, SYS_fork
    syscall

    ; if zero = execution through a child process
    test rax, rax
    jz handle

    ; if not, main program execution
    jmp .accept          ; server loop
handle:
    ; int nanosleep(timespec duration)
    lea rdi, [timespec]
    mov rax, SYS_nanosleep
    syscall    

    ; int write(int fd, buffer *bf, int bfLen)
    mov rdi, r8
    mov rsi, response
    mov rdx, responseLen
    mov rax, SYS_write
    syscall

    ; int close(int fd)
    mov rdi, r8
    mov rax, SYS_close
    syscall
    ret
.exit:
    mov rdi, 0
    mov rax, 60
    syscall