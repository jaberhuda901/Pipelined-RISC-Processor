module risc_dmemory (
  input [3:0] dmaddr,
  input [7:0] dmdatain,
  input dmenbl, 
  input rdwr,
  output reg [7:0] dmdataout
);
  // Define memory size: 8 bits per reg; 16 regs
  reg [7:0] dmemory [0:15];

  // Initialize memory contents
  initial begin
    dmemory[00] = 8'h00;
    dmemory[01] = 8'h22;
    dmemory[02] = 8'h44;
    dmemory[03] = 8'h66;
    dmemory[04] = 8'h88;
    dmemory[05] = 8'haa;
    dmemory[06] = 8'hcc;
    dmemory[07] = 8'hff;
    dmemory[08] = 8'h00;
    dmemory[09] = 8'h00;
    dmemory[10] = 8'h00;
    dmemory[11] = 8'h00;
    dmemory[12] = 8'h00;
    dmemory[13] = 8'h00;
    dmemory[14] = 8'h00;
    dmemory[15] = 8'h00;
  end

  // Handle read and write operations
  always @(posedge dmenbl) begin
    if (rdwr) begin
      dmdataout <= dmemory[dmaddr]; // Read operation
    end else begin
      dmemory[dmaddr] <= dmdatain; // Write operation
    end
  end
endmodule
