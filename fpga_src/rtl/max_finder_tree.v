module max_finder_tree # (
  parameter PORT_COUNT = 16,
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = $clog2(PORT_COUNT)
) ( 
  input  wire [PORT_COUNT*DATA_WIDTH-1:0] values,
  output wire [DATA_WIDTH-1:0]            max_val,
  output wire [ADDR_WIDTH-1:0]            max_ptr
);

// intermediate signals
wire [DATA_WIDTH-1:0] int_max [0:PORT_COUNT-2];
wire [ADDR_WIDTH-1:0] int_ptr [0:PORT_COUNT-2];
wire                  cmp_res [0:PORT_COUNT-2];

function [ADDR_WIDTH:0] l_offset (input [ADDR_WIDTH-1:0] stage);
  integer i;
  begin
    l_offset = 0;
    for (i=1;i<=stage;i=i+1)
      l_offset = l_offset + PORT_COUNT/(2**i);
  end
endfunction

function [ADDR_WIDTH:0] r_offset (input [ADDR_WIDTH-1:0] stage);
  integer i;
  begin
    r_offset = 0;
    for (i=1;i<stage;i=i+1)
      r_offset = r_offset + PORT_COUNT/(2**i);
  end
endfunction

genvar stage,j,k;

generate
  for (k=0; k<PORT_COUNT; k=k+2) begin
    greater_than # (.DATA_WIDTH(DATA_WIDTH)) inp_stage (
      .inp_A(values[(k+1)*DATA_WIDTH +: DATA_WIDTH]),
      .inp_B(values [k*DATA_WIDTH +: DATA_WIDTH]),
      .result(cmp_res[k/2]));

    assign int_max [k/2] = cmp_res[k/2] ?  
              values[(k+1)*DATA_WIDTH +: DATA_WIDTH] : values[k*DATA_WIDTH +: DATA_WIDTH];

    assign int_ptr [k/2] = cmp_res[k/2] ?  
                       {{(ADDR_WIDTH-1){1'b0}},1'b1} : {{(ADDR_WIDTH-1){1'b0}},1'b0};
  end

  for (stage=1; stage < ADDR_WIDTH; stage = stage+1) begin
    for (j=0; j<(PORT_COUNT/(2*stage)); j=j+2) begin
      greater_than # (.DATA_WIDTH(DATA_WIDTH)) intermediate_stage (
        .inp_A(int_max[r_offset(stage)+j+1]),
        .inp_B(int_max[r_offset(stage)+j]),
        .result(cmp_res[l_offset(stage)+(j/2)]));

      assign int_max [l_offset(stage)+(j/2)] = cmp_res[l_offset(stage)+(j/2)] ? 
                             int_max[r_offset(stage)+j+1] : int_max[r_offset(stage)+j] ;

      assign int_ptr [l_offset(stage)+(j/2)] = cmp_res[l_offset(stage)+(j/2)] ? 
             {{(ADDR_WIDTH-stage-1){1'b0}},1'b1,int_ptr[r_offset(stage)+j+1][stage-1:0]} :
             {{(ADDR_WIDTH-stage-1){1'b0}},1'b0,int_ptr[r_offset(stage)+j][stage-1:0]} ;
    end
  end

endgenerate

assign max_val = int_max [PORT_COUNT-2];
assign max_ptr = int_ptr [PORT_COUNT-2]; 

endmodule

module greater_than #(
  parameter DATA_WIDTH=8
)(
  input [DATA_WIDTH-1:0] inp_A,
  input [DATA_WIDTH-1:0] inp_B,

  output result
);
  
  assign result = (inp_A>inp_B);

endmodule
