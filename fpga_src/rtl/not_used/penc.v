module penc # (
  parameter IN_WIDTH=4,
  parameter OUT_WIDTH=$clog2(IN_WIDTH)
)(
    input  [IN_WIDTH-1:0]  to_select,
    
    output reg  [IN_WIDTH-1:0]  selected_1hot,
    output reg  [OUT_WIDTH-1:0] selected,
    output wire                 valid
);

    integer i;
    
    always@(*) begin
      selected      = {OUT_WIDTH{1'b0}};
      selected_1hot = {IN_WIDTH{1'b0}};
      for (i=IN_WIDTH-1;i>=0;i=i-1)
        if (to_select[i]) begin
          selected = i;
          selected_1hot = 1 << i;
        end
    end
    
    assign valid = |to_select;

endmodule


