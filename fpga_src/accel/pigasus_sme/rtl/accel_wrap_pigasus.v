module accel_wrap #(
  parameter IO_DATA_WIDTH   = 32,
  parameter IO_STRB_WIDTH   = (IO_DATA_WIDTH/8),
  parameter IO_ADDR_WIDTH   = 22,
  parameter DATA_WIDTH      = 128,
  parameter STRB_WIDTH      = (DATA_WIDTH/8),
  parameter PMEM_ADDR_WIDTH = 8,
  parameter AROM_ADDR_WIDTH = 21,
  parameter AROM_DATA_WIDTH = 72,
  parameter SLOW_M_B_LINES  = 4096,
  parameter ACC_ADDR_WIDTH  = $clog2(SLOW_M_B_LINES),
  parameter PMEM_SEL_BITS   = PMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                              -1-$clog2(SLOW_M_B_LINES),
  parameter ACC_MEM_BLOCKS  = 2**PMEM_SEL_BITS,
  parameter SLOT_COUNT      = 16
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

  input  wire [AROM_ADDR_WIDTH-1:0]               acc_rom_wr_addr,
  input  wire [AROM_DATA_WIDTH-1:0]               acc_rom_wr_data,
  input  wire                                     acc_rom_wr_en,

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

localparam LEN_WIDTH = 14;
localparam BLOCK_ADDR_WIDTH =PMEM_ADDR_WIDTH-PMEM_SEL_BITS;

reg   dma_done;
wire  dma_ready;
reg   dma_done_err;
wire  dma_desc_err = 1'b0;

reg  [PMEM_ADDR_WIDTH-1:0] cmd_addr_reg;
reg  [LEN_WIDTH-1:0]       cmd_len_reg;
reg                        cmd_valid_reg;
reg                        cmd_stop_reg;
reg                        match_release;
reg  [63:0]                cmd_preamble_reg;
reg  [31:0]                cmd_port_reg;
reg  [7:0]                 cmd_slot_reg;

wire         match_valid;
wire         match_last;
wire [31:0]  match_rules_ID;
wire [63:0]  accel_state;
wire [7:0]   accel_slot;
wire         accel_state_valid;

reg [31:0]  src_ip_reg = 0;
reg [31:0]  dst_ip_reg = 0;
reg         src_ip_valid_reg = 0;
reg         dst_ip_valid_reg = 0;
reg         read_data_stall_reg;

wire       dos_attack     = 1'b0;
wire [2:0] from_attack      = 3'd0;
wire       from_attack_done = 1'b0;

reg [IO_DATA_WIDTH-1:0] read_data_reg;
reg read_data_valid_reg;

assign io_rd_data = read_data_reg;
assign io_rd_valid = read_data_valid_reg;

always @(posedge clk) begin
  cmd_valid_reg <= 1'b0;
  cmd_stop_reg  <= 1'b0;
  match_release <= 1'b0;

  src_ip_valid_reg   <= 1'b0;
  dst_ip_valid_reg   <= 1'b0;
  read_data_valid_reg <= 1'b0;

  // Memory mapped I/O writes
  if (io_en && io_wen) begin
    // <1xx xxxx> for IP write for CDN and DoS accels
    if (io_addr[6]) begin
      if(io_addr[5:4]==2'b00) begin // CDN+DoS
        src_ip_reg       <= io_wr_data;
        src_ip_valid_reg <= 1'b1;
      end else if(io_addr[5:4]==2'b01) begin // DoS
        dst_ip_reg       <= io_wr_data;
        dst_ip_valid_reg <= 1'b1;
      end
      // 2'b10 and 2'b11 used in read port

    // <0 xxxx> for Pigasus IPS
    end else if (!io_addr[5]) begin
      case ({io_addr[4:2], 2'b00})
        // Pigasus control register, to start, stop and release the output
        5'h00: begin
          if (io_strb[0]) begin
            cmd_valid_reg <= io_wr_data[0];
            match_release <= io_wr_data[1];
            cmd_stop_reg  <= io_wr_data[2];
          end
        end
        // DMA request len

        5'h04: begin
          cmd_len_reg <= io_wr_data;
        end
        // DMA request start addr
        5'h08: begin
          cmd_addr_reg <= io_wr_data;
        end
        // Packet header ports
        5'h0c: begin
          if (io_strb[1] && io_strb[0])
            cmd_port_reg[15:0] <= io_wr_data[15:0];
          if (io_strb[3] && io_strb[2])
            cmd_port_reg[31:16] <= io_wr_data[31:16];
        end

        // SME input (preamble bytes and state)
        5'h10: begin
          cmd_preamble_reg[31:0] <= io_wr_data;
        end
        5'h14: begin
          cmd_preamble_reg[63:32] <= io_wr_data;
        end

        // Slot meta data
        5'h18: begin
          cmd_slot_reg <= io_wr_data[7:0];
        end
        // 5'h1c reserved to avoid read conflict
      endcase
    end
  end

  // Memory mapped I/O reads
  // There are 2 cases of read stall, for CDN or DoS
  if (io_en && !io_wen) begin
    read_data_reg <= 0;
    read_data_valid_reg <= 1'b1;

    // <1xx xxxx> for IP write for CDN and DoS accels + DMA stat
    if (io_addr[6]) begin
      case(io_addr[5:4])
        2'b00: begin // CDN+DoS
          read_data_reg <= src_ip_reg;
        end
        2'b01: begin // DoS
          read_data_reg <= dst_ip_reg;
        end

        2'b10: begin
          if (io_addr[3:2]==2'b00) begin
            read_data_reg       <=  ip_match;
            read_data_valid_reg <=  ip_done;
            read_data_stall_reg <= !ip_done;
          end else if (io_addr[3:2]==2'b10) begin
            read_data_reg <= {8'd0, 7'd0, from_attack[2],
                              7'd0, from_attack[1], 7'd0, from_attack[0]};
            read_data_valid_reg <=  from_attack_done;
            read_data_stall_reg <= !from_attack_done;
          end else if (io_addr[3:2]==2'b11) begin
            read_data_reg <= {31'd0, dos_attack};
          end
        end

        2'b11: begin
          read_data_reg <= {8'd0, 7'd0, dma_done_err,
                            7'd0, dma_done, 7'd0, dma_ready};
        end
      endcase

    // <0 xxxx> for Pigasus IPS
    end else if (!io_addr[5]) begin
      case ({io_addr[4:2], 2'b00})
        // Match status
        6'h00: begin
          read_data_reg[0]  <= match_valid;
        end

        // DMA len and address readback
        6'h04: begin
          read_data_reg <= cmd_len_reg;
        end
        6'h08: begin
          read_data_reg <= cmd_addr_reg;
        end
        // cmd_port_reg readback
        6'h0c: begin
          read_data_reg <= cmd_port_reg;
        end

        // cmd_preamble_reg readback
        6'h10: begin
          read_data_reg <= accel_state[31:0];
        end
        6'h14: begin
          read_data_reg <= accel_state[63:32];
        end

        // Slot meta data and if it's valid
        6'h18: begin
          read_data_reg <= {23'd0, accel_state_valid, accel_slot};
        end

        // Accel match rule ID
        6'h1c: begin
          read_data_reg <= match_rules_ID;
        end

      endcase
    end
  end

  // core keeps the address in case of stall, there are total 2 cases
  if (read_data_stall_reg) begin
    if (io_addr[3]) begin
      read_data_reg <= {8'd0, 7'd0, from_attack[2],
                        7'd0, from_attack[1], 7'd0, from_attack[0]};
      read_data_stall_reg <= !from_attack_done;
    end else begin
      read_data_valid_reg <=  ip_done;
      read_data_stall_reg <= !ip_done;
    end
  end

  if (rst) begin
    cmd_valid_reg       <= 1'b0;
    cmd_stop_reg        <= 1'b0;
    match_release       <= 1'b0;
    src_ip_valid_reg    <= 1'b0;
    dst_ip_valid_reg    <= 1'b0;

    read_data_stall_reg <= 1'b0;
    read_data_valid_reg <= 1'b0;

    // Initial state of preamble
    cmd_preamble_reg[63:56] <= 1'b0;
  end
end

// Register Pigasus data in separate FIFOs to feed the
// 3 accelerators in the proper time
wire [BLOCK_ADDR_WIDTH+1-1:0] cmd_addr_reg_f;
wire [LEN_WIDTH-1:0]          cmd_len_reg_f;
wire                          cmd_valid_reg_f;

simple_fifo # (
  .ADDR_WIDTH($clog2(SLOT_COUNT)-1),
  .DATA_WIDTH(LEN_WIDTH+BLOCK_ADDR_WIDTH+1)
) desc_fifo (
  .clk(clk),
  .rst(rst),
  .clear(1'b0),

  .din_valid(cmd_valid_reg),
  .din({cmd_addr_reg[BLOCK_ADDR_WIDTH+1-1:0], cmd_len_reg}),
  .din_ready(),

  .dout_valid(cmd_valid_reg_f),
  .dout({cmd_addr_reg_f, cmd_len_reg_f}),
  .dout_ready(dma_ready)
);

wire        meta_data_valid, meta_data_ready;
wire [63:0] preamble_state;
wire [15:0] src_port, dst_port;

simple_fifo # (
  .ADDR_WIDTH($clog2(SLOT_COUNT)-1),
  .DATA_WIDTH(64+32)
) meta_data_fifo (
  .clk(clk),
  .rst(rst),
  .clear(1'b0),

  .din_valid(cmd_valid_reg),
  .din({cmd_preamble_reg, cmd_port_reg}), // port might need byte swapping
  .din_ready(),

  .dout_valid(meta_data_valid),
  .dout({preamble_state, src_port, dst_port}),
  .dout_ready(meta_data_ready)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(SLOT_COUNT)-1),
  .DATA_WIDTH(8)
) cmd_slot_fifo (
  .clk(clk),
  .rst(rst),
  .clear(1'b0),

  .din_valid(cmd_valid_reg),
  .din(cmd_slot_reg),
  .din_ready(),

  .dout_valid(meta_slot_valid),
  .dout(accel_slot),
  .dout_ready(match_release && match_last)
);

// DMA engine for single block of the packet memory
localparam ATTACHED_CNT = SLOT_COUNT/8;
localparam ATTACHED = ACC_MEM_BLOCKS-ATTACHED_CNT;
localparam USER_WIDTH = $clog2(DATA_WIDTH/8);

wire [DATA_WIDTH-1:0] accel_tdata;
wire [USER_WIDTH-1:0] accel_tuser;
wire                  accel_tlast;
wire                  accel_tvalid;
wire                  accel_tready;

single_accel_rd_dma # (
  .DATA_WIDTH(DATA_WIDTH),
  .KEEP_WIDTH(DATA_WIDTH/8),
  .ADDR_WIDTH(BLOCK_ADDR_WIDTH+1),
  .LEN_WIDTH(LEN_WIDTH),
  .MEM_LINES(SLOW_M_B_LINES),
  .FIFO_LINES(8)
) accel_dma_engine (
  .clk(clk),
  .rst(rst),

  .desc_addr(cmd_addr_reg_f),
  .desc_len(cmd_len_reg_f),
  .desc_valid(cmd_valid_reg_f),
  .desc_ready(dma_ready),
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

always @ (posedge clk) begin
  dma_done     <= (dma_done  | (accel_tvalid & accel_tlast) | cmd_stop_reg);
  dma_done_err <= dma_done_err | (dma_done & !dma_ready);

  if (rst) begin
    dma_done     <= 1'b0;
    dma_done_err <= 1'b0;
  end
end

// Pigasus accelerator
wire [63:0] state_out;
wire        state_out_valid;
wire [4-1:0] accel_tempty = 4'hf-accel_tuser;

pigasus_sme_wrapper fast_pattern_sme_inst (
  .clk(clk),
  .rst(rst),

  .s_axis_tdata(accel_tdata),
  .s_axis_tempty(accel_tempty),
  .s_axis_tvalid(accel_tvalid),
  .s_axis_tlast(accel_tlast),
  .s_axis_tready(accel_tready),

  .wr_data(acc_rom_wr_data),
  .wr_addr(acc_rom_wr_addr[AROM_ADDR_WIDTH-1:4]),
  .wr_en(acc_rom_wr_en),

  .preamble_state_in(preamble_state),
  .src_port(src_port),
  .dst_port(dst_port),
  .meta_valid(meta_data_valid),
  .meta_ready(meta_data_ready),

  .match_rules_ID(match_rules_ID),
  .match_last(match_last),
  .match_valid(match_valid),
  .match_release(match_release),

  .preamble_state_out(state_out),
  .state_out_valid(state_out_valid)
);

// FIFO for output state
simple_fifo # (
  .ADDR_WIDTH($clog2(SLOT_COUNT)-1),
  .DATA_WIDTH(64)
) state_out_fifo (
  .clk(clk),
  .rst(rst),
  .clear(1'b0),

  .din_valid(state_out_valid),
  .din(state_out),
  .din_ready(),

  .dout_valid(accel_state_valid),
  .dout(accel_state),
  .dout_ready(match_release && match_last)
);

// CND IP check accelerator
// ip_match and ip_done keep their value until new valid is asserted
// It needs byte swap due to network packets endian
ip_match ip_match_inst (
  .clk(clk),
  .rst(rst),
  .addr({src_ip_reg[7:0], src_ip_reg[15:8],
         src_ip_reg[23:16], src_ip_reg[31:24]}),
  .valid(src_ip_valid_reg),
  .match(ip_match),
  .done(ip_done)
);

endmodule
