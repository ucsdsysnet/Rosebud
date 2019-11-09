module max_finder_tree # (
  parameter PORT_COUNT = 16,
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = $clog2(PORT_COUNT)
) ( 
  input  wire [PORT_COUNT*DATA_WIDTH-1:0] values,
  input  wire [PORT_COUNT-1:0]            valids,

  output wire [DATA_WIDTH-1:0]            max_val,
  output wire [ADDR_WIDTH-1:0]            max_ptr,
  output wire                             max_valid
);

localparam CEIL_PORT_CNT = (2**$clog2(PORT_COUNT));
localparam PADDING       = CEIL_PORT_CNT - PORT_COUNT;

reg [PORT_COUNT*DATA_WIDTH-1:0] masked_values;
integer i;

always @ (*)
  for (i=0; i< PORT_COUNT; i=i+1)
    if (!valids[i])
      masked_values [i*DATA_WIDTH +: DATA_WIDTH] = {DATA_WIDTH{1'b0}};
    else
      masked_values [i*DATA_WIDTH +: DATA_WIDTH] = values [i*DATA_WIDTH +: DATA_WIDTH];

max_finder_tree_pow_of_2 # (
  .PORT_COUNT(CEIL_PORT_CNT),
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH)
) max_finder ( 
  .values({{PADDING*DATA_WIDTH{1'b0}},masked_values}),
  .max_val(max_val),
  .max_ptr(max_ptr)
);

assign max_valid = (masked_values != {PORT_COUNT*DATA_WIDTH{1'b0}});

endmodule

module max_finder_tree_pow_of_2 # (
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
    for (j=0; j<(PORT_COUNT/(2**stage)); j=j+2) begin
      // initial
      //   $display("%d %d %d %d", stage, j, r_offset(stage), l_offset(stage));
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
    // cmp_cla #(.DATA_WIDTH(DATA_WIDTH)) cmp_cla_inst (
    //   .input_value_0(inp_B),
    //   .input_value_1(inp_A),
    //   .output_found(),
    //   .output_sel(result)
    // );
    
    assign result = (inp_A>inp_B);

endmodule

module cmp_cla #(parameter DATA_WIDTH=4)
(
    input  wire [DATA_WIDTH-1:0] input_value_0,
    input  wire [DATA_WIDTH-1:0] input_value_1,
    output wire                  output_found,
    output wire                  output_sel
);

  wire [DATA_WIDTH-1:0] out_gf = input_value_1 ^ input_value_0;
  wire [DATA_WIDTH-1:0] out_gc = input_value_1 & ~input_value_0;
  
  wire [DATA_WIDTH-1:0] out_sel;
  
  genvar i;
  generate 
    if (DATA_WIDTH==1) begin
      assign out_sel[0] = out_gc[0];
    end else begin
      assign out_sel[DATA_WIDTH-1] = out_gc[DATA_WIDTH-1];
      for (i=DATA_WIDTH-2;i>=0;i=i-1) begin
        assign out_sel[i] = out_sel[i+1] | &{out_gc[i], ~out_gf[DATA_WIDTH-1:i+1]};
      end
    end  
  endgenerate

  assign output_sel   = out_sel[0];
  assign output_found = |out_gf[DATA_WIDTH-1:0];

endmodule

