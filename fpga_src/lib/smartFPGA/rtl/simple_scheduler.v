module simple_scheduler # (
  parameter INTERFACE_COUNT = 2,
  parameter PORT_COUNT      = 4,
  parameter CORE_COUNT      = 16,
  parameter SLOT_COUNT      = 8,
  parameter DATA_WIDTH      = 64,
  parameter CTRL_WIDTH      = 32+4,
  parameter LOOPBACK_PORT   = 2,
  parameter LOOPBACK_COUNT  = 2,
  parameter ENABLE_ILA      = 0,

  parameter SLOT_WIDTH      = $clog2(SLOT_COUNT+1),
  parameter CORE_ID_WIDTH   = $clog2(CORE_COUNT),
  parameter INTERFACE_WIDTH = $clog2(INTERFACE_COUNT),
  parameter PORT_WIDTH      = $clog2(PORT_COUNT),
  parameter TAG_WIDTH       = (SLOT_WIDTH>5)? SLOT_WIDTH:5,
  parameter ID_TAG_WIDTH    = CORE_ID_WIDTH+TAG_WIDTH,
  parameter STRB_WIDTH      = DATA_WIDTH/8,
  parameter CLUSTER_COUNT   = CORE_COUNT,
  parameter LVL2_SW_PORTS   = CORE_COUNT/CLUSTER_COUNT,
  parameter LVL1_BITS       = $clog2(CLUSTER_COUNT)
) (
  input                                           clk,
  input                                           rst,

  // Data line to/from Eth interfaces
  input  wire [INTERFACE_COUNT*DATA_WIDTH-1:0]    rx_axis_tdata,
  input  wire [INTERFACE_COUNT*STRB_WIDTH-1:0]    rx_axis_tkeep,
  input  wire [INTERFACE_COUNT-1:0]               rx_axis_tvalid, 
  output wire [INTERFACE_COUNT-1:0]               rx_axis_tready, 
  input  wire [INTERFACE_COUNT-1:0]               rx_axis_tlast,
  
  output wire [INTERFACE_COUNT*DATA_WIDTH-1:0]    tx_axis_tdata,
  output wire [INTERFACE_COUNT*STRB_WIDTH-1:0]    tx_axis_tkeep,
  output wire [INTERFACE_COUNT-1:0]               tx_axis_tvalid, 
  input  wire [INTERFACE_COUNT-1:0]               tx_axis_tready, 
  output wire [INTERFACE_COUNT-1:0]               tx_axis_tlast,
  
  // DATA lines to/from cores
  output wire [INTERFACE_COUNT*DATA_WIDTH-1:0]    data_m_axis_tdata,
  output wire [INTERFACE_COUNT*STRB_WIDTH-1:0]    data_m_axis_tkeep,
  output wire [INTERFACE_COUNT*ID_TAG_WIDTH-1:0]  data_m_axis_tdest,
  output wire [INTERFACE_COUNT*PORT_WIDTH-1:0]    data_m_axis_tuser,
  output wire [INTERFACE_COUNT-1:0]               data_m_axis_tvalid,
  input  wire [INTERFACE_COUNT-1:0]               data_m_axis_tready,
  output wire [INTERFACE_COUNT-1:0]               data_m_axis_tlast,
  
  input  wire [INTERFACE_COUNT*DATA_WIDTH-1:0]    data_s_axis_tdata,
  input  wire [INTERFACE_COUNT*STRB_WIDTH-1:0]    data_s_axis_tkeep,
  input  wire [INTERFACE_COUNT*ID_TAG_WIDTH-1:0]  data_s_axis_tuser,
  input  wire [INTERFACE_COUNT-1:0]               data_s_axis_tvalid, 
  output wire [INTERFACE_COUNT-1:0]               data_s_axis_tready, 
  input  wire [INTERFACE_COUNT-1:0]               data_s_axis_tlast,
      
  // Control lines to/from cores
  output wire [CTRL_WIDTH-1:0]               ctrl_m_axis_tdata,
  output wire                                ctrl_m_axis_tvalid,
  input  wire                                ctrl_m_axis_tready,
  output wire [CORE_ID_WIDTH-1:0]            ctrl_m_axis_tdest,

  input  wire [CTRL_WIDTH-1:0]               ctrl_s_axis_tdata,
  input  wire                                ctrl_s_axis_tvalid,
  output wire                                ctrl_s_axis_tready,
  input  wire [CORE_ID_WIDTH-1:0]            ctrl_s_axis_tuser,

  // Cores reset
  input  wire [3:0]                          host_cmd,
  input  wire [CORE_ID_WIDTH-1:0]            host_cmd_dest,
  input  wire [31:0]                         host_cmd_data,
  input  wire                                host_cmd_valid,
  output wire                                host_cmd_ready,

  input  wire [CORE_COUNT-1:0]               income_cores, 
  input  wire [CORE_COUNT-1:0]               cores_to_be_reset,

  input  wire [CORE_ID_WIDTH-1:0]            stat_read_core,
  output reg  [SLOT_WIDTH-1:0]               slot_count,
  input  wire [INTERFACE_WIDTH-1:0]          stat_read_interface,
  output reg  [ID_TAG_WIDTH-1:0]             loaded_desc,

  input  wire                                trig_in,
  output wire                                trig_in_ack,
  output wire                                trig_out,
  input  wire                                trig_out_ack
);

  parameter MSG_TYPE_WIDTH = 4;
  parameter DESC_WIDTH     = CTRL_WIDTH-MSG_TYPE_WIDTH;

  // Separate incoming ctrl messages
  wire [MSG_TYPE_WIDTH-1:0] msg_type = 
                ctrl_s_axis_tdata[CTRL_WIDTH-1:CTRL_WIDTH-MSG_TYPE_WIDTH];

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
    .rst(rst),
    .clear(1'b0),
  
    .din_valid(ctrl_s_axis_tvalid && (msg_type==1)),
    .din({ctrl_s_axis_tuser,ctrl_s_axis_tdata[DESC_WIDTH-1:0]}),
    .din_ready(pkt_done_ready),
   
    .dout_valid(pkt_done_valid),
    .dout({pkt_done_src,pkt_done_desc}),
    .dout_ready(loopback_ready)
  );

  genvar m;
  generate 
    for (m=0;m<CORE_COUNT;m=m+1) begin
      wire [CORE_ID_WIDTH-1:0] dest_core = ctrl_s_axis_tdata[24+:CORE_ID_WIDTH];
      simple_fifo # (
        .ADDR_WIDTH($clog2(SLOT_COUNT)),
        .DATA_WIDTH(CORE_ID_WIDTH+DESC_WIDTH)
      ) pkt_to_core_fifo (
        .clk(clk),
        .rst(rst),
        .clear(1'b0),
      
        .din_valid(ctrl_s_axis_tvalid && (msg_type==2) && (dest_core==m)),
        .din({ctrl_s_axis_tuser, ctrl_s_axis_tdata[DESC_WIDTH-1:0]}), 
        .din_ready(pkt_to_core_ready[m]),
       
        .dout_valid(pkt_to_core_valid[m]),
        .dout(pkt_to_core_req[m*(DESC_WIDTH+CORE_ID_WIDTH) +: 
                                (DESC_WIDTH+CORE_ID_WIDTH)]),
        .dout_ready(arb_to_core_ready[m] && rx_desc_slot_v[m] && !cores_to_be_reset[m])
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
    .rst(rst),
  
    .s_axis_tdata(pkt_to_core_req), 
    .s_axis_tkeep(),
    .s_axis_tvalid(pkt_to_core_valid & rx_desc_slot_v & ~cores_to_be_reset),
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
   
  assign ctrl_s_axis_tready = ((msg_type==0)   ||   (msg_type==3)) ||
                              (pkt_done_ready    && (msg_type==1)) || 
                              (pkt_to_core_ready && (msg_type==2)) ;
  
  // Slot descriptor fifos, addressing msg type 0&3 requests
  wire [CORE_COUNT*SLOT_WIDTH-1:0] rx_desc_count;
  wire [CORE_ID_WIDTH-1:0] selected_desc;
  wire [CORE_COUNT-1:0]    rx_desc_slot_pop;
  
  reg  [CORE_COUNT-1:0] enq_slot_v;
  reg  [CORE_COUNT-1:0] init_slot_v;
  reg  [SLOT_WIDTH-1:0] input_slot;
  
  always @ (posedge clk)
    input_slot <= ctrl_s_axis_tdata[16 +: SLOT_WIDTH];

  wire rx_desc_pop; 
  wire max_valid;

  wire [CORE_COUNT-1:0] core_slot_err;
  reg  slot_insert_err;

  always @ (posedge clk) begin
    slot_insert_err <= | core_slot_err;
  end

  genvar i;
  generate 
    for (i=0;i<CORE_COUNT;i=i+1) begin
      assign rx_desc_slot_pop[i]    = (rx_desc_pop && (selected_desc==i)) || 
                                      (pkt_to_core_valid[i] && arb_to_core_ready[i] && (~cores_to_be_reset[i]));
      // Register valid for better timing closure
      always @ (posedge clk)
        if (rst) begin
          enq_slot_v[i]  <= 1'b0;
          init_slot_v[i] <= 1'b0;
        end else begin
          enq_slot_v[i]  <= ctrl_s_axis_tvalid && (msg_type==0) && (ctrl_s_axis_tuser==i);
          init_slot_v[i] <= ctrl_s_axis_tvalid && (msg_type==3) && (ctrl_s_axis_tuser==i);
        end

      slot_keeper # (
        .SLOT_COUNT(SLOT_COUNT), 
        .SLOT_WIDTH(SLOT_WIDTH)
      ) rx_desc_keeper (
        .clk(clk),
        .rst(rst),

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
  
  always @ (posedge clk) begin
    slot_count  <= rx_desc_count[stat_read_core * SLOT_WIDTH +: SLOT_WIDTH];
    loaded_desc <= dest_r[stat_read_interface * ID_TAG_WIDTH +: ID_TAG_WIDTH];
  end

  // Assing looback port
  wire [CORE_ID_WIDTH-1:0] loopback_port;

  if (LOOPBACK_COUNT==1)
    assign loopback_port = LOOPBACK_PORT;
  else if (LOOPBACK_COUNT==2) begin

    reg loopback_port_select_r;

    always @ (posedge clk)
      if (rst)
        loopback_port_select_r <= 1'b0;
      else if (selected_pkt_to_core_valid && selected_pkt_to_core_ready)
        loopback_port_select_r <= ~loopback_port_select_r;

    assign loopback_port = loopback_port_select_r ? (LOOPBACK_PORT+1) : LOOPBACK_PORT;

  end else begin

    reg [$clog2(LOOPBACK_COUNT)-1:0] loopback_port_select_r;

    always @ (posedge clk)
      if (rst)
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
    if (rst) 
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
    if (rst) begin
      ctrl_out_valid_r <= 1'b0;
      ctrl_out_desc_r  <= {CTRL_WIDTH{1'b0}};
      ctrl_out_dest_r  <= {CORE_ID_WIDTH{1'b0}};
    end
  end 

  assign ctrl_out_ready = (!ctrl_out_valid_r) || ctrl_out_ready_r; 

  // Arbiter between host cmd and scheduler messages
  assign ctrl_m_axis_tdata  = host_cmd_valid ? {host_cmd, host_cmd_data} 
                                             : ctrl_out_desc_r;
  assign ctrl_m_axis_tvalid = host_cmd_valid || ctrl_out_valid_r;
  assign ctrl_m_axis_tdest  = host_cmd_valid ? host_cmd_dest : ctrl_out_dest_r;

  assign ctrl_out_ready_r   = (!host_cmd_valid) && ctrl_m_axis_tready;
  assign host_cmd_ready     = 1'b1;

  // Selecting the core with most available slots
  // Since slots start from 1, SLOT WIDTH is already 1 bit extra
  reg  [CORE_COUNT*SLOT_WIDTH-1:0] reordered_rx_desc_count;
  wire [CORE_ID_WIDTH-1:0]         reordered_selected_desc;
  reg  [CORE_COUNT-1:0]            reordered_masks;
  integer k,l;
  always @ (*)
    for (k=0; k<LVL2_SW_PORTS; k=k+1)
      for (l=0; l<CLUSTER_COUNT; l=l+1) begin
        reordered_rx_desc_count[(k*CLUSTER_COUNT+l)*SLOT_WIDTH +: SLOT_WIDTH] = 
                  rx_desc_count[(l*LVL2_SW_PORTS+k)*SLOT_WIDTH +: SLOT_WIDTH];
        // Priority to inter core messages, and only income_cores are available for selection
        // cores_to_be_reset would remove the core from income_cores
        reordered_masks [k*CLUSTER_COUNT+l] = income_cores[l*LVL2_SW_PORTS+k] &&
                                             !(pkt_to_core_valid[l*LVL2_SW_PORTS+k] &&
                                               arb_to_core_ready[l*LVL2_SW_PORTS+k]);
      end

  max_finder_tree # (
    .PORT_COUNT(CORE_COUNT),
    .DATA_WIDTH(SLOT_WIDTH)
  ) core_selector ( 
    .values(reordered_rx_desc_count),
    .valids(reordered_masks),
    .max_val(),
    .max_ptr(reordered_selected_desc),
    .max_valid(max_valid)
  );

  if (LVL2_SW_PORTS==1)
    assign selected_desc = reordered_selected_desc;
  else 
    assign selected_desc = {reordered_selected_desc[LVL1_BITS-1:0],
                           reordered_selected_desc[CORE_ID_WIDTH-1:LVL1_BITS]};

  
  // Adding tdest and tuser to input data from eth, dest based on 
  // rx_desc_fifo and stamp the incoming port
  wire [INTERFACE_COUNT-1:0] selected_port;
  wire [INTERFACE_WIDTH-1:0] selected_port_enc;
  wire selected_port_v;

  reg  [INTERFACE_COUNT*ID_TAG_WIDTH-1:0] dest;
  reg  [INTERFACE_COUNT*ID_TAG_WIDTH-1:0] dest_r;
  reg  [INTERFACE_COUNT*ID_TAG_WIDTH-1:0] dest_rr;

  assign rx_desc_pop                           = selected_port_v && max_valid;
  wire [INTERFACE_COUNT-1:0] port_desc_avail   = {INTERFACE_COUNT{rx_desc_pop}} & selected_port;
  wire [INTERFACE_COUNT-1:0] port_valid        = rx_axis_tvalid & rx_axis_tready;
  wire [INTERFACE_COUNT-1:0] sending_last_word = port_valid & rx_axis_tlast;
  
  // State machine per port
  reg [1:0] port_state [0:INTERFACE_COUNT-1];
  localparam STALL = 2'b00; // Don't accept until getting a desc
  localparam FIRST = 2'b01; // Ready to get new packet
  localparam WAIT  = 2'b10; // Accept while waiting for new desc
  localparam MID   = 2'b11; // Desc ready, wait for end of the packet

  integer n;
  always @ (posedge clk)
      for (n=0; n<INTERFACE_COUNT; n=n+1) 
          if (rst) begin
              port_state[n] <= STALL;
          end else begin
              case (port_state[n])
                  STALL: if (port_desc_avail[n]) 
                            port_state[n] <= FIRST;
                  FIRST: if (sending_last_word[n]) 
                            port_state[n] <= STALL; 
                         else if (port_valid[n]) 
                            port_state[n] <= WAIT;
                  WAIT:  if (port_desc_avail[n] && sending_last_word[n]) 
                            port_state[n] <= FIRST;
                         else if (port_desc_avail[n]) 
                            port_state[n] <= MID;
                         else if (sending_last_word[n]) 
                            port_state[n] <= STALL;
                  MID:   if (sending_last_word[n]) 
                            port_state[n] <= FIRST;
              endcase
              // When a packet starts latch the tdest
              if ((port_state[n] == FIRST) && port_valid[n])
                  dest_rr[n*ID_TAG_WIDTH +: ID_TAG_WIDTH] <= dest_r[n*ID_TAG_WIDTH +: ID_TAG_WIDTH];
          end

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
          port_not_stall[p] = (port_state[p]!=STALL);
          dest[p*ID_TAG_WIDTH +: ID_TAG_WIDTH] = (port_state[p]==FIRST) ?
              dest_r[p*ID_TAG_WIDTH +: ID_TAG_WIDTH] : dest_rr[p*ID_TAG_WIDTH +: ID_TAG_WIDTH];
      end
  
  // arbiter among ports for desc request
  arbiter # (.PORTS(INTERFACE_COUNT),.TYPE("ROUND_ROBIN")) port_selector (
    .clk(clk),
    .rst(rst),
    
    .request(desc_req),
    .acknowledge({INTERFACE_COUNT{1'b0}}),
    
    .grant(selected_port),
    .grant_valid(selected_port_v),
    .grant_encoded(selected_port_enc)
    );

  // Load the new desc
  wire [ID_TAG_WIDTH-1:0] rx_desc_data = {selected_desc, {(TAG_WIDTH-SLOT_WIDTH){1'b0}}, 
                                          rx_desc_slot[selected_desc*SLOT_WIDTH +: SLOT_WIDTH]};
  
  always @ (posedge clk) 
    if (rx_desc_pop) 
      dest_r[selected_port_enc*ID_TAG_WIDTH +: ID_TAG_WIDTH] <= rx_desc_data;
 
  genvar j;
  generate
    for (j=0; j<INTERFACE_COUNT;j=j+1)
      assign data_m_axis_tuser[j*PORT_WIDTH +: PORT_WIDTH] = j;
  endgenerate

  assign data_m_axis_tdata  = rx_axis_tdata;
  assign data_m_axis_tkeep  = rx_axis_tkeep;
  assign data_m_axis_tvalid = rx_axis_tvalid & port_not_stall; 
  assign data_m_axis_tlast  = rx_axis_tlast;
  assign data_m_axis_tdest  = dest;
  assign rx_axis_tready     = data_m_axis_tready & port_not_stall;
  
  assign tx_axis_tdata      = data_s_axis_tdata;
  assign tx_axis_tkeep      = data_s_axis_tkeep;
  assign tx_axis_tvalid     = data_s_axis_tvalid;  
  assign tx_axis_tlast      = data_s_axis_tlast;
  assign data_s_axis_tready = tx_axis_tready;

if (ENABLE_ILA) begin  
  wire trig_out_1, trig_out_2;
  wire ack_1, ack_2;
  reg [CORE_COUNT*SLOT_WIDTH-1:0] rx_desc_count_r;
  reg [INTERFACE_COUNT-1:0] desc_req_r;
  reg max_valid_r, rx_desc_pop_r;
  reg [ID_TAG_WIDTH-1:0] rx_desc_data_r; 
  reg [1:0] port0_state_r, port1_state_r, port2_state_r;
  reg [1:0] selected_port_enc_r;
  always @ (posedge clk) begin
    rx_desc_count_r     <= rx_desc_count;
    desc_req_r          <= desc_req;
    max_valid_r         <= max_valid;
    rx_desc_pop_r       <= rx_desc_pop;
    rx_desc_data_r      <= rx_desc_data;
    port0_state_r       <= port_state[0];
    port1_state_r       <= port_state[1];
    port2_state_r       <= port_state[2];
    selected_port_enc_r <= selected_port_enc;
  end

  ila_2x64 debugger1 (
    .clk    (clk),
 
    .trig_out(trig_out),
    .trig_out_ack(trig_out_ack),
    .trig_in (trig_in),
    .trig_in_ack(trig_in_ack),
 
    .probe0 ({
       data_m_axis_tdest[17:0],
       ctrl_m_axis_tdest,
       ctrl_s_axis_tuser,
       ctrl_m_axis_tvalid,
       ctrl_m_axis_tready,
       ctrl_s_axis_tvalid,
       ctrl_s_axis_tready,
       rst,
       slot_insert_err,
       msg_type,
       rx_axis_tvalid[1:0], 
       rx_axis_tlast[1:0],
       rx_axis_tvalid[1:0],
       max_valid_r,
       rx_desc_pop_r,
       desc_req_r,
       rx_desc_data_r,
       port2_state_r,
       port1_state_r,
       port0_state_r,
       selected_port_enc_r
     }),
    
    .probe1 ({
       ctrl_m_axis_tdata[31:0],
       ctrl_s_axis_tdata[31:0]})
  
    // .probe2 (rx_desc_count_r),

    // .probe3 ({rx_desc_slot_v, rx_desc_slot_pop,
    //           cores_to_be_reset, income_cores})
  );

end else begin
  assign trig_in_ack = 1'b0;
  assign trig_out    = 1'b0;
end

endmodule
