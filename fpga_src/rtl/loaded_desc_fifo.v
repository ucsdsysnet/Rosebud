module loaded_desc_fifo # (
  parameter CORE_COUNT        = 16,
  parameter SLOT_COUNT        = 8,
  parameter START_ADDR        = 8'h20,
  parameter ADDR_STEP         = 8'h08,
  parameter SLOT_ADDR_WIDTH   = 8,
  parameter ADDR_WIDTH        = $clog2(CORE_COUNT*SLOT_COUNT),
  parameter DATA_WIDTH        = $clog2(CORE_COUNT)+SLOT_ADDR_WIDTH,
  parameter ALMOST_FULL_DIST  = 2, 
  parameter ALMOST_EMPTY_DIST = 2
)(
  input clk,
  input rst,

  input                		din_valid,
  input [DATA_WIDTH-1:0]  din,
  output               		din_ready,
 
  output               		dout_valid,
  output [DATA_WIDTH-1:0] dout,
  input                		dout_ready,

  output [ADDR_WIDTH:0]   item_count,
  output                  full,
  output                  empty,
  output                  almost_full,
  output                  almost_empty
);

localparam ALMOST_FULL_THRESH  = 2**ADDR_WIDTH + ALMOST_FULL_DIST;
localparam ALMOST_EMPTY_THRESH = ALMOST_EMPTY_DIST;

reg [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];
reg [ADDR_WIDTH-1:0] rptr, wptr;
reg [ADDR_WIDTH:0]   item_count_r;
reg enque_r, deque_r;

wire enque = din_valid  & din_ready;
wire deque = dout_valid & dout_ready;

always @ (posedge clk)
	if (rst) begin
		wptr <= {ADDR_WIDTH{1'b0}};
		rptr <= {ADDR_WIDTH{1'b0}};
	end else begin
		if (enque) begin
			mem[wptr] <= din;
			wptr      <= wptr + {{(ADDR_WIDTH-1){1'b0}},1'b1};
		end
		if (deque) begin
			rptr      <= rptr + {{(ADDR_WIDTH-1){1'b0}},1'b1};
		end
	end

assign dout = mem[rptr];

// Latching last transaction to know FIFO is full or empty
// Starting with full state after the reset. 
always @ (posedge clk)
	if (rst) begin
		enque_r <= 1'b1;
		deque_r <= 1'b0;
	end else if (enque | deque) begin
		enque_r <= enque;
		deque_r <= deque;
	end

always @ (posedge clk)
	if (rst)
    item_count_r <= {{1'b1},{ADDR_WIDTH{1'b0}}};
  else 
    if (enque && !deque)
      item_count_r <= item_count_r + {{(ADDR_WIDTH){1'b0}},1'b1};
    else if (!enque && deque)
      item_count_r <= item_count_r - {{(ADDR_WIDTH){1'b0}},1'b1};

assign empty = (rptr == wptr) & deque_r;
assign full  = (rptr == wptr) & enque_r;

assign din_ready  = ~full & ~rst;
assign dout_valid = ~empty;

assign almost_full  = item_count_r >= ALMOST_FULL_THRESH;
assign almost_empty = item_count_r <= ALMOST_EMPTY_THRESH;
assign item_count   = item_count_r;

integer i,j;
reg [SLOT_ADDR_WIDTH-1:0] slot_addr;
initial begin
  for (i=0; i<SLOT_COUNT; i=i+1)
    for (j=0; j<CORE_COUNT; j=j+1) begin
      slot_addr = START_ADDR + (i*ADDR_STEP);
      mem[i*CORE_COUNT+j] = {j,slot_addr};
    end
end

endmodule

