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
    
    // Configuration
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

reg [SLOT_ADDR_EFF-1:0] slot_addr_mem [0:SLOT_COUNT];
reg [SLOT_ADDR_EFF-1:0] rx_desc_slot_addr;
always @ (posedge clk) begin
  if (slot_addr_wr_valid)
    slot_addr_mem[slot_addr_wr_no] <= slot_addr_wr_data;
  rx_desc_slot_addr <= slot_addr_mem[rx_desc_slot];
end

wire drop = |(rx_desc_core_1hot_r & drop_list_r);
wire [ADDR_WIDTH-1:0] rx_desc_addr = {rx_desc_core_r , 
                    {(CORE_LEAD_ZERO-SLOT_ADDR_WIDTH){1'b0}}, 
                    rx_desc_slot_addr, {(SLOT_LEAD_ZERO-4){1'b0}},4'hA};

reg [LEN_WIDTH-1:0] max_pkt_len_r;
always @ (posedge clk)
  if (rst) 
    max_pkt_len_r <= 1000; // {LEN_WIDTH{1'b0}};
  else if (max_pkt_len_valid)
    max_pkt_len_r <= max_pkt_len;

wire ready_to_send = rx_desc_fifo_v_r && (!drop) && s_axis_rx_desc_ready;
reg [9:0] rx_pkt_counter;
always @ (posedge clk)
  if (rst)
    rx_pkt_counter <= 10'd0;
  else if (ready_to_send && !incoming_pkt_ready && (rx_pkt_counter>0))
    rx_pkt_counter <= rx_pkt_counter - 10'd1;
  else if (~ready_to_send && incoming_pkt_ready)
    rx_pkt_counter <= rx_pkt_counter + 10'd1;
    
assign s_axis_rx_desc_tag   = {TAG_WIDTH{1'b0}};
assign s_axis_rx_desc_len   = max_pkt_len_r;
assign s_axis_rx_desc_addr  = rx_desc_addr;
assign s_axis_rx_desc_valid = ready_to_send && ((rx_pkt_counter>0) || incoming_pkt_ready);

assign rx_desc_fifo_pop = (rx_desc_fifo_v_r && drop) || (s_axis_rx_desc_valid);

// trigger fifo
wire trigger_fifo_ready, trigger_fifo_v;
wire [CORE_NO_WIDTH-1:0] trigger_fifo_core_no;
wire [SLOT_NO_WIDTH-1:0] trigger_fifo_slot_no;
wire [SLOT_ADDR_EFF-1:0] trigger_fifo_slot_addr;
wire trigger_sent;
simple_fifo # (
  .ADDR_WIDTH($clog2(2*CORE_COUNT)),
  .DATA_WIDTH(CORE_NO_WIDTH+SLOT_NO_WIDTH+SLOT_ADDR_EFF)
) trigger_fifo (
  .clk(clk),
  .rst(rst),

  .din_valid(s_axis_rx_desc_valid),
  .din({rx_desc_core_r,rx_desc_slot_r,rx_desc_slot_addr}),
  .din_ready(trigger_fifo_ready),
 
  .dout_valid(trigger_fifo_v),
  .dout({trigger_fifo_core_no, trigger_fifo_slot_no, trigger_fifo_slot_addr}),
  .dout_ready(trigger_sent)
);
 
// There is no read operation
assign m_axi_arlock  = 1'b0;
assign m_axi_arcache = 4'd3;
assign m_axi_arprot  = 3'b010;
assign m_axi_arlen   = 8'd0;
assign m_axi_arsize  = 3'b011;
assign m_axi_arburst = 2'b01;
assign m_axi_arid    = 8'd0;  
assign m_axi_araddr  = 18'd0; 
assign m_axi_arvalid = 1'b0;  
assign m_axi_rready  = 1'b0;

// write trigger
reg [ADDR_WIDTH-1:0]  m_axi_awaddr_reg;
reg [ID_WIDTH-1:0]  m_axi_awid_reg;
reg m_axi_awvalid_reg;
reg awr_req_attempt;

wire [ADDR_WIDTH-1:0] trigger_addr;
assign trigger_addr = {trigger_fifo_core_no, 
                    {(CORE_LEAD_ZERO  - 9){1'b0}} , 1'b1, 
                    {(5 - SLOT_NO_WIDTH){1'b0}}, trigger_fifo_slot_no, 3'd0};

reg [CORE_COUNT+1-1:0] trigger_counter;
assign trigger_sent = trigger_accepted; 
always @ (posedge clk)
  if (rst)
    trigger_counter <= {(CORE_COUNT+1){1'b0}};
  else if (trigger_sent && !pkt_sent_to_core_valid) // && (trigger_counter>0))
    trigger_counter <= trigger_counter - 1'd1;
  else if (~trigger_sent && pkt_sent_to_core_valid)
    trigger_counter <= trigger_counter + 1'd1;
 
wire trigger_send_valid = (pkt_sent_to_core_valid || (trigger_counter>0)) 
                          && trigger_fifo_v;

always @ (posedge clk)
  if (rst) begin 
    m_axi_awvalid_reg <= 1'b0;
    awr_req_attempt   <= 1'b0;
  end else begin
    if (trigger_send_valid && !awr_req_attempt) begin
      m_axi_awaddr_reg  <= trigger_addr;
      m_axi_awid_reg    <= trigger_fifo_core_no;
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
reg trigger_accepted;
reg [DATA_WIDTH-1:0]  m_axi_wdata_reg;
reg [STRB_WIDTH-1:0]  m_axi_wstrb_reg;
reg                   m_axi_wlast_reg;

wire [23:0] core_slot_addr = {{(24-SLOT_LEAD_ZERO-SLOT_ADDR_EFF){1'b0}},
                              trigger_fifo_slot_addr, {SLOT_LEAD_ZERO{1'b0}}};
wire [7:0]  core_slot_no   = {{(8-SLOT_NO_WIDTH){1'b0}}, trigger_fifo_slot_no};
wire [7:0]  incoming_port  = 8'd0;

always @ (posedge clk)
  if (rst) begin 
    m_axi_wvalid_reg <= 1'b0;
    wr_req_attempt   <= 1'b0;
    trigger_accepted <= 1'b0;
  end else begin
    trigger_accepted <= 1'b0;
    if (trigger_send_valid && !wr_req_attempt) begin
      m_axi_wvalid_reg <= 1'b1;
      m_axi_wdata_reg  <= {8'd0, core_slot_addr, core_slot_no,
                           incoming_port, pkt_sent_to_core_len[15:0]};
      m_axi_wstrb_reg  <= 8'hFF;
      m_axi_wlast_reg  <= 1'b1;
      wr_req_attempt   <= 1'b1;
      trigger_accepted <= 1'b1;
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

// decode core_messages and send read desc
wire [15:0] read_pkt_len = msg_data[15:0];
wire [7:0]  out_port     = msg_data[23:16];
wire [7:0]  read_slot_no = msg_data[31:24];
wire [7:0]  core_errs    = msg_data[63:48];

wire [ADDR_WIDTH-1:0] read_slot_addr = {msg_core_no,
                      msg_data[32+CORE_LEAD_ZERO-1:32]};

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
    end else if (msg_valid) begin // add check for errors here
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

assign msg_ready = s_axis_tx_desc_ready;

reg [CORE_NO_WIDTH-1:0] tx_desc_core_no_latched;
reg [SLOT_NO_WIDTH-1:0] tx_desc_slot_no_latched;

// Latch core and slot number of core message to add to read desc fifo
always @ (posedge clk) 
    if (s_axis_tx_desc_valid) begin
      tx_desc_core_no_latched   <= msg_core_no;
      tx_desc_slot_no_latched   <= read_slot_no;
    end

assign dma_rx_desc = {tx_desc_core_no_latched, tx_desc_slot_no_latched};
assign dma_rx_desc_valid = pkt_sent_out_valid;

endmodule
