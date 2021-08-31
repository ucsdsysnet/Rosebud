module mem_sys # (
  parameter DATA_WIDTH      = 64,
  parameter STRB_WIDTH      = (DATA_WIDTH/8),
  parameter IMEM_SIZE       = 65536,
  parameter PMEM_SIZE       = 1048576,
  parameter DMEM_SIZE       = 32768,
  parameter BC_REGION_SIZE  = 4048,
  parameter PMEM_ADDR_WIDTH = $clog2(PMEM_SIZE),
  parameter DMEM_ADDR_WIDTH = $clog2(DMEM_SIZE),
  parameter IMEM_ADDR_WIDTH = $clog2(IMEM_SIZE),
  parameter MSG_WIDTH       = 32+4+$clog2(BC_REGION_SIZE)-2,
  parameter BC_START_ADDR   = 32'h00800000+DMEM_SIZE-BC_REGION_SIZE,
  parameter ACC_ROM_EN      = 0,
  parameter AROM_ADDR_WIDTH = 1,
  parameter AROM_DATA_WIDTH = 1,
  parameter SLOW_M_B_LINES  = 4096,
  parameter FAST_M_B_LINES  = 1024,
  parameter ACC_ADDR_WIDTH  = $clog2(SLOW_M_B_LINES),
  parameter PMEM_SEL_BITS   = PMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                              -1-$clog2(SLOW_M_B_LINES),
  parameter ACC_MEM_BLOCKS  = 2**PMEM_SEL_BITS
) (
  input  wire                                     clk,
  input  wire                                     rst,

  input  wire                                     dma_cmd_wr_en,
  input  wire [25:0]                              dma_cmd_wr_addr,
  input  wire                                     dma_cmd_hdr_wr_en,
  input  wire [23:0]                              dma_cmd_hdr_wr_addr,
  input  wire [DATA_WIDTH-1:0]                    dma_cmd_wr_data,
  input  wire [STRB_WIDTH-1:0]                    dma_cmd_wr_strb,
  input  wire                                     dma_cmd_wr_last,
  output wire                                     dma_cmd_wr_ready,

  input  wire                                     dma_cmd_rd_en,
  input  wire [25:0]                              dma_cmd_rd_addr,
  input  wire                                     dma_cmd_rd_last,
  output wire                                     dma_cmd_rd_ready,

  output wire                                     dma_rd_resp_valid,
  output wire [DATA_WIDTH-1:0]                    dma_rd_resp_data,
  input  wire                                     dma_rd_resp_ready,

  input  wire                                     core_dmem_en,
  input  wire                                     core_pmem_en,
  input  wire                                     core_dmem_wen,
  input  wire [3:0]                               core_dmem_strb,
  input  wire [24:0]                              core_dmem_addr,
  input  wire [31:0]                              core_dmem_wr_data,
  output wire [31:0]                              core_dmem_rd_data,
  output wire                                     core_dmem_rd_valid,

  input  wire                                     core_imem_ren,
  input  wire [24:0]                              core_imem_addr,
  output wire [31:0]                              core_imem_rd_data,
  output wire                                     core_imem_rd_valid,

  input  wire [MSG_WIDTH-1:0]                     bc_msg_in,
  input  wire                                     bc_msg_in_valid,

  output wire [AROM_ADDR_WIDTH-1:0]               acc_rom_wr_addr,
  output wire [AROM_DATA_WIDTH-1:0]               acc_rom_wr_data,
  output wire                                     acc_rom_wr_en,

  input  wire [ACC_MEM_BLOCKS-1:0]                acc_en_b1,
  input  wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b1,
  input  wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b1,
  input  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b1,
  output reg  [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b1,

  input  wire [ACC_MEM_BLOCKS-1:0]                acc_en_b2,
  input  wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b2,
  input  wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b2,
  input  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b2,
  output reg  [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b2,

  output reg  [DMEM_ADDR_WIDTH-1:0]               bc_msg_addr,
  output reg                                      bc_msg_valid,

  output wire [7:0]                               mem_fifo_fulls
);

  localparam LINE_ADDR_BITS = $clog2(STRB_WIDTH);
  localparam MSG_ADDR_WIDTH = $clog2(BC_REGION_SIZE)-2;

  // Converting from DATA_WIDTH to 32 bit for riscvcore
  wire [STRB_WIDTH-1:0] core_dmem_strb_w;
  wire [DATA_WIDTH-1:0] core_dmem_wr_data_w;
  wire [DATA_WIDTH-1:0] core_dmem_rd_data_w;
  wire [DATA_WIDTH-1:0] core_imem_rd_data_w;

  if (STRB_WIDTH==4) begin: mem_width_32
    assign core_dmem_strb_w    = core_dmem_strb;
    assign core_dmem_wr_data_w = core_dmem_wr_data;
    assign core_dmem_rd_data   = core_dmem_rd_data_w;
    assign core_imem_rd_data   = core_imem_rd_data_w;
  end else begin: mem_width_convert
    localparam REMAINED_BYTES = STRB_WIDTH-4;
    localparam REMAINED_BITS  = 8*REMAINED_BYTES;

    wire [DATA_WIDTH-1:0] core_dmem_rd_data_shifted;
    wire [DATA_WIDTH-1:0] core_imem_rd_data_shifted;
    reg  [LINE_ADDR_BITS-3:0] core_dmem_latched_addr;
    reg  [LINE_ADDR_BITS-3:0] core_imem_latched_addr;

    // Core does not change the address before receiving the data
    always @ (posedge clk)
      if (core_dmem_en || core_pmem_en)
        core_dmem_latched_addr <= core_dmem_addr[LINE_ADDR_BITS-1:2];

    always @ (posedge clk)
      if (core_imem_ren)
        core_imem_latched_addr <= core_imem_addr[LINE_ADDR_BITS-1:2];

    assign core_dmem_rd_data_shifted = core_dmem_rd_data_w >> {core_dmem_latched_addr, 5'd0};
    assign core_dmem_rd_data         = core_dmem_rd_data_shifted[31:0];
    assign core_dmem_strb_w          = {{REMAINED_BYTES{1'b0}}, core_dmem_strb}
                                       << {core_dmem_addr[LINE_ADDR_BITS-1:2], 2'd0};
    assign core_dmem_wr_data_w       = {{REMAINED_BITS{1'b0}}, core_dmem_wr_data}
                                       << {core_dmem_addr[LINE_ADDR_BITS-1:2], 5'd0};

    assign core_imem_rd_data_shifted = core_imem_rd_data_w >> {core_imem_latched_addr, 5'd0};
    assign core_imem_rd_data         = core_imem_rd_data_shifted[31:0];
  end

  // Register and width convert incoming core msg
  reg [MSG_ADDR_WIDTH-1:0] bc_msg_in_addr_r;
  reg [31:0]               bc_msg_in_data_r;
  reg [3:0]                bc_msg_in_strb_r;
  reg                      bc_msg_in_valid_r;

  always @ (posedge clk) begin
    bc_msg_in_addr_r    <= bc_msg_in[MSG_WIDTH-1:36];
    bc_msg_in_data_r    <= bc_msg_in[31:0];
    bc_msg_in_strb_r    <= bc_msg_in[35:32];
    if (rst)
      bc_msg_in_valid_r <= 1'b0;
    else
      bc_msg_in_valid_r <= bc_msg_in_valid;
  end

  reg [DMEM_ADDR_WIDTH-1:0] bc_msg_in_addr_rr;
  reg [DATA_WIDTH-1:0]      bc_msg_in_data_rr;
  reg [STRB_WIDTH-1:0]      bc_msg_in_strb_rr;
  reg                       bc_msg_in_valid_rr;

  always @ (posedge clk) begin
    bc_msg_in_addr_rr  <= {{(DMEM_ADDR_WIDTH-MSG_ADDR_WIDTH-2){1'b0}},
                          bc_msg_in_addr_r,2'b00} + BC_START_ADDR;
    bc_msg_in_valid_rr <= bc_msg_in_valid_r;

    bc_msg_addr        <= bc_msg_in_addr_rr;
    bc_msg_valid       <= bc_msg_in_valid_rr;

    if (rst) begin
      bc_msg_in_valid_rr <= 1'b0;
      bc_msg_valid       <= 1'b0;
    end
  end

  if (STRB_WIDTH==4) begin: msg_no_width_conv
    always @ (posedge clk) begin
      bc_msg_in_strb_rr <= bc_msg_in_strb_r;
      bc_msg_in_data_rr <= bc_msg_in_data_r;
    end
  end else begin: msg_width_conv
    always @ (posedge clk) begin
      bc_msg_in_strb_rr <= {{(STRB_WIDTH-4){1'b0}}, bc_msg_in_strb_r[3:0]}
                           << {bc_msg_in_addr_r[LINE_ADDR_BITS-3:0], 2'd0};
      bc_msg_in_data_rr <= {{(DATA_WIDTH-32){1'b0}}, bc_msg_in_data_r}
                           << {bc_msg_in_addr_r[LINE_ADDR_BITS-3:0], 5'd0};
    end
  end

  ///////////////////////////////////////////////////////////////////////////
  ////////////////// Separate dma and core requests based on ////////////////
  /////////////// read/write and speed of memory to be accesssed ////////////
  ///////////////////////////////////////////////////////////////////////////
  wire dmem_wr_addr = ~dma_cmd_wr_addr[25] && ~dma_cmd_wr_addr[24];
  wire dmem_rd_addr = ~dma_cmd_rd_addr[25] && ~dma_cmd_rd_addr[24];
  wire pmem_wr_addr = ~dma_cmd_wr_addr[25] && dma_cmd_wr_addr[24];
  wire pmem_rd_addr = ~dma_cmd_rd_addr[25] && dma_cmd_rd_addr[24];
  wire imem_addr    =  dma_cmd_wr_addr[25] && ~dma_cmd_wr_addr[24];
  wire arom_addr    =  dma_cmd_wr_addr[25] && dma_cmd_wr_addr[24];

  wire dma_dmem_wr_en = (dmem_wr_addr && dma_cmd_wr_en) || dma_cmd_hdr_wr_en;
  wire dma_dmem_rd_en =  dmem_rd_addr && dma_cmd_rd_en;
  wire dma_pmem_wr_en =  pmem_wr_addr && dma_cmd_wr_en;
  wire dma_pmem_rd_en =  pmem_rd_addr && dma_cmd_rd_en;
  wire dma_imem_wr_en =  imem_addr    && dma_cmd_wr_en;
  wire dma_arom_wr_en =  arom_addr    && dma_cmd_wr_en;

  wire dma_imem_wr_fifo_full, dma_arom_wr_fifo_full,
       dma_dmem_wr_fifo_full, dma_dmem_rd_fifo_full,
       dma_pmem_wr_fifo_full, dma_pmem_rd_fifo_full,
       dma_dmem_rd_resp_fifo_full, dma_pmem_rd_resp_fifo_full;

  assign mem_fifo_fulls = {dma_arom_wr_fifo_full,
                           dma_dmem_rd_resp_fifo_full,
                           dma_dmem_rd_fifo_full,
                           dma_dmem_wr_fifo_full,
                           dma_pmem_rd_resp_fifo_full,
                           dma_pmem_rd_fifo_full,
                           dma_pmem_wr_fifo_full,
                           dma_imem_wr_fifo_full};

  // Shallow FIFOs for dma requests to spread them for meeting timing
  wire [IMEM_ADDR_WIDTH-1:0] dma_imem_wr_addr;
  wire [STRB_WIDTH-1:0]      dma_imem_wr_strb;
  wire [DATA_WIDTH-1:0]      dma_imem_wr_data;
  wire                       dma_imem_wr_en_r;

  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(DATA_WIDTH+IMEM_ADDR_WIDTH+STRB_WIDTH)
  ) dma_imem_wr_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),

    .din_valid(dma_imem_wr_en),
    .din({dma_cmd_wr_addr[IMEM_ADDR_WIDTH-1:0], dma_cmd_wr_strb, dma_cmd_wr_data}),
    .din_ready(), //imem always accepts

    .dout_valid(dma_imem_wr_en_r),
    .dout({dma_imem_wr_addr, dma_imem_wr_strb, dma_imem_wr_data}),
    .dout_ready(1'b1),

    .full(dma_imem_wr_fifo_full)
  );

  generate
    if (ACC_ROM_EN) begin: acc_ROM_fifo
      simple_fifo # (
        .ADDR_WIDTH(2),
        .DATA_WIDTH(AROM_DATA_WIDTH+AROM_ADDR_WIDTH)
      ) dma_arom_wr_fifo (
        .clk(clk),
        .rst(rst),
        .clear(1'b0),

        .din_valid(dma_arom_wr_en),
        .din({dma_cmd_wr_addr[AROM_ADDR_WIDTH-1:0],
              dma_cmd_wr_data[AROM_DATA_WIDTH-1:0]}),
        .din_ready(), // Accelerator ROMs always accept

        .dout_valid(acc_rom_wr_en),
        .dout({acc_rom_wr_addr, acc_rom_wr_data}),
        .dout_ready(1'b1),

        .full(dma_arom_wr_fifo_full)
      );
    end else begin
      assign acc_rom_wr_en   = 1'b0;
      assign acc_rom_wr_addr = {AROM_ADDR_WIDTH{1'b0}};
      assign acc_rom_wr_data = {AROM_DATA_WIDTH{1'b0}};
    end
  endgenerate

  wire [DMEM_ADDR_WIDTH-1:0] dma_dmem_cmd_wr_addr;
  wire [DATA_WIDTH-1:0]      dma_dmem_cmd_wr_data;
  wire [STRB_WIDTH-1:0]      dma_dmem_cmd_wr_strb;
  wire                       dma_dmem_cmd_wr_ready;
  reg                        dma_dmem_wr_b1_gnt;
  reg                        dma_dmem_wr_b2_gnt;
  wire                       dma_dmem_wr_en_r;
  wire                       dma_pmem_cmd_wr_ready;

  wire [24:0] dma_dmem_wr_addr = dma_cmd_hdr_wr_en ? dma_cmd_hdr_wr_addr : dma_cmd_wr_addr;

  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(DATA_WIDTH+DMEM_ADDR_WIDTH+STRB_WIDTH)
  ) dma_dmem_wr_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),

    // Normally DMA writes to one of the FIFOes and ready check
    // becomes redundant, but if packet header is written to both
    // pmem and dmem dmems, this would prevent from redundant
    // Entries if one of them is not ready.
    .din_valid(dma_dmem_wr_en && dma_pmem_cmd_wr_ready),
    .din({dma_dmem_wr_addr[DMEM_ADDR_WIDTH-1:0], dma_cmd_wr_strb, dma_cmd_wr_data}),
    .din_ready(dma_dmem_cmd_wr_ready),

    .dout_valid(dma_dmem_wr_en_r),
    .dout({dma_dmem_cmd_wr_addr, dma_dmem_cmd_wr_strb, dma_dmem_cmd_wr_data}),
    .dout_ready(dma_dmem_wr_b1_gnt || dma_dmem_wr_b2_gnt),

    .full(dma_dmem_wr_fifo_full)
  );

  wire [PMEM_ADDR_WIDTH-1:0] dma_pmem_cmd_wr_addr;
  wire [DATA_WIDTH-1:0]      dma_pmem_cmd_wr_data;
  wire [STRB_WIDTH-1:0]      dma_pmem_cmd_wr_strb;
  reg                        dma_pmem_wr_b1_gnt;
  reg                        dma_pmem_wr_b2_gnt;
  wire                       dma_pmem_wr_en_r;

  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(DATA_WIDTH+PMEM_ADDR_WIDTH+STRB_WIDTH)
  ) dma_pmem_wr_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),

    // Normally DMA writes to one of the FIFOes and ready check
    // becomes redundant, but if packet header is written to both
    // pmem and dmem dmems, this would prevent from redundant
    // Entries if one of them is not ready.
    .din_valid(dma_pmem_wr_en && dma_dmem_cmd_wr_ready),
    .din({dma_cmd_wr_addr[PMEM_ADDR_WIDTH-1:0], dma_cmd_wr_strb, dma_cmd_wr_data}),
    .din_ready(dma_pmem_cmd_wr_ready),

    .dout_valid(dma_pmem_wr_en_r),
    .dout({dma_pmem_cmd_wr_addr, dma_pmem_cmd_wr_strb, dma_pmem_cmd_wr_data}),
    .dout_ready(dma_pmem_wr_b1_gnt || dma_pmem_wr_b2_gnt),

    .full(dma_pmem_wr_fifo_full)
  );

  wire [DMEM_ADDR_WIDTH-1:0] dma_dmem_cmd_rd_addr;
  wire [DATA_WIDTH-1:0]      dma_dmem_cmd_rd_data;
  wire                       dma_dmem_cmd_rd_ready;
  reg                        dma_dmem_rd_b1_gnt;
  reg                        dma_dmem_rd_b2_gnt;
  wire                       dma_dmem_rd_en_r;

  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(DMEM_ADDR_WIDTH)
  ) dma_dmem_rd_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),

    .din_valid(dma_dmem_rd_en),
    .din(dma_cmd_rd_addr[DMEM_ADDR_WIDTH-1:0]),
    .din_ready(dma_dmem_cmd_rd_ready),

    .dout_valid(dma_dmem_rd_en_r),
    .dout(dma_dmem_cmd_rd_addr),
    .dout_ready(dma_dmem_rd_b1_gnt || dma_dmem_rd_b2_gnt),

    .full(dma_dmem_rd_fifo_full)
  );

  wire [PMEM_ADDR_WIDTH-1:0] dma_pmem_cmd_rd_addr;
  wire [DATA_WIDTH-1:0]      dma_pmem_cmd_rd_data;
  wire                       dma_pmem_cmd_rd_ready;
  reg                        dma_pmem_rd_b1_gnt;
  reg                        dma_pmem_rd_b2_gnt;
  wire                       dma_pmem_rd_en_r;

  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(PMEM_ADDR_WIDTH)
  ) dma_pmem_rd_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),

    .din_valid(dma_pmem_rd_en),
    .din(dma_cmd_rd_addr[PMEM_ADDR_WIDTH-1:0]),
    .din_ready(dma_pmem_cmd_rd_ready),

    .dout_valid(dma_pmem_rd_en_r),
    .dout(dma_pmem_cmd_rd_addr),
    .dout_ready(dma_pmem_rd_b1_gnt || dma_pmem_rd_b2_gnt),

    .full(dma_pmem_rd_fifo_full)
  );

  //////////////////////////////////////////////////////////////////
  ////// Arbiters for each bank of each memory speed ///////////////
  //////////////////////////////////////////////////////////////////

  reg                        dma_dmem_en_b1;
  reg  [DMEM_ADDR_WIDTH-1:0] dma_dmem_addr_b1;
  reg  [STRB_WIDTH-1:0]      dma_dmem_wen_b1;
  reg  [DATA_WIDTH-1:0]      dma_dmem_wr_data_b1;
  wire [DATA_WIDTH-1:0]      dma_dmem_rd_data_b1;

  reg                        dma_dmem_en_b2;
  reg  [DMEM_ADDR_WIDTH-1:0] dma_dmem_addr_b2;
  reg  [STRB_WIDTH-1:0]      dma_dmem_wen_b2;
  reg  [DATA_WIDTH-1:0]      dma_dmem_wr_data_b2;
  wire [DATA_WIDTH-1:0]      dma_dmem_rd_data_b2;

  // For dmem memory core has separate port, and the other port is shared among dma engine
  // and broadcast messaging. BC messaging has highest priority, followed by dma write to
  // take the load from internal distribution network.
  always @ (*) begin
    dma_dmem_en_b1      = 1'b0;
    dma_dmem_wr_b1_gnt  = 1'b0;
    dma_dmem_rd_b1_gnt  = 1'b0;
    dma_dmem_addr_b1    = dma_dmem_cmd_wr_addr;
    dma_dmem_wen_b1     = {STRB_WIDTH{1'b0}};
    dma_dmem_wr_data_b1 = dma_dmem_cmd_wr_data;

    if (!bc_msg_in_addr_rr[LINE_ADDR_BITS] && bc_msg_in_valid_rr) begin
      dma_dmem_en_b1      = 1'b1;
      dma_dmem_addr_b1    = bc_msg_in_addr_rr;
      dma_dmem_wen_b1     = bc_msg_in_strb_rr;
      dma_dmem_wr_data_b1 = bc_msg_in_data_rr;
    end else if (!dma_dmem_cmd_wr_addr[LINE_ADDR_BITS] && dma_dmem_wr_en_r) begin
      dma_dmem_en_b1      = 1'b1;
      dma_dmem_wr_b1_gnt  = 1'b1;
      dma_dmem_wen_b1     = dma_dmem_cmd_wr_strb;
    end else if (!dma_dmem_cmd_rd_addr[LINE_ADDR_BITS] && dma_dmem_rd_en_r) begin
      dma_dmem_en_b1      = 1'b1;
      dma_dmem_rd_b1_gnt  = 1'b1;
      dma_dmem_addr_b1    = dma_dmem_cmd_rd_addr;
    end
  end

  always @ (*) begin
    dma_dmem_en_b2      = 1'b0;
    dma_dmem_wr_b2_gnt  = 1'b0;
    dma_dmem_rd_b2_gnt  = 1'b0;
    dma_dmem_addr_b2    = dma_dmem_cmd_wr_addr;
    dma_dmem_wen_b2     = {STRB_WIDTH{1'b0}};
    dma_dmem_wr_data_b2 = dma_dmem_cmd_wr_data;

    if (bc_msg_in_addr_rr[LINE_ADDR_BITS] && bc_msg_in_valid_rr) begin
      dma_dmem_en_b2      = 1'b1;
      dma_dmem_addr_b2    = bc_msg_in_addr_rr;
      dma_dmem_wen_b2     = bc_msg_in_strb_rr;
      dma_dmem_wr_data_b2 = bc_msg_in_data_rr;
    end else if (dma_dmem_cmd_wr_addr[LINE_ADDR_BITS] && dma_dmem_wr_en_r) begin
      dma_dmem_en_b2      = 1'b1;
      dma_dmem_wr_b2_gnt  = 1'b1;
      dma_dmem_wen_b2     = dma_dmem_cmd_wr_strb;
    end else if (dma_dmem_cmd_rd_addr[LINE_ADDR_BITS] && dma_dmem_rd_en_r) begin
      dma_dmem_en_b2      = 1'b1;
      dma_dmem_rd_b2_gnt  = 1'b1;
      dma_dmem_addr_b2    = dma_dmem_cmd_rd_addr;
    end
  end

  // For pmem memory core and dma are sharing the same port, and the other port is for
  // accelerators. Core has higher priority, followed by dma write to take the load
  // from internal distribution network.
  reg                        pmem_en_b1;
  reg                        core_pmem_rd_b1;
  reg  [PMEM_ADDR_WIDTH-1:0] pmem_addr_b1;
  reg  [STRB_WIDTH-1:0]      pmem_wen_b1;
  reg  [DATA_WIDTH-1:0]      pmem_wr_data_b1;

  reg                        pmem_en_b2;
  reg                        core_pmem_rd_b2;
  reg  [PMEM_ADDR_WIDTH-1:0] pmem_addr_b2;
  reg  [STRB_WIDTH-1:0]      pmem_wen_b2;
  reg  [DATA_WIDTH-1:0]      pmem_wr_data_b2;

  always @ (*) begin
    dma_pmem_wr_b1_gnt = 1'b0;
    dma_pmem_rd_b1_gnt = 1'b0;

    if (core_dmem_addr[LINE_ADDR_BITS] || !core_pmem_en)
      if (!dma_pmem_cmd_wr_addr[LINE_ADDR_BITS] && dma_pmem_wr_en_r)
        dma_pmem_wr_b1_gnt = 1'b1;
      else if (!dma_pmem_cmd_rd_addr[LINE_ADDR_BITS] && dma_pmem_rd_en_r)
        dma_pmem_rd_b1_gnt = 1'b1;
  end

  // Register level for inputs to PMEM, 1st cycle latency of PMEM
  always @ (posedge clk) begin
    pmem_en_b1      <= 1'b0;
    core_pmem_rd_b1 <= 1'b0;
    pmem_addr_b1    <= core_dmem_addr[PMEM_ADDR_WIDTH-1:0];
    pmem_wen_b1     <= {STRB_WIDTH{1'b0}};
    pmem_wr_data_b1 <= core_dmem_wr_data_w;

    if (!core_dmem_addr[LINE_ADDR_BITS] && core_pmem_en) begin
      pmem_en_b1      <= 1'b1;
      pmem_wen_b1     <= core_dmem_strb_w;
      core_pmem_rd_b1 <= !core_dmem_wen;
    end else if (!dma_pmem_cmd_wr_addr[LINE_ADDR_BITS] && dma_pmem_wr_en_r) begin
      pmem_en_b1      <= 1'b1;
      pmem_addr_b1    <= dma_pmem_cmd_wr_addr;
      pmem_wen_b1     <= dma_pmem_cmd_wr_strb;
      pmem_wr_data_b1 <= dma_pmem_cmd_wr_data;
    end else if (!dma_pmem_cmd_rd_addr[LINE_ADDR_BITS] && dma_pmem_rd_en_r) begin
      pmem_en_b1      <= 1'b1;
      pmem_addr_b1    <= dma_pmem_cmd_rd_addr;
    end

    if (rst)
      pmem_en_b1 <= 1'b0;
  end

  always @ (*) begin
    dma_pmem_wr_b2_gnt = 1'b0;
    dma_pmem_rd_b2_gnt = 1'b0;

    if (!core_dmem_addr[LINE_ADDR_BITS] || !core_pmem_en)
      if (dma_pmem_cmd_wr_addr[LINE_ADDR_BITS] && dma_pmem_wr_en_r)
        dma_pmem_wr_b2_gnt = 1'b1;
      else if (dma_pmem_cmd_rd_addr[LINE_ADDR_BITS] && dma_pmem_rd_en_r)
        dma_pmem_rd_b2_gnt = 1'b1;
  end

  always @ (posedge clk) begin
    pmem_en_b2      <= 1'b0;
    core_pmem_rd_b2 <= 1'b0;
    pmem_addr_b2    <= core_dmem_addr[PMEM_ADDR_WIDTH-1:0];
    pmem_wen_b2     <= {STRB_WIDTH{1'b0}};
    pmem_wr_data_b2 <= core_dmem_wr_data_w;

    if (core_dmem_addr[LINE_ADDR_BITS] && core_pmem_en) begin
      pmem_en_b2      <= 1'b1;
      pmem_wen_b2     <= core_dmem_strb_w;
      core_pmem_rd_b2 <= !core_dmem_wen;
    end else if (dma_pmem_cmd_wr_addr[LINE_ADDR_BITS] && dma_pmem_wr_en_r) begin
      pmem_en_b2      <= 1'b1;
      pmem_addr_b2    <= dma_pmem_cmd_wr_addr;
      pmem_wen_b2     <= dma_pmem_cmd_wr_strb;
      pmem_wr_data_b2 <= dma_pmem_cmd_wr_data;
    end else if (dma_pmem_cmd_rd_addr[LINE_ADDR_BITS] && dma_pmem_rd_en_r) begin
      pmem_en_b2      <= 1'b1;
      pmem_addr_b2    <= dma_pmem_cmd_rd_addr;
    end

    if (rst)
      pmem_en_b2 <= 1'b0;
  end

  ///////////////////////////////////////////////////////////////////////////
  //////////////////////////// MEMORY UNITS /////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////

  // URAM cannot be initialized, so using BRAM for imem.
  // Can be initialized through pcie if URAM is necessary.
  mem_1r1w #(
    .BYTES_PER_LINE(STRB_WIDTH),
    .ADDR_WIDTH(IMEM_ADDR_WIDTH-LINE_ADDR_BITS)
  ) imem (
    .clka(clk),
    .ena(dma_imem_wr_en_r),
    .wea(dma_imem_wr_strb),
    .addra(dma_imem_wr_addr[IMEM_ADDR_WIDTH-1:LINE_ADDR_BITS]),
    .dina(dma_imem_wr_data),

    .clkb(clk),
    .enb(core_imem_ren),
    .addrb(core_imem_addr[IMEM_ADDR_WIDTH-1:LINE_ADDR_BITS]),
    .doutb(core_imem_rd_data_w)
  );

  reg core_imem_ren_r;
  always @ (posedge clk)
    if (rst)
        core_imem_ren_r <= 1'b0;
    else
        core_imem_ren_r <= core_imem_ren;

  assign core_imem_rd_valid = core_imem_ren_r;

  // Single cycle response DMEM, potentially BRAM
  wire [DATA_WIDTH-1:0] core_dmem_rd_data_b1;
  wire [DATA_WIDTH-1:0] core_dmem_rd_data_b2;

  mem_2rw_bram #(
    .BYTES_PER_LINE(STRB_WIDTH),
    .ADDR_WIDTH(DMEM_ADDR_WIDTH-LINE_ADDR_BITS-1)
  ) dmem_b1 (
    .clka(clk),
    .ena(dma_dmem_en_b1),
    .rena(dma_dmem_rd_b1_gnt),
    .wena(dma_dmem_wen_b1),
    .addra(dma_dmem_addr_b1[DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS+1]),
    .dina(dma_dmem_wr_data_b1),
    .douta(dma_dmem_rd_data_b1),

    .clkb(clk),
    .enb(core_dmem_en && !core_dmem_addr[LINE_ADDR_BITS]),
    .renb(!core_dmem_wen),
    .wenb(core_dmem_strb_w),
    .addrb(core_dmem_addr[DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS+1]),
    .dinb(core_dmem_wr_data_w),
    .doutb(core_dmem_rd_data_b1)
  );

  mem_2rw_bram #(
    .BYTES_PER_LINE(STRB_WIDTH),
    .ADDR_WIDTH(DMEM_ADDR_WIDTH-LINE_ADDR_BITS-1)
  ) dmem_b2 (
    .clka(clk),
    .ena(dma_dmem_en_b2),
    .rena(dma_dmem_rd_b2_gnt),
    .wena(dma_dmem_wen_b2),
    .addra(dma_dmem_addr_b2[DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS+1]),
    .dina(dma_dmem_wr_data_b2),
    .douta(dma_dmem_rd_data_b2),

    .clkb(clk),
    .enb(core_dmem_en && core_dmem_addr[LINE_ADDR_BITS]),
    .renb(!core_dmem_wen),
    .wenb(core_dmem_strb_w),
    .addrb(core_dmem_addr[DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS+1]),
    .dinb(core_dmem_wr_data_w),
    .doutb(core_dmem_rd_data_b2)
  );

  // Two or more cycles response PMEM, potentially URAM
  parameter PMEM_SEL_BITS_MIN1 = PMEM_SEL_BITS>0 ? PMEM_SEL_BITS : 1;

  wire [PMEM_SEL_BITS_MIN1-1:0]   pmem_rd_sel_b1;
  wire [PMEM_SEL_BITS_MIN1-1:0]   pmem_rd_sel_b2;

  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0] pmem_rd_data_b1;
  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0] pmem_rd_data_b2;

  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0] acc_rd_data_b1_n;
  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0] acc_rd_data_b2_n;

  if (PMEM_SEL_BITS>0) begin
    assign pmem_rd_sel_b1 = pmem_addr_b1[PMEM_ADDR_WIDTH-1:
                                         PMEM_ADDR_WIDTH-PMEM_SEL_BITS];
    assign pmem_rd_sel_b2 = pmem_addr_b2[PMEM_ADDR_WIDTH-1:
                                         PMEM_ADDR_WIDTH-PMEM_SEL_BITS];
  end else begin
    assign pmem_rd_sel_b1 = 1'b0;
    assign pmem_rd_sel_b2 = 1'b0;
  end

  genvar i;
  generate
    for (i=0; i < ACC_MEM_BLOCKS; i=i+1) begin: pmem_mem_pair

      mem_2rw_uram #(
        .BYTES_PER_LINE(STRB_WIDTH),
        .ADDR_WIDTH($clog2(SLOW_M_B_LINES))
      ) pmem_b1 (
        .clk(clk),

        .ena(pmem_en_b1 && (pmem_rd_sel_b1==i)),
        .wena(pmem_wen_b1),
        .addra(pmem_addr_b1[PMEM_ADDR_WIDTH-PMEM_SEL_BITS-1:LINE_ADDR_BITS+1]),
        .dina(pmem_wr_data_b1),
        .douta(pmem_rd_data_b1[i*DATA_WIDTH +: DATA_WIDTH]),

        .enb(acc_en_b1[i]),
        .wenb(acc_wen_b1[i*STRB_WIDTH +: STRB_WIDTH]),
        .addrb(acc_addr_b1[i*ACC_ADDR_WIDTH +: ACC_ADDR_WIDTH]),
        .dinb(acc_wr_data_b1[i*DATA_WIDTH +: DATA_WIDTH]),
        .doutb(acc_rd_data_b1_n[i*DATA_WIDTH +: DATA_WIDTH])
      );

      mem_2rw_uram #(
        .BYTES_PER_LINE(STRB_WIDTH),
        .ADDR_WIDTH($clog2(SLOW_M_B_LINES))
      ) pmem_b2 (
        .clk(clk),

        .ena(pmem_en_b2 && (pmem_rd_sel_b2==i)),
        .wena(pmem_wen_b2),
        .addra(pmem_addr_b2[PMEM_ADDR_WIDTH-PMEM_SEL_BITS-1:LINE_ADDR_BITS+1]),
        .dina(pmem_wr_data_b2),
        .douta(pmem_rd_data_b2[i*DATA_WIDTH +: DATA_WIDTH]),

        .enb(acc_en_b2[i]),
        .wenb(acc_wen_b2[i*STRB_WIDTH +: STRB_WIDTH]),
        .addrb(acc_addr_b2[i*ACC_ADDR_WIDTH +: ACC_ADDR_WIDTH]),
        .dinb(acc_wr_data_b2[i*DATA_WIDTH +: DATA_WIDTH]),
        .doutb(acc_rd_data_b2_n[i*DATA_WIDTH +: DATA_WIDTH])
      );

  end
  endgenerate

  // register PMEM output, 3rd cycle of PMEM latency for accelerators
  always @ (posedge clk) begin
    acc_rd_data_b1    <= acc_rd_data_b1_n;
    acc_rd_data_b2    <= acc_rd_data_b2_n;
  end

  ////////////////////////////////////////////////////////////////////
  //////////////////// READ RESPONSE STATE ///////////////////////////
  ////////////////////////////////////////////////////////////////////

  // Also remembering memory block for pmem dmem and register the output reads
  reg  [PMEM_SEL_BITS_MIN1-1:0] pmem_rd_sel_b1_r;
  reg  [PMEM_SEL_BITS_MIN1-1:0] pmem_rd_sel_b2_r;

  reg  [DATA_WIDTH-1:0] dma_pmem_rd_data;
  reg  [DATA_WIDTH-1:0] core_pmem_rd_data;
  wire [DATA_WIDTH-1:0] dma_dmem_rd_data;
  reg                   core_pmem_rd_b1_r;
  reg                   dma_pmem_rd_bank_rr;
  reg                   dma_dmem_rd_bank_r;

  if (PMEM_SEL_BITS>0) begin

    always @ (posedge clk) begin
      pmem_rd_sel_b1_r  <= pmem_rd_sel_b1;
      pmem_rd_sel_b2_r  <= pmem_rd_sel_b2;
    end

    // 4th cycle of PMEM latency
    always @ (posedge clk) begin
      core_pmem_rd_data <= core_pmem_rd_b1_r   ? pmem_rd_data_b1[pmem_rd_sel_b1_r*DATA_WIDTH +: DATA_WIDTH]
                                               : pmem_rd_data_b2[pmem_rd_sel_b2_r*DATA_WIDTH +: DATA_WIDTH];
      dma_pmem_rd_data  <= dma_pmem_rd_bank_rr ? pmem_rd_data_b2[pmem_rd_sel_b2_r*DATA_WIDTH +: DATA_WIDTH]
                                               : pmem_rd_data_b1[pmem_rd_sel_b1_r*DATA_WIDTH +: DATA_WIDTH];
    end

  end else begin

    always @ (posedge clk) begin
      core_pmem_rd_data <= core_pmem_rd_b1_r   ? pmem_rd_data_b1
                                               : pmem_rd_data_b2;
      dma_pmem_rd_data  <= dma_pmem_rd_bank_rr ? pmem_rd_data_b2
                                               : pmem_rd_data_b1;
    end
  end

  assign dma_dmem_rd_data = dma_dmem_rd_bank_r ? dma_dmem_rd_data_b2
                                               : dma_dmem_rd_data_b1;

  // Saving valid and bank of read requests to direct them back for response
  reg dma_pmem_rd_gnt_r;
  reg dma_pmem_rd_gnt_rr;
  reg dma_pmem_rd_gnt_rrr;
  reg dma_dmem_rd_gnt_r;
  reg dma_pmem_rd_bank_r;

  reg core_dmem_bank_r;
  reg core_pmem_rd_r;
  reg core_dmem_rd_r;
  reg core_pmem_rd_rr;
  reg core_pmem_rd_rrr;

  always @(posedge clk)
    if(rst) begin
      dma_pmem_rd_gnt_r    <= 1'b0;
      dma_pmem_rd_gnt_rr   <= 1'b0;
      dma_pmem_rd_gnt_rrr  <= 1'b0;
      dma_dmem_rd_gnt_r    <= 1'b0;
      dma_pmem_rd_bank_rr  <= 1'b0;
      dma_dmem_rd_bank_r   <= 1'b0;

      core_dmem_bank_r     <= 1'b0;
      core_pmem_rd_r       <= 1'b0;
      core_dmem_rd_r       <= 1'b0;
      core_pmem_rd_rr      <= 1'b0;
      core_pmem_rd_rrr     <= 1'b0;
      core_pmem_rd_b1_r    <= 1'b0;
    end else begin
      dma_pmem_rd_gnt_r    <= dma_pmem_rd_b1_gnt || dma_pmem_rd_b2_gnt;
      dma_pmem_rd_gnt_rr   <= dma_pmem_rd_gnt_r;
      dma_pmem_rd_gnt_rrr  <= dma_pmem_rd_gnt_rr;
      dma_dmem_rd_gnt_r    <= dma_dmem_rd_b1_gnt || dma_dmem_rd_b2_gnt;
      dma_pmem_rd_bank_r   <= dma_pmem_rd_b2_gnt;
      dma_pmem_rd_bank_rr  <= dma_pmem_rd_bank_r;
      dma_dmem_rd_bank_r   <= dma_dmem_rd_b2_gnt;

      core_dmem_bank_r     <= core_dmem_addr[LINE_ADDR_BITS];
      core_dmem_rd_r       <= core_dmem_en && !core_dmem_wen;
      core_pmem_rd_r       <= core_pmem_en && !core_dmem_wen;
      core_pmem_rd_rr      <= core_pmem_rd_r;
      core_pmem_rd_rrr     <= core_pmem_rd_rr;
      core_pmem_rd_b1_r    <= core_pmem_rd_b1;
    end

  ////////////////////////////////////////////////////////////////////
  ///////////////// SELECTING READ RESPONSE DATA /////////////////////
  ////////////////////////////////////////////////////////////////////

  // FIFOes for read data response to dma, which might not always accept data
  wire                  dma_dmem_fifo_valid;
  wire [DATA_WIDTH-1:0] dma_dmem_fifo_rd_data;
  wire                  dma_pmem_fifo_valid;
  wire [DATA_WIDTH-1:0] dma_pmem_fifo_rd_data;

  simple_fifo # (
    .ADDR_WIDTH(3),
    .DATA_WIDTH(DATA_WIDTH)
  ) dma_dmem_rd_resp_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),

    .din_valid(dma_dmem_rd_gnt_r),
    .din(dma_dmem_rd_data),
    .din_ready(),
    // never gets full since if not readyed a bubble is
    // inserted to the pipe by not acceptign rd_req

    .dout_valid(dma_dmem_fifo_valid),
    .dout(dma_dmem_fifo_rd_data),
    // DMA should not read from both type of memories at once,
    // but since priority is to pmem mem it should be checked
    .dout_ready(dma_rd_resp_ready && !dma_pmem_fifo_valid),

    .full(dma_dmem_rd_resp_fifo_full)
  );

  simple_fifo # (
    .ADDR_WIDTH(4),
    .DATA_WIDTH(DATA_WIDTH)
  ) dma_pmem_rd_resp_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),

    .din_valid(dma_pmem_rd_gnt_rrr),
    .din(dma_pmem_rd_data),
    .din_ready(),
    // never gets full since if not readyed a bubble is
    // inserted to the pipe by not acceptign rd_req

    .dout_valid(dma_pmem_fifo_valid),
    .dout(dma_pmem_fifo_rd_data),
    .dout_ready(dma_rd_resp_ready), // && !dma_dmem_fifo_valid)

    .full(dma_pmem_rd_resp_fifo_full)
  );

  // Selecting output data based on state
  assign core_dmem_rd_data_w = core_pmem_rd_rrr    ? core_pmem_rd_data :
                               core_dmem_bank_r    ? core_dmem_rd_data_b2 : core_dmem_rd_data_b1;
  assign dma_rd_resp_data    = dma_pmem_fifo_valid ? dma_pmem_fifo_rd_data : dma_dmem_fifo_rd_data;

  // Asserting valids
  assign core_dmem_rd_valid = core_pmem_rd_rrr    || core_dmem_rd_r;
  assign dma_rd_resp_valid  = dma_pmem_fifo_valid || dma_dmem_fifo_valid;

  // DMA request ready responses
  assign dma_cmd_wr_ready = dma_pmem_cmd_wr_ready && dma_dmem_cmd_wr_ready; //imem always accepts
  assign dma_cmd_rd_ready = dma_pmem_cmd_rd_ready && dma_dmem_cmd_rd_ready;

endmodule
