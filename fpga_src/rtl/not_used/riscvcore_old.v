module riscvcore #(
  parameter IMEM_BYTES_PER_LINE = 4,
  parameter DMEM_BYTES_PER_LINE = 4,
  parameter IMEM_SIZE_BYTES     = 8192,
  parameter DMEM_SIZE_BYTES     = 32768,
  parameter CONTROL_BIT_LOC     = 16,
  parameter STAT_ADDR_WIDTH     = 1,

  parameter IMEM_LINE_SIZE      = 8*IMEM_BYTES_PER_LINE,
  parameter DMEM_LINE_SIZE      = 8*DMEM_BYTES_PER_LINE,
  parameter IMEM_LINE_ADDR_BITS = $clog2(IMEM_BYTES_PER_LINE),
  parameter DMEM_LINE_ADDR_BITS = $clog2(DMEM_BYTES_PER_LINE),
  parameter IMEM_ADDR_WIDTH     = $clog2(IMEM_SIZE_BYTES),
  parameter DMEM_ADDR_WIDTH     = $clog2(DMEM_SIZE_BYTES)
)(
    input clk,
    input core_reset,

    input                            data_dma_en,
    input  [DMEM_BYTES_PER_LINE-1:0] data_dma_we,
    input  [DMEM_ADDR_WIDTH-1:0]     data_dma_addr,
    input  [DMEM_LINE_SIZE-1:0]      data_dma_wr_data,
    output [DMEM_LINE_SIZE-1:0]      data_dma_read_data,

    input                            ins_dma_wen,
    input  [IMEM_ADDR_WIDTH-1:0]     ins_dma_stat_addr,
    input  [IMEM_LINE_SIZE-1:0]      ins_dma_wr_data,

    input                            stat_rd_en,
    output [31:0]                    stat_rd_data,
    output                           status_update
);

// Core to memory signals
wire [31:0] imem_read_data, dmem_wr_data, dmem_read_data; 
wire [31:0] imem_addr, dmem_addr;
wire dmem_v, dmem_wr_en, imem_v;
reg  dmem_read_ready, imem_read_ready;
wire [1:0] dmem_byte_count;

VexRiscv core (
      .clk(clk),
      .reset(core_reset),

      .iBus_cmd_valid(imem_v),
      .iBus_cmd_ready(1'b1),
      .iBus_cmd_payload_pc(imem_addr),
      .iBus_rsp_valid(imem_read_ready),
      .iBus_rsp_payload_error(1'b0),
      .iBus_rsp_payload_inst(imem_read_data),

      .dBus_cmd_valid(dmem_v),
      .dBus_cmd_ready(1'b1),
      .dBus_cmd_payload_wr(dmem_wr_en),
      .dBus_cmd_payload_address(dmem_addr),
      .dBus_cmd_payload_data(dmem_wr_data),
      .dBus_cmd_payload_size(dmem_byte_count),
      .dBus_rsp_ready(dmem_read_ready),
      .dBus_rsp_error(1'b0),
      .dBus_rsp_data(dmem_read_data)
);

always @ (posedge clk)
    if (core_reset) begin
		    dmem_read_ready <= 1'b0;
		    imem_read_ready <= 1'b0;
		end else begin
			  dmem_read_ready <= dmem_v;
		    imem_read_ready <= imem_v;
    end

// Conversion from core dmem_byte_count to normal byte mask
wire [4:0] dmem_word_write_mask;
assign dmem_word_write_mask = ((!dmem_wr_en) || (!dmem_v)) ? 5'h0 : 
								     			 	  (dmem_byte_count == 2'd0) ? (5'd1  << dmem_addr[1:0]) :
                              (dmem_byte_count == 2'd1) ? (5'd11 << dmem_addr[1:0]) :
                              5'h0f;

// memory mapped status registers 
wire io_not_mem = dmem_addr[CONTROL_BIT_LOC-1];
wire status_wen = io_not_mem && dmem_v && dmem_wr_en;
wire status_ren = io_not_mem && dmem_v && (!dmem_wr_en);
reg  status_ren_r;

reg [31:0] status_reg [0:(2**STAT_ADDR_WIDTH)-1];
reg [31:0] stat_read, stat_internal_read;
reg stat_update;

integer i;

always @ (posedge clk)
    if (core_reset)
        for (i = 0; i < 2**STAT_ADDR_WIDTH; i = i + 1)
            status_reg[i] <= 0;
    else if (status_wen)
        for (i = 0; i < 4; i = i + 1) 
            if (dmem_word_write_mask[i] == 1'b1) 
                status_reg[dmem_addr[STAT_ADDR_WIDTH-1+2:2]][i*8 +: 8] 
                            <= dmem_wr_data[i*8 +: 8];

always @ (posedge clk)
    if (core_reset)
        status_ren_r <= 1'b0;
    else
        status_ren_r <= status_ren;

always @ (posedge clk)
    if (status_ren)
        stat_internal_read <= status_reg[dmem_addr[STAT_ADDR_WIDTH-1+2:2]];

always @ (posedge clk)
    if (stat_rd_en)
        stat_read <= status_reg[ins_dma_stat_addr[STAT_ADDR_WIDTH-1+2:2]];


// Conversion from 32-bit values to longer line size
wire [IMEM_LINE_SIZE-1:0] imem_data_out;
wire [DMEM_LINE_SIZE-1:0] dmem_data_in, dmem_data_out; 
wire [DMEM_BYTES_PER_LINE-1:0] dmem_line_write_mask;


if (DMEM_BYTES_PER_LINE==4) begin
    assign dmem_read_data = status_ren_r ? stat_internal_read : dmem_data_out;
    assign dmem_line_write_mask = dmem_word_write_mask[3:0];
    assign dmem_data_in   = dmem_wr_data;
end else begin
    wire [DMEM_LINE_SIZE-1:0] dmem_data_out_shifted; 
    reg  [DMEM_LINE_ADDR_BITS-3:0] dmem_latched_addr;
    localparam REMAINED_BYTES = DMEM_BYTES_PER_LINE-4;
    localparam REMAINED_BITS  = 8*REMAINED_BYTES;

    always @ (posedge clk)
        dmem_latched_addr <= dmem_addr[DMEM_LINE_ADDR_BITS-1:2];

    assign dmem_data_out_shifted = dmem_data_out >> {dmem_latched_addr, 5'd0};
    assign dmem_read_data = status_ren_r ? stat_internal_read : dmem_data_out_shifted[31:0];
    assign dmem_line_write_mask = 
                         {{REMAINED_BYTES{1'b0}}, dmem_word_write_mask[3:0]} 
                         << {dmem_addr[DMEM_LINE_ADDR_BITS-1:2], 2'd0};
    assign dmem_data_in =  
                         {{REMAINED_BITS{1'b0}}, dmem_wr_data} 
                         << {dmem_addr[DMEM_LINE_ADDR_BITS-1:2], 5'd0};
end

if (IMEM_BYTES_PER_LINE==4) begin
    assign imem_read_data = imem_data_out;
end else begin
    wire [IMEM_LINE_SIZE-1:0] imem_data_out_shifted;
    reg [IMEM_LINE_ADDR_BITS-3:0] imem_latched_addr;

    always @ (posedge clk)
        imem_latched_addr <= imem_addr[IMEM_LINE_ADDR_BITS-1:2];

    assign imem_data_out_shifted = imem_data_out >> {imem_latched_addr, 5'd0};
    assign imem_read_data = imem_data_out_shifted[31:0];
end

// If stat read and new stat write happen at the same cycle stat_update stays high
always @ (posedge clk)
    if (core_reset)
        stat_update <= 1'b0;
    else if (status_wen)
        stat_update <= 1'b1;
    else if (stat_rd_en)
        stat_update <= 1'b0;

assign stat_rd_data  = stat_read;
assign status_update = stat_update;

// Memory units
masked_mem #(
  .BYTES_PER_LINE(DMEM_BYTES_PER_LINE),
  .ADDR_WIDTH(DMEM_ADDR_WIDTH-DMEM_LINE_ADDR_BITS)    
) dmem (
  .clk(clk),
  .ena(dmem_v && (!io_not_mem)),
  .wea(dmem_line_write_mask),
  .addra(dmem_addr[DMEM_ADDR_WIDTH-1:DMEM_LINE_ADDR_BITS]),
  .dina(dmem_data_in),
  .douta(dmem_data_out),

  .enb(data_dma_en),
  .web(data_dma_we),
  .addrb(data_dma_addr[DMEM_ADDR_WIDTH-1:DMEM_LINE_ADDR_BITS]),
  .dinb(data_dma_wr_data),
  .doutb(data_dma_read_data)
);

Imem #(
  .BYTES_PER_LINE(IMEM_BYTES_PER_LINE),
  .ADDR_WIDTH(IMEM_ADDR_WIDTH-IMEM_LINE_ADDR_BITS)    
) imem (
  .clk(clk),
  .ena(ins_dma_wen),
  .wea(ins_dma_wen),
  .addra(ins_dma_stat_addr[IMEM_ADDR_WIDTH-1:IMEM_LINE_ADDR_BITS]),
  .dina(ins_dma_wr_data),

  .enb(imem_v),
  .addrb(imem_addr[IMEM_ADDR_WIDTH-1:IMEM_LINE_ADDR_BITS]),
  .doutb(imem_data_out)
);

endmodule
