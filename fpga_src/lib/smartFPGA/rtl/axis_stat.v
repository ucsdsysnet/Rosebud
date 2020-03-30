module axis_stat # (
  parameter KEEP_WIDTH        = 8,
  // If KEEP_ENABLE is not 1, byte_count represents word count
  parameter KEEP_ENABLE       = KEEP_WIDTH>1,
  parameter BYTE_COUNT_WIDTH  = 32,
  parameter FRAME_COUNT_WIDTH = 32
) (
  input  wire                         clk,
  input  wire                         rst,
  input  wire                         clear,
  
  input  wire [KEEP_WIDTH-1:0]        monitor_axis_tkeep,
  input  wire                         monitor_axis_tvalid,
  input  wire                         monitor_axis_tready,
  input  wire                         monitor_axis_tlast,
  input  wire                         monitor_drop_pulse,

  output reg  [BYTE_COUNT_WIDTH-1:0]  byte_count,
  output reg  [FRAME_COUNT_WIDTH-1:0] frame_count,
  output reg  [FRAME_COUNT_WIDTH-1:0] drop_count,
  output reg  [FRAME_COUNT_WIDTH-1:0] stall_count
);

integer i, bit_cnt;

always @ (posedge clk) begin

  // valid transfer cycle
  if (monitor_axis_tready && monitor_axis_tvalid) begin
    if (KEEP_ENABLE) begin
      bit_cnt = 0;
      for (i = 0; i <= KEEP_WIDTH; i = i + 1) begin
        //bit_cnt = bit_cnt + monitor_axis_tkeep[i];
        if (monitor_axis_tkeep == ({KEEP_WIDTH{1'b1}}) >> (KEEP_WIDTH-i)) bit_cnt = i;
      end
      byte_count <= byte_count + bit_cnt;
    end else begin
      byte_count <= byte_count + 1;
    end

    if (monitor_axis_tlast)
      frame_count <= frame_count + 1;
  end
  
  if (!monitor_axis_tready && monitor_axis_tvalid)
    stall_count <= stall_count + 1;
  
  if (monitor_drop_pulse)
    drop_count <= drop_count + 1;
 
  
  if (rst || clear) begin
    byte_count  <= {BYTE_COUNT_WIDTH{1'b0}};
    frame_count <= {FRAME_COUNT_WIDTH{1'b0}};
    drop_count  <= {FRAME_COUNT_WIDTH{1'b0}};
    stall_count  <= {FRAME_COUNT_WIDTH{1'b0}};
  end 

end

endmodule
