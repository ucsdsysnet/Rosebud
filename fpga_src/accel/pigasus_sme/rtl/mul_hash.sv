// Latency = 2 + DSP latency
module mul_hash(clk, a, ab0, ab1, ab2, ab3);

input clk;
input[7:0] a;
// 4 terms of multiply
output reg [23:0] ab0;
output reg [23:0] ab1;
output reg [23:0] ab2;
output reg [23:0] ab3;

wire [63:0] b = 64'h0b4e0ef37bc32127;

reg [7:0] a_reg0;

wire [17:0] b0  = {2'b00, b[15: 0]};
wire [17:0] b1  = {2'b00, b[31:16]};
wire [17:0] b2  = {2'b00, b[47:32]};
wire [17:0] b3  = {2'b00, b[63:48]};
wire [17:0] a_f = {10'd0, a_reg0};

wire [36:0] ab0_n;
wire [36:0] ab1_n;
wire [36:0] ab2_n;
wire [36:0] ab3_n;

// Register inputs and outputs
always @ (posedge clk) begin
    a_reg0      <= a;

    ab0 <= ab0_n[23:0];
    ab1 <= ab1_n[23:0];
    ab2 <= ab2_n[23:0];
    ab3 <= ab3_n[23:0];
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

endmodule
