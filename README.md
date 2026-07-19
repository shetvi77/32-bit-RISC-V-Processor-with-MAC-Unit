# 32-bit-RISC-V-Processor-with-MAC-Unit
Design of a 32-bit Single-Cycle RISC-V Processor with Memory-Mapped MAC Unit for Machine Learning Acceleration

This project implements a **32-bit single-cycle RISC-V processor** in **Verilog HDL** using **Xilinx Vivado**. The processor follows an RV32I-style datapath and supports basic arithmetic, logical, memory, and branch instructions. After verifying the base processor, a **memory-mapped MAC / neuron accelerator** was integrated to demonstrate AI-style hardware acceleration using standard RISC-V `lw` and `sw` instructions.

The main goal of this project was to understand how a processor datapath works at RTL level and how a custom hardware accelerator can be connected to a processor without modifying the instruction set.

## Project Overview

The project is divided into two major parts:

1. **Base 32-bit Single-Cycle RISC-V Processor**
   - Implements a basic RV32I-style datapath.
   - Supports arithmetic, logical, load/store, and branch instructions.
   - Each processor block was designed as a separate Verilog module.
   - Individual modules were verified using separate testbenches.
   - The full processor was simulated using a machine-code test program.

2. **Memory-Mapped MAC / Neuron Accelerator**
   - Implements a Multiply-Accumulate based neuron computation.
   - Computes:

     ```text
     Y = X0*W0 + X1*W1 + X2*W2 + X3*W3 + BIAS
     ```

   - Integrated using a memory-mapped interface.
   - Controlled by the RISC-V processor using standard `sw` and `lw` instructions.
   - Does not require custom RISC-V instructions.
   - Final simulation verified result `Y = 39`.

## Key Features

- 32-bit single-cycle RISC-V processor
- Modular RTL design in Verilog HDL
- RV32I-style instruction support
- 32 general-purpose registers
- Register `x0` hardwired to zero
- Program Counter with sequential and branch update logic
- ALU supporting arithmetic and logical operations
- Separate Main Control Unit and ALU Control Unit
- Data Memory for load/store operations
- Immediate Generator for I-type, S-type, B-type, and U-type instructions
- Memory-mapped MAC / neuron accelerator
- Address decoder for selecting normal memory or accelerator
- Vivado behavioral simulation and waveform verification
- RTL schematic generation

## Supported Instruction Set

| Instruction Type | Instructions Implemented | Purpose |
|---|---|---|
| R-type | `add`, `sub`, `and`, `or`, `slt` | Register-to-register ALU operations |
| I-type | `addi`, `lw` | Immediate arithmetic and load operation |
| S-type | `sw` | Store register data into memory or accelerator |
| B-type | `beq` | Conditional branch |
| U-type | `lui` | Optional upper immediate path |
