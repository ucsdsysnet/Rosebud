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
  parameter LVL1_SW_PORTS   = CORE_COUNT,
  parameter LVL2_SW_PORTS   = CORE_COUNT/LVL1_SW_PORTS,
  parameter LVL1_BITS       = $clog2(LVL1_SW_PORTS)
) (
  input                                     clk,
  input                                     rst,

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
  input  wire [INTERFACE_COUNT*PORT_WIDTH-1:0]    data_s_axis_tdest,
  input  wire [INTERFACE_COUNT*ID_TAG_WIDTH-1:0]  data_s_axis_tuser,
  input  wire [INTERFACE_COUNT-1:0]               data_s_axis_tvalid, 
  output wire [INTERFACE_COUNT-1:0]               data_s_axis_tready, 
  input  wire [INTERFACE_COUNT-1:0]               data_s_axis_tlast,
      
  // Control lines to/from cores
  output wire [CTRL_WIDTH-1:0]               ctrl_m_axis_tdata,
  output wire                                ctrl_m_axis_tvalid,
  input  wire                                ctrl_m_axis_tready,
  output wire                                ctrl_m_axis_tlast,
  output wire [CORE_ID_WIDTH-1:0]            ctrl_m_axis_tdest,

  input  wire [CTRL_WIDTH-1:0]               ctrl_s_axis_tdata,
  input  wire                                ctrl_s_axis_tvalid,
  output wire                                ctrl_s_axis_tready,
  input  wire                                ctrl_s_axis_tlast,
  input  wire [CORE_ID_WIDTH-1:0]            ctrl_s_axis_tuser,

  // Descriptor for Loopback message FIFO among cores
  output wire [ID_TAG_WIDTH-1:0]             loopback_msg_src,
  output wire [ID_TAG_WIDTH-1:0]             loopback_msg_dest,
  output wire                                loopback_msg_valid,
  input  wire                                loopback_msg_ready
);

  parameter MSG_TYPE_WIDTH = 4;
  parameter DESC_WIDTH     = CTRL_WIDTH-MSG_TYPE_WIDTH;

  // Separate incoming ctrl messages
  wire [MSG_TYPE_WIDTH-1:0] msg_type = 
                ctrl_s_axis_tdata[CTRL_WIDTH-1:CTRL_WIDTH-MSG_TYPE_WIDTH];

  wire [DESC_WIDTH-1:0]    pkt_done_desc,  pkt_sent_desc,  slot_loader_desc;
  wire [CORE_ID_WIDTH-1:0] pkt_done_src,   pkt_sent_src,   slot_loader_src;
  wire                     pkt_done_valid, pkt_sent_valid, slot_loader_valid;
  wire                     pkt_done_ready, pkt_sent_ready, slot_loader_ready;
                           
  wire [CORE_COUNT*(DESC_WIDTH+CORE_ID_WIDTH)-1:0] pkt_to_core_req;
  wire [CORE_COUNT*SLOT_WIDTH-1:0]                 rx_desc_slot;
  wire [CORE_COUNT-1:0] pkt_to_core_valid, pkt_to_core_ready, 
                        arb_to_core_ready, rx_desc_slot_v;

  wire loader_ready, loopback_ready;
  wire [CORE_COUNT-1:0]    rx_desc_slot_accept;

  simple_fifo # (
    .ADDR_WIDTH(3),
    .DATA_WIDTH(CORE_ID_WIDTH+DESC_WIDTH)
  ) pkt_sent_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
  
    .din_valid(ctrl_s_axis_tvalid && (msg_type==0)),
    .din({ctrl_s_axis_tuser,ctrl_s_axis_tdata[DESC_WIDTH-1:0]}),
    .din_ready(pkt_sent_ready),
   
    .dout_valid(pkt_sent_valid),
    .dout({pkt_sent_src,pkt_sent_desc}),
    .dout_ready(|(rx_desc_slot_accept & (1<<pkt_sent_src)))
  );

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
        .dout_ready(arb_to_core_ready[m] && rx_desc_slot_v[m])
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
    .s_axis_tvalid(pkt_to_core_valid & rx_desc_slot_v),
    .s_axis_tready(arb_to_core_ready),
    .s_axis_tlast({CORE_COUNT{1'b1}}),
    .s_axis_tid(),
    .s_axis_tdest(),
    .s_axis_tuser(rx_desc_slot),
    
    .m_axis_tdata({selected_pkt_to_core_src, selected_pkt_to_core_desc}),
    .m_axis_tkeep(),
    .m_axis_tvalid(selected_pkt_to_core_valid),
    .m_axis_tready(selected_pkt_to_core_ready && loopback_msg_ready),
    .m_axis_tlast(),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(selected_pkt_to_core_dest_slot)
  );
   
  simple_fifo # (
    .ADDR_WIDTH(3),
    .DATA_WIDTH(CORE_ID_WIDTH+DESC_WIDTH)
  ) slot_loader_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
  
    .din_valid(ctrl_s_axis_tvalid && (msg_type==3)),
    .din({ctrl_s_axis_tuser,ctrl_s_axis_tdata[DESC_WIDTH-1:0]}),
    .din_ready(slot_loader_ready),
   
    .dout_valid(slot_loader_valid),
    .dout({slot_loader_src,slot_loader_desc}),
    .dout_ready(loader_ready)
  );
 
  assign ctrl_s_axis_tready = (pkt_sent_ready    && (msg_type==0)) ||
                              (pkt_done_ready    && (msg_type==1)) || 
                              (pkt_to_core_ready && (msg_type==2)) || 
                              (slot_loader_ready && (msg_type==3));
  
  // Slot descriptor fifos, addressing msg type 0 requests
  wire [CORE_COUNT*SLOT_WIDTH-1:0] rx_desc_count;
  wire [CORE_ID_WIDTH-1:0] selected_desc;
  wire [CORE_COUNT-1:0]    rx_desc_slot_pop;
  wire [CORE_COUNT-1:0]    rx_desc_slot_accept_temp;

  wire [CORE_COUNT-1:0] desc_fifo_clear, loader_valid, busy_by_loader, rx_desc_fifo_v;
  wire [SLOT_WIDTH-1:0] loader_slot;
  
  wire [SLOT_WIDTH-1:0] pkt_sent_slot = pkt_sent_desc[16 +: SLOT_WIDTH]; 
  wire rx_desc_pop; // maybe used for error catching

  // TODO: Make this one bit flags and use PENC and DEC
  genvar i;
  generate 
    for (i=0;i<CORE_COUNT;i=i+1) begin
      simple_fifo # (
        .DATA_WIDTH(SLOT_WIDTH),
        .ADDR_WIDTH($clog2(SLOT_COUNT))
      ) rx_desc_fifo (
        .clk(clk),
        .rst(rst),
        .clear(desc_fifo_clear[i]),
      
        .din_valid(rx_desc_fifo_v[i]), 
        .din(loader_valid[i] ? loader_slot : pkt_sent_slot),
        .din_ready(rx_desc_slot_accept_temp[i]),
       
        .dout_valid(rx_desc_slot_v[i]),
        .dout(rx_desc_slot[i*SLOT_WIDTH +: SLOT_WIDTH]),
        .dout_ready(rx_desc_slot_pop[i]),
        
        .item_count(rx_desc_count[i*SLOT_WIDTH +: SLOT_WIDTH])
      );
      // If there is no data in any fifo max_finder would return 0, meaning first core is selected.
      // but since rx_desc_v is zero (all fifoes are not-valid) this ready is not used
      assign rx_desc_fifo_v[i]      = (pkt_sent_valid && (pkt_sent_src==i) && (pkt_sent_slot!=0)) 
                                      || loader_valid[i];
      assign rx_desc_slot_pop[i]    = (rx_desc_pop && (selected_desc==i)) || 
                                      (pkt_to_core_valid[i] && arb_to_core_ready[i]);

      assign rx_desc_slot_accept[i] = (rx_desc_slot_accept_temp[i] || (pkt_sent_slot==0)) && 
                                      (!busy_by_loader[i]);
    end
  endgenerate

  // Assing looback port
  wire [CORE_ID_WIDTH-1:0] loopback_port;

  if (LOOPBACK_COUNT==1)
    assign loopback_port = LOOPBACK_PORT;
  else if (LOOPBACK_COUNT==2) begin

    reg loopback_port_select_r;

    always @ (posedge clk)
      if (rst)
        loopback_port_select_r <= 1'b0;
      else if (selected_pkt_to_core_valid && selected_pkt_to_core_ready && loopback_msg_ready)
        loopback_port_select_r <= ~loopback_port_select_r;

    assign loopback_port = loopback_port_select_r ? (LOOPBACK_PORT+1) : LOOPBACK_PORT;

  end else begin

    reg [$clog2(LOOPBACK_COUNT)-1:0] loopback_port_select_r;

    always @ (posedge clk)
      if (rst)
        loopback_port_select_r <= 0;
      else if (selected_pkt_to_core_valid && selected_pkt_to_core_ready && loopback_msg_ready)
        if (loopback_port_select_r==(LOOPBACK_COUNT-1))
          loopback_port_select_r <= 0;
        else
          loopback_port_select_r <= loopback_port_select_r+1;

    assign loopback_port = LOOPBACK_PORT + loopback_port_select_r;

  end

  wire [DESC_WIDTH-1:0] pkt_to_core_with_port = 
              {selected_pkt_to_core_desc[DESC_WIDTH-1:24+CORE_ID_WIDTH], 
               loopback_port, selected_pkt_to_core_desc[23:0]};

  // Slot descriptor loader module, addressing msg typee 3 requests
  slot_fifo_loader # (
    .MAX_SLOT_COUNT(SLOT_COUNT),
    .DEST_COUNT(CORE_COUNT)
  ) slot_loader (
    .clk(clk),
    .rst(rst),
  
    .req_valid(slot_loader_valid),
    .req_dest(slot_loader_src),
    .slot_count(slot_loader_desc[16 +: SLOT_WIDTH]),
    .req_ready(loader_ready),
  
    .clear_fifo(desc_fifo_clear),
    .out_slot_valid(loader_valid),
    .out_slot(loader_slot)
  );

  assign busy_by_loader = loader_valid | desc_fifo_clear;

  // Generating src,dest descriptor for loopback output port
  wire [SLOT_WIDTH-1:0]    selected_pkt_to_core_slot = selected_pkt_to_core_desc[16 +: SLOT_WIDTH]; 
  wire [CORE_ID_WIDTH-1:0] loopback_msg_dest_core    = selected_pkt_to_core_desc[24 +: CORE_ID_WIDTH];

  assign loopback_msg_src   = {selected_pkt_to_core_src, {(TAG_WIDTH-SLOT_WIDTH){1'b0}}, 
                               selected_pkt_to_core_slot};
  assign loopback_msg_dest  = {loopback_msg_dest_core, {(TAG_WIDTH-SLOT_WIDTH){1'b0}}, 
                               selected_pkt_to_core_dest_slot};
  assign loopback_msg_valid = selected_pkt_to_core_valid && selected_pkt_to_core_ready;

  // Arbiter for ctrl messaage output 
  
  // arbiter between pkt done and pkt send to core, addressing msg type 1&2 requests
  wire [CORE_ID_WIDTH-1:0] ctrl_out_dest;
  wire [DESC_WIDTH-1:0]    ctrl_out_desc;
  wire ctrl_out_valid, ctrl_out_ready;

  axis_arb_mux #
  (
    .S_COUNT(2),
    .DATA_WIDTH(CORE_ID_WIDTH+DESC_WIDTH),
    .KEEP_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(0),
    .ARB_TYPE("ROUND_ROBIN")
  ) ctrl_out_arbiter
  (
    .clk(clk),
    .rst(rst),

    .s_axis_tdata({selected_pkt_to_core_src, pkt_to_core_with_port,
                   pkt_done_src,pkt_done_desc}),
    .s_axis_tkeep(),
    .s_axis_tvalid({(selected_pkt_to_core_valid && loopback_msg_ready)
                    ,pkt_done_valid}),
    .s_axis_tready({selected_pkt_to_core_ready, loopback_ready}),
    .s_axis_tlast(2'b11),
    .s_axis_tid(),
    .s_axis_tdest(),
    .s_axis_tuser(),

    .m_axis_tdata({ctrl_out_dest,ctrl_out_desc}),
    .m_axis_tkeep(),
    .m_axis_tvalid(ctrl_out_valid),
    .m_axis_tready(ctrl_out_ready),
    .m_axis_tlast(),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser()
  );

  // Core reset command
  reg [CORE_ID_WIDTH:0] core_rst_counter;
  wire core_reset_in_prog = (core_rst_counter < CORE_COUNT); 
  wire [CORE_ID_WIDTH:0] reordered_core_rst_counter;
  
  // Reordering of reset for alleviating congestion on lvl 2 switches 
  // during startup
  if (LVL2_SW_PORTS==1)
    assign reordered_core_rst_counter = core_rst_counter[CORE_ID_WIDTH-1:0];  
  else 
    assign reordered_core_rst_counter = {core_rst_counter[LVL1_BITS-1:0],
                                         core_rst_counter[CORE_ID_WIDTH-1:LVL1_BITS]};

  always @ (posedge clk)
    if (rst)
        core_rst_counter <= 0;
    else
      if (ctrl_m_axis_tvalid && ctrl_m_axis_tready && core_reset_in_prog)
        core_rst_counter <= core_rst_counter + 1;

  // making the descriptor type to be 0, so core would send out. 
  assign ctrl_m_axis_tdata  = core_reset_in_prog ? {{(CTRL_WIDTH-1){1'b1}}, 1'b0} 
                                                 : {{MSG_TYPE_WIDTH{1'b0}}, ctrl_out_desc};
  assign ctrl_m_axis_tvalid = core_reset_in_prog || ctrl_out_valid;
  assign ctrl_m_axis_tlast  = ctrl_m_axis_tvalid;
  assign ctrl_m_axis_tdest  = core_reset_in_prog ? reordered_core_rst_counter 
                                                 : ctrl_out_dest;

  assign ctrl_out_ready     = (!core_reset_in_prog) && ctrl_m_axis_tready;

  
  // Selecting the core with most available slots
  // Since slots start from 1, SLOT WIDTH is already 1 bit extra
  reg [CORE_COUNT*SLOT_WIDTH-1:0] reordered_rx_desc_count;
  wire [CORE_ID_WIDTH-1:0] reordered_selected_desc;
  integer k,l;
  always @ (*)
    for (k=0; k<LVL2_SW_PORTS; k=k+1)
      for (l=0; l<LVL1_SW_PORTS; l=l+1)
        reordered_rx_desc_count[(k*LVL1_SW_PORTS+l)*SLOT_WIDTH +: SLOT_WIDTH] = 
                  rx_desc_count[(l*LVL2_SW_PORTS+k)*SLOT_WIDTH +: SLOT_WIDTH];

  max_finder_tree # (
    .PORT_COUNT(CORE_COUNT),
    .DATA_WIDTH(SLOT_WIDTH)
  ) core_selector ( 
    .values(reordered_rx_desc_count),
    .max_val(),
    .max_ptr(reordered_selected_desc)
  );

  if (LVL2_SW_PORTS==1)
    assign selected_desc = reordered_selected_desc;
  else 
    assign selected_desc = {reordered_selected_desc[LVL1_BITS-1:0],
                           reordered_selected_desc[CORE_ID_WIDTH-1:LVL1_BITS]};

  
  // Adding tdest and tuser to input data from eth, dest based on 
  // rx_desc_fifo and stamp the incoming port
  reg  [INTERFACE_COUNT*ID_TAG_WIDTH-1:0] dest_r;
  wire [INTERFACE_WIDTH-1:0] selected_port_enc;
  wire [INTERFACE_COUNT-1:0] sending_last_word;
  reg  [INTERFACE_COUNT-1:0] dest_r_v;
  wire [INTERFACE_COUNT-1:0] selected_port;
  wire selected_port_v;
  
  wire [ID_TAG_WIDTH-1:0] rx_desc_data; 
  wire rx_desc_v; 
  
  assign rx_desc_v          = | rx_desc_slot_v;
  assign rx_desc_data       = {selected_desc, {(TAG_WIDTH-SLOT_WIDTH){1'b0}}, 
                              rx_desc_slot[selected_desc*SLOT_WIDTH +: SLOT_WIDTH]};
 
  assign sending_last_word = rx_axis_tvalid & rx_axis_tlast & rx_axis_tready;
  assign rx_desc_pop = selected_port_v && rx_desc_v && 
                       !(|(pkt_to_core_valid & arb_to_core_ready & rx_desc_slot_v));
  // If one of the descriptors are not valid or a last word is being sent 
  // that means they need a new descriptor. If a descriptor is being assigned 
  // or there is no descriptors available the request would be masked.
  wire [INTERFACE_COUNT-1:0] desc_req = ((~dest_r_v)|sending_last_word) & 
                                        {INTERFACE_COUNT{rx_desc_v}} & (~selected_port);
  
  arbiter # (.PORTS(INTERFACE_COUNT),.TYPE("ROUND_ROBIN")) port_selector (
    .clk(clk),
    .rst(rst),
    
    .request(desc_req),
    .acknowledge({INTERFACE_COUNT{1'b0}}),
    
    .grant(selected_port),
    .grant_valid(selected_port_v),
    .grant_encoded(selected_port_enc)
    );

  always @ (posedge clk) begin
    dest_r_v <= dest_r_v & (~sending_last_word);
    if (rx_desc_pop) begin
      dest_r_v[selected_port_enc] <= 1'b1;
      dest_r[selected_port_enc*ID_TAG_WIDTH +: ID_TAG_WIDTH] <= rx_desc_data;
    end
    if (rst)
      dest_r_v <= {INTERFACE_COUNT{1'b0}};
  end

  genvar j;
  generate
    for (j=0; j<INTERFACE_COUNT;j=j+1)
      assign data_m_axis_tuser[j*PORT_WIDTH +: PORT_WIDTH] = j;
  endgenerate

  assign data_m_axis_tdata  = rx_axis_tdata;
  assign data_m_axis_tkeep  = rx_axis_tkeep;
  assign data_m_axis_tvalid = rx_axis_tvalid & dest_r_v; 
  assign data_m_axis_tlast  = rx_axis_tlast;
  assign data_m_axis_tdest  = dest_r;
  assign rx_axis_tready     = data_m_axis_tready & dest_r_v;
  
  assign tx_axis_tdata      = data_s_axis_tdata;
  assign tx_axis_tkeep      = data_s_axis_tkeep;
  assign tx_axis_tvalid     = data_s_axis_tvalid;  
  assign tx_axis_tlast      = data_s_axis_tlast;
  assign data_s_axis_tready = tx_axis_tready;
  // no further use for data_s_axis_tdest after its at correct port

if (ENABLE_ILA) begin
  wire trig_out_1, trig_out_2;
  wire ack_1, ack_2;

  reg [15:0] rx_count_0, rx_count_1, tx_count_0, tx_count_1;
  always @ (posedge clk)
    if (rst) begin
        rx_count_0 <= 16'd0;
        rx_count_1 <= 16'd0;
        tx_count_0 <= 16'd0;
        tx_count_1 <= 16'd0;
    end else begin
      if (rx_axis_tlast[0] && rx_axis_tvalid[0])
        rx_count_0 <= 16'd0;
      else if (rx_axis_tvalid[0])
        rx_count_0 <= rx_count_0 + 16'd1;

      if (rx_axis_tlast[1] && rx_axis_tvalid[1])
        rx_count_1 <= 16'd0;
      else if (rx_axis_tvalid[1])
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

  wire hang_trigger = ctrl_s_axis_tvalid && (!ctrl_s_axis_tready) && (msg_type==0);

  ila_4x64 debugger1 (
    .clk    (clk),
 
    .trig_out(trig_out_1),
    .trig_out_ack(1'b0), // ack_1),
    .trig_in (hang_trigger), // trig_out_2 || hang_trigger),
    .trig_in_ack(ack_2),
 
    .probe0 ({
       // rx_axis_tkeep,
       sending_last_word,
       data_m_axis_tdest,
       ctrl_m_axis_tdata[31:0]
       // rx_count_0,
    }),
    
    .probe1 ({
       ctrl_s_axis_tdata[31:0],
       data_m_axis_tuser,
       ctrl_m_axis_tdest,
       ctrl_s_axis_tuser,
       ctrl_m_axis_tvalid,
       ctrl_m_axis_tready,
       ctrl_m_axis_tlast,
       ctrl_s_axis_tvalid,
       ctrl_s_axis_tready,
       ctrl_s_axis_tlast,
       dest_r_v,
       msg_type,
       rx_axis_tvalid, 
       rx_axis_tready, 
       rx_axis_tlast
     }),
  
    .probe2 (rx_desc_count), 

    .probe3 ({rx_desc_fifo_v, rx_desc_slot_accept,
              rx_desc_slot_v, rx_desc_slot_pop})

    // .probe2 (rx_axis_tdata[63:0]),

    // .probe3 (rx_axis_tdata[127:64])
  );

  // Updated signals, just disabled for saving BRAMs
  // ila_8x64 debugger2 (
  //   .clk    (clk),
 
  //   .trig_out(trig_out_2),
  //   .trig_out_ack(ack_2),
  //   .trig_in (trig_out_1 || hang_trigger),
  //   .trig_in_ack(ack_1),
  //  
  //   .probe0 ({
  //      data_s_axis_tkeep,
  //      data_s_axis_tuser,
  //      rx_desc_data,
  //      data_s_axis_tdest,
  //      data_s_axis_tvalid, 
  //      data_s_axis_tready, 
  //      data_s_axis_tlast,
  //      rx_desc_v, 
  //      rx_desc_pop
  //    }),
  // 
  //   .probe1 (ctrl_m_axis_tdata),
  //   
  //   .probe2 (data_s_axis_tdata[63:0]),

  //   .probe3 (data_s_axis_tdata[127:64]),
  //   
  //   .probe4 (tx_count_1), .probe5 (tx_count_0), 
  //   .probe6 (rx_count_1), .probe7 (rx_count_0)
 
  // );
end

endmodule
