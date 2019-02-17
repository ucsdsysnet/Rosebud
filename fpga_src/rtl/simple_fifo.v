module simple_fifo # (
  parameter ADDR_WIDTH = 5,
  parameter DATA_WIDTH = 32
)(
  input clk,
  input rst,

  input                		din_valid,
  input [DATA_WIDTH-1:0]  din,
  output               		din_ready,
 
  output               		dout_valid,
  output [DATA_WIDTH-1:0] dout,
  input                		dout_ready
);

reg [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];
reg [ADDR_WIDTH-1:0] rptr, wptr;
reg enque_r, deque_r;
wire empty, full;

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
always @ (posedge clk)
	if (rst) begin
		enque_r <= 1'b0;
		deque_r <= 1'b1;
	end else if (enque | deque) begin
		enque_r <= enque;
		deque_r <= deque;
	end

assign empty = (rptr == wptr) & deque_r;
assign full  = (rptr == wptr) & enque_r;

assign din_ready  = ~full & ~rst;
assign dout_valid = ~empty;

endmodule

