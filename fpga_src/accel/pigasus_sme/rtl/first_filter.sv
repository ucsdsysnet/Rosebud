module first_filter(clk,rst,
	in_data,in_valid,init,in_last,in_strb,
    out_data,out_valid
);

input clk;
input rst;
input [255:0] in_data;
input in_valid;
input init;
input in_last;
input [7:0] in_strb; //MOEIN
output wire [255:0] out_data;
output reg out_valid;

wire [12:0] addr0;
wire [63:0] q0;
wire [127:0] temp_st0;
wire [12:0] addr1;
wire [63:0] q1;
wire [127:0] temp_st1;
wire [12:0] addr2;
wire [63:0] q2;
wire [127:0] temp_st2;
wire [12:0] addr3;
wire [63:0] q3;
wire [127:0] temp_st3;
wire [12:0] addr4;
wire [63:0] q4;
wire [127:0] temp_st4;
wire [12:0] addr5;
wire [63:0] q5;
wire [127:0] temp_st5;
wire [12:0] addr6;
wire [63:0] q6;
wire [127:0] temp_st6;
wire [12:0] addr7;
wire [63:0] q7;
wire [127:0] temp_st7;

reg [255:0] in_reg;
reg in_valid_reg;
wire [127:0] temp_low;
wire [127:0] temp_high;
wire [127:0] temp_high1;
wire [127:0] temp_high2;
reg [63:0] state;
wire [63:0] next_state;
wire [127:0] state_low;
wire [127:0] state_high;
wire [127:0] state_high1;
wire [127:0] state_high2;
wire new_pkt;
reg new_pkt_reg;
reg state_valid;
reg last;
reg last_r;
reg [63:0] mask; //MOEIN
reg [7:0] n_strb;

assign addr0 = in_reg[0*8+12:0*8];
assign addr1 = in_reg[1*8+12:1*8];
assign addr2 = in_reg[2*8+12:2*8];
assign addr3 = in_reg[3*8+12:3*8];
assign addr4 = in_reg[4*8+12:4*8];
assign addr5 = in_reg[5*8+12:5*8];
assign addr6 = in_reg[6*8+12:6*8];
assign addr7 = last ? {5'b0,in_reg[(7+1)*8-1:7*8]} : {in_data[4:0],in_reg[(7+1)*8-1:7*8]};

assign temp_st0 = q0 << 0*8;
assign temp_st1 = q1 << 1*8;
assign temp_st2 = q2 << 2*8;
assign temp_st3 = q3 << 3*8;
assign temp_st4 = q4 << 4*8;
assign temp_st5 = q5 << 5*8;
assign temp_st6 = q6 << 6*8;
assign temp_st7 = q7 << 7*8;
assign temp_st8 = 0; // q8 << 0*8;
assign temp_st9 = 0; // q9 << 1*8;
assign temp_st10 = 0; // q10 << 2*8;
assign temp_st11 = 0; // q11 << 3*8;
assign temp_st12 = 0; // q12 << 4*8;
assign temp_st13 = 0; // q13 << 5*8;
assign temp_st14 = 0; // q14 << 6*8;
assign temp_st15 = 0; // q15 << 7*8;
assign temp_st16 = 0; // q16 << 0*8;
assign temp_st17 = 0; // q17 << 1*8;
assign temp_st18 = 0; // q18 << 2*8;
assign temp_st19 = 0; // q19 << 3*8;
assign temp_st20 = 0; // q20 << 4*8;
assign temp_st21 = 0; // q21 << 5*8;
assign temp_st22 = 0; // q22 << 6*8;
assign temp_st23 = 0; // q23 << 7*8;
assign temp_st24 = 0; // q24 << 0*8;
assign temp_st25 = 0; // q25 << 1*8;
assign temp_st26 = 0; // q26 << 2*8;
assign temp_st27 = 0; // q27 << 3*8;
assign temp_st28 = 0; // q28 << 4*8;
assign temp_st29 = 0; // q29 << 5*8;
assign temp_st30 = 0; // q30 << 6*8;
assign temp_st31 = 0; // q31 << 7*8;



assign temp_low = temp_st0|temp_st1|temp_st2|temp_st3|temp_st4|temp_st5|temp_st6|temp_st7;     
assign temp_high = temp_st8|temp_st9|temp_st10|temp_st11|temp_st12|temp_st13|temp_st14|temp_st15;     
assign temp_high1 = temp_st16|temp_st17|temp_st18|temp_st19|temp_st20|temp_st21|temp_st22|temp_st23;     
assign temp_high2 = temp_st24|temp_st25|temp_st26|temp_st27|temp_st28|temp_st29|temp_st30|temp_st31;     
assign state_low = temp_low | state;
assign state_high = temp_high | temp_low[127:64];
assign state_high1 = temp_high1 | temp_high[127:64];
assign state_high2 = temp_high2 | temp_high1[127:64];

//assign out_data = {state_high[63:0],state_low[63:0]};
assign out_data = {state_high2[63:0],state_high1[63:0],state_high[63:0],state_low[63:0]} | {{192{1'b1}}, mask};

assign next_state = temp_low[127:64]; //state_high2[127:64];


always @ (posedge clk) begin
    n_strb <= ~in_strb;
    last <= in_valid & in_last;

    //end

    if(last)begin
        mask <= {{8{n_strb[7]}},{8{n_strb[6]}},{8{n_strb[5]}},{8{n_strb[4]}},
                 {8{n_strb[3]}},{8{n_strb[2]}},{8{n_strb[1]}},{8{n_strb[0]}}};
        
    end else begin
        mask <= 0;
    end
end

always @ (posedge clk) begin
	//if(rst) begin
	//	in_valid_reg <= 0;
    //    out_valid <= 0;
    //    //state <= 64'h0003070f1f3f7fff;
    //    //state <= {64{1'b1}};
    //    new_pkt_reg <= 0;
    //    state_valid <= 0;
    //    //in_reg <= 0;
    //    last_r <= 0;
	//end else begin
	//end
    last_r <= last;
    in_valid_reg <= in_valid;
    out_valid <= in_valid_reg;

    //state update
    if(init)begin
        state <= 64'h0003070f1f3f7fff;
        //The boudary bytes should not generate matches
        //by themselves
        //state <= {64{1'b1}};
    end else begin
        if(out_valid)begin
            state <= next_state;
        end
    end

    in_reg <= in_data;
end

rom_2port_noreg #(
	.DWIDTH(64),
	.AWIDTH(13),
	.MEM_SIZE(8192),
	.INIT_FILE("./memory_init/match_table.mif")
)
match_table_0 (
	.q_a       (q0),    
	.q_b       (q1),    
	.address_a (addr0),
	.address_b (addr1),
	.clk       (clk)   
);
rom_2port_noreg #(
	.DWIDTH(64),
	.AWIDTH(13),
	.MEM_SIZE(8192),
	.INIT_FILE("./memory_init/match_table.mif")
)
match_table_1 (
	.q_a       (q2),    
	.q_b       (q3),    
	.address_a (addr2),
	.address_b (addr3),
	.clk       (clk)   
);
rom_2port_noreg #(
	.DWIDTH(64),
	.AWIDTH(13),
	.MEM_SIZE(8192),
	.INIT_FILE("./memory_init/match_table.mif")
)
match_table_2 (
	.q_a       (q4),    
	.q_b       (q5),    
	.address_a (addr4),
	.address_b (addr5),
	.clk       (clk)   
);
rom_2port_noreg #(
	.DWIDTH(64),
	.AWIDTH(13),
	.MEM_SIZE(8192),
	.INIT_FILE("./memory_init/match_table.mif")
)
match_table_3 (
	.q_a       (q6),    
	.q_b       (q7),    
	.address_a (addr6),
	.address_b (addr7),
	.clk       (clk)   
);

endmodule