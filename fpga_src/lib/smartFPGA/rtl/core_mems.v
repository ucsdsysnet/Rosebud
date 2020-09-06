module mem_1r1w # (
  parameter BYTES_PER_LINE = 4,
  parameter ADDR_WIDTH     = 11,
  parameter LINE_SIZE      = 8*BYTES_PER_LINE
)( 
  input                       clka,
  input                       ena,
  input  [BYTES_PER_LINE-1:0] wea,
  input  [ADDR_WIDTH-1:0]     addra,
  input  [LINE_SIZE-1 :0]     dina,

  input                       clkb,
  input                       enb,
  input  [ADDR_WIDTH-1:0]     addrb,
  output [LINE_SIZE-1 :0]     doutb
);

(* ram_style = "block" *)
reg [LINE_SIZE-1:0] mem [0:(2**ADDR_WIDTH)-1];
reg [LINE_SIZE-1:0] mem_out;
integer i;

always @ (posedge clka)
  if (ena)
    for (i = 0; i < BYTES_PER_LINE; i = i + 1) 
      if (wea[i] == 1'b1) 
        mem[addra][i*8 +: 8]  <= dina[i*8 +: 8];

always @ (posedge clkb)
  if (enb)
    mem_out <= mem[addrb];

assign doutb = mem_out;

endmodule

module mem_2rw_bram # (
  parameter BYTES_PER_LINE = 4,
  parameter ADDR_WIDTH     = 13,
  parameter LINE_SIZE      = 8*BYTES_PER_LINE
)(
  input                       clka,
  input                       ena,
  input                       rena,
  input  [BYTES_PER_LINE-1:0] wena,
  input  [ADDR_WIDTH-1    :0] addra,
  input  [LINE_SIZE-1     :0] dina,
  output [LINE_SIZE-1     :0] douta,

  input                       clkb,
  input                       enb,
  input                       renb,
  input  [BYTES_PER_LINE-1:0] wenb,
  input  [ADDR_WIDTH-1    :0] addrb,
  input  [LINE_SIZE-1     :0] dinb,
  output [LINE_SIZE-1     :0] doutb
);

(* ram_style = "block" *)
reg [LINE_SIZE-1:0] mem [0:(2**ADDR_WIDTH)-1];
reg [LINE_SIZE-1:0] mem_out_a;
reg [LINE_SIZE-1:0] mem_out_b;
integer i;

always @ (posedge clka)
  if (ena) begin
    for (i = 0; i < BYTES_PER_LINE; i = i + 1) 
      if (wena[i]) 
        mem[addra][i*8 +: 8]  <= dina[i*8 +: 8];
    if (rena)
      mem_out_a <= mem[addra];
  end

always @ (posedge clkb)
  if (enb) begin
    for (i = 0; i < BYTES_PER_LINE; i = i + 1) 
      if (wenb[i])
        mem[addrb][i*8 +: 8]  <= dinb[i*8 +: 8];
    if (renb)
      mem_out_b <= mem[addrb];
  end

assign douta = mem_out_a;
assign doutb = mem_out_b;

// Mostly for test benches 
// synthesis translate_off
integer j;
initial begin
    // two nested loops for smaller number of iterations per loop
    // workaround for synthesizer complaints about large loop counts
    for (i = 0; i < 2**(ADDR_WIDTH); i = i + 2**((ADDR_WIDTH-1)/2)) begin
        for (j = i; j < i + 2**((ADDR_WIDTH-1)/2); j = j + 1) begin
            mem[j] = {LINE_SIZE{1'b0}};
        end
    end
end
// synthesis translate_on

endmodule

module mem_1r1w_uram_pipelined # (
  parameter BYTES_PER_LINE = 4,
  parameter ADDR_WIDTH     = 11,
  parameter LINE_SIZE      = 8*BYTES_PER_LINE,
  parameter RAM_PIPELINE   = 2
)( 
  input                       clk,
  input                       rst,

  input                       ena,
  input  [ADDR_WIDTH-1:0]     addra,
  input  [LINE_SIZE-1 :0]     dina,

  input                       enb,
  input  [ADDR_WIDTH-1:0]     addrb,
  output [LINE_SIZE-1 :0]     doutb
);

(* ram_style = "ultra" *)
reg [LINE_SIZE-1:0] mem [(1<<ADDR_WIDTH)-1:0];
reg [LINE_SIZE-1:0] mem_out;

reg [LINE_SIZE-1: 0]   dout_regs [RAM_PIPELINE-1:0];
reg [RAM_PIPELINE-1:0] enb_regs;

integer i;

always @ (posedge clk)
  if (ena)
    mem[addra] <= dina;

always @ (posedge clk)
  if (enb)
    dout_regs[0] <= mem[addrb];

// Pipeline registers
always @(posedge clk) begin
  enb_regs[0] <= enb;
  for (i = 1 ; i < RAM_PIPELINE; i = i + 1) begin
    enb_regs[i] <= enb_regs[i-1];
    if (enb_regs[i-1])
      dout_regs[i] <= dout_regs[i-1];
  end
  if (rst)
    enb_regs <= 0;
end

assign doutb = dout_regs[RAM_PIPELINE-1];

endmodule

module mem_2rw_uram # (
  parameter BYTES_PER_LINE = 4,
  parameter ADDR_WIDTH     = 13,
  parameter LINE_SIZE      = 8*BYTES_PER_LINE
)(
  input                       clk,

  input                       ena,
  input  [BYTES_PER_LINE-1:0] wena,
  input  [ADDR_WIDTH-1    :0] addra,
  input  [LINE_SIZE-1     :0] dina,
  output [LINE_SIZE-1     :0] douta,

  input                       enb,
  input  [BYTES_PER_LINE-1:0] wenb,
  input  [ADDR_WIDTH-1    :0] addrb,
  input  [LINE_SIZE-1     :0] dinb,
  output [LINE_SIZE-1     :0] doutb
);

(* ram_style = "ultra" *)
reg [LINE_SIZE-1:0] mem [(1<<ADDR_WIDTH)-1:0];
reg [LINE_SIZE-1:0] mem_out_a;
reg [LINE_SIZE-1:0] mem_out_b;
integer i;

always @ (posedge clk)
  if (ena)
    for (i = 0; i < BYTES_PER_LINE; i = i + 1) 
      if (wena[i]) 
        mem[addra][i*8 +: 8]  <= dina[i*8 +: 8];

always @ (posedge clk)
  if (ena)
    if (~|wena)
      mem_out_a <= mem[addra];

always @ (posedge clk)
  if (enb) 
    for (i = 0; i < BYTES_PER_LINE; i = i + 1) 
      if (wenb[i])
        mem[addrb][i*8 +: 8]  <= dinb[i*8 +: 8];

always @ (posedge clk)
  if (enb)
    if (~|wenb)
      mem_out_b <= mem[addrb];

assign douta = mem_out_a;
assign doutb = mem_out_b;

// Only for simulation, URAM cannot be loaded during programming 
// synthesis translate_off
integer j;
initial begin
    // two nested loops for smaller number of iterations per loop
    // workaround for synthesizer complaints about large loop counts
    for (i = 0; i < 2**(ADDR_WIDTH); i = i + 2**((ADDR_WIDTH-1)/2)) begin
        for (j = i; j < i + 2**((ADDR_WIDTH-1)/2); j = j + 1) begin
            mem[j] = {LINE_SIZE{1'b0}};
        end
    end
end
// synthesis translate_on

endmodule
