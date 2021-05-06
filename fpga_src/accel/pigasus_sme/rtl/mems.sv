module rom_2port #(
	parameter DWIDTH    = 8,
	parameter AWIDTH    = 8,
	parameter MEM_SIZE  = (2**AWIDTH),
	parameter INIT_FILE = ""
) (

  input  wire              clk,
  input  wire [AWIDTH-1:0] address_a,
  input  wire [AWIDTH-1:0] address_b,
  
  output reg  [DWIDTH-1:0] qa,
  output reg  [DWIDTH-1:0] qb
);

  reg [DWIDTH-1:0] mem [(1<<AWIDTH)-1:0];
  
  always @ (posedge clk) begin
    qa <= mem[address_a];
    qb <= mem[address_b];
  end

  initial begin
    if (INIT_FILE!="")
      $readmemb(INIT_FILE, mem);
  end

endmodule

module rom_2port_noreg #(
	parameter DWIDTH    = 8,
	parameter AWIDTH    = 8,
	parameter MEM_SIZE  = (2**AWIDTH),
	parameter INIT_FILE = ""
) (

  input  wire              clock,
  input  wire [AWIDTH-1:0] address_a,
  input  wire [AWIDTH-1:0] address_b,
  
  output reg  [DWIDTH-1:0] qa,
  output reg  [DWIDTH-1:0] qb
);

  reg [DWIDTH-1:0] mem [(1<<AWIDTH)-1:0];
  
  always @ (*) begin
    qa = mem[address_a];
    qb = mem[address_b];
  end

  initial begin
    if (INIT_FILE!="")
      $readmemb(INIT_FILE, mem);
  end

endmodule

module singledsp (
  input         clk0,
  input         clk1,
  input         clk2,
  
  input         ena,
  input  [17:0] ay,
  input  [17:0] ax,
  output [36:0] resulta
);

  wire [35:0] ax2 = ax*ax;
  wire [35:0] ay2 = ay*ay;
  wire [36:0] sum = ax2+ay2;

  always @ (posedge clk0)
    if (ena)
      resulta <= sum;

endmodule
