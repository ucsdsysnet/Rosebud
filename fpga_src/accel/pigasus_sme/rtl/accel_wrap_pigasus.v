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

localparam ACCEL_COUNT = 1;
localparam DEST_WIDTH  = $clog2(ACCEL_COUNT);

localparam LEN_WIDTH = 14;

reg  [PMEM_ADDR_WIDTH-1:0] cmd_addr_reg;
reg  [LEN_WIDTH-1:0]       cmd_len_reg;
reg                        cmd_valid_reg;
reg  [DEST_WIDTH-1:0]      cmd_accel_reg;
reg  [ACCEL_COUNT-1:0]     cmd_stop_reg;
reg  [ACCEL_COUNT-1:0]     cmd_init_reg;
reg  [ACCEL_COUNT-1:0]     release_match;
reg  [63:0]                cmd_state_reg;
wire [ACCEL_COUNT-1:0]     accel_busy;
reg  [DEST_WIDTH-1:0]      next_done_accel;

reg  [ACCEL_COUNT-1:0]     status_match;
reg  [ACCEL_COUNT-1:0]     status_done;
wire [ACCEL_COUNT-1:0]     masked_done;
reg  [ACCEL_COUNT*8-1:0]   match_1hot;
wire [ACCEL_COUNT*32-1:0]  match_indexes;
wire [ACCEL_COUNT-1:0]     match_valid;
reg  [ACCEL_COUNT-1:0]     done_err;
wire [ACCEL_COUNT-1:0]     desc_error;
wire [ACCEL_COUNT*64-1:0]  accel_state;

reg [31:0]  ip_addr_reg = 0;
reg         ip_addr_valid_reg = 0;
reg         read_data_stall_reg;

reg [IO_DATA_WIDTH-1:0] read_data_reg;
reg read_data_valid_reg;

assign io_rd_data = read_data_reg;
assign io_rd_valid = read_data_valid_reg;

always @(posedge clk) begin
  done_err <= done_err | (status_done & accel_busy);
  if (rst) begin
    done_err <= {ACCEL_COUNT{1'b0}};
  end
end

always @(posedge clk) begin
  cmd_valid_reg <= 'b0;
  cmd_stop_reg  <= {ACCEL_COUNT{1'b0}};
  cmd_init_reg  <= {ACCEL_COUNT{1'b0}};
  release_match <= {ACCEL_COUNT{1'b0}};

  ip_addr_valid_reg   <= 1'b0;
  read_data_valid_reg <= 1'b0;

  // Memory mapped I/O writes
  if (io_en && io_wen) begin
    // <1xxx xxxx xxxx> for CDN accel
    if (io_addr[11]) begin
      ip_addr_reg <= io_wr_data;
      ip_addr_valid_reg <= 1'b1;

    // <01xx xxxx xxxx> for SME aggregated SME accels

    // <00xx xxxx xxxx> for individual SME accels
    end else if (!io_addr[10]) begin
      // 4 MSB for selecting SME IP, next 4 for selecting command (and two LSB=0)
      case ({io_addr[5:2], 2'b00})
        // set destination SMR IP, and set bit in cmd_stop and cmd_init for that IP
        6'h00: begin
          if (io_strb[0]) begin
            cmd_valid_reg <= io_wr_data[0];
            cmd_accel_reg <= io_addr[9:6];
            cmd_stop_reg [io_addr[9:6]] <= cmd_stop_reg [io_addr[9:6]] || io_wr_data[4];
            cmd_init_reg [io_addr[9:6]] <= cmd_init_reg [io_addr[9:6]] || io_wr_data[0];
          end
        end
        // Update DMA len
        6'h04: begin
          cmd_len_reg <= io_wr_data;
        end
        // update DMA start addr
        6'h08: begin
          cmd_addr_reg <= io_wr_data;
        end
        // update SME input (preamble bytes)
        6'h10: begin
          cmd_state_reg[31:0] <= io_wr_data;
        end
        6'h14: begin
          cmd_state_reg[63:32] <= io_wr_data;
        end

        // 6'h18 to 6'h24 are used for other reads,
        // avoiding conflict for read back

        // Move on to the next index
        6'h28: begin
          release_match[io_addr[9:6]] <= io_wr_data[0];
        end
        // can go to 6'h3c
      endcase
    end
  end

  // Memory mapped I/O reads
  // There are 2 cases of read stall, for CND or
  // individual accel status readback
  if (io_en && !io_wen) begin
    read_data_reg <= 0;
    read_data_valid_reg <= 1'b1;
    // <1xxx xxxx xxxx> for CDN accel
    if (io_addr[11]) begin
      read_data_reg       <=  ip_match;
      read_data_valid_reg <=  ip_done;
      read_data_stall_reg <= !ip_done;

    // <01xx xxxx xxxx> for SME aggregated SME acceles (stat registers)
    end else if (io_addr[10]) begin
      case ({io_addr[5:2], 2'b00})
        6'h00: begin
          read_data_reg <= status_done|status_match;
        end
        6'h04: begin
          read_data_reg <= status_done;
        end
        6'h08: begin
          read_data_reg <= status_match;
        end
        6'h0c: begin
          read_data_reg <= accel_busy;
        end
        6'h10: begin
          read_data_reg <= desc_error;
        end
        6'h14: begin
          read_data_reg <= done_err;
        end
        6'h1c: begin
          read_data_reg <= masked_done;
        end
        6'h20: begin
          read_data_reg <= next_done_accel;
        end
        // can go to 6'h3c
      endcase

    // <00xx xxxx xxxx> for individual SME accels
    // (registers readback, individual accelerator stat)
    end else if (!io_addr[10]) begin
      case ({io_addr[5:2], 2'b00})
        6'h00: begin
          read_data_reg[0]  <= 1'b0; // cmd_valid_reg[io_addr[6:4]];
          read_data_reg[1]  <= accel_busy[io_addr[9:6]];
          read_data_reg[8]  <= status_done[io_addr[9:6]];
          read_data_reg[9]  <= status_match[io_addr[9:6]];
          read_data_reg[16] <= match_valid[io_addr[9:6]];
        end

        // DMA len and address readback
        6'h04: begin
          read_data_reg <= cmd_len_reg[io_addr[9:6]];
        end
        6'h08: begin
          read_data_reg <= cmd_addr_reg[io_addr[9:6]];
        end

        // onehot representation for match/error/done
        6'h0c: begin
          read_data_reg <= {24'd0, match_1hot[io_addr[9:6]*8+:8]};
          read_data_valid_reg <=   (status_done [io_addr[9:6]]
                                 || status_match[io_addr[9:6]]);
          read_data_stall_reg <= ! (status_done [io_addr[9:6]]
                                 || status_match[io_addr[9:6]]);
        end

        // cmd_state_reg readback
        6'h10: begin
          read_data_reg <= cmd_state_reg[63:32];
        end
        6'h14: begin
          read_data_reg <= cmd_state_reg[31:0];
        end

        // Accel output state
        6'h18: begin
          read_data_reg <= accel_state[(io_addr[9:6]*64)+:32];
        end
        6'h1C: begin
          read_data_reg <= accel_state[(io_addr[9:6]*64+32)+:32];
        end

        // Accel match index
        6'h20: begin
          read_data_reg <= match_indexes[(io_addr[9:6]*32)+:32];
        end
        // can go to 6'h3c
      endcase
    end
  end

  // core keeps the address in case of stall
  if (read_data_stall_reg) begin
    if (io_addr[11]) begin
      read_data_valid_reg <=  ip_done;
      read_data_stall_reg <= !ip_done;

    end else begin // There is only 1 remaining stall case
      read_data_valid_reg <=   (status_done [io_addr[9:6]]
                             || status_match[io_addr[9:6]]);
      read_data_stall_reg <= ! (status_done [io_addr[9:6]]
                             || status_match[io_addr[9:6]]);
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
localparam ATTACHED_CNT = 2;
localparam ATTACHED = ACC_MEM_BLOCKS-ATTACHED_CNT;
localparam USER_WIDTH = $clog2(DATA_WIDTH/8);

wire [ACCEL_COUNT*DATA_WIDTH-1:0] accel_tdata;
wire [ACCEL_COUNT*USER_WIDTH-1:0] accel_tuser;
wire [ACCEL_COUNT-1:0]            accel_tlast;
wire [ACCEL_COUNT-1:0]            accel_tvalid;
wire [ACCEL_COUNT-1:0]            accel_tready;

accel_rd_dma_sp # (
  .DATA_WIDTH(DATA_WIDTH),
  .KEEP_WIDTH(DATA_WIDTH/8),
  .ADDR_WIDTH(BLOCK_ADDR_WIDTH+1),
  .ACCEL_COUNT(ACCEL_COUNT),
  .DEST_WIDTH(DEST_WIDTH),
  .LEN_WIDTH(LEN_WIDTH),
  .MEM_LINES(SLOW_M_B_LINES),
  .FIFO_LINES(32)
) accel_dma_engine (
  .clk(clk),
  .rst(rst),

  .desc_accel_id(cmd_accel_reg),
  .desc_addr(cmd_addr_reg[BLOCK_ADDR_WIDTH+1-1:0]),
  .desc_len(cmd_len_reg),
  .desc_valid(cmd_valid_reg),
  .desc_error(desc_error),

  .accel_busy(accel_busy),
  .accel_stop(cmd_stop_reg),

  .mem_b1_rd_addr(acc_addr_b1[ATTACHED*ACC_ADDR_WIDTH +: ATTACHED_CNT*ACC_ADDR_WIDTH]),
  .mem_b1_rd_en(acc_en_b1[ATTACHED+:ATTACHED_CNT]),
  .mem_b1_rd_data(acc_rd_data_b1[ATTACHED*DATA_WIDTH +: ATTACHED_CNT*DATA_WIDTH]),

  .mem_b2_rd_addr(acc_addr_b2[ATTACHED*ACC_ADDR_WIDTH +: ATTACHED_CNT*ACC_ADDR_WIDTH]),
  .mem_b2_rd_en(acc_en_b2[ATTACHED+:ATTACHED_CNT]),
  .mem_b2_rd_data(acc_rd_data_b2[ATTACHED*DATA_WIDTH +: ATTACHED_CNT*DATA_WIDTH]),

  .m_axis_tdata(accel_tdata),
  .m_axis_tuser(accel_tuser),
  .m_axis_tlast(accel_tlast),
  .m_axis_tvalid(accel_tvalid),
  .m_axis_tready(accel_tready)
);

assign acc_wen_b1[ATTACHED*STRB_WIDTH +: ATTACHED_CNT*STRB_WIDTH] = {ATTACHED_CNT*STRB_WIDTH{1'b0}};
assign acc_wen_b2[ATTACHED*STRB_WIDTH +: ATTACHED_CNT*STRB_WIDTH] = {ATTACHED_CNT*STRB_WIDTH{1'b0}};

genvar i;

generate
  for (i = 0; i < (ACC_MEM_BLOCKS-ATTACHED_CNT); i = i + 1) begin: other_mem_ens
    assign acc_en_b1[i]  = 1'b0;
    assign acc_en_b2[i]  = 1'b0;
    assign acc_wen_b1[i*STRB_WIDTH +: STRB_WIDTH] = {STRB_WIDTH{1'b0}};
    assign acc_wen_b2[i*STRB_WIDTH +: STRB_WIDTH] = {STRB_WIDTH{1'b0}};
  end
endgenerate

// Pigasus accelerator
wire [ACCEL_COUNT-1:0] sme_match;

wire [15:0] match_index;
wire [7:0]  match_valid_stat;
wire [7:0]  match_error_stat;

wire [4-1:0] accel_tempty = 4'hf-accel_tuser;

pigasus_sme_wrapper fast_pattern_sme_inst (
  .clk(clk),
  .rst(rst),

  .s_axis_tdata(accel_tdata),
  .s_axis_tempty(accel_tempty),
  .s_axis_tvalid(accel_tvalid),
  .s_axis_tlast(accel_tlast),
  .s_axis_tready(accel_tready),

  .preamble_state(cmd_state_reg[63:0]),
  .reload(cmd_init_reg),

  .match_rule_ID(match_index),
  .match_release(release_match),
  .match_valid(match_valid),

  .last_bytes_state(accel_state),
  .match_valid_stat(match_valid_stat)
);

always @ (posedge clk)
  if (cmd_init_reg | rst) begin
    match_1hot <= 0;
  end else begin
    match_1hot <= match_1hot | match_valid_stat;
  end

assign match_indexes = {16'd0, match_index};
assign sme_match     = |match_valid_stat;

always @ (posedge clk) begin
  status_match <= (status_match | sme_match) & (~cmd_init_reg);
  status_done  <= (status_done  | (accel_tvalid & accel_tlast) | cmd_stop_reg)
                  & (~cmd_init_reg);

  if (rst) begin
    status_match <= {ACCEL_COUNT{1'b0}};
    status_done  <= {ACCEL_COUNT{1'b0}};
  end
end

// CND IP check accelerator
// ip_match and ip_done keep their value until new valid is asserted
// It needs byte swap due to network packets endian
ip_match ip_match_inst (
  .clk(clk),
  .rst(rst),
  .addr({ip_addr_reg[7:0], ip_addr_reg[15:8],
         ip_addr_reg[23:16], ip_addr_reg[31:24]}),
  .valid(ip_addr_valid_reg),
  .match(ip_match),
  .done(ip_done)
);

endmodule
