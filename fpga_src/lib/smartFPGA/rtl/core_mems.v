module mem_1r1w # (
  parameter BYTES_PER_LINE = 4,
  parameter ADDR_WIDTH     = 11,
  parameter LINE_SIZE      = 8*BYTES_PER_LINE
)( 
  input                       clk,

  input                       ena,
  input  [BYTES_PER_LINE-1:0] wea,
  input  [ADDR_WIDTH-1:0]     addra,
  input  [LINE_SIZE-1 :0]     dina,

  input                       enb,
  input  [ADDR_WIDTH-1:0]     addrb,
  output [LINE_SIZE-1 :0]     doutb
);

reg [LINE_SIZE-1:0] mem [0:(2**ADDR_WIDTH)-1];
reg [LINE_SIZE-1:0] mem_out;
integer i;

always @ (posedge clk)
  if (ena)
    for (i = 0; i < BYTES_PER_LINE; i = i + 1) 
      if (wea[i] == 1'b1) 
        mem[addra][i*8 +: 8]  <= dina[i*8 +: 8];

always @ (posedge clk)
  if (enb)
    mem_out <= mem[addrb];

assign doutb = mem_out;

initial begin
    $readmemh("../../../../c_code/default.hex", mem);
end 

endmodule


module mem_2rw # (
  parameter BYTES_PER_LINE = 4,
  parameter ADDR_WIDTH     = 13,
  parameter LINE_SIZE      = 8*BYTES_PER_LINE
)(
  input                       clk,

  input                       ena,
  input  [BYTES_PER_LINE-1:0] wena,
  input  [ADDR_WIDTH-1    :0] addra,
  input  [LINE_SIZE-1     :0] dina,
  output [LINE_SIZE-1     :0] douta,

  input                       enb,
  input  [BYTES_PER_LINE-1:0] wenb,
  input  [ADDR_WIDTH-1    :0] addrb,
  input  [LINE_SIZE-1     :0] dinb,
  output [LINE_SIZE-1     :0] doutb
);

(* ram_style = "ultra" *)
reg [LINE_SIZE-1:0] mem [(1<<ADDR_WIDTH)-1:0];
reg [LINE_SIZE-1:0] mem_out_a;
reg [LINE_SIZE-1:0] mem_out_b;
integer i;

always @ (posedge clk)
  if (ena)
    for (i = 0; i < BYTES_PER_LINE; i = i + 1) 
      if (wena[i]) 
        mem[addra][i*8 +: 8]  <= dina[i*8 +: 8];

always @ (posedge clk)
  if (ena)
    if (~|wena)
      mem_out_a <= mem[addra];

always @ (posedge clk)
  if (enb) 
    for (i = 0; i < BYTES_PER_LINE; i = i + 1) 
      if (wenb[i])
        mem[addrb][i*8 +: 8]  <= dinb[i*8 +: 8];

always @ (posedge clk)
  if (enb)
    if (~|wenb)
      mem_out_b <= mem[addrb];

assign douta = mem_out_a;
assign doutb = mem_out_b;

endmodule
