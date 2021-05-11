module test_mul_hash (
  input  clk,
  input  [63:0] a,
  output [63:0] p
);

parameter MSK_BYTES = 0;
localparam ANDMSK   = {{(8-MSK_BYTES)*8{1'b1}},{MSK_BYTES*8{1'b0}}};

wire [31:0] a0b0;
wire [31:0] a0b1;
wire [31:0] a0b2;
wire [31:0] a0b3;
wire [31:0] a0b0_1sc;
wire [31:0] a0b1_1sc;
wire [31:0] a0b2_1sc;
wire [31:0] a0b3_1sc;
wire [23:0] msk_a0b0;
wire [23:0] msk_a0b1;
wire [23:0] msk_a0b2;
wire [23:0] msk_a0b3;
wire [23:0] msk_a0b0_1sc;
wire [23:0] msk_a0b1_1sc;
wire [23:0] msk_a0b2_1sc;
wire [23:0] msk_a0b3_1sc;

wire [31:0] a1b0;
wire [31:0] a1b1;
wire [31:0] a1b2;
wire [31:0] a1b3;
wire [31:0] a1b0_1sc;
wire [31:0] a1b1_1sc;
wire [31:0] a1b2_1sc;
wire [31:0] a1b3_1sc;
wire [23:0] msk_a1b0;
wire [23:0] msk_a1b1;
wire [23:0] msk_a1b2;
wire [23:0] msk_a1b3;
wire [23:0] msk_a1b0_1sc;
wire [23:0] msk_a1b1_1sc;
wire [23:0] msk_a1b2_1sc;
wire [23:0] msk_a1b3_1sc;

wire [31:0] a2b0;
wire [31:0] a2b1;
wire [31:0] a2b2;
wire [31:0] a2b3;
wire [31:0] a2b0_1sc;
wire [31:0] a2b1_1sc;
wire [31:0] a2b2_1sc;
wire [31:0] a2b3_1sc;
wire [23:0] msk_a2b0;
wire [23:0] msk_a2b1;
wire [23:0] msk_a2b2;
wire [23:0] msk_a2b3;
wire [23:0] msk_a2b0_1sc;
wire [23:0] msk_a2b1_1sc;
wire [23:0] msk_a2b2_1sc;
wire [23:0] msk_a2b3_1sc;

wire [31:0] a3b0;
wire [31:0] a3b1;
wire [31:0] a3b2;
wire [31:0] a3b3;
wire [31:0] a3b0_1sc;
wire [31:0] a3b1_1sc;
wire [31:0] a3b2_1sc;
wire [31:0] a3b3_1sc;
wire [23:0] msk_a3b0;
wire [23:0] msk_a3b1;
wire [23:0] msk_a3b2;
wire [23:0] msk_a3b3;
wire [23:0] msk_a3b0_1sc;
wire [23:0] msk_a3b1_1sc;
wire [23:0] msk_a3b2_1sc;
wire [23:0] msk_a3b3_1sc;

mul_hash dut_mul_0 (
  .clk(clk),
  .a(a[0*8+:16]), 
  .ab0(a0b0),                 
  .ab1(a0b1), 
  .ab2(a0b2),                 
  .ab3(a0b3),
  .ab0_1sc(a0b0_1sc),         
  .ab1_1sc(a0b1_1sc), 
  .ab2_1sc(a0b2_1sc),         
  .ab3_1sc(a0b3_1sc),
  .msk_ab0(msk_a0b0),        
  .msk_ab1(msk_a0b1), 
  .msk_ab2(msk_a0b2),        
  .msk_ab3(msk_a0b3),
  .msk_ab0_1sc(msk_a0b0_1sc), 
  .msk_ab1_1sc(msk_a0b1_1sc), 
  .msk_ab2_1sc(msk_a0b2_1sc), 
  .msk_ab3_1sc(msk_a0b3_1sc)
);

mul_hash dut_mul_1 (
  .clk(clk),
  .a(a[2*8+:16]), 
  .ab0(a1b0),                 
  .ab1(a1b1), 
  .ab2(a1b2),                 
  .ab3(a1b3),
  .ab0_1sc(a1b0_1sc),         
  .ab1_1sc(a1b1_1sc), 
  .ab2_1sc(a1b2_1sc),         
  .ab3_1sc(a1b3_1sc),
  .msk_ab0(msk_a1b0),        
  .msk_ab1(msk_a1b1), 
  .msk_ab2(msk_a1b2),        
  .msk_ab3(msk_a1b3),
  .msk_ab0_1sc(msk_a1b0_1sc), 
  .msk_ab1_1sc(msk_a1b1_1sc), 
  .msk_ab2_1sc(msk_a1b2_1sc), 
  .msk_ab3_1sc(msk_a1b3_1sc)
);

mul_hash dut_mul_2 (
  .clk(clk),
  .a(a[4*8+:16]), 
  .ab0(a2b0),                 
  .ab1(a2b1), 
  .ab2(a2b2),                 
  .ab3(a2b3),
  .ab0_1sc(a2b0_1sc),         
  .ab1_1sc(a2b1_1sc), 
  .ab2_1sc(a2b2_1sc),         
  .ab3_1sc(a2b3_1sc),
  .msk_ab0(msk_a2b0),        
  .msk_ab1(msk_a2b1), 
  .msk_ab2(msk_a2b2),        
  .msk_ab3(msk_a2b3),
  .msk_ab0_1sc(msk_a2b0_1sc), 
  .msk_ab1_1sc(msk_a2b1_1sc), 
  .msk_ab2_1sc(msk_a2b2_1sc), 
  .msk_ab3_1sc(msk_a2b3_1sc)
);

mul_hash dut_mul_3 (
  .clk(clk),
  .a(a[6*8+:16]), 
  .ab0(a3b0),                 
  .ab1(a3b1), 
  .ab2(a3b2),                 
  .ab3(a3b3),
  .ab0_1sc(a3b0_1sc),         
  .ab1_1sc(a3b1_1sc), 
  .ab2_1sc(a3b2_1sc),         
  .ab3_1sc(a3b3_1sc),
  .msk_ab0(msk_a3b0),        
  .msk_ab1(msk_a3b1), 
  .msk_ab2(msk_a3b2),        
  .msk_ab3(msk_a3b3),
  .msk_ab0_1sc(msk_a3b0_1sc), 
  .msk_ab1_1sc(msk_a3b1_1sc), 
  .msk_ab2_1sc(msk_a3b2_1sc), 
  .msk_ab3_1sc(msk_a3b3_1sc)
);

wire sign;
hyper_pipe #(.NUM_PIPES(6),.WIDTH(1)) sign_bits_pipe (
    .clk(clk),.din(a[63]),.dout(sign));

acc_hash # (
	.ANDMSK(ANDMSK),
	.NBITS(64)
) dut_acc_hash (
  .clk(clk), .sign(sign), .p(p),

  .a0b0(a0b0), .a0b1(a0b1), .a0b2(a0b2), .a0b3(a0b3),
  .a0b0_1sc(a0b0_1sc), .a0b1_1sc(a0b1_1sc), .a0b2_1sc(a0b2_1sc), .a0b3_1sc(a0b3_1sc),
  .msk_a0b0(msk_a0b0), .msk_a0b1(msk_a0b1), .msk_a0b2(msk_a0b2), .msk_a0b3(msk_a0b3),
  .msk_a0b0_1sc(msk_a0b0_1sc), .msk_a0b1_1sc(msk_a0b1_1sc), .msk_a0b2_1sc(msk_a0b2_1sc), .msk_a0b3_1sc(msk_a0b3_1sc),

  .a1b0(a1b0), .a1b1(a1b1), .a1b2(a1b2),
  .a1b0_1sc(a1b0_1sc), .a1b1_1sc(a1b1_1sc), .a1b2_1sc(a1b2_1sc),
  .msk_a1b0(msk_a1b0), .msk_a1b1(msk_a1b1), .msk_a1b2(msk_a1b2),
  .msk_a1b0_1sc(msk_a1b0_1sc), .msk_a1b1_1sc(msk_a1b1_1sc), .msk_a1b2_1sc(msk_a1b2_1sc),

  .a2b0(a2b0), .a2b1(a2b1),
  .a2b0_1sc(a2b0_1sc), .a2b1_1sc(a2b1_1sc),
  .msk_a2b0(msk_a2b0), .msk_a2b1(msk_a2b1),
  .msk_a2b0_1sc(msk_a2b0_1sc), .msk_a2b1_1sc(msk_a2b1_1sc),
  
  .a3b0(a3b0),
  .a3b0_1sc(a3b0_1sc)
);
  
  initial begin
    $dumpfile ("sim_build/mul_hash_waveform.fst");
    $dumpvars (0,test_mul_hash);
    #1;
  end

endmodule
