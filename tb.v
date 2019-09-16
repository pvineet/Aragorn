//To do
//add rams
//add reading image
//

module tb();

reg clk, rstn, start_op;
reg [7:0] width, height;
initial begin
    clk = 0;
    rstn = 1;
    #100
    start_op = 1;
    rstn = 0;
    width = 28;
    height = 28;
    #1000
    $finish;
end


always #5 clk = ~clk;


top u_top(.clk(clk), 
	.rstn(rstn), 
	.in_pixel(), 
	.out_pixel(), 
        .start_op(start_op),
	.width(width),
	.height(height));

endmodule
