module scheduler_PR (
  input                   clk,
  input                   rst,

  // Data line to/from Eth interfaces
  input  wire [3*512-1:0] rx_axis_tdata,
  input  wire [3*64-1:0]  rx_axis_tkeep,
  input  wire [3-1:0]     rx_axis_tvalid,
  output wire [3-1:0]     rx_axis_tready,
  input  wire [3-1:0]     rx_axis_tlast,
  input  wire [3-1:0]     rx_axis_almost_full,

  output wire [3*512-1:0] tx_axis_tdata,
  output wire [3*64-1:0]  tx_axis_tkeep,
  output wire [3-1:0]     tx_axis_tvalid,
  input  wire [3-1:0]     tx_axis_tready,
  output wire [3-1:0]     tx_axis_tlast,

  // DATA lines to/from cores
  output wire [3*512-1:0] data_m_axis_tdata,
  output wire [3*64-1:0]  data_m_axis_tkeep,
  output wire [3*9-1:0]   data_m_axis_tdest,
  output wire [3*3-1:0]   data_m_axis_tuser,
  output wire [3-1:0]     data_m_axis_tvalid,
  input  wire [3-1:0]     data_m_axis_tready,
  output wire [3-1:0]     data_m_axis_tlast,

  input  wire [3*512-1:0] data_s_axis_tdata,
  input  wire [3*64-1:0]  data_s_axis_tkeep,
  input  wire [3*9-1:0]   data_s_axis_tuser,
  input  wire [3-1:0]     data_s_axis_tvalid,
  output wire [3-1:0]     data_s_axis_tready,
  input  wire [3-1:0]     data_s_axis_tlast,

  // Control lines to/from cores
  output wire [36-1:0]    ctrl_m_axis_tdata,
  output wire             ctrl_m_axis_tvalid,
  input  wire             ctrl_m_axis_tready,
  output wire [4-1:0]     ctrl_m_axis_tdest,

  input  wire [36-1:0]    ctrl_s_axis_tdata,
  input  wire             ctrl_s_axis_tvalid,
  output wire             ctrl_s_axis_tready,
  input  wire [4-1:0]     ctrl_s_axis_tuser,

  // Cores commands
  input  wire [31:0]      host_cmd,
  input  wire [31:0]      host_cmd_wr_data,
  output reg  [31:0]      host_cmd_rd_data,
  input  wire             host_cmd_valid
);

  parameter INTERFACE_COUNT = 3;
  parameter PORT_COUNT      = 5;
  parameter CORE_COUNT      = 16;
  parameter SLOT_COUNT      = 16;
  parameter DATA_WIDTH      = 512;
  parameter CTRL_WIDTH      = 32+4;
  parameter LOOPBACK_PORT   = 3;
  parameter LOOPBACK_COUNT  = 1;
  parameter DATA_REG_TYPE   = 2;
  parameter CTRL_REG_TYPE   = 2;
  parameter DATA_FIFO_DEPTH = 4096;
  parameter HASH_SEL_OFFSET = 0;

  parameter SLOT_WIDTH      = $clog2(SLOT_COUNT+1);
  parameter CORE_ID_WIDTH   = $clog2(CORE_COUNT);
  parameter INTERFACE_WIDTH = $clog2(INTERFACE_COUNT);
  parameter PORT_WIDTH      = $clog2(PORT_COUNT);
  parameter TAG_WIDTH       = (SLOT_WIDTH>5)? SLOT_WIDTH:5;
  parameter ID_TAG_WIDTH    = CORE_ID_WIDTH+TAG_WIDTH;
  parameter STRB_WIDTH      = DATA_WIDTH/8;
  parameter HASH_FIFO_DEPTH = DATA_FIFO_DEPTH/64;
  parameter HASH_N_DESC     = 32+ID_TAG_WIDTH+1;

  // Register inputs and outputs
  wire [INTERFACE_COUNT*DATA_WIDTH-1:0]    data_m_axis_tdata_n;
  wire [INTERFACE_COUNT*STRB_WIDTH-1:0]    data_m_axis_tkeep_n;
  wire [INTERFACE_COUNT*ID_TAG_WIDTH-1:0]  data_m_axis_tdest_n;
  wire [INTERFACE_COUNT*PORT_WIDTH-1:0]    data_m_axis_tuser_n;
  wire [INTERFACE_COUNT-1:0]               data_m_axis_tvalid_n;
  wire [INTERFACE_COUNT-1:0]               data_m_axis_tready_n;
  wire [INTERFACE_COUNT-1:0]               data_m_axis_tlast_n;

  wire [INTERFACE_COUNT*DATA_WIDTH-1:0]    rx_axis_tdata_r;
  wire [INTERFACE_COUNT*STRB_WIDTH-1:0]    rx_axis_tkeep_r;
  wire [INTERFACE_COUNT-1:0]               rx_axis_tvalid_r;
  wire [INTERFACE_COUNT-1:0]               rx_axis_tready_r;
  wire [INTERFACE_COUNT-1:0]               rx_axis_tlast_r;

  wire [INTERFACE_COUNT*DATA_WIDTH-1:0]    rx_axis_tdata_f;
  wire [INTERFACE_COUNT*STRB_WIDTH-1:0]    rx_axis_tkeep_f;
  wire [INTERFACE_COUNT-1:0]               rx_axis_tvalid_f;
  wire [INTERFACE_COUNT-1:0]               rx_axis_tready_f;
  wire [INTERFACE_COUNT-1:0]               rx_axis_tlast_f;

  wire [INTERFACE_COUNT*32-1:0]            rx_hash;
  wire [INTERFACE_COUNT*4-1:0]             rx_hash_type;
  wire [INTERFACE_COUNT-1:0]               rx_hash_valid;
  // wire [INTERFACE_COUNT-1:0]               rx_hash_ready;

  wire [INTERFACE_COUNT*32-1:0]            rx_hash_f;
  wire [INTERFACE_COUNT*4-1:0]             rx_hash_type_f;
  wire [INTERFACE_COUNT-1:0]               rx_hash_valid_f;
  reg  [INTERFACE_COUNT-1:0]               rx_hash_ready_f;

  wire [INTERFACE_COUNT*CORE_ID_WIDTH-1:0] masked_hash;

  wire [INTERFACE_COUNT*HASH_N_DESC-1:0]   hash_n_dest_in;
  reg  [INTERFACE_COUNT-1:0]               hash_n_dest_in_v;
  wire [INTERFACE_COUNT-1:0]               hash_n_dest_in_ready;

  wire [INTERFACE_COUNT*32-1:0]            hash_out;
  wire [INTERFACE_COUNT*ID_TAG_WIDTH-1:0]  dest_out;
  wire [INTERFACE_COUNT-1:0]               drop_out;
  wire [INTERFACE_COUNT-1:0]               hash_n_dest_out_v;
  wire [INTERFACE_COUNT-1:0]               hash_n_dest_out_ready;

  wire [CTRL_WIDTH-1:0]                    ctrl_s_axis_tdata_r;
  wire                                     ctrl_s_axis_tvalid_r;
  wire                                     ctrl_s_axis_tready_r;
  wire [CORE_ID_WIDTH-1:0]                 ctrl_s_axis_tuser_r;

  wire [CTRL_WIDTH-1:0]                    ctrl_m_axis_tdata_n;
  wire                                     ctrl_m_axis_tvalid_n;
  wire                                     ctrl_m_axis_tready_n;
  wire [CORE_ID_WIDTH-1:0]                 ctrl_m_axis_tdest_n;

  wire rst_r;
  sync_reset sync_rst_inst (
    .clk(clk),
    .rst(rst),
    .out(rst_r)
  );

  genvar q;
  generate
    for (q=0; q<INTERFACE_COUNT; q=q+1) begin: int_regs_n_hash

      /// *** INPUT AND OUTPUT DATA LINE REGISTERS FOR BETTER TIMING *** ///

      // A register before TX for better timing
      axis_pipeline_register # (
        .DATA_WIDTH(DATA_WIDTH),
        .KEEP_ENABLE(1),
        .KEEP_WIDTH(STRB_WIDTH),
        .LAST_ENABLE(1),
        .ID_ENABLE(0),
        .DEST_ENABLE(0),
        .USER_ENABLE(1),
        .USER_WIDTH(ID_TAG_WIDTH),
        .REG_TYPE(DATA_REG_TYPE),
        .LENGTH(2)
      ) data_s_reg_inst (
        .clk(clk),
        .rst(rst_r),
        // AXI input
        .s_axis_tdata (data_s_axis_tdata[q*DATA_WIDTH +: DATA_WIDTH]),
        .s_axis_tkeep (data_s_axis_tkeep[q*STRB_WIDTH +: STRB_WIDTH]),
        .s_axis_tvalid(data_s_axis_tvalid[q]),
        .s_axis_tready(data_s_axis_tready[q]),
        .s_axis_tlast (data_s_axis_tlast[q]),
        .s_axis_tid   (8'd0),
        .s_axis_tdest (8'd0),
        .s_axis_tuser (data_s_axis_tuser[q*ID_TAG_WIDTH +: ID_TAG_WIDTH]),
        // AXI output
        .m_axis_tdata (tx_axis_tdata[q*DATA_WIDTH +: DATA_WIDTH]),
        .m_axis_tkeep (tx_axis_tkeep[q*STRB_WIDTH +: STRB_WIDTH]),
        .m_axis_tvalid(tx_axis_tvalid[q]),
        .m_axis_tready(tx_axis_tready[q]),
        .m_axis_tlast (tx_axis_tlast[q]),
        .m_axis_tid   (),
        .m_axis_tdest (),
        .m_axis_tuser ()
      );

      axis_pipeline_register # (
        .DATA_WIDTH(DATA_WIDTH),
        .KEEP_ENABLE(1),
        .KEEP_WIDTH(STRB_WIDTH),
        .LAST_ENABLE(1),
        .ID_ENABLE(0),
        .DEST_ENABLE(1),
        .DEST_WIDTH(ID_TAG_WIDTH),
        .USER_ENABLE(1),
        .USER_WIDTH(PORT_WIDTH),
        .REG_TYPE(DATA_REG_TYPE),
        .LENGTH(1)
      ) data_m_reg_inst (
        .clk(clk),
        .rst(rst_r),
        // AXI input
        .s_axis_tdata (data_m_axis_tdata_n[q*DATA_WIDTH +: DATA_WIDTH]),
        .s_axis_tkeep (data_m_axis_tkeep_n[q*STRB_WIDTH +: STRB_WIDTH]),
        .s_axis_tvalid(data_m_axis_tvalid_n[q]),
        .s_axis_tready(data_m_axis_tready_n[q]),
        .s_axis_tlast (data_m_axis_tlast_n[q]),
        .s_axis_tid   (8'd0),
        .s_axis_tdest (data_m_axis_tdest_n[q*ID_TAG_WIDTH +: ID_TAG_WIDTH]),
        .s_axis_tuser (data_m_axis_tuser_n[q*PORT_WIDTH +: PORT_WIDTH]),
        // AXI output
        .m_axis_tdata (data_m_axis_tdata[q*DATA_WIDTH +: DATA_WIDTH]),
        .m_axis_tkeep (data_m_axis_tkeep[q*STRB_WIDTH +: STRB_WIDTH]),
        .m_axis_tvalid(data_m_axis_tvalid[q]),
        .m_axis_tready(data_m_axis_tready[q]),
        .m_axis_tlast (data_m_axis_tlast[q]),
        .m_axis_tid   (),
        .m_axis_tdest (data_m_axis_tdest[q*ID_TAG_WIDTH +: ID_TAG_WIDTH]),
        .m_axis_tuser (data_m_axis_tuser[q*PORT_WIDTH +: PORT_WIDTH])
      );

      axis_pipeline_register # (
        .DATA_WIDTH(DATA_WIDTH),
        .KEEP_ENABLE(1),
        .KEEP_WIDTH(STRB_WIDTH),
        .LAST_ENABLE(1),
        .ID_ENABLE(0),
        .DEST_ENABLE(0),
        .USER_ENABLE(0),
        .REG_TYPE(DATA_REG_TYPE),
        .LENGTH(1)
      ) rx_reg_inst (
        .clk(clk),
        .rst(rst_r),
        // AXI input
        .s_axis_tdata (rx_axis_tdata[q*DATA_WIDTH +: DATA_WIDTH]),
        .s_axis_tkeep (rx_axis_tkeep[q*STRB_WIDTH +: STRB_WIDTH]),
        .s_axis_tvalid(rx_axis_tvalid[q]),
        .s_axis_tready(rx_axis_tready[q]),
        .s_axis_tlast (rx_axis_tlast[q]),
        .s_axis_tid   (8'd0),
        .s_axis_tdest (8'd0),
        .s_axis_tuser (1'b0),
        // AXI output
        .m_axis_tdata (rx_axis_tdata_r[q*DATA_WIDTH +: DATA_WIDTH]),
        .m_axis_tkeep (rx_axis_tkeep_r[q*STRB_WIDTH +: STRB_WIDTH]),
        .m_axis_tvalid(rx_axis_tvalid_r[q]),
        .m_axis_tready(rx_axis_tready_r[q] && enabled_ints[q]),
        .m_axis_tlast (rx_axis_tlast_r[q]),
        .m_axis_tid   (),
        .m_axis_tdest (),
        .m_axis_tuser ()
      );

      /// *** COMPUTE FLOW HASH AND A FIFO FOR RESULTS *** ///

      rx_hash #(
        .DATA_WIDTH(DATA_WIDTH),
        .KEEP_WIDTH(STRB_WIDTH)
      ) rx_Toeplitz_hash (
        .clk(clk),
        .rst(rst_r),

        .s_axis_tdata (rx_axis_tdata_r[q*DATA_WIDTH +: DATA_WIDTH]),
        .s_axis_tkeep (rx_axis_tkeep_r[q*STRB_WIDTH +: STRB_WIDTH]),
        .s_axis_tvalid(rx_axis_tvalid_r[q] && rx_axis_tready_r[q] && enabled_ints[q]),
        .s_axis_tlast (rx_axis_tlast_r[q]),

        .hash_key(320'h6d5a56da255b0ec24167253d43a38fb0d0ca2bcbae7b30b477cb2da38030f20c6a42b73bbeac01fa),

        .m_axis_hash(rx_hash[q*32 +: 32]),
        .m_axis_hash_type(rx_hash_type[q*4 +: 4]),
        .m_axis_hash_valid(rx_hash_valid[q])
      );

      simple_fifo # (
        .ADDR_WIDTH($clog2(HASH_FIFO_DEPTH)),
        .DATA_WIDTH(32+4)
      ) rx_hash_fifo (
        .clk(clk),
        .rst(rst_r),
        .clear(1'b0),

        .din_valid(rx_hash_valid[q]),
        .din({rx_hash_type[q*4 +: 4], rx_hash[q*32 +: 32]}),
        .din_ready(), // rx_hash_ready[q]),
        // FIFO has more room than 64B packets in the data fifo

        .dout_valid(rx_hash_valid_f[q]),
        .dout({rx_hash_type_f[q*4 +: 4], rx_hash_f[q*32 +: 32]}),
        .dout_ready(rx_hash_ready_f[q])
      );

      // integrate hash_type?
      assign masked_hash[q*CORE_ID_WIDTH +: CORE_ID_WIDTH] =
                 rx_hash_f[(q*32)+HASH_SEL_OFFSET +: CORE_ID_WIDTH];

      /// *** DATA FIFO WHILE WAITING FOR HASH AND DESC ALLOCATION *** ///

      axis_fifo # (
          .DEPTH(DATA_FIFO_DEPTH),
          .DATA_WIDTH(DATA_WIDTH),
          .KEEP_ENABLE(1),
          .KEEP_WIDTH(STRB_WIDTH),
          .LAST_ENABLE(1),
          .ID_ENABLE(0),
          .DEST_ENABLE(0),
          .USER_ENABLE(0),
          .PIPELINE_OUTPUT(2),
          .FRAME_FIFO(0)
      ) rx_fifo_inst (
          .clk(clk),
          .rst(rst_r),

          .s_axis_tdata (rx_axis_tdata_r[q*DATA_WIDTH +: DATA_WIDTH]),
          .s_axis_tkeep (rx_axis_tkeep_r[q*STRB_WIDTH +: STRB_WIDTH]),
          .s_axis_tvalid(rx_axis_tvalid_r[q] && enabled_ints[q]),
          .s_axis_tready(rx_axis_tready_r[q]),
          .s_axis_tlast (rx_axis_tlast_r[q]),
          .s_axis_tid   (8'd0),
          .s_axis_tdest (8'd0),
          .s_axis_tuser (1'b0),

          .m_axis_tdata (rx_axis_tdata_f[q*DATA_WIDTH +: DATA_WIDTH]),
          .m_axis_tkeep (rx_axis_tkeep_f[q*STRB_WIDTH +: STRB_WIDTH]),
          .m_axis_tvalid(rx_axis_tvalid_f[q]),
          .m_axis_tready(rx_axis_tready_f[q]),
          .m_axis_tlast (rx_axis_tlast_f[q]),
          .m_axis_tid   (),
          .m_axis_tdest (),
          .m_axis_tuser (),

          .status_overflow(),
          .status_bad_frame(),
          .status_good_frame()
      );

      /// *** FIFO FOR HASH AND ALLOCATED DESC, WAITING TO BE SENT OUT *** ///

      simple_fifo # (
        .ADDR_WIDTH($clog2(HASH_FIFO_DEPTH)),
        .DATA_WIDTH(HASH_N_DESC)
      ) rx_hash_n_desc_fifo (
        .clk(clk),
        .rst(rst_r),
        .clear(1'b0),

        .din_valid(hash_n_dest_in_v[q]),
        .din(hash_n_dest_in[q*HASH_N_DESC +: HASH_N_DESC]),
        .din_ready(hash_n_dest_in_ready[q]),

        .dout_valid(hash_n_dest_out_v[q]),
        .dout({drop_out[q], hash_out[q*32 +: 32], dest_out[q*ID_TAG_WIDTH +: ID_TAG_WIDTH]}),
        .dout_ready(hash_n_dest_out_ready[q])
      );

      wire [PORT_WIDTH-1:0] port_num = q;

      /// *** ATTACHING HASH AT THE BEGINNING OF THE PACKET *** ///

      header_adder_blocking # (
        .DATA_WIDTH(DATA_WIDTH),
        .STRB_WIDTH(DATA_WIDTH/8),
        .HDR_WIDTH(32),
        .DEST_WIDTH(ID_TAG_WIDTH),
        .USER_WIDTH(PORT_WIDTH)
      ) hash_adder (
        .clk(clk),
        .rst(rst_r),

        .s_axis_tdata (rx_axis_tdata_f[q*DATA_WIDTH +: DATA_WIDTH]),
        .s_axis_tkeep (rx_axis_tkeep_f[q*STRB_WIDTH +: STRB_WIDTH]),
        .s_axis_tdest (dest_out[q*ID_TAG_WIDTH +: ID_TAG_WIDTH]),
        .s_axis_tuser (port_num),
        .s_axis_tlast (rx_axis_tlast_f[q]),
        .s_axis_tvalid(rx_axis_tvalid_f[q]),
        .s_axis_tready(rx_axis_tready_f[q]),

        .header(hash_out[q*32 +: 32]),
        .drop(drop_out[q]),
        .header_valid(hash_n_dest_out_v[q]),
        .header_ready(hash_n_dest_out_ready[q]),

        .m_axis_tdata(data_m_axis_tdata_n[q*DATA_WIDTH +: DATA_WIDTH]),
        .m_axis_tkeep(data_m_axis_tkeep_n[q*STRB_WIDTH +: STRB_WIDTH]),
        .m_axis_tdest(data_m_axis_tdest_n[q*ID_TAG_WIDTH +: ID_TAG_WIDTH]),
        .m_axis_tuser(data_m_axis_tuser_n[q*PORT_WIDTH +: PORT_WIDTH]),
        .m_axis_tlast(data_m_axis_tlast_n[q]),
        .m_axis_tvalid(data_m_axis_tvalid_n[q]),
        .m_axis_tready(data_m_axis_tready_n[q])
      );

    end
  endgenerate

  /// *** CTRL PATH REGISTERS FOR BETTER TIMING *** ///

  axis_register # (
    .DATA_WIDTH(CTRL_WIDTH),
    .KEEP_ENABLE(0),
    .KEEP_WIDTH(1),
    .LAST_ENABLE(0),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(CORE_ID_WIDTH),
    .REG_TYPE(CTRL_REG_TYPE)
  ) ctrl_s_reg_inst (
    .clk(clk),
    .rst(rst_r),
    // AXI input
    .s_axis_tdata (ctrl_s_axis_tdata),
    .s_axis_tkeep (1'b1),
    .s_axis_tvalid(ctrl_s_axis_tvalid),
    .s_axis_tready(ctrl_s_axis_tready),
    .s_axis_tlast (1'b1),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (8'd0),
    .s_axis_tuser (ctrl_s_axis_tuser),
    // AXI output
    .m_axis_tdata (ctrl_s_axis_tdata_r),
    .m_axis_tkeep (),
    .m_axis_tvalid(ctrl_s_axis_tvalid_r),
    .m_axis_tready(ctrl_s_axis_tready_r),
    .m_axis_tlast (),
    .m_axis_tid   (),
    .m_axis_tdest (),
    .m_axis_tuser (ctrl_s_axis_tuser_r)
  );

  axis_register # (
    .DATA_WIDTH(CTRL_WIDTH),
    .KEEP_ENABLE(0),
    .KEEP_WIDTH(1),
    .LAST_ENABLE(0),
    .ID_ENABLE(0),
    .DEST_ENABLE(1),
    .DEST_WIDTH(CORE_ID_WIDTH),
    .USER_ENABLE(0),
    .REG_TYPE(CTRL_REG_TYPE)
  ) ctrl_m_reg_inst (
    .clk(clk),
    .rst(rst_r),
    // AXI input
    .s_axis_tdata (ctrl_m_axis_tdata_n),
    .s_axis_tkeep (1'b1),
    .s_axis_tvalid(ctrl_m_axis_tvalid_n),
    .s_axis_tready(ctrl_m_axis_tready_n),
    .s_axis_tlast (1'b1),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (ctrl_m_axis_tdest_n),
    .s_axis_tuser (1'b0),
    // AXI output
    .m_axis_tdata (ctrl_m_axis_tdata),
    .m_axis_tkeep (),
    .m_axis_tvalid(ctrl_m_axis_tvalid),
    .m_axis_tready(ctrl_m_axis_tready),
    .m_axis_tlast (),
    .m_axis_tid   (),
    .m_axis_tdest (ctrl_m_axis_tdest),
    .m_axis_tuser ()
  );

  reg [31:0]                host_cmd_r;
  reg [31:0]                host_cmd_wr_data_r;
  reg                       host_to_cores_valid_r;
  reg                       host_to_sched_valid_r;
  reg [CORE_COUNT-1:0]      income_cores;
  reg [CORE_COUNT-1:0]      enabled_cores;
  reg [CORE_COUNT-1:0]      slots_flush;
  reg [CORE_ID_WIDTH-1:0]   stat_read_core_r;
  reg [INTERFACE_WIDTH-1:0] stat_read_interface_r;
  reg [31:0]                host_cmd_rd_data_n;
  reg [INTERFACE_COUNT-1:0] rx_almost_full_r;
  reg [INTERFACE_COUNT-1:0] enabled_ints;
  reg [2:0]                 sched_cmd_addr;

  // host cmd bit 31 high means wr. bit 30 low means command for cores
  always @ (posedge clk) begin
    host_cmd_r            <= host_cmd;
    host_cmd_wr_data_r    <= host_cmd_wr_data;
    host_to_cores_valid_r <= host_cmd_valid && host_cmd[31] && !host_cmd[30];
    host_to_sched_valid_r <= host_cmd_valid && host_cmd[31] &&  host_cmd[30];
    stat_read_core_r      <= host_cmd[CORE_ID_WIDTH-1:0];
    stat_read_interface_r <= host_cmd[INTERFACE_WIDTH-1:0];
    sched_cmd_addr        <= host_cmd[29:27];
    host_cmd_rd_data      <= host_cmd_rd_data_n;
    rx_almost_full_r      <= rx_axis_almost_full;

    if (host_to_sched_valid_r)
      case (sched_cmd_addr)
        3'b000: begin
          // A core to be reset cannot be an incoming core.
          income_cores  <= host_cmd_wr_data_r[CORE_COUNT-1:0] & enabled_cores;
        end
        3'b001: begin
          income_cores  <= income_cores & host_cmd_wr_data_r[CORE_COUNT-1:0];
          enabled_cores <= host_cmd_wr_data_r[CORE_COUNT-1:0];
        end
        3'b011: begin
          slots_flush   <= host_cmd_wr_data_r[CORE_COUNT-1:0];
        end
        3'b101: begin
          enabled_ints  <= host_cmd_wr_data_r[INTERFACE_COUNT-1:0];
        end

        default: begin //for one-cycle signals
          slots_flush  <= {CORE_COUNT{1'b0}};
        end
      endcase
    else begin // for one-cycle signals
          slots_flush  <= {CORE_COUNT{1'b0}};
    end

    if (rst_r) begin
      host_to_cores_valid_r <= 1'b0;
      host_to_sched_valid_r <= 1'b0;
      income_cores          <= {CORE_COUNT{1'b0}};
      enabled_cores         <= {CORE_COUNT{1'b0}};
      enabled_ints          <= {INTERFACE_COUNT{1'b0}};
      slots_flush           <= {CORE_COUNT{1'b0}};
    end
  end

  wire [3:0]                host_cores_cmd = host_cmd_r [3:0];
  wire [CORE_ID_WIDTH-1:0]  host_cmd_dest  = host_cmd_r [4 +: CORE_ID_WIDTH];

  // Separate incoming ctrl messages
  parameter MSG_TYPE_WIDTH = 4;
  parameter DESC_WIDTH     = CTRL_WIDTH-MSG_TYPE_WIDTH;

  wire [MSG_TYPE_WIDTH-1:0] msg_type =
                ctrl_s_axis_tdata_r[CTRL_WIDTH-1:CTRL_WIDTH-MSG_TYPE_WIDTH];

  wire [MSG_TYPE_WIDTH-1:0] send_out_msg = {(MSG_TYPE_WIDTH){1'b0}};
  wire [MSG_TYPE_WIDTH-1:0] loopback_msg = {{(MSG_TYPE_WIDTH-1){1'b0}},1'b1};

  wire [DESC_WIDTH-1:0]    pkt_done_desc;
  wire [CORE_ID_WIDTH-1:0] pkt_done_src;
  wire                     pkt_done_valid;
  wire                     pkt_done_ready;

  wire [CORE_COUNT*(DESC_WIDTH+CORE_ID_WIDTH)-1:0] pkt_to_core_req;
  wire [CORE_COUNT*SLOT_WIDTH-1:0]                 rx_desc_slot;
  wire [CORE_COUNT-1:0] pkt_to_core_valid, pkt_to_core_ready,
                        arb_to_core_ready, rx_desc_slot_v;

  wire loopback_ready;

  simple_fifo # (
    .ADDR_WIDTH(3),
    .DATA_WIDTH(CORE_ID_WIDTH+DESC_WIDTH)
  ) pkt_done_fifo (
    .clk(clk),
    .rst(rst_r),
    .clear(1'b0),

    .din_valid(ctrl_s_axis_tvalid_r && (msg_type==1)),
    .din({ctrl_s_axis_tuser_r,ctrl_s_axis_tdata_r[DESC_WIDTH-1:0]}),
    .din_ready(pkt_done_ready),

    .dout_valid(pkt_done_valid),
    .dout({pkt_done_src,pkt_done_desc}),
    .dout_ready(loopback_ready)
  );

  genvar m;
  generate
    for (m=0;m<CORE_COUNT;m=m+1) begin
      wire [CORE_ID_WIDTH-1:0] dest_core = ctrl_s_axis_tdata_r[24+:CORE_ID_WIDTH];
      simple_fifo # (
        .ADDR_WIDTH($clog2(SLOT_COUNT)),
        .DATA_WIDTH(CORE_ID_WIDTH+DESC_WIDTH)
      ) pkt_to_core_fifo (
        .clk(clk),
        .rst(rst_r),
        .clear(1'b0),

        .din_valid(ctrl_s_axis_tvalid_r && (msg_type==2) && (dest_core==m)),
        .din({ctrl_s_axis_tuser_r, ctrl_s_axis_tdata_r[DESC_WIDTH-1:0]}),
        .din_ready(pkt_to_core_ready[m]),

        .dout_valid(pkt_to_core_valid[m]),
        .dout(pkt_to_core_req[m*(DESC_WIDTH+CORE_ID_WIDTH) +:
                                (DESC_WIDTH+CORE_ID_WIDTH)]),
        .dout_ready(arb_to_core_ready[m] && rx_desc_slot_v[m] && enabled_cores[m])
      );
    end
  endgenerate

  wire [CORE_ID_WIDTH-1:0] selected_pkt_to_core_src;
  wire [SLOT_WIDTH-1:0]    selected_pkt_to_core_dest_slot;
  wire [DESC_WIDTH-1:0]    selected_pkt_to_core_desc;
  wire                     selected_pkt_to_core_valid,
                           selected_pkt_to_core_ready;
  axis_arb_mux #
  (
    .S_COUNT(CORE_COUNT),
    .DATA_WIDTH(CORE_ID_WIDTH+DESC_WIDTH),
    .KEEP_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(SLOT_WIDTH),
    .ARB_TYPE("ROUND_ROBIN")
  ) pkt_to_core_arbiter
  (
    .clk(clk),
    .rst(rst_r),

    .s_axis_tdata(pkt_to_core_req),
    .s_axis_tkeep(),
    .s_axis_tvalid(pkt_to_core_valid & rx_desc_slot_v & enabled_cores),
    .s_axis_tready(arb_to_core_ready),
    .s_axis_tlast({CORE_COUNT{1'b1}}),
    .s_axis_tid(),
    .s_axis_tdest(),
    .s_axis_tuser(rx_desc_slot),

    .m_axis_tdata({selected_pkt_to_core_src, selected_pkt_to_core_desc}),
    .m_axis_tkeep(),
    .m_axis_tvalid(selected_pkt_to_core_valid),
    .m_axis_tready(selected_pkt_to_core_ready),
    .m_axis_tlast(),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(selected_pkt_to_core_dest_slot)
  );

  assign ctrl_s_axis_tready_r = ((msg_type==0)   ||   (msg_type==3)) ||
                                (pkt_done_ready    && (msg_type==1)) ||
                                (pkt_to_core_ready && (msg_type==2)) ;

  // Slot descriptor fifos, addressing msg type 0&3 requests
  wire [CORE_COUNT*SLOT_WIDTH-1:0] rx_desc_count;
  reg  [CORE_ID_WIDTH-1:0] rx_dest_core;
  wire [CORE_COUNT-1:0]    rx_desc_slot_pop;
  wire [CORE_COUNT-1:0]    rx_desc_avail;
  wire [CORE_COUNT-1:0]    msg_desc_pop;

  reg  [CORE_COUNT-1:0] enq_slot_v;
  reg  [CORE_COUNT-1:0] init_slot_v;
  reg  [SLOT_WIDTH-1:0] input_slot;

  always @ (posedge clk)
    input_slot <= ctrl_s_axis_tdata_r[16 +: SLOT_WIDTH];

  reg  rx_desc_pop;

  wire [CORE_COUNT-1:0] core_slot_err;
  reg  slot_insert_err;

  always @ (posedge clk) begin
    slot_insert_err <= | core_slot_err;
  end

  genvar i;
  generate
    for (i=0;i<CORE_COUNT;i=i+1) begin
      assign rx_desc_slot_pop[i]    = (rx_desc_pop && (rx_dest_core==i)) ||
                                      (pkt_to_core_valid[i] && arb_to_core_ready[i] && enabled_cores[i]);

      // Register valid for better timing closure
      always @ (posedge clk)
        if (rst_r) begin
          enq_slot_v[i]  <= 1'b0;
          init_slot_v[i] <= 1'b0;
        end else begin
          enq_slot_v[i]  <= ctrl_s_axis_tvalid_r && (msg_type==0) && (ctrl_s_axis_tuser_r==i);
          init_slot_v[i] <= ctrl_s_axis_tvalid_r && (msg_type==3) && (ctrl_s_axis_tuser_r==i);
        end

      slot_keeper # (
        .SLOT_COUNT(SLOT_COUNT),
        .SLOT_WIDTH(SLOT_WIDTH)
      ) rx_desc_keeper (
        .clk(clk),
        .rst(rst_r|slots_flush[i]),

        .init_slots(input_slot),
        .init_valid(init_slot_v[i]),

        .slot_in(input_slot),
        .slot_in_valid(enq_slot_v[i]),

        .slot_out(rx_desc_slot[i*SLOT_WIDTH +: SLOT_WIDTH]),
        .slot_out_valid(rx_desc_slot_v[i]),
        .slot_out_pop(rx_desc_slot_pop[i]),

        .slot_count(rx_desc_count[i*SLOT_WIDTH +: SLOT_WIDTH]),
        .enq_err(core_slot_err[i])
      );

    end
  endgenerate

  // Assing looback port
  wire [CORE_ID_WIDTH-1:0] loopback_port;

  if (LOOPBACK_COUNT==1)
    assign loopback_port = LOOPBACK_PORT;
  else if (LOOPBACK_COUNT==2) begin

    reg loopback_port_select_r;

    always @ (posedge clk)
      if (rst_r)
        loopback_port_select_r <= 1'b0;
      else if (selected_pkt_to_core_valid && selected_pkt_to_core_ready)
        loopback_port_select_r <= ~loopback_port_select_r;

    assign loopback_port = loopback_port_select_r ? (LOOPBACK_PORT+1) : LOOPBACK_PORT;

  end else begin

    reg [$clog2(LOOPBACK_COUNT)-1:0] loopback_port_select_r;

    always @ (posedge clk)
      if (rst_r)
        loopback_port_select_r <= 0;
      else if (selected_pkt_to_core_valid && selected_pkt_to_core_ready)
        if (loopback_port_select_r==(LOOPBACK_COUNT-1))
          loopback_port_select_r <= 0;
        else
          loopback_port_select_r <= loopback_port_select_r+1;

    assign loopback_port = LOOPBACK_PORT + loopback_port_select_r;

  end

  wire [ID_TAG_WIDTH-1:0] dest_id_slot = {selected_pkt_to_core_desc[24 +: CORE_ID_WIDTH],
                               {(TAG_WIDTH-SLOT_WIDTH){1'b0}}, selected_pkt_to_core_dest_slot};

  wire [DESC_WIDTH-1:0] pkt_to_core_with_port =
              {{(8-CORE_ID_WIDTH){1'b0}}, loopback_port,
              selected_pkt_to_core_desc[23:16], //this is src slot
              {(16-ID_TAG_WIDTH){1'b0}}, dest_id_slot};

  // Arbiter for ctrl messaage output

  // arbiter between pkt done and pkt send to core, addressing msg type 1&2 requests
  wire [CORE_ID_WIDTH-1:0] ctrl_out_dest;
  wire [CTRL_WIDTH-1:0]    ctrl_out_desc;
  wire ctrl_out_valid, ctrl_out_ready;

  reg last_selected;
  reg ctrl_out_select;

  always @ (posedge clk)
    if (rst_r)
      last_selected <= 1'b0;
    else if (ctrl_out_valid && ctrl_out_ready)
      last_selected <= ctrl_out_select;

  always @ (*)
    if (selected_pkt_to_core_valid && pkt_done_valid)
      ctrl_out_select = ~last_selected;
    else if (selected_pkt_to_core_valid)
      ctrl_out_select = 1'b1;
    else if (pkt_done_valid)
      ctrl_out_select = 1'b0;
    else
      ctrl_out_select = last_selected;

  assign ctrl_out_valid = selected_pkt_to_core_valid || pkt_done_valid;
  assign ctrl_out_dest  = ctrl_out_select ? selected_pkt_to_core_src : pkt_done_src;
  assign ctrl_out_desc  = ctrl_out_select ? {loopback_msg, pkt_to_core_with_port}
                                          : {send_out_msg, pkt_done_desc};
  assign selected_pkt_to_core_ready = ctrl_out_select  && ctrl_out_ready;
  assign loopback_ready             = !ctrl_out_select && ctrl_out_ready;

  // Latching the output to deal with the next stage valid/ready
  reg [CORE_ID_WIDTH-1:0] ctrl_out_dest_r;
  reg [CTRL_WIDTH-1:0]    ctrl_out_desc_r;
  reg                     ctrl_out_valid_r;
  wire                    ctrl_out_ready_r;

  always @ (posedge clk) begin
    if (ctrl_out_valid && (!ctrl_out_valid_r || ctrl_out_ready_r)) begin
      ctrl_out_desc_r  <= ctrl_out_desc;
      ctrl_out_dest_r  <= ctrl_out_dest;
      ctrl_out_valid_r <= 1'b1;
    end else if (ctrl_out_ready_r && !ctrl_out_valid) begin
      ctrl_out_valid_r <= 1'b0;
    end
    if (rst_r) begin
      ctrl_out_valid_r <= 1'b0;
      ctrl_out_desc_r  <= {CTRL_WIDTH{1'b0}};
      ctrl_out_dest_r  <= {CORE_ID_WIDTH{1'b0}};
    end
  end

  assign ctrl_out_ready = (!ctrl_out_valid_r) || ctrl_out_ready_r;

  // Arbiter between host cmd and scheduler messages
  assign ctrl_m_axis_tdata_n  = host_to_cores_valid_r ? {host_cores_cmd, host_cmd_wr_data_r}
                                                      : ctrl_out_desc_r;
  assign ctrl_m_axis_tvalid_n = host_to_cores_valid_r || ctrl_out_valid_r;
  assign ctrl_m_axis_tdest_n  = host_to_cores_valid_r ? host_cmd_dest : ctrl_out_dest_r;

  assign ctrl_out_ready_r   = (!host_to_cores_valid_r) && ctrl_m_axis_tready_n;

  /// *** ARBITRATION AND DESC ALLOCATION FOR RX DATA *** ///

  // Arbiter among ports for desc request. The destination core based on hash
  // is registered for next cycle.
  wire [INTERFACE_COUNT-1:0] selected_port;
  wire [INTERFACE_WIDTH-1:0] selected_port_enc;
  wire selected_port_v;

  // arbiter results are saved for the next cycle
  reg  [INTERFACE_COUNT-1:0] selected_port_r;
  reg  [INTERFACE_WIDTH-1:0] selected_port_enc_r;
  reg  selected_port_v_r;

  always @ (posedge clk)
    if (rst_r) begin
      selected_port_r     <= {INTERFACE_COUNT{1'b0}};
      selected_port_enc_r <= {INTERFACE_WIDTH{1'b0}};
      selected_port_v_r   <= 1'b0;
    end else begin
      selected_port_v_r   <= selected_port_v;
      selected_port_enc_r <= selected_port_enc;
      if (selected_port_v)
        selected_port_r   <= selected_port;
      else
        selected_port_r   <= {INTERFACE_COUNT{1'b0}};
    end

  // we have to wait one cycle for desc availability check, so the same core
  // should not be selected in consecutive cycles. An interface has data when
  // the corresponding hash fifo is valid. Also if next fifo is full there
  // should not be any requests.
  wire [INTERFACE_COUNT-1:0] desc_req;
  assign desc_req = rx_hash_valid_f & ~selected_port_r & hash_n_dest_in_ready;

  // Same cycle arbiter, with memory of last result
  simple_arbiter # (.PORTS(INTERFACE_COUNT),.TYPE("ROUND_ROBIN")) port_selector (
    .clk(clk),
    .rst(rst_r),

    .request(desc_req),
    .taken(1'b1), // We always use the results

    .grant(selected_port),
    .grant_valid(selected_port_v),
    .grant_encoded(selected_port_enc)
    );

  // selecting the destination core based on the selected interface and
  // corresponding masked hash
  always @ (posedge clk)
    if (rst_r)
      rx_dest_core <= {CORE_ID_WIDTH{1'b0}};
    else
      rx_dest_core <= masked_hash[selected_port_enc*CORE_ID_WIDTH +: CORE_ID_WIDTH];

  // Checking for slot availability, collision with intercore desc request and
  // if core is allowed to receive packets from interfaces
  assign rx_desc_avail = rx_desc_slot_v & income_cores;
  assign msg_desc_pop  = pkt_to_core_valid & arb_to_core_ready;

  wire [ID_TAG_WIDTH-1:0] rx_desc_data = {rx_dest_core, {(TAG_WIDTH-SLOT_WIDTH){1'b0}},
                                          rx_desc_slot[rx_dest_core*SLOT_WIDTH +: SLOT_WIDTH]};

  // MSB is to drop packet or not, followed by hash value and finally core desc
  // For now no intercore messages, so !rx_desc_avail means desc was not available
  assign hash_n_dest_in = {INTERFACE_COUNT{!rx_desc_avail[rx_dest_core],
                           rx_hash_f[selected_port_enc_r*32 +: 32], rx_desc_data}};

  // if a port is selected and desired core is not being used for intercore messaging,
  // pop the hash from the interface hash fifo, and push the hash
  // and full descriptor with core number into interface hash_n_desc fifo.
  // If core doesn't have descriptor available raise the drop bit and don't pop from
  // core's desc fifo
  always @ (*) begin
    rx_desc_pop      = 1'b0;
    rx_hash_ready_f  = {INTERFACE_COUNT{1'b0}};
    hash_n_dest_in_v = {INTERFACE_COUNT{1'b0}};

    if (selected_port_v_r && !msg_desc_pop[rx_dest_core])
      if (rx_desc_avail[rx_dest_core]) begin
        rx_desc_pop      = 1'b1;
        rx_hash_ready_f  = selected_port_r;
        hash_n_dest_in_v = selected_port_r;

      end else if (rx_almost_full_r[selected_port_enc_r]) begin
        rx_hash_ready_f  = selected_port_r;
        hash_n_dest_in_v = selected_port_r;
      end

  end

  /// *** STATUS FOR HOST READBACK *** ///
  reg [INTERFACE_COUNT*32-1:0] drop_count;

  always @ (posedge clk) begin
    if (rst_r)
      drop_count <= {INTERFACE_COUNT*ID_TAG_WIDTH{1'b0}};
    else if (selected_port_v_r && !msg_desc_pop[rx_dest_core] &&
             !rx_desc_avail[rx_dest_core] && rx_almost_full_r[selected_port_enc_r])
      drop_count[selected_port_enc_r*32 +: 32] <=
        drop_count[selected_port_enc_r*32 +: 32] + 1;
  end

  always @ (posedge clk)
    case (sched_cmd_addr)
      3'b000:  host_cmd_rd_data_n <= income_cores;
      3'b001:  host_cmd_rd_data_n <= enabled_cores;
      3'b010:  host_cmd_rd_data_n <= rx_desc_count[stat_read_core_r * SLOT_WIDTH +: SLOT_WIDTH];
      3'b101:  host_cmd_rd_data_n <= {{(32-INTERFACE_COUNT){1'b0}}, enabled_ints};
      3'b111:  host_cmd_rd_data_n <= drop_count[stat_read_interface_r*32 +: 32];
      default: host_cmd_rd_data_n <= 32'hFEFEFEFE;
    endcase

endmodule
