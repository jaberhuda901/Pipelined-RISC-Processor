module risc_eunit (
    input clk, 
    input rst_n, 
    input [3:0] dmaddrin, 
    input [3:0] opcode,
    input [7:0] oprnd_a, 
    input [7:0] oprnd_b,
    input [2:0] dstin,
    output reg dmenbl, 
    output wire rdwr, 
    output wire reg_wr_vld, 
    output wire load_op,
    output reg [3:0] dmaddr,
    output reg [7:0] rslt, 
    output wire [7:0] dmdatain,
    output reg [2:0] dst
);

  // Internal signals
  wire [7:0] adder_in_a;
  wire ci; // carry in
  reg [7:0] rslt_i;
  reg [7:0] rslt_sum;
  reg [7:0] adder_in_b;
  reg adder_mode;
  reg co; // carry out
  reg [3:0] opcode_out;

  parameter ADD = 1'b0;
  parameter SUB = 1'b1;
  parameter NOP_OP = 4'b0000,
            ADD_OP = 4'b0001,
            SUB_OP = 4'b0010,
            AND_OP = 4'b0011,
            OR_OP  = 4'b0100,
            XOR_OP = 4'b0101,
            INC_OP = 4'b0110,
            DEC_OP = 4'b0111,
            NOT_OP = 4'b1000,
            NEG_OP = 4'b1001,
            SHR_OP = 4'b1010,
            SHL_OP = 4'b1011,
            ROR_OP = 4'b1100,
            ROL_OP = 4'b1101,
            LD_OP  = 4'b1110,
            ST_OP  = 4'b1111;

  // Use assign statements to show mix of dataflow and behavioral
  assign load_op = (opcode_out == LD_OP);
  assign rdwr = (opcode_out == ST_OP) ? 1'b0 : 1'b1; // 0 for write (store), 1 for read (load)
  assign reg_wr_vld = (opcode_out != ST_OP) && (opcode_out != NOP_OP);
  assign dmdatain = rslt;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rslt <= 8'h00;
      dmaddr <= 4'h0;
      opcode_out <= 4'h0;
      dst <= 3'b000;
    end else begin
      rslt <= rslt_i;
      dst <= dstin;
      dmaddr <= dmaddrin;
      opcode_out <= opcode;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      dmenbl <= 1'b0;
    else if (opcode == ST_OP || opcode == LD_OP)
      dmenbl <= 1'b1;
    else
      dmenbl <= 1'b0;
  end

  always @(opcode) begin
    // Fillout 1: if opcode is SHL_OP or DEC_OP set adder_mode to SUB otherwise set it to ADD
    if (opcode == SHL_OP || opcode == DEC_OP) begin
      adder_mode = SUB;
    end else begin
      adder_mode = ADD;
    end
  end

  // Determine the b-input into the adder based on the opcode
  always @(opcode or oprnd_b) begin
    case (opcode)
      SUB_OP: adder_in_b = ~oprnd_b;  // Fillout 2: pass not of operand b
      INC_OP: adder_in_b = 8'h01;
      NEG_OP: adder_in_b = 8'h01;
      DEC_OP: adder_in_b = ~(8'h01);
      default: adder_in_b = oprnd_b;
    endcase
  end

  assign adder_in_a = (opcode == NEG_OP) ? ~oprnd_a : oprnd_a;
  assign ci = adder_mode;

  always @(adder_in_a or adder_in_b or ci) begin
    {co, rslt_sum} = adder_in_a + adder_in_b + ci;
  end

  // Mux in the result based on opcode
  always @(opcode or oprnd_a or oprnd_b or rslt_sum) begin
    case (opcode)
      // Fillout 3: complete this section
      ST_OP : rslt_i = oprnd_a;
      NOP_OP: rslt_i = 8'h00;
      AND_OP: rslt_i = oprnd_a & oprnd_b;              // Calculate and of a and b
      OR_OP : rslt_i = oprnd_a | oprnd_b;              // Calculate or of a and b
      XOR_OP: rslt_i = oprnd_a ^ oprnd_b;
      SHR_OP: rslt_i = oprnd_a >> 1;
      SHL_OP: rslt_i = oprnd_a << 1;
      ROR_OP: rslt_i = {oprnd_a[0], oprnd_a[7:1]};
      ROL_OP: rslt_i = {oprnd_a[6:0], oprnd_a[7]};
      NOT_OP: rslt_i = ~oprnd_a;    // Not of operand a
      ADD_OP,
      SUB_OP,
      INC_OP,
      DEC_OP,
      NEG_OP: rslt_i = rslt_sum;
      default: rslt_i = 8'h00;
    endcase
  end

endmodule

