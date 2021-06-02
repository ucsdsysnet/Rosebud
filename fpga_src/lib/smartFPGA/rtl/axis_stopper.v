// Sits on tvalid/tready/tlast to stop the interface on packet boundaries.
// Adds 2 bits logic for tvalid and tready
module axis_stopper # (
  parameter PORT_COUNT = 4,
  parameter REG_FOR_EN = 0
) (
  input  wire                  clk,
  input  wire                  rst,

  input  wire [PORT_COUNT-1:0] enable,

  input  wire [PORT_COUNT-1:0] s_axis_tvalid,
  input  wire [PORT_COUNT-1:0] s_axis_tlast,
  output wire [PORT_COUNT-1:0] s_axis_tready,

  output wire [PORT_COUNT-1:0] m_axis_tvalid,
  output wire [PORT_COUNT-1:0] m_axis_tlast,
  input  wire [PORT_COUNT-1:0] m_axis_tready
);

  // Register enable input if necessary
  reg [PORT_COUNT-1:0] enable_r;
  generate
    if (REG_FOR_EN) begin

      always @ (posedge clk)
        if (rst)
          enable_r <= {PORT_COUNT{1'b1}};
        else
          enable_r <= enable;

    end else begin

      always @ (*)
          enable_r = enable;

    end
  endgenerate

  // Detect Start of Packet
  reg [PORT_COUNT-1:0] SoP;
  integer i;

  always @ (posedge clk)
    if (rst)
      SoP <= {PORT_COUNT{1'b1}};
    else
      for (i=0;i<PORT_COUNT;i=i+1)
        if (s_axis_tvalid[i] && s_axis_tready[i]) // If there was a transaction
          SoP[i] <= s_axis_tlast[i]; // SoP becomes 1 only after tlast

  // Combinational logic for the outputs.
  // Blocking happens only from start of a packet until enable is re-asserted
  wire [PORT_COUNT-1:0] block = SoP & ~enable_r;

  assign m_axis_tlast  = s_axis_tlast;
  assign m_axis_tvalid = s_axis_tvalid & ~block;
  assign s_axis_tready = m_axis_tready & ~block;

endmodule
