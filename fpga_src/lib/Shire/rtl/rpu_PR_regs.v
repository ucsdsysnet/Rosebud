  // Register inputs and outputs
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
    .rst(rst_r || core_reset_r),

    .s_data(in_desc),
    .s_valid(in_desc_valid),
    .s_ready(in_desc_taken),

    .m_data(in_desc_r),
    .m_valid(in_desc_valid_r),
    .m_ready(in_desc_taken_r)
  );

  wire [63:0] out_desc_n;
  wire        out_desc_2nd_n;
  wire        out_desc_valid_n;
  wire        out_desc_ready_n;

  simple_pipe_reg # (
    .DATA_WIDTH(65),
    .REG_TYPE(REG_TYPE),
    .REG_LENGTH(REG_LENGTH)
  ) out_desc_reg (
    .clk(clk),
    .rst(rst_r || core_reset_r),

    .s_data({out_desc_2nd_n,out_desc_n}),
    .s_valid(out_desc_valid_n),
    .s_ready(out_desc_ready_n),

    .m_data({out_desc_2nd,out_desc}),
    .m_valid(out_desc_valid),
    .m_ready(out_desc_ready)
  );

  wire [MSG_WIDTH-1:0]  bc_msg_in_r;
  wire                  bc_msg_in_valid_r;

  simple_pipe_reg # (
    .DATA_WIDTH(MSG_WIDTH),
    .REG_TYPE(REG_TYPE),
    .REG_LENGTH(REG_LENGTH)
  ) bc_msg_in_reg (
    .clk(clk),
    .rst(rst_r || core_reset_r),

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
    .rst(rst_r),

    .s_data(bc_msg_out_n),
    .s_valid(bc_msg_out_valid_n),
    .s_ready(bc_msg_out_ready_n),

    .m_data(bc_msg_out),
    .m_valid(bc_msg_out_valid),
    .m_ready(bc_msg_out_ready)
  );

  reg  [31:0] intercon_status_data_r;
  reg  [2:0]  intercon_status_addr_r;
  wire [31:0]  rpu_status_data_n;
  wire [2:0]   rpu_status_addr_n;

  always @ (posedge clk) begin
    intercon_status_data_r <= intercon_status_data;
    intercon_status_addr_r <= intercon_status_addr;
    rpu_status_data      <= rpu_status_data_n;
    rpu_status_addr      <= rpu_status_addr_n;
  end

