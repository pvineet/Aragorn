module top(clk, 
	   rstn, 
	   in_pixel, 
           out_pixel, 
           start_op,
           width,
           height);

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 16;
input clk, rstn, start_op;
input [7:0] width;
input [7:0] height;
input [DATA_WIDTH-1:0] in_pixel;
output [DATA_WIDTH-1:0] out_pixel;

wire [DATA_WIDTH-1:0] fifo0_data_in_o, fifo0_data_out_i;
wire [DATA_WIDTH-1:0] fifo1_data_in_o, fifo1_data_out_i;
wire [DATA_WIDTH-1:0] fifo2_data_in_o, fifo2_data_out_i;

wire [DATA_WIDTH-1:0] ram_dina_o_0;
wire [DATA_WIDTH-1:0] ram_dina_o_1;
wire [DATA_WIDTH-1:0] ram_dina_o_2;

wire [DATA_WIDTH-1:0] ram_doutb_i_0;
wire [DATA_WIDTH-1:0] ram_doutb_i_1;
wire [DATA_WIDTH-1:0] ram_doutb_i_2;

wire [ADDR_WIDTH-1:0] ram_addra_o_0;
wire [ADDR_WIDTH-1:0] ram_addra_o_1;
wire [ADDR_WIDTH-1:0] ram_addra_o_2;

wire [ADDR_WIDTH-1:0] ram_addrb_o_0;
wire [ADDR_WIDTH-1:0] ram_addrb_o_1;
wire [ADDR_WIDTH-1:0] ram_addrb_o_2;

dataflow u_dataflow(.clk(clk), 
        .rstn(rstn),
        .width(width),
        .height(height), 
    	.fifo0_data_in_o(fifo0_data_in_o), 
    	.fifo0_data_out_i(fifo0_data_out_i), 
    	.fifo0_full_i(fifo0_full_i),
    	.fifo0_empty_i(fifo0_empty_i),
    	.fifo0_rd_en_o(fifo0_rd_en_o),
    	.fifo0_wr_en_o(fifo0_wr_en_o),
    	.fifo0_rd_cs_o(fifo0_rd_cs_o),
    	.fifo0_wr_cs_o(fifo0_wr_cs_o),
    	.fifo1_data_in_o(fifo1_data_in_o), 
    	.fifo1_data_out_i(fifo1_data_out_i), 
    	.fifo1_full_i(fifo1_full_i),
    	.fifo1_empty_i(fifo1_empty_i),
    	.fifo1_rd_en_o(fifo1_rd_en_o),
    	.fifo1_wr_en_o(fifo1_wr_en_o),
    	.fifo1_rd_cs_o(fifo1_rd_cs_o),
    	.fifo1_wr_cs_o(fifo1_wr_cs_o),
    	.fifo2_data_in_o(fifo2_data_in_o), 
    	.fifo2_data_out_i(fifo2_data_out_i), 
    	.fifo2_full_i(fifo2_full_i),
    	.fifo2_empty_i(fifo2_empty_i),
    	.fifo2_rd_en_o(fifo2_rd_en_o),
    	.fifo2_wr_en_o(fifo2_wr_en_o),
    	.fifo2_rd_cs_o(fifo2_rd_cs_o),
    	.fifo2_wr_cs_o(fifo2_wr_cs_o),
        .pixel_addr(),
        .in_pixel(in_pixel), 
        .out_pixel(out_pixel),
        .start_op(start_op));

fifo u_fifo_0(.clk(clk), 
     .rstn(rstn),       
     .data_in(fifo0_data_in_o), 
     .data_out(fifo0_data_out_i), 
     .full(fifo0_full_i),
     .empty(fifo0_empty_i),
     .rd_en(fifo0_rd_en_o),
     .wr_en(fifo0_wr_en_o),
     .rd_cs(fifo0_rd_cs_o),
     .wr_cs(fifo0_wr_cs_o),
     // RAM signals
     .ram_dina_o(ram_dina_o_0),
     .ram_ena_o(),
     .ram_wea_o(ram_wea_o_0),
     .ram_addra_o(ram_addra_o_0),
     .ram_addrb_o(ram_addrb_o_0),
     .ram_doutb_i(ram_doutb_i_0),
     .ram_enb_o());

fifo u_fifo_1(.clk(clk), 
     .rstn(rstn),       
     .data_in(fifo1_data_in_o), 
     .data_out(fifo1_data_out_i), 
     .full(fifo1_full_i),
     .empty(fifo1_empty_i),
     .rd_en(fifo1_rd_en_o),
     .wr_en(fifo1_wr_en_o),
     .rd_cs(fifo1_rd_cs_o),
     .wr_cs(fifo1_wr_cs_o),
     // RAM signals
     .ram_dina_o(ram_dina_o_1),
     .ram_ena_o(),
     .ram_wea_o(ram_wea_o_1),
     .ram_addra_o(ram_addra_o_1),
     .ram_addrb_o(ram_addrb_o_1),
     .ram_doutb_i(ram_doutb_i_1),
     .ram_enb_o());

fifo u_fifo_2(.clk(clk), 
     .rstn(rstn),       
     .data_in(fifo2_data_in_o), 
     .data_out(fifo2_data_out_i), 
     .full(fifo2_full_i),
     .empty(fifo2_empty_i),
     .rd_en(fifo2_rd_en_o),
     .wr_en(fifo2_wr_en_o),
     .rd_cs(fifo2_rd_cs_o),
     .wr_cs(fifo2_wr_cs_o),
     // RAM signals
     .ram_dina_o(ram_dina_o_2),
     .ram_ena_o(),
     .ram_wea_o(ram_wea_o_2),
     .ram_addra_o(ram_addra_o_2),
     .ram_addrb_o(ram_addrb_o_2),
     .ram_doutb_i(ram_doutb_i_2),
     .ram_enb_o());

true_dpram_sclk mem0(
     .data_a(ram_dina_o_0),//data in 
     .data_b(),
     .addr_a(ram_addra_o_0), 
     .addr_b(ram_addrb_o_0),
     .we_a(ram_wea_o_0), 
     .we_b(1'b0), 
     .clk(clk),
     .q_a(), 
     .q_b(ram_doutb_i_0) //data out
);

true_dpram_sclk mem1(
     .data_a(ram_dina_o_1),//data in 
     .data_b(),
     .addr_a(ram_addra_o_1), 
     .addr_b(ram_addrb_o_1),
     .we_a(ram_wea_o_0), 
     .we_b(1'b0), 
     .clk(clk),
     .q_a(), 
     .q_b(ram_doutb_i_1) //data out
);

true_dpram_sclk mem2(
     .data_a(ram_dina_o_2),//data in 
     .data_b(),
     .addr_a(ram_addra_o_2), 
     .addr_b(ram_addrb_o_2),
     .we_a(ram_wea_o_2), 
     .we_b(1'b0), 
     .clk(clk),
     .q_a(), 
     .q_b(ram_doutb_i_2) //data out
);

endmodule
