// NAME: JABER-UL HUDA
// ID: 101137524

module risc_regfile (
  input clk, 
  input rst_n, 
  input reg_wr_vld, 
  input load_op,
  input [7:0] rslt, 
  input [7:0] dmdataout,
  input [2:0] dst,
  input [2:0] opnda_addr, 
  input [2:0] opndb_addr,
  output reg [7:0] oprnd_a, 
  output reg [7:0] oprnd_b
);

  reg [7:0] regfile [0:7];
  wire [7:0] reg_data_in;

/// fillout 1: if load_op is  1 assign dmdataout to reg_data_in otherwise rslt
assign reg_data_in = (load_op) ? dmdataout : rslt;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      regfile[0] <= 8'h00;
      regfile[1] <= 8'h22;
      regfile[2] <= 8'h44;
      regfile[3] <= 8'h66;
      regfile[4] <= 8'h88;
      regfile[5] <= 8'haa;
      regfile[6] <= 8'hcc;
      regfile[7] <= 8'hff;
    end else if (reg_wr_vld) begin
      case (dst)
      // fillout2
      // this is for load operation, 
      // depending on dst we write the data in the
      // destination register specified by dst
        3'd0: regfile[0] <= reg_data_in;
      3'd1: regfile[1] <= reg_data_in;
      3'd2: regfile[2] <= reg_data_in;
      3'd3: regfile[3] <= reg_data_in;
      3'd4: regfile[4] <= reg_data_in;
      3'd5: regfile[5] <= reg_data_in;
      3'd6: regfile[6] <= reg_data_in;
      3'd7: regfile[7] <= reg_data_in;
      endcase
    end
  end

  always @(*) begin
    case (opnda_addr)
	// fillout 3: pass appropriate register to oprnd_a based on opnd_addr
	// 
      3'd0: oprnd_a = regfile[0];
      3'd1: oprnd_a = regfile[1];
      3'd2: oprnd_a = regfile[2];
      3'd3: oprnd_a = regfile[3];
      3'd4: oprnd_a = regfile[4];
      3'd5: oprnd_a = regfile[5];
      3'd6: oprnd_a = regfile[6];
      3'd7: oprnd_a = regfile[7];
      default: oprnd_a = 8'h00;
    endcase
  end

  always @(*) begin
  // fillout 4: pass appropriate register to oprnd_b based on opnd_addr
	// 
    case (opndb_addr)
      3'd0: oprnd_b = regfile[0];
      3'd1: oprnd_b = regfile[1];
      3'd2: oprnd_b = regfile[2];
      3'd3: oprnd_b = regfile[3];
      3'd4: oprnd_b = regfile[4];
      3'd5: oprnd_b = regfile[5];
      3'd6: oprnd_b = regfile[6];
      3'd7: oprnd_b = regfile[7];
      default: oprnd_b = 8'h00;
    endcase
  end
endmodule




