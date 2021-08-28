module test_firewall (
  input  wire             clk,
  input  wire             rst,

  input  [31:0]           ip,
  input                   ip_valid,

  output                  match,
  output                  match_valid
);

  firewall DUT (
    .clk(clk), 
    .rst(rst), 
    .addr(ip), 
    .valid(ip_valid), 
    .match(match), 
    .done(match_valid)
  );
  
  // Generating Waveform
  initial begin
    $dumpfile ("sim_build/test_firewall.fst");
    $dumpvars (0,test_firewall);
    #1;
  end

endmodule
