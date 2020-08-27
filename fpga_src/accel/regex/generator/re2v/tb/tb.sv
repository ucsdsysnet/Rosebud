module tb;

logic clk = 0;
logic rst_n = 0;

always #1 clk <= ~clk;
initial #5 rst_n <= 1;

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,tb);
end

logic [7:0] c;
logic match;
string v = "Hello, world!! Helo world! Helllo, world!!";

initial begin
    #10;
    for (int i = 0; i < 43; ++i) begin
        @(posedge clk);
        c <= v[i];
    end
    #20;
    $finish;
end


re matcher(clk, rst_n, c, match);

endmodule