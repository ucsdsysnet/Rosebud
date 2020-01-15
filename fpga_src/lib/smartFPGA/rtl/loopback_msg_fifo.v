module loopback_msg_fifo # (
    parameter DATA_WIDTH      = 64,   
    parameter STRB_WIDTH      = (DATA_WIDTH/8),
    parameter PORT_WIDTH      = 2,
    parameter CORE_WIDTH      = 4,
    parameter SLOT_WIDTH      = 3,
    parameter PORT_COUNT      = 2,
    parameter FIRST_PORT      = 2,
    parameter HDR_WIDTH       = 64,
    parameter ID_TAG_WIDTH    = 5+CORE_WIDTH
) (
    input  wire                     clk,
    input  wire                     rst,

    input  wire [PORT_COUNT*DATA_WIDTH-1:0]    s_axis_tdata,
    input  wire [PORT_COUNT*STRB_WIDTH-1:0]    s_axis_tkeep,
    input  wire [PORT_COUNT-1:0]               s_axis_tvalid,
    input  wire [PORT_COUNT-1:0]               s_axis_tlast,
    input  wire [PORT_COUNT*ID_TAG_WIDTH-1:0]  s_axis_tuser,
    output wire [PORT_COUNT-1:0]               s_axis_tready,
  
    output wire [PORT_COUNT*DATA_WIDTH-1:0]    m_axis_tdata,
    output wire [PORT_COUNT*STRB_WIDTH-1:0]    m_axis_tkeep,
    output wire [PORT_COUNT-1:0]               m_axis_tvalid,
    output wire [PORT_COUNT-1:0]               m_axis_tlast,
    output wire [PORT_COUNT*ID_TAG_WIDTH-1:0]  m_axis_tdest,
    output wire [PORT_COUNT*PORT_WIDTH-1:0]    m_axis_tuser,
    input  wire [PORT_COUNT-1:0]               m_axis_tready
);
  
genvar i;
generate
  for (i=0; i<PORT_COUNT; i=i+1) begin

    wire [DATA_WIDTH-1:0]    int_axis_tdata;
    wire [STRB_WIDTH-1:0]    int_axis_tkeep;
    wire                     int_axis_tvalid;
    wire                     int_axis_tlast;
    wire                     int_axis_tready;
    wire [HDR_WIDTH-1:0]     dest_header;

    // no use fo s_axis_tuser
    assign m_axis_tuser[i*PORT_WIDTH +: PORT_WIDTH] = FIRST_PORT + i;
 
    header_remover # (
      .DATA_WIDTH(DATA_WIDTH),
      .HDR_WIDTH(HDR_WIDTH),
      .USER_WIDTH(1),
      .DEST_WIDTH(1)
    ) dest_remover (
      .clk(clk),
      .rst(rst),
        
      .s_axis_tdata (s_axis_tdata[i*DATA_WIDTH +: DATA_WIDTH]),
      .s_axis_tkeep (s_axis_tkeep[i*STRB_WIDTH +: STRB_WIDTH]),
      .s_axis_tdest (1'b0), 
      .s_axis_tuser (1'b0), 
      .s_axis_tlast (s_axis_tlast[i]),
      .s_axis_tvalid(s_axis_tvalid[i]),
      .s_axis_tready(s_axis_tready[i]),
     
      .header(dest_header), 
    
      .m_axis_tdata (int_axis_tdata),
      .m_axis_tkeep (int_axis_tkeep),
      .m_axis_tdest (),
      .m_axis_tuser (),
      .m_axis_tlast (int_axis_tlast),
      .m_axis_tvalid(int_axis_tvalid),
      .m_axis_tready(int_axis_tready)

    );

    // AXIS FIFO
    axis_fifo #(
        .DEPTH(8192),
        .DATA_WIDTH(DATA_WIDTH),
        .KEEP_ENABLE(1),
        .KEEP_WIDTH(STRB_WIDTH),
        .LAST_ENABLE(1),
        .ID_ENABLE(0),
        .DEST_ENABLE(1),
        .DEST_WIDTH(ID_TAG_WIDTH),
        .USER_ENABLE(0),
        .USER_WIDTH (1),
        .FRAME_FIFO(0)
    ) axis_fifo_inst (
        .clk(clk),
        .rst(rst),
    
        .s_axis_tdata (int_axis_tdata),
        .s_axis_tkeep (int_axis_tkeep),
        .s_axis_tvalid(int_axis_tvalid),
        .s_axis_tready(int_axis_tready),
        .s_axis_tlast (int_axis_tlast),
        .s_axis_tid   (8'd0),
        .s_axis_tdest (dest_header[ID_TAG_WIDTH-1:0]),
        .s_axis_tuser (1'b0),
    
        .m_axis_tdata (m_axis_tdata[i*DATA_WIDTH +: DATA_WIDTH]),
        .m_axis_tkeep (m_axis_tkeep[i*STRB_WIDTH +: STRB_WIDTH]),
        .m_axis_tvalid(m_axis_tvalid[i]),
        .m_axis_tready(m_axis_tready[i]),
        .m_axis_tlast (m_axis_tlast[i]),
        .m_axis_tid   (),
        .m_axis_tdest (m_axis_tdest[i*ID_TAG_WIDTH +: ID_TAG_WIDTH]),
        .m_axis_tuser (),
    
        .status_overflow(),
        .status_bad_frame(),
        .status_good_frame()
    );
  end
endgenerate

endmodule
