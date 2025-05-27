global _start

; Segmento de dados
section .data
msg: db "Hello, World", 0xA

section .text
_start:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Chamada de sistema
    ; glibc -> ssize_t write(int fd,const void buf[.count],size_t count)
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov rdi, 1          ; STDOUT
    mov rsi, msg
    mov rdx, 13         ; quantiade de bytes a serem escritos
    mov rax, 1          ; nome da syscall
    syscall

    ; Chamada de Sistema -> void _exit(int status)
    mov rdi, 0
    mov rax, 60
    syscall