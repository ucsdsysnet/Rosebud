module accel_wrap #(
  parameter DATA_WIDTH           = 128,
  parameter STRB_WIDTH           = (DATA_WIDTH/8),
  parameter SLOW_DMEM_ADDR_WIDTH = 8,
  parameter ADDR_WIDTH           = SLOW_DMEM_ADDR_WIDTH+2,
  parameter SLOW_M_B_LINES       = 4096,
  parameter ACC_ADDR_WIDTH       = $clog2(SLOW_M_B_LINES),
  parameter SLOW_DMEM_SEL_BITS   = SLOW_DMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                                   -1-$clog2(SLOW_M_B_LINES),
  parameter ACC_MEM_BLOCKS       = 2**SLOW_DMEM_SEL_BITS
) (
  input  wire                                     clk,
  input  wire                                     rst,

  input  wire [ADDR_WIDTH-1:0]                    io_addr,
  input  wire [STRB_WIDTH-1:0]                    io_strb,
  input  wire                                     io_write,
  input  wire                                     io_read,
  output wire [DATA_WIDTH-1:0]                    io_rd_data,
  input  wire [DATA_WIDTH-1:0]                    io_wr_data,

  output wire [ACC_MEM_BLOCKS-1:0]                acc_en_b1,
  output wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b1,
  output wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b1,
  output wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b1,
  input  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b1,

  output wire [ACC_MEM_BLOCKS-1:0]                acc_en_b2,
  output wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b2,
  output wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b2,
  output wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b2,
  input  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b2
);

localparam LEN_WIDTH = 16;

reg [SLOW_DMEM_ADDR_WIDTH-1:0] cmd_addr_reg;
reg [LEN_WIDTH-1:0]            cmd_len_reg;
reg                            cmd_valid_reg;
wire                           cmd_ready;

wire                           status_match;
wire                           status_done;

reg [DATA_WIDTH-1:0] read_data_reg;

assign cmd_addr = cmd_addr_reg;
assign cmd_len = cmd_len_reg;
assign cmd_valid = cmd_valid_reg;

assign io_rd_data = read_data_reg;

always @(posedge clk) begin
  cmd_valid_reg <= cmd_valid_reg && !cmd_ready;

  if (io_write) begin
    case (io_addr[7:0] & 8'hf0)
      8'h00: begin
        if (io_strb[0]) begin
          cmd_valid_reg <= cmd_valid_reg || io_wr_data[0];
        end
        if (io_strb[7:4]) begin
          cmd_len_reg <= io_wr_data[63:32];
        end
        if (io_strb[15:8]) begin
          cmd_addr_reg <= io_wr_data[127:64];
        end
      end
    endcase
  end

  if (io_read) begin
    read_data_reg <= 0;
    case (io_addr[7:0] & 8'hf0)
      8'h00: begin
        read_data_reg[0] <= cmd_valid_reg;
        read_data_reg[1] <= cmd_ready;
        read_data_reg[8] <= status_done;
        read_data_reg[9] <= status_match;
        read_data_reg[63:32] <= cmd_len_reg;
        read_data_reg[127:64] <= cmd_addr_reg;
      end
    endcase
  end

  if (rst) begin
    cmd_valid_reg <= 1'b0;
  end
end

regex_acc #(
  .DATA_WIDTH(DATA_WIDTH),
  .STRB_WIDTH(STRB_WIDTH),
  .SLOW_DMEM_ADDR_WIDTH(SLOW_DMEM_ADDR_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH),
  .SLOW_M_B_LINES(SLOW_M_B_LINES),
  .ACC_ADDR_WIDTH(ACC_ADDR_WIDTH),
  .SLOW_DMEM_SEL_BITS(SLOW_DMEM_SEL_BITS),
  .ACC_MEM_BLOCKS(ACC_MEM_BLOCKS)
) regex_acc_inst (
  .clk(clk),
  .rst(rst),

  .cmd_addr(cmd_addr_reg),
  .cmd_len(cmd_len_reg),
  .cmd_valid(cmd_valid_reg),
  .cmd_ready(cmd_ready),

  .status_match(status_match),
  .status_done(status_done),

  .acc_en_b1(acc_en_b1),
  .acc_wen_b1(acc_wen_b1),
  .acc_addr_b1(acc_addr_b1),
  .acc_wr_data_b1(acc_wr_data_b1),
  .acc_rd_data_b1(acc_rd_data_b1),

  .acc_en_b2(acc_en_b2),
  .acc_wen_b2(acc_wen_b2),
  .acc_addr_b2(acc_addr_b2),
  .acc_wr_data_b2(acc_wr_data_b2),
  .acc_rd_data_b2(acc_rd_data_b2)
);

endmodule
