module test_pigasus (
  input  wire            clk,
  input  wire            rst,
  input  wire            init,

  // AXI Stream input
  input  wire [512-1:0]  s_axis_tdata,
  input  wire [8-1:0]    s_axis_tkeep,
  input  wire            s_axis_tvalid,
  input  wire            s_axis_tlast,
  output wire            s_axis_tready,

  output wire [15:0]    sme_output [8],
  output wire           sme_output_v
);

wire [127:0] pigasus_output;

string_matcher pigasus (
  .clk(clk),
  .rst(rst),

  .in_data({s_axis_tdata}), // , {192{1'b0}}}),
  .in_strb(s_axis_tkeep),
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

