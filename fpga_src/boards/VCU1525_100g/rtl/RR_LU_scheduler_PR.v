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
  input  wire             host_cmd_valid,

  // ILA chain if used
  input  wire             trig_in,
  output wire             trig_in_ack,
  output wire             trig_out,
  input  wire             trig_out_ack
);

  parameter INTERFACE_COUNT = 3;
  parameter PORT_COUNT      = 5;
  parameter CORE_COUNT      = 16;
  parameter SLOT_COUNT      = 16;
  parameter DATA_WIDTH      = 512;
  parameter CTRL_WIDTH      = 32+4;
  parameter LOOPBACK_PORT   = 3;
  parameter LOOPBACK_COUNT  = 1;
  parameter ENABLE_ILA      = 0;
  parameter DATA_REG_TYPE   = 2;
  parameter CTRL_REG_TYPE   = 2;
  parameter CLUSTER_COUNT   = 4;

  parameter SLOT_WIDTH      = $clog2(SLOT_COUNT+1);
  parameter CORE_ID_WIDTH   = $clog2(CORE_COUNT);
  parameter INTERFACE_WIDTH = $clog2(INTERFACE_COUNT);
  parameter PORT_WIDTH      = $clog2(PORT_COUNT);
  parameter TAG_WIDTH       = (SLOT_WIDTH>5)? SLOT_WIDTH:5;
  parameter ID_TAG_WIDTH    = CORE_ID_WIDTH+TAG_WIDTH;
  parameter STRB_WIDTH      = DATA_WIDTH/8;


  // Register inputs and outputs
  wire [INTERFACE_COUNT*DATA_WIDTH-1:0]   data_m_axis_tdata_n;
  wire [INTERFACE_COUNT*STRB_WIDTH-1:0]   data_m_axis_tkeep_n;
  wire [INTERFACE_COUNT*ID_TAG_WIDTH-1:0] data_m_axis_tdest_n;
  wire [INTERFACE_COUNT*PORT_WIDTH-1:0]   data_m_axis_tuser_n;
  wire [INTERFACE_COUNT-1:0]              data_m_axis_tvalid_n;
  wire [INTERFACE_COUNT-1:0]              data_m_axis_tready_n;
  wire [INTERFACE_COUNT-1:0]              data_m_axis_tlast_n;

  wire [INTERFACE_COUNT*DATA_WIDTH-1:0]   rx_axis_tdata_r;
  wire [INTERFACE_COUNT*STRB_WIDTH-1:0]   rx_axis_tkeep_r;
  wire [INTERFACE_COUNT-1:0]              rx_axis_tvalid_r;
  wire [INTERFACE_COUNT-1:0]              rx_axis_tready_r;
  wire [INTERFACE_COUNT-1:0]              rx_axis_tlast_r;

  wire [CTRL_WIDTH-1:0]    ctrl_s_axis_tdata_r;
  wire                     ctrl_s_axis_tvalid_r;
  wire                     ctrl_s_axis_tready_r;
  wire [CORE_ID_WIDTH-1:0] ctrl_s_axis_tuser_r;

  wire [CTRL_WIDTH-1:0]    ctrl_m_axis_tdata_n;
  wire                     ctrl_m_axis_tvalid_n;
  wire                     ctrl_m_axis_tready_n;
  wire [CORE_ID_WIDTH-1:0] ctrl_m_axis_tdest_n;

  wire rst_r;
  sync_reset sync_rst_inst (
    .clk(clk),
    .rst(rst),
    .out(rst_r)
  );

  genvar q;
  generate
    for (q=0; q<INTERFACE_COUNT; q=q+1) begin: int_regs

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
        .m_axis_tready(rx_axis_tready_r[q]),
        .m_axis_tlast (rx_axis_tlast_r[q]),
        .m_axis_tid   (),
        .m_axis_tdest (),
        .m_axis_tuser ()
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
  reg [INTERFACE_COUNT-1:0] release_desc;
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
        3'b110: begin
          release_desc  <= host_cmd_wr_data_r[INTERFACE_COUNT-1:0];
        end

        default: begin //for one-cycle signals
          release_desc <= {INTERFACE_COUNT{1'b0}};
          slots_flush  <= {CORE_COUNT{1'b0}};
        end
      endcase
    else begin // for one-cycle signals
          release_desc <= {INTERFACE_COUNT{1'b0}};
          slots_flush  <= {CORE_COUNT{1'b0}};
    end

    if (rst_r) begin
      host_to_cores_valid_r <= 1'b0;
      host_to_sched_valid_r <= 1'b0;
      income_cores          <= {CORE_COUNT{1'b0}};
      enabled_cores         <= {CORE_COUNT{1'b0}};
      enabled_ints          <= {INTERFACE_COUNT{1'b0}};
      release_desc          <= {INTERFACE_COUNT{1'b0}};
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
  wire [CORE_ID_WIDTH-1:0] selected_rx_core;
  wire [CORE_COUNT-1:0]    rx_desc_slot_pop;

  reg  [CORE_COUNT-1:0] enq_slot_v;
  reg  [CORE_COUNT-1:0] init_slot_v;
  reg  [SLOT_WIDTH-1:0] input_slot;

  always @ (posedge clk)
    input_slot <= ctrl_s_axis_tdata_r[16 +: SLOT_WIDTH];

  wire rx_desc_pop;

  wire [CORE_COUNT-1:0] core_slot_err;
  reg  slot_insert_err;

  always @ (posedge clk) begin
    slot_insert_err <= | core_slot_err;
  end

  genvar i;
  generate
    for (i=0;i<CORE_COUNT;i=i+1) begin
      assign rx_desc_slot_pop[i]    = (rx_desc_pop && (selected_rx_core==i)) ||
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

  // Selecting the core with most available slots
  // Since slots start from 1, SLOT WIDTH is already 1 bit extra
  localparam CLUSTER_CORES      = CORE_COUNT/CLUSTER_COUNT;
  localparam CLUSTER_WIDTH      = $clog2(CLUSTER_COUNT);
  localparam CLUSTER_CORE_WIDTH = $clog2(CLUSTER_CORES);

  wire [CLUSTER_COUNT-1:0] cluster_max_valid;
  wire [CLUSTER_CORE_WIDTH-1:0] selected_cluster_core [0:CLUSTER_COUNT-1];
  wire [CORE_COUNT-1:0] masks = income_cores & ~(pkt_to_core_valid & arb_to_core_ready);

  genvar k;
  generate
    for (k=0; k<CLUSTER_COUNT; k=k+1) begin
      max_finder_tree # (
        .PORT_COUNT(CLUSTER_CORES),
        .DATA_WIDTH(SLOT_WIDTH)
      ) core_selector (
        .values(rx_desc_count[k*CLUSTER_CORES*SLOT_WIDTH +: CLUSTER_CORES*SLOT_WIDTH]),
        .valids(masks[k*CLUSTER_CORES +: CLUSTER_CORES]),
        .max_val(),
        .max_ptr(selected_cluster_core[k]),
        .max_valid(cluster_max_valid[k])
      );
    end
  endgenerate

  wire max_valid;
  wire selected_port_v;

  generate
      if (CLUSTER_COUNT==1)
          assign selected_rx_core = {selected_cluster_core[0]};
      else begin
          wire [CLUSTER_WIDTH-1:0] selected_cluster;
          simple_arbiter # (
              .PORTS(CLUSTER_COUNT),
              .TYPE("ROUND_ROBIN"),
              .LSB_PRIORITY("HIGH")
          ) max_slot_arbiter (
              .clk(clk),
              .rst(rst_r),

              .request(cluster_max_valid),
              .taken(selected_port_v), // equal to rx_desc_pop

              .grant(),
              .grant_valid (max_valid),
              .grant_encoded(selected_cluster)
          );

          assign selected_rx_core = {selected_cluster, selected_cluster_core[selected_cluster]};
      end
  endgenerate

  // Adding tdest and tuser to input data from eth, dest based on
  // rx_desc_fifo and stamp the incoming port
  wire [INTERFACE_COUNT-1:0] selected_port;
  wire [INTERFACE_WIDTH-1:0] selected_port_enc;

  reg  [INTERFACE_COUNT*ID_TAG_WIDTH-1:0] dest;
  reg  [INTERFACE_COUNT*ID_TAG_WIDTH-1:0] dest_r;
  reg  [INTERFACE_COUNT*ID_TAG_WIDTH-1:0] dest_rr;

  assign rx_desc_pop                           = selected_port_v && max_valid;
  wire [INTERFACE_COUNT-1:0] port_desc_avail   = {INTERFACE_COUNT{rx_desc_pop}} & selected_port;
  wire [INTERFACE_COUNT-1:0] port_valid        = rx_axis_tvalid_r & rx_axis_tready_r;
  wire [INTERFACE_COUNT-1:0] sending_last_word = port_valid & rx_axis_tlast_r;

  // State machine per port
  reg [1:0] port_state [0:INTERFACE_COUNT-1];
  localparam STALL = 2'b00; // Don't accept until getting a desc
  localparam FIRST = 2'b01; // Ready to get new packet
  localparam WAIT  = 2'b10; // Accept while waiting for new desc
  localparam MID   = 2'b11; // Desc ready, wait for end of the packet

  integer n;
  always @ (posedge clk)
      for (n=0; n<INTERFACE_COUNT; n=n+1)
          if (rst_r) begin
              port_state[n]     <= STALL;
          end else begin
              case (port_state[n])
                  STALL: if (port_desc_avail[n])
                             port_state[n] <= FIRST;
                  FIRST: if (sending_last_word[n])
                             port_state[n] <= STALL;
                         else if (port_valid[n])
                             port_state[n] <= WAIT;
                         // 2 previous ifs already used the desc
                         else if (release_desc[n])
                             port_state[n] <= STALL;
                         // Since the specific core is disabled,
                         // it cannot get desc from the same core
                  WAIT:  if (port_desc_avail[n] && sending_last_word[n])
                             port_state[n] <= FIRST;
                         else if (port_desc_avail[n])
                             port_state[n] <= MID;
                         else if (sending_last_word[n])
                             port_state[n] <= STALL;
                  MID:   if (sending_last_word[n]) begin
                             if (release_desc[n])
                                 port_state[n] <= STALL;
                             else
                                 port_state[n] <= FIRST;
                         // Don't use the reserved desc
                         end else if (release_desc[n]) begin
                                 port_state[n] <= WAIT;
                         end
              endcase
              // When a packet starts latch the tdest
              if ((port_state[n] == FIRST) && port_valid[n])
                  dest_rr[n*ID_TAG_WIDTH +: ID_TAG_WIDTH] <= dest_r[n*ID_TAG_WIDTH +: ID_TAG_WIDTH];
          end

  wire [1:0] state_0 = port_state[0];
  wire [1:0] state_1 = port_state[1];
  wire [1:0] state_2 = port_state[2];

  // Desc request and port ready
  integer p;
  reg [INTERFACE_COUNT-1:0] desc_req;
  reg [INTERFACE_COUNT-1:0] port_not_stall;
  always @ (*)
      for (p=0; p<INTERFACE_COUNT; p=p+1) begin
          // When a packet starts we ask for new desc, or if we are in stall or wait.
          // If request in FIRST is responded during WAIT it would be cancedlled by !selected_port
          desc_req[p] = !(selected_port[p]) && ((port_state[p]==STALL) || (port_state[p]==WAIT) ||
                          ((port_state[p]==FIRST) && port_valid[p]));
          port_not_stall[p] = (port_state[p]!=STALL) && enabled_ints[p];
          dest[p*ID_TAG_WIDTH +: ID_TAG_WIDTH] = (port_state[p]==FIRST) ?
              dest_r[p*ID_TAG_WIDTH +: ID_TAG_WIDTH] : dest_rr[p*ID_TAG_WIDTH +: ID_TAG_WIDTH];
      end

  // arbiter among ports for desc request
  arbiter # (
    .PORTS(INTERFACE_COUNT),
    .TYPE("ROUND_ROBIN"),
    .LSB_PRIORITY("HIGH")
  ) port_selector (
    .clk(clk),
    .rst(rst_r),

    .request(desc_req),
    .acknowledge({INTERFACE_COUNT{1'b0}}),

    .grant(selected_port),
    .grant_valid(selected_port_v),
    .grant_encoded(selected_port_enc)
  );

  // Load the new desc
  wire [ID_TAG_WIDTH-1:0] rx_desc_data = {selected_rx_core, {(TAG_WIDTH-SLOT_WIDTH){1'b0}},
                                          rx_desc_slot[selected_rx_core*SLOT_WIDTH +: SLOT_WIDTH]};

  always @ (posedge clk)
    if (rx_desc_pop)
      dest_r[selected_port_enc*ID_TAG_WIDTH +: ID_TAG_WIDTH] <= rx_desc_data;

  always @ (posedge clk)
    case (sched_cmd_addr)
      3'b000:  host_cmd_rd_data_n <= income_cores;
      3'b001:  host_cmd_rd_data_n <= enabled_cores;
      3'b010:  host_cmd_rd_data_n <= rx_desc_count[stat_read_core_r * SLOT_WIDTH +: SLOT_WIDTH];
      3'b100:  host_cmd_rd_data_n <= {14'd0, port_state[stat_read_interface_r], {(16-ID_TAG_WIDTH){1'b0}},
                                     dest_r[stat_read_interface_r * ID_TAG_WIDTH +: ID_TAG_WIDTH]};
      3'b101:  host_cmd_rd_data_n <= {{(32-INTERFACE_COUNT){1'b0}}, enabled_ints};
      default: host_cmd_rd_data_n <= 32'hFEFEFEFE;
    endcase

  genvar j;
  generate
    for (j=0; j<INTERFACE_COUNT;j=j+1)
      assign data_m_axis_tuser_n[j*PORT_WIDTH +: PORT_WIDTH] = j;
  endgenerate

  assign data_m_axis_tdata_n  = rx_axis_tdata_r;
  assign data_m_axis_tkeep_n  = rx_axis_tkeep_r;
  assign data_m_axis_tvalid_n = rx_axis_tvalid_r & port_not_stall;
  assign data_m_axis_tlast_n  = rx_axis_tlast_r;
  assign data_m_axis_tdest_n  = dest;
  assign rx_axis_tready_r     = data_m_axis_tready_n & port_not_stall;

if (ENABLE_ILA) begin
  wire trig_out_1, trig_out_2;
  wire ack_1, ack_2;
  reg [CORE_COUNT*SLOT_WIDTH-1:0] rx_desc_count_r;
  reg [INTERFACE_COUNT-1:0] desc_req_r;
  reg max_valid_r, rx_desc_pop_r;
  reg [ID_TAG_WIDTH-1:0] rx_desc_data_r;

  always @ (posedge clk) begin
    rx_desc_count_r <= rx_desc_count;
    desc_req_r      <= desc_req;
    max_valid_r     <= max_valid;
    rx_desc_pop_r   <= rx_desc_pop;
    rx_desc_data_r  <= rx_desc_data;
  end

  reg [15:0] rx_count_0, rx_count_1, tx_count_0, tx_count_1;
  always @ (posedge clk)
    if (rst_r) begin
        rx_count_0 <= 16'd0;
        rx_count_1 <= 16'd0;
        tx_count_0 <= 16'd0;
        tx_count_1 <= 16'd0;
    end else begin
      if (rx_axis_tlast_r[0] && rx_axis_tvalid_r[0])
        rx_count_0 <= 16'd0;
      else if (rx_axis_tvalid_r[0])
        rx_count_0 <= rx_count_0 + 16'd1;

      if (rx_axis_tlast_r[1] && rx_axis_tvalid_r[1])
        rx_count_1 <= 16'd0;
      else if (rx_axis_tvalid_r[1])
        rx_count_1 <= rx_count_1 + 16'd1;

      if (tx_axis_tlast[0] && tx_axis_tvalid[0])
        tx_count_0 <= 16'd0;
      else if (tx_axis_tvalid[0])
        tx_count_0 <= tx_count_0 + 16'd1;

      if (tx_axis_tlast[1] && tx_axis_tvalid[1])
        tx_count_1 <= 16'd0;
      else if (tx_axis_tvalid[1])
        tx_count_1 <= tx_count_1 + 16'd1;
    end

  ila_4x64 debugger1 (
    .clk    (clk),

    .trig_out(trig_out),
    .trig_out_ack(trig_out_ack),
    .trig_in (trig_in),
    .trig_in_ack(trig_in_ack),

    .probe0 ({
       sending_last_word,
       data_m_axis_tdest_n,
       rst_r,
       data_m_axis_tuser_n,
       ctrl_m_axis_tdest_n,
       ctrl_s_axis_tuser_r,
       ctrl_m_axis_tvalid_n,
       ctrl_m_axis_tready_n,
       ctrl_s_axis_tvalid_r,
       ctrl_s_axis_tready_r,
       slot_insert_err,
       msg_type,
       rx_axis_tvalid_r,
       max_valid_r,
       rx_desc_pop_r,
       desc_req_r,
       // rx_axis_tready_r,
       // rx_axis_tkeep_r,
       rx_axis_tlast_r,
       rx_desc_data_r
     }),

    .probe1 ({
       ctrl_m_axis_tdata_n[31:0],
       ctrl_s_axis_tdata_r[31:0]}),

    .probe2 (rx_desc_count_r),

    .probe3 ({rx_desc_slot_v, rx_desc_slot_pop,
              enabled_cores, income_cores})
  );

end else begin
  assign trig_in_ack = 1'b0;
  assign trig_out    = 1'b0;
end

endmodule
