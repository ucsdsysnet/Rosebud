module test;
logic rst_n = 0;
logic clk = 0;
always #10 clk =~ clk;
initial #14 rst_n = 1;
initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,test);
end

logic [31:0] data1 = 'x;
logic data1en = 0;
logic [31:0] sig0;
logic en = 0;

task w16(input int b);
    @(posedge clk);
    data1en <= 1;
    data1 <= b;
endtask

task skip;
    @(posedge clk);
    data1en <= 0;
    data1 <= 'x;
endtask

initial begin
    #13;
    repeat (10) @(posedge clk);
    w16(9);
    w16(2);
    skip;
    w16(13);
    skip;
    repeat (20) @(posedge clk);
    #12;
    en = 1;
    repeat (20) @(posedge clk);
    $finish;
end
`include "gen.sv"

endmodule