// Language: Verilog 2001

`timescale 1ns / 1ps

module test_max_finder_tree;

// Parameters
parameter DATA_WIDTH = 8;
parameter PORT_COUNT = 16;
parameter ADDR_WIDTH = $clog2(PORT_COUNT);

// Inputs
reg [PORT_COUNT*DATA_WIDTH-1:0] values;

// Outputs
wire [DATA_WIDTH-1:0] max_val;
wire [ADDR_WIDTH-1:0] max_ptr;

initial begin
    // myhdl integration
    $from_myhdl(values);
    $to_myhdl(max_val, max_ptr);

    // dump file
    $dumpfile("test_max_finder_tree.lxt");
    $dumpvars(0, test_max_finder_tree);
end

max_finder_tree # (
  .PORT_COUNT(PORT_COUNT),
  .DATA_WIDTH(DATA_WIDTH)
) UUT ( 
  .values (values),
  .max_val(max_val),
  .max_ptr(max_ptr)
);

endmodule
