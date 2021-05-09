// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1.1 (lin64) Build 2580384 Sat Jun 29 08:04:45 MDT 2019
// Date        : Thu Mar 19 15:47:59 2020
// Host        : skateboard.sysnet.ucsd.edu running 64-bit Ubuntu 18.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/moein/BumpinTheWire/fpga_src/boards/VCU1525_100g/fpga/fpga.srcs/sources_1/ip/ila_4x64/ila_4x64_stub.v
// Design      : ila_4x64
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu9p-fsgd2104-2L-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2019.1.1" *)
module ila_4x64(clk, trig_out, trig_out_ack, trig_in, 
  trig_in_ack, probe0, probe1, probe2, probe3)
/* synthesis syn_black_box black_box_pad_pin="clk,trig_out,trig_out_ack,trig_in,trig_in_ack,probe0[63:0],probe1[63:0],probe2[63:0],probe3[63:0]" */;
  input clk;
  output trig_out;
  input trig_out_ack;
  input trig_in;
  output trig_in_ack;
  input [63:0]probe0;
  input [63:0]probe1;
  input [63:0]probe2;
  input [63:0]probe3;
endmodule
