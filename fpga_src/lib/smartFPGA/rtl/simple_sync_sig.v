module simple_sync_sig # (
  parameter RST_VAL = 1'b0,
  parameter WIDTH   = 1
) (
  input  dst_clk,
  input  dst_rst,
  input  [WIDTH-1:0] in,
  output [WIDTH-1:0] out
);

(* KEEP = "TRUE" *) reg [WIDTH-1:0] sync_reg_1;
(* KEEP = "TRUE" *) reg [WIDTH-1:0] sync_reg_2;

always @ (posedge dst_clk)
  if (dst_rst) begin
    sync_reg_1 <= {WIDTH{RST_VAL}};
    sync_reg_2 <= {WIDTH{RST_VAL}};
  end else begin
    sync_reg_1 <= in;
    sync_reg_2 <= sync_reg_1;
  end

assign out = sync_reg_2;

endmodule
