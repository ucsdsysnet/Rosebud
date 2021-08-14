`include "struct_s.sv"
module first_filter(
    input                        clk,
    input                        rst,
    input [FP_DWIDTH-1:0]        in_data,
    input                        in_valid,
    input                        in_sop,
    input                        in_eop,
    input [FP_EWIDTH-1:0]        in_empty,
    input [63:0]                 wr_data,
    input [12:0]                 wr_addr,
    input                        wr_en,
    output logic [FP_DWIDTH-1:0] out_data,
    output logic                 out_valid
);


logic [12:0] addr0;
logic [63:0] q0;
logic [127:0] temp_st0;
logic [12:0] addr1;
logic [63:0] q1;
logic [127:0] temp_st1;
logic [12:0] addr2;
logic [63:0] q2;
logic [127:0] temp_st2;
logic [12:0] addr3;
logic [63:0] q3;
logic [127:0] temp_st3;
logic [12:0] addr4;
logic [63:0] q4;
logic [127:0] temp_st4;
logic [12:0] addr5;
logic [63:0] q5;
logic [127:0] temp_st5;
logic [12:0] addr6;
logic [63:0] q6;
logic [127:0] temp_st6;
logic [12:0] addr7;
logic [63:0] q7;
logic [127:0] temp_st7;
logic [12:0] addr8;
logic [63:0] q8;
logic [127:0] temp_st8;
logic [12:0] addr9;
logic [63:0] q9;
logic [127:0] temp_st9;
logic [12:0] addr10;
logic [63:0] q10;
logic [127:0] temp_st10;
logic [12:0] addr11;
logic [63:0] q11;
logic [127:0] temp_st11;
logic [12:0] addr12;
logic [63:0] q12;
logic [127:0] temp_st12;
logic [12:0] addr13;
logic [63:0] q13;
logic [127:0] temp_st13;
logic [12:0] addr14;
logic [63:0] q14;
logic [127:0] temp_st14;
logic [12:0] addr15;
logic [63:0] q15;
logic [127:0] temp_st15;

logic [FP_DWIDTH-1:0] in_reg;
logic [63:0] state;
logic [63:0] next_state;
logic in_valid_reg;
logic in_valid_reg_1;

logic [127:0] shiftor0;
logic [127:0] shiftor_state_0;
logic [127:0] shiftor1;
logic [127:0] shiftor_state_1;

logic new_pkt;
logic new_pkt_reg;
logic state_valid;
logic last;
logic last_r;
logic last_r1;
logic [FP_DWIDTH-1:0] mask;
logic [8:0] shift;

assign addr0 = in_reg[0*8+12:0*8];
assign addr1 = in_reg[1*8+12:1*8];
assign addr2 = in_reg[2*8+12:2*8];
assign addr3 = in_reg[3*8+12:3*8];
assign addr4 = in_reg[4*8+12:4*8];
assign addr5 = in_reg[5*8+12:5*8];
assign addr6 = in_reg[6*8+12:6*8];
assign addr7 = in_reg[7*8+12:7*8];
assign addr8 = in_reg[8*8+12:8*8];
assign addr9 = in_reg[9*8+12:9*8];
assign addr10 = in_reg[10*8+12:10*8];
assign addr11 = in_reg[11*8+12:11*8];
assign addr12 = in_reg[12*8+12:12*8];
assign addr13 = in_reg[13*8+12:13*8];
assign addr14 = in_reg[14*8+12:14*8];
assign addr15 = last ? {5'b0,in_reg[(15+1)*8-1:15*8]} : {in_data[4:0],in_reg[(15+1)*8-1:15*8]};

assign temp_st0 = q0 << 0*8;
assign temp_st1 = q1 << 1*8;
assign temp_st2 = q2 << 2*8;
assign temp_st3 = q3 << 3*8;
assign temp_st4 = q4 << 4*8;
assign temp_st5 = q5 << 5*8;
assign temp_st6 = q6 << 6*8;
assign temp_st7 = q7 << 7*8;
assign temp_st8 = q8 << 0*8;
assign temp_st9 = q9 << 1*8;
assign temp_st10 = q10 << 2*8;
assign temp_st11 = q11 << 3*8;
assign temp_st12 = q12 << 4*8;
assign temp_st13 = q13 << 5*8;
assign temp_st14 = q14 << 6*8;
assign temp_st15 = q15 << 7*8;


assign shiftor0 =  temp_st0 | temp_st1 | temp_st2 | temp_st3 | temp_st4 | temp_st5 | temp_st6 | temp_st7 | 0;
assign shiftor1 =  temp_st8 | temp_st9 | temp_st10 | temp_st11 | temp_st12 | temp_st13 | temp_st14 | temp_st15 | 0;

assign shiftor_state_0 = shiftor0 | state;
assign shiftor_state_1 = shiftor1 | shiftor_state_0[127:64];

//assign out_data = {state_high2[63:0],state_high1[63:0],state_high[63:0],state_low[63:0]} | mask;
assign out_data[64*0+63:64*0] = shiftor_state_0[63:0] | mask[64*0+63:64*0];
//assign out_data = {state_high2[63:0],state_high1[63:0],state_high[63:0],state_low[63:0]} | mask;
assign out_data[64*1+63:64*1] = shiftor_state_1[63:0] | mask[64*1+63:64*1];

assign next_state = shiftor_state_1[127:64];
//assign next_state = shiftor_state_1[127:64];


always @ (posedge clk) begin
    shift   <= (16-in_empty)*8;
    last    <= in_valid & in_eop;
    last_r  <= last;
    last_r1 <= last_r;

    if(last_r)begin
        mask <= {FP_DWIDTH-1{1'b1}} << shift;
    end else begin
        mask <= 0;
    end
end

always @ (posedge clk) begin
    in_valid_reg   <= in_valid;
    in_valid_reg_1 <= in_valid_reg;
    out_valid      <= in_valid_reg_1;

    // state update
    if (out_valid)begin
        if (last_r1) begin
            state <= 64'h0003070f1f3f7fff;
        end else begin
            state <= next_state;
        end
    end

    if (in_valid) begin
        in_reg <= in_data;
    end

    if (rst) begin
        state <= 64'h0003070f1f3f7fff;
    end
end

rom_2port #(
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
	.clock     (clk),
  .wr_data   (wr_data),
  .wr_addr   (wr_addr),
  .wr_en     (wr_en)
);
rom_2port #(
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
	.clock     (clk),
  .wr_data   (wr_data),
  .wr_addr   (wr_addr),
  .wr_en     (wr_en)
);
rom_2port #(
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
	.clock     (clk),
  .wr_data   (wr_data),
  .wr_addr   (wr_addr),
  .wr_en     (wr_en)
);
rom_2port #(
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
	.clock     (clk),
  .wr_data   (wr_data),
  .wr_addr   (wr_addr),
  .wr_en     (wr_en)
);
rom_2port #(
	.DWIDTH(64),
	.AWIDTH(13),
	.MEM_SIZE(8192),
	.INIT_FILE("./memory_init/match_table.mif")
)
match_table_4 (
	.q_a       (q8),    
	.q_b       (q9),    
	.address_a (addr8),
	.address_b (addr9),
	.clock     (clk),
  .wr_data   (wr_data),
  .wr_addr   (wr_addr),
  .wr_en     (wr_en)
);
rom_2port #(
	.DWIDTH(64),
	.AWIDTH(13),
	.MEM_SIZE(8192),
	.INIT_FILE("./memory_init/match_table.mif")
)
match_table_5 (
	.q_a       (q10),    
	.q_b       (q11),    
	.address_a (addr10),
	.address_b (addr11),
	.clock     (clk),
  .wr_data   (wr_data),
  .wr_addr   (wr_addr),
  .wr_en     (wr_en)
);
rom_2port #(
	.DWIDTH(64),
	.AWIDTH(13),
	.MEM_SIZE(8192),
	.INIT_FILE("./memory_init/match_table.mif")
)
match_table_6 (
	.q_a       (q12),    
	.q_b       (q13),    
	.address_a (addr12),
	.address_b (addr13),
	.clock     (clk),
  .wr_data   (wr_data),
  .wr_addr   (wr_addr),
  .wr_en     (wr_en)
);
rom_2port #(
	.DWIDTH(64),
	.AWIDTH(13),
	.MEM_SIZE(8192),
	.INIT_FILE("./memory_init/match_table.mif")
)
match_table_7 (
	.q_a       (q14),    
	.q_b       (q15),    
	.address_a (addr14),
	.address_b (addr15),
	.clock     (clk),
  .wr_data   (wr_data),
  .wr_addr   (wr_addr),
  .wr_en     (wr_en)
);

endmodule