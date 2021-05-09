module FDCE #(
  parameter INIT = 1'b0
) (
   output reg  Q,
   input  wire C,
   input  wire CE,
   input  wire CLR,
   input  wire D
);

always @ (posedge C) begin
  if (CLR)
    Q <= INIT;
  else if (CE)
    Q <= D;
end

endmodule
