module accel_wrap #(
  parameter IO_DATA_WIDTH        = 32,
  parameter IO_STRB_WIDTH        = (IO_DATA_WIDTH/8),
  parameter IO_ADDR_WIDTH        = 22,
  parameter DATA_WIDTH           = 128,
  parameter STRB_WIDTH           = (DATA_WIDTH/8),
  parameter SLOW_DMEM_ADDR_WIDTH = 8,
  parameter SLOW_M_B_LINES       = 4096,
  parameter ACC_ADDR_WIDTH       = $clog2(SLOW_M_B_LINES),
  parameter SLOW_DMEM_SEL_BITS   = SLOW_DMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                                   -1-$clog2(SLOW_M_B_LINES),
  parameter ACC_MEM_BLOCKS       = 2**SLOW_DMEM_SEL_BITS
) (
  input  wire                                     clk,
  input  wire                                     rst,

  input  wire                                     io_en,
  input  wire                                     io_wen,
  input  wire [IO_STRB_WIDTH-1:0]                 io_strb,
  input  wire [IO_ADDR_WIDTH-1:0]                 io_addr,
  input  wire [IO_DATA_WIDTH-1:0]                 io_wr_data,
  output wire [IO_DATA_WIDTH-1:0]                 io_rd_data,
  output wire                                     io_rd_valid,

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

assign acc_en_b1 = 0;
assign acc_wen_b1 = 0;
assign acc_addr_b1 = 0;
assign acc_wr_data_b1 = 0;

assign acc_en_b2 = 0;
assign acc_wen_b2 = 0;
assign acc_addr_b2 = 0;
assign acc_wr_data_b2 = 0;

reg [31:0]  hash_data_reg = 0;
reg [1:0]   hash_data_len_reg = 0;
reg         hash_data_valid_reg = 0;
reg         hash_clear_reg = 0;

wire [31:0]  hash_out;

reg [DATA_WIDTH-1:0] read_data_reg;
reg read_data_valid_reg;

assign io_rd_data = read_data_reg;
assign io_rd_valid = read_data_valid_reg;

always @(posedge clk) begin
  hash_data_valid_reg <= 1'b0;
  hash_clear_reg <= 1'b0;

  read_data_valid_reg <= 1'b0;

  if (io_en && io_wen) begin
    hash_data_reg <= io_wr_data;
    case (io_addr[7:0] & ({IO_ADDR_WIDTH{1'b1}} << 2))
      8'h00: begin
        hash_clear_reg <= 1'b1;
      end
      8'h04: begin
        hash_data_len_reg <= 1;
        hash_data_valid_reg <= 1'b1;
      end
      8'h08: begin
        hash_data_len_reg <= 2;
        hash_data_valid_reg <= 1'b1;
      end
      8'h0C: begin
        hash_data_len_reg <= 0;
        hash_data_valid_reg <= 1'b1;
      end
    endcase
  end

  if (io_en && ~io_wen) begin
    read_data_reg <= hash_out;
    read_data_valid_reg <= 1'b1;
  end

  if (rst) begin
    hash_data_valid_reg <= 1'b0;
    hash_clear_reg <= 1'b0;
    read_data_valid_reg <= 1'b0;
  end
end

hash_acc #(
  .HASH_WIDTH(36)
) hash_acc_inst (
  .clk(clk),
  .rst(rst),

  .hash_data(hash_data_reg),
  .hash_data_len(hash_data_len_reg),
  .hash_data_valid(hash_data_valid_reg),
  .hash_clear(hash_clear_reg),
  
  .hash_key(320'h6d5a56da255b0ec24167253d43a38fb0d0ca2bcbae7b30b477cb2da38030f20c6a42b73bbeac01fa),
  
  .hash_out(hash_out)
);

endmodule
