module risc_decode (
    input clk, 
    input rst_n, 
    // fillout 1: complete the following interface description
    input [12:0] instr,
    output reg [3:0] dmaddr, 
    output reg [3:0] opcode,
    output reg [3:0] opnda, 
    output reg [3:0] opndb, 
    output reg [3:0] dst
);

  // Internal signals
  wire [3:0] opcode_i;
  reg [3:0] dmaddr_i;
  reg [2:0] opnda_i, opndb_i, dst_i;

  parameter ld = 4'b1110, st = 4'b1111;

  // fillout2: extract the opcode from the instruction and assign it to opcode_i
  assign opcode_i = instr[12:9];
  
  // in this always block you need to check the opcode,
  // and depending on the opcode you will have to extract information accordingly
  // note that the format for arithmetic/logical instructions are the same,
  // so you need to check if the opcode represents a load, a store or arithmetic/logical
  // make sure to consider a default for your case, so if something goes wrong it resets
  // to a specific case
  // refer to the instructions format given in the lab document

  always @(*) begin
    case (opcode_i)
      ld: begin
        dmaddr_i = instr[7:4];
        dst_i = instr[2:0];
        opnda_i = 3'b000;
        opndb_i = 3'b000;
      end
      st: begin
        dst_i = instr[6:4];
        dmaddr_i = instr[3:0];
        opnda_i = 3'b000;
        opndb_i = 3'b000;
      end
      4'b0001, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111, 4'b1000, 4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101: begin
        opnda_i = instr[8:6];
        opndb_i = instr[5:3];
        dst_i = instr[2:0];
      end

      default: begin
        dst_i = 3'b000;
        dmaddr_i = 4'b0000;
        opnda_i = 3'b000;
        opndb_i = 3'b000;
      end
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // fillout4: reset all outputs with 0
      dst <= 3'b000;
      dmaddr <= 4'b0000;
      opnda <= 3'b000;
      opndb <= 3'b000;
      opcode <= 4'b0000; 
    end else begin
      // fillout5:
      // pass the extracted information from the
      // instructions to the next unit, this include opcode,
      // dmaddr, dst, opnda, and opndb
      dst <= dst_i;
      dmaddr <= dmaddr_i;
      opnda <= opnda_i;
      opndb <= opndb_i;
      opcode <= opcode_i;    end
  end

endmodule
