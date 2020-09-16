module riscv_block_PR_w_accel2 (
  input  wire         clk,
  input               rst,
  input  wire         core_rst,

  input  wire         evict_int,
  output reg          evict_int_ack,
  input  wire         poke_int,
  output reg          poke_int_ack,

  // DMA interface
  input  wire         dma_cmd_wr_en,
  input  wire [25:0]  dma_cmd_wr_addr,
  input  wire         dma_cmd_hdr_wr_en,
  input  wire [23:0]  dma_cmd_hdr_wr_addr,
  input  wire [127:0] dma_cmd_wr_data,
  input  wire [15:0]  dma_cmd_wr_strb,
  input  wire         dma_cmd_wr_last,
  output wire         dma_cmd_wr_ready,

  input  wire         dma_cmd_rd_en,
  input  wire [25:0]  dma_cmd_rd_addr,
  input  wire         dma_cmd_rd_last,
  output wire         dma_cmd_rd_ready,

  output wire         dma_rd_resp_valid,
  output wire [127:0] dma_rd_resp_data,
  input  wire         dma_rd_resp_ready,

  // Descriptor to/from core
  input  wire [63:0]  in_desc,
  input  wire         in_desc_valid,
  output wire         in_desc_taken,

  output wire [63:0]  out_desc,
  output wire [63:0]  out_desc_dram_addr,
  output wire         out_desc_valid,
  input  wire         out_desc_ready,

  // Received DRAM and active slots info to core
  input  wire [4:0]   recv_dram_tag,
  input  wire         recv_dram_tag_valid,

  // Broadcast messages
  input  wire [46:0]  bc_msg_in,
  input  wire         bc_msg_in_valid,
  output wire [46:0]  bc_msg_out,
  output wire         bc_msg_out_valid,
  input  wire         bc_msg_out_ready,

  // Status channel to core
  input  wire [31:0]  wrapper_status_data,
  input  wire [1:0]   wrapper_status_addr,
  input  wire         wrapper_status_valid,
  output wire         wrapper_status_ready,

  // Status channel from core
  output wire [31:0]  core_status_data,
  output wire [1:0]   core_status_addr,
  output wire         core_status_valid,
  input  wire         core_status_ready
);

// Parameters that should match the wrapper and are used in ports
parameter DATA_WIDTH     = 128;
parameter STRB_WIDTH     = (DATA_WIDTH/8);
parameter IMEM_SIZE      = 65536/2;
parameter PMEM_SIZE      = 1048576;
parameter DMEM_SIZE      = 32768;
parameter SLOW_M_B_LINES = 4096;
parameter FAST_M_B_LINES = 1024;
parameter BC_REGION_SIZE = 8192;
parameter BC_START_ADDR  = 32'h01000000+PMEM_SIZE-BC_REGION_SIZE;
parameter MSG_WIDTH      = 32+4+$clog2(BC_REGION_SIZE)-2;
parameter CORE_ID_WIDTH  = 4;

parameter REG_TYPE       = 2;
parameter REG_LENGTH     = 1;

///////////////////////////////////////////////////////////////////////////////
/////////////////// Register input and outputs ////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
(* KEEP = "TRUE" *) reg rst_r;
(* KEEP = "TRUE" *) reg core_rst_r;

reg  poke_int_r, evict_int_r;
wire poke_int_ack_n, evict_int_ack_n;

always @ (posedge clk) begin
  rst_r          <= rst;
  core_rst_r     <= core_rst;
  poke_int_r     <= poke_int;
  evict_int_r    <= evict_int;
  poke_int_ack   <= poke_int_ack_n;
  evict_int_ack  <= evict_int_ack_n;
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

wire [31:0]  wrapper_status_data_r;
wire [1:0]   wrapper_status_addr_r;
wire         wrapper_status_valid_r;
wire         wrapper_status_ready_r;

simple_pipe_reg # (
  .DATA_WIDTH(32+2),
  .REG_TYPE(REG_TYPE),
  .REG_LENGTH(REG_LENGTH)
) wrapper_status_reg (
  .clk(clk),
  .rst(rst_r),

  .s_data ({wrapper_status_addr, wrapper_status_data}),
  .s_valid(wrapper_status_valid),
  .s_ready(wrapper_status_ready),

  .m_data ({wrapper_status_addr_r, wrapper_status_data_r}),
  .m_valid(wrapper_status_valid_r),
  .m_ready(wrapper_status_ready_r)
);

wire [31:0]  core_status_data_n;
wire [1:0]   core_status_addr_n;
wire         core_status_valid_n;
wire         core_status_ready_n;

simple_pipe_reg # (
  .DATA_WIDTH(32+2),
  .REG_TYPE(REG_TYPE),
  .REG_LENGTH(REG_LENGTH)
) core_status_reg (
  .clk(clk),
  .rst(rst_r),

  .s_data ({core_status_addr_n, core_status_data_n}),
  .s_valid(core_status_valid_n),
  .s_ready(core_status_ready_n),

  .m_data ({core_status_addr, core_status_data}),
  .m_valid(core_status_valid),
  .m_ready(core_status_ready)
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
    .CORE_ID_WIDTH(CORE_ID_WIDTH)
) riscv_block_inst (
    .clk(clk),
    .rst(rst_r),
    .core_rst(core_rst_r),

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

    .recv_dram_tag(recv_dram_tag_r),
    .recv_dram_tag_valid(recv_dram_tag_valid_r),

    .bc_msg_out(bc_msg_out_n),
    .bc_msg_out_valid(bc_msg_out_valid_n),
    .bc_msg_out_ready(bc_msg_out_ready_n),
    .bc_msg_in(bc_msg_in_r),
    .bc_msg_in_valid(bc_msg_in_valid_r),

    .wrapper_status_data(wrapper_status_data_r),
    .wrapper_status_addr(wrapper_status_addr_r),
    .wrapper_status_valid(wrapper_status_valid_r),
    .wrapper_status_ready(wrapper_status_ready_r),
    .core_status_data(core_status_data_n),
    .core_status_addr(core_status_addr_n),
    .core_status_valid(core_status_valid_n),
    .core_status_ready(core_status_ready_n)
);

endmodule
