//Unified FIFO, no pkt meta data
//FIFO_NAME, a string describes the name of the FIFO
//MEM_TYPE, could be either "M20K" (BRAM) or MLAB (LUTRAM)
//DUAL_CLOCK, 0 or 1; 0 is single clock, 1 is dual clock
//USE_ALMOST_FULL, 0 or 1; 0 means not using almost_full, use in_ready for
//backpressure. 1 means ONLY use almost_full for backpressure.
//FULL_LEVEL, if the FIFO occupancy reaches this value, almost_full will be raised.
`timescale 1 ps / 1 ps
module unified_fifo #(
    //new parameters
    parameter FIFO_NAME = "FIFO",
    parameter MEM_TYPE = "M20K",
    parameter DUAL_CLOCK = 0,
    parameter USE_ALMOST_FULL = 0,
    parameter FULL_LEVEL = 450,//does not matter is USE_ALMOST_FULL is 0
    //parameters used for generated IP
    parameter SYMBOLS_PER_BEAT    = 64,
    parameter BITS_PER_SYMBOL     = 8,
    parameter FIFO_DEPTH          = 512
) (
    input  logic         in_clk,
    input  logic         in_reset,
    input  logic         out_clk,  //Only used in DC mode
    input  logic         out_reset,
    input  logic [SYMBOLS_PER_BEAT*BITS_PER_SYMBOL-1:0] in_data,
    input  logic         in_valid,
    output logic         in_ready,
    output logic [SYMBOLS_PER_BEAT*BITS_PER_SYMBOL-1:0] out_data,
    output logic         out_valid,
    input  logic         out_ready,
    //new signals, all in in_clk domain
    output logic [31:0]  fill_level, //current occupancy
    output logic         almost_full, //current occupancy reaches FULL_LEVEL
    output logic         overflow    //only used for RTL sim for now
);


generate
    if(USE_ALMOST_FULL==1)begin
        always @(posedge in_clk) begin
            if (in_reset) begin
                almost_full <= 0;
            end
            else begin
                if (fill_level >= FULL_LEVEL) begin
                    almost_full <= 1;
                end
                else begin
                    almost_full <= 0;
                end
            end
        end

        //When almost_full is high, upstream should deassert in_valid after some delay.
        //If the upstream fails to do so, 'overflow' can happen.
        //The upstream thinks the data is passing through,
        //but the data is not accepted as in_ready is low.
        always @(posedge in_clk)begin
            if (in_reset)begin
                overflow <= 1'b0;
            end else begin
                if(in_valid & !in_ready)begin
                    overflow <= 1'b1;
                    //Debug
                    // $error("%s overflows!",FIFO_NAME);
                    // $finish;
                end
            end
        end
    end else begin
        assign almost_full = 1'b0;
        assign overflow = 1'b0;
    end
endgenerate

    simple_fifo # (
      .ADDR_WIDTH($clog2(FIFO_DEPTH)),
      .DATA_WIDTH(SYMBOLS_PER_BEAT*BITS_PER_SYMBOL),
      .INIT_ZERO(1)
    ) fifo_inst (
        .clk        (in_clk),
        .rst        (in_rst),
        .clear      (1'b0),
          
        .din        (in_data),
        .din_valid  (in_valid),
        .din_ready  (in_ready),

        .dout       (out_data),
        .dout_valid (out_valid),
        .dout_ready (out_ready),
          
        .item_count (fill_level[$clog2(FIFO_DEPTH):0]),
        .full(),
        .empty()
    );

    assign fill_level [31:$clog2(FIFO_DEPTH)+1] = 0;

endmodule
