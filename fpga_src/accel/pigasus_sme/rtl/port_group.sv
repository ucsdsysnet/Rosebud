`timescale 1 ps / 1 ps
`include "struct_s.sv"

module port_group (
    input   logic           clk,
    input   logic           rst,

    // In Meta data
    input   logic           in_meta_valid,
    input   logic [15:0]    src_port,
    input   logic [15:0]    dst_port,
    input   logic           is_tcp,
    output  logic           in_meta_ready,

    // In User data
    input   logic           in_usr_sop,
    input   logic           in_usr_eop,
    input   logic [63:0]   in_usr_data,
    input   logic [2:0]     in_usr_empty,
    input   logic           in_usr_valid,
    output  logic           in_usr_ready,
    
    // Memory write port
    input  logic [2*RULE_PG_WIDTH-1:0] wr_data,
    input  logic [RULE_AWIDTH-2:0]     wr_addr,
    input  logic                       wr_en,

    // Out User data
    output  logic [63:0]   out_usr_data,
    output  logic           out_usr_valid,
    output  logic           out_usr_sop,
    output  logic           out_usr_eop,
    output  logic [2:0]     out_usr_empty,
    input   logic           out_usr_ready,

    //stats
    output  logic [31:0]    no_pg_rule_cnt,
    output  logic [31:0]    pg_rule_cnt
);

// This should be 1 bigger than the NUM_PIPE in rule_unit
localparam NUM_PIPES = 17;

typedef enum {
    IDLE,
    RULE
} state_t;
state_t state;

logic                   tcp;
logic [15:0]            src_port_r;
logic [15:0]            dst_port_r;
logic                   rule_valid;
logic                   reg_rule_valid;
logic                   rule_eop;
logic                   reg_rule_eop;

logic                                  int_sop;
logic                                  int_eop;
logic [63:0] int_data;
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

logic [2*RULE_PG_WIDTH-1:0] wr_data_r;
logic [RULE_AWIDTH-2:0]     wr_addr_r;
logic                       wr_en_r;

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
                    src_port_r <= src_port;
                    dst_port_r <= dst_port;
                    tcp <= is_tcp;
                end
            end
            RULE: begin
                if (in_usr_valid) begin
                    in_rule_data_0 <= in_usr_data[16*0+RULE_AWIDTH-1:16*0];
                    in_rule_data_1 <= in_usr_data[16*1+RULE_AWIDTH-1:16*1];
                    in_rule_data_2 <= in_usr_data[16*2+RULE_AWIDTH-1:16*2];
                    in_rule_data_3 <= in_usr_data[16*3+RULE_AWIDTH-1:16*3];
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
            int_valid <=  rule_pg_match_0 |  rule_pg_match_1 |  rule_pg_match_2 |  rule_pg_match_3 |  reg_rule_eop;
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
    
always @(posedge clk) begin
    wr_data_r <= wr_data;
    wr_addr_r <= wr_addr;
    wr_en_r   <= wr_en;

    if (rst) 
      wr_en_r <= 1'b0;
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
    .src_port       (src_port_r),
    .dst_port       (dst_port_r),
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
    .src_port       (src_port_r),
    .dst_port       (dst_port_r),
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
    .src_port       (src_port_r),
    .dst_port       (dst_port_r),
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
    .src_port       (src_port_r),
    .dst_port       (dst_port_r),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data_3),
    .in_rule_valid  (rule_valid),
    .out_rule_data  (out_rule_data_3),
    .rule_pg_match  (rule_pg_match_3),
    .rule_pg_addr   (rule_pg_addr_3),
    .rule_pg_data   (rule_pg_data_3)
);

uram_2rw_reg #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .LWIDTH(2*RULE_PG_WIDTH),
    .MEM_SIZE(RULE_DEPTH)
    // .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_0_1 (
    .clock     (clk),
    .en_a      (1'b1),
    .wr_en_a   (wr_en_r),
    .address_a (wr_en_r ? {wr_addr_r, 1'b0} : rule_pg_addr_0),
    .wr_data_a (wr_data_r),
    .q_a       (rule_pg_data_0),
    .en_b      (1'b1),
    .wr_en_b   (1'b0),
    .address_b (rule_pg_addr_1),
    .wr_data_b ({2*RULE_PG_WIDTH{1'b0}}),
    .q_b       (rule_pg_data_1)
);
uram_2rw_reg #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .LWIDTH(2*RULE_PG_WIDTH),
    .MEM_SIZE(RULE_DEPTH)
    // .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_2_3 (
    .clock     (clk),
    .en_a      (1'b1),
    .wr_en_a   (wr_en_r),
    .address_a (wr_en_r ? {wr_addr_r, 1'b0} : rule_pg_addr_2),
    .wr_data_a (wr_data_r),
    .q_a       (rule_pg_data_2),
    .en_b      (1'b1),
    .wr_en_b   (1'b0),
    .address_b (rule_pg_addr_3),
    .wr_data_b ({2*RULE_PG_WIDTH{1'b0}}),
    .q_b       (rule_pg_data_3)
);

//rule FIFO
unified_pkt_fifo  #(
    .FIFO_NAME        ("[port_group] rule_FIFO"),
    .MEM_TYPE         ("M20K"),
    .DUAL_CLOCK       (0),
    .USE_ALMOST_FULL  (1),
    .FULL_LEVEL       (400),
    .SYMBOLS_PER_BEAT (8),
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
    .in_empty          (3'd0),
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

endmodule