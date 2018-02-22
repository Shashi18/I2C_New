module TestI2C;

	// Inputs
	reg clk;

	// Outputs
	wire scl;

	// Bidirs
	wire sda;

	// Instantiate the Unit Under Test (UUT)
	Master uut (
		.sda(sda), 
		.scl(scl), 
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		clk = 0;


	end
always #1 clk = ! clk;
      
endmodule

