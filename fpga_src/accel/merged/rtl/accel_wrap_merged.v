module accel_wrap #(
  parameter IO_DATA_WIDTH   = 32,
  parameter IO_STRB_WIDTH   = (IO_DATA_WIDTH/8),
  parameter IO_ADDR_WIDTH   = 22,
  parameter DATA_WIDTH      = 128,
  parameter STRB_WIDTH      = (DATA_WIDTH/8),
  parameter PMEM_ADDR_WIDTH = 8,
  parameter SLOW_M_B_LINES  = 4096,
  parameter ACC_ADDR_WIDTH  = $clog2(SLOW_M_B_LINES),
  parameter PMEM_SEL_BITS   = PMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                              -1-$clog2(SLOW_M_B_LINES),
  parameter ACC_MEM_BLOCKS  = 2**PMEM_SEL_BITS
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
  input  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b2,

  output wire                                     error,
  input  wire                                     error_ack
);

assign error = 1'b0;

localparam ACCEL_COUNT = ACC_MEM_BLOCKS;

localparam LEN_WIDTH = 16;

reg [PMEM_ADDR_WIDTH-1:0] cmd_addr_reg[ACCEL_COUNT-1:0];
reg [LEN_WIDTH-1:0]       cmd_len_reg[ACCEL_COUNT-1:0];
reg [ACCEL_COUNT-1:0]     cmd_valid_reg;
reg [ACCEL_COUNT-1:0]     cmd_stop_reg;
wire [ACCEL_COUNT-1:0]    cmd_ready;

wire [ACCEL_COUNT-1:0]    status_match;
wire [ACCEL_COUNT-1:0]    status_done;

reg [31:0]  hash_data_reg = 0;
reg [1:0]   hash_data_len_reg = 0;
reg         hash_data_valid_reg = 0;
reg         hash_clear_reg = 0;
reg         hash_rd_stall_reg;

wire [31:0]  hash_out;

reg [IO_DATA_WIDTH-1:0] read_data_reg;
reg read_data_valid_reg;

assign io_rd_data = read_data_reg;
assign io_rd_valid = read_data_valid_reg;

always @(posedge clk) begin
  cmd_valid_reg <= cmd_valid_reg & ~cmd_ready;
  cmd_stop_reg  <= {ACCEL_COUNT{1'b0}};

  hash_data_valid_reg <= 1'b0;
  hash_clear_reg      <= 1'b0;
  hash_rd_stall_reg   <= 1'b0;

  read_data_valid_reg <= 1'b0;

  if (io_en && io_wen) begin
    if (io_addr[8]) begin
      hash_data_reg <= io_wr_data;
      case ({io_addr[7:2], 2'b00})
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
    end else if (!io_addr[7]) begin
      case ({io_addr[3:2], 2'b00})
        4'h0: begin
          if (io_strb[0]) begin
            cmd_valid_reg[io_addr[6:4]] <= cmd_valid_reg[io_addr[6:4]] || io_wr_data[0];
            cmd_stop_reg [io_addr[6:4]] <= cmd_stop_reg [io_addr[6:4]] || io_wr_data[4];
          end
        end
        4'h4: begin
          cmd_len_reg[io_addr[6:4]] <= io_wr_data;
        end
        4'h8: begin
          cmd_addr_reg[io_addr[6:4]] <= io_wr_data;
        end
      endcase
    end
  end

  if (io_en && !io_wen) begin
    read_data_reg <= 0;
    read_data_valid_reg <= 1'b1;
    if (io_addr[8]) begin
      read_data_reg <= hash_out;
      read_data_valid_reg <= ~ hash_data_valid_reg; // one cycle stall after last wr
      hash_rd_stall_reg <= hash_data_valid_reg;
    end else if (io_addr[7]) begin
      read_data_reg <= status_done|status_match;
    end else if (!io_addr[7]) begin
      case ({io_addr[3:2], 2'b00})
        4'h0: begin
          read_data_reg[0] <= cmd_valid_reg[io_addr[6:4]];
          read_data_reg[1] <= cmd_ready[io_addr[6:4]];
          read_data_reg[8] <= status_done[io_addr[6:4]];
          read_data_reg[9] <= status_match[io_addr[6:4]];
        end
        4'h4: begin
          read_data_reg <= cmd_len_reg[io_addr[6:4]];
        end
        4'h8: begin
          read_data_reg <= cmd_addr_reg[io_addr[6:4]];
        end
      endcase
    end
  end

  if (hash_rd_stall_reg) begin
      read_data_reg <= hash_out;
      read_data_valid_reg <= 1'b1;
  end

  if (rst) begin
    cmd_valid_reg <= {ACCEL_COUNT{1'b0}};
    cmd_stop_reg  <= {ACCEL_COUNT{1'b0}};

    hash_data_valid_reg <= 1'b0;
    hash_clear_reg      <= 1'b0;
    hash_rd_stall_reg   <= 1'b0;

    read_data_valid_reg <= 1'b0;
  end
end

generate

genvar n;

for (n = 0; n < ACCEL_COUNT; n = n + 1) begin

  regex_acc #(
    .DATA_WIDTH(DATA_WIDTH),
    .STRB_WIDTH(STRB_WIDTH),
    .PMEM_ADDR_WIDTH(PMEM_ADDR_WIDTH),
    .SLOW_M_B_LINES(SLOW_M_B_LINES),
    .ACC_ADDR_WIDTH(ACC_ADDR_WIDTH),
    .PMEM_SEL_BITS(0),
    .ACC_MEM_BLOCKS(1)
  ) regex_acc_inst (
    .clk(clk),
    .rst(rst),

    .cmd_addr(cmd_addr_reg[n]),
    .cmd_len(cmd_len_reg[n]),
    .cmd_valid(cmd_valid_reg[n]),
    .cmd_stop(cmd_stop_reg[n]),
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
