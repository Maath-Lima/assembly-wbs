# Building a web server with Assembly x86

### Reference link
[Series](https://dev.to/leandronsp/construindo-um-web-server-em-assembly-x86-parte-i-introducao-14p5)

## History and more
> Writing computer programs involves manipulating finite memory and I/O data devices through instructions executed by the CPU.

Our program deals with memory manipulation everytime.
* Memory Hierarchy

1. Registers
2. CPU Cache
3. RAM
4. Mass storage device

The CPU does not only interacts with RAM but also with other storage devices managed by the computational system.

> Everything (or almost) is memory. (data or instructions)

The OS abstract a program's location in the memory hierarchy, freeing it from needing to know the physical implementation.

### CPU Clock
> To execute an instruction the CPU needs at least one clock cicle.

The decision about how many clock cycles an instruction takes is determined during CPU design.

| **Reminder**: Instructions live in memory.

**CPU timeline**

Search instruction in memory > decode > execute > storage output in memory  

### Registers
> Outputs from CPU are stored in something inside the CPU itself instead of main memory for a faster operation. **REGISTERS**. 

**Tradeoffs**
In the memory hierarchy, the closer a memory is to the CPU, the faster it can be accessed. However, this also means the memory is more volatile and has lower storage capacity.

Registers are components where the CPU stores instructions and data for the program being executed.

**ISA** - Instruction Set Architecture

### ISA
**CISC**
> Complex Instruction Set Computing

**RISC**
> Reduced Instruction Set Computing, architecture designed with simpler and fewer instructions, resulting in fewer CPU clock cycles. 

Fixed length instructions: Faster and predictable performance.

> ARM is **RISC**.

* x86 is a "fake-CISC" architecture because of adaptations to support operations found in RISC architecture.

## About Computer Programs
To resolve concurrency issues in memory access or output between program instructions, we need to isolate them from other programs by grouping them.

> One of the OS roles and a concept: processes.

Every program is encapsulated in a process that has its own virtual space in main memory.

### Opcodes
> x64 defines a set of **opcodes** that represent the available instructions, registers, etc.

### Endianness
> Property to define bit significance.

**Little endian vs Big endian**

## Hello, World!
Next, write a programa that outputs the classic "Hello, World".

* Allocate memory for "Hello, World" string
* Write the string in the output STDOUT
* Exit the program

### ASCII
```
H: 0x48     
e: 0x65     
l: 0x6C     
l: 0x6C     
o: 0x6F
,: 0x2C

W: 0x57
o: 0x6F
r: 0x72
l: 0x6C
d: 0x64
```
> 0x is a notation to indicate that the number after *x* it's a hexadecimal.

**Table**: [System calls table](https://x64.syscall.sh/)

