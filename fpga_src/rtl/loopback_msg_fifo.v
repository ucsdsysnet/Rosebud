module loopback_msg_fifo # (
    parameter DATA_WIDTH      = 64,   
    parameter STRB_WIDTH      = (DATA_WIDTH/8),
    parameter PORT_WIDTH      = 2,
    parameter CORE_WIDTH      = 4,
    parameter SLOT_WIDTH      = 3,
    parameter ID_TAG_WIDTH    = 5+CORE_WIDTH
) (
    input  wire                     clk,
    input  wire                     rst,

    input  wire [DATA_WIDTH-1:0]    s_axis_tdata,
    input  wire [STRB_WIDTH-1:0]    s_axis_tkeep,
    input  wire                     s_axis_tvalid,
    input  wire                     s_axis_tlast,
    input  wire [PORT_WIDTH-1:0]    s_axis_tdest,
    input  wire [ID_TAG_WIDTH-1:0]  s_axis_tuser,
    output wire                     s_axis_tready,
  
    output wire [DATA_WIDTH-1:0]    m_axis_tdata,
    output wire [STRB_WIDTH-1:0]    m_axis_tkeep,
    output wire                     m_axis_tvalid,
    output wire                     m_axis_tlast,
    output wire [ID_TAG_WIDTH-1:0]  m_axis_tdest,
    output wire [PORT_WIDTH-1:0]    m_axis_tuser,
    input  wire                     m_axis_tready,
 
    input  wire [ID_TAG_WIDTH-1:0]  msg_src,
    input  wire [ID_TAG_WIDTH-1:0]  msg_dest,
    input  wire                     msg_valid,
    output wire                     msg_ready
);
  
// Look up table for destination 
reg [ID_TAG_WIDTH-1:0] dest_lut [0:2**(CORE_WIDTH+SLOT_WIDTH)-1];

wire [CORE_WIDTH+SLOT_WIDTH-1:0] lut_wr_ptr = 
    {msg_src[ID_TAG_WIDTH-1:ID_TAG_WIDTH-CORE_WIDTH],msg_src[SLOT_WIDTH-1:0]};
wire [CORE_WIDTH+SLOT_WIDTH-1:0] lut_rd_ptr = 
    {s_axis_tuser[ID_TAG_WIDTH-1:ID_TAG_WIDTH-CORE_WIDTH],s_axis_tuser[SLOT_WIDTH-1:0]};

always @ (posedge clk)
  if (msg_valid)
    dest_lut[lut_wr_ptr] <= msg_dest;

assign msg_ready = 1'b1;

wire [ID_TAG_WIDTH-1:0] dest_tag;

assign dest_tag = dest_lut[lut_rd_ptr];

// AXIS FIFO
axis_fifo #(
    .DEPTH(4096),
    .DATA_WIDTH(DATA_WIDTH),
    .KEEP_ENABLE(1),
    .KEEP_WIDTH(STRB_WIDTH),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(1),
    .DEST_WIDTH(ID_TAG_WIDTH),
    .USER_ENABLE(1),
    .USER_WIDTH (PORT_WIDTH),
    .FRAME_FIFO(0)
) axis_fifo_inst (
    .clk(clk),
    .rst(rst),

    .s_axis_tdata (s_axis_tdata),
    .s_axis_tkeep (s_axis_tkeep),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tready(s_axis_tready),
    .s_axis_tlast (s_axis_tlast),
    .s_axis_tid   (8'd0),
    .s_axis_tdest (dest_tag),
    .s_axis_tuser (s_axis_tdest),

    .m_axis_tdata (m_axis_tdata),
    .m_axis_tkeep (m_axis_tkeep),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready),
    .m_axis_tlast (m_axis_tlast),
    .m_axis_tid   (),
    .m_axis_tdest (m_axis_tdest),
    .m_axis_tuser (m_axis_tuser),

    .status_overflow(),
    .status_bad_frame(),
    .status_good_frame()
);

endmodule
