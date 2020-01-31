module stat_reader # (
  parameter KEEP_WIDTH        = 8,
  parameter PORT_COUNT        = 4,
  parameter BYTE_COUNT_WIDTH  = 32,
  parameter FRAME_COUNT_WIDTH = 32,

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

wire [PORT_COUNT*BYTE_COUNT_WIDTH-1:0]  byte_count_int;
wire [PORT_COUNT*FRAME_COUNT_WIDTH-1:0] frame_count_int;

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

always @ (posedge clk) begin
  byte_count  <= byte_count_int [port_select*BYTE_COUNT_WIDTH  +: BYTE_COUNT_WIDTH ];
  frame_count <= frame_count_int[port_select*FRAME_COUNT_WIDTH +: FRAME_COUNT_WIDTH];
end

endmodule
