module riscvcore #(
  parameter DATA_WIDTH      = 64,
  parameter ADDR_WIDTH      = 16,
  parameter IMEM_SIZE_BYTES = 8192,
  parameter DMEM_SIZE_BYTES = 32768,
  parameter COHERENT_START  = 16'h6FFF,
  parameter STRB_WIDTH      = DATA_WIDTH/8,
  parameter LINE_ADDR_BITS  = $clog2(STRB_WIDTH),
  parameter IMEM_ADDR_WIDTH = $clog2(IMEM_SIZE_BYTES),
  parameter DMEM_ADDR_WIDTH = $clog2(DMEM_SIZE_BYTES)
)(
    input                        clk,
    input                        rst,

    input                        data_dma_en,
    input                        data_dma_ren,
    input  [STRB_WIDTH-1:0]      data_dma_wen,
    input  [ADDR_WIDTH-1:0]      data_dma_addr,
    input  [DATA_WIDTH-1:0]      data_dma_wr_data,
    output [DATA_WIDTH-1:0]      data_dma_rd_data,

    input  [STRB_WIDTH-1:0]      ins_dma_wen,
    input  [ADDR_WIDTH-1:0]      ins_dma_addr,
    input  [DATA_WIDTH-1:0]      ins_dma_wr_data,

    input  [63:0]                in_desc,
    input                        in_desc_valid,
    output                       in_desc_taken,

    output [63:0]                out_desc,
    output                       out_desc_valid,
    input                        out_desc_taken,

    output [31:0]                core_msg_data,
    output [DMEM_ADDR_WIDTH-1:0] core_msg_addr,
    output [3:0]                 core_msg_strb,
    output                       core_msg_valid
);

// Core to memory signals
wire [31:0] imem_read_data, dmem_wr_data, dmem_read_data; 
wire [31:0] imem_addr, dmem_addr;
wire dmem_v, dmem_wr_en, imem_v;
reg  dmem_read_ready, imem_read_ready;
reg  imem_access_err, dmem_access_err, desc_access_err;
wire [1:0] dmem_byte_count;
reg interrupt;
wire io_not_mem = dmem_addr[ADDR_WIDTH-1];
wire [4:0] dmem_word_write_mask;

VexRiscv core (
      .clk(clk),
      .reset(rst),

      .iBus_cmd_valid(imem_v),
      .iBus_cmd_ready(1'b1),
      .iBus_cmd_payload_pc(imem_addr),
      .iBus_rsp_valid(imem_read_ready),
      .iBus_rsp_payload_error(imem_access_err), //1'b0),
      .iBus_rsp_payload_inst(imem_read_data),

      .dBus_cmd_valid(dmem_v),
      .dBus_cmd_ready(1'b1),
      .dBus_cmd_payload_wr(dmem_wr_en),
      .dBus_cmd_payload_address(dmem_addr),
      .dBus_cmd_payload_data(dmem_wr_data),
      .dBus_cmd_payload_size(dmem_byte_count),
      .dBus_rsp_ready(dmem_read_ready),
      .dBus_rsp_error(dmem_access_err || desc_access_err), // 1'b0),
      .dBus_rsp_data(dmem_read_data),
      
      .timerInterrupt(), 
      .externalInterrupt(interrupt)
);

///////////////////////////////////////////////////////////////////////////
///////////////////// READ AND WRITE DESCRIPTORS //////////////////////////
///////////////////////////////////////////////////////////////////////////

// read desc is mapped to 0 and 4, write desc is mapped to 8 and 12
wire desc_wen = io_not_mem && dmem_v &&   dmem_wr_en &&    dmem_addr[3];
wire desc_ren = io_not_mem && dmem_v && (!dmem_wr_en) && (!dmem_addr[3]);
reg [63:0] out_desc_data;
reg [31:0] stat_internal_read;
reg out_desc_low_v, out_desc_high_v;
reg in_desc_low_read, in_desc_high_read;


// Byte writable out_desc
wire [7:0]  out_desc_write_mask = {4'd0, dmem_word_write_mask[3:0]} << {dmem_addr[2], 2'd0};
wire [63:0] out_desc_data_in    = {32'd0, dmem_wr_data} << {dmem_addr[2], 5'd0};
integer i;
always @ (posedge clk) 
    for (i = 0; i < 8; i = i + 1) 
        if (out_desc_write_mask[i] == 1'b1) 
            out_desc_data[i*8 +: 8] <= out_desc_data_in[i*8 +: 8];

always @ (posedge clk) begin
    if (rst) begin
            out_desc_high_v <= 1'b0;
            out_desc_low_v  <= 1'b0;
    end else begin
        if (desc_wen)
            if (dmem_addr[2]) begin
                out_desc_high_v <= 1'b1;
            end else begin
                out_desc_low_v <= 1'b1;
            end
        if (out_desc_valid && out_desc_taken) begin
                out_desc_high_v <= 1'b0;
                out_desc_low_v  <= 1'b0;
        end
    end
end

assign out_desc = out_desc_data;
assign out_desc_valid = out_desc_high_v && out_desc_low_v;

// pkt received/incoming descriptor
always @ (posedge clk) begin
    if (rst) begin
            in_desc_high_read  <= 1'b0;
            in_desc_low_read   <= 1'b0;
    end
    else begin
        if (desc_ren)
            if (in_desc_valid)
                if (dmem_addr[2]) begin
                    stat_internal_read <= in_desc[63:32];
                    in_desc_high_read  <= 1'b1;
                end else begin
                    stat_internal_read <= in_desc[31:0];
                    in_desc_low_read   <= 1'b1;
                end
            else begin
                    stat_internal_read <= 64'd0;
                    in_desc_high_read  <= 1'b0;
                    in_desc_low_read   <= 1'b0;
            end
        if (in_desc_taken && in_desc_valid) begin
            in_desc_high_read  <= 1'b0;
            in_desc_low_read   <= 1'b0;
        end
    end
end

assign in_desc_taken = in_desc_high_read && in_desc_low_read;

reg  desc_ren_r;
always @ (posedge clk)
    if (rst)
        desc_ren_r <= 1'b0;
    else
        desc_ren_r <= desc_ren;

///////////////////////////////////////////////////////////////////////////
///////////////////// CORE BROADCAST MESSAGING ////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Any write after the coherent point would become a message
assign core_msg_data  = dmem_wr_data;
assign core_msg_addr  = dmem_addr[DMEM_ADDR_WIDTH-1:0];
assign core_msg_strb  = dmem_word_write_mask[3:0];
assign core_msg_valid = dmem_v && dmem_wr_en && 
      (dmem_addr >= COHERENT_START) && (dmem_addr < (1 << DMEM_ADDR_WIDTH));
// Conversion from core dmem_byte_count to normal byte mask
assign dmem_word_write_mask = ((!dmem_wr_en) || (!dmem_v)) ? 5'h0 : 
								     			 	  (dmem_byte_count == 2'd0) ? (5'd1  << dmem_addr[1:0]) :
                              (dmem_byte_count == 2'd1) ? (5'd11 << dmem_addr[1:0]) :
                              5'h0f;

///////////////////////////////////////////////////////////////////////////
/////////////////////// WORD LENGTH ADJUSTMENT ////////////////////////////
///////////////////////////////////////////////////////////////////////////
wire [DATA_WIDTH-1:0] imem_data_out;
wire [DATA_WIDTH-1:0] dmem_data_in, dmem_data_out; 
wire [STRB_WIDTH-1:0] dmem_line_write_mask;

if (STRB_WIDTH==4) begin
    assign dmem_read_data = desc_ren_r ? stat_internal_read : dmem_data_out;
    assign dmem_line_write_mask = dmem_word_write_mask[3:0];
    assign dmem_data_in   = dmem_wr_data;
end else begin
    wire [DATA_WIDTH-1:0] dmem_data_out_shifted; 
    reg  [LINE_ADDR_BITS-3:0] dmem_latched_addr;
    localparam REMAINED_BYTES = STRB_WIDTH-4;
    localparam REMAINED_BITS  = 8*REMAINED_BYTES;

    always @ (posedge clk)
        dmem_latched_addr <= dmem_addr[LINE_ADDR_BITS-1:2];

    assign dmem_data_out_shifted = dmem_data_out >> {dmem_latched_addr, 5'd0};
    assign dmem_read_data = desc_ren_r ? stat_internal_read : dmem_data_out_shifted[31:0];
    assign dmem_line_write_mask = 
                         {{REMAINED_BYTES{1'b0}}, dmem_word_write_mask[3:0]} 
                         << {dmem_addr[LINE_ADDR_BITS-1:2], 2'd0};
    assign dmem_data_in =  
                         {{REMAINED_BITS{1'b0}}, dmem_wr_data} 
                         << {dmem_addr[LINE_ADDR_BITS-1:2], 5'd0};
end

if (STRB_WIDTH==4) begin
    assign imem_read_data = imem_data_out;
end else begin
    wire [DATA_WIDTH-1:0] imem_data_out_shifted;
    reg [LINE_ADDR_BITS-3:0] imem_latched_addr;

    always @ (posedge clk)
        imem_latched_addr <= imem_addr[LINE_ADDR_BITS-1:2];

    assign imem_data_out_shifted = imem_data_out >> {imem_latched_addr, 5'd0};
    assign imem_read_data = imem_data_out_shifted[31:0];
end

///////////////////////////////////////////////////////////////////////////
//////////////////////////// MEMORY UNITS /////////////////////////////////
///////////////////////////////////////////////////////////////////////////
mem_2rw #(
  .BYTES_PER_LINE(STRB_WIDTH),
  .ADDR_WIDTH(DMEM_ADDR_WIDTH-LINE_ADDR_BITS)    
) dmem (
  .clk(clk),
  .ena(dmem_v && (!io_not_mem)),
  .rena(!(|dmem_line_write_mask)),
  .wena(dmem_line_write_mask),
  .addra(dmem_addr[DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS]),
  .dina(dmem_data_in),
  .douta(dmem_data_out),

  .enb(data_dma_en),
  .renb(data_dma_ren),
  .wenb(data_dma_wen),
  .addrb(data_dma_addr[DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS]),
  .dinb(data_dma_wr_data),
  .doutb(data_dma_rd_data)
);

mem_1r1w #(
  .BYTES_PER_LINE(STRB_WIDTH),
  .ADDR_WIDTH(IMEM_ADDR_WIDTH-LINE_ADDR_BITS)    
) imem (
  .clk(clk),
  .ena(|(ins_dma_wen)),
  .wea(ins_dma_wen),
  .addra(ins_dma_addr[IMEM_ADDR_WIDTH-1:LINE_ADDR_BITS]),
  .dina(ins_dma_wr_data),

  .enb(imem_v),
  .addrb(imem_addr[IMEM_ADDR_WIDTH-1:LINE_ADDR_BITS]),
  .doutb(imem_data_out)
);

///////////////////////////////////////////////////////////////////////////
/////////////////////// ADDRESS ERROR CATCHING ////////////////////////////
///////////////////////////////////////////////////////////////////////////

always @ (posedge clk)
    if (rst) begin
		    dmem_read_ready <= 1'b0;
		    imem_read_ready <= 1'b0;
        imem_access_err <= 1'b0;
        dmem_access_err <= 1'b0;
        desc_access_err <= 1'b0;
		end else begin
			  dmem_read_ready <= dmem_v;
		    imem_read_ready <= imem_v;
        imem_access_err <= imem_access_err || (imem_v && 
                                (imem_addr >= (1 << IMEM_ADDR_WIDTH)));

        dmem_access_err <= dmem_access_err || (dmem_v && 
                                ((!io_not_mem && (dmem_addr >= (1 << DMEM_ADDR_WIDTH)))
                                || (dmem_addr >= ((1 << (ADDR_WIDTH-1))+16))));
                       
        desc_access_err <= desc_access_err || (io_not_mem && dmem_v && 
            ((dmem_wr_en && !dmem_addr[3]) || (!dmem_wr_en && dmem_addr[3])));

    end

// External memory access out of bound detection
wire out_of_bound = (data_dma_en && (|data_dma_addr[ADDR_WIDTH-1:DMEM_ADDR_WIDTH])) ||
                 ((|ins_dma_wen)  && (|ins_dma_addr[ADDR_WIDTH-1:IMEM_ADDR_WIDTH]));

// If an error occures the interrupt line stays high until core is reset
always @ (posedge clk)
    if (rst)
        interrupt <= 1'b0;
    else 
        interrupt <= interrupt || out_of_bound;

endmodule
