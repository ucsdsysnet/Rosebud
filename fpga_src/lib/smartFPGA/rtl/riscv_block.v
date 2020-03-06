module riscv_block # (
  parameter DATA_WIDTH     = 128,
  parameter STRB_WIDTH     = (DATA_WIDTH/8),
  parameter IMEM_SIZE      = 65536,
  parameter PMEM_SIZE      = 1048576,
  parameter DMEM_SIZE      = 32768,
  parameter BC_REGION_SIZE = 4048,
  parameter BC_START_ADDR  = 32'h00800000+DMEM_SIZE-BC_REGION_SIZE,
  parameter MSG_ADDR_WIDTH = $clog2(BC_REGION_SIZE)-2,
  parameter MSG_WIDTH      = 32+4+MSG_ADDR_WIDTH,
  parameter SLOW_M_B_LINES = 4096,
  parameter FAST_M_B_LINES = 1024,
  parameter CORE_ID_WIDTH  = 4
) (
  input  wire                     clk,
  input  wire                     rst,
  input  wire                     core_rst,

  input  wire                     evict_int,
  output wire                     evict_int_ack,
  input  wire                     poke_int,
  output wire                     poke_int_ack,

  // DMA interface
  input  wire                     dma_cmd_wr_en,
  input  wire [25:0]              dma_cmd_wr_addr,
  input  wire                     dma_cmd_hdr_wr_en,
  input  wire [23:0]              dma_cmd_hdr_wr_addr,
  input  wire [DATA_WIDTH-1:0]    dma_cmd_wr_data,
  input  wire [STRB_WIDTH-1:0]    dma_cmd_wr_strb,
  input  wire                     dma_cmd_wr_last,
  output wire                     dma_cmd_wr_ready,

  input  wire                     dma_cmd_rd_en,
  input  wire [25:0]              dma_cmd_rd_addr,
  input  wire                     dma_cmd_rd_last,
  output wire                     dma_cmd_rd_ready,

  output wire                     dma_rd_resp_valid,
  output wire [DATA_WIDTH-1:0]    dma_rd_resp_data,
  input  wire                     dma_rd_resp_ready,

  // Descriptor to/from core
  input  wire [63:0]              in_desc,
  input  wire                     in_desc_valid,
  output wire                     in_desc_taken,

  output wire [63:0]              out_desc,
  output wire [63:0]              out_desc_dram_addr,
  output wire                     out_desc_valid,
  input  wire                     out_desc_ready,

  // Received DRAM and active slot info to core
  input  wire [4:0]               recv_dram_tag,
  input  wire                     recv_dram_tag_valid,

  // Broadcast messages
  input  wire [MSG_WIDTH-1:0]     bc_msg_in,
  input  wire                     bc_msg_in_valid,
  output wire [MSG_WIDTH-1:0]     bc_msg_out,
  output wire                     bc_msg_out_valid,
  input  wire                     bc_msg_out_ready,

  // Status channel to core
  input  wire [31:0]              wrapper_status_data,
  input  wire [1:0]               wrapper_status_addr,
  input  wire                     wrapper_status_valid,
  output wire                     wrapper_status_ready,

  // Status channel from core
  output wire [31:0]              core_status_data,
  output wire [1:0]               core_status_addr,
  output wire                     core_status_valid,
  input  wire                     core_status_ready
);

// Internal paramaters
parameter PMEM_ADDR_WIDTH = $clog2(PMEM_SIZE);
parameter ACC_ADDR_WIDTH  = $clog2(SLOW_M_B_LINES);
parameter PMEM_SEL_BITS   = PMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                            -1-$clog2(SLOW_M_B_LINES);
parameter ACC_MEM_BLOCKS  = 2**PMEM_SEL_BITS;

///////////////////////////////////////////////////////////////////////////
///////////////////////////// STATUS CHANNEL //////////////////////////////
///////////////////////////////////////////////////////////////////////////
reg  [63:0] debug_in;
reg  [31:0] active_slots;
reg  [15:0] bc_region_size;
reg  [7:0]  core_id;
reg  [7:0]  max_slot_count;

wire [31:0] slot_wr_data;
wire        slot_wr_valid;
wire        slot_wr_ready;
wire [63:0] debug_out;
wire        debug_out_l_valid;
wire        debug_out_h_valid;
wire [7:0]  core_errors;
wire        ready_to_evict;
wire [7:0]  mem_fifo_fulls;

always @ (posedge clk) begin
  if (wrapper_status_valid)
    case (wrapper_status_addr)
      2'b00: begin
             bc_region_size  <= wrapper_status_data[15:0];
             max_slot_count  <= wrapper_status_data[23:16];
             core_id         <= wrapper_status_data[31:24];
      end
      2'b01: active_slots    <= wrapper_status_data;
      2'b10: debug_in[31:0]  <= wrapper_status_data;
      2'b11: debug_in[63:32] <= wrapper_status_data;
    endcase

  if (core_rst)
      active_slots <= 32'd0;
end

assign wrapper_status_ready = 1'b1;


assign core_status_valid = 1'b1;
assign core_status_addr = slot_wr_valid   ? 2'd1 :
                          debug_out_l_valid ? 2'd2 : 
                          debug_out_h_valid ? 2'd3 : 
                          2'd0;
assign core_status_data = slot_wr_valid   ? slot_wr_data :
                          debug_out_l_valid ? debug_out[31:0] :
                          debug_out_h_valid ? debug_out[63:32] :
                          {14'd0, core_rst, ready_to_evict, mem_fifo_fulls, core_errors};
assign slot_wr_ready    = core_status_ready;
///////////////////////////////////////////////////////////////////////////
//////////////////////////// RISCV CORE ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////
wire        core_dmem_en;
wire        core_pmem_en;
wire        core_exio_en;
wire        core_mem_wen;
wire        core_mem_ready;
wire [3:0]  core_mem_strb;
wire [24:0] core_mem_addr;
wire [31:0] core_mem_wr_data;
wire [31:0] core_mem_rd_data;
wire        core_mem_rd_valid;

wire [31:0] core_dmem_rd_data;
wire        core_dmem_rd_valid;
wire [31:0] core_exio_rd_data;
wire        core_exio_rd_valid;

wire        core_imem_ren;
wire [24:0] core_imem_addr;
wire [31:0] core_imem_rd_data;
wire        core_imem_rd_valid;

wire ext_io_err, ext_io_err_ack;

assign core_mem_rd_data  = core_exio_rd_valid ?  core_exio_rd_data : core_dmem_rd_data;
assign core_mem_rd_valid = core_exio_rd_valid || core_dmem_rd_valid;
assign core_mem_ready    = !bc_msg_out_valid  || bc_msg_out_ready;

riscvcore #(
  .IMEM_SIZE(IMEM_SIZE),
  .DMEM_SIZE(DMEM_SIZE),
  .PMEM_SIZE(PMEM_SIZE),
  .PMEM_SEG_SIZE(PMEM_SIZE/ACC_MEM_BLOCKS),
  .PMEM_SEG_COUNT(ACC_MEM_BLOCKS)
) core (
  .clk(clk),
  .rst(core_rst),
  .init_rst(rst),

  .dmem_en(core_dmem_en),
  .pmem_en(core_pmem_en),
  .exio_en(core_exio_en),
  .mem_wen(core_mem_wen),
  .mem_ready(core_mem_ready),
  .mem_strb(core_mem_strb),
  .mem_addr(core_mem_addr),
  .mem_wr_data(core_mem_wr_data),
  .mem_rd_data(core_mem_rd_data),
  .mem_rd_valid(core_mem_rd_valid),

  .imem_ren(core_imem_ren),
  .imem_addr(core_imem_addr),
  .imem_rd_data(core_imem_rd_data),
  .imem_rd_valid(core_imem_rd_valid),

  .in_desc(in_desc),
  .in_desc_valid(in_desc_valid),
  .in_desc_taken(in_desc_taken),

  .out_desc(out_desc),
  .out_desc_dram_addr(out_desc_dram_addr),
  .out_desc_valid(out_desc_valid),
  .out_desc_ready(out_desc_ready),

  .active_slots(active_slots),
  .bc_region_size(bc_region_size),
  .core_id(core_id),
  .max_slot_count(max_slot_count),
  .debug_in(debug_in),
  .core_msg_ready(bc_msg_out_ready),

  .slot_wr_data(slot_wr_data),
  .slot_wr_valid(slot_wr_valid),
  .slot_wr_ready(slot_wr_ready),
  .debug_out(debug_out),
  .debug_out_l_valid(debug_out_l_valid),
  .debug_out_h_valid(debug_out_h_valid),
  .core_errors(core_errors),
  .ready_to_evict(ready_to_evict),

  .ext_io_err(ext_io_err),
  .ext_io_err_ack(ext_io_err_ack),

  .evict_int(evict_int),
  .evict_int_ack(evict_int_ack),
  .poke_int(poke_int),
  .poke_int_ack(poke_int_ack),
  .recv_dram_tag_valid(recv_dram_tag_valid),
  .recv_dram_tag(recv_dram_tag)
);

// Broadcast messaging
assign bc_msg_out[31:0]           = core_mem_wr_data;
assign bc_msg_out[35:32]          = core_mem_strb;
assign bc_msg_out[MSG_WIDTH-1:36] = core_mem_addr[MSG_ADDR_WIDTH+2-1:2];
assign bc_msg_out_valid           = core_dmem_en && core_mem_wen &&
                    (&core_mem_addr[$clog2(DMEM_SIZE)-1:$clog2(BC_REGION_SIZE)]);

///////////////////////////////////////////////////////////////////////////
////////////////////////// ACCELERATORS ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////
wire [ACC_MEM_BLOCKS-1:0]                acc_en_b1;
wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b1;
wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b1;
wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b1;
wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b1;

wire [ACC_MEM_BLOCKS-1:0]                acc_en_b2;
wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b2;
wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b2;
wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b2;
wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b2;

accel_wrap #(
  .DATA_WIDTH(DATA_WIDTH),
  .STRB_WIDTH(STRB_WIDTH),
  .PMEM_ADDR_WIDTH(PMEM_ADDR_WIDTH),
  .SLOW_M_B_LINES(SLOW_M_B_LINES),
  .ACC_ADDR_WIDTH(ACC_ADDR_WIDTH),
  .PMEM_SEL_BITS(PMEM_SEL_BITS),
  .ACC_MEM_BLOCKS(ACC_MEM_BLOCKS)
) accel_wrap_inst (
  .clk(clk),
  .rst(core_rst),

  .io_en(core_exio_en),
  .io_wen(core_mem_wen),
  .io_strb(core_mem_strb),
  .io_addr(core_mem_addr[21:0]),
  .io_wr_data(core_mem_wr_data),
  .io_rd_data(core_exio_rd_data),
  .io_rd_valid(core_exio_rd_valid),

  .acc_en_b1(acc_en_b1),
  .acc_wen_b1(acc_wen_b1),
  .acc_addr_b1(acc_addr_b1),
  .acc_wr_data_b1(acc_wr_data_b1),
  .acc_rd_data_b1(acc_rd_data_b1),

  .acc_en_b2(acc_en_b2),
  .acc_wen_b2(acc_wen_b2),
  .acc_addr_b2(acc_addr_b2),
  .acc_wr_data_b2(acc_wr_data_b2),
  .acc_rd_data_b2(acc_rd_data_b2),

  .error(ext_io_err),
  .error_ack(ext_io_err_ack)
);

///////////////////////////////////////////////////////////////////////////
/////////////////////// HYBRID MEMORY SYSTEM //////////////////////////////
///////////////////////////////////////////////////////////////////////////
mem_sys # (
  .DATA_WIDTH(DATA_WIDTH),
  .STRB_WIDTH(STRB_WIDTH),
  .IMEM_SIZE(IMEM_SIZE),
  .PMEM_SIZE(PMEM_SIZE),
  .DMEM_SIZE(DMEM_SIZE),
  .BC_REGION_SIZE(BC_REGION_SIZE),
  .BC_START_ADDR(BC_START_ADDR),
  .MSG_WIDTH(MSG_WIDTH),
  .SLOW_M_B_LINES(SLOW_M_B_LINES),
  .FAST_M_B_LINES(FAST_M_B_LINES)
) memories (
  .clk(clk),
  .rst(rst),

  .dma_cmd_wr_en(dma_cmd_wr_en),
  .dma_cmd_wr_addr(dma_cmd_wr_addr),
  .dma_cmd_hdr_wr_en(dma_cmd_hdr_wr_en),
  .dma_cmd_hdr_wr_addr(dma_cmd_hdr_wr_addr),
  .dma_cmd_wr_data(dma_cmd_wr_data),
  .dma_cmd_wr_strb(dma_cmd_wr_strb),
  .dma_cmd_wr_last(dma_cmd_wr_last),
  .dma_cmd_wr_ready(dma_cmd_wr_ready),

  .dma_cmd_rd_en(dma_cmd_rd_en),
  .dma_cmd_rd_addr(dma_cmd_rd_addr),
  .dma_cmd_rd_last(dma_cmd_rd_last),
  .dma_cmd_rd_ready(dma_cmd_rd_ready),

  .dma_rd_resp_valid(dma_rd_resp_valid),
  .dma_rd_resp_data(dma_rd_resp_data),
  .dma_rd_resp_ready(dma_rd_resp_ready),

  .core_dmem_en(core_dmem_en),
  .core_pmem_en(core_pmem_en),
  .core_dmem_wen(core_mem_wen),
  .core_dmem_strb(core_mem_strb),
  .core_dmem_addr(core_mem_addr),
  .core_dmem_wr_data(core_mem_wr_data),
  .core_dmem_rd_data(core_dmem_rd_data),
  .core_dmem_rd_valid(core_dmem_rd_valid),

  .core_imem_ren(core_imem_ren),
  .core_imem_addr(core_imem_addr),
  .core_imem_rd_data(core_imem_rd_data),
  .core_imem_rd_valid(core_imem_rd_valid),

  .bc_msg_in(bc_msg_in),
  .bc_msg_in_valid(bc_msg_in_valid),

  .acc_en_b1(acc_en_b1),
  .acc_wen_b1(acc_wen_b1),
  .acc_addr_b1(acc_addr_b1),
  .acc_wr_data_b1(acc_wr_data_b1),
  .acc_rd_data_b1(acc_rd_data_b1),

  .acc_en_b2(acc_en_b2),
  .acc_wen_b2(acc_wen_b2),
  .acc_addr_b2(acc_addr_b2),
  .acc_wr_data_b2(acc_wr_data_b2),
  .acc_rd_data_b2(acc_rd_data_b2),

  .mem_fifo_fulls(mem_fifo_fulls)
);

endmodule
