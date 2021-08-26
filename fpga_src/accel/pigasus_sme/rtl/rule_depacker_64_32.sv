`include "struct_s.sv"
module rule_depacker_64_32 (
    input   logic           clk,
    input   logic           rst,
    input   logic           in_rule_sop,
    input   logic           in_rule_eop,
    input   logic [2:0]     in_rule_empty,
    input   logic           in_rule_valid,
    input   logic [63:0]    in_rule_data,
    output  logic           in_rule_ready,

    output  logic           out_rule_sop,
    output  logic           out_rule_eop,
    output  logic           out_rule_valid,
    output  logic [31:0]    out_rule_data,
    output  logic [1:0]     out_rule_empty,
    input   logic           out_rule_ready
);

typedef enum{
    IDLE,
    MIDDLE,
    LAST
} state_t;
state_t state;

logic [63:0]    latch;
logic           int_rule_sop;
logic           int_rule_eop;
logic           int_rule_valid;
logic [31:0]    int_rule_data;
logic [1:0]     int_rule_empty;
logic           int_rule_ready;
logic           int_rule_almost_full;

logic  int_cnt;
assign int_rule_empty = 0;

always @(posedge clk) begin
    if (rst) begin
        int_cnt        <= 1'b0;
        int_rule_valid <= 1'b0;
        int_rule_eop   <= 1'b0;
        int_rule_sop   <= 1'b0;
    end else begin
        in_rule_ready  <= 1'b0;
        int_rule_valid <= 1'b0;
        int_rule_eop   <= 1'b0;
        int_rule_sop   <= 1'b0;
        case(state)
            IDLE:begin
                int_cnt <= 1'b0;
                if(!int_rule_almost_full & in_rule_valid)begin
                    in_rule_ready <= 1'b1;
                    if(in_rule_eop)begin
                        state <= LAST;
                    end else begin
                        latch <= in_rule_data;
                        state <= MIDDLE;
                    end
                end
            end
            MIDDLE:begin
                case(int_cnt)
                    1'b0:begin
                        if(latch[31:0]!=0)begin
                            int_rule_valid <= 1'b1;
                            int_rule_data <= latch[31:0];
                        end
                    end
                    1'b1:begin
                        if(latch[63:32]!=0)begin
                            int_rule_valid <= 1'b1;
                            int_rule_data <= latch[63:32];
                        end
                        state <= IDLE;
                    end
                endcase
                int_cnt <= int_cnt + 1'b1;
            end
            LAST:begin
                int_rule_valid <= 1'b1;
                int_rule_eop   <= 1'b1;
                int_rule_data  <= 0;
                int_rule_sop   <= in_rule_sop;
                state <= IDLE;
            end
        endcase
    end
end

unified_pkt_fifo  #(
    .FIFO_NAME        ("[rule_depacker_32] rule_FIFO"),
    .MEM_TYPE         ("M20K"),
    .DUAL_CLOCK       (0),
    .FULL_LEVEL       (12),
    .SYMBOLS_PER_BEAT (4),
    .BITS_PER_SYMBOL  (8),
    .FIFO_DEPTH       (16)
) rule_fifo (
    .in_clk            (clk),
    .in_reset          (rst),
    .out_clk           (),
    .out_reset         (),
    .in_data           (int_rule_data),
    .in_valid          (int_rule_valid),
    .in_ready          (int_rule_ready),
    .in_startofpacket  (int_rule_sop),
    .in_endofpacket    (int_rule_eop),
    .in_empty          (int_rule_empty),
    .out_data          (out_rule_data),
    .out_valid         (out_rule_valid),
    .out_ready         (out_rule_ready),
    .out_startofpacket (out_rule_sop),
    .out_endofpacket   (out_rule_eop),
    .out_empty         (out_rule_empty),
    .fill_level        (),
    .almost_full       (int_rule_almost_full),
    .overflow          ()
);

endmodule
