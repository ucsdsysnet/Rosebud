`include "struct_s.sv"
module string_matcher (
    clk,
    rst,
    in_data,
    in_valid,
    in_sop,
    in_eop,
    in_empty,
    in_ready,
    out_data,
    out_valid,
    out_almost_full,
    out_last
);

input clk;
input rst;
input [255:0] in_data;
input in_valid;
input in_sop;
input in_eop;
input [4:0] in_empty;
output logic in_ready;
output logic [127:0] out_data;
output logic out_valid;
output logic out_last;
input out_almost_full;

logic [255:0] in_data_r1;
logic [255:0] in_data_r2;
logic         in_valid_r1;
logic         in_valid_r2;
logic         in_sop_r1;
logic         in_sop_r2;
logic         in_eop_r1;
logic         in_eop_r2;
logic [4:0]   in_empty_r1;
logic [4:0]   in_empty_r2;

logic [RID_WIDTH-1:0] hash_out_0_0;
logic hash_out_valid_filter_0_0;
rule_s_t din_0_0;
rule_s_t din_0_0_r1;
rule_s_t din_0_0_r2;
logic din_valid_0_0;
logic din_valid_0_0_r1;
logic din_valid_0_0_r2;
logic [2:0] din_valid_0_0_r;
logic din_ready_0_0;
logic din_almost_full_0_0;
logic [RID_WIDTH-1:0] hash_out_0_1;
logic hash_out_valid_filter_0_1;
rule_s_t din_0_1;
rule_s_t din_0_1_r1;
rule_s_t din_0_1_r2;
logic din_valid_0_1;
logic din_valid_0_1_r1;
logic din_valid_0_1_r2;
logic [2:0] din_valid_0_1_r;
logic din_ready_0_1;
logic din_almost_full_0_1;
logic [RID_WIDTH-1:0] hash_out_0_2;
logic hash_out_valid_filter_0_2;
rule_s_t din_0_2;
rule_s_t din_0_2_r1;
rule_s_t din_0_2_r2;
logic din_valid_0_2;
logic din_valid_0_2_r1;
logic din_valid_0_2_r2;
logic [2:0] din_valid_0_2_r;
logic din_ready_0_2;
logic din_almost_full_0_2;
logic [RID_WIDTH-1:0] hash_out_0_3;
logic hash_out_valid_filter_0_3;
rule_s_t din_0_3;
rule_s_t din_0_3_r1;
rule_s_t din_0_3_r2;
logic din_valid_0_3;
logic din_valid_0_3_r1;
logic din_valid_0_3_r2;
logic [2:0] din_valid_0_3_r;
logic din_ready_0_3;
logic din_almost_full_0_3;
logic [RID_WIDTH-1:0] hash_out_0_4;
logic hash_out_valid_filter_0_4;
rule_s_t din_0_4;
rule_s_t din_0_4_r1;
rule_s_t din_0_4_r2;
logic din_valid_0_4;
logic din_valid_0_4_r1;
logic din_valid_0_4_r2;
logic [2:0] din_valid_0_4_r;
logic din_ready_0_4;
logic din_almost_full_0_4;
logic [RID_WIDTH-1:0] hash_out_0_5;
logic hash_out_valid_filter_0_5;
rule_s_t din_0_5;
rule_s_t din_0_5_r1;
rule_s_t din_0_5_r2;
logic din_valid_0_5;
logic din_valid_0_5_r1;
logic din_valid_0_5_r2;
logic [2:0] din_valid_0_5_r;
logic din_ready_0_5;
logic din_almost_full_0_5;
logic [RID_WIDTH-1:0] hash_out_0_6;
logic hash_out_valid_filter_0_6;
rule_s_t din_0_6;
rule_s_t din_0_6_r1;
rule_s_t din_0_6_r2;
logic din_valid_0_6;
logic din_valid_0_6_r1;
logic din_valid_0_6_r2;
logic [2:0] din_valid_0_6_r;
logic din_ready_0_6;
logic din_almost_full_0_6;
logic [RID_WIDTH-1:0] hash_out_0_7;
logic hash_out_valid_filter_0_7;
rule_s_t din_0_7;
rule_s_t din_0_7_r1;
rule_s_t din_0_7_r2;
logic din_valid_0_7;
logic din_valid_0_7_r1;
logic din_valid_0_7_r2;
logic [2:0] din_valid_0_7_r;
logic din_ready_0_7;
logic din_almost_full_0_7;
logic [RID_WIDTH-1:0] hash_out_1_0;
logic hash_out_valid_filter_1_0;
rule_s_t din_1_0;
rule_s_t din_1_0_r1;
rule_s_t din_1_0_r2;
logic din_valid_1_0;
logic din_valid_1_0_r1;
logic din_valid_1_0_r2;
logic [2:0] din_valid_1_0_r;
logic din_ready_1_0;
logic din_almost_full_1_0;
logic [RID_WIDTH-1:0] hash_out_1_1;
logic hash_out_valid_filter_1_1;
rule_s_t din_1_1;
rule_s_t din_1_1_r1;
rule_s_t din_1_1_r2;
logic din_valid_1_1;
logic din_valid_1_1_r1;
logic din_valid_1_1_r2;
logic [2:0] din_valid_1_1_r;
logic din_ready_1_1;
logic din_almost_full_1_1;
logic [RID_WIDTH-1:0] hash_out_1_2;
logic hash_out_valid_filter_1_2;
rule_s_t din_1_2;
rule_s_t din_1_2_r1;
rule_s_t din_1_2_r2;
logic din_valid_1_2;
logic din_valid_1_2_r1;
logic din_valid_1_2_r2;
logic [2:0] din_valid_1_2_r;
logic din_ready_1_2;
logic din_almost_full_1_2;
logic [RID_WIDTH-1:0] hash_out_1_3;
logic hash_out_valid_filter_1_3;
rule_s_t din_1_3;
rule_s_t din_1_3_r1;
rule_s_t din_1_3_r2;
logic din_valid_1_3;
logic din_valid_1_3_r1;
logic din_valid_1_3_r2;
logic [2:0] din_valid_1_3_r;
logic din_ready_1_3;
logic din_almost_full_1_3;
logic [RID_WIDTH-1:0] hash_out_1_4;
logic hash_out_valid_filter_1_4;
rule_s_t din_1_4;
rule_s_t din_1_4_r1;
rule_s_t din_1_4_r2;
logic din_valid_1_4;
logic din_valid_1_4_r1;
logic din_valid_1_4_r2;
logic [2:0] din_valid_1_4_r;
logic din_ready_1_4;
logic din_almost_full_1_4;
logic [RID_WIDTH-1:0] hash_out_1_5;
logic hash_out_valid_filter_1_5;
rule_s_t din_1_5;
rule_s_t din_1_5_r1;
rule_s_t din_1_5_r2;
logic din_valid_1_5;
logic din_valid_1_5_r1;
logic din_valid_1_5_r2;
logic [2:0] din_valid_1_5_r;
logic din_ready_1_5;
logic din_almost_full_1_5;
logic [RID_WIDTH-1:0] hash_out_1_6;
logic hash_out_valid_filter_1_6;
rule_s_t din_1_6;
rule_s_t din_1_6_r1;
rule_s_t din_1_6_r2;
logic din_valid_1_6;
logic din_valid_1_6_r1;
logic din_valid_1_6_r2;
logic [2:0] din_valid_1_6_r;
logic din_ready_1_6;
logic din_almost_full_1_6;
logic [RID_WIDTH-1:0] hash_out_1_7;
logic hash_out_valid_filter_1_7;
rule_s_t din_1_7;
rule_s_t din_1_7_r1;
rule_s_t din_1_7_r2;
logic din_valid_1_7;
logic din_valid_1_7_r1;
logic din_valid_1_7_r2;
logic [2:0] din_valid_1_7_r;
logic din_ready_1_7;
logic din_almost_full_1_7;
logic [RID_WIDTH-1:0] hash_out_2_0;
logic hash_out_valid_filter_2_0;
rule_s_t din_2_0;
rule_s_t din_2_0_r1;
rule_s_t din_2_0_r2;
logic din_valid_2_0;
logic din_valid_2_0_r1;
logic din_valid_2_0_r2;
logic [2:0] din_valid_2_0_r;
logic din_ready_2_0;
logic din_almost_full_2_0;
logic [RID_WIDTH-1:0] hash_out_2_1;
logic hash_out_valid_filter_2_1;
rule_s_t din_2_1;
rule_s_t din_2_1_r1;
rule_s_t din_2_1_r2;
logic din_valid_2_1;
logic din_valid_2_1_r1;
logic din_valid_2_1_r2;
logic [2:0] din_valid_2_1_r;
logic din_ready_2_1;
logic din_almost_full_2_1;
logic [RID_WIDTH-1:0] hash_out_2_2;
logic hash_out_valid_filter_2_2;
rule_s_t din_2_2;
rule_s_t din_2_2_r1;
rule_s_t din_2_2_r2;
logic din_valid_2_2;
logic din_valid_2_2_r1;
logic din_valid_2_2_r2;
logic [2:0] din_valid_2_2_r;
logic din_ready_2_2;
logic din_almost_full_2_2;
logic [RID_WIDTH-1:0] hash_out_2_3;
logic hash_out_valid_filter_2_3;
rule_s_t din_2_3;
rule_s_t din_2_3_r1;
rule_s_t din_2_3_r2;
logic din_valid_2_3;
logic din_valid_2_3_r1;
logic din_valid_2_3_r2;
logic [2:0] din_valid_2_3_r;
logic din_ready_2_3;
logic din_almost_full_2_3;
logic [RID_WIDTH-1:0] hash_out_2_4;
logic hash_out_valid_filter_2_4;
rule_s_t din_2_4;
rule_s_t din_2_4_r1;
rule_s_t din_2_4_r2;
logic din_valid_2_4;
logic din_valid_2_4_r1;
logic din_valid_2_4_r2;
logic [2:0] din_valid_2_4_r;
logic din_ready_2_4;
logic din_almost_full_2_4;
logic [RID_WIDTH-1:0] hash_out_2_5;
logic hash_out_valid_filter_2_5;
rule_s_t din_2_5;
rule_s_t din_2_5_r1;
rule_s_t din_2_5_r2;
logic din_valid_2_5;
logic din_valid_2_5_r1;
logic din_valid_2_5_r2;
logic [2:0] din_valid_2_5_r;
logic din_ready_2_5;
logic din_almost_full_2_5;
logic [RID_WIDTH-1:0] hash_out_2_6;
logic hash_out_valid_filter_2_6;
rule_s_t din_2_6;
rule_s_t din_2_6_r1;
rule_s_t din_2_6_r2;
logic din_valid_2_6;
logic din_valid_2_6_r1;
logic din_valid_2_6_r2;
logic [2:0] din_valid_2_6_r;
logic din_ready_2_6;
logic din_almost_full_2_6;
logic [RID_WIDTH-1:0] hash_out_2_7;
logic hash_out_valid_filter_2_7;
rule_s_t din_2_7;
rule_s_t din_2_7_r1;
rule_s_t din_2_7_r2;
logic din_valid_2_7;
logic din_valid_2_7_r1;
logic din_valid_2_7_r2;
logic [2:0] din_valid_2_7_r;
logic din_ready_2_7;
logic din_almost_full_2_7;
logic [RID_WIDTH-1:0] hash_out_3_0;
logic hash_out_valid_filter_3_0;
rule_s_t din_3_0;
rule_s_t din_3_0_r1;
rule_s_t din_3_0_r2;
logic din_valid_3_0;
logic din_valid_3_0_r1;
logic din_valid_3_0_r2;
logic [2:0] din_valid_3_0_r;
logic din_ready_3_0;
logic din_almost_full_3_0;
logic [RID_WIDTH-1:0] hash_out_3_1;
logic hash_out_valid_filter_3_1;
rule_s_t din_3_1;
rule_s_t din_3_1_r1;
rule_s_t din_3_1_r2;
logic din_valid_3_1;
logic din_valid_3_1_r1;
logic din_valid_3_1_r2;
logic [2:0] din_valid_3_1_r;
logic din_ready_3_1;
logic din_almost_full_3_1;
logic [RID_WIDTH-1:0] hash_out_3_2;
logic hash_out_valid_filter_3_2;
rule_s_t din_3_2;
rule_s_t din_3_2_r1;
rule_s_t din_3_2_r2;
logic din_valid_3_2;
logic din_valid_3_2_r1;
logic din_valid_3_2_r2;
logic [2:0] din_valid_3_2_r;
logic din_ready_3_2;
logic din_almost_full_3_2;
logic [RID_WIDTH-1:0] hash_out_3_3;
logic hash_out_valid_filter_3_3;
rule_s_t din_3_3;
rule_s_t din_3_3_r1;
rule_s_t din_3_3_r2;
logic din_valid_3_3;
logic din_valid_3_3_r1;
logic din_valid_3_3_r2;
logic [2:0] din_valid_3_3_r;
logic din_ready_3_3;
logic din_almost_full_3_3;
logic [RID_WIDTH-1:0] hash_out_3_4;
logic hash_out_valid_filter_3_4;
rule_s_t din_3_4;
rule_s_t din_3_4_r1;
rule_s_t din_3_4_r2;
logic din_valid_3_4;
logic din_valid_3_4_r1;
logic din_valid_3_4_r2;
logic [2:0] din_valid_3_4_r;
logic din_ready_3_4;
logic din_almost_full_3_4;
logic [RID_WIDTH-1:0] hash_out_3_5;
logic hash_out_valid_filter_3_5;
rule_s_t din_3_5;
rule_s_t din_3_5_r1;
rule_s_t din_3_5_r2;
logic din_valid_3_5;
logic din_valid_3_5_r1;
logic din_valid_3_5_r2;
logic [2:0] din_valid_3_5_r;
logic din_ready_3_5;
logic din_almost_full_3_5;
logic [RID_WIDTH-1:0] hash_out_3_6;
logic hash_out_valid_filter_3_6;
rule_s_t din_3_6;
rule_s_t din_3_6_r1;
rule_s_t din_3_6_r2;
logic din_valid_3_6;
logic din_valid_3_6_r1;
logic din_valid_3_6_r2;
logic [2:0] din_valid_3_6_r;
logic din_ready_3_6;
logic din_almost_full_3_6;
logic [RID_WIDTH-1:0] hash_out_3_7;
logic hash_out_valid_filter_3_7;
rule_s_t din_3_7;
rule_s_t din_3_7_r1;
rule_s_t din_3_7_r2;
logic din_valid_3_7;
logic din_valid_3_7_r1;
logic din_valid_3_7_r2;
logic [2:0] din_valid_3_7_r;
logic din_ready_3_7;
logic din_almost_full_3_7;
logic [RID_WIDTH-1:0] hash_out_4_0;
logic hash_out_valid_filter_4_0;
rule_s_t din_4_0;
rule_s_t din_4_0_r1;
rule_s_t din_4_0_r2;
logic din_valid_4_0;
logic din_valid_4_0_r1;
logic din_valid_4_0_r2;
logic [2:0] din_valid_4_0_r;
logic din_ready_4_0;
logic din_almost_full_4_0;
logic [RID_WIDTH-1:0] hash_out_4_1;
logic hash_out_valid_filter_4_1;
rule_s_t din_4_1;
rule_s_t din_4_1_r1;
rule_s_t din_4_1_r2;
logic din_valid_4_1;
logic din_valid_4_1_r1;
logic din_valid_4_1_r2;
logic [2:0] din_valid_4_1_r;
logic din_ready_4_1;
logic din_almost_full_4_1;
logic [RID_WIDTH-1:0] hash_out_4_2;
logic hash_out_valid_filter_4_2;
rule_s_t din_4_2;
rule_s_t din_4_2_r1;
rule_s_t din_4_2_r2;
logic din_valid_4_2;
logic din_valid_4_2_r1;
logic din_valid_4_2_r2;
logic [2:0] din_valid_4_2_r;
logic din_ready_4_2;
logic din_almost_full_4_2;
logic [RID_WIDTH-1:0] hash_out_4_3;
logic hash_out_valid_filter_4_3;
rule_s_t din_4_3;
rule_s_t din_4_3_r1;
rule_s_t din_4_3_r2;
logic din_valid_4_3;
logic din_valid_4_3_r1;
logic din_valid_4_3_r2;
logic [2:0] din_valid_4_3_r;
logic din_ready_4_3;
logic din_almost_full_4_3;
logic [RID_WIDTH-1:0] hash_out_4_4;
logic hash_out_valid_filter_4_4;
rule_s_t din_4_4;
rule_s_t din_4_4_r1;
rule_s_t din_4_4_r2;
logic din_valid_4_4;
logic din_valid_4_4_r1;
logic din_valid_4_4_r2;
logic [2:0] din_valid_4_4_r;
logic din_ready_4_4;
logic din_almost_full_4_4;
logic [RID_WIDTH-1:0] hash_out_4_5;
logic hash_out_valid_filter_4_5;
rule_s_t din_4_5;
rule_s_t din_4_5_r1;
rule_s_t din_4_5_r2;
logic din_valid_4_5;
logic din_valid_4_5_r1;
logic din_valid_4_5_r2;
logic [2:0] din_valid_4_5_r;
logic din_ready_4_5;
logic din_almost_full_4_5;
logic [RID_WIDTH-1:0] hash_out_4_6;
logic hash_out_valid_filter_4_6;
rule_s_t din_4_6;
rule_s_t din_4_6_r1;
rule_s_t din_4_6_r2;
logic din_valid_4_6;
logic din_valid_4_6_r1;
logic din_valid_4_6_r2;
logic [2:0] din_valid_4_6_r;
logic din_ready_4_6;
logic din_almost_full_4_6;
logic [RID_WIDTH-1:0] hash_out_4_7;
logic hash_out_valid_filter_4_7;
rule_s_t din_4_7;
rule_s_t din_4_7_r1;
rule_s_t din_4_7_r2;
logic din_valid_4_7;
logic din_valid_4_7_r1;
logic din_valid_4_7_r2;
logic [2:0] din_valid_4_7_r;
logic din_ready_4_7;
logic din_almost_full_4_7;
logic [RID_WIDTH-1:0] hash_out_5_0;
logic hash_out_valid_filter_5_0;
rule_s_t din_5_0;
rule_s_t din_5_0_r1;
rule_s_t din_5_0_r2;
logic din_valid_5_0;
logic din_valid_5_0_r1;
logic din_valid_5_0_r2;
logic [2:0] din_valid_5_0_r;
logic din_ready_5_0;
logic din_almost_full_5_0;
logic [RID_WIDTH-1:0] hash_out_5_1;
logic hash_out_valid_filter_5_1;
rule_s_t din_5_1;
rule_s_t din_5_1_r1;
rule_s_t din_5_1_r2;
logic din_valid_5_1;
logic din_valid_5_1_r1;
logic din_valid_5_1_r2;
logic [2:0] din_valid_5_1_r;
logic din_ready_5_1;
logic din_almost_full_5_1;
logic [RID_WIDTH-1:0] hash_out_5_2;
logic hash_out_valid_filter_5_2;
rule_s_t din_5_2;
rule_s_t din_5_2_r1;
rule_s_t din_5_2_r2;
logic din_valid_5_2;
logic din_valid_5_2_r1;
logic din_valid_5_2_r2;
logic [2:0] din_valid_5_2_r;
logic din_ready_5_2;
logic din_almost_full_5_2;
logic [RID_WIDTH-1:0] hash_out_5_3;
logic hash_out_valid_filter_5_3;
rule_s_t din_5_3;
rule_s_t din_5_3_r1;
rule_s_t din_5_3_r2;
logic din_valid_5_3;
logic din_valid_5_3_r1;
logic din_valid_5_3_r2;
logic [2:0] din_valid_5_3_r;
logic din_ready_5_3;
logic din_almost_full_5_3;
logic [RID_WIDTH-1:0] hash_out_5_4;
logic hash_out_valid_filter_5_4;
rule_s_t din_5_4;
rule_s_t din_5_4_r1;
rule_s_t din_5_4_r2;
logic din_valid_5_4;
logic din_valid_5_4_r1;
logic din_valid_5_4_r2;
logic [2:0] din_valid_5_4_r;
logic din_ready_5_4;
logic din_almost_full_5_4;
logic [RID_WIDTH-1:0] hash_out_5_5;
logic hash_out_valid_filter_5_5;
rule_s_t din_5_5;
rule_s_t din_5_5_r1;
rule_s_t din_5_5_r2;
logic din_valid_5_5;
logic din_valid_5_5_r1;
logic din_valid_5_5_r2;
logic [2:0] din_valid_5_5_r;
logic din_ready_5_5;
logic din_almost_full_5_5;
logic [RID_WIDTH-1:0] hash_out_5_6;
logic hash_out_valid_filter_5_6;
rule_s_t din_5_6;
rule_s_t din_5_6_r1;
rule_s_t din_5_6_r2;
logic din_valid_5_6;
logic din_valid_5_6_r1;
logic din_valid_5_6_r2;
logic [2:0] din_valid_5_6_r;
logic din_ready_5_6;
logic din_almost_full_5_6;
logic [RID_WIDTH-1:0] hash_out_5_7;
logic hash_out_valid_filter_5_7;
rule_s_t din_5_7;
rule_s_t din_5_7_r1;
rule_s_t din_5_7_r2;
logic din_valid_5_7;
logic din_valid_5_7_r1;
logic din_valid_5_7_r2;
logic [2:0] din_valid_5_7_r;
logic din_ready_5_7;
logic din_almost_full_5_7;
logic [RID_WIDTH-1:0] hash_out_6_0;
logic hash_out_valid_filter_6_0;
rule_s_t din_6_0;
rule_s_t din_6_0_r1;
rule_s_t din_6_0_r2;
logic din_valid_6_0;
logic din_valid_6_0_r1;
logic din_valid_6_0_r2;
logic [2:0] din_valid_6_0_r;
logic din_ready_6_0;
logic din_almost_full_6_0;
logic [RID_WIDTH-1:0] hash_out_6_1;
logic hash_out_valid_filter_6_1;
rule_s_t din_6_1;
rule_s_t din_6_1_r1;
rule_s_t din_6_1_r2;
logic din_valid_6_1;
logic din_valid_6_1_r1;
logic din_valid_6_1_r2;
logic [2:0] din_valid_6_1_r;
logic din_ready_6_1;
logic din_almost_full_6_1;
logic [RID_WIDTH-1:0] hash_out_6_2;
logic hash_out_valid_filter_6_2;
rule_s_t din_6_2;
rule_s_t din_6_2_r1;
rule_s_t din_6_2_r2;
logic din_valid_6_2;
logic din_valid_6_2_r1;
logic din_valid_6_2_r2;
logic [2:0] din_valid_6_2_r;
logic din_ready_6_2;
logic din_almost_full_6_2;
logic [RID_WIDTH-1:0] hash_out_6_3;
logic hash_out_valid_filter_6_3;
rule_s_t din_6_3;
rule_s_t din_6_3_r1;
rule_s_t din_6_3_r2;
logic din_valid_6_3;
logic din_valid_6_3_r1;
logic din_valid_6_3_r2;
logic [2:0] din_valid_6_3_r;
logic din_ready_6_3;
logic din_almost_full_6_3;
logic [RID_WIDTH-1:0] hash_out_6_4;
logic hash_out_valid_filter_6_4;
rule_s_t din_6_4;
rule_s_t din_6_4_r1;
rule_s_t din_6_4_r2;
logic din_valid_6_4;
logic din_valid_6_4_r1;
logic din_valid_6_4_r2;
logic [2:0] din_valid_6_4_r;
logic din_ready_6_4;
logic din_almost_full_6_4;
logic [RID_WIDTH-1:0] hash_out_6_5;
logic hash_out_valid_filter_6_5;
rule_s_t din_6_5;
rule_s_t din_6_5_r1;
rule_s_t din_6_5_r2;
logic din_valid_6_5;
logic din_valid_6_5_r1;
logic din_valid_6_5_r2;
logic [2:0] din_valid_6_5_r;
logic din_ready_6_5;
logic din_almost_full_6_5;
logic [RID_WIDTH-1:0] hash_out_6_6;
logic hash_out_valid_filter_6_6;
rule_s_t din_6_6;
rule_s_t din_6_6_r1;
rule_s_t din_6_6_r2;
logic din_valid_6_6;
logic din_valid_6_6_r1;
logic din_valid_6_6_r2;
logic [2:0] din_valid_6_6_r;
logic din_ready_6_6;
logic din_almost_full_6_6;
logic [RID_WIDTH-1:0] hash_out_6_7;
logic hash_out_valid_filter_6_7;
rule_s_t din_6_7;
rule_s_t din_6_7_r1;
rule_s_t din_6_7_r2;
logic din_valid_6_7;
logic din_valid_6_7_r1;
logic din_valid_6_7_r2;
logic [2:0] din_valid_6_7_r;
logic din_ready_6_7;
logic din_almost_full_6_7;
logic [RID_WIDTH-1:0] hash_out_7_0;
logic hash_out_valid_filter_7_0;
rule_s_t din_7_0;
rule_s_t din_7_0_r1;
rule_s_t din_7_0_r2;
logic din_valid_7_0;
logic din_valid_7_0_r1;
logic din_valid_7_0_r2;
logic [2:0] din_valid_7_0_r;
logic din_ready_7_0;
logic din_almost_full_7_0;
logic [RID_WIDTH-1:0] hash_out_7_1;
logic hash_out_valid_filter_7_1;
rule_s_t din_7_1;
rule_s_t din_7_1_r1;
rule_s_t din_7_1_r2;
logic din_valid_7_1;
logic din_valid_7_1_r1;
logic din_valid_7_1_r2;
logic [2:0] din_valid_7_1_r;
logic din_ready_7_1;
logic din_almost_full_7_1;
logic [RID_WIDTH-1:0] hash_out_7_2;
logic hash_out_valid_filter_7_2;
rule_s_t din_7_2;
rule_s_t din_7_2_r1;
rule_s_t din_7_2_r2;
logic din_valid_7_2;
logic din_valid_7_2_r1;
logic din_valid_7_2_r2;
logic [2:0] din_valid_7_2_r;
logic din_ready_7_2;
logic din_almost_full_7_2;
logic [RID_WIDTH-1:0] hash_out_7_3;
logic hash_out_valid_filter_7_3;
rule_s_t din_7_3;
rule_s_t din_7_3_r1;
rule_s_t din_7_3_r2;
logic din_valid_7_3;
logic din_valid_7_3_r1;
logic din_valid_7_3_r2;
logic [2:0] din_valid_7_3_r;
logic din_ready_7_3;
logic din_almost_full_7_3;
logic [RID_WIDTH-1:0] hash_out_7_4;
logic hash_out_valid_filter_7_4;
rule_s_t din_7_4;
rule_s_t din_7_4_r1;
rule_s_t din_7_4_r2;
logic din_valid_7_4;
logic din_valid_7_4_r1;
logic din_valid_7_4_r2;
logic [2:0] din_valid_7_4_r;
logic din_ready_7_4;
logic din_almost_full_7_4;
logic [RID_WIDTH-1:0] hash_out_7_5;
logic hash_out_valid_filter_7_5;
rule_s_t din_7_5;
rule_s_t din_7_5_r1;
rule_s_t din_7_5_r2;
logic din_valid_7_5;
logic din_valid_7_5_r1;
logic din_valid_7_5_r2;
logic [2:0] din_valid_7_5_r;
logic din_ready_7_5;
logic din_almost_full_7_5;
logic [RID_WIDTH-1:0] hash_out_7_6;
logic hash_out_valid_filter_7_6;
rule_s_t din_7_6;
rule_s_t din_7_6_r1;
rule_s_t din_7_6_r2;
logic din_valid_7_6;
logic din_valid_7_6_r1;
logic din_valid_7_6_r2;
logic [2:0] din_valid_7_6_r;
logic din_ready_7_6;
logic din_almost_full_7_6;
logic [RID_WIDTH-1:0] hash_out_7_7;
logic hash_out_valid_filter_7_7;
rule_s_t din_7_7;
rule_s_t din_7_7_r1;
rule_s_t din_7_7_r2;
logic din_valid_7_7;
logic din_valid_7_7_r1;
logic din_valid_7_7_r2;
logic [2:0] din_valid_7_7_r;
logic din_ready_7_7;
logic din_almost_full_7_7;

logic out_new_pkt;

logic [255:0] in_convt;
logic gap;

assign in_convt[7+0*8:0+0*8] = in_data[255-0*8:255-7-0*8];
assign in_convt[7+1*8:0+1*8] = in_data[255-1*8:255-7-1*8];
assign in_convt[7+2*8:0+2*8] = in_data[255-2*8:255-7-2*8];
assign in_convt[7+3*8:0+3*8] = in_data[255-3*8:255-7-3*8];
assign in_convt[7+4*8:0+4*8] = in_data[255-4*8:255-7-4*8];
assign in_convt[7+5*8:0+5*8] = in_data[255-5*8:255-7-5*8];
assign in_convt[7+6*8:0+6*8] = in_data[255-6*8:255-7-6*8];
assign in_convt[7+7*8:0+7*8] = in_data[255-7*8:255-7-7*8];

always @ (posedge clk) begin
    //in_ready <=   !din_almost_full_0_0 &  !din_almost_full_0_1 &  !din_almost_full_0_2 &  !din_almost_full_0_3 &  !din_almost_full_0_4 &  !din_almost_full_0_5 &  !din_almost_full_0_6 &  !din_almost_full_0_7 &    !din_almost_full_1_0 &  !din_almost_full_1_1 &  !din_almost_full_1_2 &  !din_almost_full_1_3 &  !din_almost_full_1_4 &  !din_almost_full_1_5 &  !din_almost_full_1_6 &  !din_almost_full_1_7 &    !din_almost_full_2_0 &  !din_almost_full_2_1 &  !din_almost_full_2_2 &  !din_almost_full_2_3 &  !din_almost_full_2_4 &  !din_almost_full_2_5 &  !din_almost_full_2_6 &  !din_almost_full_2_7 &    !din_almost_full_3_0 &  !din_almost_full_3_1 &  !din_almost_full_3_2 &  !din_almost_full_3_3 &  !din_almost_full_3_4 &  !din_almost_full_3_5 &  !din_almost_full_3_6 &  !din_almost_full_3_7 &    !din_almost_full_4_0 &  !din_almost_full_4_1 &  !din_almost_full_4_2 &  !din_almost_full_4_3 &  !din_almost_full_4_4 &  !din_almost_full_4_5 &  !din_almost_full_4_6 &  !din_almost_full_4_7 &    !din_almost_full_5_0 &  !din_almost_full_5_1 &  !din_almost_full_5_2 &  !din_almost_full_5_3 &  !din_almost_full_5_4 &  !din_almost_full_5_5 &  !din_almost_full_5_6 &  !din_almost_full_5_7 &    !din_almost_full_6_0 &  !din_almost_full_6_1 &  !din_almost_full_6_2 &  !din_almost_full_6_3 &  !din_almost_full_6_4 &  !din_almost_full_6_5 &  !din_almost_full_6_6 &  !din_almost_full_6_7 &    !din_almost_full_7_0 &  !din_almost_full_7_1 &  !din_almost_full_7_2 &  !din_almost_full_7_3 &  !din_almost_full_7_4 &  !din_almost_full_7_5 &  !din_almost_full_7_6 &  !din_almost_full_7_7 &   !gap;
    in_ready <=   !din_almost_full_0_0 &  !din_almost_full_0_1 &  !din_almost_full_0_2 &  !din_almost_full_0_3 &  !din_almost_full_0_4 &  !din_almost_full_0_5 &  !din_almost_full_0_6 &  !din_almost_full_0_7 &    !din_almost_full_1_0 &  !din_almost_full_1_1 &  !din_almost_full_1_2 &  !din_almost_full_1_3 &  !din_almost_full_1_4 &  !din_almost_full_1_5 &  !din_almost_full_1_6 &  !din_almost_full_1_7 &    !din_almost_full_2_0 &  !din_almost_full_2_1 &  !din_almost_full_2_2 &  !din_almost_full_2_3 &  !din_almost_full_2_4 &  !din_almost_full_2_5 &  !din_almost_full_2_6 &  !din_almost_full_2_7 &    !din_almost_full_3_0 &  !din_almost_full_3_1 &  !din_almost_full_3_2 &  !din_almost_full_3_3 &  !din_almost_full_3_4 &  !din_almost_full_3_5 &  !din_almost_full_3_6 &  !din_almost_full_3_7 &    !din_almost_full_4_0 &  !din_almost_full_4_1 &  !din_almost_full_4_2 &  !din_almost_full_4_3 &  !din_almost_full_4_4 &  !din_almost_full_4_5 &  !din_almost_full_4_6 &  !din_almost_full_4_7 &    !din_almost_full_5_0 &  !din_almost_full_5_1 &  !din_almost_full_5_2 &  !din_almost_full_5_3 &  !din_almost_full_5_4 &  !din_almost_full_5_5 &  !din_almost_full_5_6 &  !din_almost_full_5_7 &    !din_almost_full_6_0 &  !din_almost_full_6_1 &  !din_almost_full_6_2 &  !din_almost_full_6_3 &  !din_almost_full_6_4 &  !din_almost_full_6_5 &  !din_almost_full_6_6 &  !din_almost_full_6_7 &    !din_almost_full_7_0 &  !din_almost_full_7_1 &  !din_almost_full_7_2 &  !din_almost_full_7_3 &  !din_almost_full_7_4 &  !din_almost_full_7_5 &  !din_almost_full_7_6 &  !din_almost_full_7_7 &   1;
    //in_ready <= !in_eop; //create a gap
    
    in_data_r1 <= in_convt;
    in_data_r2 <= in_data_r1;

    //only valid when the input is dequeued. 
    in_valid_r1 <= in_valid;
    in_valid_r2 <= in_valid_r1;
    in_sop_r1 <= in_sop;
    in_sop_r2 <= in_sop_r1;
    in_eop_r1 <= in_eop;
    in_eop_r2 <= in_eop_r1;
    in_empty_r1 <= in_empty;
    in_empty_r2 <= in_empty_r1;
end

assign gap = (in_eop & in_valid & in_ready);

always@(posedge clk)begin
    din_valid_0_0 <= out_new_pkt | hash_out_valid_filter_0_0;
    din_valid_0_0_r1 <= din_valid_0_0;
    din_valid_0_0_r2 <= din_valid_0_0_r1;

    din_0_0.data <= hash_out_valid_filter_0_0 ? hash_out_0_0 : 0;
    din_0_0.last <= out_new_pkt;
    din_0_0.bucket <= 0;


    din_0_0_r1 <= din_0_0;
    din_0_0_r2 <= din_0_0_r1;
    din_valid_0_1 <= out_new_pkt | hash_out_valid_filter_0_1;
    din_valid_0_1_r1 <= din_valid_0_1;
    din_valid_0_1_r2 <= din_valid_0_1_r1;

    din_0_1.data <= hash_out_valid_filter_0_1 ? hash_out_0_1 : 0;
    din_0_1.last <= out_new_pkt;
    din_0_1.bucket <= 0;


    din_0_1_r1 <= din_0_1;
    din_0_1_r2 <= din_0_1_r1;
    din_valid_0_2 <= out_new_pkt | hash_out_valid_filter_0_2;
    din_valid_0_2_r1 <= din_valid_0_2;
    din_valid_0_2_r2 <= din_valid_0_2_r1;

    din_0_2.data <= hash_out_valid_filter_0_2 ? hash_out_0_2 : 0;
    din_0_2.last <= out_new_pkt;
    din_0_2.bucket <= 0;


    din_0_2_r1 <= din_0_2;
    din_0_2_r2 <= din_0_2_r1;
    din_valid_0_3 <= out_new_pkt | hash_out_valid_filter_0_3;
    din_valid_0_3_r1 <= din_valid_0_3;
    din_valid_0_3_r2 <= din_valid_0_3_r1;

    din_0_3.data <= hash_out_valid_filter_0_3 ? hash_out_0_3 : 0;
    din_0_3.last <= out_new_pkt;
    din_0_3.bucket <= 0;


    din_0_3_r1 <= din_0_3;
    din_0_3_r2 <= din_0_3_r1;
    din_valid_0_4 <= out_new_pkt | hash_out_valid_filter_0_4;
    din_valid_0_4_r1 <= din_valid_0_4;
    din_valid_0_4_r2 <= din_valid_0_4_r1;

    din_0_4.data <= hash_out_valid_filter_0_4 ? hash_out_0_4 : 0;
    din_0_4.last <= out_new_pkt;
    din_0_4.bucket <= 0;


    din_0_4_r1 <= din_0_4;
    din_0_4_r2 <= din_0_4_r1;
    din_valid_0_5 <= out_new_pkt | hash_out_valid_filter_0_5;
    din_valid_0_5_r1 <= din_valid_0_5;
    din_valid_0_5_r2 <= din_valid_0_5_r1;

    din_0_5.data <= hash_out_valid_filter_0_5 ? hash_out_0_5 : 0;
    din_0_5.last <= out_new_pkt;
    din_0_5.bucket <= 0;


    din_0_5_r1 <= din_0_5;
    din_0_5_r2 <= din_0_5_r1;
    din_valid_0_6 <= out_new_pkt | hash_out_valid_filter_0_6;
    din_valid_0_6_r1 <= din_valid_0_6;
    din_valid_0_6_r2 <= din_valid_0_6_r1;

    din_0_6.data <= hash_out_valid_filter_0_6 ? hash_out_0_6 : 0;
    din_0_6.last <= out_new_pkt;
    din_0_6.bucket <= 0;


    din_0_6_r1 <= din_0_6;
    din_0_6_r2 <= din_0_6_r1;
    din_valid_0_7 <= out_new_pkt | hash_out_valid_filter_0_7;
    din_valid_0_7_r1 <= din_valid_0_7;
    din_valid_0_7_r2 <= din_valid_0_7_r1;

    din_0_7.data <= hash_out_valid_filter_0_7 ? hash_out_0_7 : 0;
    din_0_7.last <= out_new_pkt;
    din_0_7.bucket <= 0;


    din_0_7_r1 <= din_0_7;
    din_0_7_r2 <= din_0_7_r1;
    din_valid_1_0 <= out_new_pkt | hash_out_valid_filter_1_0;
    din_valid_1_0_r1 <= din_valid_1_0;
    din_valid_1_0_r2 <= din_valid_1_0_r1;

    din_1_0.data <= hash_out_valid_filter_1_0 ? hash_out_1_0 : 0;
    din_1_0.last <= out_new_pkt;
    din_1_0.bucket <= 1;


    din_1_0_r1 <= din_1_0;
    din_1_0_r2 <= din_1_0_r1;
    din_valid_1_1 <= out_new_pkt | hash_out_valid_filter_1_1;
    din_valid_1_1_r1 <= din_valid_1_1;
    din_valid_1_1_r2 <= din_valid_1_1_r1;

    din_1_1.data <= hash_out_valid_filter_1_1 ? hash_out_1_1 : 0;
    din_1_1.last <= out_new_pkt;
    din_1_1.bucket <= 1;


    din_1_1_r1 <= din_1_1;
    din_1_1_r2 <= din_1_1_r1;
    din_valid_1_2 <= out_new_pkt | hash_out_valid_filter_1_2;
    din_valid_1_2_r1 <= din_valid_1_2;
    din_valid_1_2_r2 <= din_valid_1_2_r1;

    din_1_2.data <= hash_out_valid_filter_1_2 ? hash_out_1_2 : 0;
    din_1_2.last <= out_new_pkt;
    din_1_2.bucket <= 1;


    din_1_2_r1 <= din_1_2;
    din_1_2_r2 <= din_1_2_r1;
    din_valid_1_3 <= out_new_pkt | hash_out_valid_filter_1_3;
    din_valid_1_3_r1 <= din_valid_1_3;
    din_valid_1_3_r2 <= din_valid_1_3_r1;

    din_1_3.data <= hash_out_valid_filter_1_3 ? hash_out_1_3 : 0;
    din_1_3.last <= out_new_pkt;
    din_1_3.bucket <= 1;


    din_1_3_r1 <= din_1_3;
    din_1_3_r2 <= din_1_3_r1;
    din_valid_1_4 <= out_new_pkt | hash_out_valid_filter_1_4;
    din_valid_1_4_r1 <= din_valid_1_4;
    din_valid_1_4_r2 <= din_valid_1_4_r1;

    din_1_4.data <= hash_out_valid_filter_1_4 ? hash_out_1_4 : 0;
    din_1_4.last <= out_new_pkt;
    din_1_4.bucket <= 1;


    din_1_4_r1 <= din_1_4;
    din_1_4_r2 <= din_1_4_r1;
    din_valid_1_5 <= out_new_pkt | hash_out_valid_filter_1_5;
    din_valid_1_5_r1 <= din_valid_1_5;
    din_valid_1_5_r2 <= din_valid_1_5_r1;

    din_1_5.data <= hash_out_valid_filter_1_5 ? hash_out_1_5 : 0;
    din_1_5.last <= out_new_pkt;
    din_1_5.bucket <= 1;


    din_1_5_r1 <= din_1_5;
    din_1_5_r2 <= din_1_5_r1;
    din_valid_1_6 <= out_new_pkt | hash_out_valid_filter_1_6;
    din_valid_1_6_r1 <= din_valid_1_6;
    din_valid_1_6_r2 <= din_valid_1_6_r1;

    din_1_6.data <= hash_out_valid_filter_1_6 ? hash_out_1_6 : 0;
    din_1_6.last <= out_new_pkt;
    din_1_6.bucket <= 1;


    din_1_6_r1 <= din_1_6;
    din_1_6_r2 <= din_1_6_r1;
    din_valid_1_7 <= out_new_pkt | hash_out_valid_filter_1_7;
    din_valid_1_7_r1 <= din_valid_1_7;
    din_valid_1_7_r2 <= din_valid_1_7_r1;

    din_1_7.data <= hash_out_valid_filter_1_7 ? hash_out_1_7 : 0;
    din_1_7.last <= out_new_pkt;
    din_1_7.bucket <= 1;


    din_1_7_r1 <= din_1_7;
    din_1_7_r2 <= din_1_7_r1;
    din_valid_2_0 <= out_new_pkt | hash_out_valid_filter_2_0;
    din_valid_2_0_r1 <= din_valid_2_0;
    din_valid_2_0_r2 <= din_valid_2_0_r1;

    din_2_0.data <= hash_out_valid_filter_2_0 ? hash_out_2_0 : 0;
    din_2_0.last <= out_new_pkt;
    din_2_0.bucket <= 2;


    din_2_0_r1 <= din_2_0;
    din_2_0_r2 <= din_2_0_r1;
    din_valid_2_1 <= out_new_pkt | hash_out_valid_filter_2_1;
    din_valid_2_1_r1 <= din_valid_2_1;
    din_valid_2_1_r2 <= din_valid_2_1_r1;

    din_2_1.data <= hash_out_valid_filter_2_1 ? hash_out_2_1 : 0;
    din_2_1.last <= out_new_pkt;
    din_2_1.bucket <= 2;


    din_2_1_r1 <= din_2_1;
    din_2_1_r2 <= din_2_1_r1;
    din_valid_2_2 <= out_new_pkt | hash_out_valid_filter_2_2;
    din_valid_2_2_r1 <= din_valid_2_2;
    din_valid_2_2_r2 <= din_valid_2_2_r1;

    din_2_2.data <= hash_out_valid_filter_2_2 ? hash_out_2_2 : 0;
    din_2_2.last <= out_new_pkt;
    din_2_2.bucket <= 2;


    din_2_2_r1 <= din_2_2;
    din_2_2_r2 <= din_2_2_r1;
    din_valid_2_3 <= out_new_pkt | hash_out_valid_filter_2_3;
    din_valid_2_3_r1 <= din_valid_2_3;
    din_valid_2_3_r2 <= din_valid_2_3_r1;

    din_2_3.data <= hash_out_valid_filter_2_3 ? hash_out_2_3 : 0;
    din_2_3.last <= out_new_pkt;
    din_2_3.bucket <= 2;


    din_2_3_r1 <= din_2_3;
    din_2_3_r2 <= din_2_3_r1;
    din_valid_2_4 <= out_new_pkt | hash_out_valid_filter_2_4;
    din_valid_2_4_r1 <= din_valid_2_4;
    din_valid_2_4_r2 <= din_valid_2_4_r1;

    din_2_4.data <= hash_out_valid_filter_2_4 ? hash_out_2_4 : 0;
    din_2_4.last <= out_new_pkt;
    din_2_4.bucket <= 2;


    din_2_4_r1 <= din_2_4;
    din_2_4_r2 <= din_2_4_r1;
    din_valid_2_5 <= out_new_pkt | hash_out_valid_filter_2_5;
    din_valid_2_5_r1 <= din_valid_2_5;
    din_valid_2_5_r2 <= din_valid_2_5_r1;

    din_2_5.data <= hash_out_valid_filter_2_5 ? hash_out_2_5 : 0;
    din_2_5.last <= out_new_pkt;
    din_2_5.bucket <= 2;


    din_2_5_r1 <= din_2_5;
    din_2_5_r2 <= din_2_5_r1;
    din_valid_2_6 <= out_new_pkt | hash_out_valid_filter_2_6;
    din_valid_2_6_r1 <= din_valid_2_6;
    din_valid_2_6_r2 <= din_valid_2_6_r1;

    din_2_6.data <= hash_out_valid_filter_2_6 ? hash_out_2_6 : 0;
    din_2_6.last <= out_new_pkt;
    din_2_6.bucket <= 2;


    din_2_6_r1 <= din_2_6;
    din_2_6_r2 <= din_2_6_r1;
    din_valid_2_7 <= out_new_pkt | hash_out_valid_filter_2_7;
    din_valid_2_7_r1 <= din_valid_2_7;
    din_valid_2_7_r2 <= din_valid_2_7_r1;

    din_2_7.data <= hash_out_valid_filter_2_7 ? hash_out_2_7 : 0;
    din_2_7.last <= out_new_pkt;
    din_2_7.bucket <= 2;


    din_2_7_r1 <= din_2_7;
    din_2_7_r2 <= din_2_7_r1;
    din_valid_3_0 <= out_new_pkt | hash_out_valid_filter_3_0;
    din_valid_3_0_r1 <= din_valid_3_0;
    din_valid_3_0_r2 <= din_valid_3_0_r1;

    din_3_0.data <= hash_out_valid_filter_3_0 ? hash_out_3_0 : 0;
    din_3_0.last <= out_new_pkt;
    din_3_0.bucket <= 3;


    din_3_0_r1 <= din_3_0;
    din_3_0_r2 <= din_3_0_r1;
    din_valid_3_1 <= out_new_pkt | hash_out_valid_filter_3_1;
    din_valid_3_1_r1 <= din_valid_3_1;
    din_valid_3_1_r2 <= din_valid_3_1_r1;

    din_3_1.data <= hash_out_valid_filter_3_1 ? hash_out_3_1 : 0;
    din_3_1.last <= out_new_pkt;
    din_3_1.bucket <= 3;


    din_3_1_r1 <= din_3_1;
    din_3_1_r2 <= din_3_1_r1;
    din_valid_3_2 <= out_new_pkt | hash_out_valid_filter_3_2;
    din_valid_3_2_r1 <= din_valid_3_2;
    din_valid_3_2_r2 <= din_valid_3_2_r1;

    din_3_2.data <= hash_out_valid_filter_3_2 ? hash_out_3_2 : 0;
    din_3_2.last <= out_new_pkt;
    din_3_2.bucket <= 3;


    din_3_2_r1 <= din_3_2;
    din_3_2_r2 <= din_3_2_r1;
    din_valid_3_3 <= out_new_pkt | hash_out_valid_filter_3_3;
    din_valid_3_3_r1 <= din_valid_3_3;
    din_valid_3_3_r2 <= din_valid_3_3_r1;

    din_3_3.data <= hash_out_valid_filter_3_3 ? hash_out_3_3 : 0;
    din_3_3.last <= out_new_pkt;
    din_3_3.bucket <= 3;


    din_3_3_r1 <= din_3_3;
    din_3_3_r2 <= din_3_3_r1;
    din_valid_3_4 <= out_new_pkt | hash_out_valid_filter_3_4;
    din_valid_3_4_r1 <= din_valid_3_4;
    din_valid_3_4_r2 <= din_valid_3_4_r1;

    din_3_4.data <= hash_out_valid_filter_3_4 ? hash_out_3_4 : 0;
    din_3_4.last <= out_new_pkt;
    din_3_4.bucket <= 3;


    din_3_4_r1 <= din_3_4;
    din_3_4_r2 <= din_3_4_r1;
    din_valid_3_5 <= out_new_pkt | hash_out_valid_filter_3_5;
    din_valid_3_5_r1 <= din_valid_3_5;
    din_valid_3_5_r2 <= din_valid_3_5_r1;

    din_3_5.data <= hash_out_valid_filter_3_5 ? hash_out_3_5 : 0;
    din_3_5.last <= out_new_pkt;
    din_3_5.bucket <= 3;


    din_3_5_r1 <= din_3_5;
    din_3_5_r2 <= din_3_5_r1;
    din_valid_3_6 <= out_new_pkt | hash_out_valid_filter_3_6;
    din_valid_3_6_r1 <= din_valid_3_6;
    din_valid_3_6_r2 <= din_valid_3_6_r1;

    din_3_6.data <= hash_out_valid_filter_3_6 ? hash_out_3_6 : 0;
    din_3_6.last <= out_new_pkt;
    din_3_6.bucket <= 3;


    din_3_6_r1 <= din_3_6;
    din_3_6_r2 <= din_3_6_r1;
    din_valid_3_7 <= out_new_pkt | hash_out_valid_filter_3_7;
    din_valid_3_7_r1 <= din_valid_3_7;
    din_valid_3_7_r2 <= din_valid_3_7_r1;

    din_3_7.data <= hash_out_valid_filter_3_7 ? hash_out_3_7 : 0;
    din_3_7.last <= out_new_pkt;
    din_3_7.bucket <= 3;


    din_3_7_r1 <= din_3_7;
    din_3_7_r2 <= din_3_7_r1;
    din_valid_4_0 <= out_new_pkt | hash_out_valid_filter_4_0;
    din_valid_4_0_r1 <= din_valid_4_0;
    din_valid_4_0_r2 <= din_valid_4_0_r1;

    din_4_0.data <= hash_out_valid_filter_4_0 ? hash_out_4_0 : 0;
    din_4_0.last <= out_new_pkt;
    din_4_0.bucket <= 4;


    din_4_0_r1 <= din_4_0;
    din_4_0_r2 <= din_4_0_r1;
    din_valid_4_1 <= out_new_pkt | hash_out_valid_filter_4_1;
    din_valid_4_1_r1 <= din_valid_4_1;
    din_valid_4_1_r2 <= din_valid_4_1_r1;

    din_4_1.data <= hash_out_valid_filter_4_1 ? hash_out_4_1 : 0;
    din_4_1.last <= out_new_pkt;
    din_4_1.bucket <= 4;


    din_4_1_r1 <= din_4_1;
    din_4_1_r2 <= din_4_1_r1;
    din_valid_4_2 <= out_new_pkt | hash_out_valid_filter_4_2;
    din_valid_4_2_r1 <= din_valid_4_2;
    din_valid_4_2_r2 <= din_valid_4_2_r1;

    din_4_2.data <= hash_out_valid_filter_4_2 ? hash_out_4_2 : 0;
    din_4_2.last <= out_new_pkt;
    din_4_2.bucket <= 4;


    din_4_2_r1 <= din_4_2;
    din_4_2_r2 <= din_4_2_r1;
    din_valid_4_3 <= out_new_pkt | hash_out_valid_filter_4_3;
    din_valid_4_3_r1 <= din_valid_4_3;
    din_valid_4_3_r2 <= din_valid_4_3_r1;

    din_4_3.data <= hash_out_valid_filter_4_3 ? hash_out_4_3 : 0;
    din_4_3.last <= out_new_pkt;
    din_4_3.bucket <= 4;


    din_4_3_r1 <= din_4_3;
    din_4_3_r2 <= din_4_3_r1;
    din_valid_4_4 <= out_new_pkt | hash_out_valid_filter_4_4;
    din_valid_4_4_r1 <= din_valid_4_4;
    din_valid_4_4_r2 <= din_valid_4_4_r1;

    din_4_4.data <= hash_out_valid_filter_4_4 ? hash_out_4_4 : 0;
    din_4_4.last <= out_new_pkt;
    din_4_4.bucket <= 4;


    din_4_4_r1 <= din_4_4;
    din_4_4_r2 <= din_4_4_r1;
    din_valid_4_5 <= out_new_pkt | hash_out_valid_filter_4_5;
    din_valid_4_5_r1 <= din_valid_4_5;
    din_valid_4_5_r2 <= din_valid_4_5_r1;

    din_4_5.data <= hash_out_valid_filter_4_5 ? hash_out_4_5 : 0;
    din_4_5.last <= out_new_pkt;
    din_4_5.bucket <= 4;


    din_4_5_r1 <= din_4_5;
    din_4_5_r2 <= din_4_5_r1;
    din_valid_4_6 <= out_new_pkt | hash_out_valid_filter_4_6;
    din_valid_4_6_r1 <= din_valid_4_6;
    din_valid_4_6_r2 <= din_valid_4_6_r1;

    din_4_6.data <= hash_out_valid_filter_4_6 ? hash_out_4_6 : 0;
    din_4_6.last <= out_new_pkt;
    din_4_6.bucket <= 4;


    din_4_6_r1 <= din_4_6;
    din_4_6_r2 <= din_4_6_r1;
    din_valid_4_7 <= out_new_pkt | hash_out_valid_filter_4_7;
    din_valid_4_7_r1 <= din_valid_4_7;
    din_valid_4_7_r2 <= din_valid_4_7_r1;

    din_4_7.data <= hash_out_valid_filter_4_7 ? hash_out_4_7 : 0;
    din_4_7.last <= out_new_pkt;
    din_4_7.bucket <= 4;


    din_4_7_r1 <= din_4_7;
    din_4_7_r2 <= din_4_7_r1;
    din_valid_5_0 <= out_new_pkt | hash_out_valid_filter_5_0;
    din_valid_5_0_r1 <= din_valid_5_0;
    din_valid_5_0_r2 <= din_valid_5_0_r1;

    din_5_0.data <= hash_out_valid_filter_5_0 ? hash_out_5_0 : 0;
    din_5_0.last <= out_new_pkt;
    din_5_0.bucket <= 5;


    din_5_0_r1 <= din_5_0;
    din_5_0_r2 <= din_5_0_r1;
    din_valid_5_1 <= out_new_pkt | hash_out_valid_filter_5_1;
    din_valid_5_1_r1 <= din_valid_5_1;
    din_valid_5_1_r2 <= din_valid_5_1_r1;

    din_5_1.data <= hash_out_valid_filter_5_1 ? hash_out_5_1 : 0;
    din_5_1.last <= out_new_pkt;
    din_5_1.bucket <= 5;


    din_5_1_r1 <= din_5_1;
    din_5_1_r2 <= din_5_1_r1;
    din_valid_5_2 <= out_new_pkt | hash_out_valid_filter_5_2;
    din_valid_5_2_r1 <= din_valid_5_2;
    din_valid_5_2_r2 <= din_valid_5_2_r1;

    din_5_2.data <= hash_out_valid_filter_5_2 ? hash_out_5_2 : 0;
    din_5_2.last <= out_new_pkt;
    din_5_2.bucket <= 5;


    din_5_2_r1 <= din_5_2;
    din_5_2_r2 <= din_5_2_r1;
    din_valid_5_3 <= out_new_pkt | hash_out_valid_filter_5_3;
    din_valid_5_3_r1 <= din_valid_5_3;
    din_valid_5_3_r2 <= din_valid_5_3_r1;

    din_5_3.data <= hash_out_valid_filter_5_3 ? hash_out_5_3 : 0;
    din_5_3.last <= out_new_pkt;
    din_5_3.bucket <= 5;


    din_5_3_r1 <= din_5_3;
    din_5_3_r2 <= din_5_3_r1;
    din_valid_5_4 <= out_new_pkt | hash_out_valid_filter_5_4;
    din_valid_5_4_r1 <= din_valid_5_4;
    din_valid_5_4_r2 <= din_valid_5_4_r1;

    din_5_4.data <= hash_out_valid_filter_5_4 ? hash_out_5_4 : 0;
    din_5_4.last <= out_new_pkt;
    din_5_4.bucket <= 5;


    din_5_4_r1 <= din_5_4;
    din_5_4_r2 <= din_5_4_r1;
    din_valid_5_5 <= out_new_pkt | hash_out_valid_filter_5_5;
    din_valid_5_5_r1 <= din_valid_5_5;
    din_valid_5_5_r2 <= din_valid_5_5_r1;

    din_5_5.data <= hash_out_valid_filter_5_5 ? hash_out_5_5 : 0;
    din_5_5.last <= out_new_pkt;
    din_5_5.bucket <= 5;


    din_5_5_r1 <= din_5_5;
    din_5_5_r2 <= din_5_5_r1;
    din_valid_5_6 <= out_new_pkt | hash_out_valid_filter_5_6;
    din_valid_5_6_r1 <= din_valid_5_6;
    din_valid_5_6_r2 <= din_valid_5_6_r1;

    din_5_6.data <= hash_out_valid_filter_5_6 ? hash_out_5_6 : 0;
    din_5_6.last <= out_new_pkt;
    din_5_6.bucket <= 5;


    din_5_6_r1 <= din_5_6;
    din_5_6_r2 <= din_5_6_r1;
    din_valid_5_7 <= out_new_pkt | hash_out_valid_filter_5_7;
    din_valid_5_7_r1 <= din_valid_5_7;
    din_valid_5_7_r2 <= din_valid_5_7_r1;

    din_5_7.data <= hash_out_valid_filter_5_7 ? hash_out_5_7 : 0;
    din_5_7.last <= out_new_pkt;
    din_5_7.bucket <= 5;


    din_5_7_r1 <= din_5_7;
    din_5_7_r2 <= din_5_7_r1;
    din_valid_6_0 <= out_new_pkt | hash_out_valid_filter_6_0;
    din_valid_6_0_r1 <= din_valid_6_0;
    din_valid_6_0_r2 <= din_valid_6_0_r1;

    din_6_0.data <= hash_out_valid_filter_6_0 ? hash_out_6_0 : 0;
    din_6_0.last <= out_new_pkt;
    din_6_0.bucket <= 6;


    din_6_0_r1 <= din_6_0;
    din_6_0_r2 <= din_6_0_r1;
    din_valid_6_1 <= out_new_pkt | hash_out_valid_filter_6_1;
    din_valid_6_1_r1 <= din_valid_6_1;
    din_valid_6_1_r2 <= din_valid_6_1_r1;

    din_6_1.data <= hash_out_valid_filter_6_1 ? hash_out_6_1 : 0;
    din_6_1.last <= out_new_pkt;
    din_6_1.bucket <= 6;


    din_6_1_r1 <= din_6_1;
    din_6_1_r2 <= din_6_1_r1;
    din_valid_6_2 <= out_new_pkt | hash_out_valid_filter_6_2;
    din_valid_6_2_r1 <= din_valid_6_2;
    din_valid_6_2_r2 <= din_valid_6_2_r1;

    din_6_2.data <= hash_out_valid_filter_6_2 ? hash_out_6_2 : 0;
    din_6_2.last <= out_new_pkt;
    din_6_2.bucket <= 6;


    din_6_2_r1 <= din_6_2;
    din_6_2_r2 <= din_6_2_r1;
    din_valid_6_3 <= out_new_pkt | hash_out_valid_filter_6_3;
    din_valid_6_3_r1 <= din_valid_6_3;
    din_valid_6_3_r2 <= din_valid_6_3_r1;

    din_6_3.data <= hash_out_valid_filter_6_3 ? hash_out_6_3 : 0;
    din_6_3.last <= out_new_pkt;
    din_6_3.bucket <= 6;


    din_6_3_r1 <= din_6_3;
    din_6_3_r2 <= din_6_3_r1;
    din_valid_6_4 <= out_new_pkt | hash_out_valid_filter_6_4;
    din_valid_6_4_r1 <= din_valid_6_4;
    din_valid_6_4_r2 <= din_valid_6_4_r1;

    din_6_4.data <= hash_out_valid_filter_6_4 ? hash_out_6_4 : 0;
    din_6_4.last <= out_new_pkt;
    din_6_4.bucket <= 6;


    din_6_4_r1 <= din_6_4;
    din_6_4_r2 <= din_6_4_r1;
    din_valid_6_5 <= out_new_pkt | hash_out_valid_filter_6_5;
    din_valid_6_5_r1 <= din_valid_6_5;
    din_valid_6_5_r2 <= din_valid_6_5_r1;

    din_6_5.data <= hash_out_valid_filter_6_5 ? hash_out_6_5 : 0;
    din_6_5.last <= out_new_pkt;
    din_6_5.bucket <= 6;


    din_6_5_r1 <= din_6_5;
    din_6_5_r2 <= din_6_5_r1;
    din_valid_6_6 <= out_new_pkt | hash_out_valid_filter_6_6;
    din_valid_6_6_r1 <= din_valid_6_6;
    din_valid_6_6_r2 <= din_valid_6_6_r1;

    din_6_6.data <= hash_out_valid_filter_6_6 ? hash_out_6_6 : 0;
    din_6_6.last <= out_new_pkt;
    din_6_6.bucket <= 6;


    din_6_6_r1 <= din_6_6;
    din_6_6_r2 <= din_6_6_r1;
    din_valid_6_7 <= out_new_pkt | hash_out_valid_filter_6_7;
    din_valid_6_7_r1 <= din_valid_6_7;
    din_valid_6_7_r2 <= din_valid_6_7_r1;

    din_6_7.data <= hash_out_valid_filter_6_7 ? hash_out_6_7 : 0;
    din_6_7.last <= out_new_pkt;
    din_6_7.bucket <= 6;


    din_6_7_r1 <= din_6_7;
    din_6_7_r2 <= din_6_7_r1;
    din_valid_7_0 <= out_new_pkt | hash_out_valid_filter_7_0;
    din_valid_7_0_r1 <= din_valid_7_0;
    din_valid_7_0_r2 <= din_valid_7_0_r1;

    din_7_0.data <= hash_out_valid_filter_7_0 ? hash_out_7_0 : 0;
    din_7_0.last <= out_new_pkt;
    din_7_0.bucket <= 7;


    din_7_0_r1 <= din_7_0;
    din_7_0_r2 <= din_7_0_r1;
    din_valid_7_1 <= out_new_pkt | hash_out_valid_filter_7_1;
    din_valid_7_1_r1 <= din_valid_7_1;
    din_valid_7_1_r2 <= din_valid_7_1_r1;

    din_7_1.data <= hash_out_valid_filter_7_1 ? hash_out_7_1 : 0;
    din_7_1.last <= out_new_pkt;
    din_7_1.bucket <= 7;


    din_7_1_r1 <= din_7_1;
    din_7_1_r2 <= din_7_1_r1;
    din_valid_7_2 <= out_new_pkt | hash_out_valid_filter_7_2;
    din_valid_7_2_r1 <= din_valid_7_2;
    din_valid_7_2_r2 <= din_valid_7_2_r1;

    din_7_2.data <= hash_out_valid_filter_7_2 ? hash_out_7_2 : 0;
    din_7_2.last <= out_new_pkt;
    din_7_2.bucket <= 7;


    din_7_2_r1 <= din_7_2;
    din_7_2_r2 <= din_7_2_r1;
    din_valid_7_3 <= out_new_pkt | hash_out_valid_filter_7_3;
    din_valid_7_3_r1 <= din_valid_7_3;
    din_valid_7_3_r2 <= din_valid_7_3_r1;

    din_7_3.data <= hash_out_valid_filter_7_3 ? hash_out_7_3 : 0;
    din_7_3.last <= out_new_pkt;
    din_7_3.bucket <= 7;


    din_7_3_r1 <= din_7_3;
    din_7_3_r2 <= din_7_3_r1;
    din_valid_7_4 <= out_new_pkt | hash_out_valid_filter_7_4;
    din_valid_7_4_r1 <= din_valid_7_4;
    din_valid_7_4_r2 <= din_valid_7_4_r1;

    din_7_4.data <= hash_out_valid_filter_7_4 ? hash_out_7_4 : 0;
    din_7_4.last <= out_new_pkt;
    din_7_4.bucket <= 7;


    din_7_4_r1 <= din_7_4;
    din_7_4_r2 <= din_7_4_r1;
    din_valid_7_5 <= out_new_pkt | hash_out_valid_filter_7_5;
    din_valid_7_5_r1 <= din_valid_7_5;
    din_valid_7_5_r2 <= din_valid_7_5_r1;

    din_7_5.data <= hash_out_valid_filter_7_5 ? hash_out_7_5 : 0;
    din_7_5.last <= out_new_pkt;
    din_7_5.bucket <= 7;


    din_7_5_r1 <= din_7_5;
    din_7_5_r2 <= din_7_5_r1;
    din_valid_7_6 <= out_new_pkt | hash_out_valid_filter_7_6;
    din_valid_7_6_r1 <= din_valid_7_6;
    din_valid_7_6_r2 <= din_valid_7_6_r1;

    din_7_6.data <= hash_out_valid_filter_7_6 ? hash_out_7_6 : 0;
    din_7_6.last <= out_new_pkt;
    din_7_6.bucket <= 7;


    din_7_6_r1 <= din_7_6;
    din_7_6_r2 <= din_7_6_r1;
    din_valid_7_7 <= out_new_pkt | hash_out_valid_filter_7_7;
    din_valid_7_7_r1 <= din_valid_7_7;
    din_valid_7_7_r2 <= din_valid_7_7_r1;

    din_7_7.data <= hash_out_valid_filter_7_7 ? hash_out_7_7 : 0;
    din_7_7.last <= out_new_pkt;
    din_7_7.bucket <= 7;


    din_7_7_r1 <= din_7_7;
    din_7_7_r2 <= din_7_7_r1;
end

//Instantiation
frontend front(
    .clk(clk),
    .rst(rst),
    .hash_out_0_0(hash_out_0_0),
    .hash_out_valid_filter_0_0(hash_out_valid_filter_0_0),
    .hash_out_0_1(hash_out_0_1),
    .hash_out_valid_filter_0_1(hash_out_valid_filter_0_1),
    .hash_out_0_2(hash_out_0_2),
    .hash_out_valid_filter_0_2(hash_out_valid_filter_0_2),
    .hash_out_0_3(hash_out_0_3),
    .hash_out_valid_filter_0_3(hash_out_valid_filter_0_3),
    .hash_out_0_4(hash_out_0_4),
    .hash_out_valid_filter_0_4(hash_out_valid_filter_0_4),
    .hash_out_0_5(hash_out_0_5),
    .hash_out_valid_filter_0_5(hash_out_valid_filter_0_5),
    .hash_out_0_6(hash_out_0_6),
    .hash_out_valid_filter_0_6(hash_out_valid_filter_0_6),
    .hash_out_0_7(hash_out_0_7),
    .hash_out_valid_filter_0_7(hash_out_valid_filter_0_7),
    .hash_out_1_0(hash_out_1_0),
    .hash_out_valid_filter_1_0(hash_out_valid_filter_1_0),
    .hash_out_1_1(hash_out_1_1),
    .hash_out_valid_filter_1_1(hash_out_valid_filter_1_1),
    .hash_out_1_2(hash_out_1_2),
    .hash_out_valid_filter_1_2(hash_out_valid_filter_1_2),
    .hash_out_1_3(hash_out_1_3),
    .hash_out_valid_filter_1_3(hash_out_valid_filter_1_3),
    .hash_out_1_4(hash_out_1_4),
    .hash_out_valid_filter_1_4(hash_out_valid_filter_1_4),
    .hash_out_1_5(hash_out_1_5),
    .hash_out_valid_filter_1_5(hash_out_valid_filter_1_5),
    .hash_out_1_6(hash_out_1_6),
    .hash_out_valid_filter_1_6(hash_out_valid_filter_1_6),
    .hash_out_1_7(hash_out_1_7),
    .hash_out_valid_filter_1_7(hash_out_valid_filter_1_7),
    .hash_out_2_0(hash_out_2_0),
    .hash_out_valid_filter_2_0(hash_out_valid_filter_2_0),
    .hash_out_2_1(hash_out_2_1),
    .hash_out_valid_filter_2_1(hash_out_valid_filter_2_1),
    .hash_out_2_2(hash_out_2_2),
    .hash_out_valid_filter_2_2(hash_out_valid_filter_2_2),
    .hash_out_2_3(hash_out_2_3),
    .hash_out_valid_filter_2_3(hash_out_valid_filter_2_3),
    .hash_out_2_4(hash_out_2_4),
    .hash_out_valid_filter_2_4(hash_out_valid_filter_2_4),
    .hash_out_2_5(hash_out_2_5),
    .hash_out_valid_filter_2_5(hash_out_valid_filter_2_5),
    .hash_out_2_6(hash_out_2_6),
    .hash_out_valid_filter_2_6(hash_out_valid_filter_2_6),
    .hash_out_2_7(hash_out_2_7),
    .hash_out_valid_filter_2_7(hash_out_valid_filter_2_7),
    .hash_out_3_0(hash_out_3_0),
    .hash_out_valid_filter_3_0(hash_out_valid_filter_3_0),
    .hash_out_3_1(hash_out_3_1),
    .hash_out_valid_filter_3_1(hash_out_valid_filter_3_1),
    .hash_out_3_2(hash_out_3_2),
    .hash_out_valid_filter_3_2(hash_out_valid_filter_3_2),
    .hash_out_3_3(hash_out_3_3),
    .hash_out_valid_filter_3_3(hash_out_valid_filter_3_3),
    .hash_out_3_4(hash_out_3_4),
    .hash_out_valid_filter_3_4(hash_out_valid_filter_3_4),
    .hash_out_3_5(hash_out_3_5),
    .hash_out_valid_filter_3_5(hash_out_valid_filter_3_5),
    .hash_out_3_6(hash_out_3_6),
    .hash_out_valid_filter_3_6(hash_out_valid_filter_3_6),
    .hash_out_3_7(hash_out_3_7),
    .hash_out_valid_filter_3_7(hash_out_valid_filter_3_7),
    .hash_out_4_0(hash_out_4_0),
    .hash_out_valid_filter_4_0(hash_out_valid_filter_4_0),
    .hash_out_4_1(hash_out_4_1),
    .hash_out_valid_filter_4_1(hash_out_valid_filter_4_1),
    .hash_out_4_2(hash_out_4_2),
    .hash_out_valid_filter_4_2(hash_out_valid_filter_4_2),
    .hash_out_4_3(hash_out_4_3),
    .hash_out_valid_filter_4_3(hash_out_valid_filter_4_3),
    .hash_out_4_4(hash_out_4_4),
    .hash_out_valid_filter_4_4(hash_out_valid_filter_4_4),
    .hash_out_4_5(hash_out_4_5),
    .hash_out_valid_filter_4_5(hash_out_valid_filter_4_5),
    .hash_out_4_6(hash_out_4_6),
    .hash_out_valid_filter_4_6(hash_out_valid_filter_4_6),
    .hash_out_4_7(hash_out_4_7),
    .hash_out_valid_filter_4_7(hash_out_valid_filter_4_7),
    .hash_out_5_0(hash_out_5_0),
    .hash_out_valid_filter_5_0(hash_out_valid_filter_5_0),
    .hash_out_5_1(hash_out_5_1),
    .hash_out_valid_filter_5_1(hash_out_valid_filter_5_1),
    .hash_out_5_2(hash_out_5_2),
    .hash_out_valid_filter_5_2(hash_out_valid_filter_5_2),
    .hash_out_5_3(hash_out_5_3),
    .hash_out_valid_filter_5_3(hash_out_valid_filter_5_3),
    .hash_out_5_4(hash_out_5_4),
    .hash_out_valid_filter_5_4(hash_out_valid_filter_5_4),
    .hash_out_5_5(hash_out_5_5),
    .hash_out_valid_filter_5_5(hash_out_valid_filter_5_5),
    .hash_out_5_6(hash_out_5_6),
    .hash_out_valid_filter_5_6(hash_out_valid_filter_5_6),
    .hash_out_5_7(hash_out_5_7),
    .hash_out_valid_filter_5_7(hash_out_valid_filter_5_7),
    .hash_out_6_0(hash_out_6_0),
    .hash_out_valid_filter_6_0(hash_out_valid_filter_6_0),
    .hash_out_6_1(hash_out_6_1),
    .hash_out_valid_filter_6_1(hash_out_valid_filter_6_1),
    .hash_out_6_2(hash_out_6_2),
    .hash_out_valid_filter_6_2(hash_out_valid_filter_6_2),
    .hash_out_6_3(hash_out_6_3),
    .hash_out_valid_filter_6_3(hash_out_valid_filter_6_3),
    .hash_out_6_4(hash_out_6_4),
    .hash_out_valid_filter_6_4(hash_out_valid_filter_6_4),
    .hash_out_6_5(hash_out_6_5),
    .hash_out_valid_filter_6_5(hash_out_valid_filter_6_5),
    .hash_out_6_6(hash_out_6_6),
    .hash_out_valid_filter_6_6(hash_out_valid_filter_6_6),
    .hash_out_6_7(hash_out_6_7),
    .hash_out_valid_filter_6_7(hash_out_valid_filter_6_7),
    .hash_out_7_0(hash_out_7_0),
    .hash_out_valid_filter_7_0(hash_out_valid_filter_7_0),
    .hash_out_7_1(hash_out_7_1),
    .hash_out_valid_filter_7_1(hash_out_valid_filter_7_1),
    .hash_out_7_2(hash_out_7_2),
    .hash_out_valid_filter_7_2(hash_out_valid_filter_7_2),
    .hash_out_7_3(hash_out_7_3),
    .hash_out_valid_filter_7_3(hash_out_valid_filter_7_3),
    .hash_out_7_4(hash_out_7_4),
    .hash_out_valid_filter_7_4(hash_out_valid_filter_7_4),
    .hash_out_7_5(hash_out_7_5),
    .hash_out_valid_filter_7_5(hash_out_valid_filter_7_5),
    .hash_out_7_6(hash_out_7_6),
    .hash_out_valid_filter_7_6(hash_out_valid_filter_7_6),
    .hash_out_7_7(hash_out_7_7),
    .hash_out_valid_filter_7_7(hash_out_valid_filter_7_7),
    .in_data(in_data_r2),
    .in_valid(in_valid_r2),
    .in_sop(in_sop_r2),
    .in_eop(in_eop_r2),
    .in_empty(in_empty_r2),
    .out_new_pkt(out_new_pkt)
);

//RuleID reduction logic
backend back(
    .clk(clk),
    .rst(rst),
    .din_0_0(din_0_0_r2),
    .din_valid_0_0(din_valid_0_0_r2),
    .din_almost_full_0_0(din_almost_full_0_0),
    .din_0_1(din_0_1_r2),
    .din_valid_0_1(din_valid_0_1_r2),
    .din_almost_full_0_1(din_almost_full_0_1),
    .din_0_2(din_0_2_r2),
    .din_valid_0_2(din_valid_0_2_r2),
    .din_almost_full_0_2(din_almost_full_0_2),
    .din_0_3(din_0_3_r2),
    .din_valid_0_3(din_valid_0_3_r2),
    .din_almost_full_0_3(din_almost_full_0_3),
    .din_0_4(din_0_4_r2),
    .din_valid_0_4(din_valid_0_4_r2),
    .din_almost_full_0_4(din_almost_full_0_4),
    .din_0_5(din_0_5_r2),
    .din_valid_0_5(din_valid_0_5_r2),
    .din_almost_full_0_5(din_almost_full_0_5),
    .din_0_6(din_0_6_r2),
    .din_valid_0_6(din_valid_0_6_r2),
    .din_almost_full_0_6(din_almost_full_0_6),
    .din_0_7(din_0_7_r2),
    .din_valid_0_7(din_valid_0_7_r2),
    .din_almost_full_0_7(din_almost_full_0_7),
    .din_1_0(din_1_0_r2),
    .din_valid_1_0(din_valid_1_0_r2),
    .din_almost_full_1_0(din_almost_full_1_0),
    .din_1_1(din_1_1_r2),
    .din_valid_1_1(din_valid_1_1_r2),
    .din_almost_full_1_1(din_almost_full_1_1),
    .din_1_2(din_1_2_r2),
    .din_valid_1_2(din_valid_1_2_r2),
    .din_almost_full_1_2(din_almost_full_1_2),
    .din_1_3(din_1_3_r2),
    .din_valid_1_3(din_valid_1_3_r2),
    .din_almost_full_1_3(din_almost_full_1_3),
    .din_1_4(din_1_4_r2),
    .din_valid_1_4(din_valid_1_4_r2),
    .din_almost_full_1_4(din_almost_full_1_4),
    .din_1_5(din_1_5_r2),
    .din_valid_1_5(din_valid_1_5_r2),
    .din_almost_full_1_5(din_almost_full_1_5),
    .din_1_6(din_1_6_r2),
    .din_valid_1_6(din_valid_1_6_r2),
    .din_almost_full_1_6(din_almost_full_1_6),
    .din_1_7(din_1_7_r2),
    .din_valid_1_7(din_valid_1_7_r2),
    .din_almost_full_1_7(din_almost_full_1_7),
    .din_2_0(din_2_0_r2),
    .din_valid_2_0(din_valid_2_0_r2),
    .din_almost_full_2_0(din_almost_full_2_0),
    .din_2_1(din_2_1_r2),
    .din_valid_2_1(din_valid_2_1_r2),
    .din_almost_full_2_1(din_almost_full_2_1),
    .din_2_2(din_2_2_r2),
    .din_valid_2_2(din_valid_2_2_r2),
    .din_almost_full_2_2(din_almost_full_2_2),
    .din_2_3(din_2_3_r2),
    .din_valid_2_3(din_valid_2_3_r2),
    .din_almost_full_2_3(din_almost_full_2_3),
    .din_2_4(din_2_4_r2),
    .din_valid_2_4(din_valid_2_4_r2),
    .din_almost_full_2_4(din_almost_full_2_4),
    .din_2_5(din_2_5_r2),
    .din_valid_2_5(din_valid_2_5_r2),
    .din_almost_full_2_5(din_almost_full_2_5),
    .din_2_6(din_2_6_r2),
    .din_valid_2_6(din_valid_2_6_r2),
    .din_almost_full_2_6(din_almost_full_2_6),
    .din_2_7(din_2_7_r2),
    .din_valid_2_7(din_valid_2_7_r2),
    .din_almost_full_2_7(din_almost_full_2_7),
    .din_3_0(din_3_0_r2),
    .din_valid_3_0(din_valid_3_0_r2),
    .din_almost_full_3_0(din_almost_full_3_0),
    .din_3_1(din_3_1_r2),
    .din_valid_3_1(din_valid_3_1_r2),
    .din_almost_full_3_1(din_almost_full_3_1),
    .din_3_2(din_3_2_r2),
    .din_valid_3_2(din_valid_3_2_r2),
    .din_almost_full_3_2(din_almost_full_3_2),
    .din_3_3(din_3_3_r2),
    .din_valid_3_3(din_valid_3_3_r2),
    .din_almost_full_3_3(din_almost_full_3_3),
    .din_3_4(din_3_4_r2),
    .din_valid_3_4(din_valid_3_4_r2),
    .din_almost_full_3_4(din_almost_full_3_4),
    .din_3_5(din_3_5_r2),
    .din_valid_3_5(din_valid_3_5_r2),
    .din_almost_full_3_5(din_almost_full_3_5),
    .din_3_6(din_3_6_r2),
    .din_valid_3_6(din_valid_3_6_r2),
    .din_almost_full_3_6(din_almost_full_3_6),
    .din_3_7(din_3_7_r2),
    .din_valid_3_7(din_valid_3_7_r2),
    .din_almost_full_3_7(din_almost_full_3_7),
    .din_4_0(din_4_0_r2),
    .din_valid_4_0(din_valid_4_0_r2),
    .din_almost_full_4_0(din_almost_full_4_0),
    .din_4_1(din_4_1_r2),
    .din_valid_4_1(din_valid_4_1_r2),
    .din_almost_full_4_1(din_almost_full_4_1),
    .din_4_2(din_4_2_r2),
    .din_valid_4_2(din_valid_4_2_r2),
    .din_almost_full_4_2(din_almost_full_4_2),
    .din_4_3(din_4_3_r2),
    .din_valid_4_3(din_valid_4_3_r2),
    .din_almost_full_4_3(din_almost_full_4_3),
    .din_4_4(din_4_4_r2),
    .din_valid_4_4(din_valid_4_4_r2),
    .din_almost_full_4_4(din_almost_full_4_4),
    .din_4_5(din_4_5_r2),
    .din_valid_4_5(din_valid_4_5_r2),
    .din_almost_full_4_5(din_almost_full_4_5),
    .din_4_6(din_4_6_r2),
    .din_valid_4_6(din_valid_4_6_r2),
    .din_almost_full_4_6(din_almost_full_4_6),
    .din_4_7(din_4_7_r2),
    .din_valid_4_7(din_valid_4_7_r2),
    .din_almost_full_4_7(din_almost_full_4_7),
    .din_5_0(din_5_0_r2),
    .din_valid_5_0(din_valid_5_0_r2),
    .din_almost_full_5_0(din_almost_full_5_0),
    .din_5_1(din_5_1_r2),
    .din_valid_5_1(din_valid_5_1_r2),
    .din_almost_full_5_1(din_almost_full_5_1),
    .din_5_2(din_5_2_r2),
    .din_valid_5_2(din_valid_5_2_r2),
    .din_almost_full_5_2(din_almost_full_5_2),
    .din_5_3(din_5_3_r2),
    .din_valid_5_3(din_valid_5_3_r2),
    .din_almost_full_5_3(din_almost_full_5_3),
    .din_5_4(din_5_4_r2),
    .din_valid_5_4(din_valid_5_4_r2),
    .din_almost_full_5_4(din_almost_full_5_4),
    .din_5_5(din_5_5_r2),
    .din_valid_5_5(din_valid_5_5_r2),
    .din_almost_full_5_5(din_almost_full_5_5),
    .din_5_6(din_5_6_r2),
    .din_valid_5_6(din_valid_5_6_r2),
    .din_almost_full_5_6(din_almost_full_5_6),
    .din_5_7(din_5_7_r2),
    .din_valid_5_7(din_valid_5_7_r2),
    .din_almost_full_5_7(din_almost_full_5_7),
    .din_6_0(din_6_0_r2),
    .din_valid_6_0(din_valid_6_0_r2),
    .din_almost_full_6_0(din_almost_full_6_0),
    .din_6_1(din_6_1_r2),
    .din_valid_6_1(din_valid_6_1_r2),
    .din_almost_full_6_1(din_almost_full_6_1),
    .din_6_2(din_6_2_r2),
    .din_valid_6_2(din_valid_6_2_r2),
    .din_almost_full_6_2(din_almost_full_6_2),
    .din_6_3(din_6_3_r2),
    .din_valid_6_3(din_valid_6_3_r2),
    .din_almost_full_6_3(din_almost_full_6_3),
    .din_6_4(din_6_4_r2),
    .din_valid_6_4(din_valid_6_4_r2),
    .din_almost_full_6_4(din_almost_full_6_4),
    .din_6_5(din_6_5_r2),
    .din_valid_6_5(din_valid_6_5_r2),
    .din_almost_full_6_5(din_almost_full_6_5),
    .din_6_6(din_6_6_r2),
    .din_valid_6_6(din_valid_6_6_r2),
    .din_almost_full_6_6(din_almost_full_6_6),
    .din_6_7(din_6_7_r2),
    .din_valid_6_7(din_valid_6_7_r2),
    .din_almost_full_6_7(din_almost_full_6_7),
    .din_7_0(din_7_0_r2),
    .din_valid_7_0(din_valid_7_0_r2),
    .din_almost_full_7_0(din_almost_full_7_0),
    .din_7_1(din_7_1_r2),
    .din_valid_7_1(din_valid_7_1_r2),
    .din_almost_full_7_1(din_almost_full_7_1),
    .din_7_2(din_7_2_r2),
    .din_valid_7_2(din_valid_7_2_r2),
    .din_almost_full_7_2(din_almost_full_7_2),
    .din_7_3(din_7_3_r2),
    .din_valid_7_3(din_valid_7_3_r2),
    .din_almost_full_7_3(din_almost_full_7_3),
    .din_7_4(din_7_4_r2),
    .din_valid_7_4(din_valid_7_4_r2),
    .din_almost_full_7_4(din_almost_full_7_4),
    .din_7_5(din_7_5_r2),
    .din_valid_7_5(din_valid_7_5_r2),
    .din_almost_full_7_5(din_almost_full_7_5),
    .din_7_6(din_7_6_r2),
    .din_valid_7_6(din_valid_7_6_r2),
    .din_almost_full_7_6(din_almost_full_7_6),
    .din_7_7(din_7_7_r2),
    .din_valid_7_7(din_valid_7_7_r2),
    .din_almost_full_7_7(din_almost_full_7_7),
    .ruleID(out_data),
    .ruleID_valid(out_valid),
    .ruleID_last(out_last),
    .ruleID_almost_full(out_almost_full)
);

endmodule //top