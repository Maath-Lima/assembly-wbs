global _start

%define SYS_write 1
%define SYS_exit 60
%define STDOUT 1
%define NEWLINE 0xA

section .data
greet: db "Hi", NEWLINE, 0

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
    mov rsi, [rsp + 8] ; the "Hi" string is located 8 bytes below the top of the stack
    mov r9, rsi
    mov rdx, 0
.calculate_size:
    inc rdx
    inc r9             ; increment R9 register to consume the string bytes until zero
                       ; and preserving the RSI value
    cmp byte [r9], 0x00
    jz .done           ; jump if zero
    jmp .calculate_size
.done:
    mov rdi, STDOUT         
    mov rax, SYS_write
    syscall
    ret                ; return call
