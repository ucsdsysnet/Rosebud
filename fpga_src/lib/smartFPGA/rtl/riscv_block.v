module riscv_block # (
  parameter DATA_WIDTH     = 128,
  parameter STRB_WIDTH     = (DATA_WIDTH/8),
  parameter IMEM_SIZE      = 65536,
  parameter PMEM_SIZE      = 1048576,
  parameter DMEM_SIZE      = 32768,
  parameter BC_REGION_SIZE = 4048,
  parameter BC_START_ADDR  = PMEM_SIZE+DMEM_SIZE-BC_REGION_SIZE,
  parameter MSG_ADDR_WIDTH = $clog2(BC_REGION_SIZE)-2,
  parameter MSG_WIDTH      = 32+4+MSG_ADDR_WIDTH,
  parameter SLOW_M_B_LINES = 4096,
  parameter FAST_M_B_LINES = 1024,
  parameter CORE_ID_WIDTH  = 4,
  parameter SLOT_COUNT     = 8,
  parameter SLOT_WIDTH     = $clog2(SLOT_COUNT+1)
) (
  input  wire                     sys_clk,
  input  wire                     sys_rst,
  input  wire                     core_rst,
  
  input  wire [CORE_ID_WIDTH-1:0] core_id,
  input  wire                     core_interrupt,
  output wire                     core_interrupt_ack,
  
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

  // Slot information from core
  output wire [SLOT_WIDTH-1:0]    slot_wr_ptr, 
  output wire [24:0]              slot_wr_addr,
  output wire                     slot_wr_valid,
  output wire                     slot_for_hdr,
  input  wire                     slot_wr_ready,
 
  // Received DRAM infor to core
  input  wire [4:0]               recv_dram_tag,
  input  wire                     recv_dram_tag_valid,

  // Broadcast messages
  input  wire [MSG_WIDTH-1:0]     bc_msg_in,
  input  wire                     bc_msg_in_valid,
  output wire [MSG_WIDTH-1:0]     bc_msg_out,
  output wire                     bc_msg_out_valid,
  input  wire                     bc_msg_out_ready
);

// Internal paramaters
parameter LINE_ADDR_BITS       = $clog2(STRB_WIDTH);
parameter PMEM_ADDR_WIDTH = $clog2(PMEM_SIZE);
parameter DMEM_ADDR_WIDTH = $clog2(DMEM_SIZE);
parameter IMEM_ADDR_WIDTH      = $clog2(IMEM_SIZE);

parameter ACC_ADDR_WIDTH       = $clog2(SLOW_M_B_LINES);
parameter PMEM_SEL_BITS   = PMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                                 -1-$clog2(SLOW_M_B_LINES);
parameter ACC_MEM_BLOCKS       = 2**PMEM_SEL_BITS;

///////////////////////////////////////////////////////////////////////////
//////////////////////////// RISCV CORE ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////
wire        core_dmem_en;
wire        core_pmem_en;
wire        core_exio_en;
wire        core_mem_wen;
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

assign core_mem_rd_data = core_exio_rd_valid ? core_exio_rd_data : core_dmem_rd_data;
assign core_mem_rd_valid = core_exio_rd_valid | core_dmem_rd_valid;

riscvcore #(
  .SLOT_COUNT(SLOT_COUNT),
  .SLOT_WIDTH(SLOT_WIDTH),
  .CORE_ID_WIDTH(CORE_ID_WIDTH),
  .IMEM_SIZE(IMEM_SIZE),
  .DMEM_SIZE(DMEM_SIZE),
  .PMEM_SIZE(PMEM_SIZE),
  .PMEM_SEG_SIZE(PMEM_SIZE/ACC_MEM_BLOCKS),
  .PMEM_SEG_COUNT(ACC_MEM_BLOCKS),
  .BC_REGION_SIZE(BC_REGION_SIZE)
) core (
  .clk(sys_clk),
  .rst(core_rst),
  .init_rst(sys_rst),
  .core_id(core_id),

  .dmem_en(core_dmem_en),
  .pmem_en(core_pmem_en),
  .exio_en(core_exio_en),
  .mem_wen(core_mem_wen),
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
  
  .recv_dram_tag_valid(recv_dram_tag_valid),    
  .recv_dram_tag(recv_dram_tag),

  .out_desc(out_desc),
  .out_desc_dram_addr(out_desc_dram_addr),
  .out_desc_valid(out_desc_valid),
  .out_desc_ready(out_desc_ready),
  
  .slot_wr_ptr(slot_wr_ptr), 
  .slot_wr_addr(slot_wr_addr),
  .slot_wr_valid(slot_wr_valid),
  .slot_for_hdr(slot_for_hdr),
  .slot_wr_ready(slot_wr_ready),

  .core_msg_ready(bc_msg_out_ready),
  .interrupt_in(core_interrupt),
  .interrupt_in_ack(core_interrupt_ack)
);

// Broadcast messaging
assign bc_msg_out[31:0]           = core_mem_wr_data;
assign bc_msg_out[35:32]          = core_mem_strb;
assign bc_msg_out[MSG_WIDTH-1:36] = core_mem_addr[MSG_ADDR_WIDTH+2-1:2];
assign bc_msg_out_valid           = core_dmem_en && core_mem_wen && 
                                   (core_mem_addr >= BC_START_ADDR); 

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
  .clk(sys_clk),
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
  .acc_rd_data_b2(acc_rd_data_b2)
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
  .clk(sys_clk),
  .rst(sys_rst),
  
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
  .acc_rd_data_b2(acc_rd_data_b2)
);
  
endmodule
