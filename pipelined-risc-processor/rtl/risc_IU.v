//Design of instruction unit (IU)
// each instruct is 13 bits
//opcode is 4 bits
// each register info is 3 bits
//input Signals: clk, rst_n, insruction address bus (5 bits cause we have 32 instructions), pc (5 bits)
//output signals: ir the instruction 13 bits

// behavioral iunit

// this unit will receive instruction from memory
// and pass it along to the decode section
// so you need an input to receive instruction and 
// an output to pass instruction to decode

//behavioral iunit
module risc_iunit (
  //  fillout1: complete the interface based on the given block diagram in the manual
  input rst_n,
  input clk,
  input[12:0] instruction, //instruction from instrucion memory
  output reg [4:0] pc,  //pointer to next insruction in instruction memory
  output reg [12:0] ir // 13 bit instruction to the decode stage
);
  
  parameter nop = 13'h0000;

  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      //fillout2: reset the ir to nop and reset the PC
	  ir <= nop;
	  pc <= 5'b00000;

   end else begin
    // fillout3:pass the input instruction to the output port and increement the PC
	 // if the PC reached maximum value you must reset it
	 ir <= instruction;
	 if (pc == 5'b11111)
		pc <= 5'b00000;
		
	 else
		pc <= pc + 5'b 00001;
	 
    end
  end
endmodule
