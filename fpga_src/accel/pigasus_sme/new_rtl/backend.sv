`include "struct_s.sv"
//Rule reduction logic + rule table + rule packer + rule FIFO
module backend(
    input                clk,
    input                rst,
    input rule_s_t       in_data_0_0,
    input                in_valid_0_0,
    output logic         in_ready_0_0,
    input rule_s_t       in_data_0_1,
    input                in_valid_0_1,
    output logic         in_ready_0_1,
    input rule_s_t       in_data_0_2,
    input                in_valid_0_2,
    output logic         in_ready_0_2,
    input rule_s_t       in_data_0_3,
    input                in_valid_0_3,
    output logic         in_ready_0_3,
    input rule_s_t       in_data_0_4,
    input                in_valid_0_4,
    output logic         in_ready_0_4,
    input rule_s_t       in_data_0_5,
    input                in_valid_0_5,
    output logic         in_ready_0_5,
    input rule_s_t       in_data_0_6,
    input                in_valid_0_6,
    output logic         in_ready_0_6,
    input rule_s_t       in_data_0_7,
    input                in_valid_0_7,
    output logic         in_ready_0_7,
    input rule_s_t       in_data_0_8,
    input                in_valid_0_8,
    output logic         in_ready_0_8,
    input rule_s_t       in_data_0_9,
    input                in_valid_0_9,
    output logic         in_ready_0_9,
    input rule_s_t       in_data_0_10,
    input                in_valid_0_10,
    output logic         in_ready_0_10,
    input rule_s_t       in_data_0_11,
    input                in_valid_0_11,
    output logic         in_ready_0_11,
    input rule_s_t       in_data_0_12,
    input                in_valid_0_12,
    output logic         in_ready_0_12,
    input rule_s_t       in_data_0_13,
    input                in_valid_0_13,
    output logic         in_ready_0_13,
    input rule_s_t       in_data_0_14,
    input                in_valid_0_14,
    output logic         in_ready_0_14,
    input rule_s_t       in_data_0_15,
    input                in_valid_0_15,
    output logic         in_ready_0_15,
    input rule_s_t       in_data_1_0,
    input                in_valid_1_0,
    output logic         in_ready_1_0,
    input rule_s_t       in_data_1_1,
    input                in_valid_1_1,
    output logic         in_ready_1_1,
    input rule_s_t       in_data_1_2,
    input                in_valid_1_2,
    output logic         in_ready_1_2,
    input rule_s_t       in_data_1_3,
    input                in_valid_1_3,
    output logic         in_ready_1_3,
    input rule_s_t       in_data_1_4,
    input                in_valid_1_4,
    output logic         in_ready_1_4,
    input rule_s_t       in_data_1_5,
    input                in_valid_1_5,
    output logic         in_ready_1_5,
    input rule_s_t       in_data_1_6,
    input                in_valid_1_6,
    output logic         in_ready_1_6,
    input rule_s_t       in_data_1_7,
    input                in_valid_1_7,
    output logic         in_ready_1_7,
    input rule_s_t       in_data_1_8,
    input                in_valid_1_8,
    output logic         in_ready_1_8,
    input rule_s_t       in_data_1_9,
    input                in_valid_1_9,
    output logic         in_ready_1_9,
    input rule_s_t       in_data_1_10,
    input                in_valid_1_10,
    output logic         in_ready_1_10,
    input rule_s_t       in_data_1_11,
    input                in_valid_1_11,
    output logic         in_ready_1_11,
    input rule_s_t       in_data_1_12,
    input                in_valid_1_12,
    output logic         in_ready_1_12,
    input rule_s_t       in_data_1_13,
    input                in_valid_1_13,
    output logic         in_ready_1_13,
    input rule_s_t       in_data_1_14,
    input                in_valid_1_14,
    output logic         in_ready_1_14,
    input rule_s_t       in_data_1_15,
    input                in_valid_1_15,
    output logic         in_ready_1_15,
    input rule_s_t       in_data_2_0,
    input                in_valid_2_0,
    output logic         in_ready_2_0,
    input rule_s_t       in_data_2_1,
    input                in_valid_2_1,
    output logic         in_ready_2_1,
    input rule_s_t       in_data_2_2,
    input                in_valid_2_2,
    output logic         in_ready_2_2,
    input rule_s_t       in_data_2_3,
    input                in_valid_2_3,
    output logic         in_ready_2_3,
    input rule_s_t       in_data_2_4,
    input                in_valid_2_4,
    output logic         in_ready_2_4,
    input rule_s_t       in_data_2_5,
    input                in_valid_2_5,
    output logic         in_ready_2_5,
    input rule_s_t       in_data_2_6,
    input                in_valid_2_6,
    output logic         in_ready_2_6,
    input rule_s_t       in_data_2_7,
    input                in_valid_2_7,
    output logic         in_ready_2_7,
    input rule_s_t       in_data_2_8,
    input                in_valid_2_8,
    output logic         in_ready_2_8,
    input rule_s_t       in_data_2_9,
    input                in_valid_2_9,
    output logic         in_ready_2_9,
    input rule_s_t       in_data_2_10,
    input                in_valid_2_10,
    output logic         in_ready_2_10,
    input rule_s_t       in_data_2_11,
    input                in_valid_2_11,
    output logic         in_ready_2_11,
    input rule_s_t       in_data_2_12,
    input                in_valid_2_12,
    output logic         in_ready_2_12,
    input rule_s_t       in_data_2_13,
    input                in_valid_2_13,
    output logic         in_ready_2_13,
    input rule_s_t       in_data_2_14,
    input                in_valid_2_14,
    output logic         in_ready_2_14,
    input rule_s_t       in_data_2_15,
    input                in_valid_2_15,
    output logic         in_ready_2_15,
    input rule_s_t       in_data_3_0,
    input                in_valid_3_0,
    output logic         in_ready_3_0,
    input rule_s_t       in_data_3_1,
    input                in_valid_3_1,
    output logic         in_ready_3_1,
    input rule_s_t       in_data_3_2,
    input                in_valid_3_2,
    output logic         in_ready_3_2,
    input rule_s_t       in_data_3_3,
    input                in_valid_3_3,
    output logic         in_ready_3_3,
    input rule_s_t       in_data_3_4,
    input                in_valid_3_4,
    output logic         in_ready_3_4,
    input rule_s_t       in_data_3_5,
    input                in_valid_3_5,
    output logic         in_ready_3_5,
    input rule_s_t       in_data_3_6,
    input                in_valid_3_6,
    output logic         in_ready_3_6,
    input rule_s_t       in_data_3_7,
    input                in_valid_3_7,
    output logic         in_ready_3_7,
    input rule_s_t       in_data_3_8,
    input                in_valid_3_8,
    output logic         in_ready_3_8,
    input rule_s_t       in_data_3_9,
    input                in_valid_3_9,
    output logic         in_ready_3_9,
    input rule_s_t       in_data_3_10,
    input                in_valid_3_10,
    output logic         in_ready_3_10,
    input rule_s_t       in_data_3_11,
    input                in_valid_3_11,
    output logic         in_ready_3_11,
    input rule_s_t       in_data_3_12,
    input                in_valid_3_12,
    output logic         in_ready_3_12,
    input rule_s_t       in_data_3_13,
    input                in_valid_3_13,
    output logic         in_ready_3_13,
    input rule_s_t       in_data_3_14,
    input                in_valid_3_14,
    output logic         in_ready_3_14,
    input rule_s_t       in_data_3_15,
    input                in_valid_3_15,
    output logic         in_ready_3_15,
    input rule_s_t       in_data_4_0,
    input                in_valid_4_0,
    output logic         in_ready_4_0,
    input rule_s_t       in_data_4_1,
    input                in_valid_4_1,
    output logic         in_ready_4_1,
    input rule_s_t       in_data_4_2,
    input                in_valid_4_2,
    output logic         in_ready_4_2,
    input rule_s_t       in_data_4_3,
    input                in_valid_4_3,
    output logic         in_ready_4_3,
    input rule_s_t       in_data_4_4,
    input                in_valid_4_4,
    output logic         in_ready_4_4,
    input rule_s_t       in_data_4_5,
    input                in_valid_4_5,
    output logic         in_ready_4_5,
    input rule_s_t       in_data_4_6,
    input                in_valid_4_6,
    output logic         in_ready_4_6,
    input rule_s_t       in_data_4_7,
    input                in_valid_4_7,
    output logic         in_ready_4_7,
    input rule_s_t       in_data_4_8,
    input                in_valid_4_8,
    output logic         in_ready_4_8,
    input rule_s_t       in_data_4_9,
    input                in_valid_4_9,
    output logic         in_ready_4_9,
    input rule_s_t       in_data_4_10,
    input                in_valid_4_10,
    output logic         in_ready_4_10,
    input rule_s_t       in_data_4_11,
    input                in_valid_4_11,
    output logic         in_ready_4_11,
    input rule_s_t       in_data_4_12,
    input                in_valid_4_12,
    output logic         in_ready_4_12,
    input rule_s_t       in_data_4_13,
    input                in_valid_4_13,
    output logic         in_ready_4_13,
    input rule_s_t       in_data_4_14,
    input                in_valid_4_14,
    output logic         in_ready_4_14,
    input rule_s_t       in_data_4_15,
    input                in_valid_4_15,
    output logic         in_ready_4_15,
    input rule_s_t       in_data_5_0,
    input                in_valid_5_0,
    output logic         in_ready_5_0,
    input rule_s_t       in_data_5_1,
    input                in_valid_5_1,
    output logic         in_ready_5_1,
    input rule_s_t       in_data_5_2,
    input                in_valid_5_2,
    output logic         in_ready_5_2,
    input rule_s_t       in_data_5_3,
    input                in_valid_5_3,
    output logic         in_ready_5_3,
    input rule_s_t       in_data_5_4,
    input                in_valid_5_4,
    output logic         in_ready_5_4,
    input rule_s_t       in_data_5_5,
    input                in_valid_5_5,
    output logic         in_ready_5_5,
    input rule_s_t       in_data_5_6,
    input                in_valid_5_6,
    output logic         in_ready_5_6,
    input rule_s_t       in_data_5_7,
    input                in_valid_5_7,
    output logic         in_ready_5_7,
    input rule_s_t       in_data_5_8,
    input                in_valid_5_8,
    output logic         in_ready_5_8,
    input rule_s_t       in_data_5_9,
    input                in_valid_5_9,
    output logic         in_ready_5_9,
    input rule_s_t       in_data_5_10,
    input                in_valid_5_10,
    output logic         in_ready_5_10,
    input rule_s_t       in_data_5_11,
    input                in_valid_5_11,
    output logic         in_ready_5_11,
    input rule_s_t       in_data_5_12,
    input                in_valid_5_12,
    output logic         in_ready_5_12,
    input rule_s_t       in_data_5_13,
    input                in_valid_5_13,
    output logic         in_ready_5_13,
    input rule_s_t       in_data_5_14,
    input                in_valid_5_14,
    output logic         in_ready_5_14,
    input rule_s_t       in_data_5_15,
    input                in_valid_5_15,
    output logic         in_ready_5_15,
    input rule_s_t       in_data_6_0,
    input                in_valid_6_0,
    output logic         in_ready_6_0,
    input rule_s_t       in_data_6_1,
    input                in_valid_6_1,
    output logic         in_ready_6_1,
    input rule_s_t       in_data_6_2,
    input                in_valid_6_2,
    output logic         in_ready_6_2,
    input rule_s_t       in_data_6_3,
    input                in_valid_6_3,
    output logic         in_ready_6_3,
    input rule_s_t       in_data_6_4,
    input                in_valid_6_4,
    output logic         in_ready_6_4,
    input rule_s_t       in_data_6_5,
    input                in_valid_6_5,
    output logic         in_ready_6_5,
    input rule_s_t       in_data_6_6,
    input                in_valid_6_6,
    output logic         in_ready_6_6,
    input rule_s_t       in_data_6_7,
    input                in_valid_6_7,
    output logic         in_ready_6_7,
    input rule_s_t       in_data_6_8,
    input                in_valid_6_8,
    output logic         in_ready_6_8,
    input rule_s_t       in_data_6_9,
    input                in_valid_6_9,
    output logic         in_ready_6_9,
    input rule_s_t       in_data_6_10,
    input                in_valid_6_10,
    output logic         in_ready_6_10,
    input rule_s_t       in_data_6_11,
    input                in_valid_6_11,
    output logic         in_ready_6_11,
    input rule_s_t       in_data_6_12,
    input                in_valid_6_12,
    output logic         in_ready_6_12,
    input rule_s_t       in_data_6_13,
    input                in_valid_6_13,
    output logic         in_ready_6_13,
    input rule_s_t       in_data_6_14,
    input                in_valid_6_14,
    output logic         in_ready_6_14,
    input rule_s_t       in_data_6_15,
    input                in_valid_6_15,
    output logic         in_ready_6_15,
    input rule_s_t       in_data_7_0,
    input                in_valid_7_0,
    output logic         in_ready_7_0,
    input rule_s_t       in_data_7_1,
    input                in_valid_7_1,
    output logic         in_ready_7_1,
    input rule_s_t       in_data_7_2,
    input                in_valid_7_2,
    output logic         in_ready_7_2,
    input rule_s_t       in_data_7_3,
    input                in_valid_7_3,
    output logic         in_ready_7_3,
    input rule_s_t       in_data_7_4,
    input                in_valid_7_4,
    output logic         in_ready_7_4,
    input rule_s_t       in_data_7_5,
    input                in_valid_7_5,
    output logic         in_ready_7_5,
    input rule_s_t       in_data_7_6,
    input                in_valid_7_6,
    output logic         in_ready_7_6,
    input rule_s_t       in_data_7_7,
    input                in_valid_7_7,
    output logic         in_ready_7_7,
    input rule_s_t       in_data_7_8,
    input                in_valid_7_8,
    output logic         in_ready_7_8,
    input rule_s_t       in_data_7_9,
    input                in_valid_7_9,
    output logic         in_ready_7_9,
    input rule_s_t       in_data_7_10,
    input                in_valid_7_10,
    output logic         in_ready_7_10,
    input rule_s_t       in_data_7_11,
    input                in_valid_7_11,
    output logic         in_ready_7_11,
    input rule_s_t       in_data_7_12,
    input                in_valid_7_12,
    output logic         in_ready_7_12,
    input rule_s_t       in_data_7_13,
    input                in_valid_7_13,
    output logic         in_ready_7_13,
    input rule_s_t       in_data_7_14,
    input                in_valid_7_14,
    output logic         in_ready_7_14,
    input rule_s_t       in_data_7_15,
    input                in_valid_7_15,
    output logic         in_ready_7_15,
    output logic [511:0] out_usr_data,
    output logic         out_usr_valid,
    output logic         out_usr_sop,
    output logic         out_usr_eop,
    output logic [5:0]   out_usr_empty,
    input                out_usr_ready
);

rule_s_t  data_0_0_0;
logic     valid_0_0_0;
logic     ready_0_0_0;
rule_s_t  data_0_0_1;
logic     valid_0_0_1;
logic     ready_0_0_1;
rule_s_t  data_0_0_2;
logic     valid_0_0_2;
logic     ready_0_0_2;
rule_s_t  data_0_0_3;
logic     valid_0_0_3;
logic     ready_0_0_3;
rule_s_t  data_0_0_4;
logic     valid_0_0_4;
logic     ready_0_0_4;
rule_s_t  data_0_0_5;
logic     valid_0_0_5;
logic     ready_0_0_5;
rule_s_t  data_0_0_6;
logic     valid_0_0_6;
logic     ready_0_0_6;
rule_s_t  data_0_0_7;
logic     valid_0_0_7;
logic     ready_0_0_7;
rule_s_t  data_0_0_8;
logic     valid_0_0_8;
logic     ready_0_0_8;
rule_s_t  data_0_0_9;
logic     valid_0_0_9;
logic     ready_0_0_9;
rule_s_t  data_0_0_10;
logic     valid_0_0_10;
logic     ready_0_0_10;
rule_s_t  data_0_0_11;
logic     valid_0_0_11;
logic     ready_0_0_11;
rule_s_t  data_0_0_12;
logic     valid_0_0_12;
logic     ready_0_0_12;
rule_s_t  data_0_0_13;
logic     valid_0_0_13;
logic     ready_0_0_13;
rule_s_t  data_0_0_14;
logic     valid_0_0_14;
logic     ready_0_0_14;
rule_s_t  data_0_0_15;
logic     valid_0_0_15;
logic     ready_0_0_15;
rule_s_t  data_0_1_0;
logic     valid_0_1_0;
logic     ready_0_1_0;
rule_s_t  data_0_1_1;
logic     valid_0_1_1;
logic     ready_0_1_1;
rule_s_t  data_0_1_2;
logic     valid_0_1_2;
logic     ready_0_1_2;
rule_s_t  data_0_1_3;
logic     valid_0_1_3;
logic     ready_0_1_3;
rule_s_t  data_0_1_4;
logic     valid_0_1_4;
logic     ready_0_1_4;
rule_s_t  data_0_1_5;
logic     valid_0_1_5;
logic     ready_0_1_5;
rule_s_t  data_0_1_6;
logic     valid_0_1_6;
logic     ready_0_1_6;
rule_s_t  data_0_1_7;
logic     valid_0_1_7;
logic     ready_0_1_7;
rule_s_t  data_0_2_0;
logic     valid_0_2_0;
logic     ready_0_2_0;
rule_s_t  data_0_2_1;
logic     valid_0_2_1;
logic     ready_0_2_1;
rule_s_t  data_0_2_2;
logic     valid_0_2_2;
logic     ready_0_2_2;
rule_s_t  data_0_2_3;
logic     valid_0_2_3;
logic     ready_0_2_3;
rule_s_t  data_1_0_0;
logic     valid_1_0_0;
logic     ready_1_0_0;
rule_s_t  data_1_0_1;
logic     valid_1_0_1;
logic     ready_1_0_1;
rule_s_t  data_1_0_2;
logic     valid_1_0_2;
logic     ready_1_0_2;
rule_s_t  data_1_0_3;
logic     valid_1_0_3;
logic     ready_1_0_3;
rule_s_t  data_1_0_4;
logic     valid_1_0_4;
logic     ready_1_0_4;
rule_s_t  data_1_0_5;
logic     valid_1_0_5;
logic     ready_1_0_5;
rule_s_t  data_1_0_6;
logic     valid_1_0_6;
logic     ready_1_0_6;
rule_s_t  data_1_0_7;
logic     valid_1_0_7;
logic     ready_1_0_7;
rule_s_t  data_1_0_8;
logic     valid_1_0_8;
logic     ready_1_0_8;
rule_s_t  data_1_0_9;
logic     valid_1_0_9;
logic     ready_1_0_9;
rule_s_t  data_1_0_10;
logic     valid_1_0_10;
logic     ready_1_0_10;
rule_s_t  data_1_0_11;
logic     valid_1_0_11;
logic     ready_1_0_11;
rule_s_t  data_1_0_12;
logic     valid_1_0_12;
logic     ready_1_0_12;
rule_s_t  data_1_0_13;
logic     valid_1_0_13;
logic     ready_1_0_13;
rule_s_t  data_1_0_14;
logic     valid_1_0_14;
logic     ready_1_0_14;
rule_s_t  data_1_0_15;
logic     valid_1_0_15;
logic     ready_1_0_15;
rule_s_t  data_1_1_0;
logic     valid_1_1_0;
logic     ready_1_1_0;
rule_s_t  data_1_1_1;
logic     valid_1_1_1;
logic     ready_1_1_1;
rule_s_t  data_1_1_2;
logic     valid_1_1_2;
logic     ready_1_1_2;
rule_s_t  data_1_1_3;
logic     valid_1_1_3;
logic     ready_1_1_3;
rule_s_t  data_1_1_4;
logic     valid_1_1_4;
logic     ready_1_1_4;
rule_s_t  data_1_1_5;
logic     valid_1_1_5;
logic     ready_1_1_5;
rule_s_t  data_1_1_6;
logic     valid_1_1_6;
logic     ready_1_1_6;
rule_s_t  data_1_1_7;
logic     valid_1_1_7;
logic     ready_1_1_7;
rule_s_t  data_1_2_0;
logic     valid_1_2_0;
logic     ready_1_2_0;
rule_s_t  data_1_2_1;
logic     valid_1_2_1;
logic     ready_1_2_1;
rule_s_t  data_1_2_2;
logic     valid_1_2_2;
logic     ready_1_2_2;
rule_s_t  data_1_2_3;
logic     valid_1_2_3;
logic     ready_1_2_3;
rule_s_t  data_2_0_0;
logic     valid_2_0_0;
logic     ready_2_0_0;
rule_s_t  data_2_0_1;
logic     valid_2_0_1;
logic     ready_2_0_1;
rule_s_t  data_2_0_2;
logic     valid_2_0_2;
logic     ready_2_0_2;
rule_s_t  data_2_0_3;
logic     valid_2_0_3;
logic     ready_2_0_3;
rule_s_t  data_2_0_4;
logic     valid_2_0_4;
logic     ready_2_0_4;
rule_s_t  data_2_0_5;
logic     valid_2_0_5;
logic     ready_2_0_5;
rule_s_t  data_2_0_6;
logic     valid_2_0_6;
logic     ready_2_0_6;
rule_s_t  data_2_0_7;
logic     valid_2_0_7;
logic     ready_2_0_7;
rule_s_t  data_2_0_8;
logic     valid_2_0_8;
logic     ready_2_0_8;
rule_s_t  data_2_0_9;
logic     valid_2_0_9;
logic     ready_2_0_9;
rule_s_t  data_2_0_10;
logic     valid_2_0_10;
logic     ready_2_0_10;
rule_s_t  data_2_0_11;
logic     valid_2_0_11;
logic     ready_2_0_11;
rule_s_t  data_2_0_12;
logic     valid_2_0_12;
logic     ready_2_0_12;
rule_s_t  data_2_0_13;
logic     valid_2_0_13;
logic     ready_2_0_13;
rule_s_t  data_2_0_14;
logic     valid_2_0_14;
logic     ready_2_0_14;
rule_s_t  data_2_0_15;
logic     valid_2_0_15;
logic     ready_2_0_15;
rule_s_t  data_2_1_0;
logic     valid_2_1_0;
logic     ready_2_1_0;
rule_s_t  data_2_1_1;
logic     valid_2_1_1;
logic     ready_2_1_1;
rule_s_t  data_2_1_2;
logic     valid_2_1_2;
logic     ready_2_1_2;
rule_s_t  data_2_1_3;
logic     valid_2_1_3;
logic     ready_2_1_3;
rule_s_t  data_2_1_4;
logic     valid_2_1_4;
logic     ready_2_1_4;
rule_s_t  data_2_1_5;
logic     valid_2_1_5;
logic     ready_2_1_5;
rule_s_t  data_2_1_6;
logic     valid_2_1_6;
logic     ready_2_1_6;
rule_s_t  data_2_1_7;
logic     valid_2_1_7;
logic     ready_2_1_7;
rule_s_t  data_2_2_0;
logic     valid_2_2_0;
logic     ready_2_2_0;
rule_s_t  data_2_2_1;
logic     valid_2_2_1;
logic     ready_2_2_1;
rule_s_t  data_2_2_2;
logic     valid_2_2_2;
logic     ready_2_2_2;
rule_s_t  data_2_2_3;
logic     valid_2_2_3;
logic     ready_2_2_3;
rule_s_t  data_3_0_0;
logic     valid_3_0_0;
logic     ready_3_0_0;
rule_s_t  data_3_0_1;
logic     valid_3_0_1;
logic     ready_3_0_1;
rule_s_t  data_3_0_2;
logic     valid_3_0_2;
logic     ready_3_0_2;
rule_s_t  data_3_0_3;
logic     valid_3_0_3;
logic     ready_3_0_3;
rule_s_t  data_3_0_4;
logic     valid_3_0_4;
logic     ready_3_0_4;
rule_s_t  data_3_0_5;
logic     valid_3_0_5;
logic     ready_3_0_5;
rule_s_t  data_3_0_6;
logic     valid_3_0_6;
logic     ready_3_0_6;
rule_s_t  data_3_0_7;
logic     valid_3_0_7;
logic     ready_3_0_7;
rule_s_t  data_3_0_8;
logic     valid_3_0_8;
logic     ready_3_0_8;
rule_s_t  data_3_0_9;
logic     valid_3_0_9;
logic     ready_3_0_9;
rule_s_t  data_3_0_10;
logic     valid_3_0_10;
logic     ready_3_0_10;
rule_s_t  data_3_0_11;
logic     valid_3_0_11;
logic     ready_3_0_11;
rule_s_t  data_3_0_12;
logic     valid_3_0_12;
logic     ready_3_0_12;
rule_s_t  data_3_0_13;
logic     valid_3_0_13;
logic     ready_3_0_13;
rule_s_t  data_3_0_14;
logic     valid_3_0_14;
logic     ready_3_0_14;
rule_s_t  data_3_0_15;
logic     valid_3_0_15;
logic     ready_3_0_15;
rule_s_t  data_3_1_0;
logic     valid_3_1_0;
logic     ready_3_1_0;
rule_s_t  data_3_1_1;
logic     valid_3_1_1;
logic     ready_3_1_1;
rule_s_t  data_3_1_2;
logic     valid_3_1_2;
logic     ready_3_1_2;
rule_s_t  data_3_1_3;
logic     valid_3_1_3;
logic     ready_3_1_3;
rule_s_t  data_3_1_4;
logic     valid_3_1_4;
logic     ready_3_1_4;
rule_s_t  data_3_1_5;
logic     valid_3_1_5;
logic     ready_3_1_5;
rule_s_t  data_3_1_6;
logic     valid_3_1_6;
logic     ready_3_1_6;
rule_s_t  data_3_1_7;
logic     valid_3_1_7;
logic     ready_3_1_7;
rule_s_t  data_3_2_0;
logic     valid_3_2_0;
logic     ready_3_2_0;
rule_s_t  data_3_2_1;
logic     valid_3_2_1;
logic     ready_3_2_1;
rule_s_t  data_3_2_2;
logic     valid_3_2_2;
logic     ready_3_2_2;
rule_s_t  data_3_2_3;
logic     valid_3_2_3;
logic     ready_3_2_3;
rule_s_t  data_4_0_0;
logic     valid_4_0_0;
logic     ready_4_0_0;
rule_s_t  data_4_0_1;
logic     valid_4_0_1;
logic     ready_4_0_1;
rule_s_t  data_4_0_2;
logic     valid_4_0_2;
logic     ready_4_0_2;
rule_s_t  data_4_0_3;
logic     valid_4_0_3;
logic     ready_4_0_3;
rule_s_t  data_4_0_4;
logic     valid_4_0_4;
logic     ready_4_0_4;
rule_s_t  data_4_0_5;
logic     valid_4_0_5;
logic     ready_4_0_5;
rule_s_t  data_4_0_6;
logic     valid_4_0_6;
logic     ready_4_0_6;
rule_s_t  data_4_0_7;
logic     valid_4_0_7;
logic     ready_4_0_7;
rule_s_t  data_4_0_8;
logic     valid_4_0_8;
logic     ready_4_0_8;
rule_s_t  data_4_0_9;
logic     valid_4_0_9;
logic     ready_4_0_9;
rule_s_t  data_4_0_10;
logic     valid_4_0_10;
logic     ready_4_0_10;
rule_s_t  data_4_0_11;
logic     valid_4_0_11;
logic     ready_4_0_11;
rule_s_t  data_4_0_12;
logic     valid_4_0_12;
logic     ready_4_0_12;
rule_s_t  data_4_0_13;
logic     valid_4_0_13;
logic     ready_4_0_13;
rule_s_t  data_4_0_14;
logic     valid_4_0_14;
logic     ready_4_0_14;
rule_s_t  data_4_0_15;
logic     valid_4_0_15;
logic     ready_4_0_15;
rule_s_t  data_4_1_0;
logic     valid_4_1_0;
logic     ready_4_1_0;
rule_s_t  data_4_1_1;
logic     valid_4_1_1;
logic     ready_4_1_1;
rule_s_t  data_4_1_2;
logic     valid_4_1_2;
logic     ready_4_1_2;
rule_s_t  data_4_1_3;
logic     valid_4_1_3;
logic     ready_4_1_3;
rule_s_t  data_4_1_4;
logic     valid_4_1_4;
logic     ready_4_1_4;
rule_s_t  data_4_1_5;
logic     valid_4_1_5;
logic     ready_4_1_5;
rule_s_t  data_4_1_6;
logic     valid_4_1_6;
logic     ready_4_1_6;
rule_s_t  data_4_1_7;
logic     valid_4_1_7;
logic     ready_4_1_7;
rule_s_t  data_4_2_0;
logic     valid_4_2_0;
logic     ready_4_2_0;
rule_s_t  data_4_2_1;
logic     valid_4_2_1;
logic     ready_4_2_1;
rule_s_t  data_4_2_2;
logic     valid_4_2_2;
logic     ready_4_2_2;
rule_s_t  data_4_2_3;
logic     valid_4_2_3;
logic     ready_4_2_3;
rule_s_t  data_5_0_0;
logic     valid_5_0_0;
logic     ready_5_0_0;
rule_s_t  data_5_0_1;
logic     valid_5_0_1;
logic     ready_5_0_1;
rule_s_t  data_5_0_2;
logic     valid_5_0_2;
logic     ready_5_0_2;
rule_s_t  data_5_0_3;
logic     valid_5_0_3;
logic     ready_5_0_3;
rule_s_t  data_5_0_4;
logic     valid_5_0_4;
logic     ready_5_0_4;
rule_s_t  data_5_0_5;
logic     valid_5_0_5;
logic     ready_5_0_5;
rule_s_t  data_5_0_6;
logic     valid_5_0_6;
logic     ready_5_0_6;
rule_s_t  data_5_0_7;
logic     valid_5_0_7;
logic     ready_5_0_7;
rule_s_t  data_5_0_8;
logic     valid_5_0_8;
logic     ready_5_0_8;
rule_s_t  data_5_0_9;
logic     valid_5_0_9;
logic     ready_5_0_9;
rule_s_t  data_5_0_10;
logic     valid_5_0_10;
logic     ready_5_0_10;
rule_s_t  data_5_0_11;
logic     valid_5_0_11;
logic     ready_5_0_11;
rule_s_t  data_5_0_12;
logic     valid_5_0_12;
logic     ready_5_0_12;
rule_s_t  data_5_0_13;
logic     valid_5_0_13;
logic     ready_5_0_13;
rule_s_t  data_5_0_14;
logic     valid_5_0_14;
logic     ready_5_0_14;
rule_s_t  data_5_0_15;
logic     valid_5_0_15;
logic     ready_5_0_15;
rule_s_t  data_5_1_0;
logic     valid_5_1_0;
logic     ready_5_1_0;
rule_s_t  data_5_1_1;
logic     valid_5_1_1;
logic     ready_5_1_1;
rule_s_t  data_5_1_2;
logic     valid_5_1_2;
logic     ready_5_1_2;
rule_s_t  data_5_1_3;
logic     valid_5_1_3;
logic     ready_5_1_3;
rule_s_t  data_5_1_4;
logic     valid_5_1_4;
logic     ready_5_1_4;
rule_s_t  data_5_1_5;
logic     valid_5_1_5;
logic     ready_5_1_5;
rule_s_t  data_5_1_6;
logic     valid_5_1_6;
logic     ready_5_1_6;
rule_s_t  data_5_1_7;
logic     valid_5_1_7;
logic     ready_5_1_7;
rule_s_t  data_5_2_0;
logic     valid_5_2_0;
logic     ready_5_2_0;
rule_s_t  data_5_2_1;
logic     valid_5_2_1;
logic     ready_5_2_1;
rule_s_t  data_5_2_2;
logic     valid_5_2_2;
logic     ready_5_2_2;
rule_s_t  data_5_2_3;
logic     valid_5_2_3;
logic     ready_5_2_3;
rule_s_t  data_6_0_0;
logic     valid_6_0_0;
logic     ready_6_0_0;
rule_s_t  data_6_0_1;
logic     valid_6_0_1;
logic     ready_6_0_1;
rule_s_t  data_6_0_2;
logic     valid_6_0_2;
logic     ready_6_0_2;
rule_s_t  data_6_0_3;
logic     valid_6_0_3;
logic     ready_6_0_3;
rule_s_t  data_6_0_4;
logic     valid_6_0_4;
logic     ready_6_0_4;
rule_s_t  data_6_0_5;
logic     valid_6_0_5;
logic     ready_6_0_5;
rule_s_t  data_6_0_6;
logic     valid_6_0_6;
logic     ready_6_0_6;
rule_s_t  data_6_0_7;
logic     valid_6_0_7;
logic     ready_6_0_7;
rule_s_t  data_6_0_8;
logic     valid_6_0_8;
logic     ready_6_0_8;
rule_s_t  data_6_0_9;
logic     valid_6_0_9;
logic     ready_6_0_9;
rule_s_t  data_6_0_10;
logic     valid_6_0_10;
logic     ready_6_0_10;
rule_s_t  data_6_0_11;
logic     valid_6_0_11;
logic     ready_6_0_11;
rule_s_t  data_6_0_12;
logic     valid_6_0_12;
logic     ready_6_0_12;
rule_s_t  data_6_0_13;
logic     valid_6_0_13;
logic     ready_6_0_13;
rule_s_t  data_6_0_14;
logic     valid_6_0_14;
logic     ready_6_0_14;
rule_s_t  data_6_0_15;
logic     valid_6_0_15;
logic     ready_6_0_15;
rule_s_t  data_6_1_0;
logic     valid_6_1_0;
logic     ready_6_1_0;
rule_s_t  data_6_1_1;
logic     valid_6_1_1;
logic     ready_6_1_1;
rule_s_t  data_6_1_2;
logic     valid_6_1_2;
logic     ready_6_1_2;
rule_s_t  data_6_1_3;
logic     valid_6_1_3;
logic     ready_6_1_3;
rule_s_t  data_6_1_4;
logic     valid_6_1_4;
logic     ready_6_1_4;
rule_s_t  data_6_1_5;
logic     valid_6_1_5;
logic     ready_6_1_5;
rule_s_t  data_6_1_6;
logic     valid_6_1_6;
logic     ready_6_1_6;
rule_s_t  data_6_1_7;
logic     valid_6_1_7;
logic     ready_6_1_7;
rule_s_t  data_6_2_0;
logic     valid_6_2_0;
logic     ready_6_2_0;
rule_s_t  data_6_2_1;
logic     valid_6_2_1;
logic     ready_6_2_1;
rule_s_t  data_6_2_2;
logic     valid_6_2_2;
logic     ready_6_2_2;
rule_s_t  data_6_2_3;
logic     valid_6_2_3;
logic     ready_6_2_3;
rule_s_t  data_7_0_0;
logic     valid_7_0_0;
logic     ready_7_0_0;
rule_s_t  data_7_0_1;
logic     valid_7_0_1;
logic     ready_7_0_1;
rule_s_t  data_7_0_2;
logic     valid_7_0_2;
logic     ready_7_0_2;
rule_s_t  data_7_0_3;
logic     valid_7_0_3;
logic     ready_7_0_3;
rule_s_t  data_7_0_4;
logic     valid_7_0_4;
logic     ready_7_0_4;
rule_s_t  data_7_0_5;
logic     valid_7_0_5;
logic     ready_7_0_5;
rule_s_t  data_7_0_6;
logic     valid_7_0_6;
logic     ready_7_0_6;
rule_s_t  data_7_0_7;
logic     valid_7_0_7;
logic     ready_7_0_7;
rule_s_t  data_7_0_8;
logic     valid_7_0_8;
logic     ready_7_0_8;
rule_s_t  data_7_0_9;
logic     valid_7_0_9;
logic     ready_7_0_9;
rule_s_t  data_7_0_10;
logic     valid_7_0_10;
logic     ready_7_0_10;
rule_s_t  data_7_0_11;
logic     valid_7_0_11;
logic     ready_7_0_11;
rule_s_t  data_7_0_12;
logic     valid_7_0_12;
logic     ready_7_0_12;
rule_s_t  data_7_0_13;
logic     valid_7_0_13;
logic     ready_7_0_13;
rule_s_t  data_7_0_14;
logic     valid_7_0_14;
logic     ready_7_0_14;
rule_s_t  data_7_0_15;
logic     valid_7_0_15;
logic     ready_7_0_15;
rule_s_t  data_7_1_0;
logic     valid_7_1_0;
logic     ready_7_1_0;
rule_s_t  data_7_1_1;
logic     valid_7_1_1;
logic     ready_7_1_1;
rule_s_t  data_7_1_2;
logic     valid_7_1_2;
logic     ready_7_1_2;
rule_s_t  data_7_1_3;
logic     valid_7_1_3;
logic     ready_7_1_3;
rule_s_t  data_7_1_4;
logic     valid_7_1_4;
logic     ready_7_1_4;
rule_s_t  data_7_1_5;
logic     valid_7_1_5;
logic     ready_7_1_5;
rule_s_t  data_7_1_6;
logic     valid_7_1_6;
logic     ready_7_1_6;
rule_s_t  data_7_1_7;
logic     valid_7_1_7;
logic     ready_7_1_7;
rule_s_t  data_7_2_0;
logic     valid_7_2_0;
logic     ready_7_2_0;
rule_s_t  data_7_2_1;
logic     valid_7_2_1;
logic     ready_7_2_1;
rule_s_t  data_7_2_2;
logic     valid_7_2_2;
logic     ready_7_2_2;
rule_s_t  data_7_2_3;
logic     valid_7_2_3;
logic     ready_7_2_3;

rule_s_t  last_layer_data_0_0;
logic     last_layer_valid_0_0;
logic     last_layer_ready_0_0;
rule_s_t  last_layer_data_0_1;
logic     last_layer_valid_0_1;
logic     last_layer_ready_0_1;
rule_s_t  last_layer_data_1_0;
logic     last_layer_valid_1_0;
logic     last_layer_ready_1_0;
rule_s_t  last_layer_data_1_1;
logic     last_layer_valid_1_1;
logic     last_layer_ready_1_1;
rule_s_t  last_layer_data_2_0;
logic     last_layer_valid_2_0;
logic     last_layer_ready_2_0;
rule_s_t  last_layer_data_2_1;
logic     last_layer_valid_2_1;
logic     last_layer_ready_2_1;
rule_s_t  last_layer_data_3_0;
logic     last_layer_valid_3_0;
logic     last_layer_ready_3_0;
rule_s_t  last_layer_data_3_1;
logic     last_layer_valid_3_1;
logic     last_layer_ready_3_1;
rule_s_t  last_layer_data_4_0;
logic     last_layer_valid_4_0;
logic     last_layer_ready_4_0;
rule_s_t  last_layer_data_4_1;
logic     last_layer_valid_4_1;
logic     last_layer_ready_4_1;
rule_s_t  last_layer_data_5_0;
logic     last_layer_valid_5_0;
logic     last_layer_ready_5_0;
rule_s_t  last_layer_data_5_1;
logic     last_layer_valid_5_1;
logic     last_layer_ready_5_1;
rule_s_t  last_layer_data_6_0;
logic     last_layer_valid_6_0;
logic     last_layer_ready_6_0;
rule_s_t  last_layer_data_6_1;
logic     last_layer_valid_6_1;
logic     last_layer_ready_6_1;
rule_s_t  last_layer_data_7_0;
logic     last_layer_valid_7_0;
logic     last_layer_ready_7_0;
rule_s_t  last_layer_data_7_1;
logic     last_layer_valid_7_1;
logic     last_layer_ready_7_1;

//hastables
logic [RID_WIDTH-1:0] ht_addr_0_0;
logic [RID_WIDTH-1:0] ht_q_0_0;
logic ht_rd_0_0;
logic ht_rd_r1_0_0;
logic ht_rd_r2_0_0;
logic ht_rd_valid_0_0;
logic [RID_WIDTH-1:0] ht_data_0_0;
logic [RID_WIDTH-1:0] ht_addr_0_1;
logic [RID_WIDTH-1:0] ht_q_0_1;
logic ht_rd_0_1;
logic ht_rd_r1_0_1;
logic ht_rd_r2_0_1;
logic ht_rd_valid_0_1;
logic [RID_WIDTH-1:0] ht_data_0_1;
logic [RID_WIDTH-1:0] ht_addr_1_0;
logic [RID_WIDTH-1:0] ht_q_1_0;
logic ht_rd_1_0;
logic ht_rd_r1_1_0;
logic ht_rd_r2_1_0;
logic ht_rd_valid_1_0;
logic [RID_WIDTH-1:0] ht_data_1_0;
logic [RID_WIDTH-1:0] ht_addr_1_1;
logic [RID_WIDTH-1:0] ht_q_1_1;
logic ht_rd_1_1;
logic ht_rd_r1_1_1;
logic ht_rd_r2_1_1;
logic ht_rd_valid_1_1;
logic [RID_WIDTH-1:0] ht_data_1_1;
logic [RID_WIDTH-1:0] ht_addr_2_0;
logic [RID_WIDTH-1:0] ht_q_2_0;
logic ht_rd_2_0;
logic ht_rd_r1_2_0;
logic ht_rd_r2_2_0;
logic ht_rd_valid_2_0;
logic [RID_WIDTH-1:0] ht_data_2_0;
logic [RID_WIDTH-1:0] ht_addr_2_1;
logic [RID_WIDTH-1:0] ht_q_2_1;
logic ht_rd_2_1;
logic ht_rd_r1_2_1;
logic ht_rd_r2_2_1;
logic ht_rd_valid_2_1;
logic [RID_WIDTH-1:0] ht_data_2_1;
logic [RID_WIDTH-1:0] ht_addr_3_0;
logic [RID_WIDTH-1:0] ht_q_3_0;
logic ht_rd_3_0;
logic ht_rd_r1_3_0;
logic ht_rd_r2_3_0;
logic ht_rd_valid_3_0;
logic [RID_WIDTH-1:0] ht_data_3_0;
logic [RID_WIDTH-1:0] ht_addr_3_1;
logic [RID_WIDTH-1:0] ht_q_3_1;
logic ht_rd_3_1;
logic ht_rd_r1_3_1;
logic ht_rd_r2_3_1;
logic ht_rd_valid_3_1;
logic [RID_WIDTH-1:0] ht_data_3_1;
logic [RID_WIDTH-1:0] ht_addr_4_0;
logic [RID_WIDTH-1:0] ht_q_4_0;
logic ht_rd_4_0;
logic ht_rd_r1_4_0;
logic ht_rd_r2_4_0;
logic ht_rd_valid_4_0;
logic [RID_WIDTH-1:0] ht_data_4_0;
logic [RID_WIDTH-1:0] ht_addr_4_1;
logic [RID_WIDTH-1:0] ht_q_4_1;
logic ht_rd_4_1;
logic ht_rd_r1_4_1;
logic ht_rd_r2_4_1;
logic ht_rd_valid_4_1;
logic [RID_WIDTH-1:0] ht_data_4_1;
logic [RID_WIDTH-1:0] ht_addr_5_0;
logic [RID_WIDTH-1:0] ht_q_5_0;
logic ht_rd_5_0;
logic ht_rd_r1_5_0;
logic ht_rd_r2_5_0;
logic ht_rd_valid_5_0;
logic [RID_WIDTH-1:0] ht_data_5_0;
logic [RID_WIDTH-1:0] ht_addr_5_1;
logic [RID_WIDTH-1:0] ht_q_5_1;
logic ht_rd_5_1;
logic ht_rd_r1_5_1;
logic ht_rd_r2_5_1;
logic ht_rd_valid_5_1;
logic [RID_WIDTH-1:0] ht_data_5_1;
logic [RID_WIDTH-1:0] ht_addr_6_0;
logic [RID_WIDTH-1:0] ht_q_6_0;
logic ht_rd_6_0;
logic ht_rd_r1_6_0;
logic ht_rd_r2_6_0;
logic ht_rd_valid_6_0;
logic [RID_WIDTH-1:0] ht_data_6_0;
logic [RID_WIDTH-1:0] ht_addr_6_1;
logic [RID_WIDTH-1:0] ht_q_6_1;
logic ht_rd_6_1;
logic ht_rd_r1_6_1;
logic ht_rd_r2_6_1;
logic ht_rd_valid_6_1;
logic [RID_WIDTH-1:0] ht_data_6_1;
logic [RID_WIDTH-1:0] ht_addr_7_0;
logic [RID_WIDTH-1:0] ht_q_7_0;
logic ht_rd_7_0;
logic ht_rd_r1_7_0;
logic ht_rd_r2_7_0;
logic ht_rd_valid_7_0;
logic [RID_WIDTH-1:0] ht_data_7_0;
logic [RID_WIDTH-1:0] ht_addr_7_1;
logic [RID_WIDTH-1:0] ht_q_7_1;
logic ht_rd_7_1;
logic ht_rd_r1_7_1;
logic ht_rd_r2_7_1;
logic ht_rd_valid_7_1;
logic [RID_WIDTH-1:0] ht_data_7_1;

logic [255:0] int_data;
logic         int_valid;
logic         int_sop;
logic         int_eop;
logic [4:0]   int_empty;
logic         int_ready;
logic [31:0]  int_csr_readdata;
logic         int_almost_full;
logic [7:0]   int_cnt;//Assume one pkt cannot trigger 256 of rule_flit.

logic [255:0] int_usr_data;
logic         int_usr_valid;
logic         int_usr_sop;
logic         int_usr_eop;
logic [4:0]   int_usr_empty;
logic         int_usr_ready;

logic         all_last;
logic         all_last_r1;
logic         all_last_r2;
logic         all_last_r3;

logic [31:0]  rule_packer_csr_readdata;
logic [511:0] rule_packer_data;
logic         rule_packer_valid;
logic         rule_packer_sop;
logic         rule_packer_eop;
logic [5:0]   rule_packer_empty;
logic         rule_packer_ready;


//Assign layer 0 input
assign data_0_0_0 = in_data_0_0;
assign valid_0_0_0 = in_valid_0_0;
assign in_ready_0_0 = ready_0_0_0;
assign data_0_0_1 = in_data_0_1;
assign valid_0_0_1 = in_valid_0_1;
assign in_ready_0_1 = ready_0_0_1;
assign data_0_0_2 = in_data_0_2;
assign valid_0_0_2 = in_valid_0_2;
assign in_ready_0_2 = ready_0_0_2;
assign data_0_0_3 = in_data_0_3;
assign valid_0_0_3 = in_valid_0_3;
assign in_ready_0_3 = ready_0_0_3;
assign data_0_0_4 = in_data_0_4;
assign valid_0_0_4 = in_valid_0_4;
assign in_ready_0_4 = ready_0_0_4;
assign data_0_0_5 = in_data_0_5;
assign valid_0_0_5 = in_valid_0_5;
assign in_ready_0_5 = ready_0_0_5;
assign data_0_0_6 = in_data_0_6;
assign valid_0_0_6 = in_valid_0_6;
assign in_ready_0_6 = ready_0_0_6;
assign data_0_0_7 = in_data_0_7;
assign valid_0_0_7 = in_valid_0_7;
assign in_ready_0_7 = ready_0_0_7;
assign data_0_0_8 = in_data_0_8;
assign valid_0_0_8 = in_valid_0_8;
assign in_ready_0_8 = ready_0_0_8;
assign data_0_0_9 = in_data_0_9;
assign valid_0_0_9 = in_valid_0_9;
assign in_ready_0_9 = ready_0_0_9;
assign data_0_0_10 = in_data_0_10;
assign valid_0_0_10 = in_valid_0_10;
assign in_ready_0_10 = ready_0_0_10;
assign data_0_0_11 = in_data_0_11;
assign valid_0_0_11 = in_valid_0_11;
assign in_ready_0_11 = ready_0_0_11;
assign data_0_0_12 = in_data_0_12;
assign valid_0_0_12 = in_valid_0_12;
assign in_ready_0_12 = ready_0_0_12;
assign data_0_0_13 = in_data_0_13;
assign valid_0_0_13 = in_valid_0_13;
assign in_ready_0_13 = ready_0_0_13;
assign data_0_0_14 = in_data_0_14;
assign valid_0_0_14 = in_valid_0_14;
assign in_ready_0_14 = ready_0_0_14;
assign data_0_0_15 = in_data_0_15;
assign valid_0_0_15 = in_valid_0_15;
assign in_ready_0_15 = ready_0_0_15;
assign data_1_0_0 = in_data_1_0;
assign valid_1_0_0 = in_valid_1_0;
assign in_ready_1_0 = ready_1_0_0;
assign data_1_0_1 = in_data_1_1;
assign valid_1_0_1 = in_valid_1_1;
assign in_ready_1_1 = ready_1_0_1;
assign data_1_0_2 = in_data_1_2;
assign valid_1_0_2 = in_valid_1_2;
assign in_ready_1_2 = ready_1_0_2;
assign data_1_0_3 = in_data_1_3;
assign valid_1_0_3 = in_valid_1_3;
assign in_ready_1_3 = ready_1_0_3;
assign data_1_0_4 = in_data_1_4;
assign valid_1_0_4 = in_valid_1_4;
assign in_ready_1_4 = ready_1_0_4;
assign data_1_0_5 = in_data_1_5;
assign valid_1_0_5 = in_valid_1_5;
assign in_ready_1_5 = ready_1_0_5;
assign data_1_0_6 = in_data_1_6;
assign valid_1_0_6 = in_valid_1_6;
assign in_ready_1_6 = ready_1_0_6;
assign data_1_0_7 = in_data_1_7;
assign valid_1_0_7 = in_valid_1_7;
assign in_ready_1_7 = ready_1_0_7;
assign data_1_0_8 = in_data_1_8;
assign valid_1_0_8 = in_valid_1_8;
assign in_ready_1_8 = ready_1_0_8;
assign data_1_0_9 = in_data_1_9;
assign valid_1_0_9 = in_valid_1_9;
assign in_ready_1_9 = ready_1_0_9;
assign data_1_0_10 = in_data_1_10;
assign valid_1_0_10 = in_valid_1_10;
assign in_ready_1_10 = ready_1_0_10;
assign data_1_0_11 = in_data_1_11;
assign valid_1_0_11 = in_valid_1_11;
assign in_ready_1_11 = ready_1_0_11;
assign data_1_0_12 = in_data_1_12;
assign valid_1_0_12 = in_valid_1_12;
assign in_ready_1_12 = ready_1_0_12;
assign data_1_0_13 = in_data_1_13;
assign valid_1_0_13 = in_valid_1_13;
assign in_ready_1_13 = ready_1_0_13;
assign data_1_0_14 = in_data_1_14;
assign valid_1_0_14 = in_valid_1_14;
assign in_ready_1_14 = ready_1_0_14;
assign data_1_0_15 = in_data_1_15;
assign valid_1_0_15 = in_valid_1_15;
assign in_ready_1_15 = ready_1_0_15;
assign data_2_0_0 = in_data_2_0;
assign valid_2_0_0 = in_valid_2_0;
assign in_ready_2_0 = ready_2_0_0;
assign data_2_0_1 = in_data_2_1;
assign valid_2_0_1 = in_valid_2_1;
assign in_ready_2_1 = ready_2_0_1;
assign data_2_0_2 = in_data_2_2;
assign valid_2_0_2 = in_valid_2_2;
assign in_ready_2_2 = ready_2_0_2;
assign data_2_0_3 = in_data_2_3;
assign valid_2_0_3 = in_valid_2_3;
assign in_ready_2_3 = ready_2_0_3;
assign data_2_0_4 = in_data_2_4;
assign valid_2_0_4 = in_valid_2_4;
assign in_ready_2_4 = ready_2_0_4;
assign data_2_0_5 = in_data_2_5;
assign valid_2_0_5 = in_valid_2_5;
assign in_ready_2_5 = ready_2_0_5;
assign data_2_0_6 = in_data_2_6;
assign valid_2_0_6 = in_valid_2_6;
assign in_ready_2_6 = ready_2_0_6;
assign data_2_0_7 = in_data_2_7;
assign valid_2_0_7 = in_valid_2_7;
assign in_ready_2_7 = ready_2_0_7;
assign data_2_0_8 = in_data_2_8;
assign valid_2_0_8 = in_valid_2_8;
assign in_ready_2_8 = ready_2_0_8;
assign data_2_0_9 = in_data_2_9;
assign valid_2_0_9 = in_valid_2_9;
assign in_ready_2_9 = ready_2_0_9;
assign data_2_0_10 = in_data_2_10;
assign valid_2_0_10 = in_valid_2_10;
assign in_ready_2_10 = ready_2_0_10;
assign data_2_0_11 = in_data_2_11;
assign valid_2_0_11 = in_valid_2_11;
assign in_ready_2_11 = ready_2_0_11;
assign data_2_0_12 = in_data_2_12;
assign valid_2_0_12 = in_valid_2_12;
assign in_ready_2_12 = ready_2_0_12;
assign data_2_0_13 = in_data_2_13;
assign valid_2_0_13 = in_valid_2_13;
assign in_ready_2_13 = ready_2_0_13;
assign data_2_0_14 = in_data_2_14;
assign valid_2_0_14 = in_valid_2_14;
assign in_ready_2_14 = ready_2_0_14;
assign data_2_0_15 = in_data_2_15;
assign valid_2_0_15 = in_valid_2_15;
assign in_ready_2_15 = ready_2_0_15;
assign data_3_0_0 = in_data_3_0;
assign valid_3_0_0 = in_valid_3_0;
assign in_ready_3_0 = ready_3_0_0;
assign data_3_0_1 = in_data_3_1;
assign valid_3_0_1 = in_valid_3_1;
assign in_ready_3_1 = ready_3_0_1;
assign data_3_0_2 = in_data_3_2;
assign valid_3_0_2 = in_valid_3_2;
assign in_ready_3_2 = ready_3_0_2;
assign data_3_0_3 = in_data_3_3;
assign valid_3_0_3 = in_valid_3_3;
assign in_ready_3_3 = ready_3_0_3;
assign data_3_0_4 = in_data_3_4;
assign valid_3_0_4 = in_valid_3_4;
assign in_ready_3_4 = ready_3_0_4;
assign data_3_0_5 = in_data_3_5;
assign valid_3_0_5 = in_valid_3_5;
assign in_ready_3_5 = ready_3_0_5;
assign data_3_0_6 = in_data_3_6;
assign valid_3_0_6 = in_valid_3_6;
assign in_ready_3_6 = ready_3_0_6;
assign data_3_0_7 = in_data_3_7;
assign valid_3_0_7 = in_valid_3_7;
assign in_ready_3_7 = ready_3_0_7;
assign data_3_0_8 = in_data_3_8;
assign valid_3_0_8 = in_valid_3_8;
assign in_ready_3_8 = ready_3_0_8;
assign data_3_0_9 = in_data_3_9;
assign valid_3_0_9 = in_valid_3_9;
assign in_ready_3_9 = ready_3_0_9;
assign data_3_0_10 = in_data_3_10;
assign valid_3_0_10 = in_valid_3_10;
assign in_ready_3_10 = ready_3_0_10;
assign data_3_0_11 = in_data_3_11;
assign valid_3_0_11 = in_valid_3_11;
assign in_ready_3_11 = ready_3_0_11;
assign data_3_0_12 = in_data_3_12;
assign valid_3_0_12 = in_valid_3_12;
assign in_ready_3_12 = ready_3_0_12;
assign data_3_0_13 = in_data_3_13;
assign valid_3_0_13 = in_valid_3_13;
assign in_ready_3_13 = ready_3_0_13;
assign data_3_0_14 = in_data_3_14;
assign valid_3_0_14 = in_valid_3_14;
assign in_ready_3_14 = ready_3_0_14;
assign data_3_0_15 = in_data_3_15;
assign valid_3_0_15 = in_valid_3_15;
assign in_ready_3_15 = ready_3_0_15;
assign data_4_0_0 = in_data_4_0;
assign valid_4_0_0 = in_valid_4_0;
assign in_ready_4_0 = ready_4_0_0;
assign data_4_0_1 = in_data_4_1;
assign valid_4_0_1 = in_valid_4_1;
assign in_ready_4_1 = ready_4_0_1;
assign data_4_0_2 = in_data_4_2;
assign valid_4_0_2 = in_valid_4_2;
assign in_ready_4_2 = ready_4_0_2;
assign data_4_0_3 = in_data_4_3;
assign valid_4_0_3 = in_valid_4_3;
assign in_ready_4_3 = ready_4_0_3;
assign data_4_0_4 = in_data_4_4;
assign valid_4_0_4 = in_valid_4_4;
assign in_ready_4_4 = ready_4_0_4;
assign data_4_0_5 = in_data_4_5;
assign valid_4_0_5 = in_valid_4_5;
assign in_ready_4_5 = ready_4_0_5;
assign data_4_0_6 = in_data_4_6;
assign valid_4_0_6 = in_valid_4_6;
assign in_ready_4_6 = ready_4_0_6;
assign data_4_0_7 = in_data_4_7;
assign valid_4_0_7 = in_valid_4_7;
assign in_ready_4_7 = ready_4_0_7;
assign data_4_0_8 = in_data_4_8;
assign valid_4_0_8 = in_valid_4_8;
assign in_ready_4_8 = ready_4_0_8;
assign data_4_0_9 = in_data_4_9;
assign valid_4_0_9 = in_valid_4_9;
assign in_ready_4_9 = ready_4_0_9;
assign data_4_0_10 = in_data_4_10;
assign valid_4_0_10 = in_valid_4_10;
assign in_ready_4_10 = ready_4_0_10;
assign data_4_0_11 = in_data_4_11;
assign valid_4_0_11 = in_valid_4_11;
assign in_ready_4_11 = ready_4_0_11;
assign data_4_0_12 = in_data_4_12;
assign valid_4_0_12 = in_valid_4_12;
assign in_ready_4_12 = ready_4_0_12;
assign data_4_0_13 = in_data_4_13;
assign valid_4_0_13 = in_valid_4_13;
assign in_ready_4_13 = ready_4_0_13;
assign data_4_0_14 = in_data_4_14;
assign valid_4_0_14 = in_valid_4_14;
assign in_ready_4_14 = ready_4_0_14;
assign data_4_0_15 = in_data_4_15;
assign valid_4_0_15 = in_valid_4_15;
assign in_ready_4_15 = ready_4_0_15;
assign data_5_0_0 = in_data_5_0;
assign valid_5_0_0 = in_valid_5_0;
assign in_ready_5_0 = ready_5_0_0;
assign data_5_0_1 = in_data_5_1;
assign valid_5_0_1 = in_valid_5_1;
assign in_ready_5_1 = ready_5_0_1;
assign data_5_0_2 = in_data_5_2;
assign valid_5_0_2 = in_valid_5_2;
assign in_ready_5_2 = ready_5_0_2;
assign data_5_0_3 = in_data_5_3;
assign valid_5_0_3 = in_valid_5_3;
assign in_ready_5_3 = ready_5_0_3;
assign data_5_0_4 = in_data_5_4;
assign valid_5_0_4 = in_valid_5_4;
assign in_ready_5_4 = ready_5_0_4;
assign data_5_0_5 = in_data_5_5;
assign valid_5_0_5 = in_valid_5_5;
assign in_ready_5_5 = ready_5_0_5;
assign data_5_0_6 = in_data_5_6;
assign valid_5_0_6 = in_valid_5_6;
assign in_ready_5_6 = ready_5_0_6;
assign data_5_0_7 = in_data_5_7;
assign valid_5_0_7 = in_valid_5_7;
assign in_ready_5_7 = ready_5_0_7;
assign data_5_0_8 = in_data_5_8;
assign valid_5_0_8 = in_valid_5_8;
assign in_ready_5_8 = ready_5_0_8;
assign data_5_0_9 = in_data_5_9;
assign valid_5_0_9 = in_valid_5_9;
assign in_ready_5_9 = ready_5_0_9;
assign data_5_0_10 = in_data_5_10;
assign valid_5_0_10 = in_valid_5_10;
assign in_ready_5_10 = ready_5_0_10;
assign data_5_0_11 = in_data_5_11;
assign valid_5_0_11 = in_valid_5_11;
assign in_ready_5_11 = ready_5_0_11;
assign data_5_0_12 = in_data_5_12;
assign valid_5_0_12 = in_valid_5_12;
assign in_ready_5_12 = ready_5_0_12;
assign data_5_0_13 = in_data_5_13;
assign valid_5_0_13 = in_valid_5_13;
assign in_ready_5_13 = ready_5_0_13;
assign data_5_0_14 = in_data_5_14;
assign valid_5_0_14 = in_valid_5_14;
assign in_ready_5_14 = ready_5_0_14;
assign data_5_0_15 = in_data_5_15;
assign valid_5_0_15 = in_valid_5_15;
assign in_ready_5_15 = ready_5_0_15;
assign data_6_0_0 = in_data_6_0;
assign valid_6_0_0 = in_valid_6_0;
assign in_ready_6_0 = ready_6_0_0;
assign data_6_0_1 = in_data_6_1;
assign valid_6_0_1 = in_valid_6_1;
assign in_ready_6_1 = ready_6_0_1;
assign data_6_0_2 = in_data_6_2;
assign valid_6_0_2 = in_valid_6_2;
assign in_ready_6_2 = ready_6_0_2;
assign data_6_0_3 = in_data_6_3;
assign valid_6_0_3 = in_valid_6_3;
assign in_ready_6_3 = ready_6_0_3;
assign data_6_0_4 = in_data_6_4;
assign valid_6_0_4 = in_valid_6_4;
assign in_ready_6_4 = ready_6_0_4;
assign data_6_0_5 = in_data_6_5;
assign valid_6_0_5 = in_valid_6_5;
assign in_ready_6_5 = ready_6_0_5;
assign data_6_0_6 = in_data_6_6;
assign valid_6_0_6 = in_valid_6_6;
assign in_ready_6_6 = ready_6_0_6;
assign data_6_0_7 = in_data_6_7;
assign valid_6_0_7 = in_valid_6_7;
assign in_ready_6_7 = ready_6_0_7;
assign data_6_0_8 = in_data_6_8;
assign valid_6_0_8 = in_valid_6_8;
assign in_ready_6_8 = ready_6_0_8;
assign data_6_0_9 = in_data_6_9;
assign valid_6_0_9 = in_valid_6_9;
assign in_ready_6_9 = ready_6_0_9;
assign data_6_0_10 = in_data_6_10;
assign valid_6_0_10 = in_valid_6_10;
assign in_ready_6_10 = ready_6_0_10;
assign data_6_0_11 = in_data_6_11;
assign valid_6_0_11 = in_valid_6_11;
assign in_ready_6_11 = ready_6_0_11;
assign data_6_0_12 = in_data_6_12;
assign valid_6_0_12 = in_valid_6_12;
assign in_ready_6_12 = ready_6_0_12;
assign data_6_0_13 = in_data_6_13;
assign valid_6_0_13 = in_valid_6_13;
assign in_ready_6_13 = ready_6_0_13;
assign data_6_0_14 = in_data_6_14;
assign valid_6_0_14 = in_valid_6_14;
assign in_ready_6_14 = ready_6_0_14;
assign data_6_0_15 = in_data_6_15;
assign valid_6_0_15 = in_valid_6_15;
assign in_ready_6_15 = ready_6_0_15;
assign data_7_0_0 = in_data_7_0;
assign valid_7_0_0 = in_valid_7_0;
assign in_ready_7_0 = ready_7_0_0;
assign data_7_0_1 = in_data_7_1;
assign valid_7_0_1 = in_valid_7_1;
assign in_ready_7_1 = ready_7_0_1;
assign data_7_0_2 = in_data_7_2;
assign valid_7_0_2 = in_valid_7_2;
assign in_ready_7_2 = ready_7_0_2;
assign data_7_0_3 = in_data_7_3;
assign valid_7_0_3 = in_valid_7_3;
assign in_ready_7_3 = ready_7_0_3;
assign data_7_0_4 = in_data_7_4;
assign valid_7_0_4 = in_valid_7_4;
assign in_ready_7_4 = ready_7_0_4;
assign data_7_0_5 = in_data_7_5;
assign valid_7_0_5 = in_valid_7_5;
assign in_ready_7_5 = ready_7_0_5;
assign data_7_0_6 = in_data_7_6;
assign valid_7_0_6 = in_valid_7_6;
assign in_ready_7_6 = ready_7_0_6;
assign data_7_0_7 = in_data_7_7;
assign valid_7_0_7 = in_valid_7_7;
assign in_ready_7_7 = ready_7_0_7;
assign data_7_0_8 = in_data_7_8;
assign valid_7_0_8 = in_valid_7_8;
assign in_ready_7_8 = ready_7_0_8;
assign data_7_0_9 = in_data_7_9;
assign valid_7_0_9 = in_valid_7_9;
assign in_ready_7_9 = ready_7_0_9;
assign data_7_0_10 = in_data_7_10;
assign valid_7_0_10 = in_valid_7_10;
assign in_ready_7_10 = ready_7_0_10;
assign data_7_0_11 = in_data_7_11;
assign valid_7_0_11 = in_valid_7_11;
assign in_ready_7_11 = ready_7_0_11;
assign data_7_0_12 = in_data_7_12;
assign valid_7_0_12 = in_valid_7_12;
assign in_ready_7_12 = ready_7_0_12;
assign data_7_0_13 = in_data_7_13;
assign valid_7_0_13 = in_valid_7_13;
assign in_ready_7_13 = ready_7_0_13;
assign data_7_0_14 = in_data_7_14;
assign valid_7_0_14 = in_valid_7_14;
assign in_ready_7_14 = ready_7_0_14;
assign data_7_0_15 = in_data_7_15;
assign valid_7_0_15 = in_valid_7_15;
assign in_ready_7_15 = ready_7_0_15;

//Assign last_layer output
assign last_layer_ready_0_0 = all_last | (!last_layer_data_0_0.last & !int_almost_full);
assign last_layer_ready_0_1 = all_last | (!last_layer_data_0_1.last & !int_almost_full);
assign last_layer_ready_1_0 = all_last | (!last_layer_data_1_0.last & !int_almost_full);
assign last_layer_ready_1_1 = all_last | (!last_layer_data_1_1.last & !int_almost_full);
assign last_layer_ready_2_0 = all_last | (!last_layer_data_2_0.last & !int_almost_full);
assign last_layer_ready_2_1 = all_last | (!last_layer_data_2_1.last & !int_almost_full);
assign last_layer_ready_3_0 = all_last | (!last_layer_data_3_0.last & !int_almost_full);
assign last_layer_ready_3_1 = all_last | (!last_layer_data_3_1.last & !int_almost_full);
assign last_layer_ready_4_0 = all_last | (!last_layer_data_4_0.last & !int_almost_full);
assign last_layer_ready_4_1 = all_last | (!last_layer_data_4_1.last & !int_almost_full);
assign last_layer_ready_5_0 = all_last | (!last_layer_data_5_0.last & !int_almost_full);
assign last_layer_ready_5_1 = all_last | (!last_layer_data_5_1.last & !int_almost_full);
assign last_layer_ready_6_0 = all_last | (!last_layer_data_6_0.last & !int_almost_full);
assign last_layer_ready_6_1 = all_last | (!last_layer_data_6_1.last & !int_almost_full);
assign last_layer_ready_7_0 = all_last | (!last_layer_data_7_0.last & !int_almost_full);
assign last_layer_ready_7_1 = all_last | (!last_layer_data_7_1.last & !int_almost_full);


//Last layer sync
assign all_last =   last_layer_data_0_0.last & last_layer_valid_0_0 &  last_layer_data_0_1.last & last_layer_valid_0_1 &    last_layer_data_1_0.last & last_layer_valid_1_0 &  last_layer_data_1_1.last & last_layer_valid_1_1 &    last_layer_data_2_0.last & last_layer_valid_2_0 &  last_layer_data_2_1.last & last_layer_valid_2_1 &    last_layer_data_3_0.last & last_layer_valid_3_0 &  last_layer_data_3_1.last & last_layer_valid_3_1 &    last_layer_data_4_0.last & last_layer_valid_4_0 &  last_layer_data_4_1.last & last_layer_valid_4_1 &    last_layer_data_5_0.last & last_layer_valid_5_0 &  last_layer_data_5_1.last & last_layer_valid_5_1 &    last_layer_data_6_0.last & last_layer_valid_6_0 &  last_layer_data_6_1.last & last_layer_valid_6_1 &    last_layer_data_7_0.last & last_layer_valid_7_0 &  last_layer_data_7_1.last & last_layer_valid_7_1 &   !int_almost_full;

//For every rule, fetch the RULE ID from table. 
assign ht_addr_0_0 = last_layer_data_0_0.data;
assign ht_rd_0_0 = last_layer_valid_0_0 & !last_layer_data_0_0.last & !int_almost_full;
assign ht_addr_0_1 = last_layer_data_0_1.data;
assign ht_rd_0_1 = last_layer_valid_0_1 & !last_layer_data_0_1.last & !int_almost_full;
assign ht_addr_1_0 = last_layer_data_1_0.data;
assign ht_rd_1_0 = last_layer_valid_1_0 & !last_layer_data_1_0.last & !int_almost_full;
assign ht_addr_1_1 = last_layer_data_1_1.data;
assign ht_rd_1_1 = last_layer_valid_1_1 & !last_layer_data_1_1.last & !int_almost_full;
assign ht_addr_2_0 = last_layer_data_2_0.data;
assign ht_rd_2_0 = last_layer_valid_2_0 & !last_layer_data_2_0.last & !int_almost_full;
assign ht_addr_2_1 = last_layer_data_2_1.data;
assign ht_rd_2_1 = last_layer_valid_2_1 & !last_layer_data_2_1.last & !int_almost_full;
assign ht_addr_3_0 = last_layer_data_3_0.data;
assign ht_rd_3_0 = last_layer_valid_3_0 & !last_layer_data_3_0.last & !int_almost_full;
assign ht_addr_3_1 = last_layer_data_3_1.data;
assign ht_rd_3_1 = last_layer_valid_3_1 & !last_layer_data_3_1.last & !int_almost_full;
assign ht_addr_4_0 = last_layer_data_4_0.data;
assign ht_rd_4_0 = last_layer_valid_4_0 & !last_layer_data_4_0.last & !int_almost_full;
assign ht_addr_4_1 = last_layer_data_4_1.data;
assign ht_rd_4_1 = last_layer_valid_4_1 & !last_layer_data_4_1.last & !int_almost_full;
assign ht_addr_5_0 = last_layer_data_5_0.data;
assign ht_rd_5_0 = last_layer_valid_5_0 & !last_layer_data_5_0.last & !int_almost_full;
assign ht_addr_5_1 = last_layer_data_5_1.data;
assign ht_rd_5_1 = last_layer_valid_5_1 & !last_layer_data_5_1.last & !int_almost_full;
assign ht_addr_6_0 = last_layer_data_6_0.data;
assign ht_rd_6_0 = last_layer_valid_6_0 & !last_layer_data_6_0.last & !int_almost_full;
assign ht_addr_6_1 = last_layer_data_6_1.data;
assign ht_rd_6_1 = last_layer_valid_6_1 & !last_layer_data_6_1.last & !int_almost_full;
assign ht_addr_7_0 = last_layer_data_7_0.data;
assign ht_rd_7_0 = last_layer_valid_7_0 & !last_layer_data_7_0.last & !int_almost_full;
assign ht_addr_7_1 = last_layer_data_7_1.data;
assign ht_rd_7_1 = last_layer_valid_7_1 & !last_layer_data_7_1.last & !int_almost_full;

always @(posedge clk)begin
    all_last_r1 <= all_last;
    all_last_r2 <= all_last_r1;
    all_last_r3 <= all_last_r2;

    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_0_0 <= ht_rd_0_0;
    ht_rd_r2_0_0 <= ht_rd_r1_0_0;
    ht_rd_valid_0_0 <= ht_rd_r2_0_0;
    ht_data_0_0 <= ht_q_0_0;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_0_1 <= ht_rd_0_1;
    ht_rd_r2_0_1 <= ht_rd_r1_0_1;
    ht_rd_valid_0_1 <= ht_rd_r2_0_1;
    ht_data_0_1 <= ht_q_0_1;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_1_0 <= ht_rd_1_0;
    ht_rd_r2_1_0 <= ht_rd_r1_1_0;
    ht_rd_valid_1_0 <= ht_rd_r2_1_0;
    ht_data_1_0 <= ht_q_1_0;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_1_1 <= ht_rd_1_1;
    ht_rd_r2_1_1 <= ht_rd_r1_1_1;
    ht_rd_valid_1_1 <= ht_rd_r2_1_1;
    ht_data_1_1 <= ht_q_1_1;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_2_0 <= ht_rd_2_0;
    ht_rd_r2_2_0 <= ht_rd_r1_2_0;
    ht_rd_valid_2_0 <= ht_rd_r2_2_0;
    ht_data_2_0 <= ht_q_2_0;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_2_1 <= ht_rd_2_1;
    ht_rd_r2_2_1 <= ht_rd_r1_2_1;
    ht_rd_valid_2_1 <= ht_rd_r2_2_1;
    ht_data_2_1 <= ht_q_2_1;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_3_0 <= ht_rd_3_0;
    ht_rd_r2_3_0 <= ht_rd_r1_3_0;
    ht_rd_valid_3_0 <= ht_rd_r2_3_0;
    ht_data_3_0 <= ht_q_3_0;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_3_1 <= ht_rd_3_1;
    ht_rd_r2_3_1 <= ht_rd_r1_3_1;
    ht_rd_valid_3_1 <= ht_rd_r2_3_1;
    ht_data_3_1 <= ht_q_3_1;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_4_0 <= ht_rd_4_0;
    ht_rd_r2_4_0 <= ht_rd_r1_4_0;
    ht_rd_valid_4_0 <= ht_rd_r2_4_0;
    ht_data_4_0 <= ht_q_4_0;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_4_1 <= ht_rd_4_1;
    ht_rd_r2_4_1 <= ht_rd_r1_4_1;
    ht_rd_valid_4_1 <= ht_rd_r2_4_1;
    ht_data_4_1 <= ht_q_4_1;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_5_0 <= ht_rd_5_0;
    ht_rd_r2_5_0 <= ht_rd_r1_5_0;
    ht_rd_valid_5_0 <= ht_rd_r2_5_0;
    ht_data_5_0 <= ht_q_5_0;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_5_1 <= ht_rd_5_1;
    ht_rd_r2_5_1 <= ht_rd_r1_5_1;
    ht_rd_valid_5_1 <= ht_rd_r2_5_1;
    ht_data_5_1 <= ht_q_5_1;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_6_0 <= ht_rd_6_0;
    ht_rd_r2_6_0 <= ht_rd_r1_6_0;
    ht_rd_valid_6_0 <= ht_rd_r2_6_0;
    ht_data_6_0 <= ht_q_6_0;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_6_1 <= ht_rd_6_1;
    ht_rd_r2_6_1 <= ht_rd_r1_6_1;
    ht_rd_valid_6_1 <= ht_rd_r2_6_1;
    ht_data_6_1 <= ht_q_6_1;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_7_0 <= ht_rd_7_0;
    ht_rd_r2_7_0 <= ht_rd_r1_7_0;
    ht_rd_valid_7_0 <= ht_rd_r2_7_0;
    ht_data_7_0 <= ht_q_7_0;
    //two cycle delay and one more cycle for selecting right bucket
    ht_rd_r1_7_1 <= ht_rd_7_1;
    ht_rd_r2_7_1 <= ht_rd_r1_7_1;
    ht_rd_valid_7_1 <= ht_rd_r2_7_1;
    ht_data_7_1 <= ht_q_7_1;
end

//Assign data
always @(posedge clk)begin
    if(all_last_r3)begin
        int_data[15:0] <= 0;
    end else begin
        if(ht_rd_valid_0_0)begin
            int_data[15:0] <= ht_data_0_0;
        end else begin
            int_data[15:0] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[31:16] <= 0;
    end else begin
        if(ht_rd_valid_1_0)begin
            int_data[31:16] <= ht_data_1_0;
        end else begin
            int_data[31:16] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[47:32] <= 0;
    end else begin
        if(ht_rd_valid_2_0)begin
            int_data[47:32] <= ht_data_2_0;
        end else begin
            int_data[47:32] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[63:48] <= 0;
    end else begin
        if(ht_rd_valid_3_0)begin
            int_data[63:48] <= ht_data_3_0;
        end else begin
            int_data[63:48] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[79:64] <= 0;
    end else begin
        if(ht_rd_valid_4_0)begin
            int_data[79:64] <= ht_data_4_0;
        end else begin
            int_data[79:64] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[95:80] <= 0;
    end else begin
        if(ht_rd_valid_5_0)begin
            int_data[95:80] <= ht_data_5_0;
        end else begin
            int_data[95:80] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[111:96] <= 0;
    end else begin
        if(ht_rd_valid_6_0)begin
            int_data[111:96] <= ht_data_6_0;
        end else begin
            int_data[111:96] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[127:112] <= 0;
    end else begin
        if(ht_rd_valid_7_0)begin
            int_data[127:112] <= ht_data_7_0;
        end else begin
            int_data[127:112] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[143:128] <= 0;
    end else begin
        if(ht_rd_valid_0_1)begin
            int_data[143:128] <= ht_data_0_1;
        end else begin
            int_data[143:128] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[159:144] <= 0;
    end else begin
        if(ht_rd_valid_1_1)begin
            int_data[159:144] <= ht_data_1_1;
        end else begin
            int_data[159:144] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[175:160] <= 0;
    end else begin
        if(ht_rd_valid_2_1)begin
            int_data[175:160] <= ht_data_2_1;
        end else begin
            int_data[175:160] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[191:176] <= 0;
    end else begin
        if(ht_rd_valid_3_1)begin
            int_data[191:176] <= ht_data_3_1;
        end else begin
            int_data[191:176] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[207:192] <= 0;
    end else begin
        if(ht_rd_valid_4_1)begin
            int_data[207:192] <= ht_data_4_1;
        end else begin
            int_data[207:192] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[223:208] <= 0;
    end else begin
        if(ht_rd_valid_5_1)begin
            int_data[223:208] <= ht_data_5_1;
        end else begin
            int_data[223:208] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[239:224] <= 0;
    end else begin
        if(ht_rd_valid_6_1)begin
            int_data[239:224] <= ht_data_6_1;
        end else begin
            int_data[239:224] <= 0;
        end
    end
    if(all_last_r3)begin
        int_data[255:240] <= 0;
    end else begin
        if(ht_rd_valid_7_1)begin
            int_data[255:240] <= ht_data_7_1;
        end else begin
            int_data[255:240] <= 0;
        end
    end
end

//Assign metadata
//Only the first one has sop
assign int_sop = (int_cnt == 0) ? int_valid : 1'b0;
always @(posedge clk)begin
    if(rst)begin
        int_empty <= 0;
        int_eop <= 1'b0;
        int_valid <= 1'b0;
        int_cnt <= 0;
    end else begin
        int_eop <= 1'b0;
        //sync case
        if(all_last_r3) begin
            int_valid <= 1'b1;
            int_eop <= 1'b1;
        //normal case
        end else begin
            //any dequeue 
            int_valid <=   (ht_rd_valid_0_0) |  (ht_rd_valid_0_1) |    (ht_rd_valid_1_0) |  (ht_rd_valid_1_1) |    (ht_rd_valid_2_0) |  (ht_rd_valid_2_1) |    (ht_rd_valid_3_0) |  (ht_rd_valid_3_1) |    (ht_rd_valid_4_0) |  (ht_rd_valid_4_1) |    (ht_rd_valid_5_0) |  (ht_rd_valid_5_1) |    (ht_rd_valid_6_0) |  (ht_rd_valid_6_1) |    (ht_rd_valid_7_0) |  (ht_rd_valid_7_1) |   0;
        end

        //calculate int_cnt
        if(int_valid)begin
            if(int_eop)begin
                int_cnt <= 0;
            end else begin
                int_cnt <= int_cnt + 1;
            end
        end
    end
end

    reduction_2t1 reduction_unit_0_0_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_0_0),
        .in_valid_0   (valid_0_0_0),
        .in_ready_0   (ready_0_0_0),
        .in_data_1    (data_0_0_1),
        .in_valid_1   (valid_0_0_1),
        .in_ready_1   (ready_0_0_1),
        .out_data     (data_0_1_0),
        .out_valid    (valid_0_1_0),
        .out_ready    (ready_0_1_0)
    );
    reduction_2t1 reduction_unit_0_0_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_0_2),
        .in_valid_0   (valid_0_0_2),
        .in_ready_0   (ready_0_0_2),
        .in_data_1    (data_0_0_3),
        .in_valid_1   (valid_0_0_3),
        .in_ready_1   (ready_0_0_3),
        .out_data     (data_0_1_1),
        .out_valid    (valid_0_1_1),
        .out_ready    (ready_0_1_1)
    );
    reduction_2t1 reduction_unit_0_0_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_0_4),
        .in_valid_0   (valid_0_0_4),
        .in_ready_0   (ready_0_0_4),
        .in_data_1    (data_0_0_5),
        .in_valid_1   (valid_0_0_5),
        .in_ready_1   (ready_0_0_5),
        .out_data     (data_0_1_2),
        .out_valid    (valid_0_1_2),
        .out_ready    (ready_0_1_2)
    );
    reduction_2t1 reduction_unit_0_0_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_0_6),
        .in_valid_0   (valid_0_0_6),
        .in_ready_0   (ready_0_0_6),
        .in_data_1    (data_0_0_7),
        .in_valid_1   (valid_0_0_7),
        .in_ready_1   (ready_0_0_7),
        .out_data     (data_0_1_3),
        .out_valid    (valid_0_1_3),
        .out_ready    (ready_0_1_3)
    );
    reduction_2t1 reduction_unit_0_0_4 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_0_8),
        .in_valid_0   (valid_0_0_8),
        .in_ready_0   (ready_0_0_8),
        .in_data_1    (data_0_0_9),
        .in_valid_1   (valid_0_0_9),
        .in_ready_1   (ready_0_0_9),
        .out_data     (data_0_1_4),
        .out_valid    (valid_0_1_4),
        .out_ready    (ready_0_1_4)
    );
    reduction_2t1 reduction_unit_0_0_5 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_0_10),
        .in_valid_0   (valid_0_0_10),
        .in_ready_0   (ready_0_0_10),
        .in_data_1    (data_0_0_11),
        .in_valid_1   (valid_0_0_11),
        .in_ready_1   (ready_0_0_11),
        .out_data     (data_0_1_5),
        .out_valid    (valid_0_1_5),
        .out_ready    (ready_0_1_5)
    );
    reduction_2t1 reduction_unit_0_0_6 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_0_12),
        .in_valid_0   (valid_0_0_12),
        .in_ready_0   (ready_0_0_12),
        .in_data_1    (data_0_0_13),
        .in_valid_1   (valid_0_0_13),
        .in_ready_1   (ready_0_0_13),
        .out_data     (data_0_1_6),
        .out_valid    (valid_0_1_6),
        .out_ready    (ready_0_1_6)
    );
    reduction_2t1 reduction_unit_0_0_7 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_0_14),
        .in_valid_0   (valid_0_0_14),
        .in_ready_0   (ready_0_0_14),
        .in_data_1    (data_0_0_15),
        .in_valid_1   (valid_0_0_15),
        .in_ready_1   (ready_0_0_15),
        .out_data     (data_0_1_7),
        .out_valid    (valid_0_1_7),
        .out_ready    (ready_0_1_7)
    );
    reduction_2t1 reduction_unit_0_1_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_1_0),
        .in_valid_0   (valid_0_1_0),
        .in_ready_0   (ready_0_1_0),
        .in_data_1    (data_0_1_1),
        .in_valid_1   (valid_0_1_1),
        .in_ready_1   (ready_0_1_1),
        .out_data     (data_0_2_0),
        .out_valid    (valid_0_2_0),
        .out_ready    (ready_0_2_0)
    );
    reduction_2t1 reduction_unit_0_1_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_1_2),
        .in_valid_0   (valid_0_1_2),
        .in_ready_0   (ready_0_1_2),
        .in_data_1    (data_0_1_3),
        .in_valid_1   (valid_0_1_3),
        .in_ready_1   (ready_0_1_3),
        .out_data     (data_0_2_1),
        .out_valid    (valid_0_2_1),
        .out_ready    (ready_0_2_1)
    );
    reduction_2t1 reduction_unit_0_1_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_1_4),
        .in_valid_0   (valid_0_1_4),
        .in_ready_0   (ready_0_1_4),
        .in_data_1    (data_0_1_5),
        .in_valid_1   (valid_0_1_5),
        .in_ready_1   (ready_0_1_5),
        .out_data     (data_0_2_2),
        .out_valid    (valid_0_2_2),
        .out_ready    (ready_0_2_2)
    );
    reduction_2t1 reduction_unit_0_1_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_1_6),
        .in_valid_0   (valid_0_1_6),
        .in_ready_0   (ready_0_1_6),
        .in_data_1    (data_0_1_7),
        .in_valid_1   (valid_0_1_7),
        .in_ready_1   (ready_0_1_7),
        .out_data     (data_0_2_3),
        .out_valid    (valid_0_2_3),
        .out_ready    (ready_0_2_3)
    );
    reduction_2t1 reduction_unit_0_2_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_2_0),
        .in_valid_0   (valid_0_2_0),
        .in_ready_0   (ready_0_2_0),
        .in_data_1    (data_0_2_1),
        .in_valid_1   (valid_0_2_1),
        .in_ready_1   (ready_0_2_1),
        .out_data     (last_layer_data_0_0),
        .out_valid    (last_layer_valid_0_0),
        .out_ready    (last_layer_ready_0_0)
    );
    reduction_2t1 reduction_unit_0_2_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_0_2_2),
        .in_valid_0   (valid_0_2_2),
        .in_ready_0   (ready_0_2_2),
        .in_data_1    (data_0_2_3),
        .in_valid_1   (valid_0_2_3),
        .in_ready_1   (ready_0_2_3),
        .out_data     (last_layer_data_0_1),
        .out_valid    (last_layer_valid_0_1),
        .out_ready    (last_layer_ready_0_1)
    );
    reduction_2t1 reduction_unit_1_0_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_0_0),
        .in_valid_0   (valid_1_0_0),
        .in_ready_0   (ready_1_0_0),
        .in_data_1    (data_1_0_1),
        .in_valid_1   (valid_1_0_1),
        .in_ready_1   (ready_1_0_1),
        .out_data     (data_1_1_0),
        .out_valid    (valid_1_1_0),
        .out_ready    (ready_1_1_0)
    );
    reduction_2t1 reduction_unit_1_0_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_0_2),
        .in_valid_0   (valid_1_0_2),
        .in_ready_0   (ready_1_0_2),
        .in_data_1    (data_1_0_3),
        .in_valid_1   (valid_1_0_3),
        .in_ready_1   (ready_1_0_3),
        .out_data     (data_1_1_1),
        .out_valid    (valid_1_1_1),
        .out_ready    (ready_1_1_1)
    );
    reduction_2t1 reduction_unit_1_0_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_0_4),
        .in_valid_0   (valid_1_0_4),
        .in_ready_0   (ready_1_0_4),
        .in_data_1    (data_1_0_5),
        .in_valid_1   (valid_1_0_5),
        .in_ready_1   (ready_1_0_5),
        .out_data     (data_1_1_2),
        .out_valid    (valid_1_1_2),
        .out_ready    (ready_1_1_2)
    );
    reduction_2t1 reduction_unit_1_0_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_0_6),
        .in_valid_0   (valid_1_0_6),
        .in_ready_0   (ready_1_0_6),
        .in_data_1    (data_1_0_7),
        .in_valid_1   (valid_1_0_7),
        .in_ready_1   (ready_1_0_7),
        .out_data     (data_1_1_3),
        .out_valid    (valid_1_1_3),
        .out_ready    (ready_1_1_3)
    );
    reduction_2t1 reduction_unit_1_0_4 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_0_8),
        .in_valid_0   (valid_1_0_8),
        .in_ready_0   (ready_1_0_8),
        .in_data_1    (data_1_0_9),
        .in_valid_1   (valid_1_0_9),
        .in_ready_1   (ready_1_0_9),
        .out_data     (data_1_1_4),
        .out_valid    (valid_1_1_4),
        .out_ready    (ready_1_1_4)
    );
    reduction_2t1 reduction_unit_1_0_5 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_0_10),
        .in_valid_0   (valid_1_0_10),
        .in_ready_0   (ready_1_0_10),
        .in_data_1    (data_1_0_11),
        .in_valid_1   (valid_1_0_11),
        .in_ready_1   (ready_1_0_11),
        .out_data     (data_1_1_5),
        .out_valid    (valid_1_1_5),
        .out_ready    (ready_1_1_5)
    );
    reduction_2t1 reduction_unit_1_0_6 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_0_12),
        .in_valid_0   (valid_1_0_12),
        .in_ready_0   (ready_1_0_12),
        .in_data_1    (data_1_0_13),
        .in_valid_1   (valid_1_0_13),
        .in_ready_1   (ready_1_0_13),
        .out_data     (data_1_1_6),
        .out_valid    (valid_1_1_6),
        .out_ready    (ready_1_1_6)
    );
    reduction_2t1 reduction_unit_1_0_7 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_0_14),
        .in_valid_0   (valid_1_0_14),
        .in_ready_0   (ready_1_0_14),
        .in_data_1    (data_1_0_15),
        .in_valid_1   (valid_1_0_15),
        .in_ready_1   (ready_1_0_15),
        .out_data     (data_1_1_7),
        .out_valid    (valid_1_1_7),
        .out_ready    (ready_1_1_7)
    );
    reduction_2t1 reduction_unit_1_1_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_1_0),
        .in_valid_0   (valid_1_1_0),
        .in_ready_0   (ready_1_1_0),
        .in_data_1    (data_1_1_1),
        .in_valid_1   (valid_1_1_1),
        .in_ready_1   (ready_1_1_1),
        .out_data     (data_1_2_0),
        .out_valid    (valid_1_2_0),
        .out_ready    (ready_1_2_0)
    );
    reduction_2t1 reduction_unit_1_1_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_1_2),
        .in_valid_0   (valid_1_1_2),
        .in_ready_0   (ready_1_1_2),
        .in_data_1    (data_1_1_3),
        .in_valid_1   (valid_1_1_3),
        .in_ready_1   (ready_1_1_3),
        .out_data     (data_1_2_1),
        .out_valid    (valid_1_2_1),
        .out_ready    (ready_1_2_1)
    );
    reduction_2t1 reduction_unit_1_1_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_1_4),
        .in_valid_0   (valid_1_1_4),
        .in_ready_0   (ready_1_1_4),
        .in_data_1    (data_1_1_5),
        .in_valid_1   (valid_1_1_5),
        .in_ready_1   (ready_1_1_5),
        .out_data     (data_1_2_2),
        .out_valid    (valid_1_2_2),
        .out_ready    (ready_1_2_2)
    );
    reduction_2t1 reduction_unit_1_1_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_1_6),
        .in_valid_0   (valid_1_1_6),
        .in_ready_0   (ready_1_1_6),
        .in_data_1    (data_1_1_7),
        .in_valid_1   (valid_1_1_7),
        .in_ready_1   (ready_1_1_7),
        .out_data     (data_1_2_3),
        .out_valid    (valid_1_2_3),
        .out_ready    (ready_1_2_3)
    );
    reduction_2t1 reduction_unit_1_2_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_2_0),
        .in_valid_0   (valid_1_2_0),
        .in_ready_0   (ready_1_2_0),
        .in_data_1    (data_1_2_1),
        .in_valid_1   (valid_1_2_1),
        .in_ready_1   (ready_1_2_1),
        .out_data     (last_layer_data_1_0),
        .out_valid    (last_layer_valid_1_0),
        .out_ready    (last_layer_ready_1_0)
    );
    reduction_2t1 reduction_unit_1_2_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_1_2_2),
        .in_valid_0   (valid_1_2_2),
        .in_ready_0   (ready_1_2_2),
        .in_data_1    (data_1_2_3),
        .in_valid_1   (valid_1_2_3),
        .in_ready_1   (ready_1_2_3),
        .out_data     (last_layer_data_1_1),
        .out_valid    (last_layer_valid_1_1),
        .out_ready    (last_layer_ready_1_1)
    );
    reduction_2t1 reduction_unit_2_0_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_0_0),
        .in_valid_0   (valid_2_0_0),
        .in_ready_0   (ready_2_0_0),
        .in_data_1    (data_2_0_1),
        .in_valid_1   (valid_2_0_1),
        .in_ready_1   (ready_2_0_1),
        .out_data     (data_2_1_0),
        .out_valid    (valid_2_1_0),
        .out_ready    (ready_2_1_0)
    );
    reduction_2t1 reduction_unit_2_0_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_0_2),
        .in_valid_0   (valid_2_0_2),
        .in_ready_0   (ready_2_0_2),
        .in_data_1    (data_2_0_3),
        .in_valid_1   (valid_2_0_3),
        .in_ready_1   (ready_2_0_3),
        .out_data     (data_2_1_1),
        .out_valid    (valid_2_1_1),
        .out_ready    (ready_2_1_1)
    );
    reduction_2t1 reduction_unit_2_0_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_0_4),
        .in_valid_0   (valid_2_0_4),
        .in_ready_0   (ready_2_0_4),
        .in_data_1    (data_2_0_5),
        .in_valid_1   (valid_2_0_5),
        .in_ready_1   (ready_2_0_5),
        .out_data     (data_2_1_2),
        .out_valid    (valid_2_1_2),
        .out_ready    (ready_2_1_2)
    );
    reduction_2t1 reduction_unit_2_0_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_0_6),
        .in_valid_0   (valid_2_0_6),
        .in_ready_0   (ready_2_0_6),
        .in_data_1    (data_2_0_7),
        .in_valid_1   (valid_2_0_7),
        .in_ready_1   (ready_2_0_7),
        .out_data     (data_2_1_3),
        .out_valid    (valid_2_1_3),
        .out_ready    (ready_2_1_3)
    );
    reduction_2t1 reduction_unit_2_0_4 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_0_8),
        .in_valid_0   (valid_2_0_8),
        .in_ready_0   (ready_2_0_8),
        .in_data_1    (data_2_0_9),
        .in_valid_1   (valid_2_0_9),
        .in_ready_1   (ready_2_0_9),
        .out_data     (data_2_1_4),
        .out_valid    (valid_2_1_4),
        .out_ready    (ready_2_1_4)
    );
    reduction_2t1 reduction_unit_2_0_5 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_0_10),
        .in_valid_0   (valid_2_0_10),
        .in_ready_0   (ready_2_0_10),
        .in_data_1    (data_2_0_11),
        .in_valid_1   (valid_2_0_11),
        .in_ready_1   (ready_2_0_11),
        .out_data     (data_2_1_5),
        .out_valid    (valid_2_1_5),
        .out_ready    (ready_2_1_5)
    );
    reduction_2t1 reduction_unit_2_0_6 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_0_12),
        .in_valid_0   (valid_2_0_12),
        .in_ready_0   (ready_2_0_12),
        .in_data_1    (data_2_0_13),
        .in_valid_1   (valid_2_0_13),
        .in_ready_1   (ready_2_0_13),
        .out_data     (data_2_1_6),
        .out_valid    (valid_2_1_6),
        .out_ready    (ready_2_1_6)
    );
    reduction_2t1 reduction_unit_2_0_7 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_0_14),
        .in_valid_0   (valid_2_0_14),
        .in_ready_0   (ready_2_0_14),
        .in_data_1    (data_2_0_15),
        .in_valid_1   (valid_2_0_15),
        .in_ready_1   (ready_2_0_15),
        .out_data     (data_2_1_7),
        .out_valid    (valid_2_1_7),
        .out_ready    (ready_2_1_7)
    );
    reduction_2t1 reduction_unit_2_1_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_1_0),
        .in_valid_0   (valid_2_1_0),
        .in_ready_0   (ready_2_1_0),
        .in_data_1    (data_2_1_1),
        .in_valid_1   (valid_2_1_1),
        .in_ready_1   (ready_2_1_1),
        .out_data     (data_2_2_0),
        .out_valid    (valid_2_2_0),
        .out_ready    (ready_2_2_0)
    );
    reduction_2t1 reduction_unit_2_1_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_1_2),
        .in_valid_0   (valid_2_1_2),
        .in_ready_0   (ready_2_1_2),
        .in_data_1    (data_2_1_3),
        .in_valid_1   (valid_2_1_3),
        .in_ready_1   (ready_2_1_3),
        .out_data     (data_2_2_1),
        .out_valid    (valid_2_2_1),
        .out_ready    (ready_2_2_1)
    );
    reduction_2t1 reduction_unit_2_1_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_1_4),
        .in_valid_0   (valid_2_1_4),
        .in_ready_0   (ready_2_1_4),
        .in_data_1    (data_2_1_5),
        .in_valid_1   (valid_2_1_5),
        .in_ready_1   (ready_2_1_5),
        .out_data     (data_2_2_2),
        .out_valid    (valid_2_2_2),
        .out_ready    (ready_2_2_2)
    );
    reduction_2t1 reduction_unit_2_1_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_1_6),
        .in_valid_0   (valid_2_1_6),
        .in_ready_0   (ready_2_1_6),
        .in_data_1    (data_2_1_7),
        .in_valid_1   (valid_2_1_7),
        .in_ready_1   (ready_2_1_7),
        .out_data     (data_2_2_3),
        .out_valid    (valid_2_2_3),
        .out_ready    (ready_2_2_3)
    );
    reduction_2t1 reduction_unit_2_2_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_2_0),
        .in_valid_0   (valid_2_2_0),
        .in_ready_0   (ready_2_2_0),
        .in_data_1    (data_2_2_1),
        .in_valid_1   (valid_2_2_1),
        .in_ready_1   (ready_2_2_1),
        .out_data     (last_layer_data_2_0),
        .out_valid    (last_layer_valid_2_0),
        .out_ready    (last_layer_ready_2_0)
    );
    reduction_2t1 reduction_unit_2_2_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_2_2_2),
        .in_valid_0   (valid_2_2_2),
        .in_ready_0   (ready_2_2_2),
        .in_data_1    (data_2_2_3),
        .in_valid_1   (valid_2_2_3),
        .in_ready_1   (ready_2_2_3),
        .out_data     (last_layer_data_2_1),
        .out_valid    (last_layer_valid_2_1),
        .out_ready    (last_layer_ready_2_1)
    );
    reduction_2t1 reduction_unit_3_0_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_0_0),
        .in_valid_0   (valid_3_0_0),
        .in_ready_0   (ready_3_0_0),
        .in_data_1    (data_3_0_1),
        .in_valid_1   (valid_3_0_1),
        .in_ready_1   (ready_3_0_1),
        .out_data     (data_3_1_0),
        .out_valid    (valid_3_1_0),
        .out_ready    (ready_3_1_0)
    );
    reduction_2t1 reduction_unit_3_0_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_0_2),
        .in_valid_0   (valid_3_0_2),
        .in_ready_0   (ready_3_0_2),
        .in_data_1    (data_3_0_3),
        .in_valid_1   (valid_3_0_3),
        .in_ready_1   (ready_3_0_3),
        .out_data     (data_3_1_1),
        .out_valid    (valid_3_1_1),
        .out_ready    (ready_3_1_1)
    );
    reduction_2t1 reduction_unit_3_0_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_0_4),
        .in_valid_0   (valid_3_0_4),
        .in_ready_0   (ready_3_0_4),
        .in_data_1    (data_3_0_5),
        .in_valid_1   (valid_3_0_5),
        .in_ready_1   (ready_3_0_5),
        .out_data     (data_3_1_2),
        .out_valid    (valid_3_1_2),
        .out_ready    (ready_3_1_2)
    );
    reduction_2t1 reduction_unit_3_0_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_0_6),
        .in_valid_0   (valid_3_0_6),
        .in_ready_0   (ready_3_0_6),
        .in_data_1    (data_3_0_7),
        .in_valid_1   (valid_3_0_7),
        .in_ready_1   (ready_3_0_7),
        .out_data     (data_3_1_3),
        .out_valid    (valid_3_1_3),
        .out_ready    (ready_3_1_3)
    );
    reduction_2t1 reduction_unit_3_0_4 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_0_8),
        .in_valid_0   (valid_3_0_8),
        .in_ready_0   (ready_3_0_8),
        .in_data_1    (data_3_0_9),
        .in_valid_1   (valid_3_0_9),
        .in_ready_1   (ready_3_0_9),
        .out_data     (data_3_1_4),
        .out_valid    (valid_3_1_4),
        .out_ready    (ready_3_1_4)
    );
    reduction_2t1 reduction_unit_3_0_5 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_0_10),
        .in_valid_0   (valid_3_0_10),
        .in_ready_0   (ready_3_0_10),
        .in_data_1    (data_3_0_11),
        .in_valid_1   (valid_3_0_11),
        .in_ready_1   (ready_3_0_11),
        .out_data     (data_3_1_5),
        .out_valid    (valid_3_1_5),
        .out_ready    (ready_3_1_5)
    );
    reduction_2t1 reduction_unit_3_0_6 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_0_12),
        .in_valid_0   (valid_3_0_12),
        .in_ready_0   (ready_3_0_12),
        .in_data_1    (data_3_0_13),
        .in_valid_1   (valid_3_0_13),
        .in_ready_1   (ready_3_0_13),
        .out_data     (data_3_1_6),
        .out_valid    (valid_3_1_6),
        .out_ready    (ready_3_1_6)
    );
    reduction_2t1 reduction_unit_3_0_7 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_0_14),
        .in_valid_0   (valid_3_0_14),
        .in_ready_0   (ready_3_0_14),
        .in_data_1    (data_3_0_15),
        .in_valid_1   (valid_3_0_15),
        .in_ready_1   (ready_3_0_15),
        .out_data     (data_3_1_7),
        .out_valid    (valid_3_1_7),
        .out_ready    (ready_3_1_7)
    );
    reduction_2t1 reduction_unit_3_1_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_1_0),
        .in_valid_0   (valid_3_1_0),
        .in_ready_0   (ready_3_1_0),
        .in_data_1    (data_3_1_1),
        .in_valid_1   (valid_3_1_1),
        .in_ready_1   (ready_3_1_1),
        .out_data     (data_3_2_0),
        .out_valid    (valid_3_2_0),
        .out_ready    (ready_3_2_0)
    );
    reduction_2t1 reduction_unit_3_1_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_1_2),
        .in_valid_0   (valid_3_1_2),
        .in_ready_0   (ready_3_1_2),
        .in_data_1    (data_3_1_3),
        .in_valid_1   (valid_3_1_3),
        .in_ready_1   (ready_3_1_3),
        .out_data     (data_3_2_1),
        .out_valid    (valid_3_2_1),
        .out_ready    (ready_3_2_1)
    );
    reduction_2t1 reduction_unit_3_1_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_1_4),
        .in_valid_0   (valid_3_1_4),
        .in_ready_0   (ready_3_1_4),
        .in_data_1    (data_3_1_5),
        .in_valid_1   (valid_3_1_5),
        .in_ready_1   (ready_3_1_5),
        .out_data     (data_3_2_2),
        .out_valid    (valid_3_2_2),
        .out_ready    (ready_3_2_2)
    );
    reduction_2t1 reduction_unit_3_1_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_1_6),
        .in_valid_0   (valid_3_1_6),
        .in_ready_0   (ready_3_1_6),
        .in_data_1    (data_3_1_7),
        .in_valid_1   (valid_3_1_7),
        .in_ready_1   (ready_3_1_7),
        .out_data     (data_3_2_3),
        .out_valid    (valid_3_2_3),
        .out_ready    (ready_3_2_3)
    );
    reduction_2t1 reduction_unit_3_2_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_2_0),
        .in_valid_0   (valid_3_2_0),
        .in_ready_0   (ready_3_2_0),
        .in_data_1    (data_3_2_1),
        .in_valid_1   (valid_3_2_1),
        .in_ready_1   (ready_3_2_1),
        .out_data     (last_layer_data_3_0),
        .out_valid    (last_layer_valid_3_0),
        .out_ready    (last_layer_ready_3_0)
    );
    reduction_2t1 reduction_unit_3_2_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_3_2_2),
        .in_valid_0   (valid_3_2_2),
        .in_ready_0   (ready_3_2_2),
        .in_data_1    (data_3_2_3),
        .in_valid_1   (valid_3_2_3),
        .in_ready_1   (ready_3_2_3),
        .out_data     (last_layer_data_3_1),
        .out_valid    (last_layer_valid_3_1),
        .out_ready    (last_layer_ready_3_1)
    );
    reduction_2t1 reduction_unit_4_0_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_0_0),
        .in_valid_0   (valid_4_0_0),
        .in_ready_0   (ready_4_0_0),
        .in_data_1    (data_4_0_1),
        .in_valid_1   (valid_4_0_1),
        .in_ready_1   (ready_4_0_1),
        .out_data     (data_4_1_0),
        .out_valid    (valid_4_1_0),
        .out_ready    (ready_4_1_0)
    );
    reduction_2t1 reduction_unit_4_0_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_0_2),
        .in_valid_0   (valid_4_0_2),
        .in_ready_0   (ready_4_0_2),
        .in_data_1    (data_4_0_3),
        .in_valid_1   (valid_4_0_3),
        .in_ready_1   (ready_4_0_3),
        .out_data     (data_4_1_1),
        .out_valid    (valid_4_1_1),
        .out_ready    (ready_4_1_1)
    );
    reduction_2t1 reduction_unit_4_0_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_0_4),
        .in_valid_0   (valid_4_0_4),
        .in_ready_0   (ready_4_0_4),
        .in_data_1    (data_4_0_5),
        .in_valid_1   (valid_4_0_5),
        .in_ready_1   (ready_4_0_5),
        .out_data     (data_4_1_2),
        .out_valid    (valid_4_1_2),
        .out_ready    (ready_4_1_2)
    );
    reduction_2t1 reduction_unit_4_0_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_0_6),
        .in_valid_0   (valid_4_0_6),
        .in_ready_0   (ready_4_0_6),
        .in_data_1    (data_4_0_7),
        .in_valid_1   (valid_4_0_7),
        .in_ready_1   (ready_4_0_7),
        .out_data     (data_4_1_3),
        .out_valid    (valid_4_1_3),
        .out_ready    (ready_4_1_3)
    );
    reduction_2t1 reduction_unit_4_0_4 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_0_8),
        .in_valid_0   (valid_4_0_8),
        .in_ready_0   (ready_4_0_8),
        .in_data_1    (data_4_0_9),
        .in_valid_1   (valid_4_0_9),
        .in_ready_1   (ready_4_0_9),
        .out_data     (data_4_1_4),
        .out_valid    (valid_4_1_4),
        .out_ready    (ready_4_1_4)
    );
    reduction_2t1 reduction_unit_4_0_5 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_0_10),
        .in_valid_0   (valid_4_0_10),
        .in_ready_0   (ready_4_0_10),
        .in_data_1    (data_4_0_11),
        .in_valid_1   (valid_4_0_11),
        .in_ready_1   (ready_4_0_11),
        .out_data     (data_4_1_5),
        .out_valid    (valid_4_1_5),
        .out_ready    (ready_4_1_5)
    );
    reduction_2t1 reduction_unit_4_0_6 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_0_12),
        .in_valid_0   (valid_4_0_12),
        .in_ready_0   (ready_4_0_12),
        .in_data_1    (data_4_0_13),
        .in_valid_1   (valid_4_0_13),
        .in_ready_1   (ready_4_0_13),
        .out_data     (data_4_1_6),
        .out_valid    (valid_4_1_6),
        .out_ready    (ready_4_1_6)
    );
    reduction_2t1 reduction_unit_4_0_7 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_0_14),
        .in_valid_0   (valid_4_0_14),
        .in_ready_0   (ready_4_0_14),
        .in_data_1    (data_4_0_15),
        .in_valid_1   (valid_4_0_15),
        .in_ready_1   (ready_4_0_15),
        .out_data     (data_4_1_7),
        .out_valid    (valid_4_1_7),
        .out_ready    (ready_4_1_7)
    );
    reduction_2t1 reduction_unit_4_1_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_1_0),
        .in_valid_0   (valid_4_1_0),
        .in_ready_0   (ready_4_1_0),
        .in_data_1    (data_4_1_1),
        .in_valid_1   (valid_4_1_1),
        .in_ready_1   (ready_4_1_1),
        .out_data     (data_4_2_0),
        .out_valid    (valid_4_2_0),
        .out_ready    (ready_4_2_0)
    );
    reduction_2t1 reduction_unit_4_1_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_1_2),
        .in_valid_0   (valid_4_1_2),
        .in_ready_0   (ready_4_1_2),
        .in_data_1    (data_4_1_3),
        .in_valid_1   (valid_4_1_3),
        .in_ready_1   (ready_4_1_3),
        .out_data     (data_4_2_1),
        .out_valid    (valid_4_2_1),
        .out_ready    (ready_4_2_1)
    );
    reduction_2t1 reduction_unit_4_1_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_1_4),
        .in_valid_0   (valid_4_1_4),
        .in_ready_0   (ready_4_1_4),
        .in_data_1    (data_4_1_5),
        .in_valid_1   (valid_4_1_5),
        .in_ready_1   (ready_4_1_5),
        .out_data     (data_4_2_2),
        .out_valid    (valid_4_2_2),
        .out_ready    (ready_4_2_2)
    );
    reduction_2t1 reduction_unit_4_1_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_1_6),
        .in_valid_0   (valid_4_1_6),
        .in_ready_0   (ready_4_1_6),
        .in_data_1    (data_4_1_7),
        .in_valid_1   (valid_4_1_7),
        .in_ready_1   (ready_4_1_7),
        .out_data     (data_4_2_3),
        .out_valid    (valid_4_2_3),
        .out_ready    (ready_4_2_3)
    );
    reduction_2t1 reduction_unit_4_2_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_2_0),
        .in_valid_0   (valid_4_2_0),
        .in_ready_0   (ready_4_2_0),
        .in_data_1    (data_4_2_1),
        .in_valid_1   (valid_4_2_1),
        .in_ready_1   (ready_4_2_1),
        .out_data     (last_layer_data_4_0),
        .out_valid    (last_layer_valid_4_0),
        .out_ready    (last_layer_ready_4_0)
    );
    reduction_2t1 reduction_unit_4_2_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_4_2_2),
        .in_valid_0   (valid_4_2_2),
        .in_ready_0   (ready_4_2_2),
        .in_data_1    (data_4_2_3),
        .in_valid_1   (valid_4_2_3),
        .in_ready_1   (ready_4_2_3),
        .out_data     (last_layer_data_4_1),
        .out_valid    (last_layer_valid_4_1),
        .out_ready    (last_layer_ready_4_1)
    );
    reduction_2t1 reduction_unit_5_0_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_0_0),
        .in_valid_0   (valid_5_0_0),
        .in_ready_0   (ready_5_0_0),
        .in_data_1    (data_5_0_1),
        .in_valid_1   (valid_5_0_1),
        .in_ready_1   (ready_5_0_1),
        .out_data     (data_5_1_0),
        .out_valid    (valid_5_1_0),
        .out_ready    (ready_5_1_0)
    );
    reduction_2t1 reduction_unit_5_0_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_0_2),
        .in_valid_0   (valid_5_0_2),
        .in_ready_0   (ready_5_0_2),
        .in_data_1    (data_5_0_3),
        .in_valid_1   (valid_5_0_3),
        .in_ready_1   (ready_5_0_3),
        .out_data     (data_5_1_1),
        .out_valid    (valid_5_1_1),
        .out_ready    (ready_5_1_1)
    );
    reduction_2t1 reduction_unit_5_0_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_0_4),
        .in_valid_0   (valid_5_0_4),
        .in_ready_0   (ready_5_0_4),
        .in_data_1    (data_5_0_5),
        .in_valid_1   (valid_5_0_5),
        .in_ready_1   (ready_5_0_5),
        .out_data     (data_5_1_2),
        .out_valid    (valid_5_1_2),
        .out_ready    (ready_5_1_2)
    );
    reduction_2t1 reduction_unit_5_0_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_0_6),
        .in_valid_0   (valid_5_0_6),
        .in_ready_0   (ready_5_0_6),
        .in_data_1    (data_5_0_7),
        .in_valid_1   (valid_5_0_7),
        .in_ready_1   (ready_5_0_7),
        .out_data     (data_5_1_3),
        .out_valid    (valid_5_1_3),
        .out_ready    (ready_5_1_3)
    );
    reduction_2t1 reduction_unit_5_0_4 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_0_8),
        .in_valid_0   (valid_5_0_8),
        .in_ready_0   (ready_5_0_8),
        .in_data_1    (data_5_0_9),
        .in_valid_1   (valid_5_0_9),
        .in_ready_1   (ready_5_0_9),
        .out_data     (data_5_1_4),
        .out_valid    (valid_5_1_4),
        .out_ready    (ready_5_1_4)
    );
    reduction_2t1 reduction_unit_5_0_5 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_0_10),
        .in_valid_0   (valid_5_0_10),
        .in_ready_0   (ready_5_0_10),
        .in_data_1    (data_5_0_11),
        .in_valid_1   (valid_5_0_11),
        .in_ready_1   (ready_5_0_11),
        .out_data     (data_5_1_5),
        .out_valid    (valid_5_1_5),
        .out_ready    (ready_5_1_5)
    );
    reduction_2t1 reduction_unit_5_0_6 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_0_12),
        .in_valid_0   (valid_5_0_12),
        .in_ready_0   (ready_5_0_12),
        .in_data_1    (data_5_0_13),
        .in_valid_1   (valid_5_0_13),
        .in_ready_1   (ready_5_0_13),
        .out_data     (data_5_1_6),
        .out_valid    (valid_5_1_6),
        .out_ready    (ready_5_1_6)
    );
    reduction_2t1 reduction_unit_5_0_7 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_0_14),
        .in_valid_0   (valid_5_0_14),
        .in_ready_0   (ready_5_0_14),
        .in_data_1    (data_5_0_15),
        .in_valid_1   (valid_5_0_15),
        .in_ready_1   (ready_5_0_15),
        .out_data     (data_5_1_7),
        .out_valid    (valid_5_1_7),
        .out_ready    (ready_5_1_7)
    );
    reduction_2t1 reduction_unit_5_1_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_1_0),
        .in_valid_0   (valid_5_1_0),
        .in_ready_0   (ready_5_1_0),
        .in_data_1    (data_5_1_1),
        .in_valid_1   (valid_5_1_1),
        .in_ready_1   (ready_5_1_1),
        .out_data     (data_5_2_0),
        .out_valid    (valid_5_2_0),
        .out_ready    (ready_5_2_0)
    );
    reduction_2t1 reduction_unit_5_1_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_1_2),
        .in_valid_0   (valid_5_1_2),
        .in_ready_0   (ready_5_1_2),
        .in_data_1    (data_5_1_3),
        .in_valid_1   (valid_5_1_3),
        .in_ready_1   (ready_5_1_3),
        .out_data     (data_5_2_1),
        .out_valid    (valid_5_2_1),
        .out_ready    (ready_5_2_1)
    );
    reduction_2t1 reduction_unit_5_1_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_1_4),
        .in_valid_0   (valid_5_1_4),
        .in_ready_0   (ready_5_1_4),
        .in_data_1    (data_5_1_5),
        .in_valid_1   (valid_5_1_5),
        .in_ready_1   (ready_5_1_5),
        .out_data     (data_5_2_2),
        .out_valid    (valid_5_2_2),
        .out_ready    (ready_5_2_2)
    );
    reduction_2t1 reduction_unit_5_1_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_1_6),
        .in_valid_0   (valid_5_1_6),
        .in_ready_0   (ready_5_1_6),
        .in_data_1    (data_5_1_7),
        .in_valid_1   (valid_5_1_7),
        .in_ready_1   (ready_5_1_7),
        .out_data     (data_5_2_3),
        .out_valid    (valid_5_2_3),
        .out_ready    (ready_5_2_3)
    );
    reduction_2t1 reduction_unit_5_2_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_2_0),
        .in_valid_0   (valid_5_2_0),
        .in_ready_0   (ready_5_2_0),
        .in_data_1    (data_5_2_1),
        .in_valid_1   (valid_5_2_1),
        .in_ready_1   (ready_5_2_1),
        .out_data     (last_layer_data_5_0),
        .out_valid    (last_layer_valid_5_0),
        .out_ready    (last_layer_ready_5_0)
    );
    reduction_2t1 reduction_unit_5_2_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_5_2_2),
        .in_valid_0   (valid_5_2_2),
        .in_ready_0   (ready_5_2_2),
        .in_data_1    (data_5_2_3),
        .in_valid_1   (valid_5_2_3),
        .in_ready_1   (ready_5_2_3),
        .out_data     (last_layer_data_5_1),
        .out_valid    (last_layer_valid_5_1),
        .out_ready    (last_layer_ready_5_1)
    );
    reduction_2t1 reduction_unit_6_0_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_0_0),
        .in_valid_0   (valid_6_0_0),
        .in_ready_0   (ready_6_0_0),
        .in_data_1    (data_6_0_1),
        .in_valid_1   (valid_6_0_1),
        .in_ready_1   (ready_6_0_1),
        .out_data     (data_6_1_0),
        .out_valid    (valid_6_1_0),
        .out_ready    (ready_6_1_0)
    );
    reduction_2t1 reduction_unit_6_0_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_0_2),
        .in_valid_0   (valid_6_0_2),
        .in_ready_0   (ready_6_0_2),
        .in_data_1    (data_6_0_3),
        .in_valid_1   (valid_6_0_3),
        .in_ready_1   (ready_6_0_3),
        .out_data     (data_6_1_1),
        .out_valid    (valid_6_1_1),
        .out_ready    (ready_6_1_1)
    );
    reduction_2t1 reduction_unit_6_0_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_0_4),
        .in_valid_0   (valid_6_0_4),
        .in_ready_0   (ready_6_0_4),
        .in_data_1    (data_6_0_5),
        .in_valid_1   (valid_6_0_5),
        .in_ready_1   (ready_6_0_5),
        .out_data     (data_6_1_2),
        .out_valid    (valid_6_1_2),
        .out_ready    (ready_6_1_2)
    );
    reduction_2t1 reduction_unit_6_0_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_0_6),
        .in_valid_0   (valid_6_0_6),
        .in_ready_0   (ready_6_0_6),
        .in_data_1    (data_6_0_7),
        .in_valid_1   (valid_6_0_7),
        .in_ready_1   (ready_6_0_7),
        .out_data     (data_6_1_3),
        .out_valid    (valid_6_1_3),
        .out_ready    (ready_6_1_3)
    );
    reduction_2t1 reduction_unit_6_0_4 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_0_8),
        .in_valid_0   (valid_6_0_8),
        .in_ready_0   (ready_6_0_8),
        .in_data_1    (data_6_0_9),
        .in_valid_1   (valid_6_0_9),
        .in_ready_1   (ready_6_0_9),
        .out_data     (data_6_1_4),
        .out_valid    (valid_6_1_4),
        .out_ready    (ready_6_1_4)
    );
    reduction_2t1 reduction_unit_6_0_5 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_0_10),
        .in_valid_0   (valid_6_0_10),
        .in_ready_0   (ready_6_0_10),
        .in_data_1    (data_6_0_11),
        .in_valid_1   (valid_6_0_11),
        .in_ready_1   (ready_6_0_11),
        .out_data     (data_6_1_5),
        .out_valid    (valid_6_1_5),
        .out_ready    (ready_6_1_5)
    );
    reduction_2t1 reduction_unit_6_0_6 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_0_12),
        .in_valid_0   (valid_6_0_12),
        .in_ready_0   (ready_6_0_12),
        .in_data_1    (data_6_0_13),
        .in_valid_1   (valid_6_0_13),
        .in_ready_1   (ready_6_0_13),
        .out_data     (data_6_1_6),
        .out_valid    (valid_6_1_6),
        .out_ready    (ready_6_1_6)
    );
    reduction_2t1 reduction_unit_6_0_7 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_0_14),
        .in_valid_0   (valid_6_0_14),
        .in_ready_0   (ready_6_0_14),
        .in_data_1    (data_6_0_15),
        .in_valid_1   (valid_6_0_15),
        .in_ready_1   (ready_6_0_15),
        .out_data     (data_6_1_7),
        .out_valid    (valid_6_1_7),
        .out_ready    (ready_6_1_7)
    );
    reduction_2t1 reduction_unit_6_1_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_1_0),
        .in_valid_0   (valid_6_1_0),
        .in_ready_0   (ready_6_1_0),
        .in_data_1    (data_6_1_1),
        .in_valid_1   (valid_6_1_1),
        .in_ready_1   (ready_6_1_1),
        .out_data     (data_6_2_0),
        .out_valid    (valid_6_2_0),
        .out_ready    (ready_6_2_0)
    );
    reduction_2t1 reduction_unit_6_1_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_1_2),
        .in_valid_0   (valid_6_1_2),
        .in_ready_0   (ready_6_1_2),
        .in_data_1    (data_6_1_3),
        .in_valid_1   (valid_6_1_3),
        .in_ready_1   (ready_6_1_3),
        .out_data     (data_6_2_1),
        .out_valid    (valid_6_2_1),
        .out_ready    (ready_6_2_1)
    );
    reduction_2t1 reduction_unit_6_1_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_1_4),
        .in_valid_0   (valid_6_1_4),
        .in_ready_0   (ready_6_1_4),
        .in_data_1    (data_6_1_5),
        .in_valid_1   (valid_6_1_5),
        .in_ready_1   (ready_6_1_5),
        .out_data     (data_6_2_2),
        .out_valid    (valid_6_2_2),
        .out_ready    (ready_6_2_2)
    );
    reduction_2t1 reduction_unit_6_1_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_1_6),
        .in_valid_0   (valid_6_1_6),
        .in_ready_0   (ready_6_1_6),
        .in_data_1    (data_6_1_7),
        .in_valid_1   (valid_6_1_7),
        .in_ready_1   (ready_6_1_7),
        .out_data     (data_6_2_3),
        .out_valid    (valid_6_2_3),
        .out_ready    (ready_6_2_3)
    );
    reduction_2t1 reduction_unit_6_2_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_2_0),
        .in_valid_0   (valid_6_2_0),
        .in_ready_0   (ready_6_2_0),
        .in_data_1    (data_6_2_1),
        .in_valid_1   (valid_6_2_1),
        .in_ready_1   (ready_6_2_1),
        .out_data     (last_layer_data_6_0),
        .out_valid    (last_layer_valid_6_0),
        .out_ready    (last_layer_ready_6_0)
    );
    reduction_2t1 reduction_unit_6_2_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_6_2_2),
        .in_valid_0   (valid_6_2_2),
        .in_ready_0   (ready_6_2_2),
        .in_data_1    (data_6_2_3),
        .in_valid_1   (valid_6_2_3),
        .in_ready_1   (ready_6_2_3),
        .out_data     (last_layer_data_6_1),
        .out_valid    (last_layer_valid_6_1),
        .out_ready    (last_layer_ready_6_1)
    );
    reduction_2t1 reduction_unit_7_0_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_0_0),
        .in_valid_0   (valid_7_0_0),
        .in_ready_0   (ready_7_0_0),
        .in_data_1    (data_7_0_1),
        .in_valid_1   (valid_7_0_1),
        .in_ready_1   (ready_7_0_1),
        .out_data     (data_7_1_0),
        .out_valid    (valid_7_1_0),
        .out_ready    (ready_7_1_0)
    );
    reduction_2t1 reduction_unit_7_0_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_0_2),
        .in_valid_0   (valid_7_0_2),
        .in_ready_0   (ready_7_0_2),
        .in_data_1    (data_7_0_3),
        .in_valid_1   (valid_7_0_3),
        .in_ready_1   (ready_7_0_3),
        .out_data     (data_7_1_1),
        .out_valid    (valid_7_1_1),
        .out_ready    (ready_7_1_1)
    );
    reduction_2t1 reduction_unit_7_0_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_0_4),
        .in_valid_0   (valid_7_0_4),
        .in_ready_0   (ready_7_0_4),
        .in_data_1    (data_7_0_5),
        .in_valid_1   (valid_7_0_5),
        .in_ready_1   (ready_7_0_5),
        .out_data     (data_7_1_2),
        .out_valid    (valid_7_1_2),
        .out_ready    (ready_7_1_2)
    );
    reduction_2t1 reduction_unit_7_0_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_0_6),
        .in_valid_0   (valid_7_0_6),
        .in_ready_0   (ready_7_0_6),
        .in_data_1    (data_7_0_7),
        .in_valid_1   (valid_7_0_7),
        .in_ready_1   (ready_7_0_7),
        .out_data     (data_7_1_3),
        .out_valid    (valid_7_1_3),
        .out_ready    (ready_7_1_3)
    );
    reduction_2t1 reduction_unit_7_0_4 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_0_8),
        .in_valid_0   (valid_7_0_8),
        .in_ready_0   (ready_7_0_8),
        .in_data_1    (data_7_0_9),
        .in_valid_1   (valid_7_0_9),
        .in_ready_1   (ready_7_0_9),
        .out_data     (data_7_1_4),
        .out_valid    (valid_7_1_4),
        .out_ready    (ready_7_1_4)
    );
    reduction_2t1 reduction_unit_7_0_5 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_0_10),
        .in_valid_0   (valid_7_0_10),
        .in_ready_0   (ready_7_0_10),
        .in_data_1    (data_7_0_11),
        .in_valid_1   (valid_7_0_11),
        .in_ready_1   (ready_7_0_11),
        .out_data     (data_7_1_5),
        .out_valid    (valid_7_1_5),
        .out_ready    (ready_7_1_5)
    );
    reduction_2t1 reduction_unit_7_0_6 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_0_12),
        .in_valid_0   (valid_7_0_12),
        .in_ready_0   (ready_7_0_12),
        .in_data_1    (data_7_0_13),
        .in_valid_1   (valid_7_0_13),
        .in_ready_1   (ready_7_0_13),
        .out_data     (data_7_1_6),
        .out_valid    (valid_7_1_6),
        .out_ready    (ready_7_1_6)
    );
    reduction_2t1 reduction_unit_7_0_7 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_0_14),
        .in_valid_0   (valid_7_0_14),
        .in_ready_0   (ready_7_0_14),
        .in_data_1    (data_7_0_15),
        .in_valid_1   (valid_7_0_15),
        .in_ready_1   (ready_7_0_15),
        .out_data     (data_7_1_7),
        .out_valid    (valid_7_1_7),
        .out_ready    (ready_7_1_7)
    );
    reduction_2t1 reduction_unit_7_1_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_1_0),
        .in_valid_0   (valid_7_1_0),
        .in_ready_0   (ready_7_1_0),
        .in_data_1    (data_7_1_1),
        .in_valid_1   (valid_7_1_1),
        .in_ready_1   (ready_7_1_1),
        .out_data     (data_7_2_0),
        .out_valid    (valid_7_2_0),
        .out_ready    (ready_7_2_0)
    );
    reduction_2t1 reduction_unit_7_1_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_1_2),
        .in_valid_0   (valid_7_1_2),
        .in_ready_0   (ready_7_1_2),
        .in_data_1    (data_7_1_3),
        .in_valid_1   (valid_7_1_3),
        .in_ready_1   (ready_7_1_3),
        .out_data     (data_7_2_1),
        .out_valid    (valid_7_2_1),
        .out_ready    (ready_7_2_1)
    );
    reduction_2t1 reduction_unit_7_1_2 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_1_4),
        .in_valid_0   (valid_7_1_4),
        .in_ready_0   (ready_7_1_4),
        .in_data_1    (data_7_1_5),
        .in_valid_1   (valid_7_1_5),
        .in_ready_1   (ready_7_1_5),
        .out_data     (data_7_2_2),
        .out_valid    (valid_7_2_2),
        .out_ready    (ready_7_2_2)
    );
    reduction_2t1 reduction_unit_7_1_3 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_1_6),
        .in_valid_0   (valid_7_1_6),
        .in_ready_0   (ready_7_1_6),
        .in_data_1    (data_7_1_7),
        .in_valid_1   (valid_7_1_7),
        .in_ready_1   (ready_7_1_7),
        .out_data     (data_7_2_3),
        .out_valid    (valid_7_2_3),
        .out_ready    (ready_7_2_3)
    );
    reduction_2t1 reduction_unit_7_2_0 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_2_0),
        .in_valid_0   (valid_7_2_0),
        .in_ready_0   (ready_7_2_0),
        .in_data_1    (data_7_2_1),
        .in_valid_1   (valid_7_2_1),
        .in_ready_1   (ready_7_2_1),
        .out_data     (last_layer_data_7_0),
        .out_valid    (last_layer_valid_7_0),
        .out_ready    (last_layer_ready_7_0)
    );
    reduction_2t1 reduction_unit_7_2_1 (
        .clk          (clk), 
        .rst          (rst),
        .in_data_0    (data_7_2_2),
        .in_valid_0   (valid_7_2_2),
        .in_ready_0   (ready_7_2_2),
        .in_data_1    (data_7_2_3),
        .in_valid_1   (valid_7_2_3),
        .in_ready_1   (ready_7_2_3),
        .out_data     (last_layer_data_7_1),
        .out_valid    (last_layer_valid_7_1),
        .out_ready    (last_layer_ready_7_1)
    );


rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(15),
    .MEM_SIZE(32768),
    .INIT_FILE("./memory_init/hashtable0.mif")
)
hashtable_inst_0_0(
    .q_a       (ht_q_0_0),    
    .q_b       (ht_q_0_1),    
    .address_a (ht_addr_0_0[15-1:0]),
    .address_b (ht_addr_0_1[15-1:0]),
    .clock     (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(15),
    .MEM_SIZE(32768),
    .INIT_FILE("./memory_init/hashtable1.mif")
)
hashtable_inst_1_0(
    .q_a       (ht_q_1_0),    
    .q_b       (ht_q_1_1),    
    .address_a (ht_addr_1_0[15-1:0]),
    .address_b (ht_addr_1_1[15-1:0]),
    .clock     (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(12),
    .MEM_SIZE(4096),
    .INIT_FILE("./memory_init/hashtable2.mif")
)
hashtable_inst_2_0(
    .q_a       (ht_q_2_0),    
    .q_b       (ht_q_2_1),    
    .address_a (ht_addr_2_0[12-1:0]),
    .address_b (ht_addr_2_1[12-1:0]),
    .clock     (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(12),
    .MEM_SIZE(4096),
    .INIT_FILE("./memory_init/hashtable3.mif")
)
hashtable_inst_3_0(
    .q_a       (ht_q_3_0),    
    .q_b       (ht_q_3_1),    
    .address_a (ht_addr_3_0[12-1:0]),
    .address_b (ht_addr_3_1[12-1:0]),
    .clock     (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(11),
    .MEM_SIZE(2048),
    .INIT_FILE("./memory_init/hashtable4.mif")
)
hashtable_inst_4_0(
    .q_a       (ht_q_4_0),    
    .q_b       (ht_q_4_1),    
    .address_a (ht_addr_4_0[11-1:0]),
    .address_b (ht_addr_4_1[11-1:0]),
    .clock     (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(12),
    .MEM_SIZE(4096),
    .INIT_FILE("./memory_init/hashtable5.mif")
)
hashtable_inst_5_0(
    .q_a       (ht_q_5_0),    
    .q_b       (ht_q_5_1),    
    .address_a (ht_addr_5_0[12-1:0]),
    .address_b (ht_addr_5_1[12-1:0]),
    .clock     (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(10),
    .MEM_SIZE(1024),
    .INIT_FILE("./memory_init/hashtable6.mif")
)
hashtable_inst_6_0(
    .q_a       (ht_q_6_0),    
    .q_b       (ht_q_6_1),    
    .address_a (ht_addr_6_0[10-1:0]),
    .address_b (ht_addr_6_1[10-1:0]),
    .clock     (clk)   
);
rom_2port #(
    .DWIDTH(RID_WIDTH),
    .AWIDTH(8),
    .MEM_SIZE(256),
    .INIT_FILE("./memory_init/hashtable7.mif")
)
hashtable_inst_7_0(
    .q_a       (ht_q_7_0),    
    .q_b       (ht_q_7_1),    
    .address_a (ht_addr_7_0[8-1:0]),
    .address_b (ht_addr_7_1[8-1:0]),
    .clock     (clk)   
);

//internal rule FIFO
unified_pkt_fifo  #(
    .FIFO_NAME        ("[fast_pattern] rule_FIFO"),
    .MEM_TYPE         ("M20K"),
    .DUAL_CLOCK       (0),
    .USE_ALMOST_FULL  (1),
    .FULL_LEVEL       (450),
    .SYMBOLS_PER_BEAT (32),
    .BITS_PER_SYMBOL  (8),
    .FIFO_DEPTH       (512)
) rule_fifo (
    .in_clk            (clk),
    .in_reset          (rst),
    .out_clk           (),
    .out_reset         (),
    .in_data           (int_data),
    .in_valid          (int_valid),
    .in_ready          (int_ready),
    .in_startofpacket  (int_sop),
    .in_endofpacket    (int_eop),
    .in_empty          (int_empty),
    .out_data          (int_usr_data),
    .out_valid         (int_usr_valid),
    .out_ready         (int_usr_ready),
    .out_startofpacket (int_usr_sop),
    .out_endofpacket   (int_usr_eop),
    .out_empty         (int_usr_empty),
    .fill_level        (int_csr_readdata),
    .almost_full       (int_almost_full),
    .overflow          ()
);

rule_packer_256_512 rule_packer_inst(
    .clk            (clk),
    .rst            (rst),
    .in_rule_data   (int_usr_data),
    .in_rule_valid  (int_usr_valid),
    .in_rule_ready  (int_usr_ready),
    .in_rule_sop    (int_usr_sop),
    .in_rule_eop    (int_usr_eop),
    .in_rule_empty  (int_usr_empty),
    .out_rule_data  (rule_packer_data),
    .out_rule_valid (rule_packer_valid),
    .out_rule_ready (rule_packer_ready),
    .out_rule_sop   (rule_packer_sop),
    .out_rule_eop   (rule_packer_eop),
    .out_rule_empty (rule_packer_empty)
);

//512-bit wide rule FIFO
unified_pkt_fifo  #(
    .FIFO_NAME        ("[fast_pattern] rule_packer_FIFO"),
    .MEM_TYPE         ("M20K"),
    .DUAL_CLOCK       (0),
    .USE_ALMOST_FULL  (0),
    .FULL_LEVEL       (450),
    .SYMBOLS_PER_BEAT (64),
    .BITS_PER_SYMBOL  (8),
    .FIFO_DEPTH       (512)
) rule_packer_fifo (
    .in_clk            (clk),
    .in_reset          (rst),
    .out_clk           (),
    .out_reset         (),
    .in_data           (rule_packer_data),
    .in_valid          (rule_packer_valid),
    .in_ready          (rule_packer_ready),
    .in_startofpacket  (rule_packer_sop),
    .in_endofpacket    (rule_packer_eop),
    .in_empty          (rule_packer_empty),
    .out_data          (out_usr_data),
    .out_valid         (out_usr_valid),
    .out_ready         (out_usr_ready),
    .out_startofpacket (out_usr_sop),
    .out_endofpacket   (out_usr_eop),
    .out_empty         (out_usr_empty),
    .fill_level        (rule_packer_csr_readdata),
    .almost_full       (),
    .overflow          ()
);

endmodule
