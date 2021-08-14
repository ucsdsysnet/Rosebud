module port_checker (
  input  wire clk,
  input  wire rst,

  input  wire [15:0] src_port,
  input  wire [15:0] dst_port,
  input  wire        tcp,
  input  wire [12:0] in_rule_data,
  input  wire        start,

  output reg  [12:0] out_rule_data,
  output reg         out_rule_match,
  output reg         out_rule_valid
);

wire [12:0] rule_pg_addr;
wire [35:0] rule_pg_data;
  
wire  [12:0] out_rule_data_n;
wire         out_rule_valid_n;

rule_unit rule_unit_0 (
    .clk            (clk),
    .rst            (rst),

    .src_port       (src_port),
    .dst_port       (dst_port),
    .tcp            (tcp),
    .in_rule_data   (in_rule_data),
    .in_rule_valid  (start),

    .out_rule_data  (out_rule_data_n),
    .rule_pg_match  (out_rule_valid_n),

    .rule_pg_addr   (rule_pg_addr),
    .rule_pg_data   (rule_pg_data)
);

rom_2port #(
    .DWIDTH(RULE_PG_WIDTH),
    .AWIDTH(RULE_AWIDTH),
    .MEM_SIZE(RULE_DEPTH),
    .INIT_FILE("./memory_init/rule_2_pg.mif")
)
rule2pg_table_0_1 (
    .q_a       (rule_pg_data),
    .q_b       (),
    .address_a (rule_pg_addr),
    .address_b (),
    .clk       (clk)
);

// Just used for timing
localparam NUM_PIPES = 16;
hyper_pipe_rst #(
    .WIDTH (1),
    .NUM_PIPES(NUM_PIPES)
) hp_rule_valid (
    .clk(clk),
    .rst(rst),
    .din(start),
    .dout(reg_rule_valid)
);

always @(posedge clk) begin
  if (reg_rule_valid) begin
    out_rule_valid <= 1'b1;
    out_rule_match <= rule_pg_match;
    out_rule_data  <= out_rule_data_n;
  end
  if (start || rst)
    out_rule_valid <= 1'b0;
end

endmodule
