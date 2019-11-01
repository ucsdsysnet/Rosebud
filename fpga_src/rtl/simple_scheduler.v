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

  // Cores reset
  input  wire [CORE_ID_WIDTH-1:0]            reset_dest,
  input  wire                                reset_value,
  input  wire                                reset_valid,
  output wire                                reset_ready,

  input  wire [CORE_COUNT-1:0]               income_cores, 
  input  wire [CORE_COUNT-1:0]               cores_to_be_reset,
  input  wire [CORE_ID_WIDTH-1:0]            core_for_slot_count,
  output wire [SLOT_WIDTH-1:0]               slot_count,

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
    .dout_ready(rx_desc_slot_accept[pkt_sent_src])
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
    .m_axis_tready(selected_pkt_to_core_ready), // && loopback_msg_ready),
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
  wire max_valid;

  wire [CORE_COUNT-1:0] core_slot_err;
  reg  [CORE_COUNT-1:0] core_slot_err_r;
  reg  slot_insert_err;

  always @ (posedge clk) begin
    core_slot_err_r <= core_slot_err; 
    slot_insert_err <= | core_slot_err_r;
  end

  // TODO: Make this one bit flags and use PENC and DEC
  genvar i;
  generate 
    for (i=0;i<CORE_COUNT;i=i+1) begin
      wire [SLOT_WIDTH-1:0] input_slot = 
              loader_valid[i] ? loader_slot : pkt_sent_slot;
     
     slot_keeper # (
       .SLOT_COUNT(SLOT_COUNT), 
       .SLOT_WIDTH(SLOT_WIDTH)
     ) rx_desc_keeper (
        .clk(clk),
        .rst(rst),
        .clear(desc_fifo_clear[i]), 
      
        .slot_in_valid(rx_desc_fifo_v[i]), 
        .slot_in(input_slot),
        .slot_in_accept(rx_desc_slot_accept_temp[i]),
       
        .slot_out_valid(rx_desc_slot_v[i]),
        .slot_out(rx_desc_slot[i*SLOT_WIDTH +: SLOT_WIDTH]),
        .slot_out_pop(rx_desc_slot_pop[i]),
        
        .slot_count(rx_desc_count[i*SLOT_WIDTH +: SLOT_WIDTH]),
        .insert_err(core_slot_err[i])
      );

      assign rx_desc_fifo_v[i]      = (pkt_sent_valid && (pkt_sent_src==i) && (pkt_sent_slot!=0)) 
                                      || loader_valid[i];
      assign rx_desc_slot_pop[i]    = (rx_desc_pop && (selected_desc==i)) || 
                                      (pkt_to_core_valid[i] && arb_to_core_ready[i] && (~cores_to_be_reset[i]));

      assign rx_desc_slot_accept[i] = (rx_desc_slot_accept_temp[i] || (pkt_sent_slot==0)) && 
                                      (!busy_by_loader[i]);
    end
  endgenerate
  
  reg [$clog2(INTERFACE_COUNT)-1:0] dropped_count [0:CORE_COUNT-1];
  assign slot_count = rx_desc_count[core_for_slot_count * SLOT_WIDTH +: SLOT_WIDTH] + 
                      dropped_count[core_for_slot_count];

  // Assing looback port
  wire [CORE_ID_WIDTH-1:0] loopback_port;

  if (LOOPBACK_COUNT==1)
    assign loopback_port = LOOPBACK_PORT;
  else if (LOOPBACK_COUNT==2) begin

    reg loopback_port_select_r;

    always @ (posedge clk)
      if (rst)
        loopback_port_select_r <= 1'b0;
      else if (selected_pkt_to_core_valid && selected_pkt_to_core_ready) // && loopback_msg_ready)
        loopback_port_select_r <= ~loopback_port_select_r;

    assign loopback_port = loopback_port_select_r ? (LOOPBACK_PORT+1) : LOOPBACK_PORT;

  end else begin

    reg [$clog2(LOOPBACK_COUNT)-1:0] loopback_port_select_r;

    always @ (posedge clk)
      if (rst)
        loopback_port_select_r <= 0;
      else if (selected_pkt_to_core_valid && selected_pkt_to_core_ready) // && loopback_msg_ready)
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
    if (selected_pkt_to_core_valid && pkt_done_valid) //&& loopback_msg_ready
      ctrl_out_select = ~last_selected;
    else if (selected_pkt_to_core_valid) // && loopback_msg_ready)
      ctrl_out_select = 1'b1;
    else if (pkt_done_valid)
      ctrl_out_select = 1'b0;
    else 
      ctrl_out_select = last_selected;

  assign ctrl_out_valid = selected_pkt_to_core_valid || pkt_done_valid; //&& loopback_msg_ready)  
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

  // Core reset command
  reg  [CORE_ID_WIDTH:0] core_rst_counter;
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
  assign ctrl_m_axis_tdata  = core_reset_in_prog ? {{(CTRL_WIDTH-1){1'b1}}, 1'b0} :
                               reset_valid       ? {{(CTRL_WIDTH-1){1'b1}}, reset_value} 
                                                 : ctrl_out_desc_r;
  assign ctrl_m_axis_tvalid = core_reset_in_prog || reset_valid || ctrl_out_valid_r;
  assign ctrl_m_axis_tlast  = ctrl_m_axis_tvalid;
  assign ctrl_m_axis_tdest  = core_reset_in_prog ? reordered_core_rst_counter : 
                              reset_valid        ? reset_dest : ctrl_out_dest_r;

  assign ctrl_out_ready_r   = (!core_reset_in_prog) && (!reset_valid) && ctrl_m_axis_tready;
  assign reset_ready        = !core_reset_in_prog;

  // Selecting the core with most available slots
  // Since slots start from 1, SLOT WIDTH is already 1 bit extra
  reg  [CORE_COUNT*SLOT_WIDTH-1:0] reordered_rx_desc_count;
  wire [CORE_ID_WIDTH-1:0]         reordered_selected_desc;
  reg  [CORE_COUNT-1:0]            reordered_masks;
  integer k,l;
  always @ (*)
    for (k=0; k<LVL2_SW_PORTS; k=k+1)
      for (l=0; l<LVL1_SW_PORTS; l=l+1) begin
        reordered_rx_desc_count[(k*LVL1_SW_PORTS+l)*SLOT_WIDTH +: SLOT_WIDTH] = 
                  rx_desc_count[(l*LVL2_SW_PORTS+k)*SLOT_WIDTH +: SLOT_WIDTH];
        // Priority to inter core messages, and only income_cores are available for selection
        reordered_masks [k*LVL1_SW_PORTS+l] = income_cores[l*LVL2_SW_PORTS+k] &&
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
  reg  [INTERFACE_COUNT*ID_TAG_WIDTH-1:0] dest_r;
  wire [INTERFACE_WIDTH-1:0] selected_port_enc;
  wire [INTERFACE_COUNT-1:0] sending_last_word;
  reg  [INTERFACE_COUNT-1:0] dest_r_v;
  wire [INTERFACE_COUNT-1:0] selected_port;
  wire selected_port_v;
  
  wire [ID_TAG_WIDTH-1:0] rx_desc_data; 
  
  assign rx_desc_data       = {selected_desc, {(TAG_WIDTH-SLOT_WIDTH){1'b0}}, 
                              rx_desc_slot[selected_desc*SLOT_WIDTH +: SLOT_WIDTH]};
 
  assign sending_last_word = rx_axis_tvalid & rx_axis_tlast & rx_axis_tready;
  assign rx_desc_pop = selected_port_v && max_valid;
  // If one of the descriptors are not valid or a last word is being sent 
  // that means they need a new descriptor. If a descriptor is being assigned 
  // or there is no descriptors available the request would be masked.
  wire [INTERFACE_COUNT-1:0] desc_req = ((~dest_r_v)|sending_last_word) & 
                                        {INTERFACE_COUNT{max_valid}} & (~selected_port);
  
  arbiter # (.PORTS(INTERFACE_COUNT),.TYPE("ROUND_ROBIN")) port_selector (
    .clk(clk),
    .rst(rst),
    
    .request(desc_req),
    .acknowledge({INTERFACE_COUNT{1'b0}}),
    
    .grant(selected_port),
    .grant_valid(selected_port_v),
    .grant_encoded(selected_port_enc)
    );

  integer n;
  reg [CORE_COUNT-1:0] dropped [0:INTERFACE_COUNT-1];

  always @ (posedge clk) begin

    dest_r_v <= dest_r_v & (~sending_last_word);
    if (rx_desc_pop) begin
      dest_r_v[selected_port_enc] <= 1'b1;
      dest_r[selected_port_enc*ID_TAG_WIDTH +: ID_TAG_WIDTH] <= rx_desc_data;
    end

    for (n=0; n<INTERFACE_COUNT; n=n+1) begin
      // cores_to_be_reset or actual reset would flush dest_r
      if (cores_to_be_reset[dest_r[(n*ID_TAG_WIDTH)+TAG_WIDTH +: CORE_ID_WIDTH]])
        dest_r_v[n] <= 1'b0;

      if (reset_valid && reset_ready && (dest_r[(n*ID_TAG_WIDTH)+TAG_WIDTH +: CORE_ID_WIDTH] == reset_dest)) 
        dest_r_v[n] <= 1'b0;

      // If preparing for reset we remember if any desc was dropped, used for slots which were in controller before reset 
      // Drop means it was valid, and not being used for a packet
      if (cores_to_be_reset[dest_r[(n*ID_TAG_WIDTH)+TAG_WIDTH +: CORE_ID_WIDTH]] && dest_r_v[n] && !rx_axis_tvalid[n]) 
        dropped[n][dest_r[(n*ID_TAG_WIDTH)+TAG_WIDTH +: CORE_ID_WIDTH]] <= 1'b1;
      if (reset_valid && reset_ready) begin
        dropped[n][reset_dest] <= 1'b0;
      end

      if (rst) begin
        dest_r_v[n] <= 1'b0;
        dropped[n]  <= {CORE_COUNT{1'b0}};
      end
    end
      
  end

  integer p,q;
  always @(*)
    for (q=0; q<CORE_COUNT; q=q+1) begin
      dropped_count[q] = 0;
      for (p=0; p<INTERFACE_COUNT; p=p+1)
        dropped_count[q] = dropped_count[q] + dropped[p][q];
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
  reg [CORE_COUNT*SLOT_WIDTH-1:0] rx_desc_count_r;

  always @ (posedge clk)
    rx_desc_count_r <= rx_desc_count;


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

  // wire hang_trigger = ctrl_s_axis_tvalid && (!ctrl_s_axis_tready) && (msg_type==0);

  ila_4x64 debugger1 (
    .clk    (clk),
 
    .trig_out(trig_out),
    .trig_out_ack(trig_out_ack), // ack_1),
    .trig_in (trig_in), // trig_out_2 || hang_trigger),
    .trig_in_ack(trig_in_ack),
 
    .probe0 ({
       sending_last_word,
       data_m_axis_tdest,
       pkt_sent_valid, rst,
       data_m_axis_tuser,
       ctrl_m_axis_tdest,
       ctrl_s_axis_tuser,
       ctrl_m_axis_tvalid,
       ctrl_m_axis_tready,
       ctrl_s_axis_tvalid,
       ctrl_s_axis_tready,
       slot_insert_err,
       // ctrl_s_axis_tlast,
       dest_r_v,
       msg_type,
       rx_axis_tvalid, 
       pkt_sent_slot
       // rx_axis_tready,
       // rx_axis_tlast
     }),
    
    .probe1 ({
       ctrl_m_axis_tdata[31:0],
       ctrl_s_axis_tdata[31:0]
       // rx_axis_tkeep,
       // rx_count_0,
    }),
  
    .probe2 (rx_desc_count_r), 

    .probe3 ({rx_desc_fifo_v, rx_desc_slot_accept,
              rx_desc_slot_v, rx_desc_slot_pop})

    // .probe4 ({cores_to_be_reset, income_cores, 
    //           loader_valid, desc_fifo_clear})
    // .probe5 (rx_axis_tdata[63:0]),

    // .probe6 (rx_axis_tdata[127:64])
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
  //      max_valid, 
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
