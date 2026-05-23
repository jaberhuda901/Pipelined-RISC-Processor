// Testbench for Instruction Unit (IU)
module risc_iunit_tb;
    // Fillout1: Define the signals
    reg clk;                // Clock signal
    reg rst_n;              // Reset signal (active low)
    reg [12:0] instruction; // Instruction from instruction memory
    wire [4:0] pc;          // Program Counter (output from the MUT)
    wire [12:0] ir;         // Instruction Register (output to decode stage)

    // Fillout2: Instantiate the IU
    risc_iunit inst1 (
        .clk(clk), 
        .rst_n(rst_n), 
        .instruction(instruction), 
        .pc(pc), 
        .ir(ir)
    );

    // Define clock
    initial begin
        clk = 1'b0; // Initialize clock to 0
        forever #10 clk = ~clk; // Toggle clock every 10 time units (20ns clock period)
    end

    // Define reset, simulation duration, and provide test instructions
    initial begin
		#0 rst_n = 1'b0;
		instruction = 13'h0208; //pc = 00
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
	
		#5 rst_n = 1'b1;
		#10 instruction = 13'h05f1; //pc = 01; sub
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#20 instruction = 13'h06aa; //pc = 02; and
	
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#20 instruction = 13'h08e3; //pc = 03; or
		$display ("pc = %h, instruction = %h, ir = %h",
	
		pc, instruction, ir);
		#20 instruction = 13'h0b24; //pc = 04; xor
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#20 instruction = 13'h0d45; //pc = 05; inc
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#20 instruction = 13'h0f86; //pc = 06; dec
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#20 instruction = 13'h11c7; //pc = 07; not
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#20 instruction = 13'h1200; //pc = 08; neg
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#20 instruction = 13'h1441; //pc = 09; shr
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#20 instruction = 13'h1682; //pc = 10; shl
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#20 instruction = 13'h18c3; //pc = 11; ror
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#20 instruction = 13'h1b04; //pc = 12; rol
		$display ("pc = %h, instruction = %h, ir = %h",
		pc, instruction, ir);
		#200 $stop;
	end
endmodule
