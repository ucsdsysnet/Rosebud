module riscv_axi_wrapper # (
    parameter DATA_WIDTH      = 64,       // width of data bus in bits
    parameter ADDR_WIDTH      = 16,
    parameter IMEM_SIZE_BYTES = 8192,
    parameter DMEM_SIZE_BYTES = 32768,
    parameter CONTROL_BIT_LOC = 16,
    parameter STAT_ADDR_WIDTH = 1,
    parameter ID_WIDTH        = 8,
    parameter PIPELINE_OUTPUT = 0,
    
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

reg  core_reset;
wire reset_cmd = (&s_axi_awaddr[CONTROL_BIT_LOC-1:STRB_WIDTH]) 
                 && s_axi_awvalid && s_axi_wstrb[STRB_WIDTH-1];

always @ (posedge clk)
    if (rst)
        core_reset <= 1'b1;
    else if (reset_cmd)
        core_reset <= s_axi_wdata[0];

wire [ADDR_WIDTH-1:0]  mem_rd_addr;
wire [DATA_WIDTH-1:0]  mem_dout;
wire [STRB_WIDTH-1:0]  mem_wen;
wire [ADDR_WIDTH-1:0]  mem_wr_addr;
wire [DATA_WIDTH-1:0]  mem_din;

axi_to_1r1w_mem #
(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .PIPELINE_OUTPUT(PIPELINE_OUTPUT),
    .ID_WIDTH(ID_WIDTH)
) axi_to_native_mem
(
    .clk(clk),
    .rst(rst),
    
    .s_axi_awid(s_axi_awid),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awlen(s_axi_awlen),
    .s_axi_awsize(s_axi_awsize),
    .s_axi_awburst(s_axi_awburst),
    .s_axi_awlock(s_axi_awlock),
    .s_axi_awcache(s_axi_awcache),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_awvalid(s_axi_awvalid), 
    .s_axi_awready(s_axi_awready),

    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wvalid(s_axi_wvalid), 
    .s_axi_wready(s_axi_wready),

    .s_axi_bid(s_axi_bid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),

    .s_axi_arid(s_axi_arid),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_arsize(s_axi_arsize),
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arlock(s_axi_arlock),
    .s_axi_arcache(s_axi_arcache),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),

    .s_axi_rid(s_axi_rid),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rlast(s_axi_rlast),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),

    .mem_ren(mem_ren),
    .mem_rd_addr(mem_rd_addr),
    .mem_dout(mem_dout),

    .mem_wen(mem_wen),
    .mem_wr_addr(mem_wr_addr),
    .mem_din(mem_din)

);

riscvcore #(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH),
  .IMEM_SIZE_BYTES(IMEM_SIZE_BYTES),
  .DMEM_SIZE_BYTES(DMEM_SIZE_BYTES),    
  .CONTROL_BIT_LOC(CONTROL_BIT_LOC),
  .STAT_ADDR_WIDTH(STAT_ADDR_WIDTH)
) core (
    .clk(clk),
    .core_reset(core_reset),

    .status_update(status_update),
    .dmem_access_err(dmem_access_err),

    .mem_ren(mem_ren),
    .mem_rd_addr(mem_rd_addr),
    .mem_dout(mem_dout),

    .mem_wen(mem_wen),
    .mem_wr_addr(mem_wr_addr),
    .mem_din(mem_din)
);

endmodule
