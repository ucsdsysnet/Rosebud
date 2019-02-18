module dma_controller # (
    parameter DATA_WIDTH = 64,   
    parameter ADDR_WIDTH = CORE_LEAD_ZERO+CORE_NO_WIDTH,
    parameter ID_WIDTH   = 8,
    parameter LEN_WIDTH  = 20,
    parameter TAG_WIDTH  = 8,
    parameter CORE_COUNT = 8,
    parameter SLOT_COUNT = 16,
    parameter SLOT_ADDR_WIDTH = 15,
    parameter SLOT_LEAD_ZERO  = 8,
    parameter CORE_LEAD_ZERO  = 16,
    
    parameter STRB_WIDTH = (DATA_WIDTH/8),
    parameter CORE_NO_WIDTH = $clog2(CORE_COUNT),
    parameter SLOT_NO_WIDTH = $clog2(SLOT_COUNT),
    parameter CORE_FLAG_SIZE = SLOT_COUNT+4,
    parameter ERR_FLAG_SIZE = CORE_COUNT+2,
    parameter FIFO_WIDTH = CORE_NO_WIDTH + SLOT_NO_WIDTH,
    parameter SLOT_ADDR_EFF = SLOT_ADDR_WIDTH-SLOT_LEAD_ZERO

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
    output wire [ADDR_WIDTH-1:0]     s_axis_tx_desc_addr,  
    output wire [LEN_WIDTH-1:0]      s_axis_tx_desc_len,   
    output wire [TAG_WIDTH-1:0]      s_axis_tx_desc_tag,   
    output wire                      s_axis_tx_desc_user,  
    output wire                      s_axis_tx_desc_valid, 
    input  wire                      s_axis_tx_desc_ready, 

    /*
     * Receive descriptor output
     */
    output wire [ADDR_WIDTH-1:0]     s_axis_rx_desc_addr,
    output wire [LEN_WIDTH-1:0]      s_axis_rx_desc_len,
    output wire [TAG_WIDTH-1:0]      s_axis_rx_desc_tag,
    output wire                      s_axis_rx_desc_valid,
    input  wire                      s_axis_rx_desc_ready,

    // Messages from MAC
    input  wire                      incoming_pkt_ready,
    input  wire                      pkt_sent_to_core_valid,
    input  wire [LEN_WIDTH-1:0]      pkt_sent_to_core_len,
    input  wire                      pkt_sent_out_valid,
    
    // Connections to PCI-e controller 
    input  wire [CORE_COUNT-1:0]     drop_list,
    input  wire                      drop_list_valid,
    input  wire [LEN_WIDTH-1:0]      max_pkt_len,
    input  wire                      max_pkt_len_valid,

    input  wire [FIFO_WIDTH-1:0]     inject_rx_desc,
    input  wire                      inject_rx_desc_valid,
    output wire                      inject_rx_desc_ready,

    input  wire [SLOT_NO_WIDTH-1:0]  slot_addr_wr_no,
    input  wire [SLOT_ADDR_EFF-1:0]  slot_addr_wr_data,
    input  wire                      slot_addr_wr_valid,

    input  wire [CORE_NO_WIDTH-1:0]  core_status_rd_addr,
    input  wire                      core_status_rd_valid,
    output wire [CORE_FLAG_SIZE-1:0] core_status,
    output wire                      core_status_valid,

    // Connection to cores
    input  wire [CORE_COUNT-1:0]     core_msg,

    // Error outputs
    output wire                      err,
    output wire [ERR_FLAG_SIZE-1:0]  err_type
);
    
parameter FIFO_ADDR_WIDTH = $clog2(CORE_COUNT * SLOT_COUNT);
    
wire [FIFO_WIDTH-1:0] rx_desc;
wire [FIFO_WIDTH-1:0] dma_rx_desc;
wire                  dma_rx_desc_valid;
wire [FIFO_WIDTH-1:0] rx_desc_fifo_data;
wire                  rx_desc_fifo_ready;
wire                  rx_desc_fifo_v;
wire                  rx_desc_fifo_pop;

assign inject_rx_desc_ready = !dma_rx_desc_valid && rx_desc_fifo_ready;
assign rx_desc              = dma_rx_desc_valid ? dma_rx_desc : inject_rx_desc;
wire rx_desc_fifo_err       = dma_rx_desc_valid && !rx_desc_fifo_ready;

simple_fifo # (
  .ADDR_WIDTH(FIFO_ADDR_WIDTH),
  .DATA_WIDTH(FIFO_WIDTH)
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

wire [CORE_NO_WIDTH-1:0] rx_desc_core = rx_desc_fifo_data[FIFO_WIDTH-1:SLOT_NO_WIDTH];
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

reg [SLOT_NO_WIDTH-1:0] read_flag_bin;
reg [SLOT_ADDR_EFF-1:0] slot_addr_mem [0:SLOT_COUNT];
reg [SLOT_ADDR_EFF-1:0] rx_desc_slot_addr;
reg [SLOT_ADDR_EFF-1:0] tx_desc_slot_addr;
always @ (posedge clk) begin
  if (slot_addr_wr_valid)
    slot_addr_mem[slot_addr_wr_no] <= slot_addr_wr_data;
  rx_desc_slot_addr <= slot_addr_mem[rx_desc_slot];
  tx_desc_slot_addr <= slot_addr_mem[read_flag_bin];
end

wire drop = |(rx_desc_core_1hot_r & drop_list_r);
wire [ADDR_WIDTH-1:0] rx_desc_addr = {rx_desc_core_r , 
                    {(CORE_LEAD_ZERO-SLOT_ADDR_WIDTH){1'b0}}, 
                    rx_desc_slot_addr, {SLOT_LEAD_ZERO-4{1'b0}},4'h8};

reg [LEN_WIDTH-1:0] max_pkt_len_r;
always @ (posedge clk)
  if (rst) 
    max_pkt_len_r <= 1000; // {LEN_WIDTH{1'b0}};
  else if (max_pkt_len_valid)
    max_pkt_len_r <= max_pkt_len;

wire [TAG_WIDTH-1:0]   s_axis_rx_desc_tag_reg  ;
wire [LEN_WIDTH-1:0]   s_axis_rx_desc_len_reg  ;
wire [ADDR_WIDTH-1:0]  s_axis_rx_desc_addr_reg ;
wire                   s_axis_rx_desc_valid_reg;

assign s_axis_rx_desc_tag_reg   = {TAG_WIDTH{1'b0}};
assign s_axis_rx_desc_len_reg   = max_pkt_len_r;
assign s_axis_rx_desc_addr_reg  = rx_desc_addr;
assign s_axis_rx_desc_valid_reg = rx_desc_fifo_v_r && 
                                  (!drop) && incoming_pkt_ready;

assign rx_desc_fifo_pop = (rx_desc_fifo_v_r && drop) 
                          || (|s_axis_rx_desc_valid);

assign s_axis_rx_desc_addr  = s_axis_rx_desc_addr_reg;
assign s_axis_rx_desc_len   = s_axis_rx_desc_len_reg;
assign s_axis_rx_desc_valid = s_axis_rx_desc_valid_reg;
assign s_axis_rx_desc_tag   = 0;

reg [CORE_NO_WIDTH-1:0] rx_desc_core_no_latched;
reg [SLOT_NO_WIDTH-1:0] rx_desc_slot_no_latched;
reg [SLOT_ADDR_EFF-1:0] rx_desc_slot_addr_latched;

always @ (posedge clk) 
    if (s_axis_rx_desc_valid) begin
      rx_desc_core_no_latched   <= rx_desc_core_r;
      rx_desc_slot_no_latched   <= rx_desc_slot_r;
      rx_desc_slot_addr_latched <= rx_desc_slot_addr;
    end

// Core select
reg  [CORE_COUNT-1:0] core_mask;
wire [CORE_COUNT-1:0] core_msg_masked = core_msg & core_mask;
reg  [CORE_NO_WIDTH-1:0] turn;

always @ (posedge clk)
  if (rst)
    turn <= {CORE_NO_WIDTH{1'b0}};
  else
    turn <= turn + {{(CORE_NO_WIDTH-1){1'b0}},1'b1};

// barrel shifter
reg [CORE_COUNT-1:0] shifted_core_msg;
always@(posedge clk)
  if (rst)
    shifted_core_msg <= {CORE_COUNT{1'b0}};
  else
    shifted_core_msg <= ({core_msg_masked,core_msg_masked} >> turn);

integer j;
reg [CORE_NO_WIDTH-1:0] core_sel_penc;
always@(*) begin
  core_sel_penc = {CORE_COUNT{1'b0}};
  for (j=CORE_COUNT-1;j>=0;j=j-1)
    if (shifted_core_msg[j])
      core_sel_penc = j;
end

reg [CORE_NO_WIDTH-1:0] core_sel;
reg core_msg_valid;
always @ (posedge clk)
  if (rst)
    core_msg_valid <= 1'b0;
  else begin
    core_sel       <= core_sel_penc + turn - 1;
    core_msg_valid <= |(shifted_core_msg);
  end

wire [CORE_COUNT-1:0] core_sel_1hot = ({{(CORE_COUNT-1){1'b0}},1'b1}) << core_sel;

// if a core is selected, the mask bit should become zero until 
// core msg becoems zero. 
always@ (posedge clk)
  if (rst)
    core_mask <= {CORE_COUNT{1'b1}};
  else
    if (core_msg_valid)
      core_mask <= (core_mask & ~core_sel_1hot) | (~core_msg & ~core_mask);
    else
      core_mask <= core_mask | (~core_msg & ~core_mask);

// core status register read request
reg rd_req_attempt;
reg [ADDR_WIDTH-1:0]  m_axi_araddr_reg;
reg m_axi_arvalid_reg;
reg [ID_WIDTH-1:0] m_axi_arid_reg;
always @ (posedge clk)
  if (rst) begin 
    m_axi_arvalid_reg <= 1'b0;
    rd_req_attempt    <= 1'b0;
  end else begin
    if (core_msg_valid) begin
      m_axi_araddr_reg  <= {core_sel,16'h8000};
      m_axi_arvalid_reg <= 1'b1;
      m_axi_arid_reg    <= core_sel;
      rd_req_attempt    <= 1'b1;
    end
    else if (rd_req_attempt && m_axi_arready) begin
      m_axi_arvalid_reg <= 1'b0;
      rd_req_attempt    <= 1'b0;
    end
  end

assign m_axi_arlock  = 1'b0;
assign m_axi_arcache = 4'd3;
assign m_axi_arprot  = 3'b010;
assign m_axi_arlen   = 8'd0;
assign m_axi_arsize  = 3'b011;
assign m_axi_arburst = 2'b01;
assign m_axi_arid    = m_axi_arid_reg;
assign m_axi_araddr  = m_axi_araddr_reg;
assign m_axi_arvalid = m_axi_arvalid_reg;

// write trigger
reg [ADDR_WIDTH-1:0]  m_axi_awaddr_reg;
reg [ID_WIDTH-1:0]  m_axi_awid_reg;
reg m_axi_awvalid_reg;
reg awr_req_attempt;

wire [ADDR_WIDTH-1:0] trigger_addr;
assign trigger_addr = {rx_desc_core_no_latched, 
                    {(CORE_LEAD_ZERO  - 9){1'b0}} , 1'b1, {(7 - SLOT_NO_WIDTH){1'b0}},
                    rx_desc_slot_no_latched, 1'b0};

wire trigger_send_valid = pkt_sent_to_core_valid;

always @ (posedge clk)
  if (rst) begin 
    m_axi_awvalid_reg <= 1'b0;
    awr_req_attempt   <= 1'b0;
  end else begin
    if (trigger_send_valid) begin
      m_axi_awaddr_reg  <= trigger_addr;
      m_axi_awid_reg    <= rx_desc_core_no_latched;
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
assign m_axi_awid    = m_axi_awid_reg;
assign m_axi_awaddr  = m_axi_awaddr_reg;
assign m_axi_awvalid = m_axi_awvalid_reg;

reg wr_req_attempt;
reg m_axi_wvalid_reg;
reg [DATA_WIDTH-1:0]  m_axi_wdata_reg;
reg [STRB_WIDTH-1:0]  m_axi_wstrb_reg;
reg                   m_axi_wlast_reg;

wire [15:0] slot_flag = (16'd1 << rx_desc_slot_no_latched);
wire [15:0] core_slot_addr = {rx_desc_slot_addr_latched, {SLOT_LEAD_ZERO{1'b0}}};

always @ (posedge clk)
  if (rst) begin 
    m_axi_wvalid_reg <= 1'b0;
    wr_req_attempt   <= 1'b0;
  end else begin
    if (trigger_send_valid) begin
      m_axi_wvalid_reg <= 1'b1;
      m_axi_wdata_reg  <= {16'd0,core_slot_addr,pkt_sent_to_core_len[15:0],slot_flag};
      m_axi_wstrb_reg  <= 8'hFF;
      m_axi_wlast_reg  <= 1'b1;
      wr_req_attempt   <= 1'b1;
    end
    else if (wr_req_attempt && m_axi_wready) begin
      m_axi_wvalid_reg <= 1'b0;
      wr_req_attempt   <= 1'b0;
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

// decode read response and send read desc

assign m_axi_rready = 1'b1;

wire [SLOT_COUNT-1:0] read_flags = m_axi_rdata[SLOT_COUNT-1:0];

integer k;
always @ (*)
  for (k=0; k<SLOT_COUNT; k=k+1)
    if (read_flags == (1<<k))
      read_flag_bin = k;

reg [SLOT_NO_WIDTH-1:0] read_slot_r;
reg m_axi_rvalid_r;
reg read_flags_not_zero;
reg [ID_WIDTH-1:0] m_axi_rid_r;
reg [15:0] read_pkt_len;
always @ (posedge clk)
  if (rst) begin
    m_axi_rvalid_r      <= 1'b0;
    read_flags_not_zero <= 1'b0;
  end else begin
    m_axi_rvalid_r      <= m_axi_rvalid;
    read_flags_not_zero <= |read_flags;
    m_axi_rid_r         <= m_axi_rid;
    read_pkt_len        <= m_axi_rdata[31:16];
    read_slot_r         <= read_flag_bin;
  end

wire [ADDR_WIDTH-1:0] read_slot_addr = {m_axi_rid_r[CORE_NO_WIDTH-1:0],
                      {(CORE_LEAD_ZERO-SLOT_ADDR_WIDTH){1'b0}},
                      tx_desc_slot_addr, {(SLOT_LEAD_ZERO-4){1'b0}}, 4'd8};

// send tx desc
reg [ADDR_WIDTH-1:0]  s_axis_tx_desc_addr_reg;
reg [LEN_WIDTH-1:0]   s_axis_tx_desc_len_reg;
reg                   s_axis_tx_desc_valid_reg;

always @ (posedge clk)
  if (rst) begin 
      s_axis_tx_desc_valid_reg <= 1'b0;
  end else begin
    if (s_axis_tx_desc_valid_reg) begin
      s_axis_tx_desc_valid_reg <= 1'b0;
    end else if (m_axi_rvalid_r && read_flags_not_zero) begin
      s_axis_tx_desc_addr_reg   <= read_slot_addr;
      s_axis_tx_desc_len_reg    <= {4'd0, read_pkt_len};
      s_axis_tx_desc_valid_reg  <= 1'b1;
    end
  end

assign s_axis_tx_desc_addr  = s_axis_tx_desc_addr_reg;
assign s_axis_tx_desc_len   = s_axis_tx_desc_len_reg;
assign s_axis_tx_desc_valid = s_axis_tx_desc_valid_reg;
assign s_axis_tx_desc_tag   = 0;
assign s_axis_tx_desc_user  = 0;

reg [CORE_NO_WIDTH-1:0] tx_desc_core_no_latched;
reg [SLOT_NO_WIDTH-1:0] tx_desc_slot_no_latched;

always @ (posedge clk) 
    if (s_axis_tx_desc_valid) begin
      tx_desc_core_no_latched   <= m_axi_rid_r[CORE_NO_WIDTH-1:0];
      tx_desc_slot_no_latched   <= read_slot_r;
    end

assign dma_rx_desc = {tx_desc_core_no_latched, tx_desc_slot_no_latched};
assign dma_rx_desc_valid = pkt_sent_out_valid;

endmodule
