`include "struct_s.sv"
module hashtable_top(clk,
	dout_0_0,dout_valid_0_0,
	dout_0_1,dout_valid_0_1,
	dout_0_2,dout_valid_0_2,
	dout_0_3,dout_valid_0_3,
	dout_0_4,dout_valid_0_4,
	dout_0_5,dout_valid_0_5,
	dout_0_6,dout_valid_0_6,
	dout_0_7,dout_valid_0_7,
	dout_1_0,dout_valid_1_0,
	dout_1_1,dout_valid_1_1,
	dout_1_2,dout_valid_1_2,
	dout_1_3,dout_valid_1_3,
	dout_1_4,dout_valid_1_4,
	dout_1_5,dout_valid_1_5,
	dout_1_6,dout_valid_1_6,
	dout_1_7,dout_valid_1_7,
	dout_2_0,dout_valid_2_0,
	dout_2_1,dout_valid_2_1,
	dout_2_2,dout_valid_2_2,
	dout_2_3,dout_valid_2_3,
	dout_2_4,dout_valid_2_4,
	dout_2_5,dout_valid_2_5,
	dout_2_6,dout_valid_2_6,
	dout_2_7,dout_valid_2_7,
	dout_3_0,dout_valid_3_0,
	dout_3_1,dout_valid_3_1,
	dout_3_2,dout_valid_3_2,
	dout_3_3,dout_valid_3_3,
	dout_3_4,dout_valid_3_4,
	dout_3_5,dout_valid_3_5,
	dout_3_6,dout_valid_3_6,
	dout_3_7,dout_valid_3_7,
	dout_4_0,dout_valid_4_0,
	dout_4_1,dout_valid_4_1,
	dout_4_2,dout_valid_4_2,
	dout_4_3,dout_valid_4_3,
	dout_4_4,dout_valid_4_4,
	dout_4_5,dout_valid_4_5,
	dout_4_6,dout_valid_4_6,
	dout_4_7,dout_valid_4_7,
	dout_5_0,dout_valid_5_0,
	dout_5_1,dout_valid_5_1,
	dout_5_2,dout_valid_5_2,
	dout_5_3,dout_valid_5_3,
	dout_5_4,dout_valid_5_4,
	dout_5_5,dout_valid_5_5,
	dout_5_6,dout_valid_5_6,
	dout_5_7,dout_valid_5_7,
	dout_6_0,dout_valid_6_0,
	dout_6_1,dout_valid_6_1,
	dout_6_2,dout_valid_6_2,
	dout_6_3,dout_valid_6_3,
	dout_6_4,dout_valid_6_4,
	dout_6_5,dout_valid_6_5,
	dout_6_6,dout_valid_6_6,
	dout_6_7,dout_valid_6_7,
	dout_7_0,dout_valid_7_0,
	dout_7_1,dout_valid_7_1,
	dout_7_2,dout_valid_7_2,
	dout_7_3,dout_valid_7_3,
	dout_7_4,dout_valid_7_4,
	dout_7_5,dout_valid_7_5,
	dout_7_6,dout_valid_7_6,
	dout_7_7,dout_valid_7_7,
    din,din_valid
);

input clk;
input [255:0] din;
input din_valid;
output wire [RID_WIDTH-1:0] dout_0_0;
output wire dout_valid_0_0;
output wire [RID_WIDTH-1:0] dout_0_1;
output wire dout_valid_0_1;
output wire [RID_WIDTH-1:0] dout_0_2;
output wire dout_valid_0_2;
output wire [RID_WIDTH-1:0] dout_0_3;
output wire dout_valid_0_3;
output wire [RID_WIDTH-1:0] dout_0_4;
output wire dout_valid_0_4;
output wire [RID_WIDTH-1:0] dout_0_5;
output wire dout_valid_0_5;
output wire [RID_WIDTH-1:0] dout_0_6;
output wire dout_valid_0_6;
output wire [RID_WIDTH-1:0] dout_0_7;
output wire dout_valid_0_7;
output wire [RID_WIDTH-1:0] dout_1_0;
output wire dout_valid_1_0;
output wire [RID_WIDTH-1:0] dout_1_1;
output wire dout_valid_1_1;
output wire [RID_WIDTH-1:0] dout_1_2;
output wire dout_valid_1_2;
output wire [RID_WIDTH-1:0] dout_1_3;
output wire dout_valid_1_3;
output wire [RID_WIDTH-1:0] dout_1_4;
output wire dout_valid_1_4;
output wire [RID_WIDTH-1:0] dout_1_5;
output wire dout_valid_1_5;
output wire [RID_WIDTH-1:0] dout_1_6;
output wire dout_valid_1_6;
output wire [RID_WIDTH-1:0] dout_1_7;
output wire dout_valid_1_7;
output wire [RID_WIDTH-1:0] dout_2_0;
output wire dout_valid_2_0;
output wire [RID_WIDTH-1:0] dout_2_1;
output wire dout_valid_2_1;
output wire [RID_WIDTH-1:0] dout_2_2;
output wire dout_valid_2_2;
output wire [RID_WIDTH-1:0] dout_2_3;
output wire dout_valid_2_3;
output wire [RID_WIDTH-1:0] dout_2_4;
output wire dout_valid_2_4;
output wire [RID_WIDTH-1:0] dout_2_5;
output wire dout_valid_2_5;
output wire [RID_WIDTH-1:0] dout_2_6;
output wire dout_valid_2_6;
output wire [RID_WIDTH-1:0] dout_2_7;
output wire dout_valid_2_7;
output wire [RID_WIDTH-1:0] dout_3_0;
output wire dout_valid_3_0;
output wire [RID_WIDTH-1:0] dout_3_1;
output wire dout_valid_3_1;
output wire [RID_WIDTH-1:0] dout_3_2;
output wire dout_valid_3_2;
output wire [RID_WIDTH-1:0] dout_3_3;
output wire dout_valid_3_3;
output wire [RID_WIDTH-1:0] dout_3_4;
output wire dout_valid_3_4;
output wire [RID_WIDTH-1:0] dout_3_5;
output wire dout_valid_3_5;
output wire [RID_WIDTH-1:0] dout_3_6;
output wire dout_valid_3_6;
output wire [RID_WIDTH-1:0] dout_3_7;
output wire dout_valid_3_7;
output wire [RID_WIDTH-1:0] dout_4_0;
output wire dout_valid_4_0;
output wire [RID_WIDTH-1:0] dout_4_1;
output wire dout_valid_4_1;
output wire [RID_WIDTH-1:0] dout_4_2;
output wire dout_valid_4_2;
output wire [RID_WIDTH-1:0] dout_4_3;
output wire dout_valid_4_3;
output wire [RID_WIDTH-1:0] dout_4_4;
output wire dout_valid_4_4;
output wire [RID_WIDTH-1:0] dout_4_5;
output wire dout_valid_4_5;
output wire [RID_WIDTH-1:0] dout_4_6;
output wire dout_valid_4_6;
output wire [RID_WIDTH-1:0] dout_4_7;
output wire dout_valid_4_7;
output wire [RID_WIDTH-1:0] dout_5_0;
output wire dout_valid_5_0;
output wire [RID_WIDTH-1:0] dout_5_1;
output wire dout_valid_5_1;
output wire [RID_WIDTH-1:0] dout_5_2;
output wire dout_valid_5_2;
output wire [RID_WIDTH-1:0] dout_5_3;
output wire dout_valid_5_3;
output wire [RID_WIDTH-1:0] dout_5_4;
output wire dout_valid_5_4;
output wire [RID_WIDTH-1:0] dout_5_5;
output wire dout_valid_5_5;
output wire [RID_WIDTH-1:0] dout_5_6;
output wire dout_valid_5_6;
output wire [RID_WIDTH-1:0] dout_5_7;
output wire dout_valid_5_7;
output wire [RID_WIDTH-1:0] dout_6_0;
output wire dout_valid_6_0;
output wire [RID_WIDTH-1:0] dout_6_1;
output wire dout_valid_6_1;
output wire [RID_WIDTH-1:0] dout_6_2;
output wire dout_valid_6_2;
output wire [RID_WIDTH-1:0] dout_6_3;
output wire dout_valid_6_3;
output wire [RID_WIDTH-1:0] dout_6_4;
output wire dout_valid_6_4;
output wire [RID_WIDTH-1:0] dout_6_5;
output wire dout_valid_6_5;
output wire [RID_WIDTH-1:0] dout_6_6;
output wire dout_valid_6_6;
output wire [RID_WIDTH-1:0] dout_6_7;
output wire dout_valid_6_7;
output wire [RID_WIDTH-1:0] dout_7_0;
output wire dout_valid_7_0;
output wire [RID_WIDTH-1:0] dout_7_1;
output wire dout_valid_7_1;
output wire [RID_WIDTH-1:0] dout_7_2;
output wire dout_valid_7_2;
output wire [RID_WIDTH-1:0] dout_7_3;
output wire dout_valid_7_3;
output wire [RID_WIDTH-1:0] dout_7_4;
output wire dout_valid_7_4;
output wire [RID_WIDTH-1:0] dout_7_5;
output wire dout_valid_7_5;
output wire [RID_WIDTH-1:0] dout_7_6;
output wire dout_valid_7_6;
output wire [RID_WIDTH-1:0] dout_7_7;
output wire dout_valid_7_7;

wire [63:0] din_0_0;
wire din_valid_0_0;
wire [63:0] din_0_1;
wire din_valid_0_1;
wire [63:0] din_0_2;
wire din_valid_0_2;
wire [63:0] din_0_3;
wire din_valid_0_3;
wire [63:0] din_0_4;
wire din_valid_0_4;
wire [63:0] din_0_5;
wire din_valid_0_5;
wire [63:0] din_0_6;
wire din_valid_0_6;
wire [63:0] din_0_7;
wire din_valid_0_7;
wire [63:0] din_1_0;
wire din_valid_1_0;
wire [63:0] din_1_1;
wire din_valid_1_1;
wire [63:0] din_1_2;
wire din_valid_1_2;
wire [63:0] din_1_3;
wire din_valid_1_3;
wire [63:0] din_1_4;
wire din_valid_1_4;
wire [63:0] din_1_5;
wire din_valid_1_5;
wire [63:0] din_1_6;
wire din_valid_1_6;
wire [63:0] din_1_7;
wire din_valid_1_7;
wire [63:0] din_2_0;
wire din_valid_2_0;
wire [63:0] din_2_1;
wire din_valid_2_1;
wire [63:0] din_2_2;
wire din_valid_2_2;
wire [63:0] din_2_3;
wire din_valid_2_3;
wire [63:0] din_2_4;
wire din_valid_2_4;
wire [63:0] din_2_5;
wire din_valid_2_5;
wire [63:0] din_2_6;
wire din_valid_2_6;
wire [63:0] din_2_7;
wire din_valid_2_7;
wire [63:0] din_3_0;
wire din_valid_3_0;
wire [63:0] din_3_1;
wire din_valid_3_1;
wire [63:0] din_3_2;
wire din_valid_3_2;
wire [63:0] din_3_3;
wire din_valid_3_3;
wire [63:0] din_3_4;
wire din_valid_3_4;
wire [63:0] din_3_5;
wire din_valid_3_5;
wire [63:0] din_3_6;
wire din_valid_3_6;
wire [63:0] din_3_7;
wire din_valid_3_7;
wire [63:0] din_4_0;
wire din_valid_4_0;
wire [63:0] din_4_1;
wire din_valid_4_1;
wire [63:0] din_4_2;
wire din_valid_4_2;
wire [63:0] din_4_3;
wire din_valid_4_3;
wire [63:0] din_4_4;
wire din_valid_4_4;
wire [63:0] din_4_5;
wire din_valid_4_5;
wire [63:0] din_4_6;
wire din_valid_4_6;
wire [63:0] din_4_7;
wire din_valid_4_7;
wire [63:0] din_5_0;
wire din_valid_5_0;
wire [63:0] din_5_1;
wire din_valid_5_1;
wire [63:0] din_5_2;
wire din_valid_5_2;
wire [63:0] din_5_3;
wire din_valid_5_3;
wire [63:0] din_5_4;
wire din_valid_5_4;
wire [63:0] din_5_5;
wire din_valid_5_5;
wire [63:0] din_5_6;
wire din_valid_5_6;
wire [63:0] din_5_7;
wire din_valid_5_7;
wire [63:0] din_6_0;
wire din_valid_6_0;
wire [63:0] din_6_1;
wire din_valid_6_1;
wire [63:0] din_6_2;
wire din_valid_6_2;
wire [63:0] din_6_3;
wire din_valid_6_3;
wire [63:0] din_6_4;
wire din_valid_6_4;
wire [63:0] din_6_5;
wire din_valid_6_5;
wire [63:0] din_6_6;
wire din_valid_6_6;
wire [63:0] din_6_7;
wire din_valid_6_7;
wire [63:0] din_7_0;
wire din_valid_7_0;
wire [63:0] din_7_1;
wire din_valid_7_1;
wire [63:0] din_7_2;
wire din_valid_7_2;
wire [63:0] din_7_3;
wire din_valid_7_3;
wire [63:0] din_7_4;
wire din_valid_7_4;
wire [63:0] din_7_5;
wire din_valid_7_5;
wire [63:0] din_7_6;
wire din_valid_7_6;
wire [63:0] din_7_7;
wire din_valid_7_7;

reg [63:0] din_reg;
reg din_valid_reg;

assign din_0_0 = {din[7:0],din_reg[63:8]};
assign din_0_1 = {din[15:0],din_reg[63:16]};
assign din_0_2 = {din[23:0],din_reg[63:24]};
assign din_0_3 = {din[31:0],din_reg[63:32]};
assign din_0_4 = {din[39:0],din_reg[63:40]};
assign din_0_5 = {din[47:0],din_reg[63:48]};
assign din_0_6 = {din[55:0],din_reg[63:56]};

assign din_0_7 = din[63:0];
assign din_1_0 = {din[7:0],din_reg[63:8]};
assign din_1_1 = {din[15:0],din_reg[63:16]};
assign din_1_2 = {din[23:0],din_reg[63:24]};
assign din_1_3 = {din[31:0],din_reg[63:32]};
assign din_1_4 = {din[39:0],din_reg[63:40]};
assign din_1_5 = {din[47:0],din_reg[63:48]};
assign din_1_6 = {din[55:0],din_reg[63:56]};

assign din_1_7 = din[63:0];
assign din_2_0 = {din[7:0],din_reg[63:8]};
assign din_2_1 = {din[15:0],din_reg[63:16]};
assign din_2_2 = {din[23:0],din_reg[63:24]};
assign din_2_3 = {din[31:0],din_reg[63:32]};
assign din_2_4 = {din[39:0],din_reg[63:40]};
assign din_2_5 = {din[47:0],din_reg[63:48]};
assign din_2_6 = {din[55:0],din_reg[63:56]};

assign din_2_7 = din[63:0];
assign din_3_0 = {din[7:0],din_reg[63:8]};
assign din_3_1 = {din[15:0],din_reg[63:16]};
assign din_3_2 = {din[23:0],din_reg[63:24]};
assign din_3_3 = {din[31:0],din_reg[63:32]};
assign din_3_4 = {din[39:0],din_reg[63:40]};
assign din_3_5 = {din[47:0],din_reg[63:48]};
assign din_3_6 = {din[55:0],din_reg[63:56]};

assign din_3_7 = din[63:0];
assign din_4_0 = {din[7:0],din_reg[63:8]};
assign din_4_1 = {din[15:0],din_reg[63:16]};
assign din_4_2 = {din[23:0],din_reg[63:24]};
assign din_4_3 = {din[31:0],din_reg[63:32]};
assign din_4_4 = {din[39:0],din_reg[63:40]};
assign din_4_5 = {din[47:0],din_reg[63:48]};
assign din_4_6 = {din[55:0],din_reg[63:56]};

assign din_4_7 = din[63:0];
assign din_5_0 = {din[7:0],din_reg[63:8]};
assign din_5_1 = {din[15:0],din_reg[63:16]};
assign din_5_2 = {din[23:0],din_reg[63:24]};
assign din_5_3 = {din[31:0],din_reg[63:32]};
assign din_5_4 = {din[39:0],din_reg[63:40]};
assign din_5_5 = {din[47:0],din_reg[63:48]};
assign din_5_6 = {din[55:0],din_reg[63:56]};

assign din_5_7 = din[63:0];
assign din_6_0 = {din[7:0],din_reg[63:8]};
assign din_6_1 = {din[15:0],din_reg[63:16]};
assign din_6_2 = {din[23:0],din_reg[63:24]};
assign din_6_3 = {din[31:0],din_reg[63:32]};
assign din_6_4 = {din[39:0],din_reg[63:40]};
assign din_6_5 = {din[47:0],din_reg[63:48]};
assign din_6_6 = {din[55:0],din_reg[63:56]};

assign din_6_7 = din[63:0];
assign din_7_0 = {din[7:0],din_reg[63:8]};
assign din_7_1 = {din[15:0],din_reg[63:16]};
assign din_7_2 = {din[23:0],din_reg[63:24]};
assign din_7_3 = {din[31:0],din_reg[63:32]};
assign din_7_4 = {din[39:0],din_reg[63:40]};
assign din_7_5 = {din[47:0],din_reg[63:48]};
assign din_7_6 = {din[55:0],din_reg[63:56]};

assign din_7_7 = din[63:0];

//Valid signals
assign din_valid_0_0 = din_valid & din_valid_reg;
assign din_valid_1_0 = din_valid & din_valid_reg;
assign din_valid_0_1 = din_valid & din_valid_reg;
assign din_valid_1_1 = din_valid & din_valid_reg;
assign din_valid_0_2 = din_valid & din_valid_reg;
assign din_valid_1_2 = din_valid & din_valid_reg;
assign din_valid_0_3 = din_valid & din_valid_reg;
assign din_valid_1_3 = din_valid & din_valid_reg;
assign din_valid_0_4 = din_valid & din_valid_reg;
assign din_valid_1_4 = din_valid & din_valid_reg;
assign din_valid_0_5 = din_valid & din_valid_reg;
assign din_valid_1_5 = din_valid & din_valid_reg;
assign din_valid_0_6 = din_valid & din_valid_reg;
assign din_valid_1_6 = din_valid & din_valid_reg;
assign din_valid_0_7 = din_valid;
assign din_valid_1_7 = din_valid;

assign din_valid_2_0 = din_valid & din_valid_reg;
assign din_valid_2_1 = din_valid & din_valid_reg;
assign din_valid_2_2 = din_valid & din_valid_reg;
assign din_valid_2_3 = din_valid & din_valid_reg;
assign din_valid_2_4 = din_valid & din_valid_reg;
assign din_valid_2_5 = din_valid & din_valid_reg;
assign din_valid_2_6 = din_valid;
assign din_valid_2_7 = din_valid;

assign din_valid_3_0 = din_valid & din_valid_reg;
assign din_valid_3_1 = din_valid & din_valid_reg;
assign din_valid_3_2 = din_valid & din_valid_reg;
assign din_valid_3_3 = din_valid & din_valid_reg;
assign din_valid_3_4 = din_valid & din_valid_reg;
assign din_valid_3_5 = din_valid;
assign din_valid_3_6 = din_valid;
assign din_valid_3_7 = din_valid;

assign din_valid_4_0 = din_valid & din_valid_reg;
assign din_valid_4_1 = din_valid & din_valid_reg;
assign din_valid_4_2 = din_valid & din_valid_reg;
assign din_valid_4_3 = din_valid & din_valid_reg;
assign din_valid_4_4 = din_valid;
assign din_valid_4_5 = din_valid;
assign din_valid_4_6 = din_valid;
assign din_valid_4_7 = din_valid;

assign din_valid_5_0 = din_valid & din_valid_reg;
assign din_valid_5_1 = din_valid & din_valid_reg;
assign din_valid_5_2 = din_valid & din_valid_reg;
assign din_valid_5_3 = din_valid;
assign din_valid_5_4 = din_valid;
assign din_valid_5_5 = din_valid;
assign din_valid_5_6 = din_valid;
assign din_valid_5_7 = din_valid;

assign din_valid_6_0 = din_valid & din_valid_reg;
assign din_valid_6_1 = din_valid & din_valid_reg;
assign din_valid_6_2 = din_valid;
assign din_valid_6_3 = din_valid;
assign din_valid_6_4 = din_valid;
assign din_valid_6_5 = din_valid;
assign din_valid_6_6 = din_valid;
assign din_valid_6_7 = din_valid;

assign din_valid_7_0 = din_valid & din_valid_reg;
assign din_valid_7_1 = din_valid;
assign din_valid_7_2 = din_valid;
assign din_valid_7_3 = din_valid;
assign din_valid_7_4 = din_valid;
assign din_valid_7_5 = din_valid;
assign din_valid_7_6 = din_valid;
assign din_valid_7_7 = din_valid;


always @ (posedge clk) begin
    //din_reg <= din[127:64];
    din_reg <= din[255:192];
    din_valid_reg <= din_valid;
end


hashtable #(
	.ANDMSK(64'hffffffffffffffff),
	.NBITS(15),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(4096),
	.INIT_FILE("./memory_init/bitmap0.mif")
)
hashtable_0_0 (
	.clk (clk),
	.din0 (din_0_0),
	.din0_valid (din_valid_0_0),
	.din1 (din_0_1),
	.din1_valid (din_valid_0_1),
	.dout0 (dout_0_0),
	.dout0_valid (dout_valid_0_0),
	.dout1 (dout_0_1),
	.dout1_valid (dout_valid_0_1)
);

hashtable #(
	.ANDMSK(64'hffffffffffffffff),
	.NBITS(15),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(4096),
	.INIT_FILE("./memory_init/bitmap0.mif")
)
hashtable_0_1 (
	.clk (clk),
	.din0 (din_0_2),
	.din0_valid (din_valid_0_2),
	.din1 (din_0_3),
	.din1_valid (din_valid_0_3),
	.dout0 (dout_0_2),
	.dout0_valid (dout_valid_0_2),
	.dout1 (dout_0_3),
	.dout1_valid (dout_valid_0_3)
);

hashtable #(
	.ANDMSK(64'hffffffffffffffff),
	.NBITS(15),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(4096),
	.INIT_FILE("./memory_init/bitmap0.mif")
)
hashtable_0_2 (
	.clk (clk),
	.din0 (din_0_4),
	.din0_valid (din_valid_0_4),
	.din1 (din_0_5),
	.din1_valid (din_valid_0_5),
	.dout0 (dout_0_4),
	.dout0_valid (dout_valid_0_4),
	.dout1 (dout_0_5),
	.dout1_valid (dout_valid_0_5)
);

hashtable #(
	.ANDMSK(64'hffffffffffffffff),
	.NBITS(15),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(4096),
	.INIT_FILE("./memory_init/bitmap0.mif")
)
hashtable_0_3 (
	.clk (clk),
	.din0 (din_0_6),
	.din0_valid (din_valid_0_6),
	.din1 (din_0_7),
	.din1_valid (din_valid_0_7),
	.dout0 (dout_0_6),
	.dout0_valid (dout_valid_0_6),
	.dout1 (dout_0_7),
	.dout1_valid (dout_valid_0_7)
);

hashtable #(
	.ANDMSK(64'hffffffffffffffff),
	.NBITS(15),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(4096),
	.INIT_FILE("./memory_init/bitmap1.mif")
)
hashtable_1_0 (
	.clk (clk),
	.din0 (din_1_0),
	.din0_valid (din_valid_1_0),
	.din1 (din_1_1),
	.din1_valid (din_valid_1_1),
	.dout0 (dout_1_0),
	.dout0_valid (dout_valid_1_0),
	.dout1 (dout_1_1),
	.dout1_valid (dout_valid_1_1)
);

hashtable #(
	.ANDMSK(64'hffffffffffffffff),
	.NBITS(15),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(4096),
	.INIT_FILE("./memory_init/bitmap1.mif")
)
hashtable_1_1 (
	.clk (clk),
	.din0 (din_1_2),
	.din0_valid (din_valid_1_2),
	.din1 (din_1_3),
	.din1_valid (din_valid_1_3),
	.dout0 (dout_1_2),
	.dout0_valid (dout_valid_1_2),
	.dout1 (dout_1_3),
	.dout1_valid (dout_valid_1_3)
);

hashtable #(
	.ANDMSK(64'hffffffffffffffff),
	.NBITS(15),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(4096),
	.INIT_FILE("./memory_init/bitmap1.mif")
)
hashtable_1_2 (
	.clk (clk),
	.din0 (din_1_4),
	.din0_valid (din_valid_1_4),
	.din1 (din_1_5),
	.din1_valid (din_valid_1_5),
	.dout0 (dout_1_4),
	.dout0_valid (dout_valid_1_4),
	.dout1 (dout_1_5),
	.dout1_valid (dout_valid_1_5)
);

hashtable #(
	.ANDMSK(64'hffffffffffffffff),
	.NBITS(15),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(4096),
	.INIT_FILE("./memory_init/bitmap1.mif")
)
hashtable_1_3 (
	.clk (clk),
	.din0 (din_1_6),
	.din0_valid (din_valid_1_6),
	.din1 (din_1_7),
	.din1_valid (din_valid_1_7),
	.dout0 (dout_1_6),
	.dout0_valid (dout_valid_1_6),
	.dout1 (dout_1_7),
	.dout1_valid (dout_valid_1_7)
);

hashtable #(
	.ANDMSK(64'hffffffffffffff00),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap2.mif")
)
hashtable_2_0 (
	.clk (clk),
	.din0 (din_2_0),
	.din0_valid (din_valid_2_0),
	.din1 (din_2_1),
	.din1_valid (din_valid_2_1),
	.dout0 (dout_2_0),
	.dout0_valid (dout_valid_2_0),
	.dout1 (dout_2_1),
	.dout1_valid (dout_valid_2_1)
);

hashtable #(
	.ANDMSK(64'hffffffffffffff00),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap2.mif")
)
hashtable_2_1 (
	.clk (clk),
	.din0 (din_2_2),
	.din0_valid (din_valid_2_2),
	.din1 (din_2_3),
	.din1_valid (din_valid_2_3),
	.dout0 (dout_2_2),
	.dout0_valid (dout_valid_2_2),
	.dout1 (dout_2_3),
	.dout1_valid (dout_valid_2_3)
);

hashtable #(
	.ANDMSK(64'hffffffffffffff00),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap2.mif")
)
hashtable_2_2 (
	.clk (clk),
	.din0 (din_2_4),
	.din0_valid (din_valid_2_4),
	.din1 (din_2_5),
	.din1_valid (din_valid_2_5),
	.dout0 (dout_2_4),
	.dout0_valid (dout_valid_2_4),
	.dout1 (dout_2_5),
	.dout1_valid (dout_valid_2_5)
);

hashtable #(
	.ANDMSK(64'hffffffffffffff00),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap2.mif")
)
hashtable_2_3 (
	.clk (clk),
	.din0 (din_2_6),
	.din0_valid (din_valid_2_6),
	.din1 (din_2_7),
	.din1_valid (din_valid_2_7),
	.dout0 (dout_2_6),
	.dout0_valid (dout_valid_2_6),
	.dout1 (dout_2_7),
	.dout1_valid (dout_valid_2_7)
);

hashtable #(
	.ANDMSK(64'hffffffffffff0000),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap3.mif")
)
hashtable_3_0 (
	.clk (clk),
	.din0 (din_3_0),
	.din0_valid (din_valid_3_0),
	.din1 (din_3_1),
	.din1_valid (din_valid_3_1),
	.dout0 (dout_3_0),
	.dout0_valid (dout_valid_3_0),
	.dout1 (dout_3_1),
	.dout1_valid (dout_valid_3_1)
);

hashtable #(
	.ANDMSK(64'hffffffffffff0000),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap3.mif")
)
hashtable_3_1 (
	.clk (clk),
	.din0 (din_3_2),
	.din0_valid (din_valid_3_2),
	.din1 (din_3_3),
	.din1_valid (din_valid_3_3),
	.dout0 (dout_3_2),
	.dout0_valid (dout_valid_3_2),
	.dout1 (dout_3_3),
	.dout1_valid (dout_valid_3_3)
);

hashtable #(
	.ANDMSK(64'hffffffffffff0000),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap3.mif")
)
hashtable_3_2 (
	.clk (clk),
	.din0 (din_3_4),
	.din0_valid (din_valid_3_4),
	.din1 (din_3_5),
	.din1_valid (din_valid_3_5),
	.dout0 (dout_3_4),
	.dout0_valid (dout_valid_3_4),
	.dout1 (dout_3_5),
	.dout1_valid (dout_valid_3_5)
);

hashtable #(
	.ANDMSK(64'hffffffffffff0000),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap3.mif")
)
hashtable_3_3 (
	.clk (clk),
	.din0 (din_3_6),
	.din0_valid (din_valid_3_6),
	.din1 (din_3_7),
	.din1_valid (din_valid_3_7),
	.dout0 (dout_3_6),
	.dout0_valid (dout_valid_3_6),
	.dout1 (dout_3_7),
	.dout1_valid (dout_valid_3_7)
);

hashtable #(
	.ANDMSK(64'hffffffffff000000),
	.NBITS(11),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(256),
	.INIT_FILE("./memory_init/bitmap4.mif")
)
hashtable_4_0 (
	.clk (clk),
	.din0 (din_4_0),
	.din0_valid (din_valid_4_0),
	.din1 (din_4_1),
	.din1_valid (din_valid_4_1),
	.dout0 (dout_4_0),
	.dout0_valid (dout_valid_4_0),
	.dout1 (dout_4_1),
	.dout1_valid (dout_valid_4_1)
);

hashtable #(
	.ANDMSK(64'hffffffffff000000),
	.NBITS(11),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(256),
	.INIT_FILE("./memory_init/bitmap4.mif")
)
hashtable_4_1 (
	.clk (clk),
	.din0 (din_4_2),
	.din0_valid (din_valid_4_2),
	.din1 (din_4_3),
	.din1_valid (din_valid_4_3),
	.dout0 (dout_4_2),
	.dout0_valid (dout_valid_4_2),
	.dout1 (dout_4_3),
	.dout1_valid (dout_valid_4_3)
);

hashtable #(
	.ANDMSK(64'hffffffffff000000),
	.NBITS(11),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(256),
	.INIT_FILE("./memory_init/bitmap4.mif")
)
hashtable_4_2 (
	.clk (clk),
	.din0 (din_4_4),
	.din0_valid (din_valid_4_4),
	.din1 (din_4_5),
	.din1_valid (din_valid_4_5),
	.dout0 (dout_4_4),
	.dout0_valid (dout_valid_4_4),
	.dout1 (dout_4_5),
	.dout1_valid (dout_valid_4_5)
);

hashtable #(
	.ANDMSK(64'hffffffffff000000),
	.NBITS(11),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(256),
	.INIT_FILE("./memory_init/bitmap4.mif")
)
hashtable_4_3 (
	.clk (clk),
	.din0 (din_4_6),
	.din0_valid (din_valid_4_6),
	.din1 (din_4_7),
	.din1_valid (din_valid_4_7),
	.dout0 (dout_4_6),
	.dout0_valid (dout_valid_4_6),
	.dout1 (dout_4_7),
	.dout1_valid (dout_valid_4_7)
);

hashtable #(
	.ANDMSK(64'hffffffff00000000),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap5.mif")
)
hashtable_5_0 (
	.clk (clk),
	.din0 (din_5_0),
	.din0_valid (din_valid_5_0),
	.din1 (din_5_1),
	.din1_valid (din_valid_5_1),
	.dout0 (dout_5_0),
	.dout0_valid (dout_valid_5_0),
	.dout1 (dout_5_1),
	.dout1_valid (dout_valid_5_1)
);

hashtable #(
	.ANDMSK(64'hffffffff00000000),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap5.mif")
)
hashtable_5_1 (
	.clk (clk),
	.din0 (din_5_2),
	.din0_valid (din_valid_5_2),
	.din1 (din_5_3),
	.din1_valid (din_valid_5_3),
	.dout0 (dout_5_2),
	.dout0_valid (dout_valid_5_2),
	.dout1 (dout_5_3),
	.dout1_valid (dout_valid_5_3)
);

hashtable #(
	.ANDMSK(64'hffffffff00000000),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap5.mif")
)
hashtable_5_2 (
	.clk (clk),
	.din0 (din_5_4),
	.din0_valid (din_valid_5_4),
	.din1 (din_5_5),
	.din1_valid (din_valid_5_5),
	.dout0 (dout_5_4),
	.dout0_valid (dout_valid_5_4),
	.dout1 (dout_5_5),
	.dout1_valid (dout_valid_5_5)
);

hashtable #(
	.ANDMSK(64'hffffffff00000000),
	.NBITS(12),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(512),
	.INIT_FILE("./memory_init/bitmap5.mif")
)
hashtable_5_3 (
	.clk (clk),
	.din0 (din_5_6),
	.din0_valid (din_valid_5_6),
	.din1 (din_5_7),
	.din1_valid (din_valid_5_7),
	.dout0 (dout_5_6),
	.dout0_valid (dout_valid_5_6),
	.dout1 (dout_5_7),
	.dout1_valid (dout_valid_5_7)
);

hashtable #(
	.ANDMSK(64'hffffff0000000000),
	.NBITS(10),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(128),
	.INIT_FILE("./memory_init/bitmap6.mif")
)
hashtable_6_0 (
	.clk (clk),
	.din0 (din_6_0),
	.din0_valid (din_valid_6_0),
	.din1 (din_6_1),
	.din1_valid (din_valid_6_1),
	.dout0 (dout_6_0),
	.dout0_valid (dout_valid_6_0),
	.dout1 (dout_6_1),
	.dout1_valid (dout_valid_6_1)
);

hashtable #(
	.ANDMSK(64'hffffff0000000000),
	.NBITS(10),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(128),
	.INIT_FILE("./memory_init/bitmap6.mif")
)
hashtable_6_1 (
	.clk (clk),
	.din0 (din_6_2),
	.din0_valid (din_valid_6_2),
	.din1 (din_6_3),
	.din1_valid (din_valid_6_3),
	.dout0 (dout_6_2),
	.dout0_valid (dout_valid_6_2),
	.dout1 (dout_6_3),
	.dout1_valid (dout_valid_6_3)
);

hashtable #(
	.ANDMSK(64'hffffff0000000000),
	.NBITS(10),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(128),
	.INIT_FILE("./memory_init/bitmap6.mif")
)
hashtable_6_2 (
	.clk (clk),
	.din0 (din_6_4),
	.din0_valid (din_valid_6_4),
	.din1 (din_6_5),
	.din1_valid (din_valid_6_5),
	.dout0 (dout_6_4),
	.dout0_valid (dout_valid_6_4),
	.dout1 (dout_6_5),
	.dout1_valid (dout_valid_6_5)
);

hashtable #(
	.ANDMSK(64'hffffff0000000000),
	.NBITS(10),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(128),
	.INIT_FILE("./memory_init/bitmap6.mif")
)
hashtable_6_3 (
	.clk (clk),
	.din0 (din_6_6),
	.din0_valid (din_valid_6_6),
	.din1 (din_6_7),
	.din1_valid (din_valid_6_7),
	.dout0 (dout_6_6),
	.dout0_valid (dout_valid_6_6),
	.dout1 (dout_6_7),
	.dout1_valid (dout_valid_6_7)
);

hashtable #(
	.ANDMSK(64'hffff000000000000),
	.NBITS(8),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(32),
	.INIT_FILE("./memory_init/bitmap7.mif")
)
hashtable_7_0 (
	.clk (clk),
	.din0 (din_7_0),
	.din0_valid (din_valid_7_0),
	.din1 (din_7_1),
	.din1_valid (din_valid_7_1),
	.dout0 (dout_7_0),
	.dout0_valid (dout_valid_7_0),
	.dout1 (dout_7_1),
	.dout1_valid (dout_valid_7_1)
);

hashtable #(
	.ANDMSK(64'hffff000000000000),
	.NBITS(8),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(32),
	.INIT_FILE("./memory_init/bitmap7.mif")
)
hashtable_7_1 (
	.clk (clk),
	.din0 (din_7_2),
	.din0_valid (din_valid_7_2),
	.din1 (din_7_3),
	.din1_valid (din_valid_7_3),
	.dout0 (dout_7_2),
	.dout0_valid (dout_valid_7_2),
	.dout1 (dout_7_3),
	.dout1_valid (dout_valid_7_3)
);

hashtable #(
	.ANDMSK(64'hffff000000000000),
	.NBITS(8),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(32),
	.INIT_FILE("./memory_init/bitmap7.mif")
)
hashtable_7_2 (
	.clk (clk),
	.din0 (din_7_4),
	.din0_valid (din_valid_7_4),
	.din1 (din_7_5),
	.din1_valid (din_valid_7_5),
	.dout0 (dout_7_4),
	.dout0_valid (dout_valid_7_4),
	.dout1 (dout_7_5),
	.dout1_valid (dout_valid_7_5)
);

hashtable #(
	.ANDMSK(64'hffff000000000000),
	.NBITS(8),
	.DWIDTH(RID_WIDTH),
	.MEM_SIZE(32),
	.INIT_FILE("./memory_init/bitmap7.mif")
)
hashtable_7_3 (
	.clk (clk),
	.din0 (din_7_6),
	.din0_valid (din_valid_7_6),
	.din1 (din_7_7),
	.din1_valid (din_valid_7_7),
	.dout0 (dout_7_6),
	.dout0_valid (dout_valid_7_6),
	.dout1 (dout_7_7),
	.dout1_valid (dout_valid_7_7)
);

endmodule