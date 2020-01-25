/*

Copyright 2019, The Regents of the University of California.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE REGENTS OF THE UNIVERSITY OF CALIFORNIA ''AS
IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS OF THE UNIVERSITY OF CALIFORNIA OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of The Regents of the University of California.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * FPGA core logic
 */
module riscv_block (
    input  wire        clk,
    input  wire        rst,
    
    input  wire [3:0]  core_id,             //CORE_ID_WIDTH

    // ---------------- DATA CHANNEL --------------- // 
    // Incoming data
    input  wire [127:0] data_s_axis_tdata,   //DATA_WIDTH
    input  wire [15:0]  data_s_axis_tkeep,   //STRB_WIDTH
    input  wire         data_s_axis_tvalid,
    output wire         data_s_axis_tready,
    input  wire         data_s_axis_tlast,
    input  wire [4:0]   data_s_axis_tdest,   //TAG_WIDTH
    input  wire [2:0]   data_s_axis_tuser,   //PORT_WIDTH
  
    // Outgoing data
    output wire [127:0] data_m_axis_tdata,   //DATA_WIDTH
    output wire [15:0]  data_m_axis_tkeep,   //STRB_WIDTH
    output wire         data_m_axis_tvalid,
    input  wire         data_m_axis_tready,
    output wire         data_m_axis_tlast,
    output wire [2:0]   data_m_axis_tdest,   //PORT_WIDTH
    output wire [4:0]   data_m_axis_tuser,   //TAG_WIDTH
  
    // ---------------- CTRL CHANNEL --------------- // 
    // Incoming control
    input  wire [35:0]  ctrl_s_axis_tdata,
    input  wire         ctrl_s_axis_tvalid,
    output wire         ctrl_s_axis_tready,
    input  wire         ctrl_s_axis_tlast,
  
    // Outgoing control 
    output wire [35:0]  ctrl_m_axis_tdata,
    output wire         ctrl_m_axis_tvalid,
    input  wire         ctrl_m_axis_tready,
    output wire         ctrl_m_axis_tlast,
    
    // ------------ DRAM RD REQ CHANNEL ------------- // 
    // Incoming DRAM request
    input  wire [63:0]  dram_s_axis_tdata,
    input  wire         dram_s_axis_tvalid,
    output wire         dram_s_axis_tready,
    input  wire         dram_s_axis_tlast,
  
    // Outgoing DRAM request
    output wire [63:0]  dram_m_axis_tdata,
    output wire         dram_m_axis_tvalid,
    input  wire         dram_m_axis_tready,
    output wire         dram_m_axis_tlast,

    // ------------- CORE MSG CHANNEL -------------- // 
    // Core messages output  
    output wire [50:0]  core_msg_out_data,   //MSG_WIDTH
    output wire         core_msg_out_valid,
    input  wire         core_msg_out_ready,

    // Core messages input
    input  wire [50:0]  core_msg_in_data,    //MSG_WIDTH
    input  wire [3:0]   core_msg_in_user,    //CORE_ID_WIDTH
    input  wire         core_msg_in_valid
);

(* KEEP = "TRUE" *) reg rst_r;
always @ (posedge clk)
  rst_r <= rst;

// Update if CORE_COUNT or PORT_COUNT has changed
parameter CORE_ID_WIDTH   = 4;
parameter PORT_WIDTH      = 3;
parameter DRAM_PORT       = 4;
parameter SLOT_COUNT      = 8;
parameter TAG_WIDTH       = 5;
parameter MSG_WIDTH       = 15+36;
parameter DATA_WIDTH      = 128;
parameter STRB_WIDTH      = 16;

parameter IMEM_SIZE       = 65536;
parameter SLOW_DMEM_SIZE  = 1048576;
parameter FAST_DMEM_SIZE  = 32768;
parameter BC_REGION_SIZE  = 32768;

// Internal parameters
parameter RECV_DESC_DEPTH = 8;
parameter SEND_DESC_DEPTH = 8;
parameter DRAM_DESC_DEPTH = 16;
parameter MSG_FIFO_DEPTH  = 16;
parameter SLOT_START_ADDR = 16'h0;
parameter SLOT_ADDR_STEP  = 16'h4000;

riscv_axis_wrapper #(
    .CORE_ID_WIDTH(CORE_ID_WIDTH),
    .PORT_WIDTH(PORT_WIDTH),
    .DRAM_PORT(DRAM_PORT),
    .SLOT_COUNT(SLOT_COUNT),
    .DATA_WIDTH(DATA_WIDTH),
    .IMEM_SIZE(IMEM_SIZE),
    .SLOW_DMEM_SIZE(SLOW_DMEM_SIZE),
    .FAST_DMEM_SIZE(FAST_DMEM_SIZE),
    .BC_REGION_SIZE(BC_REGION_SIZE),
    .RECV_DESC_DEPTH(RECV_DESC_DEPTH),
    .SEND_DESC_DEPTH(SEND_DESC_DEPTH),
    .DRAM_DESC_DEPTH(DRAM_DESC_DEPTH),
    .MSG_FIFO_DEPTH(MSG_FIFO_DEPTH),
    .SLOT_START_ADDR(SLOT_START_ADDR),
    .SLOT_ADDR_STEP(SLOT_ADDR_STEP),
    .DATA_S_REG_TYPE(2),
    .DATA_M_REG_TYPE(2),
    .DRAM_M_REG_TYPE(2),
    .SEPARATE_CLOCKS(0),
    .TARGET_URAM(1)
) wrapper_inst (
    .sys_clk(clk),
    .sys_rst(rst_r),
    .core_clk(clk),
    .core_rst(rst_r),
    .core_id(core_id),

    // ---------------- DATA CHANNEL --------------- // 
    // Incoming data
    .data_s_axis_tdata(data_s_axis_tdata),
    .data_s_axis_tkeep(data_s_axis_tkeep),
    .data_s_axis_tvalid(data_s_axis_tvalid),
    .data_s_axis_tready(data_s_axis_tready),
    .data_s_axis_tlast(data_s_axis_tlast),
    .data_s_axis_tdest(data_s_axis_tdest),
    .data_s_axis_tuser(data_s_axis_tuser),
  
    // Outgoing data
    .data_m_axis_tdata(data_m_axis_tdata),
    .data_m_axis_tkeep(data_m_axis_tkeep),
    .data_m_axis_tvalid(data_m_axis_tvalid),
    .data_m_axis_tready(data_m_axis_tready),
    .data_m_axis_tlast(data_m_axis_tlast),
    .data_m_axis_tdest(data_m_axis_tdest),
    .data_m_axis_tuser(data_m_axis_tuser),
  
    // ---------------- CTRL CHANNEL --------------- // 
    // Incoming control
    .ctrl_s_axis_tdata(ctrl_s_axis_tdata),
    .ctrl_s_axis_tvalid(ctrl_s_axis_tvalid),
    .ctrl_s_axis_tready(ctrl_s_axis_tready),
    .ctrl_s_axis_tlast(ctrl_s_axis_tlast),
                      
    // Outgoing control
    .ctrl_m_axis_tdata(ctrl_m_axis_tdata),
    .ctrl_m_axis_tvalid(ctrl_m_axis_tvalid),
    .ctrl_m_axis_tready(ctrl_m_axis_tready),
    .ctrl_m_axis_tlast(ctrl_m_axis_tlast),
    
    // ------------ DRAM RD REQ CHANNEL ------------- // 
    // Incoming DRAM request
    .dram_s_axis_tdata(dram_s_axis_tdata),
    .dram_s_axis_tvalid(dram_s_axis_tvalid),
    .dram_s_axis_tready(dram_s_axis_tready),
    .dram_s_axis_tlast(dram_s_axis_tlast),
  
    // Outgoing DRAM request
    .dram_m_axis_tdata(dram_m_axis_tdata),
    .dram_m_axis_tvalid(dram_m_axis_tvalid),
    .dram_m_axis_tready(dram_m_axis_tready),
    .dram_m_axis_tlast(dram_m_axis_tlast),

    // ------------- CORE MSG CHANNEL -------------- // 
    // Core messages output  
    .core_msg_out_data(core_msg_out_data),
    .core_msg_out_valid(core_msg_out_valid),
    .core_msg_out_ready(core_msg_out_ready),

    // Core messages input
    .core_msg_in_data(core_msg_in_data),
    .core_msg_in_user(core_msg_in_user),
    .core_msg_in_valid(core_msg_in_valid)
);

endmodule
