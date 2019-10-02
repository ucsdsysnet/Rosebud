module header_adder # (
  parameter DATA_WIDTH = 128,
  parameter HDR_WIDTH  = 64,
  parameter DEST_WIDTH = 8,
  parameter USER_WIDTH = 8,
  parameter STRB_WIDTH = DATA_WIDTH/8,
  parameter HDR_STRB   = HDR_WIDTH/8
)(
  input  wire clk,
  input  wire rst,

  input  wire [DATA_WIDTH-1:0] s_axis_tdata,
  input  wire [STRB_WIDTH-1:0] s_axis_tkeep,
  input  wire [DEST_WIDTH-1:0] s_axis_tdest,
  input  wire [USER_WIDTH-1:0] s_axis_tuser,
  input  wire                  s_axis_tlast,
  input  wire                  s_axis_tvalid,
  output wire                  s_axis_tready,

  input  wire [HDR_WIDTH-1:0]  header,
  input  wire                  header_valid,
  output wire                  header_ready,

  output wire [DATA_WIDTH-1:0] m_axis_tdata,
  output wire [STRB_WIDTH-1:0] m_axis_tkeep,
  output wire [DEST_WIDTH-1:0] m_axis_tdest,
  output wire [USER_WIDTH-1:0] m_axis_tuser,
  output wire                  m_axis_tlast,
  output wire                  m_axis_tvalid,
  input  wire                  m_axis_tready
);

  reg [HDR_WIDTH-1:0]  rest_tdata_r;
  reg [HDR_STRB-1:0]   rest_tkeep_r;
  reg [DEST_WIDTH-1:0] s_axis_tdest_r;
  reg [USER_WIDTH-1:0] s_axis_tuser_r;
  
  wire strb_left = |s_axis_tkeep[STRB_WIDTH-1:STRB_WIDTH-HDR_STRB];
  
  // State machine. HDR while waiting or sending the header, 
  // LST when sending the last piece. MID in between
  localparam HDR = 2'b00;
  localparam MID = 2'b01;
  localparam LST = 2'b10;
  localparam ERR = 2'b11;
  
  reg [1:0] state;
  
  always @ (posedge clk)
    if (rst)
      state <= HDR;
    else case (state)
      HDR: if (s_axis_tvalid && header_valid && m_axis_tready) begin
             if (s_axis_tlast) // one word data
               if (strb_left) state <= LST; else state <= HDR;
             else 
               state <= MID;
           end
      MID: if (s_axis_tvalid && s_axis_tlast && m_axis_tready) begin
             if (strb_left) state <= LST; else state <= HDR;
           end
      LST: if (m_axis_tready) state <= HDR;
      ERR: state <= ERR;
    endcase 
  
  // Latch tdest and tuser at first cycle (for last cycle), and always latch tdata and tkeep
  always @ (posedge clk) begin
    rest_tdata_r <= s_axis_tdata[DATA_WIDTH-1:DATA_WIDTH-HDR_WIDTH];
    rest_tkeep_r <= s_axis_tkeep[STRB_WIDTH-1:STRB_WIDTH-HDR_STRB];
    if (state == HDR) begin
      s_axis_tdest_r <= s_axis_tdest;
      s_axis_tuser_r <= s_axis_tuser;
    end
  end
  
  assign m_axis_tvalid = (state==HDR) ? (s_axis_tvalid && header_valid) :
                         (state==MID) ? s_axis_tvalid : (state==LST);

  assign m_axis_tdata = (state==HDR) ? {s_axis_tdata[DATA_WIDTH-HDR_WIDTH-1:0], header} : 
                        (state==MID) ? {s_axis_tdata[DATA_WIDTH-HDR_WIDTH-1:0], rest_tdata_r} : 
                                       {{(DATA_WIDTH-HDR_WIDTH){1'b0}},         rest_tdata_r};
   
  assign m_axis_tkeep = (state==HDR) ? {s_axis_tkeep[STRB_WIDTH-HDR_STRB-1:0], {HDR_STRB{1'b1}}} : 
                        (state==MID) ? {s_axis_tkeep[STRB_WIDTH-HDR_STRB-1:0], rest_tkeep_r} : 
                                       {{(STRB_WIDTH-HDR_STRB){1'b0}},         rest_tkeep_r};
  
  assign m_axis_tdest = (state==HDR) ? s_axis_tdest : s_axis_tdest_r;
  assign m_axis_tuser = (state==HDR) ? s_axis_tuser : s_axis_tuser_r;
  assign m_axis_tlast = (state==LST) | (!strb_left && s_axis_tlast);
  
  assign s_axis_tready = (state==HDR) ? (m_axis_tready && header_valid) : m_axis_tready;
  // Accepting header only on the first word
  assign header_ready  = (state==HDR) && s_axis_tvalid && m_axis_tready; 
                      
endmodule

module header_remover # (
  parameter DATA_WIDTH = 128,
  parameter HDR_WIDTH  = 64,
  parameter DEST_WIDTH = 8,
  parameter USER_WIDTH = 8,
  parameter STRB_WIDTH = DATA_WIDTH/8,
  parameter HDR_STRB   = HDR_WIDTH/8
)(
  input  wire clk,
  input  wire rst,

  input  wire [DATA_WIDTH-1:0] s_axis_tdata,
  input  wire [STRB_WIDTH-1:0] s_axis_tkeep,
  input  wire [DEST_WIDTH-1:0] s_axis_tdest,
  input  wire [USER_WIDTH-1:0] s_axis_tuser,
  input  wire                  s_axis_tlast,
  input  wire                  s_axis_tvalid,
  output wire                  s_axis_tready,

  // As long as output is valid header is also valid
  output wire [HDR_WIDTH-1:0]  header,

  output wire [DATA_WIDTH-1:0] m_axis_tdata,
  output wire [STRB_WIDTH-1:0] m_axis_tkeep,
  output wire [DEST_WIDTH-1:0] m_axis_tdest,
  output wire [USER_WIDTH-1:0] m_axis_tuser,
  output wire                  m_axis_tlast,
  output wire                  m_axis_tvalid,
  input  wire                  m_axis_tready
);

  reg [HDR_WIDTH-1:0]            header_r;
  reg [DATA_WIDTH-HDR_WIDTH-1:0] rest_tdata_r;
  reg [STRB_WIDTH-HDR_STRB-1:0]  rest_tkeep_r;
  reg [DEST_WIDTH-1:0]           s_axis_tdest_r;
  reg [USER_WIDTH-1:0]           s_axis_tuser_r;
  
  wire strb_left = |s_axis_tkeep[STRB_WIDTH-1:HDR_STRB];
  
  // State machine. HDR while waiting or sending the header, 
  // LST when sending the last piece. MID in between
  localparam HDR = 2'b00;
  localparam MID = 2'b01;
  localparam LST = 2'b10;
  localparam ERR = 2'b11;
  
  reg [1:0] state;
  
  always @ (posedge clk)
    if (rst)
      state <= HDR;
    else case (state)
      HDR: if (s_axis_tvalid) begin
             if (s_axis_tlast && m_axis_tready) // one word data
               state <= HDR;
             else 
               state <= MID;
           end
      MID: if (s_axis_tvalid && s_axis_tlast && m_axis_tready) begin
             if (strb_left) state <= LST; else state <= HDR;
           end
      LST: if (m_axis_tready) state <= HDR;
      ERR: state <= ERR;
    endcase 
 
  // Latch tdest and tuser at first cycle (for last cycle), and always latch tdata and tkeep
  always @ (posedge clk) begin
    if (s_axis_tvalid && s_axis_tready) begin
      rest_tdata_r <= s_axis_tdata[DATA_WIDTH-1:HDR_WIDTH];
      rest_tkeep_r <= s_axis_tkeep[STRB_WIDTH-1:HDR_STRB];
    end 
    if (state == HDR) begin
      header_r       <= s_axis_tdata[HDR_WIDTH-1:0];
      s_axis_tdest_r <= s_axis_tdest;
      s_axis_tuser_r <= s_axis_tuser;
    end
  end

  assign header        = (state==HDR) ? s_axis_tdata[HDR_WIDTH-1:0] : header_r;
 
  assign m_axis_tvalid = (state==HDR) ? (s_axis_tvalid && s_axis_tlast) :
                         (state==MID) ? s_axis_tvalid : (state==LST);

  assign m_axis_tdata  = (state==HDR) ? {{HDR_WIDTH{1'b0}}, s_axis_tdata[DATA_WIDTH-1:HDR_WIDTH]} : 
                         (state==MID) ? {s_axis_tdata[HDR_WIDTH-1:0], rest_tdata_r} : 
                                       {{HDR_WIDTH{1'b0}}, rest_tdata_r};
   
  assign m_axis_tkeep  = (state==HDR) ? {{HDR_STRB{1'b0}}, s_axis_tkeep[STRB_WIDTH-1:HDR_STRB]} : 
                         (state==MID) ? {s_axis_tkeep[HDR_STRB-1:0], rest_tkeep_r} : 
                                       {{HDR_STRB{1'b0}}, rest_tkeep_r};
  
  assign m_axis_tdest  = (state==HDR) ? s_axis_tdest : s_axis_tdest_r;
  assign m_axis_tuser  = (state==HDR) ? s_axis_tuser : s_axis_tuser_r;

  assign m_axis_tlast  = (state==LST) | ((state==HDR) && s_axis_tlast) | (!strb_left && s_axis_tlast);
  
  assign s_axis_tready = (state==HDR) | m_axis_tready;

endmodule

