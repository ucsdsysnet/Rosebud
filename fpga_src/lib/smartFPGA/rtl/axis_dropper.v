// Sits on tvalid/tready/tlast to drop on packet boundaries.
// Based on SAME_CYCLE_DROP, adds 1 bit or 3bits logic for tvalid and tready
module axis_dropper # (
  parameter PORT_COUNT      = 4,
  parameter REG_FOR_DROP    = 0,
  parameter SAME_CYCLE_DROP = 0,
  parameter DROP_CNT_WIDTH  = 32
) (
  input  wire                                 clk,
  input  wire                                 rst,

  input  wire [PORT_COUNT-1:0]                drop,
  output reg  [PORT_COUNT*DROP_CNT_WIDTH-1:0] drop_count,

  input  wire [PORT_COUNT-1:0]                s_axis_tvalid,
  input  wire [PORT_COUNT-1:0]                s_axis_tlast,
  output wire [PORT_COUNT-1:0]                s_axis_tready,

  output wire [PORT_COUNT-1:0]                m_axis_tvalid,
  output wire [PORT_COUNT-1:0]                m_axis_tlast,
  input  wire [PORT_COUNT-1:0]                m_axis_tready
);

  // Register drop input if necessary
  reg [PORT_COUNT-1:0] drop_r;
  generate
    if (REG_FOR_DROP) begin

      always @ (posedge clk)
        if (rst)
          drop_r <= {PORT_COUNT{1'b0}};
        else
          drop_r <= drop;

    end else begin

      always @ (*)
          drop_r = drop;

    end
  endgenerate

  // Detect Start of Packet or idle
  reg [PORT_COUNT-1:0] SoP;
  // Register to keep dropping state
  reg [PORT_COUNT-1:0] dropping;
  integer i;
  wire [PORT_COUNT-1:0] s_axis_transaction = s_axis_tvalid & s_axis_tready;

  always @ (posedge clk)
    if (rst) begin
      SoP      <= {PORT_COUNT{1'b1}};
      dropping <= {PORT_COUNT{1'b0}};
    end else begin
      for (i=0;i<PORT_COUNT;i=i+1) begin
        if (s_axis_transaction[i]) // If there was a transaction
          SoP[i] <= s_axis_tlast[i]; // SoP becomes 1 only after tlast

        // When drop is asserted, if we have SAME_CYCLE_DROP, on IDLE or actual SoP
        // we start dropping, and if its in the middle of a packet we wait for tlast.
        // If we ignore corner case of drop signal being asserted at the same cycle
        // as SoP, we start dropping when IDLE or wait for tlast.
        if (drop_r[i] && !dropping[i])
          dropping[i] <= SAME_CYCLE_DROP ?
                                   (SoP[i] || (s_axis_transaction[i] && s_axis_tlast[i])):
            ((SoP[i] && !s_axis_tvalid[i]) || (s_axis_transaction[i] && s_axis_tlast[i]));
        // When drop is deasserted while dropping is set, if we have SAME_CYCLE_DROP,
        // either SoP, IDLE or tlast would deasserted the dropping. If we ignore the
        // corner case, only tlast or idle deasserts the dropping.
        else if (!drop_r[i] && dropping[i])
          dropping[i] <= SAME_CYCLE_DROP ?
                                  !(SoP[i] || (s_axis_transaction[i] && s_axis_tlast[i])):
           !((SoP[i] && !s_axis_tvalid[i]) || (s_axis_transaction[i] && s_axis_tlast[i]));
      end
    end    //READY!

  // Combinational logic for the outputs.
  // If we have SAME_CYCLE_DROP, if actual Stop and drop_r happen in the same cycle
  // we drop, and if SoP and deassertion of drop_r happen in the same cycle we ignore
  // the dropping register. In case of ignoring the corner case of same cycle, we
  // simply use the dropping register.
  wire [PORT_COUNT-1:0] to_drop = SAME_CYCLE_DROP ?
                (SoP & drop_r) | (dropping & ~(SoP & ~drop_r)) : dropping;

  assign m_axis_tlast  = s_axis_tlast;
  assign m_axis_tvalid = s_axis_tvalid & ~to_drop;
  assign s_axis_tready = m_axis_tready |  to_drop;

  integer j;
  always @ (posedge clk)
    if (rst)
      drop_count <= {PORT_COUNT*DROP_CNT_WIDTH{1'b0}};
    else
      for (j=0;j<PORT_COUNT;j=j+1)
        if (s_axis_transaction[j] && s_axis_tlast[j] && to_drop[j])
          drop_count [j*DROP_CNT_WIDTH +: DROP_CNT_WIDTH] =
            drop_count [j*DROP_CNT_WIDTH +: DROP_CNT_WIDTH] + 1;

endmodule
