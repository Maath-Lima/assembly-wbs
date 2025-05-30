global _start

%define SYS_SOCKET 41
%define AF_INET 2
%define SOCK_STREAM 1
%define SOCK_PROTOCOL 0

sction .bss ; not-initialized data
sockfd: resb 1

section .text
_start:
.socket:
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, SOCK_PROTOCOL
    mov rax, SYS_SOCKET
    syscall
    mov [sockfd], rax
.exit:
    mov rdi, 0
    mov rax, 60
    syscall