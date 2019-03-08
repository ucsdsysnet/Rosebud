module dma_controller # (
    parameter DATA_WIDTH           = 64,   
    parameter CORE_COUNT           = 16,
    parameter SLOT_COUNT           = 16,
    parameter SLOT_LEAD_ZERO       = 8,
    parameter RX_WRITE_OFFSET      = 8'h0A,
    parameter CORE_ADDR_WIDTH      = 16,
    parameter SLOT_ADDR_WIDTH      = CORE_ADDR_WIDTH-1,
    parameter SLOT_ADDR_EFF        = SLOT_ADDR_WIDTH-SLOT_LEAD_ZERO,
    parameter DESC_WIDTH           = CORE_NO_WIDTH+SLOT_NO_WIDTH,
    parameter DEF_MAX_PKT_LEN      = 16'd2048,

    parameter CORE_NO_WIDTH        = $clog2(CORE_COUNT),
    parameter SLOT_NO_WIDTH        = $clog2(SLOT_COUNT),
    parameter ADDR_WIDTH           = CORE_ADDR_WIDTH+CORE_NO_WIDTH,
    parameter STRB_WIDTH           = (DATA_WIDTH/8),
    parameter ID_WIDTH             = 8,
    parameter LEN_WIDTH            = 16,
    parameter TAG_WIDTH            = 8,
    
    parameter CORE_FLAG_SIZE       = SLOT_COUNT+8,
    parameter ERR_FLAG_SIZE        = CORE_COUNT+2,

    parameter DESC_FIFO_ADDR_WIDTH = $clog2(CORE_COUNT * SLOT_COUNT)
)
(
    input  wire                      clk,
    input  wire                      rst,

    /*
     * AXI master interface
     */
    output wire [ID_WIDTH-1:0]       m_axi_awid,
    output wire [ADDR_WIDTH-1:0]     m_axi_awaddr,
    output wire [7:0]                m_axi_awlen,
    output wire [2:0]                m_axi_awsize,
    output wire [1:0]                m_axi_awburst,
    output wire                      m_axi_awlock,
    output wire [3:0]                m_axi_awcache,
    output wire [2:0]                m_axi_awprot,
    output wire                      m_axi_awvalid,
    input  wire                      m_axi_awready,
    output wire [DATA_WIDTH-1:0]     m_axi_wdata,
    output wire [STRB_WIDTH-1:0]     m_axi_wstrb,
    output wire                      m_axi_wlast,
    output wire                      m_axi_wvalid,
    input  wire                      m_axi_wready,
    input  wire [ID_WIDTH-1:0]       m_axi_bid,
    input  wire [1:0]                m_axi_bresp,
    input  wire                      m_axi_bvalid,
    output wire                      m_axi_bready,
    output wire [ID_WIDTH-1:0]       m_axi_arid,
    output wire [ADDR_WIDTH-1:0]     m_axi_araddr,
    output wire [7:0]                m_axi_arlen,
    output wire [2:0]                m_axi_arsize,
    output wire [1:0]                m_axi_arburst,
    output wire                      m_axi_arlock,
    output wire [3:0]                m_axi_arcache,
    output wire [2:0]                m_axi_arprot,
    output wire                      m_axi_arvalid,
    input  wire                      m_axi_arready,
    input  wire [ID_WIDTH-1:0]       m_axi_rid,
    input  wire [DATA_WIDTH-1:0]     m_axi_rdata,
    input  wire [1:0]                m_axi_rresp,
    input  wire                      m_axi_rlast,
    input  wire                      m_axi_rvalid,
    output wire                      m_axi_rready,
 
    /*
     * Transmit descriptor output
     */
    output wire [2*ADDR_WIDTH-1:0]   s_axis_tx_desc_addr,  
    output wire [2*LEN_WIDTH-1:0]    s_axis_tx_desc_len,   
    output wire [2*TAG_WIDTH-1:0]    s_axis_tx_desc_tag,   
    output wire [2-1:0]              s_axis_tx_desc_user,  
    output wire [2-1:0]              s_axis_tx_desc_valid, 
    input  wire [2-1:0]              s_axis_tx_desc_ready, 

    /*
     * Receive descriptor output
     */
    output wire [2*ADDR_WIDTH-1:0]   s_axis_rx_desc_addr,
    output wire [2*LEN_WIDTH-1:0]    s_axis_rx_desc_len,
    output wire [2*TAG_WIDTH-1:0]    s_axis_rx_desc_tag,
    output wire [2-1:0]              s_axis_rx_desc_valid,
    input  wire [2-1:0]              s_axis_rx_desc_ready,

    // Messages from MAC
    input  wire [2-1:0]              incoming_pkt_ready,
    input  wire [2*LEN_WIDTH-1:0]    pkt_sent_to_core_len,
    input  wire [2-1:0]              pkt_sent_to_core_valid,
    input  wire [2-1:0]              pkt_sent_out_valid,
    
    // Configuration
    input  wire [CORE_COUNT-1:0]     drop_list,
    input  wire                      drop_list_valid,
    input  wire [LEN_WIDTH-1:0]      max_pkt_len,
    input  wire                      max_pkt_len_valid,

    input  wire [DESC_WIDTH-1:0]     inject_rx_desc,
    input  wire                      inject_rx_desc_valid,
    output wire                      inject_rx_desc_ready,

    input  wire [SLOT_NO_WIDTH-1:0]  slot_addr_wr_no,
    input  wire [SLOT_ADDR_EFF-1:0]  slot_addr_wr_data,
    input  wire                      slot_addr_wr_valid,

    // Status readback 
    input  wire [CORE_NO_WIDTH-1:0]  core_status_rd_addr,
    input  wire                      core_status_rd_valid,
    output wire [CORE_FLAG_SIZE-1:0] core_status,
    output wire                      core_status_valid,

    // Error outputs
    output wire                      err,
    output wire [ERR_FLAG_SIZE-1:0]  err_type,
    
    // Connection to cores
    input  wire [63:0]               msg_data,
    input  wire                      msg_valid,
    input  wire [CORE_NO_WIDTH-1:0]  msg_core_no,
    output wire                      msg_ready
);

// rx desc generation
wire [DESC_WIDTH-1:0] rx_desc;
wire [DESC_WIDTH-1:0] dma_rx_desc;
wire                  dma_rx_desc_valid;
wire [DESC_WIDTH-1:0] rx_desc_fifo_data;
wire                  rx_desc_fifo_ready;
wire                  rx_desc_fifo_v;
wire                  rx_desc_fifo_pop;

assign inject_rx_desc_ready = !dma_rx_desc_valid && rx_desc_fifo_ready;
assign rx_desc              = dma_rx_desc_valid ? dma_rx_desc : inject_rx_desc;
wire   rx_desc_fifo_err     = (dma_rx_desc_valid || inject_rx_desc_valid) && !rx_desc_fifo_ready;

simple_fifo # (
  .ADDR_WIDTH(DESC_FIFO_ADDR_WIDTH),
  .DATA_WIDTH(DESC_WIDTH)
) rx_desc_fifo (
  .clk(clk),
  .rst(rst),

  .din_valid(dma_rx_desc_valid | inject_rx_desc_valid),
  .din(rx_desc),
  .din_ready(rx_desc_fifo_ready),
 
  .dout_valid(rx_desc_fifo_v),
  .dout(rx_desc_fifo_data),
  .dout_ready(rx_desc_fifo_pop)
);
    
reg [CORE_COUNT-1:0] drop_list_r;
always @ (posedge clk)
  if (rst) 
    drop_list_r <= {CORE_COUNT{1'b0}};
  else if (drop_list_valid)
    drop_list_r <= drop_list;

reg rx_desc_fifo_v_r;
always @ (posedge clk) begin
  rx_desc_fifo_v_r  <= rx_desc_fifo_v & !rx_desc_fifo_pop;
end

wire [CORE_NO_WIDTH-1:0] rx_desc_core = rx_desc_fifo_data[DESC_WIDTH-1:SLOT_NO_WIDTH];
wire [SLOT_NO_WIDTH-1:0] rx_desc_slot = rx_desc_fifo_data[SLOT_NO_WIDTH-1:0];

reg [CORE_COUNT-1:0] rx_desc_core_1hot_r;
reg [CORE_NO_WIDTH-1:0] rx_desc_core_r;
reg [SLOT_NO_WIDTH-1:0] rx_desc_slot_r;
integer i;
always @ (posedge clk) begin
  rx_desc_core_r      <= rx_desc_core;
  rx_desc_slot_r      <= rx_desc_slot;
  rx_desc_core_1hot_r <= {CORE_COUNT{1'b0}};
  for (i=0;i<CORE_COUNT;i=i+1)
    if (rx_desc_core == i)
      rx_desc_core_1hot_r[i] <= 1'b1; // Might need to push one hot after reg to meet timing
end

reg [SLOT_ADDR_EFF-1:0] slot_addr_mem [0:SLOT_COUNT];
reg [SLOT_ADDR_EFF-1:0] rx_desc_slot_addr;
always @ (posedge clk) begin
  if (slot_addr_wr_valid)
    slot_addr_mem[slot_addr_wr_no] <= slot_addr_wr_data;
  rx_desc_slot_addr <= slot_addr_mem[rx_desc_slot];
end

wire drop = |(rx_desc_core_1hot_r & drop_list_r);
wire [ADDR_WIDTH-1:0] rx_desc_addr = {rx_desc_core_r , 
                    {(CORE_ADDR_WIDTH-SLOT_ADDR_WIDTH){1'b0}}, 
                    rx_desc_slot_addr, RX_WRITE_OFFSET};

reg [LEN_WIDTH-1:0] max_pkt_len_r;
always @ (posedge clk)
  if (rst) 
    max_pkt_len_r <= DEF_MAX_PKT_LEN; 
  else if (max_pkt_len_valid)
    max_pkt_len_r <= max_pkt_len;

wire [2-1:0] ready_to_send;
assign ready_to_send[0] = rx_desc_fifo_v_r && (!drop) && s_axis_rx_desc_ready[0];
assign ready_to_send[1] = rx_desc_fifo_v_r && (!drop) && s_axis_rx_desc_ready[1];

reg [9:0] rx_pkt_counter [0:1];
always @ (posedge clk)
  if (rst)
    rx_pkt_counter[0] <= 10'd0;
  else if (ready_to_send[0] && !incoming_pkt_ready[0] && (rx_pkt_counter[0]>0) && !in_port_sel)
    rx_pkt_counter[0] <= rx_pkt_counter[0] - 10'd1;
  else if ((~ready_to_send[0] || in_port_sel) && incoming_pkt_ready[0])
    rx_pkt_counter[0] <= rx_pkt_counter[0] + 10'd1;

always @ (posedge clk)
  if (rst)
    rx_pkt_counter[1] <= 10'd0;
  else if (ready_to_send[1] && !incoming_pkt_ready[1] && (rx_pkt_counter[1]>0) && in_port_sel)
    rx_pkt_counter[1] <= rx_pkt_counter[1] - 10'd1;
  else if ((~ready_to_send[1] || !in_port_sel) && incoming_pkt_ready[1])
    rx_pkt_counter[1] <= rx_pkt_counter[1] + 10'd1;

wire [2-1:0] can_receive;
assign can_receive[0] = ready_to_send[0] && ((rx_pkt_counter[0]>0) || incoming_pkt_ready[0]);
assign can_receive[1] = ready_to_send[1] && ((rx_pkt_counter[1]>0) || incoming_pkt_ready[1]);

reg in_port_sel, last_in_port_sel;

always @ (*) begin
  in_port_sel = last_in_port_sel;
  if (last_in_port_sel && can_receive[0])
    in_port_sel = 1'b0;
  else if (!last_in_port_sel && can_receive[1])
    in_port_sel = 1'b1;
end   

always @ (posedge clk) 
  if (rst)
    last_in_port_sel <= 1'b1;
  else if (|s_axis_rx_desc_valid)
    last_in_port_sel <= in_port_sel;

assign s_axis_rx_desc_tag      = {2*TAG_WIDTH{1'b0}};
assign s_axis_rx_desc_len      = {max_pkt_len_r,max_pkt_len_r};
assign s_axis_rx_desc_addr     = {rx_desc_addr,rx_desc_addr};

assign s_axis_rx_desc_valid[0] = can_receive[0] && !in_port_sel;
assign s_axis_rx_desc_valid[1] = can_receive[1] && in_port_sel;

assign rx_desc_fifo_pop = (rx_desc_fifo_v_r && drop) || (|s_axis_rx_desc_valid);

// trigger fifos per port. saving core, slot and slot address after sending rx_desc
wire [2-1:0] trigger_fifo_v;
wire [2-1:0] trigger_fifo_ready;
wire [CORE_NO_WIDTH-1:0] trigger_fifo_core_no [0:1];
wire [SLOT_NO_WIDTH-1:0] trigger_fifo_slot_no [0:1];
wire [SLOT_ADDR_EFF-1:0] trigger_fifo_slot_addr [0:1];
wire [2-1:0] trigger_fifo_err;
reg  trigger_accepted;
reg sent_trigger_port;

simple_fifo # (
  .ADDR_WIDTH($clog2(2*CORE_COUNT)),
  .DATA_WIDTH(CORE_NO_WIDTH+SLOT_NO_WIDTH+SLOT_ADDR_EFF)
) trigger_fifo_0 (
  .clk(clk),
  .rst(rst),

  .din_valid(s_axis_rx_desc_valid[0]),
  .din({rx_desc_core_r,rx_desc_slot_r,rx_desc_slot_addr}),
  .din_ready(trigger_fifo_ready[0]),
 
  .dout_valid(trigger_fifo_v[0]),
  .dout({trigger_fifo_core_no[0], trigger_fifo_slot_no[0], trigger_fifo_slot_addr[0]}),
  .dout_ready(trigger_accepted && !sent_trigger_port)
);

assign trigger_fifo_err[0] = s_axis_rx_desc_valid[0] && !trigger_fifo_ready[0];

simple_fifo # (
  .ADDR_WIDTH($clog2(2*CORE_COUNT)),
  .DATA_WIDTH(CORE_NO_WIDTH+SLOT_NO_WIDTH+SLOT_ADDR_EFF)
) trigger_fifo_1 (
  .clk(clk),
  .rst(rst),

  .din_valid(s_axis_rx_desc_valid[1]),
  .din({rx_desc_core_r,rx_desc_slot_r,rx_desc_slot_addr}),
  .din_ready(trigger_fifo_ready[1]),
 
  .dout_valid(trigger_fifo_v[1]),
  .dout({trigger_fifo_core_no[1], trigger_fifo_slot_no[1], trigger_fifo_slot_addr[1]}),
  .dout_ready(trigger_accepted && sent_trigger_port)
);

assign trigger_fifo_err[1] = s_axis_rx_desc_valid[1] && !trigger_fifo_ready[1];
  
// There is no read operation
assign m_axi_arlock  = 1'b0;
assign m_axi_arcache = 4'd3;
assign m_axi_arprot  = 3'b010;
assign m_axi_arlen   = 8'd0;
assign m_axi_arsize  = 3'b011;
assign m_axi_arburst = 2'b01;
assign m_axi_arid    = {ID_WIDTH{1'b0}};  
assign m_axi_araddr  = {ADDR_WIDTH{1'b0}}; 
assign m_axi_arvalid = 1'b0;  
assign m_axi_rready  = 1'b0;

// packet_sent_to_core fifo, saving len of packets sent to cores by each port
wire [LEN_WIDTH-1:0] len_fifo_data[0:1];
wire [2-1:0]         len_fifo_v;
wire [2-1:0]         len_fifo_ready;

// Pop happens one cycle after data is latched, but since we cannot
// take data next cycle it is ok for valid to remain high
simple_fifo # (
  .ADDR_WIDTH($clog2(CORE_COUNT)),
  .DATA_WIDTH(LEN_WIDTH)
) len_fifo_0 (
  .clk(clk),
  .rst(rst),

  .din_valid(pkt_sent_to_core_valid[0]),
  .din(pkt_sent_to_core_len[0*LEN_WIDTH +: LEN_WIDTH]),
  .din_ready(len_fifo_ready[0]),
 
  .dout_valid(len_fifo_v[0]),
  .dout(len_fifo_data[0]),
  .dout_ready(trigger_accepted && !sent_trigger_port)
);

wire len_fifo_0_err = (pkt_sent_to_core_valid[0]) && !len_fifo_ready[0];

simple_fifo # (
  .ADDR_WIDTH($clog2(CORE_COUNT)),
  .DATA_WIDTH(LEN_WIDTH)
) len_fifo_1 (
  .clk(clk),
  .rst(rst),

  .din_valid(pkt_sent_to_core_valid[1]),
  .din(pkt_sent_to_core_len[1*LEN_WIDTH +: LEN_WIDTH]),
  .din_ready(len_fifo_ready[1]),
 
  .dout_valid(len_fifo_v[1]),
  .dout(len_fifo_data[1]),
  .dout_ready(trigger_accepted && sent_trigger_port)
);

wire len_fifo_1_err = (pkt_sent_to_core_valid[1]) && !len_fifo_ready[1];

// write trigger

// Selecting trigger for one of the ports
reg trigger_port_sel, last_trigger_port_sel;
always @ (*) begin
  trigger_port_sel = last_trigger_port_sel;
  if (last_trigger_port_sel && trigger_fifo_v[0])
    trigger_port_sel = 1'b0;
  else if (!last_trigger_port_sel && trigger_fifo_v[1])
    trigger_port_sel = 1'b1;
end   

always @ (posedge clk) 
  if (rst)
    last_trigger_port_sel <= 1'b1;
  else if (|trigger_fifo_v)
    last_trigger_port_sel <= trigger_port_sel;

wire [CORE_NO_WIDTH-1:0] trigger_fifo_core_no_s   = trigger_fifo_core_no[trigger_port_sel]; 
wire [SLOT_NO_WIDTH-1:0] trigger_fifo_slot_no_s   = trigger_fifo_slot_no[trigger_port_sel]; 
wire [SLOT_ADDR_EFF-1:0] trigger_fifo_slot_addr_s = trigger_fifo_slot_addr[trigger_port_sel];

reg [ADDR_WIDTH-1:0]  m_axi_awaddr_reg;
reg m_axi_awvalid_reg;
reg awr_req_attempt;

wire [ADDR_WIDTH-1:0] trigger_addr;
assign trigger_addr = {trigger_fifo_core_no_s, 
                    {(CORE_ADDR_WIDTH  - 9){1'b0}} , 1'b1, 
                    {(5 - SLOT_NO_WIDTH){1'b0}}, trigger_fifo_slot_no_s, 3'd0};

wire [2-1:0] trigger_send_valid;
assign trigger_send_valid[0] = trigger_fifo_v[0] && !trigger_port_sel && len_fifo_v[0]; 
assign trigger_send_valid[1] = trigger_fifo_v[1] &&  trigger_port_sel && len_fifo_v[1];

always @ (posedge clk)
  if (rst) begin 
    m_axi_awvalid_reg <= 1'b0;
    awr_req_attempt   <= 1'b0;
    m_axi_awaddr_reg  <= {ADDR_WIDTH{1'b0}};
  end else begin
    if ((|trigger_send_valid) && !awr_req_attempt && !wr_req_attempt) begin
      m_axi_awaddr_reg  <= trigger_addr;
      m_axi_awvalid_reg <= 1'b1;
      awr_req_attempt   <= 1'b1;
    end
    else if (awr_req_attempt && m_axi_awready) begin
      m_axi_awvalid_reg <= 1'b0;
      awr_req_attempt   <= 1'b0;
    end
  end
      
assign m_axi_awlock  = 1'b0;
assign m_axi_awcache = 4'd3;
assign m_axi_awprot  = 3'b010;
assign m_axi_awlen   = 8'd0;
assign m_axi_awsize  = 3'b011;
assign m_axi_awburst = 2'b01;
assign m_axi_awid    = {ID_WIDTH{1'b0}};  
assign m_axi_awaddr  = m_axi_awaddr_reg;
assign m_axi_awvalid = m_axi_awvalid_reg;

reg wr_req_attempt;
reg m_axi_wvalid_reg;
reg [DATA_WIDTH-1:0]  m_axi_wdata_reg;
reg [STRB_WIDTH-1:0]  m_axi_wstrb_reg;
reg                   m_axi_wlast_reg;

wire [23:0] core_slot_addr = {{(24-SLOT_LEAD_ZERO-SLOT_ADDR_EFF){1'b0}},
                              trigger_fifo_slot_addr_s, {SLOT_LEAD_ZERO{1'b0}}};
wire [7:0]  core_slot_no   = {{(8-SLOT_NO_WIDTH){1'b0}}, trigger_fifo_slot_no_s};
wire [7:0]  incoming_port  = {7'd0,trigger_port_sel};
wire [15:0] trigger_pkt_len  = len_fifo_data[trigger_port_sel];

always @ (posedge clk)
  if (rst) begin 
    m_axi_wvalid_reg <= 1'b0;
    wr_req_attempt   <= 1'b0;
    trigger_accepted <= 1'b0;
  end else begin
    trigger_accepted <= 1'b0;
    if (|trigger_send_valid && !wr_req_attempt && !awr_req_attempt) begin
      m_axi_wvalid_reg  <= 1'b1;
      m_axi_wdata_reg   <= {8'd0, core_slot_addr, core_slot_no,
                            incoming_port, trigger_pkt_len};
      m_axi_wstrb_reg   <= 8'hFF;
      m_axi_wlast_reg   <= 1'b1;
      wr_req_attempt    <= 1'b1;
      trigger_accepted  <= 1'b1;
      sent_trigger_port <= trigger_port_sel;
    end
    else if (wr_req_attempt && m_axi_wready) begin
      m_axi_wvalid_reg  <= 1'b0;
      wr_req_attempt    <= 1'b0;
    end
  end

assign m_axi_wvalid = m_axi_wvalid_reg;
assign m_axi_wdata  = m_axi_wdata_reg;
assign m_axi_wstrb  = m_axi_wstrb_reg;
assign m_axi_wlast  = m_axi_wlast_reg;

// check for errors in write response, for now it doesn't stay on forever
assign m_axi_bready = 1'b1;
reg write_resp_err;
always @ (posedge clk)
  if (rst)
    write_resp_err <= 1'b0;
  else if (m_axi_bvalid) 
    write_resp_err <= (m_axi_bresp!=2'b00);

// decode core_messages and send read desc
wire [15:0] read_pkt_len = msg_data[15:0];
wire [7:0]  out_port     = msg_data[23:16];
wire [7:0]  read_slot_no = msg_data[31:24];
wire [7:0]  core_errs    = msg_data[63:48];

wire [ADDR_WIDTH-1:0] read_slot_addr = {msg_core_no,
                      msg_data[32+CORE_ADDR_WIDTH-1:32]};
reg  [CORE_NO_WIDTH-1:0] msg_core_no_r;
reg  [SLOT_NO_WIDTH-1:0] read_slot_no_r;

// send tx desc
reg [ADDR_WIDTH-1:0]  s_axis_tx_desc_addr_reg;
reg [LEN_WIDTH-1:0]   s_axis_tx_desc_len_reg;
reg                   s_axis_tx_out_port_reg;
reg                   s_axis_tx_desc_valid_reg;

always @ (posedge clk)
  if (rst) begin 
      s_axis_tx_desc_valid_reg <= 1'b0;
  end else begin
    if (s_axis_tx_desc_valid_reg) begin
      s_axis_tx_desc_valid_reg <= 1'b0;
    end else if (msg_valid && msg_ready) begin // add check for errors here
      s_axis_tx_desc_addr_reg   <= read_slot_addr;
      s_axis_tx_desc_len_reg    <= {{(LEN_WIDTH-16){1'b0}},read_pkt_len};
      s_axis_tx_desc_valid_reg  <= (read_pkt_len!=16'd0); // drop packet
      s_axis_tx_out_port_reg    <= out_port[0];
      msg_core_no_r             <= msg_core_no;
      read_slot_no_r            <= read_slot_no[SLOT_NO_WIDTH-1:0];
    end
  end

assign s_axis_tx_desc_addr     = {s_axis_tx_desc_addr_reg,s_axis_tx_desc_addr_reg};
assign s_axis_tx_desc_len      = {s_axis_tx_desc_len_reg,s_axis_tx_desc_len_reg};
assign s_axis_tx_desc_valid[0] = s_axis_tx_desc_valid_reg && !s_axis_tx_out_port_reg; 
assign s_axis_tx_desc_valid[1] = s_axis_tx_desc_valid_reg && s_axis_tx_out_port_reg;  
assign s_axis_tx_desc_tag      = {(2*TAG_WIDTH){1'b0}};
assign s_axis_tx_desc_user     = 2'd0;

// // There is 1 cycle difference, but if ready is asserted it would stay assertet.
// // And we are latching.   
assign msg_ready = (s_axis_tx_desc_ready[0] && !out_port[0]) ||
                   (s_axis_tx_desc_ready[1] &&  out_port[0]);

wire [CORE_NO_WIDTH-1:0] tx_desc_core_no_latched_0;
wire [SLOT_NO_WIDTH-1:0] tx_desc_slot_no_latched_0;
wire [CORE_NO_WIDTH-1:0] tx_desc_core_no_latched_1;
wire [SLOT_NO_WIDTH-1:0] tx_desc_slot_no_latched_1;
wire tx_desc_fifo_0_v, tx_desc_fifo_1_v;

simple_fifo # (
  .ADDR_WIDTH(1),
  .DATA_WIDTH(CORE_NO_WIDTH+SLOT_NO_WIDTH)
) tx_desc_fifo_0 (
  .clk(clk),
  .rst(rst),

  .din_valid(s_axis_tx_desc_valid[0]),
  .din({msg_core_no_r,read_slot_no_r}),
  .din_ready(),
 
  .dout_valid(tx_desc_fifo_0_v),
  .dout({tx_desc_core_no_latched_0,tx_desc_slot_no_latched_0}),
  .dout_ready(pkt_sent_out_valid[0])
);
 
simple_fifo # (
  .ADDR_WIDTH(1),
  .DATA_WIDTH(CORE_NO_WIDTH+SLOT_NO_WIDTH)
) tx_desc_fifo_1 (
  .clk(clk),
  .rst(rst),

  .din_valid(s_axis_tx_desc_valid[1]),
  .din({msg_core_no_r,read_slot_no_r}),
  .din_ready(),
 
  .dout_valid(tx_desc_fifo_1_v),
  .dout({tx_desc_core_no_latched_1,tx_desc_slot_no_latched_1}),
  .dout_ready(pkt_sent_out_valid[1])
);
 
assign dma_rx_desc = pkt_sent_out_valid[1] ? 
       {tx_desc_core_no_latched_1, tx_desc_slot_no_latched_1}:
       {tx_desc_core_no_latched_0, tx_desc_slot_no_latched_0};
assign dma_rx_desc_valid = |pkt_sent_out_valid;

endmodule
