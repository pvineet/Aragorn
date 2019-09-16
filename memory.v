module memory
(
	input [7:0] din,
	input [5:0] addr,
	input we, clk,
	output reg [7:0] dout
);
	// Declare the RAM variable
	reg [7:0] ram[255:0];
	
	// Port A
	always @ (posedge clk)
	begin
		if (we) 
		begin
			ram[addr] <= din;
			dout <= din;
		end
		else 
		begin
			dout <= ram[addr];
		end
	end
endmodule
