module riscv_block # (
  parameter DATA_WIDTH     = 128,
  parameter STRB_WIDTH     = (DATA_WIDTH/8),
  parameter IMEM_SIZE      = 65536,
  parameter SLOW_DMEM_SIZE = 1048576,
  parameter FAST_DMEM_SIZE = 32768,
  parameter BC_REGION_SIZE = 4048,
  parameter BC_START_ADDR  = SLOW_DMEM_SIZE+FAST_DMEM_SIZE-BC_REGION_SIZE,
  parameter MSG_WIDTH      = 32+4+$clog2(BC_REGION_SIZE)-2,
  parameter SLOW_M_B_LINES = 4096,
  parameter FAST_M_B_LINES = 1024,
  parameter CORE_ID_WIDTH  = 4,
  parameter SLOT_COUNT     = 8,
  parameter ADDR_WIDTH     = $clog2(SLOW_DMEM_SIZE)+2,
  parameter SLOT_WIDTH     = $clog2(SLOT_COUNT+1)
) (
  input  wire                     sys_clk,
  input  wire                     sys_rst,
  input  wire                     core_rst,
  input  wire [CORE_ID_WIDTH-1:0] core_id,
  
  // DMA interface
  input  wire                     dma_cmd_wr_en,
  input  wire [ADDR_WIDTH-1:0]    dma_cmd_wr_addr,
  input  wire [DATA_WIDTH-1:0]    dma_cmd_wr_data,
  input  wire [STRB_WIDTH-1:0]    dma_cmd_wr_strb,
  input  wire                     dma_cmd_wr_last,
  output wire                     dma_cmd_wr_ready,
  
  input  wire                     dma_cmd_rd_en,
  input  wire [ADDR_WIDTH-1:0]    dma_cmd_rd_addr,
  input  wire                     dma_cmd_rd_last,
  output wire                     dma_cmd_rd_ready,
  
  output wire                     dma_rd_resp_valid,
  output wire [DATA_WIDTH-1:0]    dma_rd_resp_data,
  input  wire                     dma_rd_resp_ready,
    
  // Descriptor to/from core 
  input  wire [63:0]              in_desc,
  input  wire                     in_desc_valid,
  output wire                     in_desc_taken,

  output wire [63:0]              data_desc,
  output wire [63:0]              dram_wr_addr,
  output wire                     data_desc_valid,
  input  wire                     data_desc_ready,

  // Slot information from core
  output wire [SLOT_WIDTH-1:0]    slot_wr_ptr, 
  output wire [ADDR_WIDTH-1:0]    slot_wr_addr,
  output wire                     slot_wr_valid,
  input  wire                     slot_wr_ready,
 
  // Received DRAM infor to core
  input  wire [4:0]               recv_dram_tag,
  input  wire                     recv_dram_tag_valid,
  
  // Broadcast messages
  input  wire [MSG_WIDTH-1:0]     bc_msg_in,
  input  wire                     bc_msg_in_valid,
  output wire [MSG_WIDTH-1:0]     bc_msg_out,
  output wire                     bc_msg_out_valid,
  input  wire                     bc_msg_out_ready,

  // Interrupt to core
  input  wire                     interrupt_in,
  output wire                     interrupt_in_ack
);

// Internal paramaters
parameter LINE_ADDR_BITS       = $clog2(STRB_WIDTH);
parameter SLOW_DMEM_ADDR_WIDTH = $clog2(SLOW_DMEM_SIZE);
parameter FAST_DMEM_ADDR_WIDTH = $clog2(FAST_DMEM_SIZE);
parameter IMEM_ADDR_WIDTH      = $clog2(IMEM_SIZE);

parameter ACC_ADDR_WIDTH       = $clog2(SLOW_M_B_LINES);
parameter SLOW_DMEM_SEL_BITS   = SLOW_DMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                                 -1-$clog2(SLOW_M_B_LINES);
parameter ACC_MEM_BLOCKS       = 2**SLOW_DMEM_SEL_BITS;

///////////////////////////////////////////////////////////////////////////////
////////////////////// RISCVCORE and MEMORY SYSTEM  ///////////////////////////
///////////////////////////////////////////////////////////////////////////////
wire [ACC_MEM_BLOCKS-1:0]                acc_en_b1 = {ACC_MEM_BLOCKS{1'b0}};
wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b1;
wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b1;
wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b1;
wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b1;

wire [ACC_MEM_BLOCKS-1:0]                acc_en_b2 = {ACC_MEM_BLOCKS{1'b0}};          
wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b2;
wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b2;
wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b2;
wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b2;

wire                                     core_dmem_en;
wire [STRB_WIDTH-1:0]                    core_dmem_wen;
wire [ADDR_WIDTH-1:0]                    core_dmem_addr;
wire [DATA_WIDTH-1:0]                    core_dmem_wr_data;
wire [DATA_WIDTH-1:0]                    core_dmem_rd_data;
wire                                     core_dmem_rd_valid;

wire                                     core_imem_ren;
wire [ADDR_WIDTH-1:0]                    core_imem_addr;
wire [DATA_WIDTH-1:0]                    core_imem_rd_data;

mem_sys # (
  .DATA_WIDTH(DATA_WIDTH),
  .STRB_WIDTH(STRB_WIDTH),
  .IMEM_SIZE(IMEM_SIZE),
  .SLOW_DMEM_SIZE(SLOW_DMEM_SIZE),
  .FAST_DMEM_SIZE(FAST_DMEM_SIZE),
  .BC_REGION_SIZE(BC_REGION_SIZE),
  .BC_START_ADDR(BC_START_ADDR),
  .MSG_WIDTH(MSG_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH),
  .SLOW_M_B_LINES(SLOW_M_B_LINES),
  .FAST_M_B_LINES(FAST_M_B_LINES)
) memories (
  .clk(sys_clk),
  .rst(sys_rst),
  
  .dma_cmd_wr_en(dma_cmd_wr_en),
  .dma_cmd_wr_addr(dma_cmd_wr_addr),
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
  .core_dmem_wen(core_dmem_wen),
  .core_dmem_addr(core_dmem_addr),
  .core_dmem_wr_data(core_dmem_wr_data),
  .core_dmem_rd_data(core_dmem_rd_data),
  .core_dmem_rd_valid(core_dmem_rd_valid),

  .core_imem_ren(core_imem_ren),
  .core_imem_addr(core_imem_addr),
  .core_imem_rd_data(core_imem_rd_data),
  
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

riscvcore #(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH),
  .IMEM_ADDR_WIDTH(IMEM_ADDR_WIDTH),
  .DMEM_ADDR_WIDTH(ADDR_WIDTH-1),    
  .BC_START_ADDR(BC_START_ADDR),
  .BC_REGION_SIZE(BC_REGION_SIZE),
  .SLOT_COUNT(SLOT_COUNT),
  .SLOT_WIDTH(SLOT_WIDTH),
  .CORE_ID_WIDTH(CORE_ID_WIDTH)
) core (
    .clk(sys_clk),
    .rst(core_rst),
    .init_rst(sys_rst),
    .core_id(core_id),

    .ext_dmem_en(core_dmem_en),
    .ext_dmem_wen(core_dmem_wen),
    .ext_dmem_addr(core_dmem_addr),
    .ext_dmem_wr_data(core_dmem_wr_data),
    .ext_dmem_rd_data(core_dmem_rd_data),
    .ext_dmem_rd_valid(core_dmem_rd_valid),
    
    .ext_imem_ren(core_imem_ren),
    .ext_imem_addr(core_imem_addr),
    .ext_imem_rd_data(core_imem_rd_data),
    
    .in_desc(in_desc),
    .in_desc_valid(in_desc_valid),
    .in_desc_taken(in_desc_taken),
    
    .recv_dram_tag_valid(recv_dram_tag_valid),    
    .recv_dram_tag(recv_dram_tag),

    .data_desc(data_desc),
    .dram_wr_addr(dram_wr_addr),
    .data_desc_valid(data_desc_valid),
    .data_desc_ready(data_desc_ready),
    
    .slot_wr_ptr(slot_wr_ptr), 
    .slot_wr_addr(slot_wr_addr),
    .slot_wr_valid(slot_wr_valid),
    .slot_wr_ready(slot_wr_ready),
 
    .core_msg_data(bc_msg_out[31:0]),
    .core_msg_addr(bc_msg_out[MSG_WIDTH-1:36]),
    .core_msg_strb(bc_msg_out[35:32]),
    .core_msg_valid(bc_msg_out_valid),
    .core_msg_ready(bc_msg_out_ready),

    .interrupt_in(interrupt_in),
    .interrupt_in_ack(interrupt_in_ack)
);

endmodule
