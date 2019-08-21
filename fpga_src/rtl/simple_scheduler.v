module simple_scheduler # (
  parameter INTERFACE_COUNT = 2,
  parameter PORT_COUNT      = 3,
  parameter CORE_COUNT      = 16,
  parameter SLOT_COUNT      = 8,
  parameter DATA_WIDTH      = 64,
  parameter LEN_WIDTH       = 16,
  parameter ENABLE_ILA      = 0,

  parameter SLOT_WIDTH      = $clog2(SLOT_COUNT+1),
  parameter CORE_ID_WIDTH   = $clog2(CORE_COUNT),
  parameter INTERFACE_WIDTH = $clog2(INTERFACE_COUNT),
  parameter PORT_WIDTH      = $clog2(PORT_COUNT),
  parameter ID_SLOT_WIDTH   = CORE_ID_WIDTH+SLOT_WIDTH,
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
  output wire [INTERFACE_COUNT*ID_SLOT_WIDTH-1:0] data_m_axis_tdest,
  output wire [INTERFACE_COUNT*PORT_WIDTH-1:0]    data_m_axis_tuser,
  output wire [INTERFACE_COUNT-1:0]               data_m_axis_tvalid,
  input  wire [INTERFACE_COUNT-1:0]               data_m_axis_tready,
  output wire [INTERFACE_COUNT-1:0]               data_m_axis_tlast,
  
  input  wire [INTERFACE_COUNT*DATA_WIDTH-1:0]    data_s_axis_tdata,
  input  wire [INTERFACE_COUNT*STRB_WIDTH-1:0]    data_s_axis_tkeep,
  input  wire [INTERFACE_COUNT*PORT_WIDTH-1:0]    data_s_axis_tdest,
  input  wire [INTERFACE_COUNT*ID_SLOT_WIDTH-1:0] data_s_axis_tuser,
  input  wire [INTERFACE_COUNT-1:0]               data_s_axis_tvalid, 
  output wire [INTERFACE_COUNT-1:0]               data_s_axis_tready, 
  input  wire [INTERFACE_COUNT-1:0]               data_s_axis_tlast,
      
  // Control lines to/from cores
  output wire [DATA_WIDTH-1:0]               ctrl_m_axis_tdata,
  output wire                                ctrl_m_axis_tvalid,
  input  wire                                ctrl_m_axis_tready,
  output wire                                ctrl_m_axis_tlast,
  output wire [CORE_ID_WIDTH-1:0]            ctrl_m_axis_tdest,

  input  wire [DATA_WIDTH-1:0]               ctrl_s_axis_tdata,
  input  wire                                ctrl_s_axis_tvalid,
  output wire                                ctrl_s_axis_tready,
  input  wire                                ctrl_s_axis_tlast,
  input  wire [CORE_ID_WIDTH-1:0]            ctrl_s_axis_tuser
);
  
  // Adding tdest and tuser to input data from eth, dest based on 
  // rx_desc_fifo and stamp the incoming port
  reg  [INTERFACE_COUNT*ID_SLOT_WIDTH-1:0] dest_r;
  wire [INTERFACE_WIDTH-1:0] selected_port_enc;
  wire [INTERFACE_COUNT-1:0] sending_last_word;
  reg  [INTERFACE_COUNT-1:0] dest_r_v;
  wire [INTERFACE_COUNT-1:0] selected_port;

  wire selected_port_v;
  wire rx_desc_pop; // maybe used for error catching
  wire [ID_SLOT_WIDTH-1:0] rx_desc_data; 
  wire rx_desc_v; 

  assign sending_last_word = rx_axis_tvalid & rx_axis_tlast & rx_axis_tready;
  assign rx_desc_pop = selected_port_v && rx_desc_v;
  // If one of the descriptors are not valid or a last word is being sent that means they need a new descriptor.
  // If a descriptor is being assigned or there is no descriptors available the request would be masked.
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
    if (selected_port_v && rx_desc_v) begin
      dest_r_v[selected_port_enc] <= 1'b1;
      dest_r[selected_port_enc*ID_SLOT_WIDTH +: ID_SLOT_WIDTH] <= rx_desc_data;
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

  wire [SLOT_WIDTH-1:0]    rx_desc_slot [0:CORE_COUNT-1];
  wire [CORE_ID_WIDTH-1:0] selected_desc;
  wire [CORE_COUNT-1:0]    rx_desc_slot_v;
  wire [CORE_COUNT-1:0]    rx_desc_slot_pop;
  wire [CORE_COUNT-1:0]    rx_desc_slot_accept_temp;
  wire [CORE_COUNT-1:0]    rx_desc_slot_accept;
  
  // Since slots start from 1, SLOT WIDTH is already 1 bit extra
  wire [CORE_COUNT*SLOT_WIDTH-1:0] rx_desc_count;
        
  assign rx_desc_v          = | rx_desc_slot_v;
  assign rx_desc_data       = {selected_desc, rx_desc_slot[selected_desc]};

  wire [3:0] msg_type = ctrl_s_axis_tdata[DATA_WIDTH-1:DATA_WIDTH-4];

  // Slot descriptor loader module 
  wire [CORE_COUNT-1:0] desc_fifo_clear, loader_valid, busy_by_loader, rx_desc_fifo_v;
  wire [SLOT_WIDTH-1:0] loader_slot;
  wire                  loader_ready;

  slot_fifo_loader # (
    .MAX_SLOT_COUNT(SLOT_COUNT),
    .DEST_COUNT(CORE_COUNT)
  ) slot_loader (
    .clk(clk),
    .rst(rst),
  
    .req_valid(ctrl_s_axis_tvalid && (msg_type==3)),
    .req_dest(ctrl_s_axis_tuser),
    .slot_count(ctrl_s_axis_tdata[SLOT_WIDTH-1:0]),
    .req_ready(loader_ready),
  
    .clear_fifo(desc_fifo_clear),
    .out_slot_valid(loader_valid),
    .out_slot(loader_slot)
  );

  assign busy_by_loader = loader_valid | desc_fifo_clear;

  // Slot descriptor fifos
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
        .din(loader_valid[i] ? loader_slot : ctrl_s_axis_tdata[LEN_WIDTH+SLOT_WIDTH-1:LEN_WIDTH]),
        .din_ready(rx_desc_slot_accept_temp[i]),
       
        .dout_valid(rx_desc_slot_v[i]),
        .dout(rx_desc_slot[i]),
        .dout_ready(rx_desc_slot_pop[i]),
        
        .item_count(rx_desc_count[i*SLOT_WIDTH +: SLOT_WIDTH])
      );
      // If there is no data in any fifo max_finder would return 0, meaning first core is selected.
      // but since rx_desc_v is zero (all fifoes are not-valid) this ready is not used
      assign rx_desc_fifo_v[i]      = (ctrl_s_axis_tvalid && (ctrl_s_axis_tuser==i) && (msg_type==0)) 
                                       || loader_valid[i];
      assign rx_desc_slot_pop[i]    = rx_desc_pop && (selected_desc==i);
      assign rx_desc_slot_accept[i] = rx_desc_slot_accept_temp[i] && (!busy_by_loader[i]);
    end
  endgenerate

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

  // Loop back ready desc 
  wire loopback_in_ready;
  wire [CORE_ID_WIDTH-1:0] loopback_dest;
  wire [DATA_WIDTH-1:0]    loopback_data;
  wire                     loopback_valid;
  wire                     loopback_ready;

  simple_fifo # (
    .ADDR_WIDTH($clog2(4*CORE_COUNT)),
    .DATA_WIDTH(DATA_WIDTH+CORE_ID_WIDTH)
  ) desc_loopback (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
  
    .din_valid(ctrl_s_axis_tvalid && (msg_type==1)),
    .din({ctrl_s_axis_tuser,ctrl_s_axis_tdata}),
    .din_ready(loopback_in_ready),
   
    .dout_valid(loopback_valid),
    .dout({loopback_dest,loopback_data}),
    .dout_ready(loopback_ready)
  );

  assign ctrl_s_axis_tready = ((|(rx_desc_slot_accept & (1<<ctrl_s_axis_tuser))) && (msg_type==0)) ||
                                 (loopback_in_ready && (msg_type==1)) || 
                                 (loader_ready && (msg_type==3));

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
  assign ctrl_m_axis_tdata  = core_reset_in_prog ? 64'hFFFFFFFF_FFFFFFFE : {4'd0,loopback_data[DATA_WIDTH-5:0]};
  assign ctrl_m_axis_tvalid = core_reset_in_prog || loopback_valid;
  assign ctrl_m_axis_tlast  = ctrl_m_axis_tvalid;
  assign ctrl_m_axis_tdest  = core_reset_in_prog ? reordered_core_rst_counter : loopback_dest;

  assign loopback_ready = (!core_reset_in_prog) && ctrl_m_axis_tready;

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
       rx_axis_tkeep,
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
       rx_axis_tlast,
       sending_last_word
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
