module test_pigasus # (
  parameter BYTE_COUNT = 8
) (
  input  wire                    clk,
  input  wire                    rst,
  input  wire                    init,

  // AXI Stream input
  input  wire [BYTE_COUNT*8-1:0] s_axis_tdata,
  input  wire [BYTE_COUNT-1:0]   s_axis_tkeep,
  input  wire                    s_axis_tvalid,
  input  wire                    s_axis_tlast,
  output wire                    s_axis_tready,

  output wire [15:0]             sme_output [8],
  output wire                    sme_output_v
);

wire [127:0] pigasus_output;
  
reg [$clog2(BYTE_COUNT)-1:0] s_axis_tempty;
integer l;
always @ (*) begin
  s_axis_tempty = 0;
  for (l=BYTE_COUNT-1; l>=0; l=l-1)
    if (!s_axis_tkeep[l])
      s_axis_tempty = s_axis_tempty+1;
end

localparam EMPTY_PAD = 5-$clog2(BYTE_COUNT);

string_matcher pigasus (
  .clk(clk),
  .rst(rst),

  .in_data({s_axis_tdata, {((32-BYTE_COUNT)*8){1'b0}}}),
  .in_empty({{EMPTY_PAD{1'b1}}, s_axis_tempty}),
  .in_valid(s_axis_tvalid),
  .in_last(s_axis_tlast),
  .in_ready(s_axis_tready),

  .out_data(pigasus_output),
  .out_valid(sme_output_v),

  .init(init),
  .out_almost_full(1'b0),
  .out_last()
);

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

