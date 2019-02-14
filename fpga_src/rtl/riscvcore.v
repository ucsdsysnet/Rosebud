module riscvcore #(
  parameter DATA_WIDTH      = 64,
  parameter ADDR_WIDTH      = 16,
  parameter IMEM_SIZE_BYTES = 8192,
  parameter DMEM_SIZE_BYTES = 32768,
  parameter STAT_ADDR_WIDTH = 1,

  parameter STRB_WIDTH      = DATA_WIDTH/8,
  parameter LINE_ADDR_BITS  = $clog2(STRB_WIDTH),
  parameter IMEM_ADDR_WIDTH = $clog2(IMEM_SIZE_BYTES),
  parameter DMEM_ADDR_WIDTH = $clog2(DMEM_SIZE_BYTES)
)(
    input                   clk,
    input                   core_reset,

    input                   data_dma_en,
    input                   data_dma_ren,
    input  [STRB_WIDTH-1:0] data_dma_wen,
    input  [ADDR_WIDTH-1:0] data_dma_addr,
    input  [DATA_WIDTH-1:0] data_dma_wr_data,
    output [DATA_WIDTH-1:0] data_dma_rd_data,

    input  [STRB_WIDTH-1:0] ins_dma_wen,
    input  [ADDR_WIDTH-1:0] ins_dma_addr,
    input  [DATA_WIDTH-1:0] ins_dma_wr_data,

    input                   stat_rd_en,
    input  [ADDR_WIDTH-1:0] stat_rd_addr,
    output [31:0]           stat_rd_data,

    output                  status_update
);

// External memory access out of bound detection
wire out_of_bound = (data_dma_en && (|data_dma_addr[ADDR_WIDTH-1:DMEM_ADDR_WIDTH])) ||
                 ((|ins_dma_wen)  && (|ins_dma_addr[ADDR_WIDTH-1:IMEM_ADDR_WIDTH])) ||
                 (stat_rd_en  && (|stat_rd_addr[ADDR_WIDTH-1:STAT_ADDR_WIDTH]));

// If an error occures the interrupt line stays high until core is reset
reg interrupt;
always @ (posedge clk)
    if (core_reset)
        interrupt <= 1'b0;
    else 
        interrupt <= interrupt || out_of_bound;

// Core to memory signals
wire [31:0] imem_read_data, dmem_wr_data, dmem_read_data; 
wire [31:0] imem_addr, dmem_addr;
wire dmem_v, dmem_wr_en, imem_v;
reg  dmem_read_ready, imem_read_ready;
reg  imem_access_err, dmem_access_err;
wire [1:0] dmem_byte_count;

VexRiscv core (
      .clk(clk),
      .reset(core_reset),

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
      .dBus_rsp_error(dmem_access_err), // 1'b0),
      .dBus_rsp_data(dmem_read_data),
      
      .timerInterrupt(), 
      .externalInterrupt(interrupt)
);

// Memory/status_reg addressing and out of bound detection
wire io_not_mem = dmem_addr[ADDR_WIDTH-1];
wire status_wen = io_not_mem && dmem_v && dmem_wr_en;
wire status_ren = io_not_mem && dmem_v && (!dmem_wr_en);

always @ (posedge clk)
    if (core_reset) begin
		    dmem_read_ready <= 1'b0;
		    imem_read_ready <= 1'b0;
        imem_access_err <= 1'b0;
        dmem_access_err <= 1'b0;
		end else begin
			  dmem_read_ready <= dmem_v;
		    imem_read_ready <= imem_v;
        imem_access_err <= imem_access_err || 
                           (imem_v && (|imem_addr[31:IMEM_ADDR_WIDTH]));
        dmem_access_err <= dmem_access_err || 
            (dmem_v && (((!io_not_mem) && (|dmem_addr[31:DMEM_ADDR_WIDTH]))
                       || (io_not_mem && ((|dmem_addr[31:ADDR_WIDTH]) || 
                                          (|dmem_addr[ADDR_WIDTH-2:STAT_ADDR_WIDTH])))));
    end

// Conversion from core dmem_byte_count to normal byte mask
wire [4:0] dmem_word_write_mask;
assign dmem_word_write_mask = ((!dmem_wr_en) || (!dmem_v)) ? 5'h0 : 
								     			 	  (dmem_byte_count == 2'd0) ? (5'd1  << dmem_addr[1:0]) :
                              (dmem_byte_count == 2'd1) ? (5'd11 << dmem_addr[1:0]) :
                              5'h0f;

// memory mapped status registers and read/write from core
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
        stat_read <= status_reg[stat_rd_addr[STAT_ADDR_WIDTH-1+2:2]];


/// Conversion from 32-bit values to longer line size
wire [DATA_WIDTH-1:0] imem_data_out;
wire [DATA_WIDTH-1:0] dmem_data_in, dmem_data_out; 
wire [STRB_WIDTH-1:0] dmem_line_write_mask;

if (STRB_WIDTH==4) begin
    assign dmem_read_data = status_ren_r ? stat_internal_read : dmem_data_out;
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
    assign dmem_read_data = status_ren_r ? stat_internal_read : dmem_data_out_shifted[31:0];
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

// ADD exception for out of bound mem access, both from DMA side and core side

endmodule
