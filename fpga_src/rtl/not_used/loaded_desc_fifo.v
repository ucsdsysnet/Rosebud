module loaded_desc_fifo # (
  parameter SLOT_COUNT = 8,
  parameter DATA_WIDTH = $clog2(SLOT_COUNT+1),
  parameter ADDR_WIDTH = $clog2(SLOT_COUNT)
)(
  input clk,
  input rst,

  input                		din_valid,
  input  [DATA_WIDTH-1:0] din,
  output               		din_ready,
 
  output               		dout_valid,
  output [DATA_WIDTH-1:0] dout,
  input                		dout_ready,

  output [ADDR_WIDTH:0]   item_count,
  output                  full,
  output                  empty
);

reg [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];
reg [ADDR_WIDTH-1:0] rptr, wptr;
reg [ADDR_WIDTH:0]   item_count_r;

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
reg full_r, empty_r;

always @ (posedge clk)
	if (rst) begin
    full_r  <= 1'b1;
    empty_r <= 1'b0;
	end else if (enque | deque) begin
    full_r  <= ((wptr + {{(ADDR_WIDTH-1){1'b0}},1'b1}) == rptr) && enque;
    empty_r <= ((rptr + {{(ADDR_WIDTH-1){1'b0}},1'b1}) == wptr) && deque;
	end

always @ (posedge clk)
	if (rst)
    item_count_r <= {{1'b1},{ADDR_WIDTH{1'b0}}};
  else 
    if (enque && !deque)
      item_count_r <= item_count_r + {{(ADDR_WIDTH){1'b0}},1'b1};
    else if (!enque && deque)
      item_count_r <= item_count_r - {{(ADDR_WIDTH){1'b0}},1'b1};

assign empty = empty_r; 
assign full  = full_r; 

assign din_ready  = ~full_r; // & ~rst;
assign dout_valid = ~empty_r;

assign item_count   = item_count_r;

integer i,j;
initial
  for (i=0; i<SLOT_COUNT; i=i+1)
    mem[i] = i+1;

endmodule
