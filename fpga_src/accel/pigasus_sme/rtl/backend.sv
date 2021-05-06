`include "struct_s.sv"
module backend(clk,rst,
    din_0_0,
    din_valid_0_0,
    din_almost_full_0_0,
    din_0_1,
    din_valid_0_1,
    din_almost_full_0_1,
    din_0_2,
    din_valid_0_2,
    din_almost_full_0_2,
    din_0_3,
    din_valid_0_3,
    din_almost_full_0_3,
    din_0_4,
    din_valid_0_4,
    din_almost_full_0_4,
    din_0_5,
    din_valid_0_5,
    din_almost_full_0_5,
    din_0_6,
    din_valid_0_6,
    din_almost_full_0_6,
    din_0_7,
    din_valid_0_7,
    din_almost_full_0_7,
    din_1_0,
    din_valid_1_0,
    din_almost_full_1_0,
    din_1_1,
    din_valid_1_1,
    din_almost_full_1_1,
    din_1_2,
    din_valid_1_2,
    din_almost_full_1_2,
    din_1_3,
    din_valid_1_3,
    din_almost_full_1_3,
    din_1_4,
    din_valid_1_4,
    din_almost_full_1_4,
    din_1_5,
    din_valid_1_5,
    din_almost_full_1_5,
    din_1_6,
    din_valid_1_6,
    din_almost_full_1_6,
    din_1_7,
    din_valid_1_7,
    din_almost_full_1_7,
    din_2_0,
    din_valid_2_0,
    din_almost_full_2_0,
    din_2_1,
    din_valid_2_1,
    din_almost_full_2_1,
    din_2_2,
    din_valid_2_2,
    din_almost_full_2_2,
    din_2_3,
    din_valid_2_3,
    din_almost_full_2_3,
    din_2_4,
    din_valid_2_4,
    din_almost_full_2_4,
    din_2_5,
    din_valid_2_5,
    din_almost_full_2_5,
    din_2_6,
    din_valid_2_6,
    din_almost_full_2_6,
    din_2_7,
    din_valid_2_7,
    din_almost_full_2_7,
    din_3_0,
    din_valid_3_0,
    din_almost_full_3_0,
    din_3_1,
    din_valid_3_1,
    din_almost_full_3_1,
    din_3_2,
    din_valid_3_2,
    din_almost_full_3_2,
    din_3_3,
    din_valid_3_3,
    din_almost_full_3_3,
    din_3_4,
    din_valid_3_4,
    din_almost_full_3_4,
    din_3_5,
    din_valid_3_5,
    din_almost_full_3_5,
    din_3_6,
    din_valid_3_6,
    din_almost_full_3_6,
    din_3_7,
    din_valid_3_7,
    din_almost_full_3_7,
    din_4_0,
    din_valid_4_0,
    din_almost_full_4_0,
    din_4_1,
    din_valid_4_1,
    din_almost_full_4_1,
    din_4_2,
    din_valid_4_2,
    din_almost_full_4_2,
    din_4_3,
    din_valid_4_3,
    din_almost_full_4_3,
    din_4_4,
    din_valid_4_4,
    din_almost_full_4_4,
    din_4_5,
    din_valid_4_5,
    din_almost_full_4_5,
    din_4_6,
    din_valid_4_6,
    din_almost_full_4_6,
    din_4_7,
    din_valid_4_7,
    din_almost_full_4_7,
    din_5_0,
    din_valid_5_0,
    din_almost_full_5_0,
    din_5_1,
    din_valid_5_1,
    din_almost_full_5_1,
    din_5_2,
    din_valid_5_2,
    din_almost_full_5_2,
    din_5_3,
    din_valid_5_3,
    din_almost_full_5_3,
    din_5_4,
    din_valid_5_4,
    din_almost_full_5_4,
    din_5_5,
    din_valid_5_5,
    din_almost_full_5_5,
    din_5_6,
    din_valid_5_6,
    din_almost_full_5_6,
    din_5_7,
    din_valid_5_7,
    din_almost_full_5_7,
    din_6_0,
    din_valid_6_0,
    din_almost_full_6_0,
    din_6_1,
    din_valid_6_1,
    din_almost_full_6_1,
    din_6_2,
    din_valid_6_2,
    din_almost_full_6_2,
    din_6_3,
    din_valid_6_3,
    din_almost_full_6_3,
    din_6_4,
    din_valid_6_4,
    din_almost_full_6_4,
    din_6_5,
    din_valid_6_5,
    din_almost_full_6_5,
    din_6_6,
    din_valid_6_6,
    din_almost_full_6_6,
    din_6_7,
    din_valid_6_7,
    din_almost_full_6_7,
    din_7_0,
    din_valid_7_0,
    din_almost_full_7_0,
    din_7_1,
    din_valid_7_1,
    din_almost_full_7_1,
    din_7_2,
    din_valid_7_2,
    din_almost_full_7_2,
    din_7_3,
    din_valid_7_3,
    din_almost_full_7_3,
    din_7_4,
    din_valid_7_4,
    din_almost_full_7_4,
    din_7_5,
    din_valid_7_5,
    din_almost_full_7_5,
    din_7_6,
    din_valid_7_6,
    din_almost_full_7_6,
    din_7_7,
    din_valid_7_7,
    din_almost_full_7_7,
    ruleID,ruleID_valid,ruleID_last,ruleID_almost_full
);

input clk;
input rst;
input rule_s_t din_0_0;
input din_valid_0_0;
output logic din_almost_full_0_0;
input rule_s_t din_0_1;
input din_valid_0_1;
output logic din_almost_full_0_1;
input rule_s_t din_0_2;
input din_valid_0_2;
output logic din_almost_full_0_2;
input rule_s_t din_0_3;
input din_valid_0_3;
output logic din_almost_full_0_3;
input rule_s_t din_0_4;
input din_valid_0_4;
output logic din_almost_full_0_4;
input rule_s_t din_0_5;
input din_valid_0_5;
output logic din_almost_full_0_5;
input rule_s_t din_0_6;
input din_valid_0_6;
output logic din_almost_full_0_6;
input rule_s_t din_0_7;
input din_valid_0_7;
output logic din_almost_full_0_7;
input rule_s_t din_1_0;
input din_valid_1_0;
output logic din_almost_full_1_0;
input rule_s_t din_1_1;
input din_valid_1_1;
output logic din_almost_full_1_1;
input rule_s_t din_1_2;
input din_valid_1_2;
output logic din_almost_full_1_2;
input rule_s_t din_1_3;
input din_valid_1_3;
output logic din_almost_full_1_3;
input rule_s_t din_1_4;
input din_valid_1_4;
output logic din_almost_full_1_4;
input rule_s_t din_1_5;
input din_valid_1_5;
output logic din_almost_full_1_5;
input rule_s_t din_1_6;
input din_valid_1_6;
output logic din_almost_full_1_6;
input rule_s_t din_1_7;
input din_valid_1_7;
output logic din_almost_full_1_7;
input rule_s_t din_2_0;
input din_valid_2_0;
output logic din_almost_full_2_0;
input rule_s_t din_2_1;
input din_valid_2_1;
output logic din_almost_full_2_1;
input rule_s_t din_2_2;
input din_valid_2_2;
output logic din_almost_full_2_2;
input rule_s_t din_2_3;
input din_valid_2_3;
output logic din_almost_full_2_3;
input rule_s_t din_2_4;
input din_valid_2_4;
output logic din_almost_full_2_4;
input rule_s_t din_2_5;
input din_valid_2_5;
output logic din_almost_full_2_5;
input rule_s_t din_2_6;
input din_valid_2_6;
output logic din_almost_full_2_6;
input rule_s_t din_2_7;
input din_valid_2_7;
output logic din_almost_full_2_7;
input rule_s_t din_3_0;
input din_valid_3_0;
output logic din_almost_full_3_0;
input rule_s_t din_3_1;
input din_valid_3_1;
output logic din_almost_full_3_1;
input rule_s_t din_3_2;
input din_valid_3_2;
output logic din_almost_full_3_2;
input rule_s_t din_3_3;
input din_valid_3_3;
output logic din_almost_full_3_3;
input rule_s_t din_3_4;
input din_valid_3_4;
output logic din_almost_full_3_4;
input rule_s_t din_3_5;
input din_valid_3_5;
output logic din_almost_full_3_5;
input rule_s_t din_3_6;
input din_valid_3_6;
output logic din_almost_full_3_6;
input rule_s_t din_3_7;
input din_valid_3_7;
output logic din_almost_full_3_7;
input rule_s_t din_4_0;
input din_valid_4_0;
output logic din_almost_full_4_0;
input rule_s_t din_4_1;
input din_valid_4_1;
output logic din_almost_full_4_1;
input rule_s_t din_4_2;
input din_valid_4_2;
output logic din_almost_full_4_2;
input rule_s_t din_4_3;
input din_valid_4_3;
output logic din_almost_full_4_3;
input rule_s_t din_4_4;
input din_valid_4_4;
output logic din_almost_full_4_4;
input rule_s_t din_4_5;
input din_valid_4_5;
output logic din_almost_full_4_5;
input rule_s_t din_4_6;
input din_valid_4_6;
output logic din_almost_full_4_6;
input rule_s_t din_4_7;
input din_valid_4_7;
output logic din_almost_full_4_7;
input rule_s_t din_5_0;
input din_valid_5_0;
output logic din_almost_full_5_0;
input rule_s_t din_5_1;
input din_valid_5_1;
output logic din_almost_full_5_1;
input rule_s_t din_5_2;
input din_valid_5_2;
output logic din_almost_full_5_2;
input rule_s_t din_5_3;
input din_valid_5_3;
output logic din_almost_full_5_3;
input rule_s_t din_5_4;
input din_valid_5_4;
output logic din_almost_full_5_4;
input rule_s_t din_5_5;
input din_valid_5_5;
output logic din_almost_full_5_5;
input rule_s_t din_5_6;
input din_valid_5_6;
output logic din_almost_full_5_6;
input rule_s_t din_5_7;
input din_valid_5_7;
output logic din_almost_full_5_7;
input rule_s_t din_6_0;
input din_valid_6_0;
output logic din_almost_full_6_0;
input rule_s_t din_6_1;
input din_valid_6_1;
output logic din_almost_full_6_1;
input rule_s_t din_6_2;
input din_valid_6_2;
output logic din_almost_full_6_2;
input rule_s_t din_6_3;
input din_valid_6_3;
output logic din_almost_full_6_3;
input rule_s_t din_6_4;
input din_valid_6_4;
output logic din_almost_full_6_4;
input rule_s_t din_6_5;
input din_valid_6_5;
output logic din_almost_full_6_5;
input rule_s_t din_6_6;
input din_valid_6_6;
output logic din_almost_full_6_6;
input rule_s_t din_6_7;
input din_valid_6_7;
output logic din_almost_full_6_7;
input rule_s_t din_7_0;
input din_valid_7_0;
output logic din_almost_full_7_0;
input rule_s_t din_7_1;
input din_valid_7_1;
output logic din_almost_full_7_1;
input rule_s_t din_7_2;
input din_valid_7_2;
output logic din_almost_full_7_2;
input rule_s_t din_7_3;
input din_valid_7_3;
output logic din_almost_full_7_3;
input rule_s_t din_7_4;
input din_valid_7_4;
output logic din_almost_full_7_4;
input rule_s_t din_7_5;
input din_valid_7_5;
output logic din_almost_full_7_5;
input rule_s_t din_7_6;
input din_valid_7_6;
output logic din_almost_full_7_6;
input rule_s_t din_7_7;
input din_valid_7_7;
output logic din_almost_full_7_7;
output logic [127:0] ruleID;
output logic ruleID_valid;
output logic ruleID_last;
input ruleID_almost_full;

localparam L1_FIFO_DEPTH = 64;
localparam FIFO_DEPTH = 32;
localparam FIFO_AWIDTH = ($clog2(FIFO_DEPTH));
localparam L1_TH = (L1_FIFO_DEPTH-24);
localparam L2_TH = (FIFO_DEPTH-3);
localparam L3_TH = (FIFO_DEPTH-3);
localparam L4_TH = (FIFO_DEPTH-3);

//L1 FIFO
logic [31:0]   din_csr_readdata_0_0_r1;
logic [31:0]   din_csr_readdata_0_0_r2;

rule_s_t    l1_data_0_0;
logic       l1_ready_0_0;
logic       l1_valid_0_0;
logic       l1_newdata_0_0;
logic [RID_WIDTH-1:0] l1_cache_0_0;
logic [31:0]   din_csr_readdata_0_1_r1;
logic [31:0]   din_csr_readdata_0_1_r2;

rule_s_t    l1_data_0_1;
logic       l1_ready_0_1;
logic       l1_valid_0_1;
logic       l1_newdata_0_1;
logic [RID_WIDTH-1:0] l1_cache_0_1;
logic [31:0]   din_csr_readdata_0_2_r1;
logic [31:0]   din_csr_readdata_0_2_r2;

rule_s_t    l1_data_0_2;
logic       l1_ready_0_2;
logic       l1_valid_0_2;
logic       l1_newdata_0_2;
logic [RID_WIDTH-1:0] l1_cache_0_2;
logic [31:0]   din_csr_readdata_0_3_r1;
logic [31:0]   din_csr_readdata_0_3_r2;

rule_s_t    l1_data_0_3;
logic       l1_ready_0_3;
logic       l1_valid_0_3;
logic       l1_newdata_0_3;
logic [RID_WIDTH-1:0] l1_cache_0_3;
logic [31:0]   din_csr_readdata_0_4_r1;
logic [31:0]   din_csr_readdata_0_4_r2;

rule_s_t    l1_data_0_4;
logic       l1_ready_0_4;
logic       l1_valid_0_4;
logic       l1_newdata_0_4;
logic [RID_WIDTH-1:0] l1_cache_0_4;
logic [31:0]   din_csr_readdata_0_5_r1;
logic [31:0]   din_csr_readdata_0_5_r2;

rule_s_t    l1_data_0_5;
logic       l1_ready_0_5;
logic       l1_valid_0_5;
logic       l1_newdata_0_5;
logic [RID_WIDTH-1:0] l1_cache_0_5;
logic [31:0]   din_csr_readdata_0_6_r1;
logic [31:0]   din_csr_readdata_0_6_r2;

rule_s_t    l1_data_0_6;
logic       l1_ready_0_6;
logic       l1_valid_0_6;
logic       l1_newdata_0_6;
logic [RID_WIDTH-1:0] l1_cache_0_6;
logic [31:0]   din_csr_readdata_0_7_r1;
logic [31:0]   din_csr_readdata_0_7_r2;

rule_s_t    l1_data_0_7;
logic       l1_ready_0_7;
logic       l1_valid_0_7;
logic       l1_newdata_0_7;
logic [RID_WIDTH-1:0] l1_cache_0_7;
logic [31:0]   din_csr_readdata_1_0_r1;
logic [31:0]   din_csr_readdata_1_0_r2;

rule_s_t    l1_data_1_0;
logic       l1_ready_1_0;
logic       l1_valid_1_0;
logic       l1_newdata_1_0;
logic [RID_WIDTH-1:0] l1_cache_1_0;
logic [31:0]   din_csr_readdata_1_1_r1;
logic [31:0]   din_csr_readdata_1_1_r2;

rule_s_t    l1_data_1_1;
logic       l1_ready_1_1;
logic       l1_valid_1_1;
logic       l1_newdata_1_1;
logic [RID_WIDTH-1:0] l1_cache_1_1;
logic [31:0]   din_csr_readdata_1_2_r1;
logic [31:0]   din_csr_readdata_1_2_r2;

rule_s_t    l1_data_1_2;
logic       l1_ready_1_2;
logic       l1_valid_1_2;
logic       l1_newdata_1_2;
logic [RID_WIDTH-1:0] l1_cache_1_2;
logic [31:0]   din_csr_readdata_1_3_r1;
logic [31:0]   din_csr_readdata_1_3_r2;

rule_s_t    l1_data_1_3;
logic       l1_ready_1_3;
logic       l1_valid_1_3;
logic       l1_newdata_1_3;
logic [RID_WIDTH-1:0] l1_cache_1_3;
logic [31:0]   din_csr_readdata_1_4_r1;
logic [31:0]   din_csr_readdata_1_4_r2;

rule_s_t    l1_data_1_4;
logic       l1_ready_1_4;
logic       l1_valid_1_4;
logic       l1_newdata_1_4;
logic [RID_WIDTH-1:0] l1_cache_1_4;
logic [31:0]   din_csr_readdata_1_5_r1;
logic [31:0]   din_csr_readdata_1_5_r2;

rule_s_t    l1_data_1_5;
logic       l1_ready_1_5;
logic       l1_valid_1_5;
logic       l1_newdata_1_5;
logic [RID_WIDTH-1:0] l1_cache_1_5;
logic [31:0]   din_csr_readdata_1_6_r1;
logic [31:0]   din_csr_readdata_1_6_r2;

rule_s_t    l1_data_1_6;
logic       l1_ready_1_6;
logic       l1_valid_1_6;
logic       l1_newdata_1_6;
logic [RID_WIDTH-1:0] l1_cache_1_6;
logic [31:0]   din_csr_readdata_1_7_r1;
logic [31:0]   din_csr_readdata_1_7_r2;

rule_s_t    l1_data_1_7;
logic       l1_ready_1_7;
logic       l1_valid_1_7;
logic       l1_newdata_1_7;
logic [RID_WIDTH-1:0] l1_cache_1_7;
logic [31:0]   din_csr_readdata_2_0_r1;
logic [31:0]   din_csr_readdata_2_0_r2;

rule_s_t    l1_data_2_0;
logic       l1_ready_2_0;
logic       l1_valid_2_0;
logic       l1_newdata_2_0;
logic [RID_WIDTH-1:0] l1_cache_2_0;
logic [31:0]   din_csr_readdata_2_1_r1;
logic [31:0]   din_csr_readdata_2_1_r2;

rule_s_t    l1_data_2_1;
logic       l1_ready_2_1;
logic       l1_valid_2_1;
logic       l1_newdata_2_1;
logic [RID_WIDTH-1:0] l1_cache_2_1;
logic [31:0]   din_csr_readdata_2_2_r1;
logic [31:0]   din_csr_readdata_2_2_r2;

rule_s_t    l1_data_2_2;
logic       l1_ready_2_2;
logic       l1_valid_2_2;
logic       l1_newdata_2_2;
logic [RID_WIDTH-1:0] l1_cache_2_2;
logic [31:0]   din_csr_readdata_2_3_r1;
logic [31:0]   din_csr_readdata_2_3_r2;

rule_s_t    l1_data_2_3;
logic       l1_ready_2_3;
logic       l1_valid_2_3;
logic       l1_newdata_2_3;
logic [RID_WIDTH-1:0] l1_cache_2_3;
logic [31:0]   din_csr_readdata_2_4_r1;
logic [31:0]   din_csr_readdata_2_4_r2;

rule_s_t    l1_data_2_4;
logic       l1_ready_2_4;
logic       l1_valid_2_4;
logic       l1_newdata_2_4;
logic [RID_WIDTH-1:0] l1_cache_2_4;
logic [31:0]   din_csr_readdata_2_5_r1;
logic [31:0]   din_csr_readdata_2_5_r2;

rule_s_t    l1_data_2_5;
logic       l1_ready_2_5;
logic       l1_valid_2_5;
logic       l1_newdata_2_5;
logic [RID_WIDTH-1:0] l1_cache_2_5;
logic [31:0]   din_csr_readdata_2_6_r1;
logic [31:0]   din_csr_readdata_2_6_r2;

rule_s_t    l1_data_2_6;
logic       l1_ready_2_6;
logic       l1_valid_2_6;
logic       l1_newdata_2_6;
logic [RID_WIDTH-1:0] l1_cache_2_6;
logic [31:0]   din_csr_readdata_2_7_r1;
logic [31:0]   din_csr_readdata_2_7_r2;

rule_s_t    l1_data_2_7;
logic       l1_ready_2_7;
logic       l1_valid_2_7;
logic       l1_newdata_2_7;
logic [RID_WIDTH-1:0] l1_cache_2_7;
logic [31:0]   din_csr_readdata_3_0_r1;
logic [31:0]   din_csr_readdata_3_0_r2;

rule_s_t    l1_data_3_0;
logic       l1_ready_3_0;
logic       l1_valid_3_0;
logic       l1_newdata_3_0;
logic [RID_WIDTH-1:0] l1_cache_3_0;
logic [31:0]   din_csr_readdata_3_1_r1;
logic [31:0]   din_csr_readdata_3_1_r2;

rule_s_t    l1_data_3_1;
logic       l1_ready_3_1;
logic       l1_valid_3_1;
logic       l1_newdata_3_1;
logic [RID_WIDTH-1:0] l1_cache_3_1;
logic [31:0]   din_csr_readdata_3_2_r1;
logic [31:0]   din_csr_readdata_3_2_r2;

rule_s_t    l1_data_3_2;
logic       l1_ready_3_2;
logic       l1_valid_3_2;
logic       l1_newdata_3_2;
logic [RID_WIDTH-1:0] l1_cache_3_2;
logic [31:0]   din_csr_readdata_3_3_r1;
logic [31:0]   din_csr_readdata_3_3_r2;

rule_s_t    l1_data_3_3;
logic       l1_ready_3_3;
logic       l1_valid_3_3;
logic       l1_newdata_3_3;
logic [RID_WIDTH-1:0] l1_cache_3_3;
logic [31:0]   din_csr_readdata_3_4_r1;
logic [31:0]   din_csr_readdata_3_4_r2;

rule_s_t    l1_data_3_4;
logic       l1_ready_3_4;
logic       l1_valid_3_4;
logic       l1_newdata_3_4;
logic [RID_WIDTH-1:0] l1_cache_3_4;
logic [31:0]   din_csr_readdata_3_5_r1;
logic [31:0]   din_csr_readdata_3_5_r2;

rule_s_t    l1_data_3_5;
logic       l1_ready_3_5;
logic       l1_valid_3_5;
logic       l1_newdata_3_5;
logic [RID_WIDTH-1:0] l1_cache_3_5;
logic [31:0]   din_csr_readdata_3_6_r1;
logic [31:0]   din_csr_readdata_3_6_r2;

rule_s_t    l1_data_3_6;
logic       l1_ready_3_6;
logic       l1_valid_3_6;
logic       l1_newdata_3_6;
logic [RID_WIDTH-1:0] l1_cache_3_6;
logic [31:0]   din_csr_readdata_3_7_r1;
logic [31:0]   din_csr_readdata_3_7_r2;

rule_s_t    l1_data_3_7;
logic       l1_ready_3_7;
logic       l1_valid_3_7;
logic       l1_newdata_3_7;
logic [RID_WIDTH-1:0] l1_cache_3_7;
logic [31:0]   din_csr_readdata_4_0_r1;
logic [31:0]   din_csr_readdata_4_0_r2;

rule_s_t    l1_data_4_0;
logic       l1_ready_4_0;
logic       l1_valid_4_0;
logic       l1_newdata_4_0;
logic [RID_WIDTH-1:0] l1_cache_4_0;
logic [31:0]   din_csr_readdata_4_1_r1;
logic [31:0]   din_csr_readdata_4_1_r2;

rule_s_t    l1_data_4_1;
logic       l1_ready_4_1;
logic       l1_valid_4_1;
logic       l1_newdata_4_1;
logic [RID_WIDTH-1:0] l1_cache_4_1;
logic [31:0]   din_csr_readdata_4_2_r1;
logic [31:0]   din_csr_readdata_4_2_r2;

rule_s_t    l1_data_4_2;
logic       l1_ready_4_2;
logic       l1_valid_4_2;
logic       l1_newdata_4_2;
logic [RID_WIDTH-1:0] l1_cache_4_2;
logic [31:0]   din_csr_readdata_4_3_r1;
logic [31:0]   din_csr_readdata_4_3_r2;

rule_s_t    l1_data_4_3;
logic       l1_ready_4_3;
logic       l1_valid_4_3;
logic       l1_newdata_4_3;
logic [RID_WIDTH-1:0] l1_cache_4_3;
logic [31:0]   din_csr_readdata_4_4_r1;
logic [31:0]   din_csr_readdata_4_4_r2;

rule_s_t    l1_data_4_4;
logic       l1_ready_4_4;
logic       l1_valid_4_4;
logic       l1_newdata_4_4;
logic [RID_WIDTH-1:0] l1_cache_4_4;
logic [31:0]   din_csr_readdata_4_5_r1;
logic [31:0]   din_csr_readdata_4_5_r2;

rule_s_t    l1_data_4_5;
logic       l1_ready_4_5;
logic       l1_valid_4_5;
logic       l1_newdata_4_5;
logic [RID_WIDTH-1:0] l1_cache_4_5;
logic [31:0]   din_csr_readdata_4_6_r1;
logic [31:0]   din_csr_readdata_4_6_r2;

rule_s_t    l1_data_4_6;
logic       l1_ready_4_6;
logic       l1_valid_4_6;
logic       l1_newdata_4_6;
logic [RID_WIDTH-1:0] l1_cache_4_6;
logic [31:0]   din_csr_readdata_4_7_r1;
logic [31:0]   din_csr_readdata_4_7_r2;

rule_s_t    l1_data_4_7;
logic       l1_ready_4_7;
logic       l1_valid_4_7;
logic       l1_newdata_4_7;
logic [RID_WIDTH-1:0] l1_cache_4_7;
logic [31:0]   din_csr_readdata_5_0_r1;
logic [31:0]   din_csr_readdata_5_0_r2;

rule_s_t    l1_data_5_0;
logic       l1_ready_5_0;
logic       l1_valid_5_0;
logic       l1_newdata_5_0;
logic [RID_WIDTH-1:0] l1_cache_5_0;
logic [31:0]   din_csr_readdata_5_1_r1;
logic [31:0]   din_csr_readdata_5_1_r2;

rule_s_t    l1_data_5_1;
logic       l1_ready_5_1;
logic       l1_valid_5_1;
logic       l1_newdata_5_1;
logic [RID_WIDTH-1:0] l1_cache_5_1;
logic [31:0]   din_csr_readdata_5_2_r1;
logic [31:0]   din_csr_readdata_5_2_r2;

rule_s_t    l1_data_5_2;
logic       l1_ready_5_2;
logic       l1_valid_5_2;
logic       l1_newdata_5_2;
logic [RID_WIDTH-1:0] l1_cache_5_2;
logic [31:0]   din_csr_readdata_5_3_r1;
logic [31:0]   din_csr_readdata_5_3_r2;

rule_s_t    l1_data_5_3;
logic       l1_ready_5_3;
logic       l1_valid_5_3;
logic       l1_newdata_5_3;
logic [RID_WIDTH-1:0] l1_cache_5_3;
logic [31:0]   din_csr_readdata_5_4_r1;
logic [31:0]   din_csr_readdata_5_4_r2;

rule_s_t    l1_data_5_4;
logic       l1_ready_5_4;
logic       l1_valid_5_4;
logic       l1_newdata_5_4;
logic [RID_WIDTH-1:0] l1_cache_5_4;
logic [31:0]   din_csr_readdata_5_5_r1;
logic [31:0]   din_csr_readdata_5_5_r2;

rule_s_t    l1_data_5_5;
logic       l1_ready_5_5;
logic       l1_valid_5_5;
logic       l1_newdata_5_5;
logic [RID_WIDTH-1:0] l1_cache_5_5;
logic [31:0]   din_csr_readdata_5_6_r1;
logic [31:0]   din_csr_readdata_5_6_r2;

rule_s_t    l1_data_5_6;
logic       l1_ready_5_6;
logic       l1_valid_5_6;
logic       l1_newdata_5_6;
logic [RID_WIDTH-1:0] l1_cache_5_6;
logic [31:0]   din_csr_readdata_5_7_r1;
logic [31:0]   din_csr_readdata_5_7_r2;

rule_s_t    l1_data_5_7;
logic       l1_ready_5_7;
logic       l1_valid_5_7;
logic       l1_newdata_5_7;
logic [RID_WIDTH-1:0] l1_cache_5_7;
logic [31:0]   din_csr_readdata_6_0_r1;
logic [31:0]   din_csr_readdata_6_0_r2;

rule_s_t    l1_data_6_0;
logic       l1_ready_6_0;
logic       l1_valid_6_0;
logic       l1_newdata_6_0;
logic [RID_WIDTH-1:0] l1_cache_6_0;
logic [31:0]   din_csr_readdata_6_1_r1;
logic [31:0]   din_csr_readdata_6_1_r2;

rule_s_t    l1_data_6_1;
logic       l1_ready_6_1;
logic       l1_valid_6_1;
logic       l1_newdata_6_1;
logic [RID_WIDTH-1:0] l1_cache_6_1;
logic [31:0]   din_csr_readdata_6_2_r1;
logic [31:0]   din_csr_readdata_6_2_r2;

rule_s_t    l1_data_6_2;
logic       l1_ready_6_2;
logic       l1_valid_6_2;
logic       l1_newdata_6_2;
logic [RID_WIDTH-1:0] l1_cache_6_2;
logic [31:0]   din_csr_readdata_6_3_r1;
logic [31:0]   din_csr_readdata_6_3_r2;

rule_s_t    l1_data_6_3;
logic       l1_ready_6_3;
logic       l1_valid_6_3;
logic       l1_newdata_6_3;
logic [RID_WIDTH-1:0] l1_cache_6_3;
logic [31:0]   din_csr_readdata_6_4_r1;
logic [31:0]   din_csr_readdata_6_4_r2;

rule_s_t    l1_data_6_4;
logic       l1_ready_6_4;
logic       l1_valid_6_4;
logic       l1_newdata_6_4;
logic [RID_WIDTH-1:0] l1_cache_6_4;
logic [31:0]   din_csr_readdata_6_5_r1;
logic [31:0]   din_csr_readdata_6_5_r2;

rule_s_t    l1_data_6_5;
logic       l1_ready_6_5;
logic       l1_valid_6_5;
logic       l1_newdata_6_5;
logic [RID_WIDTH-1:0] l1_cache_6_5;
logic [31:0]   din_csr_readdata_6_6_r1;
logic [31:0]   din_csr_readdata_6_6_r2;

rule_s_t    l1_data_6_6;
logic       l1_ready_6_6;
logic       l1_valid_6_6;
logic       l1_newdata_6_6;
logic [RID_WIDTH-1:0] l1_cache_6_6;
logic [31:0]   din_csr_readdata_6_7_r1;
logic [31:0]   din_csr_readdata_6_7_r2;

rule_s_t    l1_data_6_7;
logic       l1_ready_6_7;
logic       l1_valid_6_7;
logic       l1_newdata_6_7;
logic [RID_WIDTH-1:0] l1_cache_6_7;
logic [31:0]   din_csr_readdata_7_0_r1;
logic [31:0]   din_csr_readdata_7_0_r2;

rule_s_t    l1_data_7_0;
logic       l1_ready_7_0;
logic       l1_valid_7_0;
logic       l1_newdata_7_0;
logic [RID_WIDTH-1:0] l1_cache_7_0;
logic [31:0]   din_csr_readdata_7_1_r1;
logic [31:0]   din_csr_readdata_7_1_r2;

rule_s_t    l1_data_7_1;
logic       l1_ready_7_1;
logic       l1_valid_7_1;
logic       l1_newdata_7_1;
logic [RID_WIDTH-1:0] l1_cache_7_1;
logic [31:0]   din_csr_readdata_7_2_r1;
logic [31:0]   din_csr_readdata_7_2_r2;

rule_s_t    l1_data_7_2;
logic       l1_ready_7_2;
logic       l1_valid_7_2;
logic       l1_newdata_7_2;
logic [RID_WIDTH-1:0] l1_cache_7_2;
logic [31:0]   din_csr_readdata_7_3_r1;
logic [31:0]   din_csr_readdata_7_3_r2;

rule_s_t    l1_data_7_3;
logic       l1_ready_7_3;
logic       l1_valid_7_3;
logic       l1_newdata_7_3;
logic [RID_WIDTH-1:0] l1_cache_7_3;
logic [31:0]   din_csr_readdata_7_4_r1;
logic [31:0]   din_csr_readdata_7_4_r2;

rule_s_t    l1_data_7_4;
logic       l1_ready_7_4;
logic       l1_valid_7_4;
logic       l1_newdata_7_4;
logic [RID_WIDTH-1:0] l1_cache_7_4;
logic [31:0]   din_csr_readdata_7_5_r1;
logic [31:0]   din_csr_readdata_7_5_r2;

rule_s_t    l1_data_7_5;
logic       l1_ready_7_5;
logic       l1_valid_7_5;
logic       l1_newdata_7_5;
logic [RID_WIDTH-1:0] l1_cache_7_5;
logic [31:0]   din_csr_readdata_7_6_r1;
logic [31:0]   din_csr_readdata_7_6_r2;

rule_s_t    l1_data_7_6;
logic       l1_ready_7_6;
logic       l1_valid_7_6;
logic       l1_newdata_7_6;
logic [RID_WIDTH-1:0] l1_cache_7_6;
logic [31:0]   din_csr_readdata_7_7_r1;
logic [31:0]   din_csr_readdata_7_7_r2;

rule_s_t    l1_data_7_7;
logic       l1_ready_7_7;
logic       l1_valid_7_7;
logic       l1_newdata_7_7;
logic [RID_WIDTH-1:0] l1_cache_7_7;

//L2 FIFO & L1 ARB
rule_s_t    l2_in_data_0_0;
rule_s_t    l2_out_data_0_0;
logic       l2_in_valid_0_0;
logic       l2_in_ready_0_0;
logic       l2_out_valid_0_0;
logic       l2_out_ready_0_0;
logic       l2_almost_full_0_0;
logic [31:0] l2_csr_readdata_0_0;
logic       l2_newdata_0_0;
logic [RID_WIDTH-1:0] l2_cache_0_0;
logic [1:0] l1_req_0_0;
logic [1:0] l1_grant_0_0;
logic       l1_all_last_0_0;
logic       l1_same_0_0;
//logic [1:0] l1_all_last_0_0_r;
rule_s_t    l2_in_data_0_1;
rule_s_t    l2_out_data_0_1;
logic       l2_in_valid_0_1;
logic       l2_in_ready_0_1;
logic       l2_out_valid_0_1;
logic       l2_out_ready_0_1;
logic       l2_almost_full_0_1;
logic [31:0] l2_csr_readdata_0_1;
logic       l2_newdata_0_1;
logic [RID_WIDTH-1:0] l2_cache_0_1;
logic [1:0] l1_req_0_1;
logic [1:0] l1_grant_0_1;
logic       l1_all_last_0_1;
logic       l1_same_0_1;
//logic [1:0] l1_all_last_0_1_r;
rule_s_t    l2_in_data_0_2;
rule_s_t    l2_out_data_0_2;
logic       l2_in_valid_0_2;
logic       l2_in_ready_0_2;
logic       l2_out_valid_0_2;
logic       l2_out_ready_0_2;
logic       l2_almost_full_0_2;
logic [31:0] l2_csr_readdata_0_2;
logic       l2_newdata_0_2;
logic [RID_WIDTH-1:0] l2_cache_0_2;
logic [1:0] l1_req_0_2;
logic [1:0] l1_grant_0_2;
logic       l1_all_last_0_2;
logic       l1_same_0_2;
//logic [1:0] l1_all_last_0_2_r;
rule_s_t    l2_in_data_0_3;
rule_s_t    l2_out_data_0_3;
logic       l2_in_valid_0_3;
logic       l2_in_ready_0_3;
logic       l2_out_valid_0_3;
logic       l2_out_ready_0_3;
logic       l2_almost_full_0_3;
logic [31:0] l2_csr_readdata_0_3;
logic       l2_newdata_0_3;
logic [RID_WIDTH-1:0] l2_cache_0_3;
logic [1:0] l1_req_0_3;
logic [1:0] l1_grant_0_3;
logic       l1_all_last_0_3;
logic       l1_same_0_3;
//logic [1:0] l1_all_last_0_3_r;
rule_s_t    l2_in_data_0_4;
rule_s_t    l2_out_data_0_4;
logic       l2_in_valid_0_4;
logic       l2_in_ready_0_4;
logic       l2_out_valid_0_4;
logic       l2_out_ready_0_4;
logic       l2_almost_full_0_4;
logic [31:0] l2_csr_readdata_0_4;
logic       l2_newdata_0_4;
logic [RID_WIDTH-1:0] l2_cache_0_4;
logic [1:0] l1_req_0_4;
logic [1:0] l1_grant_0_4;
logic       l1_all_last_0_4;
logic       l1_same_0_4;
//logic [1:0] l1_all_last_0_4_r;
rule_s_t    l2_in_data_0_5;
rule_s_t    l2_out_data_0_5;
logic       l2_in_valid_0_5;
logic       l2_in_ready_0_5;
logic       l2_out_valid_0_5;
logic       l2_out_ready_0_5;
logic       l2_almost_full_0_5;
logic [31:0] l2_csr_readdata_0_5;
logic       l2_newdata_0_5;
logic [RID_WIDTH-1:0] l2_cache_0_5;
logic [1:0] l1_req_0_5;
logic [1:0] l1_grant_0_5;
logic       l1_all_last_0_5;
logic       l1_same_0_5;
//logic [1:0] l1_all_last_0_5_r;
rule_s_t    l2_in_data_0_6;
rule_s_t    l2_out_data_0_6;
logic       l2_in_valid_0_6;
logic       l2_in_ready_0_6;
logic       l2_out_valid_0_6;
logic       l2_out_ready_0_6;
logic       l2_almost_full_0_6;
logic [31:0] l2_csr_readdata_0_6;
logic       l2_newdata_0_6;
logic [RID_WIDTH-1:0] l2_cache_0_6;
logic [1:0] l1_req_0_6;
logic [1:0] l1_grant_0_6;
logic       l1_all_last_0_6;
logic       l1_same_0_6;
//logic [1:0] l1_all_last_0_6_r;
rule_s_t    l2_in_data_0_7;
rule_s_t    l2_out_data_0_7;
logic       l2_in_valid_0_7;
logic       l2_in_ready_0_7;
logic       l2_out_valid_0_7;
logic       l2_out_ready_0_7;
logic       l2_almost_full_0_7;
logic [31:0] l2_csr_readdata_0_7;
logic       l2_newdata_0_7;
logic [RID_WIDTH-1:0] l2_cache_0_7;
logic [1:0] l1_req_0_7;
logic [1:0] l1_grant_0_7;
logic       l1_all_last_0_7;
logic       l1_same_0_7;
//logic [1:0] l1_all_last_0_7_r;
rule_s_t    l2_in_data_0_8;
rule_s_t    l2_out_data_0_8;
logic       l2_in_valid_0_8;
logic       l2_in_ready_0_8;
logic       l2_out_valid_0_8;
logic       l2_out_ready_0_8;
logic       l2_almost_full_0_8;
logic [31:0] l2_csr_readdata_0_8;
logic       l2_newdata_0_8;
logic [RID_WIDTH-1:0] l2_cache_0_8;
logic [1:0] l1_req_0_8;
logic [1:0] l1_grant_0_8;
logic       l1_all_last_0_8;
logic       l1_same_0_8;
//logic [1:0] l1_all_last_0_8_r;
rule_s_t    l2_in_data_0_9;
rule_s_t    l2_out_data_0_9;
logic       l2_in_valid_0_9;
logic       l2_in_ready_0_9;
logic       l2_out_valid_0_9;
logic       l2_out_ready_0_9;
logic       l2_almost_full_0_9;
logic [31:0] l2_csr_readdata_0_9;
logic       l2_newdata_0_9;
logic [RID_WIDTH-1:0] l2_cache_0_9;
logic [1:0] l1_req_0_9;
logic [1:0] l1_grant_0_9;
logic       l1_all_last_0_9;
logic       l1_same_0_9;
//logic [1:0] l1_all_last_0_9_r;
rule_s_t    l2_in_data_0_10;
rule_s_t    l2_out_data_0_10;
logic       l2_in_valid_0_10;
logic       l2_in_ready_0_10;
logic       l2_out_valid_0_10;
logic       l2_out_ready_0_10;
logic       l2_almost_full_0_10;
logic [31:0] l2_csr_readdata_0_10;
logic       l2_newdata_0_10;
logic [RID_WIDTH-1:0] l2_cache_0_10;
logic [1:0] l1_req_0_10;
logic [1:0] l1_grant_0_10;
logic       l1_all_last_0_10;
logic       l1_same_0_10;
//logic [1:0] l1_all_last_0_10_r;
rule_s_t    l2_in_data_0_11;
rule_s_t    l2_out_data_0_11;
logic       l2_in_valid_0_11;
logic       l2_in_ready_0_11;
logic       l2_out_valid_0_11;
logic       l2_out_ready_0_11;
logic       l2_almost_full_0_11;
logic [31:0] l2_csr_readdata_0_11;
logic       l2_newdata_0_11;
logic [RID_WIDTH-1:0] l2_cache_0_11;
logic [1:0] l1_req_0_11;
logic [1:0] l1_grant_0_11;
logic       l1_all_last_0_11;
logic       l1_same_0_11;
//logic [1:0] l1_all_last_0_11_r;
rule_s_t    l2_in_data_0_12;
rule_s_t    l2_out_data_0_12;
logic       l2_in_valid_0_12;
logic       l2_in_ready_0_12;
logic       l2_out_valid_0_12;
logic       l2_out_ready_0_12;
logic       l2_almost_full_0_12;
logic [31:0] l2_csr_readdata_0_12;
logic       l2_newdata_0_12;
logic [RID_WIDTH-1:0] l2_cache_0_12;
logic [1:0] l1_req_0_12;
logic [1:0] l1_grant_0_12;
logic       l1_all_last_0_12;
logic       l1_same_0_12;
//logic [1:0] l1_all_last_0_12_r;
rule_s_t    l2_in_data_0_13;
rule_s_t    l2_out_data_0_13;
logic       l2_in_valid_0_13;
logic       l2_in_ready_0_13;
logic       l2_out_valid_0_13;
logic       l2_out_ready_0_13;
logic       l2_almost_full_0_13;
logic [31:0] l2_csr_readdata_0_13;
logic       l2_newdata_0_13;
logic [RID_WIDTH-1:0] l2_cache_0_13;
logic [1:0] l1_req_0_13;
logic [1:0] l1_grant_0_13;
logic       l1_all_last_0_13;
logic       l1_same_0_13;
//logic [1:0] l1_all_last_0_13_r;
rule_s_t    l2_in_data_0_14;
rule_s_t    l2_out_data_0_14;
logic       l2_in_valid_0_14;
logic       l2_in_ready_0_14;
logic       l2_out_valid_0_14;
logic       l2_out_ready_0_14;
logic       l2_almost_full_0_14;
logic [31:0] l2_csr_readdata_0_14;
logic       l2_newdata_0_14;
logic [RID_WIDTH-1:0] l2_cache_0_14;
logic [1:0] l1_req_0_14;
logic [1:0] l1_grant_0_14;
logic       l1_all_last_0_14;
logic       l1_same_0_14;
//logic [1:0] l1_all_last_0_14_r;
rule_s_t    l2_in_data_0_15;
rule_s_t    l2_out_data_0_15;
logic       l2_in_valid_0_15;
logic       l2_in_ready_0_15;
logic       l2_out_valid_0_15;
logic       l2_out_ready_0_15;
logic       l2_almost_full_0_15;
logic [31:0] l2_csr_readdata_0_15;
logic       l2_newdata_0_15;
logic [RID_WIDTH-1:0] l2_cache_0_15;
logic [1:0] l1_req_0_15;
logic [1:0] l1_grant_0_15;
logic       l1_all_last_0_15;
logic       l1_same_0_15;
//logic [1:0] l1_all_last_0_15_r;
rule_s_t    l2_in_data_1_0;
rule_s_t    l2_out_data_1_0;
logic       l2_in_valid_1_0;
logic       l2_in_ready_1_0;
logic       l2_out_valid_1_0;
logic       l2_out_ready_1_0;
logic       l2_almost_full_1_0;
logic [31:0] l2_csr_readdata_1_0;
logic       l2_newdata_1_0;
logic [RID_WIDTH-1:0] l2_cache_1_0;
logic [1:0] l1_req_1_0;
logic [1:0] l1_grant_1_0;
logic       l1_all_last_1_0;
logic       l1_same_1_0;
//logic [1:0] l1_all_last_1_0_r;
rule_s_t    l2_in_data_1_1;
rule_s_t    l2_out_data_1_1;
logic       l2_in_valid_1_1;
logic       l2_in_ready_1_1;
logic       l2_out_valid_1_1;
logic       l2_out_ready_1_1;
logic       l2_almost_full_1_1;
logic [31:0] l2_csr_readdata_1_1;
logic       l2_newdata_1_1;
logic [RID_WIDTH-1:0] l2_cache_1_1;
logic [1:0] l1_req_1_1;
logic [1:0] l1_grant_1_1;
logic       l1_all_last_1_1;
logic       l1_same_1_1;
//logic [1:0] l1_all_last_1_1_r;
rule_s_t    l2_in_data_1_2;
rule_s_t    l2_out_data_1_2;
logic       l2_in_valid_1_2;
logic       l2_in_ready_1_2;
logic       l2_out_valid_1_2;
logic       l2_out_ready_1_2;
logic       l2_almost_full_1_2;
logic [31:0] l2_csr_readdata_1_2;
logic       l2_newdata_1_2;
logic [RID_WIDTH-1:0] l2_cache_1_2;
logic [1:0] l1_req_1_2;
logic [1:0] l1_grant_1_2;
logic       l1_all_last_1_2;
logic       l1_same_1_2;
//logic [1:0] l1_all_last_1_2_r;
rule_s_t    l2_in_data_1_3;
rule_s_t    l2_out_data_1_3;
logic       l2_in_valid_1_3;
logic       l2_in_ready_1_3;
logic       l2_out_valid_1_3;
logic       l2_out_ready_1_3;
logic       l2_almost_full_1_3;
logic [31:0] l2_csr_readdata_1_3;
logic       l2_newdata_1_3;
logic [RID_WIDTH-1:0] l2_cache_1_3;
logic [1:0] l1_req_1_3;
logic [1:0] l1_grant_1_3;
logic       l1_all_last_1_3;
logic       l1_same_1_3;
//logic [1:0] l1_all_last_1_3_r;
rule_s_t    l2_in_data_1_4;
rule_s_t    l2_out_data_1_4;
logic       l2_in_valid_1_4;
logic       l2_in_ready_1_4;
logic       l2_out_valid_1_4;
logic       l2_out_ready_1_4;
logic       l2_almost_full_1_4;
logic [31:0] l2_csr_readdata_1_4;
logic       l2_newdata_1_4;
logic [RID_WIDTH-1:0] l2_cache_1_4;
logic [1:0] l1_req_1_4;
logic [1:0] l1_grant_1_4;
logic       l1_all_last_1_4;
logic       l1_same_1_4;
//logic [1:0] l1_all_last_1_4_r;
rule_s_t    l2_in_data_1_5;
rule_s_t    l2_out_data_1_5;
logic       l2_in_valid_1_5;
logic       l2_in_ready_1_5;
logic       l2_out_valid_1_5;
logic       l2_out_ready_1_5;
logic       l2_almost_full_1_5;
logic [31:0] l2_csr_readdata_1_5;
logic       l2_newdata_1_5;
logic [RID_WIDTH-1:0] l2_cache_1_5;
logic [1:0] l1_req_1_5;
logic [1:0] l1_grant_1_5;
logic       l1_all_last_1_5;
logic       l1_same_1_5;
//logic [1:0] l1_all_last_1_5_r;
rule_s_t    l2_in_data_1_6;
rule_s_t    l2_out_data_1_6;
logic       l2_in_valid_1_6;
logic       l2_in_ready_1_6;
logic       l2_out_valid_1_6;
logic       l2_out_ready_1_6;
logic       l2_almost_full_1_6;
logic [31:0] l2_csr_readdata_1_6;
logic       l2_newdata_1_6;
logic [RID_WIDTH-1:0] l2_cache_1_6;
logic [1:0] l1_req_1_6;
logic [1:0] l1_grant_1_6;
logic       l1_all_last_1_6;
logic       l1_same_1_6;
//logic [1:0] l1_all_last_1_6_r;
rule_s_t    l2_in_data_1_7;
rule_s_t    l2_out_data_1_7;
logic       l2_in_valid_1_7;
logic       l2_in_ready_1_7;
logic       l2_out_valid_1_7;
logic       l2_out_ready_1_7;
logic       l2_almost_full_1_7;
logic [31:0] l2_csr_readdata_1_7;
logic       l2_newdata_1_7;
logic [RID_WIDTH-1:0] l2_cache_1_7;
logic [1:0] l1_req_1_7;
logic [1:0] l1_grant_1_7;
logic       l1_all_last_1_7;
logic       l1_same_1_7;
//logic [1:0] l1_all_last_1_7_r;
rule_s_t    l2_in_data_1_8;
rule_s_t    l2_out_data_1_8;
logic       l2_in_valid_1_8;
logic       l2_in_ready_1_8;
logic       l2_out_valid_1_8;
logic       l2_out_ready_1_8;
logic       l2_almost_full_1_8;
logic [31:0] l2_csr_readdata_1_8;
logic       l2_newdata_1_8;
logic [RID_WIDTH-1:0] l2_cache_1_8;
logic [1:0] l1_req_1_8;
logic [1:0] l1_grant_1_8;
logic       l1_all_last_1_8;
logic       l1_same_1_8;
//logic [1:0] l1_all_last_1_8_r;
rule_s_t    l2_in_data_1_9;
rule_s_t    l2_out_data_1_9;
logic       l2_in_valid_1_9;
logic       l2_in_ready_1_9;
logic       l2_out_valid_1_9;
logic       l2_out_ready_1_9;
logic       l2_almost_full_1_9;
logic [31:0] l2_csr_readdata_1_9;
logic       l2_newdata_1_9;
logic [RID_WIDTH-1:0] l2_cache_1_9;
logic [1:0] l1_req_1_9;
logic [1:0] l1_grant_1_9;
logic       l1_all_last_1_9;
logic       l1_same_1_9;
//logic [1:0] l1_all_last_1_9_r;
rule_s_t    l2_in_data_1_10;
rule_s_t    l2_out_data_1_10;
logic       l2_in_valid_1_10;
logic       l2_in_ready_1_10;
logic       l2_out_valid_1_10;
logic       l2_out_ready_1_10;
logic       l2_almost_full_1_10;
logic [31:0] l2_csr_readdata_1_10;
logic       l2_newdata_1_10;
logic [RID_WIDTH-1:0] l2_cache_1_10;
logic [1:0] l1_req_1_10;
logic [1:0] l1_grant_1_10;
logic       l1_all_last_1_10;
logic       l1_same_1_10;
//logic [1:0] l1_all_last_1_10_r;
rule_s_t    l2_in_data_1_11;
rule_s_t    l2_out_data_1_11;
logic       l2_in_valid_1_11;
logic       l2_in_ready_1_11;
logic       l2_out_valid_1_11;
logic       l2_out_ready_1_11;
logic       l2_almost_full_1_11;
logic [31:0] l2_csr_readdata_1_11;
logic       l2_newdata_1_11;
logic [RID_WIDTH-1:0] l2_cache_1_11;
logic [1:0] l1_req_1_11;
logic [1:0] l1_grant_1_11;
logic       l1_all_last_1_11;
logic       l1_same_1_11;
//logic [1:0] l1_all_last_1_11_r;
rule_s_t    l2_in_data_1_12;
rule_s_t    l2_out_data_1_12;
logic       l2_in_valid_1_12;
logic       l2_in_ready_1_12;
logic       l2_out_valid_1_12;
logic       l2_out_ready_1_12;
logic       l2_almost_full_1_12;
logic [31:0] l2_csr_readdata_1_12;
logic       l2_newdata_1_12;
logic [RID_WIDTH-1:0] l2_cache_1_12;
logic [1:0] l1_req_1_12;
logic [1:0] l1_grant_1_12;
logic       l1_all_last_1_12;
logic       l1_same_1_12;
//logic [1:0] l1_all_last_1_12_r;
rule_s_t    l2_in_data_1_13;
rule_s_t    l2_out_data_1_13;
logic       l2_in_valid_1_13;
logic       l2_in_ready_1_13;
logic       l2_out_valid_1_13;
logic       l2_out_ready_1_13;
logic       l2_almost_full_1_13;
logic [31:0] l2_csr_readdata_1_13;
logic       l2_newdata_1_13;
logic [RID_WIDTH-1:0] l2_cache_1_13;
logic [1:0] l1_req_1_13;
logic [1:0] l1_grant_1_13;
logic       l1_all_last_1_13;
logic       l1_same_1_13;
//logic [1:0] l1_all_last_1_13_r;
rule_s_t    l2_in_data_1_14;
rule_s_t    l2_out_data_1_14;
logic       l2_in_valid_1_14;
logic       l2_in_ready_1_14;
logic       l2_out_valid_1_14;
logic       l2_out_ready_1_14;
logic       l2_almost_full_1_14;
logic [31:0] l2_csr_readdata_1_14;
logic       l2_newdata_1_14;
logic [RID_WIDTH-1:0] l2_cache_1_14;
logic [1:0] l1_req_1_14;
logic [1:0] l1_grant_1_14;
logic       l1_all_last_1_14;
logic       l1_same_1_14;
//logic [1:0] l1_all_last_1_14_r;
rule_s_t    l2_in_data_1_15;
rule_s_t    l2_out_data_1_15;
logic       l2_in_valid_1_15;
logic       l2_in_ready_1_15;
logic       l2_out_valid_1_15;
logic       l2_out_ready_1_15;
logic       l2_almost_full_1_15;
logic [31:0] l2_csr_readdata_1_15;
logic       l2_newdata_1_15;
logic [RID_WIDTH-1:0] l2_cache_1_15;
logic [1:0] l1_req_1_15;
logic [1:0] l1_grant_1_15;
logic       l1_all_last_1_15;
logic       l1_same_1_15;
//logic [1:0] l1_all_last_1_15_r;
rule_s_t    l2_in_data_2_0;
rule_s_t    l2_out_data_2_0;
logic       l2_in_valid_2_0;
logic       l2_in_ready_2_0;
logic       l2_out_valid_2_0;
logic       l2_out_ready_2_0;
logic       l2_almost_full_2_0;
logic [31:0] l2_csr_readdata_2_0;
logic       l2_newdata_2_0;
logic [RID_WIDTH-1:0] l2_cache_2_0;
logic [1:0] l1_req_2_0;
logic [1:0] l1_grant_2_0;
logic       l1_all_last_2_0;
logic       l1_same_2_0;
//logic [1:0] l1_all_last_2_0_r;
rule_s_t    l2_in_data_2_1;
rule_s_t    l2_out_data_2_1;
logic       l2_in_valid_2_1;
logic       l2_in_ready_2_1;
logic       l2_out_valid_2_1;
logic       l2_out_ready_2_1;
logic       l2_almost_full_2_1;
logic [31:0] l2_csr_readdata_2_1;
logic       l2_newdata_2_1;
logic [RID_WIDTH-1:0] l2_cache_2_1;
logic [1:0] l1_req_2_1;
logic [1:0] l1_grant_2_1;
logic       l1_all_last_2_1;
logic       l1_same_2_1;
//logic [1:0] l1_all_last_2_1_r;
rule_s_t    l2_in_data_2_2;
rule_s_t    l2_out_data_2_2;
logic       l2_in_valid_2_2;
logic       l2_in_ready_2_2;
logic       l2_out_valid_2_2;
logic       l2_out_ready_2_2;
logic       l2_almost_full_2_2;
logic [31:0] l2_csr_readdata_2_2;
logic       l2_newdata_2_2;
logic [RID_WIDTH-1:0] l2_cache_2_2;
logic [1:0] l1_req_2_2;
logic [1:0] l1_grant_2_2;
logic       l1_all_last_2_2;
logic       l1_same_2_2;
//logic [1:0] l1_all_last_2_2_r;
rule_s_t    l2_in_data_2_3;
rule_s_t    l2_out_data_2_3;
logic       l2_in_valid_2_3;
logic       l2_in_ready_2_3;
logic       l2_out_valid_2_3;
logic       l2_out_ready_2_3;
logic       l2_almost_full_2_3;
logic [31:0] l2_csr_readdata_2_3;
logic       l2_newdata_2_3;
logic [RID_WIDTH-1:0] l2_cache_2_3;
logic [1:0] l1_req_2_3;
logic [1:0] l1_grant_2_3;
logic       l1_all_last_2_3;
logic       l1_same_2_3;
//logic [1:0] l1_all_last_2_3_r;
rule_s_t    l2_in_data_2_4;
rule_s_t    l2_out_data_2_4;
logic       l2_in_valid_2_4;
logic       l2_in_ready_2_4;
logic       l2_out_valid_2_4;
logic       l2_out_ready_2_4;
logic       l2_almost_full_2_4;
logic [31:0] l2_csr_readdata_2_4;
logic       l2_newdata_2_4;
logic [RID_WIDTH-1:0] l2_cache_2_4;
logic [1:0] l1_req_2_4;
logic [1:0] l1_grant_2_4;
logic       l1_all_last_2_4;
logic       l1_same_2_4;
//logic [1:0] l1_all_last_2_4_r;
rule_s_t    l2_in_data_2_5;
rule_s_t    l2_out_data_2_5;
logic       l2_in_valid_2_5;
logic       l2_in_ready_2_5;
logic       l2_out_valid_2_5;
logic       l2_out_ready_2_5;
logic       l2_almost_full_2_5;
logic [31:0] l2_csr_readdata_2_5;
logic       l2_newdata_2_5;
logic [RID_WIDTH-1:0] l2_cache_2_5;
logic [1:0] l1_req_2_5;
logic [1:0] l1_grant_2_5;
logic       l1_all_last_2_5;
logic       l1_same_2_5;
//logic [1:0] l1_all_last_2_5_r;
rule_s_t    l2_in_data_2_6;
rule_s_t    l2_out_data_2_6;
logic       l2_in_valid_2_6;
logic       l2_in_ready_2_6;
logic       l2_out_valid_2_6;
logic       l2_out_ready_2_6;
logic       l2_almost_full_2_6;
logic [31:0] l2_csr_readdata_2_6;
logic       l2_newdata_2_6;
logic [RID_WIDTH-1:0] l2_cache_2_6;
logic [1:0] l1_req_2_6;
logic [1:0] l1_grant_2_6;
logic       l1_all_last_2_6;
logic       l1_same_2_6;
//logic [1:0] l1_all_last_2_6_r;
rule_s_t    l2_in_data_2_7;
rule_s_t    l2_out_data_2_7;
logic       l2_in_valid_2_7;
logic       l2_in_ready_2_7;
logic       l2_out_valid_2_7;
logic       l2_out_ready_2_7;
logic       l2_almost_full_2_7;
logic [31:0] l2_csr_readdata_2_7;
logic       l2_newdata_2_7;
logic [RID_WIDTH-1:0] l2_cache_2_7;
logic [1:0] l1_req_2_7;
logic [1:0] l1_grant_2_7;
logic       l1_all_last_2_7;
logic       l1_same_2_7;
//logic [1:0] l1_all_last_2_7_r;
rule_s_t    l2_in_data_2_8;
rule_s_t    l2_out_data_2_8;
logic       l2_in_valid_2_8;
logic       l2_in_ready_2_8;
logic       l2_out_valid_2_8;
logic       l2_out_ready_2_8;
logic       l2_almost_full_2_8;
logic [31:0] l2_csr_readdata_2_8;
logic       l2_newdata_2_8;
logic [RID_WIDTH-1:0] l2_cache_2_8;
logic [1:0] l1_req_2_8;
logic [1:0] l1_grant_2_8;
logic       l1_all_last_2_8;
logic       l1_same_2_8;
//logic [1:0] l1_all_last_2_8_r;
rule_s_t    l2_in_data_2_9;
rule_s_t    l2_out_data_2_9;
logic       l2_in_valid_2_9;
logic       l2_in_ready_2_9;
logic       l2_out_valid_2_9;
logic       l2_out_ready_2_9;
logic       l2_almost_full_2_9;
logic [31:0] l2_csr_readdata_2_9;
logic       l2_newdata_2_9;
logic [RID_WIDTH-1:0] l2_cache_2_9;
logic [1:0] l1_req_2_9;
logic [1:0] l1_grant_2_9;
logic       l1_all_last_2_9;
logic       l1_same_2_9;
//logic [1:0] l1_all_last_2_9_r;
rule_s_t    l2_in_data_2_10;
rule_s_t    l2_out_data_2_10;
logic       l2_in_valid_2_10;
logic       l2_in_ready_2_10;
logic       l2_out_valid_2_10;
logic       l2_out_ready_2_10;
logic       l2_almost_full_2_10;
logic [31:0] l2_csr_readdata_2_10;
logic       l2_newdata_2_10;
logic [RID_WIDTH-1:0] l2_cache_2_10;
logic [1:0] l1_req_2_10;
logic [1:0] l1_grant_2_10;
logic       l1_all_last_2_10;
logic       l1_same_2_10;
//logic [1:0] l1_all_last_2_10_r;
rule_s_t    l2_in_data_2_11;
rule_s_t    l2_out_data_2_11;
logic       l2_in_valid_2_11;
logic       l2_in_ready_2_11;
logic       l2_out_valid_2_11;
logic       l2_out_ready_2_11;
logic       l2_almost_full_2_11;
logic [31:0] l2_csr_readdata_2_11;
logic       l2_newdata_2_11;
logic [RID_WIDTH-1:0] l2_cache_2_11;
logic [1:0] l1_req_2_11;
logic [1:0] l1_grant_2_11;
logic       l1_all_last_2_11;
logic       l1_same_2_11;
//logic [1:0] l1_all_last_2_11_r;
rule_s_t    l2_in_data_2_12;
rule_s_t    l2_out_data_2_12;
logic       l2_in_valid_2_12;
logic       l2_in_ready_2_12;
logic       l2_out_valid_2_12;
logic       l2_out_ready_2_12;
logic       l2_almost_full_2_12;
logic [31:0] l2_csr_readdata_2_12;
logic       l2_newdata_2_12;
logic [RID_WIDTH-1:0] l2_cache_2_12;
logic [1:0] l1_req_2_12;
logic [1:0] l1_grant_2_12;
logic       l1_all_last_2_12;
logic       l1_same_2_12;
//logic [1:0] l1_all_last_2_12_r;
rule_s_t    l2_in_data_2_13;
rule_s_t    l2_out_data_2_13;
logic       l2_in_valid_2_13;
logic       l2_in_ready_2_13;
logic       l2_out_valid_2_13;
logic       l2_out_ready_2_13;
logic       l2_almost_full_2_13;
logic [31:0] l2_csr_readdata_2_13;
logic       l2_newdata_2_13;
logic [RID_WIDTH-1:0] l2_cache_2_13;
logic [1:0] l1_req_2_13;
logic [1:0] l1_grant_2_13;
logic       l1_all_last_2_13;
logic       l1_same_2_13;
//logic [1:0] l1_all_last_2_13_r;
rule_s_t    l2_in_data_2_14;
rule_s_t    l2_out_data_2_14;
logic       l2_in_valid_2_14;
logic       l2_in_ready_2_14;
logic       l2_out_valid_2_14;
logic       l2_out_ready_2_14;
logic       l2_almost_full_2_14;
logic [31:0] l2_csr_readdata_2_14;
logic       l2_newdata_2_14;
logic [RID_WIDTH-1:0] l2_cache_2_14;
logic [1:0] l1_req_2_14;
logic [1:0] l1_grant_2_14;
logic       l1_all_last_2_14;
logic       l1_same_2_14;
//logic [1:0] l1_all_last_2_14_r;
rule_s_t    l2_in_data_2_15;
rule_s_t    l2_out_data_2_15;
logic       l2_in_valid_2_15;
logic       l2_in_ready_2_15;
logic       l2_out_valid_2_15;
logic       l2_out_ready_2_15;
logic       l2_almost_full_2_15;
logic [31:0] l2_csr_readdata_2_15;
logic       l2_newdata_2_15;
logic [RID_WIDTH-1:0] l2_cache_2_15;
logic [1:0] l1_req_2_15;
logic [1:0] l1_grant_2_15;
logic       l1_all_last_2_15;
logic       l1_same_2_15;
//logic [1:0] l1_all_last_2_15_r;
rule_s_t    l2_in_data_3_0;
rule_s_t    l2_out_data_3_0;
logic       l2_in_valid_3_0;
logic       l2_in_ready_3_0;
logic       l2_out_valid_3_0;
logic       l2_out_ready_3_0;
logic       l2_almost_full_3_0;
logic [31:0] l2_csr_readdata_3_0;
logic       l2_newdata_3_0;
logic [RID_WIDTH-1:0] l2_cache_3_0;
logic [1:0] l1_req_3_0;
logic [1:0] l1_grant_3_0;
logic       l1_all_last_3_0;
logic       l1_same_3_0;
//logic [1:0] l1_all_last_3_0_r;
rule_s_t    l2_in_data_3_1;
rule_s_t    l2_out_data_3_1;
logic       l2_in_valid_3_1;
logic       l2_in_ready_3_1;
logic       l2_out_valid_3_1;
logic       l2_out_ready_3_1;
logic       l2_almost_full_3_1;
logic [31:0] l2_csr_readdata_3_1;
logic       l2_newdata_3_1;
logic [RID_WIDTH-1:0] l2_cache_3_1;
logic [1:0] l1_req_3_1;
logic [1:0] l1_grant_3_1;
logic       l1_all_last_3_1;
logic       l1_same_3_1;
//logic [1:0] l1_all_last_3_1_r;
rule_s_t    l2_in_data_3_2;
rule_s_t    l2_out_data_3_2;
logic       l2_in_valid_3_2;
logic       l2_in_ready_3_2;
logic       l2_out_valid_3_2;
logic       l2_out_ready_3_2;
logic       l2_almost_full_3_2;
logic [31:0] l2_csr_readdata_3_2;
logic       l2_newdata_3_2;
logic [RID_WIDTH-1:0] l2_cache_3_2;
logic [1:0] l1_req_3_2;
logic [1:0] l1_grant_3_2;
logic       l1_all_last_3_2;
logic       l1_same_3_2;
//logic [1:0] l1_all_last_3_2_r;
rule_s_t    l2_in_data_3_3;
rule_s_t    l2_out_data_3_3;
logic       l2_in_valid_3_3;
logic       l2_in_ready_3_3;
logic       l2_out_valid_3_3;
logic       l2_out_ready_3_3;
logic       l2_almost_full_3_3;
logic [31:0] l2_csr_readdata_3_3;
logic       l2_newdata_3_3;
logic [RID_WIDTH-1:0] l2_cache_3_3;
logic [1:0] l1_req_3_3;
logic [1:0] l1_grant_3_3;
logic       l1_all_last_3_3;
logic       l1_same_3_3;
//logic [1:0] l1_all_last_3_3_r;
rule_s_t    l2_in_data_3_4;
rule_s_t    l2_out_data_3_4;
logic       l2_in_valid_3_4;
logic       l2_in_ready_3_4;
logic       l2_out_valid_3_4;
logic       l2_out_ready_3_4;
logic       l2_almost_full_3_4;
logic [31:0] l2_csr_readdata_3_4;
logic       l2_newdata_3_4;
logic [RID_WIDTH-1:0] l2_cache_3_4;
logic [1:0] l1_req_3_4;
logic [1:0] l1_grant_3_4;
logic       l1_all_last_3_4;
logic       l1_same_3_4;
//logic [1:0] l1_all_last_3_4_r;
rule_s_t    l2_in_data_3_5;
rule_s_t    l2_out_data_3_5;
logic       l2_in_valid_3_5;
logic       l2_in_ready_3_5;
logic       l2_out_valid_3_5;
logic       l2_out_ready_3_5;
logic       l2_almost_full_3_5;
logic [31:0] l2_csr_readdata_3_5;
logic       l2_newdata_3_5;
logic [RID_WIDTH-1:0] l2_cache_3_5;
logic [1:0] l1_req_3_5;
logic [1:0] l1_grant_3_5;
logic       l1_all_last_3_5;
logic       l1_same_3_5;
//logic [1:0] l1_all_last_3_5_r;
rule_s_t    l2_in_data_3_6;
rule_s_t    l2_out_data_3_6;
logic       l2_in_valid_3_6;
logic       l2_in_ready_3_6;
logic       l2_out_valid_3_6;
logic       l2_out_ready_3_6;
logic       l2_almost_full_3_6;
logic [31:0] l2_csr_readdata_3_6;
logic       l2_newdata_3_6;
logic [RID_WIDTH-1:0] l2_cache_3_6;
logic [1:0] l1_req_3_6;
logic [1:0] l1_grant_3_6;
logic       l1_all_last_3_6;
logic       l1_same_3_6;
//logic [1:0] l1_all_last_3_6_r;
rule_s_t    l2_in_data_3_7;
rule_s_t    l2_out_data_3_7;
logic       l2_in_valid_3_7;
logic       l2_in_ready_3_7;
logic       l2_out_valid_3_7;
logic       l2_out_ready_3_7;
logic       l2_almost_full_3_7;
logic [31:0] l2_csr_readdata_3_7;
logic       l2_newdata_3_7;
logic [RID_WIDTH-1:0] l2_cache_3_7;
logic [1:0] l1_req_3_7;
logic [1:0] l1_grant_3_7;
logic       l1_all_last_3_7;
logic       l1_same_3_7;
//logic [1:0] l1_all_last_3_7_r;
rule_s_t    l2_in_data_3_8;
rule_s_t    l2_out_data_3_8;
logic       l2_in_valid_3_8;
logic       l2_in_ready_3_8;
logic       l2_out_valid_3_8;
logic       l2_out_ready_3_8;
logic       l2_almost_full_3_8;
logic [31:0] l2_csr_readdata_3_8;
logic       l2_newdata_3_8;
logic [RID_WIDTH-1:0] l2_cache_3_8;
logic [1:0] l1_req_3_8;
logic [1:0] l1_grant_3_8;
logic       l1_all_last_3_8;
logic       l1_same_3_8;
//logic [1:0] l1_all_last_3_8_r;
rule_s_t    l2_in_data_3_9;
rule_s_t    l2_out_data_3_9;
logic       l2_in_valid_3_9;
logic       l2_in_ready_3_9;
logic       l2_out_valid_3_9;
logic       l2_out_ready_3_9;
logic       l2_almost_full_3_9;
logic [31:0] l2_csr_readdata_3_9;
logic       l2_newdata_3_9;
logic [RID_WIDTH-1:0] l2_cache_3_9;
logic [1:0] l1_req_3_9;
logic [1:0] l1_grant_3_9;
logic       l1_all_last_3_9;
logic       l1_same_3_9;
//logic [1:0] l1_all_last_3_9_r;
rule_s_t    l2_in_data_3_10;
rule_s_t    l2_out_data_3_10;
logic       l2_in_valid_3_10;
logic       l2_in_ready_3_10;
logic       l2_out_valid_3_10;
logic       l2_out_ready_3_10;
logic       l2_almost_full_3_10;
logic [31:0] l2_csr_readdata_3_10;
logic       l2_newdata_3_10;
logic [RID_WIDTH-1:0] l2_cache_3_10;
logic [1:0] l1_req_3_10;
logic [1:0] l1_grant_3_10;
logic       l1_all_last_3_10;
logic       l1_same_3_10;
//logic [1:0] l1_all_last_3_10_r;
rule_s_t    l2_in_data_3_11;
rule_s_t    l2_out_data_3_11;
logic       l2_in_valid_3_11;
logic       l2_in_ready_3_11;
logic       l2_out_valid_3_11;
logic       l2_out_ready_3_11;
logic       l2_almost_full_3_11;
logic [31:0] l2_csr_readdata_3_11;
logic       l2_newdata_3_11;
logic [RID_WIDTH-1:0] l2_cache_3_11;
logic [1:0] l1_req_3_11;
logic [1:0] l1_grant_3_11;
logic       l1_all_last_3_11;
logic       l1_same_3_11;
//logic [1:0] l1_all_last_3_11_r;
rule_s_t    l2_in_data_3_12;
rule_s_t    l2_out_data_3_12;
logic       l2_in_valid_3_12;
logic       l2_in_ready_3_12;
logic       l2_out_valid_3_12;
logic       l2_out_ready_3_12;
logic       l2_almost_full_3_12;
logic [31:0] l2_csr_readdata_3_12;
logic       l2_newdata_3_12;
logic [RID_WIDTH-1:0] l2_cache_3_12;
logic [1:0] l1_req_3_12;
logic [1:0] l1_grant_3_12;
logic       l1_all_last_3_12;
logic       l1_same_3_12;
//logic [1:0] l1_all_last_3_12_r;
rule_s_t    l2_in_data_3_13;
rule_s_t    l2_out_data_3_13;
logic       l2_in_valid_3_13;
logic       l2_in_ready_3_13;
logic       l2_out_valid_3_13;
logic       l2_out_ready_3_13;
logic       l2_almost_full_3_13;
logic [31:0] l2_csr_readdata_3_13;
logic       l2_newdata_3_13;
logic [RID_WIDTH-1:0] l2_cache_3_13;
logic [1:0] l1_req_3_13;
logic [1:0] l1_grant_3_13;
logic       l1_all_last_3_13;
logic       l1_same_3_13;
//logic [1:0] l1_all_last_3_13_r;
rule_s_t    l2_in_data_3_14;
rule_s_t    l2_out_data_3_14;
logic       l2_in_valid_3_14;
logic       l2_in_ready_3_14;
logic       l2_out_valid_3_14;
logic       l2_out_ready_3_14;
logic       l2_almost_full_3_14;
logic [31:0] l2_csr_readdata_3_14;
logic       l2_newdata_3_14;
logic [RID_WIDTH-1:0] l2_cache_3_14;
logic [1:0] l1_req_3_14;
logic [1:0] l1_grant_3_14;
logic       l1_all_last_3_14;
logic       l1_same_3_14;
//logic [1:0] l1_all_last_3_14_r;
rule_s_t    l2_in_data_3_15;
rule_s_t    l2_out_data_3_15;
logic       l2_in_valid_3_15;
logic       l2_in_ready_3_15;
logic       l2_out_valid_3_15;
logic       l2_out_ready_3_15;
logic       l2_almost_full_3_15;
logic [31:0] l2_csr_readdata_3_15;
logic       l2_newdata_3_15;
logic [RID_WIDTH-1:0] l2_cache_3_15;
logic [1:0] l1_req_3_15;
logic [1:0] l1_grant_3_15;
logic       l1_all_last_3_15;
logic       l1_same_3_15;
//logic [1:0] l1_all_last_3_15_r;
rule_s_t    l2_in_data_4_0;
rule_s_t    l2_out_data_4_0;
logic       l2_in_valid_4_0;
logic       l2_in_ready_4_0;
logic       l2_out_valid_4_0;
logic       l2_out_ready_4_0;
logic       l2_almost_full_4_0;
logic [31:0] l2_csr_readdata_4_0;
logic       l2_newdata_4_0;
logic [RID_WIDTH-1:0] l2_cache_4_0;
logic [1:0] l1_req_4_0;
logic [1:0] l1_grant_4_0;
logic       l1_all_last_4_0;
logic       l1_same_4_0;
//logic [1:0] l1_all_last_4_0_r;
rule_s_t    l2_in_data_4_1;
rule_s_t    l2_out_data_4_1;
logic       l2_in_valid_4_1;
logic       l2_in_ready_4_1;
logic       l2_out_valid_4_1;
logic       l2_out_ready_4_1;
logic       l2_almost_full_4_1;
logic [31:0] l2_csr_readdata_4_1;
logic       l2_newdata_4_1;
logic [RID_WIDTH-1:0] l2_cache_4_1;
logic [1:0] l1_req_4_1;
logic [1:0] l1_grant_4_1;
logic       l1_all_last_4_1;
logic       l1_same_4_1;
//logic [1:0] l1_all_last_4_1_r;
rule_s_t    l2_in_data_4_2;
rule_s_t    l2_out_data_4_2;
logic       l2_in_valid_4_2;
logic       l2_in_ready_4_2;
logic       l2_out_valid_4_2;
logic       l2_out_ready_4_2;
logic       l2_almost_full_4_2;
logic [31:0] l2_csr_readdata_4_2;
logic       l2_newdata_4_2;
logic [RID_WIDTH-1:0] l2_cache_4_2;
logic [1:0] l1_req_4_2;
logic [1:0] l1_grant_4_2;
logic       l1_all_last_4_2;
logic       l1_same_4_2;
//logic [1:0] l1_all_last_4_2_r;
rule_s_t    l2_in_data_4_3;
rule_s_t    l2_out_data_4_3;
logic       l2_in_valid_4_3;
logic       l2_in_ready_4_3;
logic       l2_out_valid_4_3;
logic       l2_out_ready_4_3;
logic       l2_almost_full_4_3;
logic [31:0] l2_csr_readdata_4_3;
logic       l2_newdata_4_3;
logic [RID_WIDTH-1:0] l2_cache_4_3;
logic [1:0] l1_req_4_3;
logic [1:0] l1_grant_4_3;
logic       l1_all_last_4_3;
logic       l1_same_4_3;
//logic [1:0] l1_all_last_4_3_r;
rule_s_t    l2_in_data_4_4;
rule_s_t    l2_out_data_4_4;
logic       l2_in_valid_4_4;
logic       l2_in_ready_4_4;
logic       l2_out_valid_4_4;
logic       l2_out_ready_4_4;
logic       l2_almost_full_4_4;
logic [31:0] l2_csr_readdata_4_4;
logic       l2_newdata_4_4;
logic [RID_WIDTH-1:0] l2_cache_4_4;
logic [1:0] l1_req_4_4;
logic [1:0] l1_grant_4_4;
logic       l1_all_last_4_4;
logic       l1_same_4_4;
//logic [1:0] l1_all_last_4_4_r;
rule_s_t    l2_in_data_4_5;
rule_s_t    l2_out_data_4_5;
logic       l2_in_valid_4_5;
logic       l2_in_ready_4_5;
logic       l2_out_valid_4_5;
logic       l2_out_ready_4_5;
logic       l2_almost_full_4_5;
logic [31:0] l2_csr_readdata_4_5;
logic       l2_newdata_4_5;
logic [RID_WIDTH-1:0] l2_cache_4_5;
logic [1:0] l1_req_4_5;
logic [1:0] l1_grant_4_5;
logic       l1_all_last_4_5;
logic       l1_same_4_5;
//logic [1:0] l1_all_last_4_5_r;
rule_s_t    l2_in_data_4_6;
rule_s_t    l2_out_data_4_6;
logic       l2_in_valid_4_6;
logic       l2_in_ready_4_6;
logic       l2_out_valid_4_6;
logic       l2_out_ready_4_6;
logic       l2_almost_full_4_6;
logic [31:0] l2_csr_readdata_4_6;
logic       l2_newdata_4_6;
logic [RID_WIDTH-1:0] l2_cache_4_6;
logic [1:0] l1_req_4_6;
logic [1:0] l1_grant_4_6;
logic       l1_all_last_4_6;
logic       l1_same_4_6;
//logic [1:0] l1_all_last_4_6_r;
rule_s_t    l2_in_data_4_7;
rule_s_t    l2_out_data_4_7;
logic       l2_in_valid_4_7;
logic       l2_in_ready_4_7;
logic       l2_out_valid_4_7;
logic       l2_out_ready_4_7;
logic       l2_almost_full_4_7;
logic [31:0] l2_csr_readdata_4_7;
logic       l2_newdata_4_7;
logic [RID_WIDTH-1:0] l2_cache_4_7;
logic [1:0] l1_req_4_7;
logic [1:0] l1_grant_4_7;
logic       l1_all_last_4_7;
logic       l1_same_4_7;
//logic [1:0] l1_all_last_4_7_r;
rule_s_t    l2_in_data_4_8;
rule_s_t    l2_out_data_4_8;
logic       l2_in_valid_4_8;
logic       l2_in_ready_4_8;
logic       l2_out_valid_4_8;
logic       l2_out_ready_4_8;
logic       l2_almost_full_4_8;
logic [31:0] l2_csr_readdata_4_8;
logic       l2_newdata_4_8;
logic [RID_WIDTH-1:0] l2_cache_4_8;
logic [1:0] l1_req_4_8;
logic [1:0] l1_grant_4_8;
logic       l1_all_last_4_8;
logic       l1_same_4_8;
//logic [1:0] l1_all_last_4_8_r;
rule_s_t    l2_in_data_4_9;
rule_s_t    l2_out_data_4_9;
logic       l2_in_valid_4_9;
logic       l2_in_ready_4_9;
logic       l2_out_valid_4_9;
logic       l2_out_ready_4_9;
logic       l2_almost_full_4_9;
logic [31:0] l2_csr_readdata_4_9;
logic       l2_newdata_4_9;
logic [RID_WIDTH-1:0] l2_cache_4_9;
logic [1:0] l1_req_4_9;
logic [1:0] l1_grant_4_9;
logic       l1_all_last_4_9;
logic       l1_same_4_9;
//logic [1:0] l1_all_last_4_9_r;
rule_s_t    l2_in_data_4_10;
rule_s_t    l2_out_data_4_10;
logic       l2_in_valid_4_10;
logic       l2_in_ready_4_10;
logic       l2_out_valid_4_10;
logic       l2_out_ready_4_10;
logic       l2_almost_full_4_10;
logic [31:0] l2_csr_readdata_4_10;
logic       l2_newdata_4_10;
logic [RID_WIDTH-1:0] l2_cache_4_10;
logic [1:0] l1_req_4_10;
logic [1:0] l1_grant_4_10;
logic       l1_all_last_4_10;
logic       l1_same_4_10;
//logic [1:0] l1_all_last_4_10_r;
rule_s_t    l2_in_data_4_11;
rule_s_t    l2_out_data_4_11;
logic       l2_in_valid_4_11;
logic       l2_in_ready_4_11;
logic       l2_out_valid_4_11;
logic       l2_out_ready_4_11;
logic       l2_almost_full_4_11;
logic [31:0] l2_csr_readdata_4_11;
logic       l2_newdata_4_11;
logic [RID_WIDTH-1:0] l2_cache_4_11;
logic [1:0] l1_req_4_11;
logic [1:0] l1_grant_4_11;
logic       l1_all_last_4_11;
logic       l1_same_4_11;
//logic [1:0] l1_all_last_4_11_r;
rule_s_t    l2_in_data_4_12;
rule_s_t    l2_out_data_4_12;
logic       l2_in_valid_4_12;
logic       l2_in_ready_4_12;
logic       l2_out_valid_4_12;
logic       l2_out_ready_4_12;
logic       l2_almost_full_4_12;
logic [31:0] l2_csr_readdata_4_12;
logic       l2_newdata_4_12;
logic [RID_WIDTH-1:0] l2_cache_4_12;
logic [1:0] l1_req_4_12;
logic [1:0] l1_grant_4_12;
logic       l1_all_last_4_12;
logic       l1_same_4_12;
//logic [1:0] l1_all_last_4_12_r;
rule_s_t    l2_in_data_4_13;
rule_s_t    l2_out_data_4_13;
logic       l2_in_valid_4_13;
logic       l2_in_ready_4_13;
logic       l2_out_valid_4_13;
logic       l2_out_ready_4_13;
logic       l2_almost_full_4_13;
logic [31:0] l2_csr_readdata_4_13;
logic       l2_newdata_4_13;
logic [RID_WIDTH-1:0] l2_cache_4_13;
logic [1:0] l1_req_4_13;
logic [1:0] l1_grant_4_13;
logic       l1_all_last_4_13;
logic       l1_same_4_13;
//logic [1:0] l1_all_last_4_13_r;
rule_s_t    l2_in_data_4_14;
rule_s_t    l2_out_data_4_14;
logic       l2_in_valid_4_14;
logic       l2_in_ready_4_14;
logic       l2_out_valid_4_14;
logic       l2_out_ready_4_14;
logic       l2_almost_full_4_14;
logic [31:0] l2_csr_readdata_4_14;
logic       l2_newdata_4_14;
logic [RID_WIDTH-1:0] l2_cache_4_14;
logic [1:0] l1_req_4_14;
logic [1:0] l1_grant_4_14;
logic       l1_all_last_4_14;
logic       l1_same_4_14;
//logic [1:0] l1_all_last_4_14_r;
rule_s_t    l2_in_data_4_15;
rule_s_t    l2_out_data_4_15;
logic       l2_in_valid_4_15;
logic       l2_in_ready_4_15;
logic       l2_out_valid_4_15;
logic       l2_out_ready_4_15;
logic       l2_almost_full_4_15;
logic [31:0] l2_csr_readdata_4_15;
logic       l2_newdata_4_15;
logic [RID_WIDTH-1:0] l2_cache_4_15;
logic [1:0] l1_req_4_15;
logic [1:0] l1_grant_4_15;
logic       l1_all_last_4_15;
logic       l1_same_4_15;
//logic [1:0] l1_all_last_4_15_r;
rule_s_t    l2_in_data_5_0;
rule_s_t    l2_out_data_5_0;
logic       l2_in_valid_5_0;
logic       l2_in_ready_5_0;
logic       l2_out_valid_5_0;
logic       l2_out_ready_5_0;
logic       l2_almost_full_5_0;
logic [31:0] l2_csr_readdata_5_0;
logic       l2_newdata_5_0;
logic [RID_WIDTH-1:0] l2_cache_5_0;
logic [1:0] l1_req_5_0;
logic [1:0] l1_grant_5_0;
logic       l1_all_last_5_0;
logic       l1_same_5_0;
//logic [1:0] l1_all_last_5_0_r;
rule_s_t    l2_in_data_5_1;
rule_s_t    l2_out_data_5_1;
logic       l2_in_valid_5_1;
logic       l2_in_ready_5_1;
logic       l2_out_valid_5_1;
logic       l2_out_ready_5_1;
logic       l2_almost_full_5_1;
logic [31:0] l2_csr_readdata_5_1;
logic       l2_newdata_5_1;
logic [RID_WIDTH-1:0] l2_cache_5_1;
logic [1:0] l1_req_5_1;
logic [1:0] l1_grant_5_1;
logic       l1_all_last_5_1;
logic       l1_same_5_1;
//logic [1:0] l1_all_last_5_1_r;
rule_s_t    l2_in_data_5_2;
rule_s_t    l2_out_data_5_2;
logic       l2_in_valid_5_2;
logic       l2_in_ready_5_2;
logic       l2_out_valid_5_2;
logic       l2_out_ready_5_2;
logic       l2_almost_full_5_2;
logic [31:0] l2_csr_readdata_5_2;
logic       l2_newdata_5_2;
logic [RID_WIDTH-1:0] l2_cache_5_2;
logic [1:0] l1_req_5_2;
logic [1:0] l1_grant_5_2;
logic       l1_all_last_5_2;
logic       l1_same_5_2;
//logic [1:0] l1_all_last_5_2_r;
rule_s_t    l2_in_data_5_3;
rule_s_t    l2_out_data_5_3;
logic       l2_in_valid_5_3;
logic       l2_in_ready_5_3;
logic       l2_out_valid_5_3;
logic       l2_out_ready_5_3;
logic       l2_almost_full_5_3;
logic [31:0] l2_csr_readdata_5_3;
logic       l2_newdata_5_3;
logic [RID_WIDTH-1:0] l2_cache_5_3;
logic [1:0] l1_req_5_3;
logic [1:0] l1_grant_5_3;
logic       l1_all_last_5_3;
logic       l1_same_5_3;
//logic [1:0] l1_all_last_5_3_r;
rule_s_t    l2_in_data_5_4;
rule_s_t    l2_out_data_5_4;
logic       l2_in_valid_5_4;
logic       l2_in_ready_5_4;
logic       l2_out_valid_5_4;
logic       l2_out_ready_5_4;
logic       l2_almost_full_5_4;
logic [31:0] l2_csr_readdata_5_4;
logic       l2_newdata_5_4;
logic [RID_WIDTH-1:0] l2_cache_5_4;
logic [1:0] l1_req_5_4;
logic [1:0] l1_grant_5_4;
logic       l1_all_last_5_4;
logic       l1_same_5_4;
//logic [1:0] l1_all_last_5_4_r;
rule_s_t    l2_in_data_5_5;
rule_s_t    l2_out_data_5_5;
logic       l2_in_valid_5_5;
logic       l2_in_ready_5_5;
logic       l2_out_valid_5_5;
logic       l2_out_ready_5_5;
logic       l2_almost_full_5_5;
logic [31:0] l2_csr_readdata_5_5;
logic       l2_newdata_5_5;
logic [RID_WIDTH-1:0] l2_cache_5_5;
logic [1:0] l1_req_5_5;
logic [1:0] l1_grant_5_5;
logic       l1_all_last_5_5;
logic       l1_same_5_5;
//logic [1:0] l1_all_last_5_5_r;
rule_s_t    l2_in_data_5_6;
rule_s_t    l2_out_data_5_6;
logic       l2_in_valid_5_6;
logic       l2_in_ready_5_6;
logic       l2_out_valid_5_6;
logic       l2_out_ready_5_6;
logic       l2_almost_full_5_6;
logic [31:0] l2_csr_readdata_5_6;
logic       l2_newdata_5_6;
logic [RID_WIDTH-1:0] l2_cache_5_6;
logic [1:0] l1_req_5_6;
logic [1:0] l1_grant_5_6;
logic       l1_all_last_5_6;
logic       l1_same_5_6;
//logic [1:0] l1_all_last_5_6_r;
rule_s_t    l2_in_data_5_7;
rule_s_t    l2_out_data_5_7;
logic       l2_in_valid_5_7;
logic       l2_in_ready_5_7;
logic       l2_out_valid_5_7;
logic       l2_out_ready_5_7;
logic       l2_almost_full_5_7;
logic [31:0] l2_csr_readdata_5_7;
logic       l2_newdata_5_7;
logic [RID_WIDTH-1:0] l2_cache_5_7;
logic [1:0] l1_req_5_7;
logic [1:0] l1_grant_5_7;
logic       l1_all_last_5_7;
logic       l1_same_5_7;
//logic [1:0] l1_all_last_5_7_r;
rule_s_t    l2_in_data_5_8;
rule_s_t    l2_out_data_5_8;
logic       l2_in_valid_5_8;
logic       l2_in_ready_5_8;
logic       l2_out_valid_5_8;
logic       l2_out_ready_5_8;
logic       l2_almost_full_5_8;
logic [31:0] l2_csr_readdata_5_8;
logic       l2_newdata_5_8;
logic [RID_WIDTH-1:0] l2_cache_5_8;
logic [1:0] l1_req_5_8;
logic [1:0] l1_grant_5_8;
logic       l1_all_last_5_8;
logic       l1_same_5_8;
//logic [1:0] l1_all_last_5_8_r;
rule_s_t    l2_in_data_5_9;
rule_s_t    l2_out_data_5_9;
logic       l2_in_valid_5_9;
logic       l2_in_ready_5_9;
logic       l2_out_valid_5_9;
logic       l2_out_ready_5_9;
logic       l2_almost_full_5_9;
logic [31:0] l2_csr_readdata_5_9;
logic       l2_newdata_5_9;
logic [RID_WIDTH-1:0] l2_cache_5_9;
logic [1:0] l1_req_5_9;
logic [1:0] l1_grant_5_9;
logic       l1_all_last_5_9;
logic       l1_same_5_9;
//logic [1:0] l1_all_last_5_9_r;
rule_s_t    l2_in_data_5_10;
rule_s_t    l2_out_data_5_10;
logic       l2_in_valid_5_10;
logic       l2_in_ready_5_10;
logic       l2_out_valid_5_10;
logic       l2_out_ready_5_10;
logic       l2_almost_full_5_10;
logic [31:0] l2_csr_readdata_5_10;
logic       l2_newdata_5_10;
logic [RID_WIDTH-1:0] l2_cache_5_10;
logic [1:0] l1_req_5_10;
logic [1:0] l1_grant_5_10;
logic       l1_all_last_5_10;
logic       l1_same_5_10;
//logic [1:0] l1_all_last_5_10_r;
rule_s_t    l2_in_data_5_11;
rule_s_t    l2_out_data_5_11;
logic       l2_in_valid_5_11;
logic       l2_in_ready_5_11;
logic       l2_out_valid_5_11;
logic       l2_out_ready_5_11;
logic       l2_almost_full_5_11;
logic [31:0] l2_csr_readdata_5_11;
logic       l2_newdata_5_11;
logic [RID_WIDTH-1:0] l2_cache_5_11;
logic [1:0] l1_req_5_11;
logic [1:0] l1_grant_5_11;
logic       l1_all_last_5_11;
logic       l1_same_5_11;
//logic [1:0] l1_all_last_5_11_r;
rule_s_t    l2_in_data_5_12;
rule_s_t    l2_out_data_5_12;
logic       l2_in_valid_5_12;
logic       l2_in_ready_5_12;
logic       l2_out_valid_5_12;
logic       l2_out_ready_5_12;
logic       l2_almost_full_5_12;
logic [31:0] l2_csr_readdata_5_12;
logic       l2_newdata_5_12;
logic [RID_WIDTH-1:0] l2_cache_5_12;
logic [1:0] l1_req_5_12;
logic [1:0] l1_grant_5_12;
logic       l1_all_last_5_12;
logic       l1_same_5_12;
//logic [1:0] l1_all_last_5_12_r;
rule_s_t    l2_in_data_5_13;
rule_s_t    l2_out_data_5_13;
logic       l2_in_valid_5_13;
logic       l2_in_ready_5_13;
logic       l2_out_valid_5_13;
logic       l2_out_ready_5_13;
logic       l2_almost_full_5_13;
logic [31:0] l2_csr_readdata_5_13;
logic       l2_newdata_5_13;
logic [RID_WIDTH-1:0] l2_cache_5_13;
logic [1:0] l1_req_5_13;
logic [1:0] l1_grant_5_13;
logic       l1_all_last_5_13;
logic       l1_same_5_13;
//logic [1:0] l1_all_last_5_13_r;
rule_s_t    l2_in_data_5_14;
rule_s_t    l2_out_data_5_14;
logic       l2_in_valid_5_14;
logic       l2_in_ready_5_14;
logic       l2_out_valid_5_14;
logic       l2_out_ready_5_14;
logic       l2_almost_full_5_14;
logic [31:0] l2_csr_readdata_5_14;
logic       l2_newdata_5_14;
logic [RID_WIDTH-1:0] l2_cache_5_14;
logic [1:0] l1_req_5_14;
logic [1:0] l1_grant_5_14;
logic       l1_all_last_5_14;
logic       l1_same_5_14;
//logic [1:0] l1_all_last_5_14_r;
rule_s_t    l2_in_data_5_15;
rule_s_t    l2_out_data_5_15;
logic       l2_in_valid_5_15;
logic       l2_in_ready_5_15;
logic       l2_out_valid_5_15;
logic       l2_out_ready_5_15;
logic       l2_almost_full_5_15;
logic [31:0] l2_csr_readdata_5_15;
logic       l2_newdata_5_15;
logic [RID_WIDTH-1:0] l2_cache_5_15;
logic [1:0] l1_req_5_15;
logic [1:0] l1_grant_5_15;
logic       l1_all_last_5_15;
logic       l1_same_5_15;
//logic [1:0] l1_all_last_5_15_r;
rule_s_t    l2_in_data_6_0;
rule_s_t    l2_out_data_6_0;
logic       l2_in_valid_6_0;
logic       l2_in_ready_6_0;
logic       l2_out_valid_6_0;
logic       l2_out_ready_6_0;
logic       l2_almost_full_6_0;
logic [31:0] l2_csr_readdata_6_0;
logic       l2_newdata_6_0;
logic [RID_WIDTH-1:0] l2_cache_6_0;
logic [1:0] l1_req_6_0;
logic [1:0] l1_grant_6_0;
logic       l1_all_last_6_0;
logic       l1_same_6_0;
//logic [1:0] l1_all_last_6_0_r;
rule_s_t    l2_in_data_6_1;
rule_s_t    l2_out_data_6_1;
logic       l2_in_valid_6_1;
logic       l2_in_ready_6_1;
logic       l2_out_valid_6_1;
logic       l2_out_ready_6_1;
logic       l2_almost_full_6_1;
logic [31:0] l2_csr_readdata_6_1;
logic       l2_newdata_6_1;
logic [RID_WIDTH-1:0] l2_cache_6_1;
logic [1:0] l1_req_6_1;
logic [1:0] l1_grant_6_1;
logic       l1_all_last_6_1;
logic       l1_same_6_1;
//logic [1:0] l1_all_last_6_1_r;
rule_s_t    l2_in_data_6_2;
rule_s_t    l2_out_data_6_2;
logic       l2_in_valid_6_2;
logic       l2_in_ready_6_2;
logic       l2_out_valid_6_2;
logic       l2_out_ready_6_2;
logic       l2_almost_full_6_2;
logic [31:0] l2_csr_readdata_6_2;
logic       l2_newdata_6_2;
logic [RID_WIDTH-1:0] l2_cache_6_2;
logic [1:0] l1_req_6_2;
logic [1:0] l1_grant_6_2;
logic       l1_all_last_6_2;
logic       l1_same_6_2;
//logic [1:0] l1_all_last_6_2_r;
rule_s_t    l2_in_data_6_3;
rule_s_t    l2_out_data_6_3;
logic       l2_in_valid_6_3;
logic       l2_in_ready_6_3;
logic       l2_out_valid_6_3;
logic       l2_out_ready_6_3;
logic       l2_almost_full_6_3;
logic [31:0] l2_csr_readdata_6_3;
logic       l2_newdata_6_3;
logic [RID_WIDTH-1:0] l2_cache_6_3;
logic [1:0] l1_req_6_3;
logic [1:0] l1_grant_6_3;
logic       l1_all_last_6_3;
logic       l1_same_6_3;
//logic [1:0] l1_all_last_6_3_r;
rule_s_t    l2_in_data_6_4;
rule_s_t    l2_out_data_6_4;
logic       l2_in_valid_6_4;
logic       l2_in_ready_6_4;
logic       l2_out_valid_6_4;
logic       l2_out_ready_6_4;
logic       l2_almost_full_6_4;
logic [31:0] l2_csr_readdata_6_4;
logic       l2_newdata_6_4;
logic [RID_WIDTH-1:0] l2_cache_6_4;
logic [1:0] l1_req_6_4;
logic [1:0] l1_grant_6_4;
logic       l1_all_last_6_4;
logic       l1_same_6_4;
//logic [1:0] l1_all_last_6_4_r;
rule_s_t    l2_in_data_6_5;
rule_s_t    l2_out_data_6_5;
logic       l2_in_valid_6_5;
logic       l2_in_ready_6_5;
logic       l2_out_valid_6_5;
logic       l2_out_ready_6_5;
logic       l2_almost_full_6_5;
logic [31:0] l2_csr_readdata_6_5;
logic       l2_newdata_6_5;
logic [RID_WIDTH-1:0] l2_cache_6_5;
logic [1:0] l1_req_6_5;
logic [1:0] l1_grant_6_5;
logic       l1_all_last_6_5;
logic       l1_same_6_5;
//logic [1:0] l1_all_last_6_5_r;
rule_s_t    l2_in_data_6_6;
rule_s_t    l2_out_data_6_6;
logic       l2_in_valid_6_6;
logic       l2_in_ready_6_6;
logic       l2_out_valid_6_6;
logic       l2_out_ready_6_6;
logic       l2_almost_full_6_6;
logic [31:0] l2_csr_readdata_6_6;
logic       l2_newdata_6_6;
logic [RID_WIDTH-1:0] l2_cache_6_6;
logic [1:0] l1_req_6_6;
logic [1:0] l1_grant_6_6;
logic       l1_all_last_6_6;
logic       l1_same_6_6;
//logic [1:0] l1_all_last_6_6_r;
rule_s_t    l2_in_data_6_7;
rule_s_t    l2_out_data_6_7;
logic       l2_in_valid_6_7;
logic       l2_in_ready_6_7;
logic       l2_out_valid_6_7;
logic       l2_out_ready_6_7;
logic       l2_almost_full_6_7;
logic [31:0] l2_csr_readdata_6_7;
logic       l2_newdata_6_7;
logic [RID_WIDTH-1:0] l2_cache_6_7;
logic [1:0] l1_req_6_7;
logic [1:0] l1_grant_6_7;
logic       l1_all_last_6_7;
logic       l1_same_6_7;
//logic [1:0] l1_all_last_6_7_r;
rule_s_t    l2_in_data_6_8;
rule_s_t    l2_out_data_6_8;
logic       l2_in_valid_6_8;
logic       l2_in_ready_6_8;
logic       l2_out_valid_6_8;
logic       l2_out_ready_6_8;
logic       l2_almost_full_6_8;
logic [31:0] l2_csr_readdata_6_8;
logic       l2_newdata_6_8;
logic [RID_WIDTH-1:0] l2_cache_6_8;
logic [1:0] l1_req_6_8;
logic [1:0] l1_grant_6_8;
logic       l1_all_last_6_8;
logic       l1_same_6_8;
//logic [1:0] l1_all_last_6_8_r;
rule_s_t    l2_in_data_6_9;
rule_s_t    l2_out_data_6_9;
logic       l2_in_valid_6_9;
logic       l2_in_ready_6_9;
logic       l2_out_valid_6_9;
logic       l2_out_ready_6_9;
logic       l2_almost_full_6_9;
logic [31:0] l2_csr_readdata_6_9;
logic       l2_newdata_6_9;
logic [RID_WIDTH-1:0] l2_cache_6_9;
logic [1:0] l1_req_6_9;
logic [1:0] l1_grant_6_9;
logic       l1_all_last_6_9;
logic       l1_same_6_9;
//logic [1:0] l1_all_last_6_9_r;
rule_s_t    l2_in_data_6_10;
rule_s_t    l2_out_data_6_10;
logic       l2_in_valid_6_10;
logic       l2_in_ready_6_10;
logic       l2_out_valid_6_10;
logic       l2_out_ready_6_10;
logic       l2_almost_full_6_10;
logic [31:0] l2_csr_readdata_6_10;
logic       l2_newdata_6_10;
logic [RID_WIDTH-1:0] l2_cache_6_10;
logic [1:0] l1_req_6_10;
logic [1:0] l1_grant_6_10;
logic       l1_all_last_6_10;
logic       l1_same_6_10;
//logic [1:0] l1_all_last_6_10_r;
rule_s_t    l2_in_data_6_11;
rule_s_t    l2_out_data_6_11;
logic       l2_in_valid_6_11;
logic       l2_in_ready_6_11;
logic       l2_out_valid_6_11;
logic       l2_out_ready_6_11;
logic       l2_almost_full_6_11;
logic [31:0] l2_csr_readdata_6_11;
logic       l2_newdata_6_11;
logic [RID_WIDTH-1:0] l2_cache_6_11;
logic [1:0] l1_req_6_11;
logic [1:0] l1_grant_6_11;
logic       l1_all_last_6_11;
logic       l1_same_6_11;
//logic [1:0] l1_all_last_6_11_r;
rule_s_t    l2_in_data_6_12;
rule_s_t    l2_out_data_6_12;
logic       l2_in_valid_6_12;
logic       l2_in_ready_6_12;
logic       l2_out_valid_6_12;
logic       l2_out_ready_6_12;
logic       l2_almost_full_6_12;
logic [31:0] l2_csr_readdata_6_12;
logic       l2_newdata_6_12;
logic [RID_WIDTH-1:0] l2_cache_6_12;
logic [1:0] l1_req_6_12;
logic [1:0] l1_grant_6_12;
logic       l1_all_last_6_12;
logic       l1_same_6_12;
//logic [1:0] l1_all_last_6_12_r;
rule_s_t    l2_in_data_6_13;
rule_s_t    l2_out_data_6_13;
logic       l2_in_valid_6_13;
logic       l2_in_ready_6_13;
logic       l2_out_valid_6_13;
logic       l2_out_ready_6_13;
logic       l2_almost_full_6_13;
logic [31:0] l2_csr_readdata_6_13;
logic       l2_newdata_6_13;
logic [RID_WIDTH-1:0] l2_cache_6_13;
logic [1:0] l1_req_6_13;
logic [1:0] l1_grant_6_13;
logic       l1_all_last_6_13;
logic       l1_same_6_13;
//logic [1:0] l1_all_last_6_13_r;
rule_s_t    l2_in_data_6_14;
rule_s_t    l2_out_data_6_14;
logic       l2_in_valid_6_14;
logic       l2_in_ready_6_14;
logic       l2_out_valid_6_14;
logic       l2_out_ready_6_14;
logic       l2_almost_full_6_14;
logic [31:0] l2_csr_readdata_6_14;
logic       l2_newdata_6_14;
logic [RID_WIDTH-1:0] l2_cache_6_14;
logic [1:0] l1_req_6_14;
logic [1:0] l1_grant_6_14;
logic       l1_all_last_6_14;
logic       l1_same_6_14;
//logic [1:0] l1_all_last_6_14_r;
rule_s_t    l2_in_data_6_15;
rule_s_t    l2_out_data_6_15;
logic       l2_in_valid_6_15;
logic       l2_in_ready_6_15;
logic       l2_out_valid_6_15;
logic       l2_out_ready_6_15;
logic       l2_almost_full_6_15;
logic [31:0] l2_csr_readdata_6_15;
logic       l2_newdata_6_15;
logic [RID_WIDTH-1:0] l2_cache_6_15;
logic [1:0] l1_req_6_15;
logic [1:0] l1_grant_6_15;
logic       l1_all_last_6_15;
logic       l1_same_6_15;
//logic [1:0] l1_all_last_6_15_r;
rule_s_t    l2_in_data_7_0;
rule_s_t    l2_out_data_7_0;
logic       l2_in_valid_7_0;
logic       l2_in_ready_7_0;
logic       l2_out_valid_7_0;
logic       l2_out_ready_7_0;
logic       l2_almost_full_7_0;
logic [31:0] l2_csr_readdata_7_0;
logic       l2_newdata_7_0;
logic [RID_WIDTH-1:0] l2_cache_7_0;
logic [1:0] l1_req_7_0;
logic [1:0] l1_grant_7_0;
logic       l1_all_last_7_0;
logic       l1_same_7_0;
//logic [1:0] l1_all_last_7_0_r;
rule_s_t    l2_in_data_7_1;
rule_s_t    l2_out_data_7_1;
logic       l2_in_valid_7_1;
logic       l2_in_ready_7_1;
logic       l2_out_valid_7_1;
logic       l2_out_ready_7_1;
logic       l2_almost_full_7_1;
logic [31:0] l2_csr_readdata_7_1;
logic       l2_newdata_7_1;
logic [RID_WIDTH-1:0] l2_cache_7_1;
logic [1:0] l1_req_7_1;
logic [1:0] l1_grant_7_1;
logic       l1_all_last_7_1;
logic       l1_same_7_1;
//logic [1:0] l1_all_last_7_1_r;
rule_s_t    l2_in_data_7_2;
rule_s_t    l2_out_data_7_2;
logic       l2_in_valid_7_2;
logic       l2_in_ready_7_2;
logic       l2_out_valid_7_2;
logic       l2_out_ready_7_2;
logic       l2_almost_full_7_2;
logic [31:0] l2_csr_readdata_7_2;
logic       l2_newdata_7_2;
logic [RID_WIDTH-1:0] l2_cache_7_2;
logic [1:0] l1_req_7_2;
logic [1:0] l1_grant_7_2;
logic       l1_all_last_7_2;
logic       l1_same_7_2;
//logic [1:0] l1_all_last_7_2_r;
rule_s_t    l2_in_data_7_3;
rule_s_t    l2_out_data_7_3;
logic       l2_in_valid_7_3;
logic       l2_in_ready_7_3;
logic       l2_out_valid_7_3;
logic       l2_out_ready_7_3;
logic       l2_almost_full_7_3;
logic [31:0] l2_csr_readdata_7_3;
logic       l2_newdata_7_3;
logic [RID_WIDTH-1:0] l2_cache_7_3;
logic [1:0] l1_req_7_3;
logic [1:0] l1_grant_7_3;
logic       l1_all_last_7_3;
logic       l1_same_7_3;
//logic [1:0] l1_all_last_7_3_r;
rule_s_t    l2_in_data_7_4;
rule_s_t    l2_out_data_7_4;
logic       l2_in_valid_7_4;
logic       l2_in_ready_7_4;
logic       l2_out_valid_7_4;
logic       l2_out_ready_7_4;
logic       l2_almost_full_7_4;
logic [31:0] l2_csr_readdata_7_4;
logic       l2_newdata_7_4;
logic [RID_WIDTH-1:0] l2_cache_7_4;
logic [1:0] l1_req_7_4;
logic [1:0] l1_grant_7_4;
logic       l1_all_last_7_4;
logic       l1_same_7_4;
//logic [1:0] l1_all_last_7_4_r;
rule_s_t    l2_in_data_7_5;
rule_s_t    l2_out_data_7_5;
logic       l2_in_valid_7_5;
logic       l2_in_ready_7_5;
logic       l2_out_valid_7_5;
logic       l2_out_ready_7_5;
logic       l2_almost_full_7_5;
logic [31:0] l2_csr_readdata_7_5;
logic       l2_newdata_7_5;
logic [RID_WIDTH-1:0] l2_cache_7_5;
logic [1:0] l1_req_7_5;
logic [1:0] l1_grant_7_5;
logic       l1_all_last_7_5;
logic       l1_same_7_5;
//logic [1:0] l1_all_last_7_5_r;
rule_s_t    l2_in_data_7_6;
rule_s_t    l2_out_data_7_6;
logic       l2_in_valid_7_6;
logic       l2_in_ready_7_6;
logic       l2_out_valid_7_6;
logic       l2_out_ready_7_6;
logic       l2_almost_full_7_6;
logic [31:0] l2_csr_readdata_7_6;
logic       l2_newdata_7_6;
logic [RID_WIDTH-1:0] l2_cache_7_6;
logic [1:0] l1_req_7_6;
logic [1:0] l1_grant_7_6;
logic       l1_all_last_7_6;
logic       l1_same_7_6;
//logic [1:0] l1_all_last_7_6_r;
rule_s_t    l2_in_data_7_7;
rule_s_t    l2_out_data_7_7;
logic       l2_in_valid_7_7;
logic       l2_in_ready_7_7;
logic       l2_out_valid_7_7;
logic       l2_out_ready_7_7;
logic       l2_almost_full_7_7;
logic [31:0] l2_csr_readdata_7_7;
logic       l2_newdata_7_7;
logic [RID_WIDTH-1:0] l2_cache_7_7;
logic [1:0] l1_req_7_7;
logic [1:0] l1_grant_7_7;
logic       l1_all_last_7_7;
logic       l1_same_7_7;
//logic [1:0] l1_all_last_7_7_r;
rule_s_t    l2_in_data_7_8;
rule_s_t    l2_out_data_7_8;
logic       l2_in_valid_7_8;
logic       l2_in_ready_7_8;
logic       l2_out_valid_7_8;
logic       l2_out_ready_7_8;
logic       l2_almost_full_7_8;
logic [31:0] l2_csr_readdata_7_8;
logic       l2_newdata_7_8;
logic [RID_WIDTH-1:0] l2_cache_7_8;
logic [1:0] l1_req_7_8;
logic [1:0] l1_grant_7_8;
logic       l1_all_last_7_8;
logic       l1_same_7_8;
//logic [1:0] l1_all_last_7_8_r;
rule_s_t    l2_in_data_7_9;
rule_s_t    l2_out_data_7_9;
logic       l2_in_valid_7_9;
logic       l2_in_ready_7_9;
logic       l2_out_valid_7_9;
logic       l2_out_ready_7_9;
logic       l2_almost_full_7_9;
logic [31:0] l2_csr_readdata_7_9;
logic       l2_newdata_7_9;
logic [RID_WIDTH-1:0] l2_cache_7_9;
logic [1:0] l1_req_7_9;
logic [1:0] l1_grant_7_9;
logic       l1_all_last_7_9;
logic       l1_same_7_9;
//logic [1:0] l1_all_last_7_9_r;
rule_s_t    l2_in_data_7_10;
rule_s_t    l2_out_data_7_10;
logic       l2_in_valid_7_10;
logic       l2_in_ready_7_10;
logic       l2_out_valid_7_10;
logic       l2_out_ready_7_10;
logic       l2_almost_full_7_10;
logic [31:0] l2_csr_readdata_7_10;
logic       l2_newdata_7_10;
logic [RID_WIDTH-1:0] l2_cache_7_10;
logic [1:0] l1_req_7_10;
logic [1:0] l1_grant_7_10;
logic       l1_all_last_7_10;
logic       l1_same_7_10;
//logic [1:0] l1_all_last_7_10_r;
rule_s_t    l2_in_data_7_11;
rule_s_t    l2_out_data_7_11;
logic       l2_in_valid_7_11;
logic       l2_in_ready_7_11;
logic       l2_out_valid_7_11;
logic       l2_out_ready_7_11;
logic       l2_almost_full_7_11;
logic [31:0] l2_csr_readdata_7_11;
logic       l2_newdata_7_11;
logic [RID_WIDTH-1:0] l2_cache_7_11;
logic [1:0] l1_req_7_11;
logic [1:0] l1_grant_7_11;
logic       l1_all_last_7_11;
logic       l1_same_7_11;
//logic [1:0] l1_all_last_7_11_r;
rule_s_t    l2_in_data_7_12;
rule_s_t    l2_out_data_7_12;
logic       l2_in_valid_7_12;
logic       l2_in_ready_7_12;
logic       l2_out_valid_7_12;
logic       l2_out_ready_7_12;
logic       l2_almost_full_7_12;
logic [31:0] l2_csr_readdata_7_12;
logic       l2_newdata_7_12;
logic [RID_WIDTH-1:0] l2_cache_7_12;
logic [1:0] l1_req_7_12;
logic [1:0] l1_grant_7_12;
logic       l1_all_last_7_12;
logic       l1_same_7_12;
//logic [1:0] l1_all_last_7_12_r;
rule_s_t    l2_in_data_7_13;
rule_s_t    l2_out_data_7_13;
logic       l2_in_valid_7_13;
logic       l2_in_ready_7_13;
logic       l2_out_valid_7_13;
logic       l2_out_ready_7_13;
logic       l2_almost_full_7_13;
logic [31:0] l2_csr_readdata_7_13;
logic       l2_newdata_7_13;
logic [RID_WIDTH-1:0] l2_cache_7_13;
logic [1:0] l1_req_7_13;
logic [1:0] l1_grant_7_13;
logic       l1_all_last_7_13;
logic       l1_same_7_13;
//logic [1:0] l1_all_last_7_13_r;
rule_s_t    l2_in_data_7_14;
rule_s_t    l2_out_data_7_14;
logic       l2_in_valid_7_14;
logic       l2_in_ready_7_14;
logic       l2_out_valid_7_14;
logic       l2_out_ready_7_14;
logic       l2_almost_full_7_14;
logic [31:0] l2_csr_readdata_7_14;
logic       l2_newdata_7_14;
logic [RID_WIDTH-1:0] l2_cache_7_14;
logic [1:0] l1_req_7_14;
logic [1:0] l1_grant_7_14;
logic       l1_all_last_7_14;
logic       l1_same_7_14;
//logic [1:0] l1_all_last_7_14_r;
rule_s_t    l2_in_data_7_15;
rule_s_t    l2_out_data_7_15;
logic       l2_in_valid_7_15;
logic       l2_in_ready_7_15;
logic       l2_out_valid_7_15;
logic       l2_out_ready_7_15;
logic       l2_almost_full_7_15;
logic [31:0] l2_csr_readdata_7_15;
logic       l2_newdata_7_15;
logic [RID_WIDTH-1:0] l2_cache_7_15;
logic [1:0] l1_req_7_15;
logic [1:0] l1_grant_7_15;
logic       l1_all_last_7_15;
logic       l1_same_7_15;
//logic [1:0] l1_all_last_7_15_r;

//L2 ARB and L3 FIFO
rule_s_t l3_in_data_0_0;
rule_s_t l3_out_data_0_0;
logic l3_in_valid_0_0;
logic l3_in_ready_0_0;
logic l3_out_valid_0_0;
logic l3_out_ready_0_0;
logic l3_almost_full_0_0;
logic [31:0] l3_csr_readdata_0_0;
logic       l3_newdata_0_0;
logic [RID_WIDTH-1:0] l3_cache_0_0;
logic [3:0] l2_req_0_0;
logic [3:0] l2_grant_0_0;
logic       l2_all_last_0_0;
logic       l2_same_0_0;
//logic [1:0] l2_all_last_0_0_r;
rule_s_t l3_in_data_0_1;
rule_s_t l3_out_data_0_1;
logic l3_in_valid_0_1;
logic l3_in_ready_0_1;
logic l3_out_valid_0_1;
logic l3_out_ready_0_1;
logic l3_almost_full_0_1;
logic [31:0] l3_csr_readdata_0_1;
logic       l3_newdata_0_1;
logic [RID_WIDTH-1:0] l3_cache_0_1;
logic [3:0] l2_req_0_1;
logic [3:0] l2_grant_0_1;
logic       l2_all_last_0_1;
logic       l2_same_0_1;
//logic [1:0] l2_all_last_0_1_r;
rule_s_t l3_in_data_0_2;
rule_s_t l3_out_data_0_2;
logic l3_in_valid_0_2;
logic l3_in_ready_0_2;
logic l3_out_valid_0_2;
logic l3_out_ready_0_2;
logic l3_almost_full_0_2;
logic [31:0] l3_csr_readdata_0_2;
logic       l3_newdata_0_2;
logic [RID_WIDTH-1:0] l3_cache_0_2;
logic [3:0] l2_req_0_2;
logic [3:0] l2_grant_0_2;
logic       l2_all_last_0_2;
logic       l2_same_0_2;
//logic [1:0] l2_all_last_0_2_r;
rule_s_t l3_in_data_0_3;
rule_s_t l3_out_data_0_3;
logic l3_in_valid_0_3;
logic l3_in_ready_0_3;
logic l3_out_valid_0_3;
logic l3_out_ready_0_3;
logic l3_almost_full_0_3;
logic [31:0] l3_csr_readdata_0_3;
logic       l3_newdata_0_3;
logic [RID_WIDTH-1:0] l3_cache_0_3;
logic [3:0] l2_req_0_3;
logic [3:0] l2_grant_0_3;
logic       l2_all_last_0_3;
logic       l2_same_0_3;
//logic [1:0] l2_all_last_0_3_r;
rule_s_t l3_in_data_1_0;
rule_s_t l3_out_data_1_0;
logic l3_in_valid_1_0;
logic l3_in_ready_1_0;
logic l3_out_valid_1_0;
logic l3_out_ready_1_0;
logic l3_almost_full_1_0;
logic [31:0] l3_csr_readdata_1_0;
logic       l3_newdata_1_0;
logic [RID_WIDTH-1:0] l3_cache_1_0;
logic [3:0] l2_req_1_0;
logic [3:0] l2_grant_1_0;
logic       l2_all_last_1_0;
logic       l2_same_1_0;
//logic [1:0] l2_all_last_1_0_r;
rule_s_t l3_in_data_1_1;
rule_s_t l3_out_data_1_1;
logic l3_in_valid_1_1;
logic l3_in_ready_1_1;
logic l3_out_valid_1_1;
logic l3_out_ready_1_1;
logic l3_almost_full_1_1;
logic [31:0] l3_csr_readdata_1_1;
logic       l3_newdata_1_1;
logic [RID_WIDTH-1:0] l3_cache_1_1;
logic [3:0] l2_req_1_1;
logic [3:0] l2_grant_1_1;
logic       l2_all_last_1_1;
logic       l2_same_1_1;
//logic [1:0] l2_all_last_1_1_r;
rule_s_t l3_in_data_1_2;
rule_s_t l3_out_data_1_2;
logic l3_in_valid_1_2;
logic l3_in_ready_1_2;
logic l3_out_valid_1_2;
logic l3_out_ready_1_2;
logic l3_almost_full_1_2;
logic [31:0] l3_csr_readdata_1_2;
logic       l3_newdata_1_2;
logic [RID_WIDTH-1:0] l3_cache_1_2;
logic [3:0] l2_req_1_2;
logic [3:0] l2_grant_1_2;
logic       l2_all_last_1_2;
logic       l2_same_1_2;
//logic [1:0] l2_all_last_1_2_r;
rule_s_t l3_in_data_1_3;
rule_s_t l3_out_data_1_3;
logic l3_in_valid_1_3;
logic l3_in_ready_1_3;
logic l3_out_valid_1_3;
logic l3_out_ready_1_3;
logic l3_almost_full_1_3;
logic [31:0] l3_csr_readdata_1_3;
logic       l3_newdata_1_3;
logic [RID_WIDTH-1:0] l3_cache_1_3;
logic [3:0] l2_req_1_3;
logic [3:0] l2_grant_1_3;
logic       l2_all_last_1_3;
logic       l2_same_1_3;
//logic [1:0] l2_all_last_1_3_r;
rule_s_t l3_in_data_2_0;
rule_s_t l3_out_data_2_0;
logic l3_in_valid_2_0;
logic l3_in_ready_2_0;
logic l3_out_valid_2_0;
logic l3_out_ready_2_0;
logic l3_almost_full_2_0;
logic [31:0] l3_csr_readdata_2_0;
logic       l3_newdata_2_0;
logic [RID_WIDTH-1:0] l3_cache_2_0;
logic [3:0] l2_req_2_0;
logic [3:0] l2_grant_2_0;
logic       l2_all_last_2_0;
logic       l2_same_2_0;
//logic [1:0] l2_all_last_2_0_r;
rule_s_t l3_in_data_2_1;
rule_s_t l3_out_data_2_1;
logic l3_in_valid_2_1;
logic l3_in_ready_2_1;
logic l3_out_valid_2_1;
logic l3_out_ready_2_1;
logic l3_almost_full_2_1;
logic [31:0] l3_csr_readdata_2_1;
logic       l3_newdata_2_1;
logic [RID_WIDTH-1:0] l3_cache_2_1;
logic [3:0] l2_req_2_1;
logic [3:0] l2_grant_2_1;
logic       l2_all_last_2_1;
logic       l2_same_2_1;
//logic [1:0] l2_all_last_2_1_r;
rule_s_t l3_in_data_2_2;
rule_s_t l3_out_data_2_2;
logic l3_in_valid_2_2;
logic l3_in_ready_2_2;
logic l3_out_valid_2_2;
logic l3_out_ready_2_2;
logic l3_almost_full_2_2;
logic [31:0] l3_csr_readdata_2_2;
logic       l3_newdata_2_2;
logic [RID_WIDTH-1:0] l3_cache_2_2;
logic [3:0] l2_req_2_2;
logic [3:0] l2_grant_2_2;
logic       l2_all_last_2_2;
logic       l2_same_2_2;
//logic [1:0] l2_all_last_2_2_r;
rule_s_t l3_in_data_2_3;
rule_s_t l3_out_data_2_3;
logic l3_in_valid_2_3;
logic l3_in_ready_2_3;
logic l3_out_valid_2_3;
logic l3_out_ready_2_3;
logic l3_almost_full_2_3;
logic [31:0] l3_csr_readdata_2_3;
logic       l3_newdata_2_3;
logic [RID_WIDTH-1:0] l3_cache_2_3;
logic [3:0] l2_req_2_3;
logic [3:0] l2_grant_2_3;
logic       l2_all_last_2_3;
logic       l2_same_2_3;
//logic [1:0] l2_all_last_2_3_r;
rule_s_t l3_in_data_3_0;
rule_s_t l3_out_data_3_0;
logic l3_in_valid_3_0;
logic l3_in_ready_3_0;
logic l3_out_valid_3_0;
logic l3_out_ready_3_0;
logic l3_almost_full_3_0;
logic [31:0] l3_csr_readdata_3_0;
logic       l3_newdata_3_0;
logic [RID_WIDTH-1:0] l3_cache_3_0;
logic [3:0] l2_req_3_0;
logic [3:0] l2_grant_3_0;
logic       l2_all_last_3_0;
logic       l2_same_3_0;
//logic [1:0] l2_all_last_3_0_r;
rule_s_t l3_in_data_3_1;
rule_s_t l3_out_data_3_1;
logic l3_in_valid_3_1;
logic l3_in_ready_3_1;
logic l3_out_valid_3_1;
logic l3_out_ready_3_1;
logic l3_almost_full_3_1;
logic [31:0] l3_csr_readdata_3_1;
logic       l3_newdata_3_1;
logic [RID_WIDTH-1:0] l3_cache_3_1;
logic [3:0] l2_req_3_1;
logic [3:0] l2_grant_3_1;
logic       l2_all_last_3_1;
logic       l2_same_3_1;
//logic [1:0] l2_all_last_3_1_r;
rule_s_t l3_in_data_3_2;
rule_s_t l3_out_data_3_2;
logic l3_in_valid_3_2;
logic l3_in_ready_3_2;
logic l3_out_valid_3_2;
logic l3_out_ready_3_2;
logic l3_almost_full_3_2;
logic [31:0] l3_csr_readdata_3_2;
logic       l3_newdata_3_2;
logic [RID_WIDTH-1:0] l3_cache_3_2;
logic [3:0] l2_req_3_2;
logic [3:0] l2_grant_3_2;
logic       l2_all_last_3_2;
logic       l2_same_3_2;
//logic [1:0] l2_all_last_3_2_r;
rule_s_t l3_in_data_3_3;
rule_s_t l3_out_data_3_3;
logic l3_in_valid_3_3;
logic l3_in_ready_3_3;
logic l3_out_valid_3_3;
logic l3_out_ready_3_3;
logic l3_almost_full_3_3;
logic [31:0] l3_csr_readdata_3_3;
logic       l3_newdata_3_3;
logic [RID_WIDTH-1:0] l3_cache_3_3;
logic [3:0] l2_req_3_3;
logic [3:0] l2_grant_3_3;
logic       l2_all_last_3_3;
logic       l2_same_3_3;
//logic [1:0] l2_all_last_3_3_r;
rule_s_t l3_in_data_4_0;
rule_s_t l3_out_data_4_0;
logic l3_in_valid_4_0;
logic l3_in_ready_4_0;
logic l3_out_valid_4_0;
logic l3_out_ready_4_0;
logic l3_almost_full_4_0;
logic [31:0] l3_csr_readdata_4_0;
logic       l3_newdata_4_0;
logic [RID_WIDTH-1:0] l3_cache_4_0;
logic [3:0] l2_req_4_0;
logic [3:0] l2_grant_4_0;
logic       l2_all_last_4_0;
logic       l2_same_4_0;
//logic [1:0] l2_all_last_4_0_r;
rule_s_t l3_in_data_4_1;
rule_s_t l3_out_data_4_1;
logic l3_in_valid_4_1;
logic l3_in_ready_4_1;
logic l3_out_valid_4_1;
logic l3_out_ready_4_1;
logic l3_almost_full_4_1;
logic [31:0] l3_csr_readdata_4_1;
logic       l3_newdata_4_1;
logic [RID_WIDTH-1:0] l3_cache_4_1;
logic [3:0] l2_req_4_1;
logic [3:0] l2_grant_4_1;
logic       l2_all_last_4_1;
logic       l2_same_4_1;
//logic [1:0] l2_all_last_4_1_r;
rule_s_t l3_in_data_4_2;
rule_s_t l3_out_data_4_2;
logic l3_in_valid_4_2;
logic l3_in_ready_4_2;
logic l3_out_valid_4_2;
logic l3_out_ready_4_2;
logic l3_almost_full_4_2;
logic [31:0] l3_csr_readdata_4_2;
logic       l3_newdata_4_2;
logic [RID_WIDTH-1:0] l3_cache_4_2;
logic [3:0] l2_req_4_2;
logic [3:0] l2_grant_4_2;
logic       l2_all_last_4_2;
logic       l2_same_4_2;
//logic [1:0] l2_all_last_4_2_r;
rule_s_t l3_in_data_4_3;
rule_s_t l3_out_data_4_3;
logic l3_in_valid_4_3;
logic l3_in_ready_4_3;
logic l3_out_valid_4_3;
logic l3_out_ready_4_3;
logic l3_almost_full_4_3;
logic [31:0] l3_csr_readdata_4_3;
logic       l3_newdata_4_3;
logic [RID_WIDTH-1:0] l3_cache_4_3;
logic [3:0] l2_req_4_3;
logic [3:0] l2_grant_4_3;
logic       l2_all_last_4_3;
logic       l2_same_4_3;
//logic [1:0] l2_all_last_4_3_r;
rule_s_t l3_in_data_5_0;
rule_s_t l3_out_data_5_0;
logic l3_in_valid_5_0;
logic l3_in_ready_5_0;
logic l3_out_valid_5_0;
logic l3_out_ready_5_0;
logic l3_almost_full_5_0;
logic [31:0] l3_csr_readdata_5_0;
logic       l3_newdata_5_0;
logic [RID_WIDTH-1:0] l3_cache_5_0;
logic [3:0] l2_req_5_0;
logic [3:0] l2_grant_5_0;
logic       l2_all_last_5_0;
logic       l2_same_5_0;
//logic [1:0] l2_all_last_5_0_r;
rule_s_t l3_in_data_5_1;
rule_s_t l3_out_data_5_1;
logic l3_in_valid_5_1;
logic l3_in_ready_5_1;
logic l3_out_valid_5_1;
logic l3_out_ready_5_1;
logic l3_almost_full_5_1;
logic [31:0] l3_csr_readdata_5_1;
logic       l3_newdata_5_1;
logic [RID_WIDTH-1:0] l3_cache_5_1;
logic [3:0] l2_req_5_1;
logic [3:0] l2_grant_5_1;
logic       l2_all_last_5_1;
logic       l2_same_5_1;
//logic [1:0] l2_all_last_5_1_r;
rule_s_t l3_in_data_5_2;
rule_s_t l3_out_data_5_2;
logic l3_in_valid_5_2;
logic l3_in_ready_5_2;
logic l3_out_valid_5_2;
logic l3_out_ready_5_2;
logic l3_almost_full_5_2;
logic [31:0] l3_csr_readdata_5_2;
logic       l3_newdata_5_2;
logic [RID_WIDTH-1:0] l3_cache_5_2;
logic [3:0] l2_req_5_2;
logic [3:0] l2_grant_5_2;
logic       l2_all_last_5_2;
logic       l2_same_5_2;
//logic [1:0] l2_all_last_5_2_r;
rule_s_t l3_in_data_5_3;
rule_s_t l3_out_data_5_3;
logic l3_in_valid_5_3;
logic l3_in_ready_5_3;
logic l3_out_valid_5_3;
logic l3_out_ready_5_3;
logic l3_almost_full_5_3;
logic [31:0] l3_csr_readdata_5_3;
logic       l3_newdata_5_3;
logic [RID_WIDTH-1:0] l3_cache_5_3;
logic [3:0] l2_req_5_3;
logic [3:0] l2_grant_5_3;
logic       l2_all_last_5_3;
logic       l2_same_5_3;
//logic [1:0] l2_all_last_5_3_r;
rule_s_t l3_in_data_6_0;
rule_s_t l3_out_data_6_0;
logic l3_in_valid_6_0;
logic l3_in_ready_6_0;
logic l3_out_valid_6_0;
logic l3_out_ready_6_0;
logic l3_almost_full_6_0;
logic [31:0] l3_csr_readdata_6_0;
logic       l3_newdata_6_0;
logic [RID_WIDTH-1:0] l3_cache_6_0;
logic [3:0] l2_req_6_0;
logic [3:0] l2_grant_6_0;
logic       l2_all_last_6_0;
logic       l2_same_6_0;
//logic [1:0] l2_all_last_6_0_r;
rule_s_t l3_in_data_6_1;
rule_s_t l3_out_data_6_1;
logic l3_in_valid_6_1;
logic l3_in_ready_6_1;
logic l3_out_valid_6_1;
logic l3_out_ready_6_1;
logic l3_almost_full_6_1;
logic [31:0] l3_csr_readdata_6_1;
logic       l3_newdata_6_1;
logic [RID_WIDTH-1:0] l3_cache_6_1;
logic [3:0] l2_req_6_1;
logic [3:0] l2_grant_6_1;
logic       l2_all_last_6_1;
logic       l2_same_6_1;
//logic [1:0] l2_all_last_6_1_r;
rule_s_t l3_in_data_6_2;
rule_s_t l3_out_data_6_2;
logic l3_in_valid_6_2;
logic l3_in_ready_6_2;
logic l3_out_valid_6_2;
logic l3_out_ready_6_2;
logic l3_almost_full_6_2;
logic [31:0] l3_csr_readdata_6_2;
logic       l3_newdata_6_2;
logic [RID_WIDTH-1:0] l3_cache_6_2;
logic [3:0] l2_req_6_2;
logic [3:0] l2_grant_6_2;
logic       l2_all_last_6_2;
logic       l2_same_6_2;
//logic [1:0] l2_all_last_6_2_r;
rule_s_t l3_in_data_6_3;
rule_s_t l3_out_data_6_3;
logic l3_in_valid_6_3;
logic l3_in_ready_6_3;
logic l3_out_valid_6_3;
logic l3_out_ready_6_3;
logic l3_almost_full_6_3;
logic [31:0] l3_csr_readdata_6_3;
logic       l3_newdata_6_3;
logic [RID_WIDTH-1:0] l3_cache_6_3;
logic [3:0] l2_req_6_3;
logic [3:0] l2_grant_6_3;
logic       l2_all_last_6_3;
logic       l2_same_6_3;
//logic [1:0] l2_all_last_6_3_r;
rule_s_t l3_in_data_7_0;
rule_s_t l3_out_data_7_0;
logic l3_in_valid_7_0;
logic l3_in_ready_7_0;
logic l3_out_valid_7_0;
logic l3_out_ready_7_0;
logic l3_almost_full_7_0;
logic [31:0] l3_csr_readdata_7_0;
logic       l3_newdata_7_0;
logic [RID_WIDTH-1:0] l3_cache_7_0;
logic [3:0] l2_req_7_0;
logic [3:0] l2_grant_7_0;
logic       l2_all_last_7_0;
logic       l2_same_7_0;
//logic [1:0] l2_all_last_7_0_r;
rule_s_t l3_in_data_7_1;
rule_s_t l3_out_data_7_1;
logic l3_in_valid_7_1;
logic l3_in_ready_7_1;
logic l3_out_valid_7_1;
logic l3_out_ready_7_1;
logic l3_almost_full_7_1;
logic [31:0] l3_csr_readdata_7_1;
logic       l3_newdata_7_1;
logic [RID_WIDTH-1:0] l3_cache_7_1;
logic [3:0] l2_req_7_1;
logic [3:0] l2_grant_7_1;
logic       l2_all_last_7_1;
logic       l2_same_7_1;
//logic [1:0] l2_all_last_7_1_r;
rule_s_t l3_in_data_7_2;
rule_s_t l3_out_data_7_2;
logic l3_in_valid_7_2;
logic l3_in_ready_7_2;
logic l3_out_valid_7_2;
logic l3_out_ready_7_2;
logic l3_almost_full_7_2;
logic [31:0] l3_csr_readdata_7_2;
logic       l3_newdata_7_2;
logic [RID_WIDTH-1:0] l3_cache_7_2;
logic [3:0] l2_req_7_2;
logic [3:0] l2_grant_7_2;
logic       l2_all_last_7_2;
logic       l2_same_7_2;
//logic [1:0] l2_all_last_7_2_r;
rule_s_t l3_in_data_7_3;
rule_s_t l3_out_data_7_3;
logic l3_in_valid_7_3;
logic l3_in_ready_7_3;
logic l3_out_valid_7_3;
logic l3_out_ready_7_3;
logic l3_almost_full_7_3;
logic [31:0] l3_csr_readdata_7_3;
logic       l3_newdata_7_3;
logic [RID_WIDTH-1:0] l3_cache_7_3;
logic [3:0] l2_req_7_3;
logic [3:0] l2_grant_7_3;
logic       l2_all_last_7_3;
logic       l2_same_7_3;
//logic [1:0] l2_all_last_7_3_r;

//L3 ARB and OUT FIFO
rule_s_t l4_in_data_0;
rule_s_t l4_out_data_0;
logic l4_in_valid_0;
logic l4_in_ready_0;
logic l4_out_valid_0;
logic l4_out_ready_0;
logic l4_almost_full_0;
logic [31:0] l4_csr_readdata_0;
logic [RID_WIDTH-1:0] l4_cache_0;
logic [3:0] l3_req_0;
logic [3:0] l3_grant_0;
logic       l3_all_last_0;
logic       l3_same_0;
rule_s_t l4_in_data_1;
rule_s_t l4_out_data_1;
logic l4_in_valid_1;
logic l4_in_ready_1;
logic l4_out_valid_1;
logic l4_out_ready_1;
logic l4_almost_full_1;
logic [31:0] l4_csr_readdata_1;
logic [RID_WIDTH-1:0] l4_cache_1;
logic [3:0] l3_req_1;
logic [3:0] l3_grant_1;
logic       l3_all_last_1;
logic       l3_same_1;
rule_s_t l4_in_data_2;
rule_s_t l4_out_data_2;
logic l4_in_valid_2;
logic l4_in_ready_2;
logic l4_out_valid_2;
logic l4_out_ready_2;
logic l4_almost_full_2;
logic [31:0] l4_csr_readdata_2;
logic [RID_WIDTH-1:0] l4_cache_2;
logic [3:0] l3_req_2;
logic [3:0] l3_grant_2;
logic       l3_all_last_2;
logic       l3_same_2;
rule_s_t l4_in_data_3;
rule_s_t l4_out_data_3;
logic l4_in_valid_3;
logic l4_in_ready_3;
logic l4_out_valid_3;
logic l4_out_ready_3;
logic l4_almost_full_3;
logic [31:0] l4_csr_readdata_3;
logic [RID_WIDTH-1:0] l4_cache_3;
logic [3:0] l3_req_3;
logic [3:0] l3_grant_3;
logic       l3_all_last_3;
logic       l3_same_3;
rule_s_t l4_in_data_4;
rule_s_t l4_out_data_4;
logic l4_in_valid_4;
logic l4_in_ready_4;
logic l4_out_valid_4;
logic l4_out_ready_4;
logic l4_almost_full_4;
logic [31:0] l4_csr_readdata_4;
logic [RID_WIDTH-1:0] l4_cache_4;
logic [3:0] l3_req_4;
logic [3:0] l3_grant_4;
logic       l3_all_last_4;
logic       l3_same_4;
rule_s_t l4_in_data_5;
rule_s_t l4_out_data_5;
logic l4_in_valid_5;
logic l4_in_ready_5;
logic l4_out_valid_5;
logic l4_out_ready_5;
logic l4_almost_full_5;
logic [31:0] l4_csr_readdata_5;
logic [RID_WIDTH-1:0] l4_cache_5;
logic [3:0] l3_req_5;
logic [3:0] l3_grant_5;
logic       l3_all_last_5;
logic       l3_same_5;
rule_s_t l4_in_data_6;
rule_s_t l4_out_data_6;
logic l4_in_valid_6;
logic l4_in_ready_6;
logic l4_out_valid_6;
logic l4_out_ready_6;
logic l4_almost_full_6;
logic [31:0] l4_csr_readdata_6;
logic [RID_WIDTH-1:0] l4_cache_6;
logic [3:0] l3_req_6;
logic [3:0] l3_grant_6;
logic       l3_all_last_6;
logic       l3_same_6;
rule_s_t l4_in_data_7;
rule_s_t l4_out_data_7;
logic l4_in_valid_7;
logic l4_in_ready_7;
logic l4_out_valid_7;
logic l4_out_ready_7;
logic l4_almost_full_7;
logic [31:0] l4_csr_readdata_7;
logic [RID_WIDTH-1:0] l4_cache_7;
logic [3:0] l3_req_7;
logic [3:0] l3_grant_7;
logic       l3_all_last_7;
logic       l3_same_7;

logic all_last;
logic all_last_r1;
logic all_last_r2;
logic all_last_r3;

logic [RID_WIDTH-1:0] ht_addr_0;//need to change
logic [RID_WIDTH-1:0] ht_q_0;
logic ht_rd_0;
logic ht_rd_0_r1;
logic ht_rd_0_r2;
logic ht_rd_0_valid;
logic [RID_WIDTH-1:0] ht_data_0;
logic [2:0] bucket_0;
logic [2:0] bucket_0_r1;
logic [2:0] bucket_0_r2;
logic [RID_WIDTH-1:0] ht_addr_1;//need to change
logic [RID_WIDTH-1:0] ht_q_1;
logic ht_rd_1;
logic ht_rd_1_r1;
logic ht_rd_1_r2;
logic ht_rd_1_valid;
logic [RID_WIDTH-1:0] ht_data_1;
logic [2:0] bucket_1;
logic [2:0] bucket_1_r1;
logic [2:0] bucket_1_r2;
logic [RID_WIDTH-1:0] ht_addr_2;//need to change
logic [RID_WIDTH-1:0] ht_q_2;
logic ht_rd_2;
logic ht_rd_2_r1;
logic ht_rd_2_r2;
logic ht_rd_2_valid;
logic [RID_WIDTH-1:0] ht_data_2;
logic [2:0] bucket_2;
logic [2:0] bucket_2_r1;
logic [2:0] bucket_2_r2;
logic [RID_WIDTH-1:0] ht_addr_3;//need to change
logic [RID_WIDTH-1:0] ht_q_3;
logic ht_rd_3;
logic ht_rd_3_r1;
logic ht_rd_3_r2;
logic ht_rd_3_valid;
logic [RID_WIDTH-1:0] ht_data_3;
logic [2:0] bucket_3;
logic [2:0] bucket_3_r1;
logic [2:0] bucket_3_r2;
logic [RID_WIDTH-1:0] ht_addr_4;//need to change
logic [RID_WIDTH-1:0] ht_q_4;
logic ht_rd_4;
logic ht_rd_4_r1;
logic ht_rd_4_r2;
logic ht_rd_4_valid;
logic [RID_WIDTH-1:0] ht_data_4;
logic [2:0] bucket_4;
logic [2:0] bucket_4_r1;
logic [2:0] bucket_4_r2;
logic [RID_WIDTH-1:0] ht_addr_5;//need to change
logic [RID_WIDTH-1:0] ht_q_5;
logic ht_rd_5;
logic ht_rd_5_r1;
logic ht_rd_5_r2;
logic ht_rd_5_valid;
logic [RID_WIDTH-1:0] ht_data_5;
logic [2:0] bucket_5;
logic [2:0] bucket_5_r1;
logic [2:0] bucket_5_r2;
logic [RID_WIDTH-1:0] ht_addr_6;//need to change
logic [RID_WIDTH-1:0] ht_q_6;
logic ht_rd_6;
logic ht_rd_6_r1;
logic ht_rd_6_r2;
logic ht_rd_6_valid;
logic [RID_WIDTH-1:0] ht_data_6;
logic [2:0] bucket_6;
logic [2:0] bucket_6_r1;
logic [2:0] bucket_6_r2;
logic [RID_WIDTH-1:0] ht_addr_7;//need to change
logic [RID_WIDTH-1:0] ht_q_7;
logic ht_rd_7;
logic ht_rd_7_r1;
logic ht_rd_7_r2;
logic ht_rd_7_valid;
logic [RID_WIDTH-1:0] ht_data_7;
logic [2:0] bucket_7;
logic [2:0] bucket_7_r1;
logic [2:0] bucket_7_r2;

//L1 
always @(posedge clk)begin
    din_csr_readdata_0_0_r1 <= din_csr_readdata_0_0;
    din_csr_readdata_0_0_r2 <= din_csr_readdata_0_0_r1;
    din_csr_readdata_0_1_r1 <= din_csr_readdata_0_1;
    din_csr_readdata_0_1_r2 <= din_csr_readdata_0_1_r1;
    din_csr_readdata_0_2_r1 <= din_csr_readdata_0_2;
    din_csr_readdata_0_2_r2 <= din_csr_readdata_0_2_r1;
    din_csr_readdata_0_3_r1 <= din_csr_readdata_0_3;
    din_csr_readdata_0_3_r2 <= din_csr_readdata_0_3_r1;
    din_csr_readdata_0_4_r1 <= din_csr_readdata_0_4;
    din_csr_readdata_0_4_r2 <= din_csr_readdata_0_4_r1;
    din_csr_readdata_0_5_r1 <= din_csr_readdata_0_5;
    din_csr_readdata_0_5_r2 <= din_csr_readdata_0_5_r1;
    din_csr_readdata_0_6_r1 <= din_csr_readdata_0_6;
    din_csr_readdata_0_6_r2 <= din_csr_readdata_0_6_r1;
    din_csr_readdata_0_7_r1 <= din_csr_readdata_0_7;
    din_csr_readdata_0_7_r2 <= din_csr_readdata_0_7_r1;
    din_csr_readdata_1_0_r1 <= din_csr_readdata_1_0;
    din_csr_readdata_1_0_r2 <= din_csr_readdata_1_0_r1;
    din_csr_readdata_1_1_r1 <= din_csr_readdata_1_1;
    din_csr_readdata_1_1_r2 <= din_csr_readdata_1_1_r1;
    din_csr_readdata_1_2_r1 <= din_csr_readdata_1_2;
    din_csr_readdata_1_2_r2 <= din_csr_readdata_1_2_r1;
    din_csr_readdata_1_3_r1 <= din_csr_readdata_1_3;
    din_csr_readdata_1_3_r2 <= din_csr_readdata_1_3_r1;
    din_csr_readdata_1_4_r1 <= din_csr_readdata_1_4;
    din_csr_readdata_1_4_r2 <= din_csr_readdata_1_4_r1;
    din_csr_readdata_1_5_r1 <= din_csr_readdata_1_5;
    din_csr_readdata_1_5_r2 <= din_csr_readdata_1_5_r1;
    din_csr_readdata_1_6_r1 <= din_csr_readdata_1_6;
    din_csr_readdata_1_6_r2 <= din_csr_readdata_1_6_r1;
    din_csr_readdata_1_7_r1 <= din_csr_readdata_1_7;
    din_csr_readdata_1_7_r2 <= din_csr_readdata_1_7_r1;
    din_csr_readdata_2_0_r1 <= din_csr_readdata_2_0;
    din_csr_readdata_2_0_r2 <= din_csr_readdata_2_0_r1;
    din_csr_readdata_2_1_r1 <= din_csr_readdata_2_1;
    din_csr_readdata_2_1_r2 <= din_csr_readdata_2_1_r1;
    din_csr_readdata_2_2_r1 <= din_csr_readdata_2_2;
    din_csr_readdata_2_2_r2 <= din_csr_readdata_2_2_r1;
    din_csr_readdata_2_3_r1 <= din_csr_readdata_2_3;
    din_csr_readdata_2_3_r2 <= din_csr_readdata_2_3_r1;
    din_csr_readdata_2_4_r1 <= din_csr_readdata_2_4;
    din_csr_readdata_2_4_r2 <= din_csr_readdata_2_4_r1;
    din_csr_readdata_2_5_r1 <= din_csr_readdata_2_5;
    din_csr_readdata_2_5_r2 <= din_csr_readdata_2_5_r1;
    din_csr_readdata_2_6_r1 <= din_csr_readdata_2_6;
    din_csr_readdata_2_6_r2 <= din_csr_readdata_2_6_r1;
    din_csr_readdata_2_7_r1 <= din_csr_readdata_2_7;
    din_csr_readdata_2_7_r2 <= din_csr_readdata_2_7_r1;
    din_csr_readdata_3_0_r1 <= din_csr_readdata_3_0;
    din_csr_readdata_3_0_r2 <= din_csr_readdata_3_0_r1;
    din_csr_readdata_3_1_r1 <= din_csr_readdata_3_1;
    din_csr_readdata_3_1_r2 <= din_csr_readdata_3_1_r1;
    din_csr_readdata_3_2_r1 <= din_csr_readdata_3_2;
    din_csr_readdata_3_2_r2 <= din_csr_readdata_3_2_r1;
    din_csr_readdata_3_3_r1 <= din_csr_readdata_3_3;
    din_csr_readdata_3_3_r2 <= din_csr_readdata_3_3_r1;
    din_csr_readdata_3_4_r1 <= din_csr_readdata_3_4;
    din_csr_readdata_3_4_r2 <= din_csr_readdata_3_4_r1;
    din_csr_readdata_3_5_r1 <= din_csr_readdata_3_5;
    din_csr_readdata_3_5_r2 <= din_csr_readdata_3_5_r1;
    din_csr_readdata_3_6_r1 <= din_csr_readdata_3_6;
    din_csr_readdata_3_6_r2 <= din_csr_readdata_3_6_r1;
    din_csr_readdata_3_7_r1 <= din_csr_readdata_3_7;
    din_csr_readdata_3_7_r2 <= din_csr_readdata_3_7_r1;
    din_csr_readdata_4_0_r1 <= din_csr_readdata_4_0;
    din_csr_readdata_4_0_r2 <= din_csr_readdata_4_0_r1;
    din_csr_readdata_4_1_r1 <= din_csr_readdata_4_1;
    din_csr_readdata_4_1_r2 <= din_csr_readdata_4_1_r1;
    din_csr_readdata_4_2_r1 <= din_csr_readdata_4_2;
    din_csr_readdata_4_2_r2 <= din_csr_readdata_4_2_r1;
    din_csr_readdata_4_3_r1 <= din_csr_readdata_4_3;
    din_csr_readdata_4_3_r2 <= din_csr_readdata_4_3_r1;
    din_csr_readdata_4_4_r1 <= din_csr_readdata_4_4;
    din_csr_readdata_4_4_r2 <= din_csr_readdata_4_4_r1;
    din_csr_readdata_4_5_r1 <= din_csr_readdata_4_5;
    din_csr_readdata_4_5_r2 <= din_csr_readdata_4_5_r1;
    din_csr_readdata_4_6_r1 <= din_csr_readdata_4_6;
    din_csr_readdata_4_6_r2 <= din_csr_readdata_4_6_r1;
    din_csr_readdata_4_7_r1 <= din_csr_readdata_4_7;
    din_csr_readdata_4_7_r2 <= din_csr_readdata_4_7_r1;
    din_csr_readdata_5_0_r1 <= din_csr_readdata_5_0;
    din_csr_readdata_5_0_r2 <= din_csr_readdata_5_0_r1;
    din_csr_readdata_5_1_r1 <= din_csr_readdata_5_1;
    din_csr_readdata_5_1_r2 <= din_csr_readdata_5_1_r1;
    din_csr_readdata_5_2_r1 <= din_csr_readdata_5_2;
    din_csr_readdata_5_2_r2 <= din_csr_readdata_5_2_r1;
    din_csr_readdata_5_3_r1 <= din_csr_readdata_5_3;
    din_csr_readdata_5_3_r2 <= din_csr_readdata_5_3_r1;
    din_csr_readdata_5_4_r1 <= din_csr_readdata_5_4;
    din_csr_readdata_5_4_r2 <= din_csr_readdata_5_4_r1;
    din_csr_readdata_5_5_r1 <= din_csr_readdata_5_5;
    din_csr_readdata_5_5_r2 <= din_csr_readdata_5_5_r1;
    din_csr_readdata_5_6_r1 <= din_csr_readdata_5_6;
    din_csr_readdata_5_6_r2 <= din_csr_readdata_5_6_r1;
    din_csr_readdata_5_7_r1 <= din_csr_readdata_5_7;
    din_csr_readdata_5_7_r2 <= din_csr_readdata_5_7_r1;
    din_csr_readdata_6_0_r1 <= din_csr_readdata_6_0;
    din_csr_readdata_6_0_r2 <= din_csr_readdata_6_0_r1;
    din_csr_readdata_6_1_r1 <= din_csr_readdata_6_1;
    din_csr_readdata_6_1_r2 <= din_csr_readdata_6_1_r1;
    din_csr_readdata_6_2_r1 <= din_csr_readdata_6_2;
    din_csr_readdata_6_2_r2 <= din_csr_readdata_6_2_r1;
    din_csr_readdata_6_3_r1 <= din_csr_readdata_6_3;
    din_csr_readdata_6_3_r2 <= din_csr_readdata_6_3_r1;
    din_csr_readdata_6_4_r1 <= din_csr_readdata_6_4;
    din_csr_readdata_6_4_r2 <= din_csr_readdata_6_4_r1;
    din_csr_readdata_6_5_r1 <= din_csr_readdata_6_5;
    din_csr_readdata_6_5_r2 <= din_csr_readdata_6_5_r1;
    din_csr_readdata_6_6_r1 <= din_csr_readdata_6_6;
    din_csr_readdata_6_6_r2 <= din_csr_readdata_6_6_r1;
    din_csr_readdata_6_7_r1 <= din_csr_readdata_6_7;
    din_csr_readdata_6_7_r2 <= din_csr_readdata_6_7_r1;
    din_csr_readdata_7_0_r1 <= din_csr_readdata_7_0;
    din_csr_readdata_7_0_r2 <= din_csr_readdata_7_0_r1;
    din_csr_readdata_7_1_r1 <= din_csr_readdata_7_1;
    din_csr_readdata_7_1_r2 <= din_csr_readdata_7_1_r1;
    din_csr_readdata_7_2_r1 <= din_csr_readdata_7_2;
    din_csr_readdata_7_2_r2 <= din_csr_readdata_7_2_r1;
    din_csr_readdata_7_3_r1 <= din_csr_readdata_7_3;
    din_csr_readdata_7_3_r2 <= din_csr_readdata_7_3_r1;
    din_csr_readdata_7_4_r1 <= din_csr_readdata_7_4;
    din_csr_readdata_7_4_r2 <= din_csr_readdata_7_4_r1;
    din_csr_readdata_7_5_r1 <= din_csr_readdata_7_5;
    din_csr_readdata_7_5_r2 <= din_csr_readdata_7_5_r1;
    din_csr_readdata_7_6_r1 <= din_csr_readdata_7_6;
    din_csr_readdata_7_6_r2 <= din_csr_readdata_7_6_r1;
    din_csr_readdata_7_7_r1 <= din_csr_readdata_7_7;
    din_csr_readdata_7_7_r2 <= din_csr_readdata_7_7_r1;
end

//L1 FIFO output
assign l1_all_last_0_0 = (l1_data_0_0.last & l1_valid_0_0) & (l1_data_0_1.last & l1_valid_0_1) & !l2_almost_full_0_0;
assign l1_same_0_0 = l1_newdata_0_0 & l1_newdata_0_1 & (l1_data_0_0.data==l1_data_0_1.data) & !l2_almost_full_0_0;
assign l1_newdata_0_0 = l1_valid_0_0 & (l1_data_0_0.data != l1_cache_0_0) & !l1_data_0_0.last;

assign l1_newdata_0_1 = l1_valid_0_1 & (l1_data_0_1.data != l1_cache_0_1) & !l1_data_0_1.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_0[0] = l1_newdata_0_0 & !l2_almost_full_0_0;
    l1_ready_0_0 = l1_grant_0_0[0];       
    l1_req_0_0[1] = l1_newdata_0_1 & !l2_almost_full_0_0;
    l1_ready_0_1 = l1_grant_0_0[1];       
    //sync case
    if(l1_all_last_0_0) begin
        l1_req_0_0 = 0;
        l1_ready_0_0 = 1;
        l1_ready_0_1 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_0)begin
        l1_req_0_0[0] = 1;
        l1_req_0_0[0] = 0;
        l1_ready_0_1 = 1;
    end else begin
        if(l1_valid_0_0 & (l1_data_0_0.data == l1_cache_0_0) & !l1_data_0_0.last)begin
            l1_ready_0_0 = 1;
        end
        if(l1_valid_0_1 & (l1_data_0_1.data == l1_cache_0_1) & !l1_data_0_1.last)begin
            l1_ready_0_1 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_0 <= 0;
        l1_cache_0_1 <= 0;
    end else begin
        if(l1_all_last_0_0)begin
            l1_cache_0_0 <= 0;
            l1_cache_0_1 <= 0;
        end else begin
            if(l1_valid_0_0 & l1_ready_0_0)begin
                l1_cache_0_0 <= l1_data_0_0.data;
            end
            if(l1_valid_0_1 & l1_ready_0_1)begin
                l1_cache_0_1 <= l1_data_0_1.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_0 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_0) begin
            l2_in_valid_0_0 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_0 <= |l1_grant_0_0;
        end
    end
    //sync case
    if(l1_all_last_0_0) begin
        l2_in_data_0_0.last <= 1;
        l2_in_data_0_0.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_0)
            2'b01: l2_in_data_0_0 <= l1_data_0_0;
            2'b10: l2_in_data_0_0 <= l1_data_0_1;
            default: l2_in_data_0_0 <= 0;
        endcase
    end   
end

assign l1_all_last_0_1 = (l1_data_0_2.last & l1_valid_0_2) & (l1_data_0_3.last & l1_valid_0_3) & !l2_almost_full_0_1;
assign l1_same_0_1 = l1_newdata_0_2 & l1_newdata_0_3 & (l1_data_0_2.data==l1_data_0_3.data) & !l2_almost_full_0_1;
assign l1_newdata_0_2 = l1_valid_0_2 & (l1_data_0_2.data != l1_cache_0_2) & !l1_data_0_2.last;

assign l1_newdata_0_3 = l1_valid_0_3 & (l1_data_0_3.data != l1_cache_0_3) & !l1_data_0_3.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_1[0] = l1_newdata_0_2 & !l2_almost_full_0_1;
    l1_ready_0_2 = l1_grant_0_1[0];       
    l1_req_0_1[1] = l1_newdata_0_3 & !l2_almost_full_0_1;
    l1_ready_0_3 = l1_grant_0_1[1];       
    //sync case
    if(l1_all_last_0_1) begin
        l1_req_0_1 = 0;
        l1_ready_0_2 = 1;
        l1_ready_0_3 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_1)begin
        l1_req_0_1[0] = 1;
        l1_req_0_1[0] = 0;
        l1_ready_0_3 = 1;
    end else begin
        if(l1_valid_0_2 & (l1_data_0_2.data == l1_cache_0_2) & !l1_data_0_2.last)begin
            l1_ready_0_2 = 1;
        end
        if(l1_valid_0_3 & (l1_data_0_3.data == l1_cache_0_3) & !l1_data_0_3.last)begin
            l1_ready_0_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_2 <= 0;
        l1_cache_0_3 <= 0;
    end else begin
        if(l1_all_last_0_1)begin
            l1_cache_0_2 <= 0;
            l1_cache_0_3 <= 0;
        end else begin
            if(l1_valid_0_2 & l1_ready_0_2)begin
                l1_cache_0_2 <= l1_data_0_2.data;
            end
            if(l1_valid_0_3 & l1_ready_0_3)begin
                l1_cache_0_3 <= l1_data_0_3.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_1 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_1) begin
            l2_in_valid_0_1 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_1 <= |l1_grant_0_1;
        end
    end
    //sync case
    if(l1_all_last_0_1) begin
        l2_in_data_0_1.last <= 1;
        l2_in_data_0_1.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_1)
            2'b01: l2_in_data_0_1 <= l1_data_0_2;
            2'b10: l2_in_data_0_1 <= l1_data_0_3;
            default: l2_in_data_0_1 <= 0;
        endcase
    end   
end

assign l1_all_last_0_2 = (l1_data_0_4.last & l1_valid_0_4) & (l1_data_0_5.last & l1_valid_0_5) & !l2_almost_full_0_2;
assign l1_same_0_2 = l1_newdata_0_4 & l1_newdata_0_5 & (l1_data_0_4.data==l1_data_0_5.data) & !l2_almost_full_0_2;
assign l1_newdata_0_4 = l1_valid_0_4 & (l1_data_0_4.data != l1_cache_0_4) & !l1_data_0_4.last;

assign l1_newdata_0_5 = l1_valid_0_5 & (l1_data_0_5.data != l1_cache_0_5) & !l1_data_0_5.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_2[0] = l1_newdata_0_4 & !l2_almost_full_0_2;
    l1_ready_0_4 = l1_grant_0_2[0];       
    l1_req_0_2[1] = l1_newdata_0_5 & !l2_almost_full_0_2;
    l1_ready_0_5 = l1_grant_0_2[1];       
    //sync case
    if(l1_all_last_0_2) begin
        l1_req_0_2 = 0;
        l1_ready_0_4 = 1;
        l1_ready_0_5 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_2)begin
        l1_req_0_2[0] = 1;
        l1_req_0_2[0] = 0;
        l1_ready_0_5 = 1;
    end else begin
        if(l1_valid_0_4 & (l1_data_0_4.data == l1_cache_0_4) & !l1_data_0_4.last)begin
            l1_ready_0_4 = 1;
        end
        if(l1_valid_0_5 & (l1_data_0_5.data == l1_cache_0_5) & !l1_data_0_5.last)begin
            l1_ready_0_5 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_4 <= 0;
        l1_cache_0_5 <= 0;
    end else begin
        if(l1_all_last_0_2)begin
            l1_cache_0_4 <= 0;
            l1_cache_0_5 <= 0;
        end else begin
            if(l1_valid_0_4 & l1_ready_0_4)begin
                l1_cache_0_4 <= l1_data_0_4.data;
            end
            if(l1_valid_0_5 & l1_ready_0_5)begin
                l1_cache_0_5 <= l1_data_0_5.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_2 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_2) begin
            l2_in_valid_0_2 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_2 <= |l1_grant_0_2;
        end
    end
    //sync case
    if(l1_all_last_0_2) begin
        l2_in_data_0_2.last <= 1;
        l2_in_data_0_2.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_2)
            2'b01: l2_in_data_0_2 <= l1_data_0_4;
            2'b10: l2_in_data_0_2 <= l1_data_0_5;
            default: l2_in_data_0_2 <= 0;
        endcase
    end   
end

assign l1_all_last_0_3 = (l1_data_0_6.last & l1_valid_0_6) & (l1_data_0_7.last & l1_valid_0_7) & !l2_almost_full_0_3;
assign l1_same_0_3 = l1_newdata_0_6 & l1_newdata_0_7 & (l1_data_0_6.data==l1_data_0_7.data) & !l2_almost_full_0_3;
assign l1_newdata_0_6 = l1_valid_0_6 & (l1_data_0_6.data != l1_cache_0_6) & !l1_data_0_6.last;

assign l1_newdata_0_7 = l1_valid_0_7 & (l1_data_0_7.data != l1_cache_0_7) & !l1_data_0_7.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_3[0] = l1_newdata_0_6 & !l2_almost_full_0_3;
    l1_ready_0_6 = l1_grant_0_3[0];       
    l1_req_0_3[1] = l1_newdata_0_7 & !l2_almost_full_0_3;
    l1_ready_0_7 = l1_grant_0_3[1];       
    //sync case
    if(l1_all_last_0_3) begin
        l1_req_0_3 = 0;
        l1_ready_0_6 = 1;
        l1_ready_0_7 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_3)begin
        l1_req_0_3[0] = 1;
        l1_req_0_3[0] = 0;
        l1_ready_0_7 = 1;
    end else begin
        if(l1_valid_0_6 & (l1_data_0_6.data == l1_cache_0_6) & !l1_data_0_6.last)begin
            l1_ready_0_6 = 1;
        end
        if(l1_valid_0_7 & (l1_data_0_7.data == l1_cache_0_7) & !l1_data_0_7.last)begin
            l1_ready_0_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_6 <= 0;
        l1_cache_0_7 <= 0;
    end else begin
        if(l1_all_last_0_3)begin
            l1_cache_0_6 <= 0;
            l1_cache_0_7 <= 0;
        end else begin
            if(l1_valid_0_6 & l1_ready_0_6)begin
                l1_cache_0_6 <= l1_data_0_6.data;
            end
            if(l1_valid_0_7 & l1_ready_0_7)begin
                l1_cache_0_7 <= l1_data_0_7.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_3 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_3) begin
            l2_in_valid_0_3 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_3 <= |l1_grant_0_3;
        end
    end
    //sync case
    if(l1_all_last_0_3) begin
        l2_in_data_0_3.last <= 1;
        l2_in_data_0_3.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_3)
            2'b01: l2_in_data_0_3 <= l1_data_0_6;
            2'b10: l2_in_data_0_3 <= l1_data_0_7;
            default: l2_in_data_0_3 <= 0;
        endcase
    end   
end

assign l1_all_last_0_4 = (l1_data_0_8.last & l1_valid_0_8) & (l1_data_0_9.last & l1_valid_0_9) & !l2_almost_full_0_4;
assign l1_same_0_4 = l1_newdata_0_8 & l1_newdata_0_9 & (l1_data_0_8.data==l1_data_0_9.data) & !l2_almost_full_0_4;
assign l1_newdata_0_8 = l1_valid_0_8 & (l1_data_0_8.data != l1_cache_0_8) & !l1_data_0_8.last;

assign l1_newdata_0_9 = l1_valid_0_9 & (l1_data_0_9.data != l1_cache_0_9) & !l1_data_0_9.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_4[0] = l1_newdata_0_8 & !l2_almost_full_0_4;
    l1_ready_0_8 = l1_grant_0_4[0];       
    l1_req_0_4[1] = l1_newdata_0_9 & !l2_almost_full_0_4;
    l1_ready_0_9 = l1_grant_0_4[1];       
    //sync case
    if(l1_all_last_0_4) begin
        l1_req_0_4 = 0;
        l1_ready_0_8 = 1;
        l1_ready_0_9 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_4)begin
        l1_req_0_4[0] = 1;
        l1_req_0_4[0] = 0;
        l1_ready_0_9 = 1;
    end else begin
        if(l1_valid_0_8 & (l1_data_0_8.data == l1_cache_0_8) & !l1_data_0_8.last)begin
            l1_ready_0_8 = 1;
        end
        if(l1_valid_0_9 & (l1_data_0_9.data == l1_cache_0_9) & !l1_data_0_9.last)begin
            l1_ready_0_9 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_8 <= 0;
        l1_cache_0_9 <= 0;
    end else begin
        if(l1_all_last_0_4)begin
            l1_cache_0_8 <= 0;
            l1_cache_0_9 <= 0;
        end else begin
            if(l1_valid_0_8 & l1_ready_0_8)begin
                l1_cache_0_8 <= l1_data_0_8.data;
            end
            if(l1_valid_0_9 & l1_ready_0_9)begin
                l1_cache_0_9 <= l1_data_0_9.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_4 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_4) begin
            l2_in_valid_0_4 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_4 <= |l1_grant_0_4;
        end
    end
    //sync case
    if(l1_all_last_0_4) begin
        l2_in_data_0_4.last <= 1;
        l2_in_data_0_4.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_4)
            2'b01: l2_in_data_0_4 <= l1_data_0_8;
            2'b10: l2_in_data_0_4 <= l1_data_0_9;
            default: l2_in_data_0_4 <= 0;
        endcase
    end   
end

assign l1_all_last_0_5 = (l1_data_0_10.last & l1_valid_0_10) & (l1_data_0_11.last & l1_valid_0_11) & !l2_almost_full_0_5;
assign l1_same_0_5 = l1_newdata_0_10 & l1_newdata_0_11 & (l1_data_0_10.data==l1_data_0_11.data) & !l2_almost_full_0_5;
assign l1_newdata_0_10 = l1_valid_0_10 & (l1_data_0_10.data != l1_cache_0_10) & !l1_data_0_10.last;

assign l1_newdata_0_11 = l1_valid_0_11 & (l1_data_0_11.data != l1_cache_0_11) & !l1_data_0_11.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_5[0] = l1_newdata_0_10 & !l2_almost_full_0_5;
    l1_ready_0_10 = l1_grant_0_5[0];       
    l1_req_0_5[1] = l1_newdata_0_11 & !l2_almost_full_0_5;
    l1_ready_0_11 = l1_grant_0_5[1];       
    //sync case
    if(l1_all_last_0_5) begin
        l1_req_0_5 = 0;
        l1_ready_0_10 = 1;
        l1_ready_0_11 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_5)begin
        l1_req_0_5[0] = 1;
        l1_req_0_5[0] = 0;
        l1_ready_0_11 = 1;
    end else begin
        if(l1_valid_0_10 & (l1_data_0_10.data == l1_cache_0_10) & !l1_data_0_10.last)begin
            l1_ready_0_10 = 1;
        end
        if(l1_valid_0_11 & (l1_data_0_11.data == l1_cache_0_11) & !l1_data_0_11.last)begin
            l1_ready_0_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_10 <= 0;
        l1_cache_0_11 <= 0;
    end else begin
        if(l1_all_last_0_5)begin
            l1_cache_0_10 <= 0;
            l1_cache_0_11 <= 0;
        end else begin
            if(l1_valid_0_10 & l1_ready_0_10)begin
                l1_cache_0_10 <= l1_data_0_10.data;
            end
            if(l1_valid_0_11 & l1_ready_0_11)begin
                l1_cache_0_11 <= l1_data_0_11.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_5 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_5) begin
            l2_in_valid_0_5 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_5 <= |l1_grant_0_5;
        end
    end
    //sync case
    if(l1_all_last_0_5) begin
        l2_in_data_0_5.last <= 1;
        l2_in_data_0_5.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_5)
            2'b01: l2_in_data_0_5 <= l1_data_0_10;
            2'b10: l2_in_data_0_5 <= l1_data_0_11;
            default: l2_in_data_0_5 <= 0;
        endcase
    end   
end

assign l1_all_last_0_6 = (l1_data_0_12.last & l1_valid_0_12) & (l1_data_0_13.last & l1_valid_0_13) & !l2_almost_full_0_6;
assign l1_same_0_6 = l1_newdata_0_12 & l1_newdata_0_13 & (l1_data_0_12.data==l1_data_0_13.data) & !l2_almost_full_0_6;
assign l1_newdata_0_12 = l1_valid_0_12 & (l1_data_0_12.data != l1_cache_0_12) & !l1_data_0_12.last;

assign l1_newdata_0_13 = l1_valid_0_13 & (l1_data_0_13.data != l1_cache_0_13) & !l1_data_0_13.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_6[0] = l1_newdata_0_12 & !l2_almost_full_0_6;
    l1_ready_0_12 = l1_grant_0_6[0];       
    l1_req_0_6[1] = l1_newdata_0_13 & !l2_almost_full_0_6;
    l1_ready_0_13 = l1_grant_0_6[1];       
    //sync case
    if(l1_all_last_0_6) begin
        l1_req_0_6 = 0;
        l1_ready_0_12 = 1;
        l1_ready_0_13 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_6)begin
        l1_req_0_6[0] = 1;
        l1_req_0_6[0] = 0;
        l1_ready_0_13 = 1;
    end else begin
        if(l1_valid_0_12 & (l1_data_0_12.data == l1_cache_0_12) & !l1_data_0_12.last)begin
            l1_ready_0_12 = 1;
        end
        if(l1_valid_0_13 & (l1_data_0_13.data == l1_cache_0_13) & !l1_data_0_13.last)begin
            l1_ready_0_13 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_12 <= 0;
        l1_cache_0_13 <= 0;
    end else begin
        if(l1_all_last_0_6)begin
            l1_cache_0_12 <= 0;
            l1_cache_0_13 <= 0;
        end else begin
            if(l1_valid_0_12 & l1_ready_0_12)begin
                l1_cache_0_12 <= l1_data_0_12.data;
            end
            if(l1_valid_0_13 & l1_ready_0_13)begin
                l1_cache_0_13 <= l1_data_0_13.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_6 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_6) begin
            l2_in_valid_0_6 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_6 <= |l1_grant_0_6;
        end
    end
    //sync case
    if(l1_all_last_0_6) begin
        l2_in_data_0_6.last <= 1;
        l2_in_data_0_6.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_6)
            2'b01: l2_in_data_0_6 <= l1_data_0_12;
            2'b10: l2_in_data_0_6 <= l1_data_0_13;
            default: l2_in_data_0_6 <= 0;
        endcase
    end   
end

assign l1_all_last_0_7 = (l1_data_0_14.last & l1_valid_0_14) & (l1_data_0_15.last & l1_valid_0_15) & !l2_almost_full_0_7;
assign l1_same_0_7 = l1_newdata_0_14 & l1_newdata_0_15 & (l1_data_0_14.data==l1_data_0_15.data) & !l2_almost_full_0_7;
assign l1_newdata_0_14 = l1_valid_0_14 & (l1_data_0_14.data != l1_cache_0_14) & !l1_data_0_14.last;

assign l1_newdata_0_15 = l1_valid_0_15 & (l1_data_0_15.data != l1_cache_0_15) & !l1_data_0_15.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_7[0] = l1_newdata_0_14 & !l2_almost_full_0_7;
    l1_ready_0_14 = l1_grant_0_7[0];       
    l1_req_0_7[1] = l1_newdata_0_15 & !l2_almost_full_0_7;
    l1_ready_0_15 = l1_grant_0_7[1];       
    //sync case
    if(l1_all_last_0_7) begin
        l1_req_0_7 = 0;
        l1_ready_0_14 = 1;
        l1_ready_0_15 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_7)begin
        l1_req_0_7[0] = 1;
        l1_req_0_7[0] = 0;
        l1_ready_0_15 = 1;
    end else begin
        if(l1_valid_0_14 & (l1_data_0_14.data == l1_cache_0_14) & !l1_data_0_14.last)begin
            l1_ready_0_14 = 1;
        end
        if(l1_valid_0_15 & (l1_data_0_15.data == l1_cache_0_15) & !l1_data_0_15.last)begin
            l1_ready_0_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_14 <= 0;
        l1_cache_0_15 <= 0;
    end else begin
        if(l1_all_last_0_7)begin
            l1_cache_0_14 <= 0;
            l1_cache_0_15 <= 0;
        end else begin
            if(l1_valid_0_14 & l1_ready_0_14)begin
                l1_cache_0_14 <= l1_data_0_14.data;
            end
            if(l1_valid_0_15 & l1_ready_0_15)begin
                l1_cache_0_15 <= l1_data_0_15.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_7 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_7) begin
            l2_in_valid_0_7 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_7 <= |l1_grant_0_7;
        end
    end
    //sync case
    if(l1_all_last_0_7) begin
        l2_in_data_0_7.last <= 1;
        l2_in_data_0_7.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_7)
            2'b01: l2_in_data_0_7 <= l1_data_0_14;
            2'b10: l2_in_data_0_7 <= l1_data_0_15;
            default: l2_in_data_0_7 <= 0;
        endcase
    end   
end

assign l1_all_last_0_8 = (l1_data_0_16.last & l1_valid_0_16) & (l1_data_0_17.last & l1_valid_0_17) & !l2_almost_full_0_8;
assign l1_same_0_8 = l1_newdata_0_16 & l1_newdata_0_17 & (l1_data_0_16.data==l1_data_0_17.data) & !l2_almost_full_0_8;
assign l1_newdata_0_16 = l1_valid_0_16 & (l1_data_0_16.data != l1_cache_0_16) & !l1_data_0_16.last;

assign l1_newdata_0_17 = l1_valid_0_17 & (l1_data_0_17.data != l1_cache_0_17) & !l1_data_0_17.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_8[0] = l1_newdata_0_16 & !l2_almost_full_0_8;
    l1_ready_0_16 = l1_grant_0_8[0];       
    l1_req_0_8[1] = l1_newdata_0_17 & !l2_almost_full_0_8;
    l1_ready_0_17 = l1_grant_0_8[1];       
    //sync case
    if(l1_all_last_0_8) begin
        l1_req_0_8 = 0;
        l1_ready_0_16 = 1;
        l1_ready_0_17 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_8)begin
        l1_req_0_8[0] = 1;
        l1_req_0_8[0] = 0;
        l1_ready_0_17 = 1;
    end else begin
        if(l1_valid_0_16 & (l1_data_0_16.data == l1_cache_0_16) & !l1_data_0_16.last)begin
            l1_ready_0_16 = 1;
        end
        if(l1_valid_0_17 & (l1_data_0_17.data == l1_cache_0_17) & !l1_data_0_17.last)begin
            l1_ready_0_17 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_16 <= 0;
        l1_cache_0_17 <= 0;
    end else begin
        if(l1_all_last_0_8)begin
            l1_cache_0_16 <= 0;
            l1_cache_0_17 <= 0;
        end else begin
            if(l1_valid_0_16 & l1_ready_0_16)begin
                l1_cache_0_16 <= l1_data_0_16.data;
            end
            if(l1_valid_0_17 & l1_ready_0_17)begin
                l1_cache_0_17 <= l1_data_0_17.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_8 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_8) begin
            l2_in_valid_0_8 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_8 <= |l1_grant_0_8;
        end
    end
    //sync case
    if(l1_all_last_0_8) begin
        l2_in_data_0_8.last <= 1;
        l2_in_data_0_8.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_8)
            2'b01: l2_in_data_0_8 <= l1_data_0_16;
            2'b10: l2_in_data_0_8 <= l1_data_0_17;
            default: l2_in_data_0_8 <= 0;
        endcase
    end   
end

assign l1_all_last_0_9 = (l1_data_0_18.last & l1_valid_0_18) & (l1_data_0_19.last & l1_valid_0_19) & !l2_almost_full_0_9;
assign l1_same_0_9 = l1_newdata_0_18 & l1_newdata_0_19 & (l1_data_0_18.data==l1_data_0_19.data) & !l2_almost_full_0_9;
assign l1_newdata_0_18 = l1_valid_0_18 & (l1_data_0_18.data != l1_cache_0_18) & !l1_data_0_18.last;

assign l1_newdata_0_19 = l1_valid_0_19 & (l1_data_0_19.data != l1_cache_0_19) & !l1_data_0_19.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_9[0] = l1_newdata_0_18 & !l2_almost_full_0_9;
    l1_ready_0_18 = l1_grant_0_9[0];       
    l1_req_0_9[1] = l1_newdata_0_19 & !l2_almost_full_0_9;
    l1_ready_0_19 = l1_grant_0_9[1];       
    //sync case
    if(l1_all_last_0_9) begin
        l1_req_0_9 = 0;
        l1_ready_0_18 = 1;
        l1_ready_0_19 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_9)begin
        l1_req_0_9[0] = 1;
        l1_req_0_9[0] = 0;
        l1_ready_0_19 = 1;
    end else begin
        if(l1_valid_0_18 & (l1_data_0_18.data == l1_cache_0_18) & !l1_data_0_18.last)begin
            l1_ready_0_18 = 1;
        end
        if(l1_valid_0_19 & (l1_data_0_19.data == l1_cache_0_19) & !l1_data_0_19.last)begin
            l1_ready_0_19 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_18 <= 0;
        l1_cache_0_19 <= 0;
    end else begin
        if(l1_all_last_0_9)begin
            l1_cache_0_18 <= 0;
            l1_cache_0_19 <= 0;
        end else begin
            if(l1_valid_0_18 & l1_ready_0_18)begin
                l1_cache_0_18 <= l1_data_0_18.data;
            end
            if(l1_valid_0_19 & l1_ready_0_19)begin
                l1_cache_0_19 <= l1_data_0_19.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_9 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_9) begin
            l2_in_valid_0_9 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_9 <= |l1_grant_0_9;
        end
    end
    //sync case
    if(l1_all_last_0_9) begin
        l2_in_data_0_9.last <= 1;
        l2_in_data_0_9.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_9)
            2'b01: l2_in_data_0_9 <= l1_data_0_18;
            2'b10: l2_in_data_0_9 <= l1_data_0_19;
            default: l2_in_data_0_9 <= 0;
        endcase
    end   
end

assign l1_all_last_0_10 = (l1_data_0_20.last & l1_valid_0_20) & (l1_data_0_21.last & l1_valid_0_21) & !l2_almost_full_0_10;
assign l1_same_0_10 = l1_newdata_0_20 & l1_newdata_0_21 & (l1_data_0_20.data==l1_data_0_21.data) & !l2_almost_full_0_10;
assign l1_newdata_0_20 = l1_valid_0_20 & (l1_data_0_20.data != l1_cache_0_20) & !l1_data_0_20.last;

assign l1_newdata_0_21 = l1_valid_0_21 & (l1_data_0_21.data != l1_cache_0_21) & !l1_data_0_21.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_10[0] = l1_newdata_0_20 & !l2_almost_full_0_10;
    l1_ready_0_20 = l1_grant_0_10[0];       
    l1_req_0_10[1] = l1_newdata_0_21 & !l2_almost_full_0_10;
    l1_ready_0_21 = l1_grant_0_10[1];       
    //sync case
    if(l1_all_last_0_10) begin
        l1_req_0_10 = 0;
        l1_ready_0_20 = 1;
        l1_ready_0_21 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_10)begin
        l1_req_0_10[0] = 1;
        l1_req_0_10[0] = 0;
        l1_ready_0_21 = 1;
    end else begin
        if(l1_valid_0_20 & (l1_data_0_20.data == l1_cache_0_20) & !l1_data_0_20.last)begin
            l1_ready_0_20 = 1;
        end
        if(l1_valid_0_21 & (l1_data_0_21.data == l1_cache_0_21) & !l1_data_0_21.last)begin
            l1_ready_0_21 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_20 <= 0;
        l1_cache_0_21 <= 0;
    end else begin
        if(l1_all_last_0_10)begin
            l1_cache_0_20 <= 0;
            l1_cache_0_21 <= 0;
        end else begin
            if(l1_valid_0_20 & l1_ready_0_20)begin
                l1_cache_0_20 <= l1_data_0_20.data;
            end
            if(l1_valid_0_21 & l1_ready_0_21)begin
                l1_cache_0_21 <= l1_data_0_21.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_10 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_10) begin
            l2_in_valid_0_10 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_10 <= |l1_grant_0_10;
        end
    end
    //sync case
    if(l1_all_last_0_10) begin
        l2_in_data_0_10.last <= 1;
        l2_in_data_0_10.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_10)
            2'b01: l2_in_data_0_10 <= l1_data_0_20;
            2'b10: l2_in_data_0_10 <= l1_data_0_21;
            default: l2_in_data_0_10 <= 0;
        endcase
    end   
end

assign l1_all_last_0_11 = (l1_data_0_22.last & l1_valid_0_22) & (l1_data_0_23.last & l1_valid_0_23) & !l2_almost_full_0_11;
assign l1_same_0_11 = l1_newdata_0_22 & l1_newdata_0_23 & (l1_data_0_22.data==l1_data_0_23.data) & !l2_almost_full_0_11;
assign l1_newdata_0_22 = l1_valid_0_22 & (l1_data_0_22.data != l1_cache_0_22) & !l1_data_0_22.last;

assign l1_newdata_0_23 = l1_valid_0_23 & (l1_data_0_23.data != l1_cache_0_23) & !l1_data_0_23.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_11[0] = l1_newdata_0_22 & !l2_almost_full_0_11;
    l1_ready_0_22 = l1_grant_0_11[0];       
    l1_req_0_11[1] = l1_newdata_0_23 & !l2_almost_full_0_11;
    l1_ready_0_23 = l1_grant_0_11[1];       
    //sync case
    if(l1_all_last_0_11) begin
        l1_req_0_11 = 0;
        l1_ready_0_22 = 1;
        l1_ready_0_23 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_11)begin
        l1_req_0_11[0] = 1;
        l1_req_0_11[0] = 0;
        l1_ready_0_23 = 1;
    end else begin
        if(l1_valid_0_22 & (l1_data_0_22.data == l1_cache_0_22) & !l1_data_0_22.last)begin
            l1_ready_0_22 = 1;
        end
        if(l1_valid_0_23 & (l1_data_0_23.data == l1_cache_0_23) & !l1_data_0_23.last)begin
            l1_ready_0_23 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_22 <= 0;
        l1_cache_0_23 <= 0;
    end else begin
        if(l1_all_last_0_11)begin
            l1_cache_0_22 <= 0;
            l1_cache_0_23 <= 0;
        end else begin
            if(l1_valid_0_22 & l1_ready_0_22)begin
                l1_cache_0_22 <= l1_data_0_22.data;
            end
            if(l1_valid_0_23 & l1_ready_0_23)begin
                l1_cache_0_23 <= l1_data_0_23.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_11 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_11) begin
            l2_in_valid_0_11 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_11 <= |l1_grant_0_11;
        end
    end
    //sync case
    if(l1_all_last_0_11) begin
        l2_in_data_0_11.last <= 1;
        l2_in_data_0_11.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_11)
            2'b01: l2_in_data_0_11 <= l1_data_0_22;
            2'b10: l2_in_data_0_11 <= l1_data_0_23;
            default: l2_in_data_0_11 <= 0;
        endcase
    end   
end

assign l1_all_last_0_12 = (l1_data_0_24.last & l1_valid_0_24) & (l1_data_0_25.last & l1_valid_0_25) & !l2_almost_full_0_12;
assign l1_same_0_12 = l1_newdata_0_24 & l1_newdata_0_25 & (l1_data_0_24.data==l1_data_0_25.data) & !l2_almost_full_0_12;
assign l1_newdata_0_24 = l1_valid_0_24 & (l1_data_0_24.data != l1_cache_0_24) & !l1_data_0_24.last;

assign l1_newdata_0_25 = l1_valid_0_25 & (l1_data_0_25.data != l1_cache_0_25) & !l1_data_0_25.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_12[0] = l1_newdata_0_24 & !l2_almost_full_0_12;
    l1_ready_0_24 = l1_grant_0_12[0];       
    l1_req_0_12[1] = l1_newdata_0_25 & !l2_almost_full_0_12;
    l1_ready_0_25 = l1_grant_0_12[1];       
    //sync case
    if(l1_all_last_0_12) begin
        l1_req_0_12 = 0;
        l1_ready_0_24 = 1;
        l1_ready_0_25 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_12)begin
        l1_req_0_12[0] = 1;
        l1_req_0_12[0] = 0;
        l1_ready_0_25 = 1;
    end else begin
        if(l1_valid_0_24 & (l1_data_0_24.data == l1_cache_0_24) & !l1_data_0_24.last)begin
            l1_ready_0_24 = 1;
        end
        if(l1_valid_0_25 & (l1_data_0_25.data == l1_cache_0_25) & !l1_data_0_25.last)begin
            l1_ready_0_25 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_24 <= 0;
        l1_cache_0_25 <= 0;
    end else begin
        if(l1_all_last_0_12)begin
            l1_cache_0_24 <= 0;
            l1_cache_0_25 <= 0;
        end else begin
            if(l1_valid_0_24 & l1_ready_0_24)begin
                l1_cache_0_24 <= l1_data_0_24.data;
            end
            if(l1_valid_0_25 & l1_ready_0_25)begin
                l1_cache_0_25 <= l1_data_0_25.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_12 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_12) begin
            l2_in_valid_0_12 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_12 <= |l1_grant_0_12;
        end
    end
    //sync case
    if(l1_all_last_0_12) begin
        l2_in_data_0_12.last <= 1;
        l2_in_data_0_12.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_12)
            2'b01: l2_in_data_0_12 <= l1_data_0_24;
            2'b10: l2_in_data_0_12 <= l1_data_0_25;
            default: l2_in_data_0_12 <= 0;
        endcase
    end   
end

assign l1_all_last_0_13 = (l1_data_0_26.last & l1_valid_0_26) & (l1_data_0_27.last & l1_valid_0_27) & !l2_almost_full_0_13;
assign l1_same_0_13 = l1_newdata_0_26 & l1_newdata_0_27 & (l1_data_0_26.data==l1_data_0_27.data) & !l2_almost_full_0_13;
assign l1_newdata_0_26 = l1_valid_0_26 & (l1_data_0_26.data != l1_cache_0_26) & !l1_data_0_26.last;

assign l1_newdata_0_27 = l1_valid_0_27 & (l1_data_0_27.data != l1_cache_0_27) & !l1_data_0_27.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_13[0] = l1_newdata_0_26 & !l2_almost_full_0_13;
    l1_ready_0_26 = l1_grant_0_13[0];       
    l1_req_0_13[1] = l1_newdata_0_27 & !l2_almost_full_0_13;
    l1_ready_0_27 = l1_grant_0_13[1];       
    //sync case
    if(l1_all_last_0_13) begin
        l1_req_0_13 = 0;
        l1_ready_0_26 = 1;
        l1_ready_0_27 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_13)begin
        l1_req_0_13[0] = 1;
        l1_req_0_13[0] = 0;
        l1_ready_0_27 = 1;
    end else begin
        if(l1_valid_0_26 & (l1_data_0_26.data == l1_cache_0_26) & !l1_data_0_26.last)begin
            l1_ready_0_26 = 1;
        end
        if(l1_valid_0_27 & (l1_data_0_27.data == l1_cache_0_27) & !l1_data_0_27.last)begin
            l1_ready_0_27 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_26 <= 0;
        l1_cache_0_27 <= 0;
    end else begin
        if(l1_all_last_0_13)begin
            l1_cache_0_26 <= 0;
            l1_cache_0_27 <= 0;
        end else begin
            if(l1_valid_0_26 & l1_ready_0_26)begin
                l1_cache_0_26 <= l1_data_0_26.data;
            end
            if(l1_valid_0_27 & l1_ready_0_27)begin
                l1_cache_0_27 <= l1_data_0_27.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_13 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_13) begin
            l2_in_valid_0_13 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_13 <= |l1_grant_0_13;
        end
    end
    //sync case
    if(l1_all_last_0_13) begin
        l2_in_data_0_13.last <= 1;
        l2_in_data_0_13.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_13)
            2'b01: l2_in_data_0_13 <= l1_data_0_26;
            2'b10: l2_in_data_0_13 <= l1_data_0_27;
            default: l2_in_data_0_13 <= 0;
        endcase
    end   
end

assign l1_all_last_0_14 = (l1_data_0_28.last & l1_valid_0_28) & (l1_data_0_29.last & l1_valid_0_29) & !l2_almost_full_0_14;
assign l1_same_0_14 = l1_newdata_0_28 & l1_newdata_0_29 & (l1_data_0_28.data==l1_data_0_29.data) & !l2_almost_full_0_14;
assign l1_newdata_0_28 = l1_valid_0_28 & (l1_data_0_28.data != l1_cache_0_28) & !l1_data_0_28.last;

assign l1_newdata_0_29 = l1_valid_0_29 & (l1_data_0_29.data != l1_cache_0_29) & !l1_data_0_29.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_14[0] = l1_newdata_0_28 & !l2_almost_full_0_14;
    l1_ready_0_28 = l1_grant_0_14[0];       
    l1_req_0_14[1] = l1_newdata_0_29 & !l2_almost_full_0_14;
    l1_ready_0_29 = l1_grant_0_14[1];       
    //sync case
    if(l1_all_last_0_14) begin
        l1_req_0_14 = 0;
        l1_ready_0_28 = 1;
        l1_ready_0_29 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_14)begin
        l1_req_0_14[0] = 1;
        l1_req_0_14[0] = 0;
        l1_ready_0_29 = 1;
    end else begin
        if(l1_valid_0_28 & (l1_data_0_28.data == l1_cache_0_28) & !l1_data_0_28.last)begin
            l1_ready_0_28 = 1;
        end
        if(l1_valid_0_29 & (l1_data_0_29.data == l1_cache_0_29) & !l1_data_0_29.last)begin
            l1_ready_0_29 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_28 <= 0;
        l1_cache_0_29 <= 0;
    end else begin
        if(l1_all_last_0_14)begin
            l1_cache_0_28 <= 0;
            l1_cache_0_29 <= 0;
        end else begin
            if(l1_valid_0_28 & l1_ready_0_28)begin
                l1_cache_0_28 <= l1_data_0_28.data;
            end
            if(l1_valid_0_29 & l1_ready_0_29)begin
                l1_cache_0_29 <= l1_data_0_29.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_14 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_14) begin
            l2_in_valid_0_14 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_14 <= |l1_grant_0_14;
        end
    end
    //sync case
    if(l1_all_last_0_14) begin
        l2_in_data_0_14.last <= 1;
        l2_in_data_0_14.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_14)
            2'b01: l2_in_data_0_14 <= l1_data_0_28;
            2'b10: l2_in_data_0_14 <= l1_data_0_29;
            default: l2_in_data_0_14 <= 0;
        endcase
    end   
end

assign l1_all_last_0_15 = (l1_data_0_30.last & l1_valid_0_30) & (l1_data_0_31.last & l1_valid_0_31) & !l2_almost_full_0_15;
assign l1_same_0_15 = l1_newdata_0_30 & l1_newdata_0_31 & (l1_data_0_30.data==l1_data_0_31.data) & !l2_almost_full_0_15;
assign l1_newdata_0_30 = l1_valid_0_30 & (l1_data_0_30.data != l1_cache_0_30) & !l1_data_0_30.last;

assign l1_newdata_0_31 = l1_valid_0_31 & (l1_data_0_31.data != l1_cache_0_31) & !l1_data_0_31.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_0_15[0] = l1_newdata_0_30 & !l2_almost_full_0_15;
    l1_ready_0_30 = l1_grant_0_15[0];       
    l1_req_0_15[1] = l1_newdata_0_31 & !l2_almost_full_0_15;
    l1_ready_0_31 = l1_grant_0_15[1];       
    //sync case
    if(l1_all_last_0_15) begin
        l1_req_0_15 = 0;
        l1_ready_0_30 = 1;
        l1_ready_0_31 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_0_15)begin
        l1_req_0_15[0] = 1;
        l1_req_0_15[0] = 0;
        l1_ready_0_31 = 1;
    end else begin
        if(l1_valid_0_30 & (l1_data_0_30.data == l1_cache_0_30) & !l1_data_0_30.last)begin
            l1_ready_0_30 = 1;
        end
        if(l1_valid_0_31 & (l1_data_0_31.data == l1_cache_0_31) & !l1_data_0_31.last)begin
            l1_ready_0_31 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_0_30 <= 0;
        l1_cache_0_31 <= 0;
    end else begin
        if(l1_all_last_0_15)begin
            l1_cache_0_30 <= 0;
            l1_cache_0_31 <= 0;
        end else begin
            if(l1_valid_0_30 & l1_ready_0_30)begin
                l1_cache_0_30 <= l1_data_0_30.data;
            end
            if(l1_valid_0_31 & l1_ready_0_31)begin
                l1_cache_0_31 <= l1_data_0_31.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_0_15 <= 0;
    end else begin
        //sync case
        if(l1_all_last_0_15) begin
            l2_in_valid_0_15 <= 1;
        //normal case
        end else begin
            l2_in_valid_0_15 <= |l1_grant_0_15;
        end
    end
    //sync case
    if(l1_all_last_0_15) begin
        l2_in_data_0_15.last <= 1;
        l2_in_data_0_15.data <= 0;
    //normal case
    end else begin
        case(l1_grant_0_15)
            2'b01: l2_in_data_0_15 <= l1_data_0_30;
            2'b10: l2_in_data_0_15 <= l1_data_0_31;
            default: l2_in_data_0_15 <= 0;
        endcase
    end   
end

assign l1_all_last_1_0 = (l1_data_1_0.last & l1_valid_1_0) & (l1_data_1_1.last & l1_valid_1_1) & !l2_almost_full_1_0;
assign l1_same_1_0 = l1_newdata_1_0 & l1_newdata_1_1 & (l1_data_1_0.data==l1_data_1_1.data) & !l2_almost_full_1_0;
assign l1_newdata_1_0 = l1_valid_1_0 & (l1_data_1_0.data != l1_cache_1_0) & !l1_data_1_0.last;

assign l1_newdata_1_1 = l1_valid_1_1 & (l1_data_1_1.data != l1_cache_1_1) & !l1_data_1_1.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_0[0] = l1_newdata_1_0 & !l2_almost_full_1_0;
    l1_ready_1_0 = l1_grant_1_0[0];       
    l1_req_1_0[1] = l1_newdata_1_1 & !l2_almost_full_1_0;
    l1_ready_1_1 = l1_grant_1_0[1];       
    //sync case
    if(l1_all_last_1_0) begin
        l1_req_1_0 = 0;
        l1_ready_1_0 = 1;
        l1_ready_1_1 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_0)begin
        l1_req_1_0[0] = 1;
        l1_req_1_0[0] = 0;
        l1_ready_1_1 = 1;
    end else begin
        if(l1_valid_1_0 & (l1_data_1_0.data == l1_cache_1_0) & !l1_data_1_0.last)begin
            l1_ready_1_0 = 1;
        end
        if(l1_valid_1_1 & (l1_data_1_1.data == l1_cache_1_1) & !l1_data_1_1.last)begin
            l1_ready_1_1 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_0 <= 0;
        l1_cache_1_1 <= 0;
    end else begin
        if(l1_all_last_1_0)begin
            l1_cache_1_0 <= 0;
            l1_cache_1_1 <= 0;
        end else begin
            if(l1_valid_1_0 & l1_ready_1_0)begin
                l1_cache_1_0 <= l1_data_1_0.data;
            end
            if(l1_valid_1_1 & l1_ready_1_1)begin
                l1_cache_1_1 <= l1_data_1_1.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_0 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_0) begin
            l2_in_valid_1_0 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_0 <= |l1_grant_1_0;
        end
    end
    //sync case
    if(l1_all_last_1_0) begin
        l2_in_data_1_0.last <= 1;
        l2_in_data_1_0.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_0)
            2'b01: l2_in_data_1_0 <= l1_data_1_0;
            2'b10: l2_in_data_1_0 <= l1_data_1_1;
            default: l2_in_data_1_0 <= 0;
        endcase
    end   
end

assign l1_all_last_1_1 = (l1_data_1_2.last & l1_valid_1_2) & (l1_data_1_3.last & l1_valid_1_3) & !l2_almost_full_1_1;
assign l1_same_1_1 = l1_newdata_1_2 & l1_newdata_1_3 & (l1_data_1_2.data==l1_data_1_3.data) & !l2_almost_full_1_1;
assign l1_newdata_1_2 = l1_valid_1_2 & (l1_data_1_2.data != l1_cache_1_2) & !l1_data_1_2.last;

assign l1_newdata_1_3 = l1_valid_1_3 & (l1_data_1_3.data != l1_cache_1_3) & !l1_data_1_3.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_1[0] = l1_newdata_1_2 & !l2_almost_full_1_1;
    l1_ready_1_2 = l1_grant_1_1[0];       
    l1_req_1_1[1] = l1_newdata_1_3 & !l2_almost_full_1_1;
    l1_ready_1_3 = l1_grant_1_1[1];       
    //sync case
    if(l1_all_last_1_1) begin
        l1_req_1_1 = 0;
        l1_ready_1_2 = 1;
        l1_ready_1_3 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_1)begin
        l1_req_1_1[0] = 1;
        l1_req_1_1[0] = 0;
        l1_ready_1_3 = 1;
    end else begin
        if(l1_valid_1_2 & (l1_data_1_2.data == l1_cache_1_2) & !l1_data_1_2.last)begin
            l1_ready_1_2 = 1;
        end
        if(l1_valid_1_3 & (l1_data_1_3.data == l1_cache_1_3) & !l1_data_1_3.last)begin
            l1_ready_1_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_2 <= 0;
        l1_cache_1_3 <= 0;
    end else begin
        if(l1_all_last_1_1)begin
            l1_cache_1_2 <= 0;
            l1_cache_1_3 <= 0;
        end else begin
            if(l1_valid_1_2 & l1_ready_1_2)begin
                l1_cache_1_2 <= l1_data_1_2.data;
            end
            if(l1_valid_1_3 & l1_ready_1_3)begin
                l1_cache_1_3 <= l1_data_1_3.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_1 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_1) begin
            l2_in_valid_1_1 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_1 <= |l1_grant_1_1;
        end
    end
    //sync case
    if(l1_all_last_1_1) begin
        l2_in_data_1_1.last <= 1;
        l2_in_data_1_1.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_1)
            2'b01: l2_in_data_1_1 <= l1_data_1_2;
            2'b10: l2_in_data_1_1 <= l1_data_1_3;
            default: l2_in_data_1_1 <= 0;
        endcase
    end   
end

assign l1_all_last_1_2 = (l1_data_1_4.last & l1_valid_1_4) & (l1_data_1_5.last & l1_valid_1_5) & !l2_almost_full_1_2;
assign l1_same_1_2 = l1_newdata_1_4 & l1_newdata_1_5 & (l1_data_1_4.data==l1_data_1_5.data) & !l2_almost_full_1_2;
assign l1_newdata_1_4 = l1_valid_1_4 & (l1_data_1_4.data != l1_cache_1_4) & !l1_data_1_4.last;

assign l1_newdata_1_5 = l1_valid_1_5 & (l1_data_1_5.data != l1_cache_1_5) & !l1_data_1_5.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_2[0] = l1_newdata_1_4 & !l2_almost_full_1_2;
    l1_ready_1_4 = l1_grant_1_2[0];       
    l1_req_1_2[1] = l1_newdata_1_5 & !l2_almost_full_1_2;
    l1_ready_1_5 = l1_grant_1_2[1];       
    //sync case
    if(l1_all_last_1_2) begin
        l1_req_1_2 = 0;
        l1_ready_1_4 = 1;
        l1_ready_1_5 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_2)begin
        l1_req_1_2[0] = 1;
        l1_req_1_2[0] = 0;
        l1_ready_1_5 = 1;
    end else begin
        if(l1_valid_1_4 & (l1_data_1_4.data == l1_cache_1_4) & !l1_data_1_4.last)begin
            l1_ready_1_4 = 1;
        end
        if(l1_valid_1_5 & (l1_data_1_5.data == l1_cache_1_5) & !l1_data_1_5.last)begin
            l1_ready_1_5 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_4 <= 0;
        l1_cache_1_5 <= 0;
    end else begin
        if(l1_all_last_1_2)begin
            l1_cache_1_4 <= 0;
            l1_cache_1_5 <= 0;
        end else begin
            if(l1_valid_1_4 & l1_ready_1_4)begin
                l1_cache_1_4 <= l1_data_1_4.data;
            end
            if(l1_valid_1_5 & l1_ready_1_5)begin
                l1_cache_1_5 <= l1_data_1_5.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_2 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_2) begin
            l2_in_valid_1_2 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_2 <= |l1_grant_1_2;
        end
    end
    //sync case
    if(l1_all_last_1_2) begin
        l2_in_data_1_2.last <= 1;
        l2_in_data_1_2.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_2)
            2'b01: l2_in_data_1_2 <= l1_data_1_4;
            2'b10: l2_in_data_1_2 <= l1_data_1_5;
            default: l2_in_data_1_2 <= 0;
        endcase
    end   
end

assign l1_all_last_1_3 = (l1_data_1_6.last & l1_valid_1_6) & (l1_data_1_7.last & l1_valid_1_7) & !l2_almost_full_1_3;
assign l1_same_1_3 = l1_newdata_1_6 & l1_newdata_1_7 & (l1_data_1_6.data==l1_data_1_7.data) & !l2_almost_full_1_3;
assign l1_newdata_1_6 = l1_valid_1_6 & (l1_data_1_6.data != l1_cache_1_6) & !l1_data_1_6.last;

assign l1_newdata_1_7 = l1_valid_1_7 & (l1_data_1_7.data != l1_cache_1_7) & !l1_data_1_7.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_3[0] = l1_newdata_1_6 & !l2_almost_full_1_3;
    l1_ready_1_6 = l1_grant_1_3[0];       
    l1_req_1_3[1] = l1_newdata_1_7 & !l2_almost_full_1_3;
    l1_ready_1_7 = l1_grant_1_3[1];       
    //sync case
    if(l1_all_last_1_3) begin
        l1_req_1_3 = 0;
        l1_ready_1_6 = 1;
        l1_ready_1_7 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_3)begin
        l1_req_1_3[0] = 1;
        l1_req_1_3[0] = 0;
        l1_ready_1_7 = 1;
    end else begin
        if(l1_valid_1_6 & (l1_data_1_6.data == l1_cache_1_6) & !l1_data_1_6.last)begin
            l1_ready_1_6 = 1;
        end
        if(l1_valid_1_7 & (l1_data_1_7.data == l1_cache_1_7) & !l1_data_1_7.last)begin
            l1_ready_1_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_6 <= 0;
        l1_cache_1_7 <= 0;
    end else begin
        if(l1_all_last_1_3)begin
            l1_cache_1_6 <= 0;
            l1_cache_1_7 <= 0;
        end else begin
            if(l1_valid_1_6 & l1_ready_1_6)begin
                l1_cache_1_6 <= l1_data_1_6.data;
            end
            if(l1_valid_1_7 & l1_ready_1_7)begin
                l1_cache_1_7 <= l1_data_1_7.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_3 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_3) begin
            l2_in_valid_1_3 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_3 <= |l1_grant_1_3;
        end
    end
    //sync case
    if(l1_all_last_1_3) begin
        l2_in_data_1_3.last <= 1;
        l2_in_data_1_3.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_3)
            2'b01: l2_in_data_1_3 <= l1_data_1_6;
            2'b10: l2_in_data_1_3 <= l1_data_1_7;
            default: l2_in_data_1_3 <= 0;
        endcase
    end   
end

assign l1_all_last_1_4 = (l1_data_1_8.last & l1_valid_1_8) & (l1_data_1_9.last & l1_valid_1_9) & !l2_almost_full_1_4;
assign l1_same_1_4 = l1_newdata_1_8 & l1_newdata_1_9 & (l1_data_1_8.data==l1_data_1_9.data) & !l2_almost_full_1_4;
assign l1_newdata_1_8 = l1_valid_1_8 & (l1_data_1_8.data != l1_cache_1_8) & !l1_data_1_8.last;

assign l1_newdata_1_9 = l1_valid_1_9 & (l1_data_1_9.data != l1_cache_1_9) & !l1_data_1_9.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_4[0] = l1_newdata_1_8 & !l2_almost_full_1_4;
    l1_ready_1_8 = l1_grant_1_4[0];       
    l1_req_1_4[1] = l1_newdata_1_9 & !l2_almost_full_1_4;
    l1_ready_1_9 = l1_grant_1_4[1];       
    //sync case
    if(l1_all_last_1_4) begin
        l1_req_1_4 = 0;
        l1_ready_1_8 = 1;
        l1_ready_1_9 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_4)begin
        l1_req_1_4[0] = 1;
        l1_req_1_4[0] = 0;
        l1_ready_1_9 = 1;
    end else begin
        if(l1_valid_1_8 & (l1_data_1_8.data == l1_cache_1_8) & !l1_data_1_8.last)begin
            l1_ready_1_8 = 1;
        end
        if(l1_valid_1_9 & (l1_data_1_9.data == l1_cache_1_9) & !l1_data_1_9.last)begin
            l1_ready_1_9 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_8 <= 0;
        l1_cache_1_9 <= 0;
    end else begin
        if(l1_all_last_1_4)begin
            l1_cache_1_8 <= 0;
            l1_cache_1_9 <= 0;
        end else begin
            if(l1_valid_1_8 & l1_ready_1_8)begin
                l1_cache_1_8 <= l1_data_1_8.data;
            end
            if(l1_valid_1_9 & l1_ready_1_9)begin
                l1_cache_1_9 <= l1_data_1_9.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_4 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_4) begin
            l2_in_valid_1_4 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_4 <= |l1_grant_1_4;
        end
    end
    //sync case
    if(l1_all_last_1_4) begin
        l2_in_data_1_4.last <= 1;
        l2_in_data_1_4.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_4)
            2'b01: l2_in_data_1_4 <= l1_data_1_8;
            2'b10: l2_in_data_1_4 <= l1_data_1_9;
            default: l2_in_data_1_4 <= 0;
        endcase
    end   
end

assign l1_all_last_1_5 = (l1_data_1_10.last & l1_valid_1_10) & (l1_data_1_11.last & l1_valid_1_11) & !l2_almost_full_1_5;
assign l1_same_1_5 = l1_newdata_1_10 & l1_newdata_1_11 & (l1_data_1_10.data==l1_data_1_11.data) & !l2_almost_full_1_5;
assign l1_newdata_1_10 = l1_valid_1_10 & (l1_data_1_10.data != l1_cache_1_10) & !l1_data_1_10.last;

assign l1_newdata_1_11 = l1_valid_1_11 & (l1_data_1_11.data != l1_cache_1_11) & !l1_data_1_11.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_5[0] = l1_newdata_1_10 & !l2_almost_full_1_5;
    l1_ready_1_10 = l1_grant_1_5[0];       
    l1_req_1_5[1] = l1_newdata_1_11 & !l2_almost_full_1_5;
    l1_ready_1_11 = l1_grant_1_5[1];       
    //sync case
    if(l1_all_last_1_5) begin
        l1_req_1_5 = 0;
        l1_ready_1_10 = 1;
        l1_ready_1_11 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_5)begin
        l1_req_1_5[0] = 1;
        l1_req_1_5[0] = 0;
        l1_ready_1_11 = 1;
    end else begin
        if(l1_valid_1_10 & (l1_data_1_10.data == l1_cache_1_10) & !l1_data_1_10.last)begin
            l1_ready_1_10 = 1;
        end
        if(l1_valid_1_11 & (l1_data_1_11.data == l1_cache_1_11) & !l1_data_1_11.last)begin
            l1_ready_1_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_10 <= 0;
        l1_cache_1_11 <= 0;
    end else begin
        if(l1_all_last_1_5)begin
            l1_cache_1_10 <= 0;
            l1_cache_1_11 <= 0;
        end else begin
            if(l1_valid_1_10 & l1_ready_1_10)begin
                l1_cache_1_10 <= l1_data_1_10.data;
            end
            if(l1_valid_1_11 & l1_ready_1_11)begin
                l1_cache_1_11 <= l1_data_1_11.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_5 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_5) begin
            l2_in_valid_1_5 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_5 <= |l1_grant_1_5;
        end
    end
    //sync case
    if(l1_all_last_1_5) begin
        l2_in_data_1_5.last <= 1;
        l2_in_data_1_5.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_5)
            2'b01: l2_in_data_1_5 <= l1_data_1_10;
            2'b10: l2_in_data_1_5 <= l1_data_1_11;
            default: l2_in_data_1_5 <= 0;
        endcase
    end   
end

assign l1_all_last_1_6 = (l1_data_1_12.last & l1_valid_1_12) & (l1_data_1_13.last & l1_valid_1_13) & !l2_almost_full_1_6;
assign l1_same_1_6 = l1_newdata_1_12 & l1_newdata_1_13 & (l1_data_1_12.data==l1_data_1_13.data) & !l2_almost_full_1_6;
assign l1_newdata_1_12 = l1_valid_1_12 & (l1_data_1_12.data != l1_cache_1_12) & !l1_data_1_12.last;

assign l1_newdata_1_13 = l1_valid_1_13 & (l1_data_1_13.data != l1_cache_1_13) & !l1_data_1_13.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_6[0] = l1_newdata_1_12 & !l2_almost_full_1_6;
    l1_ready_1_12 = l1_grant_1_6[0];       
    l1_req_1_6[1] = l1_newdata_1_13 & !l2_almost_full_1_6;
    l1_ready_1_13 = l1_grant_1_6[1];       
    //sync case
    if(l1_all_last_1_6) begin
        l1_req_1_6 = 0;
        l1_ready_1_12 = 1;
        l1_ready_1_13 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_6)begin
        l1_req_1_6[0] = 1;
        l1_req_1_6[0] = 0;
        l1_ready_1_13 = 1;
    end else begin
        if(l1_valid_1_12 & (l1_data_1_12.data == l1_cache_1_12) & !l1_data_1_12.last)begin
            l1_ready_1_12 = 1;
        end
        if(l1_valid_1_13 & (l1_data_1_13.data == l1_cache_1_13) & !l1_data_1_13.last)begin
            l1_ready_1_13 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_12 <= 0;
        l1_cache_1_13 <= 0;
    end else begin
        if(l1_all_last_1_6)begin
            l1_cache_1_12 <= 0;
            l1_cache_1_13 <= 0;
        end else begin
            if(l1_valid_1_12 & l1_ready_1_12)begin
                l1_cache_1_12 <= l1_data_1_12.data;
            end
            if(l1_valid_1_13 & l1_ready_1_13)begin
                l1_cache_1_13 <= l1_data_1_13.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_6 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_6) begin
            l2_in_valid_1_6 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_6 <= |l1_grant_1_6;
        end
    end
    //sync case
    if(l1_all_last_1_6) begin
        l2_in_data_1_6.last <= 1;
        l2_in_data_1_6.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_6)
            2'b01: l2_in_data_1_6 <= l1_data_1_12;
            2'b10: l2_in_data_1_6 <= l1_data_1_13;
            default: l2_in_data_1_6 <= 0;
        endcase
    end   
end

assign l1_all_last_1_7 = (l1_data_1_14.last & l1_valid_1_14) & (l1_data_1_15.last & l1_valid_1_15) & !l2_almost_full_1_7;
assign l1_same_1_7 = l1_newdata_1_14 & l1_newdata_1_15 & (l1_data_1_14.data==l1_data_1_15.data) & !l2_almost_full_1_7;
assign l1_newdata_1_14 = l1_valid_1_14 & (l1_data_1_14.data != l1_cache_1_14) & !l1_data_1_14.last;

assign l1_newdata_1_15 = l1_valid_1_15 & (l1_data_1_15.data != l1_cache_1_15) & !l1_data_1_15.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_7[0] = l1_newdata_1_14 & !l2_almost_full_1_7;
    l1_ready_1_14 = l1_grant_1_7[0];       
    l1_req_1_7[1] = l1_newdata_1_15 & !l2_almost_full_1_7;
    l1_ready_1_15 = l1_grant_1_7[1];       
    //sync case
    if(l1_all_last_1_7) begin
        l1_req_1_7 = 0;
        l1_ready_1_14 = 1;
        l1_ready_1_15 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_7)begin
        l1_req_1_7[0] = 1;
        l1_req_1_7[0] = 0;
        l1_ready_1_15 = 1;
    end else begin
        if(l1_valid_1_14 & (l1_data_1_14.data == l1_cache_1_14) & !l1_data_1_14.last)begin
            l1_ready_1_14 = 1;
        end
        if(l1_valid_1_15 & (l1_data_1_15.data == l1_cache_1_15) & !l1_data_1_15.last)begin
            l1_ready_1_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_14 <= 0;
        l1_cache_1_15 <= 0;
    end else begin
        if(l1_all_last_1_7)begin
            l1_cache_1_14 <= 0;
            l1_cache_1_15 <= 0;
        end else begin
            if(l1_valid_1_14 & l1_ready_1_14)begin
                l1_cache_1_14 <= l1_data_1_14.data;
            end
            if(l1_valid_1_15 & l1_ready_1_15)begin
                l1_cache_1_15 <= l1_data_1_15.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_7 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_7) begin
            l2_in_valid_1_7 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_7 <= |l1_grant_1_7;
        end
    end
    //sync case
    if(l1_all_last_1_7) begin
        l2_in_data_1_7.last <= 1;
        l2_in_data_1_7.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_7)
            2'b01: l2_in_data_1_7 <= l1_data_1_14;
            2'b10: l2_in_data_1_7 <= l1_data_1_15;
            default: l2_in_data_1_7 <= 0;
        endcase
    end   
end

assign l1_all_last_1_8 = (l1_data_1_16.last & l1_valid_1_16) & (l1_data_1_17.last & l1_valid_1_17) & !l2_almost_full_1_8;
assign l1_same_1_8 = l1_newdata_1_16 & l1_newdata_1_17 & (l1_data_1_16.data==l1_data_1_17.data) & !l2_almost_full_1_8;
assign l1_newdata_1_16 = l1_valid_1_16 & (l1_data_1_16.data != l1_cache_1_16) & !l1_data_1_16.last;

assign l1_newdata_1_17 = l1_valid_1_17 & (l1_data_1_17.data != l1_cache_1_17) & !l1_data_1_17.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_8[0] = l1_newdata_1_16 & !l2_almost_full_1_8;
    l1_ready_1_16 = l1_grant_1_8[0];       
    l1_req_1_8[1] = l1_newdata_1_17 & !l2_almost_full_1_8;
    l1_ready_1_17 = l1_grant_1_8[1];       
    //sync case
    if(l1_all_last_1_8) begin
        l1_req_1_8 = 0;
        l1_ready_1_16 = 1;
        l1_ready_1_17 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_8)begin
        l1_req_1_8[0] = 1;
        l1_req_1_8[0] = 0;
        l1_ready_1_17 = 1;
    end else begin
        if(l1_valid_1_16 & (l1_data_1_16.data == l1_cache_1_16) & !l1_data_1_16.last)begin
            l1_ready_1_16 = 1;
        end
        if(l1_valid_1_17 & (l1_data_1_17.data == l1_cache_1_17) & !l1_data_1_17.last)begin
            l1_ready_1_17 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_16 <= 0;
        l1_cache_1_17 <= 0;
    end else begin
        if(l1_all_last_1_8)begin
            l1_cache_1_16 <= 0;
            l1_cache_1_17 <= 0;
        end else begin
            if(l1_valid_1_16 & l1_ready_1_16)begin
                l1_cache_1_16 <= l1_data_1_16.data;
            end
            if(l1_valid_1_17 & l1_ready_1_17)begin
                l1_cache_1_17 <= l1_data_1_17.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_8 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_8) begin
            l2_in_valid_1_8 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_8 <= |l1_grant_1_8;
        end
    end
    //sync case
    if(l1_all_last_1_8) begin
        l2_in_data_1_8.last <= 1;
        l2_in_data_1_8.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_8)
            2'b01: l2_in_data_1_8 <= l1_data_1_16;
            2'b10: l2_in_data_1_8 <= l1_data_1_17;
            default: l2_in_data_1_8 <= 0;
        endcase
    end   
end

assign l1_all_last_1_9 = (l1_data_1_18.last & l1_valid_1_18) & (l1_data_1_19.last & l1_valid_1_19) & !l2_almost_full_1_9;
assign l1_same_1_9 = l1_newdata_1_18 & l1_newdata_1_19 & (l1_data_1_18.data==l1_data_1_19.data) & !l2_almost_full_1_9;
assign l1_newdata_1_18 = l1_valid_1_18 & (l1_data_1_18.data != l1_cache_1_18) & !l1_data_1_18.last;

assign l1_newdata_1_19 = l1_valid_1_19 & (l1_data_1_19.data != l1_cache_1_19) & !l1_data_1_19.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_9[0] = l1_newdata_1_18 & !l2_almost_full_1_9;
    l1_ready_1_18 = l1_grant_1_9[0];       
    l1_req_1_9[1] = l1_newdata_1_19 & !l2_almost_full_1_9;
    l1_ready_1_19 = l1_grant_1_9[1];       
    //sync case
    if(l1_all_last_1_9) begin
        l1_req_1_9 = 0;
        l1_ready_1_18 = 1;
        l1_ready_1_19 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_9)begin
        l1_req_1_9[0] = 1;
        l1_req_1_9[0] = 0;
        l1_ready_1_19 = 1;
    end else begin
        if(l1_valid_1_18 & (l1_data_1_18.data == l1_cache_1_18) & !l1_data_1_18.last)begin
            l1_ready_1_18 = 1;
        end
        if(l1_valid_1_19 & (l1_data_1_19.data == l1_cache_1_19) & !l1_data_1_19.last)begin
            l1_ready_1_19 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_18 <= 0;
        l1_cache_1_19 <= 0;
    end else begin
        if(l1_all_last_1_9)begin
            l1_cache_1_18 <= 0;
            l1_cache_1_19 <= 0;
        end else begin
            if(l1_valid_1_18 & l1_ready_1_18)begin
                l1_cache_1_18 <= l1_data_1_18.data;
            end
            if(l1_valid_1_19 & l1_ready_1_19)begin
                l1_cache_1_19 <= l1_data_1_19.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_9 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_9) begin
            l2_in_valid_1_9 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_9 <= |l1_grant_1_9;
        end
    end
    //sync case
    if(l1_all_last_1_9) begin
        l2_in_data_1_9.last <= 1;
        l2_in_data_1_9.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_9)
            2'b01: l2_in_data_1_9 <= l1_data_1_18;
            2'b10: l2_in_data_1_9 <= l1_data_1_19;
            default: l2_in_data_1_9 <= 0;
        endcase
    end   
end

assign l1_all_last_1_10 = (l1_data_1_20.last & l1_valid_1_20) & (l1_data_1_21.last & l1_valid_1_21) & !l2_almost_full_1_10;
assign l1_same_1_10 = l1_newdata_1_20 & l1_newdata_1_21 & (l1_data_1_20.data==l1_data_1_21.data) & !l2_almost_full_1_10;
assign l1_newdata_1_20 = l1_valid_1_20 & (l1_data_1_20.data != l1_cache_1_20) & !l1_data_1_20.last;

assign l1_newdata_1_21 = l1_valid_1_21 & (l1_data_1_21.data != l1_cache_1_21) & !l1_data_1_21.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_10[0] = l1_newdata_1_20 & !l2_almost_full_1_10;
    l1_ready_1_20 = l1_grant_1_10[0];       
    l1_req_1_10[1] = l1_newdata_1_21 & !l2_almost_full_1_10;
    l1_ready_1_21 = l1_grant_1_10[1];       
    //sync case
    if(l1_all_last_1_10) begin
        l1_req_1_10 = 0;
        l1_ready_1_20 = 1;
        l1_ready_1_21 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_10)begin
        l1_req_1_10[0] = 1;
        l1_req_1_10[0] = 0;
        l1_ready_1_21 = 1;
    end else begin
        if(l1_valid_1_20 & (l1_data_1_20.data == l1_cache_1_20) & !l1_data_1_20.last)begin
            l1_ready_1_20 = 1;
        end
        if(l1_valid_1_21 & (l1_data_1_21.data == l1_cache_1_21) & !l1_data_1_21.last)begin
            l1_ready_1_21 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_20 <= 0;
        l1_cache_1_21 <= 0;
    end else begin
        if(l1_all_last_1_10)begin
            l1_cache_1_20 <= 0;
            l1_cache_1_21 <= 0;
        end else begin
            if(l1_valid_1_20 & l1_ready_1_20)begin
                l1_cache_1_20 <= l1_data_1_20.data;
            end
            if(l1_valid_1_21 & l1_ready_1_21)begin
                l1_cache_1_21 <= l1_data_1_21.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_10 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_10) begin
            l2_in_valid_1_10 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_10 <= |l1_grant_1_10;
        end
    end
    //sync case
    if(l1_all_last_1_10) begin
        l2_in_data_1_10.last <= 1;
        l2_in_data_1_10.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_10)
            2'b01: l2_in_data_1_10 <= l1_data_1_20;
            2'b10: l2_in_data_1_10 <= l1_data_1_21;
            default: l2_in_data_1_10 <= 0;
        endcase
    end   
end

assign l1_all_last_1_11 = (l1_data_1_22.last & l1_valid_1_22) & (l1_data_1_23.last & l1_valid_1_23) & !l2_almost_full_1_11;
assign l1_same_1_11 = l1_newdata_1_22 & l1_newdata_1_23 & (l1_data_1_22.data==l1_data_1_23.data) & !l2_almost_full_1_11;
assign l1_newdata_1_22 = l1_valid_1_22 & (l1_data_1_22.data != l1_cache_1_22) & !l1_data_1_22.last;

assign l1_newdata_1_23 = l1_valid_1_23 & (l1_data_1_23.data != l1_cache_1_23) & !l1_data_1_23.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_11[0] = l1_newdata_1_22 & !l2_almost_full_1_11;
    l1_ready_1_22 = l1_grant_1_11[0];       
    l1_req_1_11[1] = l1_newdata_1_23 & !l2_almost_full_1_11;
    l1_ready_1_23 = l1_grant_1_11[1];       
    //sync case
    if(l1_all_last_1_11) begin
        l1_req_1_11 = 0;
        l1_ready_1_22 = 1;
        l1_ready_1_23 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_11)begin
        l1_req_1_11[0] = 1;
        l1_req_1_11[0] = 0;
        l1_ready_1_23 = 1;
    end else begin
        if(l1_valid_1_22 & (l1_data_1_22.data == l1_cache_1_22) & !l1_data_1_22.last)begin
            l1_ready_1_22 = 1;
        end
        if(l1_valid_1_23 & (l1_data_1_23.data == l1_cache_1_23) & !l1_data_1_23.last)begin
            l1_ready_1_23 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_22 <= 0;
        l1_cache_1_23 <= 0;
    end else begin
        if(l1_all_last_1_11)begin
            l1_cache_1_22 <= 0;
            l1_cache_1_23 <= 0;
        end else begin
            if(l1_valid_1_22 & l1_ready_1_22)begin
                l1_cache_1_22 <= l1_data_1_22.data;
            end
            if(l1_valid_1_23 & l1_ready_1_23)begin
                l1_cache_1_23 <= l1_data_1_23.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_11 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_11) begin
            l2_in_valid_1_11 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_11 <= |l1_grant_1_11;
        end
    end
    //sync case
    if(l1_all_last_1_11) begin
        l2_in_data_1_11.last <= 1;
        l2_in_data_1_11.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_11)
            2'b01: l2_in_data_1_11 <= l1_data_1_22;
            2'b10: l2_in_data_1_11 <= l1_data_1_23;
            default: l2_in_data_1_11 <= 0;
        endcase
    end   
end

assign l1_all_last_1_12 = (l1_data_1_24.last & l1_valid_1_24) & (l1_data_1_25.last & l1_valid_1_25) & !l2_almost_full_1_12;
assign l1_same_1_12 = l1_newdata_1_24 & l1_newdata_1_25 & (l1_data_1_24.data==l1_data_1_25.data) & !l2_almost_full_1_12;
assign l1_newdata_1_24 = l1_valid_1_24 & (l1_data_1_24.data != l1_cache_1_24) & !l1_data_1_24.last;

assign l1_newdata_1_25 = l1_valid_1_25 & (l1_data_1_25.data != l1_cache_1_25) & !l1_data_1_25.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_12[0] = l1_newdata_1_24 & !l2_almost_full_1_12;
    l1_ready_1_24 = l1_grant_1_12[0];       
    l1_req_1_12[1] = l1_newdata_1_25 & !l2_almost_full_1_12;
    l1_ready_1_25 = l1_grant_1_12[1];       
    //sync case
    if(l1_all_last_1_12) begin
        l1_req_1_12 = 0;
        l1_ready_1_24 = 1;
        l1_ready_1_25 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_12)begin
        l1_req_1_12[0] = 1;
        l1_req_1_12[0] = 0;
        l1_ready_1_25 = 1;
    end else begin
        if(l1_valid_1_24 & (l1_data_1_24.data == l1_cache_1_24) & !l1_data_1_24.last)begin
            l1_ready_1_24 = 1;
        end
        if(l1_valid_1_25 & (l1_data_1_25.data == l1_cache_1_25) & !l1_data_1_25.last)begin
            l1_ready_1_25 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_24 <= 0;
        l1_cache_1_25 <= 0;
    end else begin
        if(l1_all_last_1_12)begin
            l1_cache_1_24 <= 0;
            l1_cache_1_25 <= 0;
        end else begin
            if(l1_valid_1_24 & l1_ready_1_24)begin
                l1_cache_1_24 <= l1_data_1_24.data;
            end
            if(l1_valid_1_25 & l1_ready_1_25)begin
                l1_cache_1_25 <= l1_data_1_25.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_12 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_12) begin
            l2_in_valid_1_12 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_12 <= |l1_grant_1_12;
        end
    end
    //sync case
    if(l1_all_last_1_12) begin
        l2_in_data_1_12.last <= 1;
        l2_in_data_1_12.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_12)
            2'b01: l2_in_data_1_12 <= l1_data_1_24;
            2'b10: l2_in_data_1_12 <= l1_data_1_25;
            default: l2_in_data_1_12 <= 0;
        endcase
    end   
end

assign l1_all_last_1_13 = (l1_data_1_26.last & l1_valid_1_26) & (l1_data_1_27.last & l1_valid_1_27) & !l2_almost_full_1_13;
assign l1_same_1_13 = l1_newdata_1_26 & l1_newdata_1_27 & (l1_data_1_26.data==l1_data_1_27.data) & !l2_almost_full_1_13;
assign l1_newdata_1_26 = l1_valid_1_26 & (l1_data_1_26.data != l1_cache_1_26) & !l1_data_1_26.last;

assign l1_newdata_1_27 = l1_valid_1_27 & (l1_data_1_27.data != l1_cache_1_27) & !l1_data_1_27.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_13[0] = l1_newdata_1_26 & !l2_almost_full_1_13;
    l1_ready_1_26 = l1_grant_1_13[0];       
    l1_req_1_13[1] = l1_newdata_1_27 & !l2_almost_full_1_13;
    l1_ready_1_27 = l1_grant_1_13[1];       
    //sync case
    if(l1_all_last_1_13) begin
        l1_req_1_13 = 0;
        l1_ready_1_26 = 1;
        l1_ready_1_27 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_13)begin
        l1_req_1_13[0] = 1;
        l1_req_1_13[0] = 0;
        l1_ready_1_27 = 1;
    end else begin
        if(l1_valid_1_26 & (l1_data_1_26.data == l1_cache_1_26) & !l1_data_1_26.last)begin
            l1_ready_1_26 = 1;
        end
        if(l1_valid_1_27 & (l1_data_1_27.data == l1_cache_1_27) & !l1_data_1_27.last)begin
            l1_ready_1_27 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_26 <= 0;
        l1_cache_1_27 <= 0;
    end else begin
        if(l1_all_last_1_13)begin
            l1_cache_1_26 <= 0;
            l1_cache_1_27 <= 0;
        end else begin
            if(l1_valid_1_26 & l1_ready_1_26)begin
                l1_cache_1_26 <= l1_data_1_26.data;
            end
            if(l1_valid_1_27 & l1_ready_1_27)begin
                l1_cache_1_27 <= l1_data_1_27.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_13 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_13) begin
            l2_in_valid_1_13 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_13 <= |l1_grant_1_13;
        end
    end
    //sync case
    if(l1_all_last_1_13) begin
        l2_in_data_1_13.last <= 1;
        l2_in_data_1_13.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_13)
            2'b01: l2_in_data_1_13 <= l1_data_1_26;
            2'b10: l2_in_data_1_13 <= l1_data_1_27;
            default: l2_in_data_1_13 <= 0;
        endcase
    end   
end

assign l1_all_last_1_14 = (l1_data_1_28.last & l1_valid_1_28) & (l1_data_1_29.last & l1_valid_1_29) & !l2_almost_full_1_14;
assign l1_same_1_14 = l1_newdata_1_28 & l1_newdata_1_29 & (l1_data_1_28.data==l1_data_1_29.data) & !l2_almost_full_1_14;
assign l1_newdata_1_28 = l1_valid_1_28 & (l1_data_1_28.data != l1_cache_1_28) & !l1_data_1_28.last;

assign l1_newdata_1_29 = l1_valid_1_29 & (l1_data_1_29.data != l1_cache_1_29) & !l1_data_1_29.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_14[0] = l1_newdata_1_28 & !l2_almost_full_1_14;
    l1_ready_1_28 = l1_grant_1_14[0];       
    l1_req_1_14[1] = l1_newdata_1_29 & !l2_almost_full_1_14;
    l1_ready_1_29 = l1_grant_1_14[1];       
    //sync case
    if(l1_all_last_1_14) begin
        l1_req_1_14 = 0;
        l1_ready_1_28 = 1;
        l1_ready_1_29 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_14)begin
        l1_req_1_14[0] = 1;
        l1_req_1_14[0] = 0;
        l1_ready_1_29 = 1;
    end else begin
        if(l1_valid_1_28 & (l1_data_1_28.data == l1_cache_1_28) & !l1_data_1_28.last)begin
            l1_ready_1_28 = 1;
        end
        if(l1_valid_1_29 & (l1_data_1_29.data == l1_cache_1_29) & !l1_data_1_29.last)begin
            l1_ready_1_29 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_28 <= 0;
        l1_cache_1_29 <= 0;
    end else begin
        if(l1_all_last_1_14)begin
            l1_cache_1_28 <= 0;
            l1_cache_1_29 <= 0;
        end else begin
            if(l1_valid_1_28 & l1_ready_1_28)begin
                l1_cache_1_28 <= l1_data_1_28.data;
            end
            if(l1_valid_1_29 & l1_ready_1_29)begin
                l1_cache_1_29 <= l1_data_1_29.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_14 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_14) begin
            l2_in_valid_1_14 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_14 <= |l1_grant_1_14;
        end
    end
    //sync case
    if(l1_all_last_1_14) begin
        l2_in_data_1_14.last <= 1;
        l2_in_data_1_14.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_14)
            2'b01: l2_in_data_1_14 <= l1_data_1_28;
            2'b10: l2_in_data_1_14 <= l1_data_1_29;
            default: l2_in_data_1_14 <= 0;
        endcase
    end   
end

assign l1_all_last_1_15 = (l1_data_1_30.last & l1_valid_1_30) & (l1_data_1_31.last & l1_valid_1_31) & !l2_almost_full_1_15;
assign l1_same_1_15 = l1_newdata_1_30 & l1_newdata_1_31 & (l1_data_1_30.data==l1_data_1_31.data) & !l2_almost_full_1_15;
assign l1_newdata_1_30 = l1_valid_1_30 & (l1_data_1_30.data != l1_cache_1_30) & !l1_data_1_30.last;

assign l1_newdata_1_31 = l1_valid_1_31 & (l1_data_1_31.data != l1_cache_1_31) & !l1_data_1_31.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_1_15[0] = l1_newdata_1_30 & !l2_almost_full_1_15;
    l1_ready_1_30 = l1_grant_1_15[0];       
    l1_req_1_15[1] = l1_newdata_1_31 & !l2_almost_full_1_15;
    l1_ready_1_31 = l1_grant_1_15[1];       
    //sync case
    if(l1_all_last_1_15) begin
        l1_req_1_15 = 0;
        l1_ready_1_30 = 1;
        l1_ready_1_31 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_1_15)begin
        l1_req_1_15[0] = 1;
        l1_req_1_15[0] = 0;
        l1_ready_1_31 = 1;
    end else begin
        if(l1_valid_1_30 & (l1_data_1_30.data == l1_cache_1_30) & !l1_data_1_30.last)begin
            l1_ready_1_30 = 1;
        end
        if(l1_valid_1_31 & (l1_data_1_31.data == l1_cache_1_31) & !l1_data_1_31.last)begin
            l1_ready_1_31 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_1_30 <= 0;
        l1_cache_1_31 <= 0;
    end else begin
        if(l1_all_last_1_15)begin
            l1_cache_1_30 <= 0;
            l1_cache_1_31 <= 0;
        end else begin
            if(l1_valid_1_30 & l1_ready_1_30)begin
                l1_cache_1_30 <= l1_data_1_30.data;
            end
            if(l1_valid_1_31 & l1_ready_1_31)begin
                l1_cache_1_31 <= l1_data_1_31.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_1_15 <= 0;
    end else begin
        //sync case
        if(l1_all_last_1_15) begin
            l2_in_valid_1_15 <= 1;
        //normal case
        end else begin
            l2_in_valid_1_15 <= |l1_grant_1_15;
        end
    end
    //sync case
    if(l1_all_last_1_15) begin
        l2_in_data_1_15.last <= 1;
        l2_in_data_1_15.data <= 0;
    //normal case
    end else begin
        case(l1_grant_1_15)
            2'b01: l2_in_data_1_15 <= l1_data_1_30;
            2'b10: l2_in_data_1_15 <= l1_data_1_31;
            default: l2_in_data_1_15 <= 0;
        endcase
    end   
end

assign l1_all_last_2_0 = (l1_data_2_0.last & l1_valid_2_0) & (l1_data_2_1.last & l1_valid_2_1) & !l2_almost_full_2_0;
assign l1_same_2_0 = l1_newdata_2_0 & l1_newdata_2_1 & (l1_data_2_0.data==l1_data_2_1.data) & !l2_almost_full_2_0;
assign l1_newdata_2_0 = l1_valid_2_0 & (l1_data_2_0.data != l1_cache_2_0) & !l1_data_2_0.last;

assign l1_newdata_2_1 = l1_valid_2_1 & (l1_data_2_1.data != l1_cache_2_1) & !l1_data_2_1.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_0[0] = l1_newdata_2_0 & !l2_almost_full_2_0;
    l1_ready_2_0 = l1_grant_2_0[0];       
    l1_req_2_0[1] = l1_newdata_2_1 & !l2_almost_full_2_0;
    l1_ready_2_1 = l1_grant_2_0[1];       
    //sync case
    if(l1_all_last_2_0) begin
        l1_req_2_0 = 0;
        l1_ready_2_0 = 1;
        l1_ready_2_1 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_0)begin
        l1_req_2_0[0] = 1;
        l1_req_2_0[0] = 0;
        l1_ready_2_1 = 1;
    end else begin
        if(l1_valid_2_0 & (l1_data_2_0.data == l1_cache_2_0) & !l1_data_2_0.last)begin
            l1_ready_2_0 = 1;
        end
        if(l1_valid_2_1 & (l1_data_2_1.data == l1_cache_2_1) & !l1_data_2_1.last)begin
            l1_ready_2_1 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_0 <= 0;
        l1_cache_2_1 <= 0;
    end else begin
        if(l1_all_last_2_0)begin
            l1_cache_2_0 <= 0;
            l1_cache_2_1 <= 0;
        end else begin
            if(l1_valid_2_0 & l1_ready_2_0)begin
                l1_cache_2_0 <= l1_data_2_0.data;
            end
            if(l1_valid_2_1 & l1_ready_2_1)begin
                l1_cache_2_1 <= l1_data_2_1.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_0 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_0) begin
            l2_in_valid_2_0 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_0 <= |l1_grant_2_0;
        end
    end
    //sync case
    if(l1_all_last_2_0) begin
        l2_in_data_2_0.last <= 1;
        l2_in_data_2_0.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_0)
            2'b01: l2_in_data_2_0 <= l1_data_2_0;
            2'b10: l2_in_data_2_0 <= l1_data_2_1;
            default: l2_in_data_2_0 <= 0;
        endcase
    end   
end

assign l1_all_last_2_1 = (l1_data_2_2.last & l1_valid_2_2) & (l1_data_2_3.last & l1_valid_2_3) & !l2_almost_full_2_1;
assign l1_same_2_1 = l1_newdata_2_2 & l1_newdata_2_3 & (l1_data_2_2.data==l1_data_2_3.data) & !l2_almost_full_2_1;
assign l1_newdata_2_2 = l1_valid_2_2 & (l1_data_2_2.data != l1_cache_2_2) & !l1_data_2_2.last;

assign l1_newdata_2_3 = l1_valid_2_3 & (l1_data_2_3.data != l1_cache_2_3) & !l1_data_2_3.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_1[0] = l1_newdata_2_2 & !l2_almost_full_2_1;
    l1_ready_2_2 = l1_grant_2_1[0];       
    l1_req_2_1[1] = l1_newdata_2_3 & !l2_almost_full_2_1;
    l1_ready_2_3 = l1_grant_2_1[1];       
    //sync case
    if(l1_all_last_2_1) begin
        l1_req_2_1 = 0;
        l1_ready_2_2 = 1;
        l1_ready_2_3 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_1)begin
        l1_req_2_1[0] = 1;
        l1_req_2_1[0] = 0;
        l1_ready_2_3 = 1;
    end else begin
        if(l1_valid_2_2 & (l1_data_2_2.data == l1_cache_2_2) & !l1_data_2_2.last)begin
            l1_ready_2_2 = 1;
        end
        if(l1_valid_2_3 & (l1_data_2_3.data == l1_cache_2_3) & !l1_data_2_3.last)begin
            l1_ready_2_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_2 <= 0;
        l1_cache_2_3 <= 0;
    end else begin
        if(l1_all_last_2_1)begin
            l1_cache_2_2 <= 0;
            l1_cache_2_3 <= 0;
        end else begin
            if(l1_valid_2_2 & l1_ready_2_2)begin
                l1_cache_2_2 <= l1_data_2_2.data;
            end
            if(l1_valid_2_3 & l1_ready_2_3)begin
                l1_cache_2_3 <= l1_data_2_3.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_1 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_1) begin
            l2_in_valid_2_1 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_1 <= |l1_grant_2_1;
        end
    end
    //sync case
    if(l1_all_last_2_1) begin
        l2_in_data_2_1.last <= 1;
        l2_in_data_2_1.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_1)
            2'b01: l2_in_data_2_1 <= l1_data_2_2;
            2'b10: l2_in_data_2_1 <= l1_data_2_3;
            default: l2_in_data_2_1 <= 0;
        endcase
    end   
end

assign l1_all_last_2_2 = (l1_data_2_4.last & l1_valid_2_4) & (l1_data_2_5.last & l1_valid_2_5) & !l2_almost_full_2_2;
assign l1_same_2_2 = l1_newdata_2_4 & l1_newdata_2_5 & (l1_data_2_4.data==l1_data_2_5.data) & !l2_almost_full_2_2;
assign l1_newdata_2_4 = l1_valid_2_4 & (l1_data_2_4.data != l1_cache_2_4) & !l1_data_2_4.last;

assign l1_newdata_2_5 = l1_valid_2_5 & (l1_data_2_5.data != l1_cache_2_5) & !l1_data_2_5.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_2[0] = l1_newdata_2_4 & !l2_almost_full_2_2;
    l1_ready_2_4 = l1_grant_2_2[0];       
    l1_req_2_2[1] = l1_newdata_2_5 & !l2_almost_full_2_2;
    l1_ready_2_5 = l1_grant_2_2[1];       
    //sync case
    if(l1_all_last_2_2) begin
        l1_req_2_2 = 0;
        l1_ready_2_4 = 1;
        l1_ready_2_5 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_2)begin
        l1_req_2_2[0] = 1;
        l1_req_2_2[0] = 0;
        l1_ready_2_5 = 1;
    end else begin
        if(l1_valid_2_4 & (l1_data_2_4.data == l1_cache_2_4) & !l1_data_2_4.last)begin
            l1_ready_2_4 = 1;
        end
        if(l1_valid_2_5 & (l1_data_2_5.data == l1_cache_2_5) & !l1_data_2_5.last)begin
            l1_ready_2_5 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_4 <= 0;
        l1_cache_2_5 <= 0;
    end else begin
        if(l1_all_last_2_2)begin
            l1_cache_2_4 <= 0;
            l1_cache_2_5 <= 0;
        end else begin
            if(l1_valid_2_4 & l1_ready_2_4)begin
                l1_cache_2_4 <= l1_data_2_4.data;
            end
            if(l1_valid_2_5 & l1_ready_2_5)begin
                l1_cache_2_5 <= l1_data_2_5.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_2 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_2) begin
            l2_in_valid_2_2 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_2 <= |l1_grant_2_2;
        end
    end
    //sync case
    if(l1_all_last_2_2) begin
        l2_in_data_2_2.last <= 1;
        l2_in_data_2_2.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_2)
            2'b01: l2_in_data_2_2 <= l1_data_2_4;
            2'b10: l2_in_data_2_2 <= l1_data_2_5;
            default: l2_in_data_2_2 <= 0;
        endcase
    end   
end

assign l1_all_last_2_3 = (l1_data_2_6.last & l1_valid_2_6) & (l1_data_2_7.last & l1_valid_2_7) & !l2_almost_full_2_3;
assign l1_same_2_3 = l1_newdata_2_6 & l1_newdata_2_7 & (l1_data_2_6.data==l1_data_2_7.data) & !l2_almost_full_2_3;
assign l1_newdata_2_6 = l1_valid_2_6 & (l1_data_2_6.data != l1_cache_2_6) & !l1_data_2_6.last;

assign l1_newdata_2_7 = l1_valid_2_7 & (l1_data_2_7.data != l1_cache_2_7) & !l1_data_2_7.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_3[0] = l1_newdata_2_6 & !l2_almost_full_2_3;
    l1_ready_2_6 = l1_grant_2_3[0];       
    l1_req_2_3[1] = l1_newdata_2_7 & !l2_almost_full_2_3;
    l1_ready_2_7 = l1_grant_2_3[1];       
    //sync case
    if(l1_all_last_2_3) begin
        l1_req_2_3 = 0;
        l1_ready_2_6 = 1;
        l1_ready_2_7 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_3)begin
        l1_req_2_3[0] = 1;
        l1_req_2_3[0] = 0;
        l1_ready_2_7 = 1;
    end else begin
        if(l1_valid_2_6 & (l1_data_2_6.data == l1_cache_2_6) & !l1_data_2_6.last)begin
            l1_ready_2_6 = 1;
        end
        if(l1_valid_2_7 & (l1_data_2_7.data == l1_cache_2_7) & !l1_data_2_7.last)begin
            l1_ready_2_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_6 <= 0;
        l1_cache_2_7 <= 0;
    end else begin
        if(l1_all_last_2_3)begin
            l1_cache_2_6 <= 0;
            l1_cache_2_7 <= 0;
        end else begin
            if(l1_valid_2_6 & l1_ready_2_6)begin
                l1_cache_2_6 <= l1_data_2_6.data;
            end
            if(l1_valid_2_7 & l1_ready_2_7)begin
                l1_cache_2_7 <= l1_data_2_7.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_3 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_3) begin
            l2_in_valid_2_3 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_3 <= |l1_grant_2_3;
        end
    end
    //sync case
    if(l1_all_last_2_3) begin
        l2_in_data_2_3.last <= 1;
        l2_in_data_2_3.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_3)
            2'b01: l2_in_data_2_3 <= l1_data_2_6;
            2'b10: l2_in_data_2_3 <= l1_data_2_7;
            default: l2_in_data_2_3 <= 0;
        endcase
    end   
end

assign l1_all_last_2_4 = (l1_data_2_8.last & l1_valid_2_8) & (l1_data_2_9.last & l1_valid_2_9) & !l2_almost_full_2_4;
assign l1_same_2_4 = l1_newdata_2_8 & l1_newdata_2_9 & (l1_data_2_8.data==l1_data_2_9.data) & !l2_almost_full_2_4;
assign l1_newdata_2_8 = l1_valid_2_8 & (l1_data_2_8.data != l1_cache_2_8) & !l1_data_2_8.last;

assign l1_newdata_2_9 = l1_valid_2_9 & (l1_data_2_9.data != l1_cache_2_9) & !l1_data_2_9.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_4[0] = l1_newdata_2_8 & !l2_almost_full_2_4;
    l1_ready_2_8 = l1_grant_2_4[0];       
    l1_req_2_4[1] = l1_newdata_2_9 & !l2_almost_full_2_4;
    l1_ready_2_9 = l1_grant_2_4[1];       
    //sync case
    if(l1_all_last_2_4) begin
        l1_req_2_4 = 0;
        l1_ready_2_8 = 1;
        l1_ready_2_9 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_4)begin
        l1_req_2_4[0] = 1;
        l1_req_2_4[0] = 0;
        l1_ready_2_9 = 1;
    end else begin
        if(l1_valid_2_8 & (l1_data_2_8.data == l1_cache_2_8) & !l1_data_2_8.last)begin
            l1_ready_2_8 = 1;
        end
        if(l1_valid_2_9 & (l1_data_2_9.data == l1_cache_2_9) & !l1_data_2_9.last)begin
            l1_ready_2_9 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_8 <= 0;
        l1_cache_2_9 <= 0;
    end else begin
        if(l1_all_last_2_4)begin
            l1_cache_2_8 <= 0;
            l1_cache_2_9 <= 0;
        end else begin
            if(l1_valid_2_8 & l1_ready_2_8)begin
                l1_cache_2_8 <= l1_data_2_8.data;
            end
            if(l1_valid_2_9 & l1_ready_2_9)begin
                l1_cache_2_9 <= l1_data_2_9.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_4 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_4) begin
            l2_in_valid_2_4 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_4 <= |l1_grant_2_4;
        end
    end
    //sync case
    if(l1_all_last_2_4) begin
        l2_in_data_2_4.last <= 1;
        l2_in_data_2_4.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_4)
            2'b01: l2_in_data_2_4 <= l1_data_2_8;
            2'b10: l2_in_data_2_4 <= l1_data_2_9;
            default: l2_in_data_2_4 <= 0;
        endcase
    end   
end

assign l1_all_last_2_5 = (l1_data_2_10.last & l1_valid_2_10) & (l1_data_2_11.last & l1_valid_2_11) & !l2_almost_full_2_5;
assign l1_same_2_5 = l1_newdata_2_10 & l1_newdata_2_11 & (l1_data_2_10.data==l1_data_2_11.data) & !l2_almost_full_2_5;
assign l1_newdata_2_10 = l1_valid_2_10 & (l1_data_2_10.data != l1_cache_2_10) & !l1_data_2_10.last;

assign l1_newdata_2_11 = l1_valid_2_11 & (l1_data_2_11.data != l1_cache_2_11) & !l1_data_2_11.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_5[0] = l1_newdata_2_10 & !l2_almost_full_2_5;
    l1_ready_2_10 = l1_grant_2_5[0];       
    l1_req_2_5[1] = l1_newdata_2_11 & !l2_almost_full_2_5;
    l1_ready_2_11 = l1_grant_2_5[1];       
    //sync case
    if(l1_all_last_2_5) begin
        l1_req_2_5 = 0;
        l1_ready_2_10 = 1;
        l1_ready_2_11 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_5)begin
        l1_req_2_5[0] = 1;
        l1_req_2_5[0] = 0;
        l1_ready_2_11 = 1;
    end else begin
        if(l1_valid_2_10 & (l1_data_2_10.data == l1_cache_2_10) & !l1_data_2_10.last)begin
            l1_ready_2_10 = 1;
        end
        if(l1_valid_2_11 & (l1_data_2_11.data == l1_cache_2_11) & !l1_data_2_11.last)begin
            l1_ready_2_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_10 <= 0;
        l1_cache_2_11 <= 0;
    end else begin
        if(l1_all_last_2_5)begin
            l1_cache_2_10 <= 0;
            l1_cache_2_11 <= 0;
        end else begin
            if(l1_valid_2_10 & l1_ready_2_10)begin
                l1_cache_2_10 <= l1_data_2_10.data;
            end
            if(l1_valid_2_11 & l1_ready_2_11)begin
                l1_cache_2_11 <= l1_data_2_11.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_5 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_5) begin
            l2_in_valid_2_5 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_5 <= |l1_grant_2_5;
        end
    end
    //sync case
    if(l1_all_last_2_5) begin
        l2_in_data_2_5.last <= 1;
        l2_in_data_2_5.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_5)
            2'b01: l2_in_data_2_5 <= l1_data_2_10;
            2'b10: l2_in_data_2_5 <= l1_data_2_11;
            default: l2_in_data_2_5 <= 0;
        endcase
    end   
end

assign l1_all_last_2_6 = (l1_data_2_12.last & l1_valid_2_12) & (l1_data_2_13.last & l1_valid_2_13) & !l2_almost_full_2_6;
assign l1_same_2_6 = l1_newdata_2_12 & l1_newdata_2_13 & (l1_data_2_12.data==l1_data_2_13.data) & !l2_almost_full_2_6;
assign l1_newdata_2_12 = l1_valid_2_12 & (l1_data_2_12.data != l1_cache_2_12) & !l1_data_2_12.last;

assign l1_newdata_2_13 = l1_valid_2_13 & (l1_data_2_13.data != l1_cache_2_13) & !l1_data_2_13.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_6[0] = l1_newdata_2_12 & !l2_almost_full_2_6;
    l1_ready_2_12 = l1_grant_2_6[0];       
    l1_req_2_6[1] = l1_newdata_2_13 & !l2_almost_full_2_6;
    l1_ready_2_13 = l1_grant_2_6[1];       
    //sync case
    if(l1_all_last_2_6) begin
        l1_req_2_6 = 0;
        l1_ready_2_12 = 1;
        l1_ready_2_13 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_6)begin
        l1_req_2_6[0] = 1;
        l1_req_2_6[0] = 0;
        l1_ready_2_13 = 1;
    end else begin
        if(l1_valid_2_12 & (l1_data_2_12.data == l1_cache_2_12) & !l1_data_2_12.last)begin
            l1_ready_2_12 = 1;
        end
        if(l1_valid_2_13 & (l1_data_2_13.data == l1_cache_2_13) & !l1_data_2_13.last)begin
            l1_ready_2_13 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_12 <= 0;
        l1_cache_2_13 <= 0;
    end else begin
        if(l1_all_last_2_6)begin
            l1_cache_2_12 <= 0;
            l1_cache_2_13 <= 0;
        end else begin
            if(l1_valid_2_12 & l1_ready_2_12)begin
                l1_cache_2_12 <= l1_data_2_12.data;
            end
            if(l1_valid_2_13 & l1_ready_2_13)begin
                l1_cache_2_13 <= l1_data_2_13.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_6 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_6) begin
            l2_in_valid_2_6 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_6 <= |l1_grant_2_6;
        end
    end
    //sync case
    if(l1_all_last_2_6) begin
        l2_in_data_2_6.last <= 1;
        l2_in_data_2_6.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_6)
            2'b01: l2_in_data_2_6 <= l1_data_2_12;
            2'b10: l2_in_data_2_6 <= l1_data_2_13;
            default: l2_in_data_2_6 <= 0;
        endcase
    end   
end

assign l1_all_last_2_7 = (l1_data_2_14.last & l1_valid_2_14) & (l1_data_2_15.last & l1_valid_2_15) & !l2_almost_full_2_7;
assign l1_same_2_7 = l1_newdata_2_14 & l1_newdata_2_15 & (l1_data_2_14.data==l1_data_2_15.data) & !l2_almost_full_2_7;
assign l1_newdata_2_14 = l1_valid_2_14 & (l1_data_2_14.data != l1_cache_2_14) & !l1_data_2_14.last;

assign l1_newdata_2_15 = l1_valid_2_15 & (l1_data_2_15.data != l1_cache_2_15) & !l1_data_2_15.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_7[0] = l1_newdata_2_14 & !l2_almost_full_2_7;
    l1_ready_2_14 = l1_grant_2_7[0];       
    l1_req_2_7[1] = l1_newdata_2_15 & !l2_almost_full_2_7;
    l1_ready_2_15 = l1_grant_2_7[1];       
    //sync case
    if(l1_all_last_2_7) begin
        l1_req_2_7 = 0;
        l1_ready_2_14 = 1;
        l1_ready_2_15 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_7)begin
        l1_req_2_7[0] = 1;
        l1_req_2_7[0] = 0;
        l1_ready_2_15 = 1;
    end else begin
        if(l1_valid_2_14 & (l1_data_2_14.data == l1_cache_2_14) & !l1_data_2_14.last)begin
            l1_ready_2_14 = 1;
        end
        if(l1_valid_2_15 & (l1_data_2_15.data == l1_cache_2_15) & !l1_data_2_15.last)begin
            l1_ready_2_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_14 <= 0;
        l1_cache_2_15 <= 0;
    end else begin
        if(l1_all_last_2_7)begin
            l1_cache_2_14 <= 0;
            l1_cache_2_15 <= 0;
        end else begin
            if(l1_valid_2_14 & l1_ready_2_14)begin
                l1_cache_2_14 <= l1_data_2_14.data;
            end
            if(l1_valid_2_15 & l1_ready_2_15)begin
                l1_cache_2_15 <= l1_data_2_15.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_7 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_7) begin
            l2_in_valid_2_7 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_7 <= |l1_grant_2_7;
        end
    end
    //sync case
    if(l1_all_last_2_7) begin
        l2_in_data_2_7.last <= 1;
        l2_in_data_2_7.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_7)
            2'b01: l2_in_data_2_7 <= l1_data_2_14;
            2'b10: l2_in_data_2_7 <= l1_data_2_15;
            default: l2_in_data_2_7 <= 0;
        endcase
    end   
end

assign l1_all_last_2_8 = (l1_data_2_16.last & l1_valid_2_16) & (l1_data_2_17.last & l1_valid_2_17) & !l2_almost_full_2_8;
assign l1_same_2_8 = l1_newdata_2_16 & l1_newdata_2_17 & (l1_data_2_16.data==l1_data_2_17.data) & !l2_almost_full_2_8;
assign l1_newdata_2_16 = l1_valid_2_16 & (l1_data_2_16.data != l1_cache_2_16) & !l1_data_2_16.last;

assign l1_newdata_2_17 = l1_valid_2_17 & (l1_data_2_17.data != l1_cache_2_17) & !l1_data_2_17.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_8[0] = l1_newdata_2_16 & !l2_almost_full_2_8;
    l1_ready_2_16 = l1_grant_2_8[0];       
    l1_req_2_8[1] = l1_newdata_2_17 & !l2_almost_full_2_8;
    l1_ready_2_17 = l1_grant_2_8[1];       
    //sync case
    if(l1_all_last_2_8) begin
        l1_req_2_8 = 0;
        l1_ready_2_16 = 1;
        l1_ready_2_17 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_8)begin
        l1_req_2_8[0] = 1;
        l1_req_2_8[0] = 0;
        l1_ready_2_17 = 1;
    end else begin
        if(l1_valid_2_16 & (l1_data_2_16.data == l1_cache_2_16) & !l1_data_2_16.last)begin
            l1_ready_2_16 = 1;
        end
        if(l1_valid_2_17 & (l1_data_2_17.data == l1_cache_2_17) & !l1_data_2_17.last)begin
            l1_ready_2_17 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_16 <= 0;
        l1_cache_2_17 <= 0;
    end else begin
        if(l1_all_last_2_8)begin
            l1_cache_2_16 <= 0;
            l1_cache_2_17 <= 0;
        end else begin
            if(l1_valid_2_16 & l1_ready_2_16)begin
                l1_cache_2_16 <= l1_data_2_16.data;
            end
            if(l1_valid_2_17 & l1_ready_2_17)begin
                l1_cache_2_17 <= l1_data_2_17.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_8 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_8) begin
            l2_in_valid_2_8 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_8 <= |l1_grant_2_8;
        end
    end
    //sync case
    if(l1_all_last_2_8) begin
        l2_in_data_2_8.last <= 1;
        l2_in_data_2_8.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_8)
            2'b01: l2_in_data_2_8 <= l1_data_2_16;
            2'b10: l2_in_data_2_8 <= l1_data_2_17;
            default: l2_in_data_2_8 <= 0;
        endcase
    end   
end

assign l1_all_last_2_9 = (l1_data_2_18.last & l1_valid_2_18) & (l1_data_2_19.last & l1_valid_2_19) & !l2_almost_full_2_9;
assign l1_same_2_9 = l1_newdata_2_18 & l1_newdata_2_19 & (l1_data_2_18.data==l1_data_2_19.data) & !l2_almost_full_2_9;
assign l1_newdata_2_18 = l1_valid_2_18 & (l1_data_2_18.data != l1_cache_2_18) & !l1_data_2_18.last;

assign l1_newdata_2_19 = l1_valid_2_19 & (l1_data_2_19.data != l1_cache_2_19) & !l1_data_2_19.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_9[0] = l1_newdata_2_18 & !l2_almost_full_2_9;
    l1_ready_2_18 = l1_grant_2_9[0];       
    l1_req_2_9[1] = l1_newdata_2_19 & !l2_almost_full_2_9;
    l1_ready_2_19 = l1_grant_2_9[1];       
    //sync case
    if(l1_all_last_2_9) begin
        l1_req_2_9 = 0;
        l1_ready_2_18 = 1;
        l1_ready_2_19 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_9)begin
        l1_req_2_9[0] = 1;
        l1_req_2_9[0] = 0;
        l1_ready_2_19 = 1;
    end else begin
        if(l1_valid_2_18 & (l1_data_2_18.data == l1_cache_2_18) & !l1_data_2_18.last)begin
            l1_ready_2_18 = 1;
        end
        if(l1_valid_2_19 & (l1_data_2_19.data == l1_cache_2_19) & !l1_data_2_19.last)begin
            l1_ready_2_19 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_18 <= 0;
        l1_cache_2_19 <= 0;
    end else begin
        if(l1_all_last_2_9)begin
            l1_cache_2_18 <= 0;
            l1_cache_2_19 <= 0;
        end else begin
            if(l1_valid_2_18 & l1_ready_2_18)begin
                l1_cache_2_18 <= l1_data_2_18.data;
            end
            if(l1_valid_2_19 & l1_ready_2_19)begin
                l1_cache_2_19 <= l1_data_2_19.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_9 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_9) begin
            l2_in_valid_2_9 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_9 <= |l1_grant_2_9;
        end
    end
    //sync case
    if(l1_all_last_2_9) begin
        l2_in_data_2_9.last <= 1;
        l2_in_data_2_9.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_9)
            2'b01: l2_in_data_2_9 <= l1_data_2_18;
            2'b10: l2_in_data_2_9 <= l1_data_2_19;
            default: l2_in_data_2_9 <= 0;
        endcase
    end   
end

assign l1_all_last_2_10 = (l1_data_2_20.last & l1_valid_2_20) & (l1_data_2_21.last & l1_valid_2_21) & !l2_almost_full_2_10;
assign l1_same_2_10 = l1_newdata_2_20 & l1_newdata_2_21 & (l1_data_2_20.data==l1_data_2_21.data) & !l2_almost_full_2_10;
assign l1_newdata_2_20 = l1_valid_2_20 & (l1_data_2_20.data != l1_cache_2_20) & !l1_data_2_20.last;

assign l1_newdata_2_21 = l1_valid_2_21 & (l1_data_2_21.data != l1_cache_2_21) & !l1_data_2_21.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_10[0] = l1_newdata_2_20 & !l2_almost_full_2_10;
    l1_ready_2_20 = l1_grant_2_10[0];       
    l1_req_2_10[1] = l1_newdata_2_21 & !l2_almost_full_2_10;
    l1_ready_2_21 = l1_grant_2_10[1];       
    //sync case
    if(l1_all_last_2_10) begin
        l1_req_2_10 = 0;
        l1_ready_2_20 = 1;
        l1_ready_2_21 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_10)begin
        l1_req_2_10[0] = 1;
        l1_req_2_10[0] = 0;
        l1_ready_2_21 = 1;
    end else begin
        if(l1_valid_2_20 & (l1_data_2_20.data == l1_cache_2_20) & !l1_data_2_20.last)begin
            l1_ready_2_20 = 1;
        end
        if(l1_valid_2_21 & (l1_data_2_21.data == l1_cache_2_21) & !l1_data_2_21.last)begin
            l1_ready_2_21 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_20 <= 0;
        l1_cache_2_21 <= 0;
    end else begin
        if(l1_all_last_2_10)begin
            l1_cache_2_20 <= 0;
            l1_cache_2_21 <= 0;
        end else begin
            if(l1_valid_2_20 & l1_ready_2_20)begin
                l1_cache_2_20 <= l1_data_2_20.data;
            end
            if(l1_valid_2_21 & l1_ready_2_21)begin
                l1_cache_2_21 <= l1_data_2_21.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_10 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_10) begin
            l2_in_valid_2_10 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_10 <= |l1_grant_2_10;
        end
    end
    //sync case
    if(l1_all_last_2_10) begin
        l2_in_data_2_10.last <= 1;
        l2_in_data_2_10.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_10)
            2'b01: l2_in_data_2_10 <= l1_data_2_20;
            2'b10: l2_in_data_2_10 <= l1_data_2_21;
            default: l2_in_data_2_10 <= 0;
        endcase
    end   
end

assign l1_all_last_2_11 = (l1_data_2_22.last & l1_valid_2_22) & (l1_data_2_23.last & l1_valid_2_23) & !l2_almost_full_2_11;
assign l1_same_2_11 = l1_newdata_2_22 & l1_newdata_2_23 & (l1_data_2_22.data==l1_data_2_23.data) & !l2_almost_full_2_11;
assign l1_newdata_2_22 = l1_valid_2_22 & (l1_data_2_22.data != l1_cache_2_22) & !l1_data_2_22.last;

assign l1_newdata_2_23 = l1_valid_2_23 & (l1_data_2_23.data != l1_cache_2_23) & !l1_data_2_23.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_11[0] = l1_newdata_2_22 & !l2_almost_full_2_11;
    l1_ready_2_22 = l1_grant_2_11[0];       
    l1_req_2_11[1] = l1_newdata_2_23 & !l2_almost_full_2_11;
    l1_ready_2_23 = l1_grant_2_11[1];       
    //sync case
    if(l1_all_last_2_11) begin
        l1_req_2_11 = 0;
        l1_ready_2_22 = 1;
        l1_ready_2_23 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_11)begin
        l1_req_2_11[0] = 1;
        l1_req_2_11[0] = 0;
        l1_ready_2_23 = 1;
    end else begin
        if(l1_valid_2_22 & (l1_data_2_22.data == l1_cache_2_22) & !l1_data_2_22.last)begin
            l1_ready_2_22 = 1;
        end
        if(l1_valid_2_23 & (l1_data_2_23.data == l1_cache_2_23) & !l1_data_2_23.last)begin
            l1_ready_2_23 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_22 <= 0;
        l1_cache_2_23 <= 0;
    end else begin
        if(l1_all_last_2_11)begin
            l1_cache_2_22 <= 0;
            l1_cache_2_23 <= 0;
        end else begin
            if(l1_valid_2_22 & l1_ready_2_22)begin
                l1_cache_2_22 <= l1_data_2_22.data;
            end
            if(l1_valid_2_23 & l1_ready_2_23)begin
                l1_cache_2_23 <= l1_data_2_23.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_11 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_11) begin
            l2_in_valid_2_11 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_11 <= |l1_grant_2_11;
        end
    end
    //sync case
    if(l1_all_last_2_11) begin
        l2_in_data_2_11.last <= 1;
        l2_in_data_2_11.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_11)
            2'b01: l2_in_data_2_11 <= l1_data_2_22;
            2'b10: l2_in_data_2_11 <= l1_data_2_23;
            default: l2_in_data_2_11 <= 0;
        endcase
    end   
end

assign l1_all_last_2_12 = (l1_data_2_24.last & l1_valid_2_24) & (l1_data_2_25.last & l1_valid_2_25) & !l2_almost_full_2_12;
assign l1_same_2_12 = l1_newdata_2_24 & l1_newdata_2_25 & (l1_data_2_24.data==l1_data_2_25.data) & !l2_almost_full_2_12;
assign l1_newdata_2_24 = l1_valid_2_24 & (l1_data_2_24.data != l1_cache_2_24) & !l1_data_2_24.last;

assign l1_newdata_2_25 = l1_valid_2_25 & (l1_data_2_25.data != l1_cache_2_25) & !l1_data_2_25.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_12[0] = l1_newdata_2_24 & !l2_almost_full_2_12;
    l1_ready_2_24 = l1_grant_2_12[0];       
    l1_req_2_12[1] = l1_newdata_2_25 & !l2_almost_full_2_12;
    l1_ready_2_25 = l1_grant_2_12[1];       
    //sync case
    if(l1_all_last_2_12) begin
        l1_req_2_12 = 0;
        l1_ready_2_24 = 1;
        l1_ready_2_25 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_12)begin
        l1_req_2_12[0] = 1;
        l1_req_2_12[0] = 0;
        l1_ready_2_25 = 1;
    end else begin
        if(l1_valid_2_24 & (l1_data_2_24.data == l1_cache_2_24) & !l1_data_2_24.last)begin
            l1_ready_2_24 = 1;
        end
        if(l1_valid_2_25 & (l1_data_2_25.data == l1_cache_2_25) & !l1_data_2_25.last)begin
            l1_ready_2_25 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_24 <= 0;
        l1_cache_2_25 <= 0;
    end else begin
        if(l1_all_last_2_12)begin
            l1_cache_2_24 <= 0;
            l1_cache_2_25 <= 0;
        end else begin
            if(l1_valid_2_24 & l1_ready_2_24)begin
                l1_cache_2_24 <= l1_data_2_24.data;
            end
            if(l1_valid_2_25 & l1_ready_2_25)begin
                l1_cache_2_25 <= l1_data_2_25.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_12 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_12) begin
            l2_in_valid_2_12 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_12 <= |l1_grant_2_12;
        end
    end
    //sync case
    if(l1_all_last_2_12) begin
        l2_in_data_2_12.last <= 1;
        l2_in_data_2_12.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_12)
            2'b01: l2_in_data_2_12 <= l1_data_2_24;
            2'b10: l2_in_data_2_12 <= l1_data_2_25;
            default: l2_in_data_2_12 <= 0;
        endcase
    end   
end

assign l1_all_last_2_13 = (l1_data_2_26.last & l1_valid_2_26) & (l1_data_2_27.last & l1_valid_2_27) & !l2_almost_full_2_13;
assign l1_same_2_13 = l1_newdata_2_26 & l1_newdata_2_27 & (l1_data_2_26.data==l1_data_2_27.data) & !l2_almost_full_2_13;
assign l1_newdata_2_26 = l1_valid_2_26 & (l1_data_2_26.data != l1_cache_2_26) & !l1_data_2_26.last;

assign l1_newdata_2_27 = l1_valid_2_27 & (l1_data_2_27.data != l1_cache_2_27) & !l1_data_2_27.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_13[0] = l1_newdata_2_26 & !l2_almost_full_2_13;
    l1_ready_2_26 = l1_grant_2_13[0];       
    l1_req_2_13[1] = l1_newdata_2_27 & !l2_almost_full_2_13;
    l1_ready_2_27 = l1_grant_2_13[1];       
    //sync case
    if(l1_all_last_2_13) begin
        l1_req_2_13 = 0;
        l1_ready_2_26 = 1;
        l1_ready_2_27 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_13)begin
        l1_req_2_13[0] = 1;
        l1_req_2_13[0] = 0;
        l1_ready_2_27 = 1;
    end else begin
        if(l1_valid_2_26 & (l1_data_2_26.data == l1_cache_2_26) & !l1_data_2_26.last)begin
            l1_ready_2_26 = 1;
        end
        if(l1_valid_2_27 & (l1_data_2_27.data == l1_cache_2_27) & !l1_data_2_27.last)begin
            l1_ready_2_27 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_26 <= 0;
        l1_cache_2_27 <= 0;
    end else begin
        if(l1_all_last_2_13)begin
            l1_cache_2_26 <= 0;
            l1_cache_2_27 <= 0;
        end else begin
            if(l1_valid_2_26 & l1_ready_2_26)begin
                l1_cache_2_26 <= l1_data_2_26.data;
            end
            if(l1_valid_2_27 & l1_ready_2_27)begin
                l1_cache_2_27 <= l1_data_2_27.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_13 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_13) begin
            l2_in_valid_2_13 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_13 <= |l1_grant_2_13;
        end
    end
    //sync case
    if(l1_all_last_2_13) begin
        l2_in_data_2_13.last <= 1;
        l2_in_data_2_13.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_13)
            2'b01: l2_in_data_2_13 <= l1_data_2_26;
            2'b10: l2_in_data_2_13 <= l1_data_2_27;
            default: l2_in_data_2_13 <= 0;
        endcase
    end   
end

assign l1_all_last_2_14 = (l1_data_2_28.last & l1_valid_2_28) & (l1_data_2_29.last & l1_valid_2_29) & !l2_almost_full_2_14;
assign l1_same_2_14 = l1_newdata_2_28 & l1_newdata_2_29 & (l1_data_2_28.data==l1_data_2_29.data) & !l2_almost_full_2_14;
assign l1_newdata_2_28 = l1_valid_2_28 & (l1_data_2_28.data != l1_cache_2_28) & !l1_data_2_28.last;

assign l1_newdata_2_29 = l1_valid_2_29 & (l1_data_2_29.data != l1_cache_2_29) & !l1_data_2_29.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_14[0] = l1_newdata_2_28 & !l2_almost_full_2_14;
    l1_ready_2_28 = l1_grant_2_14[0];       
    l1_req_2_14[1] = l1_newdata_2_29 & !l2_almost_full_2_14;
    l1_ready_2_29 = l1_grant_2_14[1];       
    //sync case
    if(l1_all_last_2_14) begin
        l1_req_2_14 = 0;
        l1_ready_2_28 = 1;
        l1_ready_2_29 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_14)begin
        l1_req_2_14[0] = 1;
        l1_req_2_14[0] = 0;
        l1_ready_2_29 = 1;
    end else begin
        if(l1_valid_2_28 & (l1_data_2_28.data == l1_cache_2_28) & !l1_data_2_28.last)begin
            l1_ready_2_28 = 1;
        end
        if(l1_valid_2_29 & (l1_data_2_29.data == l1_cache_2_29) & !l1_data_2_29.last)begin
            l1_ready_2_29 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_28 <= 0;
        l1_cache_2_29 <= 0;
    end else begin
        if(l1_all_last_2_14)begin
            l1_cache_2_28 <= 0;
            l1_cache_2_29 <= 0;
        end else begin
            if(l1_valid_2_28 & l1_ready_2_28)begin
                l1_cache_2_28 <= l1_data_2_28.data;
            end
            if(l1_valid_2_29 & l1_ready_2_29)begin
                l1_cache_2_29 <= l1_data_2_29.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_14 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_14) begin
            l2_in_valid_2_14 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_14 <= |l1_grant_2_14;
        end
    end
    //sync case
    if(l1_all_last_2_14) begin
        l2_in_data_2_14.last <= 1;
        l2_in_data_2_14.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_14)
            2'b01: l2_in_data_2_14 <= l1_data_2_28;
            2'b10: l2_in_data_2_14 <= l1_data_2_29;
            default: l2_in_data_2_14 <= 0;
        endcase
    end   
end

assign l1_all_last_2_15 = (l1_data_2_30.last & l1_valid_2_30) & (l1_data_2_31.last & l1_valid_2_31) & !l2_almost_full_2_15;
assign l1_same_2_15 = l1_newdata_2_30 & l1_newdata_2_31 & (l1_data_2_30.data==l1_data_2_31.data) & !l2_almost_full_2_15;
assign l1_newdata_2_30 = l1_valid_2_30 & (l1_data_2_30.data != l1_cache_2_30) & !l1_data_2_30.last;

assign l1_newdata_2_31 = l1_valid_2_31 & (l1_data_2_31.data != l1_cache_2_31) & !l1_data_2_31.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_2_15[0] = l1_newdata_2_30 & !l2_almost_full_2_15;
    l1_ready_2_30 = l1_grant_2_15[0];       
    l1_req_2_15[1] = l1_newdata_2_31 & !l2_almost_full_2_15;
    l1_ready_2_31 = l1_grant_2_15[1];       
    //sync case
    if(l1_all_last_2_15) begin
        l1_req_2_15 = 0;
        l1_ready_2_30 = 1;
        l1_ready_2_31 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_2_15)begin
        l1_req_2_15[0] = 1;
        l1_req_2_15[0] = 0;
        l1_ready_2_31 = 1;
    end else begin
        if(l1_valid_2_30 & (l1_data_2_30.data == l1_cache_2_30) & !l1_data_2_30.last)begin
            l1_ready_2_30 = 1;
        end
        if(l1_valid_2_31 & (l1_data_2_31.data == l1_cache_2_31) & !l1_data_2_31.last)begin
            l1_ready_2_31 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_2_30 <= 0;
        l1_cache_2_31 <= 0;
    end else begin
        if(l1_all_last_2_15)begin
            l1_cache_2_30 <= 0;
            l1_cache_2_31 <= 0;
        end else begin
            if(l1_valid_2_30 & l1_ready_2_30)begin
                l1_cache_2_30 <= l1_data_2_30.data;
            end
            if(l1_valid_2_31 & l1_ready_2_31)begin
                l1_cache_2_31 <= l1_data_2_31.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_2_15 <= 0;
    end else begin
        //sync case
        if(l1_all_last_2_15) begin
            l2_in_valid_2_15 <= 1;
        //normal case
        end else begin
            l2_in_valid_2_15 <= |l1_grant_2_15;
        end
    end
    //sync case
    if(l1_all_last_2_15) begin
        l2_in_data_2_15.last <= 1;
        l2_in_data_2_15.data <= 0;
    //normal case
    end else begin
        case(l1_grant_2_15)
            2'b01: l2_in_data_2_15 <= l1_data_2_30;
            2'b10: l2_in_data_2_15 <= l1_data_2_31;
            default: l2_in_data_2_15 <= 0;
        endcase
    end   
end

assign l1_all_last_3_0 = (l1_data_3_0.last & l1_valid_3_0) & (l1_data_3_1.last & l1_valid_3_1) & !l2_almost_full_3_0;
assign l1_same_3_0 = l1_newdata_3_0 & l1_newdata_3_1 & (l1_data_3_0.data==l1_data_3_1.data) & !l2_almost_full_3_0;
assign l1_newdata_3_0 = l1_valid_3_0 & (l1_data_3_0.data != l1_cache_3_0) & !l1_data_3_0.last;

assign l1_newdata_3_1 = l1_valid_3_1 & (l1_data_3_1.data != l1_cache_3_1) & !l1_data_3_1.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_0[0] = l1_newdata_3_0 & !l2_almost_full_3_0;
    l1_ready_3_0 = l1_grant_3_0[0];       
    l1_req_3_0[1] = l1_newdata_3_1 & !l2_almost_full_3_0;
    l1_ready_3_1 = l1_grant_3_0[1];       
    //sync case
    if(l1_all_last_3_0) begin
        l1_req_3_0 = 0;
        l1_ready_3_0 = 1;
        l1_ready_3_1 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_0)begin
        l1_req_3_0[0] = 1;
        l1_req_3_0[0] = 0;
        l1_ready_3_1 = 1;
    end else begin
        if(l1_valid_3_0 & (l1_data_3_0.data == l1_cache_3_0) & !l1_data_3_0.last)begin
            l1_ready_3_0 = 1;
        end
        if(l1_valid_3_1 & (l1_data_3_1.data == l1_cache_3_1) & !l1_data_3_1.last)begin
            l1_ready_3_1 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_0 <= 0;
        l1_cache_3_1 <= 0;
    end else begin
        if(l1_all_last_3_0)begin
            l1_cache_3_0 <= 0;
            l1_cache_3_1 <= 0;
        end else begin
            if(l1_valid_3_0 & l1_ready_3_0)begin
                l1_cache_3_0 <= l1_data_3_0.data;
            end
            if(l1_valid_3_1 & l1_ready_3_1)begin
                l1_cache_3_1 <= l1_data_3_1.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_0 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_0) begin
            l2_in_valid_3_0 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_0 <= |l1_grant_3_0;
        end
    end
    //sync case
    if(l1_all_last_3_0) begin
        l2_in_data_3_0.last <= 1;
        l2_in_data_3_0.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_0)
            2'b01: l2_in_data_3_0 <= l1_data_3_0;
            2'b10: l2_in_data_3_0 <= l1_data_3_1;
            default: l2_in_data_3_0 <= 0;
        endcase
    end   
end

assign l1_all_last_3_1 = (l1_data_3_2.last & l1_valid_3_2) & (l1_data_3_3.last & l1_valid_3_3) & !l2_almost_full_3_1;
assign l1_same_3_1 = l1_newdata_3_2 & l1_newdata_3_3 & (l1_data_3_2.data==l1_data_3_3.data) & !l2_almost_full_3_1;
assign l1_newdata_3_2 = l1_valid_3_2 & (l1_data_3_2.data != l1_cache_3_2) & !l1_data_3_2.last;

assign l1_newdata_3_3 = l1_valid_3_3 & (l1_data_3_3.data != l1_cache_3_3) & !l1_data_3_3.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_1[0] = l1_newdata_3_2 & !l2_almost_full_3_1;
    l1_ready_3_2 = l1_grant_3_1[0];       
    l1_req_3_1[1] = l1_newdata_3_3 & !l2_almost_full_3_1;
    l1_ready_3_3 = l1_grant_3_1[1];       
    //sync case
    if(l1_all_last_3_1) begin
        l1_req_3_1 = 0;
        l1_ready_3_2 = 1;
        l1_ready_3_3 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_1)begin
        l1_req_3_1[0] = 1;
        l1_req_3_1[0] = 0;
        l1_ready_3_3 = 1;
    end else begin
        if(l1_valid_3_2 & (l1_data_3_2.data == l1_cache_3_2) & !l1_data_3_2.last)begin
            l1_ready_3_2 = 1;
        end
        if(l1_valid_3_3 & (l1_data_3_3.data == l1_cache_3_3) & !l1_data_3_3.last)begin
            l1_ready_3_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_2 <= 0;
        l1_cache_3_3 <= 0;
    end else begin
        if(l1_all_last_3_1)begin
            l1_cache_3_2 <= 0;
            l1_cache_3_3 <= 0;
        end else begin
            if(l1_valid_3_2 & l1_ready_3_2)begin
                l1_cache_3_2 <= l1_data_3_2.data;
            end
            if(l1_valid_3_3 & l1_ready_3_3)begin
                l1_cache_3_3 <= l1_data_3_3.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_1 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_1) begin
            l2_in_valid_3_1 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_1 <= |l1_grant_3_1;
        end
    end
    //sync case
    if(l1_all_last_3_1) begin
        l2_in_data_3_1.last <= 1;
        l2_in_data_3_1.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_1)
            2'b01: l2_in_data_3_1 <= l1_data_3_2;
            2'b10: l2_in_data_3_1 <= l1_data_3_3;
            default: l2_in_data_3_1 <= 0;
        endcase
    end   
end

assign l1_all_last_3_2 = (l1_data_3_4.last & l1_valid_3_4) & (l1_data_3_5.last & l1_valid_3_5) & !l2_almost_full_3_2;
assign l1_same_3_2 = l1_newdata_3_4 & l1_newdata_3_5 & (l1_data_3_4.data==l1_data_3_5.data) & !l2_almost_full_3_2;
assign l1_newdata_3_4 = l1_valid_3_4 & (l1_data_3_4.data != l1_cache_3_4) & !l1_data_3_4.last;

assign l1_newdata_3_5 = l1_valid_3_5 & (l1_data_3_5.data != l1_cache_3_5) & !l1_data_3_5.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_2[0] = l1_newdata_3_4 & !l2_almost_full_3_2;
    l1_ready_3_4 = l1_grant_3_2[0];       
    l1_req_3_2[1] = l1_newdata_3_5 & !l2_almost_full_3_2;
    l1_ready_3_5 = l1_grant_3_2[1];       
    //sync case
    if(l1_all_last_3_2) begin
        l1_req_3_2 = 0;
        l1_ready_3_4 = 1;
        l1_ready_3_5 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_2)begin
        l1_req_3_2[0] = 1;
        l1_req_3_2[0] = 0;
        l1_ready_3_5 = 1;
    end else begin
        if(l1_valid_3_4 & (l1_data_3_4.data == l1_cache_3_4) & !l1_data_3_4.last)begin
            l1_ready_3_4 = 1;
        end
        if(l1_valid_3_5 & (l1_data_3_5.data == l1_cache_3_5) & !l1_data_3_5.last)begin
            l1_ready_3_5 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_4 <= 0;
        l1_cache_3_5 <= 0;
    end else begin
        if(l1_all_last_3_2)begin
            l1_cache_3_4 <= 0;
            l1_cache_3_5 <= 0;
        end else begin
            if(l1_valid_3_4 & l1_ready_3_4)begin
                l1_cache_3_4 <= l1_data_3_4.data;
            end
            if(l1_valid_3_5 & l1_ready_3_5)begin
                l1_cache_3_5 <= l1_data_3_5.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_2 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_2) begin
            l2_in_valid_3_2 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_2 <= |l1_grant_3_2;
        end
    end
    //sync case
    if(l1_all_last_3_2) begin
        l2_in_data_3_2.last <= 1;
        l2_in_data_3_2.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_2)
            2'b01: l2_in_data_3_2 <= l1_data_3_4;
            2'b10: l2_in_data_3_2 <= l1_data_3_5;
            default: l2_in_data_3_2 <= 0;
        endcase
    end   
end

assign l1_all_last_3_3 = (l1_data_3_6.last & l1_valid_3_6) & (l1_data_3_7.last & l1_valid_3_7) & !l2_almost_full_3_3;
assign l1_same_3_3 = l1_newdata_3_6 & l1_newdata_3_7 & (l1_data_3_6.data==l1_data_3_7.data) & !l2_almost_full_3_3;
assign l1_newdata_3_6 = l1_valid_3_6 & (l1_data_3_6.data != l1_cache_3_6) & !l1_data_3_6.last;

assign l1_newdata_3_7 = l1_valid_3_7 & (l1_data_3_7.data != l1_cache_3_7) & !l1_data_3_7.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_3[0] = l1_newdata_3_6 & !l2_almost_full_3_3;
    l1_ready_3_6 = l1_grant_3_3[0];       
    l1_req_3_3[1] = l1_newdata_3_7 & !l2_almost_full_3_3;
    l1_ready_3_7 = l1_grant_3_3[1];       
    //sync case
    if(l1_all_last_3_3) begin
        l1_req_3_3 = 0;
        l1_ready_3_6 = 1;
        l1_ready_3_7 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_3)begin
        l1_req_3_3[0] = 1;
        l1_req_3_3[0] = 0;
        l1_ready_3_7 = 1;
    end else begin
        if(l1_valid_3_6 & (l1_data_3_6.data == l1_cache_3_6) & !l1_data_3_6.last)begin
            l1_ready_3_6 = 1;
        end
        if(l1_valid_3_7 & (l1_data_3_7.data == l1_cache_3_7) & !l1_data_3_7.last)begin
            l1_ready_3_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_6 <= 0;
        l1_cache_3_7 <= 0;
    end else begin
        if(l1_all_last_3_3)begin
            l1_cache_3_6 <= 0;
            l1_cache_3_7 <= 0;
        end else begin
            if(l1_valid_3_6 & l1_ready_3_6)begin
                l1_cache_3_6 <= l1_data_3_6.data;
            end
            if(l1_valid_3_7 & l1_ready_3_7)begin
                l1_cache_3_7 <= l1_data_3_7.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_3 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_3) begin
            l2_in_valid_3_3 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_3 <= |l1_grant_3_3;
        end
    end
    //sync case
    if(l1_all_last_3_3) begin
        l2_in_data_3_3.last <= 1;
        l2_in_data_3_3.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_3)
            2'b01: l2_in_data_3_3 <= l1_data_3_6;
            2'b10: l2_in_data_3_3 <= l1_data_3_7;
            default: l2_in_data_3_3 <= 0;
        endcase
    end   
end

assign l1_all_last_3_4 = (l1_data_3_8.last & l1_valid_3_8) & (l1_data_3_9.last & l1_valid_3_9) & !l2_almost_full_3_4;
assign l1_same_3_4 = l1_newdata_3_8 & l1_newdata_3_9 & (l1_data_3_8.data==l1_data_3_9.data) & !l2_almost_full_3_4;
assign l1_newdata_3_8 = l1_valid_3_8 & (l1_data_3_8.data != l1_cache_3_8) & !l1_data_3_8.last;

assign l1_newdata_3_9 = l1_valid_3_9 & (l1_data_3_9.data != l1_cache_3_9) & !l1_data_3_9.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_4[0] = l1_newdata_3_8 & !l2_almost_full_3_4;
    l1_ready_3_8 = l1_grant_3_4[0];       
    l1_req_3_4[1] = l1_newdata_3_9 & !l2_almost_full_3_4;
    l1_ready_3_9 = l1_grant_3_4[1];       
    //sync case
    if(l1_all_last_3_4) begin
        l1_req_3_4 = 0;
        l1_ready_3_8 = 1;
        l1_ready_3_9 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_4)begin
        l1_req_3_4[0] = 1;
        l1_req_3_4[0] = 0;
        l1_ready_3_9 = 1;
    end else begin
        if(l1_valid_3_8 & (l1_data_3_8.data == l1_cache_3_8) & !l1_data_3_8.last)begin
            l1_ready_3_8 = 1;
        end
        if(l1_valid_3_9 & (l1_data_3_9.data == l1_cache_3_9) & !l1_data_3_9.last)begin
            l1_ready_3_9 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_8 <= 0;
        l1_cache_3_9 <= 0;
    end else begin
        if(l1_all_last_3_4)begin
            l1_cache_3_8 <= 0;
            l1_cache_3_9 <= 0;
        end else begin
            if(l1_valid_3_8 & l1_ready_3_8)begin
                l1_cache_3_8 <= l1_data_3_8.data;
            end
            if(l1_valid_3_9 & l1_ready_3_9)begin
                l1_cache_3_9 <= l1_data_3_9.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_4 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_4) begin
            l2_in_valid_3_4 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_4 <= |l1_grant_3_4;
        end
    end
    //sync case
    if(l1_all_last_3_4) begin
        l2_in_data_3_4.last <= 1;
        l2_in_data_3_4.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_4)
            2'b01: l2_in_data_3_4 <= l1_data_3_8;
            2'b10: l2_in_data_3_4 <= l1_data_3_9;
            default: l2_in_data_3_4 <= 0;
        endcase
    end   
end

assign l1_all_last_3_5 = (l1_data_3_10.last & l1_valid_3_10) & (l1_data_3_11.last & l1_valid_3_11) & !l2_almost_full_3_5;
assign l1_same_3_5 = l1_newdata_3_10 & l1_newdata_3_11 & (l1_data_3_10.data==l1_data_3_11.data) & !l2_almost_full_3_5;
assign l1_newdata_3_10 = l1_valid_3_10 & (l1_data_3_10.data != l1_cache_3_10) & !l1_data_3_10.last;

assign l1_newdata_3_11 = l1_valid_3_11 & (l1_data_3_11.data != l1_cache_3_11) & !l1_data_3_11.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_5[0] = l1_newdata_3_10 & !l2_almost_full_3_5;
    l1_ready_3_10 = l1_grant_3_5[0];       
    l1_req_3_5[1] = l1_newdata_3_11 & !l2_almost_full_3_5;
    l1_ready_3_11 = l1_grant_3_5[1];       
    //sync case
    if(l1_all_last_3_5) begin
        l1_req_3_5 = 0;
        l1_ready_3_10 = 1;
        l1_ready_3_11 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_5)begin
        l1_req_3_5[0] = 1;
        l1_req_3_5[0] = 0;
        l1_ready_3_11 = 1;
    end else begin
        if(l1_valid_3_10 & (l1_data_3_10.data == l1_cache_3_10) & !l1_data_3_10.last)begin
            l1_ready_3_10 = 1;
        end
        if(l1_valid_3_11 & (l1_data_3_11.data == l1_cache_3_11) & !l1_data_3_11.last)begin
            l1_ready_3_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_10 <= 0;
        l1_cache_3_11 <= 0;
    end else begin
        if(l1_all_last_3_5)begin
            l1_cache_3_10 <= 0;
            l1_cache_3_11 <= 0;
        end else begin
            if(l1_valid_3_10 & l1_ready_3_10)begin
                l1_cache_3_10 <= l1_data_3_10.data;
            end
            if(l1_valid_3_11 & l1_ready_3_11)begin
                l1_cache_3_11 <= l1_data_3_11.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_5 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_5) begin
            l2_in_valid_3_5 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_5 <= |l1_grant_3_5;
        end
    end
    //sync case
    if(l1_all_last_3_5) begin
        l2_in_data_3_5.last <= 1;
        l2_in_data_3_5.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_5)
            2'b01: l2_in_data_3_5 <= l1_data_3_10;
            2'b10: l2_in_data_3_5 <= l1_data_3_11;
            default: l2_in_data_3_5 <= 0;
        endcase
    end   
end

assign l1_all_last_3_6 = (l1_data_3_12.last & l1_valid_3_12) & (l1_data_3_13.last & l1_valid_3_13) & !l2_almost_full_3_6;
assign l1_same_3_6 = l1_newdata_3_12 & l1_newdata_3_13 & (l1_data_3_12.data==l1_data_3_13.data) & !l2_almost_full_3_6;
assign l1_newdata_3_12 = l1_valid_3_12 & (l1_data_3_12.data != l1_cache_3_12) & !l1_data_3_12.last;

assign l1_newdata_3_13 = l1_valid_3_13 & (l1_data_3_13.data != l1_cache_3_13) & !l1_data_3_13.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_6[0] = l1_newdata_3_12 & !l2_almost_full_3_6;
    l1_ready_3_12 = l1_grant_3_6[0];       
    l1_req_3_6[1] = l1_newdata_3_13 & !l2_almost_full_3_6;
    l1_ready_3_13 = l1_grant_3_6[1];       
    //sync case
    if(l1_all_last_3_6) begin
        l1_req_3_6 = 0;
        l1_ready_3_12 = 1;
        l1_ready_3_13 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_6)begin
        l1_req_3_6[0] = 1;
        l1_req_3_6[0] = 0;
        l1_ready_3_13 = 1;
    end else begin
        if(l1_valid_3_12 & (l1_data_3_12.data == l1_cache_3_12) & !l1_data_3_12.last)begin
            l1_ready_3_12 = 1;
        end
        if(l1_valid_3_13 & (l1_data_3_13.data == l1_cache_3_13) & !l1_data_3_13.last)begin
            l1_ready_3_13 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_12 <= 0;
        l1_cache_3_13 <= 0;
    end else begin
        if(l1_all_last_3_6)begin
            l1_cache_3_12 <= 0;
            l1_cache_3_13 <= 0;
        end else begin
            if(l1_valid_3_12 & l1_ready_3_12)begin
                l1_cache_3_12 <= l1_data_3_12.data;
            end
            if(l1_valid_3_13 & l1_ready_3_13)begin
                l1_cache_3_13 <= l1_data_3_13.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_6 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_6) begin
            l2_in_valid_3_6 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_6 <= |l1_grant_3_6;
        end
    end
    //sync case
    if(l1_all_last_3_6) begin
        l2_in_data_3_6.last <= 1;
        l2_in_data_3_6.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_6)
            2'b01: l2_in_data_3_6 <= l1_data_3_12;
            2'b10: l2_in_data_3_6 <= l1_data_3_13;
            default: l2_in_data_3_6 <= 0;
        endcase
    end   
end

assign l1_all_last_3_7 = (l1_data_3_14.last & l1_valid_3_14) & (l1_data_3_15.last & l1_valid_3_15) & !l2_almost_full_3_7;
assign l1_same_3_7 = l1_newdata_3_14 & l1_newdata_3_15 & (l1_data_3_14.data==l1_data_3_15.data) & !l2_almost_full_3_7;
assign l1_newdata_3_14 = l1_valid_3_14 & (l1_data_3_14.data != l1_cache_3_14) & !l1_data_3_14.last;

assign l1_newdata_3_15 = l1_valid_3_15 & (l1_data_3_15.data != l1_cache_3_15) & !l1_data_3_15.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_7[0] = l1_newdata_3_14 & !l2_almost_full_3_7;
    l1_ready_3_14 = l1_grant_3_7[0];       
    l1_req_3_7[1] = l1_newdata_3_15 & !l2_almost_full_3_7;
    l1_ready_3_15 = l1_grant_3_7[1];       
    //sync case
    if(l1_all_last_3_7) begin
        l1_req_3_7 = 0;
        l1_ready_3_14 = 1;
        l1_ready_3_15 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_7)begin
        l1_req_3_7[0] = 1;
        l1_req_3_7[0] = 0;
        l1_ready_3_15 = 1;
    end else begin
        if(l1_valid_3_14 & (l1_data_3_14.data == l1_cache_3_14) & !l1_data_3_14.last)begin
            l1_ready_3_14 = 1;
        end
        if(l1_valid_3_15 & (l1_data_3_15.data == l1_cache_3_15) & !l1_data_3_15.last)begin
            l1_ready_3_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_14 <= 0;
        l1_cache_3_15 <= 0;
    end else begin
        if(l1_all_last_3_7)begin
            l1_cache_3_14 <= 0;
            l1_cache_3_15 <= 0;
        end else begin
            if(l1_valid_3_14 & l1_ready_3_14)begin
                l1_cache_3_14 <= l1_data_3_14.data;
            end
            if(l1_valid_3_15 & l1_ready_3_15)begin
                l1_cache_3_15 <= l1_data_3_15.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_7 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_7) begin
            l2_in_valid_3_7 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_7 <= |l1_grant_3_7;
        end
    end
    //sync case
    if(l1_all_last_3_7) begin
        l2_in_data_3_7.last <= 1;
        l2_in_data_3_7.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_7)
            2'b01: l2_in_data_3_7 <= l1_data_3_14;
            2'b10: l2_in_data_3_7 <= l1_data_3_15;
            default: l2_in_data_3_7 <= 0;
        endcase
    end   
end

assign l1_all_last_3_8 = (l1_data_3_16.last & l1_valid_3_16) & (l1_data_3_17.last & l1_valid_3_17) & !l2_almost_full_3_8;
assign l1_same_3_8 = l1_newdata_3_16 & l1_newdata_3_17 & (l1_data_3_16.data==l1_data_3_17.data) & !l2_almost_full_3_8;
assign l1_newdata_3_16 = l1_valid_3_16 & (l1_data_3_16.data != l1_cache_3_16) & !l1_data_3_16.last;

assign l1_newdata_3_17 = l1_valid_3_17 & (l1_data_3_17.data != l1_cache_3_17) & !l1_data_3_17.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_8[0] = l1_newdata_3_16 & !l2_almost_full_3_8;
    l1_ready_3_16 = l1_grant_3_8[0];       
    l1_req_3_8[1] = l1_newdata_3_17 & !l2_almost_full_3_8;
    l1_ready_3_17 = l1_grant_3_8[1];       
    //sync case
    if(l1_all_last_3_8) begin
        l1_req_3_8 = 0;
        l1_ready_3_16 = 1;
        l1_ready_3_17 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_8)begin
        l1_req_3_8[0] = 1;
        l1_req_3_8[0] = 0;
        l1_ready_3_17 = 1;
    end else begin
        if(l1_valid_3_16 & (l1_data_3_16.data == l1_cache_3_16) & !l1_data_3_16.last)begin
            l1_ready_3_16 = 1;
        end
        if(l1_valid_3_17 & (l1_data_3_17.data == l1_cache_3_17) & !l1_data_3_17.last)begin
            l1_ready_3_17 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_16 <= 0;
        l1_cache_3_17 <= 0;
    end else begin
        if(l1_all_last_3_8)begin
            l1_cache_3_16 <= 0;
            l1_cache_3_17 <= 0;
        end else begin
            if(l1_valid_3_16 & l1_ready_3_16)begin
                l1_cache_3_16 <= l1_data_3_16.data;
            end
            if(l1_valid_3_17 & l1_ready_3_17)begin
                l1_cache_3_17 <= l1_data_3_17.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_8 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_8) begin
            l2_in_valid_3_8 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_8 <= |l1_grant_3_8;
        end
    end
    //sync case
    if(l1_all_last_3_8) begin
        l2_in_data_3_8.last <= 1;
        l2_in_data_3_8.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_8)
            2'b01: l2_in_data_3_8 <= l1_data_3_16;
            2'b10: l2_in_data_3_8 <= l1_data_3_17;
            default: l2_in_data_3_8 <= 0;
        endcase
    end   
end

assign l1_all_last_3_9 = (l1_data_3_18.last & l1_valid_3_18) & (l1_data_3_19.last & l1_valid_3_19) & !l2_almost_full_3_9;
assign l1_same_3_9 = l1_newdata_3_18 & l1_newdata_3_19 & (l1_data_3_18.data==l1_data_3_19.data) & !l2_almost_full_3_9;
assign l1_newdata_3_18 = l1_valid_3_18 & (l1_data_3_18.data != l1_cache_3_18) & !l1_data_3_18.last;

assign l1_newdata_3_19 = l1_valid_3_19 & (l1_data_3_19.data != l1_cache_3_19) & !l1_data_3_19.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_9[0] = l1_newdata_3_18 & !l2_almost_full_3_9;
    l1_ready_3_18 = l1_grant_3_9[0];       
    l1_req_3_9[1] = l1_newdata_3_19 & !l2_almost_full_3_9;
    l1_ready_3_19 = l1_grant_3_9[1];       
    //sync case
    if(l1_all_last_3_9) begin
        l1_req_3_9 = 0;
        l1_ready_3_18 = 1;
        l1_ready_3_19 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_9)begin
        l1_req_3_9[0] = 1;
        l1_req_3_9[0] = 0;
        l1_ready_3_19 = 1;
    end else begin
        if(l1_valid_3_18 & (l1_data_3_18.data == l1_cache_3_18) & !l1_data_3_18.last)begin
            l1_ready_3_18 = 1;
        end
        if(l1_valid_3_19 & (l1_data_3_19.data == l1_cache_3_19) & !l1_data_3_19.last)begin
            l1_ready_3_19 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_18 <= 0;
        l1_cache_3_19 <= 0;
    end else begin
        if(l1_all_last_3_9)begin
            l1_cache_3_18 <= 0;
            l1_cache_3_19 <= 0;
        end else begin
            if(l1_valid_3_18 & l1_ready_3_18)begin
                l1_cache_3_18 <= l1_data_3_18.data;
            end
            if(l1_valid_3_19 & l1_ready_3_19)begin
                l1_cache_3_19 <= l1_data_3_19.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_9 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_9) begin
            l2_in_valid_3_9 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_9 <= |l1_grant_3_9;
        end
    end
    //sync case
    if(l1_all_last_3_9) begin
        l2_in_data_3_9.last <= 1;
        l2_in_data_3_9.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_9)
            2'b01: l2_in_data_3_9 <= l1_data_3_18;
            2'b10: l2_in_data_3_9 <= l1_data_3_19;
            default: l2_in_data_3_9 <= 0;
        endcase
    end   
end

assign l1_all_last_3_10 = (l1_data_3_20.last & l1_valid_3_20) & (l1_data_3_21.last & l1_valid_3_21) & !l2_almost_full_3_10;
assign l1_same_3_10 = l1_newdata_3_20 & l1_newdata_3_21 & (l1_data_3_20.data==l1_data_3_21.data) & !l2_almost_full_3_10;
assign l1_newdata_3_20 = l1_valid_3_20 & (l1_data_3_20.data != l1_cache_3_20) & !l1_data_3_20.last;

assign l1_newdata_3_21 = l1_valid_3_21 & (l1_data_3_21.data != l1_cache_3_21) & !l1_data_3_21.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_10[0] = l1_newdata_3_20 & !l2_almost_full_3_10;
    l1_ready_3_20 = l1_grant_3_10[0];       
    l1_req_3_10[1] = l1_newdata_3_21 & !l2_almost_full_3_10;
    l1_ready_3_21 = l1_grant_3_10[1];       
    //sync case
    if(l1_all_last_3_10) begin
        l1_req_3_10 = 0;
        l1_ready_3_20 = 1;
        l1_ready_3_21 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_10)begin
        l1_req_3_10[0] = 1;
        l1_req_3_10[0] = 0;
        l1_ready_3_21 = 1;
    end else begin
        if(l1_valid_3_20 & (l1_data_3_20.data == l1_cache_3_20) & !l1_data_3_20.last)begin
            l1_ready_3_20 = 1;
        end
        if(l1_valid_3_21 & (l1_data_3_21.data == l1_cache_3_21) & !l1_data_3_21.last)begin
            l1_ready_3_21 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_20 <= 0;
        l1_cache_3_21 <= 0;
    end else begin
        if(l1_all_last_3_10)begin
            l1_cache_3_20 <= 0;
            l1_cache_3_21 <= 0;
        end else begin
            if(l1_valid_3_20 & l1_ready_3_20)begin
                l1_cache_3_20 <= l1_data_3_20.data;
            end
            if(l1_valid_3_21 & l1_ready_3_21)begin
                l1_cache_3_21 <= l1_data_3_21.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_10 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_10) begin
            l2_in_valid_3_10 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_10 <= |l1_grant_3_10;
        end
    end
    //sync case
    if(l1_all_last_3_10) begin
        l2_in_data_3_10.last <= 1;
        l2_in_data_3_10.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_10)
            2'b01: l2_in_data_3_10 <= l1_data_3_20;
            2'b10: l2_in_data_3_10 <= l1_data_3_21;
            default: l2_in_data_3_10 <= 0;
        endcase
    end   
end

assign l1_all_last_3_11 = (l1_data_3_22.last & l1_valid_3_22) & (l1_data_3_23.last & l1_valid_3_23) & !l2_almost_full_3_11;
assign l1_same_3_11 = l1_newdata_3_22 & l1_newdata_3_23 & (l1_data_3_22.data==l1_data_3_23.data) & !l2_almost_full_3_11;
assign l1_newdata_3_22 = l1_valid_3_22 & (l1_data_3_22.data != l1_cache_3_22) & !l1_data_3_22.last;

assign l1_newdata_3_23 = l1_valid_3_23 & (l1_data_3_23.data != l1_cache_3_23) & !l1_data_3_23.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_11[0] = l1_newdata_3_22 & !l2_almost_full_3_11;
    l1_ready_3_22 = l1_grant_3_11[0];       
    l1_req_3_11[1] = l1_newdata_3_23 & !l2_almost_full_3_11;
    l1_ready_3_23 = l1_grant_3_11[1];       
    //sync case
    if(l1_all_last_3_11) begin
        l1_req_3_11 = 0;
        l1_ready_3_22 = 1;
        l1_ready_3_23 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_11)begin
        l1_req_3_11[0] = 1;
        l1_req_3_11[0] = 0;
        l1_ready_3_23 = 1;
    end else begin
        if(l1_valid_3_22 & (l1_data_3_22.data == l1_cache_3_22) & !l1_data_3_22.last)begin
            l1_ready_3_22 = 1;
        end
        if(l1_valid_3_23 & (l1_data_3_23.data == l1_cache_3_23) & !l1_data_3_23.last)begin
            l1_ready_3_23 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_22 <= 0;
        l1_cache_3_23 <= 0;
    end else begin
        if(l1_all_last_3_11)begin
            l1_cache_3_22 <= 0;
            l1_cache_3_23 <= 0;
        end else begin
            if(l1_valid_3_22 & l1_ready_3_22)begin
                l1_cache_3_22 <= l1_data_3_22.data;
            end
            if(l1_valid_3_23 & l1_ready_3_23)begin
                l1_cache_3_23 <= l1_data_3_23.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_11 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_11) begin
            l2_in_valid_3_11 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_11 <= |l1_grant_3_11;
        end
    end
    //sync case
    if(l1_all_last_3_11) begin
        l2_in_data_3_11.last <= 1;
        l2_in_data_3_11.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_11)
            2'b01: l2_in_data_3_11 <= l1_data_3_22;
            2'b10: l2_in_data_3_11 <= l1_data_3_23;
            default: l2_in_data_3_11 <= 0;
        endcase
    end   
end

assign l1_all_last_3_12 = (l1_data_3_24.last & l1_valid_3_24) & (l1_data_3_25.last & l1_valid_3_25) & !l2_almost_full_3_12;
assign l1_same_3_12 = l1_newdata_3_24 & l1_newdata_3_25 & (l1_data_3_24.data==l1_data_3_25.data) & !l2_almost_full_3_12;
assign l1_newdata_3_24 = l1_valid_3_24 & (l1_data_3_24.data != l1_cache_3_24) & !l1_data_3_24.last;

assign l1_newdata_3_25 = l1_valid_3_25 & (l1_data_3_25.data != l1_cache_3_25) & !l1_data_3_25.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_12[0] = l1_newdata_3_24 & !l2_almost_full_3_12;
    l1_ready_3_24 = l1_grant_3_12[0];       
    l1_req_3_12[1] = l1_newdata_3_25 & !l2_almost_full_3_12;
    l1_ready_3_25 = l1_grant_3_12[1];       
    //sync case
    if(l1_all_last_3_12) begin
        l1_req_3_12 = 0;
        l1_ready_3_24 = 1;
        l1_ready_3_25 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_12)begin
        l1_req_3_12[0] = 1;
        l1_req_3_12[0] = 0;
        l1_ready_3_25 = 1;
    end else begin
        if(l1_valid_3_24 & (l1_data_3_24.data == l1_cache_3_24) & !l1_data_3_24.last)begin
            l1_ready_3_24 = 1;
        end
        if(l1_valid_3_25 & (l1_data_3_25.data == l1_cache_3_25) & !l1_data_3_25.last)begin
            l1_ready_3_25 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_24 <= 0;
        l1_cache_3_25 <= 0;
    end else begin
        if(l1_all_last_3_12)begin
            l1_cache_3_24 <= 0;
            l1_cache_3_25 <= 0;
        end else begin
            if(l1_valid_3_24 & l1_ready_3_24)begin
                l1_cache_3_24 <= l1_data_3_24.data;
            end
            if(l1_valid_3_25 & l1_ready_3_25)begin
                l1_cache_3_25 <= l1_data_3_25.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_12 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_12) begin
            l2_in_valid_3_12 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_12 <= |l1_grant_3_12;
        end
    end
    //sync case
    if(l1_all_last_3_12) begin
        l2_in_data_3_12.last <= 1;
        l2_in_data_3_12.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_12)
            2'b01: l2_in_data_3_12 <= l1_data_3_24;
            2'b10: l2_in_data_3_12 <= l1_data_3_25;
            default: l2_in_data_3_12 <= 0;
        endcase
    end   
end

assign l1_all_last_3_13 = (l1_data_3_26.last & l1_valid_3_26) & (l1_data_3_27.last & l1_valid_3_27) & !l2_almost_full_3_13;
assign l1_same_3_13 = l1_newdata_3_26 & l1_newdata_3_27 & (l1_data_3_26.data==l1_data_3_27.data) & !l2_almost_full_3_13;
assign l1_newdata_3_26 = l1_valid_3_26 & (l1_data_3_26.data != l1_cache_3_26) & !l1_data_3_26.last;

assign l1_newdata_3_27 = l1_valid_3_27 & (l1_data_3_27.data != l1_cache_3_27) & !l1_data_3_27.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_13[0] = l1_newdata_3_26 & !l2_almost_full_3_13;
    l1_ready_3_26 = l1_grant_3_13[0];       
    l1_req_3_13[1] = l1_newdata_3_27 & !l2_almost_full_3_13;
    l1_ready_3_27 = l1_grant_3_13[1];       
    //sync case
    if(l1_all_last_3_13) begin
        l1_req_3_13 = 0;
        l1_ready_3_26 = 1;
        l1_ready_3_27 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_13)begin
        l1_req_3_13[0] = 1;
        l1_req_3_13[0] = 0;
        l1_ready_3_27 = 1;
    end else begin
        if(l1_valid_3_26 & (l1_data_3_26.data == l1_cache_3_26) & !l1_data_3_26.last)begin
            l1_ready_3_26 = 1;
        end
        if(l1_valid_3_27 & (l1_data_3_27.data == l1_cache_3_27) & !l1_data_3_27.last)begin
            l1_ready_3_27 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_26 <= 0;
        l1_cache_3_27 <= 0;
    end else begin
        if(l1_all_last_3_13)begin
            l1_cache_3_26 <= 0;
            l1_cache_3_27 <= 0;
        end else begin
            if(l1_valid_3_26 & l1_ready_3_26)begin
                l1_cache_3_26 <= l1_data_3_26.data;
            end
            if(l1_valid_3_27 & l1_ready_3_27)begin
                l1_cache_3_27 <= l1_data_3_27.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_13 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_13) begin
            l2_in_valid_3_13 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_13 <= |l1_grant_3_13;
        end
    end
    //sync case
    if(l1_all_last_3_13) begin
        l2_in_data_3_13.last <= 1;
        l2_in_data_3_13.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_13)
            2'b01: l2_in_data_3_13 <= l1_data_3_26;
            2'b10: l2_in_data_3_13 <= l1_data_3_27;
            default: l2_in_data_3_13 <= 0;
        endcase
    end   
end

assign l1_all_last_3_14 = (l1_data_3_28.last & l1_valid_3_28) & (l1_data_3_29.last & l1_valid_3_29) & !l2_almost_full_3_14;
assign l1_same_3_14 = l1_newdata_3_28 & l1_newdata_3_29 & (l1_data_3_28.data==l1_data_3_29.data) & !l2_almost_full_3_14;
assign l1_newdata_3_28 = l1_valid_3_28 & (l1_data_3_28.data != l1_cache_3_28) & !l1_data_3_28.last;

assign l1_newdata_3_29 = l1_valid_3_29 & (l1_data_3_29.data != l1_cache_3_29) & !l1_data_3_29.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_14[0] = l1_newdata_3_28 & !l2_almost_full_3_14;
    l1_ready_3_28 = l1_grant_3_14[0];       
    l1_req_3_14[1] = l1_newdata_3_29 & !l2_almost_full_3_14;
    l1_ready_3_29 = l1_grant_3_14[1];       
    //sync case
    if(l1_all_last_3_14) begin
        l1_req_3_14 = 0;
        l1_ready_3_28 = 1;
        l1_ready_3_29 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_14)begin
        l1_req_3_14[0] = 1;
        l1_req_3_14[0] = 0;
        l1_ready_3_29 = 1;
    end else begin
        if(l1_valid_3_28 & (l1_data_3_28.data == l1_cache_3_28) & !l1_data_3_28.last)begin
            l1_ready_3_28 = 1;
        end
        if(l1_valid_3_29 & (l1_data_3_29.data == l1_cache_3_29) & !l1_data_3_29.last)begin
            l1_ready_3_29 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_28 <= 0;
        l1_cache_3_29 <= 0;
    end else begin
        if(l1_all_last_3_14)begin
            l1_cache_3_28 <= 0;
            l1_cache_3_29 <= 0;
        end else begin
            if(l1_valid_3_28 & l1_ready_3_28)begin
                l1_cache_3_28 <= l1_data_3_28.data;
            end
            if(l1_valid_3_29 & l1_ready_3_29)begin
                l1_cache_3_29 <= l1_data_3_29.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_14 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_14) begin
            l2_in_valid_3_14 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_14 <= |l1_grant_3_14;
        end
    end
    //sync case
    if(l1_all_last_3_14) begin
        l2_in_data_3_14.last <= 1;
        l2_in_data_3_14.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_14)
            2'b01: l2_in_data_3_14 <= l1_data_3_28;
            2'b10: l2_in_data_3_14 <= l1_data_3_29;
            default: l2_in_data_3_14 <= 0;
        endcase
    end   
end

assign l1_all_last_3_15 = (l1_data_3_30.last & l1_valid_3_30) & (l1_data_3_31.last & l1_valid_3_31) & !l2_almost_full_3_15;
assign l1_same_3_15 = l1_newdata_3_30 & l1_newdata_3_31 & (l1_data_3_30.data==l1_data_3_31.data) & !l2_almost_full_3_15;
assign l1_newdata_3_30 = l1_valid_3_30 & (l1_data_3_30.data != l1_cache_3_30) & !l1_data_3_30.last;

assign l1_newdata_3_31 = l1_valid_3_31 & (l1_data_3_31.data != l1_cache_3_31) & !l1_data_3_31.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_3_15[0] = l1_newdata_3_30 & !l2_almost_full_3_15;
    l1_ready_3_30 = l1_grant_3_15[0];       
    l1_req_3_15[1] = l1_newdata_3_31 & !l2_almost_full_3_15;
    l1_ready_3_31 = l1_grant_3_15[1];       
    //sync case
    if(l1_all_last_3_15) begin
        l1_req_3_15 = 0;
        l1_ready_3_30 = 1;
        l1_ready_3_31 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_3_15)begin
        l1_req_3_15[0] = 1;
        l1_req_3_15[0] = 0;
        l1_ready_3_31 = 1;
    end else begin
        if(l1_valid_3_30 & (l1_data_3_30.data == l1_cache_3_30) & !l1_data_3_30.last)begin
            l1_ready_3_30 = 1;
        end
        if(l1_valid_3_31 & (l1_data_3_31.data == l1_cache_3_31) & !l1_data_3_31.last)begin
            l1_ready_3_31 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_3_30 <= 0;
        l1_cache_3_31 <= 0;
    end else begin
        if(l1_all_last_3_15)begin
            l1_cache_3_30 <= 0;
            l1_cache_3_31 <= 0;
        end else begin
            if(l1_valid_3_30 & l1_ready_3_30)begin
                l1_cache_3_30 <= l1_data_3_30.data;
            end
            if(l1_valid_3_31 & l1_ready_3_31)begin
                l1_cache_3_31 <= l1_data_3_31.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_3_15 <= 0;
    end else begin
        //sync case
        if(l1_all_last_3_15) begin
            l2_in_valid_3_15 <= 1;
        //normal case
        end else begin
            l2_in_valid_3_15 <= |l1_grant_3_15;
        end
    end
    //sync case
    if(l1_all_last_3_15) begin
        l2_in_data_3_15.last <= 1;
        l2_in_data_3_15.data <= 0;
    //normal case
    end else begin
        case(l1_grant_3_15)
            2'b01: l2_in_data_3_15 <= l1_data_3_30;
            2'b10: l2_in_data_3_15 <= l1_data_3_31;
            default: l2_in_data_3_15 <= 0;
        endcase
    end   
end

assign l1_all_last_4_0 = (l1_data_4_0.last & l1_valid_4_0) & (l1_data_4_1.last & l1_valid_4_1) & !l2_almost_full_4_0;
assign l1_same_4_0 = l1_newdata_4_0 & l1_newdata_4_1 & (l1_data_4_0.data==l1_data_4_1.data) & !l2_almost_full_4_0;
assign l1_newdata_4_0 = l1_valid_4_0 & (l1_data_4_0.data != l1_cache_4_0) & !l1_data_4_0.last;

assign l1_newdata_4_1 = l1_valid_4_1 & (l1_data_4_1.data != l1_cache_4_1) & !l1_data_4_1.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_0[0] = l1_newdata_4_0 & !l2_almost_full_4_0;
    l1_ready_4_0 = l1_grant_4_0[0];       
    l1_req_4_0[1] = l1_newdata_4_1 & !l2_almost_full_4_0;
    l1_ready_4_1 = l1_grant_4_0[1];       
    //sync case
    if(l1_all_last_4_0) begin
        l1_req_4_0 = 0;
        l1_ready_4_0 = 1;
        l1_ready_4_1 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_0)begin
        l1_req_4_0[0] = 1;
        l1_req_4_0[0] = 0;
        l1_ready_4_1 = 1;
    end else begin
        if(l1_valid_4_0 & (l1_data_4_0.data == l1_cache_4_0) & !l1_data_4_0.last)begin
            l1_ready_4_0 = 1;
        end
        if(l1_valid_4_1 & (l1_data_4_1.data == l1_cache_4_1) & !l1_data_4_1.last)begin
            l1_ready_4_1 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_0 <= 0;
        l1_cache_4_1 <= 0;
    end else begin
        if(l1_all_last_4_0)begin
            l1_cache_4_0 <= 0;
            l1_cache_4_1 <= 0;
        end else begin
            if(l1_valid_4_0 & l1_ready_4_0)begin
                l1_cache_4_0 <= l1_data_4_0.data;
            end
            if(l1_valid_4_1 & l1_ready_4_1)begin
                l1_cache_4_1 <= l1_data_4_1.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_0 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_0) begin
            l2_in_valid_4_0 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_0 <= |l1_grant_4_0;
        end
    end
    //sync case
    if(l1_all_last_4_0) begin
        l2_in_data_4_0.last <= 1;
        l2_in_data_4_0.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_0)
            2'b01: l2_in_data_4_0 <= l1_data_4_0;
            2'b10: l2_in_data_4_0 <= l1_data_4_1;
            default: l2_in_data_4_0 <= 0;
        endcase
    end   
end

assign l1_all_last_4_1 = (l1_data_4_2.last & l1_valid_4_2) & (l1_data_4_3.last & l1_valid_4_3) & !l2_almost_full_4_1;
assign l1_same_4_1 = l1_newdata_4_2 & l1_newdata_4_3 & (l1_data_4_2.data==l1_data_4_3.data) & !l2_almost_full_4_1;
assign l1_newdata_4_2 = l1_valid_4_2 & (l1_data_4_2.data != l1_cache_4_2) & !l1_data_4_2.last;

assign l1_newdata_4_3 = l1_valid_4_3 & (l1_data_4_3.data != l1_cache_4_3) & !l1_data_4_3.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_1[0] = l1_newdata_4_2 & !l2_almost_full_4_1;
    l1_ready_4_2 = l1_grant_4_1[0];       
    l1_req_4_1[1] = l1_newdata_4_3 & !l2_almost_full_4_1;
    l1_ready_4_3 = l1_grant_4_1[1];       
    //sync case
    if(l1_all_last_4_1) begin
        l1_req_4_1 = 0;
        l1_ready_4_2 = 1;
        l1_ready_4_3 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_1)begin
        l1_req_4_1[0] = 1;
        l1_req_4_1[0] = 0;
        l1_ready_4_3 = 1;
    end else begin
        if(l1_valid_4_2 & (l1_data_4_2.data == l1_cache_4_2) & !l1_data_4_2.last)begin
            l1_ready_4_2 = 1;
        end
        if(l1_valid_4_3 & (l1_data_4_3.data == l1_cache_4_3) & !l1_data_4_3.last)begin
            l1_ready_4_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_2 <= 0;
        l1_cache_4_3 <= 0;
    end else begin
        if(l1_all_last_4_1)begin
            l1_cache_4_2 <= 0;
            l1_cache_4_3 <= 0;
        end else begin
            if(l1_valid_4_2 & l1_ready_4_2)begin
                l1_cache_4_2 <= l1_data_4_2.data;
            end
            if(l1_valid_4_3 & l1_ready_4_3)begin
                l1_cache_4_3 <= l1_data_4_3.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_1 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_1) begin
            l2_in_valid_4_1 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_1 <= |l1_grant_4_1;
        end
    end
    //sync case
    if(l1_all_last_4_1) begin
        l2_in_data_4_1.last <= 1;
        l2_in_data_4_1.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_1)
            2'b01: l2_in_data_4_1 <= l1_data_4_2;
            2'b10: l2_in_data_4_1 <= l1_data_4_3;
            default: l2_in_data_4_1 <= 0;
        endcase
    end   
end

assign l1_all_last_4_2 = (l1_data_4_4.last & l1_valid_4_4) & (l1_data_4_5.last & l1_valid_4_5) & !l2_almost_full_4_2;
assign l1_same_4_2 = l1_newdata_4_4 & l1_newdata_4_5 & (l1_data_4_4.data==l1_data_4_5.data) & !l2_almost_full_4_2;
assign l1_newdata_4_4 = l1_valid_4_4 & (l1_data_4_4.data != l1_cache_4_4) & !l1_data_4_4.last;

assign l1_newdata_4_5 = l1_valid_4_5 & (l1_data_4_5.data != l1_cache_4_5) & !l1_data_4_5.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_2[0] = l1_newdata_4_4 & !l2_almost_full_4_2;
    l1_ready_4_4 = l1_grant_4_2[0];       
    l1_req_4_2[1] = l1_newdata_4_5 & !l2_almost_full_4_2;
    l1_ready_4_5 = l1_grant_4_2[1];       
    //sync case
    if(l1_all_last_4_2) begin
        l1_req_4_2 = 0;
        l1_ready_4_4 = 1;
        l1_ready_4_5 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_2)begin
        l1_req_4_2[0] = 1;
        l1_req_4_2[0] = 0;
        l1_ready_4_5 = 1;
    end else begin
        if(l1_valid_4_4 & (l1_data_4_4.data == l1_cache_4_4) & !l1_data_4_4.last)begin
            l1_ready_4_4 = 1;
        end
        if(l1_valid_4_5 & (l1_data_4_5.data == l1_cache_4_5) & !l1_data_4_5.last)begin
            l1_ready_4_5 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_4 <= 0;
        l1_cache_4_5 <= 0;
    end else begin
        if(l1_all_last_4_2)begin
            l1_cache_4_4 <= 0;
            l1_cache_4_5 <= 0;
        end else begin
            if(l1_valid_4_4 & l1_ready_4_4)begin
                l1_cache_4_4 <= l1_data_4_4.data;
            end
            if(l1_valid_4_5 & l1_ready_4_5)begin
                l1_cache_4_5 <= l1_data_4_5.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_2 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_2) begin
            l2_in_valid_4_2 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_2 <= |l1_grant_4_2;
        end
    end
    //sync case
    if(l1_all_last_4_2) begin
        l2_in_data_4_2.last <= 1;
        l2_in_data_4_2.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_2)
            2'b01: l2_in_data_4_2 <= l1_data_4_4;
            2'b10: l2_in_data_4_2 <= l1_data_4_5;
            default: l2_in_data_4_2 <= 0;
        endcase
    end   
end

assign l1_all_last_4_3 = (l1_data_4_6.last & l1_valid_4_6) & (l1_data_4_7.last & l1_valid_4_7) & !l2_almost_full_4_3;
assign l1_same_4_3 = l1_newdata_4_6 & l1_newdata_4_7 & (l1_data_4_6.data==l1_data_4_7.data) & !l2_almost_full_4_3;
assign l1_newdata_4_6 = l1_valid_4_6 & (l1_data_4_6.data != l1_cache_4_6) & !l1_data_4_6.last;

assign l1_newdata_4_7 = l1_valid_4_7 & (l1_data_4_7.data != l1_cache_4_7) & !l1_data_4_7.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_3[0] = l1_newdata_4_6 & !l2_almost_full_4_3;
    l1_ready_4_6 = l1_grant_4_3[0];       
    l1_req_4_3[1] = l1_newdata_4_7 & !l2_almost_full_4_3;
    l1_ready_4_7 = l1_grant_4_3[1];       
    //sync case
    if(l1_all_last_4_3) begin
        l1_req_4_3 = 0;
        l1_ready_4_6 = 1;
        l1_ready_4_7 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_3)begin
        l1_req_4_3[0] = 1;
        l1_req_4_3[0] = 0;
        l1_ready_4_7 = 1;
    end else begin
        if(l1_valid_4_6 & (l1_data_4_6.data == l1_cache_4_6) & !l1_data_4_6.last)begin
            l1_ready_4_6 = 1;
        end
        if(l1_valid_4_7 & (l1_data_4_7.data == l1_cache_4_7) & !l1_data_4_7.last)begin
            l1_ready_4_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_6 <= 0;
        l1_cache_4_7 <= 0;
    end else begin
        if(l1_all_last_4_3)begin
            l1_cache_4_6 <= 0;
            l1_cache_4_7 <= 0;
        end else begin
            if(l1_valid_4_6 & l1_ready_4_6)begin
                l1_cache_4_6 <= l1_data_4_6.data;
            end
            if(l1_valid_4_7 & l1_ready_4_7)begin
                l1_cache_4_7 <= l1_data_4_7.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_3 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_3) begin
            l2_in_valid_4_3 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_3 <= |l1_grant_4_3;
        end
    end
    //sync case
    if(l1_all_last_4_3) begin
        l2_in_data_4_3.last <= 1;
        l2_in_data_4_3.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_3)
            2'b01: l2_in_data_4_3 <= l1_data_4_6;
            2'b10: l2_in_data_4_3 <= l1_data_4_7;
            default: l2_in_data_4_3 <= 0;
        endcase
    end   
end

assign l1_all_last_4_4 = (l1_data_4_8.last & l1_valid_4_8) & (l1_data_4_9.last & l1_valid_4_9) & !l2_almost_full_4_4;
assign l1_same_4_4 = l1_newdata_4_8 & l1_newdata_4_9 & (l1_data_4_8.data==l1_data_4_9.data) & !l2_almost_full_4_4;
assign l1_newdata_4_8 = l1_valid_4_8 & (l1_data_4_8.data != l1_cache_4_8) & !l1_data_4_8.last;

assign l1_newdata_4_9 = l1_valid_4_9 & (l1_data_4_9.data != l1_cache_4_9) & !l1_data_4_9.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_4[0] = l1_newdata_4_8 & !l2_almost_full_4_4;
    l1_ready_4_8 = l1_grant_4_4[0];       
    l1_req_4_4[1] = l1_newdata_4_9 & !l2_almost_full_4_4;
    l1_ready_4_9 = l1_grant_4_4[1];       
    //sync case
    if(l1_all_last_4_4) begin
        l1_req_4_4 = 0;
        l1_ready_4_8 = 1;
        l1_ready_4_9 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_4)begin
        l1_req_4_4[0] = 1;
        l1_req_4_4[0] = 0;
        l1_ready_4_9 = 1;
    end else begin
        if(l1_valid_4_8 & (l1_data_4_8.data == l1_cache_4_8) & !l1_data_4_8.last)begin
            l1_ready_4_8 = 1;
        end
        if(l1_valid_4_9 & (l1_data_4_9.data == l1_cache_4_9) & !l1_data_4_9.last)begin
            l1_ready_4_9 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_8 <= 0;
        l1_cache_4_9 <= 0;
    end else begin
        if(l1_all_last_4_4)begin
            l1_cache_4_8 <= 0;
            l1_cache_4_9 <= 0;
        end else begin
            if(l1_valid_4_8 & l1_ready_4_8)begin
                l1_cache_4_8 <= l1_data_4_8.data;
            end
            if(l1_valid_4_9 & l1_ready_4_9)begin
                l1_cache_4_9 <= l1_data_4_9.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_4 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_4) begin
            l2_in_valid_4_4 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_4 <= |l1_grant_4_4;
        end
    end
    //sync case
    if(l1_all_last_4_4) begin
        l2_in_data_4_4.last <= 1;
        l2_in_data_4_4.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_4)
            2'b01: l2_in_data_4_4 <= l1_data_4_8;
            2'b10: l2_in_data_4_4 <= l1_data_4_9;
            default: l2_in_data_4_4 <= 0;
        endcase
    end   
end

assign l1_all_last_4_5 = (l1_data_4_10.last & l1_valid_4_10) & (l1_data_4_11.last & l1_valid_4_11) & !l2_almost_full_4_5;
assign l1_same_4_5 = l1_newdata_4_10 & l1_newdata_4_11 & (l1_data_4_10.data==l1_data_4_11.data) & !l2_almost_full_4_5;
assign l1_newdata_4_10 = l1_valid_4_10 & (l1_data_4_10.data != l1_cache_4_10) & !l1_data_4_10.last;

assign l1_newdata_4_11 = l1_valid_4_11 & (l1_data_4_11.data != l1_cache_4_11) & !l1_data_4_11.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_5[0] = l1_newdata_4_10 & !l2_almost_full_4_5;
    l1_ready_4_10 = l1_grant_4_5[0];       
    l1_req_4_5[1] = l1_newdata_4_11 & !l2_almost_full_4_5;
    l1_ready_4_11 = l1_grant_4_5[1];       
    //sync case
    if(l1_all_last_4_5) begin
        l1_req_4_5 = 0;
        l1_ready_4_10 = 1;
        l1_ready_4_11 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_5)begin
        l1_req_4_5[0] = 1;
        l1_req_4_5[0] = 0;
        l1_ready_4_11 = 1;
    end else begin
        if(l1_valid_4_10 & (l1_data_4_10.data == l1_cache_4_10) & !l1_data_4_10.last)begin
            l1_ready_4_10 = 1;
        end
        if(l1_valid_4_11 & (l1_data_4_11.data == l1_cache_4_11) & !l1_data_4_11.last)begin
            l1_ready_4_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_10 <= 0;
        l1_cache_4_11 <= 0;
    end else begin
        if(l1_all_last_4_5)begin
            l1_cache_4_10 <= 0;
            l1_cache_4_11 <= 0;
        end else begin
            if(l1_valid_4_10 & l1_ready_4_10)begin
                l1_cache_4_10 <= l1_data_4_10.data;
            end
            if(l1_valid_4_11 & l1_ready_4_11)begin
                l1_cache_4_11 <= l1_data_4_11.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_5 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_5) begin
            l2_in_valid_4_5 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_5 <= |l1_grant_4_5;
        end
    end
    //sync case
    if(l1_all_last_4_5) begin
        l2_in_data_4_5.last <= 1;
        l2_in_data_4_5.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_5)
            2'b01: l2_in_data_4_5 <= l1_data_4_10;
            2'b10: l2_in_data_4_5 <= l1_data_4_11;
            default: l2_in_data_4_5 <= 0;
        endcase
    end   
end

assign l1_all_last_4_6 = (l1_data_4_12.last & l1_valid_4_12) & (l1_data_4_13.last & l1_valid_4_13) & !l2_almost_full_4_6;
assign l1_same_4_6 = l1_newdata_4_12 & l1_newdata_4_13 & (l1_data_4_12.data==l1_data_4_13.data) & !l2_almost_full_4_6;
assign l1_newdata_4_12 = l1_valid_4_12 & (l1_data_4_12.data != l1_cache_4_12) & !l1_data_4_12.last;

assign l1_newdata_4_13 = l1_valid_4_13 & (l1_data_4_13.data != l1_cache_4_13) & !l1_data_4_13.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_6[0] = l1_newdata_4_12 & !l2_almost_full_4_6;
    l1_ready_4_12 = l1_grant_4_6[0];       
    l1_req_4_6[1] = l1_newdata_4_13 & !l2_almost_full_4_6;
    l1_ready_4_13 = l1_grant_4_6[1];       
    //sync case
    if(l1_all_last_4_6) begin
        l1_req_4_6 = 0;
        l1_ready_4_12 = 1;
        l1_ready_4_13 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_6)begin
        l1_req_4_6[0] = 1;
        l1_req_4_6[0] = 0;
        l1_ready_4_13 = 1;
    end else begin
        if(l1_valid_4_12 & (l1_data_4_12.data == l1_cache_4_12) & !l1_data_4_12.last)begin
            l1_ready_4_12 = 1;
        end
        if(l1_valid_4_13 & (l1_data_4_13.data == l1_cache_4_13) & !l1_data_4_13.last)begin
            l1_ready_4_13 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_12 <= 0;
        l1_cache_4_13 <= 0;
    end else begin
        if(l1_all_last_4_6)begin
            l1_cache_4_12 <= 0;
            l1_cache_4_13 <= 0;
        end else begin
            if(l1_valid_4_12 & l1_ready_4_12)begin
                l1_cache_4_12 <= l1_data_4_12.data;
            end
            if(l1_valid_4_13 & l1_ready_4_13)begin
                l1_cache_4_13 <= l1_data_4_13.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_6 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_6) begin
            l2_in_valid_4_6 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_6 <= |l1_grant_4_6;
        end
    end
    //sync case
    if(l1_all_last_4_6) begin
        l2_in_data_4_6.last <= 1;
        l2_in_data_4_6.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_6)
            2'b01: l2_in_data_4_6 <= l1_data_4_12;
            2'b10: l2_in_data_4_6 <= l1_data_4_13;
            default: l2_in_data_4_6 <= 0;
        endcase
    end   
end

assign l1_all_last_4_7 = (l1_data_4_14.last & l1_valid_4_14) & (l1_data_4_15.last & l1_valid_4_15) & !l2_almost_full_4_7;
assign l1_same_4_7 = l1_newdata_4_14 & l1_newdata_4_15 & (l1_data_4_14.data==l1_data_4_15.data) & !l2_almost_full_4_7;
assign l1_newdata_4_14 = l1_valid_4_14 & (l1_data_4_14.data != l1_cache_4_14) & !l1_data_4_14.last;

assign l1_newdata_4_15 = l1_valid_4_15 & (l1_data_4_15.data != l1_cache_4_15) & !l1_data_4_15.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_7[0] = l1_newdata_4_14 & !l2_almost_full_4_7;
    l1_ready_4_14 = l1_grant_4_7[0];       
    l1_req_4_7[1] = l1_newdata_4_15 & !l2_almost_full_4_7;
    l1_ready_4_15 = l1_grant_4_7[1];       
    //sync case
    if(l1_all_last_4_7) begin
        l1_req_4_7 = 0;
        l1_ready_4_14 = 1;
        l1_ready_4_15 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_7)begin
        l1_req_4_7[0] = 1;
        l1_req_4_7[0] = 0;
        l1_ready_4_15 = 1;
    end else begin
        if(l1_valid_4_14 & (l1_data_4_14.data == l1_cache_4_14) & !l1_data_4_14.last)begin
            l1_ready_4_14 = 1;
        end
        if(l1_valid_4_15 & (l1_data_4_15.data == l1_cache_4_15) & !l1_data_4_15.last)begin
            l1_ready_4_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_14 <= 0;
        l1_cache_4_15 <= 0;
    end else begin
        if(l1_all_last_4_7)begin
            l1_cache_4_14 <= 0;
            l1_cache_4_15 <= 0;
        end else begin
            if(l1_valid_4_14 & l1_ready_4_14)begin
                l1_cache_4_14 <= l1_data_4_14.data;
            end
            if(l1_valid_4_15 & l1_ready_4_15)begin
                l1_cache_4_15 <= l1_data_4_15.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_7 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_7) begin
            l2_in_valid_4_7 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_7 <= |l1_grant_4_7;
        end
    end
    //sync case
    if(l1_all_last_4_7) begin
        l2_in_data_4_7.last <= 1;
        l2_in_data_4_7.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_7)
            2'b01: l2_in_data_4_7 <= l1_data_4_14;
            2'b10: l2_in_data_4_7 <= l1_data_4_15;
            default: l2_in_data_4_7 <= 0;
        endcase
    end   
end

assign l1_all_last_4_8 = (l1_data_4_16.last & l1_valid_4_16) & (l1_data_4_17.last & l1_valid_4_17) & !l2_almost_full_4_8;
assign l1_same_4_8 = l1_newdata_4_16 & l1_newdata_4_17 & (l1_data_4_16.data==l1_data_4_17.data) & !l2_almost_full_4_8;
assign l1_newdata_4_16 = l1_valid_4_16 & (l1_data_4_16.data != l1_cache_4_16) & !l1_data_4_16.last;

assign l1_newdata_4_17 = l1_valid_4_17 & (l1_data_4_17.data != l1_cache_4_17) & !l1_data_4_17.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_8[0] = l1_newdata_4_16 & !l2_almost_full_4_8;
    l1_ready_4_16 = l1_grant_4_8[0];       
    l1_req_4_8[1] = l1_newdata_4_17 & !l2_almost_full_4_8;
    l1_ready_4_17 = l1_grant_4_8[1];       
    //sync case
    if(l1_all_last_4_8) begin
        l1_req_4_8 = 0;
        l1_ready_4_16 = 1;
        l1_ready_4_17 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_8)begin
        l1_req_4_8[0] = 1;
        l1_req_4_8[0] = 0;
        l1_ready_4_17 = 1;
    end else begin
        if(l1_valid_4_16 & (l1_data_4_16.data == l1_cache_4_16) & !l1_data_4_16.last)begin
            l1_ready_4_16 = 1;
        end
        if(l1_valid_4_17 & (l1_data_4_17.data == l1_cache_4_17) & !l1_data_4_17.last)begin
            l1_ready_4_17 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_16 <= 0;
        l1_cache_4_17 <= 0;
    end else begin
        if(l1_all_last_4_8)begin
            l1_cache_4_16 <= 0;
            l1_cache_4_17 <= 0;
        end else begin
            if(l1_valid_4_16 & l1_ready_4_16)begin
                l1_cache_4_16 <= l1_data_4_16.data;
            end
            if(l1_valid_4_17 & l1_ready_4_17)begin
                l1_cache_4_17 <= l1_data_4_17.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_8 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_8) begin
            l2_in_valid_4_8 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_8 <= |l1_grant_4_8;
        end
    end
    //sync case
    if(l1_all_last_4_8) begin
        l2_in_data_4_8.last <= 1;
        l2_in_data_4_8.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_8)
            2'b01: l2_in_data_4_8 <= l1_data_4_16;
            2'b10: l2_in_data_4_8 <= l1_data_4_17;
            default: l2_in_data_4_8 <= 0;
        endcase
    end   
end

assign l1_all_last_4_9 = (l1_data_4_18.last & l1_valid_4_18) & (l1_data_4_19.last & l1_valid_4_19) & !l2_almost_full_4_9;
assign l1_same_4_9 = l1_newdata_4_18 & l1_newdata_4_19 & (l1_data_4_18.data==l1_data_4_19.data) & !l2_almost_full_4_9;
assign l1_newdata_4_18 = l1_valid_4_18 & (l1_data_4_18.data != l1_cache_4_18) & !l1_data_4_18.last;

assign l1_newdata_4_19 = l1_valid_4_19 & (l1_data_4_19.data != l1_cache_4_19) & !l1_data_4_19.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_9[0] = l1_newdata_4_18 & !l2_almost_full_4_9;
    l1_ready_4_18 = l1_grant_4_9[0];       
    l1_req_4_9[1] = l1_newdata_4_19 & !l2_almost_full_4_9;
    l1_ready_4_19 = l1_grant_4_9[1];       
    //sync case
    if(l1_all_last_4_9) begin
        l1_req_4_9 = 0;
        l1_ready_4_18 = 1;
        l1_ready_4_19 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_9)begin
        l1_req_4_9[0] = 1;
        l1_req_4_9[0] = 0;
        l1_ready_4_19 = 1;
    end else begin
        if(l1_valid_4_18 & (l1_data_4_18.data == l1_cache_4_18) & !l1_data_4_18.last)begin
            l1_ready_4_18 = 1;
        end
        if(l1_valid_4_19 & (l1_data_4_19.data == l1_cache_4_19) & !l1_data_4_19.last)begin
            l1_ready_4_19 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_18 <= 0;
        l1_cache_4_19 <= 0;
    end else begin
        if(l1_all_last_4_9)begin
            l1_cache_4_18 <= 0;
            l1_cache_4_19 <= 0;
        end else begin
            if(l1_valid_4_18 & l1_ready_4_18)begin
                l1_cache_4_18 <= l1_data_4_18.data;
            end
            if(l1_valid_4_19 & l1_ready_4_19)begin
                l1_cache_4_19 <= l1_data_4_19.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_9 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_9) begin
            l2_in_valid_4_9 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_9 <= |l1_grant_4_9;
        end
    end
    //sync case
    if(l1_all_last_4_9) begin
        l2_in_data_4_9.last <= 1;
        l2_in_data_4_9.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_9)
            2'b01: l2_in_data_4_9 <= l1_data_4_18;
            2'b10: l2_in_data_4_9 <= l1_data_4_19;
            default: l2_in_data_4_9 <= 0;
        endcase
    end   
end

assign l1_all_last_4_10 = (l1_data_4_20.last & l1_valid_4_20) & (l1_data_4_21.last & l1_valid_4_21) & !l2_almost_full_4_10;
assign l1_same_4_10 = l1_newdata_4_20 & l1_newdata_4_21 & (l1_data_4_20.data==l1_data_4_21.data) & !l2_almost_full_4_10;
assign l1_newdata_4_20 = l1_valid_4_20 & (l1_data_4_20.data != l1_cache_4_20) & !l1_data_4_20.last;

assign l1_newdata_4_21 = l1_valid_4_21 & (l1_data_4_21.data != l1_cache_4_21) & !l1_data_4_21.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_10[0] = l1_newdata_4_20 & !l2_almost_full_4_10;
    l1_ready_4_20 = l1_grant_4_10[0];       
    l1_req_4_10[1] = l1_newdata_4_21 & !l2_almost_full_4_10;
    l1_ready_4_21 = l1_grant_4_10[1];       
    //sync case
    if(l1_all_last_4_10) begin
        l1_req_4_10 = 0;
        l1_ready_4_20 = 1;
        l1_ready_4_21 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_10)begin
        l1_req_4_10[0] = 1;
        l1_req_4_10[0] = 0;
        l1_ready_4_21 = 1;
    end else begin
        if(l1_valid_4_20 & (l1_data_4_20.data == l1_cache_4_20) & !l1_data_4_20.last)begin
            l1_ready_4_20 = 1;
        end
        if(l1_valid_4_21 & (l1_data_4_21.data == l1_cache_4_21) & !l1_data_4_21.last)begin
            l1_ready_4_21 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_20 <= 0;
        l1_cache_4_21 <= 0;
    end else begin
        if(l1_all_last_4_10)begin
            l1_cache_4_20 <= 0;
            l1_cache_4_21 <= 0;
        end else begin
            if(l1_valid_4_20 & l1_ready_4_20)begin
                l1_cache_4_20 <= l1_data_4_20.data;
            end
            if(l1_valid_4_21 & l1_ready_4_21)begin
                l1_cache_4_21 <= l1_data_4_21.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_10 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_10) begin
            l2_in_valid_4_10 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_10 <= |l1_grant_4_10;
        end
    end
    //sync case
    if(l1_all_last_4_10) begin
        l2_in_data_4_10.last <= 1;
        l2_in_data_4_10.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_10)
            2'b01: l2_in_data_4_10 <= l1_data_4_20;
            2'b10: l2_in_data_4_10 <= l1_data_4_21;
            default: l2_in_data_4_10 <= 0;
        endcase
    end   
end

assign l1_all_last_4_11 = (l1_data_4_22.last & l1_valid_4_22) & (l1_data_4_23.last & l1_valid_4_23) & !l2_almost_full_4_11;
assign l1_same_4_11 = l1_newdata_4_22 & l1_newdata_4_23 & (l1_data_4_22.data==l1_data_4_23.data) & !l2_almost_full_4_11;
assign l1_newdata_4_22 = l1_valid_4_22 & (l1_data_4_22.data != l1_cache_4_22) & !l1_data_4_22.last;

assign l1_newdata_4_23 = l1_valid_4_23 & (l1_data_4_23.data != l1_cache_4_23) & !l1_data_4_23.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_11[0] = l1_newdata_4_22 & !l2_almost_full_4_11;
    l1_ready_4_22 = l1_grant_4_11[0];       
    l1_req_4_11[1] = l1_newdata_4_23 & !l2_almost_full_4_11;
    l1_ready_4_23 = l1_grant_4_11[1];       
    //sync case
    if(l1_all_last_4_11) begin
        l1_req_4_11 = 0;
        l1_ready_4_22 = 1;
        l1_ready_4_23 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_11)begin
        l1_req_4_11[0] = 1;
        l1_req_4_11[0] = 0;
        l1_ready_4_23 = 1;
    end else begin
        if(l1_valid_4_22 & (l1_data_4_22.data == l1_cache_4_22) & !l1_data_4_22.last)begin
            l1_ready_4_22 = 1;
        end
        if(l1_valid_4_23 & (l1_data_4_23.data == l1_cache_4_23) & !l1_data_4_23.last)begin
            l1_ready_4_23 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_22 <= 0;
        l1_cache_4_23 <= 0;
    end else begin
        if(l1_all_last_4_11)begin
            l1_cache_4_22 <= 0;
            l1_cache_4_23 <= 0;
        end else begin
            if(l1_valid_4_22 & l1_ready_4_22)begin
                l1_cache_4_22 <= l1_data_4_22.data;
            end
            if(l1_valid_4_23 & l1_ready_4_23)begin
                l1_cache_4_23 <= l1_data_4_23.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_11 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_11) begin
            l2_in_valid_4_11 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_11 <= |l1_grant_4_11;
        end
    end
    //sync case
    if(l1_all_last_4_11) begin
        l2_in_data_4_11.last <= 1;
        l2_in_data_4_11.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_11)
            2'b01: l2_in_data_4_11 <= l1_data_4_22;
            2'b10: l2_in_data_4_11 <= l1_data_4_23;
            default: l2_in_data_4_11 <= 0;
        endcase
    end   
end

assign l1_all_last_4_12 = (l1_data_4_24.last & l1_valid_4_24) & (l1_data_4_25.last & l1_valid_4_25) & !l2_almost_full_4_12;
assign l1_same_4_12 = l1_newdata_4_24 & l1_newdata_4_25 & (l1_data_4_24.data==l1_data_4_25.data) & !l2_almost_full_4_12;
assign l1_newdata_4_24 = l1_valid_4_24 & (l1_data_4_24.data != l1_cache_4_24) & !l1_data_4_24.last;

assign l1_newdata_4_25 = l1_valid_4_25 & (l1_data_4_25.data != l1_cache_4_25) & !l1_data_4_25.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_12[0] = l1_newdata_4_24 & !l2_almost_full_4_12;
    l1_ready_4_24 = l1_grant_4_12[0];       
    l1_req_4_12[1] = l1_newdata_4_25 & !l2_almost_full_4_12;
    l1_ready_4_25 = l1_grant_4_12[1];       
    //sync case
    if(l1_all_last_4_12) begin
        l1_req_4_12 = 0;
        l1_ready_4_24 = 1;
        l1_ready_4_25 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_12)begin
        l1_req_4_12[0] = 1;
        l1_req_4_12[0] = 0;
        l1_ready_4_25 = 1;
    end else begin
        if(l1_valid_4_24 & (l1_data_4_24.data == l1_cache_4_24) & !l1_data_4_24.last)begin
            l1_ready_4_24 = 1;
        end
        if(l1_valid_4_25 & (l1_data_4_25.data == l1_cache_4_25) & !l1_data_4_25.last)begin
            l1_ready_4_25 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_24 <= 0;
        l1_cache_4_25 <= 0;
    end else begin
        if(l1_all_last_4_12)begin
            l1_cache_4_24 <= 0;
            l1_cache_4_25 <= 0;
        end else begin
            if(l1_valid_4_24 & l1_ready_4_24)begin
                l1_cache_4_24 <= l1_data_4_24.data;
            end
            if(l1_valid_4_25 & l1_ready_4_25)begin
                l1_cache_4_25 <= l1_data_4_25.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_12 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_12) begin
            l2_in_valid_4_12 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_12 <= |l1_grant_4_12;
        end
    end
    //sync case
    if(l1_all_last_4_12) begin
        l2_in_data_4_12.last <= 1;
        l2_in_data_4_12.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_12)
            2'b01: l2_in_data_4_12 <= l1_data_4_24;
            2'b10: l2_in_data_4_12 <= l1_data_4_25;
            default: l2_in_data_4_12 <= 0;
        endcase
    end   
end

assign l1_all_last_4_13 = (l1_data_4_26.last & l1_valid_4_26) & (l1_data_4_27.last & l1_valid_4_27) & !l2_almost_full_4_13;
assign l1_same_4_13 = l1_newdata_4_26 & l1_newdata_4_27 & (l1_data_4_26.data==l1_data_4_27.data) & !l2_almost_full_4_13;
assign l1_newdata_4_26 = l1_valid_4_26 & (l1_data_4_26.data != l1_cache_4_26) & !l1_data_4_26.last;

assign l1_newdata_4_27 = l1_valid_4_27 & (l1_data_4_27.data != l1_cache_4_27) & !l1_data_4_27.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_13[0] = l1_newdata_4_26 & !l2_almost_full_4_13;
    l1_ready_4_26 = l1_grant_4_13[0];       
    l1_req_4_13[1] = l1_newdata_4_27 & !l2_almost_full_4_13;
    l1_ready_4_27 = l1_grant_4_13[1];       
    //sync case
    if(l1_all_last_4_13) begin
        l1_req_4_13 = 0;
        l1_ready_4_26 = 1;
        l1_ready_4_27 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_13)begin
        l1_req_4_13[0] = 1;
        l1_req_4_13[0] = 0;
        l1_ready_4_27 = 1;
    end else begin
        if(l1_valid_4_26 & (l1_data_4_26.data == l1_cache_4_26) & !l1_data_4_26.last)begin
            l1_ready_4_26 = 1;
        end
        if(l1_valid_4_27 & (l1_data_4_27.data == l1_cache_4_27) & !l1_data_4_27.last)begin
            l1_ready_4_27 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_26 <= 0;
        l1_cache_4_27 <= 0;
    end else begin
        if(l1_all_last_4_13)begin
            l1_cache_4_26 <= 0;
            l1_cache_4_27 <= 0;
        end else begin
            if(l1_valid_4_26 & l1_ready_4_26)begin
                l1_cache_4_26 <= l1_data_4_26.data;
            end
            if(l1_valid_4_27 & l1_ready_4_27)begin
                l1_cache_4_27 <= l1_data_4_27.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_13 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_13) begin
            l2_in_valid_4_13 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_13 <= |l1_grant_4_13;
        end
    end
    //sync case
    if(l1_all_last_4_13) begin
        l2_in_data_4_13.last <= 1;
        l2_in_data_4_13.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_13)
            2'b01: l2_in_data_4_13 <= l1_data_4_26;
            2'b10: l2_in_data_4_13 <= l1_data_4_27;
            default: l2_in_data_4_13 <= 0;
        endcase
    end   
end

assign l1_all_last_4_14 = (l1_data_4_28.last & l1_valid_4_28) & (l1_data_4_29.last & l1_valid_4_29) & !l2_almost_full_4_14;
assign l1_same_4_14 = l1_newdata_4_28 & l1_newdata_4_29 & (l1_data_4_28.data==l1_data_4_29.data) & !l2_almost_full_4_14;
assign l1_newdata_4_28 = l1_valid_4_28 & (l1_data_4_28.data != l1_cache_4_28) & !l1_data_4_28.last;

assign l1_newdata_4_29 = l1_valid_4_29 & (l1_data_4_29.data != l1_cache_4_29) & !l1_data_4_29.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_14[0] = l1_newdata_4_28 & !l2_almost_full_4_14;
    l1_ready_4_28 = l1_grant_4_14[0];       
    l1_req_4_14[1] = l1_newdata_4_29 & !l2_almost_full_4_14;
    l1_ready_4_29 = l1_grant_4_14[1];       
    //sync case
    if(l1_all_last_4_14) begin
        l1_req_4_14 = 0;
        l1_ready_4_28 = 1;
        l1_ready_4_29 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_14)begin
        l1_req_4_14[0] = 1;
        l1_req_4_14[0] = 0;
        l1_ready_4_29 = 1;
    end else begin
        if(l1_valid_4_28 & (l1_data_4_28.data == l1_cache_4_28) & !l1_data_4_28.last)begin
            l1_ready_4_28 = 1;
        end
        if(l1_valid_4_29 & (l1_data_4_29.data == l1_cache_4_29) & !l1_data_4_29.last)begin
            l1_ready_4_29 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_28 <= 0;
        l1_cache_4_29 <= 0;
    end else begin
        if(l1_all_last_4_14)begin
            l1_cache_4_28 <= 0;
            l1_cache_4_29 <= 0;
        end else begin
            if(l1_valid_4_28 & l1_ready_4_28)begin
                l1_cache_4_28 <= l1_data_4_28.data;
            end
            if(l1_valid_4_29 & l1_ready_4_29)begin
                l1_cache_4_29 <= l1_data_4_29.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_14 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_14) begin
            l2_in_valid_4_14 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_14 <= |l1_grant_4_14;
        end
    end
    //sync case
    if(l1_all_last_4_14) begin
        l2_in_data_4_14.last <= 1;
        l2_in_data_4_14.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_14)
            2'b01: l2_in_data_4_14 <= l1_data_4_28;
            2'b10: l2_in_data_4_14 <= l1_data_4_29;
            default: l2_in_data_4_14 <= 0;
        endcase
    end   
end

assign l1_all_last_4_15 = (l1_data_4_30.last & l1_valid_4_30) & (l1_data_4_31.last & l1_valid_4_31) & !l2_almost_full_4_15;
assign l1_same_4_15 = l1_newdata_4_30 & l1_newdata_4_31 & (l1_data_4_30.data==l1_data_4_31.data) & !l2_almost_full_4_15;
assign l1_newdata_4_30 = l1_valid_4_30 & (l1_data_4_30.data != l1_cache_4_30) & !l1_data_4_30.last;

assign l1_newdata_4_31 = l1_valid_4_31 & (l1_data_4_31.data != l1_cache_4_31) & !l1_data_4_31.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_4_15[0] = l1_newdata_4_30 & !l2_almost_full_4_15;
    l1_ready_4_30 = l1_grant_4_15[0];       
    l1_req_4_15[1] = l1_newdata_4_31 & !l2_almost_full_4_15;
    l1_ready_4_31 = l1_grant_4_15[1];       
    //sync case
    if(l1_all_last_4_15) begin
        l1_req_4_15 = 0;
        l1_ready_4_30 = 1;
        l1_ready_4_31 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_4_15)begin
        l1_req_4_15[0] = 1;
        l1_req_4_15[0] = 0;
        l1_ready_4_31 = 1;
    end else begin
        if(l1_valid_4_30 & (l1_data_4_30.data == l1_cache_4_30) & !l1_data_4_30.last)begin
            l1_ready_4_30 = 1;
        end
        if(l1_valid_4_31 & (l1_data_4_31.data == l1_cache_4_31) & !l1_data_4_31.last)begin
            l1_ready_4_31 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_4_30 <= 0;
        l1_cache_4_31 <= 0;
    end else begin
        if(l1_all_last_4_15)begin
            l1_cache_4_30 <= 0;
            l1_cache_4_31 <= 0;
        end else begin
            if(l1_valid_4_30 & l1_ready_4_30)begin
                l1_cache_4_30 <= l1_data_4_30.data;
            end
            if(l1_valid_4_31 & l1_ready_4_31)begin
                l1_cache_4_31 <= l1_data_4_31.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_4_15 <= 0;
    end else begin
        //sync case
        if(l1_all_last_4_15) begin
            l2_in_valid_4_15 <= 1;
        //normal case
        end else begin
            l2_in_valid_4_15 <= |l1_grant_4_15;
        end
    end
    //sync case
    if(l1_all_last_4_15) begin
        l2_in_data_4_15.last <= 1;
        l2_in_data_4_15.data <= 0;
    //normal case
    end else begin
        case(l1_grant_4_15)
            2'b01: l2_in_data_4_15 <= l1_data_4_30;
            2'b10: l2_in_data_4_15 <= l1_data_4_31;
            default: l2_in_data_4_15 <= 0;
        endcase
    end   
end

assign l1_all_last_5_0 = (l1_data_5_0.last & l1_valid_5_0) & (l1_data_5_1.last & l1_valid_5_1) & !l2_almost_full_5_0;
assign l1_same_5_0 = l1_newdata_5_0 & l1_newdata_5_1 & (l1_data_5_0.data==l1_data_5_1.data) & !l2_almost_full_5_0;
assign l1_newdata_5_0 = l1_valid_5_0 & (l1_data_5_0.data != l1_cache_5_0) & !l1_data_5_0.last;

assign l1_newdata_5_1 = l1_valid_5_1 & (l1_data_5_1.data != l1_cache_5_1) & !l1_data_5_1.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_0[0] = l1_newdata_5_0 & !l2_almost_full_5_0;
    l1_ready_5_0 = l1_grant_5_0[0];       
    l1_req_5_0[1] = l1_newdata_5_1 & !l2_almost_full_5_0;
    l1_ready_5_1 = l1_grant_5_0[1];       
    //sync case
    if(l1_all_last_5_0) begin
        l1_req_5_0 = 0;
        l1_ready_5_0 = 1;
        l1_ready_5_1 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_0)begin
        l1_req_5_0[0] = 1;
        l1_req_5_0[0] = 0;
        l1_ready_5_1 = 1;
    end else begin
        if(l1_valid_5_0 & (l1_data_5_0.data == l1_cache_5_0) & !l1_data_5_0.last)begin
            l1_ready_5_0 = 1;
        end
        if(l1_valid_5_1 & (l1_data_5_1.data == l1_cache_5_1) & !l1_data_5_1.last)begin
            l1_ready_5_1 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_0 <= 0;
        l1_cache_5_1 <= 0;
    end else begin
        if(l1_all_last_5_0)begin
            l1_cache_5_0 <= 0;
            l1_cache_5_1 <= 0;
        end else begin
            if(l1_valid_5_0 & l1_ready_5_0)begin
                l1_cache_5_0 <= l1_data_5_0.data;
            end
            if(l1_valid_5_1 & l1_ready_5_1)begin
                l1_cache_5_1 <= l1_data_5_1.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_0 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_0) begin
            l2_in_valid_5_0 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_0 <= |l1_grant_5_0;
        end
    end
    //sync case
    if(l1_all_last_5_0) begin
        l2_in_data_5_0.last <= 1;
        l2_in_data_5_0.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_0)
            2'b01: l2_in_data_5_0 <= l1_data_5_0;
            2'b10: l2_in_data_5_0 <= l1_data_5_1;
            default: l2_in_data_5_0 <= 0;
        endcase
    end   
end

assign l1_all_last_5_1 = (l1_data_5_2.last & l1_valid_5_2) & (l1_data_5_3.last & l1_valid_5_3) & !l2_almost_full_5_1;
assign l1_same_5_1 = l1_newdata_5_2 & l1_newdata_5_3 & (l1_data_5_2.data==l1_data_5_3.data) & !l2_almost_full_5_1;
assign l1_newdata_5_2 = l1_valid_5_2 & (l1_data_5_2.data != l1_cache_5_2) & !l1_data_5_2.last;

assign l1_newdata_5_3 = l1_valid_5_3 & (l1_data_5_3.data != l1_cache_5_3) & !l1_data_5_3.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_1[0] = l1_newdata_5_2 & !l2_almost_full_5_1;
    l1_ready_5_2 = l1_grant_5_1[0];       
    l1_req_5_1[1] = l1_newdata_5_3 & !l2_almost_full_5_1;
    l1_ready_5_3 = l1_grant_5_1[1];       
    //sync case
    if(l1_all_last_5_1) begin
        l1_req_5_1 = 0;
        l1_ready_5_2 = 1;
        l1_ready_5_3 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_1)begin
        l1_req_5_1[0] = 1;
        l1_req_5_1[0] = 0;
        l1_ready_5_3 = 1;
    end else begin
        if(l1_valid_5_2 & (l1_data_5_2.data == l1_cache_5_2) & !l1_data_5_2.last)begin
            l1_ready_5_2 = 1;
        end
        if(l1_valid_5_3 & (l1_data_5_3.data == l1_cache_5_3) & !l1_data_5_3.last)begin
            l1_ready_5_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_2 <= 0;
        l1_cache_5_3 <= 0;
    end else begin
        if(l1_all_last_5_1)begin
            l1_cache_5_2 <= 0;
            l1_cache_5_3 <= 0;
        end else begin
            if(l1_valid_5_2 & l1_ready_5_2)begin
                l1_cache_5_2 <= l1_data_5_2.data;
            end
            if(l1_valid_5_3 & l1_ready_5_3)begin
                l1_cache_5_3 <= l1_data_5_3.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_1 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_1) begin
            l2_in_valid_5_1 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_1 <= |l1_grant_5_1;
        end
    end
    //sync case
    if(l1_all_last_5_1) begin
        l2_in_data_5_1.last <= 1;
        l2_in_data_5_1.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_1)
            2'b01: l2_in_data_5_1 <= l1_data_5_2;
            2'b10: l2_in_data_5_1 <= l1_data_5_3;
            default: l2_in_data_5_1 <= 0;
        endcase
    end   
end

assign l1_all_last_5_2 = (l1_data_5_4.last & l1_valid_5_4) & (l1_data_5_5.last & l1_valid_5_5) & !l2_almost_full_5_2;
assign l1_same_5_2 = l1_newdata_5_4 & l1_newdata_5_5 & (l1_data_5_4.data==l1_data_5_5.data) & !l2_almost_full_5_2;
assign l1_newdata_5_4 = l1_valid_5_4 & (l1_data_5_4.data != l1_cache_5_4) & !l1_data_5_4.last;

assign l1_newdata_5_5 = l1_valid_5_5 & (l1_data_5_5.data != l1_cache_5_5) & !l1_data_5_5.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_2[0] = l1_newdata_5_4 & !l2_almost_full_5_2;
    l1_ready_5_4 = l1_grant_5_2[0];       
    l1_req_5_2[1] = l1_newdata_5_5 & !l2_almost_full_5_2;
    l1_ready_5_5 = l1_grant_5_2[1];       
    //sync case
    if(l1_all_last_5_2) begin
        l1_req_5_2 = 0;
        l1_ready_5_4 = 1;
        l1_ready_5_5 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_2)begin
        l1_req_5_2[0] = 1;
        l1_req_5_2[0] = 0;
        l1_ready_5_5 = 1;
    end else begin
        if(l1_valid_5_4 & (l1_data_5_4.data == l1_cache_5_4) & !l1_data_5_4.last)begin
            l1_ready_5_4 = 1;
        end
        if(l1_valid_5_5 & (l1_data_5_5.data == l1_cache_5_5) & !l1_data_5_5.last)begin
            l1_ready_5_5 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_4 <= 0;
        l1_cache_5_5 <= 0;
    end else begin
        if(l1_all_last_5_2)begin
            l1_cache_5_4 <= 0;
            l1_cache_5_5 <= 0;
        end else begin
            if(l1_valid_5_4 & l1_ready_5_4)begin
                l1_cache_5_4 <= l1_data_5_4.data;
            end
            if(l1_valid_5_5 & l1_ready_5_5)begin
                l1_cache_5_5 <= l1_data_5_5.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_2 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_2) begin
            l2_in_valid_5_2 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_2 <= |l1_grant_5_2;
        end
    end
    //sync case
    if(l1_all_last_5_2) begin
        l2_in_data_5_2.last <= 1;
        l2_in_data_5_2.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_2)
            2'b01: l2_in_data_5_2 <= l1_data_5_4;
            2'b10: l2_in_data_5_2 <= l1_data_5_5;
            default: l2_in_data_5_2 <= 0;
        endcase
    end   
end

assign l1_all_last_5_3 = (l1_data_5_6.last & l1_valid_5_6) & (l1_data_5_7.last & l1_valid_5_7) & !l2_almost_full_5_3;
assign l1_same_5_3 = l1_newdata_5_6 & l1_newdata_5_7 & (l1_data_5_6.data==l1_data_5_7.data) & !l2_almost_full_5_3;
assign l1_newdata_5_6 = l1_valid_5_6 & (l1_data_5_6.data != l1_cache_5_6) & !l1_data_5_6.last;

assign l1_newdata_5_7 = l1_valid_5_7 & (l1_data_5_7.data != l1_cache_5_7) & !l1_data_5_7.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_3[0] = l1_newdata_5_6 & !l2_almost_full_5_3;
    l1_ready_5_6 = l1_grant_5_3[0];       
    l1_req_5_3[1] = l1_newdata_5_7 & !l2_almost_full_5_3;
    l1_ready_5_7 = l1_grant_5_3[1];       
    //sync case
    if(l1_all_last_5_3) begin
        l1_req_5_3 = 0;
        l1_ready_5_6 = 1;
        l1_ready_5_7 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_3)begin
        l1_req_5_3[0] = 1;
        l1_req_5_3[0] = 0;
        l1_ready_5_7 = 1;
    end else begin
        if(l1_valid_5_6 & (l1_data_5_6.data == l1_cache_5_6) & !l1_data_5_6.last)begin
            l1_ready_5_6 = 1;
        end
        if(l1_valid_5_7 & (l1_data_5_7.data == l1_cache_5_7) & !l1_data_5_7.last)begin
            l1_ready_5_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_6 <= 0;
        l1_cache_5_7 <= 0;
    end else begin
        if(l1_all_last_5_3)begin
            l1_cache_5_6 <= 0;
            l1_cache_5_7 <= 0;
        end else begin
            if(l1_valid_5_6 & l1_ready_5_6)begin
                l1_cache_5_6 <= l1_data_5_6.data;
            end
            if(l1_valid_5_7 & l1_ready_5_7)begin
                l1_cache_5_7 <= l1_data_5_7.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_3 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_3) begin
            l2_in_valid_5_3 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_3 <= |l1_grant_5_3;
        end
    end
    //sync case
    if(l1_all_last_5_3) begin
        l2_in_data_5_3.last <= 1;
        l2_in_data_5_3.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_3)
            2'b01: l2_in_data_5_3 <= l1_data_5_6;
            2'b10: l2_in_data_5_3 <= l1_data_5_7;
            default: l2_in_data_5_3 <= 0;
        endcase
    end   
end

assign l1_all_last_5_4 = (l1_data_5_8.last & l1_valid_5_8) & (l1_data_5_9.last & l1_valid_5_9) & !l2_almost_full_5_4;
assign l1_same_5_4 = l1_newdata_5_8 & l1_newdata_5_9 & (l1_data_5_8.data==l1_data_5_9.data) & !l2_almost_full_5_4;
assign l1_newdata_5_8 = l1_valid_5_8 & (l1_data_5_8.data != l1_cache_5_8) & !l1_data_5_8.last;

assign l1_newdata_5_9 = l1_valid_5_9 & (l1_data_5_9.data != l1_cache_5_9) & !l1_data_5_9.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_4[0] = l1_newdata_5_8 & !l2_almost_full_5_4;
    l1_ready_5_8 = l1_grant_5_4[0];       
    l1_req_5_4[1] = l1_newdata_5_9 & !l2_almost_full_5_4;
    l1_ready_5_9 = l1_grant_5_4[1];       
    //sync case
    if(l1_all_last_5_4) begin
        l1_req_5_4 = 0;
        l1_ready_5_8 = 1;
        l1_ready_5_9 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_4)begin
        l1_req_5_4[0] = 1;
        l1_req_5_4[0] = 0;
        l1_ready_5_9 = 1;
    end else begin
        if(l1_valid_5_8 & (l1_data_5_8.data == l1_cache_5_8) & !l1_data_5_8.last)begin
            l1_ready_5_8 = 1;
        end
        if(l1_valid_5_9 & (l1_data_5_9.data == l1_cache_5_9) & !l1_data_5_9.last)begin
            l1_ready_5_9 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_8 <= 0;
        l1_cache_5_9 <= 0;
    end else begin
        if(l1_all_last_5_4)begin
            l1_cache_5_8 <= 0;
            l1_cache_5_9 <= 0;
        end else begin
            if(l1_valid_5_8 & l1_ready_5_8)begin
                l1_cache_5_8 <= l1_data_5_8.data;
            end
            if(l1_valid_5_9 & l1_ready_5_9)begin
                l1_cache_5_9 <= l1_data_5_9.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_4 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_4) begin
            l2_in_valid_5_4 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_4 <= |l1_grant_5_4;
        end
    end
    //sync case
    if(l1_all_last_5_4) begin
        l2_in_data_5_4.last <= 1;
        l2_in_data_5_4.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_4)
            2'b01: l2_in_data_5_4 <= l1_data_5_8;
            2'b10: l2_in_data_5_4 <= l1_data_5_9;
            default: l2_in_data_5_4 <= 0;
        endcase
    end   
end

assign l1_all_last_5_5 = (l1_data_5_10.last & l1_valid_5_10) & (l1_data_5_11.last & l1_valid_5_11) & !l2_almost_full_5_5;
assign l1_same_5_5 = l1_newdata_5_10 & l1_newdata_5_11 & (l1_data_5_10.data==l1_data_5_11.data) & !l2_almost_full_5_5;
assign l1_newdata_5_10 = l1_valid_5_10 & (l1_data_5_10.data != l1_cache_5_10) & !l1_data_5_10.last;

assign l1_newdata_5_11 = l1_valid_5_11 & (l1_data_5_11.data != l1_cache_5_11) & !l1_data_5_11.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_5[0] = l1_newdata_5_10 & !l2_almost_full_5_5;
    l1_ready_5_10 = l1_grant_5_5[0];       
    l1_req_5_5[1] = l1_newdata_5_11 & !l2_almost_full_5_5;
    l1_ready_5_11 = l1_grant_5_5[1];       
    //sync case
    if(l1_all_last_5_5) begin
        l1_req_5_5 = 0;
        l1_ready_5_10 = 1;
        l1_ready_5_11 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_5)begin
        l1_req_5_5[0] = 1;
        l1_req_5_5[0] = 0;
        l1_ready_5_11 = 1;
    end else begin
        if(l1_valid_5_10 & (l1_data_5_10.data == l1_cache_5_10) & !l1_data_5_10.last)begin
            l1_ready_5_10 = 1;
        end
        if(l1_valid_5_11 & (l1_data_5_11.data == l1_cache_5_11) & !l1_data_5_11.last)begin
            l1_ready_5_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_10 <= 0;
        l1_cache_5_11 <= 0;
    end else begin
        if(l1_all_last_5_5)begin
            l1_cache_5_10 <= 0;
            l1_cache_5_11 <= 0;
        end else begin
            if(l1_valid_5_10 & l1_ready_5_10)begin
                l1_cache_5_10 <= l1_data_5_10.data;
            end
            if(l1_valid_5_11 & l1_ready_5_11)begin
                l1_cache_5_11 <= l1_data_5_11.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_5 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_5) begin
            l2_in_valid_5_5 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_5 <= |l1_grant_5_5;
        end
    end
    //sync case
    if(l1_all_last_5_5) begin
        l2_in_data_5_5.last <= 1;
        l2_in_data_5_5.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_5)
            2'b01: l2_in_data_5_5 <= l1_data_5_10;
            2'b10: l2_in_data_5_5 <= l1_data_5_11;
            default: l2_in_data_5_5 <= 0;
        endcase
    end   
end

assign l1_all_last_5_6 = (l1_data_5_12.last & l1_valid_5_12) & (l1_data_5_13.last & l1_valid_5_13) & !l2_almost_full_5_6;
assign l1_same_5_6 = l1_newdata_5_12 & l1_newdata_5_13 & (l1_data_5_12.data==l1_data_5_13.data) & !l2_almost_full_5_6;
assign l1_newdata_5_12 = l1_valid_5_12 & (l1_data_5_12.data != l1_cache_5_12) & !l1_data_5_12.last;

assign l1_newdata_5_13 = l1_valid_5_13 & (l1_data_5_13.data != l1_cache_5_13) & !l1_data_5_13.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_6[0] = l1_newdata_5_12 & !l2_almost_full_5_6;
    l1_ready_5_12 = l1_grant_5_6[0];       
    l1_req_5_6[1] = l1_newdata_5_13 & !l2_almost_full_5_6;
    l1_ready_5_13 = l1_grant_5_6[1];       
    //sync case
    if(l1_all_last_5_6) begin
        l1_req_5_6 = 0;
        l1_ready_5_12 = 1;
        l1_ready_5_13 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_6)begin
        l1_req_5_6[0] = 1;
        l1_req_5_6[0] = 0;
        l1_ready_5_13 = 1;
    end else begin
        if(l1_valid_5_12 & (l1_data_5_12.data == l1_cache_5_12) & !l1_data_5_12.last)begin
            l1_ready_5_12 = 1;
        end
        if(l1_valid_5_13 & (l1_data_5_13.data == l1_cache_5_13) & !l1_data_5_13.last)begin
            l1_ready_5_13 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_12 <= 0;
        l1_cache_5_13 <= 0;
    end else begin
        if(l1_all_last_5_6)begin
            l1_cache_5_12 <= 0;
            l1_cache_5_13 <= 0;
        end else begin
            if(l1_valid_5_12 & l1_ready_5_12)begin
                l1_cache_5_12 <= l1_data_5_12.data;
            end
            if(l1_valid_5_13 & l1_ready_5_13)begin
                l1_cache_5_13 <= l1_data_5_13.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_6 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_6) begin
            l2_in_valid_5_6 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_6 <= |l1_grant_5_6;
        end
    end
    //sync case
    if(l1_all_last_5_6) begin
        l2_in_data_5_6.last <= 1;
        l2_in_data_5_6.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_6)
            2'b01: l2_in_data_5_6 <= l1_data_5_12;
            2'b10: l2_in_data_5_6 <= l1_data_5_13;
            default: l2_in_data_5_6 <= 0;
        endcase
    end   
end

assign l1_all_last_5_7 = (l1_data_5_14.last & l1_valid_5_14) & (l1_data_5_15.last & l1_valid_5_15) & !l2_almost_full_5_7;
assign l1_same_5_7 = l1_newdata_5_14 & l1_newdata_5_15 & (l1_data_5_14.data==l1_data_5_15.data) & !l2_almost_full_5_7;
assign l1_newdata_5_14 = l1_valid_5_14 & (l1_data_5_14.data != l1_cache_5_14) & !l1_data_5_14.last;

assign l1_newdata_5_15 = l1_valid_5_15 & (l1_data_5_15.data != l1_cache_5_15) & !l1_data_5_15.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_7[0] = l1_newdata_5_14 & !l2_almost_full_5_7;
    l1_ready_5_14 = l1_grant_5_7[0];       
    l1_req_5_7[1] = l1_newdata_5_15 & !l2_almost_full_5_7;
    l1_ready_5_15 = l1_grant_5_7[1];       
    //sync case
    if(l1_all_last_5_7) begin
        l1_req_5_7 = 0;
        l1_ready_5_14 = 1;
        l1_ready_5_15 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_7)begin
        l1_req_5_7[0] = 1;
        l1_req_5_7[0] = 0;
        l1_ready_5_15 = 1;
    end else begin
        if(l1_valid_5_14 & (l1_data_5_14.data == l1_cache_5_14) & !l1_data_5_14.last)begin
            l1_ready_5_14 = 1;
        end
        if(l1_valid_5_15 & (l1_data_5_15.data == l1_cache_5_15) & !l1_data_5_15.last)begin
            l1_ready_5_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_14 <= 0;
        l1_cache_5_15 <= 0;
    end else begin
        if(l1_all_last_5_7)begin
            l1_cache_5_14 <= 0;
            l1_cache_5_15 <= 0;
        end else begin
            if(l1_valid_5_14 & l1_ready_5_14)begin
                l1_cache_5_14 <= l1_data_5_14.data;
            end
            if(l1_valid_5_15 & l1_ready_5_15)begin
                l1_cache_5_15 <= l1_data_5_15.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_7 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_7) begin
            l2_in_valid_5_7 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_7 <= |l1_grant_5_7;
        end
    end
    //sync case
    if(l1_all_last_5_7) begin
        l2_in_data_5_7.last <= 1;
        l2_in_data_5_7.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_7)
            2'b01: l2_in_data_5_7 <= l1_data_5_14;
            2'b10: l2_in_data_5_7 <= l1_data_5_15;
            default: l2_in_data_5_7 <= 0;
        endcase
    end   
end

assign l1_all_last_5_8 = (l1_data_5_16.last & l1_valid_5_16) & (l1_data_5_17.last & l1_valid_5_17) & !l2_almost_full_5_8;
assign l1_same_5_8 = l1_newdata_5_16 & l1_newdata_5_17 & (l1_data_5_16.data==l1_data_5_17.data) & !l2_almost_full_5_8;
assign l1_newdata_5_16 = l1_valid_5_16 & (l1_data_5_16.data != l1_cache_5_16) & !l1_data_5_16.last;

assign l1_newdata_5_17 = l1_valid_5_17 & (l1_data_5_17.data != l1_cache_5_17) & !l1_data_5_17.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_8[0] = l1_newdata_5_16 & !l2_almost_full_5_8;
    l1_ready_5_16 = l1_grant_5_8[0];       
    l1_req_5_8[1] = l1_newdata_5_17 & !l2_almost_full_5_8;
    l1_ready_5_17 = l1_grant_5_8[1];       
    //sync case
    if(l1_all_last_5_8) begin
        l1_req_5_8 = 0;
        l1_ready_5_16 = 1;
        l1_ready_5_17 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_8)begin
        l1_req_5_8[0] = 1;
        l1_req_5_8[0] = 0;
        l1_ready_5_17 = 1;
    end else begin
        if(l1_valid_5_16 & (l1_data_5_16.data == l1_cache_5_16) & !l1_data_5_16.last)begin
            l1_ready_5_16 = 1;
        end
        if(l1_valid_5_17 & (l1_data_5_17.data == l1_cache_5_17) & !l1_data_5_17.last)begin
            l1_ready_5_17 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_16 <= 0;
        l1_cache_5_17 <= 0;
    end else begin
        if(l1_all_last_5_8)begin
            l1_cache_5_16 <= 0;
            l1_cache_5_17 <= 0;
        end else begin
            if(l1_valid_5_16 & l1_ready_5_16)begin
                l1_cache_5_16 <= l1_data_5_16.data;
            end
            if(l1_valid_5_17 & l1_ready_5_17)begin
                l1_cache_5_17 <= l1_data_5_17.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_8 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_8) begin
            l2_in_valid_5_8 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_8 <= |l1_grant_5_8;
        end
    end
    //sync case
    if(l1_all_last_5_8) begin
        l2_in_data_5_8.last <= 1;
        l2_in_data_5_8.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_8)
            2'b01: l2_in_data_5_8 <= l1_data_5_16;
            2'b10: l2_in_data_5_8 <= l1_data_5_17;
            default: l2_in_data_5_8 <= 0;
        endcase
    end   
end

assign l1_all_last_5_9 = (l1_data_5_18.last & l1_valid_5_18) & (l1_data_5_19.last & l1_valid_5_19) & !l2_almost_full_5_9;
assign l1_same_5_9 = l1_newdata_5_18 & l1_newdata_5_19 & (l1_data_5_18.data==l1_data_5_19.data) & !l2_almost_full_5_9;
assign l1_newdata_5_18 = l1_valid_5_18 & (l1_data_5_18.data != l1_cache_5_18) & !l1_data_5_18.last;

assign l1_newdata_5_19 = l1_valid_5_19 & (l1_data_5_19.data != l1_cache_5_19) & !l1_data_5_19.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_9[0] = l1_newdata_5_18 & !l2_almost_full_5_9;
    l1_ready_5_18 = l1_grant_5_9[0];       
    l1_req_5_9[1] = l1_newdata_5_19 & !l2_almost_full_5_9;
    l1_ready_5_19 = l1_grant_5_9[1];       
    //sync case
    if(l1_all_last_5_9) begin
        l1_req_5_9 = 0;
        l1_ready_5_18 = 1;
        l1_ready_5_19 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_9)begin
        l1_req_5_9[0] = 1;
        l1_req_5_9[0] = 0;
        l1_ready_5_19 = 1;
    end else begin
        if(l1_valid_5_18 & (l1_data_5_18.data == l1_cache_5_18) & !l1_data_5_18.last)begin
            l1_ready_5_18 = 1;
        end
        if(l1_valid_5_19 & (l1_data_5_19.data == l1_cache_5_19) & !l1_data_5_19.last)begin
            l1_ready_5_19 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_18 <= 0;
        l1_cache_5_19 <= 0;
    end else begin
        if(l1_all_last_5_9)begin
            l1_cache_5_18 <= 0;
            l1_cache_5_19 <= 0;
        end else begin
            if(l1_valid_5_18 & l1_ready_5_18)begin
                l1_cache_5_18 <= l1_data_5_18.data;
            end
            if(l1_valid_5_19 & l1_ready_5_19)begin
                l1_cache_5_19 <= l1_data_5_19.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_9 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_9) begin
            l2_in_valid_5_9 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_9 <= |l1_grant_5_9;
        end
    end
    //sync case
    if(l1_all_last_5_9) begin
        l2_in_data_5_9.last <= 1;
        l2_in_data_5_9.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_9)
            2'b01: l2_in_data_5_9 <= l1_data_5_18;
            2'b10: l2_in_data_5_9 <= l1_data_5_19;
            default: l2_in_data_5_9 <= 0;
        endcase
    end   
end

assign l1_all_last_5_10 = (l1_data_5_20.last & l1_valid_5_20) & (l1_data_5_21.last & l1_valid_5_21) & !l2_almost_full_5_10;
assign l1_same_5_10 = l1_newdata_5_20 & l1_newdata_5_21 & (l1_data_5_20.data==l1_data_5_21.data) & !l2_almost_full_5_10;
assign l1_newdata_5_20 = l1_valid_5_20 & (l1_data_5_20.data != l1_cache_5_20) & !l1_data_5_20.last;

assign l1_newdata_5_21 = l1_valid_5_21 & (l1_data_5_21.data != l1_cache_5_21) & !l1_data_5_21.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_10[0] = l1_newdata_5_20 & !l2_almost_full_5_10;
    l1_ready_5_20 = l1_grant_5_10[0];       
    l1_req_5_10[1] = l1_newdata_5_21 & !l2_almost_full_5_10;
    l1_ready_5_21 = l1_grant_5_10[1];       
    //sync case
    if(l1_all_last_5_10) begin
        l1_req_5_10 = 0;
        l1_ready_5_20 = 1;
        l1_ready_5_21 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_10)begin
        l1_req_5_10[0] = 1;
        l1_req_5_10[0] = 0;
        l1_ready_5_21 = 1;
    end else begin
        if(l1_valid_5_20 & (l1_data_5_20.data == l1_cache_5_20) & !l1_data_5_20.last)begin
            l1_ready_5_20 = 1;
        end
        if(l1_valid_5_21 & (l1_data_5_21.data == l1_cache_5_21) & !l1_data_5_21.last)begin
            l1_ready_5_21 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_20 <= 0;
        l1_cache_5_21 <= 0;
    end else begin
        if(l1_all_last_5_10)begin
            l1_cache_5_20 <= 0;
            l1_cache_5_21 <= 0;
        end else begin
            if(l1_valid_5_20 & l1_ready_5_20)begin
                l1_cache_5_20 <= l1_data_5_20.data;
            end
            if(l1_valid_5_21 & l1_ready_5_21)begin
                l1_cache_5_21 <= l1_data_5_21.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_10 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_10) begin
            l2_in_valid_5_10 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_10 <= |l1_grant_5_10;
        end
    end
    //sync case
    if(l1_all_last_5_10) begin
        l2_in_data_5_10.last <= 1;
        l2_in_data_5_10.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_10)
            2'b01: l2_in_data_5_10 <= l1_data_5_20;
            2'b10: l2_in_data_5_10 <= l1_data_5_21;
            default: l2_in_data_5_10 <= 0;
        endcase
    end   
end

assign l1_all_last_5_11 = (l1_data_5_22.last & l1_valid_5_22) & (l1_data_5_23.last & l1_valid_5_23) & !l2_almost_full_5_11;
assign l1_same_5_11 = l1_newdata_5_22 & l1_newdata_5_23 & (l1_data_5_22.data==l1_data_5_23.data) & !l2_almost_full_5_11;
assign l1_newdata_5_22 = l1_valid_5_22 & (l1_data_5_22.data != l1_cache_5_22) & !l1_data_5_22.last;

assign l1_newdata_5_23 = l1_valid_5_23 & (l1_data_5_23.data != l1_cache_5_23) & !l1_data_5_23.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_11[0] = l1_newdata_5_22 & !l2_almost_full_5_11;
    l1_ready_5_22 = l1_grant_5_11[0];       
    l1_req_5_11[1] = l1_newdata_5_23 & !l2_almost_full_5_11;
    l1_ready_5_23 = l1_grant_5_11[1];       
    //sync case
    if(l1_all_last_5_11) begin
        l1_req_5_11 = 0;
        l1_ready_5_22 = 1;
        l1_ready_5_23 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_11)begin
        l1_req_5_11[0] = 1;
        l1_req_5_11[0] = 0;
        l1_ready_5_23 = 1;
    end else begin
        if(l1_valid_5_22 & (l1_data_5_22.data == l1_cache_5_22) & !l1_data_5_22.last)begin
            l1_ready_5_22 = 1;
        end
        if(l1_valid_5_23 & (l1_data_5_23.data == l1_cache_5_23) & !l1_data_5_23.last)begin
            l1_ready_5_23 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_22 <= 0;
        l1_cache_5_23 <= 0;
    end else begin
        if(l1_all_last_5_11)begin
            l1_cache_5_22 <= 0;
            l1_cache_5_23 <= 0;
        end else begin
            if(l1_valid_5_22 & l1_ready_5_22)begin
                l1_cache_5_22 <= l1_data_5_22.data;
            end
            if(l1_valid_5_23 & l1_ready_5_23)begin
                l1_cache_5_23 <= l1_data_5_23.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_11 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_11) begin
            l2_in_valid_5_11 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_11 <= |l1_grant_5_11;
        end
    end
    //sync case
    if(l1_all_last_5_11) begin
        l2_in_data_5_11.last <= 1;
        l2_in_data_5_11.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_11)
            2'b01: l2_in_data_5_11 <= l1_data_5_22;
            2'b10: l2_in_data_5_11 <= l1_data_5_23;
            default: l2_in_data_5_11 <= 0;
        endcase
    end   
end

assign l1_all_last_5_12 = (l1_data_5_24.last & l1_valid_5_24) & (l1_data_5_25.last & l1_valid_5_25) & !l2_almost_full_5_12;
assign l1_same_5_12 = l1_newdata_5_24 & l1_newdata_5_25 & (l1_data_5_24.data==l1_data_5_25.data) & !l2_almost_full_5_12;
assign l1_newdata_5_24 = l1_valid_5_24 & (l1_data_5_24.data != l1_cache_5_24) & !l1_data_5_24.last;

assign l1_newdata_5_25 = l1_valid_5_25 & (l1_data_5_25.data != l1_cache_5_25) & !l1_data_5_25.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_12[0] = l1_newdata_5_24 & !l2_almost_full_5_12;
    l1_ready_5_24 = l1_grant_5_12[0];       
    l1_req_5_12[1] = l1_newdata_5_25 & !l2_almost_full_5_12;
    l1_ready_5_25 = l1_grant_5_12[1];       
    //sync case
    if(l1_all_last_5_12) begin
        l1_req_5_12 = 0;
        l1_ready_5_24 = 1;
        l1_ready_5_25 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_12)begin
        l1_req_5_12[0] = 1;
        l1_req_5_12[0] = 0;
        l1_ready_5_25 = 1;
    end else begin
        if(l1_valid_5_24 & (l1_data_5_24.data == l1_cache_5_24) & !l1_data_5_24.last)begin
            l1_ready_5_24 = 1;
        end
        if(l1_valid_5_25 & (l1_data_5_25.data == l1_cache_5_25) & !l1_data_5_25.last)begin
            l1_ready_5_25 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_24 <= 0;
        l1_cache_5_25 <= 0;
    end else begin
        if(l1_all_last_5_12)begin
            l1_cache_5_24 <= 0;
            l1_cache_5_25 <= 0;
        end else begin
            if(l1_valid_5_24 & l1_ready_5_24)begin
                l1_cache_5_24 <= l1_data_5_24.data;
            end
            if(l1_valid_5_25 & l1_ready_5_25)begin
                l1_cache_5_25 <= l1_data_5_25.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_12 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_12) begin
            l2_in_valid_5_12 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_12 <= |l1_grant_5_12;
        end
    end
    //sync case
    if(l1_all_last_5_12) begin
        l2_in_data_5_12.last <= 1;
        l2_in_data_5_12.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_12)
            2'b01: l2_in_data_5_12 <= l1_data_5_24;
            2'b10: l2_in_data_5_12 <= l1_data_5_25;
            default: l2_in_data_5_12 <= 0;
        endcase
    end   
end

assign l1_all_last_5_13 = (l1_data_5_26.last & l1_valid_5_26) & (l1_data_5_27.last & l1_valid_5_27) & !l2_almost_full_5_13;
assign l1_same_5_13 = l1_newdata_5_26 & l1_newdata_5_27 & (l1_data_5_26.data==l1_data_5_27.data) & !l2_almost_full_5_13;
assign l1_newdata_5_26 = l1_valid_5_26 & (l1_data_5_26.data != l1_cache_5_26) & !l1_data_5_26.last;

assign l1_newdata_5_27 = l1_valid_5_27 & (l1_data_5_27.data != l1_cache_5_27) & !l1_data_5_27.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_13[0] = l1_newdata_5_26 & !l2_almost_full_5_13;
    l1_ready_5_26 = l1_grant_5_13[0];       
    l1_req_5_13[1] = l1_newdata_5_27 & !l2_almost_full_5_13;
    l1_ready_5_27 = l1_grant_5_13[1];       
    //sync case
    if(l1_all_last_5_13) begin
        l1_req_5_13 = 0;
        l1_ready_5_26 = 1;
        l1_ready_5_27 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_13)begin
        l1_req_5_13[0] = 1;
        l1_req_5_13[0] = 0;
        l1_ready_5_27 = 1;
    end else begin
        if(l1_valid_5_26 & (l1_data_5_26.data == l1_cache_5_26) & !l1_data_5_26.last)begin
            l1_ready_5_26 = 1;
        end
        if(l1_valid_5_27 & (l1_data_5_27.data == l1_cache_5_27) & !l1_data_5_27.last)begin
            l1_ready_5_27 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_26 <= 0;
        l1_cache_5_27 <= 0;
    end else begin
        if(l1_all_last_5_13)begin
            l1_cache_5_26 <= 0;
            l1_cache_5_27 <= 0;
        end else begin
            if(l1_valid_5_26 & l1_ready_5_26)begin
                l1_cache_5_26 <= l1_data_5_26.data;
            end
            if(l1_valid_5_27 & l1_ready_5_27)begin
                l1_cache_5_27 <= l1_data_5_27.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_13 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_13) begin
            l2_in_valid_5_13 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_13 <= |l1_grant_5_13;
        end
    end
    //sync case
    if(l1_all_last_5_13) begin
        l2_in_data_5_13.last <= 1;
        l2_in_data_5_13.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_13)
            2'b01: l2_in_data_5_13 <= l1_data_5_26;
            2'b10: l2_in_data_5_13 <= l1_data_5_27;
            default: l2_in_data_5_13 <= 0;
        endcase
    end   
end

assign l1_all_last_5_14 = (l1_data_5_28.last & l1_valid_5_28) & (l1_data_5_29.last & l1_valid_5_29) & !l2_almost_full_5_14;
assign l1_same_5_14 = l1_newdata_5_28 & l1_newdata_5_29 & (l1_data_5_28.data==l1_data_5_29.data) & !l2_almost_full_5_14;
assign l1_newdata_5_28 = l1_valid_5_28 & (l1_data_5_28.data != l1_cache_5_28) & !l1_data_5_28.last;

assign l1_newdata_5_29 = l1_valid_5_29 & (l1_data_5_29.data != l1_cache_5_29) & !l1_data_5_29.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_14[0] = l1_newdata_5_28 & !l2_almost_full_5_14;
    l1_ready_5_28 = l1_grant_5_14[0];       
    l1_req_5_14[1] = l1_newdata_5_29 & !l2_almost_full_5_14;
    l1_ready_5_29 = l1_grant_5_14[1];       
    //sync case
    if(l1_all_last_5_14) begin
        l1_req_5_14 = 0;
        l1_ready_5_28 = 1;
        l1_ready_5_29 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_14)begin
        l1_req_5_14[0] = 1;
        l1_req_5_14[0] = 0;
        l1_ready_5_29 = 1;
    end else begin
        if(l1_valid_5_28 & (l1_data_5_28.data == l1_cache_5_28) & !l1_data_5_28.last)begin
            l1_ready_5_28 = 1;
        end
        if(l1_valid_5_29 & (l1_data_5_29.data == l1_cache_5_29) & !l1_data_5_29.last)begin
            l1_ready_5_29 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_28 <= 0;
        l1_cache_5_29 <= 0;
    end else begin
        if(l1_all_last_5_14)begin
            l1_cache_5_28 <= 0;
            l1_cache_5_29 <= 0;
        end else begin
            if(l1_valid_5_28 & l1_ready_5_28)begin
                l1_cache_5_28 <= l1_data_5_28.data;
            end
            if(l1_valid_5_29 & l1_ready_5_29)begin
                l1_cache_5_29 <= l1_data_5_29.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_14 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_14) begin
            l2_in_valid_5_14 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_14 <= |l1_grant_5_14;
        end
    end
    //sync case
    if(l1_all_last_5_14) begin
        l2_in_data_5_14.last <= 1;
        l2_in_data_5_14.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_14)
            2'b01: l2_in_data_5_14 <= l1_data_5_28;
            2'b10: l2_in_data_5_14 <= l1_data_5_29;
            default: l2_in_data_5_14 <= 0;
        endcase
    end   
end

assign l1_all_last_5_15 = (l1_data_5_30.last & l1_valid_5_30) & (l1_data_5_31.last & l1_valid_5_31) & !l2_almost_full_5_15;
assign l1_same_5_15 = l1_newdata_5_30 & l1_newdata_5_31 & (l1_data_5_30.data==l1_data_5_31.data) & !l2_almost_full_5_15;
assign l1_newdata_5_30 = l1_valid_5_30 & (l1_data_5_30.data != l1_cache_5_30) & !l1_data_5_30.last;

assign l1_newdata_5_31 = l1_valid_5_31 & (l1_data_5_31.data != l1_cache_5_31) & !l1_data_5_31.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_5_15[0] = l1_newdata_5_30 & !l2_almost_full_5_15;
    l1_ready_5_30 = l1_grant_5_15[0];       
    l1_req_5_15[1] = l1_newdata_5_31 & !l2_almost_full_5_15;
    l1_ready_5_31 = l1_grant_5_15[1];       
    //sync case
    if(l1_all_last_5_15) begin
        l1_req_5_15 = 0;
        l1_ready_5_30 = 1;
        l1_ready_5_31 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_5_15)begin
        l1_req_5_15[0] = 1;
        l1_req_5_15[0] = 0;
        l1_ready_5_31 = 1;
    end else begin
        if(l1_valid_5_30 & (l1_data_5_30.data == l1_cache_5_30) & !l1_data_5_30.last)begin
            l1_ready_5_30 = 1;
        end
        if(l1_valid_5_31 & (l1_data_5_31.data == l1_cache_5_31) & !l1_data_5_31.last)begin
            l1_ready_5_31 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_5_30 <= 0;
        l1_cache_5_31 <= 0;
    end else begin
        if(l1_all_last_5_15)begin
            l1_cache_5_30 <= 0;
            l1_cache_5_31 <= 0;
        end else begin
            if(l1_valid_5_30 & l1_ready_5_30)begin
                l1_cache_5_30 <= l1_data_5_30.data;
            end
            if(l1_valid_5_31 & l1_ready_5_31)begin
                l1_cache_5_31 <= l1_data_5_31.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_5_15 <= 0;
    end else begin
        //sync case
        if(l1_all_last_5_15) begin
            l2_in_valid_5_15 <= 1;
        //normal case
        end else begin
            l2_in_valid_5_15 <= |l1_grant_5_15;
        end
    end
    //sync case
    if(l1_all_last_5_15) begin
        l2_in_data_5_15.last <= 1;
        l2_in_data_5_15.data <= 0;
    //normal case
    end else begin
        case(l1_grant_5_15)
            2'b01: l2_in_data_5_15 <= l1_data_5_30;
            2'b10: l2_in_data_5_15 <= l1_data_5_31;
            default: l2_in_data_5_15 <= 0;
        endcase
    end   
end

assign l1_all_last_6_0 = (l1_data_6_0.last & l1_valid_6_0) & (l1_data_6_1.last & l1_valid_6_1) & !l2_almost_full_6_0;
assign l1_same_6_0 = l1_newdata_6_0 & l1_newdata_6_1 & (l1_data_6_0.data==l1_data_6_1.data) & !l2_almost_full_6_0;
assign l1_newdata_6_0 = l1_valid_6_0 & (l1_data_6_0.data != l1_cache_6_0) & !l1_data_6_0.last;

assign l1_newdata_6_1 = l1_valid_6_1 & (l1_data_6_1.data != l1_cache_6_1) & !l1_data_6_1.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_0[0] = l1_newdata_6_0 & !l2_almost_full_6_0;
    l1_ready_6_0 = l1_grant_6_0[0];       
    l1_req_6_0[1] = l1_newdata_6_1 & !l2_almost_full_6_0;
    l1_ready_6_1 = l1_grant_6_0[1];       
    //sync case
    if(l1_all_last_6_0) begin
        l1_req_6_0 = 0;
        l1_ready_6_0 = 1;
        l1_ready_6_1 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_0)begin
        l1_req_6_0[0] = 1;
        l1_req_6_0[0] = 0;
        l1_ready_6_1 = 1;
    end else begin
        if(l1_valid_6_0 & (l1_data_6_0.data == l1_cache_6_0) & !l1_data_6_0.last)begin
            l1_ready_6_0 = 1;
        end
        if(l1_valid_6_1 & (l1_data_6_1.data == l1_cache_6_1) & !l1_data_6_1.last)begin
            l1_ready_6_1 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_0 <= 0;
        l1_cache_6_1 <= 0;
    end else begin
        if(l1_all_last_6_0)begin
            l1_cache_6_0 <= 0;
            l1_cache_6_1 <= 0;
        end else begin
            if(l1_valid_6_0 & l1_ready_6_0)begin
                l1_cache_6_0 <= l1_data_6_0.data;
            end
            if(l1_valid_6_1 & l1_ready_6_1)begin
                l1_cache_6_1 <= l1_data_6_1.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_0 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_0) begin
            l2_in_valid_6_0 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_0 <= |l1_grant_6_0;
        end
    end
    //sync case
    if(l1_all_last_6_0) begin
        l2_in_data_6_0.last <= 1;
        l2_in_data_6_0.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_0)
            2'b01: l2_in_data_6_0 <= l1_data_6_0;
            2'b10: l2_in_data_6_0 <= l1_data_6_1;
            default: l2_in_data_6_0 <= 0;
        endcase
    end   
end

assign l1_all_last_6_1 = (l1_data_6_2.last & l1_valid_6_2) & (l1_data_6_3.last & l1_valid_6_3) & !l2_almost_full_6_1;
assign l1_same_6_1 = l1_newdata_6_2 & l1_newdata_6_3 & (l1_data_6_2.data==l1_data_6_3.data) & !l2_almost_full_6_1;
assign l1_newdata_6_2 = l1_valid_6_2 & (l1_data_6_2.data != l1_cache_6_2) & !l1_data_6_2.last;

assign l1_newdata_6_3 = l1_valid_6_3 & (l1_data_6_3.data != l1_cache_6_3) & !l1_data_6_3.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_1[0] = l1_newdata_6_2 & !l2_almost_full_6_1;
    l1_ready_6_2 = l1_grant_6_1[0];       
    l1_req_6_1[1] = l1_newdata_6_3 & !l2_almost_full_6_1;
    l1_ready_6_3 = l1_grant_6_1[1];       
    //sync case
    if(l1_all_last_6_1) begin
        l1_req_6_1 = 0;
        l1_ready_6_2 = 1;
        l1_ready_6_3 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_1)begin
        l1_req_6_1[0] = 1;
        l1_req_6_1[0] = 0;
        l1_ready_6_3 = 1;
    end else begin
        if(l1_valid_6_2 & (l1_data_6_2.data == l1_cache_6_2) & !l1_data_6_2.last)begin
            l1_ready_6_2 = 1;
        end
        if(l1_valid_6_3 & (l1_data_6_3.data == l1_cache_6_3) & !l1_data_6_3.last)begin
            l1_ready_6_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_2 <= 0;
        l1_cache_6_3 <= 0;
    end else begin
        if(l1_all_last_6_1)begin
            l1_cache_6_2 <= 0;
            l1_cache_6_3 <= 0;
        end else begin
            if(l1_valid_6_2 & l1_ready_6_2)begin
                l1_cache_6_2 <= l1_data_6_2.data;
            end
            if(l1_valid_6_3 & l1_ready_6_3)begin
                l1_cache_6_3 <= l1_data_6_3.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_1 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_1) begin
            l2_in_valid_6_1 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_1 <= |l1_grant_6_1;
        end
    end
    //sync case
    if(l1_all_last_6_1) begin
        l2_in_data_6_1.last <= 1;
        l2_in_data_6_1.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_1)
            2'b01: l2_in_data_6_1 <= l1_data_6_2;
            2'b10: l2_in_data_6_1 <= l1_data_6_3;
            default: l2_in_data_6_1 <= 0;
        endcase
    end   
end

assign l1_all_last_6_2 = (l1_data_6_4.last & l1_valid_6_4) & (l1_data_6_5.last & l1_valid_6_5) & !l2_almost_full_6_2;
assign l1_same_6_2 = l1_newdata_6_4 & l1_newdata_6_5 & (l1_data_6_4.data==l1_data_6_5.data) & !l2_almost_full_6_2;
assign l1_newdata_6_4 = l1_valid_6_4 & (l1_data_6_4.data != l1_cache_6_4) & !l1_data_6_4.last;

assign l1_newdata_6_5 = l1_valid_6_5 & (l1_data_6_5.data != l1_cache_6_5) & !l1_data_6_5.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_2[0] = l1_newdata_6_4 & !l2_almost_full_6_2;
    l1_ready_6_4 = l1_grant_6_2[0];       
    l1_req_6_2[1] = l1_newdata_6_5 & !l2_almost_full_6_2;
    l1_ready_6_5 = l1_grant_6_2[1];       
    //sync case
    if(l1_all_last_6_2) begin
        l1_req_6_2 = 0;
        l1_ready_6_4 = 1;
        l1_ready_6_5 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_2)begin
        l1_req_6_2[0] = 1;
        l1_req_6_2[0] = 0;
        l1_ready_6_5 = 1;
    end else begin
        if(l1_valid_6_4 & (l1_data_6_4.data == l1_cache_6_4) & !l1_data_6_4.last)begin
            l1_ready_6_4 = 1;
        end
        if(l1_valid_6_5 & (l1_data_6_5.data == l1_cache_6_5) & !l1_data_6_5.last)begin
            l1_ready_6_5 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_4 <= 0;
        l1_cache_6_5 <= 0;
    end else begin
        if(l1_all_last_6_2)begin
            l1_cache_6_4 <= 0;
            l1_cache_6_5 <= 0;
        end else begin
            if(l1_valid_6_4 & l1_ready_6_4)begin
                l1_cache_6_4 <= l1_data_6_4.data;
            end
            if(l1_valid_6_5 & l1_ready_6_5)begin
                l1_cache_6_5 <= l1_data_6_5.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_2 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_2) begin
            l2_in_valid_6_2 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_2 <= |l1_grant_6_2;
        end
    end
    //sync case
    if(l1_all_last_6_2) begin
        l2_in_data_6_2.last <= 1;
        l2_in_data_6_2.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_2)
            2'b01: l2_in_data_6_2 <= l1_data_6_4;
            2'b10: l2_in_data_6_2 <= l1_data_6_5;
            default: l2_in_data_6_2 <= 0;
        endcase
    end   
end

assign l1_all_last_6_3 = (l1_data_6_6.last & l1_valid_6_6) & (l1_data_6_7.last & l1_valid_6_7) & !l2_almost_full_6_3;
assign l1_same_6_3 = l1_newdata_6_6 & l1_newdata_6_7 & (l1_data_6_6.data==l1_data_6_7.data) & !l2_almost_full_6_3;
assign l1_newdata_6_6 = l1_valid_6_6 & (l1_data_6_6.data != l1_cache_6_6) & !l1_data_6_6.last;

assign l1_newdata_6_7 = l1_valid_6_7 & (l1_data_6_7.data != l1_cache_6_7) & !l1_data_6_7.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_3[0] = l1_newdata_6_6 & !l2_almost_full_6_3;
    l1_ready_6_6 = l1_grant_6_3[0];       
    l1_req_6_3[1] = l1_newdata_6_7 & !l2_almost_full_6_3;
    l1_ready_6_7 = l1_grant_6_3[1];       
    //sync case
    if(l1_all_last_6_3) begin
        l1_req_6_3 = 0;
        l1_ready_6_6 = 1;
        l1_ready_6_7 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_3)begin
        l1_req_6_3[0] = 1;
        l1_req_6_3[0] = 0;
        l1_ready_6_7 = 1;
    end else begin
        if(l1_valid_6_6 & (l1_data_6_6.data == l1_cache_6_6) & !l1_data_6_6.last)begin
            l1_ready_6_6 = 1;
        end
        if(l1_valid_6_7 & (l1_data_6_7.data == l1_cache_6_7) & !l1_data_6_7.last)begin
            l1_ready_6_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_6 <= 0;
        l1_cache_6_7 <= 0;
    end else begin
        if(l1_all_last_6_3)begin
            l1_cache_6_6 <= 0;
            l1_cache_6_7 <= 0;
        end else begin
            if(l1_valid_6_6 & l1_ready_6_6)begin
                l1_cache_6_6 <= l1_data_6_6.data;
            end
            if(l1_valid_6_7 & l1_ready_6_7)begin
                l1_cache_6_7 <= l1_data_6_7.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_3 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_3) begin
            l2_in_valid_6_3 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_3 <= |l1_grant_6_3;
        end
    end
    //sync case
    if(l1_all_last_6_3) begin
        l2_in_data_6_3.last <= 1;
        l2_in_data_6_3.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_3)
            2'b01: l2_in_data_6_3 <= l1_data_6_6;
            2'b10: l2_in_data_6_3 <= l1_data_6_7;
            default: l2_in_data_6_3 <= 0;
        endcase
    end   
end

assign l1_all_last_6_4 = (l1_data_6_8.last & l1_valid_6_8) & (l1_data_6_9.last & l1_valid_6_9) & !l2_almost_full_6_4;
assign l1_same_6_4 = l1_newdata_6_8 & l1_newdata_6_9 & (l1_data_6_8.data==l1_data_6_9.data) & !l2_almost_full_6_4;
assign l1_newdata_6_8 = l1_valid_6_8 & (l1_data_6_8.data != l1_cache_6_8) & !l1_data_6_8.last;

assign l1_newdata_6_9 = l1_valid_6_9 & (l1_data_6_9.data != l1_cache_6_9) & !l1_data_6_9.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_4[0] = l1_newdata_6_8 & !l2_almost_full_6_4;
    l1_ready_6_8 = l1_grant_6_4[0];       
    l1_req_6_4[1] = l1_newdata_6_9 & !l2_almost_full_6_4;
    l1_ready_6_9 = l1_grant_6_4[1];       
    //sync case
    if(l1_all_last_6_4) begin
        l1_req_6_4 = 0;
        l1_ready_6_8 = 1;
        l1_ready_6_9 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_4)begin
        l1_req_6_4[0] = 1;
        l1_req_6_4[0] = 0;
        l1_ready_6_9 = 1;
    end else begin
        if(l1_valid_6_8 & (l1_data_6_8.data == l1_cache_6_8) & !l1_data_6_8.last)begin
            l1_ready_6_8 = 1;
        end
        if(l1_valid_6_9 & (l1_data_6_9.data == l1_cache_6_9) & !l1_data_6_9.last)begin
            l1_ready_6_9 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_8 <= 0;
        l1_cache_6_9 <= 0;
    end else begin
        if(l1_all_last_6_4)begin
            l1_cache_6_8 <= 0;
            l1_cache_6_9 <= 0;
        end else begin
            if(l1_valid_6_8 & l1_ready_6_8)begin
                l1_cache_6_8 <= l1_data_6_8.data;
            end
            if(l1_valid_6_9 & l1_ready_6_9)begin
                l1_cache_6_9 <= l1_data_6_9.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_4 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_4) begin
            l2_in_valid_6_4 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_4 <= |l1_grant_6_4;
        end
    end
    //sync case
    if(l1_all_last_6_4) begin
        l2_in_data_6_4.last <= 1;
        l2_in_data_6_4.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_4)
            2'b01: l2_in_data_6_4 <= l1_data_6_8;
            2'b10: l2_in_data_6_4 <= l1_data_6_9;
            default: l2_in_data_6_4 <= 0;
        endcase
    end   
end

assign l1_all_last_6_5 = (l1_data_6_10.last & l1_valid_6_10) & (l1_data_6_11.last & l1_valid_6_11) & !l2_almost_full_6_5;
assign l1_same_6_5 = l1_newdata_6_10 & l1_newdata_6_11 & (l1_data_6_10.data==l1_data_6_11.data) & !l2_almost_full_6_5;
assign l1_newdata_6_10 = l1_valid_6_10 & (l1_data_6_10.data != l1_cache_6_10) & !l1_data_6_10.last;

assign l1_newdata_6_11 = l1_valid_6_11 & (l1_data_6_11.data != l1_cache_6_11) & !l1_data_6_11.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_5[0] = l1_newdata_6_10 & !l2_almost_full_6_5;
    l1_ready_6_10 = l1_grant_6_5[0];       
    l1_req_6_5[1] = l1_newdata_6_11 & !l2_almost_full_6_5;
    l1_ready_6_11 = l1_grant_6_5[1];       
    //sync case
    if(l1_all_last_6_5) begin
        l1_req_6_5 = 0;
        l1_ready_6_10 = 1;
        l1_ready_6_11 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_5)begin
        l1_req_6_5[0] = 1;
        l1_req_6_5[0] = 0;
        l1_ready_6_11 = 1;
    end else begin
        if(l1_valid_6_10 & (l1_data_6_10.data == l1_cache_6_10) & !l1_data_6_10.last)begin
            l1_ready_6_10 = 1;
        end
        if(l1_valid_6_11 & (l1_data_6_11.data == l1_cache_6_11) & !l1_data_6_11.last)begin
            l1_ready_6_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_10 <= 0;
        l1_cache_6_11 <= 0;
    end else begin
        if(l1_all_last_6_5)begin
            l1_cache_6_10 <= 0;
            l1_cache_6_11 <= 0;
        end else begin
            if(l1_valid_6_10 & l1_ready_6_10)begin
                l1_cache_6_10 <= l1_data_6_10.data;
            end
            if(l1_valid_6_11 & l1_ready_6_11)begin
                l1_cache_6_11 <= l1_data_6_11.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_5 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_5) begin
            l2_in_valid_6_5 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_5 <= |l1_grant_6_5;
        end
    end
    //sync case
    if(l1_all_last_6_5) begin
        l2_in_data_6_5.last <= 1;
        l2_in_data_6_5.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_5)
            2'b01: l2_in_data_6_5 <= l1_data_6_10;
            2'b10: l2_in_data_6_5 <= l1_data_6_11;
            default: l2_in_data_6_5 <= 0;
        endcase
    end   
end

assign l1_all_last_6_6 = (l1_data_6_12.last & l1_valid_6_12) & (l1_data_6_13.last & l1_valid_6_13) & !l2_almost_full_6_6;
assign l1_same_6_6 = l1_newdata_6_12 & l1_newdata_6_13 & (l1_data_6_12.data==l1_data_6_13.data) & !l2_almost_full_6_6;
assign l1_newdata_6_12 = l1_valid_6_12 & (l1_data_6_12.data != l1_cache_6_12) & !l1_data_6_12.last;

assign l1_newdata_6_13 = l1_valid_6_13 & (l1_data_6_13.data != l1_cache_6_13) & !l1_data_6_13.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_6[0] = l1_newdata_6_12 & !l2_almost_full_6_6;
    l1_ready_6_12 = l1_grant_6_6[0];       
    l1_req_6_6[1] = l1_newdata_6_13 & !l2_almost_full_6_6;
    l1_ready_6_13 = l1_grant_6_6[1];       
    //sync case
    if(l1_all_last_6_6) begin
        l1_req_6_6 = 0;
        l1_ready_6_12 = 1;
        l1_ready_6_13 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_6)begin
        l1_req_6_6[0] = 1;
        l1_req_6_6[0] = 0;
        l1_ready_6_13 = 1;
    end else begin
        if(l1_valid_6_12 & (l1_data_6_12.data == l1_cache_6_12) & !l1_data_6_12.last)begin
            l1_ready_6_12 = 1;
        end
        if(l1_valid_6_13 & (l1_data_6_13.data == l1_cache_6_13) & !l1_data_6_13.last)begin
            l1_ready_6_13 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_12 <= 0;
        l1_cache_6_13 <= 0;
    end else begin
        if(l1_all_last_6_6)begin
            l1_cache_6_12 <= 0;
            l1_cache_6_13 <= 0;
        end else begin
            if(l1_valid_6_12 & l1_ready_6_12)begin
                l1_cache_6_12 <= l1_data_6_12.data;
            end
            if(l1_valid_6_13 & l1_ready_6_13)begin
                l1_cache_6_13 <= l1_data_6_13.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_6 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_6) begin
            l2_in_valid_6_6 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_6 <= |l1_grant_6_6;
        end
    end
    //sync case
    if(l1_all_last_6_6) begin
        l2_in_data_6_6.last <= 1;
        l2_in_data_6_6.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_6)
            2'b01: l2_in_data_6_6 <= l1_data_6_12;
            2'b10: l2_in_data_6_6 <= l1_data_6_13;
            default: l2_in_data_6_6 <= 0;
        endcase
    end   
end

assign l1_all_last_6_7 = (l1_data_6_14.last & l1_valid_6_14) & (l1_data_6_15.last & l1_valid_6_15) & !l2_almost_full_6_7;
assign l1_same_6_7 = l1_newdata_6_14 & l1_newdata_6_15 & (l1_data_6_14.data==l1_data_6_15.data) & !l2_almost_full_6_7;
assign l1_newdata_6_14 = l1_valid_6_14 & (l1_data_6_14.data != l1_cache_6_14) & !l1_data_6_14.last;

assign l1_newdata_6_15 = l1_valid_6_15 & (l1_data_6_15.data != l1_cache_6_15) & !l1_data_6_15.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_7[0] = l1_newdata_6_14 & !l2_almost_full_6_7;
    l1_ready_6_14 = l1_grant_6_7[0];       
    l1_req_6_7[1] = l1_newdata_6_15 & !l2_almost_full_6_7;
    l1_ready_6_15 = l1_grant_6_7[1];       
    //sync case
    if(l1_all_last_6_7) begin
        l1_req_6_7 = 0;
        l1_ready_6_14 = 1;
        l1_ready_6_15 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_7)begin
        l1_req_6_7[0] = 1;
        l1_req_6_7[0] = 0;
        l1_ready_6_15 = 1;
    end else begin
        if(l1_valid_6_14 & (l1_data_6_14.data == l1_cache_6_14) & !l1_data_6_14.last)begin
            l1_ready_6_14 = 1;
        end
        if(l1_valid_6_15 & (l1_data_6_15.data == l1_cache_6_15) & !l1_data_6_15.last)begin
            l1_ready_6_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_14 <= 0;
        l1_cache_6_15 <= 0;
    end else begin
        if(l1_all_last_6_7)begin
            l1_cache_6_14 <= 0;
            l1_cache_6_15 <= 0;
        end else begin
            if(l1_valid_6_14 & l1_ready_6_14)begin
                l1_cache_6_14 <= l1_data_6_14.data;
            end
            if(l1_valid_6_15 & l1_ready_6_15)begin
                l1_cache_6_15 <= l1_data_6_15.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_7 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_7) begin
            l2_in_valid_6_7 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_7 <= |l1_grant_6_7;
        end
    end
    //sync case
    if(l1_all_last_6_7) begin
        l2_in_data_6_7.last <= 1;
        l2_in_data_6_7.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_7)
            2'b01: l2_in_data_6_7 <= l1_data_6_14;
            2'b10: l2_in_data_6_7 <= l1_data_6_15;
            default: l2_in_data_6_7 <= 0;
        endcase
    end   
end

assign l1_all_last_6_8 = (l1_data_6_16.last & l1_valid_6_16) & (l1_data_6_17.last & l1_valid_6_17) & !l2_almost_full_6_8;
assign l1_same_6_8 = l1_newdata_6_16 & l1_newdata_6_17 & (l1_data_6_16.data==l1_data_6_17.data) & !l2_almost_full_6_8;
assign l1_newdata_6_16 = l1_valid_6_16 & (l1_data_6_16.data != l1_cache_6_16) & !l1_data_6_16.last;

assign l1_newdata_6_17 = l1_valid_6_17 & (l1_data_6_17.data != l1_cache_6_17) & !l1_data_6_17.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_8[0] = l1_newdata_6_16 & !l2_almost_full_6_8;
    l1_ready_6_16 = l1_grant_6_8[0];       
    l1_req_6_8[1] = l1_newdata_6_17 & !l2_almost_full_6_8;
    l1_ready_6_17 = l1_grant_6_8[1];       
    //sync case
    if(l1_all_last_6_8) begin
        l1_req_6_8 = 0;
        l1_ready_6_16 = 1;
        l1_ready_6_17 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_8)begin
        l1_req_6_8[0] = 1;
        l1_req_6_8[0] = 0;
        l1_ready_6_17 = 1;
    end else begin
        if(l1_valid_6_16 & (l1_data_6_16.data == l1_cache_6_16) & !l1_data_6_16.last)begin
            l1_ready_6_16 = 1;
        end
        if(l1_valid_6_17 & (l1_data_6_17.data == l1_cache_6_17) & !l1_data_6_17.last)begin
            l1_ready_6_17 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_16 <= 0;
        l1_cache_6_17 <= 0;
    end else begin
        if(l1_all_last_6_8)begin
            l1_cache_6_16 <= 0;
            l1_cache_6_17 <= 0;
        end else begin
            if(l1_valid_6_16 & l1_ready_6_16)begin
                l1_cache_6_16 <= l1_data_6_16.data;
            end
            if(l1_valid_6_17 & l1_ready_6_17)begin
                l1_cache_6_17 <= l1_data_6_17.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_8 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_8) begin
            l2_in_valid_6_8 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_8 <= |l1_grant_6_8;
        end
    end
    //sync case
    if(l1_all_last_6_8) begin
        l2_in_data_6_8.last <= 1;
        l2_in_data_6_8.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_8)
            2'b01: l2_in_data_6_8 <= l1_data_6_16;
            2'b10: l2_in_data_6_8 <= l1_data_6_17;
            default: l2_in_data_6_8 <= 0;
        endcase
    end   
end

assign l1_all_last_6_9 = (l1_data_6_18.last & l1_valid_6_18) & (l1_data_6_19.last & l1_valid_6_19) & !l2_almost_full_6_9;
assign l1_same_6_9 = l1_newdata_6_18 & l1_newdata_6_19 & (l1_data_6_18.data==l1_data_6_19.data) & !l2_almost_full_6_9;
assign l1_newdata_6_18 = l1_valid_6_18 & (l1_data_6_18.data != l1_cache_6_18) & !l1_data_6_18.last;

assign l1_newdata_6_19 = l1_valid_6_19 & (l1_data_6_19.data != l1_cache_6_19) & !l1_data_6_19.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_9[0] = l1_newdata_6_18 & !l2_almost_full_6_9;
    l1_ready_6_18 = l1_grant_6_9[0];       
    l1_req_6_9[1] = l1_newdata_6_19 & !l2_almost_full_6_9;
    l1_ready_6_19 = l1_grant_6_9[1];       
    //sync case
    if(l1_all_last_6_9) begin
        l1_req_6_9 = 0;
        l1_ready_6_18 = 1;
        l1_ready_6_19 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_9)begin
        l1_req_6_9[0] = 1;
        l1_req_6_9[0] = 0;
        l1_ready_6_19 = 1;
    end else begin
        if(l1_valid_6_18 & (l1_data_6_18.data == l1_cache_6_18) & !l1_data_6_18.last)begin
            l1_ready_6_18 = 1;
        end
        if(l1_valid_6_19 & (l1_data_6_19.data == l1_cache_6_19) & !l1_data_6_19.last)begin
            l1_ready_6_19 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_18 <= 0;
        l1_cache_6_19 <= 0;
    end else begin
        if(l1_all_last_6_9)begin
            l1_cache_6_18 <= 0;
            l1_cache_6_19 <= 0;
        end else begin
            if(l1_valid_6_18 & l1_ready_6_18)begin
                l1_cache_6_18 <= l1_data_6_18.data;
            end
            if(l1_valid_6_19 & l1_ready_6_19)begin
                l1_cache_6_19 <= l1_data_6_19.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_9 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_9) begin
            l2_in_valid_6_9 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_9 <= |l1_grant_6_9;
        end
    end
    //sync case
    if(l1_all_last_6_9) begin
        l2_in_data_6_9.last <= 1;
        l2_in_data_6_9.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_9)
            2'b01: l2_in_data_6_9 <= l1_data_6_18;
            2'b10: l2_in_data_6_9 <= l1_data_6_19;
            default: l2_in_data_6_9 <= 0;
        endcase
    end   
end

assign l1_all_last_6_10 = (l1_data_6_20.last & l1_valid_6_20) & (l1_data_6_21.last & l1_valid_6_21) & !l2_almost_full_6_10;
assign l1_same_6_10 = l1_newdata_6_20 & l1_newdata_6_21 & (l1_data_6_20.data==l1_data_6_21.data) & !l2_almost_full_6_10;
assign l1_newdata_6_20 = l1_valid_6_20 & (l1_data_6_20.data != l1_cache_6_20) & !l1_data_6_20.last;

assign l1_newdata_6_21 = l1_valid_6_21 & (l1_data_6_21.data != l1_cache_6_21) & !l1_data_6_21.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_10[0] = l1_newdata_6_20 & !l2_almost_full_6_10;
    l1_ready_6_20 = l1_grant_6_10[0];       
    l1_req_6_10[1] = l1_newdata_6_21 & !l2_almost_full_6_10;
    l1_ready_6_21 = l1_grant_6_10[1];       
    //sync case
    if(l1_all_last_6_10) begin
        l1_req_6_10 = 0;
        l1_ready_6_20 = 1;
        l1_ready_6_21 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_10)begin
        l1_req_6_10[0] = 1;
        l1_req_6_10[0] = 0;
        l1_ready_6_21 = 1;
    end else begin
        if(l1_valid_6_20 & (l1_data_6_20.data == l1_cache_6_20) & !l1_data_6_20.last)begin
            l1_ready_6_20 = 1;
        end
        if(l1_valid_6_21 & (l1_data_6_21.data == l1_cache_6_21) & !l1_data_6_21.last)begin
            l1_ready_6_21 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_20 <= 0;
        l1_cache_6_21 <= 0;
    end else begin
        if(l1_all_last_6_10)begin
            l1_cache_6_20 <= 0;
            l1_cache_6_21 <= 0;
        end else begin
            if(l1_valid_6_20 & l1_ready_6_20)begin
                l1_cache_6_20 <= l1_data_6_20.data;
            end
            if(l1_valid_6_21 & l1_ready_6_21)begin
                l1_cache_6_21 <= l1_data_6_21.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_10 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_10) begin
            l2_in_valid_6_10 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_10 <= |l1_grant_6_10;
        end
    end
    //sync case
    if(l1_all_last_6_10) begin
        l2_in_data_6_10.last <= 1;
        l2_in_data_6_10.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_10)
            2'b01: l2_in_data_6_10 <= l1_data_6_20;
            2'b10: l2_in_data_6_10 <= l1_data_6_21;
            default: l2_in_data_6_10 <= 0;
        endcase
    end   
end

assign l1_all_last_6_11 = (l1_data_6_22.last & l1_valid_6_22) & (l1_data_6_23.last & l1_valid_6_23) & !l2_almost_full_6_11;
assign l1_same_6_11 = l1_newdata_6_22 & l1_newdata_6_23 & (l1_data_6_22.data==l1_data_6_23.data) & !l2_almost_full_6_11;
assign l1_newdata_6_22 = l1_valid_6_22 & (l1_data_6_22.data != l1_cache_6_22) & !l1_data_6_22.last;

assign l1_newdata_6_23 = l1_valid_6_23 & (l1_data_6_23.data != l1_cache_6_23) & !l1_data_6_23.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_11[0] = l1_newdata_6_22 & !l2_almost_full_6_11;
    l1_ready_6_22 = l1_grant_6_11[0];       
    l1_req_6_11[1] = l1_newdata_6_23 & !l2_almost_full_6_11;
    l1_ready_6_23 = l1_grant_6_11[1];       
    //sync case
    if(l1_all_last_6_11) begin
        l1_req_6_11 = 0;
        l1_ready_6_22 = 1;
        l1_ready_6_23 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_11)begin
        l1_req_6_11[0] = 1;
        l1_req_6_11[0] = 0;
        l1_ready_6_23 = 1;
    end else begin
        if(l1_valid_6_22 & (l1_data_6_22.data == l1_cache_6_22) & !l1_data_6_22.last)begin
            l1_ready_6_22 = 1;
        end
        if(l1_valid_6_23 & (l1_data_6_23.data == l1_cache_6_23) & !l1_data_6_23.last)begin
            l1_ready_6_23 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_22 <= 0;
        l1_cache_6_23 <= 0;
    end else begin
        if(l1_all_last_6_11)begin
            l1_cache_6_22 <= 0;
            l1_cache_6_23 <= 0;
        end else begin
            if(l1_valid_6_22 & l1_ready_6_22)begin
                l1_cache_6_22 <= l1_data_6_22.data;
            end
            if(l1_valid_6_23 & l1_ready_6_23)begin
                l1_cache_6_23 <= l1_data_6_23.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_11 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_11) begin
            l2_in_valid_6_11 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_11 <= |l1_grant_6_11;
        end
    end
    //sync case
    if(l1_all_last_6_11) begin
        l2_in_data_6_11.last <= 1;
        l2_in_data_6_11.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_11)
            2'b01: l2_in_data_6_11 <= l1_data_6_22;
            2'b10: l2_in_data_6_11 <= l1_data_6_23;
            default: l2_in_data_6_11 <= 0;
        endcase
    end   
end

assign l1_all_last_6_12 = (l1_data_6_24.last & l1_valid_6_24) & (l1_data_6_25.last & l1_valid_6_25) & !l2_almost_full_6_12;
assign l1_same_6_12 = l1_newdata_6_24 & l1_newdata_6_25 & (l1_data_6_24.data==l1_data_6_25.data) & !l2_almost_full_6_12;
assign l1_newdata_6_24 = l1_valid_6_24 & (l1_data_6_24.data != l1_cache_6_24) & !l1_data_6_24.last;

assign l1_newdata_6_25 = l1_valid_6_25 & (l1_data_6_25.data != l1_cache_6_25) & !l1_data_6_25.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_12[0] = l1_newdata_6_24 & !l2_almost_full_6_12;
    l1_ready_6_24 = l1_grant_6_12[0];       
    l1_req_6_12[1] = l1_newdata_6_25 & !l2_almost_full_6_12;
    l1_ready_6_25 = l1_grant_6_12[1];       
    //sync case
    if(l1_all_last_6_12) begin
        l1_req_6_12 = 0;
        l1_ready_6_24 = 1;
        l1_ready_6_25 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_12)begin
        l1_req_6_12[0] = 1;
        l1_req_6_12[0] = 0;
        l1_ready_6_25 = 1;
    end else begin
        if(l1_valid_6_24 & (l1_data_6_24.data == l1_cache_6_24) & !l1_data_6_24.last)begin
            l1_ready_6_24 = 1;
        end
        if(l1_valid_6_25 & (l1_data_6_25.data == l1_cache_6_25) & !l1_data_6_25.last)begin
            l1_ready_6_25 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_24 <= 0;
        l1_cache_6_25 <= 0;
    end else begin
        if(l1_all_last_6_12)begin
            l1_cache_6_24 <= 0;
            l1_cache_6_25 <= 0;
        end else begin
            if(l1_valid_6_24 & l1_ready_6_24)begin
                l1_cache_6_24 <= l1_data_6_24.data;
            end
            if(l1_valid_6_25 & l1_ready_6_25)begin
                l1_cache_6_25 <= l1_data_6_25.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_12 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_12) begin
            l2_in_valid_6_12 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_12 <= |l1_grant_6_12;
        end
    end
    //sync case
    if(l1_all_last_6_12) begin
        l2_in_data_6_12.last <= 1;
        l2_in_data_6_12.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_12)
            2'b01: l2_in_data_6_12 <= l1_data_6_24;
            2'b10: l2_in_data_6_12 <= l1_data_6_25;
            default: l2_in_data_6_12 <= 0;
        endcase
    end   
end

assign l1_all_last_6_13 = (l1_data_6_26.last & l1_valid_6_26) & (l1_data_6_27.last & l1_valid_6_27) & !l2_almost_full_6_13;
assign l1_same_6_13 = l1_newdata_6_26 & l1_newdata_6_27 & (l1_data_6_26.data==l1_data_6_27.data) & !l2_almost_full_6_13;
assign l1_newdata_6_26 = l1_valid_6_26 & (l1_data_6_26.data != l1_cache_6_26) & !l1_data_6_26.last;

assign l1_newdata_6_27 = l1_valid_6_27 & (l1_data_6_27.data != l1_cache_6_27) & !l1_data_6_27.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_13[0] = l1_newdata_6_26 & !l2_almost_full_6_13;
    l1_ready_6_26 = l1_grant_6_13[0];       
    l1_req_6_13[1] = l1_newdata_6_27 & !l2_almost_full_6_13;
    l1_ready_6_27 = l1_grant_6_13[1];       
    //sync case
    if(l1_all_last_6_13) begin
        l1_req_6_13 = 0;
        l1_ready_6_26 = 1;
        l1_ready_6_27 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_13)begin
        l1_req_6_13[0] = 1;
        l1_req_6_13[0] = 0;
        l1_ready_6_27 = 1;
    end else begin
        if(l1_valid_6_26 & (l1_data_6_26.data == l1_cache_6_26) & !l1_data_6_26.last)begin
            l1_ready_6_26 = 1;
        end
        if(l1_valid_6_27 & (l1_data_6_27.data == l1_cache_6_27) & !l1_data_6_27.last)begin
            l1_ready_6_27 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_26 <= 0;
        l1_cache_6_27 <= 0;
    end else begin
        if(l1_all_last_6_13)begin
            l1_cache_6_26 <= 0;
            l1_cache_6_27 <= 0;
        end else begin
            if(l1_valid_6_26 & l1_ready_6_26)begin
                l1_cache_6_26 <= l1_data_6_26.data;
            end
            if(l1_valid_6_27 & l1_ready_6_27)begin
                l1_cache_6_27 <= l1_data_6_27.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_13 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_13) begin
            l2_in_valid_6_13 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_13 <= |l1_grant_6_13;
        end
    end
    //sync case
    if(l1_all_last_6_13) begin
        l2_in_data_6_13.last <= 1;
        l2_in_data_6_13.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_13)
            2'b01: l2_in_data_6_13 <= l1_data_6_26;
            2'b10: l2_in_data_6_13 <= l1_data_6_27;
            default: l2_in_data_6_13 <= 0;
        endcase
    end   
end

assign l1_all_last_6_14 = (l1_data_6_28.last & l1_valid_6_28) & (l1_data_6_29.last & l1_valid_6_29) & !l2_almost_full_6_14;
assign l1_same_6_14 = l1_newdata_6_28 & l1_newdata_6_29 & (l1_data_6_28.data==l1_data_6_29.data) & !l2_almost_full_6_14;
assign l1_newdata_6_28 = l1_valid_6_28 & (l1_data_6_28.data != l1_cache_6_28) & !l1_data_6_28.last;

assign l1_newdata_6_29 = l1_valid_6_29 & (l1_data_6_29.data != l1_cache_6_29) & !l1_data_6_29.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_14[0] = l1_newdata_6_28 & !l2_almost_full_6_14;
    l1_ready_6_28 = l1_grant_6_14[0];       
    l1_req_6_14[1] = l1_newdata_6_29 & !l2_almost_full_6_14;
    l1_ready_6_29 = l1_grant_6_14[1];       
    //sync case
    if(l1_all_last_6_14) begin
        l1_req_6_14 = 0;
        l1_ready_6_28 = 1;
        l1_ready_6_29 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_14)begin
        l1_req_6_14[0] = 1;
        l1_req_6_14[0] = 0;
        l1_ready_6_29 = 1;
    end else begin
        if(l1_valid_6_28 & (l1_data_6_28.data == l1_cache_6_28) & !l1_data_6_28.last)begin
            l1_ready_6_28 = 1;
        end
        if(l1_valid_6_29 & (l1_data_6_29.data == l1_cache_6_29) & !l1_data_6_29.last)begin
            l1_ready_6_29 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_28 <= 0;
        l1_cache_6_29 <= 0;
    end else begin
        if(l1_all_last_6_14)begin
            l1_cache_6_28 <= 0;
            l1_cache_6_29 <= 0;
        end else begin
            if(l1_valid_6_28 & l1_ready_6_28)begin
                l1_cache_6_28 <= l1_data_6_28.data;
            end
            if(l1_valid_6_29 & l1_ready_6_29)begin
                l1_cache_6_29 <= l1_data_6_29.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_14 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_14) begin
            l2_in_valid_6_14 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_14 <= |l1_grant_6_14;
        end
    end
    //sync case
    if(l1_all_last_6_14) begin
        l2_in_data_6_14.last <= 1;
        l2_in_data_6_14.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_14)
            2'b01: l2_in_data_6_14 <= l1_data_6_28;
            2'b10: l2_in_data_6_14 <= l1_data_6_29;
            default: l2_in_data_6_14 <= 0;
        endcase
    end   
end

assign l1_all_last_6_15 = (l1_data_6_30.last & l1_valid_6_30) & (l1_data_6_31.last & l1_valid_6_31) & !l2_almost_full_6_15;
assign l1_same_6_15 = l1_newdata_6_30 & l1_newdata_6_31 & (l1_data_6_30.data==l1_data_6_31.data) & !l2_almost_full_6_15;
assign l1_newdata_6_30 = l1_valid_6_30 & (l1_data_6_30.data != l1_cache_6_30) & !l1_data_6_30.last;

assign l1_newdata_6_31 = l1_valid_6_31 & (l1_data_6_31.data != l1_cache_6_31) & !l1_data_6_31.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_6_15[0] = l1_newdata_6_30 & !l2_almost_full_6_15;
    l1_ready_6_30 = l1_grant_6_15[0];       
    l1_req_6_15[1] = l1_newdata_6_31 & !l2_almost_full_6_15;
    l1_ready_6_31 = l1_grant_6_15[1];       
    //sync case
    if(l1_all_last_6_15) begin
        l1_req_6_15 = 0;
        l1_ready_6_30 = 1;
        l1_ready_6_31 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_6_15)begin
        l1_req_6_15[0] = 1;
        l1_req_6_15[0] = 0;
        l1_ready_6_31 = 1;
    end else begin
        if(l1_valid_6_30 & (l1_data_6_30.data == l1_cache_6_30) & !l1_data_6_30.last)begin
            l1_ready_6_30 = 1;
        end
        if(l1_valid_6_31 & (l1_data_6_31.data == l1_cache_6_31) & !l1_data_6_31.last)begin
            l1_ready_6_31 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_6_30 <= 0;
        l1_cache_6_31 <= 0;
    end else begin
        if(l1_all_last_6_15)begin
            l1_cache_6_30 <= 0;
            l1_cache_6_31 <= 0;
        end else begin
            if(l1_valid_6_30 & l1_ready_6_30)begin
                l1_cache_6_30 <= l1_data_6_30.data;
            end
            if(l1_valid_6_31 & l1_ready_6_31)begin
                l1_cache_6_31 <= l1_data_6_31.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_6_15 <= 0;
    end else begin
        //sync case
        if(l1_all_last_6_15) begin
            l2_in_valid_6_15 <= 1;
        //normal case
        end else begin
            l2_in_valid_6_15 <= |l1_grant_6_15;
        end
    end
    //sync case
    if(l1_all_last_6_15) begin
        l2_in_data_6_15.last <= 1;
        l2_in_data_6_15.data <= 0;
    //normal case
    end else begin
        case(l1_grant_6_15)
            2'b01: l2_in_data_6_15 <= l1_data_6_30;
            2'b10: l2_in_data_6_15 <= l1_data_6_31;
            default: l2_in_data_6_15 <= 0;
        endcase
    end   
end

assign l1_all_last_7_0 = (l1_data_7_0.last & l1_valid_7_0) & (l1_data_7_1.last & l1_valid_7_1) & !l2_almost_full_7_0;
assign l1_same_7_0 = l1_newdata_7_0 & l1_newdata_7_1 & (l1_data_7_0.data==l1_data_7_1.data) & !l2_almost_full_7_0;
assign l1_newdata_7_0 = l1_valid_7_0 & (l1_data_7_0.data != l1_cache_7_0) & !l1_data_7_0.last;

assign l1_newdata_7_1 = l1_valid_7_1 & (l1_data_7_1.data != l1_cache_7_1) & !l1_data_7_1.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_0[0] = l1_newdata_7_0 & !l2_almost_full_7_0;
    l1_ready_7_0 = l1_grant_7_0[0];       
    l1_req_7_0[1] = l1_newdata_7_1 & !l2_almost_full_7_0;
    l1_ready_7_1 = l1_grant_7_0[1];       
    //sync case
    if(l1_all_last_7_0) begin
        l1_req_7_0 = 0;
        l1_ready_7_0 = 1;
        l1_ready_7_1 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_0)begin
        l1_req_7_0[0] = 1;
        l1_req_7_0[0] = 0;
        l1_ready_7_1 = 1;
    end else begin
        if(l1_valid_7_0 & (l1_data_7_0.data == l1_cache_7_0) & !l1_data_7_0.last)begin
            l1_ready_7_0 = 1;
        end
        if(l1_valid_7_1 & (l1_data_7_1.data == l1_cache_7_1) & !l1_data_7_1.last)begin
            l1_ready_7_1 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_0 <= 0;
        l1_cache_7_1 <= 0;
    end else begin
        if(l1_all_last_7_0)begin
            l1_cache_7_0 <= 0;
            l1_cache_7_1 <= 0;
        end else begin
            if(l1_valid_7_0 & l1_ready_7_0)begin
                l1_cache_7_0 <= l1_data_7_0.data;
            end
            if(l1_valid_7_1 & l1_ready_7_1)begin
                l1_cache_7_1 <= l1_data_7_1.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_0 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_0) begin
            l2_in_valid_7_0 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_0 <= |l1_grant_7_0;
        end
    end
    //sync case
    if(l1_all_last_7_0) begin
        l2_in_data_7_0.last <= 1;
        l2_in_data_7_0.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_0)
            2'b01: l2_in_data_7_0 <= l1_data_7_0;
            2'b10: l2_in_data_7_0 <= l1_data_7_1;
            default: l2_in_data_7_0 <= 0;
        endcase
    end   
end

assign l1_all_last_7_1 = (l1_data_7_2.last & l1_valid_7_2) & (l1_data_7_3.last & l1_valid_7_3) & !l2_almost_full_7_1;
assign l1_same_7_1 = l1_newdata_7_2 & l1_newdata_7_3 & (l1_data_7_2.data==l1_data_7_3.data) & !l2_almost_full_7_1;
assign l1_newdata_7_2 = l1_valid_7_2 & (l1_data_7_2.data != l1_cache_7_2) & !l1_data_7_2.last;

assign l1_newdata_7_3 = l1_valid_7_3 & (l1_data_7_3.data != l1_cache_7_3) & !l1_data_7_3.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_1[0] = l1_newdata_7_2 & !l2_almost_full_7_1;
    l1_ready_7_2 = l1_grant_7_1[0];       
    l1_req_7_1[1] = l1_newdata_7_3 & !l2_almost_full_7_1;
    l1_ready_7_3 = l1_grant_7_1[1];       
    //sync case
    if(l1_all_last_7_1) begin
        l1_req_7_1 = 0;
        l1_ready_7_2 = 1;
        l1_ready_7_3 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_1)begin
        l1_req_7_1[0] = 1;
        l1_req_7_1[0] = 0;
        l1_ready_7_3 = 1;
    end else begin
        if(l1_valid_7_2 & (l1_data_7_2.data == l1_cache_7_2) & !l1_data_7_2.last)begin
            l1_ready_7_2 = 1;
        end
        if(l1_valid_7_3 & (l1_data_7_3.data == l1_cache_7_3) & !l1_data_7_3.last)begin
            l1_ready_7_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_2 <= 0;
        l1_cache_7_3 <= 0;
    end else begin
        if(l1_all_last_7_1)begin
            l1_cache_7_2 <= 0;
            l1_cache_7_3 <= 0;
        end else begin
            if(l1_valid_7_2 & l1_ready_7_2)begin
                l1_cache_7_2 <= l1_data_7_2.data;
            end
            if(l1_valid_7_3 & l1_ready_7_3)begin
                l1_cache_7_3 <= l1_data_7_3.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_1 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_1) begin
            l2_in_valid_7_1 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_1 <= |l1_grant_7_1;
        end
    end
    //sync case
    if(l1_all_last_7_1) begin
        l2_in_data_7_1.last <= 1;
        l2_in_data_7_1.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_1)
            2'b01: l2_in_data_7_1 <= l1_data_7_2;
            2'b10: l2_in_data_7_1 <= l1_data_7_3;
            default: l2_in_data_7_1 <= 0;
        endcase
    end   
end

assign l1_all_last_7_2 = (l1_data_7_4.last & l1_valid_7_4) & (l1_data_7_5.last & l1_valid_7_5) & !l2_almost_full_7_2;
assign l1_same_7_2 = l1_newdata_7_4 & l1_newdata_7_5 & (l1_data_7_4.data==l1_data_7_5.data) & !l2_almost_full_7_2;
assign l1_newdata_7_4 = l1_valid_7_4 & (l1_data_7_4.data != l1_cache_7_4) & !l1_data_7_4.last;

assign l1_newdata_7_5 = l1_valid_7_5 & (l1_data_7_5.data != l1_cache_7_5) & !l1_data_7_5.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_2[0] = l1_newdata_7_4 & !l2_almost_full_7_2;
    l1_ready_7_4 = l1_grant_7_2[0];       
    l1_req_7_2[1] = l1_newdata_7_5 & !l2_almost_full_7_2;
    l1_ready_7_5 = l1_grant_7_2[1];       
    //sync case
    if(l1_all_last_7_2) begin
        l1_req_7_2 = 0;
        l1_ready_7_4 = 1;
        l1_ready_7_5 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_2)begin
        l1_req_7_2[0] = 1;
        l1_req_7_2[0] = 0;
        l1_ready_7_5 = 1;
    end else begin
        if(l1_valid_7_4 & (l1_data_7_4.data == l1_cache_7_4) & !l1_data_7_4.last)begin
            l1_ready_7_4 = 1;
        end
        if(l1_valid_7_5 & (l1_data_7_5.data == l1_cache_7_5) & !l1_data_7_5.last)begin
            l1_ready_7_5 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_4 <= 0;
        l1_cache_7_5 <= 0;
    end else begin
        if(l1_all_last_7_2)begin
            l1_cache_7_4 <= 0;
            l1_cache_7_5 <= 0;
        end else begin
            if(l1_valid_7_4 & l1_ready_7_4)begin
                l1_cache_7_4 <= l1_data_7_4.data;
            end
            if(l1_valid_7_5 & l1_ready_7_5)begin
                l1_cache_7_5 <= l1_data_7_5.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_2 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_2) begin
            l2_in_valid_7_2 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_2 <= |l1_grant_7_2;
        end
    end
    //sync case
    if(l1_all_last_7_2) begin
        l2_in_data_7_2.last <= 1;
        l2_in_data_7_2.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_2)
            2'b01: l2_in_data_7_2 <= l1_data_7_4;
            2'b10: l2_in_data_7_2 <= l1_data_7_5;
            default: l2_in_data_7_2 <= 0;
        endcase
    end   
end

assign l1_all_last_7_3 = (l1_data_7_6.last & l1_valid_7_6) & (l1_data_7_7.last & l1_valid_7_7) & !l2_almost_full_7_3;
assign l1_same_7_3 = l1_newdata_7_6 & l1_newdata_7_7 & (l1_data_7_6.data==l1_data_7_7.data) & !l2_almost_full_7_3;
assign l1_newdata_7_6 = l1_valid_7_6 & (l1_data_7_6.data != l1_cache_7_6) & !l1_data_7_6.last;

assign l1_newdata_7_7 = l1_valid_7_7 & (l1_data_7_7.data != l1_cache_7_7) & !l1_data_7_7.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_3[0] = l1_newdata_7_6 & !l2_almost_full_7_3;
    l1_ready_7_6 = l1_grant_7_3[0];       
    l1_req_7_3[1] = l1_newdata_7_7 & !l2_almost_full_7_3;
    l1_ready_7_7 = l1_grant_7_3[1];       
    //sync case
    if(l1_all_last_7_3) begin
        l1_req_7_3 = 0;
        l1_ready_7_6 = 1;
        l1_ready_7_7 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_3)begin
        l1_req_7_3[0] = 1;
        l1_req_7_3[0] = 0;
        l1_ready_7_7 = 1;
    end else begin
        if(l1_valid_7_6 & (l1_data_7_6.data == l1_cache_7_6) & !l1_data_7_6.last)begin
            l1_ready_7_6 = 1;
        end
        if(l1_valid_7_7 & (l1_data_7_7.data == l1_cache_7_7) & !l1_data_7_7.last)begin
            l1_ready_7_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_6 <= 0;
        l1_cache_7_7 <= 0;
    end else begin
        if(l1_all_last_7_3)begin
            l1_cache_7_6 <= 0;
            l1_cache_7_7 <= 0;
        end else begin
            if(l1_valid_7_6 & l1_ready_7_6)begin
                l1_cache_7_6 <= l1_data_7_6.data;
            end
            if(l1_valid_7_7 & l1_ready_7_7)begin
                l1_cache_7_7 <= l1_data_7_7.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_3 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_3) begin
            l2_in_valid_7_3 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_3 <= |l1_grant_7_3;
        end
    end
    //sync case
    if(l1_all_last_7_3) begin
        l2_in_data_7_3.last <= 1;
        l2_in_data_7_3.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_3)
            2'b01: l2_in_data_7_3 <= l1_data_7_6;
            2'b10: l2_in_data_7_3 <= l1_data_7_7;
            default: l2_in_data_7_3 <= 0;
        endcase
    end   
end

assign l1_all_last_7_4 = (l1_data_7_8.last & l1_valid_7_8) & (l1_data_7_9.last & l1_valid_7_9) & !l2_almost_full_7_4;
assign l1_same_7_4 = l1_newdata_7_8 & l1_newdata_7_9 & (l1_data_7_8.data==l1_data_7_9.data) & !l2_almost_full_7_4;
assign l1_newdata_7_8 = l1_valid_7_8 & (l1_data_7_8.data != l1_cache_7_8) & !l1_data_7_8.last;

assign l1_newdata_7_9 = l1_valid_7_9 & (l1_data_7_9.data != l1_cache_7_9) & !l1_data_7_9.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_4[0] = l1_newdata_7_8 & !l2_almost_full_7_4;
    l1_ready_7_8 = l1_grant_7_4[0];       
    l1_req_7_4[1] = l1_newdata_7_9 & !l2_almost_full_7_4;
    l1_ready_7_9 = l1_grant_7_4[1];       
    //sync case
    if(l1_all_last_7_4) begin
        l1_req_7_4 = 0;
        l1_ready_7_8 = 1;
        l1_ready_7_9 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_4)begin
        l1_req_7_4[0] = 1;
        l1_req_7_4[0] = 0;
        l1_ready_7_9 = 1;
    end else begin
        if(l1_valid_7_8 & (l1_data_7_8.data == l1_cache_7_8) & !l1_data_7_8.last)begin
            l1_ready_7_8 = 1;
        end
        if(l1_valid_7_9 & (l1_data_7_9.data == l1_cache_7_9) & !l1_data_7_9.last)begin
            l1_ready_7_9 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_8 <= 0;
        l1_cache_7_9 <= 0;
    end else begin
        if(l1_all_last_7_4)begin
            l1_cache_7_8 <= 0;
            l1_cache_7_9 <= 0;
        end else begin
            if(l1_valid_7_8 & l1_ready_7_8)begin
                l1_cache_7_8 <= l1_data_7_8.data;
            end
            if(l1_valid_7_9 & l1_ready_7_9)begin
                l1_cache_7_9 <= l1_data_7_9.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_4 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_4) begin
            l2_in_valid_7_4 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_4 <= |l1_grant_7_4;
        end
    end
    //sync case
    if(l1_all_last_7_4) begin
        l2_in_data_7_4.last <= 1;
        l2_in_data_7_4.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_4)
            2'b01: l2_in_data_7_4 <= l1_data_7_8;
            2'b10: l2_in_data_7_4 <= l1_data_7_9;
            default: l2_in_data_7_4 <= 0;
        endcase
    end   
end

assign l1_all_last_7_5 = (l1_data_7_10.last & l1_valid_7_10) & (l1_data_7_11.last & l1_valid_7_11) & !l2_almost_full_7_5;
assign l1_same_7_5 = l1_newdata_7_10 & l1_newdata_7_11 & (l1_data_7_10.data==l1_data_7_11.data) & !l2_almost_full_7_5;
assign l1_newdata_7_10 = l1_valid_7_10 & (l1_data_7_10.data != l1_cache_7_10) & !l1_data_7_10.last;

assign l1_newdata_7_11 = l1_valid_7_11 & (l1_data_7_11.data != l1_cache_7_11) & !l1_data_7_11.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_5[0] = l1_newdata_7_10 & !l2_almost_full_7_5;
    l1_ready_7_10 = l1_grant_7_5[0];       
    l1_req_7_5[1] = l1_newdata_7_11 & !l2_almost_full_7_5;
    l1_ready_7_11 = l1_grant_7_5[1];       
    //sync case
    if(l1_all_last_7_5) begin
        l1_req_7_5 = 0;
        l1_ready_7_10 = 1;
        l1_ready_7_11 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_5)begin
        l1_req_7_5[0] = 1;
        l1_req_7_5[0] = 0;
        l1_ready_7_11 = 1;
    end else begin
        if(l1_valid_7_10 & (l1_data_7_10.data == l1_cache_7_10) & !l1_data_7_10.last)begin
            l1_ready_7_10 = 1;
        end
        if(l1_valid_7_11 & (l1_data_7_11.data == l1_cache_7_11) & !l1_data_7_11.last)begin
            l1_ready_7_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_10 <= 0;
        l1_cache_7_11 <= 0;
    end else begin
        if(l1_all_last_7_5)begin
            l1_cache_7_10 <= 0;
            l1_cache_7_11 <= 0;
        end else begin
            if(l1_valid_7_10 & l1_ready_7_10)begin
                l1_cache_7_10 <= l1_data_7_10.data;
            end
            if(l1_valid_7_11 & l1_ready_7_11)begin
                l1_cache_7_11 <= l1_data_7_11.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_5 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_5) begin
            l2_in_valid_7_5 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_5 <= |l1_grant_7_5;
        end
    end
    //sync case
    if(l1_all_last_7_5) begin
        l2_in_data_7_5.last <= 1;
        l2_in_data_7_5.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_5)
            2'b01: l2_in_data_7_5 <= l1_data_7_10;
            2'b10: l2_in_data_7_5 <= l1_data_7_11;
            default: l2_in_data_7_5 <= 0;
        endcase
    end   
end

assign l1_all_last_7_6 = (l1_data_7_12.last & l1_valid_7_12) & (l1_data_7_13.last & l1_valid_7_13) & !l2_almost_full_7_6;
assign l1_same_7_6 = l1_newdata_7_12 & l1_newdata_7_13 & (l1_data_7_12.data==l1_data_7_13.data) & !l2_almost_full_7_6;
assign l1_newdata_7_12 = l1_valid_7_12 & (l1_data_7_12.data != l1_cache_7_12) & !l1_data_7_12.last;

assign l1_newdata_7_13 = l1_valid_7_13 & (l1_data_7_13.data != l1_cache_7_13) & !l1_data_7_13.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_6[0] = l1_newdata_7_12 & !l2_almost_full_7_6;
    l1_ready_7_12 = l1_grant_7_6[0];       
    l1_req_7_6[1] = l1_newdata_7_13 & !l2_almost_full_7_6;
    l1_ready_7_13 = l1_grant_7_6[1];       
    //sync case
    if(l1_all_last_7_6) begin
        l1_req_7_6 = 0;
        l1_ready_7_12 = 1;
        l1_ready_7_13 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_6)begin
        l1_req_7_6[0] = 1;
        l1_req_7_6[0] = 0;
        l1_ready_7_13 = 1;
    end else begin
        if(l1_valid_7_12 & (l1_data_7_12.data == l1_cache_7_12) & !l1_data_7_12.last)begin
            l1_ready_7_12 = 1;
        end
        if(l1_valid_7_13 & (l1_data_7_13.data == l1_cache_7_13) & !l1_data_7_13.last)begin
            l1_ready_7_13 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_12 <= 0;
        l1_cache_7_13 <= 0;
    end else begin
        if(l1_all_last_7_6)begin
            l1_cache_7_12 <= 0;
            l1_cache_7_13 <= 0;
        end else begin
            if(l1_valid_7_12 & l1_ready_7_12)begin
                l1_cache_7_12 <= l1_data_7_12.data;
            end
            if(l1_valid_7_13 & l1_ready_7_13)begin
                l1_cache_7_13 <= l1_data_7_13.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_6 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_6) begin
            l2_in_valid_7_6 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_6 <= |l1_grant_7_6;
        end
    end
    //sync case
    if(l1_all_last_7_6) begin
        l2_in_data_7_6.last <= 1;
        l2_in_data_7_6.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_6)
            2'b01: l2_in_data_7_6 <= l1_data_7_12;
            2'b10: l2_in_data_7_6 <= l1_data_7_13;
            default: l2_in_data_7_6 <= 0;
        endcase
    end   
end

assign l1_all_last_7_7 = (l1_data_7_14.last & l1_valid_7_14) & (l1_data_7_15.last & l1_valid_7_15) & !l2_almost_full_7_7;
assign l1_same_7_7 = l1_newdata_7_14 & l1_newdata_7_15 & (l1_data_7_14.data==l1_data_7_15.data) & !l2_almost_full_7_7;
assign l1_newdata_7_14 = l1_valid_7_14 & (l1_data_7_14.data != l1_cache_7_14) & !l1_data_7_14.last;

assign l1_newdata_7_15 = l1_valid_7_15 & (l1_data_7_15.data != l1_cache_7_15) & !l1_data_7_15.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_7[0] = l1_newdata_7_14 & !l2_almost_full_7_7;
    l1_ready_7_14 = l1_grant_7_7[0];       
    l1_req_7_7[1] = l1_newdata_7_15 & !l2_almost_full_7_7;
    l1_ready_7_15 = l1_grant_7_7[1];       
    //sync case
    if(l1_all_last_7_7) begin
        l1_req_7_7 = 0;
        l1_ready_7_14 = 1;
        l1_ready_7_15 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_7)begin
        l1_req_7_7[0] = 1;
        l1_req_7_7[0] = 0;
        l1_ready_7_15 = 1;
    end else begin
        if(l1_valid_7_14 & (l1_data_7_14.data == l1_cache_7_14) & !l1_data_7_14.last)begin
            l1_ready_7_14 = 1;
        end
        if(l1_valid_7_15 & (l1_data_7_15.data == l1_cache_7_15) & !l1_data_7_15.last)begin
            l1_ready_7_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_14 <= 0;
        l1_cache_7_15 <= 0;
    end else begin
        if(l1_all_last_7_7)begin
            l1_cache_7_14 <= 0;
            l1_cache_7_15 <= 0;
        end else begin
            if(l1_valid_7_14 & l1_ready_7_14)begin
                l1_cache_7_14 <= l1_data_7_14.data;
            end
            if(l1_valid_7_15 & l1_ready_7_15)begin
                l1_cache_7_15 <= l1_data_7_15.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_7 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_7) begin
            l2_in_valid_7_7 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_7 <= |l1_grant_7_7;
        end
    end
    //sync case
    if(l1_all_last_7_7) begin
        l2_in_data_7_7.last <= 1;
        l2_in_data_7_7.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_7)
            2'b01: l2_in_data_7_7 <= l1_data_7_14;
            2'b10: l2_in_data_7_7 <= l1_data_7_15;
            default: l2_in_data_7_7 <= 0;
        endcase
    end   
end

assign l1_all_last_7_8 = (l1_data_7_16.last & l1_valid_7_16) & (l1_data_7_17.last & l1_valid_7_17) & !l2_almost_full_7_8;
assign l1_same_7_8 = l1_newdata_7_16 & l1_newdata_7_17 & (l1_data_7_16.data==l1_data_7_17.data) & !l2_almost_full_7_8;
assign l1_newdata_7_16 = l1_valid_7_16 & (l1_data_7_16.data != l1_cache_7_16) & !l1_data_7_16.last;

assign l1_newdata_7_17 = l1_valid_7_17 & (l1_data_7_17.data != l1_cache_7_17) & !l1_data_7_17.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_8[0] = l1_newdata_7_16 & !l2_almost_full_7_8;
    l1_ready_7_16 = l1_grant_7_8[0];       
    l1_req_7_8[1] = l1_newdata_7_17 & !l2_almost_full_7_8;
    l1_ready_7_17 = l1_grant_7_8[1];       
    //sync case
    if(l1_all_last_7_8) begin
        l1_req_7_8 = 0;
        l1_ready_7_16 = 1;
        l1_ready_7_17 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_8)begin
        l1_req_7_8[0] = 1;
        l1_req_7_8[0] = 0;
        l1_ready_7_17 = 1;
    end else begin
        if(l1_valid_7_16 & (l1_data_7_16.data == l1_cache_7_16) & !l1_data_7_16.last)begin
            l1_ready_7_16 = 1;
        end
        if(l1_valid_7_17 & (l1_data_7_17.data == l1_cache_7_17) & !l1_data_7_17.last)begin
            l1_ready_7_17 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_16 <= 0;
        l1_cache_7_17 <= 0;
    end else begin
        if(l1_all_last_7_8)begin
            l1_cache_7_16 <= 0;
            l1_cache_7_17 <= 0;
        end else begin
            if(l1_valid_7_16 & l1_ready_7_16)begin
                l1_cache_7_16 <= l1_data_7_16.data;
            end
            if(l1_valid_7_17 & l1_ready_7_17)begin
                l1_cache_7_17 <= l1_data_7_17.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_8 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_8) begin
            l2_in_valid_7_8 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_8 <= |l1_grant_7_8;
        end
    end
    //sync case
    if(l1_all_last_7_8) begin
        l2_in_data_7_8.last <= 1;
        l2_in_data_7_8.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_8)
            2'b01: l2_in_data_7_8 <= l1_data_7_16;
            2'b10: l2_in_data_7_8 <= l1_data_7_17;
            default: l2_in_data_7_8 <= 0;
        endcase
    end   
end

assign l1_all_last_7_9 = (l1_data_7_18.last & l1_valid_7_18) & (l1_data_7_19.last & l1_valid_7_19) & !l2_almost_full_7_9;
assign l1_same_7_9 = l1_newdata_7_18 & l1_newdata_7_19 & (l1_data_7_18.data==l1_data_7_19.data) & !l2_almost_full_7_9;
assign l1_newdata_7_18 = l1_valid_7_18 & (l1_data_7_18.data != l1_cache_7_18) & !l1_data_7_18.last;

assign l1_newdata_7_19 = l1_valid_7_19 & (l1_data_7_19.data != l1_cache_7_19) & !l1_data_7_19.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_9[0] = l1_newdata_7_18 & !l2_almost_full_7_9;
    l1_ready_7_18 = l1_grant_7_9[0];       
    l1_req_7_9[1] = l1_newdata_7_19 & !l2_almost_full_7_9;
    l1_ready_7_19 = l1_grant_7_9[1];       
    //sync case
    if(l1_all_last_7_9) begin
        l1_req_7_9 = 0;
        l1_ready_7_18 = 1;
        l1_ready_7_19 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_9)begin
        l1_req_7_9[0] = 1;
        l1_req_7_9[0] = 0;
        l1_ready_7_19 = 1;
    end else begin
        if(l1_valid_7_18 & (l1_data_7_18.data == l1_cache_7_18) & !l1_data_7_18.last)begin
            l1_ready_7_18 = 1;
        end
        if(l1_valid_7_19 & (l1_data_7_19.data == l1_cache_7_19) & !l1_data_7_19.last)begin
            l1_ready_7_19 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_18 <= 0;
        l1_cache_7_19 <= 0;
    end else begin
        if(l1_all_last_7_9)begin
            l1_cache_7_18 <= 0;
            l1_cache_7_19 <= 0;
        end else begin
            if(l1_valid_7_18 & l1_ready_7_18)begin
                l1_cache_7_18 <= l1_data_7_18.data;
            end
            if(l1_valid_7_19 & l1_ready_7_19)begin
                l1_cache_7_19 <= l1_data_7_19.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_9 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_9) begin
            l2_in_valid_7_9 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_9 <= |l1_grant_7_9;
        end
    end
    //sync case
    if(l1_all_last_7_9) begin
        l2_in_data_7_9.last <= 1;
        l2_in_data_7_9.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_9)
            2'b01: l2_in_data_7_9 <= l1_data_7_18;
            2'b10: l2_in_data_7_9 <= l1_data_7_19;
            default: l2_in_data_7_9 <= 0;
        endcase
    end   
end

assign l1_all_last_7_10 = (l1_data_7_20.last & l1_valid_7_20) & (l1_data_7_21.last & l1_valid_7_21) & !l2_almost_full_7_10;
assign l1_same_7_10 = l1_newdata_7_20 & l1_newdata_7_21 & (l1_data_7_20.data==l1_data_7_21.data) & !l2_almost_full_7_10;
assign l1_newdata_7_20 = l1_valid_7_20 & (l1_data_7_20.data != l1_cache_7_20) & !l1_data_7_20.last;

assign l1_newdata_7_21 = l1_valid_7_21 & (l1_data_7_21.data != l1_cache_7_21) & !l1_data_7_21.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_10[0] = l1_newdata_7_20 & !l2_almost_full_7_10;
    l1_ready_7_20 = l1_grant_7_10[0];       
    l1_req_7_10[1] = l1_newdata_7_21 & !l2_almost_full_7_10;
    l1_ready_7_21 = l1_grant_7_10[1];       
    //sync case
    if(l1_all_last_7_10) begin
        l1_req_7_10 = 0;
        l1_ready_7_20 = 1;
        l1_ready_7_21 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_10)begin
        l1_req_7_10[0] = 1;
        l1_req_7_10[0] = 0;
        l1_ready_7_21 = 1;
    end else begin
        if(l1_valid_7_20 & (l1_data_7_20.data == l1_cache_7_20) & !l1_data_7_20.last)begin
            l1_ready_7_20 = 1;
        end
        if(l1_valid_7_21 & (l1_data_7_21.data == l1_cache_7_21) & !l1_data_7_21.last)begin
            l1_ready_7_21 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_20 <= 0;
        l1_cache_7_21 <= 0;
    end else begin
        if(l1_all_last_7_10)begin
            l1_cache_7_20 <= 0;
            l1_cache_7_21 <= 0;
        end else begin
            if(l1_valid_7_20 & l1_ready_7_20)begin
                l1_cache_7_20 <= l1_data_7_20.data;
            end
            if(l1_valid_7_21 & l1_ready_7_21)begin
                l1_cache_7_21 <= l1_data_7_21.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_10 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_10) begin
            l2_in_valid_7_10 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_10 <= |l1_grant_7_10;
        end
    end
    //sync case
    if(l1_all_last_7_10) begin
        l2_in_data_7_10.last <= 1;
        l2_in_data_7_10.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_10)
            2'b01: l2_in_data_7_10 <= l1_data_7_20;
            2'b10: l2_in_data_7_10 <= l1_data_7_21;
            default: l2_in_data_7_10 <= 0;
        endcase
    end   
end

assign l1_all_last_7_11 = (l1_data_7_22.last & l1_valid_7_22) & (l1_data_7_23.last & l1_valid_7_23) & !l2_almost_full_7_11;
assign l1_same_7_11 = l1_newdata_7_22 & l1_newdata_7_23 & (l1_data_7_22.data==l1_data_7_23.data) & !l2_almost_full_7_11;
assign l1_newdata_7_22 = l1_valid_7_22 & (l1_data_7_22.data != l1_cache_7_22) & !l1_data_7_22.last;

assign l1_newdata_7_23 = l1_valid_7_23 & (l1_data_7_23.data != l1_cache_7_23) & !l1_data_7_23.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_11[0] = l1_newdata_7_22 & !l2_almost_full_7_11;
    l1_ready_7_22 = l1_grant_7_11[0];       
    l1_req_7_11[1] = l1_newdata_7_23 & !l2_almost_full_7_11;
    l1_ready_7_23 = l1_grant_7_11[1];       
    //sync case
    if(l1_all_last_7_11) begin
        l1_req_7_11 = 0;
        l1_ready_7_22 = 1;
        l1_ready_7_23 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_11)begin
        l1_req_7_11[0] = 1;
        l1_req_7_11[0] = 0;
        l1_ready_7_23 = 1;
    end else begin
        if(l1_valid_7_22 & (l1_data_7_22.data == l1_cache_7_22) & !l1_data_7_22.last)begin
            l1_ready_7_22 = 1;
        end
        if(l1_valid_7_23 & (l1_data_7_23.data == l1_cache_7_23) & !l1_data_7_23.last)begin
            l1_ready_7_23 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_22 <= 0;
        l1_cache_7_23 <= 0;
    end else begin
        if(l1_all_last_7_11)begin
            l1_cache_7_22 <= 0;
            l1_cache_7_23 <= 0;
        end else begin
            if(l1_valid_7_22 & l1_ready_7_22)begin
                l1_cache_7_22 <= l1_data_7_22.data;
            end
            if(l1_valid_7_23 & l1_ready_7_23)begin
                l1_cache_7_23 <= l1_data_7_23.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_11 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_11) begin
            l2_in_valid_7_11 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_11 <= |l1_grant_7_11;
        end
    end
    //sync case
    if(l1_all_last_7_11) begin
        l2_in_data_7_11.last <= 1;
        l2_in_data_7_11.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_11)
            2'b01: l2_in_data_7_11 <= l1_data_7_22;
            2'b10: l2_in_data_7_11 <= l1_data_7_23;
            default: l2_in_data_7_11 <= 0;
        endcase
    end   
end

assign l1_all_last_7_12 = (l1_data_7_24.last & l1_valid_7_24) & (l1_data_7_25.last & l1_valid_7_25) & !l2_almost_full_7_12;
assign l1_same_7_12 = l1_newdata_7_24 & l1_newdata_7_25 & (l1_data_7_24.data==l1_data_7_25.data) & !l2_almost_full_7_12;
assign l1_newdata_7_24 = l1_valid_7_24 & (l1_data_7_24.data != l1_cache_7_24) & !l1_data_7_24.last;

assign l1_newdata_7_25 = l1_valid_7_25 & (l1_data_7_25.data != l1_cache_7_25) & !l1_data_7_25.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_12[0] = l1_newdata_7_24 & !l2_almost_full_7_12;
    l1_ready_7_24 = l1_grant_7_12[0];       
    l1_req_7_12[1] = l1_newdata_7_25 & !l2_almost_full_7_12;
    l1_ready_7_25 = l1_grant_7_12[1];       
    //sync case
    if(l1_all_last_7_12) begin
        l1_req_7_12 = 0;
        l1_ready_7_24 = 1;
        l1_ready_7_25 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_12)begin
        l1_req_7_12[0] = 1;
        l1_req_7_12[0] = 0;
        l1_ready_7_25 = 1;
    end else begin
        if(l1_valid_7_24 & (l1_data_7_24.data == l1_cache_7_24) & !l1_data_7_24.last)begin
            l1_ready_7_24 = 1;
        end
        if(l1_valid_7_25 & (l1_data_7_25.data == l1_cache_7_25) & !l1_data_7_25.last)begin
            l1_ready_7_25 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_24 <= 0;
        l1_cache_7_25 <= 0;
    end else begin
        if(l1_all_last_7_12)begin
            l1_cache_7_24 <= 0;
            l1_cache_7_25 <= 0;
        end else begin
            if(l1_valid_7_24 & l1_ready_7_24)begin
                l1_cache_7_24 <= l1_data_7_24.data;
            end
            if(l1_valid_7_25 & l1_ready_7_25)begin
                l1_cache_7_25 <= l1_data_7_25.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_12 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_12) begin
            l2_in_valid_7_12 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_12 <= |l1_grant_7_12;
        end
    end
    //sync case
    if(l1_all_last_7_12) begin
        l2_in_data_7_12.last <= 1;
        l2_in_data_7_12.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_12)
            2'b01: l2_in_data_7_12 <= l1_data_7_24;
            2'b10: l2_in_data_7_12 <= l1_data_7_25;
            default: l2_in_data_7_12 <= 0;
        endcase
    end   
end

assign l1_all_last_7_13 = (l1_data_7_26.last & l1_valid_7_26) & (l1_data_7_27.last & l1_valid_7_27) & !l2_almost_full_7_13;
assign l1_same_7_13 = l1_newdata_7_26 & l1_newdata_7_27 & (l1_data_7_26.data==l1_data_7_27.data) & !l2_almost_full_7_13;
assign l1_newdata_7_26 = l1_valid_7_26 & (l1_data_7_26.data != l1_cache_7_26) & !l1_data_7_26.last;

assign l1_newdata_7_27 = l1_valid_7_27 & (l1_data_7_27.data != l1_cache_7_27) & !l1_data_7_27.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_13[0] = l1_newdata_7_26 & !l2_almost_full_7_13;
    l1_ready_7_26 = l1_grant_7_13[0];       
    l1_req_7_13[1] = l1_newdata_7_27 & !l2_almost_full_7_13;
    l1_ready_7_27 = l1_grant_7_13[1];       
    //sync case
    if(l1_all_last_7_13) begin
        l1_req_7_13 = 0;
        l1_ready_7_26 = 1;
        l1_ready_7_27 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_13)begin
        l1_req_7_13[0] = 1;
        l1_req_7_13[0] = 0;
        l1_ready_7_27 = 1;
    end else begin
        if(l1_valid_7_26 & (l1_data_7_26.data == l1_cache_7_26) & !l1_data_7_26.last)begin
            l1_ready_7_26 = 1;
        end
        if(l1_valid_7_27 & (l1_data_7_27.data == l1_cache_7_27) & !l1_data_7_27.last)begin
            l1_ready_7_27 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_26 <= 0;
        l1_cache_7_27 <= 0;
    end else begin
        if(l1_all_last_7_13)begin
            l1_cache_7_26 <= 0;
            l1_cache_7_27 <= 0;
        end else begin
            if(l1_valid_7_26 & l1_ready_7_26)begin
                l1_cache_7_26 <= l1_data_7_26.data;
            end
            if(l1_valid_7_27 & l1_ready_7_27)begin
                l1_cache_7_27 <= l1_data_7_27.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_13 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_13) begin
            l2_in_valid_7_13 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_13 <= |l1_grant_7_13;
        end
    end
    //sync case
    if(l1_all_last_7_13) begin
        l2_in_data_7_13.last <= 1;
        l2_in_data_7_13.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_13)
            2'b01: l2_in_data_7_13 <= l1_data_7_26;
            2'b10: l2_in_data_7_13 <= l1_data_7_27;
            default: l2_in_data_7_13 <= 0;
        endcase
    end   
end

assign l1_all_last_7_14 = (l1_data_7_28.last & l1_valid_7_28) & (l1_data_7_29.last & l1_valid_7_29) & !l2_almost_full_7_14;
assign l1_same_7_14 = l1_newdata_7_28 & l1_newdata_7_29 & (l1_data_7_28.data==l1_data_7_29.data) & !l2_almost_full_7_14;
assign l1_newdata_7_28 = l1_valid_7_28 & (l1_data_7_28.data != l1_cache_7_28) & !l1_data_7_28.last;

assign l1_newdata_7_29 = l1_valid_7_29 & (l1_data_7_29.data != l1_cache_7_29) & !l1_data_7_29.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_14[0] = l1_newdata_7_28 & !l2_almost_full_7_14;
    l1_ready_7_28 = l1_grant_7_14[0];       
    l1_req_7_14[1] = l1_newdata_7_29 & !l2_almost_full_7_14;
    l1_ready_7_29 = l1_grant_7_14[1];       
    //sync case
    if(l1_all_last_7_14) begin
        l1_req_7_14 = 0;
        l1_ready_7_28 = 1;
        l1_ready_7_29 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_14)begin
        l1_req_7_14[0] = 1;
        l1_req_7_14[0] = 0;
        l1_ready_7_29 = 1;
    end else begin
        if(l1_valid_7_28 & (l1_data_7_28.data == l1_cache_7_28) & !l1_data_7_28.last)begin
            l1_ready_7_28 = 1;
        end
        if(l1_valid_7_29 & (l1_data_7_29.data == l1_cache_7_29) & !l1_data_7_29.last)begin
            l1_ready_7_29 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_28 <= 0;
        l1_cache_7_29 <= 0;
    end else begin
        if(l1_all_last_7_14)begin
            l1_cache_7_28 <= 0;
            l1_cache_7_29 <= 0;
        end else begin
            if(l1_valid_7_28 & l1_ready_7_28)begin
                l1_cache_7_28 <= l1_data_7_28.data;
            end
            if(l1_valid_7_29 & l1_ready_7_29)begin
                l1_cache_7_29 <= l1_data_7_29.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_14 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_14) begin
            l2_in_valid_7_14 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_14 <= |l1_grant_7_14;
        end
    end
    //sync case
    if(l1_all_last_7_14) begin
        l2_in_data_7_14.last <= 1;
        l2_in_data_7_14.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_14)
            2'b01: l2_in_data_7_14 <= l1_data_7_28;
            2'b10: l2_in_data_7_14 <= l1_data_7_29;
            default: l2_in_data_7_14 <= 0;
        endcase
    end   
end

assign l1_all_last_7_15 = (l1_data_7_30.last & l1_valid_7_30) & (l1_data_7_31.last & l1_valid_7_31) & !l2_almost_full_7_15;
assign l1_same_7_15 = l1_newdata_7_30 & l1_newdata_7_31 & (l1_data_7_30.data==l1_data_7_31.data) & !l2_almost_full_7_15;
assign l1_newdata_7_30 = l1_valid_7_30 & (l1_data_7_30.data != l1_cache_7_30) & !l1_data_7_30.last;

assign l1_newdata_7_31 = l1_valid_7_31 & (l1_data_7_31.data != l1_cache_7_31) & !l1_data_7_31.last;

//generate request, combinationally logic
always @(*)begin
    l1_req_7_15[0] = l1_newdata_7_30 & !l2_almost_full_7_15;
    l1_ready_7_30 = l1_grant_7_15[0];       
    l1_req_7_15[1] = l1_newdata_7_31 & !l2_almost_full_7_15;
    l1_ready_7_31 = l1_grant_7_15[1];       
    //sync case
    if(l1_all_last_7_15) begin
        l1_req_7_15 = 0;
        l1_ready_7_30 = 1;
        l1_ready_7_31 = 1;
    //if the values are same, reduce the duplicated one. 
    end else if (l1_same_7_15)begin
        l1_req_7_15[0] = 1;
        l1_req_7_15[0] = 0;
        l1_ready_7_31 = 1;
    end else begin
        if(l1_valid_7_30 & (l1_data_7_30.data == l1_cache_7_30) & !l1_data_7_30.last)begin
            l1_ready_7_30 = 1;
        end
        if(l1_valid_7_31 & (l1_data_7_31.data == l1_cache_7_31) & !l1_data_7_31.last)begin
            l1_ready_7_31 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l1_cache_7_30 <= 0;
        l1_cache_7_31 <= 0;
    end else begin
        if(l1_all_last_7_15)begin
            l1_cache_7_30 <= 0;
            l1_cache_7_31 <= 0;
        end else begin
            if(l1_valid_7_30 & l1_ready_7_30)begin
                l1_cache_7_30 <= l1_data_7_30.data;
            end
            if(l1_valid_7_31 & l1_ready_7_31)begin
                l1_cache_7_31 <= l1_data_7_31.data;
            end
        end
    end
end
//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l2_in_valid_7_15 <= 0;
    end else begin
        //sync case
        if(l1_all_last_7_15) begin
            l2_in_valid_7_15 <= 1;
        //normal case
        end else begin
            l2_in_valid_7_15 <= |l1_grant_7_15;
        end
    end
    //sync case
    if(l1_all_last_7_15) begin
        l2_in_data_7_15.last <= 1;
        l2_in_data_7_15.data <= 0;
    //normal case
    end else begin
        case(l1_grant_7_15)
            2'b01: l2_in_data_7_15 <= l1_data_7_30;
            2'b10: l2_in_data_7_15 <= l1_data_7_31;
            default: l2_in_data_7_15 <= 0;
        endcase
    end   
end



//L2
//L1 FIFO output
assign l2_all_last_0_0 =  (l2_out_data_0_0.last & l2_out_valid_0_0) &  (l2_out_data_0_1.last & l2_out_valid_0_1) &  (l2_out_data_0_2.last & l2_out_valid_0_2) &  (l2_out_data_0_3.last & l2_out_valid_0_3) &  !l3_almost_full_0_0;
assign l2_same_0_0 =  (l2_newdata_0_0) &  (l2_newdata_0_1) &  (l2_newdata_0_2) &  (l2_newdata_0_3) &  
                             (l2_out_data_0_0.data==l2_out_data_0_1.data) & (l2_out_data_0_0.data==l2_out_data_0_2.data) 
                             & (l2_out_data_0_0.data==l2_out_data_0_3.data)
                             & !l3_almost_full_0_0;
assign l2_newdata_0_0 = l2_out_valid_0_0 & (l2_out_data_0_0.data != l2_cache_0_0) & !l2_out_data_0_0.last;
assign l2_newdata_0_1 = l2_out_valid_0_1 & (l2_out_data_0_1.data != l2_cache_0_1) & !l2_out_data_0_1.last;
assign l2_newdata_0_2 = l2_out_valid_0_2 & (l2_out_data_0_2.data != l2_cache_0_2) & !l2_out_data_0_2.last;
assign l2_newdata_0_3 = l2_out_valid_0_3 & (l2_out_data_0_3.data != l2_cache_0_3) & !l2_out_data_0_3.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_0_0[0] = l2_newdata_0_0 & !l3_almost_full_0_0;
    l2_out_ready_0_0 = l2_grant_0_0[0];       
    l2_req_0_0[1] = l2_newdata_0_1 & !l3_almost_full_0_0;
    l2_out_ready_0_1 = l2_grant_0_0[1];       
    l2_req_0_0[2] = l2_newdata_0_2 & !l3_almost_full_0_0;
    l2_out_ready_0_2 = l2_grant_0_0[2];       
    l2_req_0_0[3] = l2_newdata_0_3 & !l3_almost_full_0_0;
    l2_out_ready_0_3 = l2_grant_0_0[3];       
    //sync case
    if(l2_all_last_0_0) begin
        l2_req_0_0 = 0;
        l2_out_ready_0_0 = 1;
        l2_out_ready_0_1 = 1;
        l2_out_ready_0_2 = 1;
        l2_out_ready_0_3 = 1;
    end else if(l2_same_0_0)begin
        l2_req_0_0[0] = 1;
        l2_req_0_0[3:1] = 0;
        l2_out_ready_0_1 = 1;
        l2_out_ready_0_2 = 1;
        l2_out_ready_0_3 = 1;
    end else begin
        if(l2_out_valid_0_0 & (l2_out_data_0_0.data == l2_cache_0_0) 
          & !l2_out_data_0_0.last)begin
            l2_out_ready_0_0 = 1;
        end
        if(l2_out_valid_0_1 & (l2_out_data_0_1.data == l2_cache_0_1) 
          & !l2_out_data_0_1.last)begin
            l2_out_ready_0_1 = 1;
        end
        if(l2_out_valid_0_2 & (l2_out_data_0_2.data == l2_cache_0_2) 
          & !l2_out_data_0_2.last)begin
            l2_out_ready_0_2 = 1;
        end
        if(l2_out_valid_0_3 & (l2_out_data_0_3.data == l2_cache_0_3) 
          & !l2_out_data_0_3.last)begin
            l2_out_ready_0_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_0_0 <= 0;
        l2_cache_0_1 <= 0;
        l2_cache_0_2 <= 0;
        l2_cache_0_3 <= 0;
    end else begin
        if(l2_all_last_0_0)begin
            l2_cache_0_0 <= 0;
            l2_cache_0_1 <= 0;
            l2_cache_0_2 <= 0;
            l2_cache_0_3 <= 0;
        end else begin
            if(l2_out_valid_0_0 & l2_out_ready_0_0)begin
                l2_cache_0_0 <= l2_out_data_0_0.data;
            end
            if(l2_out_valid_0_1 & l2_out_ready_0_1)begin
                l2_cache_0_1 <= l2_out_data_0_1.data;
            end
            if(l2_out_valid_0_2 & l2_out_ready_0_2)begin
                l2_cache_0_2 <= l2_out_data_0_2.data;
            end
            if(l2_out_valid_0_3 & l2_out_ready_0_3)begin
                l2_cache_0_3 <= l2_out_data_0_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_0_0 <= 0;
    end else begin
        //sync case
        if(l2_all_last_0_0) begin
            l3_in_valid_0_0 <= 1;
        //normal case
        end else begin
            l3_in_valid_0_0 <= |l2_grant_0_0;
        end
    end
    //sync case
    if(l2_all_last_0_0) begin
        l3_in_data_0_0.last <= 1;
        l3_in_data_0_0.data <= 0;
    //normal case
    end else begin
        case(l2_grant_0_0)
            4'b0001: l3_in_data_0_0 <= l2_out_data_0_0;
            4'b0010: l3_in_data_0_0 <= l2_out_data_0_1;
            4'b0100: l3_in_data_0_0 <= l2_out_data_0_2;
            4'b1000: l3_in_data_0_0 <= l2_out_data_0_3;
            default: l3_in_data_0_0 <= 0;
        endcase
    end   
end
assign l2_all_last_0_1 =  (l2_out_data_0_4.last & l2_out_valid_0_4) &  (l2_out_data_0_5.last & l2_out_valid_0_5) &  (l2_out_data_0_6.last & l2_out_valid_0_6) &  (l2_out_data_0_7.last & l2_out_valid_0_7) &  !l3_almost_full_0_1;
assign l2_same_0_1 =  (l2_newdata_0_4) &  (l2_newdata_0_5) &  (l2_newdata_0_6) &  (l2_newdata_0_7) &  
                             (l2_out_data_0_4.data==l2_out_data_0_5.data) & (l2_out_data_0_4.data==l2_out_data_0_6.data) 
                             & (l2_out_data_0_4.data==l2_out_data_0_7.data)
                             & !l3_almost_full_0_1;
assign l2_newdata_0_4 = l2_out_valid_0_4 & (l2_out_data_0_4.data != l2_cache_0_4) & !l2_out_data_0_4.last;
assign l2_newdata_0_5 = l2_out_valid_0_5 & (l2_out_data_0_5.data != l2_cache_0_5) & !l2_out_data_0_5.last;
assign l2_newdata_0_6 = l2_out_valid_0_6 & (l2_out_data_0_6.data != l2_cache_0_6) & !l2_out_data_0_6.last;
assign l2_newdata_0_7 = l2_out_valid_0_7 & (l2_out_data_0_7.data != l2_cache_0_7) & !l2_out_data_0_7.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_0_1[0] = l2_newdata_0_4 & !l3_almost_full_0_1;
    l2_out_ready_0_4 = l2_grant_0_1[0];       
    l2_req_0_1[1] = l2_newdata_0_5 & !l3_almost_full_0_1;
    l2_out_ready_0_5 = l2_grant_0_1[1];       
    l2_req_0_1[2] = l2_newdata_0_6 & !l3_almost_full_0_1;
    l2_out_ready_0_6 = l2_grant_0_1[2];       
    l2_req_0_1[3] = l2_newdata_0_7 & !l3_almost_full_0_1;
    l2_out_ready_0_7 = l2_grant_0_1[3];       
    //sync case
    if(l2_all_last_0_1) begin
        l2_req_0_1 = 0;
        l2_out_ready_0_4 = 1;
        l2_out_ready_0_5 = 1;
        l2_out_ready_0_6 = 1;
        l2_out_ready_0_7 = 1;
    end else if(l2_same_0_1)begin
        l2_req_0_1[0] = 1;
        l2_req_0_1[3:1] = 0;
        l2_out_ready_0_5 = 1;
        l2_out_ready_0_6 = 1;
        l2_out_ready_0_7 = 1;
    end else begin
        if(l2_out_valid_0_4 & (l2_out_data_0_4.data == l2_cache_0_4) 
          & !l2_out_data_0_4.last)begin
            l2_out_ready_0_4 = 1;
        end
        if(l2_out_valid_0_5 & (l2_out_data_0_5.data == l2_cache_0_5) 
          & !l2_out_data_0_5.last)begin
            l2_out_ready_0_5 = 1;
        end
        if(l2_out_valid_0_6 & (l2_out_data_0_6.data == l2_cache_0_6) 
          & !l2_out_data_0_6.last)begin
            l2_out_ready_0_6 = 1;
        end
        if(l2_out_valid_0_7 & (l2_out_data_0_7.data == l2_cache_0_7) 
          & !l2_out_data_0_7.last)begin
            l2_out_ready_0_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_0_4 <= 0;
        l2_cache_0_5 <= 0;
        l2_cache_0_6 <= 0;
        l2_cache_0_7 <= 0;
    end else begin
        if(l2_all_last_0_1)begin
            l2_cache_0_4 <= 0;
            l2_cache_0_5 <= 0;
            l2_cache_0_6 <= 0;
            l2_cache_0_7 <= 0;
        end else begin
            if(l2_out_valid_0_4 & l2_out_ready_0_4)begin
                l2_cache_0_4 <= l2_out_data_0_4.data;
            end
            if(l2_out_valid_0_5 & l2_out_ready_0_5)begin
                l2_cache_0_5 <= l2_out_data_0_5.data;
            end
            if(l2_out_valid_0_6 & l2_out_ready_0_6)begin
                l2_cache_0_6 <= l2_out_data_0_6.data;
            end
            if(l2_out_valid_0_7 & l2_out_ready_0_7)begin
                l2_cache_0_7 <= l2_out_data_0_7.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_0_1 <= 0;
    end else begin
        //sync case
        if(l2_all_last_0_1) begin
            l3_in_valid_0_1 <= 1;
        //normal case
        end else begin
            l3_in_valid_0_1 <= |l2_grant_0_1;
        end
    end
    //sync case
    if(l2_all_last_0_1) begin
        l3_in_data_0_1.last <= 1;
        l3_in_data_0_1.data <= 0;
    //normal case
    end else begin
        case(l2_grant_0_1)
            4'b0001: l3_in_data_0_1 <= l2_out_data_0_4;
            4'b0010: l3_in_data_0_1 <= l2_out_data_0_5;
            4'b0100: l3_in_data_0_1 <= l2_out_data_0_6;
            4'b1000: l3_in_data_0_1 <= l2_out_data_0_7;
            default: l3_in_data_0_1 <= 0;
        endcase
    end   
end
assign l2_all_last_0_2 =  (l2_out_data_0_8.last & l2_out_valid_0_8) &  (l2_out_data_0_9.last & l2_out_valid_0_9) &  (l2_out_data_0_10.last & l2_out_valid_0_10) &  (l2_out_data_0_11.last & l2_out_valid_0_11) &  !l3_almost_full_0_2;
assign l2_same_0_2 =  (l2_newdata_0_8) &  (l2_newdata_0_9) &  (l2_newdata_0_10) &  (l2_newdata_0_11) &  
                             (l2_out_data_0_8.data==l2_out_data_0_9.data) & (l2_out_data_0_8.data==l2_out_data_0_10.data) 
                             & (l2_out_data_0_8.data==l2_out_data_0_11.data)
                             & !l3_almost_full_0_2;
assign l2_newdata_0_8 = l2_out_valid_0_8 & (l2_out_data_0_8.data != l2_cache_0_8) & !l2_out_data_0_8.last;
assign l2_newdata_0_9 = l2_out_valid_0_9 & (l2_out_data_0_9.data != l2_cache_0_9) & !l2_out_data_0_9.last;
assign l2_newdata_0_10 = l2_out_valid_0_10 & (l2_out_data_0_10.data != l2_cache_0_10) & !l2_out_data_0_10.last;
assign l2_newdata_0_11 = l2_out_valid_0_11 & (l2_out_data_0_11.data != l2_cache_0_11) & !l2_out_data_0_11.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_0_2[0] = l2_newdata_0_8 & !l3_almost_full_0_2;
    l2_out_ready_0_8 = l2_grant_0_2[0];       
    l2_req_0_2[1] = l2_newdata_0_9 & !l3_almost_full_0_2;
    l2_out_ready_0_9 = l2_grant_0_2[1];       
    l2_req_0_2[2] = l2_newdata_0_10 & !l3_almost_full_0_2;
    l2_out_ready_0_10 = l2_grant_0_2[2];       
    l2_req_0_2[3] = l2_newdata_0_11 & !l3_almost_full_0_2;
    l2_out_ready_0_11 = l2_grant_0_2[3];       
    //sync case
    if(l2_all_last_0_2) begin
        l2_req_0_2 = 0;
        l2_out_ready_0_8 = 1;
        l2_out_ready_0_9 = 1;
        l2_out_ready_0_10 = 1;
        l2_out_ready_0_11 = 1;
    end else if(l2_same_0_2)begin
        l2_req_0_2[0] = 1;
        l2_req_0_2[3:1] = 0;
        l2_out_ready_0_9 = 1;
        l2_out_ready_0_10 = 1;
        l2_out_ready_0_11 = 1;
    end else begin
        if(l2_out_valid_0_8 & (l2_out_data_0_8.data == l2_cache_0_8) 
          & !l2_out_data_0_8.last)begin
            l2_out_ready_0_8 = 1;
        end
        if(l2_out_valid_0_9 & (l2_out_data_0_9.data == l2_cache_0_9) 
          & !l2_out_data_0_9.last)begin
            l2_out_ready_0_9 = 1;
        end
        if(l2_out_valid_0_10 & (l2_out_data_0_10.data == l2_cache_0_10) 
          & !l2_out_data_0_10.last)begin
            l2_out_ready_0_10 = 1;
        end
        if(l2_out_valid_0_11 & (l2_out_data_0_11.data == l2_cache_0_11) 
          & !l2_out_data_0_11.last)begin
            l2_out_ready_0_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_0_8 <= 0;
        l2_cache_0_9 <= 0;
        l2_cache_0_10 <= 0;
        l2_cache_0_11 <= 0;
    end else begin
        if(l2_all_last_0_2)begin
            l2_cache_0_8 <= 0;
            l2_cache_0_9 <= 0;
            l2_cache_0_10 <= 0;
            l2_cache_0_11 <= 0;
        end else begin
            if(l2_out_valid_0_8 & l2_out_ready_0_8)begin
                l2_cache_0_8 <= l2_out_data_0_8.data;
            end
            if(l2_out_valid_0_9 & l2_out_ready_0_9)begin
                l2_cache_0_9 <= l2_out_data_0_9.data;
            end
            if(l2_out_valid_0_10 & l2_out_ready_0_10)begin
                l2_cache_0_10 <= l2_out_data_0_10.data;
            end
            if(l2_out_valid_0_11 & l2_out_ready_0_11)begin
                l2_cache_0_11 <= l2_out_data_0_11.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_0_2 <= 0;
    end else begin
        //sync case
        if(l2_all_last_0_2) begin
            l3_in_valid_0_2 <= 1;
        //normal case
        end else begin
            l3_in_valid_0_2 <= |l2_grant_0_2;
        end
    end
    //sync case
    if(l2_all_last_0_2) begin
        l3_in_data_0_2.last <= 1;
        l3_in_data_0_2.data <= 0;
    //normal case
    end else begin
        case(l2_grant_0_2)
            4'b0001: l3_in_data_0_2 <= l2_out_data_0_8;
            4'b0010: l3_in_data_0_2 <= l2_out_data_0_9;
            4'b0100: l3_in_data_0_2 <= l2_out_data_0_10;
            4'b1000: l3_in_data_0_2 <= l2_out_data_0_11;
            default: l3_in_data_0_2 <= 0;
        endcase
    end   
end
assign l2_all_last_0_3 =  (l2_out_data_0_12.last & l2_out_valid_0_12) &  (l2_out_data_0_13.last & l2_out_valid_0_13) &  (l2_out_data_0_14.last & l2_out_valid_0_14) &  (l2_out_data_0_15.last & l2_out_valid_0_15) &  !l3_almost_full_0_3;
assign l2_same_0_3 =  (l2_newdata_0_12) &  (l2_newdata_0_13) &  (l2_newdata_0_14) &  (l2_newdata_0_15) &  
                             (l2_out_data_0_12.data==l2_out_data_0_13.data) & (l2_out_data_0_12.data==l2_out_data_0_14.data) 
                             & (l2_out_data_0_12.data==l2_out_data_0_15.data)
                             & !l3_almost_full_0_3;
assign l2_newdata_0_12 = l2_out_valid_0_12 & (l2_out_data_0_12.data != l2_cache_0_12) & !l2_out_data_0_12.last;
assign l2_newdata_0_13 = l2_out_valid_0_13 & (l2_out_data_0_13.data != l2_cache_0_13) & !l2_out_data_0_13.last;
assign l2_newdata_0_14 = l2_out_valid_0_14 & (l2_out_data_0_14.data != l2_cache_0_14) & !l2_out_data_0_14.last;
assign l2_newdata_0_15 = l2_out_valid_0_15 & (l2_out_data_0_15.data != l2_cache_0_15) & !l2_out_data_0_15.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_0_3[0] = l2_newdata_0_12 & !l3_almost_full_0_3;
    l2_out_ready_0_12 = l2_grant_0_3[0];       
    l2_req_0_3[1] = l2_newdata_0_13 & !l3_almost_full_0_3;
    l2_out_ready_0_13 = l2_grant_0_3[1];       
    l2_req_0_3[2] = l2_newdata_0_14 & !l3_almost_full_0_3;
    l2_out_ready_0_14 = l2_grant_0_3[2];       
    l2_req_0_3[3] = l2_newdata_0_15 & !l3_almost_full_0_3;
    l2_out_ready_0_15 = l2_grant_0_3[3];       
    //sync case
    if(l2_all_last_0_3) begin
        l2_req_0_3 = 0;
        l2_out_ready_0_12 = 1;
        l2_out_ready_0_13 = 1;
        l2_out_ready_0_14 = 1;
        l2_out_ready_0_15 = 1;
    end else if(l2_same_0_3)begin
        l2_req_0_3[0] = 1;
        l2_req_0_3[3:1] = 0;
        l2_out_ready_0_13 = 1;
        l2_out_ready_0_14 = 1;
        l2_out_ready_0_15 = 1;
    end else begin
        if(l2_out_valid_0_12 & (l2_out_data_0_12.data == l2_cache_0_12) 
          & !l2_out_data_0_12.last)begin
            l2_out_ready_0_12 = 1;
        end
        if(l2_out_valid_0_13 & (l2_out_data_0_13.data == l2_cache_0_13) 
          & !l2_out_data_0_13.last)begin
            l2_out_ready_0_13 = 1;
        end
        if(l2_out_valid_0_14 & (l2_out_data_0_14.data == l2_cache_0_14) 
          & !l2_out_data_0_14.last)begin
            l2_out_ready_0_14 = 1;
        end
        if(l2_out_valid_0_15 & (l2_out_data_0_15.data == l2_cache_0_15) 
          & !l2_out_data_0_15.last)begin
            l2_out_ready_0_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_0_12 <= 0;
        l2_cache_0_13 <= 0;
        l2_cache_0_14 <= 0;
        l2_cache_0_15 <= 0;
    end else begin
        if(l2_all_last_0_3)begin
            l2_cache_0_12 <= 0;
            l2_cache_0_13 <= 0;
            l2_cache_0_14 <= 0;
            l2_cache_0_15 <= 0;
        end else begin
            if(l2_out_valid_0_12 & l2_out_ready_0_12)begin
                l2_cache_0_12 <= l2_out_data_0_12.data;
            end
            if(l2_out_valid_0_13 & l2_out_ready_0_13)begin
                l2_cache_0_13 <= l2_out_data_0_13.data;
            end
            if(l2_out_valid_0_14 & l2_out_ready_0_14)begin
                l2_cache_0_14 <= l2_out_data_0_14.data;
            end
            if(l2_out_valid_0_15 & l2_out_ready_0_15)begin
                l2_cache_0_15 <= l2_out_data_0_15.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_0_3 <= 0;
    end else begin
        //sync case
        if(l2_all_last_0_3) begin
            l3_in_valid_0_3 <= 1;
        //normal case
        end else begin
            l3_in_valid_0_3 <= |l2_grant_0_3;
        end
    end
    //sync case
    if(l2_all_last_0_3) begin
        l3_in_data_0_3.last <= 1;
        l3_in_data_0_3.data <= 0;
    //normal case
    end else begin
        case(l2_grant_0_3)
            4'b0001: l3_in_data_0_3 <= l2_out_data_0_12;
            4'b0010: l3_in_data_0_3 <= l2_out_data_0_13;
            4'b0100: l3_in_data_0_3 <= l2_out_data_0_14;
            4'b1000: l3_in_data_0_3 <= l2_out_data_0_15;
            default: l3_in_data_0_3 <= 0;
        endcase
    end   
end
assign l2_all_last_1_0 =  (l2_out_data_1_0.last & l2_out_valid_1_0) &  (l2_out_data_1_1.last & l2_out_valid_1_1) &  (l2_out_data_1_2.last & l2_out_valid_1_2) &  (l2_out_data_1_3.last & l2_out_valid_1_3) &  !l3_almost_full_1_0;
assign l2_same_1_0 =  (l2_newdata_1_0) &  (l2_newdata_1_1) &  (l2_newdata_1_2) &  (l2_newdata_1_3) &  
                             (l2_out_data_1_0.data==l2_out_data_1_1.data) & (l2_out_data_1_0.data==l2_out_data_1_2.data) 
                             & (l2_out_data_1_0.data==l2_out_data_1_3.data)
                             & !l3_almost_full_1_0;
assign l2_newdata_1_0 = l2_out_valid_1_0 & (l2_out_data_1_0.data != l2_cache_1_0) & !l2_out_data_1_0.last;
assign l2_newdata_1_1 = l2_out_valid_1_1 & (l2_out_data_1_1.data != l2_cache_1_1) & !l2_out_data_1_1.last;
assign l2_newdata_1_2 = l2_out_valid_1_2 & (l2_out_data_1_2.data != l2_cache_1_2) & !l2_out_data_1_2.last;
assign l2_newdata_1_3 = l2_out_valid_1_3 & (l2_out_data_1_3.data != l2_cache_1_3) & !l2_out_data_1_3.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_1_0[0] = l2_newdata_1_0 & !l3_almost_full_1_0;
    l2_out_ready_1_0 = l2_grant_1_0[0];       
    l2_req_1_0[1] = l2_newdata_1_1 & !l3_almost_full_1_0;
    l2_out_ready_1_1 = l2_grant_1_0[1];       
    l2_req_1_0[2] = l2_newdata_1_2 & !l3_almost_full_1_0;
    l2_out_ready_1_2 = l2_grant_1_0[2];       
    l2_req_1_0[3] = l2_newdata_1_3 & !l3_almost_full_1_0;
    l2_out_ready_1_3 = l2_grant_1_0[3];       
    //sync case
    if(l2_all_last_1_0) begin
        l2_req_1_0 = 0;
        l2_out_ready_1_0 = 1;
        l2_out_ready_1_1 = 1;
        l2_out_ready_1_2 = 1;
        l2_out_ready_1_3 = 1;
    end else if(l2_same_1_0)begin
        l2_req_1_0[0] = 1;
        l2_req_1_0[3:1] = 0;
        l2_out_ready_1_1 = 1;
        l2_out_ready_1_2 = 1;
        l2_out_ready_1_3 = 1;
    end else begin
        if(l2_out_valid_1_0 & (l2_out_data_1_0.data == l2_cache_1_0) 
          & !l2_out_data_1_0.last)begin
            l2_out_ready_1_0 = 1;
        end
        if(l2_out_valid_1_1 & (l2_out_data_1_1.data == l2_cache_1_1) 
          & !l2_out_data_1_1.last)begin
            l2_out_ready_1_1 = 1;
        end
        if(l2_out_valid_1_2 & (l2_out_data_1_2.data == l2_cache_1_2) 
          & !l2_out_data_1_2.last)begin
            l2_out_ready_1_2 = 1;
        end
        if(l2_out_valid_1_3 & (l2_out_data_1_3.data == l2_cache_1_3) 
          & !l2_out_data_1_3.last)begin
            l2_out_ready_1_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_1_0 <= 0;
        l2_cache_1_1 <= 0;
        l2_cache_1_2 <= 0;
        l2_cache_1_3 <= 0;
    end else begin
        if(l2_all_last_1_0)begin
            l2_cache_1_0 <= 0;
            l2_cache_1_1 <= 0;
            l2_cache_1_2 <= 0;
            l2_cache_1_3 <= 0;
        end else begin
            if(l2_out_valid_1_0 & l2_out_ready_1_0)begin
                l2_cache_1_0 <= l2_out_data_1_0.data;
            end
            if(l2_out_valid_1_1 & l2_out_ready_1_1)begin
                l2_cache_1_1 <= l2_out_data_1_1.data;
            end
            if(l2_out_valid_1_2 & l2_out_ready_1_2)begin
                l2_cache_1_2 <= l2_out_data_1_2.data;
            end
            if(l2_out_valid_1_3 & l2_out_ready_1_3)begin
                l2_cache_1_3 <= l2_out_data_1_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_1_0 <= 0;
    end else begin
        //sync case
        if(l2_all_last_1_0) begin
            l3_in_valid_1_0 <= 1;
        //normal case
        end else begin
            l3_in_valid_1_0 <= |l2_grant_1_0;
        end
    end
    //sync case
    if(l2_all_last_1_0) begin
        l3_in_data_1_0.last <= 1;
        l3_in_data_1_0.data <= 0;
    //normal case
    end else begin
        case(l2_grant_1_0)
            4'b0001: l3_in_data_1_0 <= l2_out_data_1_0;
            4'b0010: l3_in_data_1_0 <= l2_out_data_1_1;
            4'b0100: l3_in_data_1_0 <= l2_out_data_1_2;
            4'b1000: l3_in_data_1_0 <= l2_out_data_1_3;
            default: l3_in_data_1_0 <= 0;
        endcase
    end   
end
assign l2_all_last_1_1 =  (l2_out_data_1_4.last & l2_out_valid_1_4) &  (l2_out_data_1_5.last & l2_out_valid_1_5) &  (l2_out_data_1_6.last & l2_out_valid_1_6) &  (l2_out_data_1_7.last & l2_out_valid_1_7) &  !l3_almost_full_1_1;
assign l2_same_1_1 =  (l2_newdata_1_4) &  (l2_newdata_1_5) &  (l2_newdata_1_6) &  (l2_newdata_1_7) &  
                             (l2_out_data_1_4.data==l2_out_data_1_5.data) & (l2_out_data_1_4.data==l2_out_data_1_6.data) 
                             & (l2_out_data_1_4.data==l2_out_data_1_7.data)
                             & !l3_almost_full_1_1;
assign l2_newdata_1_4 = l2_out_valid_1_4 & (l2_out_data_1_4.data != l2_cache_1_4) & !l2_out_data_1_4.last;
assign l2_newdata_1_5 = l2_out_valid_1_5 & (l2_out_data_1_5.data != l2_cache_1_5) & !l2_out_data_1_5.last;
assign l2_newdata_1_6 = l2_out_valid_1_6 & (l2_out_data_1_6.data != l2_cache_1_6) & !l2_out_data_1_6.last;
assign l2_newdata_1_7 = l2_out_valid_1_7 & (l2_out_data_1_7.data != l2_cache_1_7) & !l2_out_data_1_7.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_1_1[0] = l2_newdata_1_4 & !l3_almost_full_1_1;
    l2_out_ready_1_4 = l2_grant_1_1[0];       
    l2_req_1_1[1] = l2_newdata_1_5 & !l3_almost_full_1_1;
    l2_out_ready_1_5 = l2_grant_1_1[1];       
    l2_req_1_1[2] = l2_newdata_1_6 & !l3_almost_full_1_1;
    l2_out_ready_1_6 = l2_grant_1_1[2];       
    l2_req_1_1[3] = l2_newdata_1_7 & !l3_almost_full_1_1;
    l2_out_ready_1_7 = l2_grant_1_1[3];       
    //sync case
    if(l2_all_last_1_1) begin
        l2_req_1_1 = 0;
        l2_out_ready_1_4 = 1;
        l2_out_ready_1_5 = 1;
        l2_out_ready_1_6 = 1;
        l2_out_ready_1_7 = 1;
    end else if(l2_same_1_1)begin
        l2_req_1_1[0] = 1;
        l2_req_1_1[3:1] = 0;
        l2_out_ready_1_5 = 1;
        l2_out_ready_1_6 = 1;
        l2_out_ready_1_7 = 1;
    end else begin
        if(l2_out_valid_1_4 & (l2_out_data_1_4.data == l2_cache_1_4) 
          & !l2_out_data_1_4.last)begin
            l2_out_ready_1_4 = 1;
        end
        if(l2_out_valid_1_5 & (l2_out_data_1_5.data == l2_cache_1_5) 
          & !l2_out_data_1_5.last)begin
            l2_out_ready_1_5 = 1;
        end
        if(l2_out_valid_1_6 & (l2_out_data_1_6.data == l2_cache_1_6) 
          & !l2_out_data_1_6.last)begin
            l2_out_ready_1_6 = 1;
        end
        if(l2_out_valid_1_7 & (l2_out_data_1_7.data == l2_cache_1_7) 
          & !l2_out_data_1_7.last)begin
            l2_out_ready_1_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_1_4 <= 0;
        l2_cache_1_5 <= 0;
        l2_cache_1_6 <= 0;
        l2_cache_1_7 <= 0;
    end else begin
        if(l2_all_last_1_1)begin
            l2_cache_1_4 <= 0;
            l2_cache_1_5 <= 0;
            l2_cache_1_6 <= 0;
            l2_cache_1_7 <= 0;
        end else begin
            if(l2_out_valid_1_4 & l2_out_ready_1_4)begin
                l2_cache_1_4 <= l2_out_data_1_4.data;
            end
            if(l2_out_valid_1_5 & l2_out_ready_1_5)begin
                l2_cache_1_5 <= l2_out_data_1_5.data;
            end
            if(l2_out_valid_1_6 & l2_out_ready_1_6)begin
                l2_cache_1_6 <= l2_out_data_1_6.data;
            end
            if(l2_out_valid_1_7 & l2_out_ready_1_7)begin
                l2_cache_1_7 <= l2_out_data_1_7.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_1_1 <= 0;
    end else begin
        //sync case
        if(l2_all_last_1_1) begin
            l3_in_valid_1_1 <= 1;
        //normal case
        end else begin
            l3_in_valid_1_1 <= |l2_grant_1_1;
        end
    end
    //sync case
    if(l2_all_last_1_1) begin
        l3_in_data_1_1.last <= 1;
        l3_in_data_1_1.data <= 0;
    //normal case
    end else begin
        case(l2_grant_1_1)
            4'b0001: l3_in_data_1_1 <= l2_out_data_1_4;
            4'b0010: l3_in_data_1_1 <= l2_out_data_1_5;
            4'b0100: l3_in_data_1_1 <= l2_out_data_1_6;
            4'b1000: l3_in_data_1_1 <= l2_out_data_1_7;
            default: l3_in_data_1_1 <= 0;
        endcase
    end   
end
assign l2_all_last_1_2 =  (l2_out_data_1_8.last & l2_out_valid_1_8) &  (l2_out_data_1_9.last & l2_out_valid_1_9) &  (l2_out_data_1_10.last & l2_out_valid_1_10) &  (l2_out_data_1_11.last & l2_out_valid_1_11) &  !l3_almost_full_1_2;
assign l2_same_1_2 =  (l2_newdata_1_8) &  (l2_newdata_1_9) &  (l2_newdata_1_10) &  (l2_newdata_1_11) &  
                             (l2_out_data_1_8.data==l2_out_data_1_9.data) & (l2_out_data_1_8.data==l2_out_data_1_10.data) 
                             & (l2_out_data_1_8.data==l2_out_data_1_11.data)
                             & !l3_almost_full_1_2;
assign l2_newdata_1_8 = l2_out_valid_1_8 & (l2_out_data_1_8.data != l2_cache_1_8) & !l2_out_data_1_8.last;
assign l2_newdata_1_9 = l2_out_valid_1_9 & (l2_out_data_1_9.data != l2_cache_1_9) & !l2_out_data_1_9.last;
assign l2_newdata_1_10 = l2_out_valid_1_10 & (l2_out_data_1_10.data != l2_cache_1_10) & !l2_out_data_1_10.last;
assign l2_newdata_1_11 = l2_out_valid_1_11 & (l2_out_data_1_11.data != l2_cache_1_11) & !l2_out_data_1_11.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_1_2[0] = l2_newdata_1_8 & !l3_almost_full_1_2;
    l2_out_ready_1_8 = l2_grant_1_2[0];       
    l2_req_1_2[1] = l2_newdata_1_9 & !l3_almost_full_1_2;
    l2_out_ready_1_9 = l2_grant_1_2[1];       
    l2_req_1_2[2] = l2_newdata_1_10 & !l3_almost_full_1_2;
    l2_out_ready_1_10 = l2_grant_1_2[2];       
    l2_req_1_2[3] = l2_newdata_1_11 & !l3_almost_full_1_2;
    l2_out_ready_1_11 = l2_grant_1_2[3];       
    //sync case
    if(l2_all_last_1_2) begin
        l2_req_1_2 = 0;
        l2_out_ready_1_8 = 1;
        l2_out_ready_1_9 = 1;
        l2_out_ready_1_10 = 1;
        l2_out_ready_1_11 = 1;
    end else if(l2_same_1_2)begin
        l2_req_1_2[0] = 1;
        l2_req_1_2[3:1] = 0;
        l2_out_ready_1_9 = 1;
        l2_out_ready_1_10 = 1;
        l2_out_ready_1_11 = 1;
    end else begin
        if(l2_out_valid_1_8 & (l2_out_data_1_8.data == l2_cache_1_8) 
          & !l2_out_data_1_8.last)begin
            l2_out_ready_1_8 = 1;
        end
        if(l2_out_valid_1_9 & (l2_out_data_1_9.data == l2_cache_1_9) 
          & !l2_out_data_1_9.last)begin
            l2_out_ready_1_9 = 1;
        end
        if(l2_out_valid_1_10 & (l2_out_data_1_10.data == l2_cache_1_10) 
          & !l2_out_data_1_10.last)begin
            l2_out_ready_1_10 = 1;
        end
        if(l2_out_valid_1_11 & (l2_out_data_1_11.data == l2_cache_1_11) 
          & !l2_out_data_1_11.last)begin
            l2_out_ready_1_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_1_8 <= 0;
        l2_cache_1_9 <= 0;
        l2_cache_1_10 <= 0;
        l2_cache_1_11 <= 0;
    end else begin
        if(l2_all_last_1_2)begin
            l2_cache_1_8 <= 0;
            l2_cache_1_9 <= 0;
            l2_cache_1_10 <= 0;
            l2_cache_1_11 <= 0;
        end else begin
            if(l2_out_valid_1_8 & l2_out_ready_1_8)begin
                l2_cache_1_8 <= l2_out_data_1_8.data;
            end
            if(l2_out_valid_1_9 & l2_out_ready_1_9)begin
                l2_cache_1_9 <= l2_out_data_1_9.data;
            end
            if(l2_out_valid_1_10 & l2_out_ready_1_10)begin
                l2_cache_1_10 <= l2_out_data_1_10.data;
            end
            if(l2_out_valid_1_11 & l2_out_ready_1_11)begin
                l2_cache_1_11 <= l2_out_data_1_11.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_1_2 <= 0;
    end else begin
        //sync case
        if(l2_all_last_1_2) begin
            l3_in_valid_1_2 <= 1;
        //normal case
        end else begin
            l3_in_valid_1_2 <= |l2_grant_1_2;
        end
    end
    //sync case
    if(l2_all_last_1_2) begin
        l3_in_data_1_2.last <= 1;
        l3_in_data_1_2.data <= 0;
    //normal case
    end else begin
        case(l2_grant_1_2)
            4'b0001: l3_in_data_1_2 <= l2_out_data_1_8;
            4'b0010: l3_in_data_1_2 <= l2_out_data_1_9;
            4'b0100: l3_in_data_1_2 <= l2_out_data_1_10;
            4'b1000: l3_in_data_1_2 <= l2_out_data_1_11;
            default: l3_in_data_1_2 <= 0;
        endcase
    end   
end
assign l2_all_last_1_3 =  (l2_out_data_1_12.last & l2_out_valid_1_12) &  (l2_out_data_1_13.last & l2_out_valid_1_13) &  (l2_out_data_1_14.last & l2_out_valid_1_14) &  (l2_out_data_1_15.last & l2_out_valid_1_15) &  !l3_almost_full_1_3;
assign l2_same_1_3 =  (l2_newdata_1_12) &  (l2_newdata_1_13) &  (l2_newdata_1_14) &  (l2_newdata_1_15) &  
                             (l2_out_data_1_12.data==l2_out_data_1_13.data) & (l2_out_data_1_12.data==l2_out_data_1_14.data) 
                             & (l2_out_data_1_12.data==l2_out_data_1_15.data)
                             & !l3_almost_full_1_3;
assign l2_newdata_1_12 = l2_out_valid_1_12 & (l2_out_data_1_12.data != l2_cache_1_12) & !l2_out_data_1_12.last;
assign l2_newdata_1_13 = l2_out_valid_1_13 & (l2_out_data_1_13.data != l2_cache_1_13) & !l2_out_data_1_13.last;
assign l2_newdata_1_14 = l2_out_valid_1_14 & (l2_out_data_1_14.data != l2_cache_1_14) & !l2_out_data_1_14.last;
assign l2_newdata_1_15 = l2_out_valid_1_15 & (l2_out_data_1_15.data != l2_cache_1_15) & !l2_out_data_1_15.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_1_3[0] = l2_newdata_1_12 & !l3_almost_full_1_3;
    l2_out_ready_1_12 = l2_grant_1_3[0];       
    l2_req_1_3[1] = l2_newdata_1_13 & !l3_almost_full_1_3;
    l2_out_ready_1_13 = l2_grant_1_3[1];       
    l2_req_1_3[2] = l2_newdata_1_14 & !l3_almost_full_1_3;
    l2_out_ready_1_14 = l2_grant_1_3[2];       
    l2_req_1_3[3] = l2_newdata_1_15 & !l3_almost_full_1_3;
    l2_out_ready_1_15 = l2_grant_1_3[3];       
    //sync case
    if(l2_all_last_1_3) begin
        l2_req_1_3 = 0;
        l2_out_ready_1_12 = 1;
        l2_out_ready_1_13 = 1;
        l2_out_ready_1_14 = 1;
        l2_out_ready_1_15 = 1;
    end else if(l2_same_1_3)begin
        l2_req_1_3[0] = 1;
        l2_req_1_3[3:1] = 0;
        l2_out_ready_1_13 = 1;
        l2_out_ready_1_14 = 1;
        l2_out_ready_1_15 = 1;
    end else begin
        if(l2_out_valid_1_12 & (l2_out_data_1_12.data == l2_cache_1_12) 
          & !l2_out_data_1_12.last)begin
            l2_out_ready_1_12 = 1;
        end
        if(l2_out_valid_1_13 & (l2_out_data_1_13.data == l2_cache_1_13) 
          & !l2_out_data_1_13.last)begin
            l2_out_ready_1_13 = 1;
        end
        if(l2_out_valid_1_14 & (l2_out_data_1_14.data == l2_cache_1_14) 
          & !l2_out_data_1_14.last)begin
            l2_out_ready_1_14 = 1;
        end
        if(l2_out_valid_1_15 & (l2_out_data_1_15.data == l2_cache_1_15) 
          & !l2_out_data_1_15.last)begin
            l2_out_ready_1_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_1_12 <= 0;
        l2_cache_1_13 <= 0;
        l2_cache_1_14 <= 0;
        l2_cache_1_15 <= 0;
    end else begin
        if(l2_all_last_1_3)begin
            l2_cache_1_12 <= 0;
            l2_cache_1_13 <= 0;
            l2_cache_1_14 <= 0;
            l2_cache_1_15 <= 0;
        end else begin
            if(l2_out_valid_1_12 & l2_out_ready_1_12)begin
                l2_cache_1_12 <= l2_out_data_1_12.data;
            end
            if(l2_out_valid_1_13 & l2_out_ready_1_13)begin
                l2_cache_1_13 <= l2_out_data_1_13.data;
            end
            if(l2_out_valid_1_14 & l2_out_ready_1_14)begin
                l2_cache_1_14 <= l2_out_data_1_14.data;
            end
            if(l2_out_valid_1_15 & l2_out_ready_1_15)begin
                l2_cache_1_15 <= l2_out_data_1_15.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_1_3 <= 0;
    end else begin
        //sync case
        if(l2_all_last_1_3) begin
            l3_in_valid_1_3 <= 1;
        //normal case
        end else begin
            l3_in_valid_1_3 <= |l2_grant_1_3;
        end
    end
    //sync case
    if(l2_all_last_1_3) begin
        l3_in_data_1_3.last <= 1;
        l3_in_data_1_3.data <= 0;
    //normal case
    end else begin
        case(l2_grant_1_3)
            4'b0001: l3_in_data_1_3 <= l2_out_data_1_12;
            4'b0010: l3_in_data_1_3 <= l2_out_data_1_13;
            4'b0100: l3_in_data_1_3 <= l2_out_data_1_14;
            4'b1000: l3_in_data_1_3 <= l2_out_data_1_15;
            default: l3_in_data_1_3 <= 0;
        endcase
    end   
end
assign l2_all_last_2_0 =  (l2_out_data_2_0.last & l2_out_valid_2_0) &  (l2_out_data_2_1.last & l2_out_valid_2_1) &  (l2_out_data_2_2.last & l2_out_valid_2_2) &  (l2_out_data_2_3.last & l2_out_valid_2_3) &  !l3_almost_full_2_0;
assign l2_same_2_0 =  (l2_newdata_2_0) &  (l2_newdata_2_1) &  (l2_newdata_2_2) &  (l2_newdata_2_3) &  
                             (l2_out_data_2_0.data==l2_out_data_2_1.data) & (l2_out_data_2_0.data==l2_out_data_2_2.data) 
                             & (l2_out_data_2_0.data==l2_out_data_2_3.data)
                             & !l3_almost_full_2_0;
assign l2_newdata_2_0 = l2_out_valid_2_0 & (l2_out_data_2_0.data != l2_cache_2_0) & !l2_out_data_2_0.last;
assign l2_newdata_2_1 = l2_out_valid_2_1 & (l2_out_data_2_1.data != l2_cache_2_1) & !l2_out_data_2_1.last;
assign l2_newdata_2_2 = l2_out_valid_2_2 & (l2_out_data_2_2.data != l2_cache_2_2) & !l2_out_data_2_2.last;
assign l2_newdata_2_3 = l2_out_valid_2_3 & (l2_out_data_2_3.data != l2_cache_2_3) & !l2_out_data_2_3.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_2_0[0] = l2_newdata_2_0 & !l3_almost_full_2_0;
    l2_out_ready_2_0 = l2_grant_2_0[0];       
    l2_req_2_0[1] = l2_newdata_2_1 & !l3_almost_full_2_0;
    l2_out_ready_2_1 = l2_grant_2_0[1];       
    l2_req_2_0[2] = l2_newdata_2_2 & !l3_almost_full_2_0;
    l2_out_ready_2_2 = l2_grant_2_0[2];       
    l2_req_2_0[3] = l2_newdata_2_3 & !l3_almost_full_2_0;
    l2_out_ready_2_3 = l2_grant_2_0[3];       
    //sync case
    if(l2_all_last_2_0) begin
        l2_req_2_0 = 0;
        l2_out_ready_2_0 = 1;
        l2_out_ready_2_1 = 1;
        l2_out_ready_2_2 = 1;
        l2_out_ready_2_3 = 1;
    end else if(l2_same_2_0)begin
        l2_req_2_0[0] = 1;
        l2_req_2_0[3:1] = 0;
        l2_out_ready_2_1 = 1;
        l2_out_ready_2_2 = 1;
        l2_out_ready_2_3 = 1;
    end else begin
        if(l2_out_valid_2_0 & (l2_out_data_2_0.data == l2_cache_2_0) 
          & !l2_out_data_2_0.last)begin
            l2_out_ready_2_0 = 1;
        end
        if(l2_out_valid_2_1 & (l2_out_data_2_1.data == l2_cache_2_1) 
          & !l2_out_data_2_1.last)begin
            l2_out_ready_2_1 = 1;
        end
        if(l2_out_valid_2_2 & (l2_out_data_2_2.data == l2_cache_2_2) 
          & !l2_out_data_2_2.last)begin
            l2_out_ready_2_2 = 1;
        end
        if(l2_out_valid_2_3 & (l2_out_data_2_3.data == l2_cache_2_3) 
          & !l2_out_data_2_3.last)begin
            l2_out_ready_2_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_2_0 <= 0;
        l2_cache_2_1 <= 0;
        l2_cache_2_2 <= 0;
        l2_cache_2_3 <= 0;
    end else begin
        if(l2_all_last_2_0)begin
            l2_cache_2_0 <= 0;
            l2_cache_2_1 <= 0;
            l2_cache_2_2 <= 0;
            l2_cache_2_3 <= 0;
        end else begin
            if(l2_out_valid_2_0 & l2_out_ready_2_0)begin
                l2_cache_2_0 <= l2_out_data_2_0.data;
            end
            if(l2_out_valid_2_1 & l2_out_ready_2_1)begin
                l2_cache_2_1 <= l2_out_data_2_1.data;
            end
            if(l2_out_valid_2_2 & l2_out_ready_2_2)begin
                l2_cache_2_2 <= l2_out_data_2_2.data;
            end
            if(l2_out_valid_2_3 & l2_out_ready_2_3)begin
                l2_cache_2_3 <= l2_out_data_2_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_2_0 <= 0;
    end else begin
        //sync case
        if(l2_all_last_2_0) begin
            l3_in_valid_2_0 <= 1;
        //normal case
        end else begin
            l3_in_valid_2_0 <= |l2_grant_2_0;
        end
    end
    //sync case
    if(l2_all_last_2_0) begin
        l3_in_data_2_0.last <= 1;
        l3_in_data_2_0.data <= 0;
    //normal case
    end else begin
        case(l2_grant_2_0)
            4'b0001: l3_in_data_2_0 <= l2_out_data_2_0;
            4'b0010: l3_in_data_2_0 <= l2_out_data_2_1;
            4'b0100: l3_in_data_2_0 <= l2_out_data_2_2;
            4'b1000: l3_in_data_2_0 <= l2_out_data_2_3;
            default: l3_in_data_2_0 <= 0;
        endcase
    end   
end
assign l2_all_last_2_1 =  (l2_out_data_2_4.last & l2_out_valid_2_4) &  (l2_out_data_2_5.last & l2_out_valid_2_5) &  (l2_out_data_2_6.last & l2_out_valid_2_6) &  (l2_out_data_2_7.last & l2_out_valid_2_7) &  !l3_almost_full_2_1;
assign l2_same_2_1 =  (l2_newdata_2_4) &  (l2_newdata_2_5) &  (l2_newdata_2_6) &  (l2_newdata_2_7) &  
                             (l2_out_data_2_4.data==l2_out_data_2_5.data) & (l2_out_data_2_4.data==l2_out_data_2_6.data) 
                             & (l2_out_data_2_4.data==l2_out_data_2_7.data)
                             & !l3_almost_full_2_1;
assign l2_newdata_2_4 = l2_out_valid_2_4 & (l2_out_data_2_4.data != l2_cache_2_4) & !l2_out_data_2_4.last;
assign l2_newdata_2_5 = l2_out_valid_2_5 & (l2_out_data_2_5.data != l2_cache_2_5) & !l2_out_data_2_5.last;
assign l2_newdata_2_6 = l2_out_valid_2_6 & (l2_out_data_2_6.data != l2_cache_2_6) & !l2_out_data_2_6.last;
assign l2_newdata_2_7 = l2_out_valid_2_7 & (l2_out_data_2_7.data != l2_cache_2_7) & !l2_out_data_2_7.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_2_1[0] = l2_newdata_2_4 & !l3_almost_full_2_1;
    l2_out_ready_2_4 = l2_grant_2_1[0];       
    l2_req_2_1[1] = l2_newdata_2_5 & !l3_almost_full_2_1;
    l2_out_ready_2_5 = l2_grant_2_1[1];       
    l2_req_2_1[2] = l2_newdata_2_6 & !l3_almost_full_2_1;
    l2_out_ready_2_6 = l2_grant_2_1[2];       
    l2_req_2_1[3] = l2_newdata_2_7 & !l3_almost_full_2_1;
    l2_out_ready_2_7 = l2_grant_2_1[3];       
    //sync case
    if(l2_all_last_2_1) begin
        l2_req_2_1 = 0;
        l2_out_ready_2_4 = 1;
        l2_out_ready_2_5 = 1;
        l2_out_ready_2_6 = 1;
        l2_out_ready_2_7 = 1;
    end else if(l2_same_2_1)begin
        l2_req_2_1[0] = 1;
        l2_req_2_1[3:1] = 0;
        l2_out_ready_2_5 = 1;
        l2_out_ready_2_6 = 1;
        l2_out_ready_2_7 = 1;
    end else begin
        if(l2_out_valid_2_4 & (l2_out_data_2_4.data == l2_cache_2_4) 
          & !l2_out_data_2_4.last)begin
            l2_out_ready_2_4 = 1;
        end
        if(l2_out_valid_2_5 & (l2_out_data_2_5.data == l2_cache_2_5) 
          & !l2_out_data_2_5.last)begin
            l2_out_ready_2_5 = 1;
        end
        if(l2_out_valid_2_6 & (l2_out_data_2_6.data == l2_cache_2_6) 
          & !l2_out_data_2_6.last)begin
            l2_out_ready_2_6 = 1;
        end
        if(l2_out_valid_2_7 & (l2_out_data_2_7.data == l2_cache_2_7) 
          & !l2_out_data_2_7.last)begin
            l2_out_ready_2_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_2_4 <= 0;
        l2_cache_2_5 <= 0;
        l2_cache_2_6 <= 0;
        l2_cache_2_7 <= 0;
    end else begin
        if(l2_all_last_2_1)begin
            l2_cache_2_4 <= 0;
            l2_cache_2_5 <= 0;
            l2_cache_2_6 <= 0;
            l2_cache_2_7 <= 0;
        end else begin
            if(l2_out_valid_2_4 & l2_out_ready_2_4)begin
                l2_cache_2_4 <= l2_out_data_2_4.data;
            end
            if(l2_out_valid_2_5 & l2_out_ready_2_5)begin
                l2_cache_2_5 <= l2_out_data_2_5.data;
            end
            if(l2_out_valid_2_6 & l2_out_ready_2_6)begin
                l2_cache_2_6 <= l2_out_data_2_6.data;
            end
            if(l2_out_valid_2_7 & l2_out_ready_2_7)begin
                l2_cache_2_7 <= l2_out_data_2_7.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_2_1 <= 0;
    end else begin
        //sync case
        if(l2_all_last_2_1) begin
            l3_in_valid_2_1 <= 1;
        //normal case
        end else begin
            l3_in_valid_2_1 <= |l2_grant_2_1;
        end
    end
    //sync case
    if(l2_all_last_2_1) begin
        l3_in_data_2_1.last <= 1;
        l3_in_data_2_1.data <= 0;
    //normal case
    end else begin
        case(l2_grant_2_1)
            4'b0001: l3_in_data_2_1 <= l2_out_data_2_4;
            4'b0010: l3_in_data_2_1 <= l2_out_data_2_5;
            4'b0100: l3_in_data_2_1 <= l2_out_data_2_6;
            4'b1000: l3_in_data_2_1 <= l2_out_data_2_7;
            default: l3_in_data_2_1 <= 0;
        endcase
    end   
end
assign l2_all_last_2_2 =  (l2_out_data_2_8.last & l2_out_valid_2_8) &  (l2_out_data_2_9.last & l2_out_valid_2_9) &  (l2_out_data_2_10.last & l2_out_valid_2_10) &  (l2_out_data_2_11.last & l2_out_valid_2_11) &  !l3_almost_full_2_2;
assign l2_same_2_2 =  (l2_newdata_2_8) &  (l2_newdata_2_9) &  (l2_newdata_2_10) &  (l2_newdata_2_11) &  
                             (l2_out_data_2_8.data==l2_out_data_2_9.data) & (l2_out_data_2_8.data==l2_out_data_2_10.data) 
                             & (l2_out_data_2_8.data==l2_out_data_2_11.data)
                             & !l3_almost_full_2_2;
assign l2_newdata_2_8 = l2_out_valid_2_8 & (l2_out_data_2_8.data != l2_cache_2_8) & !l2_out_data_2_8.last;
assign l2_newdata_2_9 = l2_out_valid_2_9 & (l2_out_data_2_9.data != l2_cache_2_9) & !l2_out_data_2_9.last;
assign l2_newdata_2_10 = l2_out_valid_2_10 & (l2_out_data_2_10.data != l2_cache_2_10) & !l2_out_data_2_10.last;
assign l2_newdata_2_11 = l2_out_valid_2_11 & (l2_out_data_2_11.data != l2_cache_2_11) & !l2_out_data_2_11.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_2_2[0] = l2_newdata_2_8 & !l3_almost_full_2_2;
    l2_out_ready_2_8 = l2_grant_2_2[0];       
    l2_req_2_2[1] = l2_newdata_2_9 & !l3_almost_full_2_2;
    l2_out_ready_2_9 = l2_grant_2_2[1];       
    l2_req_2_2[2] = l2_newdata_2_10 & !l3_almost_full_2_2;
    l2_out_ready_2_10 = l2_grant_2_2[2];       
    l2_req_2_2[3] = l2_newdata_2_11 & !l3_almost_full_2_2;
    l2_out_ready_2_11 = l2_grant_2_2[3];       
    //sync case
    if(l2_all_last_2_2) begin
        l2_req_2_2 = 0;
        l2_out_ready_2_8 = 1;
        l2_out_ready_2_9 = 1;
        l2_out_ready_2_10 = 1;
        l2_out_ready_2_11 = 1;
    end else if(l2_same_2_2)begin
        l2_req_2_2[0] = 1;
        l2_req_2_2[3:1] = 0;
        l2_out_ready_2_9 = 1;
        l2_out_ready_2_10 = 1;
        l2_out_ready_2_11 = 1;
    end else begin
        if(l2_out_valid_2_8 & (l2_out_data_2_8.data == l2_cache_2_8) 
          & !l2_out_data_2_8.last)begin
            l2_out_ready_2_8 = 1;
        end
        if(l2_out_valid_2_9 & (l2_out_data_2_9.data == l2_cache_2_9) 
          & !l2_out_data_2_9.last)begin
            l2_out_ready_2_9 = 1;
        end
        if(l2_out_valid_2_10 & (l2_out_data_2_10.data == l2_cache_2_10) 
          & !l2_out_data_2_10.last)begin
            l2_out_ready_2_10 = 1;
        end
        if(l2_out_valid_2_11 & (l2_out_data_2_11.data == l2_cache_2_11) 
          & !l2_out_data_2_11.last)begin
            l2_out_ready_2_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_2_8 <= 0;
        l2_cache_2_9 <= 0;
        l2_cache_2_10 <= 0;
        l2_cache_2_11 <= 0;
    end else begin
        if(l2_all_last_2_2)begin
            l2_cache_2_8 <= 0;
            l2_cache_2_9 <= 0;
            l2_cache_2_10 <= 0;
            l2_cache_2_11 <= 0;
        end else begin
            if(l2_out_valid_2_8 & l2_out_ready_2_8)begin
                l2_cache_2_8 <= l2_out_data_2_8.data;
            end
            if(l2_out_valid_2_9 & l2_out_ready_2_9)begin
                l2_cache_2_9 <= l2_out_data_2_9.data;
            end
            if(l2_out_valid_2_10 & l2_out_ready_2_10)begin
                l2_cache_2_10 <= l2_out_data_2_10.data;
            end
            if(l2_out_valid_2_11 & l2_out_ready_2_11)begin
                l2_cache_2_11 <= l2_out_data_2_11.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_2_2 <= 0;
    end else begin
        //sync case
        if(l2_all_last_2_2) begin
            l3_in_valid_2_2 <= 1;
        //normal case
        end else begin
            l3_in_valid_2_2 <= |l2_grant_2_2;
        end
    end
    //sync case
    if(l2_all_last_2_2) begin
        l3_in_data_2_2.last <= 1;
        l3_in_data_2_2.data <= 0;
    //normal case
    end else begin
        case(l2_grant_2_2)
            4'b0001: l3_in_data_2_2 <= l2_out_data_2_8;
            4'b0010: l3_in_data_2_2 <= l2_out_data_2_9;
            4'b0100: l3_in_data_2_2 <= l2_out_data_2_10;
            4'b1000: l3_in_data_2_2 <= l2_out_data_2_11;
            default: l3_in_data_2_2 <= 0;
        endcase
    end   
end
assign l2_all_last_2_3 =  (l2_out_data_2_12.last & l2_out_valid_2_12) &  (l2_out_data_2_13.last & l2_out_valid_2_13) &  (l2_out_data_2_14.last & l2_out_valid_2_14) &  (l2_out_data_2_15.last & l2_out_valid_2_15) &  !l3_almost_full_2_3;
assign l2_same_2_3 =  (l2_newdata_2_12) &  (l2_newdata_2_13) &  (l2_newdata_2_14) &  (l2_newdata_2_15) &  
                             (l2_out_data_2_12.data==l2_out_data_2_13.data) & (l2_out_data_2_12.data==l2_out_data_2_14.data) 
                             & (l2_out_data_2_12.data==l2_out_data_2_15.data)
                             & !l3_almost_full_2_3;
assign l2_newdata_2_12 = l2_out_valid_2_12 & (l2_out_data_2_12.data != l2_cache_2_12) & !l2_out_data_2_12.last;
assign l2_newdata_2_13 = l2_out_valid_2_13 & (l2_out_data_2_13.data != l2_cache_2_13) & !l2_out_data_2_13.last;
assign l2_newdata_2_14 = l2_out_valid_2_14 & (l2_out_data_2_14.data != l2_cache_2_14) & !l2_out_data_2_14.last;
assign l2_newdata_2_15 = l2_out_valid_2_15 & (l2_out_data_2_15.data != l2_cache_2_15) & !l2_out_data_2_15.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_2_3[0] = l2_newdata_2_12 & !l3_almost_full_2_3;
    l2_out_ready_2_12 = l2_grant_2_3[0];       
    l2_req_2_3[1] = l2_newdata_2_13 & !l3_almost_full_2_3;
    l2_out_ready_2_13 = l2_grant_2_3[1];       
    l2_req_2_3[2] = l2_newdata_2_14 & !l3_almost_full_2_3;
    l2_out_ready_2_14 = l2_grant_2_3[2];       
    l2_req_2_3[3] = l2_newdata_2_15 & !l3_almost_full_2_3;
    l2_out_ready_2_15 = l2_grant_2_3[3];       
    //sync case
    if(l2_all_last_2_3) begin
        l2_req_2_3 = 0;
        l2_out_ready_2_12 = 1;
        l2_out_ready_2_13 = 1;
        l2_out_ready_2_14 = 1;
        l2_out_ready_2_15 = 1;
    end else if(l2_same_2_3)begin
        l2_req_2_3[0] = 1;
        l2_req_2_3[3:1] = 0;
        l2_out_ready_2_13 = 1;
        l2_out_ready_2_14 = 1;
        l2_out_ready_2_15 = 1;
    end else begin
        if(l2_out_valid_2_12 & (l2_out_data_2_12.data == l2_cache_2_12) 
          & !l2_out_data_2_12.last)begin
            l2_out_ready_2_12 = 1;
        end
        if(l2_out_valid_2_13 & (l2_out_data_2_13.data == l2_cache_2_13) 
          & !l2_out_data_2_13.last)begin
            l2_out_ready_2_13 = 1;
        end
        if(l2_out_valid_2_14 & (l2_out_data_2_14.data == l2_cache_2_14) 
          & !l2_out_data_2_14.last)begin
            l2_out_ready_2_14 = 1;
        end
        if(l2_out_valid_2_15 & (l2_out_data_2_15.data == l2_cache_2_15) 
          & !l2_out_data_2_15.last)begin
            l2_out_ready_2_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_2_12 <= 0;
        l2_cache_2_13 <= 0;
        l2_cache_2_14 <= 0;
        l2_cache_2_15 <= 0;
    end else begin
        if(l2_all_last_2_3)begin
            l2_cache_2_12 <= 0;
            l2_cache_2_13 <= 0;
            l2_cache_2_14 <= 0;
            l2_cache_2_15 <= 0;
        end else begin
            if(l2_out_valid_2_12 & l2_out_ready_2_12)begin
                l2_cache_2_12 <= l2_out_data_2_12.data;
            end
            if(l2_out_valid_2_13 & l2_out_ready_2_13)begin
                l2_cache_2_13 <= l2_out_data_2_13.data;
            end
            if(l2_out_valid_2_14 & l2_out_ready_2_14)begin
                l2_cache_2_14 <= l2_out_data_2_14.data;
            end
            if(l2_out_valid_2_15 & l2_out_ready_2_15)begin
                l2_cache_2_15 <= l2_out_data_2_15.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_2_3 <= 0;
    end else begin
        //sync case
        if(l2_all_last_2_3) begin
            l3_in_valid_2_3 <= 1;
        //normal case
        end else begin
            l3_in_valid_2_3 <= |l2_grant_2_3;
        end
    end
    //sync case
    if(l2_all_last_2_3) begin
        l3_in_data_2_3.last <= 1;
        l3_in_data_2_3.data <= 0;
    //normal case
    end else begin
        case(l2_grant_2_3)
            4'b0001: l3_in_data_2_3 <= l2_out_data_2_12;
            4'b0010: l3_in_data_2_3 <= l2_out_data_2_13;
            4'b0100: l3_in_data_2_3 <= l2_out_data_2_14;
            4'b1000: l3_in_data_2_3 <= l2_out_data_2_15;
            default: l3_in_data_2_3 <= 0;
        endcase
    end   
end
assign l2_all_last_3_0 =  (l2_out_data_3_0.last & l2_out_valid_3_0) &  (l2_out_data_3_1.last & l2_out_valid_3_1) &  (l2_out_data_3_2.last & l2_out_valid_3_2) &  (l2_out_data_3_3.last & l2_out_valid_3_3) &  !l3_almost_full_3_0;
assign l2_same_3_0 =  (l2_newdata_3_0) &  (l2_newdata_3_1) &  (l2_newdata_3_2) &  (l2_newdata_3_3) &  
                             (l2_out_data_3_0.data==l2_out_data_3_1.data) & (l2_out_data_3_0.data==l2_out_data_3_2.data) 
                             & (l2_out_data_3_0.data==l2_out_data_3_3.data)
                             & !l3_almost_full_3_0;
assign l2_newdata_3_0 = l2_out_valid_3_0 & (l2_out_data_3_0.data != l2_cache_3_0) & !l2_out_data_3_0.last;
assign l2_newdata_3_1 = l2_out_valid_3_1 & (l2_out_data_3_1.data != l2_cache_3_1) & !l2_out_data_3_1.last;
assign l2_newdata_3_2 = l2_out_valid_3_2 & (l2_out_data_3_2.data != l2_cache_3_2) & !l2_out_data_3_2.last;
assign l2_newdata_3_3 = l2_out_valid_3_3 & (l2_out_data_3_3.data != l2_cache_3_3) & !l2_out_data_3_3.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_3_0[0] = l2_newdata_3_0 & !l3_almost_full_3_0;
    l2_out_ready_3_0 = l2_grant_3_0[0];       
    l2_req_3_0[1] = l2_newdata_3_1 & !l3_almost_full_3_0;
    l2_out_ready_3_1 = l2_grant_3_0[1];       
    l2_req_3_0[2] = l2_newdata_3_2 & !l3_almost_full_3_0;
    l2_out_ready_3_2 = l2_grant_3_0[2];       
    l2_req_3_0[3] = l2_newdata_3_3 & !l3_almost_full_3_0;
    l2_out_ready_3_3 = l2_grant_3_0[3];       
    //sync case
    if(l2_all_last_3_0) begin
        l2_req_3_0 = 0;
        l2_out_ready_3_0 = 1;
        l2_out_ready_3_1 = 1;
        l2_out_ready_3_2 = 1;
        l2_out_ready_3_3 = 1;
    end else if(l2_same_3_0)begin
        l2_req_3_0[0] = 1;
        l2_req_3_0[3:1] = 0;
        l2_out_ready_3_1 = 1;
        l2_out_ready_3_2 = 1;
        l2_out_ready_3_3 = 1;
    end else begin
        if(l2_out_valid_3_0 & (l2_out_data_3_0.data == l2_cache_3_0) 
          & !l2_out_data_3_0.last)begin
            l2_out_ready_3_0 = 1;
        end
        if(l2_out_valid_3_1 & (l2_out_data_3_1.data == l2_cache_3_1) 
          & !l2_out_data_3_1.last)begin
            l2_out_ready_3_1 = 1;
        end
        if(l2_out_valid_3_2 & (l2_out_data_3_2.data == l2_cache_3_2) 
          & !l2_out_data_3_2.last)begin
            l2_out_ready_3_2 = 1;
        end
        if(l2_out_valid_3_3 & (l2_out_data_3_3.data == l2_cache_3_3) 
          & !l2_out_data_3_3.last)begin
            l2_out_ready_3_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_3_0 <= 0;
        l2_cache_3_1 <= 0;
        l2_cache_3_2 <= 0;
        l2_cache_3_3 <= 0;
    end else begin
        if(l2_all_last_3_0)begin
            l2_cache_3_0 <= 0;
            l2_cache_3_1 <= 0;
            l2_cache_3_2 <= 0;
            l2_cache_3_3 <= 0;
        end else begin
            if(l2_out_valid_3_0 & l2_out_ready_3_0)begin
                l2_cache_3_0 <= l2_out_data_3_0.data;
            end
            if(l2_out_valid_3_1 & l2_out_ready_3_1)begin
                l2_cache_3_1 <= l2_out_data_3_1.data;
            end
            if(l2_out_valid_3_2 & l2_out_ready_3_2)begin
                l2_cache_3_2 <= l2_out_data_3_2.data;
            end
            if(l2_out_valid_3_3 & l2_out_ready_3_3)begin
                l2_cache_3_3 <= l2_out_data_3_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_3_0 <= 0;
    end else begin
        //sync case
        if(l2_all_last_3_0) begin
            l3_in_valid_3_0 <= 1;
        //normal case
        end else begin
            l3_in_valid_3_0 <= |l2_grant_3_0;
        end
    end
    //sync case
    if(l2_all_last_3_0) begin
        l3_in_data_3_0.last <= 1;
        l3_in_data_3_0.data <= 0;
    //normal case
    end else begin
        case(l2_grant_3_0)
            4'b0001: l3_in_data_3_0 <= l2_out_data_3_0;
            4'b0010: l3_in_data_3_0 <= l2_out_data_3_1;
            4'b0100: l3_in_data_3_0 <= l2_out_data_3_2;
            4'b1000: l3_in_data_3_0 <= l2_out_data_3_3;
            default: l3_in_data_3_0 <= 0;
        endcase
    end   
end
assign l2_all_last_3_1 =  (l2_out_data_3_4.last & l2_out_valid_3_4) &  (l2_out_data_3_5.last & l2_out_valid_3_5) &  (l2_out_data_3_6.last & l2_out_valid_3_6) &  (l2_out_data_3_7.last & l2_out_valid_3_7) &  !l3_almost_full_3_1;
assign l2_same_3_1 =  (l2_newdata_3_4) &  (l2_newdata_3_5) &  (l2_newdata_3_6) &  (l2_newdata_3_7) &  
                             (l2_out_data_3_4.data==l2_out_data_3_5.data) & (l2_out_data_3_4.data==l2_out_data_3_6.data) 
                             & (l2_out_data_3_4.data==l2_out_data_3_7.data)
                             & !l3_almost_full_3_1;
assign l2_newdata_3_4 = l2_out_valid_3_4 & (l2_out_data_3_4.data != l2_cache_3_4) & !l2_out_data_3_4.last;
assign l2_newdata_3_5 = l2_out_valid_3_5 & (l2_out_data_3_5.data != l2_cache_3_5) & !l2_out_data_3_5.last;
assign l2_newdata_3_6 = l2_out_valid_3_6 & (l2_out_data_3_6.data != l2_cache_3_6) & !l2_out_data_3_6.last;
assign l2_newdata_3_7 = l2_out_valid_3_7 & (l2_out_data_3_7.data != l2_cache_3_7) & !l2_out_data_3_7.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_3_1[0] = l2_newdata_3_4 & !l3_almost_full_3_1;
    l2_out_ready_3_4 = l2_grant_3_1[0];       
    l2_req_3_1[1] = l2_newdata_3_5 & !l3_almost_full_3_1;
    l2_out_ready_3_5 = l2_grant_3_1[1];       
    l2_req_3_1[2] = l2_newdata_3_6 & !l3_almost_full_3_1;
    l2_out_ready_3_6 = l2_grant_3_1[2];       
    l2_req_3_1[3] = l2_newdata_3_7 & !l3_almost_full_3_1;
    l2_out_ready_3_7 = l2_grant_3_1[3];       
    //sync case
    if(l2_all_last_3_1) begin
        l2_req_3_1 = 0;
        l2_out_ready_3_4 = 1;
        l2_out_ready_3_5 = 1;
        l2_out_ready_3_6 = 1;
        l2_out_ready_3_7 = 1;
    end else if(l2_same_3_1)begin
        l2_req_3_1[0] = 1;
        l2_req_3_1[3:1] = 0;
        l2_out_ready_3_5 = 1;
        l2_out_ready_3_6 = 1;
        l2_out_ready_3_7 = 1;
    end else begin
        if(l2_out_valid_3_4 & (l2_out_data_3_4.data == l2_cache_3_4) 
          & !l2_out_data_3_4.last)begin
            l2_out_ready_3_4 = 1;
        end
        if(l2_out_valid_3_5 & (l2_out_data_3_5.data == l2_cache_3_5) 
          & !l2_out_data_3_5.last)begin
            l2_out_ready_3_5 = 1;
        end
        if(l2_out_valid_3_6 & (l2_out_data_3_6.data == l2_cache_3_6) 
          & !l2_out_data_3_6.last)begin
            l2_out_ready_3_6 = 1;
        end
        if(l2_out_valid_3_7 & (l2_out_data_3_7.data == l2_cache_3_7) 
          & !l2_out_data_3_7.last)begin
            l2_out_ready_3_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_3_4 <= 0;
        l2_cache_3_5 <= 0;
        l2_cache_3_6 <= 0;
        l2_cache_3_7 <= 0;
    end else begin
        if(l2_all_last_3_1)begin
            l2_cache_3_4 <= 0;
            l2_cache_3_5 <= 0;
            l2_cache_3_6 <= 0;
            l2_cache_3_7 <= 0;
        end else begin
            if(l2_out_valid_3_4 & l2_out_ready_3_4)begin
                l2_cache_3_4 <= l2_out_data_3_4.data;
            end
            if(l2_out_valid_3_5 & l2_out_ready_3_5)begin
                l2_cache_3_5 <= l2_out_data_3_5.data;
            end
            if(l2_out_valid_3_6 & l2_out_ready_3_6)begin
                l2_cache_3_6 <= l2_out_data_3_6.data;
            end
            if(l2_out_valid_3_7 & l2_out_ready_3_7)begin
                l2_cache_3_7 <= l2_out_data_3_7.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_3_1 <= 0;
    end else begin
        //sync case
        if(l2_all_last_3_1) begin
            l3_in_valid_3_1 <= 1;
        //normal case
        end else begin
            l3_in_valid_3_1 <= |l2_grant_3_1;
        end
    end
    //sync case
    if(l2_all_last_3_1) begin
        l3_in_data_3_1.last <= 1;
        l3_in_data_3_1.data <= 0;
    //normal case
    end else begin
        case(l2_grant_3_1)
            4'b0001: l3_in_data_3_1 <= l2_out_data_3_4;
            4'b0010: l3_in_data_3_1 <= l2_out_data_3_5;
            4'b0100: l3_in_data_3_1 <= l2_out_data_3_6;
            4'b1000: l3_in_data_3_1 <= l2_out_data_3_7;
            default: l3_in_data_3_1 <= 0;
        endcase
    end   
end
assign l2_all_last_3_2 =  (l2_out_data_3_8.last & l2_out_valid_3_8) &  (l2_out_data_3_9.last & l2_out_valid_3_9) &  (l2_out_data_3_10.last & l2_out_valid_3_10) &  (l2_out_data_3_11.last & l2_out_valid_3_11) &  !l3_almost_full_3_2;
assign l2_same_3_2 =  (l2_newdata_3_8) &  (l2_newdata_3_9) &  (l2_newdata_3_10) &  (l2_newdata_3_11) &  
                             (l2_out_data_3_8.data==l2_out_data_3_9.data) & (l2_out_data_3_8.data==l2_out_data_3_10.data) 
                             & (l2_out_data_3_8.data==l2_out_data_3_11.data)
                             & !l3_almost_full_3_2;
assign l2_newdata_3_8 = l2_out_valid_3_8 & (l2_out_data_3_8.data != l2_cache_3_8) & !l2_out_data_3_8.last;
assign l2_newdata_3_9 = l2_out_valid_3_9 & (l2_out_data_3_9.data != l2_cache_3_9) & !l2_out_data_3_9.last;
assign l2_newdata_3_10 = l2_out_valid_3_10 & (l2_out_data_3_10.data != l2_cache_3_10) & !l2_out_data_3_10.last;
assign l2_newdata_3_11 = l2_out_valid_3_11 & (l2_out_data_3_11.data != l2_cache_3_11) & !l2_out_data_3_11.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_3_2[0] = l2_newdata_3_8 & !l3_almost_full_3_2;
    l2_out_ready_3_8 = l2_grant_3_2[0];       
    l2_req_3_2[1] = l2_newdata_3_9 & !l3_almost_full_3_2;
    l2_out_ready_3_9 = l2_grant_3_2[1];       
    l2_req_3_2[2] = l2_newdata_3_10 & !l3_almost_full_3_2;
    l2_out_ready_3_10 = l2_grant_3_2[2];       
    l2_req_3_2[3] = l2_newdata_3_11 & !l3_almost_full_3_2;
    l2_out_ready_3_11 = l2_grant_3_2[3];       
    //sync case
    if(l2_all_last_3_2) begin
        l2_req_3_2 = 0;
        l2_out_ready_3_8 = 1;
        l2_out_ready_3_9 = 1;
        l2_out_ready_3_10 = 1;
        l2_out_ready_3_11 = 1;
    end else if(l2_same_3_2)begin
        l2_req_3_2[0] = 1;
        l2_req_3_2[3:1] = 0;
        l2_out_ready_3_9 = 1;
        l2_out_ready_3_10 = 1;
        l2_out_ready_3_11 = 1;
    end else begin
        if(l2_out_valid_3_8 & (l2_out_data_3_8.data == l2_cache_3_8) 
          & !l2_out_data_3_8.last)begin
            l2_out_ready_3_8 = 1;
        end
        if(l2_out_valid_3_9 & (l2_out_data_3_9.data == l2_cache_3_9) 
          & !l2_out_data_3_9.last)begin
            l2_out_ready_3_9 = 1;
        end
        if(l2_out_valid_3_10 & (l2_out_data_3_10.data == l2_cache_3_10) 
          & !l2_out_data_3_10.last)begin
            l2_out_ready_3_10 = 1;
        end
        if(l2_out_valid_3_11 & (l2_out_data_3_11.data == l2_cache_3_11) 
          & !l2_out_data_3_11.last)begin
            l2_out_ready_3_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_3_8 <= 0;
        l2_cache_3_9 <= 0;
        l2_cache_3_10 <= 0;
        l2_cache_3_11 <= 0;
    end else begin
        if(l2_all_last_3_2)begin
            l2_cache_3_8 <= 0;
            l2_cache_3_9 <= 0;
            l2_cache_3_10 <= 0;
            l2_cache_3_11 <= 0;
        end else begin
            if(l2_out_valid_3_8 & l2_out_ready_3_8)begin
                l2_cache_3_8 <= l2_out_data_3_8.data;
            end
            if(l2_out_valid_3_9 & l2_out_ready_3_9)begin
                l2_cache_3_9 <= l2_out_data_3_9.data;
            end
            if(l2_out_valid_3_10 & l2_out_ready_3_10)begin
                l2_cache_3_10 <= l2_out_data_3_10.data;
            end
            if(l2_out_valid_3_11 & l2_out_ready_3_11)begin
                l2_cache_3_11 <= l2_out_data_3_11.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_3_2 <= 0;
    end else begin
        //sync case
        if(l2_all_last_3_2) begin
            l3_in_valid_3_2 <= 1;
        //normal case
        end else begin
            l3_in_valid_3_2 <= |l2_grant_3_2;
        end
    end
    //sync case
    if(l2_all_last_3_2) begin
        l3_in_data_3_2.last <= 1;
        l3_in_data_3_2.data <= 0;
    //normal case
    end else begin
        case(l2_grant_3_2)
            4'b0001: l3_in_data_3_2 <= l2_out_data_3_8;
            4'b0010: l3_in_data_3_2 <= l2_out_data_3_9;
            4'b0100: l3_in_data_3_2 <= l2_out_data_3_10;
            4'b1000: l3_in_data_3_2 <= l2_out_data_3_11;
            default: l3_in_data_3_2 <= 0;
        endcase
    end   
end
assign l2_all_last_3_3 =  (l2_out_data_3_12.last & l2_out_valid_3_12) &  (l2_out_data_3_13.last & l2_out_valid_3_13) &  (l2_out_data_3_14.last & l2_out_valid_3_14) &  (l2_out_data_3_15.last & l2_out_valid_3_15) &  !l3_almost_full_3_3;
assign l2_same_3_3 =  (l2_newdata_3_12) &  (l2_newdata_3_13) &  (l2_newdata_3_14) &  (l2_newdata_3_15) &  
                             (l2_out_data_3_12.data==l2_out_data_3_13.data) & (l2_out_data_3_12.data==l2_out_data_3_14.data) 
                             & (l2_out_data_3_12.data==l2_out_data_3_15.data)
                             & !l3_almost_full_3_3;
assign l2_newdata_3_12 = l2_out_valid_3_12 & (l2_out_data_3_12.data != l2_cache_3_12) & !l2_out_data_3_12.last;
assign l2_newdata_3_13 = l2_out_valid_3_13 & (l2_out_data_3_13.data != l2_cache_3_13) & !l2_out_data_3_13.last;
assign l2_newdata_3_14 = l2_out_valid_3_14 & (l2_out_data_3_14.data != l2_cache_3_14) & !l2_out_data_3_14.last;
assign l2_newdata_3_15 = l2_out_valid_3_15 & (l2_out_data_3_15.data != l2_cache_3_15) & !l2_out_data_3_15.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_3_3[0] = l2_newdata_3_12 & !l3_almost_full_3_3;
    l2_out_ready_3_12 = l2_grant_3_3[0];       
    l2_req_3_3[1] = l2_newdata_3_13 & !l3_almost_full_3_3;
    l2_out_ready_3_13 = l2_grant_3_3[1];       
    l2_req_3_3[2] = l2_newdata_3_14 & !l3_almost_full_3_3;
    l2_out_ready_3_14 = l2_grant_3_3[2];       
    l2_req_3_3[3] = l2_newdata_3_15 & !l3_almost_full_3_3;
    l2_out_ready_3_15 = l2_grant_3_3[3];       
    //sync case
    if(l2_all_last_3_3) begin
        l2_req_3_3 = 0;
        l2_out_ready_3_12 = 1;
        l2_out_ready_3_13 = 1;
        l2_out_ready_3_14 = 1;
        l2_out_ready_3_15 = 1;
    end else if(l2_same_3_3)begin
        l2_req_3_3[0] = 1;
        l2_req_3_3[3:1] = 0;
        l2_out_ready_3_13 = 1;
        l2_out_ready_3_14 = 1;
        l2_out_ready_3_15 = 1;
    end else begin
        if(l2_out_valid_3_12 & (l2_out_data_3_12.data == l2_cache_3_12) 
          & !l2_out_data_3_12.last)begin
            l2_out_ready_3_12 = 1;
        end
        if(l2_out_valid_3_13 & (l2_out_data_3_13.data == l2_cache_3_13) 
          & !l2_out_data_3_13.last)begin
            l2_out_ready_3_13 = 1;
        end
        if(l2_out_valid_3_14 & (l2_out_data_3_14.data == l2_cache_3_14) 
          & !l2_out_data_3_14.last)begin
            l2_out_ready_3_14 = 1;
        end
        if(l2_out_valid_3_15 & (l2_out_data_3_15.data == l2_cache_3_15) 
          & !l2_out_data_3_15.last)begin
            l2_out_ready_3_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_3_12 <= 0;
        l2_cache_3_13 <= 0;
        l2_cache_3_14 <= 0;
        l2_cache_3_15 <= 0;
    end else begin
        if(l2_all_last_3_3)begin
            l2_cache_3_12 <= 0;
            l2_cache_3_13 <= 0;
            l2_cache_3_14 <= 0;
            l2_cache_3_15 <= 0;
        end else begin
            if(l2_out_valid_3_12 & l2_out_ready_3_12)begin
                l2_cache_3_12 <= l2_out_data_3_12.data;
            end
            if(l2_out_valid_3_13 & l2_out_ready_3_13)begin
                l2_cache_3_13 <= l2_out_data_3_13.data;
            end
            if(l2_out_valid_3_14 & l2_out_ready_3_14)begin
                l2_cache_3_14 <= l2_out_data_3_14.data;
            end
            if(l2_out_valid_3_15 & l2_out_ready_3_15)begin
                l2_cache_3_15 <= l2_out_data_3_15.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_3_3 <= 0;
    end else begin
        //sync case
        if(l2_all_last_3_3) begin
            l3_in_valid_3_3 <= 1;
        //normal case
        end else begin
            l3_in_valid_3_3 <= |l2_grant_3_3;
        end
    end
    //sync case
    if(l2_all_last_3_3) begin
        l3_in_data_3_3.last <= 1;
        l3_in_data_3_3.data <= 0;
    //normal case
    end else begin
        case(l2_grant_3_3)
            4'b0001: l3_in_data_3_3 <= l2_out_data_3_12;
            4'b0010: l3_in_data_3_3 <= l2_out_data_3_13;
            4'b0100: l3_in_data_3_3 <= l2_out_data_3_14;
            4'b1000: l3_in_data_3_3 <= l2_out_data_3_15;
            default: l3_in_data_3_3 <= 0;
        endcase
    end   
end
assign l2_all_last_4_0 =  (l2_out_data_4_0.last & l2_out_valid_4_0) &  (l2_out_data_4_1.last & l2_out_valid_4_1) &  (l2_out_data_4_2.last & l2_out_valid_4_2) &  (l2_out_data_4_3.last & l2_out_valid_4_3) &  !l3_almost_full_4_0;
assign l2_same_4_0 =  (l2_newdata_4_0) &  (l2_newdata_4_1) &  (l2_newdata_4_2) &  (l2_newdata_4_3) &  
                             (l2_out_data_4_0.data==l2_out_data_4_1.data) & (l2_out_data_4_0.data==l2_out_data_4_2.data) 
                             & (l2_out_data_4_0.data==l2_out_data_4_3.data)
                             & !l3_almost_full_4_0;
assign l2_newdata_4_0 = l2_out_valid_4_0 & (l2_out_data_4_0.data != l2_cache_4_0) & !l2_out_data_4_0.last;
assign l2_newdata_4_1 = l2_out_valid_4_1 & (l2_out_data_4_1.data != l2_cache_4_1) & !l2_out_data_4_1.last;
assign l2_newdata_4_2 = l2_out_valid_4_2 & (l2_out_data_4_2.data != l2_cache_4_2) & !l2_out_data_4_2.last;
assign l2_newdata_4_3 = l2_out_valid_4_3 & (l2_out_data_4_3.data != l2_cache_4_3) & !l2_out_data_4_3.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_4_0[0] = l2_newdata_4_0 & !l3_almost_full_4_0;
    l2_out_ready_4_0 = l2_grant_4_0[0];       
    l2_req_4_0[1] = l2_newdata_4_1 & !l3_almost_full_4_0;
    l2_out_ready_4_1 = l2_grant_4_0[1];       
    l2_req_4_0[2] = l2_newdata_4_2 & !l3_almost_full_4_0;
    l2_out_ready_4_2 = l2_grant_4_0[2];       
    l2_req_4_0[3] = l2_newdata_4_3 & !l3_almost_full_4_0;
    l2_out_ready_4_3 = l2_grant_4_0[3];       
    //sync case
    if(l2_all_last_4_0) begin
        l2_req_4_0 = 0;
        l2_out_ready_4_0 = 1;
        l2_out_ready_4_1 = 1;
        l2_out_ready_4_2 = 1;
        l2_out_ready_4_3 = 1;
    end else if(l2_same_4_0)begin
        l2_req_4_0[0] = 1;
        l2_req_4_0[3:1] = 0;
        l2_out_ready_4_1 = 1;
        l2_out_ready_4_2 = 1;
        l2_out_ready_4_3 = 1;
    end else begin
        if(l2_out_valid_4_0 & (l2_out_data_4_0.data == l2_cache_4_0) 
          & !l2_out_data_4_0.last)begin
            l2_out_ready_4_0 = 1;
        end
        if(l2_out_valid_4_1 & (l2_out_data_4_1.data == l2_cache_4_1) 
          & !l2_out_data_4_1.last)begin
            l2_out_ready_4_1 = 1;
        end
        if(l2_out_valid_4_2 & (l2_out_data_4_2.data == l2_cache_4_2) 
          & !l2_out_data_4_2.last)begin
            l2_out_ready_4_2 = 1;
        end
        if(l2_out_valid_4_3 & (l2_out_data_4_3.data == l2_cache_4_3) 
          & !l2_out_data_4_3.last)begin
            l2_out_ready_4_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_4_0 <= 0;
        l2_cache_4_1 <= 0;
        l2_cache_4_2 <= 0;
        l2_cache_4_3 <= 0;
    end else begin
        if(l2_all_last_4_0)begin
            l2_cache_4_0 <= 0;
            l2_cache_4_1 <= 0;
            l2_cache_4_2 <= 0;
            l2_cache_4_3 <= 0;
        end else begin
            if(l2_out_valid_4_0 & l2_out_ready_4_0)begin
                l2_cache_4_0 <= l2_out_data_4_0.data;
            end
            if(l2_out_valid_4_1 & l2_out_ready_4_1)begin
                l2_cache_4_1 <= l2_out_data_4_1.data;
            end
            if(l2_out_valid_4_2 & l2_out_ready_4_2)begin
                l2_cache_4_2 <= l2_out_data_4_2.data;
            end
            if(l2_out_valid_4_3 & l2_out_ready_4_3)begin
                l2_cache_4_3 <= l2_out_data_4_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_4_0 <= 0;
    end else begin
        //sync case
        if(l2_all_last_4_0) begin
            l3_in_valid_4_0 <= 1;
        //normal case
        end else begin
            l3_in_valid_4_0 <= |l2_grant_4_0;
        end
    end
    //sync case
    if(l2_all_last_4_0) begin
        l3_in_data_4_0.last <= 1;
        l3_in_data_4_0.data <= 0;
    //normal case
    end else begin
        case(l2_grant_4_0)
            4'b0001: l3_in_data_4_0 <= l2_out_data_4_0;
            4'b0010: l3_in_data_4_0 <= l2_out_data_4_1;
            4'b0100: l3_in_data_4_0 <= l2_out_data_4_2;
            4'b1000: l3_in_data_4_0 <= l2_out_data_4_3;
            default: l3_in_data_4_0 <= 0;
        endcase
    end   
end
assign l2_all_last_4_1 =  (l2_out_data_4_4.last & l2_out_valid_4_4) &  (l2_out_data_4_5.last & l2_out_valid_4_5) &  (l2_out_data_4_6.last & l2_out_valid_4_6) &  (l2_out_data_4_7.last & l2_out_valid_4_7) &  !l3_almost_full_4_1;
assign l2_same_4_1 =  (l2_newdata_4_4) &  (l2_newdata_4_5) &  (l2_newdata_4_6) &  (l2_newdata_4_7) &  
                             (l2_out_data_4_4.data==l2_out_data_4_5.data) & (l2_out_data_4_4.data==l2_out_data_4_6.data) 
                             & (l2_out_data_4_4.data==l2_out_data_4_7.data)
                             & !l3_almost_full_4_1;
assign l2_newdata_4_4 = l2_out_valid_4_4 & (l2_out_data_4_4.data != l2_cache_4_4) & !l2_out_data_4_4.last;
assign l2_newdata_4_5 = l2_out_valid_4_5 & (l2_out_data_4_5.data != l2_cache_4_5) & !l2_out_data_4_5.last;
assign l2_newdata_4_6 = l2_out_valid_4_6 & (l2_out_data_4_6.data != l2_cache_4_6) & !l2_out_data_4_6.last;
assign l2_newdata_4_7 = l2_out_valid_4_7 & (l2_out_data_4_7.data != l2_cache_4_7) & !l2_out_data_4_7.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_4_1[0] = l2_newdata_4_4 & !l3_almost_full_4_1;
    l2_out_ready_4_4 = l2_grant_4_1[0];       
    l2_req_4_1[1] = l2_newdata_4_5 & !l3_almost_full_4_1;
    l2_out_ready_4_5 = l2_grant_4_1[1];       
    l2_req_4_1[2] = l2_newdata_4_6 & !l3_almost_full_4_1;
    l2_out_ready_4_6 = l2_grant_4_1[2];       
    l2_req_4_1[3] = l2_newdata_4_7 & !l3_almost_full_4_1;
    l2_out_ready_4_7 = l2_grant_4_1[3];       
    //sync case
    if(l2_all_last_4_1) begin
        l2_req_4_1 = 0;
        l2_out_ready_4_4 = 1;
        l2_out_ready_4_5 = 1;
        l2_out_ready_4_6 = 1;
        l2_out_ready_4_7 = 1;
    end else if(l2_same_4_1)begin
        l2_req_4_1[0] = 1;
        l2_req_4_1[3:1] = 0;
        l2_out_ready_4_5 = 1;
        l2_out_ready_4_6 = 1;
        l2_out_ready_4_7 = 1;
    end else begin
        if(l2_out_valid_4_4 & (l2_out_data_4_4.data == l2_cache_4_4) 
          & !l2_out_data_4_4.last)begin
            l2_out_ready_4_4 = 1;
        end
        if(l2_out_valid_4_5 & (l2_out_data_4_5.data == l2_cache_4_5) 
          & !l2_out_data_4_5.last)begin
            l2_out_ready_4_5 = 1;
        end
        if(l2_out_valid_4_6 & (l2_out_data_4_6.data == l2_cache_4_6) 
          & !l2_out_data_4_6.last)begin
            l2_out_ready_4_6 = 1;
        end
        if(l2_out_valid_4_7 & (l2_out_data_4_7.data == l2_cache_4_7) 
          & !l2_out_data_4_7.last)begin
            l2_out_ready_4_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_4_4 <= 0;
        l2_cache_4_5 <= 0;
        l2_cache_4_6 <= 0;
        l2_cache_4_7 <= 0;
    end else begin
        if(l2_all_last_4_1)begin
            l2_cache_4_4 <= 0;
            l2_cache_4_5 <= 0;
            l2_cache_4_6 <= 0;
            l2_cache_4_7 <= 0;
        end else begin
            if(l2_out_valid_4_4 & l2_out_ready_4_4)begin
                l2_cache_4_4 <= l2_out_data_4_4.data;
            end
            if(l2_out_valid_4_5 & l2_out_ready_4_5)begin
                l2_cache_4_5 <= l2_out_data_4_5.data;
            end
            if(l2_out_valid_4_6 & l2_out_ready_4_6)begin
                l2_cache_4_6 <= l2_out_data_4_6.data;
            end
            if(l2_out_valid_4_7 & l2_out_ready_4_7)begin
                l2_cache_4_7 <= l2_out_data_4_7.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_4_1 <= 0;
    end else begin
        //sync case
        if(l2_all_last_4_1) begin
            l3_in_valid_4_1 <= 1;
        //normal case
        end else begin
            l3_in_valid_4_1 <= |l2_grant_4_1;
        end
    end
    //sync case
    if(l2_all_last_4_1) begin
        l3_in_data_4_1.last <= 1;
        l3_in_data_4_1.data <= 0;
    //normal case
    end else begin
        case(l2_grant_4_1)
            4'b0001: l3_in_data_4_1 <= l2_out_data_4_4;
            4'b0010: l3_in_data_4_1 <= l2_out_data_4_5;
            4'b0100: l3_in_data_4_1 <= l2_out_data_4_6;
            4'b1000: l3_in_data_4_1 <= l2_out_data_4_7;
            default: l3_in_data_4_1 <= 0;
        endcase
    end   
end
assign l2_all_last_4_2 =  (l2_out_data_4_8.last & l2_out_valid_4_8) &  (l2_out_data_4_9.last & l2_out_valid_4_9) &  (l2_out_data_4_10.last & l2_out_valid_4_10) &  (l2_out_data_4_11.last & l2_out_valid_4_11) &  !l3_almost_full_4_2;
assign l2_same_4_2 =  (l2_newdata_4_8) &  (l2_newdata_4_9) &  (l2_newdata_4_10) &  (l2_newdata_4_11) &  
                             (l2_out_data_4_8.data==l2_out_data_4_9.data) & (l2_out_data_4_8.data==l2_out_data_4_10.data) 
                             & (l2_out_data_4_8.data==l2_out_data_4_11.data)
                             & !l3_almost_full_4_2;
assign l2_newdata_4_8 = l2_out_valid_4_8 & (l2_out_data_4_8.data != l2_cache_4_8) & !l2_out_data_4_8.last;
assign l2_newdata_4_9 = l2_out_valid_4_9 & (l2_out_data_4_9.data != l2_cache_4_9) & !l2_out_data_4_9.last;
assign l2_newdata_4_10 = l2_out_valid_4_10 & (l2_out_data_4_10.data != l2_cache_4_10) & !l2_out_data_4_10.last;
assign l2_newdata_4_11 = l2_out_valid_4_11 & (l2_out_data_4_11.data != l2_cache_4_11) & !l2_out_data_4_11.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_4_2[0] = l2_newdata_4_8 & !l3_almost_full_4_2;
    l2_out_ready_4_8 = l2_grant_4_2[0];       
    l2_req_4_2[1] = l2_newdata_4_9 & !l3_almost_full_4_2;
    l2_out_ready_4_9 = l2_grant_4_2[1];       
    l2_req_4_2[2] = l2_newdata_4_10 & !l3_almost_full_4_2;
    l2_out_ready_4_10 = l2_grant_4_2[2];       
    l2_req_4_2[3] = l2_newdata_4_11 & !l3_almost_full_4_2;
    l2_out_ready_4_11 = l2_grant_4_2[3];       
    //sync case
    if(l2_all_last_4_2) begin
        l2_req_4_2 = 0;
        l2_out_ready_4_8 = 1;
        l2_out_ready_4_9 = 1;
        l2_out_ready_4_10 = 1;
        l2_out_ready_4_11 = 1;
    end else if(l2_same_4_2)begin
        l2_req_4_2[0] = 1;
        l2_req_4_2[3:1] = 0;
        l2_out_ready_4_9 = 1;
        l2_out_ready_4_10 = 1;
        l2_out_ready_4_11 = 1;
    end else begin
        if(l2_out_valid_4_8 & (l2_out_data_4_8.data == l2_cache_4_8) 
          & !l2_out_data_4_8.last)begin
            l2_out_ready_4_8 = 1;
        end
        if(l2_out_valid_4_9 & (l2_out_data_4_9.data == l2_cache_4_9) 
          & !l2_out_data_4_9.last)begin
            l2_out_ready_4_9 = 1;
        end
        if(l2_out_valid_4_10 & (l2_out_data_4_10.data == l2_cache_4_10) 
          & !l2_out_data_4_10.last)begin
            l2_out_ready_4_10 = 1;
        end
        if(l2_out_valid_4_11 & (l2_out_data_4_11.data == l2_cache_4_11) 
          & !l2_out_data_4_11.last)begin
            l2_out_ready_4_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_4_8 <= 0;
        l2_cache_4_9 <= 0;
        l2_cache_4_10 <= 0;
        l2_cache_4_11 <= 0;
    end else begin
        if(l2_all_last_4_2)begin
            l2_cache_4_8 <= 0;
            l2_cache_4_9 <= 0;
            l2_cache_4_10 <= 0;
            l2_cache_4_11 <= 0;
        end else begin
            if(l2_out_valid_4_8 & l2_out_ready_4_8)begin
                l2_cache_4_8 <= l2_out_data_4_8.data;
            end
            if(l2_out_valid_4_9 & l2_out_ready_4_9)begin
                l2_cache_4_9 <= l2_out_data_4_9.data;
            end
            if(l2_out_valid_4_10 & l2_out_ready_4_10)begin
                l2_cache_4_10 <= l2_out_data_4_10.data;
            end
            if(l2_out_valid_4_11 & l2_out_ready_4_11)begin
                l2_cache_4_11 <= l2_out_data_4_11.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_4_2 <= 0;
    end else begin
        //sync case
        if(l2_all_last_4_2) begin
            l3_in_valid_4_2 <= 1;
        //normal case
        end else begin
            l3_in_valid_4_2 <= |l2_grant_4_2;
        end
    end
    //sync case
    if(l2_all_last_4_2) begin
        l3_in_data_4_2.last <= 1;
        l3_in_data_4_2.data <= 0;
    //normal case
    end else begin
        case(l2_grant_4_2)
            4'b0001: l3_in_data_4_2 <= l2_out_data_4_8;
            4'b0010: l3_in_data_4_2 <= l2_out_data_4_9;
            4'b0100: l3_in_data_4_2 <= l2_out_data_4_10;
            4'b1000: l3_in_data_4_2 <= l2_out_data_4_11;
            default: l3_in_data_4_2 <= 0;
        endcase
    end   
end
assign l2_all_last_4_3 =  (l2_out_data_4_12.last & l2_out_valid_4_12) &  (l2_out_data_4_13.last & l2_out_valid_4_13) &  (l2_out_data_4_14.last & l2_out_valid_4_14) &  (l2_out_data_4_15.last & l2_out_valid_4_15) &  !l3_almost_full_4_3;
assign l2_same_4_3 =  (l2_newdata_4_12) &  (l2_newdata_4_13) &  (l2_newdata_4_14) &  (l2_newdata_4_15) &  
                             (l2_out_data_4_12.data==l2_out_data_4_13.data) & (l2_out_data_4_12.data==l2_out_data_4_14.data) 
                             & (l2_out_data_4_12.data==l2_out_data_4_15.data)
                             & !l3_almost_full_4_3;
assign l2_newdata_4_12 = l2_out_valid_4_12 & (l2_out_data_4_12.data != l2_cache_4_12) & !l2_out_data_4_12.last;
assign l2_newdata_4_13 = l2_out_valid_4_13 & (l2_out_data_4_13.data != l2_cache_4_13) & !l2_out_data_4_13.last;
assign l2_newdata_4_14 = l2_out_valid_4_14 & (l2_out_data_4_14.data != l2_cache_4_14) & !l2_out_data_4_14.last;
assign l2_newdata_4_15 = l2_out_valid_4_15 & (l2_out_data_4_15.data != l2_cache_4_15) & !l2_out_data_4_15.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_4_3[0] = l2_newdata_4_12 & !l3_almost_full_4_3;
    l2_out_ready_4_12 = l2_grant_4_3[0];       
    l2_req_4_3[1] = l2_newdata_4_13 & !l3_almost_full_4_3;
    l2_out_ready_4_13 = l2_grant_4_3[1];       
    l2_req_4_3[2] = l2_newdata_4_14 & !l3_almost_full_4_3;
    l2_out_ready_4_14 = l2_grant_4_3[2];       
    l2_req_4_3[3] = l2_newdata_4_15 & !l3_almost_full_4_3;
    l2_out_ready_4_15 = l2_grant_4_3[3];       
    //sync case
    if(l2_all_last_4_3) begin
        l2_req_4_3 = 0;
        l2_out_ready_4_12 = 1;
        l2_out_ready_4_13 = 1;
        l2_out_ready_4_14 = 1;
        l2_out_ready_4_15 = 1;
    end else if(l2_same_4_3)begin
        l2_req_4_3[0] = 1;
        l2_req_4_3[3:1] = 0;
        l2_out_ready_4_13 = 1;
        l2_out_ready_4_14 = 1;
        l2_out_ready_4_15 = 1;
    end else begin
        if(l2_out_valid_4_12 & (l2_out_data_4_12.data == l2_cache_4_12) 
          & !l2_out_data_4_12.last)begin
            l2_out_ready_4_12 = 1;
        end
        if(l2_out_valid_4_13 & (l2_out_data_4_13.data == l2_cache_4_13) 
          & !l2_out_data_4_13.last)begin
            l2_out_ready_4_13 = 1;
        end
        if(l2_out_valid_4_14 & (l2_out_data_4_14.data == l2_cache_4_14) 
          & !l2_out_data_4_14.last)begin
            l2_out_ready_4_14 = 1;
        end
        if(l2_out_valid_4_15 & (l2_out_data_4_15.data == l2_cache_4_15) 
          & !l2_out_data_4_15.last)begin
            l2_out_ready_4_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_4_12 <= 0;
        l2_cache_4_13 <= 0;
        l2_cache_4_14 <= 0;
        l2_cache_4_15 <= 0;
    end else begin
        if(l2_all_last_4_3)begin
            l2_cache_4_12 <= 0;
            l2_cache_4_13 <= 0;
            l2_cache_4_14 <= 0;
            l2_cache_4_15 <= 0;
        end else begin
            if(l2_out_valid_4_12 & l2_out_ready_4_12)begin
                l2_cache_4_12 <= l2_out_data_4_12.data;
            end
            if(l2_out_valid_4_13 & l2_out_ready_4_13)begin
                l2_cache_4_13 <= l2_out_data_4_13.data;
            end
            if(l2_out_valid_4_14 & l2_out_ready_4_14)begin
                l2_cache_4_14 <= l2_out_data_4_14.data;
            end
            if(l2_out_valid_4_15 & l2_out_ready_4_15)begin
                l2_cache_4_15 <= l2_out_data_4_15.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_4_3 <= 0;
    end else begin
        //sync case
        if(l2_all_last_4_3) begin
            l3_in_valid_4_3 <= 1;
        //normal case
        end else begin
            l3_in_valid_4_3 <= |l2_grant_4_3;
        end
    end
    //sync case
    if(l2_all_last_4_3) begin
        l3_in_data_4_3.last <= 1;
        l3_in_data_4_3.data <= 0;
    //normal case
    end else begin
        case(l2_grant_4_3)
            4'b0001: l3_in_data_4_3 <= l2_out_data_4_12;
            4'b0010: l3_in_data_4_3 <= l2_out_data_4_13;
            4'b0100: l3_in_data_4_3 <= l2_out_data_4_14;
            4'b1000: l3_in_data_4_3 <= l2_out_data_4_15;
            default: l3_in_data_4_3 <= 0;
        endcase
    end   
end
assign l2_all_last_5_0 =  (l2_out_data_5_0.last & l2_out_valid_5_0) &  (l2_out_data_5_1.last & l2_out_valid_5_1) &  (l2_out_data_5_2.last & l2_out_valid_5_2) &  (l2_out_data_5_3.last & l2_out_valid_5_3) &  !l3_almost_full_5_0;
assign l2_same_5_0 =  (l2_newdata_5_0) &  (l2_newdata_5_1) &  (l2_newdata_5_2) &  (l2_newdata_5_3) &  
                             (l2_out_data_5_0.data==l2_out_data_5_1.data) & (l2_out_data_5_0.data==l2_out_data_5_2.data) 
                             & (l2_out_data_5_0.data==l2_out_data_5_3.data)
                             & !l3_almost_full_5_0;
assign l2_newdata_5_0 = l2_out_valid_5_0 & (l2_out_data_5_0.data != l2_cache_5_0) & !l2_out_data_5_0.last;
assign l2_newdata_5_1 = l2_out_valid_5_1 & (l2_out_data_5_1.data != l2_cache_5_1) & !l2_out_data_5_1.last;
assign l2_newdata_5_2 = l2_out_valid_5_2 & (l2_out_data_5_2.data != l2_cache_5_2) & !l2_out_data_5_2.last;
assign l2_newdata_5_3 = l2_out_valid_5_3 & (l2_out_data_5_3.data != l2_cache_5_3) & !l2_out_data_5_3.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_5_0[0] = l2_newdata_5_0 & !l3_almost_full_5_0;
    l2_out_ready_5_0 = l2_grant_5_0[0];       
    l2_req_5_0[1] = l2_newdata_5_1 & !l3_almost_full_5_0;
    l2_out_ready_5_1 = l2_grant_5_0[1];       
    l2_req_5_0[2] = l2_newdata_5_2 & !l3_almost_full_5_0;
    l2_out_ready_5_2 = l2_grant_5_0[2];       
    l2_req_5_0[3] = l2_newdata_5_3 & !l3_almost_full_5_0;
    l2_out_ready_5_3 = l2_grant_5_0[3];       
    //sync case
    if(l2_all_last_5_0) begin
        l2_req_5_0 = 0;
        l2_out_ready_5_0 = 1;
        l2_out_ready_5_1 = 1;
        l2_out_ready_5_2 = 1;
        l2_out_ready_5_3 = 1;
    end else if(l2_same_5_0)begin
        l2_req_5_0[0] = 1;
        l2_req_5_0[3:1] = 0;
        l2_out_ready_5_1 = 1;
        l2_out_ready_5_2 = 1;
        l2_out_ready_5_3 = 1;
    end else begin
        if(l2_out_valid_5_0 & (l2_out_data_5_0.data == l2_cache_5_0) 
          & !l2_out_data_5_0.last)begin
            l2_out_ready_5_0 = 1;
        end
        if(l2_out_valid_5_1 & (l2_out_data_5_1.data == l2_cache_5_1) 
          & !l2_out_data_5_1.last)begin
            l2_out_ready_5_1 = 1;
        end
        if(l2_out_valid_5_2 & (l2_out_data_5_2.data == l2_cache_5_2) 
          & !l2_out_data_5_2.last)begin
            l2_out_ready_5_2 = 1;
        end
        if(l2_out_valid_5_3 & (l2_out_data_5_3.data == l2_cache_5_3) 
          & !l2_out_data_5_3.last)begin
            l2_out_ready_5_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_5_0 <= 0;
        l2_cache_5_1 <= 0;
        l2_cache_5_2 <= 0;
        l2_cache_5_3 <= 0;
    end else begin
        if(l2_all_last_5_0)begin
            l2_cache_5_0 <= 0;
            l2_cache_5_1 <= 0;
            l2_cache_5_2 <= 0;
            l2_cache_5_3 <= 0;
        end else begin
            if(l2_out_valid_5_0 & l2_out_ready_5_0)begin
                l2_cache_5_0 <= l2_out_data_5_0.data;
            end
            if(l2_out_valid_5_1 & l2_out_ready_5_1)begin
                l2_cache_5_1 <= l2_out_data_5_1.data;
            end
            if(l2_out_valid_5_2 & l2_out_ready_5_2)begin
                l2_cache_5_2 <= l2_out_data_5_2.data;
            end
            if(l2_out_valid_5_3 & l2_out_ready_5_3)begin
                l2_cache_5_3 <= l2_out_data_5_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_5_0 <= 0;
    end else begin
        //sync case
        if(l2_all_last_5_0) begin
            l3_in_valid_5_0 <= 1;
        //normal case
        end else begin
            l3_in_valid_5_0 <= |l2_grant_5_0;
        end
    end
    //sync case
    if(l2_all_last_5_0) begin
        l3_in_data_5_0.last <= 1;
        l3_in_data_5_0.data <= 0;
    //normal case
    end else begin
        case(l2_grant_5_0)
            4'b0001: l3_in_data_5_0 <= l2_out_data_5_0;
            4'b0010: l3_in_data_5_0 <= l2_out_data_5_1;
            4'b0100: l3_in_data_5_0 <= l2_out_data_5_2;
            4'b1000: l3_in_data_5_0 <= l2_out_data_5_3;
            default: l3_in_data_5_0 <= 0;
        endcase
    end   
end
assign l2_all_last_5_1 =  (l2_out_data_5_4.last & l2_out_valid_5_4) &  (l2_out_data_5_5.last & l2_out_valid_5_5) &  (l2_out_data_5_6.last & l2_out_valid_5_6) &  (l2_out_data_5_7.last & l2_out_valid_5_7) &  !l3_almost_full_5_1;
assign l2_same_5_1 =  (l2_newdata_5_4) &  (l2_newdata_5_5) &  (l2_newdata_5_6) &  (l2_newdata_5_7) &  
                             (l2_out_data_5_4.data==l2_out_data_5_5.data) & (l2_out_data_5_4.data==l2_out_data_5_6.data) 
                             & (l2_out_data_5_4.data==l2_out_data_5_7.data)
                             & !l3_almost_full_5_1;
assign l2_newdata_5_4 = l2_out_valid_5_4 & (l2_out_data_5_4.data != l2_cache_5_4) & !l2_out_data_5_4.last;
assign l2_newdata_5_5 = l2_out_valid_5_5 & (l2_out_data_5_5.data != l2_cache_5_5) & !l2_out_data_5_5.last;
assign l2_newdata_5_6 = l2_out_valid_5_6 & (l2_out_data_5_6.data != l2_cache_5_6) & !l2_out_data_5_6.last;
assign l2_newdata_5_7 = l2_out_valid_5_7 & (l2_out_data_5_7.data != l2_cache_5_7) & !l2_out_data_5_7.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_5_1[0] = l2_newdata_5_4 & !l3_almost_full_5_1;
    l2_out_ready_5_4 = l2_grant_5_1[0];       
    l2_req_5_1[1] = l2_newdata_5_5 & !l3_almost_full_5_1;
    l2_out_ready_5_5 = l2_grant_5_1[1];       
    l2_req_5_1[2] = l2_newdata_5_6 & !l3_almost_full_5_1;
    l2_out_ready_5_6 = l2_grant_5_1[2];       
    l2_req_5_1[3] = l2_newdata_5_7 & !l3_almost_full_5_1;
    l2_out_ready_5_7 = l2_grant_5_1[3];       
    //sync case
    if(l2_all_last_5_1) begin
        l2_req_5_1 = 0;
        l2_out_ready_5_4 = 1;
        l2_out_ready_5_5 = 1;
        l2_out_ready_5_6 = 1;
        l2_out_ready_5_7 = 1;
    end else if(l2_same_5_1)begin
        l2_req_5_1[0] = 1;
        l2_req_5_1[3:1] = 0;
        l2_out_ready_5_5 = 1;
        l2_out_ready_5_6 = 1;
        l2_out_ready_5_7 = 1;
    end else begin
        if(l2_out_valid_5_4 & (l2_out_data_5_4.data == l2_cache_5_4) 
          & !l2_out_data_5_4.last)begin
            l2_out_ready_5_4 = 1;
        end
        if(l2_out_valid_5_5 & (l2_out_data_5_5.data == l2_cache_5_5) 
          & !l2_out_data_5_5.last)begin
            l2_out_ready_5_5 = 1;
        end
        if(l2_out_valid_5_6 & (l2_out_data_5_6.data == l2_cache_5_6) 
          & !l2_out_data_5_6.last)begin
            l2_out_ready_5_6 = 1;
        end
        if(l2_out_valid_5_7 & (l2_out_data_5_7.data == l2_cache_5_7) 
          & !l2_out_data_5_7.last)begin
            l2_out_ready_5_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_5_4 <= 0;
        l2_cache_5_5 <= 0;
        l2_cache_5_6 <= 0;
        l2_cache_5_7 <= 0;
    end else begin
        if(l2_all_last_5_1)begin
            l2_cache_5_4 <= 0;
            l2_cache_5_5 <= 0;
            l2_cache_5_6 <= 0;
            l2_cache_5_7 <= 0;
        end else begin
            if(l2_out_valid_5_4 & l2_out_ready_5_4)begin
                l2_cache_5_4 <= l2_out_data_5_4.data;
            end
            if(l2_out_valid_5_5 & l2_out_ready_5_5)begin
                l2_cache_5_5 <= l2_out_data_5_5.data;
            end
            if(l2_out_valid_5_6 & l2_out_ready_5_6)begin
                l2_cache_5_6 <= l2_out_data_5_6.data;
            end
            if(l2_out_valid_5_7 & l2_out_ready_5_7)begin
                l2_cache_5_7 <= l2_out_data_5_7.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_5_1 <= 0;
    end else begin
        //sync case
        if(l2_all_last_5_1) begin
            l3_in_valid_5_1 <= 1;
        //normal case
        end else begin
            l3_in_valid_5_1 <= |l2_grant_5_1;
        end
    end
    //sync case
    if(l2_all_last_5_1) begin
        l3_in_data_5_1.last <= 1;
        l3_in_data_5_1.data <= 0;
    //normal case
    end else begin
        case(l2_grant_5_1)
            4'b0001: l3_in_data_5_1 <= l2_out_data_5_4;
            4'b0010: l3_in_data_5_1 <= l2_out_data_5_5;
            4'b0100: l3_in_data_5_1 <= l2_out_data_5_6;
            4'b1000: l3_in_data_5_1 <= l2_out_data_5_7;
            default: l3_in_data_5_1 <= 0;
        endcase
    end   
end
assign l2_all_last_5_2 =  (l2_out_data_5_8.last & l2_out_valid_5_8) &  (l2_out_data_5_9.last & l2_out_valid_5_9) &  (l2_out_data_5_10.last & l2_out_valid_5_10) &  (l2_out_data_5_11.last & l2_out_valid_5_11) &  !l3_almost_full_5_2;
assign l2_same_5_2 =  (l2_newdata_5_8) &  (l2_newdata_5_9) &  (l2_newdata_5_10) &  (l2_newdata_5_11) &  
                             (l2_out_data_5_8.data==l2_out_data_5_9.data) & (l2_out_data_5_8.data==l2_out_data_5_10.data) 
                             & (l2_out_data_5_8.data==l2_out_data_5_11.data)
                             & !l3_almost_full_5_2;
assign l2_newdata_5_8 = l2_out_valid_5_8 & (l2_out_data_5_8.data != l2_cache_5_8) & !l2_out_data_5_8.last;
assign l2_newdata_5_9 = l2_out_valid_5_9 & (l2_out_data_5_9.data != l2_cache_5_9) & !l2_out_data_5_9.last;
assign l2_newdata_5_10 = l2_out_valid_5_10 & (l2_out_data_5_10.data != l2_cache_5_10) & !l2_out_data_5_10.last;
assign l2_newdata_5_11 = l2_out_valid_5_11 & (l2_out_data_5_11.data != l2_cache_5_11) & !l2_out_data_5_11.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_5_2[0] = l2_newdata_5_8 & !l3_almost_full_5_2;
    l2_out_ready_5_8 = l2_grant_5_2[0];       
    l2_req_5_2[1] = l2_newdata_5_9 & !l3_almost_full_5_2;
    l2_out_ready_5_9 = l2_grant_5_2[1];       
    l2_req_5_2[2] = l2_newdata_5_10 & !l3_almost_full_5_2;
    l2_out_ready_5_10 = l2_grant_5_2[2];       
    l2_req_5_2[3] = l2_newdata_5_11 & !l3_almost_full_5_2;
    l2_out_ready_5_11 = l2_grant_5_2[3];       
    //sync case
    if(l2_all_last_5_2) begin
        l2_req_5_2 = 0;
        l2_out_ready_5_8 = 1;
        l2_out_ready_5_9 = 1;
        l2_out_ready_5_10 = 1;
        l2_out_ready_5_11 = 1;
    end else if(l2_same_5_2)begin
        l2_req_5_2[0] = 1;
        l2_req_5_2[3:1] = 0;
        l2_out_ready_5_9 = 1;
        l2_out_ready_5_10 = 1;
        l2_out_ready_5_11 = 1;
    end else begin
        if(l2_out_valid_5_8 & (l2_out_data_5_8.data == l2_cache_5_8) 
          & !l2_out_data_5_8.last)begin
            l2_out_ready_5_8 = 1;
        end
        if(l2_out_valid_5_9 & (l2_out_data_5_9.data == l2_cache_5_9) 
          & !l2_out_data_5_9.last)begin
            l2_out_ready_5_9 = 1;
        end
        if(l2_out_valid_5_10 & (l2_out_data_5_10.data == l2_cache_5_10) 
          & !l2_out_data_5_10.last)begin
            l2_out_ready_5_10 = 1;
        end
        if(l2_out_valid_5_11 & (l2_out_data_5_11.data == l2_cache_5_11) 
          & !l2_out_data_5_11.last)begin
            l2_out_ready_5_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_5_8 <= 0;
        l2_cache_5_9 <= 0;
        l2_cache_5_10 <= 0;
        l2_cache_5_11 <= 0;
    end else begin
        if(l2_all_last_5_2)begin
            l2_cache_5_8 <= 0;
            l2_cache_5_9 <= 0;
            l2_cache_5_10 <= 0;
            l2_cache_5_11 <= 0;
        end else begin
            if(l2_out_valid_5_8 & l2_out_ready_5_8)begin
                l2_cache_5_8 <= l2_out_data_5_8.data;
            end
            if(l2_out_valid_5_9 & l2_out_ready_5_9)begin
                l2_cache_5_9 <= l2_out_data_5_9.data;
            end
            if(l2_out_valid_5_10 & l2_out_ready_5_10)begin
                l2_cache_5_10 <= l2_out_data_5_10.data;
            end
            if(l2_out_valid_5_11 & l2_out_ready_5_11)begin
                l2_cache_5_11 <= l2_out_data_5_11.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_5_2 <= 0;
    end else begin
        //sync case
        if(l2_all_last_5_2) begin
            l3_in_valid_5_2 <= 1;
        //normal case
        end else begin
            l3_in_valid_5_2 <= |l2_grant_5_2;
        end
    end
    //sync case
    if(l2_all_last_5_2) begin
        l3_in_data_5_2.last <= 1;
        l3_in_data_5_2.data <= 0;
    //normal case
    end else begin
        case(l2_grant_5_2)
            4'b0001: l3_in_data_5_2 <= l2_out_data_5_8;
            4'b0010: l3_in_data_5_2 <= l2_out_data_5_9;
            4'b0100: l3_in_data_5_2 <= l2_out_data_5_10;
            4'b1000: l3_in_data_5_2 <= l2_out_data_5_11;
            default: l3_in_data_5_2 <= 0;
        endcase
    end   
end
assign l2_all_last_5_3 =  (l2_out_data_5_12.last & l2_out_valid_5_12) &  (l2_out_data_5_13.last & l2_out_valid_5_13) &  (l2_out_data_5_14.last & l2_out_valid_5_14) &  (l2_out_data_5_15.last & l2_out_valid_5_15) &  !l3_almost_full_5_3;
assign l2_same_5_3 =  (l2_newdata_5_12) &  (l2_newdata_5_13) &  (l2_newdata_5_14) &  (l2_newdata_5_15) &  
                             (l2_out_data_5_12.data==l2_out_data_5_13.data) & (l2_out_data_5_12.data==l2_out_data_5_14.data) 
                             & (l2_out_data_5_12.data==l2_out_data_5_15.data)
                             & !l3_almost_full_5_3;
assign l2_newdata_5_12 = l2_out_valid_5_12 & (l2_out_data_5_12.data != l2_cache_5_12) & !l2_out_data_5_12.last;
assign l2_newdata_5_13 = l2_out_valid_5_13 & (l2_out_data_5_13.data != l2_cache_5_13) & !l2_out_data_5_13.last;
assign l2_newdata_5_14 = l2_out_valid_5_14 & (l2_out_data_5_14.data != l2_cache_5_14) & !l2_out_data_5_14.last;
assign l2_newdata_5_15 = l2_out_valid_5_15 & (l2_out_data_5_15.data != l2_cache_5_15) & !l2_out_data_5_15.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_5_3[0] = l2_newdata_5_12 & !l3_almost_full_5_3;
    l2_out_ready_5_12 = l2_grant_5_3[0];       
    l2_req_5_3[1] = l2_newdata_5_13 & !l3_almost_full_5_3;
    l2_out_ready_5_13 = l2_grant_5_3[1];       
    l2_req_5_3[2] = l2_newdata_5_14 & !l3_almost_full_5_3;
    l2_out_ready_5_14 = l2_grant_5_3[2];       
    l2_req_5_3[3] = l2_newdata_5_15 & !l3_almost_full_5_3;
    l2_out_ready_5_15 = l2_grant_5_3[3];       
    //sync case
    if(l2_all_last_5_3) begin
        l2_req_5_3 = 0;
        l2_out_ready_5_12 = 1;
        l2_out_ready_5_13 = 1;
        l2_out_ready_5_14 = 1;
        l2_out_ready_5_15 = 1;
    end else if(l2_same_5_3)begin
        l2_req_5_3[0] = 1;
        l2_req_5_3[3:1] = 0;
        l2_out_ready_5_13 = 1;
        l2_out_ready_5_14 = 1;
        l2_out_ready_5_15 = 1;
    end else begin
        if(l2_out_valid_5_12 & (l2_out_data_5_12.data == l2_cache_5_12) 
          & !l2_out_data_5_12.last)begin
            l2_out_ready_5_12 = 1;
        end
        if(l2_out_valid_5_13 & (l2_out_data_5_13.data == l2_cache_5_13) 
          & !l2_out_data_5_13.last)begin
            l2_out_ready_5_13 = 1;
        end
        if(l2_out_valid_5_14 & (l2_out_data_5_14.data == l2_cache_5_14) 
          & !l2_out_data_5_14.last)begin
            l2_out_ready_5_14 = 1;
        end
        if(l2_out_valid_5_15 & (l2_out_data_5_15.data == l2_cache_5_15) 
          & !l2_out_data_5_15.last)begin
            l2_out_ready_5_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_5_12 <= 0;
        l2_cache_5_13 <= 0;
        l2_cache_5_14 <= 0;
        l2_cache_5_15 <= 0;
    end else begin
        if(l2_all_last_5_3)begin
            l2_cache_5_12 <= 0;
            l2_cache_5_13 <= 0;
            l2_cache_5_14 <= 0;
            l2_cache_5_15 <= 0;
        end else begin
            if(l2_out_valid_5_12 & l2_out_ready_5_12)begin
                l2_cache_5_12 <= l2_out_data_5_12.data;
            end
            if(l2_out_valid_5_13 & l2_out_ready_5_13)begin
                l2_cache_5_13 <= l2_out_data_5_13.data;
            end
            if(l2_out_valid_5_14 & l2_out_ready_5_14)begin
                l2_cache_5_14 <= l2_out_data_5_14.data;
            end
            if(l2_out_valid_5_15 & l2_out_ready_5_15)begin
                l2_cache_5_15 <= l2_out_data_5_15.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_5_3 <= 0;
    end else begin
        //sync case
        if(l2_all_last_5_3) begin
            l3_in_valid_5_3 <= 1;
        //normal case
        end else begin
            l3_in_valid_5_3 <= |l2_grant_5_3;
        end
    end
    //sync case
    if(l2_all_last_5_3) begin
        l3_in_data_5_3.last <= 1;
        l3_in_data_5_3.data <= 0;
    //normal case
    end else begin
        case(l2_grant_5_3)
            4'b0001: l3_in_data_5_3 <= l2_out_data_5_12;
            4'b0010: l3_in_data_5_3 <= l2_out_data_5_13;
            4'b0100: l3_in_data_5_3 <= l2_out_data_5_14;
            4'b1000: l3_in_data_5_3 <= l2_out_data_5_15;
            default: l3_in_data_5_3 <= 0;
        endcase
    end   
end
assign l2_all_last_6_0 =  (l2_out_data_6_0.last & l2_out_valid_6_0) &  (l2_out_data_6_1.last & l2_out_valid_6_1) &  (l2_out_data_6_2.last & l2_out_valid_6_2) &  (l2_out_data_6_3.last & l2_out_valid_6_3) &  !l3_almost_full_6_0;
assign l2_same_6_0 =  (l2_newdata_6_0) &  (l2_newdata_6_1) &  (l2_newdata_6_2) &  (l2_newdata_6_3) &  
                             (l2_out_data_6_0.data==l2_out_data_6_1.data) & (l2_out_data_6_0.data==l2_out_data_6_2.data) 
                             & (l2_out_data_6_0.data==l2_out_data_6_3.data)
                             & !l3_almost_full_6_0;
assign l2_newdata_6_0 = l2_out_valid_6_0 & (l2_out_data_6_0.data != l2_cache_6_0) & !l2_out_data_6_0.last;
assign l2_newdata_6_1 = l2_out_valid_6_1 & (l2_out_data_6_1.data != l2_cache_6_1) & !l2_out_data_6_1.last;
assign l2_newdata_6_2 = l2_out_valid_6_2 & (l2_out_data_6_2.data != l2_cache_6_2) & !l2_out_data_6_2.last;
assign l2_newdata_6_3 = l2_out_valid_6_3 & (l2_out_data_6_3.data != l2_cache_6_3) & !l2_out_data_6_3.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_6_0[0] = l2_newdata_6_0 & !l3_almost_full_6_0;
    l2_out_ready_6_0 = l2_grant_6_0[0];       
    l2_req_6_0[1] = l2_newdata_6_1 & !l3_almost_full_6_0;
    l2_out_ready_6_1 = l2_grant_6_0[1];       
    l2_req_6_0[2] = l2_newdata_6_2 & !l3_almost_full_6_0;
    l2_out_ready_6_2 = l2_grant_6_0[2];       
    l2_req_6_0[3] = l2_newdata_6_3 & !l3_almost_full_6_0;
    l2_out_ready_6_3 = l2_grant_6_0[3];       
    //sync case
    if(l2_all_last_6_0) begin
        l2_req_6_0 = 0;
        l2_out_ready_6_0 = 1;
        l2_out_ready_6_1 = 1;
        l2_out_ready_6_2 = 1;
        l2_out_ready_6_3 = 1;
    end else if(l2_same_6_0)begin
        l2_req_6_0[0] = 1;
        l2_req_6_0[3:1] = 0;
        l2_out_ready_6_1 = 1;
        l2_out_ready_6_2 = 1;
        l2_out_ready_6_3 = 1;
    end else begin
        if(l2_out_valid_6_0 & (l2_out_data_6_0.data == l2_cache_6_0) 
          & !l2_out_data_6_0.last)begin
            l2_out_ready_6_0 = 1;
        end
        if(l2_out_valid_6_1 & (l2_out_data_6_1.data == l2_cache_6_1) 
          & !l2_out_data_6_1.last)begin
            l2_out_ready_6_1 = 1;
        end
        if(l2_out_valid_6_2 & (l2_out_data_6_2.data == l2_cache_6_2) 
          & !l2_out_data_6_2.last)begin
            l2_out_ready_6_2 = 1;
        end
        if(l2_out_valid_6_3 & (l2_out_data_6_3.data == l2_cache_6_3) 
          & !l2_out_data_6_3.last)begin
            l2_out_ready_6_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_6_0 <= 0;
        l2_cache_6_1 <= 0;
        l2_cache_6_2 <= 0;
        l2_cache_6_3 <= 0;
    end else begin
        if(l2_all_last_6_0)begin
            l2_cache_6_0 <= 0;
            l2_cache_6_1 <= 0;
            l2_cache_6_2 <= 0;
            l2_cache_6_3 <= 0;
        end else begin
            if(l2_out_valid_6_0 & l2_out_ready_6_0)begin
                l2_cache_6_0 <= l2_out_data_6_0.data;
            end
            if(l2_out_valid_6_1 & l2_out_ready_6_1)begin
                l2_cache_6_1 <= l2_out_data_6_1.data;
            end
            if(l2_out_valid_6_2 & l2_out_ready_6_2)begin
                l2_cache_6_2 <= l2_out_data_6_2.data;
            end
            if(l2_out_valid_6_3 & l2_out_ready_6_3)begin
                l2_cache_6_3 <= l2_out_data_6_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_6_0 <= 0;
    end else begin
        //sync case
        if(l2_all_last_6_0) begin
            l3_in_valid_6_0 <= 1;
        //normal case
        end else begin
            l3_in_valid_6_0 <= |l2_grant_6_0;
        end
    end
    //sync case
    if(l2_all_last_6_0) begin
        l3_in_data_6_0.last <= 1;
        l3_in_data_6_0.data <= 0;
    //normal case
    end else begin
        case(l2_grant_6_0)
            4'b0001: l3_in_data_6_0 <= l2_out_data_6_0;
            4'b0010: l3_in_data_6_0 <= l2_out_data_6_1;
            4'b0100: l3_in_data_6_0 <= l2_out_data_6_2;
            4'b1000: l3_in_data_6_0 <= l2_out_data_6_3;
            default: l3_in_data_6_0 <= 0;
        endcase
    end   
end
assign l2_all_last_6_1 =  (l2_out_data_6_4.last & l2_out_valid_6_4) &  (l2_out_data_6_5.last & l2_out_valid_6_5) &  (l2_out_data_6_6.last & l2_out_valid_6_6) &  (l2_out_data_6_7.last & l2_out_valid_6_7) &  !l3_almost_full_6_1;
assign l2_same_6_1 =  (l2_newdata_6_4) &  (l2_newdata_6_5) &  (l2_newdata_6_6) &  (l2_newdata_6_7) &  
                             (l2_out_data_6_4.data==l2_out_data_6_5.data) & (l2_out_data_6_4.data==l2_out_data_6_6.data) 
                             & (l2_out_data_6_4.data==l2_out_data_6_7.data)
                             & !l3_almost_full_6_1;
assign l2_newdata_6_4 = l2_out_valid_6_4 & (l2_out_data_6_4.data != l2_cache_6_4) & !l2_out_data_6_4.last;
assign l2_newdata_6_5 = l2_out_valid_6_5 & (l2_out_data_6_5.data != l2_cache_6_5) & !l2_out_data_6_5.last;
assign l2_newdata_6_6 = l2_out_valid_6_6 & (l2_out_data_6_6.data != l2_cache_6_6) & !l2_out_data_6_6.last;
assign l2_newdata_6_7 = l2_out_valid_6_7 & (l2_out_data_6_7.data != l2_cache_6_7) & !l2_out_data_6_7.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_6_1[0] = l2_newdata_6_4 & !l3_almost_full_6_1;
    l2_out_ready_6_4 = l2_grant_6_1[0];       
    l2_req_6_1[1] = l2_newdata_6_5 & !l3_almost_full_6_1;
    l2_out_ready_6_5 = l2_grant_6_1[1];       
    l2_req_6_1[2] = l2_newdata_6_6 & !l3_almost_full_6_1;
    l2_out_ready_6_6 = l2_grant_6_1[2];       
    l2_req_6_1[3] = l2_newdata_6_7 & !l3_almost_full_6_1;
    l2_out_ready_6_7 = l2_grant_6_1[3];       
    //sync case
    if(l2_all_last_6_1) begin
        l2_req_6_1 = 0;
        l2_out_ready_6_4 = 1;
        l2_out_ready_6_5 = 1;
        l2_out_ready_6_6 = 1;
        l2_out_ready_6_7 = 1;
    end else if(l2_same_6_1)begin
        l2_req_6_1[0] = 1;
        l2_req_6_1[3:1] = 0;
        l2_out_ready_6_5 = 1;
        l2_out_ready_6_6 = 1;
        l2_out_ready_6_7 = 1;
    end else begin
        if(l2_out_valid_6_4 & (l2_out_data_6_4.data == l2_cache_6_4) 
          & !l2_out_data_6_4.last)begin
            l2_out_ready_6_4 = 1;
        end
        if(l2_out_valid_6_5 & (l2_out_data_6_5.data == l2_cache_6_5) 
          & !l2_out_data_6_5.last)begin
            l2_out_ready_6_5 = 1;
        end
        if(l2_out_valid_6_6 & (l2_out_data_6_6.data == l2_cache_6_6) 
          & !l2_out_data_6_6.last)begin
            l2_out_ready_6_6 = 1;
        end
        if(l2_out_valid_6_7 & (l2_out_data_6_7.data == l2_cache_6_7) 
          & !l2_out_data_6_7.last)begin
            l2_out_ready_6_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_6_4 <= 0;
        l2_cache_6_5 <= 0;
        l2_cache_6_6 <= 0;
        l2_cache_6_7 <= 0;
    end else begin
        if(l2_all_last_6_1)begin
            l2_cache_6_4 <= 0;
            l2_cache_6_5 <= 0;
            l2_cache_6_6 <= 0;
            l2_cache_6_7 <= 0;
        end else begin
            if(l2_out_valid_6_4 & l2_out_ready_6_4)begin
                l2_cache_6_4 <= l2_out_data_6_4.data;
            end
            if(l2_out_valid_6_5 & l2_out_ready_6_5)begin
                l2_cache_6_5 <= l2_out_data_6_5.data;
            end
            if(l2_out_valid_6_6 & l2_out_ready_6_6)begin
                l2_cache_6_6 <= l2_out_data_6_6.data;
            end
            if(l2_out_valid_6_7 & l2_out_ready_6_7)begin
                l2_cache_6_7 <= l2_out_data_6_7.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_6_1 <= 0;
    end else begin
        //sync case
        if(l2_all_last_6_1) begin
            l3_in_valid_6_1 <= 1;
        //normal case
        end else begin
            l3_in_valid_6_1 <= |l2_grant_6_1;
        end
    end
    //sync case
    if(l2_all_last_6_1) begin
        l3_in_data_6_1.last <= 1;
        l3_in_data_6_1.data <= 0;
    //normal case
    end else begin
        case(l2_grant_6_1)
            4'b0001: l3_in_data_6_1 <= l2_out_data_6_4;
            4'b0010: l3_in_data_6_1 <= l2_out_data_6_5;
            4'b0100: l3_in_data_6_1 <= l2_out_data_6_6;
            4'b1000: l3_in_data_6_1 <= l2_out_data_6_7;
            default: l3_in_data_6_1 <= 0;
        endcase
    end   
end
assign l2_all_last_6_2 =  (l2_out_data_6_8.last & l2_out_valid_6_8) &  (l2_out_data_6_9.last & l2_out_valid_6_9) &  (l2_out_data_6_10.last & l2_out_valid_6_10) &  (l2_out_data_6_11.last & l2_out_valid_6_11) &  !l3_almost_full_6_2;
assign l2_same_6_2 =  (l2_newdata_6_8) &  (l2_newdata_6_9) &  (l2_newdata_6_10) &  (l2_newdata_6_11) &  
                             (l2_out_data_6_8.data==l2_out_data_6_9.data) & (l2_out_data_6_8.data==l2_out_data_6_10.data) 
                             & (l2_out_data_6_8.data==l2_out_data_6_11.data)
                             & !l3_almost_full_6_2;
assign l2_newdata_6_8 = l2_out_valid_6_8 & (l2_out_data_6_8.data != l2_cache_6_8) & !l2_out_data_6_8.last;
assign l2_newdata_6_9 = l2_out_valid_6_9 & (l2_out_data_6_9.data != l2_cache_6_9) & !l2_out_data_6_9.last;
assign l2_newdata_6_10 = l2_out_valid_6_10 & (l2_out_data_6_10.data != l2_cache_6_10) & !l2_out_data_6_10.last;
assign l2_newdata_6_11 = l2_out_valid_6_11 & (l2_out_data_6_11.data != l2_cache_6_11) & !l2_out_data_6_11.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_6_2[0] = l2_newdata_6_8 & !l3_almost_full_6_2;
    l2_out_ready_6_8 = l2_grant_6_2[0];       
    l2_req_6_2[1] = l2_newdata_6_9 & !l3_almost_full_6_2;
    l2_out_ready_6_9 = l2_grant_6_2[1];       
    l2_req_6_2[2] = l2_newdata_6_10 & !l3_almost_full_6_2;
    l2_out_ready_6_10 = l2_grant_6_2[2];       
    l2_req_6_2[3] = l2_newdata_6_11 & !l3_almost_full_6_2;
    l2_out_ready_6_11 = l2_grant_6_2[3];       
    //sync case
    if(l2_all_last_6_2) begin
        l2_req_6_2 = 0;
        l2_out_ready_6_8 = 1;
        l2_out_ready_6_9 = 1;
        l2_out_ready_6_10 = 1;
        l2_out_ready_6_11 = 1;
    end else if(l2_same_6_2)begin
        l2_req_6_2[0] = 1;
        l2_req_6_2[3:1] = 0;
        l2_out_ready_6_9 = 1;
        l2_out_ready_6_10 = 1;
        l2_out_ready_6_11 = 1;
    end else begin
        if(l2_out_valid_6_8 & (l2_out_data_6_8.data == l2_cache_6_8) 
          & !l2_out_data_6_8.last)begin
            l2_out_ready_6_8 = 1;
        end
        if(l2_out_valid_6_9 & (l2_out_data_6_9.data == l2_cache_6_9) 
          & !l2_out_data_6_9.last)begin
            l2_out_ready_6_9 = 1;
        end
        if(l2_out_valid_6_10 & (l2_out_data_6_10.data == l2_cache_6_10) 
          & !l2_out_data_6_10.last)begin
            l2_out_ready_6_10 = 1;
        end
        if(l2_out_valid_6_11 & (l2_out_data_6_11.data == l2_cache_6_11) 
          & !l2_out_data_6_11.last)begin
            l2_out_ready_6_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_6_8 <= 0;
        l2_cache_6_9 <= 0;
        l2_cache_6_10 <= 0;
        l2_cache_6_11 <= 0;
    end else begin
        if(l2_all_last_6_2)begin
            l2_cache_6_8 <= 0;
            l2_cache_6_9 <= 0;
            l2_cache_6_10 <= 0;
            l2_cache_6_11 <= 0;
        end else begin
            if(l2_out_valid_6_8 & l2_out_ready_6_8)begin
                l2_cache_6_8 <= l2_out_data_6_8.data;
            end
            if(l2_out_valid_6_9 & l2_out_ready_6_9)begin
                l2_cache_6_9 <= l2_out_data_6_9.data;
            end
            if(l2_out_valid_6_10 & l2_out_ready_6_10)begin
                l2_cache_6_10 <= l2_out_data_6_10.data;
            end
            if(l2_out_valid_6_11 & l2_out_ready_6_11)begin
                l2_cache_6_11 <= l2_out_data_6_11.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_6_2 <= 0;
    end else begin
        //sync case
        if(l2_all_last_6_2) begin
            l3_in_valid_6_2 <= 1;
        //normal case
        end else begin
            l3_in_valid_6_2 <= |l2_grant_6_2;
        end
    end
    //sync case
    if(l2_all_last_6_2) begin
        l3_in_data_6_2.last <= 1;
        l3_in_data_6_2.data <= 0;
    //normal case
    end else begin
        case(l2_grant_6_2)
            4'b0001: l3_in_data_6_2 <= l2_out_data_6_8;
            4'b0010: l3_in_data_6_2 <= l2_out_data_6_9;
            4'b0100: l3_in_data_6_2 <= l2_out_data_6_10;
            4'b1000: l3_in_data_6_2 <= l2_out_data_6_11;
            default: l3_in_data_6_2 <= 0;
        endcase
    end   
end
assign l2_all_last_6_3 =  (l2_out_data_6_12.last & l2_out_valid_6_12) &  (l2_out_data_6_13.last & l2_out_valid_6_13) &  (l2_out_data_6_14.last & l2_out_valid_6_14) &  (l2_out_data_6_15.last & l2_out_valid_6_15) &  !l3_almost_full_6_3;
assign l2_same_6_3 =  (l2_newdata_6_12) &  (l2_newdata_6_13) &  (l2_newdata_6_14) &  (l2_newdata_6_15) &  
                             (l2_out_data_6_12.data==l2_out_data_6_13.data) & (l2_out_data_6_12.data==l2_out_data_6_14.data) 
                             & (l2_out_data_6_12.data==l2_out_data_6_15.data)
                             & !l3_almost_full_6_3;
assign l2_newdata_6_12 = l2_out_valid_6_12 & (l2_out_data_6_12.data != l2_cache_6_12) & !l2_out_data_6_12.last;
assign l2_newdata_6_13 = l2_out_valid_6_13 & (l2_out_data_6_13.data != l2_cache_6_13) & !l2_out_data_6_13.last;
assign l2_newdata_6_14 = l2_out_valid_6_14 & (l2_out_data_6_14.data != l2_cache_6_14) & !l2_out_data_6_14.last;
assign l2_newdata_6_15 = l2_out_valid_6_15 & (l2_out_data_6_15.data != l2_cache_6_15) & !l2_out_data_6_15.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_6_3[0] = l2_newdata_6_12 & !l3_almost_full_6_3;
    l2_out_ready_6_12 = l2_grant_6_3[0];       
    l2_req_6_3[1] = l2_newdata_6_13 & !l3_almost_full_6_3;
    l2_out_ready_6_13 = l2_grant_6_3[1];       
    l2_req_6_3[2] = l2_newdata_6_14 & !l3_almost_full_6_3;
    l2_out_ready_6_14 = l2_grant_6_3[2];       
    l2_req_6_3[3] = l2_newdata_6_15 & !l3_almost_full_6_3;
    l2_out_ready_6_15 = l2_grant_6_3[3];       
    //sync case
    if(l2_all_last_6_3) begin
        l2_req_6_3 = 0;
        l2_out_ready_6_12 = 1;
        l2_out_ready_6_13 = 1;
        l2_out_ready_6_14 = 1;
        l2_out_ready_6_15 = 1;
    end else if(l2_same_6_3)begin
        l2_req_6_3[0] = 1;
        l2_req_6_3[3:1] = 0;
        l2_out_ready_6_13 = 1;
        l2_out_ready_6_14 = 1;
        l2_out_ready_6_15 = 1;
    end else begin
        if(l2_out_valid_6_12 & (l2_out_data_6_12.data == l2_cache_6_12) 
          & !l2_out_data_6_12.last)begin
            l2_out_ready_6_12 = 1;
        end
        if(l2_out_valid_6_13 & (l2_out_data_6_13.data == l2_cache_6_13) 
          & !l2_out_data_6_13.last)begin
            l2_out_ready_6_13 = 1;
        end
        if(l2_out_valid_6_14 & (l2_out_data_6_14.data == l2_cache_6_14) 
          & !l2_out_data_6_14.last)begin
            l2_out_ready_6_14 = 1;
        end
        if(l2_out_valid_6_15 & (l2_out_data_6_15.data == l2_cache_6_15) 
          & !l2_out_data_6_15.last)begin
            l2_out_ready_6_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_6_12 <= 0;
        l2_cache_6_13 <= 0;
        l2_cache_6_14 <= 0;
        l2_cache_6_15 <= 0;
    end else begin
        if(l2_all_last_6_3)begin
            l2_cache_6_12 <= 0;
            l2_cache_6_13 <= 0;
            l2_cache_6_14 <= 0;
            l2_cache_6_15 <= 0;
        end else begin
            if(l2_out_valid_6_12 & l2_out_ready_6_12)begin
                l2_cache_6_12 <= l2_out_data_6_12.data;
            end
            if(l2_out_valid_6_13 & l2_out_ready_6_13)begin
                l2_cache_6_13 <= l2_out_data_6_13.data;
            end
            if(l2_out_valid_6_14 & l2_out_ready_6_14)begin
                l2_cache_6_14 <= l2_out_data_6_14.data;
            end
            if(l2_out_valid_6_15 & l2_out_ready_6_15)begin
                l2_cache_6_15 <= l2_out_data_6_15.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_6_3 <= 0;
    end else begin
        //sync case
        if(l2_all_last_6_3) begin
            l3_in_valid_6_3 <= 1;
        //normal case
        end else begin
            l3_in_valid_6_3 <= |l2_grant_6_3;
        end
    end
    //sync case
    if(l2_all_last_6_3) begin
        l3_in_data_6_3.last <= 1;
        l3_in_data_6_3.data <= 0;
    //normal case
    end else begin
        case(l2_grant_6_3)
            4'b0001: l3_in_data_6_3 <= l2_out_data_6_12;
            4'b0010: l3_in_data_6_3 <= l2_out_data_6_13;
            4'b0100: l3_in_data_6_3 <= l2_out_data_6_14;
            4'b1000: l3_in_data_6_3 <= l2_out_data_6_15;
            default: l3_in_data_6_3 <= 0;
        endcase
    end   
end
assign l2_all_last_7_0 =  (l2_out_data_7_0.last & l2_out_valid_7_0) &  (l2_out_data_7_1.last & l2_out_valid_7_1) &  (l2_out_data_7_2.last & l2_out_valid_7_2) &  (l2_out_data_7_3.last & l2_out_valid_7_3) &  !l3_almost_full_7_0;
assign l2_same_7_0 =  (l2_newdata_7_0) &  (l2_newdata_7_1) &  (l2_newdata_7_2) &  (l2_newdata_7_3) &  
                             (l2_out_data_7_0.data==l2_out_data_7_1.data) & (l2_out_data_7_0.data==l2_out_data_7_2.data) 
                             & (l2_out_data_7_0.data==l2_out_data_7_3.data)
                             & !l3_almost_full_7_0;
assign l2_newdata_7_0 = l2_out_valid_7_0 & (l2_out_data_7_0.data != l2_cache_7_0) & !l2_out_data_7_0.last;
assign l2_newdata_7_1 = l2_out_valid_7_1 & (l2_out_data_7_1.data != l2_cache_7_1) & !l2_out_data_7_1.last;
assign l2_newdata_7_2 = l2_out_valid_7_2 & (l2_out_data_7_2.data != l2_cache_7_2) & !l2_out_data_7_2.last;
assign l2_newdata_7_3 = l2_out_valid_7_3 & (l2_out_data_7_3.data != l2_cache_7_3) & !l2_out_data_7_3.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_7_0[0] = l2_newdata_7_0 & !l3_almost_full_7_0;
    l2_out_ready_7_0 = l2_grant_7_0[0];       
    l2_req_7_0[1] = l2_newdata_7_1 & !l3_almost_full_7_0;
    l2_out_ready_7_1 = l2_grant_7_0[1];       
    l2_req_7_0[2] = l2_newdata_7_2 & !l3_almost_full_7_0;
    l2_out_ready_7_2 = l2_grant_7_0[2];       
    l2_req_7_0[3] = l2_newdata_7_3 & !l3_almost_full_7_0;
    l2_out_ready_7_3 = l2_grant_7_0[3];       
    //sync case
    if(l2_all_last_7_0) begin
        l2_req_7_0 = 0;
        l2_out_ready_7_0 = 1;
        l2_out_ready_7_1 = 1;
        l2_out_ready_7_2 = 1;
        l2_out_ready_7_3 = 1;
    end else if(l2_same_7_0)begin
        l2_req_7_0[0] = 1;
        l2_req_7_0[3:1] = 0;
        l2_out_ready_7_1 = 1;
        l2_out_ready_7_2 = 1;
        l2_out_ready_7_3 = 1;
    end else begin
        if(l2_out_valid_7_0 & (l2_out_data_7_0.data == l2_cache_7_0) 
          & !l2_out_data_7_0.last)begin
            l2_out_ready_7_0 = 1;
        end
        if(l2_out_valid_7_1 & (l2_out_data_7_1.data == l2_cache_7_1) 
          & !l2_out_data_7_1.last)begin
            l2_out_ready_7_1 = 1;
        end
        if(l2_out_valid_7_2 & (l2_out_data_7_2.data == l2_cache_7_2) 
          & !l2_out_data_7_2.last)begin
            l2_out_ready_7_2 = 1;
        end
        if(l2_out_valid_7_3 & (l2_out_data_7_3.data == l2_cache_7_3) 
          & !l2_out_data_7_3.last)begin
            l2_out_ready_7_3 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_7_0 <= 0;
        l2_cache_7_1 <= 0;
        l2_cache_7_2 <= 0;
        l2_cache_7_3 <= 0;
    end else begin
        if(l2_all_last_7_0)begin
            l2_cache_7_0 <= 0;
            l2_cache_7_1 <= 0;
            l2_cache_7_2 <= 0;
            l2_cache_7_3 <= 0;
        end else begin
            if(l2_out_valid_7_0 & l2_out_ready_7_0)begin
                l2_cache_7_0 <= l2_out_data_7_0.data;
            end
            if(l2_out_valid_7_1 & l2_out_ready_7_1)begin
                l2_cache_7_1 <= l2_out_data_7_1.data;
            end
            if(l2_out_valid_7_2 & l2_out_ready_7_2)begin
                l2_cache_7_2 <= l2_out_data_7_2.data;
            end
            if(l2_out_valid_7_3 & l2_out_ready_7_3)begin
                l2_cache_7_3 <= l2_out_data_7_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_7_0 <= 0;
    end else begin
        //sync case
        if(l2_all_last_7_0) begin
            l3_in_valid_7_0 <= 1;
        //normal case
        end else begin
            l3_in_valid_7_0 <= |l2_grant_7_0;
        end
    end
    //sync case
    if(l2_all_last_7_0) begin
        l3_in_data_7_0.last <= 1;
        l3_in_data_7_0.data <= 0;
    //normal case
    end else begin
        case(l2_grant_7_0)
            4'b0001: l3_in_data_7_0 <= l2_out_data_7_0;
            4'b0010: l3_in_data_7_0 <= l2_out_data_7_1;
            4'b0100: l3_in_data_7_0 <= l2_out_data_7_2;
            4'b1000: l3_in_data_7_0 <= l2_out_data_7_3;
            default: l3_in_data_7_0 <= 0;
        endcase
    end   
end
assign l2_all_last_7_1 =  (l2_out_data_7_4.last & l2_out_valid_7_4) &  (l2_out_data_7_5.last & l2_out_valid_7_5) &  (l2_out_data_7_6.last & l2_out_valid_7_6) &  (l2_out_data_7_7.last & l2_out_valid_7_7) &  !l3_almost_full_7_1;
assign l2_same_7_1 =  (l2_newdata_7_4) &  (l2_newdata_7_5) &  (l2_newdata_7_6) &  (l2_newdata_7_7) &  
                             (l2_out_data_7_4.data==l2_out_data_7_5.data) & (l2_out_data_7_4.data==l2_out_data_7_6.data) 
                             & (l2_out_data_7_4.data==l2_out_data_7_7.data)
                             & !l3_almost_full_7_1;
assign l2_newdata_7_4 = l2_out_valid_7_4 & (l2_out_data_7_4.data != l2_cache_7_4) & !l2_out_data_7_4.last;
assign l2_newdata_7_5 = l2_out_valid_7_5 & (l2_out_data_7_5.data != l2_cache_7_5) & !l2_out_data_7_5.last;
assign l2_newdata_7_6 = l2_out_valid_7_6 & (l2_out_data_7_6.data != l2_cache_7_6) & !l2_out_data_7_6.last;
assign l2_newdata_7_7 = l2_out_valid_7_7 & (l2_out_data_7_7.data != l2_cache_7_7) & !l2_out_data_7_7.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_7_1[0] = l2_newdata_7_4 & !l3_almost_full_7_1;
    l2_out_ready_7_4 = l2_grant_7_1[0];       
    l2_req_7_1[1] = l2_newdata_7_5 & !l3_almost_full_7_1;
    l2_out_ready_7_5 = l2_grant_7_1[1];       
    l2_req_7_1[2] = l2_newdata_7_6 & !l3_almost_full_7_1;
    l2_out_ready_7_6 = l2_grant_7_1[2];       
    l2_req_7_1[3] = l2_newdata_7_7 & !l3_almost_full_7_1;
    l2_out_ready_7_7 = l2_grant_7_1[3];       
    //sync case
    if(l2_all_last_7_1) begin
        l2_req_7_1 = 0;
        l2_out_ready_7_4 = 1;
        l2_out_ready_7_5 = 1;
        l2_out_ready_7_6 = 1;
        l2_out_ready_7_7 = 1;
    end else if(l2_same_7_1)begin
        l2_req_7_1[0] = 1;
        l2_req_7_1[3:1] = 0;
        l2_out_ready_7_5 = 1;
        l2_out_ready_7_6 = 1;
        l2_out_ready_7_7 = 1;
    end else begin
        if(l2_out_valid_7_4 & (l2_out_data_7_4.data == l2_cache_7_4) 
          & !l2_out_data_7_4.last)begin
            l2_out_ready_7_4 = 1;
        end
        if(l2_out_valid_7_5 & (l2_out_data_7_5.data == l2_cache_7_5) 
          & !l2_out_data_7_5.last)begin
            l2_out_ready_7_5 = 1;
        end
        if(l2_out_valid_7_6 & (l2_out_data_7_6.data == l2_cache_7_6) 
          & !l2_out_data_7_6.last)begin
            l2_out_ready_7_6 = 1;
        end
        if(l2_out_valid_7_7 & (l2_out_data_7_7.data == l2_cache_7_7) 
          & !l2_out_data_7_7.last)begin
            l2_out_ready_7_7 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_7_4 <= 0;
        l2_cache_7_5 <= 0;
        l2_cache_7_6 <= 0;
        l2_cache_7_7 <= 0;
    end else begin
        if(l2_all_last_7_1)begin
            l2_cache_7_4 <= 0;
            l2_cache_7_5 <= 0;
            l2_cache_7_6 <= 0;
            l2_cache_7_7 <= 0;
        end else begin
            if(l2_out_valid_7_4 & l2_out_ready_7_4)begin
                l2_cache_7_4 <= l2_out_data_7_4.data;
            end
            if(l2_out_valid_7_5 & l2_out_ready_7_5)begin
                l2_cache_7_5 <= l2_out_data_7_5.data;
            end
            if(l2_out_valid_7_6 & l2_out_ready_7_6)begin
                l2_cache_7_6 <= l2_out_data_7_6.data;
            end
            if(l2_out_valid_7_7 & l2_out_ready_7_7)begin
                l2_cache_7_7 <= l2_out_data_7_7.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_7_1 <= 0;
    end else begin
        //sync case
        if(l2_all_last_7_1) begin
            l3_in_valid_7_1 <= 1;
        //normal case
        end else begin
            l3_in_valid_7_1 <= |l2_grant_7_1;
        end
    end
    //sync case
    if(l2_all_last_7_1) begin
        l3_in_data_7_1.last <= 1;
        l3_in_data_7_1.data <= 0;
    //normal case
    end else begin
        case(l2_grant_7_1)
            4'b0001: l3_in_data_7_1 <= l2_out_data_7_4;
            4'b0010: l3_in_data_7_1 <= l2_out_data_7_5;
            4'b0100: l3_in_data_7_1 <= l2_out_data_7_6;
            4'b1000: l3_in_data_7_1 <= l2_out_data_7_7;
            default: l3_in_data_7_1 <= 0;
        endcase
    end   
end
assign l2_all_last_7_2 =  (l2_out_data_7_8.last & l2_out_valid_7_8) &  (l2_out_data_7_9.last & l2_out_valid_7_9) &  (l2_out_data_7_10.last & l2_out_valid_7_10) &  (l2_out_data_7_11.last & l2_out_valid_7_11) &  !l3_almost_full_7_2;
assign l2_same_7_2 =  (l2_newdata_7_8) &  (l2_newdata_7_9) &  (l2_newdata_7_10) &  (l2_newdata_7_11) &  
                             (l2_out_data_7_8.data==l2_out_data_7_9.data) & (l2_out_data_7_8.data==l2_out_data_7_10.data) 
                             & (l2_out_data_7_8.data==l2_out_data_7_11.data)
                             & !l3_almost_full_7_2;
assign l2_newdata_7_8 = l2_out_valid_7_8 & (l2_out_data_7_8.data != l2_cache_7_8) & !l2_out_data_7_8.last;
assign l2_newdata_7_9 = l2_out_valid_7_9 & (l2_out_data_7_9.data != l2_cache_7_9) & !l2_out_data_7_9.last;
assign l2_newdata_7_10 = l2_out_valid_7_10 & (l2_out_data_7_10.data != l2_cache_7_10) & !l2_out_data_7_10.last;
assign l2_newdata_7_11 = l2_out_valid_7_11 & (l2_out_data_7_11.data != l2_cache_7_11) & !l2_out_data_7_11.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_7_2[0] = l2_newdata_7_8 & !l3_almost_full_7_2;
    l2_out_ready_7_8 = l2_grant_7_2[0];       
    l2_req_7_2[1] = l2_newdata_7_9 & !l3_almost_full_7_2;
    l2_out_ready_7_9 = l2_grant_7_2[1];       
    l2_req_7_2[2] = l2_newdata_7_10 & !l3_almost_full_7_2;
    l2_out_ready_7_10 = l2_grant_7_2[2];       
    l2_req_7_2[3] = l2_newdata_7_11 & !l3_almost_full_7_2;
    l2_out_ready_7_11 = l2_grant_7_2[3];       
    //sync case
    if(l2_all_last_7_2) begin
        l2_req_7_2 = 0;
        l2_out_ready_7_8 = 1;
        l2_out_ready_7_9 = 1;
        l2_out_ready_7_10 = 1;
        l2_out_ready_7_11 = 1;
    end else if(l2_same_7_2)begin
        l2_req_7_2[0] = 1;
        l2_req_7_2[3:1] = 0;
        l2_out_ready_7_9 = 1;
        l2_out_ready_7_10 = 1;
        l2_out_ready_7_11 = 1;
    end else begin
        if(l2_out_valid_7_8 & (l2_out_data_7_8.data == l2_cache_7_8) 
          & !l2_out_data_7_8.last)begin
            l2_out_ready_7_8 = 1;
        end
        if(l2_out_valid_7_9 & (l2_out_data_7_9.data == l2_cache_7_9) 
          & !l2_out_data_7_9.last)begin
            l2_out_ready_7_9 = 1;
        end
        if(l2_out_valid_7_10 & (l2_out_data_7_10.data == l2_cache_7_10) 
          & !l2_out_data_7_10.last)begin
            l2_out_ready_7_10 = 1;
        end
        if(l2_out_valid_7_11 & (l2_out_data_7_11.data == l2_cache_7_11) 
          & !l2_out_data_7_11.last)begin
            l2_out_ready_7_11 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_7_8 <= 0;
        l2_cache_7_9 <= 0;
        l2_cache_7_10 <= 0;
        l2_cache_7_11 <= 0;
    end else begin
        if(l2_all_last_7_2)begin
            l2_cache_7_8 <= 0;
            l2_cache_7_9 <= 0;
            l2_cache_7_10 <= 0;
            l2_cache_7_11 <= 0;
        end else begin
            if(l2_out_valid_7_8 & l2_out_ready_7_8)begin
                l2_cache_7_8 <= l2_out_data_7_8.data;
            end
            if(l2_out_valid_7_9 & l2_out_ready_7_9)begin
                l2_cache_7_9 <= l2_out_data_7_9.data;
            end
            if(l2_out_valid_7_10 & l2_out_ready_7_10)begin
                l2_cache_7_10 <= l2_out_data_7_10.data;
            end
            if(l2_out_valid_7_11 & l2_out_ready_7_11)begin
                l2_cache_7_11 <= l2_out_data_7_11.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_7_2 <= 0;
    end else begin
        //sync case
        if(l2_all_last_7_2) begin
            l3_in_valid_7_2 <= 1;
        //normal case
        end else begin
            l3_in_valid_7_2 <= |l2_grant_7_2;
        end
    end
    //sync case
    if(l2_all_last_7_2) begin
        l3_in_data_7_2.last <= 1;
        l3_in_data_7_2.data <= 0;
    //normal case
    end else begin
        case(l2_grant_7_2)
            4'b0001: l3_in_data_7_2 <= l2_out_data_7_8;
            4'b0010: l3_in_data_7_2 <= l2_out_data_7_9;
            4'b0100: l3_in_data_7_2 <= l2_out_data_7_10;
            4'b1000: l3_in_data_7_2 <= l2_out_data_7_11;
            default: l3_in_data_7_2 <= 0;
        endcase
    end   
end
assign l2_all_last_7_3 =  (l2_out_data_7_12.last & l2_out_valid_7_12) &  (l2_out_data_7_13.last & l2_out_valid_7_13) &  (l2_out_data_7_14.last & l2_out_valid_7_14) &  (l2_out_data_7_15.last & l2_out_valid_7_15) &  !l3_almost_full_7_3;
assign l2_same_7_3 =  (l2_newdata_7_12) &  (l2_newdata_7_13) &  (l2_newdata_7_14) &  (l2_newdata_7_15) &  
                             (l2_out_data_7_12.data==l2_out_data_7_13.data) & (l2_out_data_7_12.data==l2_out_data_7_14.data) 
                             & (l2_out_data_7_12.data==l2_out_data_7_15.data)
                             & !l3_almost_full_7_3;
assign l2_newdata_7_12 = l2_out_valid_7_12 & (l2_out_data_7_12.data != l2_cache_7_12) & !l2_out_data_7_12.last;
assign l2_newdata_7_13 = l2_out_valid_7_13 & (l2_out_data_7_13.data != l2_cache_7_13) & !l2_out_data_7_13.last;
assign l2_newdata_7_14 = l2_out_valid_7_14 & (l2_out_data_7_14.data != l2_cache_7_14) & !l2_out_data_7_14.last;
assign l2_newdata_7_15 = l2_out_valid_7_15 & (l2_out_data_7_15.data != l2_cache_7_15) & !l2_out_data_7_15.last;

//generate request, combinationally logic
always @(*)begin
    l2_req_7_3[0] = l2_newdata_7_12 & !l3_almost_full_7_3;
    l2_out_ready_7_12 = l2_grant_7_3[0];       
    l2_req_7_3[1] = l2_newdata_7_13 & !l3_almost_full_7_3;
    l2_out_ready_7_13 = l2_grant_7_3[1];       
    l2_req_7_3[2] = l2_newdata_7_14 & !l3_almost_full_7_3;
    l2_out_ready_7_14 = l2_grant_7_3[2];       
    l2_req_7_3[3] = l2_newdata_7_15 & !l3_almost_full_7_3;
    l2_out_ready_7_15 = l2_grant_7_3[3];       
    //sync case
    if(l2_all_last_7_3) begin
        l2_req_7_3 = 0;
        l2_out_ready_7_12 = 1;
        l2_out_ready_7_13 = 1;
        l2_out_ready_7_14 = 1;
        l2_out_ready_7_15 = 1;
    end else if(l2_same_7_3)begin
        l2_req_7_3[0] = 1;
        l2_req_7_3[3:1] = 0;
        l2_out_ready_7_13 = 1;
        l2_out_ready_7_14 = 1;
        l2_out_ready_7_15 = 1;
    end else begin
        if(l2_out_valid_7_12 & (l2_out_data_7_12.data == l2_cache_7_12) 
          & !l2_out_data_7_12.last)begin
            l2_out_ready_7_12 = 1;
        end
        if(l2_out_valid_7_13 & (l2_out_data_7_13.data == l2_cache_7_13) 
          & !l2_out_data_7_13.last)begin
            l2_out_ready_7_13 = 1;
        end
        if(l2_out_valid_7_14 & (l2_out_data_7_14.data == l2_cache_7_14) 
          & !l2_out_data_7_14.last)begin
            l2_out_ready_7_14 = 1;
        end
        if(l2_out_valid_7_15 & (l2_out_data_7_15.data == l2_cache_7_15) 
          & !l2_out_data_7_15.last)begin
            l2_out_ready_7_15 = 1;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        l2_cache_7_12 <= 0;
        l2_cache_7_13 <= 0;
        l2_cache_7_14 <= 0;
        l2_cache_7_15 <= 0;
    end else begin
        if(l2_all_last_7_3)begin
            l2_cache_7_12 <= 0;
            l2_cache_7_13 <= 0;
            l2_cache_7_14 <= 0;
            l2_cache_7_15 <= 0;
        end else begin
            if(l2_out_valid_7_12 & l2_out_ready_7_12)begin
                l2_cache_7_12 <= l2_out_data_7_12.data;
            end
            if(l2_out_valid_7_13 & l2_out_ready_7_13)begin
                l2_cache_7_13 <= l2_out_data_7_13.data;
            end
            if(l2_out_valid_7_14 & l2_out_ready_7_14)begin
                l2_cache_7_14 <= l2_out_data_7_14.data;
            end
            if(l2_out_valid_7_15 & l2_out_ready_7_15)begin
                l2_cache_7_15 <= l2_out_data_7_15.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l3_in_valid_7_3 <= 0;
    end else begin
        //sync case
        if(l2_all_last_7_3) begin
            l3_in_valid_7_3 <= 1;
        //normal case
        end else begin
            l3_in_valid_7_3 <= |l2_grant_7_3;
        end
    end
    //sync case
    if(l2_all_last_7_3) begin
        l3_in_data_7_3.last <= 1;
        l3_in_data_7_3.data <= 0;
    //normal case
    end else begin
        case(l2_grant_7_3)
            4'b0001: l3_in_data_7_3 <= l2_out_data_7_12;
            4'b0010: l3_in_data_7_3 <= l2_out_data_7_13;
            4'b0100: l3_in_data_7_3 <= l2_out_data_7_14;
            4'b1000: l3_in_data_7_3 <= l2_out_data_7_15;
            default: l3_in_data_7_3 <= 0;
        endcase
    end   
end

//L3
//L2 FIFO output
assign l3_all_last_0 =  (l3_out_data_0_0.last & l3_out_valid_0_0) &  (l3_out_data_0_1.last & l3_out_valid_0_1) &  (l3_out_data_0_2.last & l3_out_valid_0_2) &  (l3_out_data_0_3.last & l3_out_valid_0_3) &  !l4_almost_full_0;
assign l3_same_0 =  l3_out_valid_0_0 &  l3_out_valid_0_1 &  l3_out_valid_0_2 &  l3_out_valid_0_3 &  !l4_almost_full_0 &
                       (l3_out_data_0_0==l3_out_data_0_1) & (l3_out_data_0_0==l3_out_data_0_2) & (l3_out_data_0_0==l3_out_data_0_3);
assign l3_newdata_0_0 = l3_out_valid_0_0 & (l3_out_data_0_0.data != l3_cache_0_0) & !l3_out_data_0_0.last;
assign l3_newdata_0_1 = l3_out_valid_0_1 & (l3_out_data_0_1.data != l3_cache_0_1) & !l3_out_data_0_1.last;
assign l3_newdata_0_2 = l3_out_valid_0_2 & (l3_out_data_0_2.data != l3_cache_0_2) & !l3_out_data_0_2.last;
assign l3_newdata_0_3 = l3_out_valid_0_3 & (l3_out_data_0_3.data != l3_cache_0_3) & !l3_out_data_0_3.last;
//generate request, combinationally logic
always @(*)begin
    l3_req_0[0] = l3_newdata_0_0 & !l4_almost_full_0;
    l3_out_ready_0_0 = l3_grant_0[0];       
    l3_req_0[1] = l3_newdata_0_1 & !l4_almost_full_0;
    l3_out_ready_0_1 = l3_grant_0[1];       
    l3_req_0[2] = l3_newdata_0_2 & !l4_almost_full_0;
    l3_out_ready_0_2 = l3_grant_0[2];       
    l3_req_0[3] = l3_newdata_0_3 & !l4_almost_full_0;
    l3_out_ready_0_3 = l3_grant_0[3];       
    //sync case
    if(l3_all_last_0) begin
        l3_req_0 = 0;
        l3_out_ready_0_0 = 1;
        l3_out_ready_0_1 = 1;
        l3_out_ready_0_2 = 1;
        l3_out_ready_0_3 = 1;
    end else if (l3_same_0)begin
        l3_req_0[0] = 1;
        l3_req_0[3:1] = 0;
        l3_out_ready_0_1 = 1;
        l3_out_ready_0_2 = 1;
        l3_out_ready_0_3 = 1;
    end else begin
        if(l3_out_valid_0_0 & (l3_out_data_0_0.data == l3_cache_0_0) 
          & !l3_out_data_0_0.last)begin
            l3_out_ready_0_0 = 1;
        end
        if(l3_out_valid_0_1 & (l3_out_data_0_1.data == l3_cache_0_1) 
          & !l3_out_data_0_1.last)begin
            l3_out_ready_0_1 = 1;
        end
        if(l3_out_valid_0_2 & (l3_out_data_0_2.data == l3_cache_0_2) 
          & !l3_out_data_0_2.last)begin
            l3_out_ready_0_2 = 1;
        end
        if(l3_out_valid_0_3 & (l3_out_data_0_3.data == l3_cache_0_3) 
          & !l3_out_data_0_3.last)begin
            l3_out_ready_0_3 = 1;
        end

    end
end

always @(posedge clk)begin
    if(rst)begin
        l3_cache_0_0 <= 0;
        l3_cache_0_1 <= 0;
        l3_cache_0_2 <= 0;
        l3_cache_0_3 <= 0;
    end else begin
        if(l3_all_last_0)begin
            l3_cache_0_0 <= 0;
            l3_cache_0_1 <= 0;
            l3_cache_0_2 <= 0;
            l3_cache_0_3 <= 0;
        end else begin
            if(l3_out_valid_0_0 & l3_out_ready_0_0)begin
                l3_cache_0_0 <= l3_out_data_0_0.data;
            end
            if(l3_out_valid_0_1 & l3_out_ready_0_1)begin
                l3_cache_0_1 <= l3_out_data_0_1.data;
            end
            if(l3_out_valid_0_2 & l3_out_ready_0_2)begin
                l3_cache_0_2 <= l3_out_data_0_2.data;
            end
            if(l3_out_valid_0_3 & l3_out_ready_0_3)begin
                l3_cache_0_3 <= l3_out_data_0_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l4_in_valid_0 <= 0;
    end else begin
        //sync case
        if(l3_all_last_0) begin
            l4_in_valid_0 <= 1;
        //normal case
        end else begin
            l4_in_valid_0 <= |l3_grant_0;
        end
    end
    //sync case
    if(l3_all_last_0) begin
        l4_in_data_0.last <= 1;
        l4_in_data_0.data <= 0;
    //normal case
    end else begin
        case(l3_grant_0)
            4'b0001: l4_in_data_0 <= l3_out_data_0_0;
            4'b0010: l4_in_data_0 <= l3_out_data_0_1;
            4'b0100: l4_in_data_0 <= l3_out_data_0_2;
            4'b1000: l4_in_data_0 <= l3_out_data_0_3;
            default: l4_in_data_0 <= 0;
        endcase
    end   
end

assign l3_all_last_1 =  (l3_out_data_1_0.last & l3_out_valid_1_0) &  (l3_out_data_1_1.last & l3_out_valid_1_1) &  (l3_out_data_1_2.last & l3_out_valid_1_2) &  (l3_out_data_1_3.last & l3_out_valid_1_3) &  !l4_almost_full_1;
assign l3_same_1 =  l3_out_valid_1_0 &  l3_out_valid_1_1 &  l3_out_valid_1_2 &  l3_out_valid_1_3 &  !l4_almost_full_1 &
                       (l3_out_data_1_0==l3_out_data_1_1) & (l3_out_data_1_0==l3_out_data_1_2) & (l3_out_data_1_0==l3_out_data_1_3);
assign l3_newdata_1_0 = l3_out_valid_1_0 & (l3_out_data_1_0.data != l3_cache_1_0) & !l3_out_data_1_0.last;
assign l3_newdata_1_1 = l3_out_valid_1_1 & (l3_out_data_1_1.data != l3_cache_1_1) & !l3_out_data_1_1.last;
assign l3_newdata_1_2 = l3_out_valid_1_2 & (l3_out_data_1_2.data != l3_cache_1_2) & !l3_out_data_1_2.last;
assign l3_newdata_1_3 = l3_out_valid_1_3 & (l3_out_data_1_3.data != l3_cache_1_3) & !l3_out_data_1_3.last;
//generate request, combinationally logic
always @(*)begin
    l3_req_1[0] = l3_newdata_1_0 & !l4_almost_full_1;
    l3_out_ready_1_0 = l3_grant_1[0];       
    l3_req_1[1] = l3_newdata_1_1 & !l4_almost_full_1;
    l3_out_ready_1_1 = l3_grant_1[1];       
    l3_req_1[2] = l3_newdata_1_2 & !l4_almost_full_1;
    l3_out_ready_1_2 = l3_grant_1[2];       
    l3_req_1[3] = l3_newdata_1_3 & !l4_almost_full_1;
    l3_out_ready_1_3 = l3_grant_1[3];       
    //sync case
    if(l3_all_last_1) begin
        l3_req_1 = 0;
        l3_out_ready_1_0 = 1;
        l3_out_ready_1_1 = 1;
        l3_out_ready_1_2 = 1;
        l3_out_ready_1_3 = 1;
    end else if (l3_same_1)begin
        l3_req_1[0] = 1;
        l3_req_1[3:1] = 0;
        l3_out_ready_1_1 = 1;
        l3_out_ready_1_2 = 1;
        l3_out_ready_1_3 = 1;
    end else begin
        if(l3_out_valid_1_0 & (l3_out_data_1_0.data == l3_cache_1_0) 
          & !l3_out_data_1_0.last)begin
            l3_out_ready_1_0 = 1;
        end
        if(l3_out_valid_1_1 & (l3_out_data_1_1.data == l3_cache_1_1) 
          & !l3_out_data_1_1.last)begin
            l3_out_ready_1_1 = 1;
        end
        if(l3_out_valid_1_2 & (l3_out_data_1_2.data == l3_cache_1_2) 
          & !l3_out_data_1_2.last)begin
            l3_out_ready_1_2 = 1;
        end
        if(l3_out_valid_1_3 & (l3_out_data_1_3.data == l3_cache_1_3) 
          & !l3_out_data_1_3.last)begin
            l3_out_ready_1_3 = 1;
        end

    end
end

always @(posedge clk)begin
    if(rst)begin
        l3_cache_1_0 <= 0;
        l3_cache_1_1 <= 0;
        l3_cache_1_2 <= 0;
        l3_cache_1_3 <= 0;
    end else begin
        if(l3_all_last_1)begin
            l3_cache_1_0 <= 0;
            l3_cache_1_1 <= 0;
            l3_cache_1_2 <= 0;
            l3_cache_1_3 <= 0;
        end else begin
            if(l3_out_valid_1_0 & l3_out_ready_1_0)begin
                l3_cache_1_0 <= l3_out_data_1_0.data;
            end
            if(l3_out_valid_1_1 & l3_out_ready_1_1)begin
                l3_cache_1_1 <= l3_out_data_1_1.data;
            end
            if(l3_out_valid_1_2 & l3_out_ready_1_2)begin
                l3_cache_1_2 <= l3_out_data_1_2.data;
            end
            if(l3_out_valid_1_3 & l3_out_ready_1_3)begin
                l3_cache_1_3 <= l3_out_data_1_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l4_in_valid_1 <= 0;
    end else begin
        //sync case
        if(l3_all_last_1) begin
            l4_in_valid_1 <= 1;
        //normal case
        end else begin
            l4_in_valid_1 <= |l3_grant_1;
        end
    end
    //sync case
    if(l3_all_last_1) begin
        l4_in_data_1.last <= 1;
        l4_in_data_1.data <= 0;
    //normal case
    end else begin
        case(l3_grant_1)
            4'b0001: l4_in_data_1 <= l3_out_data_1_0;
            4'b0010: l4_in_data_1 <= l3_out_data_1_1;
            4'b0100: l4_in_data_1 <= l3_out_data_1_2;
            4'b1000: l4_in_data_1 <= l3_out_data_1_3;
            default: l4_in_data_1 <= 0;
        endcase
    end   
end

assign l3_all_last_2 =  (l3_out_data_2_0.last & l3_out_valid_2_0) &  (l3_out_data_2_1.last & l3_out_valid_2_1) &  (l3_out_data_2_2.last & l3_out_valid_2_2) &  (l3_out_data_2_3.last & l3_out_valid_2_3) &  !l4_almost_full_2;
assign l3_same_2 =  l3_out_valid_2_0 &  l3_out_valid_2_1 &  l3_out_valid_2_2 &  l3_out_valid_2_3 &  !l4_almost_full_2 &
                       (l3_out_data_2_0==l3_out_data_2_1) & (l3_out_data_2_0==l3_out_data_2_2) & (l3_out_data_2_0==l3_out_data_2_3);
assign l3_newdata_2_0 = l3_out_valid_2_0 & (l3_out_data_2_0.data != l3_cache_2_0) & !l3_out_data_2_0.last;
assign l3_newdata_2_1 = l3_out_valid_2_1 & (l3_out_data_2_1.data != l3_cache_2_1) & !l3_out_data_2_1.last;
assign l3_newdata_2_2 = l3_out_valid_2_2 & (l3_out_data_2_2.data != l3_cache_2_2) & !l3_out_data_2_2.last;
assign l3_newdata_2_3 = l3_out_valid_2_3 & (l3_out_data_2_3.data != l3_cache_2_3) & !l3_out_data_2_3.last;
//generate request, combinationally logic
always @(*)begin
    l3_req_2[0] = l3_newdata_2_0 & !l4_almost_full_2;
    l3_out_ready_2_0 = l3_grant_2[0];       
    l3_req_2[1] = l3_newdata_2_1 & !l4_almost_full_2;
    l3_out_ready_2_1 = l3_grant_2[1];       
    l3_req_2[2] = l3_newdata_2_2 & !l4_almost_full_2;
    l3_out_ready_2_2 = l3_grant_2[2];       
    l3_req_2[3] = l3_newdata_2_3 & !l4_almost_full_2;
    l3_out_ready_2_3 = l3_grant_2[3];       
    //sync case
    if(l3_all_last_2) begin
        l3_req_2 = 0;
        l3_out_ready_2_0 = 1;
        l3_out_ready_2_1 = 1;
        l3_out_ready_2_2 = 1;
        l3_out_ready_2_3 = 1;
    end else if (l3_same_2)begin
        l3_req_2[0] = 1;
        l3_req_2[3:1] = 0;
        l3_out_ready_2_1 = 1;
        l3_out_ready_2_2 = 1;
        l3_out_ready_2_3 = 1;
    end else begin
        if(l3_out_valid_2_0 & (l3_out_data_2_0.data == l3_cache_2_0) 
          & !l3_out_data_2_0.last)begin
            l3_out_ready_2_0 = 1;
        end
        if(l3_out_valid_2_1 & (l3_out_data_2_1.data == l3_cache_2_1) 
          & !l3_out_data_2_1.last)begin
            l3_out_ready_2_1 = 1;
        end
        if(l3_out_valid_2_2 & (l3_out_data_2_2.data == l3_cache_2_2) 
          & !l3_out_data_2_2.last)begin
            l3_out_ready_2_2 = 1;
        end
        if(l3_out_valid_2_3 & (l3_out_data_2_3.data == l3_cache_2_3) 
          & !l3_out_data_2_3.last)begin
            l3_out_ready_2_3 = 1;
        end

    end
end

always @(posedge clk)begin
    if(rst)begin
        l3_cache_2_0 <= 0;
        l3_cache_2_1 <= 0;
        l3_cache_2_2 <= 0;
        l3_cache_2_3 <= 0;
    end else begin
        if(l3_all_last_2)begin
            l3_cache_2_0 <= 0;
            l3_cache_2_1 <= 0;
            l3_cache_2_2 <= 0;
            l3_cache_2_3 <= 0;
        end else begin
            if(l3_out_valid_2_0 & l3_out_ready_2_0)begin
                l3_cache_2_0 <= l3_out_data_2_0.data;
            end
            if(l3_out_valid_2_1 & l3_out_ready_2_1)begin
                l3_cache_2_1 <= l3_out_data_2_1.data;
            end
            if(l3_out_valid_2_2 & l3_out_ready_2_2)begin
                l3_cache_2_2 <= l3_out_data_2_2.data;
            end
            if(l3_out_valid_2_3 & l3_out_ready_2_3)begin
                l3_cache_2_3 <= l3_out_data_2_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l4_in_valid_2 <= 0;
    end else begin
        //sync case
        if(l3_all_last_2) begin
            l4_in_valid_2 <= 1;
        //normal case
        end else begin
            l4_in_valid_2 <= |l3_grant_2;
        end
    end
    //sync case
    if(l3_all_last_2) begin
        l4_in_data_2.last <= 1;
        l4_in_data_2.data <= 0;
    //normal case
    end else begin
        case(l3_grant_2)
            4'b0001: l4_in_data_2 <= l3_out_data_2_0;
            4'b0010: l4_in_data_2 <= l3_out_data_2_1;
            4'b0100: l4_in_data_2 <= l3_out_data_2_2;
            4'b1000: l4_in_data_2 <= l3_out_data_2_3;
            default: l4_in_data_2 <= 0;
        endcase
    end   
end

assign l3_all_last_3 =  (l3_out_data_3_0.last & l3_out_valid_3_0) &  (l3_out_data_3_1.last & l3_out_valid_3_1) &  (l3_out_data_3_2.last & l3_out_valid_3_2) &  (l3_out_data_3_3.last & l3_out_valid_3_3) &  !l4_almost_full_3;
assign l3_same_3 =  l3_out_valid_3_0 &  l3_out_valid_3_1 &  l3_out_valid_3_2 &  l3_out_valid_3_3 &  !l4_almost_full_3 &
                       (l3_out_data_3_0==l3_out_data_3_1) & (l3_out_data_3_0==l3_out_data_3_2) & (l3_out_data_3_0==l3_out_data_3_3);
assign l3_newdata_3_0 = l3_out_valid_3_0 & (l3_out_data_3_0.data != l3_cache_3_0) & !l3_out_data_3_0.last;
assign l3_newdata_3_1 = l3_out_valid_3_1 & (l3_out_data_3_1.data != l3_cache_3_1) & !l3_out_data_3_1.last;
assign l3_newdata_3_2 = l3_out_valid_3_2 & (l3_out_data_3_2.data != l3_cache_3_2) & !l3_out_data_3_2.last;
assign l3_newdata_3_3 = l3_out_valid_3_3 & (l3_out_data_3_3.data != l3_cache_3_3) & !l3_out_data_3_3.last;
//generate request, combinationally logic
always @(*)begin
    l3_req_3[0] = l3_newdata_3_0 & !l4_almost_full_3;
    l3_out_ready_3_0 = l3_grant_3[0];       
    l3_req_3[1] = l3_newdata_3_1 & !l4_almost_full_3;
    l3_out_ready_3_1 = l3_grant_3[1];       
    l3_req_3[2] = l3_newdata_3_2 & !l4_almost_full_3;
    l3_out_ready_3_2 = l3_grant_3[2];       
    l3_req_3[3] = l3_newdata_3_3 & !l4_almost_full_3;
    l3_out_ready_3_3 = l3_grant_3[3];       
    //sync case
    if(l3_all_last_3) begin
        l3_req_3 = 0;
        l3_out_ready_3_0 = 1;
        l3_out_ready_3_1 = 1;
        l3_out_ready_3_2 = 1;
        l3_out_ready_3_3 = 1;
    end else if (l3_same_3)begin
        l3_req_3[0] = 1;
        l3_req_3[3:1] = 0;
        l3_out_ready_3_1 = 1;
        l3_out_ready_3_2 = 1;
        l3_out_ready_3_3 = 1;
    end else begin
        if(l3_out_valid_3_0 & (l3_out_data_3_0.data == l3_cache_3_0) 
          & !l3_out_data_3_0.last)begin
            l3_out_ready_3_0 = 1;
        end
        if(l3_out_valid_3_1 & (l3_out_data_3_1.data == l3_cache_3_1) 
          & !l3_out_data_3_1.last)begin
            l3_out_ready_3_1 = 1;
        end
        if(l3_out_valid_3_2 & (l3_out_data_3_2.data == l3_cache_3_2) 
          & !l3_out_data_3_2.last)begin
            l3_out_ready_3_2 = 1;
        end
        if(l3_out_valid_3_3 & (l3_out_data_3_3.data == l3_cache_3_3) 
          & !l3_out_data_3_3.last)begin
            l3_out_ready_3_3 = 1;
        end

    end
end

always @(posedge clk)begin
    if(rst)begin
        l3_cache_3_0 <= 0;
        l3_cache_3_1 <= 0;
        l3_cache_3_2 <= 0;
        l3_cache_3_3 <= 0;
    end else begin
        if(l3_all_last_3)begin
            l3_cache_3_0 <= 0;
            l3_cache_3_1 <= 0;
            l3_cache_3_2 <= 0;
            l3_cache_3_3 <= 0;
        end else begin
            if(l3_out_valid_3_0 & l3_out_ready_3_0)begin
                l3_cache_3_0 <= l3_out_data_3_0.data;
            end
            if(l3_out_valid_3_1 & l3_out_ready_3_1)begin
                l3_cache_3_1 <= l3_out_data_3_1.data;
            end
            if(l3_out_valid_3_2 & l3_out_ready_3_2)begin
                l3_cache_3_2 <= l3_out_data_3_2.data;
            end
            if(l3_out_valid_3_3 & l3_out_ready_3_3)begin
                l3_cache_3_3 <= l3_out_data_3_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l4_in_valid_3 <= 0;
    end else begin
        //sync case
        if(l3_all_last_3) begin
            l4_in_valid_3 <= 1;
        //normal case
        end else begin
            l4_in_valid_3 <= |l3_grant_3;
        end
    end
    //sync case
    if(l3_all_last_3) begin
        l4_in_data_3.last <= 1;
        l4_in_data_3.data <= 0;
    //normal case
    end else begin
        case(l3_grant_3)
            4'b0001: l4_in_data_3 <= l3_out_data_3_0;
            4'b0010: l4_in_data_3 <= l3_out_data_3_1;
            4'b0100: l4_in_data_3 <= l3_out_data_3_2;
            4'b1000: l4_in_data_3 <= l3_out_data_3_3;
            default: l4_in_data_3 <= 0;
        endcase
    end   
end

assign l3_all_last_4 =  (l3_out_data_4_0.last & l3_out_valid_4_0) &  (l3_out_data_4_1.last & l3_out_valid_4_1) &  (l3_out_data_4_2.last & l3_out_valid_4_2) &  (l3_out_data_4_3.last & l3_out_valid_4_3) &  !l4_almost_full_4;
assign l3_same_4 =  l3_out_valid_4_0 &  l3_out_valid_4_1 &  l3_out_valid_4_2 &  l3_out_valid_4_3 &  !l4_almost_full_4 &
                       (l3_out_data_4_0==l3_out_data_4_1) & (l3_out_data_4_0==l3_out_data_4_2) & (l3_out_data_4_0==l3_out_data_4_3);
assign l3_newdata_4_0 = l3_out_valid_4_0 & (l3_out_data_4_0.data != l3_cache_4_0) & !l3_out_data_4_0.last;
assign l3_newdata_4_1 = l3_out_valid_4_1 & (l3_out_data_4_1.data != l3_cache_4_1) & !l3_out_data_4_1.last;
assign l3_newdata_4_2 = l3_out_valid_4_2 & (l3_out_data_4_2.data != l3_cache_4_2) & !l3_out_data_4_2.last;
assign l3_newdata_4_3 = l3_out_valid_4_3 & (l3_out_data_4_3.data != l3_cache_4_3) & !l3_out_data_4_3.last;
//generate request, combinationally logic
always @(*)begin
    l3_req_4[0] = l3_newdata_4_0 & !l4_almost_full_4;
    l3_out_ready_4_0 = l3_grant_4[0];       
    l3_req_4[1] = l3_newdata_4_1 & !l4_almost_full_4;
    l3_out_ready_4_1 = l3_grant_4[1];       
    l3_req_4[2] = l3_newdata_4_2 & !l4_almost_full_4;
    l3_out_ready_4_2 = l3_grant_4[2];       
    l3_req_4[3] = l3_newdata_4_3 & !l4_almost_full_4;
    l3_out_ready_4_3 = l3_grant_4[3];       
    //sync case
    if(l3_all_last_4) begin
        l3_req_4 = 0;
        l3_out_ready_4_0 = 1;
        l3_out_ready_4_1 = 1;
        l3_out_ready_4_2 = 1;
        l3_out_ready_4_3 = 1;
    end else if (l3_same_4)begin
        l3_req_4[0] = 1;
        l3_req_4[3:1] = 0;
        l3_out_ready_4_1 = 1;
        l3_out_ready_4_2 = 1;
        l3_out_ready_4_3 = 1;
    end else begin
        if(l3_out_valid_4_0 & (l3_out_data_4_0.data == l3_cache_4_0) 
          & !l3_out_data_4_0.last)begin
            l3_out_ready_4_0 = 1;
        end
        if(l3_out_valid_4_1 & (l3_out_data_4_1.data == l3_cache_4_1) 
          & !l3_out_data_4_1.last)begin
            l3_out_ready_4_1 = 1;
        end
        if(l3_out_valid_4_2 & (l3_out_data_4_2.data == l3_cache_4_2) 
          & !l3_out_data_4_2.last)begin
            l3_out_ready_4_2 = 1;
        end
        if(l3_out_valid_4_3 & (l3_out_data_4_3.data == l3_cache_4_3) 
          & !l3_out_data_4_3.last)begin
            l3_out_ready_4_3 = 1;
        end

    end
end

always @(posedge clk)begin
    if(rst)begin
        l3_cache_4_0 <= 0;
        l3_cache_4_1 <= 0;
        l3_cache_4_2 <= 0;
        l3_cache_4_3 <= 0;
    end else begin
        if(l3_all_last_4)begin
            l3_cache_4_0 <= 0;
            l3_cache_4_1 <= 0;
            l3_cache_4_2 <= 0;
            l3_cache_4_3 <= 0;
        end else begin
            if(l3_out_valid_4_0 & l3_out_ready_4_0)begin
                l3_cache_4_0 <= l3_out_data_4_0.data;
            end
            if(l3_out_valid_4_1 & l3_out_ready_4_1)begin
                l3_cache_4_1 <= l3_out_data_4_1.data;
            end
            if(l3_out_valid_4_2 & l3_out_ready_4_2)begin
                l3_cache_4_2 <= l3_out_data_4_2.data;
            end
            if(l3_out_valid_4_3 & l3_out_ready_4_3)begin
                l3_cache_4_3 <= l3_out_data_4_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l4_in_valid_4 <= 0;
    end else begin
        //sync case
        if(l3_all_last_4) begin
            l4_in_valid_4 <= 1;
        //normal case
        end else begin
            l4_in_valid_4 <= |l3_grant_4;
        end
    end
    //sync case
    if(l3_all_last_4) begin
        l4_in_data_4.last <= 1;
        l4_in_data_4.data <= 0;
    //normal case
    end else begin
        case(l3_grant_4)
            4'b0001: l4_in_data_4 <= l3_out_data_4_0;
            4'b0010: l4_in_data_4 <= l3_out_data_4_1;
            4'b0100: l4_in_data_4 <= l3_out_data_4_2;
            4'b1000: l4_in_data_4 <= l3_out_data_4_3;
            default: l4_in_data_4 <= 0;
        endcase
    end   
end

assign l3_all_last_5 =  (l3_out_data_5_0.last & l3_out_valid_5_0) &  (l3_out_data_5_1.last & l3_out_valid_5_1) &  (l3_out_data_5_2.last & l3_out_valid_5_2) &  (l3_out_data_5_3.last & l3_out_valid_5_3) &  !l4_almost_full_5;
assign l3_same_5 =  l3_out_valid_5_0 &  l3_out_valid_5_1 &  l3_out_valid_5_2 &  l3_out_valid_5_3 &  !l4_almost_full_5 &
                       (l3_out_data_5_0==l3_out_data_5_1) & (l3_out_data_5_0==l3_out_data_5_2) & (l3_out_data_5_0==l3_out_data_5_3);
assign l3_newdata_5_0 = l3_out_valid_5_0 & (l3_out_data_5_0.data != l3_cache_5_0) & !l3_out_data_5_0.last;
assign l3_newdata_5_1 = l3_out_valid_5_1 & (l3_out_data_5_1.data != l3_cache_5_1) & !l3_out_data_5_1.last;
assign l3_newdata_5_2 = l3_out_valid_5_2 & (l3_out_data_5_2.data != l3_cache_5_2) & !l3_out_data_5_2.last;
assign l3_newdata_5_3 = l3_out_valid_5_3 & (l3_out_data_5_3.data != l3_cache_5_3) & !l3_out_data_5_3.last;
//generate request, combinationally logic
always @(*)begin
    l3_req_5[0] = l3_newdata_5_0 & !l4_almost_full_5;
    l3_out_ready_5_0 = l3_grant_5[0];       
    l3_req_5[1] = l3_newdata_5_1 & !l4_almost_full_5;
    l3_out_ready_5_1 = l3_grant_5[1];       
    l3_req_5[2] = l3_newdata_5_2 & !l4_almost_full_5;
    l3_out_ready_5_2 = l3_grant_5[2];       
    l3_req_5[3] = l3_newdata_5_3 & !l4_almost_full_5;
    l3_out_ready_5_3 = l3_grant_5[3];       
    //sync case
    if(l3_all_last_5) begin
        l3_req_5 = 0;
        l3_out_ready_5_0 = 1;
        l3_out_ready_5_1 = 1;
        l3_out_ready_5_2 = 1;
        l3_out_ready_5_3 = 1;
    end else if (l3_same_5)begin
        l3_req_5[0] = 1;
        l3_req_5[3:1] = 0;
        l3_out_ready_5_1 = 1;
        l3_out_ready_5_2 = 1;
        l3_out_ready_5_3 = 1;
    end else begin
        if(l3_out_valid_5_0 & (l3_out_data_5_0.data == l3_cache_5_0) 
          & !l3_out_data_5_0.last)begin
            l3_out_ready_5_0 = 1;
        end
        if(l3_out_valid_5_1 & (l3_out_data_5_1.data == l3_cache_5_1) 
          & !l3_out_data_5_1.last)begin
            l3_out_ready_5_1 = 1;
        end
        if(l3_out_valid_5_2 & (l3_out_data_5_2.data == l3_cache_5_2) 
          & !l3_out_data_5_2.last)begin
            l3_out_ready_5_2 = 1;
        end
        if(l3_out_valid_5_3 & (l3_out_data_5_3.data == l3_cache_5_3) 
          & !l3_out_data_5_3.last)begin
            l3_out_ready_5_3 = 1;
        end

    end
end

always @(posedge clk)begin
    if(rst)begin
        l3_cache_5_0 <= 0;
        l3_cache_5_1 <= 0;
        l3_cache_5_2 <= 0;
        l3_cache_5_3 <= 0;
    end else begin
        if(l3_all_last_5)begin
            l3_cache_5_0 <= 0;
            l3_cache_5_1 <= 0;
            l3_cache_5_2 <= 0;
            l3_cache_5_3 <= 0;
        end else begin
            if(l3_out_valid_5_0 & l3_out_ready_5_0)begin
                l3_cache_5_0 <= l3_out_data_5_0.data;
            end
            if(l3_out_valid_5_1 & l3_out_ready_5_1)begin
                l3_cache_5_1 <= l3_out_data_5_1.data;
            end
            if(l3_out_valid_5_2 & l3_out_ready_5_2)begin
                l3_cache_5_2 <= l3_out_data_5_2.data;
            end
            if(l3_out_valid_5_3 & l3_out_ready_5_3)begin
                l3_cache_5_3 <= l3_out_data_5_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l4_in_valid_5 <= 0;
    end else begin
        //sync case
        if(l3_all_last_5) begin
            l4_in_valid_5 <= 1;
        //normal case
        end else begin
            l4_in_valid_5 <= |l3_grant_5;
        end
    end
    //sync case
    if(l3_all_last_5) begin
        l4_in_data_5.last <= 1;
        l4_in_data_5.data <= 0;
    //normal case
    end else begin
        case(l3_grant_5)
            4'b0001: l4_in_data_5 <= l3_out_data_5_0;
            4'b0010: l4_in_data_5 <= l3_out_data_5_1;
            4'b0100: l4_in_data_5 <= l3_out_data_5_2;
            4'b1000: l4_in_data_5 <= l3_out_data_5_3;
            default: l4_in_data_5 <= 0;
        endcase
    end   
end

assign l3_all_last_6 =  (l3_out_data_6_0.last & l3_out_valid_6_0) &  (l3_out_data_6_1.last & l3_out_valid_6_1) &  (l3_out_data_6_2.last & l3_out_valid_6_2) &  (l3_out_data_6_3.last & l3_out_valid_6_3) &  !l4_almost_full_6;
assign l3_same_6 =  l3_out_valid_6_0 &  l3_out_valid_6_1 &  l3_out_valid_6_2 &  l3_out_valid_6_3 &  !l4_almost_full_6 &
                       (l3_out_data_6_0==l3_out_data_6_1) & (l3_out_data_6_0==l3_out_data_6_2) & (l3_out_data_6_0==l3_out_data_6_3);
assign l3_newdata_6_0 = l3_out_valid_6_0 & (l3_out_data_6_0.data != l3_cache_6_0) & !l3_out_data_6_0.last;
assign l3_newdata_6_1 = l3_out_valid_6_1 & (l3_out_data_6_1.data != l3_cache_6_1) & !l3_out_data_6_1.last;
assign l3_newdata_6_2 = l3_out_valid_6_2 & (l3_out_data_6_2.data != l3_cache_6_2) & !l3_out_data_6_2.last;
assign l3_newdata_6_3 = l3_out_valid_6_3 & (l3_out_data_6_3.data != l3_cache_6_3) & !l3_out_data_6_3.last;
//generate request, combinationally logic
always @(*)begin
    l3_req_6[0] = l3_newdata_6_0 & !l4_almost_full_6;
    l3_out_ready_6_0 = l3_grant_6[0];       
    l3_req_6[1] = l3_newdata_6_1 & !l4_almost_full_6;
    l3_out_ready_6_1 = l3_grant_6[1];       
    l3_req_6[2] = l3_newdata_6_2 & !l4_almost_full_6;
    l3_out_ready_6_2 = l3_grant_6[2];       
    l3_req_6[3] = l3_newdata_6_3 & !l4_almost_full_6;
    l3_out_ready_6_3 = l3_grant_6[3];       
    //sync case
    if(l3_all_last_6) begin
        l3_req_6 = 0;
        l3_out_ready_6_0 = 1;
        l3_out_ready_6_1 = 1;
        l3_out_ready_6_2 = 1;
        l3_out_ready_6_3 = 1;
    end else if (l3_same_6)begin
        l3_req_6[0] = 1;
        l3_req_6[3:1] = 0;
        l3_out_ready_6_1 = 1;
        l3_out_ready_6_2 = 1;
        l3_out_ready_6_3 = 1;
    end else begin
        if(l3_out_valid_6_0 & (l3_out_data_6_0.data == l3_cache_6_0) 
          & !l3_out_data_6_0.last)begin
            l3_out_ready_6_0 = 1;
        end
        if(l3_out_valid_6_1 & (l3_out_data_6_1.data == l3_cache_6_1) 
          & !l3_out_data_6_1.last)begin
            l3_out_ready_6_1 = 1;
        end
        if(l3_out_valid_6_2 & (l3_out_data_6_2.data == l3_cache_6_2) 
          & !l3_out_data_6_2.last)begin
            l3_out_ready_6_2 = 1;
        end
        if(l3_out_valid_6_3 & (l3_out_data_6_3.data == l3_cache_6_3) 
          & !l3_out_data_6_3.last)begin
            l3_out_ready_6_3 = 1;
        end

    end
end

always @(posedge clk)begin
    if(rst)begin
        l3_cache_6_0 <= 0;
        l3_cache_6_1 <= 0;
        l3_cache_6_2 <= 0;
        l3_cache_6_3 <= 0;
    end else begin
        if(l3_all_last_6)begin
            l3_cache_6_0 <= 0;
            l3_cache_6_1 <= 0;
            l3_cache_6_2 <= 0;
            l3_cache_6_3 <= 0;
        end else begin
            if(l3_out_valid_6_0 & l3_out_ready_6_0)begin
                l3_cache_6_0 <= l3_out_data_6_0.data;
            end
            if(l3_out_valid_6_1 & l3_out_ready_6_1)begin
                l3_cache_6_1 <= l3_out_data_6_1.data;
            end
            if(l3_out_valid_6_2 & l3_out_ready_6_2)begin
                l3_cache_6_2 <= l3_out_data_6_2.data;
            end
            if(l3_out_valid_6_3 & l3_out_ready_6_3)begin
                l3_cache_6_3 <= l3_out_data_6_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l4_in_valid_6 <= 0;
    end else begin
        //sync case
        if(l3_all_last_6) begin
            l4_in_valid_6 <= 1;
        //normal case
        end else begin
            l4_in_valid_6 <= |l3_grant_6;
        end
    end
    //sync case
    if(l3_all_last_6) begin
        l4_in_data_6.last <= 1;
        l4_in_data_6.data <= 0;
    //normal case
    end else begin
        case(l3_grant_6)
            4'b0001: l4_in_data_6 <= l3_out_data_6_0;
            4'b0010: l4_in_data_6 <= l3_out_data_6_1;
            4'b0100: l4_in_data_6 <= l3_out_data_6_2;
            4'b1000: l4_in_data_6 <= l3_out_data_6_3;
            default: l4_in_data_6 <= 0;
        endcase
    end   
end

assign l3_all_last_7 =  (l3_out_data_7_0.last & l3_out_valid_7_0) &  (l3_out_data_7_1.last & l3_out_valid_7_1) &  (l3_out_data_7_2.last & l3_out_valid_7_2) &  (l3_out_data_7_3.last & l3_out_valid_7_3) &  !l4_almost_full_7;
assign l3_same_7 =  l3_out_valid_7_0 &  l3_out_valid_7_1 &  l3_out_valid_7_2 &  l3_out_valid_7_3 &  !l4_almost_full_7 &
                       (l3_out_data_7_0==l3_out_data_7_1) & (l3_out_data_7_0==l3_out_data_7_2) & (l3_out_data_7_0==l3_out_data_7_3);
assign l3_newdata_7_0 = l3_out_valid_7_0 & (l3_out_data_7_0.data != l3_cache_7_0) & !l3_out_data_7_0.last;
assign l3_newdata_7_1 = l3_out_valid_7_1 & (l3_out_data_7_1.data != l3_cache_7_1) & !l3_out_data_7_1.last;
assign l3_newdata_7_2 = l3_out_valid_7_2 & (l3_out_data_7_2.data != l3_cache_7_2) & !l3_out_data_7_2.last;
assign l3_newdata_7_3 = l3_out_valid_7_3 & (l3_out_data_7_3.data != l3_cache_7_3) & !l3_out_data_7_3.last;
//generate request, combinationally logic
always @(*)begin
    l3_req_7[0] = l3_newdata_7_0 & !l4_almost_full_7;
    l3_out_ready_7_0 = l3_grant_7[0];       
    l3_req_7[1] = l3_newdata_7_1 & !l4_almost_full_7;
    l3_out_ready_7_1 = l3_grant_7[1];       
    l3_req_7[2] = l3_newdata_7_2 & !l4_almost_full_7;
    l3_out_ready_7_2 = l3_grant_7[2];       
    l3_req_7[3] = l3_newdata_7_3 & !l4_almost_full_7;
    l3_out_ready_7_3 = l3_grant_7[3];       
    //sync case
    if(l3_all_last_7) begin
        l3_req_7 = 0;
        l3_out_ready_7_0 = 1;
        l3_out_ready_7_1 = 1;
        l3_out_ready_7_2 = 1;
        l3_out_ready_7_3 = 1;
    end else if (l3_same_7)begin
        l3_req_7[0] = 1;
        l3_req_7[3:1] = 0;
        l3_out_ready_7_1 = 1;
        l3_out_ready_7_2 = 1;
        l3_out_ready_7_3 = 1;
    end else begin
        if(l3_out_valid_7_0 & (l3_out_data_7_0.data == l3_cache_7_0) 
          & !l3_out_data_7_0.last)begin
            l3_out_ready_7_0 = 1;
        end
        if(l3_out_valid_7_1 & (l3_out_data_7_1.data == l3_cache_7_1) 
          & !l3_out_data_7_1.last)begin
            l3_out_ready_7_1 = 1;
        end
        if(l3_out_valid_7_2 & (l3_out_data_7_2.data == l3_cache_7_2) 
          & !l3_out_data_7_2.last)begin
            l3_out_ready_7_2 = 1;
        end
        if(l3_out_valid_7_3 & (l3_out_data_7_3.data == l3_cache_7_3) 
          & !l3_out_data_7_3.last)begin
            l3_out_ready_7_3 = 1;
        end

    end
end

always @(posedge clk)begin
    if(rst)begin
        l3_cache_7_0 <= 0;
        l3_cache_7_1 <= 0;
        l3_cache_7_2 <= 0;
        l3_cache_7_3 <= 0;
    end else begin
        if(l3_all_last_7)begin
            l3_cache_7_0 <= 0;
            l3_cache_7_1 <= 0;
            l3_cache_7_2 <= 0;
            l3_cache_7_3 <= 0;
        end else begin
            if(l3_out_valid_7_0 & l3_out_ready_7_0)begin
                l3_cache_7_0 <= l3_out_data_7_0.data;
            end
            if(l3_out_valid_7_1 & l3_out_ready_7_1)begin
                l3_cache_7_1 <= l3_out_data_7_1.data;
            end
            if(l3_out_valid_7_2 & l3_out_ready_7_2)begin
                l3_cache_7_2 <= l3_out_data_7_2.data;
            end
            if(l3_out_valid_7_3 & l3_out_ready_7_3)begin
                l3_cache_7_3 <= l3_out_data_7_3.data;
            end
        end
    end
end

//dequeue FIFO and write to next FIFO
always @(posedge clk)begin
    if(rst)begin
        l4_in_valid_7 <= 0;
    end else begin
        //sync case
        if(l3_all_last_7) begin
            l4_in_valid_7 <= 1;
        //normal case
        end else begin
            l4_in_valid_7 <= |l3_grant_7;
        end
    end
    //sync case
    if(l3_all_last_7) begin
        l4_in_data_7.last <= 1;
        l4_in_data_7.data <= 0;
    //normal case
    end else begin
        case(l3_grant_7)
            4'b0001: l4_in_data_7 <= l3_out_data_7_0;
            4'b0010: l4_in_data_7 <= l3_out_data_7_1;
            4'b0100: l4_in_data_7 <= l3_out_data_7_2;
            4'b1000: l4_in_data_7 <= l3_out_data_7_3;
            default: l4_in_data_7 <= 0;
        endcase
    end   
end


//BACK, after arbiter
assign all_last =  l4_out_data_0.last & l4_out_valid_0 &  l4_out_data_1.last & l4_out_valid_1 &  l4_out_data_2.last & l4_out_valid_2 &  l4_out_data_3.last & l4_out_valid_3 &  l4_out_data_4.last & l4_out_valid_4 &  l4_out_data_5.last & l4_out_valid_5 &  l4_out_data_6.last & l4_out_valid_6 &  l4_out_data_7.last & l4_out_valid_7 &  !ruleID_almost_full;

always @(posedge clk)begin
    if(all_last_r3)begin
        ruleID[15:0] <= 0;
    end else begin
        if(ht_rd_0_valid)begin
            ruleID[15:0] <= ht_data_0;
        end else begin
            ruleID[15:0] <= 0;
        end
    end
    if(all_last_r3)begin
        ruleID[31:16] <= 0;
    end else begin
        if(ht_rd_1_valid)begin
            ruleID[31:16] <= ht_data_1;
        end else begin
            ruleID[31:16] <= 0;
        end
    end
    if(all_last_r3)begin
        ruleID[47:32] <= 0;
    end else begin
        if(ht_rd_2_valid)begin
            ruleID[47:32] <= ht_data_2;
        end else begin
            ruleID[47:32] <= 0;
        end
    end
    if(all_last_r3)begin
        ruleID[63:48] <= 0;
    end else begin
        if(ht_rd_3_valid)begin
            ruleID[63:48] <= ht_data_3;
        end else begin
            ruleID[63:48] <= 0;
        end
    end
    if(all_last_r3)begin
        ruleID[79:64] <= 0;
    end else begin
        if(ht_rd_4_valid)begin
            ruleID[79:64] <= ht_data_4;
        end else begin
            ruleID[79:64] <= 0;
        end
    end
    if(all_last_r3)begin
        ruleID[95:80] <= 0;
    end else begin
        if(ht_rd_5_valid)begin
            ruleID[95:80] <= ht_data_5;
        end else begin
            ruleID[95:80] <= 0;
        end
    end
    if(all_last_r3)begin
        ruleID[111:96] <= 0;
    end else begin
        if(ht_rd_6_valid)begin
            ruleID[111:96] <= ht_data_6;
        end else begin
            ruleID[111:96] <= 0;
        end
    end
    if(all_last_r3)begin
        ruleID[127:112] <= 0;
    end else begin
        if(ht_rd_7_valid)begin
            ruleID[127:112] <= ht_data_7;
        end else begin
            ruleID[127:112] <= 0;
        end
    end
end

always @(posedge clk)begin
    if(rst)begin
        ruleID_last <= 0;
        ruleID_valid <= 0;
    end else begin
        //sync case
        if(all_last_r3) begin
            ruleID_last <= 1;
            ruleID_valid <= 1;
 
        //normal case
        end else begin
            ruleID_last <= 0;
            //any dequeue 
            ruleID_valid <=  (ht_rd_0_valid) |  (ht_rd_1_valid) |  (ht_rd_2_valid) |  (ht_rd_3_valid) |  (ht_rd_4_valid) |  (ht_rd_5_valid) |  (ht_rd_6_valid) |  (ht_rd_7_valid) |  0;
        end
    end
end

always @(*)begin
    l4_out_ready_0 = l4_out_valid_0 & !l4_out_data_0.last & !ruleID_almost_full;
    l4_out_ready_1 = l4_out_valid_1 & !l4_out_data_1.last & !ruleID_almost_full;
    l4_out_ready_2 = l4_out_valid_2 & !l4_out_data_2.last & !ruleID_almost_full;
    l4_out_ready_3 = l4_out_valid_3 & !l4_out_data_3.last & !ruleID_almost_full;
    l4_out_ready_4 = l4_out_valid_4 & !l4_out_data_4.last & !ruleID_almost_full;
    l4_out_ready_5 = l4_out_valid_5 & !l4_out_data_5.last & !ruleID_almost_full;
    l4_out_ready_6 = l4_out_valid_6 & !l4_out_data_6.last & !ruleID_almost_full;
    l4_out_ready_7 = l4_out_valid_7 & !l4_out_data_7.last & !ruleID_almost_full;
    //sync case
    if(all_last) begin
        l4_out_ready_0 = !ruleID_almost_full; 
        l4_out_ready_1 = !ruleID_almost_full; 
        l4_out_ready_2 = !ruleID_almost_full; 
        l4_out_ready_3 = !ruleID_almost_full; 
        l4_out_ready_4 = !ruleID_almost_full; 
        l4_out_ready_5 = !ruleID_almost_full; 
        l4_out_ready_6 = !ruleID_almost_full; 
        l4_out_ready_7 = !ruleID_almost_full; 
    end
end

//For every rule, fetch the RULE ID from table. 
assign ht_addr_0 = l4_out_data_0.data;
assign ht_rd_0 = l4_out_valid_0 & !l4_out_data_0.last & !ruleID_almost_full & (l4_out_data_0.data!=l4_cache_0);
assign ht_addr_1 = l4_out_data_1.data;
assign ht_rd_1 = l4_out_valid_1 & !l4_out_data_1.last & !ruleID_almost_full & (l4_out_data_1.data!=l4_cache_1);
assign ht_addr_2 = l4_out_data_2.data;
assign ht_rd_2 = l4_out_valid_2 & !l4_out_data_2.last & !ruleID_almost_full & (l4_out_data_2.data!=l4_cache_2);
assign ht_addr_3 = l4_out_data_3.data;
assign ht_rd_3 = l4_out_valid_3 & !l4_out_data_3.last & !ruleID_almost_full & (l4_out_data_3.data!=l4_cache_3);
assign ht_addr_4 = l4_out_data_4.data;
assign ht_rd_4 = l4_out_valid_4 & !l4_out_data_4.last & !ruleID_almost_full & (l4_out_data_4.data!=l4_cache_4);
assign ht_addr_5 = l4_out_data_5.data;
assign ht_rd_5 = l4_out_valid_5 & !l4_out_data_5.last & !ruleID_almost_full & (l4_out_data_5.data!=l4_cache_5);
assign ht_addr_6 = l4_out_data_6.data;
assign ht_rd_6 = l4_out_valid_6 & !l4_out_data_6.last & !ruleID_almost_full & (l4_out_data_6.data!=l4_cache_6);
assign ht_addr_7 = l4_out_data_7.data;
assign ht_rd_7 = l4_out_valid_7 & !l4_out_data_7.last & !ruleID_almost_full & (l4_out_data_7.data!=l4_cache_7);

always @(posedge clk)begin
    if (rst)begin

        l4_cache_0 <= 0;
        l4_cache_1 <= 0;
        l4_cache_2 <= 0;
        l4_cache_3 <= 0;
        l4_cache_4 <= 0;
        l4_cache_5 <= 0;
        l4_cache_6 <= 0;
        l4_cache_7 <= 0;
    end

    all_last_r1 <= all_last;
    all_last_r2 <= all_last_r1;
    all_last_r3 <= all_last_r2;

    if(all_last)begin
        l4_cache_0 <= 0;
    end else begin
        if(l4_out_valid_0 & l4_out_ready_0)begin
            l4_cache_0 <= l4_out_data_0.data;
        end
    end
        
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_0_r1 <= ht_rd_0;
    ht_rd_0_r2 <= ht_rd_0_r1;
    ht_rd_0_valid <= ht_rd_0_r2;
    ht_data_0 <= ht_q_0;
    if(all_last)begin
        l4_cache_1 <= 0;
    end else begin
        if(l4_out_valid_1 & l4_out_ready_1)begin
            l4_cache_1 <= l4_out_data_1.data;
        end
    end
        
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_1_r1 <= ht_rd_1;
    ht_rd_1_r2 <= ht_rd_1_r1;
    ht_rd_1_valid <= ht_rd_1_r2;
    ht_data_1 <= ht_q_1;
    if(all_last)begin
        l4_cache_2 <= 0;
    end else begin
        if(l4_out_valid_2 & l4_out_ready_2)begin
            l4_cache_2 <= l4_out_data_2.data;
        end
    end
        
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_2_r1 <= ht_rd_2;
    ht_rd_2_r2 <= ht_rd_2_r1;
    ht_rd_2_valid <= ht_rd_2_r2;
    ht_data_2 <= ht_q_2;
    if(all_last)begin
        l4_cache_3 <= 0;
    end else begin
        if(l4_out_valid_3 & l4_out_ready_3)begin
            l4_cache_3 <= l4_out_data_3.data;
        end
    end
        
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_3_r1 <= ht_rd_3;
    ht_rd_3_r2 <= ht_rd_3_r1;
    ht_rd_3_valid <= ht_rd_3_r2;
    ht_data_3 <= ht_q_3;
    if(all_last)begin
        l4_cache_4 <= 0;
    end else begin
        if(l4_out_valid_4 & l4_out_ready_4)begin
            l4_cache_4 <= l4_out_data_4.data;
        end
    end
        
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_4_r1 <= ht_rd_4;
    ht_rd_4_r2 <= ht_rd_4_r1;
    ht_rd_4_valid <= ht_rd_4_r2;
    ht_data_4 <= ht_q_4;
    if(all_last)begin
        l4_cache_5 <= 0;
    end else begin
        if(l4_out_valid_5 & l4_out_ready_5)begin
            l4_cache_5 <= l4_out_data_5.data;
        end
    end
        
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_5_r1 <= ht_rd_5;
    ht_rd_5_r2 <= ht_rd_5_r1;
    ht_rd_5_valid <= ht_rd_5_r2;
    ht_data_5 <= ht_q_5;
    if(all_last)begin
        l4_cache_6 <= 0;
    end else begin
        if(l4_out_valid_6 & l4_out_ready_6)begin
            l4_cache_6 <= l4_out_data_6.data;
        end
    end
        
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_6_r1 <= ht_rd_6;
    ht_rd_6_r2 <= ht_rd_6_r1;
    ht_rd_6_valid <= ht_rd_6_r2;
    ht_data_6 <= ht_q_6;
    if(all_last)begin
        l4_cache_7 <= 0;
    end else begin
        if(l4_out_valid_7 & l4_out_ready_7)begin
            l4_cache_7 <= l4_out_data_7.data;
        end
    end
        
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_7_r1 <= ht_rd_7;
    ht_rd_7_r2 <= ht_rd_7_r1;
    ht_rd_7_valid <= ht_rd_7_r2;
    ht_data_7 <= ht_q_7;
end
//L1 FIFO

simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_0_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_0_0),
  .din(din_0_0),
  .din_ready(),

  .dout_valid(l1_valid_0_0),
  .dout(l1_data_0_0),
  .dout_ready(l1_ready_0_0),

  .item_count(din_csr_readdata_0_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_0_0_r2 > L1_TH)
    din_almost_full_0_0 <= 1'b1;
  else
    din_almost_full_0_0 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_0_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_0_1),
  .din(din_0_1),
  .din_ready(),

  .dout_valid(l1_valid_0_1),
  .dout(l1_data_0_1),
  .dout_ready(l1_ready_0_1),

  .item_count(din_csr_readdata_0_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_0_1_r2 > L1_TH)
    din_almost_full_0_1 <= 1'b1;
  else
    din_almost_full_0_1 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_0_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_0_2),
  .din(din_0_2),
  .din_ready(),

  .dout_valid(l1_valid_0_2),
  .dout(l1_data_0_2),
  .dout_ready(l1_ready_0_2),

  .item_count(din_csr_readdata_0_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_0_2_r2 > L1_TH)
    din_almost_full_0_2 <= 1'b1;
  else
    din_almost_full_0_2 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_0_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_0_3),
  .din(din_0_3),
  .din_ready(),

  .dout_valid(l1_valid_0_3),
  .dout(l1_data_0_3),
  .dout_ready(l1_ready_0_3),

  .item_count(din_csr_readdata_0_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_0_3_r2 > L1_TH)
    din_almost_full_0_3 <= 1'b1;
  else
    din_almost_full_0_3 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_0_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_0_4),
  .din(din_0_4),
  .din_ready(),

  .dout_valid(l1_valid_0_4),
  .dout(l1_data_0_4),
  .dout_ready(l1_ready_0_4),

  .item_count(din_csr_readdata_0_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_0_4_r2 > L1_TH)
    din_almost_full_0_4 <= 1'b1;
  else
    din_almost_full_0_4 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_0_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_0_5),
  .din(din_0_5),
  .din_ready(),

  .dout_valid(l1_valid_0_5),
  .dout(l1_data_0_5),
  .dout_ready(l1_ready_0_5),

  .item_count(din_csr_readdata_0_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_0_5_r2 > L1_TH)
    din_almost_full_0_5 <= 1'b1;
  else
    din_almost_full_0_5 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_0_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_0_6),
  .din(din_0_6),
  .din_ready(),

  .dout_valid(l1_valid_0_6),
  .dout(l1_data_0_6),
  .dout_ready(l1_ready_0_6),

  .item_count(din_csr_readdata_0_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_0_6_r2 > L1_TH)
    din_almost_full_0_6 <= 1'b1;
  else
    din_almost_full_0_6 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_0_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_0_7),
  .din(din_0_7),
  .din_ready(),

  .dout_valid(l1_valid_0_7),
  .dout(l1_data_0_7),
  .dout_ready(l1_ready_0_7),

  .item_count(din_csr_readdata_0_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_0_7_r2 > L1_TH)
    din_almost_full_0_7 <= 1'b1;
  else
    din_almost_full_0_7 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_1_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_1_0),
  .din(din_1_0),
  .din_ready(),

  .dout_valid(l1_valid_1_0),
  .dout(l1_data_1_0),
  .dout_ready(l1_ready_1_0),

  .item_count(din_csr_readdata_1_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_1_0_r2 > L1_TH)
    din_almost_full_1_0 <= 1'b1;
  else
    din_almost_full_1_0 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_1_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_1_1),
  .din(din_1_1),
  .din_ready(),

  .dout_valid(l1_valid_1_1),
  .dout(l1_data_1_1),
  .dout_ready(l1_ready_1_1),

  .item_count(din_csr_readdata_1_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_1_1_r2 > L1_TH)
    din_almost_full_1_1 <= 1'b1;
  else
    din_almost_full_1_1 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_1_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_1_2),
  .din(din_1_2),
  .din_ready(),

  .dout_valid(l1_valid_1_2),
  .dout(l1_data_1_2),
  .dout_ready(l1_ready_1_2),

  .item_count(din_csr_readdata_1_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_1_2_r2 > L1_TH)
    din_almost_full_1_2 <= 1'b1;
  else
    din_almost_full_1_2 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_1_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_1_3),
  .din(din_1_3),
  .din_ready(),

  .dout_valid(l1_valid_1_3),
  .dout(l1_data_1_3),
  .dout_ready(l1_ready_1_3),

  .item_count(din_csr_readdata_1_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_1_3_r2 > L1_TH)
    din_almost_full_1_3 <= 1'b1;
  else
    din_almost_full_1_3 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_1_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_1_4),
  .din(din_1_4),
  .din_ready(),

  .dout_valid(l1_valid_1_4),
  .dout(l1_data_1_4),
  .dout_ready(l1_ready_1_4),

  .item_count(din_csr_readdata_1_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_1_4_r2 > L1_TH)
    din_almost_full_1_4 <= 1'b1;
  else
    din_almost_full_1_4 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_1_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_1_5),
  .din(din_1_5),
  .din_ready(),

  .dout_valid(l1_valid_1_5),
  .dout(l1_data_1_5),
  .dout_ready(l1_ready_1_5),

  .item_count(din_csr_readdata_1_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_1_5_r2 > L1_TH)
    din_almost_full_1_5 <= 1'b1;
  else
    din_almost_full_1_5 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_1_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_1_6),
  .din(din_1_6),
  .din_ready(),

  .dout_valid(l1_valid_1_6),
  .dout(l1_data_1_6),
  .dout_ready(l1_ready_1_6),

  .item_count(din_csr_readdata_1_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_1_6_r2 > L1_TH)
    din_almost_full_1_6 <= 1'b1;
  else
    din_almost_full_1_6 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_1_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_1_7),
  .din(din_1_7),
  .din_ready(),

  .dout_valid(l1_valid_1_7),
  .dout(l1_data_1_7),
  .dout_ready(l1_ready_1_7),

  .item_count(din_csr_readdata_1_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_1_7_r2 > L1_TH)
    din_almost_full_1_7 <= 1'b1;
  else
    din_almost_full_1_7 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_2_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_2_0),
  .din(din_2_0),
  .din_ready(),

  .dout_valid(l1_valid_2_0),
  .dout(l1_data_2_0),
  .dout_ready(l1_ready_2_0),

  .item_count(din_csr_readdata_2_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_2_0_r2 > L1_TH)
    din_almost_full_2_0 <= 1'b1;
  else
    din_almost_full_2_0 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_2_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_2_1),
  .din(din_2_1),
  .din_ready(),

  .dout_valid(l1_valid_2_1),
  .dout(l1_data_2_1),
  .dout_ready(l1_ready_2_1),

  .item_count(din_csr_readdata_2_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_2_1_r2 > L1_TH)
    din_almost_full_2_1 <= 1'b1;
  else
    din_almost_full_2_1 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_2_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_2_2),
  .din(din_2_2),
  .din_ready(),

  .dout_valid(l1_valid_2_2),
  .dout(l1_data_2_2),
  .dout_ready(l1_ready_2_2),

  .item_count(din_csr_readdata_2_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_2_2_r2 > L1_TH)
    din_almost_full_2_2 <= 1'b1;
  else
    din_almost_full_2_2 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_2_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_2_3),
  .din(din_2_3),
  .din_ready(),

  .dout_valid(l1_valid_2_3),
  .dout(l1_data_2_3),
  .dout_ready(l1_ready_2_3),

  .item_count(din_csr_readdata_2_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_2_3_r2 > L1_TH)
    din_almost_full_2_3 <= 1'b1;
  else
    din_almost_full_2_3 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_2_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_2_4),
  .din(din_2_4),
  .din_ready(),

  .dout_valid(l1_valid_2_4),
  .dout(l1_data_2_4),
  .dout_ready(l1_ready_2_4),

  .item_count(din_csr_readdata_2_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_2_4_r2 > L1_TH)
    din_almost_full_2_4 <= 1'b1;
  else
    din_almost_full_2_4 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_2_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_2_5),
  .din(din_2_5),
  .din_ready(),

  .dout_valid(l1_valid_2_5),
  .dout(l1_data_2_5),
  .dout_ready(l1_ready_2_5),

  .item_count(din_csr_readdata_2_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_2_5_r2 > L1_TH)
    din_almost_full_2_5 <= 1'b1;
  else
    din_almost_full_2_5 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_2_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_2_6),
  .din(din_2_6),
  .din_ready(),

  .dout_valid(l1_valid_2_6),
  .dout(l1_data_2_6),
  .dout_ready(l1_ready_2_6),

  .item_count(din_csr_readdata_2_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_2_6_r2 > L1_TH)
    din_almost_full_2_6 <= 1'b1;
  else
    din_almost_full_2_6 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_2_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_2_7),
  .din(din_2_7),
  .din_ready(),

  .dout_valid(l1_valid_2_7),
  .dout(l1_data_2_7),
  .dout_ready(l1_ready_2_7),

  .item_count(din_csr_readdata_2_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_2_7_r2 > L1_TH)
    din_almost_full_2_7 <= 1'b1;
  else
    din_almost_full_2_7 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_3_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_3_0),
  .din(din_3_0),
  .din_ready(),

  .dout_valid(l1_valid_3_0),
  .dout(l1_data_3_0),
  .dout_ready(l1_ready_3_0),

  .item_count(din_csr_readdata_3_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_3_0_r2 > L1_TH)
    din_almost_full_3_0 <= 1'b1;
  else
    din_almost_full_3_0 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_3_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_3_1),
  .din(din_3_1),
  .din_ready(),

  .dout_valid(l1_valid_3_1),
  .dout(l1_data_3_1),
  .dout_ready(l1_ready_3_1),

  .item_count(din_csr_readdata_3_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_3_1_r2 > L1_TH)
    din_almost_full_3_1 <= 1'b1;
  else
    din_almost_full_3_1 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_3_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_3_2),
  .din(din_3_2),
  .din_ready(),

  .dout_valid(l1_valid_3_2),
  .dout(l1_data_3_2),
  .dout_ready(l1_ready_3_2),

  .item_count(din_csr_readdata_3_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_3_2_r2 > L1_TH)
    din_almost_full_3_2 <= 1'b1;
  else
    din_almost_full_3_2 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_3_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_3_3),
  .din(din_3_3),
  .din_ready(),

  .dout_valid(l1_valid_3_3),
  .dout(l1_data_3_3),
  .dout_ready(l1_ready_3_3),

  .item_count(din_csr_readdata_3_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_3_3_r2 > L1_TH)
    din_almost_full_3_3 <= 1'b1;
  else
    din_almost_full_3_3 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_3_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_3_4),
  .din(din_3_4),
  .din_ready(),

  .dout_valid(l1_valid_3_4),
  .dout(l1_data_3_4),
  .dout_ready(l1_ready_3_4),

  .item_count(din_csr_readdata_3_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_3_4_r2 > L1_TH)
    din_almost_full_3_4 <= 1'b1;
  else
    din_almost_full_3_4 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_3_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_3_5),
  .din(din_3_5),
  .din_ready(),

  .dout_valid(l1_valid_3_5),
  .dout(l1_data_3_5),
  .dout_ready(l1_ready_3_5),

  .item_count(din_csr_readdata_3_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_3_5_r2 > L1_TH)
    din_almost_full_3_5 <= 1'b1;
  else
    din_almost_full_3_5 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_3_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_3_6),
  .din(din_3_6),
  .din_ready(),

  .dout_valid(l1_valid_3_6),
  .dout(l1_data_3_6),
  .dout_ready(l1_ready_3_6),

  .item_count(din_csr_readdata_3_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_3_6_r2 > L1_TH)
    din_almost_full_3_6 <= 1'b1;
  else
    din_almost_full_3_6 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_3_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_3_7),
  .din(din_3_7),
  .din_ready(),

  .dout_valid(l1_valid_3_7),
  .dout(l1_data_3_7),
  .dout_ready(l1_ready_3_7),

  .item_count(din_csr_readdata_3_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_3_7_r2 > L1_TH)
    din_almost_full_3_7 <= 1'b1;
  else
    din_almost_full_3_7 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_4_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_4_0),
  .din(din_4_0),
  .din_ready(),

  .dout_valid(l1_valid_4_0),
  .dout(l1_data_4_0),
  .dout_ready(l1_ready_4_0),

  .item_count(din_csr_readdata_4_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_4_0_r2 > L1_TH)
    din_almost_full_4_0 <= 1'b1;
  else
    din_almost_full_4_0 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_4_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_4_1),
  .din(din_4_1),
  .din_ready(),

  .dout_valid(l1_valid_4_1),
  .dout(l1_data_4_1),
  .dout_ready(l1_ready_4_1),

  .item_count(din_csr_readdata_4_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_4_1_r2 > L1_TH)
    din_almost_full_4_1 <= 1'b1;
  else
    din_almost_full_4_1 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_4_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_4_2),
  .din(din_4_2),
  .din_ready(),

  .dout_valid(l1_valid_4_2),
  .dout(l1_data_4_2),
  .dout_ready(l1_ready_4_2),

  .item_count(din_csr_readdata_4_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_4_2_r2 > L1_TH)
    din_almost_full_4_2 <= 1'b1;
  else
    din_almost_full_4_2 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_4_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_4_3),
  .din(din_4_3),
  .din_ready(),

  .dout_valid(l1_valid_4_3),
  .dout(l1_data_4_3),
  .dout_ready(l1_ready_4_3),

  .item_count(din_csr_readdata_4_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_4_3_r2 > L1_TH)
    din_almost_full_4_3 <= 1'b1;
  else
    din_almost_full_4_3 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_4_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_4_4),
  .din(din_4_4),
  .din_ready(),

  .dout_valid(l1_valid_4_4),
  .dout(l1_data_4_4),
  .dout_ready(l1_ready_4_4),

  .item_count(din_csr_readdata_4_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_4_4_r2 > L1_TH)
    din_almost_full_4_4 <= 1'b1;
  else
    din_almost_full_4_4 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_4_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_4_5),
  .din(din_4_5),
  .din_ready(),

  .dout_valid(l1_valid_4_5),
  .dout(l1_data_4_5),
  .dout_ready(l1_ready_4_5),

  .item_count(din_csr_readdata_4_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_4_5_r2 > L1_TH)
    din_almost_full_4_5 <= 1'b1;
  else
    din_almost_full_4_5 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_4_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_4_6),
  .din(din_4_6),
  .din_ready(),

  .dout_valid(l1_valid_4_6),
  .dout(l1_data_4_6),
  .dout_ready(l1_ready_4_6),

  .item_count(din_csr_readdata_4_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_4_6_r2 > L1_TH)
    din_almost_full_4_6 <= 1'b1;
  else
    din_almost_full_4_6 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_4_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_4_7),
  .din(din_4_7),
  .din_ready(),

  .dout_valid(l1_valid_4_7),
  .dout(l1_data_4_7),
  .dout_ready(l1_ready_4_7),

  .item_count(din_csr_readdata_4_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_4_7_r2 > L1_TH)
    din_almost_full_4_7 <= 1'b1;
  else
    din_almost_full_4_7 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_5_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_5_0),
  .din(din_5_0),
  .din_ready(),

  .dout_valid(l1_valid_5_0),
  .dout(l1_data_5_0),
  .dout_ready(l1_ready_5_0),

  .item_count(din_csr_readdata_5_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_5_0_r2 > L1_TH)
    din_almost_full_5_0 <= 1'b1;
  else
    din_almost_full_5_0 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_5_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_5_1),
  .din(din_5_1),
  .din_ready(),

  .dout_valid(l1_valid_5_1),
  .dout(l1_data_5_1),
  .dout_ready(l1_ready_5_1),

  .item_count(din_csr_readdata_5_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_5_1_r2 > L1_TH)
    din_almost_full_5_1 <= 1'b1;
  else
    din_almost_full_5_1 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_5_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_5_2),
  .din(din_5_2),
  .din_ready(),

  .dout_valid(l1_valid_5_2),
  .dout(l1_data_5_2),
  .dout_ready(l1_ready_5_2),

  .item_count(din_csr_readdata_5_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_5_2_r2 > L1_TH)
    din_almost_full_5_2 <= 1'b1;
  else
    din_almost_full_5_2 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_5_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_5_3),
  .din(din_5_3),
  .din_ready(),

  .dout_valid(l1_valid_5_3),
  .dout(l1_data_5_3),
  .dout_ready(l1_ready_5_3),

  .item_count(din_csr_readdata_5_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_5_3_r2 > L1_TH)
    din_almost_full_5_3 <= 1'b1;
  else
    din_almost_full_5_3 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_5_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_5_4),
  .din(din_5_4),
  .din_ready(),

  .dout_valid(l1_valid_5_4),
  .dout(l1_data_5_4),
  .dout_ready(l1_ready_5_4),

  .item_count(din_csr_readdata_5_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_5_4_r2 > L1_TH)
    din_almost_full_5_4 <= 1'b1;
  else
    din_almost_full_5_4 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_5_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_5_5),
  .din(din_5_5),
  .din_ready(),

  .dout_valid(l1_valid_5_5),
  .dout(l1_data_5_5),
  .dout_ready(l1_ready_5_5),

  .item_count(din_csr_readdata_5_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_5_5_r2 > L1_TH)
    din_almost_full_5_5 <= 1'b1;
  else
    din_almost_full_5_5 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_5_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_5_6),
  .din(din_5_6),
  .din_ready(),

  .dout_valid(l1_valid_5_6),
  .dout(l1_data_5_6),
  .dout_ready(l1_ready_5_6),

  .item_count(din_csr_readdata_5_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_5_6_r2 > L1_TH)
    din_almost_full_5_6 <= 1'b1;
  else
    din_almost_full_5_6 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_5_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_5_7),
  .din(din_5_7),
  .din_ready(),

  .dout_valid(l1_valid_5_7),
  .dout(l1_data_5_7),
  .dout_ready(l1_ready_5_7),

  .item_count(din_csr_readdata_5_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_5_7_r2 > L1_TH)
    din_almost_full_5_7 <= 1'b1;
  else
    din_almost_full_5_7 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_6_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_6_0),
  .din(din_6_0),
  .din_ready(),

  .dout_valid(l1_valid_6_0),
  .dout(l1_data_6_0),
  .dout_ready(l1_ready_6_0),

  .item_count(din_csr_readdata_6_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_6_0_r2 > L1_TH)
    din_almost_full_6_0 <= 1'b1;
  else
    din_almost_full_6_0 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_6_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_6_1),
  .din(din_6_1),
  .din_ready(),

  .dout_valid(l1_valid_6_1),
  .dout(l1_data_6_1),
  .dout_ready(l1_ready_6_1),

  .item_count(din_csr_readdata_6_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_6_1_r2 > L1_TH)
    din_almost_full_6_1 <= 1'b1;
  else
    din_almost_full_6_1 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_6_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_6_2),
  .din(din_6_2),
  .din_ready(),

  .dout_valid(l1_valid_6_2),
  .dout(l1_data_6_2),
  .dout_ready(l1_ready_6_2),

  .item_count(din_csr_readdata_6_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_6_2_r2 > L1_TH)
    din_almost_full_6_2 <= 1'b1;
  else
    din_almost_full_6_2 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_6_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_6_3),
  .din(din_6_3),
  .din_ready(),

  .dout_valid(l1_valid_6_3),
  .dout(l1_data_6_3),
  .dout_ready(l1_ready_6_3),

  .item_count(din_csr_readdata_6_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_6_3_r2 > L1_TH)
    din_almost_full_6_3 <= 1'b1;
  else
    din_almost_full_6_3 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_6_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_6_4),
  .din(din_6_4),
  .din_ready(),

  .dout_valid(l1_valid_6_4),
  .dout(l1_data_6_4),
  .dout_ready(l1_ready_6_4),

  .item_count(din_csr_readdata_6_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_6_4_r2 > L1_TH)
    din_almost_full_6_4 <= 1'b1;
  else
    din_almost_full_6_4 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_6_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_6_5),
  .din(din_6_5),
  .din_ready(),

  .dout_valid(l1_valid_6_5),
  .dout(l1_data_6_5),
  .dout_ready(l1_ready_6_5),

  .item_count(din_csr_readdata_6_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_6_5_r2 > L1_TH)
    din_almost_full_6_5 <= 1'b1;
  else
    din_almost_full_6_5 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_6_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_6_6),
  .din(din_6_6),
  .din_ready(),

  .dout_valid(l1_valid_6_6),
  .dout(l1_data_6_6),
  .dout_ready(l1_ready_6_6),

  .item_count(din_csr_readdata_6_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_6_6_r2 > L1_TH)
    din_almost_full_6_6 <= 1'b1;
  else
    din_almost_full_6_6 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_6_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_6_7),
  .din(din_6_7),
  .din_ready(),

  .dout_valid(l1_valid_6_7),
  .dout(l1_data_6_7),
  .dout_ready(l1_ready_6_7),

  .item_count(din_csr_readdata_6_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_6_7_r2 > L1_TH)
    din_almost_full_6_7 <= 1'b1;
  else
    din_almost_full_6_7 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_7_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_7_0),
  .din(din_7_0),
  .din_ready(),

  .dout_valid(l1_valid_7_0),
  .dout(l1_data_7_0),
  .dout_ready(l1_ready_7_0),

  .item_count(din_csr_readdata_7_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_7_0_r2 > L1_TH)
    din_almost_full_7_0 <= 1'b1;
  else
    din_almost_full_7_0 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_7_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_7_1),
  .din(din_7_1),
  .din_ready(),

  .dout_valid(l1_valid_7_1),
  .dout(l1_data_7_1),
  .dout_ready(l1_ready_7_1),

  .item_count(din_csr_readdata_7_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_7_1_r2 > L1_TH)
    din_almost_full_7_1 <= 1'b1;
  else
    din_almost_full_7_1 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_7_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_7_2),
  .din(din_7_2),
  .din_ready(),

  .dout_valid(l1_valid_7_2),
  .dout(l1_data_7_2),
  .dout_ready(l1_ready_7_2),

  .item_count(din_csr_readdata_7_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_7_2_r2 > L1_TH)
    din_almost_full_7_2 <= 1'b1;
  else
    din_almost_full_7_2 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_7_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_7_3),
  .din(din_7_3),
  .din_ready(),

  .dout_valid(l1_valid_7_3),
  .dout(l1_data_7_3),
  .dout_ready(l1_ready_7_3),

  .item_count(din_csr_readdata_7_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_7_3_r2 > L1_TH)
    din_almost_full_7_3 <= 1'b1;
  else
    din_almost_full_7_3 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_7_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_7_4),
  .din(din_7_4),
  .din_ready(),

  .dout_valid(l1_valid_7_4),
  .dout(l1_data_7_4),
  .dout_ready(l1_ready_7_4),

  .item_count(din_csr_readdata_7_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_7_4_r2 > L1_TH)
    din_almost_full_7_4 <= 1'b1;
  else
    din_almost_full_7_4 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_7_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_7_5),
  .din(din_7_5),
  .din_ready(),

  .dout_valid(l1_valid_7_5),
  .dout(l1_data_7_5),
  .dout_ready(l1_ready_7_5),

  .item_count(din_csr_readdata_7_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_7_5_r2 > L1_TH)
    din_almost_full_7_5 <= 1'b1;
  else
    din_almost_full_7_5 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_7_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_7_6),
  .din(din_7_6),
  .din_ready(),

  .dout_valid(l1_valid_7_6),
  .dout(l1_data_7_6),
  .dout_ready(l1_ready_7_6),

  .item_count(din_csr_readdata_7_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_7_6_r2 > L1_TH)
    din_almost_full_7_6 <= 1'b1;
  else
    din_almost_full_7_6 <= 1'b0;


simple_fifo # (
  .ADDR_WIDTH($clog2(L1_FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l1_dc_fifo_mlab_7_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(din_valid_7_7),
  .din(din_7_7),
  .din_ready(),

  .dout_valid(l1_valid_7_7),
  .dout(l1_data_7_7),
  .dout_ready(l1_ready_7_7),

  .item_count(din_csr_readdata_7_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (din_csr_readdata_7_7_r2 > L1_TH)
    din_almost_full_7_7 <= 1'b1;
  else
    din_almost_full_7_7 <= 1'b0;


//L2 FIFO and L1 ARB
rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_0),
    .grant  (l1_grant_0_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_0),
  .din(l2_in_data_0_0),
  .din_ready(l2_in_ready_0_0),

  .dout_valid(l2_out_valid_0_0),
  .dout(l2_out_data_0_0),
  .dout_ready(l2_out_ready_0_0),

  .item_count(l2_csr_readdata_0_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_0 > L2_TH)
    l2_almost_full_0_0 <= 1'b1;
  else
    l2_almost_full_0_0 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_1),
    .grant  (l1_grant_0_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_1),
  .din(l2_in_data_0_1),
  .din_ready(l2_in_ready_0_1),

  .dout_valid(l2_out_valid_0_1),
  .dout(l2_out_data_0_1),
  .dout_ready(l2_out_ready_0_1),

  .item_count(l2_csr_readdata_0_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_1 > L2_TH)
    l2_almost_full_0_1 <= 1'b1;
  else
    l2_almost_full_0_1 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_2),
    .grant  (l1_grant_0_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_2),
  .din(l2_in_data_0_2),
  .din_ready(l2_in_ready_0_2),

  .dout_valid(l2_out_valid_0_2),
  .dout(l2_out_data_0_2),
  .dout_ready(l2_out_ready_0_2),

  .item_count(l2_csr_readdata_0_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_2 > L2_TH)
    l2_almost_full_0_2 <= 1'b1;
  else
    l2_almost_full_0_2 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_3),
    .grant  (l1_grant_0_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_3),
  .din(l2_in_data_0_3),
  .din_ready(l2_in_ready_0_3),

  .dout_valid(l2_out_valid_0_3),
  .dout(l2_out_data_0_3),
  .dout_ready(l2_out_ready_0_3),

  .item_count(l2_csr_readdata_0_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_3 > L2_TH)
    l2_almost_full_0_3 <= 1'b1;
  else
    l2_almost_full_0_3 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_4(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_4),
    .grant  (l1_grant_0_4)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_4),
  .din(l2_in_data_0_4),
  .din_ready(l2_in_ready_0_4),

  .dout_valid(l2_out_valid_0_4),
  .dout(l2_out_data_0_4),
  .dout_ready(l2_out_ready_0_4),

  .item_count(l2_csr_readdata_0_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_4 > L2_TH)
    l2_almost_full_0_4 <= 1'b1;
  else
    l2_almost_full_0_4 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_5(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_5),
    .grant  (l1_grant_0_5)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_5),
  .din(l2_in_data_0_5),
  .din_ready(l2_in_ready_0_5),

  .dout_valid(l2_out_valid_0_5),
  .dout(l2_out_data_0_5),
  .dout_ready(l2_out_ready_0_5),

  .item_count(l2_csr_readdata_0_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_5 > L2_TH)
    l2_almost_full_0_5 <= 1'b1;
  else
    l2_almost_full_0_5 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_6(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_6),
    .grant  (l1_grant_0_6)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_6),
  .din(l2_in_data_0_6),
  .din_ready(l2_in_ready_0_6),

  .dout_valid(l2_out_valid_0_6),
  .dout(l2_out_data_0_6),
  .dout_ready(l2_out_ready_0_6),

  .item_count(l2_csr_readdata_0_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_6 > L2_TH)
    l2_almost_full_0_6 <= 1'b1;
  else
    l2_almost_full_0_6 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_7(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_7),
    .grant  (l1_grant_0_7)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_7),
  .din(l2_in_data_0_7),
  .din_ready(l2_in_ready_0_7),

  .dout_valid(l2_out_valid_0_7),
  .dout(l2_out_data_0_7),
  .dout_ready(l2_out_ready_0_7),

  .item_count(l2_csr_readdata_0_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_7 > L2_TH)
    l2_almost_full_0_7 <= 1'b1;
  else
    l2_almost_full_0_7 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_8(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_8),
    .grant  (l1_grant_0_8)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_8 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_8),
  .din(l2_in_data_0_8),
  .din_ready(l2_in_ready_0_8),

  .dout_valid(l2_out_valid_0_8),
  .dout(l2_out_data_0_8),
  .dout_ready(l2_out_ready_0_8),

  .item_count(l2_csr_readdata_0_8),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_8 > L2_TH)
    l2_almost_full_0_8 <= 1'b1;
  else
    l2_almost_full_0_8 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_9(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_9),
    .grant  (l1_grant_0_9)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_9 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_9),
  .din(l2_in_data_0_9),
  .din_ready(l2_in_ready_0_9),

  .dout_valid(l2_out_valid_0_9),
  .dout(l2_out_data_0_9),
  .dout_ready(l2_out_ready_0_9),

  .item_count(l2_csr_readdata_0_9),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_9 > L2_TH)
    l2_almost_full_0_9 <= 1'b1;
  else
    l2_almost_full_0_9 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_10(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_10),
    .grant  (l1_grant_0_10)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_10 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_10),
  .din(l2_in_data_0_10),
  .din_ready(l2_in_ready_0_10),

  .dout_valid(l2_out_valid_0_10),
  .dout(l2_out_data_0_10),
  .dout_ready(l2_out_ready_0_10),

  .item_count(l2_csr_readdata_0_10),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_10 > L2_TH)
    l2_almost_full_0_10 <= 1'b1;
  else
    l2_almost_full_0_10 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_11(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_11),
    .grant  (l1_grant_0_11)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_11 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_11),
  .din(l2_in_data_0_11),
  .din_ready(l2_in_ready_0_11),

  .dout_valid(l2_out_valid_0_11),
  .dout(l2_out_data_0_11),
  .dout_ready(l2_out_ready_0_11),

  .item_count(l2_csr_readdata_0_11),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_11 > L2_TH)
    l2_almost_full_0_11 <= 1'b1;
  else
    l2_almost_full_0_11 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_12(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_12),
    .grant  (l1_grant_0_12)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_12 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_12),
  .din(l2_in_data_0_12),
  .din_ready(l2_in_ready_0_12),

  .dout_valid(l2_out_valid_0_12),
  .dout(l2_out_data_0_12),
  .dout_ready(l2_out_ready_0_12),

  .item_count(l2_csr_readdata_0_12),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_12 > L2_TH)
    l2_almost_full_0_12 <= 1'b1;
  else
    l2_almost_full_0_12 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_13(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_13),
    .grant  (l1_grant_0_13)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_13 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_13),
  .din(l2_in_data_0_13),
  .din_ready(l2_in_ready_0_13),

  .dout_valid(l2_out_valid_0_13),
  .dout(l2_out_data_0_13),
  .dout_ready(l2_out_ready_0_13),

  .item_count(l2_csr_readdata_0_13),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_13 > L2_TH)
    l2_almost_full_0_13 <= 1'b1;
  else
    l2_almost_full_0_13 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_14(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_14),
    .grant  (l1_grant_0_14)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_14 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_14),
  .din(l2_in_data_0_14),
  .din_ready(l2_in_ready_0_14),

  .dout_valid(l2_out_valid_0_14),
  .dout(l2_out_data_0_14),
  .dout_ready(l2_out_ready_0_14),

  .item_count(l2_csr_readdata_0_14),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_14 > L2_TH)
    l2_almost_full_0_14 <= 1'b1;
  else
    l2_almost_full_0_14 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_0_15(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_0_15),
    .grant  (l1_grant_0_15)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_0_15 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_0_15),
  .din(l2_in_data_0_15),
  .din_ready(l2_in_ready_0_15),

  .dout_valid(l2_out_valid_0_15),
  .dout(l2_out_data_0_15),
  .dout_ready(l2_out_ready_0_15),

  .item_count(l2_csr_readdata_0_15),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_0_15 > L2_TH)
    l2_almost_full_0_15 <= 1'b1;
  else
    l2_almost_full_0_15 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_0),
    .grant  (l1_grant_1_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_0),
  .din(l2_in_data_1_0),
  .din_ready(l2_in_ready_1_0),

  .dout_valid(l2_out_valid_1_0),
  .dout(l2_out_data_1_0),
  .dout_ready(l2_out_ready_1_0),

  .item_count(l2_csr_readdata_1_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_0 > L2_TH)
    l2_almost_full_1_0 <= 1'b1;
  else
    l2_almost_full_1_0 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_1),
    .grant  (l1_grant_1_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_1),
  .din(l2_in_data_1_1),
  .din_ready(l2_in_ready_1_1),

  .dout_valid(l2_out_valid_1_1),
  .dout(l2_out_data_1_1),
  .dout_ready(l2_out_ready_1_1),

  .item_count(l2_csr_readdata_1_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_1 > L2_TH)
    l2_almost_full_1_1 <= 1'b1;
  else
    l2_almost_full_1_1 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_2),
    .grant  (l1_grant_1_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_2),
  .din(l2_in_data_1_2),
  .din_ready(l2_in_ready_1_2),

  .dout_valid(l2_out_valid_1_2),
  .dout(l2_out_data_1_2),
  .dout_ready(l2_out_ready_1_2),

  .item_count(l2_csr_readdata_1_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_2 > L2_TH)
    l2_almost_full_1_2 <= 1'b1;
  else
    l2_almost_full_1_2 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_3),
    .grant  (l1_grant_1_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_3),
  .din(l2_in_data_1_3),
  .din_ready(l2_in_ready_1_3),

  .dout_valid(l2_out_valid_1_3),
  .dout(l2_out_data_1_3),
  .dout_ready(l2_out_ready_1_3),

  .item_count(l2_csr_readdata_1_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_3 > L2_TH)
    l2_almost_full_1_3 <= 1'b1;
  else
    l2_almost_full_1_3 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_4(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_4),
    .grant  (l1_grant_1_4)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_4),
  .din(l2_in_data_1_4),
  .din_ready(l2_in_ready_1_4),

  .dout_valid(l2_out_valid_1_4),
  .dout(l2_out_data_1_4),
  .dout_ready(l2_out_ready_1_4),

  .item_count(l2_csr_readdata_1_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_4 > L2_TH)
    l2_almost_full_1_4 <= 1'b1;
  else
    l2_almost_full_1_4 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_5(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_5),
    .grant  (l1_grant_1_5)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_5),
  .din(l2_in_data_1_5),
  .din_ready(l2_in_ready_1_5),

  .dout_valid(l2_out_valid_1_5),
  .dout(l2_out_data_1_5),
  .dout_ready(l2_out_ready_1_5),

  .item_count(l2_csr_readdata_1_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_5 > L2_TH)
    l2_almost_full_1_5 <= 1'b1;
  else
    l2_almost_full_1_5 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_6(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_6),
    .grant  (l1_grant_1_6)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_6),
  .din(l2_in_data_1_6),
  .din_ready(l2_in_ready_1_6),

  .dout_valid(l2_out_valid_1_6),
  .dout(l2_out_data_1_6),
  .dout_ready(l2_out_ready_1_6),

  .item_count(l2_csr_readdata_1_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_6 > L2_TH)
    l2_almost_full_1_6 <= 1'b1;
  else
    l2_almost_full_1_6 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_7(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_7),
    .grant  (l1_grant_1_7)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_7),
  .din(l2_in_data_1_7),
  .din_ready(l2_in_ready_1_7),

  .dout_valid(l2_out_valid_1_7),
  .dout(l2_out_data_1_7),
  .dout_ready(l2_out_ready_1_7),

  .item_count(l2_csr_readdata_1_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_7 > L2_TH)
    l2_almost_full_1_7 <= 1'b1;
  else
    l2_almost_full_1_7 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_8(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_8),
    .grant  (l1_grant_1_8)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_8 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_8),
  .din(l2_in_data_1_8),
  .din_ready(l2_in_ready_1_8),

  .dout_valid(l2_out_valid_1_8),
  .dout(l2_out_data_1_8),
  .dout_ready(l2_out_ready_1_8),

  .item_count(l2_csr_readdata_1_8),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_8 > L2_TH)
    l2_almost_full_1_8 <= 1'b1;
  else
    l2_almost_full_1_8 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_9(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_9),
    .grant  (l1_grant_1_9)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_9 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_9),
  .din(l2_in_data_1_9),
  .din_ready(l2_in_ready_1_9),

  .dout_valid(l2_out_valid_1_9),
  .dout(l2_out_data_1_9),
  .dout_ready(l2_out_ready_1_9),

  .item_count(l2_csr_readdata_1_9),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_9 > L2_TH)
    l2_almost_full_1_9 <= 1'b1;
  else
    l2_almost_full_1_9 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_10(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_10),
    .grant  (l1_grant_1_10)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_10 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_10),
  .din(l2_in_data_1_10),
  .din_ready(l2_in_ready_1_10),

  .dout_valid(l2_out_valid_1_10),
  .dout(l2_out_data_1_10),
  .dout_ready(l2_out_ready_1_10),

  .item_count(l2_csr_readdata_1_10),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_10 > L2_TH)
    l2_almost_full_1_10 <= 1'b1;
  else
    l2_almost_full_1_10 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_11(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_11),
    .grant  (l1_grant_1_11)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_11 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_11),
  .din(l2_in_data_1_11),
  .din_ready(l2_in_ready_1_11),

  .dout_valid(l2_out_valid_1_11),
  .dout(l2_out_data_1_11),
  .dout_ready(l2_out_ready_1_11),

  .item_count(l2_csr_readdata_1_11),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_11 > L2_TH)
    l2_almost_full_1_11 <= 1'b1;
  else
    l2_almost_full_1_11 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_12(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_12),
    .grant  (l1_grant_1_12)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_12 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_12),
  .din(l2_in_data_1_12),
  .din_ready(l2_in_ready_1_12),

  .dout_valid(l2_out_valid_1_12),
  .dout(l2_out_data_1_12),
  .dout_ready(l2_out_ready_1_12),

  .item_count(l2_csr_readdata_1_12),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_12 > L2_TH)
    l2_almost_full_1_12 <= 1'b1;
  else
    l2_almost_full_1_12 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_13(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_13),
    .grant  (l1_grant_1_13)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_13 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_13),
  .din(l2_in_data_1_13),
  .din_ready(l2_in_ready_1_13),

  .dout_valid(l2_out_valid_1_13),
  .dout(l2_out_data_1_13),
  .dout_ready(l2_out_ready_1_13),

  .item_count(l2_csr_readdata_1_13),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_13 > L2_TH)
    l2_almost_full_1_13 <= 1'b1;
  else
    l2_almost_full_1_13 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_14(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_14),
    .grant  (l1_grant_1_14)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_14 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_14),
  .din(l2_in_data_1_14),
  .din_ready(l2_in_ready_1_14),

  .dout_valid(l2_out_valid_1_14),
  .dout(l2_out_data_1_14),
  .dout_ready(l2_out_ready_1_14),

  .item_count(l2_csr_readdata_1_14),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_14 > L2_TH)
    l2_almost_full_1_14 <= 1'b1;
  else
    l2_almost_full_1_14 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_1_15(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_1_15),
    .grant  (l1_grant_1_15)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_1_15 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_1_15),
  .din(l2_in_data_1_15),
  .din_ready(l2_in_ready_1_15),

  .dout_valid(l2_out_valid_1_15),
  .dout(l2_out_data_1_15),
  .dout_ready(l2_out_ready_1_15),

  .item_count(l2_csr_readdata_1_15),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_1_15 > L2_TH)
    l2_almost_full_1_15 <= 1'b1;
  else
    l2_almost_full_1_15 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_0),
    .grant  (l1_grant_2_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_0),
  .din(l2_in_data_2_0),
  .din_ready(l2_in_ready_2_0),

  .dout_valid(l2_out_valid_2_0),
  .dout(l2_out_data_2_0),
  .dout_ready(l2_out_ready_2_0),

  .item_count(l2_csr_readdata_2_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_0 > L2_TH)
    l2_almost_full_2_0 <= 1'b1;
  else
    l2_almost_full_2_0 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_1),
    .grant  (l1_grant_2_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_1),
  .din(l2_in_data_2_1),
  .din_ready(l2_in_ready_2_1),

  .dout_valid(l2_out_valid_2_1),
  .dout(l2_out_data_2_1),
  .dout_ready(l2_out_ready_2_1),

  .item_count(l2_csr_readdata_2_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_1 > L2_TH)
    l2_almost_full_2_1 <= 1'b1;
  else
    l2_almost_full_2_1 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_2),
    .grant  (l1_grant_2_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_2),
  .din(l2_in_data_2_2),
  .din_ready(l2_in_ready_2_2),

  .dout_valid(l2_out_valid_2_2),
  .dout(l2_out_data_2_2),
  .dout_ready(l2_out_ready_2_2),

  .item_count(l2_csr_readdata_2_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_2 > L2_TH)
    l2_almost_full_2_2 <= 1'b1;
  else
    l2_almost_full_2_2 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_3),
    .grant  (l1_grant_2_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_3),
  .din(l2_in_data_2_3),
  .din_ready(l2_in_ready_2_3),

  .dout_valid(l2_out_valid_2_3),
  .dout(l2_out_data_2_3),
  .dout_ready(l2_out_ready_2_3),

  .item_count(l2_csr_readdata_2_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_3 > L2_TH)
    l2_almost_full_2_3 <= 1'b1;
  else
    l2_almost_full_2_3 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_4(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_4),
    .grant  (l1_grant_2_4)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_4),
  .din(l2_in_data_2_4),
  .din_ready(l2_in_ready_2_4),

  .dout_valid(l2_out_valid_2_4),
  .dout(l2_out_data_2_4),
  .dout_ready(l2_out_ready_2_4),

  .item_count(l2_csr_readdata_2_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_4 > L2_TH)
    l2_almost_full_2_4 <= 1'b1;
  else
    l2_almost_full_2_4 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_5(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_5),
    .grant  (l1_grant_2_5)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_5),
  .din(l2_in_data_2_5),
  .din_ready(l2_in_ready_2_5),

  .dout_valid(l2_out_valid_2_5),
  .dout(l2_out_data_2_5),
  .dout_ready(l2_out_ready_2_5),

  .item_count(l2_csr_readdata_2_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_5 > L2_TH)
    l2_almost_full_2_5 <= 1'b1;
  else
    l2_almost_full_2_5 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_6(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_6),
    .grant  (l1_grant_2_6)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_6),
  .din(l2_in_data_2_6),
  .din_ready(l2_in_ready_2_6),

  .dout_valid(l2_out_valid_2_6),
  .dout(l2_out_data_2_6),
  .dout_ready(l2_out_ready_2_6),

  .item_count(l2_csr_readdata_2_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_6 > L2_TH)
    l2_almost_full_2_6 <= 1'b1;
  else
    l2_almost_full_2_6 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_7(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_7),
    .grant  (l1_grant_2_7)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_7),
  .din(l2_in_data_2_7),
  .din_ready(l2_in_ready_2_7),

  .dout_valid(l2_out_valid_2_7),
  .dout(l2_out_data_2_7),
  .dout_ready(l2_out_ready_2_7),

  .item_count(l2_csr_readdata_2_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_7 > L2_TH)
    l2_almost_full_2_7 <= 1'b1;
  else
    l2_almost_full_2_7 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_8(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_8),
    .grant  (l1_grant_2_8)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_8 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_8),
  .din(l2_in_data_2_8),
  .din_ready(l2_in_ready_2_8),

  .dout_valid(l2_out_valid_2_8),
  .dout(l2_out_data_2_8),
  .dout_ready(l2_out_ready_2_8),

  .item_count(l2_csr_readdata_2_8),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_8 > L2_TH)
    l2_almost_full_2_8 <= 1'b1;
  else
    l2_almost_full_2_8 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_9(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_9),
    .grant  (l1_grant_2_9)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_9 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_9),
  .din(l2_in_data_2_9),
  .din_ready(l2_in_ready_2_9),

  .dout_valid(l2_out_valid_2_9),
  .dout(l2_out_data_2_9),
  .dout_ready(l2_out_ready_2_9),

  .item_count(l2_csr_readdata_2_9),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_9 > L2_TH)
    l2_almost_full_2_9 <= 1'b1;
  else
    l2_almost_full_2_9 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_10(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_10),
    .grant  (l1_grant_2_10)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_10 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_10),
  .din(l2_in_data_2_10),
  .din_ready(l2_in_ready_2_10),

  .dout_valid(l2_out_valid_2_10),
  .dout(l2_out_data_2_10),
  .dout_ready(l2_out_ready_2_10),

  .item_count(l2_csr_readdata_2_10),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_10 > L2_TH)
    l2_almost_full_2_10 <= 1'b1;
  else
    l2_almost_full_2_10 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_11(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_11),
    .grant  (l1_grant_2_11)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_11 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_11),
  .din(l2_in_data_2_11),
  .din_ready(l2_in_ready_2_11),

  .dout_valid(l2_out_valid_2_11),
  .dout(l2_out_data_2_11),
  .dout_ready(l2_out_ready_2_11),

  .item_count(l2_csr_readdata_2_11),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_11 > L2_TH)
    l2_almost_full_2_11 <= 1'b1;
  else
    l2_almost_full_2_11 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_12(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_12),
    .grant  (l1_grant_2_12)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_12 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_12),
  .din(l2_in_data_2_12),
  .din_ready(l2_in_ready_2_12),

  .dout_valid(l2_out_valid_2_12),
  .dout(l2_out_data_2_12),
  .dout_ready(l2_out_ready_2_12),

  .item_count(l2_csr_readdata_2_12),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_12 > L2_TH)
    l2_almost_full_2_12 <= 1'b1;
  else
    l2_almost_full_2_12 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_13(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_13),
    .grant  (l1_grant_2_13)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_13 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_13),
  .din(l2_in_data_2_13),
  .din_ready(l2_in_ready_2_13),

  .dout_valid(l2_out_valid_2_13),
  .dout(l2_out_data_2_13),
  .dout_ready(l2_out_ready_2_13),

  .item_count(l2_csr_readdata_2_13),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_13 > L2_TH)
    l2_almost_full_2_13 <= 1'b1;
  else
    l2_almost_full_2_13 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_14(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_14),
    .grant  (l1_grant_2_14)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_14 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_14),
  .din(l2_in_data_2_14),
  .din_ready(l2_in_ready_2_14),

  .dout_valid(l2_out_valid_2_14),
  .dout(l2_out_data_2_14),
  .dout_ready(l2_out_ready_2_14),

  .item_count(l2_csr_readdata_2_14),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_14 > L2_TH)
    l2_almost_full_2_14 <= 1'b1;
  else
    l2_almost_full_2_14 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_2_15(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_2_15),
    .grant  (l1_grant_2_15)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_2_15 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_2_15),
  .din(l2_in_data_2_15),
  .din_ready(l2_in_ready_2_15),

  .dout_valid(l2_out_valid_2_15),
  .dout(l2_out_data_2_15),
  .dout_ready(l2_out_ready_2_15),

  .item_count(l2_csr_readdata_2_15),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_2_15 > L2_TH)
    l2_almost_full_2_15 <= 1'b1;
  else
    l2_almost_full_2_15 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_0),
    .grant  (l1_grant_3_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_0),
  .din(l2_in_data_3_0),
  .din_ready(l2_in_ready_3_0),

  .dout_valid(l2_out_valid_3_0),
  .dout(l2_out_data_3_0),
  .dout_ready(l2_out_ready_3_0),

  .item_count(l2_csr_readdata_3_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_0 > L2_TH)
    l2_almost_full_3_0 <= 1'b1;
  else
    l2_almost_full_3_0 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_1),
    .grant  (l1_grant_3_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_1),
  .din(l2_in_data_3_1),
  .din_ready(l2_in_ready_3_1),

  .dout_valid(l2_out_valid_3_1),
  .dout(l2_out_data_3_1),
  .dout_ready(l2_out_ready_3_1),

  .item_count(l2_csr_readdata_3_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_1 > L2_TH)
    l2_almost_full_3_1 <= 1'b1;
  else
    l2_almost_full_3_1 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_2),
    .grant  (l1_grant_3_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_2),
  .din(l2_in_data_3_2),
  .din_ready(l2_in_ready_3_2),

  .dout_valid(l2_out_valid_3_2),
  .dout(l2_out_data_3_2),
  .dout_ready(l2_out_ready_3_2),

  .item_count(l2_csr_readdata_3_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_2 > L2_TH)
    l2_almost_full_3_2 <= 1'b1;
  else
    l2_almost_full_3_2 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_3),
    .grant  (l1_grant_3_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_3),
  .din(l2_in_data_3_3),
  .din_ready(l2_in_ready_3_3),

  .dout_valid(l2_out_valid_3_3),
  .dout(l2_out_data_3_3),
  .dout_ready(l2_out_ready_3_3),

  .item_count(l2_csr_readdata_3_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_3 > L2_TH)
    l2_almost_full_3_3 <= 1'b1;
  else
    l2_almost_full_3_3 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_4(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_4),
    .grant  (l1_grant_3_4)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_4),
  .din(l2_in_data_3_4),
  .din_ready(l2_in_ready_3_4),

  .dout_valid(l2_out_valid_3_4),
  .dout(l2_out_data_3_4),
  .dout_ready(l2_out_ready_3_4),

  .item_count(l2_csr_readdata_3_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_4 > L2_TH)
    l2_almost_full_3_4 <= 1'b1;
  else
    l2_almost_full_3_4 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_5(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_5),
    .grant  (l1_grant_3_5)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_5),
  .din(l2_in_data_3_5),
  .din_ready(l2_in_ready_3_5),

  .dout_valid(l2_out_valid_3_5),
  .dout(l2_out_data_3_5),
  .dout_ready(l2_out_ready_3_5),

  .item_count(l2_csr_readdata_3_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_5 > L2_TH)
    l2_almost_full_3_5 <= 1'b1;
  else
    l2_almost_full_3_5 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_6(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_6),
    .grant  (l1_grant_3_6)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_6),
  .din(l2_in_data_3_6),
  .din_ready(l2_in_ready_3_6),

  .dout_valid(l2_out_valid_3_6),
  .dout(l2_out_data_3_6),
  .dout_ready(l2_out_ready_3_6),

  .item_count(l2_csr_readdata_3_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_6 > L2_TH)
    l2_almost_full_3_6 <= 1'b1;
  else
    l2_almost_full_3_6 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_7(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_7),
    .grant  (l1_grant_3_7)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_7),
  .din(l2_in_data_3_7),
  .din_ready(l2_in_ready_3_7),

  .dout_valid(l2_out_valid_3_7),
  .dout(l2_out_data_3_7),
  .dout_ready(l2_out_ready_3_7),

  .item_count(l2_csr_readdata_3_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_7 > L2_TH)
    l2_almost_full_3_7 <= 1'b1;
  else
    l2_almost_full_3_7 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_8(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_8),
    .grant  (l1_grant_3_8)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_8 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_8),
  .din(l2_in_data_3_8),
  .din_ready(l2_in_ready_3_8),

  .dout_valid(l2_out_valid_3_8),
  .dout(l2_out_data_3_8),
  .dout_ready(l2_out_ready_3_8),

  .item_count(l2_csr_readdata_3_8),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_8 > L2_TH)
    l2_almost_full_3_8 <= 1'b1;
  else
    l2_almost_full_3_8 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_9(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_9),
    .grant  (l1_grant_3_9)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_9 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_9),
  .din(l2_in_data_3_9),
  .din_ready(l2_in_ready_3_9),

  .dout_valid(l2_out_valid_3_9),
  .dout(l2_out_data_3_9),
  .dout_ready(l2_out_ready_3_9),

  .item_count(l2_csr_readdata_3_9),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_9 > L2_TH)
    l2_almost_full_3_9 <= 1'b1;
  else
    l2_almost_full_3_9 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_10(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_10),
    .grant  (l1_grant_3_10)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_10 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_10),
  .din(l2_in_data_3_10),
  .din_ready(l2_in_ready_3_10),

  .dout_valid(l2_out_valid_3_10),
  .dout(l2_out_data_3_10),
  .dout_ready(l2_out_ready_3_10),

  .item_count(l2_csr_readdata_3_10),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_10 > L2_TH)
    l2_almost_full_3_10 <= 1'b1;
  else
    l2_almost_full_3_10 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_11(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_11),
    .grant  (l1_grant_3_11)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_11 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_11),
  .din(l2_in_data_3_11),
  .din_ready(l2_in_ready_3_11),

  .dout_valid(l2_out_valid_3_11),
  .dout(l2_out_data_3_11),
  .dout_ready(l2_out_ready_3_11),

  .item_count(l2_csr_readdata_3_11),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_11 > L2_TH)
    l2_almost_full_3_11 <= 1'b1;
  else
    l2_almost_full_3_11 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_12(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_12),
    .grant  (l1_grant_3_12)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_12 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_12),
  .din(l2_in_data_3_12),
  .din_ready(l2_in_ready_3_12),

  .dout_valid(l2_out_valid_3_12),
  .dout(l2_out_data_3_12),
  .dout_ready(l2_out_ready_3_12),

  .item_count(l2_csr_readdata_3_12),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_12 > L2_TH)
    l2_almost_full_3_12 <= 1'b1;
  else
    l2_almost_full_3_12 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_13(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_13),
    .grant  (l1_grant_3_13)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_13 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_13),
  .din(l2_in_data_3_13),
  .din_ready(l2_in_ready_3_13),

  .dout_valid(l2_out_valid_3_13),
  .dout(l2_out_data_3_13),
  .dout_ready(l2_out_ready_3_13),

  .item_count(l2_csr_readdata_3_13),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_13 > L2_TH)
    l2_almost_full_3_13 <= 1'b1;
  else
    l2_almost_full_3_13 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_14(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_14),
    .grant  (l1_grant_3_14)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_14 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_14),
  .din(l2_in_data_3_14),
  .din_ready(l2_in_ready_3_14),

  .dout_valid(l2_out_valid_3_14),
  .dout(l2_out_data_3_14),
  .dout_ready(l2_out_ready_3_14),

  .item_count(l2_csr_readdata_3_14),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_14 > L2_TH)
    l2_almost_full_3_14 <= 1'b1;
  else
    l2_almost_full_3_14 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_3_15(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_3_15),
    .grant  (l1_grant_3_15)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_3_15 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_3_15),
  .din(l2_in_data_3_15),
  .din_ready(l2_in_ready_3_15),

  .dout_valid(l2_out_valid_3_15),
  .dout(l2_out_data_3_15),
  .dout_ready(l2_out_ready_3_15),

  .item_count(l2_csr_readdata_3_15),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_3_15 > L2_TH)
    l2_almost_full_3_15 <= 1'b1;
  else
    l2_almost_full_3_15 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_0),
    .grant  (l1_grant_4_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_0),
  .din(l2_in_data_4_0),
  .din_ready(l2_in_ready_4_0),

  .dout_valid(l2_out_valid_4_0),
  .dout(l2_out_data_4_0),
  .dout_ready(l2_out_ready_4_0),

  .item_count(l2_csr_readdata_4_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_0 > L2_TH)
    l2_almost_full_4_0 <= 1'b1;
  else
    l2_almost_full_4_0 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_1),
    .grant  (l1_grant_4_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_1),
  .din(l2_in_data_4_1),
  .din_ready(l2_in_ready_4_1),

  .dout_valid(l2_out_valid_4_1),
  .dout(l2_out_data_4_1),
  .dout_ready(l2_out_ready_4_1),

  .item_count(l2_csr_readdata_4_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_1 > L2_TH)
    l2_almost_full_4_1 <= 1'b1;
  else
    l2_almost_full_4_1 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_2),
    .grant  (l1_grant_4_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_2),
  .din(l2_in_data_4_2),
  .din_ready(l2_in_ready_4_2),

  .dout_valid(l2_out_valid_4_2),
  .dout(l2_out_data_4_2),
  .dout_ready(l2_out_ready_4_2),

  .item_count(l2_csr_readdata_4_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_2 > L2_TH)
    l2_almost_full_4_2 <= 1'b1;
  else
    l2_almost_full_4_2 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_3),
    .grant  (l1_grant_4_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_3),
  .din(l2_in_data_4_3),
  .din_ready(l2_in_ready_4_3),

  .dout_valid(l2_out_valid_4_3),
  .dout(l2_out_data_4_3),
  .dout_ready(l2_out_ready_4_3),

  .item_count(l2_csr_readdata_4_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_3 > L2_TH)
    l2_almost_full_4_3 <= 1'b1;
  else
    l2_almost_full_4_3 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_4(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_4),
    .grant  (l1_grant_4_4)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_4),
  .din(l2_in_data_4_4),
  .din_ready(l2_in_ready_4_4),

  .dout_valid(l2_out_valid_4_4),
  .dout(l2_out_data_4_4),
  .dout_ready(l2_out_ready_4_4),

  .item_count(l2_csr_readdata_4_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_4 > L2_TH)
    l2_almost_full_4_4 <= 1'b1;
  else
    l2_almost_full_4_4 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_5(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_5),
    .grant  (l1_grant_4_5)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_5),
  .din(l2_in_data_4_5),
  .din_ready(l2_in_ready_4_5),

  .dout_valid(l2_out_valid_4_5),
  .dout(l2_out_data_4_5),
  .dout_ready(l2_out_ready_4_5),

  .item_count(l2_csr_readdata_4_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_5 > L2_TH)
    l2_almost_full_4_5 <= 1'b1;
  else
    l2_almost_full_4_5 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_6(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_6),
    .grant  (l1_grant_4_6)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_6),
  .din(l2_in_data_4_6),
  .din_ready(l2_in_ready_4_6),

  .dout_valid(l2_out_valid_4_6),
  .dout(l2_out_data_4_6),
  .dout_ready(l2_out_ready_4_6),

  .item_count(l2_csr_readdata_4_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_6 > L2_TH)
    l2_almost_full_4_6 <= 1'b1;
  else
    l2_almost_full_4_6 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_7(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_7),
    .grant  (l1_grant_4_7)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_7),
  .din(l2_in_data_4_7),
  .din_ready(l2_in_ready_4_7),

  .dout_valid(l2_out_valid_4_7),
  .dout(l2_out_data_4_7),
  .dout_ready(l2_out_ready_4_7),

  .item_count(l2_csr_readdata_4_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_7 > L2_TH)
    l2_almost_full_4_7 <= 1'b1;
  else
    l2_almost_full_4_7 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_8(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_8),
    .grant  (l1_grant_4_8)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_8 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_8),
  .din(l2_in_data_4_8),
  .din_ready(l2_in_ready_4_8),

  .dout_valid(l2_out_valid_4_8),
  .dout(l2_out_data_4_8),
  .dout_ready(l2_out_ready_4_8),

  .item_count(l2_csr_readdata_4_8),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_8 > L2_TH)
    l2_almost_full_4_8 <= 1'b1;
  else
    l2_almost_full_4_8 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_9(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_9),
    .grant  (l1_grant_4_9)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_9 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_9),
  .din(l2_in_data_4_9),
  .din_ready(l2_in_ready_4_9),

  .dout_valid(l2_out_valid_4_9),
  .dout(l2_out_data_4_9),
  .dout_ready(l2_out_ready_4_9),

  .item_count(l2_csr_readdata_4_9),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_9 > L2_TH)
    l2_almost_full_4_9 <= 1'b1;
  else
    l2_almost_full_4_9 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_10(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_10),
    .grant  (l1_grant_4_10)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_10 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_10),
  .din(l2_in_data_4_10),
  .din_ready(l2_in_ready_4_10),

  .dout_valid(l2_out_valid_4_10),
  .dout(l2_out_data_4_10),
  .dout_ready(l2_out_ready_4_10),

  .item_count(l2_csr_readdata_4_10),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_10 > L2_TH)
    l2_almost_full_4_10 <= 1'b1;
  else
    l2_almost_full_4_10 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_11(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_11),
    .grant  (l1_grant_4_11)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_11 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_11),
  .din(l2_in_data_4_11),
  .din_ready(l2_in_ready_4_11),

  .dout_valid(l2_out_valid_4_11),
  .dout(l2_out_data_4_11),
  .dout_ready(l2_out_ready_4_11),

  .item_count(l2_csr_readdata_4_11),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_11 > L2_TH)
    l2_almost_full_4_11 <= 1'b1;
  else
    l2_almost_full_4_11 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_12(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_12),
    .grant  (l1_grant_4_12)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_12 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_12),
  .din(l2_in_data_4_12),
  .din_ready(l2_in_ready_4_12),

  .dout_valid(l2_out_valid_4_12),
  .dout(l2_out_data_4_12),
  .dout_ready(l2_out_ready_4_12),

  .item_count(l2_csr_readdata_4_12),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_12 > L2_TH)
    l2_almost_full_4_12 <= 1'b1;
  else
    l2_almost_full_4_12 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_13(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_13),
    .grant  (l1_grant_4_13)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_13 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_13),
  .din(l2_in_data_4_13),
  .din_ready(l2_in_ready_4_13),

  .dout_valid(l2_out_valid_4_13),
  .dout(l2_out_data_4_13),
  .dout_ready(l2_out_ready_4_13),

  .item_count(l2_csr_readdata_4_13),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_13 > L2_TH)
    l2_almost_full_4_13 <= 1'b1;
  else
    l2_almost_full_4_13 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_14(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_14),
    .grant  (l1_grant_4_14)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_14 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_14),
  .din(l2_in_data_4_14),
  .din_ready(l2_in_ready_4_14),

  .dout_valid(l2_out_valid_4_14),
  .dout(l2_out_data_4_14),
  .dout_ready(l2_out_ready_4_14),

  .item_count(l2_csr_readdata_4_14),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_14 > L2_TH)
    l2_almost_full_4_14 <= 1'b1;
  else
    l2_almost_full_4_14 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_4_15(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_4_15),
    .grant  (l1_grant_4_15)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_4_15 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_4_15),
  .din(l2_in_data_4_15),
  .din_ready(l2_in_ready_4_15),

  .dout_valid(l2_out_valid_4_15),
  .dout(l2_out_data_4_15),
  .dout_ready(l2_out_ready_4_15),

  .item_count(l2_csr_readdata_4_15),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_4_15 > L2_TH)
    l2_almost_full_4_15 <= 1'b1;
  else
    l2_almost_full_4_15 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_0),
    .grant  (l1_grant_5_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_0),
  .din(l2_in_data_5_0),
  .din_ready(l2_in_ready_5_0),

  .dout_valid(l2_out_valid_5_0),
  .dout(l2_out_data_5_0),
  .dout_ready(l2_out_ready_5_0),

  .item_count(l2_csr_readdata_5_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_0 > L2_TH)
    l2_almost_full_5_0 <= 1'b1;
  else
    l2_almost_full_5_0 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_1),
    .grant  (l1_grant_5_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_1),
  .din(l2_in_data_5_1),
  .din_ready(l2_in_ready_5_1),

  .dout_valid(l2_out_valid_5_1),
  .dout(l2_out_data_5_1),
  .dout_ready(l2_out_ready_5_1),

  .item_count(l2_csr_readdata_5_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_1 > L2_TH)
    l2_almost_full_5_1 <= 1'b1;
  else
    l2_almost_full_5_1 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_2),
    .grant  (l1_grant_5_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_2),
  .din(l2_in_data_5_2),
  .din_ready(l2_in_ready_5_2),

  .dout_valid(l2_out_valid_5_2),
  .dout(l2_out_data_5_2),
  .dout_ready(l2_out_ready_5_2),

  .item_count(l2_csr_readdata_5_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_2 > L2_TH)
    l2_almost_full_5_2 <= 1'b1;
  else
    l2_almost_full_5_2 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_3),
    .grant  (l1_grant_5_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_3),
  .din(l2_in_data_5_3),
  .din_ready(l2_in_ready_5_3),

  .dout_valid(l2_out_valid_5_3),
  .dout(l2_out_data_5_3),
  .dout_ready(l2_out_ready_5_3),

  .item_count(l2_csr_readdata_5_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_3 > L2_TH)
    l2_almost_full_5_3 <= 1'b1;
  else
    l2_almost_full_5_3 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_4(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_4),
    .grant  (l1_grant_5_4)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_4),
  .din(l2_in_data_5_4),
  .din_ready(l2_in_ready_5_4),

  .dout_valid(l2_out_valid_5_4),
  .dout(l2_out_data_5_4),
  .dout_ready(l2_out_ready_5_4),

  .item_count(l2_csr_readdata_5_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_4 > L2_TH)
    l2_almost_full_5_4 <= 1'b1;
  else
    l2_almost_full_5_4 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_5(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_5),
    .grant  (l1_grant_5_5)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_5),
  .din(l2_in_data_5_5),
  .din_ready(l2_in_ready_5_5),

  .dout_valid(l2_out_valid_5_5),
  .dout(l2_out_data_5_5),
  .dout_ready(l2_out_ready_5_5),

  .item_count(l2_csr_readdata_5_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_5 > L2_TH)
    l2_almost_full_5_5 <= 1'b1;
  else
    l2_almost_full_5_5 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_6(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_6),
    .grant  (l1_grant_5_6)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_6),
  .din(l2_in_data_5_6),
  .din_ready(l2_in_ready_5_6),

  .dout_valid(l2_out_valid_5_6),
  .dout(l2_out_data_5_6),
  .dout_ready(l2_out_ready_5_6),

  .item_count(l2_csr_readdata_5_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_6 > L2_TH)
    l2_almost_full_5_6 <= 1'b1;
  else
    l2_almost_full_5_6 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_7(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_7),
    .grant  (l1_grant_5_7)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_7),
  .din(l2_in_data_5_7),
  .din_ready(l2_in_ready_5_7),

  .dout_valid(l2_out_valid_5_7),
  .dout(l2_out_data_5_7),
  .dout_ready(l2_out_ready_5_7),

  .item_count(l2_csr_readdata_5_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_7 > L2_TH)
    l2_almost_full_5_7 <= 1'b1;
  else
    l2_almost_full_5_7 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_8(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_8),
    .grant  (l1_grant_5_8)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_8 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_8),
  .din(l2_in_data_5_8),
  .din_ready(l2_in_ready_5_8),

  .dout_valid(l2_out_valid_5_8),
  .dout(l2_out_data_5_8),
  .dout_ready(l2_out_ready_5_8),

  .item_count(l2_csr_readdata_5_8),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_8 > L2_TH)
    l2_almost_full_5_8 <= 1'b1;
  else
    l2_almost_full_5_8 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_9(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_9),
    .grant  (l1_grant_5_9)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_9 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_9),
  .din(l2_in_data_5_9),
  .din_ready(l2_in_ready_5_9),

  .dout_valid(l2_out_valid_5_9),
  .dout(l2_out_data_5_9),
  .dout_ready(l2_out_ready_5_9),

  .item_count(l2_csr_readdata_5_9),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_9 > L2_TH)
    l2_almost_full_5_9 <= 1'b1;
  else
    l2_almost_full_5_9 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_10(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_10),
    .grant  (l1_grant_5_10)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_10 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_10),
  .din(l2_in_data_5_10),
  .din_ready(l2_in_ready_5_10),

  .dout_valid(l2_out_valid_5_10),
  .dout(l2_out_data_5_10),
  .dout_ready(l2_out_ready_5_10),

  .item_count(l2_csr_readdata_5_10),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_10 > L2_TH)
    l2_almost_full_5_10 <= 1'b1;
  else
    l2_almost_full_5_10 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_11(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_11),
    .grant  (l1_grant_5_11)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_11 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_11),
  .din(l2_in_data_5_11),
  .din_ready(l2_in_ready_5_11),

  .dout_valid(l2_out_valid_5_11),
  .dout(l2_out_data_5_11),
  .dout_ready(l2_out_ready_5_11),

  .item_count(l2_csr_readdata_5_11),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_11 > L2_TH)
    l2_almost_full_5_11 <= 1'b1;
  else
    l2_almost_full_5_11 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_12(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_12),
    .grant  (l1_grant_5_12)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_12 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_12),
  .din(l2_in_data_5_12),
  .din_ready(l2_in_ready_5_12),

  .dout_valid(l2_out_valid_5_12),
  .dout(l2_out_data_5_12),
  .dout_ready(l2_out_ready_5_12),

  .item_count(l2_csr_readdata_5_12),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_12 > L2_TH)
    l2_almost_full_5_12 <= 1'b1;
  else
    l2_almost_full_5_12 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_13(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_13),
    .grant  (l1_grant_5_13)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_13 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_13),
  .din(l2_in_data_5_13),
  .din_ready(l2_in_ready_5_13),

  .dout_valid(l2_out_valid_5_13),
  .dout(l2_out_data_5_13),
  .dout_ready(l2_out_ready_5_13),

  .item_count(l2_csr_readdata_5_13),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_13 > L2_TH)
    l2_almost_full_5_13 <= 1'b1;
  else
    l2_almost_full_5_13 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_14(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_14),
    .grant  (l1_grant_5_14)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_14 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_14),
  .din(l2_in_data_5_14),
  .din_ready(l2_in_ready_5_14),

  .dout_valid(l2_out_valid_5_14),
  .dout(l2_out_data_5_14),
  .dout_ready(l2_out_ready_5_14),

  .item_count(l2_csr_readdata_5_14),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_14 > L2_TH)
    l2_almost_full_5_14 <= 1'b1;
  else
    l2_almost_full_5_14 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_5_15(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_5_15),
    .grant  (l1_grant_5_15)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_5_15 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_5_15),
  .din(l2_in_data_5_15),
  .din_ready(l2_in_ready_5_15),

  .dout_valid(l2_out_valid_5_15),
  .dout(l2_out_data_5_15),
  .dout_ready(l2_out_ready_5_15),

  .item_count(l2_csr_readdata_5_15),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_5_15 > L2_TH)
    l2_almost_full_5_15 <= 1'b1;
  else
    l2_almost_full_5_15 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_0),
    .grant  (l1_grant_6_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_0),
  .din(l2_in_data_6_0),
  .din_ready(l2_in_ready_6_0),

  .dout_valid(l2_out_valid_6_0),
  .dout(l2_out_data_6_0),
  .dout_ready(l2_out_ready_6_0),

  .item_count(l2_csr_readdata_6_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_0 > L2_TH)
    l2_almost_full_6_0 <= 1'b1;
  else
    l2_almost_full_6_0 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_1),
    .grant  (l1_grant_6_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_1),
  .din(l2_in_data_6_1),
  .din_ready(l2_in_ready_6_1),

  .dout_valid(l2_out_valid_6_1),
  .dout(l2_out_data_6_1),
  .dout_ready(l2_out_ready_6_1),

  .item_count(l2_csr_readdata_6_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_1 > L2_TH)
    l2_almost_full_6_1 <= 1'b1;
  else
    l2_almost_full_6_1 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_2),
    .grant  (l1_grant_6_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_2),
  .din(l2_in_data_6_2),
  .din_ready(l2_in_ready_6_2),

  .dout_valid(l2_out_valid_6_2),
  .dout(l2_out_data_6_2),
  .dout_ready(l2_out_ready_6_2),

  .item_count(l2_csr_readdata_6_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_2 > L2_TH)
    l2_almost_full_6_2 <= 1'b1;
  else
    l2_almost_full_6_2 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_3),
    .grant  (l1_grant_6_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_3),
  .din(l2_in_data_6_3),
  .din_ready(l2_in_ready_6_3),

  .dout_valid(l2_out_valid_6_3),
  .dout(l2_out_data_6_3),
  .dout_ready(l2_out_ready_6_3),

  .item_count(l2_csr_readdata_6_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_3 > L2_TH)
    l2_almost_full_6_3 <= 1'b1;
  else
    l2_almost_full_6_3 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_4(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_4),
    .grant  (l1_grant_6_4)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_4),
  .din(l2_in_data_6_4),
  .din_ready(l2_in_ready_6_4),

  .dout_valid(l2_out_valid_6_4),
  .dout(l2_out_data_6_4),
  .dout_ready(l2_out_ready_6_4),

  .item_count(l2_csr_readdata_6_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_4 > L2_TH)
    l2_almost_full_6_4 <= 1'b1;
  else
    l2_almost_full_6_4 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_5(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_5),
    .grant  (l1_grant_6_5)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_5),
  .din(l2_in_data_6_5),
  .din_ready(l2_in_ready_6_5),

  .dout_valid(l2_out_valid_6_5),
  .dout(l2_out_data_6_5),
  .dout_ready(l2_out_ready_6_5),

  .item_count(l2_csr_readdata_6_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_5 > L2_TH)
    l2_almost_full_6_5 <= 1'b1;
  else
    l2_almost_full_6_5 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_6(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_6),
    .grant  (l1_grant_6_6)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_6),
  .din(l2_in_data_6_6),
  .din_ready(l2_in_ready_6_6),

  .dout_valid(l2_out_valid_6_6),
  .dout(l2_out_data_6_6),
  .dout_ready(l2_out_ready_6_6),

  .item_count(l2_csr_readdata_6_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_6 > L2_TH)
    l2_almost_full_6_6 <= 1'b1;
  else
    l2_almost_full_6_6 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_7(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_7),
    .grant  (l1_grant_6_7)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_7),
  .din(l2_in_data_6_7),
  .din_ready(l2_in_ready_6_7),

  .dout_valid(l2_out_valid_6_7),
  .dout(l2_out_data_6_7),
  .dout_ready(l2_out_ready_6_7),

  .item_count(l2_csr_readdata_6_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_7 > L2_TH)
    l2_almost_full_6_7 <= 1'b1;
  else
    l2_almost_full_6_7 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_8(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_8),
    .grant  (l1_grant_6_8)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_8 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_8),
  .din(l2_in_data_6_8),
  .din_ready(l2_in_ready_6_8),

  .dout_valid(l2_out_valid_6_8),
  .dout(l2_out_data_6_8),
  .dout_ready(l2_out_ready_6_8),

  .item_count(l2_csr_readdata_6_8),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_8 > L2_TH)
    l2_almost_full_6_8 <= 1'b1;
  else
    l2_almost_full_6_8 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_9(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_9),
    .grant  (l1_grant_6_9)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_9 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_9),
  .din(l2_in_data_6_9),
  .din_ready(l2_in_ready_6_9),

  .dout_valid(l2_out_valid_6_9),
  .dout(l2_out_data_6_9),
  .dout_ready(l2_out_ready_6_9),

  .item_count(l2_csr_readdata_6_9),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_9 > L2_TH)
    l2_almost_full_6_9 <= 1'b1;
  else
    l2_almost_full_6_9 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_10(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_10),
    .grant  (l1_grant_6_10)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_10 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_10),
  .din(l2_in_data_6_10),
  .din_ready(l2_in_ready_6_10),

  .dout_valid(l2_out_valid_6_10),
  .dout(l2_out_data_6_10),
  .dout_ready(l2_out_ready_6_10),

  .item_count(l2_csr_readdata_6_10),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_10 > L2_TH)
    l2_almost_full_6_10 <= 1'b1;
  else
    l2_almost_full_6_10 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_11(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_11),
    .grant  (l1_grant_6_11)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_11 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_11),
  .din(l2_in_data_6_11),
  .din_ready(l2_in_ready_6_11),

  .dout_valid(l2_out_valid_6_11),
  .dout(l2_out_data_6_11),
  .dout_ready(l2_out_ready_6_11),

  .item_count(l2_csr_readdata_6_11),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_11 > L2_TH)
    l2_almost_full_6_11 <= 1'b1;
  else
    l2_almost_full_6_11 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_12(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_12),
    .grant  (l1_grant_6_12)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_12 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_12),
  .din(l2_in_data_6_12),
  .din_ready(l2_in_ready_6_12),

  .dout_valid(l2_out_valid_6_12),
  .dout(l2_out_data_6_12),
  .dout_ready(l2_out_ready_6_12),

  .item_count(l2_csr_readdata_6_12),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_12 > L2_TH)
    l2_almost_full_6_12 <= 1'b1;
  else
    l2_almost_full_6_12 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_13(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_13),
    .grant  (l1_grant_6_13)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_13 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_13),
  .din(l2_in_data_6_13),
  .din_ready(l2_in_ready_6_13),

  .dout_valid(l2_out_valid_6_13),
  .dout(l2_out_data_6_13),
  .dout_ready(l2_out_ready_6_13),

  .item_count(l2_csr_readdata_6_13),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_13 > L2_TH)
    l2_almost_full_6_13 <= 1'b1;
  else
    l2_almost_full_6_13 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_14(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_14),
    .grant  (l1_grant_6_14)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_14 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_14),
  .din(l2_in_data_6_14),
  .din_ready(l2_in_ready_6_14),

  .dout_valid(l2_out_valid_6_14),
  .dout(l2_out_data_6_14),
  .dout_ready(l2_out_ready_6_14),

  .item_count(l2_csr_readdata_6_14),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_14 > L2_TH)
    l2_almost_full_6_14 <= 1'b1;
  else
    l2_almost_full_6_14 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_6_15(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_6_15),
    .grant  (l1_grant_6_15)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_6_15 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_6_15),
  .din(l2_in_data_6_15),
  .din_ready(l2_in_ready_6_15),

  .dout_valid(l2_out_valid_6_15),
  .dout(l2_out_data_6_15),
  .dout_ready(l2_out_ready_6_15),

  .item_count(l2_csr_readdata_6_15),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_6_15 > L2_TH)
    l2_almost_full_6_15 <= 1'b1;
  else
    l2_almost_full_6_15 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_0),
    .grant  (l1_grant_7_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_0),
  .din(l2_in_data_7_0),
  .din_ready(l2_in_ready_7_0),

  .dout_valid(l2_out_valid_7_0),
  .dout(l2_out_data_7_0),
  .dout_ready(l2_out_ready_7_0),

  .item_count(l2_csr_readdata_7_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_0 > L2_TH)
    l2_almost_full_7_0 <= 1'b1;
  else
    l2_almost_full_7_0 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_1),
    .grant  (l1_grant_7_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_1),
  .din(l2_in_data_7_1),
  .din_ready(l2_in_ready_7_1),

  .dout_valid(l2_out_valid_7_1),
  .dout(l2_out_data_7_1),
  .dout_ready(l2_out_ready_7_1),

  .item_count(l2_csr_readdata_7_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_1 > L2_TH)
    l2_almost_full_7_1 <= 1'b1;
  else
    l2_almost_full_7_1 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_2),
    .grant  (l1_grant_7_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_2),
  .din(l2_in_data_7_2),
  .din_ready(l2_in_ready_7_2),

  .dout_valid(l2_out_valid_7_2),
  .dout(l2_out_data_7_2),
  .dout_ready(l2_out_ready_7_2),

  .item_count(l2_csr_readdata_7_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_2 > L2_TH)
    l2_almost_full_7_2 <= 1'b1;
  else
    l2_almost_full_7_2 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_3),
    .grant  (l1_grant_7_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_3),
  .din(l2_in_data_7_3),
  .din_ready(l2_in_ready_7_3),

  .dout_valid(l2_out_valid_7_3),
  .dout(l2_out_data_7_3),
  .dout_ready(l2_out_ready_7_3),

  .item_count(l2_csr_readdata_7_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_3 > L2_TH)
    l2_almost_full_7_3 <= 1'b1;
  else
    l2_almost_full_7_3 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_4(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_4),
    .grant  (l1_grant_7_4)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_4),
  .din(l2_in_data_7_4),
  .din_ready(l2_in_ready_7_4),

  .dout_valid(l2_out_valid_7_4),
  .dout(l2_out_data_7_4),
  .dout_ready(l2_out_ready_7_4),

  .item_count(l2_csr_readdata_7_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_4 > L2_TH)
    l2_almost_full_7_4 <= 1'b1;
  else
    l2_almost_full_7_4 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_5(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_5),
    .grant  (l1_grant_7_5)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_5),
  .din(l2_in_data_7_5),
  .din_ready(l2_in_ready_7_5),

  .dout_valid(l2_out_valid_7_5),
  .dout(l2_out_data_7_5),
  .dout_ready(l2_out_ready_7_5),

  .item_count(l2_csr_readdata_7_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_5 > L2_TH)
    l2_almost_full_7_5 <= 1'b1;
  else
    l2_almost_full_7_5 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_6(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_6),
    .grant  (l1_grant_7_6)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_6),
  .din(l2_in_data_7_6),
  .din_ready(l2_in_ready_7_6),

  .dout_valid(l2_out_valid_7_6),
  .dout(l2_out_data_7_6),
  .dout_ready(l2_out_ready_7_6),

  .item_count(l2_csr_readdata_7_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_6 > L2_TH)
    l2_almost_full_7_6 <= 1'b1;
  else
    l2_almost_full_7_6 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_7(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_7),
    .grant  (l1_grant_7_7)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_7),
  .din(l2_in_data_7_7),
  .din_ready(l2_in_ready_7_7),

  .dout_valid(l2_out_valid_7_7),
  .dout(l2_out_data_7_7),
  .dout_ready(l2_out_ready_7_7),

  .item_count(l2_csr_readdata_7_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_7 > L2_TH)
    l2_almost_full_7_7 <= 1'b1;
  else
    l2_almost_full_7_7 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_8(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_8),
    .grant  (l1_grant_7_8)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_8 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_8),
  .din(l2_in_data_7_8),
  .din_ready(l2_in_ready_7_8),

  .dout_valid(l2_out_valid_7_8),
  .dout(l2_out_data_7_8),
  .dout_ready(l2_out_ready_7_8),

  .item_count(l2_csr_readdata_7_8),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_8 > L2_TH)
    l2_almost_full_7_8 <= 1'b1;
  else
    l2_almost_full_7_8 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_9(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_9),
    .grant  (l1_grant_7_9)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_9 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_9),
  .din(l2_in_data_7_9),
  .din_ready(l2_in_ready_7_9),

  .dout_valid(l2_out_valid_7_9),
  .dout(l2_out_data_7_9),
  .dout_ready(l2_out_ready_7_9),

  .item_count(l2_csr_readdata_7_9),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_9 > L2_TH)
    l2_almost_full_7_9 <= 1'b1;
  else
    l2_almost_full_7_9 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_10(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_10),
    .grant  (l1_grant_7_10)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_10 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_10),
  .din(l2_in_data_7_10),
  .din_ready(l2_in_ready_7_10),

  .dout_valid(l2_out_valid_7_10),
  .dout(l2_out_data_7_10),
  .dout_ready(l2_out_ready_7_10),

  .item_count(l2_csr_readdata_7_10),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_10 > L2_TH)
    l2_almost_full_7_10 <= 1'b1;
  else
    l2_almost_full_7_10 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_11(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_11),
    .grant  (l1_grant_7_11)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_11 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_11),
  .din(l2_in_data_7_11),
  .din_ready(l2_in_ready_7_11),

  .dout_valid(l2_out_valid_7_11),
  .dout(l2_out_data_7_11),
  .dout_ready(l2_out_ready_7_11),

  .item_count(l2_csr_readdata_7_11),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_11 > L2_TH)
    l2_almost_full_7_11 <= 1'b1;
  else
    l2_almost_full_7_11 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_12(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_12),
    .grant  (l1_grant_7_12)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_12 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_12),
  .din(l2_in_data_7_12),
  .din_ready(l2_in_ready_7_12),

  .dout_valid(l2_out_valid_7_12),
  .dout(l2_out_data_7_12),
  .dout_ready(l2_out_ready_7_12),

  .item_count(l2_csr_readdata_7_12),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_12 > L2_TH)
    l2_almost_full_7_12 <= 1'b1;
  else
    l2_almost_full_7_12 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_13(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_13),
    .grant  (l1_grant_7_13)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_13 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_13),
  .din(l2_in_data_7_13),
  .din_ready(l2_in_ready_7_13),

  .dout_valid(l2_out_valid_7_13),
  .dout(l2_out_data_7_13),
  .dout_ready(l2_out_ready_7_13),

  .item_count(l2_csr_readdata_7_13),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_13 > L2_TH)
    l2_almost_full_7_13 <= 1'b1;
  else
    l2_almost_full_7_13 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_14(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_14),
    .grant  (l1_grant_7_14)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_14 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_14),
  .din(l2_in_data_7_14),
  .din_ready(l2_in_ready_7_14),

  .dout_valid(l2_out_valid_7_14),
  .dout(l2_out_data_7_14),
  .dout_ready(l2_out_ready_7_14),

  .item_count(l2_csr_readdata_7_14),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_14 > L2_TH)
    l2_almost_full_7_14 <= 1'b1;
  else
    l2_almost_full_7_14 <= 1'b0;

rr_arbiter #(
    .DWIDTH(2)
)
l1_arb_7_15(
    .clk    (clk),
    .rst    (rst),
    .req    (l1_req_7_15),
    .grant  (l1_grant_7_15)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l2_fifo_7_15 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l2_in_valid_7_15),
  .din(l2_in_data_7_15),
  .din_ready(l2_in_ready_7_15),

  .dout_valid(l2_out_valid_7_15),
  .dout(l2_out_data_7_15),
  .dout_ready(l2_out_ready_7_15),

  .item_count(l2_csr_readdata_7_15),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l2_csr_readdata_7_15 > L2_TH)
    l2_almost_full_7_15 <= 1'b1;
  else
    l2_almost_full_7_15 <= 1'b0;


rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_0_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_0_0),
    .grant  (l2_grant_0_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_0_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_0_0),
  .din(l3_in_data_0_0),
  .din_ready(l3_in_ready_0_0),

  .dout_valid(l3_out_valid_0_0),
  .dout(l3_out_data_0_0),
  .dout_ready(l3_out_ready_0_0),

  .item_count(l3_csr_readdata_0_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_0_0 > L3_TH)
    l3_almost_full_0_0 <= 1'b1;
  else
    l3_almost_full_0_0 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_0_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_0_1),
    .grant  (l2_grant_0_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_0_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_0_1),
  .din(l3_in_data_0_1),
  .din_ready(l3_in_ready_0_1),

  .dout_valid(l3_out_valid_0_1),
  .dout(l3_out_data_0_1),
  .dout_ready(l3_out_ready_0_1),

  .item_count(l3_csr_readdata_0_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_0_1 > L3_TH)
    l3_almost_full_0_1 <= 1'b1;
  else
    l3_almost_full_0_1 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_0_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_0_2),
    .grant  (l2_grant_0_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_0_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_0_2),
  .din(l3_in_data_0_2),
  .din_ready(l3_in_ready_0_2),

  .dout_valid(l3_out_valid_0_2),
  .dout(l3_out_data_0_2),
  .dout_ready(l3_out_ready_0_2),

  .item_count(l3_csr_readdata_0_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_0_2 > L3_TH)
    l3_almost_full_0_2 <= 1'b1;
  else
    l3_almost_full_0_2 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_0_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_0_3),
    .grant  (l2_grant_0_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_0_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_0_3),
  .din(l3_in_data_0_3),
  .din_ready(l3_in_ready_0_3),

  .dout_valid(l3_out_valid_0_3),
  .dout(l3_out_data_0_3),
  .dout_ready(l3_out_ready_0_3),

  .item_count(l3_csr_readdata_0_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_0_3 > L3_TH)
    l3_almost_full_0_3 <= 1'b1;
  else
    l3_almost_full_0_3 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_1_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_1_0),
    .grant  (l2_grant_1_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_1_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_1_0),
  .din(l3_in_data_1_0),
  .din_ready(l3_in_ready_1_0),

  .dout_valid(l3_out_valid_1_0),
  .dout(l3_out_data_1_0),
  .dout_ready(l3_out_ready_1_0),

  .item_count(l3_csr_readdata_1_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_1_0 > L3_TH)
    l3_almost_full_1_0 <= 1'b1;
  else
    l3_almost_full_1_0 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_1_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_1_1),
    .grant  (l2_grant_1_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_1_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_1_1),
  .din(l3_in_data_1_1),
  .din_ready(l3_in_ready_1_1),

  .dout_valid(l3_out_valid_1_1),
  .dout(l3_out_data_1_1),
  .dout_ready(l3_out_ready_1_1),

  .item_count(l3_csr_readdata_1_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_1_1 > L3_TH)
    l3_almost_full_1_1 <= 1'b1;
  else
    l3_almost_full_1_1 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_1_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_1_2),
    .grant  (l2_grant_1_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_1_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_1_2),
  .din(l3_in_data_1_2),
  .din_ready(l3_in_ready_1_2),

  .dout_valid(l3_out_valid_1_2),
  .dout(l3_out_data_1_2),
  .dout_ready(l3_out_ready_1_2),

  .item_count(l3_csr_readdata_1_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_1_2 > L3_TH)
    l3_almost_full_1_2 <= 1'b1;
  else
    l3_almost_full_1_2 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_1_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_1_3),
    .grant  (l2_grant_1_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_1_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_1_3),
  .din(l3_in_data_1_3),
  .din_ready(l3_in_ready_1_3),

  .dout_valid(l3_out_valid_1_3),
  .dout(l3_out_data_1_3),
  .dout_ready(l3_out_ready_1_3),

  .item_count(l3_csr_readdata_1_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_1_3 > L3_TH)
    l3_almost_full_1_3 <= 1'b1;
  else
    l3_almost_full_1_3 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_2_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_2_0),
    .grant  (l2_grant_2_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_2_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_2_0),
  .din(l3_in_data_2_0),
  .din_ready(l3_in_ready_2_0),

  .dout_valid(l3_out_valid_2_0),
  .dout(l3_out_data_2_0),
  .dout_ready(l3_out_ready_2_0),

  .item_count(l3_csr_readdata_2_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_2_0 > L3_TH)
    l3_almost_full_2_0 <= 1'b1;
  else
    l3_almost_full_2_0 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_2_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_2_1),
    .grant  (l2_grant_2_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_2_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_2_1),
  .din(l3_in_data_2_1),
  .din_ready(l3_in_ready_2_1),

  .dout_valid(l3_out_valid_2_1),
  .dout(l3_out_data_2_1),
  .dout_ready(l3_out_ready_2_1),

  .item_count(l3_csr_readdata_2_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_2_1 > L3_TH)
    l3_almost_full_2_1 <= 1'b1;
  else
    l3_almost_full_2_1 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_2_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_2_2),
    .grant  (l2_grant_2_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_2_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_2_2),
  .din(l3_in_data_2_2),
  .din_ready(l3_in_ready_2_2),

  .dout_valid(l3_out_valid_2_2),
  .dout(l3_out_data_2_2),
  .dout_ready(l3_out_ready_2_2),

  .item_count(l3_csr_readdata_2_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_2_2 > L3_TH)
    l3_almost_full_2_2 <= 1'b1;
  else
    l3_almost_full_2_2 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_2_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_2_3),
    .grant  (l2_grant_2_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_2_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_2_3),
  .din(l3_in_data_2_3),
  .din_ready(l3_in_ready_2_3),

  .dout_valid(l3_out_valid_2_3),
  .dout(l3_out_data_2_3),
  .dout_ready(l3_out_ready_2_3),

  .item_count(l3_csr_readdata_2_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_2_3 > L3_TH)
    l3_almost_full_2_3 <= 1'b1;
  else
    l3_almost_full_2_3 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_3_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_3_0),
    .grant  (l2_grant_3_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_3_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_3_0),
  .din(l3_in_data_3_0),
  .din_ready(l3_in_ready_3_0),

  .dout_valid(l3_out_valid_3_0),
  .dout(l3_out_data_3_0),
  .dout_ready(l3_out_ready_3_0),

  .item_count(l3_csr_readdata_3_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_3_0 > L3_TH)
    l3_almost_full_3_0 <= 1'b1;
  else
    l3_almost_full_3_0 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_3_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_3_1),
    .grant  (l2_grant_3_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_3_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_3_1),
  .din(l3_in_data_3_1),
  .din_ready(l3_in_ready_3_1),

  .dout_valid(l3_out_valid_3_1),
  .dout(l3_out_data_3_1),
  .dout_ready(l3_out_ready_3_1),

  .item_count(l3_csr_readdata_3_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_3_1 > L3_TH)
    l3_almost_full_3_1 <= 1'b1;
  else
    l3_almost_full_3_1 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_3_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_3_2),
    .grant  (l2_grant_3_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_3_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_3_2),
  .din(l3_in_data_3_2),
  .din_ready(l3_in_ready_3_2),

  .dout_valid(l3_out_valid_3_2),
  .dout(l3_out_data_3_2),
  .dout_ready(l3_out_ready_3_2),

  .item_count(l3_csr_readdata_3_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_3_2 > L3_TH)
    l3_almost_full_3_2 <= 1'b1;
  else
    l3_almost_full_3_2 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_3_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_3_3),
    .grant  (l2_grant_3_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_3_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_3_3),
  .din(l3_in_data_3_3),
  .din_ready(l3_in_ready_3_3),

  .dout_valid(l3_out_valid_3_3),
  .dout(l3_out_data_3_3),
  .dout_ready(l3_out_ready_3_3),

  .item_count(l3_csr_readdata_3_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_3_3 > L3_TH)
    l3_almost_full_3_3 <= 1'b1;
  else
    l3_almost_full_3_3 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_4_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_4_0),
    .grant  (l2_grant_4_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_4_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_4_0),
  .din(l3_in_data_4_0),
  .din_ready(l3_in_ready_4_0),

  .dout_valid(l3_out_valid_4_0),
  .dout(l3_out_data_4_0),
  .dout_ready(l3_out_ready_4_0),

  .item_count(l3_csr_readdata_4_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_4_0 > L3_TH)
    l3_almost_full_4_0 <= 1'b1;
  else
    l3_almost_full_4_0 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_4_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_4_1),
    .grant  (l2_grant_4_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_4_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_4_1),
  .din(l3_in_data_4_1),
  .din_ready(l3_in_ready_4_1),

  .dout_valid(l3_out_valid_4_1),
  .dout(l3_out_data_4_1),
  .dout_ready(l3_out_ready_4_1),

  .item_count(l3_csr_readdata_4_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_4_1 > L3_TH)
    l3_almost_full_4_1 <= 1'b1;
  else
    l3_almost_full_4_1 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_4_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_4_2),
    .grant  (l2_grant_4_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_4_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_4_2),
  .din(l3_in_data_4_2),
  .din_ready(l3_in_ready_4_2),

  .dout_valid(l3_out_valid_4_2),
  .dout(l3_out_data_4_2),
  .dout_ready(l3_out_ready_4_2),

  .item_count(l3_csr_readdata_4_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_4_2 > L3_TH)
    l3_almost_full_4_2 <= 1'b1;
  else
    l3_almost_full_4_2 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_4_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_4_3),
    .grant  (l2_grant_4_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_4_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_4_3),
  .din(l3_in_data_4_3),
  .din_ready(l3_in_ready_4_3),

  .dout_valid(l3_out_valid_4_3),
  .dout(l3_out_data_4_3),
  .dout_ready(l3_out_ready_4_3),

  .item_count(l3_csr_readdata_4_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_4_3 > L3_TH)
    l3_almost_full_4_3 <= 1'b1;
  else
    l3_almost_full_4_3 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_5_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_5_0),
    .grant  (l2_grant_5_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_5_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_5_0),
  .din(l3_in_data_5_0),
  .din_ready(l3_in_ready_5_0),

  .dout_valid(l3_out_valid_5_0),
  .dout(l3_out_data_5_0),
  .dout_ready(l3_out_ready_5_0),

  .item_count(l3_csr_readdata_5_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_5_0 > L3_TH)
    l3_almost_full_5_0 <= 1'b1;
  else
    l3_almost_full_5_0 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_5_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_5_1),
    .grant  (l2_grant_5_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_5_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_5_1),
  .din(l3_in_data_5_1),
  .din_ready(l3_in_ready_5_1),

  .dout_valid(l3_out_valid_5_1),
  .dout(l3_out_data_5_1),
  .dout_ready(l3_out_ready_5_1),

  .item_count(l3_csr_readdata_5_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_5_1 > L3_TH)
    l3_almost_full_5_1 <= 1'b1;
  else
    l3_almost_full_5_1 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_5_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_5_2),
    .grant  (l2_grant_5_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_5_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_5_2),
  .din(l3_in_data_5_2),
  .din_ready(l3_in_ready_5_2),

  .dout_valid(l3_out_valid_5_2),
  .dout(l3_out_data_5_2),
  .dout_ready(l3_out_ready_5_2),

  .item_count(l3_csr_readdata_5_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_5_2 > L3_TH)
    l3_almost_full_5_2 <= 1'b1;
  else
    l3_almost_full_5_2 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_5_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_5_3),
    .grant  (l2_grant_5_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_5_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_5_3),
  .din(l3_in_data_5_3),
  .din_ready(l3_in_ready_5_3),

  .dout_valid(l3_out_valid_5_3),
  .dout(l3_out_data_5_3),
  .dout_ready(l3_out_ready_5_3),

  .item_count(l3_csr_readdata_5_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_5_3 > L3_TH)
    l3_almost_full_5_3 <= 1'b1;
  else
    l3_almost_full_5_3 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_6_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_6_0),
    .grant  (l2_grant_6_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_6_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_6_0),
  .din(l3_in_data_6_0),
  .din_ready(l3_in_ready_6_0),

  .dout_valid(l3_out_valid_6_0),
  .dout(l3_out_data_6_0),
  .dout_ready(l3_out_ready_6_0),

  .item_count(l3_csr_readdata_6_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_6_0 > L3_TH)
    l3_almost_full_6_0 <= 1'b1;
  else
    l3_almost_full_6_0 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_6_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_6_1),
    .grant  (l2_grant_6_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_6_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_6_1),
  .din(l3_in_data_6_1),
  .din_ready(l3_in_ready_6_1),

  .dout_valid(l3_out_valid_6_1),
  .dout(l3_out_data_6_1),
  .dout_ready(l3_out_ready_6_1),

  .item_count(l3_csr_readdata_6_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_6_1 > L3_TH)
    l3_almost_full_6_1 <= 1'b1;
  else
    l3_almost_full_6_1 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_6_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_6_2),
    .grant  (l2_grant_6_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_6_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_6_2),
  .din(l3_in_data_6_2),
  .din_ready(l3_in_ready_6_2),

  .dout_valid(l3_out_valid_6_2),
  .dout(l3_out_data_6_2),
  .dout_ready(l3_out_ready_6_2),

  .item_count(l3_csr_readdata_6_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_6_2 > L3_TH)
    l3_almost_full_6_2 <= 1'b1;
  else
    l3_almost_full_6_2 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_6_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_6_3),
    .grant  (l2_grant_6_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_6_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_6_3),
  .din(l3_in_data_6_3),
  .din_ready(l3_in_ready_6_3),

  .dout_valid(l3_out_valid_6_3),
  .dout(l3_out_data_6_3),
  .dout_ready(l3_out_ready_6_3),

  .item_count(l3_csr_readdata_6_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_6_3 > L3_TH)
    l3_almost_full_6_3 <= 1'b1;
  else
    l3_almost_full_6_3 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_7_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_7_0),
    .grant  (l2_grant_7_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_7_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_7_0),
  .din(l3_in_data_7_0),
  .din_ready(l3_in_ready_7_0),

  .dout_valid(l3_out_valid_7_0),
  .dout(l3_out_data_7_0),
  .dout_ready(l3_out_ready_7_0),

  .item_count(l3_csr_readdata_7_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_7_0 > L3_TH)
    l3_almost_full_7_0 <= 1'b1;
  else
    l3_almost_full_7_0 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_7_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_7_1),
    .grant  (l2_grant_7_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_7_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_7_1),
  .din(l3_in_data_7_1),
  .din_ready(l3_in_ready_7_1),

  .dout_valid(l3_out_valid_7_1),
  .dout(l3_out_data_7_1),
  .dout_ready(l3_out_ready_7_1),

  .item_count(l3_csr_readdata_7_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_7_1 > L3_TH)
    l3_almost_full_7_1 <= 1'b1;
  else
    l3_almost_full_7_1 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_7_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_7_2),
    .grant  (l2_grant_7_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_7_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_7_2),
  .din(l3_in_data_7_2),
  .din_ready(l3_in_ready_7_2),

  .dout_valid(l3_out_valid_7_2),
  .dout(l3_out_data_7_2),
  .dout_ready(l3_out_ready_7_2),

  .item_count(l3_csr_readdata_7_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_7_2 > L3_TH)
    l3_almost_full_7_2 <= 1'b1;
  else
    l3_almost_full_7_2 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l2_arb_7_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l2_req_7_3),
    .grant  (l2_grant_7_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l3_fifo_7_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l3_in_valid_7_3),
  .din(l3_in_data_7_3),
  .din_ready(l3_in_ready_7_3),

  .dout_valid(l3_out_valid_7_3),
  .dout(l3_out_data_7_3),
  .dout_ready(l3_out_ready_7_3),

  .item_count(l3_csr_readdata_7_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l3_csr_readdata_7_3 > L3_TH)
    l3_almost_full_7_3 <= 1'b1;
  else
    l3_almost_full_7_3 <= 1'b0;


rr_arbiter_4 #(
    .DWIDTH(4)
)
l3_arb_0(
    .clk    (clk),
    .rst    (rst),
    .req    (l3_req_0),
    .grant  (l3_grant_0)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l4_fifo_0 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l4_in_valid_0),
  .din(l4_in_data_0),
  .din_ready(l4_in_ready_0),

  .dout_valid(l4_out_valid_0),
  .dout(l4_out_data_0),
  .dout_ready(l4_out_ready_0),

  .item_count(l4_csr_readdata_0),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l4_csr_readdata_0 > L3_TH)
    l4_almost_full_0 <= 1'b1;
  else
    l4_almost_full_0 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l3_arb_1(
    .clk    (clk),
    .rst    (rst),
    .req    (l3_req_1),
    .grant  (l3_grant_1)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l4_fifo_1 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l4_in_valid_1),
  .din(l4_in_data_1),
  .din_ready(l4_in_ready_1),

  .dout_valid(l4_out_valid_1),
  .dout(l4_out_data_1),
  .dout_ready(l4_out_ready_1),

  .item_count(l4_csr_readdata_1),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l4_csr_readdata_1 > L3_TH)
    l4_almost_full_1 <= 1'b1;
  else
    l4_almost_full_1 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l3_arb_2(
    .clk    (clk),
    .rst    (rst),
    .req    (l3_req_2),
    .grant  (l3_grant_2)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l4_fifo_2 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l4_in_valid_2),
  .din(l4_in_data_2),
  .din_ready(l4_in_ready_2),

  .dout_valid(l4_out_valid_2),
  .dout(l4_out_data_2),
  .dout_ready(l4_out_ready_2),

  .item_count(l4_csr_readdata_2),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l4_csr_readdata_2 > L3_TH)
    l4_almost_full_2 <= 1'b1;
  else
    l4_almost_full_2 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l3_arb_3(
    .clk    (clk),
    .rst    (rst),
    .req    (l3_req_3),
    .grant  (l3_grant_3)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l4_fifo_3 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l4_in_valid_3),
  .din(l4_in_data_3),
  .din_ready(l4_in_ready_3),

  .dout_valid(l4_out_valid_3),
  .dout(l4_out_data_3),
  .dout_ready(l4_out_ready_3),

  .item_count(l4_csr_readdata_3),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l4_csr_readdata_3 > L3_TH)
    l4_almost_full_3 <= 1'b1;
  else
    l4_almost_full_3 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l3_arb_4(
    .clk    (clk),
    .rst    (rst),
    .req    (l3_req_4),
    .grant  (l3_grant_4)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l4_fifo_4 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l4_in_valid_4),
  .din(l4_in_data_4),
  .din_ready(l4_in_ready_4),

  .dout_valid(l4_out_valid_4),
  .dout(l4_out_data_4),
  .dout_ready(l4_out_ready_4),

  .item_count(l4_csr_readdata_4),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l4_csr_readdata_4 > L3_TH)
    l4_almost_full_4 <= 1'b1;
  else
    l4_almost_full_4 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l3_arb_5(
    .clk    (clk),
    .rst    (rst),
    .req    (l3_req_5),
    .grant  (l3_grant_5)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l4_fifo_5 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l4_in_valid_5),
  .din(l4_in_data_5),
  .din_ready(l4_in_ready_5),

  .dout_valid(l4_out_valid_5),
  .dout(l4_out_data_5),
  .dout_ready(l4_out_ready_5),

  .item_count(l4_csr_readdata_5),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l4_csr_readdata_5 > L3_TH)
    l4_almost_full_5 <= 1'b1;
  else
    l4_almost_full_5 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l3_arb_6(
    .clk    (clk),
    .rst    (rst),
    .req    (l3_req_6),
    .grant  (l3_grant_6)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l4_fifo_6 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l4_in_valid_6),
  .din(l4_in_data_6),
  .din_ready(l4_in_ready_6),

  .dout_valid(l4_out_valid_6),
  .dout(l4_out_data_6),
  .dout_ready(l4_out_ready_6),

  .item_count(l4_csr_readdata_6),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l4_csr_readdata_6 > L3_TH)
    l4_almost_full_6 <= 1'b1;
  else
    l4_almost_full_6 <= 1'b0;

rr_arbiter_4 #(
    .DWIDTH(4)
)
l3_arb_7(
    .clk    (clk),
    .rst    (rst),
    .req    (l3_req_7),
    .grant  (l3_grant_7)
);

simple_fifo # (
  .ADDR_WIDTH($clog2(FIFO_DEPTH)),
  .DATA_WIDTH(RULE_S_WIDTH)
) l4_fifo_7 (
  .clk   (clk),
  .rst   (rst),
  .clear (1'b0),

  .din_valid(l4_in_valid_7),
  .din(l4_in_data_7),
  .din_ready(l4_in_ready_7),

  .dout_valid(l4_out_valid_7),
  .dout(l4_out_data_7),
  .dout_ready(l4_out_ready_7),

  .item_count(l4_csr_readdata_7),
  .full(),
  .empty()
);

always @ (posedge clk)
  if (l4_csr_readdata_7 > L3_TH)
    l4_almost_full_7 <= 1'b1;
  else
    l4_almost_full_7 <= 1'b0;



rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(15),
    .MEM_SIZE(32768),
    .INIT_FILE("./src/memory_init/hashtable0.mif")
)
hashtable_inst_0(
    .q_a       (ht_q_0),    
    .q_b       (),    
    .address_a (ht_addr_0),
    .address_b (),
    .clk       (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(15),
    .MEM_SIZE(32768),
    .INIT_FILE("./src/memory_init/hashtable1.mif")
)
hashtable_inst_1(
    .q_a       (ht_q_1),    
    .q_b       (),    
    .address_a (ht_addr_1),
    .address_b (),
    .clk       (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(12),
    .MEM_SIZE(4096),
    .INIT_FILE("./src/memory_init/hashtable2.mif")
)
hashtable_inst_2(
    .q_a       (ht_q_2),    
    .q_b       (),    
    .address_a (ht_addr_2),
    .address_b (),
    .clk       (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(12),
    .MEM_SIZE(4096),
    .INIT_FILE("./src/memory_init/hashtable3.mif")
)
hashtable_inst_3(
    .q_a       (ht_q_3),    
    .q_b       (),    
    .address_a (ht_addr_3),
    .address_b (),
    .clk       (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(11),
    .MEM_SIZE(2048),
    .INIT_FILE("./src/memory_init/hashtable4.mif")
)
hashtable_inst_4(
    .q_a       (ht_q_4),    
    .q_b       (),    
    .address_a (ht_addr_4),
    .address_b (),
    .clk       (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(12),
    .MEM_SIZE(4096),
    .INIT_FILE("./src/memory_init/hashtable5.mif")
)
hashtable_inst_5(
    .q_a       (ht_q_5),    
    .q_b       (),    
    .address_a (ht_addr_5),
    .address_b (),
    .clk       (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(10),
    .MEM_SIZE(1024),
    .INIT_FILE("./src/memory_init/hashtable6.mif")
)
hashtable_inst_6(
    .q_a       (ht_q_6),    
    .q_b       (),    
    .address_a (ht_addr_6),
    .address_b (),
    .clk       (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(8),
    .MEM_SIZE(256),
    .INIT_FILE("./src/memory_init/hashtable7.mif")
)
hashtable_inst_7(
    .q_a       (ht_q_7),    
    .q_b       (),    
    .address_a (ht_addr_7),
    .address_b (),
    .clk       (clk)   
);

endmodule