global _start

%define SYS_write 1
%define SYS_exit 60
%define STDOUT 1
%define NEWLINE 0xA

section .data
greet: db "Hi", NEWLINE

section .text
_start:
push greet
call .print ; jump to label .print
pop rbp     ; stack pop, rbp register is general-purpose, but it mantains the base of the stack
.exit:
    mov rdi, 0
    mov rax, SYS_exit
    syscall
.print:
    mov rdi, STDOUT         
    mov rsi, [rsp + 8] ; the "Hi" string is located 8 bytes below the top of the stack
    mov rdx, 3
    mov rax, SYS_write
    syscall
    ret                 ; return call
