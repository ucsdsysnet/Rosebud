module riscv_block_PR (  
  input  wire         sys_clk,
  input               sys_rst,
  input  wire         core_rst,
  input  wire [3:0]   core_id,
  
  // DMA interface
  input  wire         dma_cmd_wr_en,
  input  wire [21:0]  dma_cmd_wr_addr,
  input  wire [127:0] dma_cmd_wr_data,
  input  wire [15:0]  dma_cmd_wr_strb,
  input  wire         dma_cmd_wr_last,
  output wire         dma_cmd_wr_ready,
  
  input  wire         dma_cmd_rd_en,
  input  wire [21:0]  dma_cmd_rd_addr,
  input  wire         dma_cmd_rd_last,
  output wire         dma_cmd_rd_ready,
  
  output wire         dma_rd_resp_valid,
  output wire [127:0] dma_rd_resp_data,
  input  wire         dma_rd_resp_ready,
    
  // Descriptor to/from core 
  input  wire [63:0]  in_desc,
  input  wire         in_desc_valid,
  output wire         in_desc_taken,

  output wire [63:0]  data_desc,
  output wire [63:0]  dram_wr_addr,
  output wire         data_desc_valid,
  input  wire         data_desc_ready,

  // Slot information from core
  output wire [3:0]   slot_wr_ptr, 
  output wire [21:0]  slot_wr_addr,
  output wire         slot_wr_valid,
  input  wire         slot_wr_ready,
 
  // Received DRAM infor to core
  input  wire [4:0]   recv_dram_tag,
  input  wire         recv_dram_tag_valid,

  // Broadcast messages
  input  wire [46:0]  bc_msg_in,
  input  wire         bc_msg_in_valid,
  output wire [46:0]  bc_msg_out,
  output wire         bc_msg_out_valid,
  input  wire         bc_msg_out_ready,

  // Interrupt to core
  input  wire         interrupt_in,
  output reg          interrupt_in_ack
);

// Parameters that should match the wrapper and are used in ports
parameter DATA_WIDTH     = 128;
parameter STRB_WIDTH     = (DATA_WIDTH/8);
parameter IMEM_SIZE      = 65536;
parameter SLOW_DMEM_SIZE = 1048576;
parameter FAST_DMEM_SIZE = 32768;
parameter SLOW_M_B_LINES = 4096;
parameter FAST_M_B_LINES = 1024;
parameter BC_REGION_SIZE = 8192;
parameter BC_START_ADDR  = SLOW_DMEM_SIZE+FAST_DMEM_SIZE-BC_REGION_SIZE;
parameter MSG_WIDTH      = 32+4+$clog2(BC_REGION_SIZE)-2;
parameter ADDR_WIDTH     = $clog2(SLOW_DMEM_SIZE)+2;
parameter CORE_ID_WIDTH  = 4;
parameter SLOT_COUNT     = 8;
parameter SLOT_WIDTH     = $clog2(SLOT_COUNT+1);

// Internal paramaters
parameter LINE_ADDR_BITS       = $clog2(STRB_WIDTH);
parameter SLOW_DMEM_ADDR_WIDTH = $clog2(SLOW_DMEM_SIZE);
parameter FAST_DMEM_ADDR_WIDTH = $clog2(FAST_DMEM_SIZE);
parameter IMEM_ADDR_WIDTH      = $clog2(IMEM_SIZE);
//parameter BC_MSG_ADDR_WIDTH    = $clog2(BC_REGION_SIZE);
parameter REG_TYPE             = 2;
parameter REG_LENGTH           = 2;

parameter ACC_ADDR_WIDTH       = $clog2(SLOW_M_B_LINES);
parameter SLOW_DMEM_SEL_BITS   = SLOW_DMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                                 -1-$clog2(SLOW_M_B_LINES);
parameter ACC_MEM_BLOCKS       = 2**SLOW_DMEM_SEL_BITS;

///////////////////////////////////////////////////////////////////////////////
/////////////////// Register input and outputs ////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
(* KEEP = "TRUE" *) reg sys_rst_r;
(* KEEP = "TRUE" *) reg core_rst_r;

reg  [3:0] core_id_r;
reg        interrupt_in_r;
wire       interrupt_in_ack_n;

always @ (posedge sys_clk) begin
  sys_rst_r          <= sys_rst;
  core_rst_r         <= core_rst;
  core_id_r          <= core_id;
  interrupt_in_r     <= interrupt_in;
  interrupt_in_ack   <= interrupt_in_ack_n;
end

wire                  dma_cmd_wr_en_r;
wire [ADDR_WIDTH-1:0] dma_cmd_wr_addr_r;
wire [DATA_WIDTH-1:0] dma_cmd_wr_data_r;
wire [STRB_WIDTH-1:0] dma_cmd_wr_strb_r;
wire                  dma_cmd_wr_last_r;
wire                  dma_cmd_wr_ready_r;

simple_pipe_reg # (
  .DATA_WIDTH(DATA_WIDTH+ADDR_WIDTH+STRB_WIDTH+1),
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) dma_wr_reg (
  .clk(sys_clk),
  .rst(sys_rst_r),
  
  .s_data({dma_cmd_wr_data,dma_cmd_wr_addr,dma_cmd_wr_strb,dma_cmd_wr_last}),
  .s_valid(dma_cmd_wr_en),
  .s_ready(dma_cmd_wr_ready),

  .m_data({dma_cmd_wr_data_r,dma_cmd_wr_addr_r,dma_cmd_wr_strb_r,dma_cmd_wr_last_r}),
  .m_valid(dma_cmd_wr_en_r),
  .m_ready(dma_cmd_wr_ready_r)
);

wire                  dma_cmd_rd_en_r;
wire [ADDR_WIDTH-1:0] dma_cmd_rd_addr_r;
wire                  dma_cmd_rd_last_r;
wire                  dma_cmd_rd_ready_r;

simple_pipe_reg # (
  .DATA_WIDTH(ADDR_WIDTH+1),
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) dma_rd_reg (
  .clk(sys_clk),
  .rst(sys_rst_r),
  
  .s_data({dma_cmd_rd_addr,dma_cmd_rd_last}),
  .s_valid(dma_cmd_rd_en),
  .s_ready(dma_cmd_rd_ready),

  .m_data({dma_cmd_rd_addr_r,dma_cmd_rd_last_r}),
  .m_valid(dma_cmd_rd_en_r),
  .m_ready(dma_cmd_rd_ready_r)
);

wire                  dma_rd_resp_valid_n;
wire [DATA_WIDTH-1:0] dma_rd_resp_data_n;
wire                  dma_rd_resp_ready_n;

simple_pipe_reg # (
  .DATA_WIDTH(DATA_WIDTH),
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) dma_rd_resp_reg (
  .clk(sys_clk),
  .rst(sys_rst_r),
  
  .s_data(dma_rd_resp_data_n),
  .s_valid(dma_rd_resp_valid_n),
  .s_ready(dma_rd_resp_ready_n),

  .m_data(dma_rd_resp_data),
  .m_valid(dma_rd_resp_valid),
  .m_ready(dma_rd_resp_ready)
);
    
wire [63:0] in_desc_r;
wire        in_desc_valid_r;
wire        in_desc_taken_r;

simple_pipe_reg # (
  .DATA_WIDTH(64),
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) in_desc_reg (
  .clk(sys_clk),
  .rst(sys_rst_r),
  
  .s_data(in_desc),
  .s_valid(in_desc_valid),
  .s_ready(in_desc_taken),

  .m_data(in_desc_r),
  .m_valid(in_desc_valid_r),
  .m_ready(in_desc_taken_r)
);

wire [63:0] data_desc_n;
wire [63:0] dram_wr_addr_n;
wire        data_desc_valid_n;
wire        data_desc_ready_n;

simple_pipe_reg # (
  .DATA_WIDTH(128),
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) out_desc_reg (
  .clk(sys_clk),
  .rst(sys_rst_r),
  
  .s_data({dram_wr_addr_n,data_desc_n}),
  .s_valid(data_desc_valid_n),
  .s_ready(data_desc_ready_n),

  .m_data({dram_wr_addr,data_desc}),
  .m_valid(data_desc_valid),
  .m_ready(data_desc_ready)
);

wire [SLOT_WIDTH-1:0] slot_wr_ptr_n;
wire [ADDR_WIDTH-1:0] slot_wr_addr_n;
wire                  slot_wr_valid_n;
wire                  slot_wr_ready_n;

simple_pipe_reg # (
  .DATA_WIDTH(ADDR_WIDTH+SLOT_WIDTH),
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) slot_info_reg (
  .clk(sys_clk),
  .rst(sys_rst_r),
  
  .s_data({slot_wr_ptr_n,slot_wr_addr_n}),
  .s_valid(slot_wr_valid_n),
  .s_ready(slot_wr_ready_n),

  .m_data({slot_wr_ptr,slot_wr_addr}),
  .m_valid(slot_wr_valid),
  .m_ready(slot_wr_ready)
);

wire [4:0] recv_dram_tag_r;
wire       recv_dram_tag_valid_r;

simple_pipe_reg # (
  .DATA_WIDTH(5), 
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) dram_tag_reg (
  .clk(sys_clk),
  .rst(sys_rst_r),
  
  .s_data(recv_dram_tag),
  .s_valid(recv_dram_tag_valid),
  .s_ready(),

  .m_data(recv_dram_tag_r),
  .m_valid(recv_dram_tag_valid_r),
  .m_ready(1'b1)
);

wire [MSG_WIDTH-1:0]  bc_msg_in_r;
wire                  bc_msg_in_valid_r;

simple_pipe_reg # (
  .DATA_WIDTH(MSG_WIDTH), 
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) bc_msg_in_reg (
  .clk(sys_clk),
  .rst(sys_rst_r),
  
  .s_data(bc_msg_in),
  .s_valid(bc_msg_in_valid),
  .s_ready(),

  .m_data(bc_msg_in_r),
  .m_valid(bc_msg_in_valid_r),
  .m_ready(1'b1)
);

wire [MSG_WIDTH-1:0]  bc_msg_out_n;
wire                  bc_msg_out_valid_n;
wire                  bc_msg_out_ready_n;

simple_pipe_reg # (
  .DATA_WIDTH(MSG_WIDTH), 
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) bc_msg_out_reg (
  .clk(sys_clk),
  .rst(sys_rst_r),
  
  .s_data(bc_msg_out_n),
  .s_valid(bc_msg_out_valid_n),
  .s_ready(bc_msg_out_ready_n),

  .m_data(bc_msg_out),
  .m_valid(bc_msg_out_valid),
  .m_ready(bc_msg_out_ready)
);

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
  .rst(sys_rst_r),
  
  .dma_cmd_wr_en(dma_cmd_wr_en_r),
  .dma_cmd_wr_addr(dma_cmd_wr_addr_r),
  .dma_cmd_wr_data(dma_cmd_wr_data_r),
  .dma_cmd_wr_strb(dma_cmd_wr_strb_r),
  .dma_cmd_wr_last(dma_cmd_wr_last_r),
  .dma_cmd_wr_ready(dma_cmd_wr_ready_r),

  .dma_cmd_rd_en(dma_cmd_rd_en_r),
  .dma_cmd_rd_addr(dma_cmd_rd_addr_r),
  .dma_cmd_rd_last(dma_cmd_rd_last_r),
  .dma_cmd_rd_ready(dma_cmd_rd_ready_r),

  .dma_rd_resp_valid(dma_rd_resp_valid_n),
  .dma_rd_resp_data(dma_rd_resp_data_n),
  .dma_rd_resp_ready(dma_rd_resp_ready_n),
  
  .core_dmem_en(core_dmem_en), 
  .core_dmem_wen(core_dmem_wen),
  .core_dmem_addr(core_dmem_addr),
  .core_dmem_wr_data(core_dmem_wr_data),
  .core_dmem_rd_data(core_dmem_rd_data),
  .core_dmem_rd_valid(core_dmem_rd_valid),

  .core_imem_ren(core_imem_ren),
  .core_imem_addr(core_imem_addr),
  .core_imem_rd_data(core_imem_rd_data),
  
  .bc_msg_in(bc_msg_in_r),
  .bc_msg_in_valid(bc_msg_in_valid_r),
  
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
    .rst(core_rst_r),
    .init_rst(sys_rst_r),
    .core_id(core_id_r),

    .ext_dmem_en(core_dmem_en),
    .ext_dmem_wen(core_dmem_wen),
    .ext_dmem_addr(core_dmem_addr),
    .ext_dmem_wr_data(core_dmem_wr_data),
    .ext_dmem_rd_data(core_dmem_rd_data),
    .ext_dmem_rd_valid(core_dmem_rd_valid),
    
    .ext_imem_ren(core_imem_ren),
    .ext_imem_addr(core_imem_addr),
    .ext_imem_rd_data(core_imem_rd_data),
    
    .in_desc(in_desc_r),
    .in_desc_valid(in_desc_valid_r),
    .in_desc_taken(in_desc_taken_r),
    
    .recv_dram_tag_valid(recv_dram_tag_valid_r),    
    .recv_dram_tag(recv_dram_tag_r),

    .data_desc(data_desc_n),
    .dram_wr_addr(dram_wr_addr_n),
    .data_desc_valid(data_desc_valid_n),
    .data_desc_ready(data_desc_ready_n),
    
    .slot_wr_ptr(slot_wr_ptr_n), 
    .slot_wr_addr(slot_wr_addr_n),
    .slot_wr_valid(slot_wr_valid_n),
    .slot_wr_ready(slot_wr_ready_n),
 
    .core_msg_data(bc_msg_out_n[31:0]),
    .core_msg_addr(bc_msg_out_n[MSG_WIDTH-1:36]),
    .core_msg_strb(bc_msg_out_n[35:32]),
    .core_msg_valid(bc_msg_out_valid_n),
    .core_msg_ready(bc_msg_out_ready_n),

    .interrupt_in(interrupt_in_r),
    .interrupt_in_ack(interrupt_in_ack_n)
);

endmodule
