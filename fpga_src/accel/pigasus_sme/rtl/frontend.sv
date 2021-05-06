`include "struct_s.sv"
module frontend (clk,rst,
    hash_out_0_0,
    hash_out_valid_filter_0_0,
    hash_out_0_1,
    hash_out_valid_filter_0_1,
    hash_out_0_2,
    hash_out_valid_filter_0_2,
    hash_out_0_3,
    hash_out_valid_filter_0_3,
    hash_out_0_4,
    hash_out_valid_filter_0_4,
    hash_out_0_5,
    hash_out_valid_filter_0_5,
    hash_out_0_6,
    hash_out_valid_filter_0_6,
    hash_out_0_7,
    hash_out_valid_filter_0_7,
    hash_out_1_0,
    hash_out_valid_filter_1_0,
    hash_out_1_1,
    hash_out_valid_filter_1_1,
    hash_out_1_2,
    hash_out_valid_filter_1_2,
    hash_out_1_3,
    hash_out_valid_filter_1_3,
    hash_out_1_4,
    hash_out_valid_filter_1_4,
    hash_out_1_5,
    hash_out_valid_filter_1_5,
    hash_out_1_6,
    hash_out_valid_filter_1_6,
    hash_out_1_7,
    hash_out_valid_filter_1_7,
    hash_out_2_0,
    hash_out_valid_filter_2_0,
    hash_out_2_1,
    hash_out_valid_filter_2_1,
    hash_out_2_2,
    hash_out_valid_filter_2_2,
    hash_out_2_3,
    hash_out_valid_filter_2_3,
    hash_out_2_4,
    hash_out_valid_filter_2_4,
    hash_out_2_5,
    hash_out_valid_filter_2_5,
    hash_out_2_6,
    hash_out_valid_filter_2_6,
    hash_out_2_7,
    hash_out_valid_filter_2_7,
    hash_out_3_0,
    hash_out_valid_filter_3_0,
    hash_out_3_1,
    hash_out_valid_filter_3_1,
    hash_out_3_2,
    hash_out_valid_filter_3_2,
    hash_out_3_3,
    hash_out_valid_filter_3_3,
    hash_out_3_4,
    hash_out_valid_filter_3_4,
    hash_out_3_5,
    hash_out_valid_filter_3_5,
    hash_out_3_6,
    hash_out_valid_filter_3_6,
    hash_out_3_7,
    hash_out_valid_filter_3_7,
    hash_out_4_0,
    hash_out_valid_filter_4_0,
    hash_out_4_1,
    hash_out_valid_filter_4_1,
    hash_out_4_2,
    hash_out_valid_filter_4_2,
    hash_out_4_3,
    hash_out_valid_filter_4_3,
    hash_out_4_4,
    hash_out_valid_filter_4_4,
    hash_out_4_5,
    hash_out_valid_filter_4_5,
    hash_out_4_6,
    hash_out_valid_filter_4_6,
    hash_out_4_7,
    hash_out_valid_filter_4_7,
    hash_out_5_0,
    hash_out_valid_filter_5_0,
    hash_out_5_1,
    hash_out_valid_filter_5_1,
    hash_out_5_2,
    hash_out_valid_filter_5_2,
    hash_out_5_3,
    hash_out_valid_filter_5_3,
    hash_out_5_4,
    hash_out_valid_filter_5_4,
    hash_out_5_5,
    hash_out_valid_filter_5_5,
    hash_out_5_6,
    hash_out_valid_filter_5_6,
    hash_out_5_7,
    hash_out_valid_filter_5_7,
    hash_out_6_0,
    hash_out_valid_filter_6_0,
    hash_out_6_1,
    hash_out_valid_filter_6_1,
    hash_out_6_2,
    hash_out_valid_filter_6_2,
    hash_out_6_3,
    hash_out_valid_filter_6_3,
    hash_out_6_4,
    hash_out_valid_filter_6_4,
    hash_out_6_5,
    hash_out_valid_filter_6_5,
    hash_out_6_6,
    hash_out_valid_filter_6_6,
    hash_out_6_7,
    hash_out_valid_filter_6_7,
    hash_out_7_0,
    hash_out_valid_filter_7_0,
    hash_out_7_1,
    hash_out_valid_filter_7_1,
    hash_out_7_2,
    hash_out_valid_filter_7_2,
    hash_out_7_3,
    hash_out_valid_filter_7_3,
    hash_out_7_4,
    hash_out_valid_filter_7_4,
    hash_out_7_5,
    hash_out_valid_filter_7_5,
    hash_out_7_6,
    hash_out_valid_filter_7_6,
    hash_out_7_7,
    hash_out_valid_filter_7_7,
    in_data,
    in_valid,
    init,
    in_last,
    in_strb,
    out_new_pkt
);

input clk;
input rst;
input [255:0] in_data;
input in_valid;
input init;
input in_last;
input [7:0] in_strb;
output wire [RID_WIDTH-1:0] hash_out_0_0;
output wire hash_out_valid_filter_0_0;
output wire [RID_WIDTH-1:0] hash_out_0_1;
output wire hash_out_valid_filter_0_1;
output wire [RID_WIDTH-1:0] hash_out_0_2;
output wire hash_out_valid_filter_0_2;
output wire [RID_WIDTH-1:0] hash_out_0_3;
output wire hash_out_valid_filter_0_3;
output wire [RID_WIDTH-1:0] hash_out_0_4;
output wire hash_out_valid_filter_0_4;
output wire [RID_WIDTH-1:0] hash_out_0_5;
output wire hash_out_valid_filter_0_5;
output wire [RID_WIDTH-1:0] hash_out_0_6;
output wire hash_out_valid_filter_0_6;
output wire [RID_WIDTH-1:0] hash_out_0_7;
output wire hash_out_valid_filter_0_7;
output wire [RID_WIDTH-1:0] hash_out_1_0;
output wire hash_out_valid_filter_1_0;
output wire [RID_WIDTH-1:0] hash_out_1_1;
output wire hash_out_valid_filter_1_1;
output wire [RID_WIDTH-1:0] hash_out_1_2;
output wire hash_out_valid_filter_1_2;
output wire [RID_WIDTH-1:0] hash_out_1_3;
output wire hash_out_valid_filter_1_3;
output wire [RID_WIDTH-1:0] hash_out_1_4;
output wire hash_out_valid_filter_1_4;
output wire [RID_WIDTH-1:0] hash_out_1_5;
output wire hash_out_valid_filter_1_5;
output wire [RID_WIDTH-1:0] hash_out_1_6;
output wire hash_out_valid_filter_1_6;
output wire [RID_WIDTH-1:0] hash_out_1_7;
output wire hash_out_valid_filter_1_7;
output wire [RID_WIDTH-1:0] hash_out_2_0;
output wire hash_out_valid_filter_2_0;
output wire [RID_WIDTH-1:0] hash_out_2_1;
output wire hash_out_valid_filter_2_1;
output wire [RID_WIDTH-1:0] hash_out_2_2;
output wire hash_out_valid_filter_2_2;
output wire [RID_WIDTH-1:0] hash_out_2_3;
output wire hash_out_valid_filter_2_3;
output wire [RID_WIDTH-1:0] hash_out_2_4;
output wire hash_out_valid_filter_2_4;
output wire [RID_WIDTH-1:0] hash_out_2_5;
output wire hash_out_valid_filter_2_5;
output wire [RID_WIDTH-1:0] hash_out_2_6;
output wire hash_out_valid_filter_2_6;
output wire [RID_WIDTH-1:0] hash_out_2_7;
output wire hash_out_valid_filter_2_7;
output wire [RID_WIDTH-1:0] hash_out_3_0;
output wire hash_out_valid_filter_3_0;
output wire [RID_WIDTH-1:0] hash_out_3_1;
output wire hash_out_valid_filter_3_1;
output wire [RID_WIDTH-1:0] hash_out_3_2;
output wire hash_out_valid_filter_3_2;
output wire [RID_WIDTH-1:0] hash_out_3_3;
output wire hash_out_valid_filter_3_3;
output wire [RID_WIDTH-1:0] hash_out_3_4;
output wire hash_out_valid_filter_3_4;
output wire [RID_WIDTH-1:0] hash_out_3_5;
output wire hash_out_valid_filter_3_5;
output wire [RID_WIDTH-1:0] hash_out_3_6;
output wire hash_out_valid_filter_3_6;
output wire [RID_WIDTH-1:0] hash_out_3_7;
output wire hash_out_valid_filter_3_7;
output wire [RID_WIDTH-1:0] hash_out_4_0;
output wire hash_out_valid_filter_4_0;
output wire [RID_WIDTH-1:0] hash_out_4_1;
output wire hash_out_valid_filter_4_1;
output wire [RID_WIDTH-1:0] hash_out_4_2;
output wire hash_out_valid_filter_4_2;
output wire [RID_WIDTH-1:0] hash_out_4_3;
output wire hash_out_valid_filter_4_3;
output wire [RID_WIDTH-1:0] hash_out_4_4;
output wire hash_out_valid_filter_4_4;
output wire [RID_WIDTH-1:0] hash_out_4_5;
output wire hash_out_valid_filter_4_5;
output wire [RID_WIDTH-1:0] hash_out_4_6;
output wire hash_out_valid_filter_4_6;
output wire [RID_WIDTH-1:0] hash_out_4_7;
output wire hash_out_valid_filter_4_7;
output wire [RID_WIDTH-1:0] hash_out_5_0;
output wire hash_out_valid_filter_5_0;
output wire [RID_WIDTH-1:0] hash_out_5_1;
output wire hash_out_valid_filter_5_1;
output wire [RID_WIDTH-1:0] hash_out_5_2;
output wire hash_out_valid_filter_5_2;
output wire [RID_WIDTH-1:0] hash_out_5_3;
output wire hash_out_valid_filter_5_3;
output wire [RID_WIDTH-1:0] hash_out_5_4;
output wire hash_out_valid_filter_5_4;
output wire [RID_WIDTH-1:0] hash_out_5_5;
output wire hash_out_valid_filter_5_5;
output wire [RID_WIDTH-1:0] hash_out_5_6;
output wire hash_out_valid_filter_5_6;
output wire [RID_WIDTH-1:0] hash_out_5_7;
output wire hash_out_valid_filter_5_7;
output wire [RID_WIDTH-1:0] hash_out_6_0;
output wire hash_out_valid_filter_6_0;
output wire [RID_WIDTH-1:0] hash_out_6_1;
output wire hash_out_valid_filter_6_1;
output wire [RID_WIDTH-1:0] hash_out_6_2;
output wire hash_out_valid_filter_6_2;
output wire [RID_WIDTH-1:0] hash_out_6_3;
output wire hash_out_valid_filter_6_3;
output wire [RID_WIDTH-1:0] hash_out_6_4;
output wire hash_out_valid_filter_6_4;
output wire [RID_WIDTH-1:0] hash_out_6_5;
output wire hash_out_valid_filter_6_5;
output wire [RID_WIDTH-1:0] hash_out_6_6;
output wire hash_out_valid_filter_6_6;
output wire [RID_WIDTH-1:0] hash_out_6_7;
output wire hash_out_valid_filter_6_7;
output wire [RID_WIDTH-1:0] hash_out_7_0;
output wire hash_out_valid_filter_7_0;
output wire [RID_WIDTH-1:0] hash_out_7_1;
output wire hash_out_valid_filter_7_1;
output wire [RID_WIDTH-1:0] hash_out_7_2;
output wire hash_out_valid_filter_7_2;
output wire [RID_WIDTH-1:0] hash_out_7_3;
output wire hash_out_valid_filter_7_3;
output wire [RID_WIDTH-1:0] hash_out_7_4;
output wire hash_out_valid_filter_7_4;
output wire [RID_WIDTH-1:0] hash_out_7_5;
output wire hash_out_valid_filter_7_5;
output wire [RID_WIDTH-1:0] hash_out_7_6;
output wire hash_out_valid_filter_7_6;
output wire [RID_WIDTH-1:0] hash_out_7_7;
output wire hash_out_valid_filter_7_7;
output reg out_new_pkt;

//filter
wire ce;
wire [255:0] filter_out;
wire filter_out_valid;

//hashtable_top
wire hash_out_valid_0_0;
wire hash_out_valid_0_1;
wire hash_out_valid_0_2;
wire hash_out_valid_0_3;
wire hash_out_valid_0_4;
wire hash_out_valid_0_5;
wire hash_out_valid_0_6;
wire hash_out_valid_0_7;
wire hash_out_valid_1_0;
wire hash_out_valid_1_1;
wire hash_out_valid_1_2;
wire hash_out_valid_1_3;
wire hash_out_valid_1_4;
wire hash_out_valid_1_5;
wire hash_out_valid_1_6;
wire hash_out_valid_1_7;
wire hash_out_valid_2_0;
wire hash_out_valid_2_1;
wire hash_out_valid_2_2;
wire hash_out_valid_2_3;
wire hash_out_valid_2_4;
wire hash_out_valid_2_5;
wire hash_out_valid_2_6;
wire hash_out_valid_2_7;
wire hash_out_valid_3_0;
wire hash_out_valid_3_1;
wire hash_out_valid_3_2;
wire hash_out_valid_3_3;
wire hash_out_valid_3_4;
wire hash_out_valid_3_5;
wire hash_out_valid_3_6;
wire hash_out_valid_3_7;
wire hash_out_valid_4_0;
wire hash_out_valid_4_1;
wire hash_out_valid_4_2;
wire hash_out_valid_4_3;
wire hash_out_valid_4_4;
wire hash_out_valid_4_5;
wire hash_out_valid_4_6;
wire hash_out_valid_4_7;
wire hash_out_valid_5_0;
wire hash_out_valid_5_1;
wire hash_out_valid_5_2;
wire hash_out_valid_5_3;
wire hash_out_valid_5_4;
wire hash_out_valid_5_5;
wire hash_out_valid_5_6;
wire hash_out_valid_5_7;
wire hash_out_valid_6_0;
wire hash_out_valid_6_1;
wire hash_out_valid_6_2;
wire hash_out_valid_6_3;
wire hash_out_valid_6_4;
wire hash_out_valid_6_5;
wire hash_out_valid_6_6;
wire hash_out_valid_6_7;
wire hash_out_valid_7_0;
wire hash_out_valid_7_1;
wire hash_out_valid_7_2;
wire hash_out_valid_7_3;
wire hash_out_valid_7_4;
wire hash_out_valid_7_5;
wire hash_out_valid_7_6;
wire hash_out_valid_7_7;
reg [255:0] hash_in;
reg hash_in_valid;

//Other
reg [255:0] din_reg;
reg din_valid_reg;
wire new_pkt;
reg [255:0] filter_out_r1;
reg new_pkt_r1;
reg [255:0] filter_out_r2;
reg new_pkt_r2;
reg [255:0] filter_out_r3;
reg new_pkt_r3;
reg [255:0] filter_out_r4;
reg new_pkt_r4;
reg [255:0] filter_out_r5;
reg new_pkt_r5;
reg [255:0] filter_out_r6;
reg new_pkt_r6;
reg [255:0] filter_out_r7;
reg new_pkt_r7;
reg [255:0] filter_out_r8;
reg new_pkt_r8;
reg [255:0] filter_out_r9;
reg new_pkt_r9;
reg [255:0] filter_out_r10;
reg new_pkt_r10;
reg [255:0] filter_out_r11;
reg new_pkt_r11;
reg [255:0] filter_out_r12;
reg new_pkt_r12;
reg [255:0] filter_out_r13;
reg new_pkt_r13;
reg [255:0] filter_out_r14;
reg new_pkt_r14;
reg [255:0] filter_out_r15;
reg new_pkt_r15;
reg [255:0] filter_out_r16;
reg new_pkt_r16;

//Hashtable signals
assign hash_out_valid_filter_0_0 = hash_out_valid_0_0 & !filter_out_r13[0];
assign hash_out_valid_filter_0_1 = hash_out_valid_0_1 & !filter_out_r13[8];
assign hash_out_valid_filter_0_2 = hash_out_valid_0_2 & !filter_out_r13[16];
assign hash_out_valid_filter_0_3 = hash_out_valid_0_3 & !filter_out_r13[24];
assign hash_out_valid_filter_0_4 = hash_out_valid_0_4 & !filter_out_r13[32];
assign hash_out_valid_filter_0_5 = hash_out_valid_0_5 & !filter_out_r13[40];
assign hash_out_valid_filter_0_6 = hash_out_valid_0_6 & !filter_out_r13[48];
assign hash_out_valid_filter_0_7 = hash_out_valid_0_7 & !filter_out_r13[56];
assign hash_out_valid_filter_1_0 = hash_out_valid_1_0 & !filter_out_r13[1];
assign hash_out_valid_filter_1_1 = hash_out_valid_1_1 & !filter_out_r13[9];
assign hash_out_valid_filter_1_2 = hash_out_valid_1_2 & !filter_out_r13[17];
assign hash_out_valid_filter_1_3 = hash_out_valid_1_3 & !filter_out_r13[25];
assign hash_out_valid_filter_1_4 = hash_out_valid_1_4 & !filter_out_r13[33];
assign hash_out_valid_filter_1_5 = hash_out_valid_1_5 & !filter_out_r13[41];
assign hash_out_valid_filter_1_6 = hash_out_valid_1_6 & !filter_out_r13[49];
assign hash_out_valid_filter_1_7 = hash_out_valid_1_7 & !filter_out_r13[57];
assign hash_out_valid_filter_2_0 = hash_out_valid_2_0 & !filter_out_r13[2];
assign hash_out_valid_filter_2_1 = hash_out_valid_2_1 & !filter_out_r13[10];
assign hash_out_valid_filter_2_2 = hash_out_valid_2_2 & !filter_out_r13[18];
assign hash_out_valid_filter_2_3 = hash_out_valid_2_3 & !filter_out_r13[26];
assign hash_out_valid_filter_2_4 = hash_out_valid_2_4 & !filter_out_r13[34];
assign hash_out_valid_filter_2_5 = hash_out_valid_2_5 & !filter_out_r13[42];
assign hash_out_valid_filter_2_6 = hash_out_valid_2_6 & !filter_out_r13[50];
assign hash_out_valid_filter_2_7 = hash_out_valid_2_7 & !filter_out_r13[58];
assign hash_out_valid_filter_3_0 = hash_out_valid_3_0 & !filter_out_r13[3];
assign hash_out_valid_filter_3_1 = hash_out_valid_3_1 & !filter_out_r13[11];
assign hash_out_valid_filter_3_2 = hash_out_valid_3_2 & !filter_out_r13[19];
assign hash_out_valid_filter_3_3 = hash_out_valid_3_3 & !filter_out_r13[27];
assign hash_out_valid_filter_3_4 = hash_out_valid_3_4 & !filter_out_r13[35];
assign hash_out_valid_filter_3_5 = hash_out_valid_3_5 & !filter_out_r13[43];
assign hash_out_valid_filter_3_6 = hash_out_valid_3_6 & !filter_out_r13[51];
assign hash_out_valid_filter_3_7 = hash_out_valid_3_7 & !filter_out_r13[59];
assign hash_out_valid_filter_4_0 = hash_out_valid_4_0 & !filter_out_r13[4];
assign hash_out_valid_filter_4_1 = hash_out_valid_4_1 & !filter_out_r13[12];
assign hash_out_valid_filter_4_2 = hash_out_valid_4_2 & !filter_out_r13[20];
assign hash_out_valid_filter_4_3 = hash_out_valid_4_3 & !filter_out_r13[28];
assign hash_out_valid_filter_4_4 = hash_out_valid_4_4 & !filter_out_r13[36];
assign hash_out_valid_filter_4_5 = hash_out_valid_4_5 & !filter_out_r13[44];
assign hash_out_valid_filter_4_6 = hash_out_valid_4_6 & !filter_out_r13[52];
assign hash_out_valid_filter_4_7 = hash_out_valid_4_7 & !filter_out_r13[60];
assign hash_out_valid_filter_5_0 = hash_out_valid_5_0 & !filter_out_r13[5];
assign hash_out_valid_filter_5_1 = hash_out_valid_5_1 & !filter_out_r13[13];
assign hash_out_valid_filter_5_2 = hash_out_valid_5_2 & !filter_out_r13[21];
assign hash_out_valid_filter_5_3 = hash_out_valid_5_3 & !filter_out_r13[29];
assign hash_out_valid_filter_5_4 = hash_out_valid_5_4 & !filter_out_r13[37];
assign hash_out_valid_filter_5_5 = hash_out_valid_5_5 & !filter_out_r13[45];
assign hash_out_valid_filter_5_6 = hash_out_valid_5_6 & !filter_out_r13[53];
assign hash_out_valid_filter_5_7 = hash_out_valid_5_7 & !filter_out_r13[61];
assign hash_out_valid_filter_6_0 = hash_out_valid_6_0 & !filter_out_r13[6];
assign hash_out_valid_filter_6_1 = hash_out_valid_6_1 & !filter_out_r13[14];
assign hash_out_valid_filter_6_2 = hash_out_valid_6_2 & !filter_out_r13[22];
assign hash_out_valid_filter_6_3 = hash_out_valid_6_3 & !filter_out_r13[30];
assign hash_out_valid_filter_6_4 = hash_out_valid_6_4 & !filter_out_r13[38];
assign hash_out_valid_filter_6_5 = hash_out_valid_6_5 & !filter_out_r13[46];
assign hash_out_valid_filter_6_6 = hash_out_valid_6_6 & !filter_out_r13[54];
assign hash_out_valid_filter_6_7 = hash_out_valid_6_7 & !filter_out_r13[62];
assign hash_out_valid_filter_7_0 = hash_out_valid_7_0 & !filter_out_r13[7];
assign hash_out_valid_filter_7_1 = hash_out_valid_7_1 & !filter_out_r13[15];
assign hash_out_valid_filter_7_2 = hash_out_valid_7_2 & !filter_out_r13[23];
assign hash_out_valid_filter_7_3 = hash_out_valid_7_3 & !filter_out_r13[31];
assign hash_out_valid_filter_7_4 = hash_out_valid_7_4 & !filter_out_r13[39];
assign hash_out_valid_filter_7_5 = hash_out_valid_7_5 & !filter_out_r13[47];
assign hash_out_valid_filter_7_6 = hash_out_valid_7_6 & !filter_out_r13[55];
assign hash_out_valid_filter_7_7 = hash_out_valid_7_7 & !filter_out_r13[63];

assign new_pkt = in_last & in_valid;

//Make sure all the flits of the pkts have been checked before moving it. 
always @ (posedge clk) begin
    //if(rst) begin
    //    out_new_pkt <= 0;
    //    new_pkt_r1 <= 0;
    //    new_pkt_r2 <= 0;
    //    new_pkt_r3 <= 0;
    //    new_pkt_r4 <= 0;
    //    new_pkt_r5 <= 0;
    //    new_pkt_r6 <= 0;
    //    new_pkt_r7 <= 0;
    //    new_pkt_r8 <= 0;
    //    new_pkt_r9 <= 0;
    //    new_pkt_r10 <= 0;
    //    new_pkt_r11 <= 0;
    //    new_pkt_r12 <= 0;
    //    new_pkt_r13 <= 0;
    //    new_pkt_r14 <= 0;
    //    new_pkt_r15 <= 0;
    //    new_pkt_r16 <= 0;
    //end else begin
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
    //end
end

//consistent with the filter 
always @ (posedge clk) begin
    hash_in <= in_data;
    hash_in_valid <= in_valid;
end


//Comb of filter and hashtable
always @ (posedge clk) begin
    //if(rst) begin
    //    filter_out_r1 <= {256{1'b1}};
    //    filter_out_r2 <= {256{1'b1}};
    //    filter_out_r3 <= {256{1'b1}};
    //    filter_out_r4 <= {256{1'b1}};
    //    filter_out_r5 <= {256{1'b1}};
    //    filter_out_r6 <= {256{1'b1}};
    //    filter_out_r7 <= {256{1'b1}};
    //    filter_out_r8 <= {256{1'b1}};
    //    filter_out_r9 <= {256{1'b1}};
    //    filter_out_r10 <= {256{1'b1}};
    //    filter_out_r11 <= {256{1'b1}};
    //    filter_out_r12 <= {256{1'b1}};
    //    filter_out_r13 <= {256{1'b1}};
    //    filter_out_r14 <= {256{1'b1}};
    //    filter_out_r15 <= {256{1'b1}};
    //end else begin
        if(filter_out_valid) begin
            filter_out_r1 <= filter_out;
        end else begin
            filter_out_r1 <= {256{1'b1}};
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
    //end
end

//Instantiation
first_filter filter_inst(
    .clk(clk),
    .rst(rst),
	  .in_data    (in_data),
    .in_valid   (in_valid),
    .init       (init),
    .in_last    (in_last),
    .in_strb    (in_strb),
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
  .din (hash_in),
  .din_valid (hash_in_valid)
);

endmodule //top