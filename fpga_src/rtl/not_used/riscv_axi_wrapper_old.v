module riscv_axi_wrapper # (
    parameter DATA_WIDTH      = 64,       // width of data bus in bits
    parameter ADDR_WIDTH      = 16,
    parameter IMEM_SIZE_BYTES = 8192,
    parameter DMEM_SIZE_BYTES = 32768,
    parameter CONTROL_BIT_LOC = 16,
    parameter STAT_ADDR_WIDTH = 1,
    parameter ID_WIDTH        = 8,
    parameter PIPELINE_OUTPUT = 0,
    
    parameter IMEM_ADDR_WIDTH = $clog2(IMEM_SIZE_BYTES),
    parameter DMEM_ADDR_WIDTH = $clog2(DMEM_SIZE_BYTES),
    parameter STRB_WIDTH      = (DATA_WIDTH/8)
)
(
    input  wire                   clk,
    input  wire                   rst,

    input  wire [ID_WIDTH-1:0]    s_axi_awid,
    input  wire [ADDR_WIDTH-1:0]  s_axi_awaddr,
    input  wire [7:0]             s_axi_awlen,
    input  wire [2:0]             s_axi_awsize,
    input  wire [1:0]             s_axi_awburst,
    input  wire                   s_axi_awlock,
    input  wire [3:0]             s_axi_awcache,
    input  wire [2:0]             s_axi_awprot,
    input  wire                   s_axi_awvalid,
    output wire                   s_axi_awready,

    input  wire [DATA_WIDTH-1:0]  s_axi_wdata,
    input  wire [STRB_WIDTH-1:0]  s_axi_wstrb,
    input  wire                   s_axi_wlast,
    input  wire                   s_axi_wvalid,
    output wire                   s_axi_wready,

    output wire [ID_WIDTH-1:0]    s_axi_bid,
    output wire [1:0]             s_axi_bresp,
    output wire                   s_axi_bvalid,
    input  wire                   s_axi_bready,

    input  wire [ID_WIDTH-1:0]    s_axi_arid,
    input  wire [ADDR_WIDTH-1:0]  s_axi_araddr,
    input  wire [7:0]             s_axi_arlen,
    input  wire [2:0]             s_axi_arsize,
    input  wire [1:0]             s_axi_arburst,
    input  wire                   s_axi_arlock,
    input  wire [3:0]             s_axi_arcache,
    input  wire [2:0]             s_axi_arprot,
    input  wire                   s_axi_arvalid,
    output wire                   s_axi_arready,

    output wire [ID_WIDTH-1:0]    s_axi_rid,
    output wire [DATA_WIDTH-1:0]  s_axi_rdata,
    output wire [1:0]             s_axi_rresp,
    output wire                   s_axi_rlast,
    output wire                   s_axi_rvalid,
    input  wire                   s_axi_rready,
    
    output wire                   dmem_access_err,
    output wire                   status_update
);

wire imem_addr_write  = s_axi_awaddr[CONTROL_BIT_LOC-1];
wire status_read = s_axi_araddr[CONTROL_BIT_LOC-1];
reg [1:0] write_occupancy, read_occupancy;


always @ (posedge clk)
    if (rst) begin
        write_occupancy <= 2'd0;
        read_occupancy  <= 2'd0;
    end else begin
        if (s_axi_awvalid_dmem && s_axi_awready_dmem)
          write_occupancy <= 2'd1;
        else if (s_axi_awvalid_imem && s_axi_awready_imem)
          write_occupancy <= 2'd2;
        else if (s_axi_wlast && s_axi_wvalid && s_axi_wready)
          write_occupancy <= 2'd0;

        if (s_axi_arvalid_dmem && s_axi_arready_dmem)
          read_occupancy <= 2'd1;
        else if (s_axi_arvalid_imem && s_axi_arready_imem)
          read_occupancy <= 2'd2;
        else if (s_axi_rlast && s_axi_rvalid && s_axi_rready)
          read_occupancy <= 2'd0;
    end

wire s_axi_bvalid_dmem, s_axi_rvalid_dmem;
wire s_axi_bvalid_imem, s_axi_rvalid_imem;
wire [1:0] s_axi_bresp_dmem, s_axi_rresp_dmem;
wire [1:0] s_axi_bresp_imem, s_axi_rresp_imem;
wire [ID_WIDTH-1:0] s_axi_bid_dmem, s_axi_rid_dmem;
wire [ID_WIDTH-1:0] s_axi_bid_imem, s_axi_rid_imem;
wire s_axi_rlast_dmem, s_axi_rlast_imem;
wire [DATA_WIDTH-1:0] s_axi_rdata_dmem, s_axi_rdata_imem;
wire s_axi_awready_dmem, s_axi_wready_dmem, s_axi_arready_dmem;
wire s_axi_awready_imem, s_axi_wready_imem, s_axi_arready_imem;

wire s_axi_awvalid_dmem = s_axi_awvalid && (!imem_addr_write);
wire s_axi_wvalid_dmem  = s_axi_wvalid  && (s_axi_awvalid_dmem | (write_occupancy==2'd1));
wire s_axi_arvalid_dmem = s_axi_arvalid && (!status_read);
wire s_axi_awvalid_imem = s_axi_awvalid && (imem_addr_write);
wire s_axi_wvalid_imem  = s_axi_wvalid  && (s_axi_awvalid_imem | (write_occupancy==2'd2));
wire s_axi_arvalid_imem = s_axi_arvalid && (status_read);

assign s_axi_bvalid = s_axi_bvalid_dmem | s_axi_bvalid_imem;
assign s_axi_rvalid = s_axi_rvalid_dmem | s_axi_rvalid_imem;
assign s_axi_bresp  = s_axi_bvalid_dmem ? s_axi_bresp_dmem : s_axi_bresp_imem;
assign s_axi_rresp  = s_axi_rvalid_dmem ? s_axi_rresp_dmem : s_axi_rresp_imem;
assign s_axi_bid    = s_axi_bvalid_dmem ? s_axi_bid_dmem   : s_axi_bid_imem;
assign s_axi_rid    = s_axi_rvalid_dmem ? s_axi_rid_dmem   : s_axi_rid_imem;
assign s_axi_rlast  = s_axi_rvalid_dmem ? s_axi_rlast_dmem : s_axi_rlast_imem;
assign s_axi_rdata  = s_axi_rvalid_dmem ? s_axi_rdata_dmem : s_axi_rdata_imem;

// If one of them is not ready, it means they have received a request and we cannot 
// have two read or two write requests concurrently.
assign s_axi_awready = s_axi_awready_dmem && s_axi_awready_imem;
assign s_axi_arready = s_axi_arready_dmem && s_axi_arready_imem;
// Based on which AXI write interface is activated, only one of them would be ready.
assign s_axi_wready  = s_axi_wready_dmem  | s_axi_wready_imem;

assign dmem_access_err = (s_axi_awvalid_dmem && (s_axi_arvalid_dmem | (read_occupancy==2'd1))) 
                       | (s_axi_arvalid_dmem && (s_axi_awvalid_dmem | (write_occupancy==2'd1)))
                       | (s_axi_rvalid_dmem && (read_occupancy==2'd2))
                       | (s_axi_rvalid_imem && (read_occupancy==2'd1));
 
wire dmem_en;
wire [STRB_WIDTH-1:0] dmem_we;
wire [DMEM_ADDR_WIDTH-1:0] dmem_addr;
wire [DATA_WIDTH-1:0] dmem_din, dmem_dout;

wire imem_en;
wire [STRB_WIDTH-1:0] imem_we;
wire [IMEM_ADDR_WIDTH-1:0] imem_addr;
wire [DATA_WIDTH-1:0] imem_din;
wire [31:0] imem_dout;

reg  core_reset;
wire reset_cmd = (&s_axi_awaddr[CONTROL_BIT_LOC-1:STRB_WIDTH]) && s_axi_awvalid && s_axi_wstrb[STRB_WIDTH-1];

always @ (posedge clk)
    if (rst)
        core_reset <= 1'b1;
    else if (reset_cmd)
        core_reset <= s_axi_wdata[0];

axi_to_1rw_mem #
(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(DMEM_ADDR_WIDTH),
    .PIPELINE_OUTPUT(PIPELINE_OUTPUT),
    .ID_WIDTH(ID_WIDTH)
) axi_to_dmem
(
    .clk(clk),
    .rst(rst),
    
    .s_axi_awid(s_axi_awid),
    .s_axi_awaddr(s_axi_awaddr[DMEM_ADDR_WIDTH-1:0]),
    .s_axi_awlen(s_axi_awlen),
    .s_axi_awsize(s_axi_awsize),
    .s_axi_awburst(s_axi_awburst),
    .s_axi_awlock(s_axi_awlock),
    .s_axi_awcache(s_axi_awcache),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_awvalid(s_axi_awvalid_dmem),
    .s_axi_awready(s_axi_awready_dmem),

    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wvalid(s_axi_wvalid_dmem),
    .s_axi_wready(s_axi_wready_dmem),

    .s_axi_bid(s_axi_bid_dmem),
    .s_axi_bresp(s_axi_bresp_dmem),
    .s_axi_bvalid(s_axi_bvalid_dmem),
    .s_axi_bready(s_axi_bready),

    .s_axi_arid(s_axi_arid),
    .s_axi_araddr(s_axi_araddr[DMEM_ADDR_WIDTH-1:0]),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_arsize(s_axi_arsize),
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arlock(s_axi_arlock),
    .s_axi_arcache(s_axi_arcache),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_arvalid(s_axi_arvalid_dmem),
    .s_axi_arready(s_axi_arready_dmem),

    .s_axi_rid(s_axi_rid_dmem),
    .s_axi_rdata(s_axi_rdata_dmem),
    .s_axi_rresp(s_axi_rresp_dmem),
    .s_axi_rlast(s_axi_rlast_dmem),
    .s_axi_rvalid(s_axi_rvalid_dmem),
    .s_axi_rready(s_axi_rready),

    .mem_en(dmem_en),
    .mem_we(dmem_we),
    .mem_addr(dmem_addr),
    .mem_din(dmem_din),
    .mem_dout(dmem_dout)

);

axi_to_1rw_mem #
(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(IMEM_ADDR_WIDTH),
    .PIPELINE_OUTPUT(PIPELINE_OUTPUT),
    .ID_WIDTH(ID_WIDTH)
) axi_to_imem
(
    .clk(clk),
    .rst(rst),
    
    .s_axi_awid(s_axi_awid),
    .s_axi_awaddr(s_axi_awaddr[IMEM_ADDR_WIDTH-1:0]),
    .s_axi_awlen(s_axi_awlen),
    .s_axi_awsize(s_axi_awsize),
    .s_axi_awburst(s_axi_awburst),
    .s_axi_awlock(s_axi_awlock),
    .s_axi_awcache(s_axi_awcache),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_awvalid(s_axi_awvalid_imem),
    .s_axi_awready(s_axi_awready_imem),

    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wvalid(s_axi_wvalid_imem),
    .s_axi_wready(s_axi_wready_imem),

    .s_axi_bid(s_axi_bid_imem),
    .s_axi_bresp(s_axi_bresp_imem),
    .s_axi_bvalid(s_axi_bvalid_imem),
    .s_axi_bready(s_axi_bready),

    .s_axi_arid(s_axi_arid),
    .s_axi_araddr(s_axi_araddr[IMEM_ADDR_WIDTH-1:0]),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_arsize(s_axi_arsize),
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arlock(s_axi_arlock),
    .s_axi_arcache(s_axi_arcache),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_arvalid(s_axi_arvalid_imem),
    .s_axi_arready(s_axi_arready_imem),

    .s_axi_rid(s_axi_rid_imem),
    .s_axi_rdata(s_axi_rdata_imem),
    .s_axi_rresp(s_axi_rresp_imem),
    .s_axi_rlast(s_axi_rlast_imem),
    .s_axi_rvalid(s_axi_rvalid_imem),
    .s_axi_rready(s_axi_rready),

    .mem_en(imem_en),
    .mem_we(imem_we),
    .mem_addr(imem_addr),
    .mem_din(imem_din),
    .mem_dout({{DATA_WIDTH-32{1'b0}}, imem_dout})

);

wire imem_wen = |imem_we;

riscvcore #(
  .IMEM_BYTES_PER_LINE(STRB_WIDTH),
  .DMEM_BYTES_PER_LINE(STRB_WIDTH),
  .IMEM_SIZE_BYTES(IMEM_SIZE_BYTES),
  .DMEM_SIZE_BYTES(DMEM_SIZE_BYTES),    
  .CONTROL_BIT_LOC(CONTROL_BIT_LOC),
  .STAT_ADDR_WIDTH(STAT_ADDR_WIDTH)
) core (
    .clk(clk),
    .core_reset(core_reset),

    .data_dma_en(dmem_en),
    .data_dma_we(dmem_we),
    .data_dma_addr(dmem_addr),
    .data_dma_wr_data(dmem_din),
    .data_dma_read_data(dmem_dout),

    .ins_dma_wen(imem_wen && imem_en),
    .ins_dma_stat_addr(imem_addr),
    .ins_dma_wr_data(imem_din),

    .stat_rd_en(imem_en && (!imem_wen)),
    .stat_rd_data(imem_dout),

    .status_update(status_update)
);

endmodule
