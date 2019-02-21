module core_msg_arbiter # (
  parameter CORE_COUNT=8,
  parameter CORE_FIFO_ADDR_SIZE=2,
  parameter SHARED_FIFO_ADDR_SIZE=4,

  parameter CORE_NO_WIDTH=$clog2(CORE_COUNT)
)(
    input clk,
    input rst,

    input [CORE_COUNT*64-1:0] core_msg_data,
    input [CORE_COUNT-1:0] core_msg_valid,

    output [63:0]              msg_data,
    output                     msg_valid,
    output [CORE_NO_WIDTH-1:0] msg_core_no,
    input                      msg_ready
);

wire [CORE_COUNT*64-1:0] msg_fifo_data;
wire [CORE_COUNT-1:0]    msg_fifo_valid;

wire [CORE_COUNT-1:0] msg_fifo_ready;
reg  [CORE_COUNT-1:0] msg_fifo_pop;

genvar j;
generate 
    for (j=0; j<CORE_COUNT; j=j+1)
        simple_fifo # (
          .ADDR_WIDTH(CORE_FIFO_ADDR_SIZE),
          .DATA_WIDTH(64)
        ) msg_fifo (
          .clk(clk),
          .rst(rst),
        
          .din_valid(core_msg_valid[j]),
          .din(core_msg_data[j*64 +: 64]),
          .din_ready(msg_fifo_ready[j]),
         
          .dout_valid(msg_fifo_valid[j]),
          .dout(msg_fifo_data[j*64 +: 64]),
          .dout_ready(msg_fifo_pop[j])
        );
endgenerate 

wire msg_transmitted = msg_valid && msg_ready;
reg msg_transmitted_r, msg_transmitted_rr;
always@ (posedge clk)
    if (rst) begin
        msg_transmitted_r  <= 1'b0;
        msg_transmitted_rr <= 1'b0;
    end else begin
        msg_transmitted_r  <= msg_transmitted;
        msg_transmitted_rr <= msg_transmitted_r;
    end

// Core select
reg  [CORE_NO_WIDTH-1:0] turn;

// We are interested in edge of ready to change the turn. That's when a packet is accepted. 
always @ (posedge clk)
  if (rst)
    turn <= {CORE_NO_WIDTH{1'b0}};
  else if (msg_transmitted && !msg_transmitted_r)
    turn <= turn + {{(CORE_NO_WIDTH-1){1'b0}},1'b1};

// barrel shifter
// After the output is valid we do not want to update the highest priority
reg [CORE_COUNT-1:0] rotated_valid_bits;
wire found_one = |(rotated_valid_bits);

always@(posedge clk)
  if (rst)
    rotated_valid_bits <= {CORE_COUNT{1'b0}};
  else if ((!found_one) || (msg_transmitted_r && !msg_transmitted_rr))
    rotated_valid_bits <= ({msg_fifo_valid,msg_fifo_valid} >> turn);

integer i;
reg [CORE_NO_WIDTH-1:0] core_sel_penc;
always@(*) begin
  core_sel_penc = {CORE_COUNT{1'b0}};
  for (i=CORE_COUNT-1;i>=0;i=i-1)
    if (rotated_valid_bits[i])
      core_sel_penc = i;
end

reg [CORE_NO_WIDTH-1:0] core_sel;
always @ (posedge clk)
    core_sel <= core_sel_penc + turn;

reg [63:0] msg_data_reg;
always @ (posedge clk)
    msg_data_reg <= msg_fifo_data[core_sel*64 +: 64];
    
reg found_one_r;
always @ (posedge clk)
  if (rst) 
    found_one_r <= 1'b0;
  else
    found_one_r <= found_one;
// When msg is transmitted next cycle count has new value, another cycle
// rotated_valid_bits has new value, another cycle core_sel has new value and 
// finally msg_data_reg is valid, so there is 3 cycles of non-valid output
reg arbiter_valid;
always @ (posedge clk)
  if (rst)
    arbiter_valid <= 1'b0;
  else if (msg_transmitted || msg_transmitted_r || msg_transmitted_rr)
    arbiter_valid <= 1'b0;
  else 
    arbiter_valid <= found_one_r;

// core_sel stays fixed from one cycle before valid, so no need to latch it
assign msg_valid     = arbiter_valid;
assign msg_data      = msg_data_reg;
assign msg_core_no   = core_sel;

integer k;
always @ (*) begin
    for (k=0; k<CORE_COUNT; k=k+1)
        msg_fifo_pop[k] = 1'b0;
    if (msg_ready & arbiter_valid)
        msg_fifo_pop [core_sel] = 1'b1;
end

endmodule
