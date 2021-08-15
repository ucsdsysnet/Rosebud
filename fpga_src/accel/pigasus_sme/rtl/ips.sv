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

module uram_2rw_reg #(
	parameter DWIDTH    = 8,
	parameter AWIDTH    = 8,
  parameter LWIDTH    = DWIDTH,
	parameter MEM_SIZE  = (2**AWIDTH)
) (

  input  wire              clock,

  input  wire              en_a,
  input  wire [AWIDTH-1:0] address_a,
  input  wire [LWIDTH-1:0] wr_data_a,
  input  wire              wr_en_a,
  output reg  [DWIDTH-1:0] q_a,

  input  wire              en_b,
  input  wire [AWIDTH-1:0] address_b,
  input  wire [LWIDTH-1:0] wr_data_b,
  input  wire              wr_en_b,
  output reg  [DWIDTH-1:0] q_b
);

  localparam DEPTH = (LWIDTH==DWIDTH) ? AWIDTH : 
                   AWIDTH-$clog2(LWIDTH/DWIDTH);

  localparam SEL_BITS = AWIDTH-DEPTH;

  (* ram_style = "ultra" *)
  reg [LWIDTH-1:0] mem [0:(1<<DEPTH)-1];

  reg              en_a_r;
  reg              wr_en_a_r;
  reg [AWIDTH-1:0] address_a_r;
  reg [LWIDTH-1:0] wr_data_a_r;
  reg [DWIDTH-1:0] q_a_r;

  reg              en_b_r;
  reg              wr_en_b_r;
  reg [AWIDTH-1:0] address_b_r;
  reg [LWIDTH-1:0] wr_data_b_r;
  reg [DWIDTH-1:0] q_b_r;

  // Input register
  always @ (posedge clock) begin
    en_a_r      <= en_a;
    wr_en_a_r   <= wr_en_a;
    address_a_r <= address_a;
    wr_data_a_r <= wr_data_a;

    en_b_r      <= en_b;
    wr_en_b_r   <= wr_en_b;
    address_b_r <= address_b;
    wr_data_b_r <= wr_data_b;
  end

  always @ (posedge clock)
    if (en_a_r)
      if (wr_en_a_r)
        mem[address_a_r[AWIDTH-1:SEL_BITS]] <= wr_data_a_r;

  always @ (posedge clock)
    if (en_a_r)
      if (!wr_en_a_r)
        q_a_r <= mem[address_a_r[AWIDTH-1:SEL_BITS]];

  always @ (posedge clock)
    if (en_b_r)
      if (wr_en_b_r)
        mem[address_b_r[AWIDTH-1:SEL_BITS]] <= wr_data_b_r;

  always @ (posedge clock)
    if (en_b_r)
      if (!wr_en_b_r)
        q_b_r <= mem[address_b_r[AWIDTH-1:SEL_BITS]];

  generate
    if (DWIDTH==LWIDTH) begin
      assign q_a = q_a_r;
      assign q_b = q_b_r;
    end else begin
      reg [SEL_BITS-1:0] sel_a;
      reg [SEL_BITS-1:0] sel_b;

      always @ (posedge clock) begin
        sel_a <= address_a_r[SEL_BITS-1:0];
        sel_b <= address_b_r[SEL_BITS-1:0];
      end

      assign q_a = q_a_r[sel_a*DWIDTH +: DWIDTH];
      assign q_b = q_b_r[sel_b*DWIDTH +: DWIDTH];
    end
  endgenerate

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
