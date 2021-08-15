module rom_2port #(
	parameter DWIDTH    = 8,
	parameter AWIDTH    = 8,
	parameter MEM_SIZE  = (2**AWIDTH),
	parameter INIT_FILE = ""
) (

  input  wire              clock,
  input  wire [AWIDTH-1:0] address_a,
  input  wire [AWIDTH-1:0] address_b,

  output reg  [DWIDTH-1:0] q_a,
  output reg  [DWIDTH-1:0] q_b
);

  reg [DWIDTH-1:0] mem [0:(1<<AWIDTH)-1];
  reg [AWIDTH-1:0] address_a_r;
  reg [AWIDTH-1:0] address_b_r;

  always @ (posedge clock) begin
    address_a_r <= address_a;
    address_b_r <= address_b;

    q_a <= mem[address_a_r];
    q_b <= mem[address_b_r];
  end

  initial begin
    if (INIT_FILE!="")
      $readmemh(INIT_FILE, mem);
  end

endmodule

module ram_1rw1r #(
	parameter DWIDTH    = 8,
	parameter AWIDTH    = 8,
	parameter MEM_SIZE  = (2**AWIDTH)
) (

  input  wire              clock,
  input  wire [AWIDTH-1:0] address_a,
  input  wire [DWIDTH-1:0] wr_data_a,
  input  wire              en_a,
  input  wire              wr_en_a,
  output reg  [DWIDTH-1:0] q_a,

  input  wire              en_b,
  input  wire [AWIDTH-1:0] address_b,
  output reg  [DWIDTH-1:0] q_b
);

  (* ram_style = "ultra" *)
  reg [DWIDTH-1:0] mem [0:(1<<AWIDTH)-1];
  reg [AWIDTH-1:0] address_a_r;
  reg [AWIDTH-1:0] address_b_r;

  reg [DWIDTH-1:0] wr_data_r;
  reg              wr_en_r;

  // Input register
  always @ (posedge clock) begin
    address_a_r <= address_a;
    address_b_r <= address_b;
    wr_data_r   <= wr_data_a;
    wr_en_r     <= wr_en_a;
  end

  always @ (posedge clock)
    if (en_a)
      if (wr_en_r)
        mem[address_a_r] <= wr_data_r;

  always @ (posedge clock)
    if (en_a)
      if (!wr_en_r)
        q_a <= mem[address_a_r];

  always @ (posedge clock)
    if (en_b)
        q_b <= mem[address_b_r];

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

  output reg  [DWIDTH-1:0] q_a,
  output reg  [DWIDTH-1:0] q_b
);

  reg [DWIDTH-1:0] mem [0:(1<<AWIDTH)-1];

  always @ (posedge clock) begin
    q_a <= mem[address_a];
    q_b <= mem[address_b];
  end

  initial begin
    if (INIT_FILE!="")
      $readmemh(INIT_FILE, mem);
  end

endmodule


module rom_1port_mlab #(
	parameter DWIDTH    = 8,
	parameter AWIDTH    = 8,
	parameter MEM_SIZE  = (2**AWIDTH),
	parameter INIT_FILE = ""
) (
  input  wire              clock,
  input  wire [AWIDTH-1:0] address,
  output reg  [DWIDTH-1:0] q
);

  reg [DWIDTH-1:0] mem [0:(1<<AWIDTH)-1];
  reg [AWIDTH-1:0] address_r;

  always @ (posedge clock) begin
    address_r <= address;
    q <= mem[address_r];
  end

  initial begin
    if (INIT_FILE!="")
      $readmemh(INIT_FILE, mem);
  end

endmodule


module singledsp (
  input  wire        clk0,
  input  wire        clk1,
  input  wire        clk2,
  input  wire [2:0]  ena,

  input  wire [17:0] ax,
  input  wire [17:0] ay,

  output reg  [36:0] resulta
);

  reg [17:0] ax_r;
  reg [17:0] ay_r;
  reg [17:0] ax_rr;
  reg [17:0] ay_rr;
  reg [35:0] mul;

  always @ (posedge clk0)
    if (ena[0]) begin
      ax_r <= ax;
      ay_r <= ay;

      ax_rr <= ax_r;
      ay_rr <= ay_r;

      mul  <= ax_rr*ay_rr;

      resulta <= {1'b0, mul};
    end

endmodule

module dsp (
  input  wire        clk0,
  input  wire        clk1,
  input  wire        clk2,
  input  wire [2:0]  ena,

  input  wire [17:0] ax,
  input  wire [17:0] ay,

  input  wire [17:0] bx,
  input  wire [17:0] by,

  output reg  [36:0] resulta
);

  reg [17:0] ax_r;
  reg [17:0] ay_r;
  reg [17:0] bx_r;
  reg [17:0] by_r;

  reg [35:0] mul_a;
  reg [35:0] mul_b;

  reg [36:0] sum;

  always @ (posedge clk0)
    if (ena[0]) begin
      ax_r <= ax;
      ay_r <= ay;
      bx_r <= bx;
      by_r <= by;

      mul_a <= ax_r*ay_r;
      mul_b <= bx_r*by_r;

      sum <= mul_a + mul_b;

      resulta <= sum;
    end

endmodule
