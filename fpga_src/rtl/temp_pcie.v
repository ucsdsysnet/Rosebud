module temp_pcie # (
    parameter DATA_WIDTH      = 64,   
    parameter ADDR_WIDTH      = 19,
    parameter ID_WIDTH        = 8,
    parameter LEN_WIDTH       = 20,
    parameter TAG_WIDTH       = 8,
    parameter RISCV_CORES     = 8,
    parameter RISCV_SLOTS     = 16,
    parameter SLOT_ADDR_EFF   = 7,
    parameter FIRST_SLOT_ADDR = 7'h40,
    parameter SLOT_ADDR_STEP  = 7'h04,
    
    parameter STRB_WIDTH      = (DATA_WIDTH/8),
    parameter CORE_NO_WIDTH   = $clog2(RISCV_CORES),
    parameter SLOT_NO_WIDTH   = $clog2(RISCV_SLOTS), 
    parameter DESC_FIFO_WIDTH = CORE_NO_WIDTH+SLOT_NO_WIDTH
)(
    input  wire                       clk,
    input  wire                       rst,

    /*
     * AXI master interface
     */
    output wire [ID_WIDTH-1:0]        m_axi_awid,
    output wire [ADDR_WIDTH-1:0]      m_axi_awaddr,
    output wire [7:0]                 m_axi_awlen,
    output wire [2:0]                 m_axi_awsize,
    output wire [1:0]                 m_axi_awburst,
    output wire                       m_axi_awlock,
    output wire [3:0]                 m_axi_awcache,
    output wire [2:0]                 m_axi_awprot,
    output wire                       m_axi_awvalid,
    input  wire                       m_axi_awready,
    output wire [DATA_WIDTH-1:0]      m_axi_wdata,
    output wire [STRB_WIDTH-1:0]      m_axi_wstrb,
    output wire                       m_axi_wlast,
    output wire                       m_axi_wvalid,
    input  wire                       m_axi_wready,
    input  wire [ID_WIDTH-1:0]        m_axi_bid,
    input  wire [1:0]                 m_axi_bresp,
    input  wire                       m_axi_bvalid,
    output wire                       m_axi_bready,
    output wire [ID_WIDTH-1:0]        m_axi_arid,
    output wire [ADDR_WIDTH-1:0]      m_axi_araddr,
    output wire [7:0]                 m_axi_arlen,
    output wire [2:0]                 m_axi_arsize,
    output wire [1:0]                 m_axi_arburst,
    output wire                       m_axi_arlock,
    output wire [3:0]                 m_axi_arcache,
    output wire [2:0]                 m_axi_arprot,
    output wire                       m_axi_arvalid,
    input  wire                       m_axi_arready,
    input  wire [ID_WIDTH-1:0]        m_axi_rid,
    input  wire [DATA_WIDTH-1:0]      m_axi_rdata,
    input  wire [1:0]                 m_axi_rresp,
    input  wire                       m_axi_rlast,
    input  wire                       m_axi_rvalid,
    output wire                       m_axi_rready,

    output wire  [SLOT_NO_WIDTH-1:0]  slot_addr_wr_no,
    output wire  [SLOT_ADDR_EFF-1:0]  slot_addr_wr_data,
    output wire                       slot_addr_wr_valid,
    
    output wire [DESC_FIFO_WIDTH-1:0] inject_rx_desc,
    output wire                       inject_rx_desc_valid,
    input  wire                       inject_rx_desc_ready,

    // Enable of RX and TX chains
    output wire                       tx_enable,
    output wire                       rx_enable,
    output wire                       rx_abort
);

reg start_n, start_r;
reg [19:0] counter;
always @(posedge clk)
  if (rst) begin
    start_n <= 1'b0;
    counter <= 20'd0;
  end else if (counter < 20'd1000) begin
    counter <= counter + 20'd1;
  end else begin
    start_n <= 1'b1;
  end

always @(posedge clk)
  if (rst) 
    start_r <= 1'b0;
  else
    start_r <= start_n; 

reg [CORE_NO_WIDTH-1:0] core_sel;
reg core_rst_done;
// core reset or trigger 
reg [ADDR_WIDTH-1:0]  m_axi_awaddr_reg;
reg m_axi_awvalid_reg;
reg awr_req_attempt;
reg write_done;
reg start_write;

always @ (posedge clk)
  if (rst) begin 
    m_axi_awvalid_reg <= 1'b0;
    awr_req_attempt   <= 1'b0;
    core_sel          <= {CORE_NO_WIDTH{1'b0}};
    core_rst_done     <= 1'b0;
    start_write       <= 1'b0;
  end else begin
    if (start_n && (!start_r)) begin
      m_axi_awaddr_reg  <= {core_sel,16'hFFF8};
      m_axi_awvalid_reg <= 1'b1;
      awr_req_attempt   <= 1'b1;
      core_sel          <= core_sel + 1'b1;
      start_write       <= 1'b1;
    end else begin
      if (start_write) 
        start_write <= 1'b0;
      if (awr_req_attempt && m_axi_awready) begin
        m_axi_awvalid_reg <= 1'b0;
        awr_req_attempt   <= 1'b0;
      end
      if (write_done)
        if (!core_rst_done) begin
          m_axi_awaddr_reg  <= {core_sel,16'hFFF8};
          m_axi_awvalid_reg <= 1'b1;
          awr_req_attempt   <= 1'b1;
          core_sel <= core_sel + 1'b1;
          start_write <= 1'b1;
          if (core_sel == {CORE_NO_WIDTH{1'b1}})
            core_rst_done <= 1'b1;
        end
    end
  end

assign m_axi_awlock  = 1'b0;
assign m_axi_awcache = 4'd3;
assign m_axi_awprot  = 3'b010;
assign m_axi_awlen   = 8'd0;
assign m_axi_awsize  = 3'b011;
assign m_axi_awburst = 2'b01;
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
    write_done       <= 1'b0;
  end else begin
    if (write_done)
      write_done <= 1'b0;
    if (start_write) begin
      m_axi_wvalid_reg <= 1'b1;
      m_axi_wdata_reg  <= 64'd0;
      m_axi_wstrb_reg  <= 8'h80;
      m_axi_wlast_reg  <= 1'b1;
      wr_req_attempt   <= 1'b1;
    end else if (wr_req_attempt && m_axi_wready) begin
        m_axi_wvalid_reg <= 1'b0;
        wr_req_attempt   <= 1'b0;
        write_done       <= 1'b1;
    end
  end
assign m_axi_wvalid = m_axi_wvalid_reg;
assign m_axi_wdata  = m_axi_wdata_reg;
assign m_axi_wstrb  = m_axi_wstrb_reg;
assign m_axi_wlast  = m_axi_wlast_reg;

assign m_axi_bready = 1'b1;

reg go;
always @ (posedge clk)
  if (rst)
    go <= 1'b0;
  else if (core_rst_done && write_done)
    go <= 1'b1;

assign tx_enable = go; 
assign rx_enable = go; 
assign rx_abort  = go; 


reg [SLOT_NO_WIDTH+1-1:0] slot_addr_counter;
reg slot_addr_valid;
reg [SLOT_ADDR_EFF-1:0] next_slot_addr;
always @ (posedge clk)
  if (rst) begin
    slot_addr_counter <= {(SLOT_NO_WIDTH+1){1'b1}};
    slot_addr_valid   <= 1'b0;
    next_slot_addr    <= FIRST_SLOT_ADDR-SLOT_ADDR_STEP; 
  end else 
    if ((slot_addr_counter<{1'b0,{SLOT_NO_WIDTH{1'b1}}})||
       (slot_addr_counter=={(SLOT_NO_WIDTH+1){1'b1}})) begin
      slot_addr_counter <= slot_addr_counter + {{SLOT_NO_WIDTH{1'b0}},1'b1};
      slot_addr_valid   <= 1'b1;
      next_slot_addr    <= next_slot_addr + SLOT_ADDR_STEP;
    end else
      slot_addr_valid  <= 1'b0;

assign slot_addr_wr_no = slot_addr_counter[SLOT_NO_WIDTH-1:0];
assign slot_addr_wr_valid = slot_addr_valid;
assign slot_addr_wr_data = next_slot_addr;

reg desc_valid;
reg [CORE_NO_WIDTH-1:0] core_no;
reg [SLOT_NO_WIDTH-1:0] slot_no;
reg not_started;
always @ (posedge clk)
  if (rst) begin
    core_no     <= {(CORE_NO_WIDTH){1'b0}};
    slot_no     <= {(SLOT_NO_WIDTH){1'b0}};
    desc_valid  <= 1'b0;
    not_started <= 1'b1;
  end else begin
    if (not_started) begin
      not_started <= 1'b0;
      desc_valid  <= 1'b1;
    end else if (desc_valid) begin
      core_no     <= core_no + {{(CORE_NO_WIDTH-1){1'b0}},1'b1};
      if (&core_no)
        slot_no   <= slot_no + {{(SLOT_NO_WIDTH-1){1'b0}},1'b1};
      if ((&core_no) && (&slot_no))
        desc_valid <= 1'b0;
    end
  end
assign inject_rx_desc = {core_no,slot_no};
assign inject_rx_desc_valid = desc_valid;

// There is no read operations
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

endmodule
