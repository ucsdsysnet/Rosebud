module pigasus_sme_wrapper (
  input  wire            clk,
  input  wire            rst,

  // AXI Stream input
  input  wire [16*8-1:0] s_axis_tdata,
  input  wire [16-1:0]   s_axis_tkeep,
  input  wire            s_axis_tvalid,
  input  wire            s_axis_tlast,
  output wire            s_axis_tready,

  // Preamble state (7B data and 1B len)
  input  wire [8*8-1:0]  preamble_state,
  input  wire            reload,

  // Match output
  input  wire            next_index,
  output reg  [15:0]     match_index,
  output reg             match_valid,

  // Last bytes (7B data and 1B len)
  output wire [8*8-1:0]  last_bytes_state,

  // merged state
  output reg  [7:0]      match_valid_stat
);

  ///////////////////////////////////////////////
  //////////   Selecting input data   ///////////
  ///////////////////////////////////////////////
  wire [127:0]  muxed_data;
  wire [15:0]   muxed_strb;
  wire          muxed_last;
  wire          muxed_valid;
  wire          sme_ready;
  reg           preamble_valid;

  assign muxed_data    = preamble_valid ? {{9{8'hff}},preamble_state[63:8]}
                                        : s_axis_tdata;
  assign muxed_strb    = preamble_valid ? 16'hffff : s_axis_tkeep;
  assign muxed_valid   = preamble_valid ? 1'b1     : s_axis_tvalid;
  assign muxed_last    = preamble_valid ? 1'b0     : s_axis_tlast;
  assign s_axis_tready = preamble_valid ? 1'b0     : sme_ready;

  // One cycle preamble when engine is initialized
  always @ (posedge clk)
    if (rst)
      preamble_valid <= 1'b0;
    else if (reload)
      preamble_valid <= preamble_state[0];
    else if (preamble_valid && sme_ready)
      preamble_valid <= 1'b0;

  ///////////////////////////////////////////////
  ////////// Check for fast patterns ////////////
  ///////////////////////////////////////////////
  wire [127:0] sme_output;
  wire         sme_output_v;

  wire [127:0] sme_output_f;
  wire         sme_output_f_v;
  wire         sme_output_f_ready;

  reg  [127:0] sme_output_r;
  reg  [7:0]   sme_output_r_v;
  
  string_matcher pigasus (
    .clk(clk),
    .rst(rst),

    .in_data({{128{1'b0}}, muxed_data}),
    .in_strb(muxed_strb),
    .in_valid(muxed_valid),
    .in_last(muxed_last),
    .in_ready(sme_ready),

    .out_data(sme_output),
    .out_valid(sme_output_v),

    .init(reload),
    .out_almost_full(1'b0),
    .out_last()
  );

  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(128)
  ) accel_fifo (
    .clk(clk),
    .rst(rst),
    .clear(reload),

    .din_valid(sme_output_v),
    .din(sme_output),
    .din_ready(),

    .dout_valid(sme_output_f_v),
    .dout(sme_output_f),
    .dout_ready(sme_output_f_ready)
  );

  integer m; 
  always @ (posedge clk) begin
    if (sme_output_f_v & sme_output_f_ready) begin
      sme_output_r <= sme_output_f;
      for (m=0;m<8;m=m+1)
        sme_output_r_v <= (sme_output_f[m*16+:16]==0) ? 1'b0 : 1'b1;
    end
    if (rst)
        sme_output_r_v <= 8'd0;
  end

  assign sme_output_f_ready = !(|sme_output_r_v);

  reg [7:0]  selected_match;
  reg [7:0]  selected_match_r;
  reg [15:0] selected_match_index;
  reg [7:0]  match_mask;

  integer k;
  always @ (*) begin
    selected_match       = 8'd1;
    selected_match_index = sme_output_r[0*16+:16];

    for (k=7;k>=0;k=k-1)
      if (sme_output_r_v[k] & match_mask[k]) begin
        selected_match       = 8'd1 << k;
        selected_match_index = sme_output_r[k*16+:16];
      end
  end

  always @ (posedge clk) begin
    selected_match_r <= selected_match;
    match_index      <= selected_match_index;

    match_valid      <= |(sme_output_r_v & match_mask);
    match_valid_stat <= sme_output_r_v & match_mask;

    if (rst) begin
      match_valid      <= 1'b0;
      match_valid_stat <= 8'd0;
    end
  end

  always @ (posedge clk) begin
    if (rst || reload)
      match_mask <= 8'hFF;
    else if (next_index)
      match_mask <= match_mask & ~selected_match_r;
  end

  ///////////////////////////////////////////////
  ////////// Keeping last bytes logic ///////////
  ///////////////////////////////////////////////
  reg [63:0] last_chunk_1;
  reg [63:0] last_chunk_2;
  reg [2:0]  last_chunk_shift;
  reg        last_chunk_valid;
  
  reg [4:0] one_count;
  integer l;
  always @ (*) begin
    one_count = 16;
    for (l=15; l>=0; l=l-1)
      if (!s_axis_tkeep[l])
        one_count = one_count-1;
  end

  always @ (posedge clk) begin
    if (s_axis_tvalid && s_axis_tready) begin
      if (s_axis_tlast) begin
        if (s_axis_tkeep[8]) begin
          last_chunk_1 <= s_axis_tdata[63:0];
          last_chunk_2 <= s_axis_tdata[127:64];
        end else begin
          last_chunk_1 <= s_axis_tdata[63:0];
        end
        last_chunk_shift <= one_count[2:0];
        last_chunk_valid <= 1'b1;
      end else begin
        last_chunk_2 <= s_axis_tdata[127:64];
      end
    end
    if (reload | rst)
      last_chunk_valid <= 1'b0;
  end
  
  wire [127:0] full_chunk = {last_chunk_1, last_chunk_2} >> last_chunk_shift; 

  assign last_bytes_state = {full_chunk[55:0], 7'd0, last_chunk_valid};

endmodule
