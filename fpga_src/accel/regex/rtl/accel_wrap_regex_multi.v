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

localparam ACCEL_COUNT = ACC_MEM_BLOCKS;

localparam LEN_WIDTH = 16;

reg [SLOW_DMEM_ADDR_WIDTH-1:0] cmd_addr_reg[ACCEL_COUNT-1:0];
reg [LEN_WIDTH-1:0]            cmd_len_reg[ACCEL_COUNT-1:0];
reg [ACCEL_COUNT-1:0]          cmd_valid_reg;
wire [ACCEL_COUNT-1:0]         cmd_ready;

wire [ACCEL_COUNT-1:0]         status_match;
wire [ACCEL_COUNT-1:0]         status_done;

reg [DATA_WIDTH-1:0] read_data_reg;

assign io_rd_data = read_data_reg;

always @(posedge clk) begin
  cmd_valid_reg <= cmd_valid_reg & ~cmd_ready;

  if (io_write) begin
    if (io_addr[7]) begin
      
    end else begin
      if (io_strb[0]) begin
        cmd_valid_reg[io_addr[6:4]] <= cmd_valid_reg[io_addr[6:4]] || io_wr_data[0];
      end
      if (io_strb[7:4]) begin
        cmd_len_reg[io_addr[6:4]] <= io_wr_data[63:32];
      end
      if (io_strb[15:8]) begin
        cmd_addr_reg[io_addr[6:4]] <= io_wr_data[127:64];
      end
    end
  end

  if (io_read) begin
    read_data_reg <= 0;
    if (io_addr[7]) begin
      read_data_reg <= status_done;
    end else begin
      read_data_reg[0] <= cmd_valid_reg[io_addr[6:4]];
      read_data_reg[1] <= cmd_ready[io_addr[6:4]];
      read_data_reg[8] <= status_done[io_addr[6:4]];
      read_data_reg[9] <= status_match[io_addr[6:4]];
      read_data_reg[63:32] <= cmd_len_reg[io_addr[6:4]];
      read_data_reg[127:64] <= cmd_addr_reg[io_addr[6:4]];
    end
  end

  if (rst) begin
    cmd_valid_reg <= 1'b0;
  end
end

generate

genvar n;

for (n = 0; n < ACCEL_COUNT; n = n + 1) begin

  regex_acc #(
    .DATA_WIDTH(DATA_WIDTH),
    .STRB_WIDTH(STRB_WIDTH),
    .SLOW_DMEM_ADDR_WIDTH(SLOW_DMEM_ADDR_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .SLOW_M_B_LINES(SLOW_M_B_LINES),
    .ACC_ADDR_WIDTH(ACC_ADDR_WIDTH),
    .SLOW_DMEM_SEL_BITS(SLOW_DMEM_SEL_BITS),
    .ACC_MEM_BLOCKS(1)
  ) regex_acc_inst (
    .clk(clk),
    .rst(rst),

    .cmd_addr(cmd_addr_reg[n]),
    .cmd_len(cmd_len_reg[n]),
    .cmd_valid(cmd_valid_reg[n]),
    .cmd_ready(cmd_ready[n]),

    .status_match(status_match[n]),
    .status_done(status_done[n]),

    .acc_en_b1(acc_en_b1[n*1 +: 1]),
    .acc_wen_b1(acc_wen_b1[n*STRB_WIDTH +: STRB_WIDTH]),
    .acc_addr_b1(acc_addr_b1[n*ACC_ADDR_WIDTH +: ACC_ADDR_WIDTH]),
    .acc_wr_data_b1(acc_wr_data_b1[n*DATA_WIDTH +: DATA_WIDTH]),
    .acc_rd_data_b1(acc_rd_data_b1[n*DATA_WIDTH +: DATA_WIDTH]),

    .acc_en_b2(acc_en_b2[n*1 +: 1]),
    .acc_wen_b2(acc_wen_b2[n*STRB_WIDTH +: STRB_WIDTH]),
    .acc_addr_b2(acc_addr_b2[n*ACC_ADDR_WIDTH +: ACC_ADDR_WIDTH]),
    .acc_wr_data_b2(acc_wr_data_b2[n*DATA_WIDTH +: DATA_WIDTH]),
    .acc_rd_data_b2(acc_rd_data_b2[n*DATA_WIDTH +: DATA_WIDTH])
  );

end

endgenerate

endmodule
