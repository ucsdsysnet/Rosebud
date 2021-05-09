module test_pigasus # (
  parameter BYTE_COUNT = 32
) (
  input  wire                    front_clk,
  input  wire                    front_rst,
  input  wire                    back_clk,
  input  wire                    back_rst,

  // AXI Stream input
  input  wire [BYTE_COUNT*8-1:0] s_axis_tdata,
  input  wire [BYTE_COUNT-1:0]   s_axis_tkeep,
  input  wire                    s_axis_tvalid,
  input  wire                    s_axis_tlast,
  output wire                    s_axis_tready,

  output wire [15:0]             sme_output [8],
  output wire                    sme_output_v
);

reg [$clog2(BYTE_COUNT)-1:0] s_axis_tempty;
integer l;
always @ (*) begin
  s_axis_tempty = 0;
  for (l=BYTE_COUNT-1; l>=0; l=l-1)
    if (!s_axis_tkeep[l])
      s_axis_tempty = s_axis_tempty+1;
end

localparam EMPTY_PAD = 5-$clog2(BYTE_COUNT);
wire [4:0] empty = {{EMPTY_PAD{1'b1}}, s_axis_tempty};

reg valid_r;
always @ (posedge front_clk)
  if(front_rst)
    valid_r <= 1'b0;
  else
    valid_r <= s_axis_tvalid;

wire sop = s_axis_tvalid & !valid_r;

wire          shifted_sop;
wire          shifted_eop;
wire          shifted_valid;
wire [255:0]  shifted_data;
wire [4:0]    shifted_empty;
wire          shifted_ready;
reg  [55:0]   last_7_bytes;

reg [BYTE_COUNT*8-1:0] s_axis_tdata_rev;
integer k;
always @ (*)
  for (k=1;k<=BYTE_COUNT;k=k+1)
    s_axis_tdata_rev[(k-1)*8+:8] = s_axis_tdata[(BYTE_COUNT-k)*8+:8];

data_shift shifter (
    .clk(front_clk),
    .rst(front_rst),
    .in_pkt_sop(sop),
    .in_pkt_eop(s_axis_tlast),
    .in_pkt_valid(s_axis_tvalid),
    .in_pkt_data({s_axis_tdata_rev, {((32-BYTE_COUNT)*8){1'b0}}}),
    .in_pkt_empty(empty),
    .in_pkt_ready(s_axis_tready),

    .last_7_bytes({56{1'b1}}), //last_7_bytes),
    .last_7_bytes_valid(1'b1),
    .last_7_bytes_ready(),

    .out_pkt_sop  (shifted_sop),
    .out_pkt_eop  (shifted_eop),
    .out_pkt_valid(shifted_valid),
    .out_pkt_data (shifted_data),
    .out_pkt_empty(shifted_empty),
    .out_pkt_ready(shifted_ready)
);

wire [127:0] pigasus_data;
wire         pigasus_valid;
wire         pigasus_last;

string_matcher pigasus (
  .front_clk(front_clk),
  .front_rst(front_rst),
  .back_clk(back_clk),
  .back_rst(back_rst),
    
  .in_data (shifted_data),
  .in_empty(shifted_empty),
  .in_valid(shifted_valid),
  .in_sop  (shifted_sop),
  .in_eop  (shifted_eop),
  .in_ready(shifted_ready),

  .out_data(pigasus_data),
  .out_valid(pigasus_valid),
  .out_last(pigasus_last),

  .out_almost_full(1'b0)
);

wire [127:0] pigasus_output;

  port_group pg_inst (
    .clk(back_clk),
    .rst(back_rst),
    .in_match_sop(),
    .in_match_eop(pigasus_last),
    .in_match_data(pigasus_data),
    .in_match_empty(),
    .in_match_valid(pigasus_valid),
    .in_match_ready(),

    .in_meta_valid(1'b1),
    .in_meta_data(0),
    .in_meta_ready(),

    .out_match_sop(),
    .out_match_eop(),
    .out_match_data(pigasus_output),
    .out_match_empty(),
    .out_match_valid(sme_output_v),
    .out_match_ready(1'b1),

    .out_match_almost_full(1'b0),
    .out_meta_valid(),
    .out_meta_data(),
    .out_meta_ready(1'b1),
    .no_pg_rule_cnt(),
    .pg_rule_cnt()
  );

  ///////////////////////////////////////////////
  ////////// Keeping last bytes logic ///////////
  ///////////////////////////////////////////////
  reg [BYTE_COUNT*8-1:0]       last_word;
  reg [63:0]                   one_to_last_word;
  reg [$clog2(BYTE_COUNT)-1:0] last_word_shift;
  reg                          last_word_valid;

  always @ (posedge back_clk) begin
    last_word_valid <= 1'b0; //1 hot
    if (s_axis_tvalid && s_axis_tready) begin
      if (!s_axis_tlast) begin
        one_to_last_word <= s_axis_tdata[BYTE_COUNT*8-1:BYTE_COUNT*8-64];
      end else begin
        last_word <= s_axis_tdata;
        last_word_shift <= s_axis_tempty;
        last_word_valid <= 1'b1;
      end
    end

    if (sop | back_rst) begin
      one_to_last_word <= {64{1'b1}}; //not correct
      last_word_valid <= 1'b0;
    end
  end

  wire [(BYTE_COUNT+8)*8-1:0] shifted_word = {last_word,one_to_last_word} << last_word_shift;

  always @ (posedge back_clk) begin
    if (last_word_valid)
      last_7_bytes <= shifted_word[(BYTE_COUNT+8)*8-1:(BYTE_COUNT+1)*8];
    if (back_rst)
      last_7_bytes <= {56{1'b1}};
  end

  ///////////////////////////////////////////////
  ////////////// Generating Waveform ////////////
  ///////////////////////////////////////////////

  genvar i;
  generate
    for (i=0; i<8; i=i+1)
      assign sme_output[i] = pigasus_output[i*16 +: 16];
  endgenerate

  integer j;
  initial begin
    $dumpfile ("sim_build/sim_results.fst");
    $dumpvars (0,test_pigasus);
    for (j=0; j<8; j=j+1)
      $dumpvars (0,sme_output[j]);
    #1;
  end

endmodule
