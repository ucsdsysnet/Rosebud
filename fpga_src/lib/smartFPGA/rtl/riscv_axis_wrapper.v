// Moein Khazraee, 2019
// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * AXIS wrapper for RISCV cores with internal memory
 */
module riscv_axis_wrapper # (
    parameter DATA_WIDTH       = 64,   
    parameter PORT_WIDTH       = 3,
    parameter CORE_ID_WIDTH    = 4, 
    parameter DRAM_PORT        = 6,
    parameter SLOT_COUNT       = 8,
    parameter MSG_WIDTH        = 46,
    parameter STRB_WIDTH       = (DATA_WIDTH/8),
    parameter SLOT_WIDTH       = $clog2(SLOT_COUNT+1), 
    parameter TAG_WIDTH        = (SLOT_WIDTH>5)? SLOT_WIDTH:5,
    parameter ID_TAG_WIDTH     = CORE_ID_WIDTH+TAG_WIDTH,
    
    parameter RECV_DESC_DEPTH  = 8,
    parameter SEND_DESC_DEPTH  = 8,
    parameter DRAM_DESC_DEPTH  = 16,
    parameter MSG_FIFO_DEPTH   = 16,
    
    parameter MAX_PKT_HDR_SIZE = 128,
    parameter SLOT_START_ADDR  = 16'h0,
    parameter SLOT_ADDR_STEP   = 16'h0400,
    parameter HDR_START_ADDR   = 16'h5C00,

    parameter DATA_S_REG_TYPE  = 0,
    parameter DATA_M_REG_TYPE  = 2,
    parameter DRAM_M_REG_TYPE  = 0
)
(
    input  wire                     clk,
    input  wire                     rst,
    
    input  wire [CORE_ID_WIDTH-1:0] core_id,
    
    // ---------------- DATA CHANNEL --------------- // 
    // Incoming data
    input  wire [DATA_WIDTH-1:0]    data_s_axis_tdata,
    input  wire [STRB_WIDTH-1:0]    data_s_axis_tkeep,
    input  wire                     data_s_axis_tvalid,
    output wire                     data_s_axis_tready,
    input  wire                     data_s_axis_tlast,
    input  wire [TAG_WIDTH-1:0]     data_s_axis_tdest,
    input  wire [PORT_WIDTH-1:0]    data_s_axis_tuser,
  
    // Outgoing data
    output wire [DATA_WIDTH-1:0]    data_m_axis_tdata,
    output wire [STRB_WIDTH-1:0]    data_m_axis_tkeep,
    output wire                     data_m_axis_tvalid,
    input  wire                     data_m_axis_tready,
    output wire                     data_m_axis_tlast,
    output wire [PORT_WIDTH-1:0]    data_m_axis_tdest,
    output wire [TAG_WIDTH-1:0]     data_m_axis_tuser,
  
    // ---------------- CTRL CHANNEL --------------- // 
    // Incoming control
    input  wire [35:0]              ctrl_s_axis_tdata,
    input  wire                     ctrl_s_axis_tvalid,
    output wire                     ctrl_s_axis_tready,
    input  wire                     ctrl_s_axis_tlast,
  
    // Outgoing control
    output wire [35:0]              ctrl_m_axis_tdata,
    output wire                     ctrl_m_axis_tvalid,
    input  wire                     ctrl_m_axis_tready,
    output wire                     ctrl_m_axis_tlast,
    
    // ------------ DRAM RD REQ CHANNEL ------------- // 
    // Incoming DRAM request
    input  wire [63:0]              dram_s_axis_tdata,
    input  wire                     dram_s_axis_tvalid,
    output wire                     dram_s_axis_tready,
    input  wire                     dram_s_axis_tlast,
  
    // Outgoing DRAM request
    output wire [63:0]              dram_m_axis_tdata,
    output wire                     dram_m_axis_tvalid,
    input  wire                     dram_m_axis_tready,
    output wire                     dram_m_axis_tlast,
    
    // ------------- CORE MSG CHANNEL -------------- // 
    // Core messages output 
    output wire [MSG_WIDTH-1:0]     core_msg_out,
    output wire                     core_msg_out_valid,
    input  wire                     core_msg_out_ready,

    // Core messages input
    input  wire [MSG_WIDTH-1:0]     core_msg_in,
    input  wire [CORE_ID_WIDTH-1:0] core_msg_in_user,
    input  wire                     core_msg_in_valid,

    // --------------------------------------------- //
    // ------- CONNECTION TO RISCV_BLOCK ----------- //
    // --------------------------------------------- //

    output wire                     core_reset,
    output wire                     core_interrupt,
    input  wire                     core_interrupt_ack,
    
    // DMA interface
    output wire                     dma_cmd_wr_en,
    output wire [25:0]              dma_cmd_wr_addr,
    output wire                     dma_cmd_hdr_wr_en,
    output wire [23:0]              dma_cmd_hdr_wr_addr,
    output wire [DATA_WIDTH-1:0]    dma_cmd_wr_data,
    output wire [STRB_WIDTH-1:0]    dma_cmd_wr_strb,
    output wire                     dma_cmd_wr_last,
    input  wire                     dma_cmd_wr_ready,
    
    output wire                     dma_cmd_rd_en,
    output wire [25:0]              dma_cmd_rd_addr,
    output wire                     dma_cmd_rd_last,
    input  wire                     dma_cmd_rd_ready,
    
    input  wire                     dma_rd_resp_valid,
    input  wire [DATA_WIDTH-1:0]    dma_rd_resp_data,
    output wire                     dma_rd_resp_ready,
      
    // Descriptor to/from core 
    output wire [63:0]              in_desc,
    output wire                     in_desc_valid,
    input  wire                     in_desc_taken,

    input  wire [63:0]              out_desc,
    input  wire [63:0]              out_desc_dram_addr,
    input  wire                     out_desc_valid,
    output wire                     out_desc_ready,

    // Slot information from core
    input  wire [SLOT_WIDTH-1:0]    slot_wr_ptr, 
    input  wire [24:0]              slot_wr_addr,
    input  wire                     slot_wr_valid,
    input  wire                     slot_for_hdr,
    output wire                     slot_wr_ready,
 
    // Received DRAM and active slots info to core
    output wire [4:0]               recv_dram_tag,
    output wire                     recv_dram_tag_valid,
    output wire [SLOT_COUNT-1:0]    active_slots,
    
    // Messages from the core
    input  wire [MSG_WIDTH-1:0]     bc_msg_out,
    input  wire                     bc_msg_out_valid,
    output wire                     bc_msg_out_ready,

    // Messages to the core
    output reg  [MSG_WIDTH-1:0]     bc_msg_in,
    output reg  [CORE_ID_WIDTH-1:0] bc_msg_in_user,
    output reg                      bc_msg_in_valid
);
    
/////////////////////////////////////////////////////////////////////
//////////////////////// CORE RESET COMMAND /////////////////////////
/////////////////////////////////////////////////////////////////////
wire reset_cmd = ctrl_s_axis_tvalid && (&ctrl_s_axis_tdata[35:32]);
reg  core_reset_r;

always @ (posedge clk)
    if (rst) 
        core_reset_r <= 1'b1;
    else if (reset_cmd)
        core_reset_r <= ctrl_s_axis_tdata[0];

assign core_reset = core_reset_r;

/////////////////////////////////////////////////////////////////////
/////////// EXTRACTING BASE ADDR FROM/FOR INCOMING DATA /////////////
/////////////////////////////////////////////////////////////////////
parameter HDR_ADDR_BITS  = $clog2(MAX_PKT_HDR_SIZE);
parameter HDR_MSB_WIDTH = 24-HDR_ADDR_BITS;

// Internal lookup table for slot addresses
reg  [24:0] slot_addr_lut [1:SLOT_COUNT];
wire [24:0] slot_addr;
wire [SLOT_WIDTH-1:0] s_slot_ptr;

reg  [HDR_MSB_WIDTH-1:0] slot_hdr_addr_msb_lut [1:SLOT_COUNT];
wire [HDR_MSB_WIDTH-1:0] slot_hdr_msb;

always @ (posedge clk)
  if (slot_wr_valid)
    if (slot_for_hdr)
      slot_hdr_addr_msb_lut[slot_wr_ptr] <= slot_wr_addr[24:HDR_ADDR_BITS];
    else 
      slot_addr_lut        [slot_wr_ptr] <= slot_wr_addr;

assign slot_wr_ready = 1'b1;

integer j;
initial begin
  for (j=1;j<=SLOT_COUNT;j=j+1) begin
    slot_addr_lut[j]         = SLOT_START_ADDR + ((j-1)*SLOT_ADDR_STEP);
    slot_hdr_addr_msb_lut[j] = (HDR_START_ADDR>>$clog2(MAX_PKT_HDR_SIZE)) + (j-1);
  end
end
 
// Pipeline register to load from slot LUT or packet header
wire [DATA_WIDTH-1:0] data_s_axis_tdata_r;
wire [STRB_WIDTH-1:0] data_s_axis_tkeep_r;
wire                  data_s_axis_tvalid_r;
wire                  data_s_axis_tready_r;
wire                  data_s_axis_tlast_r;
wire [TAG_WIDTH-1:0]  data_s_axis_tdest_r;
wire [PORT_WIDTH-1:0] data_s_axis_tuser_r;

wire [DATA_WIDTH-1:0] s_axis_tdata;
wire [STRB_WIDTH-1:0] s_axis_tkeep;
wire                  s_axis_tvalid;
wire                  s_axis_tready;
wire                  s_axis_tlast;
wire [TAG_WIDTH-1:0]  s_axis_tdest;
wire [PORT_WIDTH-1:0] s_axis_tuser;

// register input data
axis_register # (
    .DATA_WIDTH(DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(STRB_WIDTH),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(1),
    .DEST_WIDTH(TAG_WIDTH),
    .USER_ENABLE(1),
    .USER_WIDTH(PORT_WIDTH),
    .REG_TYPE(DATA_S_REG_TYPE)
) data_s_reg_inst (
    .clk(clk),
    .rst(rst),
    // AXI input
    .s_axis_tdata (data_s_axis_tdata),
    .s_axis_tkeep (data_s_axis_tkeep),
    .s_axis_tvalid(data_s_axis_tvalid),
    .s_axis_tready(data_s_axis_tready),
    .s_axis_tlast (data_s_axis_tlast),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (data_s_axis_tdest),
    .s_axis_tuser (data_s_axis_tuser),
    // AXI output
    .m_axis_tdata (data_s_axis_tdata_r),
    .m_axis_tkeep (data_s_axis_tkeep_r),
    .m_axis_tvalid(data_s_axis_tvalid_r),
    .m_axis_tready(data_s_axis_tready_r),
    .m_axis_tlast (data_s_axis_tlast_r),
    .m_axis_tid   (),
    .m_axis_tdest (data_s_axis_tdest_r),
    .m_axis_tuser (data_s_axis_tuser_r)
);

wire [PORT_WIDTH-1:0] dram_port = DRAM_PORT;
wire [25:0]           s_header_addr;
wire [25:0]           s_base_addr;
wire [63:0]           incoming_hdr;
wire                  incoming_hdr_v;

header_remover # (
  .DATA_WIDTH(DATA_WIDTH),
  .HDR_WIDTH(64),
  .DEST_WIDTH(TAG_WIDTH),
  .USER_WIDTH(PORT_WIDTH)
) dram_header_remover (
  .clk(clk),
  .rst(rst),

  .has_header   (data_s_axis_tuser_r==dram_port),

  .s_axis_tdata (data_s_axis_tdata_r),
  .s_axis_tkeep (data_s_axis_tkeep_r),
  .s_axis_tdest (data_s_axis_tdest_r),
  .s_axis_tuser (data_s_axis_tuser_r),
  .s_axis_tlast (data_s_axis_tlast_r),
  .s_axis_tvalid(data_s_axis_tvalid_r),
  .s_axis_tready(data_s_axis_tready_r),

  .header       (incoming_hdr),
  .header_valid (incoming_hdr_v),

  .m_axis_tdata (s_axis_tdata),
  .m_axis_tkeep (s_axis_tkeep),
  .m_axis_tdest (s_axis_tdest),
  .m_axis_tuser (s_axis_tuser),
  .m_axis_tlast (s_axis_tlast),
  .m_axis_tvalid(s_axis_tvalid),
  .m_axis_tready(s_axis_tready)
);

assign s_slot_ptr    = s_axis_tdest[SLOT_WIDTH-1:0];
assign s_header_addr = incoming_hdr[32 +: 26];

// We want to use LUTS instead of BRAM or REGS
assign slot_addr     = slot_addr_lut        [s_slot_ptr]; 
assign slot_hdr_msb  = slot_hdr_addr_msb_lut[s_slot_ptr]; 
assign s_base_addr   = incoming_hdr_v ? s_header_addr : {1'b0,slot_addr};

/////////////////////////////////////////////////////////////////////
//////////// ATTACHING DRAM ADDR TO OUTGOING DRAM DATA //////////////
/////////////////////////////////////////////////////////////////////
wire [DATA_WIDTH-1:0] m_axis_tdata;
wire [STRB_WIDTH-1:0] m_axis_tkeep;
wire                  m_axis_tvalid;
wire                  m_axis_tready;
wire                  m_axis_tlast;
wire [PORT_WIDTH-1:0] m_axis_tdest;
wire [TAG_WIDTH-1:0]  m_axis_tuser;

wire [DATA_WIDTH-1:0] data_m_axis_tdata_n;
wire [STRB_WIDTH-1:0] data_m_axis_tkeep_n;
wire                  data_m_axis_tvalid_n;
wire                  data_m_axis_tready_n;
wire                  data_m_axis_tlast_n;
wire [PORT_WIDTH-1:0] data_m_axis_tdest_n;
wire [TAG_WIDTH-1:0]  data_m_axis_tuser_n;

reg  [63:0]  m_header_r;
reg          m_header_v;
wire         m_header_ready;

wire [127:0] dram_wr_desc; 
wire         dram_wr_valid;
wire         dram_wr_ready;

wire ctrl_in_valid, ctrl_in_ready;
wire [ID_TAG_WIDTH+64:0] ctrl_in_desc;

always @ (posedge clk) 
  if (dram_wr_valid && dram_wr_ready)
    m_header_r <= dram_wr_desc[127:64];
  else if (ctrl_in_valid && ctrl_in_desc[64+ID_TAG_WIDTH] && ctrl_in_ready)
    m_header_r <= {{(64-ID_TAG_WIDTH){1'b0}},ctrl_in_desc[63+ID_TAG_WIDTH:64]};

// Can get 1 cycle more efficient while output DMA is getting initialized 
always @ (posedge clk)
  if (rst)
    m_header_v <= 1'b0;
  else if ((dram_wr_valid && dram_wr_ready)||
           (ctrl_in_valid && ctrl_in_desc[64+ID_TAG_WIDTH] && ctrl_in_ready))
    m_header_v <= 1'b1;
  else if (m_header_ready)
    m_header_v <= 1'b0;

header_adder # (
  .DATA_WIDTH(DATA_WIDTH),
  .HDR_WIDTH(64),
  .DEST_WIDTH(PORT_WIDTH),
  .USER_WIDTH(TAG_WIDTH)
) dram_loopback_hdr (
  .clk(clk),
  .rst(rst),

  .s_axis_tdata (m_axis_tdata),
  .s_axis_tkeep (m_axis_tkeep),
  .s_axis_tdest (m_axis_tdest),
  .s_axis_tuser (m_axis_tuser),
  .s_axis_tlast (m_axis_tlast),
  .s_axis_tvalid(m_axis_tvalid),
  .s_axis_tready(m_axis_tready),

  .header      (m_header_r),
  .header_valid(m_header_v),
  .header_ready(m_header_ready),

  .m_axis_tdata (data_m_axis_tdata_n),
  .m_axis_tkeep (data_m_axis_tkeep_n),
  .m_axis_tdest (data_m_axis_tdest_n),
  .m_axis_tuser (data_m_axis_tuser_n),
  .m_axis_tlast (data_m_axis_tlast_n),
  .m_axis_tvalid(data_m_axis_tvalid_n),
  .m_axis_tready(data_m_axis_tready_n)
);

// register output data
axis_register # (
    .DATA_WIDTH(DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(STRB_WIDTH),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(1),
    .DEST_WIDTH(PORT_WIDTH),
    .USER_ENABLE(1),
    .USER_WIDTH(TAG_WIDTH),
    .REG_TYPE(DATA_M_REG_TYPE)
) data_m_reg_inst (
    .clk(clk),
    .rst(rst),
    // AXI input
    .s_axis_tdata (data_m_axis_tdata_n),
    .s_axis_tkeep (data_m_axis_tkeep_n),
    .s_axis_tvalid(data_m_axis_tvalid_n),
    .s_axis_tready(data_m_axis_tready_n),
    .s_axis_tlast (data_m_axis_tlast_n),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (data_m_axis_tdest_n),
    .s_axis_tuser (data_m_axis_tuser_n),
    // AXI output
    .m_axis_tdata (data_m_axis_tdata),
    .m_axis_tkeep (data_m_axis_tkeep),
    .m_axis_tvalid(data_m_axis_tvalid),
    .m_axis_tready(data_m_axis_tready),
    .m_axis_tlast (data_m_axis_tlast),
    .m_axis_tid   (),
    .m_axis_tdest (data_m_axis_tdest),
    .m_axis_tuser (data_m_axis_tuser)
);

/////////////////////////////////////////////////////////////////////
/////////// AXIS TO NATIVE MEM INTERFACE WITH DESCRIPTORS ///////////
/////////////////////////////////////////////////////////////////////
wire                   dma_cmd_rd_en_n;
wire                   pkt_sent;
  
wire                   recv_desc_valid;
wire                   recv_desc_ready;
wire                   recv_desc_fifo_ready;
wire [15:0]            recv_desc_len;
wire [TAG_WIDTH-1:0]   recv_desc_tdest;
wire [PORT_WIDTH-1:0]  recv_desc_tuser;
wire [25:0]            recv_desc_addr;

wire [63:0] send_desc;
wire send_desc_valid, send_desc_ready;

// We deassert read request if read results cannot be accepted,
// similar to adding a bobble into pipe
assign dma_cmd_rd_en = dma_cmd_rd_en_n && dma_rd_resp_ready;

axis_dma # (
  .DATA_WIDTH     (DATA_WIDTH),
  .ADDR_WIDTH     (26),       
  .LEN_WIDTH      (16),        
  .DEST_WIDTH_IN  (TAG_WIDTH),   
  .USER_WIDTH_IN  (PORT_WIDTH),   
  .DEST_WIDTH_OUT (PORT_WIDTH),  
  .USER_WIDTH_OUT (TAG_WIDTH),
  .MAX_PKT_HDR_SIZE(MAX_PKT_HDR_SIZE),
  .HDR_MSB_WIDTH  (HDR_MSB_WIDTH),
  .HDR_ADDR_WIDTH (24)
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
  .hdr_wr_addr_msb (slot_hdr_msb),
  .hdr_en(!incoming_hdr_v),

  .m_axis_tdata (m_axis_tdata),
  .m_axis_tkeep (m_axis_tkeep),
  .m_axis_tvalid(m_axis_tvalid),
  .m_axis_tready(m_axis_tready),
  .m_axis_tlast (m_axis_tlast),
  .m_axis_tdest (m_axis_tdest),
  .m_axis_tuser (m_axis_tuser),
  
  .mem_wr_en   (dma_cmd_wr_en),
  .mem_wr_strb (dma_cmd_wr_strb),
  .mem_wr_addr (dma_cmd_wr_addr),
  .mem_wr_data (dma_cmd_wr_data),
  .mem_wr_last (dma_cmd_wr_last),
  .mem_wr_ready(dma_cmd_wr_ready),
  
  .mem_hdr_wr_en(dma_cmd_hdr_wr_en),
  .mem_hdr_wr_addr(dma_cmd_hdr_wr_addr),
  
  .mem_rd_en        (dma_cmd_rd_en_n),
  .mem_rd_addr      (dma_cmd_rd_addr),
  .mem_rd_last      (dma_cmd_rd_last),
  .mem_rd_ready     (dma_cmd_rd_ready && dma_rd_resp_ready),
  .mem_rd_data      (dma_rd_resp_data),
  .mem_rd_data_v    (dma_rd_resp_valid),
  .mem_rd_data_ready(dma_rd_resp_ready),
  
  .recv_desc_valid(recv_desc_valid),
  .recv_desc_ready(recv_desc_ready),
  .recv_desc_len  (recv_desc_len),
  .recv_desc_tdest(recv_desc_tdest),
  .recv_desc_tuser(recv_desc_tuser),
  .recv_desc_addr (recv_desc_addr),

  .send_desc_valid(send_desc_valid),
  .send_desc_ready(send_desc_ready),
  .send_desc_addr({1'b0,send_desc[32+:25]}),
  .send_desc_len(send_desc[15:0]),
  .send_desc_tdest(send_desc[PORT_WIDTH+23:24]),
  .send_desc_tuser(send_desc[TAG_WIDTH+15:16]),

  .pkt_sent       (pkt_sent)

);

/////////////////////////////////////////////////////////////////////
/////////////////// DATA IN DESCRIPTOR FIFO /////////////////////////
/////////////////////////////////////////////////////////////////////
// A desc FIFO for received data
wire [63:0] recv_desc = {6'd0,recv_desc_addr,
                        {(8-PORT_WIDTH){1'b0}},recv_desc_tuser,
                        {(8-SLOT_WIDTH){1'b0}},recv_desc_tdest[SLOT_WIDTH-1:0],
                        recv_desc_len};

wire recv_from_dram = recv_desc_valid && (recv_desc_tuser==dram_port);
wire recv_tag_zero  = recv_desc_valid && (recv_desc_tdest=={TAG_WIDTH{1'b0}});

simple_sync_fifo # (
  .DEPTH(RECV_DESC_DEPTH),
  .DATA_WIDTH(64)
) recvd_data_fifo (
  .clk(clk),
  .rst(rst || core_reset_r),

  .din_valid(recv_desc_valid && (!recv_from_dram) && (!recv_tag_zero)),
  .din(recv_desc),
  .din_ready(recv_desc_fifo_ready),
 
  .dout_valid(in_desc_valid),
  .dout(in_desc),
  .dout_ready(in_desc_taken)
);

wire       recv_dram_tag_fifo_ready;
 
reg [4:0] recv_dram_tag_r;
reg       recv_dram_tag_v_r;

always @ (posedge clk) begin
  recv_dram_tag_r     <= recv_desc_tdest[4:0];
  recv_dram_tag_v_r   <= recv_desc_valid && recv_from_dram && (!recv_tag_zero);
  if (rst)
    recv_dram_tag_v_r <= 1'b0;
end

assign recv_dram_tag_valid      = recv_dram_tag_v_r;
assign recv_dram_tag            = recv_dram_tag_r;
assign recv_dram_tag_fifo_ready = 1'b1;

assign recv_desc_ready = (recv_desc_fifo_ready && (!recv_from_dram))  || 
                         (recv_from_dram && recv_dram_tag_fifo_ready) || 
                         recv_tag_zero;
/////////////////////////////////////////////////////////////////////
//////////// PARSING CORE DESCRIPTOR AND FIFOS PER TYPE /////////////
/////////////////////////////////////////////////////////////////////
wire [3:0] out_desc_type = out_desc[63:60];

wire core_data_wr =  (out_desc_type == 4'd0);
wire core_ctrl_wr = ((out_desc_type == 4'd1) || 
                     (out_desc_type == 4'd2) || 
                     (out_desc_type == 4'd3));
wire core_dram_wr =  (out_desc_type == 4'd4);
wire core_dram_rd =  (out_desc_type == 4'd5);

// A desc FIFO for send data from core
wire core_data_wr_ready;
wire core_data_wr_valid_f, core_data_wr_ready_f;
wire [63:0] core_data_wr_desc_f;

simple_sync_fifo # (
  .DEPTH(SEND_DESC_DEPTH),
  .DATA_WIDTH(64)
) send_data_fifo (
  .clk(clk),
  .rst(rst || core_reset_r),

  .din_valid(out_desc_valid && core_data_wr),
  .din(out_desc),
  .din_ready(core_data_wr_ready),
 
  .dout_valid(core_data_wr_valid_f),
  .dout(core_data_wr_desc_f),
  .dout_ready(core_data_wr_ready_f)
);

// A desc FIFO for msgs to scheduler
wire core_ctrl_wr_ready;

wire core_ctrl_wr_valid_f, core_ctrl_wr_ready_f;
wire [63:0] core_ctrl_wr_desc_f;

simple_sync_fifo # (
  .DEPTH(SEND_DESC_DEPTH),
  .DATA_WIDTH(64)
) send_ctrl_fifo (
  .clk(clk),
  .rst(rst || core_reset_r),

  .din_valid(out_desc_valid && core_ctrl_wr),
  .din(out_desc),
  .din_ready(core_ctrl_wr_ready),
 
  .dout_valid(core_ctrl_wr_valid_f),
  .dout(core_ctrl_wr_desc_f),
  .dout_ready(core_ctrl_wr_ready_f)
);

// A register to look up the send adddress based on slot
reg  [24:0]           send_slot_addr [1:SLOT_COUNT];
reg  [15:0]           send_slot_len  [1:SLOT_COUNT];
wire [SLOT_WIDTH-1:0] ctrl_out_slot_ptr = core_ctrl_wr_desc_f[16 +: SLOT_WIDTH];

always @ (posedge clk)
  if (core_ctrl_wr_valid_f && core_ctrl_wr_ready_f) begin
    send_slot_addr [ctrl_out_slot_ptr] <= core_ctrl_wr_desc_f[32+:25];
    send_slot_len  [ctrl_out_slot_ptr] <= core_ctrl_wr_desc_f[15:0];
  end

// A FIFO for dram write requests
wire core_dram_wr_ready;
wire core_dram_wr_valid_f, core_dram_wr_ready_f;
wire [127:0] core_dram_wr_desc_f;

simple_sync_fifo # (
  .DEPTH(DRAM_DESC_DEPTH),
  .DATA_WIDTH(128)
) dram_send_fifo (
  .clk(clk),
  .rst(rst || core_reset_r),

  .din_valid(out_desc_valid && core_dram_wr),
  .din({out_desc_dram_addr, out_desc[63:24+PORT_WIDTH],
        dram_port, out_desc[23:0]}),
  .din_ready(core_dram_wr_ready),
 
  .dout_valid(core_dram_wr_valid_f),
  .dout(core_dram_wr_desc_f),
  .dout_ready(core_dram_wr_ready_f)
);

// A desc FIFO for dram read msgs
wire core_dram_rd_ready;
wire core_dram_rd_valid_f, core_dram_rd_ready_f;
wire [127:0] core_dram_rd_desc_f;

simple_sync_fifo # (
  .DEPTH(DRAM_DESC_DEPTH),
  .DATA_WIDTH(128)
) send_dram_ctrl_fifo (
  .clk(clk),
  .rst(rst || core_reset_r),

  .din_valid(out_desc_valid && core_dram_rd),
  .din({out_desc_dram_addr, out_desc}),
  .din_ready(core_dram_rd_ready),
 
  .dout_valid(core_dram_rd_valid_f),
  .dout(core_dram_rd_desc_f),
  .dout_ready(core_dram_rd_ready_f)
);

assign out_desc_ready = (core_data_wr_ready && core_data_wr) || 
                         (core_ctrl_wr_ready && core_ctrl_wr) ||
                         (core_dram_wr_ready && core_dram_wr) || 
                         (core_dram_rd_ready && core_dram_rd);

/////////////////////////////////////////////////////////////////////
////////////////// INCOMING CTRL DESCRIPTOR FIFO ////////////////////
///////////////////// PKT SENT DESCRIPTOR FIFO //////////////////////
//////////////// DRAM READ REQUEST PARSER AND FIFO //////////////////
/////////////////////////////////////////////////////////////////////

reg  [35:0]           ctrl_s_axis_tdata_r;
reg                   ctrl_s_axis_tvalid_r;
reg  [SLOT_WIDTH-1:0] ctrl_in_slot_ptr;
always @ (posedge clk) begin
  if (ctrl_s_axis_tvalid && ctrl_s_axis_tready) begin
    ctrl_s_axis_tdata_r  <= ctrl_s_axis_tdata;
    ctrl_in_slot_ptr     <= ctrl_s_axis_tdata[16+:SLOT_WIDTH];
  end 
  ctrl_s_axis_tvalid_r <= ((ctrl_s_axis_tvalid && !reset_cmd && ctrl_s_axis_tready) || 
                           (ctrl_s_axis_tvalid_r && (!ctrl_s_axis_tready)));

  if (rst)
    ctrl_s_axis_tvalid_r <= 1'b0;
end
  
wire [24:0] ctrl_send_addr   = send_slot_addr[ctrl_in_slot_ptr];
wire [24:0] ctrl_lp_send_len = send_slot_len [ctrl_in_slot_ptr];
wire [3:0]  ctrl_msg_type    = ctrl_s_axis_tdata_r[35:32];
wire ctrl_s_axis_fifo_ready;

wire [ID_TAG_WIDTH+64:0] parsed_ctrl_desc = (ctrl_msg_type==4'd1) ? 
              {1'b1,ctrl_s_axis_tdata_r[ID_TAG_WIDTH-1:0],7'd0, ctrl_send_addr,
               ctrl_s_axis_tdata_r[31:16], ctrl_lp_send_len} : 
              {1'b0,{(ID_TAG_WIDTH+7){1'b0}}, ctrl_send_addr,ctrl_s_axis_tdata_r[31:0]};

// A desc FIFO for send data based on scheduler message

simple_fifo # (
  .ADDR_WIDTH($clog2(RECV_DESC_DEPTH)),
  .DATA_WIDTH(64+ID_TAG_WIDTH+1)
) recvd_ctrl_fifo (
  .clk(clk),
  .rst(rst),
  .clear(core_reset_r),

  .din_valid(ctrl_s_axis_tvalid_r),
  .din(parsed_ctrl_desc), 
  .din_ready(ctrl_s_axis_tready),
 
  .dout_valid(ctrl_in_valid),
  .dout(ctrl_in_desc),
  .dout_ready(ctrl_in_ready)
);

/////////////////////////////////////////////////////////////////////

// Latch the output descriptor and send it to controller when 
// it is transmitted
wire pkt_sent_ready; // should always be ready
reg [63:0] latched_send_desc;
always @ (posedge clk) 
    if (send_desc_valid && send_desc_ready && pkt_sent_ready)
        latched_send_desc <= send_desc;

wire pkt_sent_is_dram = (latched_send_desc[PORT_WIDTH+23:24]==dram_port);

// A FIFO for outgoing control messages
wire pkt_sent_valid_f, pkt_sent_ready_f;
wire [63:0] pkt_sent_desc_f;

simple_fifo # (
  .ADDR_WIDTH($clog2(SEND_DESC_DEPTH)),
  .DATA_WIDTH(64)
) pkt_sent_fifo (
  .clk(clk),
  .rst(rst),
  .clear(1'b0),

  .din_valid(pkt_sent && (!pkt_sent_is_dram)), 
  .din(latched_send_desc),
  .din_ready(pkt_sent_ready),
 
  .dout_valid(pkt_sent_valid_f),
  .dout(pkt_sent_desc_f),
  .dout_ready(pkt_sent_ready_f)
);

/////////////////////////////////////////////////////////////////////
reg        dram_req_valid;
wire       dram_req_ready;
reg [63:0] dram_req_high, dram_req_low;

// A desc FIFO for send dram based on dram read message
wire dram_in_valid, dram_in_ready;
wire [127:0] dram_in_desc;

simple_fifo # (
  .ADDR_WIDTH($clog2(DRAM_DESC_DEPTH)),
  .DATA_WIDTH(128)
) recvd_dram_rd_fifo (
  .clk(clk),
  .rst(rst),
  .clear(1'b0),

  .din_valid(dram_req_valid),
  .din({dram_req_high, dram_req_low}),
  .din_ready(dram_req_ready),
 
  .dout_valid(dram_in_valid),
  .dout(dram_in_desc),
  .dout_ready(dram_in_ready)
);

/////////////////////////////////////////////////////////////////////
///////////////// DRAM DESCRIPTOR WIDTH CHANGE //////////////////////
/////////////////////////////////////////////////////////////////////

// For DRAM descriptor the first word is descriptor followed by DRAM address

// Incoming dram desc
always @ (posedge clk) begin
  if (dram_s_axis_tvalid && dram_req_ready)
    if (dram_s_axis_tlast) begin
      dram_req_high  <= dram_s_axis_tdata;
      dram_req_valid <= 1'b1;
    end else begin
      // Overriding dram port and setting the tag to 0
      dram_req_low   <= {dram_s_axis_tdata[63:24+PORT_WIDTH],
                         dram_port, 8'd0, dram_s_axis_tdata[15:0]};
      dram_req_valid <= 1'b0;
    end
  else
      dram_req_valid <= 1'b0;

  if (rst) 
      dram_req_valid <= 1'b0;
end

assign dram_s_axis_tready = dram_req_ready;

// Outgoing dram desc
wire [63:0] dram_m_axis_tdata_n;
wire        dram_m_axis_tvalid_n;
wire        dram_m_axis_tready_n;
wire        dram_m_axis_tlast_n;
reg [1:0]   send_dram_rd_state;

always @ (posedge clk)
  if (rst)
    send_dram_rd_state <= 2'd0;
  else if (core_dram_rd_valid_f)
    case (send_dram_rd_state)
      2'd0: send_dram_rd_state <= 2'd1;
      2'd1: if (dram_m_axis_tready_n) send_dram_rd_state <= 2'd2;
      2'd2: if (dram_m_axis_tready_n) send_dram_rd_state <= 2'd0;
      2'd3: send_dram_rd_state <= 2'd3; // Error
    endcase

assign dram_m_axis_tvalid_n = (send_dram_rd_state != 2'd0);
assign dram_m_axis_tdata_n  = (send_dram_rd_state == 2'd2) ? core_dram_rd_desc_f[127:64] 
                                                           : core_dram_rd_desc_f[63:0];
assign dram_m_axis_tlast_n  = (send_dram_rd_state == 2'd2);
assign core_dram_rd_ready_f = (send_dram_rd_state == 2'd2) && dram_m_axis_tready_n;

// register output dram data
axis_register # (
    .DATA_WIDTH(64),
    .KEEP_ENABLE(0),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(0),
    .REG_TYPE(DRAM_M_REG_TYPE)
) dram_m_reg_inst (
    .clk(clk),
    .rst(rst),
    // AXI input
    .s_axis_tdata (dram_m_axis_tdata_n),
    .s_axis_tkeep (8'd0),
    .s_axis_tvalid(dram_m_axis_tvalid_n),
    .s_axis_tready(dram_m_axis_tready_n),
    .s_axis_tlast (dram_m_axis_tlast_n),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (8'd0),
    .s_axis_tuser (1'd0),
    // AXI output
    .m_axis_tdata (dram_m_axis_tdata),
    .m_axis_tkeep (),
    .m_axis_tvalid(dram_m_axis_tvalid),
    .m_axis_tready(dram_m_axis_tready),
    .m_axis_tlast (dram_m_axis_tlast),
    .m_axis_tid   (),
    .m_axis_tdest (),
    .m_axis_tuser ()
);

/////////////////////////////////////////////////////////////////////
/////////////////////////// ARBITERS ////////////////////////////////
/////////////////////////////////////////////////////////////////////

// Data out arbiter between core direct send data and scheduler message
// Priority to messages from the scheduler
wire [63:0] send_pkt_desc;
wire send_pkt_valid, send_pkt_ready;

wire   data_select          = ctrl_in_valid;
assign send_pkt_valid       = ctrl_in_valid || core_data_wr_valid_f;
assign send_pkt_desc        = data_select ? ctrl_in_desc[63:0] : core_data_wr_desc_f;
assign core_data_wr_ready_f = send_pkt_ready && (!data_select);
assign ctrl_in_ready        = send_pkt_ready &&   data_select ;

// DRAM request out arbiter between DRAM request and core write.
// Priority to core write.
wire   dram_select   = core_dram_wr_valid_f;
assign dram_wr_valid = core_dram_wr_valid_f || dram_in_valid;
assign dram_wr_desc  = dram_select ? core_dram_wr_desc_f : dram_in_desc;

assign core_dram_wr_ready_f =   dram_select  && core_dram_wr_valid_f && dram_wr_ready;
assign dram_in_ready       = (!dram_select) && dram_in_valid && dram_wr_ready;

// Arbiter between packets and DRAM out data, round robin 
reg dram_next_selection_r;
always @ (posedge clk)
  if (rst)
    dram_next_selection_r <= 1'b0;
  else if (dram_wr_valid && dram_wr_ready) 
    dram_next_selection_r <= 1'b0;
  else if (send_pkt_valid && send_pkt_ready)
    dram_next_selection_r <= 1'b1;

reg dram_out_select; 
always @ (*)
  if (!dram_wr_valid)
    dram_out_select = 1'b0;
  else if (!send_pkt_valid)
    dram_out_select = 1'b1;
  else
    dram_out_select = dram_next_selection_r; 

assign dram_wr_ready   = dram_wr_valid && dram_out_select && send_desc_ready && pkt_sent_ready;
assign send_pkt_ready  = send_pkt_valid && !dram_out_select && send_desc_ready && pkt_sent_ready;
assign send_desc       = dram_out_select ? dram_wr_desc[63:0] : send_pkt_desc;
assign send_desc_valid = (dram_wr_valid || send_pkt_valid) && pkt_sent_ready;

// CTRL out arbiter between packet sent and core message to scheduler
// Priority to releasing a desc
wire [63:0] ctrl_out_data;
wire ctrl_out_valid, ctrl_out_ready;

wire   ctrl_select          = pkt_sent_valid_f;
assign ctrl_out_valid       = pkt_sent_valid_f || core_ctrl_wr_valid_f; 
assign ctrl_out_data        = ctrl_select ? pkt_sent_desc_f : core_ctrl_wr_desc_f;
assign core_ctrl_wr_ready_f = ctrl_out_ready && (!ctrl_select);
assign pkt_sent_ready_f     = ctrl_out_ready &&   ctrl_select ;

// Latching the output to deal with the next stage valid/ready
reg [35:0] ctrl_m_axis_tdata_r;
reg        ctrl_m_axis_tvalid_r;

always @ (posedge clk) begin
  if (ctrl_out_valid && (!ctrl_m_axis_tvalid_r || ctrl_m_axis_tready)) begin
    ctrl_m_axis_tdata_r  <= {ctrl_out_data[63:60], ctrl_out_data[31:0]};
    ctrl_m_axis_tvalid_r <= 1'b1;
  end else if (ctrl_m_axis_tready && !ctrl_out_valid) begin
    ctrl_m_axis_tvalid_r <= 1'b0;
  end
  if (rst) begin
    ctrl_m_axis_tvalid_r <= 1'b0;
    ctrl_m_axis_tdata_r  <= 36'd0;
  end
end 

assign ctrl_m_axis_tvalid = ctrl_m_axis_tvalid_r;
assign ctrl_m_axis_tdata  = ctrl_m_axis_tdata_r;
assign ctrl_m_axis_tlast  = ctrl_m_axis_tvalid;
assign ctrl_out_ready     = (!ctrl_m_axis_tvalid_r) || ctrl_m_axis_tready;

/////////////////////////////////////////////////////////////////////
/////////////////////// BROADCAST MESSAGING /////////////////////////
/////////////////////////////////////////////////////////////////////

// Deassert write for the sender core. 
// Later grouping can be implemented as well in the fpga_core module
always @ (posedge clk) begin
  bc_msg_in       <= core_msg_in;
  bc_msg_in_user  <= core_msg_in_user;
  bc_msg_in_valid <= core_msg_in_valid && (core_msg_in_user!=core_id);
  if (rst)
    bc_msg_in_valid <= 1'b0;
end

simple_sync_fifo # (
  .DEPTH(MSG_FIFO_DEPTH),
  .DATA_WIDTH(MSG_WIDTH)
) core_msg_out_fifo (
  .clk(clk),
  .rst(rst || core_reset_r),

  .din_valid(bc_msg_out_valid),
  .din(bc_msg_out),
  .din_ready(bc_msg_out_ready),
 
  .dout_valid(core_msg_out_valid),
  .dout(core_msg_out),
  .dout_ready(core_msg_out_ready)
);

///////////////////////////////////////////////////////////////////////////
//////////////////////// ACTIVE SLOTS STATE/// ////////////////////////////
///////////////////////////////////////////////////////////////////////////
wire done_w_slot = ((out_desc_type == 4'd0) ||
                    (out_desc_type == 4'd1) ||
                    (out_desc_type == 4'd2)) && 
                    out_desc_valid && out_desc_ready;

reg [SLOT_COUNT:1] slots_in_prog;
always @ (posedge clk)
  if (rst)
      slots_in_prog <= {SLOT_COUNT{1'b0}};
  else if (in_desc_valid && in_desc_taken)
      slots_in_prog[in_desc[16+:SLOT_WIDTH]]  <= 1'b1;
  else if (done_w_slot)
      slots_in_prog[out_desc[16+:SLOT_WIDTH]] <= 1'b0;

assign active_slots = slots_in_prog;

// TODO: Add error catching

/////////////////////////////////////////////////////////////////////
///////////////////////// ERROR CATCHING ////////////////////////////
/////////////////////////////////////////////////////////////////////

wire invalid_out_desc = (out_desc_type>4'd5) && out_desc_valid;
reg invalid_out_desc_r;
always @ (posedge clk)
  if (rst || core_reset) 
    invalid_out_desc_r <= 1'b0;
  else
    invalid_out_desc_r <= invalid_out_desc_r || invalid_out_desc;

wire out_of_bound_clear;
wire out_of_bound = 1'b0;
// always @(posedge clk)
//   if (rst || out_of_bound_clear)
//     out_of_bound <= 1'b0;
//   else 
//     out_of_bound <= out_of_bound || mem_out_of_bound;

assign core_interrupt = out_of_bound;
assign out_of_bound_clear = core_interrupt_ack;

endmodule
