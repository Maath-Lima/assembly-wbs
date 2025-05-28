# Makefile for first_program.asm

ASM = nasm
ASMFLAGS = -f elf64 -g			      # elf64 format + debug info for gdb
LD = ld

SRC = first_program.asm
OBJ = first_program.o
EXE = first_program

all: $(EXE)

$(OBJ): $(SRC)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(EXE): $(OBJ)
	$(LD) -o $@ $^

clean:
	rm -f $(OBJ) $(EXE)

.PHONY: all clean
