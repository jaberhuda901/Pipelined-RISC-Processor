

//structural risc_cpu_top test bench
module risc_system_top_tb;
	reg clk, rst_n;
	
	initial begin
		clk = 1'b0;
		forever
		#10 clk = ~clk;
	end
	
	initial begin
		rst_n = 1'b0;
		#5 rst_n = 1'b1;
		#700 $stop; 
	end
	
	risc_system_top inst1 (
		.clk(clk),
		.rst_n(rst_n)
	);
endmodule