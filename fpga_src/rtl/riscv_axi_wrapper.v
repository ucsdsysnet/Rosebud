// Moein Khazraee, 2019
// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * AXI4 wrapper for RISCV cores with internal memory
 */
module riscv_axi_wrapper # (
    parameter DATA_WIDTH      = 64,   
    parameter ADDR_WIDTH      = 16,
    parameter IMEM_SIZE_BYTES = 8192,
    parameter DMEM_SIZE_BYTES = 32768,
    parameter STAT_ADDR_WIDTH = 1,
    parameter ID_WIDTH        = 8,
    parameter PIPELINE_OUTPUT = 0,
    parameter INTERLEAVE      = 0,
    
    parameter STRB_WIDTH      = (DATA_WIDTH/8)
)
(
    input  wire                   clk,
    input  wire                   rst,

    /*
     * AXI slave interface
     */
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
    
    output wire                   status_update
);

/////////////////////////////////////////////////////////////////////
//////////////////////// CORE RESET COMMAND /////////////////////////
/////////////////////////////////////////////////////////////////////
reg  core_reset;
wire reset_cmd_addr = (&s_axi_awaddr[ADDR_WIDTH-1:STRB_WIDTH]) && s_axi_awvalid;
wire reset_cmd_strb = s_axi_wstrb[STRB_WIDTH-1];
reg  reset_addr_received;

always @ (posedge clk)
    if (rst) begin
        core_reset          <= 1'b1;
        reset_addr_received <= 1'b0;
    end else if (reset_cmd_addr) begin
        if (reset_cmd_strb) // if both come together no need to raise reset_addr_received
            core_reset <= s_axi_wdata[0];
        else 
            reset_addr_received <= 1'b1;
    end else if (reset_addr_received) begin
        if (reset_cmd_strb) begin
            core_reset <= s_axi_wdata[0];
            reset_addr_received <= 1'b0;
        end
    end

/////////////////////////////////////////////////////////////////////
/////////////////// READ AND WRITE INTERFACES ///////////////////////
/////////////////////////////////////////////////////////////////////
wire                   ram_cmd_wr_en;
wire [ADDR_WIDTH-1:0]  ram_cmd_wr_addr;
wire [DATA_WIDTH-1:0]  ram_cmd_wr_data;
wire [STRB_WIDTH-1:0]  ram_cmd_wr_strb;
wire                   ram_cmd_wr_last;
wire                   ram_cmd_wr_ready;

wire                   ram_cmd_rd_en;
wire [ID_WIDTH-1:0]    ram_cmd_rd_id;
wire [ADDR_WIDTH-1:0]  ram_cmd_rd_addr;
wire                   ram_cmd_rd_last;
wire                   ram_cmd_rd_ready;

wire                   ram_rd_resp_valid;
reg  [ID_WIDTH-1:0]    ram_rd_resp_id;
wire [DATA_WIDTH-1:0]  ram_rd_resp_data;
reg                    ram_rd_resp_last; 
wire                   ram_rd_resp_ready;


axi_ram_wr_if #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .STRB_WIDTH(STRB_WIDTH),
    .ID_WIDTH(ID_WIDTH)
)
axi_ram_wr_if_inst (
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
    .ram_wr_cmd_addr(ram_cmd_wr_addr),
    .ram_wr_cmd_data(ram_cmd_wr_data),
    .ram_wr_cmd_strb(ram_cmd_wr_strb),
    .ram_wr_cmd_en(ram_cmd_wr_en),
    .ram_wr_cmd_last(ram_cmd_wr_last),
    .ram_wr_cmd_ready(ram_cmd_wr_ready)
);

axi_ram_rd_if #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .STRB_WIDTH(STRB_WIDTH),
    .ID_WIDTH(ID_WIDTH),
    .PIPELINE_OUTPUT(PIPELINE_OUTPUT)
)
axi_ram_rd_if_inst (
    .clk(clk),
    .rst(rst),
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
    .ram_rd_cmd_id(ram_cmd_rd_id),
    .ram_rd_cmd_addr(ram_cmd_rd_addr),
    .ram_rd_cmd_en(ram_cmd_rd_en),
    .ram_rd_cmd_last(ram_cmd_rd_last),
    .ram_rd_cmd_ready(ram_cmd_rd_ready),
    .ram_rd_resp_id(ram_rd_resp_id),
    .ram_rd_resp_data(ram_rd_resp_data),
    .ram_rd_resp_last(ram_rd_resp_last),
    .ram_rd_resp_valid(ram_rd_resp_valid),
    .ram_rd_resp_ready(ram_rd_resp_ready)
);

/////////////////////////////////////////////////////////////////////
/////////////// SPLITTER AND ARBITER FOR DMEM ACCESS ////////////////
/////////////////////////////////////////////////////////////////////

// if rd_resp is not ready we should deassert read requests
wire read_reject = ram_rd_resp_valid && (!ram_rd_resp_ready);

// Separation of dmem and imem/stat on dma port based on address. 
wire imem_wr_en = ram_cmd_wr_addr[ADDR_WIDTH-1] && ram_cmd_wr_en;
wire stat_rd_en = ram_cmd_rd_addr[ADDR_WIDTH-1] && ram_cmd_rd_en && (!read_reject);

wire dmem_wr_en = (~ram_cmd_wr_addr[ADDR_WIDTH-1]) && ram_cmd_wr_en;
wire dmem_rd_en = (~ram_cmd_rd_addr[ADDR_WIDTH-1]) && ram_cmd_rd_en && (!read_reject);

// Arbiter for DMEM. We cannot read and write in the same cycle.
// This can be done interleaved or full write after full read based on 
// INTERLEAVE parameter.

// DMEM_WRITE and DMEM_READ are bitwise invert
localparam DMEM_IDLE  = 2'b00;
localparam DMEM_WRITE = 2'b01;
localparam DMEM_READ  = 2'b10;

reg [1:0] dmem_op, dmem_last_op;
reg dmem_switch;

always @ (posedge clk) 
  if (rst) begin
    dmem_last_op <= DMEM_IDLE;
    dmem_switch  <= 1'b0;
  end else begin
    dmem_last_op <= dmem_op;
    if (((dmem_op == DMEM_READ)  && ram_cmd_rd_last && dmem_rd_en) ||
        ((dmem_op == DMEM_WRITE) && ram_cmd_wr_last && dmem_wr_en))
      dmem_switch  <= 1'b1;
    else
      dmem_switch  <= 1'b0;
  end

always @ (*)
  case ({dmem_wr_en,dmem_rd_en})
    2'b00: dmem_op = DMEM_IDLE;
    2'b01: dmem_op = DMEM_READ;
    2'b10: dmem_op = DMEM_WRITE;
    2'b11: 
      if (INTERLEAVE || dmem_switch)
        dmem_op = ~dmem_last_op;
      else 
        dmem_op =  dmem_last_op;
  endcase

// Signals to second port of the local DMEM of the core
wire                  data_dma_en   = dmem_wr_en || dmem_rd_en;
wire [ADDR_WIDTH-1:0] data_dma_addr =  (dmem_op==DMEM_WRITE) ? 
                      {1'b0,ram_cmd_wr_addr[ADDR_WIDTH-2:0]} : 
                      {1'b0,ram_cmd_rd_addr[ADDR_WIDTH-2:0]};
wire                  data_dma_ren   = (dmem_op==DMEM_READ); 
wire [STRB_WIDTH-1:0] data_dma_wen   = (dmem_op==DMEM_WRITE) ? 
                      ram_cmd_wr_strb : {STRB_WIDTH{1'b0}};
wire [DATA_WIDTH-1:0] data_dma_wr_data = ram_cmd_wr_data;

// Signals to second port of the local IMEM of the core (just write)
// or status registers
wire [STRB_WIDTH-1:0] ins_dma_we      = ram_cmd_wr_strb & {STRB_WIDTH{imem_wr_en}};
wire [ADDR_WIDTH-1:0] ins_dma_addr    = {1'b0,ram_cmd_wr_addr[ADDR_WIDTH-2:0]};
wire [DATA_WIDTH-1:0] ins_dma_wr_data = ram_cmd_wr_data;
wire [ADDR_WIDTH-1:0] stat_rd_addr    = {1'b0,ram_cmd_rd_addr[ADDR_WIDTH-2:0]};

// MUX between read ports (DMEM/status reg)
wire [31:0] stat_rd_data;
wire [DATA_WIDTH-1:0] data_dma_rd_data;

// Remembering the last command, according to 1 cycle delay of memories 
// shows which data should be used 
reg dmem_was_read;
always @(posedge clk)
  if (rst)
    dmem_was_read <= 1'b0;
  else if (!read_reject) // don't update if read didn't go through
      dmem_was_read <= (dmem_op==DMEM_READ);
assign ram_rd_resp_data = dmem_was_read ? data_dma_rd_data : 
                        {{DATA_WIDTH-32{1'b0}}, stat_rd_data};

// If we accepted a read we latch the next values for id and last.
wire read_accepted = (dmem_op==DMEM_READ) || stat_rd_en;
always @(posedge clk)
    if (rst)
        ram_rd_resp_last <= 1'b0;
    else if (read_accepted) begin
        ram_rd_resp_id   <= ram_cmd_rd_id;
        ram_rd_resp_last <= ram_cmd_rd_last;
    end

/////////////////////////////////////////////////////////////////////
////////////////// VALID AND READY CONTROL SIGNALS //////////////////
/////////////////////////////////////////////////////////////////////

// If there was a read request to any of the memories and one of them is accepted,
// read_accpted would be 1. And since memory response is ready after a cycle
// the valid would be asserted next cycle. If read is rejected the valid remains high.
// During read_rejected cycle no new read can be processed and also since there is 
// read enable signal for both memories the data would not change.
reg read_rejected;
reg read_accepted_r; 
always @(posedge clk) 
  if(rst) begin
    read_accepted_r <= 1'b0;
    read_rejected   <= 1'b0;
  end else begin
    read_accepted_r <= read_accepted;
    read_rejected   <= read_reject; 
  end

assign ram_rd_resp_valid = read_accepted_r || read_rejected;

// The ready signal is asserted at the end of cycle, 
// meaning whether the request was accepted.
assign ram_cmd_wr_ready = !((dmem_op!=DMEM_WRITE) && dmem_wr_en);
assign ram_cmd_rd_ready = read_accepted; 

/////////////////////////////////////////////////////////////////////
/////////////////////////// RISCV CORE //////////////////////////////
/////////////////////////////////////////////////////////////////////
riscvcore #(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH),
  .IMEM_SIZE_BYTES(IMEM_SIZE_BYTES),
  .DMEM_SIZE_BYTES(DMEM_SIZE_BYTES),    
  .STAT_ADDR_WIDTH(STAT_ADDR_WIDTH)
) core (
    .clk(clk),
    .core_reset(core_reset),

    .data_dma_en(data_dma_en),
    .data_dma_ren(data_dma_ren),
    .data_dma_wen(data_dma_wen),
    .data_dma_addr(data_dma_addr),
    .data_dma_wr_data(data_dma_wr_data),
    .data_dma_rd_data(data_dma_rd_data),
    
    .ins_dma_we(ins_dma_we),
    .ins_dma_addr(ins_dma_addr),
    .ins_dma_wr_data(ins_dma_wr_data),
    
    .stat_rd_en(stat_rd_en),
    .stat_rd_addr(stat_rd_addr),
    .stat_rd_data(stat_rd_data),
    
    .status_update(status_update)
);

endmodule
