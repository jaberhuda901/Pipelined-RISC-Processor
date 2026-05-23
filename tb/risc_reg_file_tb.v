// Testbench for regfile
module risc_regfile_tb;
    // Define required signals for inputs and outputs
    reg clk, rst_n, reg_wr_vld, load_op;
    reg [7:0] rslt, dmdataout;
    reg [2:0] dst, opnda_addr, opndb_addr;
    wire [7:0] oprnd_a, oprnd_b;

    // Instantiate the behavioral module into the testbench
    risc_regfile inst1 (
        .clk(clk),
        .rst_n(rst_n),
        .reg_wr_vld(reg_wr_vld),
        .load_op(load_op),
        .rslt(rslt),
        .dmdataout(dmdataout),
        .dst(dst),
        .opnda_addr(opnda_addr),
        .opndb_addr(opndb_addr),
        .oprnd_a(oprnd_a),
        .oprnd_b(oprnd_b)
    );

    // Clock generation
    initial begin
		clk = 1'b0;
		forever
			#5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		reg_wr_vld = 0;
		load_op = 0;
		rslt = 0;
		dmdataout = 0;
		dst = 0;
		opnda_addr = 0;
		opndb_addr = 0;

		// Reset the UUT
		#10;
		rst_n = 1;

		// Test case 1: Write to register 0
		#10;
		reg_wr_vld = 1;
		rslt = 8'hAA;
		dst = 3'd0;

		// Test case 2: Write to register 1
		#10;
		rslt = 8'hBB;
		dst = 3'd1;

		// Test case 3: Read from register 0 and 1
		#10;
		reg_wr_vld = 0;
		opnda_addr = 3'd0;
		opndb_addr = 3'd1;

		// Test case 4: Load operation
		#10;
		reg_wr_vld = 1;
		load_op = 1;
		dmdataout = 8'hCC;
		dst = 3'd2;

		// Test case 5: Read from register 2
		#10;
		reg_wr_vld = 0;
		load_op = 0;
		opnda_addr = 3'd2;

		// Finish simulation
		#50;
		$stop;
	end

	initial begin
		$monitor("Time=%0d clk=%b rst_n=%b reg_wr_vld=%b load_op=%b rslt=%h dmdataout=%h dst=%d opnda_addr=%d opndb_addr=%d oprnd_a=%h oprnd_b=%h",
				 $time, clk, rst_n, reg_wr_vld, load_op, rslt, dmdataout, dst, opnda_addr, opndb_addr, oprnd_a, oprnd_b);
	end

endmodule
