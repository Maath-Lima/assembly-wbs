global _start

%define SYS_SOCKET 41
%define AF_INET 2
%define SOCK_STREAM 1
%define SOCK_PROTOCOL 0

%define SYS_BIND 49

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
.exit:
    mov rdi, 0
    mov rax, 60
    syscall