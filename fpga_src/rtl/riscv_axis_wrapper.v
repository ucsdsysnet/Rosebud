// Moein Khazraee, 2019
// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * AXIS wrapper for RISCV cores with internal memory
 */
module riscv_axis_wrapper # (
    parameter DATA_WIDTH      = 64,   
    parameter ADDR_WIDTH      = 16,
    parameter SLOT_COUNT      = 8,
    parameter IMEM_SIZE_BYTES = 8192,
    parameter DMEM_SIZE_BYTES = 32768,
    parameter COHERENT_START  = 16'h6FFF,
    parameter INTERLEAVE      = 1,
    parameter RECV_DESC_DEPTH = 8,
    parameter SEND_DESC_DEPTH = 8,
    parameter MSG_FIFO_DEPTH  = 16,
    parameter PORT_COUNT      = 4,
    parameter LEN_WIDTH       = 16,
    parameter CORE_ID         = 0,
    parameter CORE_ID_WIDTH   = 4, 
    parameter SLOT_START_ADDR = 16'h2000,
    parameter SLOT_ADDR_STEP  = 16'h0800,
    parameter HOST_PORT       = 4,

    parameter STRB_WIDTH      = (DATA_WIDTH/8),
    parameter SLOT_WIDTH      = $clog2(SLOT_COUNT+1), 
    parameter SLOT_PTR_WIDTH  = $clog2(SLOT_COUNT), 
    parameter PORT_WIDTH      = $clog2(PORT_COUNT),
    parameter ID_SLOT_WIDTH   = CORE_ID_WIDTH+SLOT_WIDTH,
    parameter DMEM_ADDR_WIDTH = $clog2(DMEM_SIZE_BYTES),
    parameter IMEM_ADDR_WIDTH = $clog2(IMEM_SIZE_BYTES),
    parameter LINE_ADDR_BITS  = $clog2(STRB_WIDTH),
    parameter MSG_WIDTH       = 4+DMEM_ADDR_WIDTH+32,
    parameter SEPARATE_CLOCKS = 1
)
(
    input  wire                     sys_clk,
    input  wire                     sys_rst,
    input  wire                     core_clk,
    input  wire                     core_rst,

    // ---------------- DATA CHANNEL --------------- // 
    // Incoming data
    input  wire [DATA_WIDTH-1:0]    data_s_axis_tdata,
    input  wire [STRB_WIDTH-1:0]    data_s_axis_tkeep,
    input  wire                     data_s_axis_tvalid,
    output wire                     data_s_axis_tready,
    input  wire                     data_s_axis_tlast,
    input  wire [ID_SLOT_WIDTH-1:0] data_s_axis_tdest,
    input  wire [PORT_WIDTH-1:0]    data_s_axis_tuser,
  
    // Outgoing data
    output wire [DATA_WIDTH-1:0]    data_m_axis_tdata,
    output wire [STRB_WIDTH-1:0]    data_m_axis_tkeep,
    output wire                     data_m_axis_tvalid,
    input  wire                     data_m_axis_tready,
    output wire                     data_m_axis_tlast,
    output wire [PORT_WIDTH-1:0]    data_m_axis_tdest,
    output wire [ID_SLOT_WIDTH-1:0] data_m_axis_tuser,
  
    // ---------------- CTRL CHANNEL --------------- // 
    // Incoming control
    input  wire [DATA_WIDTH-1:0]    ctrl_s_axis_tdata,
    input  wire                     ctrl_s_axis_tvalid,
    output wire                     ctrl_s_axis_tready,
    input  wire                     ctrl_s_axis_tlast,
    input  wire [CORE_ID_WIDTH-1:0] ctrl_s_axis_tdest,
  
    // Outgoing control
    output wire [DATA_WIDTH-1:0]    ctrl_m_axis_tdata,
    output wire                     ctrl_m_axis_tvalid,
    input  wire                     ctrl_m_axis_tready,
    output wire                     ctrl_m_axis_tlast,
    output wire [CORE_ID_WIDTH-1:0] ctrl_m_axis_tuser,

    // ------------- CORE MSG CHANNEL -------------- // 
    // Core messages output  
    output wire [MSG_WIDTH-1:0]     core_msg_out_data,
    output wire                     core_msg_out_valid,
    input  wire                     core_msg_out_ready,

    // Core messages input
    input  wire [MSG_WIDTH-1:0]     core_msg_in_data,
    input  wire                     core_msg_in_valid
);

assign data_m_axis_tuser [SLOT_WIDTH +: CORE_ID_WIDTH] = CORE_ID; 
assign ctrl_m_axis_tuser = CORE_ID;

/////////////////////////////////////////////////////////////////////
//////////////////////// CORE RESET COMMAND /////////////////////////
/////////////////////////////////////////////////////////////////////
wire reset_cmd = ctrl_s_axis_tvalid && (&ctrl_s_axis_tdata[DATA_WIDTH-1:DATA_WIDTH-8]);
reg  core_reset_r = 1'b1;

always @ (posedge sys_clk)
    if (sys_rst) 
        core_reset_r <= 1'b1;
    else if (reset_cmd)
        core_reset_r <= ctrl_s_axis_tdata[0];

wire core_reset;
if (!SEPARATE_CLOCKS) begin
  assign core_reset = core_reset_r;

end else begin
  
  simple_sync_sig #(.RST_VAL(1'b1)) reset_sync (
    .dst_clk(core_clk),
    .dst_rst(core_rst),
    .in(core_reset_r),
    .out(core_reset)
  );

end

/////////////////////////////////////////////////////////////////////
/////////// EXTRACTING BASE ADDR FROM/FOR INCOMING DATA /////////////
/////////////////////////////////////////////////////////////////////

// Internal lookup table for slot addresses
reg  [ADDR_WIDTH-1:0]     slot_addr_lut [0:SLOT_COUNT-1];
wire [ADDR_WIDTH-1:0]     slot_wr_addr;
wire [SLOT_PTR_WIDTH-1:0] slot_wr_ptr;
wire                      slot_wr_valid;
wire                      slot_wr_ready;
reg  [SLOT_PTR_WIDTH-1:0] s_slot_ptr;
wire [ADDR_WIDTH-1:0]     slot_addr;
integer j;

if (SEPARATE_CLOCKS) begin

  wire [ADDR_WIDTH-1:0]     slot_wr_addr_r;
  wire [SLOT_PTR_WIDTH-1:0] slot_wr_ptr_r;
  wire                      slot_wr_valid_r;
  
  // There is at least a cycle between two write from core if value 
  // is changed, so even double core clock 4 entries are more than enough
  simple_async_fifo # (
    .DEPTH(4),
    .DATA_WIDTH(ADDR_WIDTH+SLOT_PTR_WIDTH)
  ) recvd_data_fifo (
    .async_rst(sys_rst),
  
    .din_clk(core_clk),
    .din_valid(slot_wr_valid),
    .din({slot_wr_ptr, slot_wr_addr}),
    .din_ready(slot_wr_ready),
   
    .dout_clk(sys_clk),
    .dout_valid(slot_wr_valid_r),
    .dout({slot_wr_ptr_r, slot_wr_addr_r}),
    .dout_ready(1'b1)
  );

  always @ (posedge sys_clk)
    if (slot_wr_valid_r)
      slot_addr_lut[slot_wr_ptr_r] <= slot_wr_addr_r;

end else begin

  always @ (posedge sys_clk)
    if (slot_wr_valid)
      slot_addr_lut[slot_wr_ptr] <= slot_wr_addr;
  assign slot_wr_ready = 1'b1;

end

initial begin
  for (j=0;j<SLOT_COUNT;j=j+1)
    slot_addr_lut[j] = SLOT_START_ADDR + (j*SLOT_ADDR_STEP);
end

assign slot_addr = slot_addr_lut[s_slot_ptr]; 
 
// Pipeline register to load from slot LUT or packet header
reg  [DATA_WIDTH-1:0]     s_axis_tdata;
reg  [STRB_WIDTH-1:0]     s_axis_tkeep;
reg                       s_axis_tvalid;
wire                      s_axis_tready;
reg                       s_axis_tlast;
reg  [SLOT_WIDTH-1:0]     s_axis_tdest;
reg  [PORT_WIDTH-1:0]     s_axis_tuser;

reg                       s_has_header; 
wire [ADDR_WIDTH-1:0]     s_base_addr;

assign data_s_axis_tready = s_axis_tready;

always @ (posedge sys_clk) begin
  if (data_s_axis_tvalid && data_s_axis_tready) begin
    s_axis_tdata  <= data_s_axis_tdata;
    s_axis_tkeep  <= data_s_axis_tkeep; 
    s_axis_tlast  <= data_s_axis_tlast;
    s_axis_tdest  <= data_s_axis_tdest[SLOT_WIDTH-1:0];  
    s_axis_tuser  <= data_s_axis_tuser;  
    s_has_header  <= data_s_axis_tdest[SLOT_WIDTH-1:0]=={SLOT_WIDTH{1'b0}};
    s_slot_ptr    <= data_s_axis_tdest[SLOT_WIDTH-1:0]-1;
  end

  // If there is data and ready is asserted pipeline can move. 
  // If there is data in pipe but ready is not asserted valid stays asserted.
  s_axis_tvalid <= ((data_s_axis_tvalid && data_s_axis_tready) || 
                    (s_axis_tvalid && (!s_axis_tready)));
  if (sys_rst)
    s_axis_tvalid <= 1'b0;
end
    
// We wanna use LUTS instead of BRAM or REGS
assign s_base_addr = s_has_header ? s_axis_tdata[ADDR_WIDTH-1:0] : slot_addr;

/////////////////////////////////////////////////////////////////////
/////////// AXIS TO NATIVE MEM INTERFACE WITH DESCRIPTORS ///////////
/////////////////////////////////////////////////////////////////////
wire                   ram_cmd_wr_en;
wire [ADDR_WIDTH-1:0]  ram_cmd_wr_addr;
wire [DATA_WIDTH-1:0]  ram_cmd_wr_data;
wire [STRB_WIDTH-1:0]  ram_cmd_wr_strb;
wire                   ram_cmd_wr_last;
wire                   ram_cmd_wr_ready;

wire                   ram_cmd_rd_en;
wire [ADDR_WIDTH-1:0]  ram_cmd_rd_addr;
wire                   ram_cmd_rd_last;
wire                   ram_cmd_rd_ready;

wire                   ram_rd_resp_valid;
wire [DATA_WIDTH-1:0]  ram_rd_resp_data;
wire                   ram_rd_resp_ready;
  
wire                   recv_desc_valid;
wire                   recv_desc_ready;
wire [LEN_WIDTH-1:0]   recv_desc_len;
wire [SLOT_WIDTH-1:0]  recv_desc_tdest;
wire [PORT_WIDTH-1:0]  recv_desc_tuser;
wire [ADDR_WIDTH-1:0]  recv_desc_addr;

wire                   pkt_sent;

wire [63:0] send_desc_fifoed;
wire send_desc_valid_fifoed, send_desc_ready_fifoed;

wire from_host_msg = recv_desc_valid && (recv_desc_tuser==HOST_PORT);

axis_dma # (
  .DATA_WIDTH     (DATA_WIDTH),
  .ADDR_WIDTH     (ADDR_WIDTH),       
  .LEN_WIDTH      (LEN_WIDTH),        
  .DEST_WIDTH_IN  (SLOT_WIDTH),   
  .USER_WIDTH_IN  (PORT_WIDTH),   
  .DEST_WIDTH_OUT (PORT_WIDTH),  
  .USER_WIDTH_OUT (SLOT_WIDTH)  
) axis_dma_inst (
  .clk(sys_clk),
  .rst(sys_rst),

  .s_axis_tdata (s_axis_tdata),
  .s_axis_tkeep (s_axis_tkeep),
  .s_axis_tvalid(s_axis_tvalid),
  .s_axis_tready(s_axis_tready),
  .s_axis_tlast (s_axis_tlast),
  .s_axis_tdest (s_axis_tdest),
  .s_axis_tuser (s_axis_tuser),

  .wr_base_addr (s_base_addr),

  .m_axis_tdata (data_m_axis_tdata),
  .m_axis_tkeep (data_m_axis_tkeep),
  .m_axis_tvalid(data_m_axis_tvalid),
  .m_axis_tready(data_m_axis_tready),
  .m_axis_tlast (data_m_axis_tlast),
  .m_axis_tdest (data_m_axis_tdest),
  .m_axis_tuser (data_m_axis_tuser[SLOT_WIDTH-1:0]),
  
  .mem_wr_en   (ram_cmd_wr_en),
  .mem_wr_strb (ram_cmd_wr_strb),
  .mem_wr_addr (ram_cmd_wr_addr),
  .mem_wr_data (ram_cmd_wr_data),
  .mem_wr_last (ram_cmd_wr_last),
  .mem_wr_ready(ram_cmd_wr_ready),
  
  .mem_rd_en        (ram_cmd_rd_en),
  .mem_rd_addr      (ram_cmd_rd_addr),
  .mem_rd_last      (ram_cmd_rd_last),
  .mem_rd_ready     (ram_cmd_rd_ready),
  .mem_rd_data      (ram_rd_resp_data),
  .mem_rd_data_v    (ram_rd_resp_valid),
  .mem_rd_data_ready(ram_rd_resp_ready),
  
  .recv_desc_valid(recv_desc_valid),
  .recv_desc_ready(recv_desc_ready || from_host_msg),
  .recv_desc_len  (recv_desc_len),
  .recv_desc_tdest(recv_desc_tdest),
  .recv_desc_tuser(recv_desc_tuser),
  .recv_desc_addr (recv_desc_addr),

  .send_desc_valid(send_desc_valid_fifoed),
  .send_desc_ready(send_desc_ready_fifoed),
  .send_desc_addr(send_desc_fifoed[ADDR_WIDTH+31:32]),
  .send_desc_len(send_desc_fifoed[LEN_WIDTH-1:0]),
  .send_desc_tdest(send_desc_fifoed[PORT_WIDTH+23:24]),
  .send_desc_tuser(send_desc_fifoed[SLOT_WIDTH+15:16]),

  .pkt_sent       (pkt_sent)

);

/////////////////////////////////////////////////////////////////////
/////////////////// DATA IN DESCRIPTOR FIFO /////////////////////////
/////////////////////////////////////////////////////////////////////
// A desc FIFO for received data
wire recv_desc_valid_fifoed, recv_desc_ready_fifoed;
wire [63:0] recv_desc_fifoed;

wire [63:0] recv_desc = {recv_desc_addr,
                        {(8-PORT_WIDTH){1'b0}},recv_desc_tuser,
                        {(8-SLOT_WIDTH){1'b0}},recv_desc_tdest,
                        {(16-LEN_WIDTH){1'b0}},recv_desc_len};


if (!SEPARATE_CLOCKS) begin
  simple_fifo # (
    .ADDR_WIDTH($clog2(RECV_DESC_DEPTH)),
    .DATA_WIDTH(64)
  ) recvd_data_fifo (
    .clk(sys_clk),
    .rst(sys_rst),
    .clear(1'b0),
  
    .din_valid(recv_desc_valid && (!from_host_msg)),
    .din(recv_desc),
    .din_ready(recv_desc_ready),
   
    .dout_valid(recv_desc_valid_fifoed),
    .dout(recv_desc_fifoed),
    .dout_ready(recv_desc_ready_fifoed)
  );

end else begin
  simple_async_fifo # (
    .DEPTH(RECV_DESC_DEPTH),
    .DATA_WIDTH(64)
  ) recvd_data_fifo (
    .async_rst(sys_rst),
  
    .din_clk(sys_clk),
    .din_valid(recv_desc_valid && (!from_host_msg)),
    .din(recv_desc),
    .din_ready(recv_desc_ready),
   
    .dout_clk(core_clk),
    .dout_valid(recv_desc_valid_fifoed),
    .dout(recv_desc_fifoed),
    .dout_ready(recv_desc_ready_fifoed)
  );

end

/////////////////////////////////////////////////////////////////////
/////////////// DATA OUT DESCRIPTOR FIFOS AND ARBITER ///////////////
/////////////////////////////////////////////////////////////////////

// A desc FIFO for send data based on scheduler message
wire ctrl_in_valid, ctrl_in_ready;
wire [63:0] ctrl_in_desc;

simple_fifo # (
  .ADDR_WIDTH($clog2(RECV_DESC_DEPTH)),
  .DATA_WIDTH(64)
) recvd_ctrl_fifo (
  .clk(sys_clk),
  .rst(sys_rst),
  .clear(1'b0),

  .din_valid(ctrl_s_axis_tvalid && !reset_cmd),
  .din(ctrl_s_axis_tdata),
  .din_ready(ctrl_s_axis_tready),
 
  .dout_valid(ctrl_in_valid),
  .dout(ctrl_in_desc),
  .dout_ready(ctrl_in_ready)
);

// A desc FIFO for send data from core
wire data_send_valid, data_send_ready;
wire [63:0] data_send_desc;

wire data_out_desc_valid, data_out_desc_ready;
wire [63:0] data_out_desc;

if (!SEPARATE_CLOCKS) begin
  simple_fifo # (
    .ADDR_WIDTH($clog2(SEND_DESC_DEPTH)),
    .DATA_WIDTH(64)
  ) send_data_fifo (
    .clk(sys_clk),
    .rst(sys_rst),
    .clear(1'b0),
  
    .din_valid(data_send_valid),
    .din(data_send_desc),
    .din_ready(data_send_ready),
   
    .dout_valid(data_out_desc_valid),
    .dout(data_out_desc),
    .dout_ready(data_out_desc_ready)
  );
end else begin 
  simple_async_fifo # (
    .DEPTH(SEND_DESC_DEPTH),
    .DATA_WIDTH(64)
  ) send_data_fifo (
    .async_rst(sys_rst),
  
    .din_clk(core_clk),
    .din_valid(data_send_valid),
    .din(data_send_desc),
    .din_ready(data_send_ready),
   
    .dout_clk(sys_clk),
    .dout_valid(data_out_desc_valid),
    .dout(data_out_desc),
    .dout_ready(data_out_desc_ready)
  );
end

// Simple arbiter among the 2 FIFOs, priority to messages from controller 
wire   data_select            = ctrl_in_valid;
assign send_desc_valid_fifoed = ctrl_in_valid || data_out_desc_valid;
assign send_desc_fifoed       = data_select ? ctrl_in_desc : data_out_desc;
assign data_out_desc_ready    = send_desc_ready_fifoed && (!data_select);
assign ctrl_in_ready          = send_desc_ready_fifoed &&   data_select ;
 
/////////////////////////////////////////////////////////////////////
/////////////// CTRL OUT DESCRIPTOR FIFOS AND ARBITER ///////////////
/////////////////////////////////////////////////////////////////////
// A desc FIFO for msgs to scheduler
wire ctrl_send_valid, ctrl_send_ready;
wire [63:0] ctrl_send_data;

wire ctrl_send_valid_fifoed, ctrl_send_ready_fifoed;
wire [63:0] ctrl_send_data_fifoed;

if (!SEPARATE_CLOCKS) begin
  simple_fifo # (
    .ADDR_WIDTH($clog2(SEND_DESC_DEPTH)),
    .DATA_WIDTH(64)
  ) send_ctrl_fifo (
    .clk(sys_clk),
    .rst(sys_rst),
    .clear(1'b0),
  
    .din_valid(ctrl_send_valid),
    .din(ctrl_send_data),
    .din_ready(ctrl_send_ready),
   
    .dout_valid(ctrl_send_valid_fifoed),
    .dout(ctrl_send_data_fifoed),
    .dout_ready(ctrl_send_ready_fifoed)
  );
end else begin
  simple_async_fifo # (
    .DEPTH(SEND_DESC_DEPTH),
    .DATA_WIDTH(64)
  ) send_ctrl_fifo (
    .async_rst(sys_rst),
  
    .din_clk(core_clk),
    .din_valid(ctrl_send_valid),
    .din(ctrl_send_data),
    .din_ready(ctrl_send_ready),
   
    .dout_clk(sys_clk),
    .dout_valid(ctrl_send_valid_fifoed),
    .dout(ctrl_send_data_fifoed),
    .dout_ready(ctrl_send_ready_fifoed)
  );
end

// Latch the output descriptor and send it to controller when 
// it is transmitted
reg [63:0] latched_send_desc;
always @ (posedge sys_clk) 
    if (send_desc_valid_fifoed && send_desc_ready_fifoed)
        latched_send_desc   <= send_desc_fifoed;

// A FIFO for outgoing control messages
wire pkt_sent_v, pkt_sent_ready;
wire [63:0] pkt_sent_desc;

simple_fifo # (
  .ADDR_WIDTH($clog2(SEND_DESC_DEPTH)),
  .DATA_WIDTH(64)
) pkt_sent_fifo (
  .clk(sys_clk),
  .rst(sys_rst),
  .clear(1'b0),

  .din_valid(pkt_sent),
  .din(latched_send_desc),
  .din_ready(),
 
  .dout_valid(pkt_sent_v),
  .dout(pkt_sent_desc),
  .dout_ready(pkt_sent_ready)
);

// Simple arbiter among the 2 FIFOs, priority to releasing a desc
wire   ctrl_select            = pkt_sent_v;
assign ctrl_m_axis_tvalid     = pkt_sent_v || ctrl_send_valid_fifoed; 
assign ctrl_m_axis_tdata      = ctrl_select ? pkt_sent_desc : ctrl_send_data_fifoed;
assign ctrl_m_axis_tlast      = 1'b1;
assign ctrl_send_ready_fifoed = ctrl_m_axis_tready && (!ctrl_select);
assign pkt_sent_ready         = ctrl_m_axis_tready &&   ctrl_select ;
 
/////////////////////////////////////////////////////////////////////
/////////////////////// BROADCAST MESSAGING /////////////////////////
/////////////////////////////////////////////////////////////////////
// A FIFO for outgoing core messages.
wire [31:0]                core_msg_data;
wire [DMEM_ADDR_WIDTH-1:0] core_msg_addr;
wire [3:0]                 core_msg_strb;
wire                       core_msg_valid;
wire                       core_msg_ready;

// Broadcast messaging is in core clk domain
simple_fifo # (
  .ADDR_WIDTH($clog2(MSG_FIFO_DEPTH)),
  .DATA_WIDTH(MSG_WIDTH)
) core_msg_out_fifo (
  .clk(core_clk),
  .rst(core_reset),
  .clear(1'b0),

  .din_valid(core_msg_valid),
  .din({core_msg_strb, core_msg_addr, core_msg_data}),
  .din_ready(core_msg_ready),
 
  .dout_valid(core_msg_out_valid),
  .dout(core_msg_out_data),
  .dout_ready(core_msg_out_ready)
);

// Register and width convert incoming core msg
reg [DMEM_ADDR_WIDTH-1:0] core_msg_in_addr_r;
reg [31:0]                core_msg_in_data_r;
reg [3:0]                 core_msg_in_strb_r;
reg                       core_msg_in_v_r;

always @ (posedge core_clk) begin
  core_msg_in_addr_r <= core_msg_in_data[31+DMEM_ADDR_WIDTH:32];
  core_msg_in_data_r <= core_msg_in_data[31:0];
  core_msg_in_strb_r <= core_msg_in_data[MSG_WIDTH-1:MSG_WIDTH-4];
  if (core_rst)
    core_msg_in_v_r  <= 1'b0;
  else
    core_msg_in_v_r  <= core_msg_in_valid;
end

wire [7:0]  core_msg_write_mask = {4'd0, core_msg_in_strb_r[3:0]} << {core_msg_in_addr_r[2], 2'd0};
wire [63:0] core_msg_write_data = {32'd0, core_msg_in_data_r} << {core_msg_in_addr_r[2], 5'd0};

/////////////////////////////////////////////////////////////////////
/////////////// SPLITTER AND ARBITER FOR DMEM ACCESS ////////////////
/////////////////////////////////////////////////////////////////////

// if rd_resp is not ready we should deassert read requests
wire read_reject = ram_rd_resp_valid && (!ram_rd_resp_ready);

// Separation of dmem and imem on dma port based on address. 
wire dma_imem_wr_en = ram_cmd_wr_addr[ADDR_WIDTH-1] && ram_cmd_wr_en;

wire dma_dmem_wr_en = (~ram_cmd_wr_addr[ADDR_WIDTH-1]) && ram_cmd_wr_en;
wire dma_dmem_rd_en = (~ram_cmd_rd_addr[ADDR_WIDTH-1]) && ram_cmd_rd_en && (!read_reject);

// Arbiter for DMEM. We cannot read and write in the same cycle.
// This can be done interleaved or full write after full read based on 
// INTERLEAVE parameter. Also incoming core messages have higher priority.

// DMEM_WRITE and DMEM_READ are bitwise invert
localparam DMEM_IDLE  = 2'b00;
localparam DMEM_WRITE = 2'b01;
localparam DMEM_READ  = 2'b10;

reg [1:0] dma_dmem_op, dma_dmem_last_op;
reg dmam_dmem_switch;

always @ (posedge sys_clk) 
  if (sys_rst) begin
    dma_dmem_last_op <= DMEM_IDLE;
    dmam_dmem_switch  <= 1'b0;
  end else begin
    dma_dmem_last_op <= dma_dmem_op;
    if (((dma_dmem_op == DMEM_READ)  && ram_cmd_rd_last && dma_dmem_rd_en) ||
        ((dma_dmem_op == DMEM_WRITE) && ram_cmd_wr_last && dma_dmem_wr_en))
      dmam_dmem_switch  <= 1'b1;
    else
      dmam_dmem_switch  <= 1'b0;
  end

always @ (*)
  //core msg is processed, no requests from DMA engine
  case ({dma_dmem_wr_en,dma_dmem_rd_en})
    2'b00: dma_dmem_op = DMEM_IDLE;
    2'b01: dma_dmem_op = DMEM_READ;
    2'b10: dma_dmem_op = DMEM_WRITE;
    2'b11: 
      if (INTERLEAVE || dmam_dmem_switch) begin
        // ram_rd_resp_ready is asserted 2 cycles after rd_en, hence
        // there could be a cycle of DMEM_IDLE after rd_en, and in the 
        // following cycle both rd_en and wr_en being asserted.
        if (dma_dmem_last_op==DMEM_IDLE)
          dma_dmem_op = DMEM_WRITE; 
        else 
          dma_dmem_op = ~dma_dmem_last_op;
      end 
      else 
          dma_dmem_op =  dma_dmem_last_op;
  endcase

// Signals to second port of the local DMEM of the core
wire                  data_dma_en   = dma_dmem_wr_en || dma_dmem_rd_en;
wire [ADDR_WIDTH-1:0] data_dma_addr = (dma_dmem_op==DMEM_WRITE) ?
                                      {1'b0,ram_cmd_wr_addr[ADDR_WIDTH-2:0]}: 
                                      {1'b0,ram_cmd_rd_addr[ADDR_WIDTH-2:0]};
wire                  data_dma_ren   = (dma_dmem_op==DMEM_READ); 
wire [STRB_WIDTH-1:0] data_dma_wen   = ((dma_dmem_op==DMEM_WRITE) ? 
                                       ram_cmd_wr_strb : {STRB_WIDTH{1'b0}});
wire [DATA_WIDTH-1:0] data_dma_wr_data = ram_cmd_wr_data;

// Signals to second port of the local IMEM of the core (just write)
// or status registers
wire [STRB_WIDTH-1:0] ins_dma_wen     = ram_cmd_wr_strb & {STRB_WIDTH{dma_imem_wr_en}};
wire [ADDR_WIDTH-1:0] ins_dma_addr    = {1'b0,ram_cmd_wr_addr[ADDR_WIDTH-2:0]};
wire [DATA_WIDTH-1:0] ins_dma_wr_data = ram_cmd_wr_data;
wire [DATA_WIDTH-1:0] data_dma_rd_data;

assign ram_rd_resp_data = data_dma_rd_data;

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
wire read_accepted = (dma_dmem_op==DMEM_READ);
always @(posedge sys_clk) 
  if(sys_rst) begin
    read_accepted_r <= 1'b0;
    read_rejected   <= 1'b0;
  end else begin
    read_accepted_r <= read_accepted;
    read_rejected   <= read_reject; 
  end

assign ram_rd_resp_valid = read_accepted_r || read_rejected;

// The ready signal is asserted at the end of cycle, 
// meaning whether the request was accepted.
assign ram_cmd_wr_ready = !((dma_dmem_op!=DMEM_WRITE) && dma_dmem_wr_en);
assign ram_cmd_rd_ready = read_accepted; 

///////////////////////////////////////////////////////////////////////////
//////////////////////////// MEMORY UNITS /////////////////////////////////
///////////////////////////////////////////////////////////////////////////
wire                  core_imem_ren;
wire [ADDR_WIDTH-1:0] core_imem_addr;
wire [DATA_WIDTH-1:0] core_imem_rd_data;

wire                  core_dmem_en;
wire                  core_dmem_ren;
wire [STRB_WIDTH-1:0] core_dmem_wen;
wire [ADDR_WIDTH-1:0] core_dmem_addr;
wire [DATA_WIDTH-1:0] core_dmem_wr_data;
wire [DATA_WIDTH-1:0] core_dmem_rd_data;
wire                  core_dmem_ready;

// Muxing between incoming msg data and core dmem access
wire                  dmem_en;
wire                  dmem_ren;
wire [STRB_WIDTH-1:0] dmem_wen;
wire [ADDR_WIDTH-1:0] dmem_addr;
wire [DATA_WIDTH-1:0] dmem_wr_data;
wire [DATA_WIDTH-1:0] dmem_rd_data;

assign dmem_en      = core_msg_in_v_r || core_dmem_en; 
assign dmem_ren     = core_dmem_ren && !core_msg_in_v_r;
assign dmem_wen     = core_msg_in_v_r ? core_msg_write_mask : core_dmem_wen;
assign dmem_addr    = core_msg_in_v_r ? core_msg_in_addr_r : core_dmem_addr;
assign dmem_wr_data = core_msg_in_v_r ? core_msg_write_data : core_dmem_wr_data;

assign core_dmem_rd_data = dmem_rd_data;
assign core_dmem_ready   = !core_msg_in_v_r;

mem_2rw #(
  .BYTES_PER_LINE(STRB_WIDTH),
  .ADDR_WIDTH(DMEM_ADDR_WIDTH-LINE_ADDR_BITS)    
) dmem (
  .clka(sys_clk),
  .ena(data_dma_en),
  .rena(data_dma_ren),
  .wena(data_dma_wen),
  .addra(data_dma_addr[DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS]),
  .dina(data_dma_wr_data),
  .douta(data_dma_rd_data),

  .clkb(core_clk),
  .enb(dmem_en),
  .renb(dmem_ren),
  .wenb(dmem_wen),
  .addrb(dmem_addr[DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS]),
  .dinb(dmem_wr_data),
  .doutb(dmem_rd_data)
);

mem_1r1w #(
  .BYTES_PER_LINE(STRB_WIDTH),
  .ADDR_WIDTH(IMEM_ADDR_WIDTH-LINE_ADDR_BITS)    
) imem (
  .clka(sys_clk),
  .ena(|(ins_dma_wen)),
  .wea(ins_dma_wen),
  .addra(ins_dma_addr[IMEM_ADDR_WIDTH-1:LINE_ADDR_BITS]),
  .dina(ins_dma_wr_data),

  .clkb(core_clk),
  .enb(core_imem_ren),
  .addrb(core_imem_addr[IMEM_ADDR_WIDTH-1:LINE_ADDR_BITS]),
  .doutb(core_imem_rd_data)
);

// External memory access out of bound detection
reg out_of_bound;
wire out_of_bound_clear;

always @(posedge sys_clk)
  if (sys_rst || out_of_bound_clear)
    out_of_bound <= 1'b0;
  else 
    out_of_bound <= out_of_bound || 
                 ((data_dma_en && (|data_dma_addr[ADDR_WIDTH-1:DMEM_ADDR_WIDTH])) ||
                 ((|ins_dma_wen)  && (|ins_dma_addr[ADDR_WIDTH-1:IMEM_ADDR_WIDTH])));

wire core_interrupt, core_interrupt_ack;

if (SEPARATE_CLOCKS) begin

  // Interrupt stays high until core addresses the problem, so a simple sync without 
  // handshake is enough. Ack also stays high for 2 cycles, so a simple sync is enough.
  simple_sync_sig #(.RST_VAL(1'b0)) interrupt_sync (
      .dst_clk(core_clk),
      .dst_rst(core_rst),
      .in(out_of_bound),
      .out(core_interrupt)
  );
  
  simple_sync_sig #(.RST_VAL(1'b0)) interrupt_ack_sync (
       .dst_clk(sys_clk),
       .dst_rst(sys_rst),
       .in(core_interrupt_ack),
       .out(out_of_bound_clear)
   );

  // sync_signal #(.WIDTH(1), .N(2)) interrupt_sync (
  //     .clk(core_clk),
  //     .in(out_of_bound),
  //     .out(core_interrupt)
  // );

  // sync_signal #(.WIDTH(1), .N(2)) interrupt_ack_sync (
  //     .clk(sys_clk),
  //     .in(core_interrupt_ack),
  //     .out(out_of_bound_clear)
  // );

end else begin 
   assign core_interrupt = out_of_bound;
   assign out_of_bound_clear = core_interrupt_ack;
end

/////////////////////////////////////////////////////////////////////
/////////////////////////// RISCV CORE //////////////////////////////
/////////////////////////////////////////////////////////////////////
riscvcore #(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH),
  .IMEM_SIZE_BYTES(IMEM_SIZE_BYTES),
  .DMEM_SIZE_BYTES(DMEM_SIZE_BYTES),    
  .COHERENT_START(COHERENT_START),
  .SLOT_PTR_WIDTH(SLOT_PTR_WIDTH),
  .CORE_ID(CORE_ID)
) core (
    .clk(core_clk),
    .rst(core_reset),

    .ext_dmem_en(core_dmem_en),
    .ext_dmem_ren(core_dmem_ren),
    .ext_dmem_wen(core_dmem_wen),
    .ext_dmem_addr(core_dmem_addr),
    .ext_dmem_wr_data(core_dmem_wr_data),
    .ext_dmem_rd_data(core_dmem_rd_data),
    .ext_dmem_ready(core_dmem_ready),
    
    .ext_imem_ren(core_imem_ren),
    .ext_imem_addr(core_imem_addr),
    .ext_imem_rd_data(core_imem_rd_data),
    
    .in_desc(recv_desc_fifoed),
    .in_desc_valid(recv_desc_valid_fifoed),
    .in_desc_taken(recv_desc_ready_fifoed),

    .data_desc(data_send_desc),
    .data_desc_valid(data_send_valid),
    .data_desc_ready(data_send_ready),
    
    .ctrl_desc(ctrl_send_data),
    .ctrl_desc_valid(ctrl_send_valid),
    .ctrl_desc_ready(ctrl_send_ready),

    .slot_wr_ptr(slot_wr_ptr), 
    .slot_wr_addr(slot_wr_addr),
    .slot_wr_valid(slot_wr_valid),
    .slot_wr_ready(slot_wr_ready),
 
    .core_msg_data(core_msg_data),
    .core_msg_addr(core_msg_addr),
    .core_msg_strb(core_msg_strb),
    .core_msg_valid(core_msg_valid),
    .core_msg_ready(core_msg_ready),

    .interrupt_in(core_interrupt),
    .interrupt_in_ack(core_interrupt_ack)
);

endmodule
