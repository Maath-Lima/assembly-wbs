global _start

%define SYS_write 1
%define SYS_exit 60
%define EXIT_STATUS 1
%define STDOUT 1
%define NEWLINE 0xA

; Segmento de dados
section .data
msg: db "Hello, World", NEWLINE
msgLen: equ $ - msg

section .text
_start:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Chamada de sistema
    ; glibc -> ssize_t write(int fd,const void buf[.count],size_t count)
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov rdi, STDOUT         
    mov rsi, msg
    mov rdx, msgLen
    mov rax, SYS_write
    syscall

    ; Chamada de Sistema -> void _exit(int status)
    mov rdi, EXIT_STATUS
    mov rax, SYS_exit
    syscall