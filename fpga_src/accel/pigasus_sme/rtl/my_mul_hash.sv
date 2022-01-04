/*

Copyright (c) 2021 Moein Khazraee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

module mul_hash(clk,a,p);
input clk;
input[63:0] a;
output reg [63:0] p;

localparam ANDMSK = 64'hdfdfdfdfdfdfdfdf;
wire [63:0] b = 64'h0b4e0ef37bc32127;

reg [63:0] a_reg0;
reg [63:0] a_reg1;
reg [63:0] a_reg2;

(* srl_style = "register" *) reg [63:0] a_reg3;
(* srl_style = "register" *) reg [63:0] a_reg4;
(* srl_style = "register" *) reg [63:0] a_reg5;

(* srl_style = "register" *) reg [63:0] sum_reg0;
(* srl_style = "register" *) reg [63:0] sum_reg1;
(* srl_style = "register" *) reg [63:0] sum_reg2;

always @ (posedge clk) begin
  a_reg3   <= a_reg2;
  a_reg4   <= a_reg3;
  a_reg5   <= a_reg4;

  sum_reg0 <= a_reg5 * b;
  sum_reg1 <= sum_reg0;
  sum_reg2 <= sum_reg1;
end

// Sign and mask handling
reg in_v_reg0;
reg in_v_reg1;

wire signed [63:0] temp;
wire [63:0] after_and;

reg sign;
reg sign_r1;
reg sign_r2;
reg sign_r3;
reg sign_r4;
reg sign_r5;
reg sign_r6;
reg sign_r7;

reg valid;
reg valid_r1;
reg valid_r2;
reg valid_r3;
reg valid_r4;
reg valid_r5;
reg valid_r6;
reg valid_r7;
reg valid_r8;
reg valid_r9;
reg valid_r10;

always @ (posedge clk) begin
    a_reg0 <= a;

    a_reg1 <= a_reg0 & ANDMSK;
    if(a_reg0[63]) begin
			  sign <= 1;
		end else begin
			  sign <= 0;
		end		

    if(sign) begin
        a_reg2 <= ~a_reg1 + 1;
    end else begin
        a_reg2 <= a_reg1;
    end

		sign_r1 <= sign;
		sign_r2 <= sign_r1;
		sign_r3 <= sign_r2;
		sign_r4 <= sign_r3;
		sign_r5 <= sign_r4;
		sign_r6 <= sign_r5;
		sign_r7 <= sign_r6;

		if(sign_r7) begin
			p <= ~sum_reg2 + 1;
		end else begin
			p <= sum_reg2;
		end
end

endmodule

`resetall
