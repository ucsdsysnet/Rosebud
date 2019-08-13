module simple_sync_sig # (
  parameter RST_VAL=1'b0
) (
  input dst_clk,
  input dst_rst,
  input in,
  output out
);

reg [1:0] sync_reg;

always @ (posedge dst_clk)
  if (dst_rst)
    sync_reg <= {2{RST_VAL}};
  else
    sync_reg <= {sync_reg[0],in};

assign out = sync_reg[1];

endmodule
