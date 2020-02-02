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
  input  wire                     core_interrupt,
  output wire                     core_interrupt_ack,
  
  // DMA interface
  input  wire                     dma_cmd_wr_en,
  input  wire [ADDR_WIDTH-1:0]    dma_cmd_wr_addr,
  input  wire                     dma_cmd_hdr_wr_en,
  input  wire [ADDR_WIDTH-1:0]    dma_cmd_hdr_wr_addr,
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

  output wire [63:0]              out_desc,
  output wire [63:0]              out_desc_dram_addr,
  output wire                     out_desc_valid,
  input  wire                     out_desc_ready,

  // Slot information from core
  output wire [SLOT_WIDTH-1:0]    slot_wr_ptr, 
  output wire [ADDR_WIDTH-1:0]    slot_wr_addr,
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
parameter SLOW_DMEM_ADDR_WIDTH = $clog2(SLOW_DMEM_SIZE);
parameter FAST_DMEM_ADDR_WIDTH = $clog2(FAST_DMEM_SIZE);
parameter IMEM_ADDR_WIDTH      = $clog2(IMEM_SIZE);

parameter ACC_ADDR_WIDTH       = $clog2(SLOW_M_B_LINES);
parameter SLOW_DMEM_SEL_BITS   = SLOW_DMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                                 -1-$clog2(SLOW_M_B_LINES);
parameter ACC_MEM_BLOCKS       = 2**SLOW_DMEM_SEL_BITS;

///////////////////////////////////////////////////////////////////////////
//////////////////////////// RISCV CORE ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////
wire                                     core_dmem_en;
wire                                     core_dmem_wen;
wire [STRB_WIDTH-1:0]                    core_dmem_strb;
wire [ADDR_WIDTH-1:0]                    core_dmem_addr;
wire [DATA_WIDTH-1:0]                    core_dmem_wr_data;
wire [DATA_WIDTH-1:0]                    core_dmem_rd_data;
wire                                     core_dmem_rd_valid;

wire                                     core_imem_ren;
wire [ADDR_WIDTH-1:0]                    core_imem_addr;
wire [DATA_WIDTH-1:0]                    core_imem_rd_data;

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
  .ext_dmem_strb(core_dmem_strb),
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

  .data_desc(out_desc),
  .dram_wr_addr(out_desc_dram_addr),
  .data_desc_valid(out_desc_valid),
  .data_desc_ready(out_desc_ready),
  
  .slot_wr_ptr(slot_wr_ptr), 
  .slot_wr_addr(slot_wr_addr),
  .slot_wr_valid(slot_wr_valid),
  .slot_for_hdr(slot_for_hdr),
  .slot_wr_ready(slot_wr_ready),

  .core_msg_data(bc_msg_out[31:0]),
  .core_msg_addr(bc_msg_out[MSG_WIDTH-1:36]),
  .core_msg_strb(bc_msg_out[35:32]),
  .core_msg_valid(bc_msg_out_valid),
  .core_msg_ready(bc_msg_out_ready),

  .interrupt_in(core_interrupt),
  .interrupt_in_ack(core_interrupt_ack)
);

///////////////////////////////////////////////////////////////////////////
///////////////////////// MEMORY MAPPED IO ////////////////////////////////
///////////////////////////////////////////////////////////////////////////
wire [DATA_WIDTH-1:0] io_rd_data;
wire [DATA_WIDTH-1:0] io_wr_data;
wire [DATA_WIDTH-1:0] mem_rd_data;
wire mem_rd_valid;

wire io_not_mem = core_dmem_addr[ADDR_WIDTH-1] && core_dmem_addr[ADDR_WIDTH-2];
wire io_write   = io_not_mem && core_dmem_en &&  core_dmem_wen; 
wire io_read    = io_not_mem && core_dmem_en && !core_dmem_wen;

// IO read data should be available the next cycle
reg  io_read_r;
always @ (posedge sys_clk)
  if (sys_rst)
    io_read_r <= 1'b0;
  else
    io_read_r <= io_read;

assign core_dmem_rd_data = io_read_r ? io_rd_data : mem_rd_data;
assign core_dmem_rd_valid = io_read_r ? 1'b1 : mem_rd_valid;
assign io_wr_data        = core_dmem_wr_data;

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
  .SLOW_DMEM_ADDR_WIDTH(SLOW_DMEM_ADDR_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH-2),
  .SLOW_M_B_LINES(SLOW_M_B_LINES),
  .ACC_ADDR_WIDTH(ACC_ADDR_WIDTH),
  .SLOW_DMEM_SEL_BITS(SLOW_DMEM_SEL_BITS),
  .ACC_MEM_BLOCKS(ACC_MEM_BLOCKS)
) accel_wrap_inst (
  .clk(sys_clk),
  .rst(core_rst),

  .io_addr(core_dmem_addr),
  .io_strb(core_dmem_strb),
  .io_write(io_write),
  .io_read(io_read),
  .io_rd_data(io_rd_data),
  .io_wr_data(io_wr_data),

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
  
  .core_dmem_en(core_dmem_en && !io_not_mem), 
  .core_dmem_wen(core_dmem_wen), 
  .core_dmem_strb(core_dmem_strb),
  .core_dmem_addr(core_dmem_addr),
  .core_dmem_wr_data(core_dmem_wr_data),
  .core_dmem_rd_data(mem_rd_data),
  .core_dmem_rd_valid(mem_rd_valid),

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


endmodule
