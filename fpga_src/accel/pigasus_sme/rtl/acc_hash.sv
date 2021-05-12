// Latency 6
module acc_hash(clk, sign, p,
           a0b0, a0b1, a0b2, a0b3,
           a0b0_1sc, a0b1_1sc, a0b2_1sc, a0b3_1sc,
           msk_a0b0, msk_a0b1, msk_a0b2, msk_a0b3,
           msk_a0b0_1sc, msk_a0b1_1sc, msk_a0b2_1sc, msk_a0b3_1sc,
           a1b0, a1b1, a1b2,
           a1b0_1sc, a1b1_1sc, a1b2_1sc,
           msk_a1b0, msk_a1b1, msk_a1b2,
           msk_a1b0_1sc, msk_a1b1_1sc, msk_a1b2_1sc,
           a2b0, a2b1,
           a2b0_1sc, a2b1_1sc,
           msk_a2b0, msk_a2b1,
           msk_a2b0_1sc, msk_a2b1_1sc,
           a3b0,
           a3b0_1sc);
           // At most there are 6 bytes being masked
           // msk_a3b0,
           // msk_a3b0_1sc

parameter ANDMSK = 64'hffffffffffffffff;
parameter NBITS = 15;

input clk;
input sign;
output reg [NBITS-1:0] p;

input [31:0] a0b0;
input [31:0] a0b1;
input [31:0] a0b2;
input [31:0] a0b3;
input [31:0] a0b0_1sc;
input [31:0] a0b1_1sc;
input [31:0] a0b2_1sc;
input [31:0] a0b3_1sc;
input [23:0] msk_a0b0;
input [23:0] msk_a0b1;
input [23:0] msk_a0b2;
input [23:0] msk_a0b3;
input [23:0] msk_a0b0_1sc;
input [23:0] msk_a0b1_1sc;
input [23:0] msk_a0b2_1sc;
input [23:0] msk_a0b3_1sc;

input [31:0] a1b0;
input [31:0] a1b1;
input [31:0] a1b2;
input [31:0] a1b0_1sc;
input [31:0] a1b1_1sc;
input [31:0] a1b2_1sc;
input [23:0] msk_a1b0;
input [23:0] msk_a1b1;
input [23:0] msk_a1b2;
input [23:0] msk_a1b0_1sc;
input [23:0] msk_a1b1_1sc;
input [23:0] msk_a1b2_1sc;

input [31:0] a2b0;
input [31:0] a2b1;
input [31:0] a2b0_1sc;
input [31:0] a2b1_1sc;
input [23:0] msk_a2b0;
input [23:0] msk_a2b1;
input [23:0] msk_a2b0_1sc;
input [23:0] msk_a2b1_1sc;

input [31:0] a3b0;
input [31:0] a3b0_1sc;
// input [23:0] msk_a3b0;
// input [23:0] msk_a3b0_1sc;

reg  [31:0] updated_a0b0;
reg  [31:0] updated_a0b1;
reg  [31:0] updated_a0b2;
reg  [31:0] updated_a0b3;
reg  [31:0] updated_a1b0;
reg  [31:0] updated_a1b1;
reg  [31:0] updated_a1b2;
reg  [31:0] updated_a2b0;
reg  [31:0] updated_a2b1;
reg  [31:0] updated_a3b0;

reg  [32:0] add_a0b1_a1b0;
reg  [32:0] add_a0b2_a2b0;
reg  [16:0] add_a0b3_a1b2;
reg  [16:0] add_a2b1_a3b0;
reg  [31:0] a0b0_reg;
reg  [31:0] a1b1_reg;

reg  [49:0] sum0_reg;
reg  [33:0] sum1_reg;
reg  [16:0] sum2_reg;

reg  [64:0] half_sum0_reg;
reg  [34:0] half_sum1_reg;

reg  [63:0] sum;

wire [63:0] result;

reg sign_r0, sign_r1, sign_r2, sign_r3, sign_r4;

localparam LSB_BYTES_MASKED = (ANDMSK[63:56]==0) ? 8 :
                              (ANDMSK[55:48]==0) ? 7 : 
                              (ANDMSK[47:40]==0) ? 6 : 
                              (ANDMSK[39:32]==0) ? 5 : 
                              (ANDMSK[31:24]==0) ? 4 : 
                              (ANDMSK[23:16]==0) ? 3 : 
                              (ANDMSK[15: 8]==0) ? 2 : 
                              (ANDMSK[7 : 0]==0) ? 1 : 0;

// Should be same as mul_hash.sv
wire [63:0] b = 64'h0b4e0ef37bc32127;

// First level selection of 32-bit multiply factors
// Note that it is a single mux based on the sign input, 
// parameter muxes are resolved in synthesie.
generate 
  if (LSB_BYTES_MASKED % 2 == 0) begin
    always @ (posedge clk) begin
      sign_r0 <= sign;
      if (sign) begin
        updated_a0b0 <= (LSB_BYTES_MASKED>=2) ? 32'd0 : a0b0_1sc;
        updated_a0b1 <= (LSB_BYTES_MASKED>=2) ? 32'd0 : a0b1_1sc;
        updated_a0b2 <= (LSB_BYTES_MASKED>=2) ? 32'd0 : a0b2_1sc;
        updated_a0b3 <= (LSB_BYTES_MASKED>=2) ? 32'd0 : a0b3_1sc;
        updated_a1b0 <= (LSB_BYTES_MASKED>=4) ? 32'd0 : a1b0_1sc;
        updated_a1b1 <= (LSB_BYTES_MASKED>=4) ? 32'd0 : a1b1_1sc;
        updated_a1b2 <= (LSB_BYTES_MASKED>=4) ? 32'd0 : a1b2_1sc;
        updated_a2b0 <= (LSB_BYTES_MASKED>=6) ? 32'd0 : a2b0_1sc;
        updated_a2b1 <= (LSB_BYTES_MASKED>=6) ? 32'd0 : a2b1_1sc;
        updated_a3b0 <= (LSB_BYTES_MASKED==8) ? 32'd0 : a3b0_1sc; // Always non-zero
      end else begin
        updated_a0b0 <= (LSB_BYTES_MASKED>=2) ? 32'd0 : a0b0;
        updated_a0b1 <= (LSB_BYTES_MASKED>=2) ? 32'd0 : a0b1;
        updated_a0b2 <= (LSB_BYTES_MASKED>=2) ? 32'd0 : a0b2;
        updated_a0b3 <= (LSB_BYTES_MASKED>=2) ? 32'd0 : a0b3;
        updated_a1b0 <= (LSB_BYTES_MASKED>=4) ? 32'd0 : a1b0;
        updated_a1b1 <= (LSB_BYTES_MASKED>=4) ? 32'd0 : a1b1;
        updated_a1b2 <= (LSB_BYTES_MASKED>=4) ? 32'd0 : a1b2;
        updated_a2b0 <= (LSB_BYTES_MASKED>=6) ? 32'd0 : a2b0;
        updated_a2b1 <= (LSB_BYTES_MASKED>=6) ? 32'd0 : a2b1;
        updated_a3b0 <= (LSB_BYTES_MASKED==8) ? 32'd0 : a3b0; // Always non-zero
      end
    end
  end else begin
    always @ (posedge clk) begin
      sign_r0 <= sign;
      if (sign) begin
        updated_a0b0 <= (LSB_BYTES_MASKED>=3) ? 32'd0 : {msk_a0b0_1sc, 8'd0};
        updated_a0b1 <= (LSB_BYTES_MASKED>=3) ? 32'd0 : {msk_a0b1_1sc, 8'd0};
        updated_a0b2 <= (LSB_BYTES_MASKED>=3) ? 32'd0 : {msk_a0b2_1sc, 8'd0};
        updated_a0b3 <= (LSB_BYTES_MASKED>=3) ? 32'd0 : {msk_a0b3_1sc, 8'd0};

        updated_a1b0 <= (LSB_BYTES_MASKED>=5) ? 32'd0                : 
                        (LSB_BYTES_MASKED==3) ? {msk_a1b0_1sc, 8'd0} :
                                                a1b0_1sc;
        updated_a1b1 <= (LSB_BYTES_MASKED>=5) ? 32'd0                : 
                        (LSB_BYTES_MASKED==3) ? {msk_a1b1_1sc, 8'd0} :
                                                a1b1_1sc;
        updated_a1b2 <= (LSB_BYTES_MASKED>=5) ? 32'd0                : 
                        (LSB_BYTES_MASKED==3) ? {msk_a1b2_1sc, 8'd0} :
                                                a1b2_1sc;
        updated_a2b0 <= (LSB_BYTES_MASKED>=7) ? 32'd0                : // Always non-zero
                        (LSB_BYTES_MASKED==5) ? {msk_a2b0_1sc, 8'd0} :
                                                a2b0_1sc;
        updated_a2b1 <= (LSB_BYTES_MASKED>=7) ? 32'd0                : // Always non-zero
                        (LSB_BYTES_MASKED==5) ? {msk_a2b1_1sc, 8'd0} :
                                                a2b1_1sc;
        // updated_a3b0 <= (LSB_BYTES_MASKED==7) ? {msk_a3b0_1sc, 8'd0} : //Never happens
        //                                         a3b0_1sc;
        updated_a3b0 <= a3b0_1sc;
      end else begin 
        updated_a0b0 <= (LSB_BYTES_MASKED>=3) ? 32'd0 : {msk_a0b0, 8'd0};
        updated_a0b1 <= (LSB_BYTES_MASKED>=3) ? 32'd0 : {msk_a0b1, 8'd0};
        updated_a0b2 <= (LSB_BYTES_MASKED>=3) ? 32'd0 : {msk_a0b2, 8'd0};
        updated_a0b3 <= (LSB_BYTES_MASKED>=3) ? 32'd0 : {msk_a0b3, 8'd0};

        updated_a1b0 <= (LSB_BYTES_MASKED>=5) ? 32'd0            : 
                        (LSB_BYTES_MASKED==3) ? {msk_a1b0, 8'd0} :
                                                a1b0;
        updated_a1b1 <= (LSB_BYTES_MASKED>=5) ? 32'd0            : 
                        (LSB_BYTES_MASKED==3) ? {msk_a1b1, 8'd0} :
                                                a1b1;
        updated_a1b2 <= (LSB_BYTES_MASKED>=5) ? 32'd0            : 
                        (LSB_BYTES_MASKED==3) ? {msk_a1b2, 8'd0} :
                                                a1b2;
        updated_a2b0 <= (LSB_BYTES_MASKED>=7) ? 32'd0            : // Always non-zero
                        (LSB_BYTES_MASKED==5) ? {msk_a2b0, 8'd0} :
                                                a2b0;
        updated_a2b1 <= (LSB_BYTES_MASKED>=7) ? 32'd0            : // Always non-zero
                        (LSB_BYTES_MASKED==5) ? {msk_a2b1, 8'd0} :
                                                a2b1;
        // updated_a3b0 <= (LSB_BYTES_MASKED==7) ? {msk_a3b0, 8'd0} : //Never happens
        //                                         a3b0;
           updated_a3b0 <= a3b0;
      end
    end
  end
endgenerate

// Addition tree level 1
// a0b3, a1b2, a2b1, a3b0 are cut short due to 64 bit final truncation
always @ (posedge clk) begin
  sign_r1       <= sign_r0;
  add_a0b1_a1b0 <= updated_a0b1       + updated_a1b0;
  add_a0b2_a2b0 <= updated_a0b2       + updated_a2b0;
  add_a0b3_a1b2 <= updated_a0b3[15:0] + updated_a1b2[15:0];
  add_a2b1_a3b0 <= updated_a2b1[15:0] + updated_a3b0[15:0];
  a0b0_reg      <= updated_a0b0;
  a1b1_reg      <= updated_a1b1;
end

// Addition tree level 2
always @ (posedge clk) begin
  sign_r2  <= sign_r1;
  sum0_reg <= (add_a0b1_a1b0<<16)  + a0b0_reg;
  sum1_reg <=  add_a0b2_a2b0       + a1b1_reg;
  sum2_reg <=  add_a0b3_a1b2[15:0] + add_a2b1_a3b0[15:0];
end

// addition tree level 3, adding 1xb from initial 2's compliment
// (We want to keep zeroes while doing 2's complement.
// E.g., 2's compliment of 0xAA00 is 0x55FF+1 = 0x5500 + 1<<8)
wire [63:0] leftover_2sc = sign_r2 ? b << (8*LSB_BYTES_MASKED) : 64'd0;
always @ (posedge clk) begin
  sign_r3       <= sign_r2;
  half_sum0_reg <= sum0_reg + leftover_2sc;
  half_sum1_reg <= {sum2_reg[15:0], 16'd0} + sum1_reg;
end

// Final addition, level 4
always @ (posedge clk) begin
  sign_r4  <= sign_r3;
	sum      <= half_sum0_reg[63:0] + {half_sum1_reg[31:0], 32'd0};
end

// Final 2's compliment if necessary
assign result = sign_r4 ? (~sum+1) : sum;
always @ (posedge clk) begin
  p <= result[63:64-NBITS];
end

endmodule
