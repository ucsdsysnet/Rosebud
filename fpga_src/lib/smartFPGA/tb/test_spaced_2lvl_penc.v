module test_spaced_2lvl_penc # (
  parameter INPUT_WIDTH  = 8192,
  parameter PENC1_SIZE   = 32,
  parameter PENC2_SIZE   = 32,
  parameter BIN_COUNT    = 8,
  parameter LARGE_BLOCK  = BIN_COUNT*PENC1_SIZE*PENC2_SIZE,
  parameter OUTPUT_WIDTH = $clog2(LARGE_BLOCK)
) (
  input  wire clk,
  input  wire rst,

  input  wire [INPUT_WIDTH-1:0]            one_hot,

  output wire [OUTPUT_WIDTH-1:0]           index [BIN_COUNT],
  output wire [BIN_COUNT-1:0]              valid,
  output wire [BIN_COUNT-1:0]              error,
  output wire                              error_merged
);

  wire [BIN_COUNT*OUTPUT_WIDTH-1:0] index_n;

  spaced_2lvl_penc # (
    .INPUT_WIDTH (INPUT_WIDTH ),
    .PENC1_SIZE  (PENC1_SIZE  ),
    .PENC2_SIZE  (PENC2_SIZE  ),
    .BIN_COUNT   (BIN_COUNT   ),
    .LARGE_BLOCK (LARGE_BLOCK ),
    .OUTPUT_WIDTH(OUTPUT_WIDTH)
  ) dut (
    .clk(clk),
    .rst(rst),

    .one_hot(one_hot),

    .index(index_n),
    .valid(valid),
    .error(error)
  );

  assign error_merged = |error;

  genvar i;
  generate
    for (i=0; i<BIN_COUNT; i=i+1)
      assign index[i] = index_n[i*OUTPUT_WIDTH +: OUTPUT_WIDTH];
  endgenerate

  integer j; //,k;
  initial begin
    $dumpfile ("sim_results.fst");
    for (j=0; j<BIN_COUNT; j=j+1)
      $dumpvars (0,index[j]);
    // for (k=0; k<BIN_COUNT*PENC2_SIZE; k=k+1)
    //   $dumpvars (0,dut.lvl1_index[k]);
    #1;
  end

endmodule
