`include "struct_s.sv"
//`define DUMMY
module frontend (
    input  logic                 clk,
    input  logic                 rst,
    input  logic [FP_DWIDTH-1:0] in_data,
    input  logic                 in_valid,
    input  logic                 in_sop,
    input  logic                 in_eop,
    input  logic [FP_EWIDTH-1:0] in_empty,
    output logic [RID_WIDTH-1:0] hash_out_0_0,
    output logic                 hash_out_valid_filter_0_0,
    output logic [RID_WIDTH-1:0] hash_out_0_1,
    output logic                 hash_out_valid_filter_0_1,
    output logic [RID_WIDTH-1:0] hash_out_0_2,
    output logic                 hash_out_valid_filter_0_2,
    output logic [RID_WIDTH-1:0] hash_out_0_3,
    output logic                 hash_out_valid_filter_0_3,
    output logic [RID_WIDTH-1:0] hash_out_0_4,
    output logic                 hash_out_valid_filter_0_4,
    output logic [RID_WIDTH-1:0] hash_out_0_5,
    output logic                 hash_out_valid_filter_0_5,
    output logic [RID_WIDTH-1:0] hash_out_0_6,
    output logic                 hash_out_valid_filter_0_6,
    output logic [RID_WIDTH-1:0] hash_out_0_7,
    output logic                 hash_out_valid_filter_0_7,
    output logic [RID_WIDTH-1:0] hash_out_0_8,
    output logic                 hash_out_valid_filter_0_8,
    output logic [RID_WIDTH-1:0] hash_out_0_9,
    output logic                 hash_out_valid_filter_0_9,
    output logic [RID_WIDTH-1:0] hash_out_0_10,
    output logic                 hash_out_valid_filter_0_10,
    output logic [RID_WIDTH-1:0] hash_out_0_11,
    output logic                 hash_out_valid_filter_0_11,
    output logic [RID_WIDTH-1:0] hash_out_0_12,
    output logic                 hash_out_valid_filter_0_12,
    output logic [RID_WIDTH-1:0] hash_out_0_13,
    output logic                 hash_out_valid_filter_0_13,
    output logic [RID_WIDTH-1:0] hash_out_0_14,
    output logic                 hash_out_valid_filter_0_14,
    output logic [RID_WIDTH-1:0] hash_out_0_15,
    output logic                 hash_out_valid_filter_0_15,
    output logic [RID_WIDTH-1:0] hash_out_1_0,
    output logic                 hash_out_valid_filter_1_0,
    output logic [RID_WIDTH-1:0] hash_out_1_1,
    output logic                 hash_out_valid_filter_1_1,
    output logic [RID_WIDTH-1:0] hash_out_1_2,
    output logic                 hash_out_valid_filter_1_2,
    output logic [RID_WIDTH-1:0] hash_out_1_3,
    output logic                 hash_out_valid_filter_1_3,
    output logic [RID_WIDTH-1:0] hash_out_1_4,
    output logic                 hash_out_valid_filter_1_4,
    output logic [RID_WIDTH-1:0] hash_out_1_5,
    output logic                 hash_out_valid_filter_1_5,
    output logic [RID_WIDTH-1:0] hash_out_1_6,
    output logic                 hash_out_valid_filter_1_6,
    output logic [RID_WIDTH-1:0] hash_out_1_7,
    output logic                 hash_out_valid_filter_1_7,
    output logic [RID_WIDTH-1:0] hash_out_1_8,
    output logic                 hash_out_valid_filter_1_8,
    output logic [RID_WIDTH-1:0] hash_out_1_9,
    output logic                 hash_out_valid_filter_1_9,
    output logic [RID_WIDTH-1:0] hash_out_1_10,
    output logic                 hash_out_valid_filter_1_10,
    output logic [RID_WIDTH-1:0] hash_out_1_11,
    output logic                 hash_out_valid_filter_1_11,
    output logic [RID_WIDTH-1:0] hash_out_1_12,
    output logic                 hash_out_valid_filter_1_12,
    output logic [RID_WIDTH-1:0] hash_out_1_13,
    output logic                 hash_out_valid_filter_1_13,
    output logic [RID_WIDTH-1:0] hash_out_1_14,
    output logic                 hash_out_valid_filter_1_14,
    output logic [RID_WIDTH-1:0] hash_out_1_15,
    output logic                 hash_out_valid_filter_1_15,
    output logic [RID_WIDTH-1:0] hash_out_2_0,
    output logic                 hash_out_valid_filter_2_0,
    output logic [RID_WIDTH-1:0] hash_out_2_1,
    output logic                 hash_out_valid_filter_2_1,
    output logic [RID_WIDTH-1:0] hash_out_2_2,
    output logic                 hash_out_valid_filter_2_2,
    output logic [RID_WIDTH-1:0] hash_out_2_3,
    output logic                 hash_out_valid_filter_2_3,
    output logic [RID_WIDTH-1:0] hash_out_2_4,
    output logic                 hash_out_valid_filter_2_4,
    output logic [RID_WIDTH-1:0] hash_out_2_5,
    output logic                 hash_out_valid_filter_2_5,
    output logic [RID_WIDTH-1:0] hash_out_2_6,
    output logic                 hash_out_valid_filter_2_6,
    output logic [RID_WIDTH-1:0] hash_out_2_7,
    output logic                 hash_out_valid_filter_2_7,
    output logic [RID_WIDTH-1:0] hash_out_2_8,
    output logic                 hash_out_valid_filter_2_8,
    output logic [RID_WIDTH-1:0] hash_out_2_9,
    output logic                 hash_out_valid_filter_2_9,
    output logic [RID_WIDTH-1:0] hash_out_2_10,
    output logic                 hash_out_valid_filter_2_10,
    output logic [RID_WIDTH-1:0] hash_out_2_11,
    output logic                 hash_out_valid_filter_2_11,
    output logic [RID_WIDTH-1:0] hash_out_2_12,
    output logic                 hash_out_valid_filter_2_12,
    output logic [RID_WIDTH-1:0] hash_out_2_13,
    output logic                 hash_out_valid_filter_2_13,
    output logic [RID_WIDTH-1:0] hash_out_2_14,
    output logic                 hash_out_valid_filter_2_14,
    output logic [RID_WIDTH-1:0] hash_out_2_15,
    output logic                 hash_out_valid_filter_2_15,
    output logic [RID_WIDTH-1:0] hash_out_3_0,
    output logic                 hash_out_valid_filter_3_0,
    output logic [RID_WIDTH-1:0] hash_out_3_1,
    output logic                 hash_out_valid_filter_3_1,
    output logic [RID_WIDTH-1:0] hash_out_3_2,
    output logic                 hash_out_valid_filter_3_2,
    output logic [RID_WIDTH-1:0] hash_out_3_3,
    output logic                 hash_out_valid_filter_3_3,
    output logic [RID_WIDTH-1:0] hash_out_3_4,
    output logic                 hash_out_valid_filter_3_4,
    output logic [RID_WIDTH-1:0] hash_out_3_5,
    output logic                 hash_out_valid_filter_3_5,
    output logic [RID_WIDTH-1:0] hash_out_3_6,
    output logic                 hash_out_valid_filter_3_6,
    output logic [RID_WIDTH-1:0] hash_out_3_7,
    output logic                 hash_out_valid_filter_3_7,
    output logic [RID_WIDTH-1:0] hash_out_3_8,
    output logic                 hash_out_valid_filter_3_8,
    output logic [RID_WIDTH-1:0] hash_out_3_9,
    output logic                 hash_out_valid_filter_3_9,
    output logic [RID_WIDTH-1:0] hash_out_3_10,
    output logic                 hash_out_valid_filter_3_10,
    output logic [RID_WIDTH-1:0] hash_out_3_11,
    output logic                 hash_out_valid_filter_3_11,
    output logic [RID_WIDTH-1:0] hash_out_3_12,
    output logic                 hash_out_valid_filter_3_12,
    output logic [RID_WIDTH-1:0] hash_out_3_13,
    output logic                 hash_out_valid_filter_3_13,
    output logic [RID_WIDTH-1:0] hash_out_3_14,
    output logic                 hash_out_valid_filter_3_14,
    output logic [RID_WIDTH-1:0] hash_out_3_15,
    output logic                 hash_out_valid_filter_3_15,
    output logic [RID_WIDTH-1:0] hash_out_4_0,
    output logic                 hash_out_valid_filter_4_0,
    output logic [RID_WIDTH-1:0] hash_out_4_1,
    output logic                 hash_out_valid_filter_4_1,
    output logic [RID_WIDTH-1:0] hash_out_4_2,
    output logic                 hash_out_valid_filter_4_2,
    output logic [RID_WIDTH-1:0] hash_out_4_3,
    output logic                 hash_out_valid_filter_4_3,
    output logic [RID_WIDTH-1:0] hash_out_4_4,
    output logic                 hash_out_valid_filter_4_4,
    output logic [RID_WIDTH-1:0] hash_out_4_5,
    output logic                 hash_out_valid_filter_4_5,
    output logic [RID_WIDTH-1:0] hash_out_4_6,
    output logic                 hash_out_valid_filter_4_6,
    output logic [RID_WIDTH-1:0] hash_out_4_7,
    output logic                 hash_out_valid_filter_4_7,
    output logic [RID_WIDTH-1:0] hash_out_4_8,
    output logic                 hash_out_valid_filter_4_8,
    output logic [RID_WIDTH-1:0] hash_out_4_9,
    output logic                 hash_out_valid_filter_4_9,
    output logic [RID_WIDTH-1:0] hash_out_4_10,
    output logic                 hash_out_valid_filter_4_10,
    output logic [RID_WIDTH-1:0] hash_out_4_11,
    output logic                 hash_out_valid_filter_4_11,
    output logic [RID_WIDTH-1:0] hash_out_4_12,
    output logic                 hash_out_valid_filter_4_12,
    output logic [RID_WIDTH-1:0] hash_out_4_13,
    output logic                 hash_out_valid_filter_4_13,
    output logic [RID_WIDTH-1:0] hash_out_4_14,
    output logic                 hash_out_valid_filter_4_14,
    output logic [RID_WIDTH-1:0] hash_out_4_15,
    output logic                 hash_out_valid_filter_4_15,
    output logic [RID_WIDTH-1:0] hash_out_5_0,
    output logic                 hash_out_valid_filter_5_0,
    output logic [RID_WIDTH-1:0] hash_out_5_1,
    output logic                 hash_out_valid_filter_5_1,
    output logic [RID_WIDTH-1:0] hash_out_5_2,
    output logic                 hash_out_valid_filter_5_2,
    output logic [RID_WIDTH-1:0] hash_out_5_3,
    output logic                 hash_out_valid_filter_5_3,
    output logic [RID_WIDTH-1:0] hash_out_5_4,
    output logic                 hash_out_valid_filter_5_4,
    output logic [RID_WIDTH-1:0] hash_out_5_5,
    output logic                 hash_out_valid_filter_5_5,
    output logic [RID_WIDTH-1:0] hash_out_5_6,
    output logic                 hash_out_valid_filter_5_6,
    output logic [RID_WIDTH-1:0] hash_out_5_7,
    output logic                 hash_out_valid_filter_5_7,
    output logic [RID_WIDTH-1:0] hash_out_5_8,
    output logic                 hash_out_valid_filter_5_8,
    output logic [RID_WIDTH-1:0] hash_out_5_9,
    output logic                 hash_out_valid_filter_5_9,
    output logic [RID_WIDTH-1:0] hash_out_5_10,
    output logic                 hash_out_valid_filter_5_10,
    output logic [RID_WIDTH-1:0] hash_out_5_11,
    output logic                 hash_out_valid_filter_5_11,
    output logic [RID_WIDTH-1:0] hash_out_5_12,
    output logic                 hash_out_valid_filter_5_12,
    output logic [RID_WIDTH-1:0] hash_out_5_13,
    output logic                 hash_out_valid_filter_5_13,
    output logic [RID_WIDTH-1:0] hash_out_5_14,
    output logic                 hash_out_valid_filter_5_14,
    output logic [RID_WIDTH-1:0] hash_out_5_15,
    output logic                 hash_out_valid_filter_5_15,
    output logic [RID_WIDTH-1:0] hash_out_6_0,
    output logic                 hash_out_valid_filter_6_0,
    output logic [RID_WIDTH-1:0] hash_out_6_1,
    output logic                 hash_out_valid_filter_6_1,
    output logic [RID_WIDTH-1:0] hash_out_6_2,
    output logic                 hash_out_valid_filter_6_2,
    output logic [RID_WIDTH-1:0] hash_out_6_3,
    output logic                 hash_out_valid_filter_6_3,
    output logic [RID_WIDTH-1:0] hash_out_6_4,
    output logic                 hash_out_valid_filter_6_4,
    output logic [RID_WIDTH-1:0] hash_out_6_5,
    output logic                 hash_out_valid_filter_6_5,
    output logic [RID_WIDTH-1:0] hash_out_6_6,
    output logic                 hash_out_valid_filter_6_6,
    output logic [RID_WIDTH-1:0] hash_out_6_7,
    output logic                 hash_out_valid_filter_6_7,
    output logic [RID_WIDTH-1:0] hash_out_6_8,
    output logic                 hash_out_valid_filter_6_8,
    output logic [RID_WIDTH-1:0] hash_out_6_9,
    output logic                 hash_out_valid_filter_6_9,
    output logic [RID_WIDTH-1:0] hash_out_6_10,
    output logic                 hash_out_valid_filter_6_10,
    output logic [RID_WIDTH-1:0] hash_out_6_11,
    output logic                 hash_out_valid_filter_6_11,
    output logic [RID_WIDTH-1:0] hash_out_6_12,
    output logic                 hash_out_valid_filter_6_12,
    output logic [RID_WIDTH-1:0] hash_out_6_13,
    output logic                 hash_out_valid_filter_6_13,
    output logic [RID_WIDTH-1:0] hash_out_6_14,
    output logic                 hash_out_valid_filter_6_14,
    output logic [RID_WIDTH-1:0] hash_out_6_15,
    output logic                 hash_out_valid_filter_6_15,
    output logic [RID_WIDTH-1:0] hash_out_7_0,
    output logic                 hash_out_valid_filter_7_0,
    output logic [RID_WIDTH-1:0] hash_out_7_1,
    output logic                 hash_out_valid_filter_7_1,
    output logic [RID_WIDTH-1:0] hash_out_7_2,
    output logic                 hash_out_valid_filter_7_2,
    output logic [RID_WIDTH-1:0] hash_out_7_3,
    output logic                 hash_out_valid_filter_7_3,
    output logic [RID_WIDTH-1:0] hash_out_7_4,
    output logic                 hash_out_valid_filter_7_4,
    output logic [RID_WIDTH-1:0] hash_out_7_5,
    output logic                 hash_out_valid_filter_7_5,
    output logic [RID_WIDTH-1:0] hash_out_7_6,
    output logic                 hash_out_valid_filter_7_6,
    output logic [RID_WIDTH-1:0] hash_out_7_7,
    output logic                 hash_out_valid_filter_7_7,
    output logic [RID_WIDTH-1:0] hash_out_7_8,
    output logic                 hash_out_valid_filter_7_8,
    output logic [RID_WIDTH-1:0] hash_out_7_9,
    output logic                 hash_out_valid_filter_7_9,
    output logic [RID_WIDTH-1:0] hash_out_7_10,
    output logic                 hash_out_valid_filter_7_10,
    output logic [RID_WIDTH-1:0] hash_out_7_11,
    output logic                 hash_out_valid_filter_7_11,
    output logic [RID_WIDTH-1:0] hash_out_7_12,
    output logic                 hash_out_valid_filter_7_12,
    output logic [RID_WIDTH-1:0] hash_out_7_13,
    output logic                 hash_out_valid_filter_7_13,
    output logic [RID_WIDTH-1:0] hash_out_7_14,
    output logic                 hash_out_valid_filter_7_14,
    output logic [RID_WIDTH-1:0] hash_out_7_15,
    output logic                 hash_out_valid_filter_7_15,
    output logic                 out_new_pkt
);

//filter
logic ce;
logic [FP_DWIDTH-1:0] filter_out;
logic filter_out_valid;

//hashtable_top
logic hash_out_valid_0_0;
logic hash_out_valid_0_1;
logic hash_out_valid_0_2;
logic hash_out_valid_0_3;
logic hash_out_valid_0_4;
logic hash_out_valid_0_5;
logic hash_out_valid_0_6;
logic hash_out_valid_0_7;
logic hash_out_valid_0_8;
logic hash_out_valid_0_9;
logic hash_out_valid_0_10;
logic hash_out_valid_0_11;
logic hash_out_valid_0_12;
logic hash_out_valid_0_13;
logic hash_out_valid_0_14;
logic hash_out_valid_0_15;
logic hash_out_valid_1_0;
logic hash_out_valid_1_1;
logic hash_out_valid_1_2;
logic hash_out_valid_1_3;
logic hash_out_valid_1_4;
logic hash_out_valid_1_5;
logic hash_out_valid_1_6;
logic hash_out_valid_1_7;
logic hash_out_valid_1_8;
logic hash_out_valid_1_9;
logic hash_out_valid_1_10;
logic hash_out_valid_1_11;
logic hash_out_valid_1_12;
logic hash_out_valid_1_13;
logic hash_out_valid_1_14;
logic hash_out_valid_1_15;
logic hash_out_valid_2_0;
logic hash_out_valid_2_1;
logic hash_out_valid_2_2;
logic hash_out_valid_2_3;
logic hash_out_valid_2_4;
logic hash_out_valid_2_5;
logic hash_out_valid_2_6;
logic hash_out_valid_2_7;
logic hash_out_valid_2_8;
logic hash_out_valid_2_9;
logic hash_out_valid_2_10;
logic hash_out_valid_2_11;
logic hash_out_valid_2_12;
logic hash_out_valid_2_13;
logic hash_out_valid_2_14;
logic hash_out_valid_2_15;
logic hash_out_valid_3_0;
logic hash_out_valid_3_1;
logic hash_out_valid_3_2;
logic hash_out_valid_3_3;
logic hash_out_valid_3_4;
logic hash_out_valid_3_5;
logic hash_out_valid_3_6;
logic hash_out_valid_3_7;
logic hash_out_valid_3_8;
logic hash_out_valid_3_9;
logic hash_out_valid_3_10;
logic hash_out_valid_3_11;
logic hash_out_valid_3_12;
logic hash_out_valid_3_13;
logic hash_out_valid_3_14;
logic hash_out_valid_3_15;
logic hash_out_valid_4_0;
logic hash_out_valid_4_1;
logic hash_out_valid_4_2;
logic hash_out_valid_4_3;
logic hash_out_valid_4_4;
logic hash_out_valid_4_5;
logic hash_out_valid_4_6;
logic hash_out_valid_4_7;
logic hash_out_valid_4_8;
logic hash_out_valid_4_9;
logic hash_out_valid_4_10;
logic hash_out_valid_4_11;
logic hash_out_valid_4_12;
logic hash_out_valid_4_13;
logic hash_out_valid_4_14;
logic hash_out_valid_4_15;
logic hash_out_valid_5_0;
logic hash_out_valid_5_1;
logic hash_out_valid_5_2;
logic hash_out_valid_5_3;
logic hash_out_valid_5_4;
logic hash_out_valid_5_5;
logic hash_out_valid_5_6;
logic hash_out_valid_5_7;
logic hash_out_valid_5_8;
logic hash_out_valid_5_9;
logic hash_out_valid_5_10;
logic hash_out_valid_5_11;
logic hash_out_valid_5_12;
logic hash_out_valid_5_13;
logic hash_out_valid_5_14;
logic hash_out_valid_5_15;
logic hash_out_valid_6_0;
logic hash_out_valid_6_1;
logic hash_out_valid_6_2;
logic hash_out_valid_6_3;
logic hash_out_valid_6_4;
logic hash_out_valid_6_5;
logic hash_out_valid_6_6;
logic hash_out_valid_6_7;
logic hash_out_valid_6_8;
logic hash_out_valid_6_9;
logic hash_out_valid_6_10;
logic hash_out_valid_6_11;
logic hash_out_valid_6_12;
logic hash_out_valid_6_13;
logic hash_out_valid_6_14;
logic hash_out_valid_6_15;
logic hash_out_valid_7_0;
logic hash_out_valid_7_1;
logic hash_out_valid_7_2;
logic hash_out_valid_7_3;
logic hash_out_valid_7_4;
logic hash_out_valid_7_5;
logic hash_out_valid_7_6;
logic hash_out_valid_7_7;
logic hash_out_valid_7_8;
logic hash_out_valid_7_9;
logic hash_out_valid_7_10;
logic hash_out_valid_7_11;
logic hash_out_valid_7_12;
logic hash_out_valid_7_13;
logic hash_out_valid_7_14;
logic hash_out_valid_7_15;
logic [FP_DWIDTH-1:0] hash_in;
logic hash_in_valid;

logic new_pkt;
logic [FP_DWIDTH-1:0] filter_out_r1;
logic new_pkt_r1;
logic [FP_DWIDTH-1:0] filter_out_r2;
logic new_pkt_r2;
logic [FP_DWIDTH-1:0] filter_out_r3;
logic new_pkt_r3;
logic [FP_DWIDTH-1:0] filter_out_r4;
logic new_pkt_r4;
logic [FP_DWIDTH-1:0] filter_out_r5;
logic new_pkt_r5;
logic [FP_DWIDTH-1:0] filter_out_r6;
logic new_pkt_r6;
logic [FP_DWIDTH-1:0] filter_out_r7;
logic new_pkt_r7;
logic [FP_DWIDTH-1:0] filter_out_r8;
logic new_pkt_r8;
logic [FP_DWIDTH-1:0] filter_out_r9;
logic new_pkt_r9;
logic [FP_DWIDTH-1:0] filter_out_r10;
logic new_pkt_r10;
logic [FP_DWIDTH-1:0] filter_out_r11;
logic new_pkt_r11;
logic [FP_DWIDTH-1:0] filter_out_r12;
logic new_pkt_r12;
logic [FP_DWIDTH-1:0] filter_out_r13;
logic new_pkt_r13;
logic [FP_DWIDTH-1:0] filter_out_r14;
logic new_pkt_r14;
logic [FP_DWIDTH-1:0] filter_out_r15;
logic new_pkt_r15;
logic [FP_DWIDTH-1:0] filter_out_r16;
logic new_pkt_r16;


`ifdef DUMMY
//No match at all
assign hash_out_valid_filter_0_0 = 0;
assign hash_out_0_0 = 0;
assign hash_out_valid_filter_0_1 = 0;
assign hash_out_0_1 = 0;
assign hash_out_valid_filter_0_2 = 0;
assign hash_out_0_2 = 0;
assign hash_out_valid_filter_0_3 = 0;
assign hash_out_0_3 = 0;
assign hash_out_valid_filter_0_4 = 0;
assign hash_out_0_4 = 0;
assign hash_out_valid_filter_0_5 = 0;
assign hash_out_0_5 = 0;
assign hash_out_valid_filter_0_6 = 0;
assign hash_out_0_6 = 0;
assign hash_out_valid_filter_0_7 = 0;
assign hash_out_0_7 = 0;
assign hash_out_valid_filter_0_8 = 0;
assign hash_out_0_8 = 0;
assign hash_out_valid_filter_0_9 = 0;
assign hash_out_0_9 = 0;
assign hash_out_valid_filter_0_10 = 0;
assign hash_out_0_10 = 0;
assign hash_out_valid_filter_0_11 = 0;
assign hash_out_0_11 = 0;
assign hash_out_valid_filter_0_12 = 0;
assign hash_out_0_12 = 0;
assign hash_out_valid_filter_0_13 = 0;
assign hash_out_0_13 = 0;
assign hash_out_valid_filter_0_14 = 0;
assign hash_out_0_14 = 0;
assign hash_out_valid_filter_0_15 = 0;
assign hash_out_0_15 = 0;
assign hash_out_valid_filter_1_0 = 0;
assign hash_out_1_0 = 0;
assign hash_out_valid_filter_1_1 = 0;
assign hash_out_1_1 = 0;
assign hash_out_valid_filter_1_2 = 0;
assign hash_out_1_2 = 0;
assign hash_out_valid_filter_1_3 = 0;
assign hash_out_1_3 = 0;
assign hash_out_valid_filter_1_4 = 0;
assign hash_out_1_4 = 0;
assign hash_out_valid_filter_1_5 = 0;
assign hash_out_1_5 = 0;
assign hash_out_valid_filter_1_6 = 0;
assign hash_out_1_6 = 0;
assign hash_out_valid_filter_1_7 = 0;
assign hash_out_1_7 = 0;
assign hash_out_valid_filter_1_8 = 0;
assign hash_out_1_8 = 0;
assign hash_out_valid_filter_1_9 = 0;
assign hash_out_1_9 = 0;
assign hash_out_valid_filter_1_10 = 0;
assign hash_out_1_10 = 0;
assign hash_out_valid_filter_1_11 = 0;
assign hash_out_1_11 = 0;
assign hash_out_valid_filter_1_12 = 0;
assign hash_out_1_12 = 0;
assign hash_out_valid_filter_1_13 = 0;
assign hash_out_1_13 = 0;
assign hash_out_valid_filter_1_14 = 0;
assign hash_out_1_14 = 0;
assign hash_out_valid_filter_1_15 = 0;
assign hash_out_1_15 = 0;
assign hash_out_valid_filter_2_0 = 0;
assign hash_out_2_0 = 0;
assign hash_out_valid_filter_2_1 = 0;
assign hash_out_2_1 = 0;
assign hash_out_valid_filter_2_2 = 0;
assign hash_out_2_2 = 0;
assign hash_out_valid_filter_2_3 = 0;
assign hash_out_2_3 = 0;
assign hash_out_valid_filter_2_4 = 0;
assign hash_out_2_4 = 0;
assign hash_out_valid_filter_2_5 = 0;
assign hash_out_2_5 = 0;
assign hash_out_valid_filter_2_6 = 0;
assign hash_out_2_6 = 0;
assign hash_out_valid_filter_2_7 = 0;
assign hash_out_2_7 = 0;
assign hash_out_valid_filter_2_8 = 0;
assign hash_out_2_8 = 0;
assign hash_out_valid_filter_2_9 = 0;
assign hash_out_2_9 = 0;
assign hash_out_valid_filter_2_10 = 0;
assign hash_out_2_10 = 0;
assign hash_out_valid_filter_2_11 = 0;
assign hash_out_2_11 = 0;
assign hash_out_valid_filter_2_12 = 0;
assign hash_out_2_12 = 0;
assign hash_out_valid_filter_2_13 = 0;
assign hash_out_2_13 = 0;
assign hash_out_valid_filter_2_14 = 0;
assign hash_out_2_14 = 0;
assign hash_out_valid_filter_2_15 = 0;
assign hash_out_2_15 = 0;
assign hash_out_valid_filter_3_0 = 0;
assign hash_out_3_0 = 0;
assign hash_out_valid_filter_3_1 = 0;
assign hash_out_3_1 = 0;
assign hash_out_valid_filter_3_2 = 0;
assign hash_out_3_2 = 0;
assign hash_out_valid_filter_3_3 = 0;
assign hash_out_3_3 = 0;
assign hash_out_valid_filter_3_4 = 0;
assign hash_out_3_4 = 0;
assign hash_out_valid_filter_3_5 = 0;
assign hash_out_3_5 = 0;
assign hash_out_valid_filter_3_6 = 0;
assign hash_out_3_6 = 0;
assign hash_out_valid_filter_3_7 = 0;
assign hash_out_3_7 = 0;
assign hash_out_valid_filter_3_8 = 0;
assign hash_out_3_8 = 0;
assign hash_out_valid_filter_3_9 = 0;
assign hash_out_3_9 = 0;
assign hash_out_valid_filter_3_10 = 0;
assign hash_out_3_10 = 0;
assign hash_out_valid_filter_3_11 = 0;
assign hash_out_3_11 = 0;
assign hash_out_valid_filter_3_12 = 0;
assign hash_out_3_12 = 0;
assign hash_out_valid_filter_3_13 = 0;
assign hash_out_3_13 = 0;
assign hash_out_valid_filter_3_14 = 0;
assign hash_out_3_14 = 0;
assign hash_out_valid_filter_3_15 = 0;
assign hash_out_3_15 = 0;
assign hash_out_valid_filter_4_0 = 0;
assign hash_out_4_0 = 0;
assign hash_out_valid_filter_4_1 = 0;
assign hash_out_4_1 = 0;
assign hash_out_valid_filter_4_2 = 0;
assign hash_out_4_2 = 0;
assign hash_out_valid_filter_4_3 = 0;
assign hash_out_4_3 = 0;
assign hash_out_valid_filter_4_4 = 0;
assign hash_out_4_4 = 0;
assign hash_out_valid_filter_4_5 = 0;
assign hash_out_4_5 = 0;
assign hash_out_valid_filter_4_6 = 0;
assign hash_out_4_6 = 0;
assign hash_out_valid_filter_4_7 = 0;
assign hash_out_4_7 = 0;
assign hash_out_valid_filter_4_8 = 0;
assign hash_out_4_8 = 0;
assign hash_out_valid_filter_4_9 = 0;
assign hash_out_4_9 = 0;
assign hash_out_valid_filter_4_10 = 0;
assign hash_out_4_10 = 0;
assign hash_out_valid_filter_4_11 = 0;
assign hash_out_4_11 = 0;
assign hash_out_valid_filter_4_12 = 0;
assign hash_out_4_12 = 0;
assign hash_out_valid_filter_4_13 = 0;
assign hash_out_4_13 = 0;
assign hash_out_valid_filter_4_14 = 0;
assign hash_out_4_14 = 0;
assign hash_out_valid_filter_4_15 = 0;
assign hash_out_4_15 = 0;
assign hash_out_valid_filter_5_0 = 0;
assign hash_out_5_0 = 0;
assign hash_out_valid_filter_5_1 = 0;
assign hash_out_5_1 = 0;
assign hash_out_valid_filter_5_2 = 0;
assign hash_out_5_2 = 0;
assign hash_out_valid_filter_5_3 = 0;
assign hash_out_5_3 = 0;
assign hash_out_valid_filter_5_4 = 0;
assign hash_out_5_4 = 0;
assign hash_out_valid_filter_5_5 = 0;
assign hash_out_5_5 = 0;
assign hash_out_valid_filter_5_6 = 0;
assign hash_out_5_6 = 0;
assign hash_out_valid_filter_5_7 = 0;
assign hash_out_5_7 = 0;
assign hash_out_valid_filter_5_8 = 0;
assign hash_out_5_8 = 0;
assign hash_out_valid_filter_5_9 = 0;
assign hash_out_5_9 = 0;
assign hash_out_valid_filter_5_10 = 0;
assign hash_out_5_10 = 0;
assign hash_out_valid_filter_5_11 = 0;
assign hash_out_5_11 = 0;
assign hash_out_valid_filter_5_12 = 0;
assign hash_out_5_12 = 0;
assign hash_out_valid_filter_5_13 = 0;
assign hash_out_5_13 = 0;
assign hash_out_valid_filter_5_14 = 0;
assign hash_out_5_14 = 0;
assign hash_out_valid_filter_5_15 = 0;
assign hash_out_5_15 = 0;
assign hash_out_valid_filter_6_0 = 0;
assign hash_out_6_0 = 0;
assign hash_out_valid_filter_6_1 = 0;
assign hash_out_6_1 = 0;
assign hash_out_valid_filter_6_2 = 0;
assign hash_out_6_2 = 0;
assign hash_out_valid_filter_6_3 = 0;
assign hash_out_6_3 = 0;
assign hash_out_valid_filter_6_4 = 0;
assign hash_out_6_4 = 0;
assign hash_out_valid_filter_6_5 = 0;
assign hash_out_6_5 = 0;
assign hash_out_valid_filter_6_6 = 0;
assign hash_out_6_6 = 0;
assign hash_out_valid_filter_6_7 = 0;
assign hash_out_6_7 = 0;
assign hash_out_valid_filter_6_8 = 0;
assign hash_out_6_8 = 0;
assign hash_out_valid_filter_6_9 = 0;
assign hash_out_6_9 = 0;
assign hash_out_valid_filter_6_10 = 0;
assign hash_out_6_10 = 0;
assign hash_out_valid_filter_6_11 = 0;
assign hash_out_6_11 = 0;
assign hash_out_valid_filter_6_12 = 0;
assign hash_out_6_12 = 0;
assign hash_out_valid_filter_6_13 = 0;
assign hash_out_6_13 = 0;
assign hash_out_valid_filter_6_14 = 0;
assign hash_out_6_14 = 0;
assign hash_out_valid_filter_6_15 = 0;
assign hash_out_6_15 = 0;
assign hash_out_valid_filter_7_0 = 0;
assign hash_out_7_0 = 0;
assign hash_out_valid_filter_7_1 = 0;
assign hash_out_7_1 = 0;
assign hash_out_valid_filter_7_2 = 0;
assign hash_out_7_2 = 0;
assign hash_out_valid_filter_7_3 = 0;
assign hash_out_7_3 = 0;
assign hash_out_valid_filter_7_4 = 0;
assign hash_out_7_4 = 0;
assign hash_out_valid_filter_7_5 = 0;
assign hash_out_7_5 = 0;
assign hash_out_valid_filter_7_6 = 0;
assign hash_out_7_6 = 0;
assign hash_out_valid_filter_7_7 = 0;
assign hash_out_7_7 = 0;
assign hash_out_valid_filter_7_8 = 0;
assign hash_out_7_8 = 0;
assign hash_out_valid_filter_7_9 = 0;
assign hash_out_7_9 = 0;
assign hash_out_valid_filter_7_10 = 0;
assign hash_out_7_10 = 0;
assign hash_out_valid_filter_7_11 = 0;
assign hash_out_7_11 = 0;
assign hash_out_valid_filter_7_12 = 0;
assign hash_out_7_12 = 0;
assign hash_out_valid_filter_7_13 = 0;
assign hash_out_7_13 = 0;
assign hash_out_valid_filter_7_14 = 0;
assign hash_out_7_14 = 0;
assign hash_out_valid_filter_7_15 = 0;
assign hash_out_7_15 = 0;

assign new_pkt = in_eop & in_valid;

//Make sure all the flits of the pkts have been checked before moving it. 
always @ (posedge clk) begin
    new_pkt_r1 <= new_pkt;
    new_pkt_r2 <= new_pkt_r1;
    new_pkt_r3 <= new_pkt_r2;
    new_pkt_r4 <= new_pkt_r3;
    new_pkt_r5 <= new_pkt_r4;
    new_pkt_r6 <= new_pkt_r5;
    new_pkt_r7 <= new_pkt_r6;
    new_pkt_r8 <= new_pkt_r7;
    new_pkt_r9 <= new_pkt_r8;
    new_pkt_r10 <= new_pkt_r9;
    new_pkt_r11 <= new_pkt_r10;
    new_pkt_r12 <= new_pkt_r11;
    new_pkt_r13 <= new_pkt_r12;
    new_pkt_r14 <= new_pkt_r13;
    new_pkt_r15 <= new_pkt_r14;
    new_pkt_r16 <= new_pkt_r15;
    out_new_pkt <= new_pkt_r15;
end


`else
//Hashtable signals
assign hash_out_valid_filter_0_0 = hash_out_valid_0_0 & !filter_out_r14[0];
assign hash_out_valid_filter_0_1 = hash_out_valid_0_1 & !filter_out_r14[8];
assign hash_out_valid_filter_0_2 = hash_out_valid_0_2 & !filter_out_r14[16];
assign hash_out_valid_filter_0_3 = hash_out_valid_0_3 & !filter_out_r14[24];
assign hash_out_valid_filter_0_4 = hash_out_valid_0_4 & !filter_out_r14[32];
assign hash_out_valid_filter_0_5 = hash_out_valid_0_5 & !filter_out_r14[40];
assign hash_out_valid_filter_0_6 = hash_out_valid_0_6 & !filter_out_r14[48];
assign hash_out_valid_filter_0_7 = hash_out_valid_0_7 & !filter_out_r14[56];
assign hash_out_valid_filter_0_8 = hash_out_valid_0_8 & !filter_out_r14[64];
assign hash_out_valid_filter_0_9 = hash_out_valid_0_9 & !filter_out_r14[72];
assign hash_out_valid_filter_0_10 = hash_out_valid_0_10 & !filter_out_r14[80];
assign hash_out_valid_filter_0_11 = hash_out_valid_0_11 & !filter_out_r14[88];
assign hash_out_valid_filter_0_12 = hash_out_valid_0_12 & !filter_out_r14[96];
assign hash_out_valid_filter_0_13 = hash_out_valid_0_13 & !filter_out_r14[104];
assign hash_out_valid_filter_0_14 = hash_out_valid_0_14 & !filter_out_r14[112];
assign hash_out_valid_filter_0_15 = hash_out_valid_0_15 & !filter_out_r14[120];
assign hash_out_valid_filter_1_0 = hash_out_valid_1_0 & !filter_out_r14[1];
assign hash_out_valid_filter_1_1 = hash_out_valid_1_1 & !filter_out_r14[9];
assign hash_out_valid_filter_1_2 = hash_out_valid_1_2 & !filter_out_r14[17];
assign hash_out_valid_filter_1_3 = hash_out_valid_1_3 & !filter_out_r14[25];
assign hash_out_valid_filter_1_4 = hash_out_valid_1_4 & !filter_out_r14[33];
assign hash_out_valid_filter_1_5 = hash_out_valid_1_5 & !filter_out_r14[41];
assign hash_out_valid_filter_1_6 = hash_out_valid_1_6 & !filter_out_r14[49];
assign hash_out_valid_filter_1_7 = hash_out_valid_1_7 & !filter_out_r14[57];
assign hash_out_valid_filter_1_8 = hash_out_valid_1_8 & !filter_out_r14[65];
assign hash_out_valid_filter_1_9 = hash_out_valid_1_9 & !filter_out_r14[73];
assign hash_out_valid_filter_1_10 = hash_out_valid_1_10 & !filter_out_r14[81];
assign hash_out_valid_filter_1_11 = hash_out_valid_1_11 & !filter_out_r14[89];
assign hash_out_valid_filter_1_12 = hash_out_valid_1_12 & !filter_out_r14[97];
assign hash_out_valid_filter_1_13 = hash_out_valid_1_13 & !filter_out_r14[105];
assign hash_out_valid_filter_1_14 = hash_out_valid_1_14 & !filter_out_r14[113];
assign hash_out_valid_filter_1_15 = hash_out_valid_1_15 & !filter_out_r14[121];
assign hash_out_valid_filter_2_0 = hash_out_valid_2_0 & !filter_out_r14[2];
assign hash_out_valid_filter_2_1 = hash_out_valid_2_1 & !filter_out_r14[10];
assign hash_out_valid_filter_2_2 = hash_out_valid_2_2 & !filter_out_r14[18];
assign hash_out_valid_filter_2_3 = hash_out_valid_2_3 & !filter_out_r14[26];
assign hash_out_valid_filter_2_4 = hash_out_valid_2_4 & !filter_out_r14[34];
assign hash_out_valid_filter_2_5 = hash_out_valid_2_5 & !filter_out_r14[42];
assign hash_out_valid_filter_2_6 = hash_out_valid_2_6 & !filter_out_r14[50];
assign hash_out_valid_filter_2_7 = hash_out_valid_2_7 & !filter_out_r14[58];
assign hash_out_valid_filter_2_8 = hash_out_valid_2_8 & !filter_out_r14[66];
assign hash_out_valid_filter_2_9 = hash_out_valid_2_9 & !filter_out_r14[74];
assign hash_out_valid_filter_2_10 = hash_out_valid_2_10 & !filter_out_r14[82];
assign hash_out_valid_filter_2_11 = hash_out_valid_2_11 & !filter_out_r14[90];
assign hash_out_valid_filter_2_12 = hash_out_valid_2_12 & !filter_out_r14[98];
assign hash_out_valid_filter_2_13 = hash_out_valid_2_13 & !filter_out_r14[106];
assign hash_out_valid_filter_2_14 = hash_out_valid_2_14 & !filter_out_r14[114];
assign hash_out_valid_filter_2_15 = hash_out_valid_2_15 & !filter_out_r14[122];
assign hash_out_valid_filter_3_0 = hash_out_valid_3_0 & !filter_out_r14[3];
assign hash_out_valid_filter_3_1 = hash_out_valid_3_1 & !filter_out_r14[11];
assign hash_out_valid_filter_3_2 = hash_out_valid_3_2 & !filter_out_r14[19];
assign hash_out_valid_filter_3_3 = hash_out_valid_3_3 & !filter_out_r14[27];
assign hash_out_valid_filter_3_4 = hash_out_valid_3_4 & !filter_out_r14[35];
assign hash_out_valid_filter_3_5 = hash_out_valid_3_5 & !filter_out_r14[43];
assign hash_out_valid_filter_3_6 = hash_out_valid_3_6 & !filter_out_r14[51];
assign hash_out_valid_filter_3_7 = hash_out_valid_3_7 & !filter_out_r14[59];
assign hash_out_valid_filter_3_8 = hash_out_valid_3_8 & !filter_out_r14[67];
assign hash_out_valid_filter_3_9 = hash_out_valid_3_9 & !filter_out_r14[75];
assign hash_out_valid_filter_3_10 = hash_out_valid_3_10 & !filter_out_r14[83];
assign hash_out_valid_filter_3_11 = hash_out_valid_3_11 & !filter_out_r14[91];
assign hash_out_valid_filter_3_12 = hash_out_valid_3_12 & !filter_out_r14[99];
assign hash_out_valid_filter_3_13 = hash_out_valid_3_13 & !filter_out_r14[107];
assign hash_out_valid_filter_3_14 = hash_out_valid_3_14 & !filter_out_r14[115];
assign hash_out_valid_filter_3_15 = hash_out_valid_3_15 & !filter_out_r14[123];
assign hash_out_valid_filter_4_0 = hash_out_valid_4_0 & !filter_out_r14[4];
assign hash_out_valid_filter_4_1 = hash_out_valid_4_1 & !filter_out_r14[12];
assign hash_out_valid_filter_4_2 = hash_out_valid_4_2 & !filter_out_r14[20];
assign hash_out_valid_filter_4_3 = hash_out_valid_4_3 & !filter_out_r14[28];
assign hash_out_valid_filter_4_4 = hash_out_valid_4_4 & !filter_out_r14[36];
assign hash_out_valid_filter_4_5 = hash_out_valid_4_5 & !filter_out_r14[44];
assign hash_out_valid_filter_4_6 = hash_out_valid_4_6 & !filter_out_r14[52];
assign hash_out_valid_filter_4_7 = hash_out_valid_4_7 & !filter_out_r14[60];
assign hash_out_valid_filter_4_8 = hash_out_valid_4_8 & !filter_out_r14[68];
assign hash_out_valid_filter_4_9 = hash_out_valid_4_9 & !filter_out_r14[76];
assign hash_out_valid_filter_4_10 = hash_out_valid_4_10 & !filter_out_r14[84];
assign hash_out_valid_filter_4_11 = hash_out_valid_4_11 & !filter_out_r14[92];
assign hash_out_valid_filter_4_12 = hash_out_valid_4_12 & !filter_out_r14[100];
assign hash_out_valid_filter_4_13 = hash_out_valid_4_13 & !filter_out_r14[108];
assign hash_out_valid_filter_4_14 = hash_out_valid_4_14 & !filter_out_r14[116];
assign hash_out_valid_filter_4_15 = hash_out_valid_4_15 & !filter_out_r14[124];
assign hash_out_valid_filter_5_0 = hash_out_valid_5_0 & !filter_out_r14[5];
assign hash_out_valid_filter_5_1 = hash_out_valid_5_1 & !filter_out_r14[13];
assign hash_out_valid_filter_5_2 = hash_out_valid_5_2 & !filter_out_r14[21];
assign hash_out_valid_filter_5_3 = hash_out_valid_5_3 & !filter_out_r14[29];
assign hash_out_valid_filter_5_4 = hash_out_valid_5_4 & !filter_out_r14[37];
assign hash_out_valid_filter_5_5 = hash_out_valid_5_5 & !filter_out_r14[45];
assign hash_out_valid_filter_5_6 = hash_out_valid_5_6 & !filter_out_r14[53];
assign hash_out_valid_filter_5_7 = hash_out_valid_5_7 & !filter_out_r14[61];
assign hash_out_valid_filter_5_8 = hash_out_valid_5_8 & !filter_out_r14[69];
assign hash_out_valid_filter_5_9 = hash_out_valid_5_9 & !filter_out_r14[77];
assign hash_out_valid_filter_5_10 = hash_out_valid_5_10 & !filter_out_r14[85];
assign hash_out_valid_filter_5_11 = hash_out_valid_5_11 & !filter_out_r14[93];
assign hash_out_valid_filter_5_12 = hash_out_valid_5_12 & !filter_out_r14[101];
assign hash_out_valid_filter_5_13 = hash_out_valid_5_13 & !filter_out_r14[109];
assign hash_out_valid_filter_5_14 = hash_out_valid_5_14 & !filter_out_r14[117];
assign hash_out_valid_filter_5_15 = hash_out_valid_5_15 & !filter_out_r14[125];
assign hash_out_valid_filter_6_0 = hash_out_valid_6_0 & !filter_out_r14[6];
assign hash_out_valid_filter_6_1 = hash_out_valid_6_1 & !filter_out_r14[14];
assign hash_out_valid_filter_6_2 = hash_out_valid_6_2 & !filter_out_r14[22];
assign hash_out_valid_filter_6_3 = hash_out_valid_6_3 & !filter_out_r14[30];
assign hash_out_valid_filter_6_4 = hash_out_valid_6_4 & !filter_out_r14[38];
assign hash_out_valid_filter_6_5 = hash_out_valid_6_5 & !filter_out_r14[46];
assign hash_out_valid_filter_6_6 = hash_out_valid_6_6 & !filter_out_r14[54];
assign hash_out_valid_filter_6_7 = hash_out_valid_6_7 & !filter_out_r14[62];
assign hash_out_valid_filter_6_8 = hash_out_valid_6_8 & !filter_out_r14[70];
assign hash_out_valid_filter_6_9 = hash_out_valid_6_9 & !filter_out_r14[78];
assign hash_out_valid_filter_6_10 = hash_out_valid_6_10 & !filter_out_r14[86];
assign hash_out_valid_filter_6_11 = hash_out_valid_6_11 & !filter_out_r14[94];
assign hash_out_valid_filter_6_12 = hash_out_valid_6_12 & !filter_out_r14[102];
assign hash_out_valid_filter_6_13 = hash_out_valid_6_13 & !filter_out_r14[110];
assign hash_out_valid_filter_6_14 = hash_out_valid_6_14 & !filter_out_r14[118];
assign hash_out_valid_filter_6_15 = hash_out_valid_6_15 & !filter_out_r14[126];
assign hash_out_valid_filter_7_0 = hash_out_valid_7_0 & !filter_out_r14[7];
assign hash_out_valid_filter_7_1 = hash_out_valid_7_1 & !filter_out_r14[15];
assign hash_out_valid_filter_7_2 = hash_out_valid_7_2 & !filter_out_r14[23];
assign hash_out_valid_filter_7_3 = hash_out_valid_7_3 & !filter_out_r14[31];
assign hash_out_valid_filter_7_4 = hash_out_valid_7_4 & !filter_out_r14[39];
assign hash_out_valid_filter_7_5 = hash_out_valid_7_5 & !filter_out_r14[47];
assign hash_out_valid_filter_7_6 = hash_out_valid_7_6 & !filter_out_r14[55];
assign hash_out_valid_filter_7_7 = hash_out_valid_7_7 & !filter_out_r14[63];
assign hash_out_valid_filter_7_8 = hash_out_valid_7_8 & !filter_out_r14[71];
assign hash_out_valid_filter_7_9 = hash_out_valid_7_9 & !filter_out_r14[79];
assign hash_out_valid_filter_7_10 = hash_out_valid_7_10 & !filter_out_r14[87];
assign hash_out_valid_filter_7_11 = hash_out_valid_7_11 & !filter_out_r14[95];
assign hash_out_valid_filter_7_12 = hash_out_valid_7_12 & !filter_out_r14[103];
assign hash_out_valid_filter_7_13 = hash_out_valid_7_13 & !filter_out_r14[111];
assign hash_out_valid_filter_7_14 = hash_out_valid_7_14 & !filter_out_r14[119];
assign hash_out_valid_filter_7_15 = hash_out_valid_7_15 & !filter_out_r14[127];

assign new_pkt = in_eop & in_valid;

//Make sure all the flits of the pkts have been checked before moving it. 
always @ (posedge clk) begin
    new_pkt_r1 <= new_pkt;
    new_pkt_r2 <= new_pkt_r1;
    new_pkt_r3 <= new_pkt_r2;
    new_pkt_r4 <= new_pkt_r3;
    new_pkt_r5 <= new_pkt_r4;
    new_pkt_r6 <= new_pkt_r5;
    new_pkt_r7 <= new_pkt_r6;
    new_pkt_r8 <= new_pkt_r7;
    new_pkt_r9 <= new_pkt_r8;
    new_pkt_r10 <= new_pkt_r9;
    new_pkt_r11 <= new_pkt_r10;
    new_pkt_r12 <= new_pkt_r11;
    new_pkt_r13 <= new_pkt_r12;
    new_pkt_r14 <= new_pkt_r13;
    new_pkt_r15 <= new_pkt_r14;
    new_pkt_r16 <= new_pkt_r15;
    out_new_pkt <= new_pkt_r15;
end

//consistent with the filter 
always @ (posedge clk) begin
    hash_in <= in_data;
    hash_in_valid <= in_valid;
end

//Comb of filter and hashtable
always @ (posedge clk) begin
    if(filter_out_valid) begin
        filter_out_r1 <= filter_out;
    end else begin
        filter_out_r1 <= {FP_DWIDTH{1'b1}};
    end
    filter_out_r2 <= filter_out_r1;
    filter_out_r3 <= filter_out_r2;
    filter_out_r4 <= filter_out_r3;
    filter_out_r5 <= filter_out_r4;
    filter_out_r6 <= filter_out_r5;
    filter_out_r7 <= filter_out_r6;
    filter_out_r8 <= filter_out_r7;
    filter_out_r9 <= filter_out_r8;
    filter_out_r10 <= filter_out_r9;
    filter_out_r11 <= filter_out_r10;
    filter_out_r12 <= filter_out_r11;
    filter_out_r13 <= filter_out_r12;
    filter_out_r14 <= filter_out_r13;
end


//Instantiation
first_filter filter_inst(
    .clk(clk),
    .rst(rst),
    .in_data    (in_data),
    .in_valid   (in_valid),
    .in_sop     (in_sop),
    .in_eop     (in_eop),
    .in_empty   (in_empty),
    .out_data   (filter_out),
    .out_valid  (filter_out_valid)
);

hashtable_top hashtable_top_inst (
    .clk (clk),
    .dout_0_0 (hash_out_0_0),
    .dout_valid_0_0 (hash_out_valid_0_0),
    .dout_0_1 (hash_out_0_1),
    .dout_valid_0_1 (hash_out_valid_0_1),
    .dout_0_2 (hash_out_0_2),
    .dout_valid_0_2 (hash_out_valid_0_2),
    .dout_0_3 (hash_out_0_3),
    .dout_valid_0_3 (hash_out_valid_0_3),
    .dout_0_4 (hash_out_0_4),
    .dout_valid_0_4 (hash_out_valid_0_4),
    .dout_0_5 (hash_out_0_5),
    .dout_valid_0_5 (hash_out_valid_0_5),
    .dout_0_6 (hash_out_0_6),
    .dout_valid_0_6 (hash_out_valid_0_6),
    .dout_0_7 (hash_out_0_7),
    .dout_valid_0_7 (hash_out_valid_0_7),
    .dout_0_8 (hash_out_0_8),
    .dout_valid_0_8 (hash_out_valid_0_8),
    .dout_0_9 (hash_out_0_9),
    .dout_valid_0_9 (hash_out_valid_0_9),
    .dout_0_10 (hash_out_0_10),
    .dout_valid_0_10 (hash_out_valid_0_10),
    .dout_0_11 (hash_out_0_11),
    .dout_valid_0_11 (hash_out_valid_0_11),
    .dout_0_12 (hash_out_0_12),
    .dout_valid_0_12 (hash_out_valid_0_12),
    .dout_0_13 (hash_out_0_13),
    .dout_valid_0_13 (hash_out_valid_0_13),
    .dout_0_14 (hash_out_0_14),
    .dout_valid_0_14 (hash_out_valid_0_14),
    .dout_0_15 (hash_out_0_15),
    .dout_valid_0_15 (hash_out_valid_0_15),
    .dout_1_0 (hash_out_1_0),
    .dout_valid_1_0 (hash_out_valid_1_0),
    .dout_1_1 (hash_out_1_1),
    .dout_valid_1_1 (hash_out_valid_1_1),
    .dout_1_2 (hash_out_1_2),
    .dout_valid_1_2 (hash_out_valid_1_2),
    .dout_1_3 (hash_out_1_3),
    .dout_valid_1_3 (hash_out_valid_1_3),
    .dout_1_4 (hash_out_1_4),
    .dout_valid_1_4 (hash_out_valid_1_4),
    .dout_1_5 (hash_out_1_5),
    .dout_valid_1_5 (hash_out_valid_1_5),
    .dout_1_6 (hash_out_1_6),
    .dout_valid_1_6 (hash_out_valid_1_6),
    .dout_1_7 (hash_out_1_7),
    .dout_valid_1_7 (hash_out_valid_1_7),
    .dout_1_8 (hash_out_1_8),
    .dout_valid_1_8 (hash_out_valid_1_8),
    .dout_1_9 (hash_out_1_9),
    .dout_valid_1_9 (hash_out_valid_1_9),
    .dout_1_10 (hash_out_1_10),
    .dout_valid_1_10 (hash_out_valid_1_10),
    .dout_1_11 (hash_out_1_11),
    .dout_valid_1_11 (hash_out_valid_1_11),
    .dout_1_12 (hash_out_1_12),
    .dout_valid_1_12 (hash_out_valid_1_12),
    .dout_1_13 (hash_out_1_13),
    .dout_valid_1_13 (hash_out_valid_1_13),
    .dout_1_14 (hash_out_1_14),
    .dout_valid_1_14 (hash_out_valid_1_14),
    .dout_1_15 (hash_out_1_15),
    .dout_valid_1_15 (hash_out_valid_1_15),
    .dout_2_0 (hash_out_2_0),
    .dout_valid_2_0 (hash_out_valid_2_0),
    .dout_2_1 (hash_out_2_1),
    .dout_valid_2_1 (hash_out_valid_2_1),
    .dout_2_2 (hash_out_2_2),
    .dout_valid_2_2 (hash_out_valid_2_2),
    .dout_2_3 (hash_out_2_3),
    .dout_valid_2_3 (hash_out_valid_2_3),
    .dout_2_4 (hash_out_2_4),
    .dout_valid_2_4 (hash_out_valid_2_4),
    .dout_2_5 (hash_out_2_5),
    .dout_valid_2_5 (hash_out_valid_2_5),
    .dout_2_6 (hash_out_2_6),
    .dout_valid_2_6 (hash_out_valid_2_6),
    .dout_2_7 (hash_out_2_7),
    .dout_valid_2_7 (hash_out_valid_2_7),
    .dout_2_8 (hash_out_2_8),
    .dout_valid_2_8 (hash_out_valid_2_8),
    .dout_2_9 (hash_out_2_9),
    .dout_valid_2_9 (hash_out_valid_2_9),
    .dout_2_10 (hash_out_2_10),
    .dout_valid_2_10 (hash_out_valid_2_10),
    .dout_2_11 (hash_out_2_11),
    .dout_valid_2_11 (hash_out_valid_2_11),
    .dout_2_12 (hash_out_2_12),
    .dout_valid_2_12 (hash_out_valid_2_12),
    .dout_2_13 (hash_out_2_13),
    .dout_valid_2_13 (hash_out_valid_2_13),
    .dout_2_14 (hash_out_2_14),
    .dout_valid_2_14 (hash_out_valid_2_14),
    .dout_2_15 (hash_out_2_15),
    .dout_valid_2_15 (hash_out_valid_2_15),
    .dout_3_0 (hash_out_3_0),
    .dout_valid_3_0 (hash_out_valid_3_0),
    .dout_3_1 (hash_out_3_1),
    .dout_valid_3_1 (hash_out_valid_3_1),
    .dout_3_2 (hash_out_3_2),
    .dout_valid_3_2 (hash_out_valid_3_2),
    .dout_3_3 (hash_out_3_3),
    .dout_valid_3_3 (hash_out_valid_3_3),
    .dout_3_4 (hash_out_3_4),
    .dout_valid_3_4 (hash_out_valid_3_4),
    .dout_3_5 (hash_out_3_5),
    .dout_valid_3_5 (hash_out_valid_3_5),
    .dout_3_6 (hash_out_3_6),
    .dout_valid_3_6 (hash_out_valid_3_6),
    .dout_3_7 (hash_out_3_7),
    .dout_valid_3_7 (hash_out_valid_3_7),
    .dout_3_8 (hash_out_3_8),
    .dout_valid_3_8 (hash_out_valid_3_8),
    .dout_3_9 (hash_out_3_9),
    .dout_valid_3_9 (hash_out_valid_3_9),
    .dout_3_10 (hash_out_3_10),
    .dout_valid_3_10 (hash_out_valid_3_10),
    .dout_3_11 (hash_out_3_11),
    .dout_valid_3_11 (hash_out_valid_3_11),
    .dout_3_12 (hash_out_3_12),
    .dout_valid_3_12 (hash_out_valid_3_12),
    .dout_3_13 (hash_out_3_13),
    .dout_valid_3_13 (hash_out_valid_3_13),
    .dout_3_14 (hash_out_3_14),
    .dout_valid_3_14 (hash_out_valid_3_14),
    .dout_3_15 (hash_out_3_15),
    .dout_valid_3_15 (hash_out_valid_3_15),
    .dout_4_0 (hash_out_4_0),
    .dout_valid_4_0 (hash_out_valid_4_0),
    .dout_4_1 (hash_out_4_1),
    .dout_valid_4_1 (hash_out_valid_4_1),
    .dout_4_2 (hash_out_4_2),
    .dout_valid_4_2 (hash_out_valid_4_2),
    .dout_4_3 (hash_out_4_3),
    .dout_valid_4_3 (hash_out_valid_4_3),
    .dout_4_4 (hash_out_4_4),
    .dout_valid_4_4 (hash_out_valid_4_4),
    .dout_4_5 (hash_out_4_5),
    .dout_valid_4_5 (hash_out_valid_4_5),
    .dout_4_6 (hash_out_4_6),
    .dout_valid_4_6 (hash_out_valid_4_6),
    .dout_4_7 (hash_out_4_7),
    .dout_valid_4_7 (hash_out_valid_4_7),
    .dout_4_8 (hash_out_4_8),
    .dout_valid_4_8 (hash_out_valid_4_8),
    .dout_4_9 (hash_out_4_9),
    .dout_valid_4_9 (hash_out_valid_4_9),
    .dout_4_10 (hash_out_4_10),
    .dout_valid_4_10 (hash_out_valid_4_10),
    .dout_4_11 (hash_out_4_11),
    .dout_valid_4_11 (hash_out_valid_4_11),
    .dout_4_12 (hash_out_4_12),
    .dout_valid_4_12 (hash_out_valid_4_12),
    .dout_4_13 (hash_out_4_13),
    .dout_valid_4_13 (hash_out_valid_4_13),
    .dout_4_14 (hash_out_4_14),
    .dout_valid_4_14 (hash_out_valid_4_14),
    .dout_4_15 (hash_out_4_15),
    .dout_valid_4_15 (hash_out_valid_4_15),
    .dout_5_0 (hash_out_5_0),
    .dout_valid_5_0 (hash_out_valid_5_0),
    .dout_5_1 (hash_out_5_1),
    .dout_valid_5_1 (hash_out_valid_5_1),
    .dout_5_2 (hash_out_5_2),
    .dout_valid_5_2 (hash_out_valid_5_2),
    .dout_5_3 (hash_out_5_3),
    .dout_valid_5_3 (hash_out_valid_5_3),
    .dout_5_4 (hash_out_5_4),
    .dout_valid_5_4 (hash_out_valid_5_4),
    .dout_5_5 (hash_out_5_5),
    .dout_valid_5_5 (hash_out_valid_5_5),
    .dout_5_6 (hash_out_5_6),
    .dout_valid_5_6 (hash_out_valid_5_6),
    .dout_5_7 (hash_out_5_7),
    .dout_valid_5_7 (hash_out_valid_5_7),
    .dout_5_8 (hash_out_5_8),
    .dout_valid_5_8 (hash_out_valid_5_8),
    .dout_5_9 (hash_out_5_9),
    .dout_valid_5_9 (hash_out_valid_5_9),
    .dout_5_10 (hash_out_5_10),
    .dout_valid_5_10 (hash_out_valid_5_10),
    .dout_5_11 (hash_out_5_11),
    .dout_valid_5_11 (hash_out_valid_5_11),
    .dout_5_12 (hash_out_5_12),
    .dout_valid_5_12 (hash_out_valid_5_12),
    .dout_5_13 (hash_out_5_13),
    .dout_valid_5_13 (hash_out_valid_5_13),
    .dout_5_14 (hash_out_5_14),
    .dout_valid_5_14 (hash_out_valid_5_14),
    .dout_5_15 (hash_out_5_15),
    .dout_valid_5_15 (hash_out_valid_5_15),
    .dout_6_0 (hash_out_6_0),
    .dout_valid_6_0 (hash_out_valid_6_0),
    .dout_6_1 (hash_out_6_1),
    .dout_valid_6_1 (hash_out_valid_6_1),
    .dout_6_2 (hash_out_6_2),
    .dout_valid_6_2 (hash_out_valid_6_2),
    .dout_6_3 (hash_out_6_3),
    .dout_valid_6_3 (hash_out_valid_6_3),
    .dout_6_4 (hash_out_6_4),
    .dout_valid_6_4 (hash_out_valid_6_4),
    .dout_6_5 (hash_out_6_5),
    .dout_valid_6_5 (hash_out_valid_6_5),
    .dout_6_6 (hash_out_6_6),
    .dout_valid_6_6 (hash_out_valid_6_6),
    .dout_6_7 (hash_out_6_7),
    .dout_valid_6_7 (hash_out_valid_6_7),
    .dout_6_8 (hash_out_6_8),
    .dout_valid_6_8 (hash_out_valid_6_8),
    .dout_6_9 (hash_out_6_9),
    .dout_valid_6_9 (hash_out_valid_6_9),
    .dout_6_10 (hash_out_6_10),
    .dout_valid_6_10 (hash_out_valid_6_10),
    .dout_6_11 (hash_out_6_11),
    .dout_valid_6_11 (hash_out_valid_6_11),
    .dout_6_12 (hash_out_6_12),
    .dout_valid_6_12 (hash_out_valid_6_12),
    .dout_6_13 (hash_out_6_13),
    .dout_valid_6_13 (hash_out_valid_6_13),
    .dout_6_14 (hash_out_6_14),
    .dout_valid_6_14 (hash_out_valid_6_14),
    .dout_6_15 (hash_out_6_15),
    .dout_valid_6_15 (hash_out_valid_6_15),
    .dout_7_0 (hash_out_7_0),
    .dout_valid_7_0 (hash_out_valid_7_0),
    .dout_7_1 (hash_out_7_1),
    .dout_valid_7_1 (hash_out_valid_7_1),
    .dout_7_2 (hash_out_7_2),
    .dout_valid_7_2 (hash_out_valid_7_2),
    .dout_7_3 (hash_out_7_3),
    .dout_valid_7_3 (hash_out_valid_7_3),
    .dout_7_4 (hash_out_7_4),
    .dout_valid_7_4 (hash_out_valid_7_4),
    .dout_7_5 (hash_out_7_5),
    .dout_valid_7_5 (hash_out_valid_7_5),
    .dout_7_6 (hash_out_7_6),
    .dout_valid_7_6 (hash_out_valid_7_6),
    .dout_7_7 (hash_out_7_7),
    .dout_valid_7_7 (hash_out_valid_7_7),
    .dout_7_8 (hash_out_7_8),
    .dout_valid_7_8 (hash_out_valid_7_8),
    .dout_7_9 (hash_out_7_9),
    .dout_valid_7_9 (hash_out_valid_7_9),
    .dout_7_10 (hash_out_7_10),
    .dout_valid_7_10 (hash_out_valid_7_10),
    .dout_7_11 (hash_out_7_11),
    .dout_valid_7_11 (hash_out_valid_7_11),
    .dout_7_12 (hash_out_7_12),
    .dout_valid_7_12 (hash_out_valid_7_12),
    .dout_7_13 (hash_out_7_13),
    .dout_valid_7_13 (hash_out_valid_7_13),
    .dout_7_14 (hash_out_7_14),
    .dout_valid_7_14 (hash_out_valid_7_14),
    .dout_7_15 (hash_out_7_15),
    .dout_valid_7_15 (hash_out_valid_7_15),
    .din (hash_in),
    .din_valid (hash_in_valid)
);

`endif
endmodule