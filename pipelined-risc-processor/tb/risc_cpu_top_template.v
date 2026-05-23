module risc_cpu_top1 (
    input  clk, 
    input  rst_n, 
    input  [12:0] instruction,   // from instruction memory
    output [4:0]  pc,            // to instruction memory
    output        dmenbl,        // data memory enable
    output [3:0]  dmaddr,        // data memory address
    output [7:0]  dmdatain,      // data to data memory
    input  [7:0]  dmdataout,     // data from data memory
    output        rdwr           // 1 = read, 0 = write
);
    // =========================================================
    // Wires between submodules
    // =========================================================

    // IU <-> DU
    wire [12:0] ir;              // instruction from IU to decode

    // Decode outputs
    wire [3:0] dmaddr_dec;
    wire [3:0] opcode_dec;
    wire [3:0] opnda_dec;
    wire [3:0] opndb_dec;
    wire [3:0] dst_dec;

    // Truncated 3-bit register addresses (regfile & EU use 3 bits)
    wire [2:0] opnda_addr;
    wire [2:0] opndb_addr;
    wire [2:0] dst_addr;

    assign opnda_addr = opnda_dec[2:0];
    assign opndb_addr = opndb_dec[2:0];
    assign dst_addr   = dst_dec[2:0];

    // EU outputs
    wire        dmenbl_w;
    wire        rdwr_w;
    wire        reg_wr_vld_w;
    wire        load_op_w;
    wire [3:0]  dmaddr_w;
    wire [7:0]  rslt_w;
    wire [7:0]  dmdatain_w;
    wire [2:0]  dst_eu;

    // Regfile outputs
    wire [7:0] oprnd_a_w;
    wire [7:0] oprnd_b_w;

    // Drive top-level outputs from EU
    assign dmenbl   = dmenbl_w;
    assign dmaddr   = dmaddr_w;
    assign dmdatain = dmdatain_w;
    assign rdwr     = rdwr_w;

    // =========================================================
    // Submodule instantiations
    // =========================================================

    // -------------------------
    // Instruction Unit (IU)
    // -------------------------
    risc_iunit iunit_inst (
        .rst_n      (rst_n),
        .clk        (clk),
        .instruction(instruction), // from instruction memory
        .pc         (pc),          // to instruction memory
        .ir         (ir)           // to decode unit
    );

    // -------------------------
    // Decode Unit (DU)
    // -------------------------
    risc_decode decode_inst (
        .clk    (clk),
        .rst_n  (rst_n),
        .instr  (ir),
        .dmaddr (dmaddr_dec),
        .opcode (opcode_dec),
        .opnda  (opnda_dec),
        .opndb  (opndb_dec),
        .dst    (dst_dec)
    );

    // -------------------------
    // Execution Unit (EU / ALU)
    // -------------------------
    risc_eunit eunit_inst (
        .clk       (clk),
        .rst_n     (rst_n),
        .dmaddrin  (dmaddr_dec),   // from decode
        .opcode    (opcode_dec),
        .oprnd_a   (oprnd_a_w),    // from regfile
        .oprnd_b   (oprnd_b_w),    // from regfile
        .dstin     (dst_addr),     // from decode
        .dmenbl    (dmenbl_w),
        .rdwr      (rdwr_w),
        .reg_wr_vld(reg_wr_vld_w),
        .load_op   (load_op_w),
        .dmaddr    (dmaddr_w),
        .rslt      (rslt_w),
        .dmdatain  (dmdatain_w),
        .dst       (dst_eu)        // destination register for regfile write
    );

    // -------------------------
    // Register File
    // -------------------------
    risc_regfile regfile_inst (
        .clk        (clk),
        .rst_n      (rst_n),
        .reg_wr_vld (reg_wr_vld_w),
        .load_op    (load_op_w),
        .rslt       (rslt_w),
        .dmdataout  (dmdataout),
        .dst        (dst_eu),         // dst from EU (pipelined)
        .opnda_addr (opnda_addr),     // src A from decode
        .opndb_addr (opndb_addr),     // src B from decode
        .oprnd_a    (oprnd_a_w),      // to EU
        .oprnd_b    (oprnd_b_w)       // to EU
    );

endmodule
