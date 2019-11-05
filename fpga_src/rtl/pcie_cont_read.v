module pcie_cont_read # (
  // PCIe Parameters
  parameter AXIS_PCIE_DATA_WIDTH = 256,
  parameter AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32),
  parameter HOST_DMA_TAG_WIDTH   = 32,
  parameter PCIE_ADDR_WIDTH      = 64,
  parameter PCIE_RAM_ADDR_WIDTH  = 32,
  parameter PCIE_SLOT_COUNT      = 16,
  parameter PCIE_SLOT_WIDTH      = $clog2(PCIE_SLOT_COUNT),
  parameter PCIE_DMA_TAG_WIDTH   = PCIE_SLOT_WIDTH,
  parameter PCIE_DMA_LEN_WIDTH   = 16,
  // RAM parameters
  parameter SEG_COUNT            = AXIS_PCIE_DATA_WIDTH > 64 ? 
                                   AXIS_PCIE_DATA_WIDTH*2 / 128 : 2,
  parameter SEG_DATA_WIDTH       = AXIS_PCIE_DATA_WIDTH*2/SEG_COUNT,
  parameter RAM_SIZE             = 2**15, 
  parameter SEG_ADDR_WIDTH       = $clog2((RAM_SIZE/SEG_COUNT)/8),
  parameter SEG_BE_WIDTH         = SEG_DATA_WIDTH/8,
  parameter RAM_ADDR_WIDTH       = SEG_ADDR_WIDTH+$clog2(SEG_COUNT)
                                   +$clog2(SEG_BE_WIDTH),
  parameter RAM_PIPELINE         = 2,
  // CORE parameters
  parameter CORE_COUNT           = 16,
  parameter CORE_WIDTH           = $clog2(CORE_COUNT), 
  parameter CORE_ADDR_WIDTH      = 16, 
  parameter AXIS_DATA_WIDTH      = 128, 
  parameter AXIS_KEEP_WIDTH      = 16, 
  parameter AXIS_TAG_WIDTH       = 9
) ( 
  input  wire                                pcie_clk,
  input  wire                                pcie_rst,
  input  wire                                dma_enable,

  // Read descriptor request from host
  input  wire [PCIE_ADDR_WIDTH-1:0]          host_dma_read_desc_pcie_addr,
  input  wire [PCIE_RAM_ADDR_WIDTH-1:0]      host_dma_read_desc_ram_addr,
  input  wire [PCIE_DMA_LEN_WIDTH-1:0]       host_dma_read_desc_len,
  input  wire [HOST_DMA_TAG_WIDTH-1:0]       host_dma_read_desc_tag,
  input  wire                                host_dma_read_desc_valid,
  output wire                                host_dma_read_desc_ready,
  
  output wire [HOST_DMA_TAG_WIDTH-1:0]       host_dma_read_desc_status_tag,
  output wire                                host_dma_read_desc_status_valid,
  
  // Read request coming from cores
  input  wire [127:0]                        cores_ctrl_s_tdata,
  input  wire                                cores_ctrl_s_tvalid,
  input  wire [CORE_WIDTH-1:0]               cores_ctrl_s_tuser,
  output wire                                cores_ctrl_s_tready,
  
  // Data to cores 
  output wire [AXIS_DATA_WIDTH-1:0]          cores_rx_tdata,
  output wire [AXIS_KEEP_WIDTH-1:0]          cores_rx_tkeep,
  output wire [AXIS_TAG_WIDTH-1:0]           cores_rx_tdest,
  output wire                                cores_rx_tvalid, 
  input  wire                                cores_rx_tready,
  output wire                                cores_rx_tlast,
  
  // Read connection to PCIE DMA
  output wire [PCIE_ADDR_WIDTH-1:0]          pcie_dma_read_desc_pcie_addr,
  output wire [RAM_ADDR_WIDTH-1:0]           pcie_dma_read_desc_ram_addr,
  output wire [PCIE_DMA_LEN_WIDTH-1:0]       pcie_dma_read_desc_len,
  output wire [PCIE_DMA_TAG_WIDTH-1:0]       pcie_dma_read_desc_tag,
  output wire                                pcie_dma_read_desc_valid,
  input  wire                                pcie_dma_read_desc_ready,
 
  input  wire [PCIE_DMA_TAG_WIDTH-1:0]       pcie_dma_read_desc_status_tag,
  input  wire                                pcie_dma_read_desc_status_valid,
  
  input  wire [SEG_COUNT*SEG_BE_WIDTH-1:0]   dma_ram_wr_cmd_be,
  input  wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0] dma_ram_wr_cmd_addr,
  input  wire [SEG_COUNT*SEG_DATA_WIDTH-1:0] dma_ram_wr_cmd_data,
  input  wire [SEG_COUNT-1:0]                dma_ram_wr_cmd_valid,
  output wire [SEG_COUNT-1:0]                dma_ram_wr_cmd_ready
);

// Internal wires
reg  [PCIE_ADDR_WIDTH-1:0]    pcie_dma_read_desc_pcie_addr_r;
reg  [RAM_ADDR_WIDTH-1:0]     pcie_dma_read_desc_ram_addr_r;
reg  [PCIE_DMA_LEN_WIDTH-1:0] pcie_dma_read_desc_len_r;
reg  [PCIE_DMA_TAG_WIDTH-1:0] pcie_dma_read_desc_tag_r;
reg                           pcie_dma_read_desc_valid_r;
wire                          pcie_dma_read_desc_ready_r;

reg  [RAM_ADDR_WIDTH-1:0]     axis_read_desc_addr_r;
reg  [PCIE_DMA_LEN_WIDTH-1:0] axis_read_desc_len_r;
reg  [PCIE_SLOT_WIDTH-1:0]    axis_read_desc_tag_r;
reg  [AXIS_TAG_WIDTH-1:0]     axis_read_desc_dest_r;
reg  [CORE_ADDR_WIDTH-1:0]    axis_read_desc_user_r;
reg                           axis_read_desc_valid_r;
wire                          axis_read_desc_ready_r;
wire [PCIE_SLOT_WIDTH-1:0]    axis_read_desc_status_tag;
wire                          axis_read_desc_status_valid;

reg  [HOST_DMA_TAG_WIDTH-1:0] host_dma_read_desc_status_tag_r;
reg                           host_dma_read_desc_status_valid_r;
  
// Internal bookkeepings
reg  [PCIE_DMA_LEN_WIDTH-1:0] rx_len       [0:PCIE_SLOT_COUNT-1];
reg  [CORE_ADDR_WIDTH-1:0]    rx_core_addr [0:PCIE_SLOT_COUNT-1];
reg  [AXIS_TAG_WIDTH-1:0]     rx_core_tag  [0:PCIE_SLOT_COUNT-1];
reg  [HOST_DMA_TAG_WIDTH-1:0] rx_pcie_tag  [0:PCIE_SLOT_COUNT-1];

reg  [PCIE_SLOT_COUNT-1:0]    rx_slot;
wire [PCIE_SLOT_WIDTH-1:0]    selected_rx_slot;
wire [PCIE_SLOT_COUNT-1:0]    selected_rx_slot_1hot;
wire                          selected_rx_slot_v;

penc # (.IN_WIDTH(PCIE_SLOT_COUNT)) rx_penc (
  .to_select(rx_slot),.selected(selected_rx_slot),
  .selected_1hot (selected_rx_slot_1hot),.valid(selected_rx_slot_v));
    
always @ (posedge pcie_clk) begin
  if (host_dma_read_desc_valid && host_dma_read_desc_ready) begin 
    // Save request info for rx slot
    rx_len      [selected_rx_slot] <= host_dma_read_desc_len;
    rx_core_addr[selected_rx_slot] <= host_dma_read_desc_ram_addr[CORE_ADDR_WIDTH-1:0];
    rx_core_tag [selected_rx_slot] <= {host_dma_read_desc_ram_addr[CORE_ADDR_WIDTH +: CORE_WIDTH], 
                                       {(AXIS_TAG_WIDTH-CORE_WIDTH){1'b0}}};
    rx_pcie_tag [selected_rx_slot] <= host_dma_read_desc_tag;

    // Make pcie_dma descriptor, it goes to FIFO
    pcie_dma_read_desc_pcie_addr_r <= host_dma_read_desc_pcie_addr;
    pcie_dma_read_desc_ram_addr_r  <= {selected_rx_slot,11'd0}; 
    pcie_dma_read_desc_len_r       <= host_dma_read_desc_len;
    pcie_dma_read_desc_tag_r       <= selected_rx_slot; 
    pcie_dma_read_desc_valid_r     <= 1'b1;
  end else if (cores_ctrl_s_tvalid && cores_ctrl_s_tready) begin
    rx_len      [selected_rx_slot] <= cores_ctrl_s_tdata[PCIE_DMA_LEN_WIDTH-1:0];
    rx_core_addr[selected_rx_slot] <= cores_ctrl_s_tdata[CORE_ADDR_WIDTH+31:32];
    rx_core_tag [selected_rx_slot] <= {cores_ctrl_s_tuser, 
                                       cores_ctrl_s_tdata[(AXIS_TAG_WIDTH-CORE_WIDTH)+15:16]};
    rx_pcie_tag [selected_rx_slot] <= {HOST_DMA_TAG_WIDTH{1'b0}};

    pcie_dma_read_desc_pcie_addr_r <= cores_ctrl_s_tdata[127:64];
    pcie_dma_read_desc_ram_addr_r  <= {selected_rx_slot,11'd0}; 
    pcie_dma_read_desc_len_r       <= cores_ctrl_s_tdata[PCIE_DMA_LEN_WIDTH-1:0];
    pcie_dma_read_desc_tag_r       <= selected_rx_slot; 
    pcie_dma_read_desc_valid_r     <= 1'b1;
  end else begin // valid gets deasserted when ready is asserted
    pcie_dma_read_desc_valid_r     <= 1'b0;
  end

  // There is FIFO afterwards and since there is a fifo for requests in first place 
  // That would limit the number of status valid and this FIFO does not overflow
  if (pcie_dma_read_desc_status_valid) begin
    axis_read_desc_addr_r  <= {pcie_dma_read_desc_status_tag,11'd0};
    axis_read_desc_len_r   <= rx_len[pcie_dma_read_desc_status_tag];
    axis_read_desc_tag_r   <= pcie_dma_read_desc_status_tag;
    axis_read_desc_dest_r  <= rx_core_tag[pcie_dma_read_desc_status_tag];
    axis_read_desc_valid_r <= 1'b1;
    axis_read_desc_user_r  <= rx_core_addr[pcie_dma_read_desc_status_tag];
  end else begin
    axis_read_desc_valid_r <= 1'b0;
  end

  // Output status is also 1 cycle, so no need for FIFO
  if (axis_read_desc_status_valid && (rx_pcie_tag [axis_read_desc_status_tag]!=0)) begin
    host_dma_read_desc_status_tag_r   <= rx_pcie_tag [axis_read_desc_status_tag];
    host_dma_read_desc_status_valid_r <= 1'b1;
  end else begin
    host_dma_read_desc_status_valid_r <= 1'b0;
  end
  
  if (((host_dma_read_desc_valid && host_dma_read_desc_ready)||
      (cores_ctrl_s_tvalid && cores_ctrl_s_tready)) && axis_read_desc_status_valid) 
    rx_slot <= (rx_slot & (~selected_rx_slot_1hot)) 
                | ({{(PCIE_SLOT_COUNT-1){1'b0}},1'b1} << axis_read_desc_status_tag);
  else if ((host_dma_read_desc_valid && host_dma_read_desc_ready)|| 
           (cores_ctrl_s_tvalid && cores_ctrl_s_tready))
    rx_slot <= rx_slot & (~selected_rx_slot_1hot);
  if (axis_read_desc_status_valid)
    rx_slot <= rx_slot | ({{(PCIE_SLOT_COUNT-1){1'b0}},1'b1} << axis_read_desc_status_tag);

  if (pcie_rst) begin
    rx_slot                           <= {PCIE_SLOT_COUNT{1'b1}};
    pcie_dma_read_desc_valid_r        <= 1'b0;
    axis_read_desc_valid_r            <= 1'b0;
    host_dma_read_desc_status_valid_r <= 1'b0;
  end
end

// If there is space in FIFO and some slot available we can accept the host dma request
// Similar for core requests, but it has lower priority than host_dma_read request
assign cores_ctrl_s_tready = pcie_dma_read_desc_ready && selected_rx_slot_v && 
                             !host_dma_read_desc_valid;

assign host_dma_read_desc_status_tag   = host_dma_read_desc_status_tag_r;
assign host_dma_read_desc_status_valid = host_dma_read_desc_status_valid_r;
assign host_dma_read_desc_ready        = pcie_dma_read_desc_ready && selected_rx_slot_v;

// internal read desc FIFO
wire [RAM_ADDR_WIDTH-1:0]     axis_read_desc_addr;
wire [PCIE_DMA_LEN_WIDTH-1:0] axis_read_desc_len;
wire [PCIE_SLOT_WIDTH-1:0]    axis_read_desc_tag;
wire [AXIS_TAG_WIDTH-1:0]     axis_read_desc_dest;
wire [CORE_ADDR_WIDTH-1:0]    axis_read_desc_user;
wire                          axis_read_desc_valid;
wire                          axis_read_desc_ready;

simple_fifo # (
  .ADDR_WIDTH(PCIE_SLOT_WIDTH),
  .DATA_WIDTH(RAM_ADDR_WIDTH+PCIE_DMA_LEN_WIDTH+PCIE_SLOT_WIDTH+
              AXIS_TAG_WIDTH+CORE_ADDR_WIDTH)
) axis_read_desc_fifo (
  .clk(pcie_clk),
  .rst(pcie_rst),
  .clear(1'b0),

  .din_valid(axis_read_desc_valid_r),
  .din(     {axis_read_desc_addr_r,
             axis_read_desc_len_r,
             axis_read_desc_tag_r,
             axis_read_desc_dest_r,
             axis_read_desc_user_r}),
  .din_ready(axis_read_desc_ready_r),
 
  .dout_valid(axis_read_desc_valid),
  .dout(     {axis_read_desc_addr,
              axis_read_desc_len,
              axis_read_desc_tag,
              axis_read_desc_dest,
              axis_read_desc_user}),
  .dout_ready(axis_read_desc_ready),

  .item_count(),
  .full(),
  .empty()
);
 
// Scratchpad for reordering from PCIe 
wire [SEG_COUNT*SEG_ADDR_WIDTH-1:0]  dma_ram_rd_cmd_addr_int;
wire [SEG_COUNT-1:0]                 dma_ram_rd_cmd_valid_int;
wire [SEG_COUNT-1:0]                 dma_ram_rd_cmd_ready_int;
wire [SEG_COUNT*SEG_DATA_WIDTH-1:0]  dma_ram_rd_resp_data_int;
wire [SEG_COUNT-1:0]                 dma_ram_rd_resp_valid_int;
wire [SEG_COUNT-1:0]                 dma_ram_rd_resp_ready_int;

dma_psdpram #(
    .SIZE(RAM_SIZE),
    .SEG_COUNT(SEG_COUNT),
    .SEG_DATA_WIDTH(SEG_DATA_WIDTH),
    .SEG_ADDR_WIDTH(SEG_ADDR_WIDTH),
    .SEG_BE_WIDTH(SEG_BE_WIDTH),
    .PIPELINE(RAM_PIPELINE)
)
dma_psdpram_read_inst (
    /*
     * Write port
     */
    .clk_wr(pcie_clk),
    .rst_wr(pcie_rst),
    .wr_cmd_be(dma_ram_wr_cmd_be),
    .wr_cmd_addr(dma_ram_wr_cmd_addr),
    .wr_cmd_data(dma_ram_wr_cmd_data),
    .wr_cmd_valid(dma_ram_wr_cmd_valid),
    .wr_cmd_ready(dma_ram_wr_cmd_ready),

    /*
     * Read port
     */
    .clk_rd(pcie_clk),
    .rst_rd(pcie_rst),
    .rd_cmd_addr(dma_ram_rd_cmd_addr_int),
    .rd_cmd_valid(dma_ram_rd_cmd_valid_int),
    .rd_cmd_ready(dma_ram_rd_cmd_ready_int),
    .rd_resp_data(dma_ram_rd_resp_data_int),
    .rd_resp_valid(dma_ram_rd_resp_valid_int),
    .rd_resp_ready(dma_ram_rd_resp_ready_int)
);

wire [AXIS_DATA_WIDTH-1:0]  axis_read_data_tdata;
wire [AXIS_KEEP_WIDTH-1:0]  axis_read_data_tkeep;
wire                       axis_read_data_tvalid;
wire                       axis_read_data_tready;
wire                       axis_read_data_tlast;
wire [AXIS_TAG_WIDTH-1:0]  axis_read_data_tdest;
wire [CORE_ADDR_WIDTH-1:0] axis_read_data_tuser;

dma_client_axis_source #(
    .SEG_COUNT(SEG_COUNT),
    .SEG_DATA_WIDTH(SEG_DATA_WIDTH),
    .SEG_ADDR_WIDTH(SEG_ADDR_WIDTH),
    .SEG_BE_WIDTH(SEG_BE_WIDTH),
    .RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .AXIS_KEEP_ENABLE(AXIS_KEEP_WIDTH > 1),
    .AXIS_KEEP_WIDTH(AXIS_KEEP_WIDTH),
    .AXIS_LAST_ENABLE(1),
    .AXIS_ID_ENABLE(0),
    .AXIS_DEST_ENABLE(1),
    .AXIS_DEST_WIDTH(AXIS_TAG_WIDTH),
    .AXIS_USER_ENABLE(1),
    .AXIS_USER_WIDTH(CORE_ADDR_WIDTH),
    .LEN_WIDTH(PCIE_DMA_LEN_WIDTH), 
    .TAG_WIDTH(PCIE_DMA_TAG_WIDTH)  
)
dma_client_axis_source_inst (
    .clk(pcie_clk),
    .rst(pcie_rst),

    /*
     * DMA read descriptor input
     */
    .s_axis_read_desc_ram_addr(axis_read_desc_addr),
    .s_axis_read_desc_len     (axis_read_desc_len),
    .s_axis_read_desc_tag     (axis_read_desc_tag),
    .s_axis_read_desc_id      (8'd0),
    .s_axis_read_desc_dest    (axis_read_desc_dest),
    .s_axis_read_desc_user    (axis_read_desc_user),
    .s_axis_read_desc_valid   (axis_read_desc_valid),
    .s_axis_read_desc_ready   (axis_read_desc_ready),

    /*
     * DMA read descriptor status output
     */
    .m_axis_read_desc_status_tag  (axis_read_desc_status_tag),
    .m_axis_read_desc_status_valid(axis_read_desc_status_valid),

    /*
     * AXI stream read data output
     */
    .m_axis_read_data_tdata (axis_read_data_tdata),
    .m_axis_read_data_tkeep (axis_read_data_tkeep),
    .m_axis_read_data_tvalid(axis_read_data_tvalid),
    .m_axis_read_data_tready(axis_read_data_tready),
    .m_axis_read_data_tlast (axis_read_data_tlast),
    .m_axis_read_data_tid   (),
    .m_axis_read_data_tdest (axis_read_data_tdest),
    .m_axis_read_data_tuser (axis_read_data_tuser),

    /*
     * RAM interface
     */
    .ram_rd_cmd_addr(dma_ram_rd_cmd_addr_int),
    .ram_rd_cmd_valid(dma_ram_rd_cmd_valid_int),
    .ram_rd_cmd_ready(dma_ram_rd_cmd_ready_int),
    .ram_rd_resp_data(dma_ram_rd_resp_data_int),
    .ram_rd_resp_valid(dma_ram_rd_resp_valid_int),
    .ram_rd_resp_ready(dma_ram_rd_resp_ready_int),

    /*
     * Configuration
     */
    .enable(dma_enable)
);

// Descriptor FIFO 
simple_fifo # (
  .ADDR_WIDTH(PCIE_SLOT_WIDTH),
  .DATA_WIDTH(PCIE_ADDR_WIDTH+RAM_ADDR_WIDTH+
              PCIE_DMA_LEN_WIDTH+PCIE_DMA_TAG_WIDTH)
) pcie_dma_read_desc_fifo (
  .clk(pcie_clk),
  .rst(pcie_rst),
  .clear(1'b0),

  .din_valid(pcie_dma_read_desc_valid_r),
  .din(     {pcie_dma_read_desc_pcie_addr_r,
             pcie_dma_read_desc_ram_addr_r,
             pcie_dma_read_desc_len_r,
             pcie_dma_read_desc_tag_r}),
  .din_ready(pcie_dma_read_desc_ready_r),
 
  .dout_valid(pcie_dma_read_desc_valid),
  .dout(     {pcie_dma_read_desc_pcie_addr,
              pcie_dma_read_desc_ram_addr,
              pcie_dma_read_desc_len,
              pcie_dma_read_desc_tag}),
  .dout_ready(pcie_dma_read_desc_ready),

  .item_count(),
  .full(),
  .empty()
);

// PCIe address header adder
header_adder # (
  .DATA_WIDTH(AXIS_DATA_WIDTH),
  .HDR_WIDTH(64),
  .DEST_WIDTH(AXIS_TAG_WIDTH)
) rx_header_adder (
  .clk(pcie_clk),
  .rst(pcie_rst),

  .s_axis_tdata (axis_read_data_tdata),
  .s_axis_tkeep (axis_read_data_tkeep),
  .s_axis_tdest (axis_read_data_tdest),
  .s_axis_tuser (8'd0), 
  .s_axis_tlast (axis_read_data_tlast),
  .s_axis_tvalid(axis_read_data_tvalid),
  .s_axis_tready(axis_read_data_tready),

  .header({{(32-CORE_ADDR_WIDTH){1'b0}},axis_read_data_tuser,32'd0}),
  .header_valid(axis_read_data_tvalid),
  .header_ready(), 

  .m_axis_tdata (cores_rx_tdata),
  .m_axis_tkeep (cores_rx_tkeep),
  .m_axis_tdest (cores_rx_tdest),
  .m_axis_tuser (),
  .m_axis_tlast (cores_rx_tlast),
  .m_axis_tvalid(cores_rx_tvalid),
  .m_axis_tready(cores_rx_tready)
);

endmodule
