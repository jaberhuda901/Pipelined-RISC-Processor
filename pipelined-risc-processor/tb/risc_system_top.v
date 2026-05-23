module risc_system_top (
    input clk, 
    input rst_n
);
    // CPU <-> memories interconnect
    wire        dmenbl;
    wire        rdwr;
    wire [12:0] instruction;
    wire [4:0]  pc;
    wire [3:0]  dmaddr;
    wire [7:0]  dmdatain;
    wire [7:0]  dmdataout;

    // -----------------------------------
    // Instruction Memory
    // -----------------------------------
    risc_imemory imem_inst (
        .pc         (pc),
        .instruction(instruction)
    );

    // -----------------------------------
    // Data Memory
    // -----------------------------------
    risc_dmemory dmem_inst (
        .dmaddr   (dmaddr),
        .dmdatain (dmdatain),
        .dmenbl   (dmenbl),
        .rdwr     (rdwr),
        .dmdataout(dmdataout)
    );

    // -----------------------------------
    // CPU Core (top-level CPU)
    // -----------------------------------
    risc_cpu_top1 cpu_inst (
        .clk       (clk),
        .rst_n     (rst_n),
        .instruction(instruction),
        .pc        (pc),
        .dmenbl    (dmenbl),
        .dmaddr    (dmaddr),
        .dmdatain  (dmdatain),
        .dmdataout (dmdataout),
        .rdwr      (rdwr)
    );

endmodule
