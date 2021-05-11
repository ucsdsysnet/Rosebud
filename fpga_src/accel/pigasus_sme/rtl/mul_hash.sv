// Latency = 3 + DSP latency
module mul_hash(clk, a, ab0, ab1, ab2, ab3,
           ab0_1sc, ab1_1sc, ab2_1sc, ab3_1sc,
           msk_ab0, msk_ab1, msk_ab2, msk_ab3,
           msk_ab0_1sc, msk_ab1_1sc, msk_ab2_1sc, msk_ab3_1sc);
input clk;
input[15:0] a;
// 4 terms of multiply
output reg  [31:0] ab0;
output reg  [31:0] ab1;
output reg  [31:0] ab2;
output reg  [31:0] ab3;
// 4 terms of multiply with 1's compliment of a
output reg  [31:0] ab0_1sc;
output reg  [31:0] ab1_1sc;
output reg  [31:0] ab2_1sc;
output reg  [31:0] ab3_1sc;
// 4 terms of multiply when first bytes is masked (8 leading zeros are truncated)
output reg  [23:0] msk_ab0;
output reg  [23:0] msk_ab1;
output reg  [23:0] msk_ab2;
output reg  [23:0] msk_ab3;
// 4 terms of multiply when first bytes of 1's complicement of a is masked
output reg  [23:0] msk_ab0_1sc;
output reg  [23:0] msk_ab1_1sc;
output reg  [23:0] msk_ab2_1sc;
output reg  [23:0] msk_ab3_1sc;

wire [63:0] b = 64'h0b4e0ef37bc32127;

wire [17:0] b0 = {2'b00, b[15: 0]};
wire [17:0] b1 = {2'b00, b[31:16]};
wire [17:0] b2 = {2'b00, b[47:32]};
wire [17:0] b3 = {2'b00, b[63:48]};

reg [15:0] a_reg0;
reg [15:0] a_reg1;
reg [15:0] a_1sc_reg1;

wire [17:0] a_f     = { 2'd0, a_reg1};
wire [17:0] a_1sc_f = { 2'd0, a_1sc_reg1};
wire [17:0] a_h     = {10'd0, a_reg1[15:8]};
wire [17:0] a_1sc_h = {10'd0, a_1sc_reg1[15:8]};
  
wire [36:0] ab0_n;
wire [36:0] ab1_n;
wire [36:0] ab2_n;
wire [36:0] ab3_n;
wire [36:0] msk_ab0_n;
wire [36:0] msk_ab1_n;
wire [36:0] msk_ab2_n;
wire [36:0] msk_ab3_n;
wire [36:0] ab0_1sc_n;
wire [36:0] ab1_1sc_n;
wire [36:0] ab2_1sc_n;
wire [36:0] ab3_1sc_n;
wire [36:0] msk_ab0_1sc_n;
wire [36:0] msk_ab1_1sc_n;
wire [36:0] msk_ab2_1sc_n;
wire [36:0] msk_ab3_1sc_n;

always @ (posedge clk) begin
    // register the input and make 1s compliment
    a_reg0      <= a;
    a_reg1      <= a_reg0;
    a_1sc_reg1  <= ~a_reg0;

    // Register the outputs
    ab0         <= ab0_n[31:0];
    ab1         <= ab1_n[31:0];
    ab2         <= ab2_n[31:0];
    ab3         <= ab3_n[31:0];
    ab0_1sc     <= ab0_1sc_n[31:0];
    ab1_1sc     <= ab1_1sc_n[31:0];
    ab2_1sc     <= ab2_1sc_n[31:0];
    ab3_1sc     <= ab3_1sc_n[31:0];
    msk_ab0     <= msk_ab0_n[23:0];
    msk_ab1     <= msk_ab1_n[23:0];
    msk_ab2     <= msk_ab2_n[23:0];
    msk_ab3     <= msk_ab3_n[23:0];
    msk_ab0_1sc <= msk_ab0_1sc_n[23:0];
    msk_ab1_1sc <= msk_ab1_1sc_n[23:0];
    msk_ab2_1sc <= msk_ab2_1sc_n[23:0];
    msk_ab3_1sc <= msk_ab3_1sc_n[23:0];
end

	singledsp ab0_product (
		.ay      (a_f),
		.ax      (b0),
		.resulta (ab0_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);

	singledsp ab1_product (
		.ay      (a_f),
		.ax      (b1),
		.resulta (ab1_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);
	
  singledsp ab2_product (
		.ay      (a_f),
		.ax      (b2),
		.resulta (ab2_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);

  singledsp ab3_product (
		.ay      (a_f),
		.ax      (b3),
		.resulta (ab3_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);

	singledsp ab0_1sc_product (
		.ay      (a_1sc_f),
		.ax      (b0),
		.resulta (ab0_1sc_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);

	singledsp ab1_1sc_product (
		.ay      (a_1sc_f),
		.ax      (b1),
		.resulta (ab1_1sc_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);
	
  singledsp ab2_1sc_product (
		.ay      (a_1sc_f),
		.ax      (b2),
		.resulta (ab2_1sc_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);

  singledsp ab3_1sc_product (
		.ay      (a_1sc_f),
		.ax      (b3),
		.resulta (ab3_1sc_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);

	singledsp msk_ab0_product (
		.ay      (a_h),
		.ax      (b0),
		.resulta (msk_ab0_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);
	
  singledsp msk_ab1_product (
		.ay      (a_h),
		.ax      (b1),
		.resulta (msk_ab1_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);

	singledsp msk_ab2_product (
		.ay      (a_h),
		.ax      (b2),
		.resulta (msk_ab2_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);
	
  singledsp msk_ab3_product (
		.ay      (a_h),
		.ax      (b3),
		.resulta (msk_ab3_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);
	
  singledsp msk_ab0_1sc_product (
		.ay      (a_1sc_h),
		.ax      (b0),
		.resulta (msk_ab0_1sc_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);

  singledsp msk_ab1_1sc_product (
		.ay      (a_1sc_h),
		.ax      (b1),
		.resulta (msk_ab1_1sc_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);
  
  singledsp msk_ab2_1sc_product (
		.ay      (a_1sc_h),
		.ax      (b2),
		.resulta (msk_ab2_1sc_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);

  singledsp msk_ab3_1sc_product (
		.ay      (a_1sc_h),
		.ax      (b3),
		.resulta (msk_ab3_1sc_n),
		.clk0    (clk),
		.clk1    (clk),
		.clk2    (clk),
		.ena     (3'd1)
	);

endmodule
