global _start

%define SYS_write 1
%define SYS_exit 60
%define STDOUT 1
%define NEWLINE 0xA

section .data
greet: db "Hi", NEWLINE

section .text
_start:
call .print ; jump to label .print
.exit:
    mov rdi, 0
    mov rax, SYS_exit
    syscall
.print:
    mov rdi, STDOUT         
    mov rsi, greet
    mov rdx, 3
    mov rax, SYS_write
    syscall
    ret                 ; return call
