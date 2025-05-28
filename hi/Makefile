# Makefile for first_program.asm

ASM = nasm
ASMFLAGS = -f elf64 -g			      # elf64 format + debug info for gdb
LD = ld

SRC = hi.asm
OBJ = hi.o
EXE = hi

all: $(EXE)

$(OBJ): $(SRC)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(EXE): $(OBJ)
	$(LD) -o $@ $^

clean:
	rm -f $(OBJ) $(EXE)

.PHONY: all clean
