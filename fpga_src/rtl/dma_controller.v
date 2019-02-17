module dma_controller # (
    parameter DATA_WIDTH = 64,   
    parameter ADDR_WIDTH = 16,
    parameter ID_WIDTH   = 8,
    parameter LEN_WIDTH  = 20,
    parameter TAG_WIDTH  = 8,
    
    parameter STRB_WIDTH = (DATA_WIDTH/8)
)
(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   go,

    /*
     * AXI master interface
     */
    output wire [ID_WIDTH-1:0]    m_axi_awid,
    output wire [ADDR_WIDTH-1:0]  m_axi_awaddr,
    output wire [7:0]             m_axi_awlen,
    output wire [2:0]             m_axi_awsize,
    output wire [1:0]             m_axi_awburst,
    output wire                   m_axi_awlock,
    output wire [3:0]             m_axi_awcache,
    output wire [2:0]             m_axi_awprot,
    output wire                   m_axi_awvalid,
    input  wire                   m_axi_awready,
    output wire [DATA_WIDTH-1:0]  m_axi_wdata,
    output wire [STRB_WIDTH-1:0]  m_axi_wstrb,
    output wire                   m_axi_wlast,
    output wire                   m_axi_wvalid,
    input  wire                   m_axi_wready,
    input  wire [ID_WIDTH-1:0]    m_axi_bid,
    input  wire [1:0]             m_axi_bresp,
    input  wire                   m_axi_bvalid,
    output wire                   m_axi_bready,
    output wire [ID_WIDTH-1:0]    m_axi_arid,
    output wire [ADDR_WIDTH-1:0]  m_axi_araddr,
    output wire [7:0]             m_axi_arlen,
    output wire [2:0]             m_axi_arsize,
    output wire [1:0]             m_axi_arburst,
    output wire                   m_axi_arlock,
    output wire [3:0]             m_axi_arcache,
    output wire [2:0]             m_axi_arprot,
    output wire                   m_axi_arvalid,
    input  wire                   m_axi_arready,
    input  wire [ID_WIDTH-1:0]    m_axi_rid,
    input  wire [DATA_WIDTH-1:0]  m_axi_rdata,
    input  wire [1:0]             m_axi_rresp,
    input  wire                   m_axi_rlast,
    input  wire                   m_axi_rvalid,
    output wire                   m_axi_rready,
 
    /*
     * Transmit descriptor output
     */
    output wire [ADDR_WIDTH-1:0]  s_axis_tx_desc_addr,
    output wire [LEN_WIDTH-1:0]       s_axis_tx_desc_len,
    output wire [TAG_WIDTH-1:0]       s_axis_tx_desc_tag,
    output wire                       s_axis_tx_desc_user,
    output wire                       s_axis_tx_desc_valid,
    input  wire                       s_axis_tx_desc_ready,

    /*
     * Receive descriptor output
     */
    output wire [ADDR_WIDTH-1:0]  s_axis_rx_desc_addr,
    output wire [LEN_WIDTH-1:0]   s_axis_rx_desc_len,
    output wire [TAG_WIDTH-1:0]   s_axis_rx_desc_tag,
    output wire                   s_axis_rx_desc_valid,
    input  wire                   s_axis_rx_desc_ready,

    output wire                   tx_enable,
    output wire                   rx_enable,
    output wire                   rx_abort,

    input  wire                   incoming_pkt_ready,
    input  wire                   core_msg,
    input  wire                   pkt_sent_to_core_valid,
    input  wire [LEN_WIDTH-1:0]   pkt_sent_to_core_len,

    input  wire                   pkt_sent_out_valid

);

reg core_status_update_r;
reg rx_fifo_good_frame_r;
reg go_r;
always @ (posedge clk)
  if (rst) begin 
    core_status_update_r <= 1'b0;
    rx_fifo_good_frame_r <= 1'b0;
    go_r                 <= 1'b0;
  end else begin
    core_status_update_r <= core_msg;
    rx_fifo_good_frame_r <= incoming_pkt_ready;
    go_r                 <= go;
  end

wire [3:0] slot = 4'd0;
wire [ADDR_WIDTH-1:0] slot_addr = {2'b01, slot, 10'h008}; //A};
wire [ADDR_WIDTH-1:0] core_slot_addr = {2'b01, slot, 10'h000};
wire [15:0] slot_flag = 16'd1;
wire [ADDR_WIDTH-1:0] trigger_addr = {11'h008, slot, 1'b0};

assign s_axis_tx_desc_tag  = 0;
assign s_axis_tx_desc_user = 0;
assign s_axis_rx_desc_tag  = 0;

assign m_axi_arlock  = 1'b0;
assign m_axi_arcache = 4'd3;
assign m_axi_arprot  = 3'b010;
assign m_axi_arid    = 1;
assign m_axi_arlen   = 8'd0;
assign m_axi_arsize  = 3'b011;
assign m_axi_arburst = 2'b01;

assign m_axi_rready = 1'b1;
assign m_axi_bready = 1'b1;

assign m_axi_awlock  = 1'b0;
assign m_axi_awcache = 4'd3;
assign m_axi_awprot  = 3'b010;
assign m_axi_awid    = 1;
assign m_axi_awlen   = 8'd0;
assign m_axi_awsize  = 3'b011;
assign m_axi_awburst = 2'b01;


// dma to core descriptor
reg [ADDR_WIDTH-1:0]  s_axis_rx_desc_addr_reg;
reg [LEN_WIDTH-1:0]       s_axis_rx_desc_len_reg;
reg                       s_axis_rx_desc_valid_reg;
always @ (posedge clk)
  if (rst) begin 
      s_axis_rx_desc_valid_reg <= 1'b0;
  end else begin
    if (s_axis_rx_desc_valid_reg) begin
      s_axis_rx_desc_valid_reg <= 1'b0;
    end else if (incoming_pkt_ready && (!rx_fifo_good_frame_r)) begin
      s_axis_rx_desc_addr_reg   <= slot_addr;
      s_axis_rx_desc_len_reg    <= 20'd1000;
      s_axis_rx_desc_valid_reg  <= 1'b1;
    end
  end
assign s_axis_rx_desc_addr  = s_axis_rx_desc_addr_reg;
assign s_axis_rx_desc_len   = s_axis_rx_desc_len_reg;
assign s_axis_rx_desc_valid = s_axis_rx_desc_valid_reg;

// core status register read request
reg rd_req_attempt;
reg [ADDR_WIDTH-1:0]  m_axi_araddr_reg;
reg m_axi_arvalid_reg;
always @ (posedge clk)
  if (rst) begin 
    m_axi_arvalid_reg <= 1'b0;
    rd_req_attempt    <= 1'b0;
  end else begin
    if (core_msg && (!core_status_update_r)) begin
      m_axi_araddr_reg  <= 16'h8000;
      m_axi_arvalid_reg <= 1'b1;
      rd_req_attempt    <= 1'b1;
    end
    else if (rd_req_attempt && m_axi_arready) begin
      m_axi_arvalid_reg <= 1'b0;
      rd_req_attempt    <= 1'b0;
    end
  end
assign m_axi_araddr  = m_axi_araddr_reg;
assign m_axi_arvalid = m_axi_arvalid_reg;

// dma from core descriptor
reg [ADDR_WIDTH-1:0]  s_axis_tx_desc_addr_reg;
reg [LEN_WIDTH-1:0]       s_axis_tx_desc_len_reg;
reg                       s_axis_tx_desc_valid_reg;
always @ (posedge clk)
  if (rst) begin 
      s_axis_tx_desc_valid_reg <= 1'b0;
  end else begin
    if (s_axis_tx_desc_valid_reg) begin
      s_axis_tx_desc_valid_reg <= 1'b0;
    end else if ((m_axi_rvalid) && (m_axi_rdata[15:0]==slot_flag)) begin
      s_axis_tx_desc_addr_reg   <= slot_addr;
      s_axis_tx_desc_len_reg    <= {4'd0, m_axi_rdata[31:16]};
      s_axis_tx_desc_valid_reg  <= 1'b1;
    end
  end
assign s_axis_tx_desc_addr  = s_axis_tx_desc_addr_reg;
assign s_axis_tx_desc_len   = s_axis_tx_desc_len_reg;
assign s_axis_tx_desc_valid = s_axis_tx_desc_valid_reg;

// core reset or trigger 
reg [ADDR_WIDTH-1:0]  m_axi_awaddr_reg;
reg m_axi_awvalid_reg;
reg awr_req_attempt;
always @ (posedge clk)
  if (rst) begin 
    m_axi_awvalid_reg <= 1'b0;
    awr_req_attempt   <= 1'b0;
  end else begin
    if (go && (!go_r)) begin
      m_axi_awaddr_reg  <= 16'hFFF8;
      m_axi_awvalid_reg <= 1'b1;
      awr_req_attempt   <= 1'b1;
    end else if (pkt_sent_to_core_valid) begin
      m_axi_awaddr_reg  <= trigger_addr;
      m_axi_awvalid_reg <= 1'b1;
      awr_req_attempt   <= 1'b1;
    end
    else if (awr_req_attempt && m_axi_awready) begin
      m_axi_awvalid_reg <= 1'b0;
      awr_req_attempt   <= 1'b0;
    end
  end
assign m_axi_awaddr  = m_axi_awaddr_reg;
assign m_axi_awvalid = m_axi_awvalid_reg;

reg wr_req_attempt;
reg m_axi_wvalid_reg;
reg [DATA_WIDTH-1:0]  m_axi_wdata_reg;
reg [STRB_WIDTH-1:0]  m_axi_wstrb_reg;
reg                   m_axi_wlast_reg;

always @ (posedge clk)
  if (rst) begin 
    m_axi_wvalid_reg <= 1'b0;
    wr_req_attempt   <= 1'b0;
  end else begin
    if (go && (!go_r)) begin
      m_axi_wvalid_reg <= 1'b1;
      m_axi_wdata_reg  <= 64'd0;
      m_axi_wstrb_reg  <= 8'h80;
      m_axi_wlast_reg  <= 1'b1;
      wr_req_attempt   <= 1'b1;
    end
    else if (pkt_sent_to_core_valid) begin
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

// enable tx and rx
reg tx_enable_reg;
reg rx_enable_reg;
reg rx_abort_reg;
always @ (posedge clk)
  if (rst) begin 
    tx_enable_reg = 1'b0;
    rx_enable_reg = 1'b0;
    rx_abort_reg  = 1'b0;
  end else if (go && (!go_r)) begin
    tx_enable_reg = 1'b1;
    rx_enable_reg = 1'b1;
    rx_abort_reg  = 1'b0;
  end

assign tx_enable = tx_enable_reg;
assign rx_enable = rx_enable_reg;
assign rx_abort  = rx_abort_reg;

endmodule
