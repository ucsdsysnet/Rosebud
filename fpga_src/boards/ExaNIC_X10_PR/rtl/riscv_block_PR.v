module riscv_block_PR (  
  input  wire         clk,
  input               rst,
  input  wire         core_rst,

  input  wire [3:0]   core_id,
  input  wire         evict_int,
  output reg          evict_int_ack,
  input  wire         poke_int,
  output reg          poke_int_ack,
  
  // DMA interface
  input  wire         dma_cmd_wr_en,
  input  wire [25:0]  dma_cmd_wr_addr,
  input  wire         dma_cmd_hdr_wr_en,
  input  wire [23:0]  dma_cmd_hdr_wr_addr,
  input  wire [63:0]  dma_cmd_wr_data,
  input  wire [7:0]   dma_cmd_wr_strb,
  input  wire         dma_cmd_wr_last,
  output wire         dma_cmd_wr_ready,
  
  input  wire         dma_cmd_rd_en,
  input  wire [25:0]  dma_cmd_rd_addr,
  input  wire         dma_cmd_rd_last,
  output wire         dma_cmd_rd_ready,
  
  output wire         dma_rd_resp_valid,
  output wire [63:0]  dma_rd_resp_data,
  input  wire         dma_rd_resp_ready,
    
  // Descriptor to/from core 
  input  wire [63:0]  in_desc,
  input  wire         in_desc_valid,
  output wire         in_desc_taken,

  output wire [63:0]  out_desc,
  output wire [63:0]  out_desc_dram_addr,
  output wire         out_desc_valid,
  input  wire         out_desc_ready,

  // Slot information from core
  output wire [3:0]   slot_wr_ptr, 
  output wire [24:0]  slot_wr_addr,
  output wire         slot_wr_valid,
  output wire         slot_for_hdr,
  input  wire         slot_wr_ready,
 
  // Received DRAM and active slots info to core
  input  wire [4:0]   recv_dram_tag,
  input  wire         recv_dram_tag_valid,
  input  wire [7:0]   active_slots,

  // Broadcast messages
  input  wire [45:0]  bc_msg_in,
  input  wire         bc_msg_in_valid,
  output wire [45:0]  bc_msg_out,
  output wire         bc_msg_out_valid,
  input  wire         bc_msg_out_ready,
  
  // Status
  output reg  [7:0]   core_errors,
  output reg  [7:0]   mem_fifo_fulls,
  output reg          ready_to_evict
);

// Parameters that should match the wrapper and are used in ports
parameter DATA_WIDTH     = 64;
parameter STRB_WIDTH     = (DATA_WIDTH/8);
parameter IMEM_SIZE      = 16384;
parameter PMEM_SIZE      = 16384;
parameter DMEM_SIZE      = 16384;
parameter SLOW_M_B_LINES = 1024;
parameter FAST_M_B_LINES = 1024;
parameter BC_REGION_SIZE = 4096;
parameter BC_START_ADDR  = 32'h01000000+PMEM_SIZE-BC_REGION_SIZE;
parameter MSG_WIDTH      = 32+4+$clog2(BC_REGION_SIZE)-2;
parameter CORE_ID_WIDTH  = 4;
parameter SLOT_COUNT     = 8;
parameter SLOT_WIDTH     = $clog2(SLOT_COUNT+1);

parameter REG_TYPE       = 2;
parameter REG_LENGTH     = 1;

///////////////////////////////////////////////////////////////////////////////
/////////////////// Register input and outputs ////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
(* KEEP = "TRUE" *) reg rst_r;
(* KEEP = "TRUE" *) reg core_rst_r;

reg [3:0]            core_id_r;
reg [SLOT_COUNT-1:0] active_slots_r;
reg                  poke_int_r, evict_int_r;

wire [7:0] core_errors_n, mem_fifo_fulls_n;
wire       poke_int_ack_n, evict_int_ack_n;
wire       ready_to_evict_n;

always @ (posedge clk) begin
  rst_r          <= rst;
  core_rst_r     <= core_rst;

  core_id_r      <= core_id;
  poke_int_r     <= poke_int;
  evict_int_r    <= evict_int;
  active_slots_r <= active_slots;

  poke_int_ack   <= poke_int_ack_n;
  evict_int_ack  <= evict_int_ack_n;
  core_errors    <= core_errors_n;
  mem_fifo_fulls <= mem_fifo_fulls_n;
  ready_to_evict <= ready_to_evict_n;
end

wire                  dma_cmd_wr_en_r;
wire [25:0]           dma_cmd_wr_addr_r;
wire                  dma_cmd_hdr_wr_en_r;
wire [23:0]           dma_cmd_hdr_wr_addr_r;
wire [DATA_WIDTH-1:0] dma_cmd_wr_data_r;
wire [STRB_WIDTH-1:0] dma_cmd_wr_strb_r;
wire                  dma_cmd_wr_last_r;
wire                  dma_cmd_wr_ready_r;

simple_pipe_reg # (
  .DATA_WIDTH(DATA_WIDTH+24+26+STRB_WIDTH+2),
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) dma_wr_reg (
  .clk(clk),
  .rst(rst_r),
  
  .s_data({dma_cmd_wr_data, dma_cmd_wr_addr, dma_cmd_hdr_wr_addr,
           dma_cmd_hdr_wr_en, dma_cmd_wr_strb, dma_cmd_wr_last}),
  .s_valid(dma_cmd_wr_en),
  .s_ready(dma_cmd_wr_ready),

  .m_data({dma_cmd_wr_data_r, dma_cmd_wr_addr_r, dma_cmd_hdr_wr_addr_r,
           dma_cmd_hdr_wr_en_r, dma_cmd_wr_strb_r, dma_cmd_wr_last_r}),
  .m_valid(dma_cmd_wr_en_r),
  .m_ready(dma_cmd_wr_ready_r)
);

wire        dma_cmd_rd_en_r;
wire [25:0] dma_cmd_rd_addr_r;
wire        dma_cmd_rd_last_r;
wire        dma_cmd_rd_ready_r;

simple_pipe_reg # (
  .DATA_WIDTH(26+1),
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) dma_rd_reg (
  .clk(clk),
  .rst(rst_r),
  
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
  .clk(clk),
  .rst(rst_r),
  
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
  .clk(clk),
  .rst(rst_r || core_rst_r),
  
  .s_data(in_desc),
  .s_valid(in_desc_valid),
  .s_ready(in_desc_taken),

  .m_data(in_desc_r),
  .m_valid(in_desc_valid_r),
  .m_ready(in_desc_taken_r)
);

wire [63:0] out_desc_n;
wire [63:0] out_desc_dram_addr_n;
wire        out_desc_valid_n;
wire        out_desc_ready_n;

simple_pipe_reg # (
  .DATA_WIDTH(128),
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) out_desc_reg (
  .clk(clk),
  .rst(rst_r || core_rst_r),
  
  .s_data({out_desc_dram_addr_n,out_desc_n}),
  .s_valid(out_desc_valid_n),
  .s_ready(out_desc_ready_n),

  .m_data({out_desc_dram_addr,out_desc}),
  .m_valid(out_desc_valid),
  .m_ready(out_desc_ready)
);

wire [SLOT_WIDTH-1:0] slot_wr_ptr_n;
wire [24:0]           slot_wr_addr_n;
wire                  slot_wr_valid_n;
wire                  slot_for_hdr_n;
wire                  slot_wr_ready_n;

simple_pipe_reg # (
  .DATA_WIDTH(25+SLOT_WIDTH+1),
  .REG_TYPE(REG_TYPE), 
  .REG_LENGTH(REG_LENGTH)
) slot_info_reg (
  .clk(clk),
  .rst(rst_r || core_rst_r),
  
  .s_data({slot_wr_ptr_n, slot_wr_addr_n, slot_for_hdr_n}),
  .s_valid(slot_wr_valid_n),
  .s_ready(slot_wr_ready_n),

  .m_data({slot_wr_ptr, slot_wr_addr, slot_for_hdr}),
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
  .clk(clk),
  .rst(rst_r || core_rst_r),
  
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
  .clk(clk),
  .rst(rst_r || core_rst_r),
  
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
  .clk(clk),
  .rst(rst_r || core_rst_r),
  
  .s_data(bc_msg_out_n),
  .s_valid(bc_msg_out_valid_n),
  .s_ready(bc_msg_out_ready_n),

  .m_data(bc_msg_out),
  .m_valid(bc_msg_out_valid),
  .m_ready(bc_msg_out_ready)
);

///////////////////////////////////////////////////////////////////////////////
////////////////////////////// RISCV BLOCK  ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
riscv_block # (
    .DATA_WIDTH(DATA_WIDTH),
    .STRB_WIDTH(STRB_WIDTH),
    .IMEM_SIZE(IMEM_SIZE),
    .PMEM_SIZE(PMEM_SIZE),
    .DMEM_SIZE(DMEM_SIZE),
    .SLOW_M_B_LINES(SLOW_M_B_LINES),
    .FAST_M_B_LINES(FAST_M_B_LINES),
    .BC_REGION_SIZE(BC_REGION_SIZE),
    .BC_START_ADDR(BC_START_ADDR),
    .MSG_WIDTH(MSG_WIDTH),
    .CORE_ID_WIDTH(CORE_ID_WIDTH),
    .SLOT_COUNT(SLOT_COUNT),
    .SLOT_WIDTH(SLOT_WIDTH)
) riscv_block_inst (
    .clk(clk),
    .rst(rst_r),
    .core_rst(core_rst_r),

    .core_id(core_id_r),
    .evict_int(evict_int_r),
    .evict_int_ack(evict_int_ack_n),
    .poke_int(poke_int_r),
    .poke_int_ack(poke_int_ack_n),

    .dma_cmd_wr_en(dma_cmd_wr_en_r),
    .dma_cmd_wr_addr(dma_cmd_wr_addr_r),
    .dma_cmd_hdr_wr_en(dma_cmd_hdr_wr_en_r),
    .dma_cmd_hdr_wr_addr(dma_cmd_hdr_wr_addr_r),
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

    .in_desc(in_desc_r),
    .in_desc_valid(in_desc_valid_r),
    .in_desc_taken(in_desc_taken_r),
    .out_desc(out_desc_n),
    .out_desc_dram_addr(out_desc_dram_addr_n),
    .out_desc_valid(out_desc_valid_n),
    .out_desc_ready(out_desc_ready_n),

    .slot_wr_ptr(slot_wr_ptr_n),
    .slot_wr_addr(slot_wr_addr_n),
    .slot_wr_valid(slot_wr_valid_n),
    .slot_for_hdr(slot_for_hdr_n),
    .slot_wr_ready(slot_wr_ready_n),
    .recv_dram_tag(recv_dram_tag_r),
    .recv_dram_tag_valid(recv_dram_tag_valid_r),
    .active_slots(active_slots_r),

    .bc_msg_out(bc_msg_out_n),
    .bc_msg_out_valid(bc_msg_out_valid_n),
    .bc_msg_out_ready(bc_msg_out_ready_n),
    .bc_msg_in(bc_msg_in_r),
    .bc_msg_in_valid(bc_msg_in_valid_r),

    .core_errors(core_errors_n),
    .mem_fifo_fulls(mem_fifo_fulls_n),
    .ready_to_evict(ready_to_evict_n)
);

endmodule
