module stat_reader # (
  parameter KEEP_WIDTH        = 8,
  parameter PORT_COUNT        = 4,
  parameter BYTE_COUNT_WIDTH  = 32,
  parameter FRAME_COUNT_WIDTH = 32,
  parameter PORT_CLUSTERS     = 2,

  // If KEEP_ENABLE is not 1, byte_count represents word count
  parameter KEEP_ENABLE       = KEEP_WIDTH>1,
  parameter PORT_WIDTH        = $clog2(PORT_COUNT)
) (
  input  wire                             clk,
  input  wire [PORT_COUNT-1:0]            port_rst,
  input  wire [PORT_COUNT-1:0]            port_clear,

  input  wire [PORT_COUNT*KEEP_WIDTH-1:0] monitor_axis_tkeep,
  input  wire [PORT_COUNT-1:0]            monitor_axis_tvalid,
  input  wire [PORT_COUNT-1:0]            monitor_axis_tready,
  input  wire [PORT_COUNT-1:0]            monitor_axis_tlast,

  input  wire [PORT_WIDTH-1:0]            port_select,
  output reg  [BYTE_COUNT_WIDTH-1:0]      byte_count,
  output reg  [FRAME_COUNT_WIDTH-1:0]     frame_count
);

localparam CEIL_PORT_COUNT   = 2**($clog2(PORT_COUNT));
localparam PORTS_PER_CLUSTER = CEIL_PORT_COUNT / PORT_CLUSTERS;
localparam LAST_SEL_BITS     = $clog2(PORTS_PER_CLUSTER);

(* KEEP = "TRUE" *) reg [PORT_WIDTH-1:0]                  port_select_r;
(* KEEP = "TRUE" *) reg [PORT_CLUSTERS*LAST_SEL_BITS-1:0] port_select_rr;

always @ (posedge clk) begin
  port_select_r  <= port_select;
  port_select_rr <= {PORT_CLUSTERS{port_select_r[LAST_SEL_BITS-1:0]}};
end

wire [CEIL_PORT_COUNT*BYTE_COUNT_WIDTH-1:0]  byte_count_int;
wire [CEIL_PORT_COUNT*FRAME_COUNT_WIDTH-1:0] frame_count_int;

if (CEIL_PORT_COUNT != PORT_COUNT) begin
  assign byte_count_int [CEIL_PORT_COUNT*BYTE_COUNT_WIDTH -1:PORT_COUNT*BYTE_COUNT_WIDTH ] 
                     = {(CEIL_PORT_COUNT-PORT_COUNT)*BYTE_COUNT_WIDTH{1'b0}};
  assign frame_count_int[CEIL_PORT_COUNT*FRAME_COUNT_WIDTH-1:PORT_COUNT*FRAME_COUNT_WIDTH] 
                     = {(CEIL_PORT_COUNT-PORT_COUNT)*FRAME_COUNT_WIDTH{1'b0}};
end

genvar i;
generate
  for (i=0; i<PORT_COUNT; i=i+1) begin: axis_stat_counters
    axis_stat # (
      .KEEP_WIDTH(KEEP_WIDTH),
      .KEEP_ENABLE(KEEP_ENABLE),
      .BYTE_COUNT_WIDTH (BYTE_COUNT_WIDTH),
      .FRAME_COUNT_WIDTH(FRAME_COUNT_WIDTH)
    ) axis_stat_inst (
      .clk(clk),
      .rst(port_rst[i]),
      .clear(port_clear[i]),
    
      .monitor_axis_tkeep(monitor_axis_tkeep[i*KEEP_WIDTH+:KEEP_WIDTH]),
      .monitor_axis_tvalid(monitor_axis_tvalid[i]),
      .monitor_axis_tready(monitor_axis_tready[i]),
      .monitor_axis_tlast(monitor_axis_tlast[i]),
    
      .byte_count(byte_count_int[i*BYTE_COUNT_WIDTH +: BYTE_COUNT_WIDTH]),
      .frame_count(frame_count_int[i*FRAME_COUNT_WIDTH +: FRAME_COUNT_WIDTH])
    );
  end
endgenerate

// Two step selection
// (* KEEP = "TRUE" *) reg [PORT_COUNT*BYTE_COUNT_WIDTH-1:0]  byte_count_int_r;
// (* KEEP = "TRUE" *) reg [PORT_COUNT*FRAME_COUNT_WIDTH-1:0] frame_count_int_r;
reg [PORT_CLUSTERS*BYTE_COUNT_WIDTH-1:0]  byte_count_int_r;
reg [PORT_CLUSTERS*FRAME_COUNT_WIDTH-1:0] frame_count_int_r;

// always @ (posedge clk) begin
//   byte_count_int_r  <= byte_count_int;
//   frame_count_int_r <= frame_count_int;
// end

genvar j;
generate
  for (j=0; j<PORT_CLUSTERS; j=j+1) begin : select_lvl1
    // Selecting each cluster bits
    wire [LAST_SEL_BITS-1:0]                      cluster_port_sel  = 
                            port_select_rr[j*LAST_SEL_BITS +: LAST_SEL_BITS];
    wire [PORTS_PER_CLUSTER*BYTE_COUNT_WIDTH-1:0] cluster_byte_counts = 
                        byte_count_int[j*PORTS_PER_CLUSTER*BYTE_COUNT_WIDTH 
                                      +: PORTS_PER_CLUSTER*BYTE_COUNT_WIDTH];
    wire [PORTS_PER_CLUSTER*BYTE_COUNT_WIDTH-1:0] cluster_frame_counts = 
                        frame_count_int[j*PORTS_PER_CLUSTER*FRAME_COUNT_WIDTH 
                                       +: PORTS_PER_CLUSTER*FRAME_COUNT_WIDTH];

    // First level selection among ports in a cluster
    always @ (posedge clk) begin
      byte_count_int_r  [j*BYTE_COUNT_WIDTH  +: BYTE_COUNT_WIDTH]  <= 
          cluster_byte_counts [cluster_port_sel*BYTE_COUNT_WIDTH  +: BYTE_COUNT_WIDTH];
      frame_count_int_r [j*FRAME_COUNT_WIDTH +: FRAME_COUNT_WIDTH] <= 
          cluster_frame_counts[cluster_port_sel*FRAME_COUNT_WIDTH +: FRAME_COUNT_WIDTH];
    end
  end
endgenerate

// 2nd and last level of selection
always @ (posedge clk) begin
  byte_count  <= byte_count_int_r [port_select_r[PORT_WIDTH-1:LAST_SEL_BITS]*
                                    BYTE_COUNT_WIDTH  +: BYTE_COUNT_WIDTH ];
  frame_count <= frame_count_int_r[port_select_r[PORT_WIDTH-1:LAST_SEL_BITS]*
                                    FRAME_COUNT_WIDTH +: FRAME_COUNT_WIDTH];
end

endmodule
