`timescale 1 ps / 1 ps
`include "struct_s.sv"
// `define DUMMY_PG

module port_group (
    input   logic           clk,
    input   logic           rst,

    // In Meta data
    input   logic           in_meta_valid,
    input   metadata_t      in_meta_data,
    output  logic           in_meta_ready,

    // In User data
    input   logic           in_usr_sop,
    input   logic           in_usr_eop,
    input   logic [255:0]   in_usr_data,
    input   logic [4:0]     in_usr_empty,
    input   logic           in_usr_valid,
    output  logic           in_usr_ready,

    // Out User data
    output  logic [255:0]   out_usr_data,
    output  logic           out_usr_valid,
    output  logic           out_usr_sop,
    output  logic           out_usr_eop,
    output  logic [4:0]     out_usr_empty,
    input   logic           out_usr_ready,

    //stats
    output  logic [31:0]    no_pg_rule_cnt,
    output  logic [31:0]    pg_rule_cnt
);

`ifdef DUMMY_PG
    assign out_pkt_data  = in_pkt_data;
    assign out_pkt_valid = in_pkt_valid;
    assign out_pkt_sop   = in_pkt_sop;
    assign out_pkt_eop   = in_pkt_eop;
    assign out_pkt_empty = in_pkt_empty;
    assign in_pkt_ready  = out_pkt_ready;
    assign in_pkt_almost_full = out_pkt_almost_full;

    assign out_meta_valid  = in_meta_valid;
    assign out_meta_data   = in_meta_data;
    assign in_meta_ready   = out_meta_ready;

    assign out_usr_sop   = in_usr_sop;
    assign out_usr_eop   = in_usr_eop;
    assign out_usr_valid = in_usr_valid;
    assign out_usr_data  = in_usr_data;
    assign out_usr_empty = in_usr_empty;
    assign in_usr_ready  = out_usr_ready;
`else

// This should be 1 bigger than the NUM_PIPE in rule_unit
localparam NUM_PIPES = 16;

typedef enum {
    IDLE,
    RULE
} state_t;
state_t state;

logic                   tcp;
logic [15:0]            src_port;
logic [15:0]            dst_port;
logic                   rule_valid;
logic                   reg_rule_valid;
logic                   rule_eop;
logic                   reg_rule_eop;

logic                                  int_sop;
logic                                  int_eop;
logic [255:0] int_data;
logic                                  int_valid;
logic                                  int_ready;
logic                                  int_almost_full;
logic [1:0]                            int_cnt;

logic [RULE_AWIDTH-1:0] in_rule_data_0;
logic [RULE_AWIDTH-1:0] out_rule_data_0;
logic                   rule_pg_match_0;
logic [RULE_AWIDTH-1:0] rule_pg_addr_0;
rule_pg_t               rule_pg_data_0;
logic [RULE_AWIDTH-1:0] in_rule_data_1;
logic [RULE_AWIDTH-1:0] out_rule_data_1;
logic                   rule_pg_match_1;
logic [RULE_AWIDTH-1:0] rule_pg_addr_1;
rule_pg_t               rule_pg_data_1;
logic [RULE_AWIDTH-1:0] in_rule_data_2;
logic [RULE_AWIDTH-1:0] out_rule_data_2;
logic                   rule_pg_match_2;
logic [RULE_AWIDTH-1:0] rule_pg_addr_2;
rule_pg_t               rule_pg_data_2;
logic [RULE_AWIDTH-1:0] in_rule_data_3;
logic [RULE_AWIDTH-1:0] out_rule_data_3;
logic                   rule_pg_match_3;
logic [RULE_AWIDTH-1:0] rule_pg_addr_3;
rule_pg_t               rule_pg_data_3;
logic [RULE_AWIDTH-1:0] in_rule_data_4;
logic [RULE_AWIDTH-1:0] out_rule_data_4;
logic                   rule_pg_match_4;
logic [RULE_AWIDTH-1:0] rule_pg_addr_4;
rule_pg_t               rule_pg_data_4;
logic [RULE_AWIDTH-1:0] in_rule_data_5;
logic [RULE_AWIDTH-1:0] out_rule_data_5;
logic                   rule_pg_match_5;
logic [RULE_AWIDTH-1:0] rule_pg_addr_5;
rule_pg_t               rule_pg_data_5;
logic [RULE_AWIDTH-1:0] in_rule_data_6;
logic [RULE_AWIDTH-1:0] out_rule_data_6;
logic                   rule_pg_match_6;
logic [RULE_AWIDTH-1:0] rule_pg_addr_6;
rule_pg_t               rule_pg_data_6;
logic [RULE_AWIDTH-1:0] in_rule_data_7;
logic [RULE_AWIDTH-1:0] out_rule_data_7;
logic                   rule_pg_match_7;
logic [RULE_AWIDTH-1:0] rule_pg_addr_7;
rule_pg_t               rule_pg_data_7;
logic [RULE_AWIDTH-1:0] in_rule_data_8;
logic [RULE_AWIDTH-1:0] out_rule_data_8;
logic                   rule_pg_match_8;
logic [RULE_AWIDTH-1:0] rule_pg_addr_8;
rule_pg_t               rule_pg_data_8;
logic [RULE_AWIDTH-1:0] in_rule_data_9;
logic [RULE_AWIDTH-1:0] out_rule_data_9;
logic                   rule_pg_match_9;
logic [RULE_AWIDTH-1:0] rule_pg_addr_9;
rule_pg_t               rule_pg_data_9;
logic [RULE_AWIDTH-1:0] in_rule_data_10;
logic [RULE_AWIDTH-1:0] out_rule_data_10;
logic                   rule_pg_match_10;
logic [RULE_AWIDTH-1:0] rule_pg_addr_10;
rule_pg_t               rule_pg_data_10;
logic [RULE_AWIDTH-1:0] in_rule_data_11;
logic [RULE_AWIDTH-1:0] out_rule_data_11;
logic                   rule_pg_match_11;
logic [RULE_AWIDTH-1:0] rule_pg_addr_11;
rule_pg_t               rule_pg_data_11;
logic [RULE_AWIDTH-1:0] in_rule_data_12;
logic [RULE_AWIDTH-1:0] out_rule_data_12;
logic                   rule_pg_match_12;
logic [RULE_AWIDTH-1:0] rule_pg_addr_12;
rule_pg_t               rule_pg_data_12;
logic [RULE_AWIDTH-1:0] in_rule_data_13;
logic [RULE_AWIDTH-1:0] out_rule_data_13;
logic                   rule_pg_match_13;
logic [RULE_AWIDTH-1:0] rule_pg_addr_13;
rule_pg_t               rule_pg_data_13;
logic [RULE_AWIDTH-1:0] in_rule_data_14;
logic [RULE_AWIDTH-1:0] out_rule_data_14;
logic                   rule_pg_match_14;
logic [RULE_AWIDTH-1:0] rule_pg_addr_14;
rule_pg_t               rule_pg_data_14;
logic [RULE_AWIDTH-1:0] in_rule_data_15;
logic [RULE_AWIDTH-1:0] out_rule_data_15;
logic                   rule_pg_match_15;
logic [RULE_AWIDTH-1:0] rule_pg_addr_15;
rule_pg_t               rule_pg_data_15;

logic         rule_packer_sop;
logic         rule_packer_eop;
logic [511:0] rule_packer_data;
logic         rule_packer_valid;
logic         rule_packer_ready;
logic [5:0]   rule_packer_empty;
logic         rule_packer_fifo_sop;
logic         rule_packer_fifo_eop;
logic [511:0] rule_packer_fifo_data;
logic         rule_packer_fifo_valid;
logic         rule_packer_fifo_ready;
logic [5:0]   rule_packer_fifo_empty;


//Forward pkt data
assign in_usr_ready = (state == RULE);

always @(posedge clk) begin
    if (rst) begin
        tcp <= 0;
        state <= IDLE;
        rule_valid <= 0;
        rule_eop  <= 0;
        in_meta_ready <= 0;
    end else begin
        case(state)
            IDLE: begin
                rule_eop <= 0;
                rule_valid <= 0;
                in_meta_ready <= 0;
                if (in_meta_valid & !in_meta_ready & !int_almost_full) begin
                    state <= RULE;
                    src_port <= in_meta_data.tuple.sPort;
                    dst_port <= in_meta_data.tuple.dPort;
                    tcp <= (in_meta_data.prot == PROT_TCP);
                end
            end
            RULE: begin
                if (in_usr_valid) begin
                    in_rule_data_0 <= in_usr_data[16*0+RULE_AWIDTH-1:16*0];
                    in_rule_data_1 <= in_usr_data[16*1+RULE_AWIDTH-1:16*1];
                    in_rule_data_2 <= in_usr_data[16*2+RULE_AWIDTH-1:16*2];
                    in_rule_data_3 <= in_usr_data[16*3+RULE_AWIDTH-1:16*3];
                    in_rule_data_4 <= in_usr_data[16*4+RULE_AWIDTH-1:16*4];
                    in_rule_data_5 <= in_usr_data[16*5+RULE_AWIDTH-1:16*5];
                    in_rule_data_6 <= in_usr_data[16*6+RULE_AWIDTH-1:16*6];
                    in_rule_data_7 <= in_usr_data[16*7+RULE_AWIDTH-1:16*7];
                    in_rule_data_8 <= in_usr_data[16*8+RULE_AWIDTH-1:16*8];
                    in_rule_data_9 <= in_usr_data[16*9+RULE_AWIDTH-1:16*9];
                    in_rule_data_10 <= in_usr_data[16*10+RULE_AWIDTH-1:16*10];
                    in_rule_data_11 <= in_usr_data[16*11+RULE_AWIDTH-1:16*11];
                    in_rule_data_12 <= in_usr_data[16*12+RULE_AWIDTH-1:16*12];
                    in_rule_data_13 <= in_usr_data[16*13+RULE_AWIDTH-1:16*13];
                    in_rule_data_14 <= in_usr_data[16*14+RULE_AWIDTH-1:16*14];
                    in_rule_data_15 <= in_usr_data[16*15+RULE_AWIDTH-1:16*15];
                    rule_valid <= 1;
                    if (in_usr_eop) begin
                        state <= IDLE;
                        rule_eop <= 1;
                        in_meta_ready <= 1;
                    end
                end else begin
                    rule_valid <= 0;
                end
            end
        endcase
    end
end

//Need to re-calculate the sop, as some of rules will be discarded. 
assign int_sop = (int_cnt == 0) ? int_valid : 1'b0;
always @(posedge clk) begin
    if (rst) begin
        int_eop <= 0;
        int_valid <= 0;
        int_cnt <= 0;
    end else begin
        int_valid <= 0;
        int_eop <= 0;
        if (reg_rule_valid) begin
            int_eop <= reg_rule_eop;
            int_valid <=  rule_pg_match_0 |  rule_pg_match_1 |  rule_pg_match_2 |  rule_pg_match_3 |  rule_pg_match_4 |  rule_pg_match_5 |  rule_pg_match_6 |  rule_pg_match_7 |  rule_pg_match_8 |  rule_pg_match_9 |  rule_pg_match_10 |  rule_pg_match_11 |  rule_pg_match_12 |  rule_pg_match_13 |  rule_pg_match_14 |  rule_pg_match_15 |  reg_rule_eop;
        end

        if(int_valid)begin
            if(int_eop)begin
                int_cnt <= 0;
            end else begin
                int_cnt <= int_cnt + 1;
            end
        end
    end
    int_data[16*0+15:16*0] <= {3'b0,out_rule_data_0};
    int_data[16*1+15:16*1] <= {3'b0,out_rule_data_1};
    int_data[16*2+15:16*2] <= {3'b0,out_rule_data_2};
    int_data[16*3+15:16*3] <= {3'b0,out_rule_data_3};
    int_data[16*4+15:16*4] <= {3'b0,out_rule_data_4};
    int_data[16*5+15:16*5] <= {3'b0,out_rule_data_5};
    int_data[16*6+15:16*6] <= {3'b0,out_rule_data_6};
    int_data[16*7+15:16*7] <= {3'b0,out_rule_data_7};
    int_data[16*8+15:16*8] <= {3'b0,out_rule_data_8};
    int_data[16*9+15:16*9] <= {3'b0,out_rule_data_9};
    int_data[16*10+15:16*10] <= {3'b0,out_rule_data_10};
    int_data[16*11+15:16*11] <= {3'b0,out_rule_data_11};
    int_data[16*12+15:16*12] <= {3'b0,out_rule_data_12};
    int_data[16*13+15:16*13] <= {3'b0,out_rule_data_13};
    int_data[16*14+15:16*14] <= {3'b0,out_rule_data_14};
    int_data[16*15+15:16*15] <= {3'b0,out_rule_data_15};

end


//Stats
always @(posedge clk) begin
    if (rst) begin
        no_pg_rule_cnt <= 0;
        pg_rule_cnt <= 0;
    end else begin
        if (reg_rule_valid & !reg_rule_eop) begin
            no_pg_rule_cnt <= no_pg_rule_cnt + 1;
        end
        if (int_valid & !int_eop) begin
            pg_rule_cnt <= pg_rule_cnt + 1;
        end
    end
end

hyper_pipe_rst #(
    .WIDTH (1),
    .NUM_PIPES(NUM_PIPES)
) hp_rule_valid (
    .clk(clk),
    .rst(rst),
    .din(rule_valid),
    .dout(reg_rule_valid)
);

hyper_pipe_rst #(
    .WIDTH (1),
    .NUM_PIPES(NUM_PIPES)
) hp_rule_eop (
    .clk(clk),
    .rst(rst),
    .din(rule_eop),
    .dout(reg_rule_eop)
);

rule_unit rule_unit_0 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_0),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_0),
    .rule_pg_match  (rule_pg_match_0),
    .rule_pg_addr   (rule_pg_addr_0),
    .rule_pg_data   (rule_pg_data_0)
);
rule_unit rule_unit_1 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_1),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_1),
    .rule_pg_match  (rule_pg_match_1),
    .rule_pg_addr   (rule_pg_addr_1),
    .rule_pg_data   (rule_pg_data_1)
);
rule_unit rule_unit_2 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_2),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_2),
    .rule_pg_match  (rule_pg_match_2),
    .rule_pg_addr   (rule_pg_addr_2),
    .rule_pg_data   (rule_pg_data_2)
);
rule_unit rule_unit_3 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_3),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_3),
    .rule_pg_match  (rule_pg_match_3),
    .rule_pg_addr   (rule_pg_addr_3),
    .rule_pg_data   (rule_pg_data_3)
);
rule_unit rule_unit_4 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_4),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_4),
    .rule_pg_match  (rule_pg_match_4),
    .rule_pg_addr   (rule_pg_addr_4),
    .rule_pg_data   (rule_pg_data_4)
);
rule_unit rule_unit_5 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_5),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_5),
    .rule_pg_match  (rule_pg_match_5),
    .rule_pg_addr   (rule_pg_addr_5),
    .rule_pg_data   (rule_pg_data_5)
);
rule_unit rule_unit_6 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_6),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_6),
    .rule_pg_match  (rule_pg_match_6),
    .rule_pg_addr   (rule_pg_addr_6),
    .rule_pg_data   (rule_pg_data_6)
);
rule_unit rule_unit_7 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_7),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_7),
    .rule_pg_match  (rule_pg_match_7),
    .rule_pg_addr   (rule_pg_addr_7),
    .rule_pg_data   (rule_pg_data_7)
);
rule_unit rule_unit_8 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_8),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_8),
    .rule_pg_match  (rule_pg_match_8),
    .rule_pg_addr   (rule_pg_addr_8),
    .rule_pg_data   (rule_pg_data_8)
);
rule_unit rule_unit_9 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_9),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_9),
    .rule_pg_match  (rule_pg_match_9),
    .rule_pg_addr   (rule_pg_addr_9),
    .rule_pg_data   (rule_pg_data_9)
);
rule_unit rule_unit_10 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_10),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_10),
    .rule_pg_match  (rule_pg_match_10),
    .rule_pg_addr   (rule_pg_addr_10),
    .rule_pg_data   (rule_pg_data_10)
);
rule_unit rule_unit_11 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_11),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_11),
    .rule_pg_match  (rule_pg_match_11),
    .rule_pg_addr   (rule_pg_addr_11),
    .rule_pg_data   (rule_pg_data_11)
);
rule_unit rule_unit_12 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_12),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_12),
    .rule_pg_match  (rule_pg_match_12),
    .rule_pg_addr   (rule_pg_addr_12),
    .rule_pg_data   (rule_pg_data_12)
);
rule_unit rule_unit_13 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_13),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_13),
    .rule_pg_match  (rule_pg_match_13),
    .rule_pg_addr   (rule_pg_addr_13),
    .rule_pg_data   (rule_pg_data_13)
);
rule_unit rule_unit_14 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_14),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_14),
    .rule_pg_match  (rule_pg_match_14),
    .rule_pg_addr   (rule_pg_addr_14),
    .rule_pg_data   (rule_pg_data_14)
);
rule_unit rule_unit_15 (
    .clk            (clk),
    .rst            (rst),
    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_15),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_15),
    .rule_pg_match  (rule_pg_match_15),
    .rule_pg_addr   (rule_pg_addr_15),
    .rule_pg_data   (rule_pg_data_15)
);

rom_2port #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .MEM_SIZE(RULE_DEPTH),
    .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_0_1 (
    .q_a       (rule_pg_data_0),
    .q_b       (rule_pg_data_1),
    .address_a (rule_pg_addr_0),
    .address_b (rule_pg_addr_1),
    .clock     (clk)
);
rom_2port #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .MEM_SIZE(RULE_DEPTH),
    .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_2_3 (
    .q_a       (rule_pg_data_2),
    .q_b       (rule_pg_data_3),
    .address_a (rule_pg_addr_2),
    .address_b (rule_pg_addr_3),
    .clock     (clk)
);
rom_2port #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .MEM_SIZE(RULE_DEPTH),
    .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_4_5 (
    .q_a       (rule_pg_data_4),
    .q_b       (rule_pg_data_5),
    .address_a (rule_pg_addr_4),
    .address_b (rule_pg_addr_5),
    .clock     (clk)
);
rom_2port #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .MEM_SIZE(RULE_DEPTH),
    .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_6_7 (
    .q_a       (rule_pg_data_6),
    .q_b       (rule_pg_data_7),
    .address_a (rule_pg_addr_6),
    .address_b (rule_pg_addr_7),
    .clock     (clk)
);
rom_2port #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .MEM_SIZE(RULE_DEPTH),
    .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_8_9 (
    .q_a       (rule_pg_data_8),
    .q_b       (rule_pg_data_9),
    .address_a (rule_pg_addr_8),
    .address_b (rule_pg_addr_9),
    .clock     (clk)
);
rom_2port #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .MEM_SIZE(RULE_DEPTH),
    .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_10_11 (
    .q_a       (rule_pg_data_10),
    .q_b       (rule_pg_data_11),
    .address_a (rule_pg_addr_10),
    .address_b (rule_pg_addr_11),
    .clock     (clk)
);
rom_2port #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .MEM_SIZE(RULE_DEPTH),
    .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_12_13 (
    .q_a       (rule_pg_data_12),
    .q_b       (rule_pg_data_13),
    .address_a (rule_pg_addr_12),
    .address_b (rule_pg_addr_13),
    .clock     (clk)
);
rom_2port #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .MEM_SIZE(RULE_DEPTH),
    .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_14_15 (
    .q_a       (rule_pg_data_14),
    .q_b       (rule_pg_data_15),
    .address_a (rule_pg_addr_14),
    .address_b (rule_pg_addr_15),
    .clock     (clk)
);

//rule FIFO
unified_pkt_fifo  #(
    .FIFO_NAME        ("[port_group] rule_FIFO"),
    .MEM_TYPE         ("M20K"),
    .DUAL_CLOCK       (0),
    .USE_ALMOST_FULL  (1),
    .FULL_LEVEL       (400),
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
    .in_empty          (5'd0),
    .out_data          (out_usr_data),
    .out_valid         (out_usr_valid),
    .out_ready         (out_usr_ready),
    .out_startofpacket (out_usr_sop),
    .out_endofpacket   (out_usr_eop),
    .out_empty         (out_usr_empty),
    .fill_level        (),
    .almost_full       (int_almost_full),
    .overflow          ()
);

`endif

endmodule
