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