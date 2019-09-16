 module dataflow(clk, 
                rstn,
	        width,
                height, 
            	fifo0_data_in_o, 
            	fifo0_data_out_i, 
            	fifo0_full_i,
            	fifo0_empty_i,
            	fifo0_rd_en_o,
            	fifo0_wr_en_o,
            	fifo0_rd_cs_o,
            	fifo0_wr_cs_o,
            	fifo1_data_in_o, 
            	fifo1_data_out_i, 
            	fifo1_full_i,
            	fifo1_empty_i,
            	fifo1_rd_en_o,
            	fifo1_wr_en_o,
            	fifo1_rd_cs_o,
            	fifo1_wr_cs_o,
            	fifo2_data_in_o, 
            	fifo2_data_out_i, 
            	fifo2_full_i,
            	fifo2_empty_i,
            	fifo2_rd_en_o,
            	fifo2_wr_en_o,
            	fifo2_rd_cs_o,
            	fifo2_wr_cs_o,
                pixel_addr,
                in_pixel, 
                out_pixel,
                start_op);

    input clk, rstn, start_op;
    input [7:0] width;
    input [7:0] height;
    output [31:0] fifo0_data_in_o; 
    input [31:0] fifo0_data_out_i;
    input 	fifo0_full_i;
    input 	fifo0_empty_i;
    output 	fifo0_rd_en_o;
    output 	fifo0_wr_en_o;
    output 	fifo0_rd_cs_o;
    output 	fifo0_wr_cs_o;
    output [31:0] fifo1_data_in_o; 
    input [31:0] fifo1_data_out_i; 
    input 	fifo1_full_i;
    input 	fifo1_empty_i;
    output 	fifo1_rd_en_o;
    output 	fifo1_wr_en_o;
    output 	fifo1_rd_cs_o;
    output 	fifo1_wr_cs_o;
    output [31:0] fifo2_data_in_o; 
    input [31:0] fifo2_data_out_i; 
    input 	fifo2_full_i;
    input 	fifo2_empty_i;
    output 	fifo2_rd_en_o;
    output 	fifo2_wr_en_o;
    output 	fifo2_rd_cs_o;
    output 	fifo2_wr_cs_o;
    input [31:0] in_pixel;
    output reg [31:0] out_pixel;
    output reg [31:0] pixel_addr;
    reg [31:0] pixel_count;
    
    reg [31:0] kernel[3];
    reg [4:0] present_state, next_state;
    reg [31:0] mac_out0, mac_out1, mac_out2; 
    reg [31:0] fifo0_rd_data;
    reg [31:0] fifo1_rd_data;
    reg [31:0] fifo2_rd_data;
    reg [31:0] pix0, pix1, pix2;
    reg [31:0] fifo_rd_data;
    reg [31:0] fifo_wr_data;
    reg [7:0] width_cnt;
    reg [7:0] height_cnt;

    parameter IDLE       = 6'b000000;
    parameter RD_PIXEL_0 = 6'b000001;
    parameter RD_PIXEL_1 = 6'b000010;
    parameter RD_PIXEL_2 = 6'b000100;
    parameter RD_FIFO    = 6'b001000; 
    parameter MAC        = 6'b010000;
    parameter WR_FIFO    = 6'b100000;
    
    // Input pixel addr logic
    always@(negedge rstn, posedge clk)
    begin
        if(rstn == 0)
            pixel_addr <= 0;
        else if(present_state == 5'b00001 | present_state == 5'b00010 | present_state == 5'b00100)
            pixel_addr <= pixel_addr + 1;
    end
   
    always@(negedge rstn, posedge clk)
    begin
        if(!rstn)    
            present_state <= IDLE;
        else
            present_state <= next_state;
   end                                  
                                        
    always@(*)                          
    begin                               
        case(present_state)             
            IDLE:                       
                begin                   
                    if(start_op)
                        next_state = RD_PIXEL_0;
                    else
                        next_state = IDLE;
                end
            RD_PIXEL_0:
                begin
                    next_state = RD_PIXEL_1;
                end
            RD_PIXEL_1:
                begin
                    next_state = RD_PIXEL_2;
                end
            RD_PIXEL_2:
                begin
                    next_state = RD_FIFO;
                end
	    RD_FIFO:
		begin
		    next_state = MAC;
		end
            MAC:
                begin
                    next_state = WR_FIFO;
                end
	    WR_FIFO:
		begin
                    next_state = RD_PIXEL_0;
		end
        endcase
    end
    
    // FIXME add shift in kernel
    always@(negedge rstn, posedge clk)
    begin
        if(!rstn)
            mac_out0 <= 0;
        else if(present_state == MAC)
            mac_out0 <= (pix0*kernel[0]+pix1*kernel[1]+pix2*kernel[2]) + fifo0_rd_data;
    end

    always@(negedge rstn, posedge clk)
    begin
        if(!rstn)
            pix0 <= 0;
        else if(present_state == RD_PIXEL_0)
            pix0 <= in_pixel;
    end
    
    always@(negedge rstn, posedge clk)
    begin
        if(!rstn)
            pix1 <= 0;
        else if(present_state == RD_PIXEL_1)
            pix1 <= in_pixel;
    end
    
    always@(negedge rstn, posedge clk)
    begin
        if(!rstn)
            pix2 <= 0;
        else if(present_state == RD_PIXEL_2)
            pix2 <= in_pixel;
    end

    always@(negedge rstn, posedge clk)
    begin
        if(!rstn) begin
            fifo0_rd_data <= 0;
            fifo1_rd_data <= 0;
            fifo2_rd_data <= 0;
	end
        else if(present_state == RD_FIFO) begin
            fifo0_rd_data <= fifo0_data_out_i;
            fifo1_rd_data <= fifo1_data_out_i;
            fifo2_rd_data <= fifo2_data_out_i;
	end
    end
    
    always@(negedge rstn, posedge clk)
    begin
	if(!rstn)
	    width_cnt <= 0;
        else if(present_state == RD_PIXEL_0 || present_state == RD_PIXEL_1 || present_state == RD_PIXEL_2)
	    width_cnt <= width + 1;
        else if(width_cnt ==  width)
	    width_cnt <= 0;
    end
    
    always@(negedge rstn, posedge clk)
    begin
	if(!rstn)
	    height_cnt <= 0;
        else if(width_cnt == width)
            height_cnt <= height_cnt + 1;
    end

    assign fifo0_data_in_o = (present_state == WR_FIFO)? mac_out0:32'd0;
    assign fifo0_wr_en_o =  (present_state == WR_FIFO)? 1:0;
    assign fifo0_wr_cs_o =  (present_state == WR_FIFO)? 1:0;
    assign fifo0_rd_en_o =  (present_state == RD_FIFO)? 1:0;
    assign fifo0_rd_cs_o =  (present_state == RD_FIFO)? 1:0;
    assign fifo1_data_in_o = (present_state == WR_FIFO)? mac_out1:32'd0;
    assign fifo1_wr_en_o =  (present_state == WR_FIFO)? 1:0;
    assign fifo1_wr_cs_o =  (present_state == WR_FIFO)? 1:0;
    assign fifo1_rd_en_o =  (present_state == RD_FIFO)? 1:0;
    assign fifo1_rd_cs_o =  (present_state == RD_FIFO)? 1:0;
    assign fifo2_data_in_o = (present_state == WR_FIFO)? mac_out2:32'd0;
    assign fifo2_wr_en_o =  (present_state == WR_FIFO)? 1:0;
    assign fifo2_wr_cs_o =  (present_state == WR_FIFO)? 1:0;
    assign fifo2_rd_en_o =  (present_state == RD_FIFO)? 1:0;
    assign fifo2_rd_cs_o =  (present_state == RD_FIFO)? 1:0;

    // need to maintain a count to decide the pixel out.
 endmodule
