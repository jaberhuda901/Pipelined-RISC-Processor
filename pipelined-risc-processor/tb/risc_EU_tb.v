// Testbench for the Execution Unit (risc_eunit)
module risc_eunit_tb;

  // Fillout 1: Define all input and output signals for the testbench
  reg clk;                     // Clock signal
  reg rst_n;                   // Reset signal
  reg [3:0] opcode;            // Opcode
  reg [2:0] opnda_addr;        // Address of operand A
  reg [2:0] opndb_addr;        // Address of operand B
  reg [3:0] dmaddrin;          // Data memory address input
  reg [7:0] oprnd_a;           // Operand A
  reg [7:0] oprnd_b;           // Operand B
  reg [2:0] dstin;             // Destination register input

  wire dmenbl;                 // Data memory enable
  wire rdwr;                   // Read/write control signal
  wire reg_wr_vld;             // Register write valid signal
  wire load_op;                // Load operation indicator
  wire [7:0] dmdatain;         // Data memory data input
  wire [7:0] rslt;             // Result of the operation
  wire [3:0] dmaddr;           // Data memory address
  wire [2:0] dst;              // Destination register

  // Fillout 2: Instantiate the `risc_eunit` module
  risc_eunit inst1 (
    .clk(clk),
    .rst_n(rst_n),
    .dmaddrin(dmaddrin),
    .opcode(opcode),
    .oprnd_a(oprnd_a),
    .oprnd_b(oprnd_b),
    .dstin(dstin),
    .dmenbl(dmenbl),
    .rdwr(rdwr),
    .reg_wr_vld(reg_wr_vld),
    .load_op(load_op),
    .dmaddr(dmaddr),
    .rslt(rslt),
    .dmdatain(dmdatain),
    .dst(dst)
  );

  reg [7:0] regfile0 = 8'h00;
	reg [7:0] regfile1 = 8'h22;
	reg [7:0] regfile2 = 8'h44;
	reg [7:0] regfile3 = 8'h66;
	reg [7:0] regfile4 = 8'h88;
	reg [7:0] regfile5 = 8'haa;
	reg [7:0] regfile6 = 8'hcc;
	reg [7:0] regfile7 = 8'hff;

  // Define the clock signal
  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk; // Generate a clock signal with a period of 20 time units
  end

  // Initialize input vectors and test cases
  initial begin//define input vectors
		#0 rst_n = 1'b0;
		//add -------------------------------------------------------
		@ (negedge clk)
		rst_n = 1'b1;
		opcode = 4'b0001; //add
		oprnd_a = regfile0; //00h + ffh
		oprnd_b = regfile7; //rslt = ffh
		@ (negedge clk)
		$display ("regfile0 = %h, regfile7 = %h, add, rslt = %h",
		regfile0, regfile7, rslt);
		
		//sub -------------------------------------------------------
		opcode = 4'b0010; //sub
		oprnd_a = regfile1; //22h - cch
		oprnd_b = regfile6; //rslt = 56h
		@ (negedge clk)
		$display ("regfile1 = %h, regfile6 = %h, sub, rslt = %h",
		regfile1, regfile6, rslt);
		
		//and -------------------------------------------------------
		opcode = 4'b0011; //and
		oprnd_a = regfile2; //44h & aah
		oprnd_b = regfile5; //rslt = 00h
		@ (negedge clk)
		$display ("regfile2 = %h, regfile5 = %h, and, rslt = %h",
		regfile2, regfile5, rslt);
		
		//or --------------------------------------------------------
		opcode = 4'b0100; //or
		oprnd_a = regfile3; //66h | 88h
		oprnd_b = regfile4; //rslt = eeh
		@ (negedge clk)
		$display ("regfile3 = %h, regfile4 = %h, or , rslt = %h",
		regfile3, regfile4, rslt);
		
		//xor -------------------------------------------------------
		opcode = 4'b0101; //xor
		oprnd_a = regfile4; //88h ^ 66h
		oprnd_b = regfile3; //rslt = eeh
		@ (negedge clk)
		$display ("regfile4 = %h, regfile3 = %h, xor, rslt = %h",
		regfile4, regfile3, rslt);
		
		//inc -------------------------------------------------------
		opcode = 4'b0110; //inc
		oprnd_a = regfile5; //aah + 1
		oprnd_b = regfile0; //rslt = abh
		@ (negedge clk)
		$display ("regfile5 = %h, regfile0 = %h, inc, rslt = %h",
		regfile5, regfile0, rslt);
		
		//dec --------------------------------------------------------
		opcode = 4'b0111; //dec
		oprnd_a = regfile6; //cch - 1
		oprnd_b = regfile0; //rslt = cbh
		@ (negedge clk)
		$display ("regfile6 = %h, regfile0 = %h, dec, rslt = %h",
		regfile6, regfile0, rslt);
		
		//not --------------------------------------------------------
		opcode = 4'b1000; //not
		oprnd_a = regfile7; //ffh
		oprnd_b = regfile0; //rslt = 00h
		@ (negedge clk)
		$display ("regfile7 = %h, regfile0 = %h, not, rslt = %h",
		regfile7, regfile0, rslt);
		
		//neg --------------------------------------------------------
		opcode = 4'b1001; //neg
		oprnd_a = regfile0; //00h
		oprnd_b = regfile0; //rslt = 01h
		@ (negedge clk)
		$display ("regfile0 = %h, regfile0 = %h, neg, rslt = %h",
		regfile0, regfile0, rslt);
		
		//shr --------------------------------------------------------
		opcode = 4'b1010; //shr
		oprnd_a = regfile1; //22h
		oprnd_b = regfile0; //rslt = 11h
		@ (negedge clk)
		$display ("regfile1 = %h, regfile0 = %h, shr, rslt = %h",
		regfile1, regfile0, rslt);
		
		//shl --------------------------------------------------------
		opcode = 4'b1011; //shl
		oprnd_a = regfile2; //44h
		oprnd_b = regfile0; //rslt = 88h
		@ (negedge clk)
		$display ("regfile2 = %h, regfile0 = %h, shl, rslt = %h",
		regfile2, regfile0, rslt);
		
		//ror --------------------------------------------------------
		opcode = 4'b1100; //ror
		oprnd_a = regfile3; // 66h
		oprnd_b = regfile0; // rslt = 33h
		@ (negedge clk)
		$display ("regfile3 = %h, regfile0 = %h, ror, rslt = %h",
		regfile3, regfile0, rslt); //next pag
		
		//rol --------------------------------------------------------
		opcode = 4'b1101; //rol
		oprnd_a = regfile4; // 88h
		oprnd_b = regfile0; //rslt = 11h
		@ (negedge clk)
		$display ("regfile4 = %h, regfile0 = %h, rol, rslt = %h",
		regfile4, regfile0, rslt);
		
		//-----------------------------------------------------------
		//Investigate the effect of the following lines on your circuit, 
		// which signals change as a result of the following three lines
		opcode = 4'b0000; //nop
		#20 opcode = 4'b1111; //st and ld
		#20 opcode = 4'b0000; //nop
		#50 $stop;
	end

endmodule
