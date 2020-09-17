module accel_wrap #(
  parameter IO_DATA_WIDTH   = 32,
  parameter IO_STRB_WIDTH   = (IO_DATA_WIDTH/8),
  parameter IO_ADDR_WIDTH   = 22,
  parameter DATA_WIDTH      = 128,
  parameter STRB_WIDTH      = (DATA_WIDTH/8),
  parameter PMEM_ADDR_WIDTH = 8,
  parameter SLOW_M_B_LINES  = 4096,
  parameter ACC_ADDR_WIDTH  = $clog2(SLOW_M_B_LINES),
  parameter PMEM_SEL_BITS   = PMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                              -1-$clog2(SLOW_M_B_LINES),
  parameter ACC_MEM_BLOCKS  = 2**PMEM_SEL_BITS
) (
  input  wire                                     clk,
  input  wire                                     rst,

  input  wire                                     io_en,
  input  wire                                     io_wen,
  input  wire [IO_STRB_WIDTH-1:0]                 io_strb,
  input  wire [IO_ADDR_WIDTH-1:0]                 io_addr,
  input  wire [IO_DATA_WIDTH-1:0]                 io_wr_data,
  output wire [IO_DATA_WIDTH-1:0]                 io_rd_data,
  output wire                                     io_rd_valid,

  output wire [ACC_MEM_BLOCKS-1:0]                acc_en_b1,
  output wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b1,
  output wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b1,
  output wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b1,
  input  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b1,

  output wire [ACC_MEM_BLOCKS-1:0]                acc_en_b2,
  output wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b2,
  output wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b2,
  output wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b2,
  input  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b2,

  output wire                                     error,
  input  wire                                     error_ack
);

assign error = 1'b0;

localparam TCP_SME_COUNT  = 4;
localparam UDP_SME_COUNT  = 4;
localparam HTTP_SME_COUNT = 4;

localparam ACCEL_COUNT = TCP_SME_COUNT+UDP_SME_COUNT+HTTP_SME_COUNT+1;
localparam DEST_WIDTH  = $clog2(ACCEL_COUNT);

localparam LEN_WIDTH = 14;

reg [PMEM_ADDR_WIDTH-1:0] cmd_addr_reg;
reg [LEN_WIDTH-1:0]       cmd_len_reg;
reg                       cmd_valid_reg;
reg [DEST_WIDTH-1:0]      cmd_accel_reg;
reg [ACCEL_COUNT-1:0]     cmd_stop_reg;
reg [ACCEL_COUNT-1:0]     cmd_init_reg;
wire [ACCEL_COUNT-1:0]    accel_busy;

reg [ACCEL_COUNT-1:0]    status_match;
reg [ACCEL_COUNT-1:0]    status_done;
reg [ACCEL_COUNT*32-1:0] match_1hot;

reg [31:0]  ip_addr_reg = 0;
reg         ip_addr_valid_reg = 0;
reg         read_data_stall_reg;

reg [IO_DATA_WIDTH-1:0] read_data_reg;
reg read_data_valid_reg;

assign io_rd_data = read_data_reg;
assign io_rd_valid = read_data_valid_reg;

always @(posedge clk) begin
  cmd_valid_reg <= 'b0;
  cmd_stop_reg  <= {ACCEL_COUNT{1'b0}};
  cmd_init_reg  <= {ACCEL_COUNT{1'b0}};

  ip_addr_valid_reg   <= 1'b0;
  read_data_valid_reg <= 1'b0;

  if (io_en && io_wen) begin
    if (io_addr[9]) begin
      ip_addr_reg <= io_wr_data;
      ip_addr_valid_reg <= 1'b1;
    end else if (!io_addr[8]) begin
      case ({io_addr[3:2], 2'b00})
        4'h0: begin
          if (io_strb[0]) begin
            cmd_valid_reg <= io_wr_data[0];
            cmd_accel_reg <= io_addr[7:4];
            cmd_stop_reg [io_addr[7:4]] <= cmd_stop_reg [io_addr[7:4]] || io_wr_data[4];
            cmd_init_reg [io_addr[7:4]] <= cmd_init_reg [io_addr[7:4]] || io_wr_data[0];
          end
        end
        4'h4: begin
          cmd_len_reg <= io_wr_data;
        end
        4'h8: begin
          cmd_addr_reg <= io_wr_data;
        end
      endcase
    end
  end

  if (io_en && !io_wen) begin
    read_data_reg <= 0;
    read_data_valid_reg <= 1'b1;
    if (io_addr[9]) begin
      read_data_reg       <=  ip_match;
      read_data_valid_reg <=  ip_done;
      read_data_stall_reg <= !ip_done;
    end else if (io_addr[8]) begin
      read_data_reg <= status_done|status_match;
    end else if (!io_addr[8]) begin
      case ({io_addr[3:2], 2'b00})
        4'h0: begin
          read_data_reg[0] <= 1'b0; // cmd_valid_reg[io_addr[6:4]];
          read_data_reg[1] <= accel_busy[io_addr[7:4]];
          read_data_reg[8] <= status_done[io_addr[7:4]];
          read_data_reg[9] <= status_match[io_addr[7:4]];
        end
        4'h4: begin
          read_data_reg <= cmd_len_reg[io_addr[7:4]];
        end
        4'h8: begin
          read_data_reg <= cmd_addr_reg[io_addr[7:4]];
        end
        4'hc: begin
          read_data_reg <= match_1hot[io_addr[7:4]*32+:32];
          read_data_valid_reg <=   (status_done [io_addr[7:4]]
                                 || status_match[io_addr[7:4]]);
          read_data_stall_reg <= ! (status_done [io_addr[7:4]]
                                 || status_match[io_addr[7:4]]);
        end
      endcase
    end
  end

  // core keeps the address in case of stall
  if (read_data_stall_reg) begin
    if (io_addr[9]) begin
      read_data_valid_reg <=  ip_done;
      read_data_stall_reg <= !ip_done;

    end else begin // There is only 1 remaining stall case
      read_data_valid_reg <=   (status_done [io_addr[7:4]]
                             || status_match[io_addr[7:4]]);
      read_data_stall_reg <= ! (status_done [io_addr[7:4]]
                             || status_match[io_addr[7:4]]);
    end
  end

  if (rst) begin
    cmd_valid_reg <= 1'b0;
    cmd_init_reg  <= {ACCEL_COUNT{1'b0}};
    cmd_stop_reg  <= {ACCEL_COUNT{1'b0}};

    ip_addr_valid_reg   <= 1'b0;
    read_data_stall_reg <= 1'b0;
    read_data_valid_reg <= 1'b0;
  end
end

// DMA engine for single block of the packet memory
localparam BLOCK_ADDR_WIDTH =PMEM_ADDR_WIDTH-PMEM_SEL_BITS;
localparam ATTACHED = ACC_MEM_BLOCKS-1;
localparam USER_WIDTH = $clog2(DATA_WIDTH/8);

wire [ACCEL_COUNT*DATA_WIDTH-1:0] accel_tdata;
wire [ACCEL_COUNT*USER_WIDTH-1:0] accel_tuser;
wire [ACCEL_COUNT-1:0]            accel_tlast;
wire [ACCEL_COUNT-1:0]            accel_tvalid;
wire [ACCEL_COUNT-1:0]            accel_tready;

// Fixed_loc IP takes 8 bytes at each cycle
wire [(ACCEL_COUNT-1)*8+64-1:0]   accel_tdata_r;
wire [ACCEL_COUNT-1:0]            accel_tlast_r;
wire [ACCEL_COUNT-1:0]            accel_tvalid_r;
wire [ACCEL_COUNT-1:0]            accel_tready_r;

accel_rd_dma_sp # (
  .DATA_WIDTH(DATA_WIDTH),
  .KEEP_WIDTH(DATA_WIDTH/8),
  .ADDR_WIDTH(BLOCK_ADDR_WIDTH),
  .ACCEL_COUNT(ACCEL_COUNT),
  .DEST_WIDTH(DEST_WIDTH),
  .LEN_WIDTH(LEN_WIDTH),
  .FIFO_LINES(32)
) accel_dma_engine (
  .clk(clk),
  .rst(rst),

  .desc_accel_id(cmd_accel_reg),
  .desc_addr(cmd_addr_reg[BLOCK_ADDR_WIDTH-1:0]),
  .desc_len(cmd_len_reg),
  .desc_valid(cmd_valid_reg),

  .accel_busy(accel_busy),
  .accel_stop(cmd_stop_reg),

  .mem_b1_rd_addr(acc_addr_b1[ATTACHED*ACC_ADDR_WIDTH +: ACC_ADDR_WIDTH]),
  .mem_b1_rd_en(acc_en_b1[ATTACHED]),
  .mem_b1_rd_data(acc_rd_data_b1[ATTACHED*DATA_WIDTH +: DATA_WIDTH]),

  .mem_b2_rd_addr(acc_addr_b2[ATTACHED*ACC_ADDR_WIDTH +: ACC_ADDR_WIDTH]),
  .mem_b2_rd_en(acc_en_b2[ATTACHED]),
  .mem_b2_rd_data(acc_rd_data_b2[ATTACHED*DATA_WIDTH +: DATA_WIDTH]),

  .m_axis_tdata(accel_tdata),
  .m_axis_tuser(accel_tuser),
  .m_axis_tlast(accel_tlast),
  .m_axis_tvalid(accel_tvalid),
  .m_axis_tready(accel_tready)
);

assign acc_wen_b1[ATTACHED*STRB_WIDTH +: STRB_WIDTH] = {STRB_WIDTH{1'b0}};
assign acc_wen_b2[ATTACHED*STRB_WIDTH +: STRB_WIDTH] = {STRB_WIDTH{1'b0}};
assign accel_tready_r = {ACCEL_COUNT{1'b1}};

genvar i;

generate
  for (i = 0; i < (ACC_MEM_BLOCKS-1); i = i + 1) begin: other_mem_ens
    assign acc_en_b1[i]  = 1'b0;
    assign acc_en_b2[i]  = 1'b0;
    assign acc_wen_b1[i*STRB_WIDTH +: STRB_WIDTH] = {STRB_WIDTH{1'b0}};
    assign acc_wen_b2[i*STRB_WIDTH +: STRB_WIDTH] = {STRB_WIDTH{1'b0}};
  end
endgenerate

// SME accelerators
wire [ACCEL_COUNT-1:0] sme_match;

genvar n;
generate

  // TCP
  for (n = 0; n < ACCEL_COUNT-1; n = n + 1) begin: width_converters_1B
    accel_width_conv # (
      .DATA_IN_WIDTH(DATA_WIDTH),
      .DATA_OUT_WIDTH(8),
      .USER_WIDTH(USER_WIDTH)
    ) accel_width_conv_inst (
      .clk(clk),
      .rst(rst),

      .s_axis_tdata (accel_tdata[n*DATA_WIDTH+:DATA_WIDTH]),
      .s_axis_tuser (accel_tuser[n*USER_WIDTH+:USER_WIDTH]),
      .s_axis_tlast (accel_tlast[n]),
      .s_axis_tvalid(accel_tvalid[n]),
      .s_axis_tready(accel_tready[n]),

      .m_axis_tdata (accel_tdata_r[n*8 +: 8]),
      .m_axis_tlast (accel_tlast_r[n]),
      .m_axis_tvalid(accel_tvalid_r[n]),
      .m_axis_tready(accel_tready_r[n])
    );
  end

  for (n = ACCEL_COUNT-1; n < ACCEL_COUNT; n = n + 1) begin: width_converters_8B
    accel_width_conv # (
      .DATA_IN_WIDTH(DATA_WIDTH),
      .DATA_OUT_WIDTH(64),
      .USER_WIDTH(USER_WIDTH)
    ) accel_width_conv_inst (
      .clk(clk),
      .rst(rst),

      .s_axis_tdata (accel_tdata[n*DATA_WIDTH+:DATA_WIDTH]),
      .s_axis_tuser (accel_tuser[n*USER_WIDTH+:USER_WIDTH]),
      .s_axis_tlast (accel_tlast[n]),
      .s_axis_tvalid(accel_tvalid[n]),
      .s_axis_tready(accel_tready[n]),

      .m_axis_tdata (accel_tdata_r[n*8 +: 64]),
      .m_axis_tlast (accel_tlast_r[n]),
      .m_axis_tvalid(accel_tvalid_r[n]),
      .m_axis_tready(accel_tready_r[n])
    );
  end

  for (n = 0; n < TCP_SME_COUNT; n = n + 1) begin: tcp_sme
    wire [9:0] match;

    tcp_sme tcp_sme_inst
    (
      .clk(clk),
      .rst(rst | cmd_init_reg[n]),

      .s_axis_tdata(accel_tdata_r[n*8 +: 8]),
      .s_axis_tvalid(accel_tvalid_r[n]),
      .match(match)
    );

    always @ (posedge clk)
      if (cmd_init_reg[n] | rst)
        match_1hot[n*32+:32] <= 0;
      else
        match_1hot[n*32+:32] <= match_1hot[n*32+:32] | match;

    assign sme_match[n] = |match;
  end

  // UDP
  for (n = TCP_SME_COUNT; n < TCP_SME_COUNT+UDP_SME_COUNT; n = n + 1) begin: udp_sme
    wire [20:0] match;

    udp_sme udp_sme_inst
    (
      .clk(clk),
      .rst(rst | cmd_init_reg[n]),

      .s_axis_tdata(accel_tdata_r[n*8 +: 8]),
      .s_axis_tvalid(accel_tvalid_r[n]),
      .match(match)
    );

    always @ (posedge clk)
      if (cmd_init_reg[n] | rst)
        match_1hot[n*32+:32] <= 0;
      else
        match_1hot[n*32+:32] <= match_1hot[n*32+:32] | match;

    assign sme_match[n] = |match;
  end

  // HTTP
  for (n = TCP_SME_COUNT+UDP_SME_COUNT; n < TCP_SME_COUNT+UDP_SME_COUNT+HTTP_SME_COUNT; n = n + 1) begin: http_sme
    wire [30:0] match;

    http_sme http_sme_inst
    (
      .clk(clk),
      .rst(rst | cmd_init_reg[n]),

      .s_axis_tdata(accel_tdata_r[n*8 +: 8]),
      .s_axis_tvalid(accel_tvalid_r[n]),
      .match(match)
    );

    always @ (posedge clk)
      if (cmd_init_reg[n] | rst)
        match_1hot[n*32+:32] <= 0;
      else
        match_1hot[n*32+:32] <= match_1hot[n*32+:32] | match;

    assign sme_match[n] = |match;
  end

  // Fixed location SME
  for (n = ACCEL_COUNT-1; n < ACCEL_COUNT; n = n + 1) begin: fied_loc_sme
    wire [27:0] match;

    fixed_loc_sme fixed_loc_sme_inst
    (
      .clk(clk),
      .rst(rst | cmd_init_reg[n]),

      .s_axis_tdata(accel_tdata_r[n*8 +: 64]),
      .s_axis_tvalid(accel_tvalid_r[n]),
      .match(match)
    );

    always @ (posedge clk)
      if (cmd_init_reg[n] | rst)
        match_1hot[n*32+:32] <= 0;
      else
        match_1hot[n*32+:32] <= match_1hot[n*32+:32] | match;

    assign sme_match[n] = |match;
  end

endgenerate

always @ (posedge clk) begin
  status_match <= (status_match | sme_match) & (~cmd_init_reg);
  status_done  <= (status_done | (accel_tvalid_r&accel_tlast_r) | cmd_stop_reg) & (~cmd_init_reg);

  if (rst) begin
    status_match <= {ACCEL_COUNT{1'b0}};
    status_done  <= {ACCEL_COUNT{1'b0}};
  end
end

// CND IP check accelerator
// ip_match and ip_done keep their value until new valid is asserted
ip_match ip_match_inst (
  .clk(clk),
  .rst(rst),
  .addr(ip_addr_reg),
  .valid(ip_addr_valid_reg),
  .match(ip_match),
  .done(ip_done)
);

endmodule