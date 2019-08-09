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
    parameter SLOT_START_ADDR = 16'h200A,
    parameter SLOT_ADDR_STEP  = 16'h0800,

    parameter STRB_WIDTH      = (DATA_WIDTH/8),
    parameter SLOT_WIDTH      = $clog2(SLOT_COUNT+1), 
    parameter SLOT_PTR_WIDTH  = $clog2(SLOT_COUNT), 
    parameter PORT_WIDTH      = $clog2(PORT_COUNT),
    parameter ID_SLOT_WIDTH   = CORE_ID_WIDTH+SLOT_WIDTH,
    parameter DMEM_ADDR_WIDTH = $clog2(DMEM_SIZE_BYTES),
    parameter MSG_WIDTH       = 4+DMEM_ADDR_WIDTH+32
)
(
    input  wire                     clk,
    input  wire                     rst,

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
reg  core_reset;
wire reset_cmd = ctrl_s_axis_tvalid && (&ctrl_s_axis_tdata[DATA_WIDTH-1:DATA_WIDTH-8]);

always @ (posedge clk)
    if (rst) 
        core_reset <= 1'b1;
    else if (reset_cmd)
        core_reset <= ctrl_s_axis_tdata[0];

/////////////////////////////////////////////////////////////////////
/////////// EXTRACTING BASE ADDR FROM/FOR INCOMING DATA /////////////
/////////////////////////////////////////////////////////////////////

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
reg  [SLOT_PTR_WIDTH-1:0] s_slot_ptr;
wire [ADDR_WIDTH-1:0]     slot_addr;

assign data_s_axis_tready = s_axis_tready;

always @ (posedge clk) begin
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
  if (rst)
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

axis_dma # (
  .DATA_WIDTH     (DATA_WIDTH),
  .ADDR_WIDTH     (ADDR_WIDTH),       
  .LEN_WIDTH      (LEN_WIDTH),        
  .DEST_WIDTH_IN  (SLOT_WIDTH),   
  .USER_WIDTH_IN  (PORT_WIDTH),   
  .DEST_WIDTH_OUT (PORT_WIDTH),  
  .USER_WIDTH_OUT (SLOT_WIDTH)  
) axis_dma_inst (
  .clk(clk),
  .rst(rst),

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
  .recv_desc_ready(recv_desc_ready),
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

simple_fifo # (
  .ADDR_WIDTH($clog2(RECV_DESC_DEPTH)),
  .DATA_WIDTH(64)
) recvd_data_fifo (
  .clk(clk),
  .rst(rst),

  .din_valid(recv_desc_valid),
  .din(recv_desc),
  .din_ready(recv_desc_ready),
 
  .dout_valid(recv_desc_valid_fifoed),
  .dout(recv_desc_fifoed),
  .dout_ready(recv_desc_ready_fifoed)
);

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
  .clk(clk),
  .rst(rst),

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

simple_fifo # (
  .ADDR_WIDTH($clog2(SEND_DESC_DEPTH)),
  .DATA_WIDTH(64)
) send_data_fifo (
  .clk(clk),
  .rst(rst),

  .din_valid(data_send_valid),
  .din(data_send_desc),
  .din_ready(data_send_ready),
 
  .dout_valid(data_out_desc_valid),
  .dout(data_out_desc),
  .dout_ready(data_out_desc_ready)
);

wire data_arbiter_v;
wire data_arbiter_select;
wire [1:0] data_arbiter_grant;

arbiter # (.PORTS(2),.TYPE("ROUND_ROBIN"),.BLOCK("REQUEST")) data_arbiter (
  .clk(clk),
  .rst(rst),
  
  .request({data_out_desc_valid,ctrl_in_valid}),
  .acknowledge(2'b0),
  
  .grant(data_arbiter_grant),
  .grant_valid(data_arbiter_v),
  .grant_encoded(data_arbiter_select)
  );

assign send_desc_valid_fifoed = data_arbiter_v;
assign send_desc_fifoed       = data_arbiter_select ? data_out_desc : ctrl_in_desc;

assign data_out_desc_ready    = send_desc_ready_fifoed && data_arbiter_grant[1];
assign ctrl_in_raedy          = send_desc_ready_fifoed && data_arbiter_grant[0];

/////////////////////////////////////////////////////////////////////
/////////////// CTRL OUT DESCRIPTOR FIFOS AND ARBITER ///////////////
/////////////////////////////////////////////////////////////////////
// A desc FIFO for msgs to scheduler
wire ctrl_send_valid, ctrl_send_ready;
wire [63:0] ctrl_send_data;

wire ctrl_send_valid_fifoed, ctrl_send_ready_fifoed;
wire [63:0] ctrl_send_data_fifoed;

simple_fifo # (
  .ADDR_WIDTH($clog2(SEND_DESC_DEPTH)),
  .DATA_WIDTH(64)
) send_ctrl_fifo (
  .clk(clk),
  .rst(rst),

  .din_valid(ctrl_send_valid),
  .din(ctrl_send_data),
  .din_ready(ctrl_send_ready),
 
  .dout_valid(ctrl_send_valid_fifoed),
  .dout(ctrl_send_data_fifoed),
  .dout_ready(ctrl_send_ready_fifoed)
);

// Latch the output descriptor and send it to controller when 
// it is transmitted
reg [63:0] latched_send_desc;
always @ (posedge clk) 
    if (send_desc_valid_fifoed && send_desc_ready_fifoed)
        latched_send_desc   <= send_desc_fifoed;

// A FIFO for outgoing control messages
wire pkt_sent_v, pkt_sent_ready;
wire [63:0] pkt_sent_desc;

simple_fifo # (
  .ADDR_WIDTH($clog2(SEND_DESC_DEPTH)),
  .DATA_WIDTH(64)
) pkt_sent_fifo (
  .clk(clk),
  .rst(rst),

  .din_valid(pkt_sent),
  .din(latched_send_desc),
  .din_ready(),
 
  .dout_valid(pkt_sent_v),
  .dout(pkt_sent_desc),
  .dout_ready(pkt_sent_ready)
);

wire ctrl_arbiter_v;
wire ctrl_arbiter_select;
wire [1:0] ctrl_arbiter_grant;

arbiter # (.PORTS(2),.TYPE("ROUND_ROBIN"),.BLOCK("REQUEST")) ctrl_arbiter (
  .clk(clk),
  .rst(rst),
  
  .request({pkt_sent_v,ctrl_send_valid_fifoed}),
  .acknowledge(2'b0),
  
  .grant(ctrl_arbiter_grant),
  .grant_valid(ctrl_arbiter_v),
  .grant_encoded(ctrl_arbiter_select)
  );

assign ctrl_m_axis_tvalid = ctrl_arbiter_v;
assign ctrl_m_axis_tdata  = ctrl_arbiter_select ? pkt_sent_desc : ctrl_send_data_fifoed;

assign ctrl_m_axis_tlast  = 1'b1;
assign pkt_sent_ready     = ctrl_m_axis_tready && ctrl_arbiter_grant [1];
assign ctrl_send_ready_fifoed = ctrl_m_axis_tready && ctrl_arbiter_grant[0];

/////////////////////////////////////////////////////////////////////
/////////////////////// BROADCAST MESSAGING /////////////////////////
/////////////////////////////////////////////////////////////////////
// A FIFO for outgoing core messages
wire [31:0]                core_msg_data;
wire [DMEM_ADDR_WIDTH-1:0] core_msg_addr;
wire [3:0]                 core_msg_strb;
wire                       core_msg_valid;

simple_fifo # (
  .ADDR_WIDTH($clog2(MSG_FIFO_DEPTH)),
  .DATA_WIDTH(MSG_WIDTH)
) core_msg_out_fifo (
  .clk(clk),
  .rst(rst),

  .din_valid(core_msg_valid),
  .din({core_msg_strb, core_msg_addr, core_msg_data}),
  .din_ready(),
 
  .dout_valid(core_msg_out_valid),
  .dout(core_msg_out_data),
  .dout_ready(core_msg_out_ready)
);

// Register and width convert incoming core msg
reg [DMEM_ADDR_WIDTH-1:0] core_msg_in_addr_r;
reg [31:0]                core_msg_in_data_r;
reg [3:0]                 core_msg_in_strb_r;
reg                       core_msg_in_v_r;

always @ (posedge clk) begin
  core_msg_in_addr_r <= core_msg_in_data[31+DMEM_ADDR_WIDTH:32];
  core_msg_in_data_r <= core_msg_in_data[31:0];
  core_msg_in_strb_r <= core_msg_in_data[MSG_WIDTH-1:MSG_WIDTH-4];
  if (rst)
    core_msg_in_v_r  <= 1'b0;
  else
    core_msg_in_v_r  <= core_msg_in_valid;
end

wire [7:0]  core_msg_write_mask = {4'd0, core_msg_in_strb_r[3:0]} << {core_msg_in_addr_r[2], 2'd0};
wire [63:0] core_msg_write_data  = {32'd0, core_msg_in_data_r} << {core_msg_in_addr_r[2], 5'd0};

/////////////////////////////////////////////////////////////////////
/////////////// SPLITTER AND ARBITER FOR DMEM ACCESS ////////////////
/////////////////////////////////////////////////////////////////////

// if rd_resp is not ready we should deassert read requests
wire read_reject = ram_rd_resp_valid && (!ram_rd_resp_ready);

// Separation of dmem and imem on dma port based on address. 
wire imem_wr_en = ram_cmd_wr_addr[ADDR_WIDTH-1] && ram_cmd_wr_en;

wire dmem_wr_en = (~ram_cmd_wr_addr[ADDR_WIDTH-1]) && ram_cmd_wr_en;
wire dmem_rd_en = (~ram_cmd_rd_addr[ADDR_WIDTH-1]) && ram_cmd_rd_en && (!read_reject);

// Arbiter for DMEM. We cannot read and write in the same cycle.
// This can be done interleaved or full write after full read based on 
// INTERLEAVE parameter. Also incoming core messages have higher priority.

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
  //core msg is processed, no requests from DMA engine
  if (core_msg_in_v_r)
    dmem_op = DMEM_IDLE; 
  else case ({dmem_wr_en,dmem_rd_en})
    2'b00: dmem_op = DMEM_IDLE;
    2'b01: dmem_op = DMEM_READ;
    2'b10: dmem_op = DMEM_WRITE;
    2'b11: 
      if (INTERLEAVE || dmem_switch) begin
        // ram_rd_resp_ready is asserted 2 cycles after rd_en, hence
        // there could be a cycle of DMEM_IDLE after rd_en, and in the 
        // following cycle both rd_en and wr_en being asserted.
        if (dmem_last_op==DMEM_IDLE)
          dmem_op = DMEM_WRITE; 
        else 
          dmem_op = ~dmem_last_op;
      end 
      else 
          dmem_op =  dmem_last_op;
  endcase

// Signals to second port of the local DMEM of the core
wire                  data_dma_en   = dmem_wr_en || dmem_rd_en || core_msg_in_v_r;
wire [ADDR_WIDTH-1:0] data_dma_addr = core_msg_in_v_r ? 
                                  {{(ADDR_WIDTH - DMEM_ADDR_WIDTH){1'b0}}, core_msg_in_addr_r} : 
                               ((dmem_op==DMEM_WRITE) ? {1'b0,ram_cmd_wr_addr[ADDR_WIDTH-2:0]} : 
                                                        {1'b0,ram_cmd_rd_addr[ADDR_WIDTH-2:0]});
wire                  data_dma_ren   = (dmem_op==DMEM_READ); 
wire [STRB_WIDTH-1:0] data_dma_wen   = core_msg_in_v_r ? core_msg_write_mask : 
                                ((dmem_op==DMEM_WRITE) ? ram_cmd_wr_strb : {STRB_WIDTH{1'b0}});
wire [DATA_WIDTH-1:0] data_dma_wr_data = core_msg_in_v_r ? core_msg_write_data : ram_cmd_wr_data;

// Signals to second port of the local IMEM of the core (just write)
// or status registers
wire [STRB_WIDTH-1:0] ins_dma_wen     = ram_cmd_wr_strb & {STRB_WIDTH{imem_wr_en}};
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
wire read_accepted = (dmem_op==DMEM_READ);
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
  .COHERENT_START(COHERENT_START),
  .MAX_SLOT_COUNT(SLOT_COUNT),
  .CORE_ID(CORE_ID),
  .SLOT_START_ADDR(SLOT_START_ADDR),
  .SLOT_ADDR_STEP(SLOT_ADDR_STEP)
) core (
    .clk(clk),
    .rst(core_reset),

    .data_dma_en(data_dma_en),
    .data_dma_ren(data_dma_ren),
    .data_dma_wen(data_dma_wen),
    .data_dma_addr(data_dma_addr),
    .data_dma_wr_data(data_dma_wr_data),
    .data_dma_rd_data(data_dma_rd_data),
    
    .ins_dma_wen(ins_dma_wen),
    .ins_dma_addr(ins_dma_addr),
    .ins_dma_wr_data(ins_dma_wr_data),
    
    .in_desc(recv_desc_fifoed),
    .in_desc_valid(recv_desc_valid_fifoed),
    .in_desc_taken(recv_desc_ready_fifoed),

    .data_desc(data_send_desc),
    .data_desc_valid(data_send_valid),
    .data_desc_ready(data_send_ready),
    
    .ctrl_desc(ctrl_send_data),
    .ctrl_desc_valid(ctrl_send_valid),
    .ctrl_desc_ready(ctrl_send_ready),

    .slot_ptr(s_slot_ptr), 
    .slot_addr(slot_addr),
 
    .core_msg_data(core_msg_data),
    .core_msg_addr(core_msg_addr),
    .core_msg_strb(core_msg_strb),
    .core_msg_valid(core_msg_valid)
);

endmodule
