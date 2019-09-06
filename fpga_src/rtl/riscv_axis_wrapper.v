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
    parameter DRAM_DESC_DEPTH = 16,
    parameter MSG_FIFO_DEPTH  = 16,
    parameter PORT_COUNT      = 4,
    parameter LEN_WIDTH       = 16,
    parameter CORE_ID         = 0,
    parameter CORE_ID_WIDTH   = 4, 
    parameter SLOT_START_ADDR = 16'h2000,
    parameter SLOT_ADDR_STEP  = 16'h0800,
    parameter DRAM_PORT       = 2,

    parameter STRB_WIDTH      = (DATA_WIDTH/8),
    parameter SLOT_WIDTH      = $clog2(SLOT_COUNT+1), 
    parameter TAG_WIDTH       = (SLOT_WIDTH>5)? SLOT_WIDTH:5,
    parameter SLOT_PTR_WIDTH  = $clog2(SLOT_COUNT), 
    parameter PORT_WIDTH      = $clog2(PORT_COUNT),
    parameter ID_TAG_WIDTH    = CORE_ID_WIDTH+TAG_WIDTH,
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
    input  wire [TAG_WIDTH-1:0]    data_s_axis_tdest,
    input  wire [PORT_WIDTH-1:0]    data_s_axis_tuser,
  
    // Outgoing data
    output wire [DATA_WIDTH-1:0]    data_m_axis_tdata,
    output wire [STRB_WIDTH-1:0]    data_m_axis_tkeep,
    output wire                     data_m_axis_tvalid,
    input  wire                     data_m_axis_tready,
    output wire                     data_m_axis_tlast,
    output wire [PORT_WIDTH-1:0]    data_m_axis_tdest,
    output wire [ID_TAG_WIDTH-1:0]  data_m_axis_tuser,
  
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
    output wire [CORE_ID_WIDTH-1:0] ctrl_m_axis_tuser,
    
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
    output wire [CORE_ID_WIDTH-1:0] dram_m_axis_tuser,

    // ------------- CORE MSG CHANNEL -------------- // 
    // Core messages output  
    output wire [MSG_WIDTH-1:0]     core_msg_out_data,
    output wire                     core_msg_out_valid,
    input  wire                     core_msg_out_ready,

    // Core messages input
    input  wire [MSG_WIDTH-1:0]     core_msg_in_data,
    input  wire [CORE_ID_WIDTH-1:0] core_msg_in_user,
    input  wire                     core_msg_in_valid
);

assign data_m_axis_tuser [TAG_WIDTH +: CORE_ID_WIDTH] = CORE_ID; 
assign dram_m_axis_tuser = CORE_ID;

/////////////////////////////////////////////////////////////////////
//////////////////////// CORE RESET COMMAND /////////////////////////
/////////////////////////////////////////////////////////////////////
wire reset_cmd = ctrl_s_axis_tvalid && (&ctrl_s_axis_tdata[35:32]);
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
  ) slot_addr_wr_fifo (
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

// We wanna use LUTS instead of BRAM or REGS
assign slot_addr = slot_addr_lut[s_slot_ptr]; 
 
// Pipeline register to load from slot LUT or packet header
reg  [DATA_WIDTH-1:0] s_axis_tdata;
reg  [STRB_WIDTH-1:0] s_axis_tkeep;
reg                   s_axis_tvalid;
wire                  s_axis_tready;
reg                   s_axis_tlast;
reg  [TAG_WIDTH-1:0]  s_axis_tdest;
reg  [PORT_WIDTH-1:0] s_axis_tuser;

reg                   s_is_header; 
reg                   s_is_header_r; 
reg                   s_pot_header;
reg  [ADDR_WIDTH-1:0] s_header_addr;
wire [ADDR_WIDTH-1:0] s_base_addr;

assign data_s_axis_tready = s_axis_tready;
wire [PORT_WIDTH-1:0] dram_port = DRAM_PORT;

always @ (posedge sys_clk) begin

  // Determining the first word which potentially can be a header
  if (sys_rst) begin
    s_pot_header <= 1'b1;
  end else if (data_s_axis_tvalid && data_s_axis_tready) begin
    if (data_s_axis_tlast) 
      s_pot_header <= 1'b1;
    else 
      s_pot_header <= 1'b0;
  end
  
  // Latch slot and port and destination address only from first word 
  if (data_s_axis_tvalid && data_s_axis_tready && s_pot_header) begin
    s_axis_tdest  <= data_s_axis_tdest;
    s_axis_tuser  <= data_s_axis_tuser;  
    s_slot_ptr    <= data_s_axis_tdest[SLOT_WIDTH-1:0]-{{(SLOT_WIDTH-1){1'b0}},1'b1};
    s_header_addr <= data_s_axis_tdata[32 +: ADDR_WIDTH];
  end

  // Register data and tkeep and tlast. Also mark first and second word
  // so in case of header the first one is not valid and base address 
  // is asserted with second word.
  if (data_s_axis_tvalid && data_s_axis_tready) begin
    s_axis_tdata  <= data_s_axis_tdata;
    s_axis_tkeep  <= data_s_axis_tkeep; 
    s_axis_tlast  <= data_s_axis_tlast;
    s_is_header   <= (data_s_axis_tuser==dram_port) && s_pot_header;  
    s_is_header_r <= s_is_header;
  end

  // If there is data and ready is asserted pipeline can move. 
  // If there is data in pipe but ready is not asserted valid stays asserted.
  s_axis_tvalid <= ((data_s_axis_tvalid && data_s_axis_tready) || 
                    (s_axis_tvalid && (!s_axis_tready)));
  if (sys_rst) begin
    s_axis_tvalid <= 1'b0;
    s_is_header   <= 1'b0;
    s_is_header_r <= 1'b0;
  end
end
    
assign s_base_addr = s_is_header_r ? s_header_addr : slot_addr;

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

reg  [63:0]  m_axis_dram_addr_r;
reg          m_axis_header_allowed_r;
reg          m_axis_dram_v;

wire [127:0] dram_wr_desc; 
wire         dram_wr_valid;
wire         dram_wr_ready;

always @ (posedge sys_clk)
  if (sys_rst)
    m_axis_header_allowed_r <= 1'b1;
  else
    if (m_axis_tvalid && m_axis_tready) begin
      if (m_axis_tlast)
        m_axis_header_allowed_r <= 1'b1;
      else
        m_axis_header_allowed_r <= 1'b0;
    end

always @ (posedge sys_clk) 
  if (dram_wr_valid && dram_wr_ready) 
    m_axis_dram_addr_r <= dram_wr_desc[127:64];

// Can get 1 cycle more efficient while output DMA is getting initialized 
always @ (posedge sys_clk)
  if (sys_rst)
    m_axis_dram_v <= 1'b0;
  else if (dram_wr_valid && dram_wr_ready) 
    m_axis_dram_v <= 1'b1;
  else if (m_axis_tvalid && data_m_axis_tready && m_axis_header_allowed_r)
    m_axis_dram_v <= 1'b0;

wire dram_addr_send = m_axis_tvalid && m_axis_header_allowed_r && m_axis_dram_v;

assign data_m_axis_tdata = dram_addr_send ? m_axis_dram_addr_r : m_axis_tdata;
assign data_m_axis_tkeep = dram_addr_send ? {STRB_WIDTH{1'b1}} : m_axis_tkeep;
assign data_m_axis_tlast = dram_addr_send ? 1'b0               : m_axis_tlast;
assign data_m_axis_tdest = m_axis_tdest;
assign data_m_axis_tuser[TAG_WIDTH-1:0] = m_axis_tuser;
assign m_axis_tready = (!dram_addr_send) && data_m_axis_tready;
assign data_m_axis_tvalid = dram_addr_send || m_axis_tvalid;

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
wire                   recv_desc_fifo_ready;
wire [LEN_WIDTH-1:0]   recv_desc_len;
wire [TAG_WIDTH-1:0]   recv_desc_tdest;
wire [PORT_WIDTH-1:0]  recv_desc_tuser;
wire [ADDR_WIDTH-1:0]  recv_desc_addr;

wire                   pkt_sent;

wire [63:0] send_desc;
wire send_desc_valid, send_desc_ready;

axis_dma # (
  .DATA_WIDTH     (DATA_WIDTH),
  .ADDR_WIDTH     (ADDR_WIDTH),       
  .LEN_WIDTH      (LEN_WIDTH),        
  .DEST_WIDTH_IN  (TAG_WIDTH),   
  .USER_WIDTH_IN  (PORT_WIDTH),   
  .DEST_WIDTH_OUT (PORT_WIDTH),  
  .USER_WIDTH_OUT (TAG_WIDTH)  
) axis_dma_inst (
  .clk(sys_clk),
  .rst(sys_rst),

  .s_axis_tdata (s_axis_tdata),
  .s_axis_tkeep (s_axis_tkeep),
  .s_axis_tvalid(s_axis_tvalid && !s_is_header),
  .s_axis_tready(s_axis_tready),
  .s_axis_tlast (s_axis_tlast),
  .s_axis_tdest (s_axis_tdest),
  .s_axis_tuser (s_axis_tuser),

  .wr_base_addr (s_base_addr),

  .m_axis_tdata (m_axis_tdata),
  .m_axis_tkeep (m_axis_tkeep),
  .m_axis_tvalid(m_axis_tvalid),
  .m_axis_tready(m_axis_tready),
  .m_axis_tlast (m_axis_tlast),
  .m_axis_tdest (m_axis_tdest),
  .m_axis_tuser (m_axis_tuser),
  
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

  .send_desc_valid(send_desc_valid),
  .send_desc_ready(send_desc_ready),
  .send_desc_addr(send_desc[ADDR_WIDTH+31:32]),
  .send_desc_len(send_desc[LEN_WIDTH-1:0]),
  .send_desc_tdest(send_desc[PORT_WIDTH+23:24]),
  .send_desc_tuser(send_desc[TAG_WIDTH+15:16]),

  .pkt_sent       (pkt_sent)

);

/////////////////////////////////////////////////////////////////////
/////////////////// DATA IN DESCRIPTOR FIFO /////////////////////////
/////////////////////////////////////////////////////////////////////
// A desc FIFO for received data
wire recv_desc_valid_f, recv_desc_ready_f;
wire [63:0] recv_desc_f;

wire [63:0] recv_desc = {recv_desc_addr,
                        {(8-PORT_WIDTH){1'b0}},recv_desc_tuser,
                        {(8-SLOT_WIDTH){1'b0}},recv_desc_tdest[SLOT_WIDTH-1:0],
                        {(16-LEN_WIDTH){1'b0}},recv_desc_len};

wire recv_from_dram = recv_desc_valid && (recv_desc_tuser==dram_port);
wire recv_tag_zero  = recv_desc_valid && (recv_desc_tdest=={TAG_WIDTH{1'b0}});

if (!SEPARATE_CLOCKS) begin
  simple_fifo # (
    .ADDR_WIDTH($clog2(RECV_DESC_DEPTH)),
    .DATA_WIDTH(64)
  ) recvd_data_fifo (
    .clk(sys_clk),
    .rst(sys_rst),
    .clear(1'b0),
  
    .din_valid(recv_desc_valid && (!recv_from_dram) && (!recv_tag_zero)),
    .din(recv_desc),
    .din_ready(recv_desc_fifo_ready),
   
    .dout_valid(recv_desc_valid_f),
    .dout(recv_desc_f),
    .dout_ready(recv_desc_ready_f)
  );

end else begin
  simple_async_fifo # (
    .DEPTH(RECV_DESC_DEPTH),
    .DATA_WIDTH(64)
  ) recvd_data_fifo (
    .async_rst(sys_rst),
  
    .din_clk(sys_clk),
    .din_valid(recv_desc_valid && (!recv_from_dram) && (!recv_tag_zero)),
    .din(recv_desc),
    .din_ready(recv_desc_fifo_ready),
   
    .dout_clk(core_clk),
    .dout_valid(recv_desc_valid_f),
    .dout(recv_desc_f),
    .dout_ready(recv_desc_ready_f)
  );

end


wire [4:0] recv_dram_tag;
wire       recv_dram_tag_fifo_ready;
wire       recv_dram_tag_v;
 
if (SEPARATE_CLOCKS) begin

 
  // There is at least a cycle between two write from core if value 
  // is changed, so even double core clock 4 entries are more than enough
  simple_async_fifo # (
    .DEPTH(4),
    .DATA_WIDTH(5)
  ) dram_flag_wr_fifo (
    .async_rst(sys_rst),
  
    .din_clk(sys_clk),
    .din_valid(recv_desc_valid && recv_from_dram && (!recv_tag_zero)),
    .din(recv_desc_tdest[4:0]),
    .din_ready(recv_dram_tag_fifo_ready),
   
    .dout_clk(core_clk),
    .dout_valid(recv_dram_tag_v),
    .dout(recv_dram_tag),
    .dout_ready(1'b1)
  );

end else begin

  reg [4:0] recv_dram_tag_r;
  reg       recv_dram_tag_v_r;

  always @ (posedge sys_clk) begin
    recv_dram_tag_r     <= recv_desc_tdest[4:0];
    recv_dram_tag_v_r   <= recv_desc_valid && recv_from_dram && (!recv_tag_zero);
    if (sys_rst)
      recv_dram_tag_v_r <= 1'b0;
  end
  
  assign recv_dram_tag_v          = recv_dram_tag_v_r;
  assign recv_dram_tag            = recv_dram_tag_r;
  assign recv_dram_tag_fifo_ready = 1'b1;

end

assign recv_desc_ready = (recv_desc_fifo_ready && (!recv_from_dram))  || 
                         (recv_from_dram && recv_dram_tag_fifo_ready) || 
                         recv_tag_zero;
/////////////////////////////////////////////////////////////////////
//////////// PARSING CORE DESCRIPTOR AND FIFOS PER TYPE /////////////
/////////////////////////////////////////////////////////////////////
wire data_send_valid, data_send_ready;
wire [63:0] data_send_desc;
wire [63:0] core_dram_addr;

wire core_data_wr =  (data_send_desc[63:60] == 4'd0);
wire core_ctrl_wr = ((data_send_desc[63:60] == 4'd1) || 
                     (data_send_desc[63:60] == 4'd2) || 
                     (data_send_desc[63:60] == 4'd3));
wire core_dram_wr =  (data_send_desc[63:60] == 4'd4);
wire core_dram_rd =  (data_send_desc[63:60] == 4'd5);

// A desc FIFO for send data from core
wire core_data_wr_ready;
wire core_data_wr_valid_f, core_data_wr_ready_f;
wire [63:0] core_data_wr_desc_f;

if (!SEPARATE_CLOCKS) begin
  simple_fifo # (
    .ADDR_WIDTH($clog2(SEND_DESC_DEPTH)),
    .DATA_WIDTH(64)
  ) send_data_fifo (
    .clk(sys_clk),
    .rst(sys_rst),
    .clear(1'b0),
  
    .din_valid(data_send_valid && core_data_wr),
    .din(data_send_desc),
    .din_ready(core_data_wr_ready),
   
    .dout_valid(core_data_wr_valid_f),
    .dout(core_data_wr_desc_f),
    .dout_ready(core_data_wr_ready_f)
  );
end else begin 
  simple_async_fifo # (
    .DEPTH(SEND_DESC_DEPTH),
    .DATA_WIDTH(64)
  ) send_data_fifo (
    .async_rst(sys_rst),
  
    .din_clk(core_clk),
    .din_valid(data_send_valid && core_data_wr),
    .din(data_send_desc),
    .din_ready(core_data_wr_ready),
   
    .dout_clk(sys_clk),
    .dout_valid(core_data_wr_valid_f),
    .dout(core_data_wr_desc_f),
    .dout_ready(core_data_wr_ready_f)
  );
end

// A desc FIFO for msgs to scheduler
wire core_ctrl_wr_ready;

wire core_ctrl_wr_valid_f, core_ctrl_wr_ready_f;
wire [63:0] core_ctrl_wr_desc_f;

if (!SEPARATE_CLOCKS) begin
  simple_fifo # (
    .ADDR_WIDTH($clog2(SEND_DESC_DEPTH)),
    .DATA_WIDTH(64)
  ) send_ctrl_fifo (
    .clk(sys_clk),
    .rst(sys_rst),
    .clear(1'b0),
  
    .din_valid(data_send_valid && core_ctrl_wr),
    .din(data_send_desc),
    .din_ready(core_ctrl_wr_ready),
   
    .dout_valid(core_ctrl_wr_valid_f),
    .dout(core_ctrl_wr_desc_f),
    .dout_ready(core_ctrl_wr_ready_f)
  );
end else begin
  simple_async_fifo # (
    .DEPTH(SEND_DESC_DEPTH),
    .DATA_WIDTH(64)
  ) send_ctrl_fifo (
    .async_rst(sys_rst),
  
    .din_clk(core_clk),
    .din_valid(data_send_valid && core_ctrl_wr),
    .din(data_send_desc),
    .din_ready(core_ctrl_wr_ready),
   
    .dout_clk(sys_clk),
    .dout_valid(core_ctrl_wr_valid_f),
    .dout(core_ctrl_wr_desc_f),
    .dout_ready(core_ctrl_wr_ready_f)
  );
end

// A register to look up the send adddress based on slot
reg  [ADDR_WIDTH-1:0] send_slot_addr [0:SLOT_COUNT-1];
wire [SLOT_PTR_WIDTH-1:0] ctrl_out_slot_ptr = core_ctrl_wr_desc_f[LEN_WIDTH +: SLOT_WIDTH]
                                              -{{(SLOT_WIDTH-1){1'b0}},1'b1};
always @ (posedge sys_clk)
  if (core_ctrl_wr_valid_f && core_ctrl_wr_ready_f)
    send_slot_addr [ctrl_out_slot_ptr] <= core_ctrl_wr_desc_f[32+:ADDR_WIDTH];

// A FIFO for dram write requests
wire core_dram_wr_ready;
wire core_dram_wr_valid_f, core_dram_wr_ready_f;
wire [127:0] core_dram_wr_desc_f;

if (!SEPARATE_CLOCKS) begin
  simple_fifo # (
    .ADDR_WIDTH($clog2(DRAM_DESC_DEPTH)),
    .DATA_WIDTH(128)
  ) dram_send_fifo (
    .clk(sys_clk),
    .rst(sys_rst),
    .clear(1'b0),
  
    .din_valid(data_send_valid && core_dram_wr),
    .din({core_dram_addr, data_send_desc[63:24+PORT_WIDTH],
          dram_port, data_send_desc[23:0]}),
    .din_ready(core_dram_wr_ready),
   
    .dout_valid(core_dram_wr_valid_f),
    .dout(core_dram_wr_desc_f),
    .dout_ready(core_dram_wr_ready_f)
  );
end else begin 
  simple_async_fifo # (
    .DEPTH(DRAM_DESC_DEPTH),
    .DATA_WIDTH(128)
  ) dram_send_fifo (
    .async_rst(sys_rst),
  
    .din_clk(core_clk),
    .din_valid(data_send_valid && core_dram_wr),
    .din({core_dram_addr, data_send_desc[63:24+PORT_WIDTH],
          dram_port, data_send_desc[23:0]}),
    .din_ready(core_dram_wr_ready),
   
    .dout_clk(sys_clk),
    .dout_valid(core_dram_wr_valid_f),
    .dout(core_dram_wr_desc_f),
    .dout_ready(core_dram_wr_ready_f)
  );
end

// A desc FIFO for dram read msgs
wire core_dram_rd_ready;
wire core_dram_rd_valid_f, core_dram_rd_ready_f;
wire [127:0] core_dram_rd_desc_f;

if (!SEPARATE_CLOCKS) begin
  simple_fifo # (
    .ADDR_WIDTH($clog2(DRAM_DESC_DEPTH)),
    .DATA_WIDTH(128)
  ) send_ctrl_fifo (
    .clk(sys_clk),
    .rst(sys_rst),
    .clear(1'b0),
  
    .din_valid(data_send_valid && core_dram_rd),
    .din({core_dram_addr, data_send_desc}),
    .din_ready(core_dram_rd_ready),
   
    .dout_valid(core_dram_rd_valid_f),
    .dout(core_dram_rd_desc_f),
    .dout_ready(core_dram_rd_ready_f)
  );
end else begin
  simple_async_fifo # (
    .DEPTH(DRAM_DESC_DEPTH),
    .DATA_WIDTH(128)
  ) send_ctrl_fifo (
    .async_rst(sys_rst),
  
    .din_clk(core_clk),
    .din_valid(data_send_valid && core_dram_rd),
    .din({core_dram_addr, data_send_desc}),
    .din_ready(core_dram_rd_ready),
   
    .dout_clk(sys_clk),
    .dout_valid(core_dram_rd_valid_f),
    .dout(core_dram_rd_desc_f),
    .dout_ready(core_dram_rd_ready_f)
  );
end

assign data_send_ready = (core_data_wr_ready && core_data_wr) || 
                         (core_ctrl_wr_ready && core_ctrl_wr) ||
                         (core_dram_wr_ready && core_dram_wr) || 
                         (core_dram_rd_ready && core_dram_rd);

/////////////////////////////////////////////////////////////////////
////////////////// INCOMING CTRL DESCRIPTOR FIFO ////////////////////
///////////////////// PKT SENT DESCRIPTOR FIFO //////////////////////
//////////////// DRAM READ REQUEST PARSER AND FIFO //////////////////
/////////////////////////////////////////////////////////////////////


reg  [31:0] ctrl_s_axis_tdata_r;
reg         ctrl_s_axis_tvalid_r;
reg  [SLOT_PTR_WIDTH-1:0] ctrl_in_slot_ptr;
always @ (posedge sys_clk) begin
  if (ctrl_s_axis_tvalid && ctrl_s_axis_tready) begin
    ctrl_s_axis_tdata_r  <= ctrl_s_axis_tdata[31:0];
    ctrl_in_slot_ptr     <= ctrl_s_axis_tdata[16+:SLOT_WIDTH]
                            - {{(SLOT_WIDTH-1){1'b0}},1'b1};
  end 
  ctrl_s_axis_tvalid_r <= ((ctrl_s_axis_tvalid && !reset_cmd && ctrl_s_axis_tready) || 
                           (ctrl_s_axis_tvalid_r && (!ctrl_s_axis_tready)));

  if (sys_rst)
    ctrl_s_axis_tvalid_r <= 1'b0;
end
  
wire [ADDR_WIDTH-1:0] ctrl_send_addr = send_slot_addr[ctrl_in_slot_ptr];
wire ctrl_s_axis_fifo_ready;

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

  .din_valid(ctrl_s_axis_tvalid_r),
  .din({{(32-ADDR_WIDTH){1'b0}},ctrl_send_addr,ctrl_s_axis_tdata_r}),
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
always @ (posedge sys_clk) 
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
  .clk(sys_clk),
  .rst(sys_rst),
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
  .clk(sys_clk),
  .rst(sys_rst),
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
always @ (posedge sys_clk) begin
  if (dram_s_axis_tvalid && dram_req_ready)
    if (dram_s_axis_tlast) begin
      dram_req_high  <= dram_s_axis_tdata;
      dram_req_valid <= 1'b1;
    end else begin
      dram_req_low   <= {dram_s_axis_tdata[63:24+PORT_WIDTH],
                         dram_port, dram_s_axis_tdata[23:0]};
      dram_req_valid <= 1'b0;
    end
  else
      dram_req_valid <= 1'b0;

  if (sys_rst) 
      dram_req_valid <= 1'b0;
end

assign dram_s_axis_tready = dram_req_ready;

// Outgoing dram desc
reg [1:0] send_dram_rd_state;
always @ (posedge sys_clk)
  if (sys_rst)
    send_dram_rd_state <= 2'd0;
  else if (core_dram_rd_valid_f)
    case (send_dram_rd_state)
      2'd0: send_dram_rd_state <= 2'd1;
      2'd1: if (dram_m_axis_tready) send_dram_rd_state <= 2'd2;
      2'd2: if (dram_m_axis_tready) send_dram_rd_state <= 2'd0;
      2'd3: send_dram_rd_state <= 2'd3; // Error
    endcase

assign dram_m_axis_tvalid = (send_dram_rd_state != 2'd0);
assign dram_m_axis_tdata  = (send_dram_rd_state == 2'd2) ? core_dram_rd_desc_f[127:64] 
                                                         : core_dram_rd_desc_f[63:0];
assign dram_m_axis_tlast  = (send_dram_rd_state == 2'd2);
assign core_dram_rd_ready_f = (send_dram_rd_state == 2'd2) && dram_m_axis_tready;

/////////////////////////////////////////////////////////////////////
/////////////////////////// ARBITERS ////////////////////////////////
/////////////////////////////////////////////////////////////////////

// Data out arbiter between core direct send data and scheduler message
// Priority to messages from the scheduler
wire [63:0] send_pkt_desc;
wire send_pkt_valid, send_pkt_ready;

wire   data_select          = ctrl_in_valid;
assign send_pkt_valid       = ctrl_in_valid || core_data_wr_valid_f;
assign send_pkt_desc        = data_select ? ctrl_in_desc : core_data_wr_desc_f;
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
always @ (posedge sys_clk)
  if (sys_rst)
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

always @ (posedge sys_clk) begin
  if (ctrl_out_valid && (!ctrl_m_axis_tvalid_r || ctrl_m_axis_tready)) begin
    ctrl_m_axis_tdata_r  <= {ctrl_out_data[63:60], ctrl_out_data[31:0]};
    ctrl_m_axis_tvalid_r <= 1'b1;
  end else if (ctrl_m_axis_tready && !ctrl_out_valid) begin
    ctrl_m_axis_tvalid_r <= 1'b0;
  end
  if (sys_rst) begin
    ctrl_m_axis_tvalid_r <= 1'b0;
    ctrl_m_axis_tdata_r  <= 36'd0;
  end
end 

assign ctrl_m_axis_tvalid = ctrl_m_axis_tvalid_r;
assign ctrl_m_axis_tdata  = ctrl_m_axis_tdata_r;
assign ctrl_m_axis_tlast  = ctrl_m_axis_tvalid;
assign ctrl_m_axis_tuser  = CORE_ID;
assign ctrl_out_ready     = (!ctrl_m_axis_tvalid_r) || ctrl_m_axis_tready; 

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
    core_msg_in_v_r  <= core_msg_in_valid && (core_msg_in_user!=CORE_ID);
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
    dmam_dmem_switch <= 1'b0;
  end else begin
    dma_dmem_last_op <= dma_dmem_op;
    if (((dma_dmem_op == DMEM_READ)  && ram_cmd_rd_last && dma_dmem_rd_en) ||
        ((dma_dmem_op == DMEM_WRITE) && ram_cmd_wr_last && dma_dmem_wr_en))
      dmam_dmem_switch <= 1'b1;
    else
      dmam_dmem_switch <= 1'b0;
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
wire                  data_dma_en      = dma_dmem_wr_en || dma_dmem_rd_en;
wire [ADDR_WIDTH-1:0] data_dma_addr    = (dma_dmem_op==DMEM_WRITE) ?
                                         {1'b0,ram_cmd_wr_addr[ADDR_WIDTH-2:0]}: 
                                         {1'b0,ram_cmd_rd_addr[ADDR_WIDTH-2:0]};
wire                  data_dma_ren     = (dma_dmem_op==DMEM_READ); 
wire [STRB_WIDTH-1:0] data_dma_wen     = ((dma_dmem_op==DMEM_WRITE) ? 
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
    
    .in_desc(recv_desc_f),
    .in_desc_valid(recv_desc_valid_f),
    .in_desc_taken(recv_desc_ready_f),
    
    .recv_dram_tag_valid(recv_dram_tag_v),    
    .recv_dram_tag(recv_dram_tag),

    .data_desc(data_send_desc),
    .data_desc_valid(data_send_valid),
    .data_desc_ready(data_send_ready),
    
    .dram_wr_addr(core_dram_addr),
    
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
