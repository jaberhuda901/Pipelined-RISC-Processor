# Pipelined RISC Processor RTL Design & Verification

pipelined-risc-processor/
├── rtl/
│   ├── risc_iunit.v
│   ├── risc_decode.v
│   ├── risc_regfile.v
│   └── risc_eunit.v
├── tb/
│   ├── risc_iunit_tb.v
│   ├── risc_decode_tb.v
│   ├── risc_regfile_tb.v
│   └── risc_eunit_tb.v
├── docs/
│   └── Lab4_report.pdf
└── README.md

## Project Overview
This repository contains the synthesis-ready RTL microarchitecture design and testbench verification for a 4-stage pipelined RISC (Reduced Instruction Set Computer) processor implemented in Verilog HDL. The processor features an optimized data and control path capable of executing 16 distinct arithmetic, logical, shift, and memory-mapped instructions (Load/Store), bound by synchronous control logic and active-low resets (`rst_n`).

The design prioritizes modular frontend design practices, explicit instruction parsing boundaries, and robust functional verification across submodules using ModelSim.

## Microarchitecture Specification
* **Instruction Word Width:** 13-bit custom instruction set format.
* **Datapath Width:** 8-bit registers and data busses.
* **Pipeline Depth:** 4 functional stages (Fetch, Decode, Execute, Register Write-Back).
* **Memory Addressing:** 5-bit Program Counter (supporting up to 32 instruction locations); 4-bit data memory addressing space.
* **Register Configuration:** General-purpose 8×8-bit Register File.

---

## Instruction Set Architecture (ISA) & Format

Instructions are dynamically parsed by the Decoder according to their structural class:

### 1. Arithmetic & Logical Formats
| Bit [12:9] | Bit [8:6] | Bit [5:3] | Bit [2:0] |
| :--- | :--- | :--- | :--- |
| Opcode (4 bits) | Operand A Address (3 bits) | Operand B Address (3 bits) | Destination Register (3 bits) |

### 2. Memory Operations (Load/Store)
* **Load (`LD` - `4'b1110`):** `instr[12:9]` = Opcode, `instr[7:4]` = Data Memory Address, `instr[2:0]` = Destination Register.
* **Store (`ST` - `4'b1111`):** `instr[12:9]` = Opcode, `instr[6:4]` = Source/Destination Register, `instr[3:0]` = Data Memory Address.

Supported execution opcodes include: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `INC`, `DEC`, `NOT`, `NEG`, `SHR`, `SHL`, `ROR`, `ROL`, `NOP`, `LD`, and `ST`.

---

## Structural Submodules

### 1. Instruction Unit (`risc_iunit.v`)
Acts as the pipeline's fetch stage. It manages the 5-bit Program Counter (`pc`) and registers the incoming instruction stream into the Instruction Register (`ir`) on the rising edge of the clock. On an active-low reset (`rst_n == 0`), the stage flushes the execution path by forcing a `NOP` (`13'h0000`) code and resetting the execution pointer.

### 2. Decode Unit (`risc_decode.v`)
An asynchronous combinational block that strips opcodes and registers addresses directly out of the 13-bit instruction bus. It drives control steering signals by sorting load/store memory operations from standard computation instructions to eliminate datapath bus contention.

### 3. Register File (`risc_regfile.v`)
An 8×8-bit multi-port storage block. Features asynchronous read outputs for immediate multi-operand loading into the ALU execution phase. It processes synchronous register write-backs dynamically mediated by the execution unit's validation flags (`reg_wr_vld`), determining whether to commit computed results (`rslt`) or raw data memory reads (`dmdataout`) using a structural multiplexing operation controlled by the `load_op` flag.

### 4. Execution Unit (`risc_eunit.v`)
The computational core of the processor. Features a versatile ALU managing 14 individual mathematical and shifting procedures. Beyond mathematical calculations, it asserts control metrics including data memory enable (`dmenbl`), read/write path switches (`rdwr`), and register modification updates (`reg_wr_vld`), forming the cornerstone of frontend system control loops.

---

## Verification Strategy

Modular validation was performed through individual testbenches under `tb/` using the ModelSim simulation environment. 

### Simulation Procedures
1. **Instruction Boundary Verification:** `risc_IU_tb.v` validates proper sequential `pc` behavior and timing-accurate synchronous `ir` buffering under high-frequency toggles.
2. **Decoding Assertions:** `risc_DU_tb.v` systematically runs a broad instruction trace array to ensure zero decoding slippage across control boundaries.
3. **Storage Pipeline Validation:** `risc_reg_file_tb.v` isolates concurrent reading routines while forcing consecutive active write updates.
4. **Execution Verification:** `risc_EU_tb.v` verifies mathematical execution correctness, negative flag calculations, and precise shifting output accuracy.

### Running Simulations (ModelSim CLI)
To compile and simulate any individual module block, execute the following commands in the ModelSim transcript terminal:

```bash
# Create work library
vlib work

# Compile RTL and Testbench files (Example: Decode Unit)
vlog ./rtl/risc_decode.v ./tb/risc_DU_tb.v

# Start Simulator
vsim work.risc_decode_tb

# Log all waveforms and run simulation
add wave -hexadecimal sim:/risc_decode_tb/*
run -all
