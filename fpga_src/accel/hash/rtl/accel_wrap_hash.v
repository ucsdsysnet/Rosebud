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

assign io_rd_data = read_data_reg;

always @(posedge clk) begin
  hash_data_valid_reg <= 1'b0;
  hash_clear_reg <= 1'b0;

  if (io_write) begin
    case (io_addr[3:2])
      2'b00: hash_data_reg <= io_wr_data[31:0];
      2'b01: hash_data_reg <= io_wr_data[63:32];
      2'b10: hash_data_reg <= io_wr_data[95:64];
      2'b11: hash_data_reg <= io_wr_data[127:96];
    endcase
    case (io_addr[7:0] & 8'hf0)
      8'h00: begin
        if (io_strb[3:0]) begin
          hash_clear_reg <= 1'b1;
        end
        if (io_strb[7:4]) begin
          hash_data_len_reg <= 1;
          hash_data_valid_reg <= 1'b1;
        end
        if (io_strb[11:8]) begin
          hash_data_len_reg <= 2;
          hash_data_valid_reg <= 1'b1;
        end
        if (io_strb[15:12]) begin
          hash_data_len_reg <= 0;
          hash_data_valid_reg <= 1'b1;
        end
      end
    endcase
  end

  if (io_read) begin
    read_data_reg <= hash_out;
  end

  if (rst) begin
    hash_data_valid_reg <= 1'b0;
    hash_clear_reg <= 1'b0;
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
