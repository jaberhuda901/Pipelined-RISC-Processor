module risc_imemory (
  input [4:0] pc,
  output reg [12:0] instruction
);
  // Define memory size
  reg [12:0] imemory [0:31]; // 13 bits per reg; 32 regs

  // Initialize memory contents
  initial begin
    // These are opcodes of our test program
    // They have been hand assembled and are to be written in the following memory locations
    // In practice, this process is done by a compiler and loader
    imemory[00] = 13'h1c00;
    imemory[01] = 13'h1c11;
    imemory[02] = 13'h1c22;
    imemory[03] = 13'h1c33;
    imemory[04] = 13'h1c44;
    imemory[05] = 13'h1c55;
    imemory[06] = 13'h1c66;
    imemory[07] = 13'h1c77;
    imemory[08] = 13'h0208;
    imemory[09] = 13'h05f1;
    imemory[10] = 13'h06aa;
    imemory[11] = 13'h08e3;
    imemory[12] = 13'h0b24;
    imemory[13] = 13'h0d45;
    imemory[14] = 13'h0f86;
    imemory[15] = 13'h11c7;
    imemory[16] = 13'h1200;
    imemory[17] = 13'h1441;
    imemory[18] = 13'h1682;
    imemory[19] = 13'h18c3;
    imemory[20] = 13'h1b04; 
    imemory[21] = 13'h1e08;
    imemory[22] = 13'h1e19;
    imemory[23] = 13'h1e2a;
    imemory[24] = 13'h1e3b;
    imemory[25] = 13'h1e4c;
    imemory[26] = 13'h1e5d;
    imemory[27] = 13'h1e6e;
    imemory[28] = 13'h1e7f;
    imemory[29] = 13'h0000;
    imemory[30] = 13'h0000;
    imemory[31] = 13'h0000;
  end

  // Assign instruction based on pc
  always @(pc) begin
    instruction = imemory[pc];
  end
endmodule
