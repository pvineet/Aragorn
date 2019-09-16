module fifo(clk, 
            rstn, 
            data_in, 
            data_out, 
            full,
            empty,
            rd_en,
            wr_en,
            rd_cs,
            wr_cs,
            // RAM signals
            ram_dina_o,
            ram_ena_o,
            ram_wea_o,
            ram_addra_o,
            ram_addrb_o,
            ram_doutb_i,
            ram_enb_o);
    
    parameter ADDR_WIDTH = 16;
    parameter DATA_WIDTH = 32;
    parameter RAM_DEPTH = (1<<ADDR_WIDTH);
    
    input clk, rstn, rd_en, rd_cs, wr_en, wr_cs;
    input [31:0] data_in;
    output [31:0] data_out;
    output full, empty;


    output ram_ena_o;
    output ram_wea_o;
    output [ADDR_WIDTH-1 : 0] ram_addra_o;
    output [ADDR_WIDTH-1 : 0] ram_addrb_o;
    output [DATA_WIDTH-1 : 0] ram_dina_o;
    input  [DATA_WIDTH-1 : 0] ram_doutb_i;
    output ram_enb_o;
    
    reg [ADDR_WIDTH-1:0] wr_pointer;
    reg [ADDR_WIDTH-1:0] rd_pointer;
    reg [ADDR_WIDTH :0] status_cnt;
    reg [DATA_WIDTH-1:0] data_out ;
    wire [DATA_WIDTH-1:0] data_ram ;

    assign full = (status_cnt == (RAM_DEPTH-1));
    assign empty = (status_cnt == 0);

    always @ (posedge clk or posedge rstn)
    begin : WRITE_POINTER
      if (!rstn) begin
        wr_pointer <= 0;
      end else if (wr_cs && wr_en ) begin
        wr_pointer <= wr_pointer + 1;
      end
    end
    
    always @ (posedge clk or posedge rstn)
    begin : READ_POINTER
      if (!rstn) begin
        rd_pointer <= 0;
      end else if (rd_cs && rd_en ) begin
        rd_pointer <= rd_pointer + 1;
      end
    end
    always  @ (posedge clk or posedge rstn)
    begin : READ_DATA
      if (!rstn) begin
        data_out <= 0;
      end else if (rd_cs && rd_en ) begin
        data_out <= data_ram;
      end
    end
    
    always @ (posedge clk or posedge rstn)
    begin : STATUS_COUNTER
      if (!rstn) begin
        status_cnt <= 0;
      // Read but no write.
      end else if ((rd_cs && rd_en) &&  !(wr_cs && wr_en) && (status_cnt != 0)) begin
        status_cnt <= status_cnt - 1;
      // Write but no read.
      end else if ((wr_cs && wr_en) &&  ! (rd_cs && rd_en) && (status_cnt != RAM_DEPTH)) begin
        status_cnt <= status_cnt + 1;
      end
    end
    
    // RAM instance
    // WR port is A
    assign ram_dina_o = data_in;
    assign dout = ram_doutb_i;
    assign ram_ena_o = wr_cs;
    assign ram_wea_o = wr_en;
    assign ram_addra_o = wr_pointer;
    assign ram_addrb_o = rd_pointer;
    assign ram_enb_o = rd_en && rd_cs;
endmodule
