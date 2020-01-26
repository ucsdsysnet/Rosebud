module mem_sys # (
  parameter DATA_WIDTH           = 64,   
  parameter STRB_WIDTH           = (DATA_WIDTH/8),
  parameter IMEM_SIZE            = 65536,
  parameter SLOW_DMEM_SIZE       = 1048576,
  parameter FAST_DMEM_SIZE       = 32768,
  parameter BC_REGION_SIZE       = 4048,
  parameter SLOW_DMEM_ADDR_WIDTH = $clog2(SLOW_DMEM_SIZE),
  parameter FAST_DMEM_ADDR_WIDTH = $clog2(FAST_DMEM_SIZE),
  parameter IMEM_ADDR_WIDTH      = $clog2(IMEM_SIZE),
  parameter BC_MSG_ADDR_WIDTH    = $clog2(BC_REGION_SIZE),
  parameter ADDR_WIDTH           = SLOW_DMEM_ADDR_WIDTH+2,
  parameter SLOW_M_B_LINES       = 4096,
  parameter FAST_M_B_LINES       = 1024,
  parameter LINE_ADDR_BITS       = $clog2(STRB_WIDTH),
  parameter ACC_ADDR_WIDTH       = $clog2(SLOW_M_B_LINES), 
  parameter SLOW_DMEM_SEL_BITS   = SLOW_DMEM_ADDR_WIDTH-$clog2(STRB_WIDTH)
                                   -1-$clog2(SLOW_M_B_LINES),
  parameter ACC_MEM_BLOCKS       = 2**SLOW_DMEM_SEL_BITS
) (
  input  wire                                     clk,
  input  wire                                     rst,
  
  input  wire                                     dma_cmd_wr_en,
  input  wire [ADDR_WIDTH-1:0]                    dma_cmd_wr_addr,
  input  wire [DATA_WIDTH-1:0]                    dma_cmd_wr_data,
  input  wire [STRB_WIDTH-1:0]                    dma_cmd_wr_strb,
  input  wire                                     dma_cmd_wr_last,
  output wire                                     dma_cmd_wr_ready,
  
  input  wire                                     dma_cmd_rd_en,
  input  wire [ADDR_WIDTH-1:0]                    dma_cmd_rd_addr,
  input  wire                                     dma_cmd_rd_last,
  output wire                                     dma_cmd_rd_ready,
  
  output wire                                     dma_rd_resp_valid,
  output wire [DATA_WIDTH-1:0]                    dma_rd_resp_data,
  input  wire                                     dma_rd_resp_ready,
  
  input  wire                                     core_dmem_en,           
  input  wire [STRB_WIDTH-1:0]                    core_dmem_wen,          
  input  wire [ADDR_WIDTH-1:0]                    core_dmem_addr,         
  input  wire [DATA_WIDTH-1:0]                    core_dmem_wr_data,      
  output wire [DATA_WIDTH-1:0]                    core_dmem_rd_data,      
  output wire                                     core_dmem_rd_valid,     
  
  input  wire                                     core_imem_ren,
  input  wire [ADDR_WIDTH-1:0]                    core_imem_addr,         
  output wire [DATA_WIDTH-1:0]                    core_imem_rd_data,      
  
  input  wire [BC_MSG_ADDR_WIDTH-1:0]             bc_msg_in_addr,
  input  wire [STRB_WIDTH-1:0]                    bc_msg_in_wr_strb,
  input  wire [DATA_WIDTH-1:0]                    bc_msg_in_wr_data,
  input  wire                                     bc_msg_in_valid,

  input  wire [ACC_MEM_BLOCKS-1:0]                acc_en_b1,
  input  wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b1,
  input  wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b1,
  input  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b1,
  output wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b1,
  
  input  wire [ACC_MEM_BLOCKS-1:0]                acc_en_b2,               
  input  wire [ACC_MEM_BLOCKS*STRB_WIDTH-1:0]     acc_wen_b2,
  input  wire [ACC_MEM_BLOCKS*ACC_ADDR_WIDTH-1:0] acc_addr_b2,
  input  wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_wr_data_b2,
  output wire [ACC_MEM_BLOCKS*DATA_WIDTH-1:0]     acc_rd_data_b2,

  output wire                                     out_of_bound
);
  
  reg [BC_MSG_ADDR_WIDTH-1:0] bc_msg_in_addr_r;
  reg [STRB_WIDTH-1:0]        bc_msg_in_wr_strb_r;
  reg [DATA_WIDTH-1:0]        bc_msg_in_wr_data_r;
  reg                         bc_msg_in_valid_r;

  always @ (posedge clk) begin
    bc_msg_in_addr_r    <= bc_msg_in_addr;
    bc_msg_in_wr_strb_r <= bc_msg_in_wr_strb;
    bc_msg_in_wr_data_r <= bc_msg_in_wr_data;
    bc_msg_in_valid_r   <= bc_msg_in_valid;
    if (rst)
      bc_msg_in_valid_r <= 1'b0;
  end
    

  ///////////////////////////////////////////////////////////////////////////
  ////////////////// Separate dma and core requests based on ////////////////
  /////////////// read/write and speed of memory to be accesssed ////////////
  ///////////////////////////////////////////////////////////////////////////
  
  // We deassert read request if read results cannot be accepted, similar to adding a bubble into pipe
  wire dma_imem_wr_en      =   dma_cmd_wr_addr[ADDR_WIDTH-1]  && dma_cmd_wr_en;
  wire dma_fast_dmem_wr_en = (~dma_cmd_wr_addr[ADDR_WIDTH-1]) && ( dma_cmd_wr_addr[ADDR_WIDTH-2]) && dma_cmd_wr_en;
  wire dma_fast_dmem_rd_en = (~dma_cmd_rd_addr[ADDR_WIDTH-1]) && ( dma_cmd_wr_addr[ADDR_WIDTH-2]) && dma_cmd_rd_en && dma_rd_resp_ready;
  wire dma_slow_dmem_wr_en = (~dma_cmd_wr_addr[ADDR_WIDTH-1]) && (~dma_cmd_wr_addr[ADDR_WIDTH-2]) && dma_cmd_wr_en;
  wire dma_slow_dmem_rd_en = (~dma_cmd_rd_addr[ADDR_WIDTH-1]) && (~dma_cmd_wr_addr[ADDR_WIDTH-2]) && dma_cmd_rd_en && dma_rd_resp_ready;
  
  wire core_fast_dmem_en = core_dmem_en &&  core_dmem_addr[ADDR_WIDTH-2];
  wire core_slow_dmem_en = core_dmem_en && ~core_dmem_addr[ADDR_WIDTH-2];
  
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
    .dout_ready(1'b1)
  );
  
  wire [FAST_DMEM_ADDR_WIDTH-1:0] fast_dma_cmd_wr_addr;
  wire [DATA_WIDTH-1:0]           fast_dma_cmd_wr_data;
  wire [STRB_WIDTH-1:0]           fast_dma_cmd_wr_strb;
  wire                            fast_dma_cmd_wr_ready;
  reg                             dma_fast_wr_b1_gnt;
  reg                             dma_fast_wr_b2_gnt;
  wire                            dma_fast_dmem_wr_en_r;
  
  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(DATA_WIDTH+FAST_DMEM_ADDR_WIDTH+STRB_WIDTH)
  ) dma_fast_wr_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
  
    .din_valid(dma_fast_dmem_wr_en), 
    .din({dma_cmd_wr_addr[FAST_DMEM_ADDR_WIDTH-1:0], dma_cmd_wr_strb, dma_cmd_wr_data}),
    .din_ready(fast_dma_cmd_wr_ready),
   
    .dout_valid(dma_fast_dmem_wr_en_r),
    .dout({fast_dma_cmd_wr_addr, fast_dma_cmd_wr_strb, fast_dma_cmd_wr_data}),
    .dout_ready(dma_fast_wr_b1_gnt || dma_fast_wr_b2_gnt)
  );
  
  wire [SLOW_DMEM_ADDR_WIDTH-1:0] slow_dma_cmd_wr_addr;
  wire [DATA_WIDTH-1:0]           slow_dma_cmd_wr_data;
  wire [STRB_WIDTH-1:0]           slow_dma_cmd_wr_strb;
  wire                            slow_dma_cmd_wr_ready;
  reg                             dma_slow_wr_b1_gnt;
  reg                             dma_slow_wr_b2_gnt;
  wire                            dma_slow_dmem_wr_en_r;
  
  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(DATA_WIDTH+SLOW_DMEM_ADDR_WIDTH+STRB_WIDTH)
  ) dma_slow_wr_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
  
    .din_valid(dma_slow_dmem_wr_en), 
    .din({dma_cmd_wr_addr[SLOW_DMEM_ADDR_WIDTH-1:0], dma_cmd_wr_strb, dma_cmd_wr_data}),
    .din_ready(slow_dma_cmd_wr_ready),
   
    .dout_valid(dma_slow_dmem_wr_en_r),
    .dout({slow_dma_cmd_wr_addr, slow_dma_cmd_wr_strb, slow_dma_cmd_wr_data}),
    .dout_ready(dma_slow_wr_b1_gnt || dma_slow_wr_b2_gnt)
  );
  
  wire [FAST_DMEM_ADDR_WIDTH-1:0] fast_dma_cmd_rd_addr;
  wire [DATA_WIDTH-1:0]           fast_dma_cmd_rd_data;
  wire                            fast_dma_cmd_rd_ready;
  reg                             dma_fast_rd_b1_gnt;
  reg                             dma_fast_rd_b2_gnt;
  wire                            dma_fast_dmem_rd_en_r;
  
  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(FAST_DMEM_ADDR_WIDTH)
  ) dma_fast_rd_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
  
    .din_valid(dma_fast_dmem_rd_en), 
    .din(dma_cmd_rd_addr[FAST_DMEM_ADDR_WIDTH-1:0]),
    .din_ready(fast_dma_cmd_rd_ready),
   
    .dout_valid(dma_fast_dmem_rd_en_r),
    .dout(fast_dma_cmd_rd_addr),
    .dout_ready(dma_fast_rd_b1_gnt || dma_fast_rd_b2_gnt)
  );
  
  wire [SLOW_DMEM_ADDR_WIDTH-1:0] slow_dma_cmd_rd_addr;
  wire [DATA_WIDTH-1:0]           slow_dma_cmd_rd_data;
  wire                            slow_dma_cmd_rd_ready;
  reg                             dma_slow_rd_b1_gnt;
  reg                             dma_slow_rd_b2_gnt;
  wire                            dma_slow_dmem_rd_en_r;
  
  simple_fifo # (
    .ADDR_WIDTH(2),
    .DATA_WIDTH(SLOW_DMEM_ADDR_WIDTH)
  ) dma_slow_rd_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
  
    .din_valid(dma_slow_dmem_rd_en), 
    .din(dma_cmd_rd_addr[SLOW_DMEM_ADDR_WIDTH-1:0]),
    .din_ready(slow_dma_cmd_rd_ready),
   
    .dout_valid(dma_slow_dmem_rd_en_r),
    .dout(slow_dma_cmd_rd_addr),
    .dout_ready(dma_slow_rd_b1_gnt || dma_slow_rd_b2_gnt)
  );
  
  //////////////////////////////////////////////////////////////////
  ////// Arbiters for each bank of each memory speed ///////////////
  //////////////////////////////////////////////////////////////////
  
  reg                             data_dma_fast_en_b1;
  reg  [FAST_DMEM_ADDR_WIDTH-1:0] data_dma_fast_addr_b1;
  reg  [STRB_WIDTH-1:0]           data_dma_fast_wen_b1;
  reg  [DATA_WIDTH-1:0]           data_dma_fast_wr_data_b1;
  wire [DATA_WIDTH-1:0]           data_dma_fast_rd_data_b1;
  
  reg                             data_dma_fast_en_b2;
  reg  [FAST_DMEM_ADDR_WIDTH-1:0] data_dma_fast_addr_b2;
  reg  [STRB_WIDTH-1:0]           data_dma_fast_wen_b2;
  reg  [DATA_WIDTH-1:0]           data_dma_fast_wr_data_b2;
  wire [DATA_WIDTH-1:0]           data_dma_fast_rd_data_b2;
  
  // For fast memory core has separate port, and the other port is shared among dma engine
  // and broadcast messaging. BC messaging has highest priority, followed by dma write to 
  // take the load from internal distribution network.
  always @ (*) begin
    data_dma_fast_en_b1      = 1'b0;
    dma_fast_wr_b1_gnt       = 1'b0;
    dma_fast_rd_b1_gnt       = 1'b0;
    data_dma_fast_addr_b1    = fast_dma_cmd_wr_addr;
    data_dma_fast_wen_b1     = {STRB_WIDTH{1'b0}};
    data_dma_fast_wr_data_b1 = fast_dma_cmd_wr_data; 
  
    if (!bc_msg_in_addr_r[LINE_ADDR_BITS] && bc_msg_in_valid_r) begin
      data_dma_fast_en_b1      = 1'b1;
      data_dma_fast_addr_b1    = bc_msg_in_addr_r[FAST_DMEM_ADDR_WIDTH-1:0];
      data_dma_fast_wen_b1     = bc_msg_in_wr_strb_r;
      data_dma_fast_wr_data_b1 = bc_msg_in_wr_data_r;
    end else if (!fast_dma_cmd_wr_addr[LINE_ADDR_BITS] && dma_fast_dmem_wr_en_r) begin
      data_dma_fast_en_b1      = 1'b1;
      dma_fast_wr_b1_gnt       = 1'b1;
      data_dma_fast_wen_b1     = fast_dma_cmd_wr_strb;
    end else if (!fast_dma_cmd_rd_addr[LINE_ADDR_BITS] && dma_fast_dmem_rd_en_r) begin
      data_dma_fast_en_b1      = 1'b1;
      dma_fast_rd_b1_gnt       = 1'b1;
      data_dma_fast_addr_b1    = fast_dma_cmd_rd_addr;
    end
  end
  
  always @ (*) begin
    data_dma_fast_en_b2      = 1'b0;
    dma_fast_wr_b2_gnt       = 1'b0;
    dma_fast_rd_b2_gnt       = 1'b0;
    data_dma_fast_addr_b2    = fast_dma_cmd_wr_addr;
    data_dma_fast_wen_b2     = {STRB_WIDTH{1'b0}};
    data_dma_fast_wr_data_b2 = fast_dma_cmd_wr_data; 
  
    if (bc_msg_in_addr_r[LINE_ADDR_BITS] && bc_msg_in_valid_r) begin
      data_dma_fast_en_b2      = 1'b1;
      data_dma_fast_addr_b2    = bc_msg_in_addr_r[FAST_DMEM_ADDR_WIDTH-1:0];
      data_dma_fast_wen_b2     = bc_msg_in_wr_strb_r;
      data_dma_fast_wr_data_b2 = bc_msg_in_wr_data_r;
    end else if (fast_dma_cmd_wr_addr[LINE_ADDR_BITS] && dma_fast_dmem_wr_en_r) begin
      data_dma_fast_en_b2      = 1'b1;
      dma_fast_wr_b2_gnt       = 1'b1;
      data_dma_fast_wen_b2     = fast_dma_cmd_wr_strb;
    end else if (fast_dma_cmd_rd_addr[LINE_ADDR_BITS] && dma_fast_dmem_rd_en_r) begin
      data_dma_fast_en_b2      = 1'b1;
      dma_fast_rd_b2_gnt       = 1'b1;
      data_dma_fast_addr_b2    = fast_dma_cmd_rd_addr;
    end
  end
  
  // For slow memory core and dma are sharing the same port, and the other port is for 
  // accelerators. Core has higher priority, followed by dma write to take the load 
  // from internal distribution network.
  reg                             dmem_slow_en_b1;
  reg                             core_slow_rd_b1;
  reg  [SLOW_DMEM_ADDR_WIDTH-1:0] dmem_slow_addr_b1;
  reg  [STRB_WIDTH-1:0]           dmem_slow_wen_b1;
  reg  [DATA_WIDTH-1:0]           dmem_slow_wr_data_b1;
  
  reg                             dmem_slow_en_b2;
  reg                             core_slow_rd_b2;
  reg  [SLOW_DMEM_ADDR_WIDTH-1:0] dmem_slow_addr_b2;
  reg  [STRB_WIDTH-1:0]           dmem_slow_wen_b2;
  reg  [DATA_WIDTH-1:0]           dmem_slow_wr_data_b2;
  
  always @ (*) begin
    dmem_slow_en_b1      = 1'b0;
    dma_slow_wr_b1_gnt   = 1'b0;
    dma_slow_rd_b1_gnt   = 1'b0;
    core_slow_rd_b1      = 1'b0;
    dmem_slow_addr_b1    = core_dmem_addr[SLOW_DMEM_ADDR_WIDTH-1:0]; 
    dmem_slow_wen_b1     = {STRB_WIDTH{1'b0}};
    dmem_slow_wr_data_b1 = core_dmem_wr_data; 
  
    if (!core_dmem_addr[LINE_ADDR_BITS] && core_slow_dmem_en) begin
      dmem_slow_en_b1      = 1'b1;
      dmem_slow_wen_b1     = core_dmem_wen;
      core_slow_rd_b1      = ~(|core_dmem_wr_data);
    end else if (!slow_dma_cmd_wr_addr[LINE_ADDR_BITS] && dma_slow_dmem_wr_en_r) begin
      dmem_slow_en_b1      = 1'b1;
      dma_slow_wr_b1_gnt   = 1'b1;
      dmem_slow_addr_b1    = slow_dma_cmd_wr_addr;
      dmem_slow_wen_b1     = slow_dma_cmd_wr_strb;
      dmem_slow_wr_data_b1 = slow_dma_cmd_wr_data; 
    end else if (!slow_dma_cmd_rd_addr[LINE_ADDR_BITS] && dma_slow_dmem_rd_en_r) begin
      dmem_slow_en_b1      = 1'b1;
      dma_slow_rd_b1_gnt   = 1'b1;
      dmem_slow_addr_b1    = slow_dma_cmd_rd_addr;
    end
  end
  
  always @ (*) begin
    dmem_slow_en_b2      = 1'b0;
    dma_slow_wr_b2_gnt   = 1'b0;
    dma_slow_rd_b2_gnt   = 1'b0;
    core_slow_rd_b2      = 1'b0;
    dmem_slow_addr_b2    = core_dmem_addr[SLOW_DMEM_ADDR_WIDTH-1:0];
    dmem_slow_wen_b2     = {STRB_WIDTH{1'b0}};
    dmem_slow_wr_data_b2 = core_dmem_wr_data; 
  
    if (core_dmem_addr[LINE_ADDR_BITS] && core_slow_dmem_en) begin
      dmem_slow_en_b2      = 1'b1;
      dmem_slow_wen_b2     = core_dmem_wen;
      core_slow_rd_b2      = ~(|core_dmem_wr_data);
    end else if (slow_dma_cmd_wr_addr[LINE_ADDR_BITS] && dma_slow_dmem_wr_en_r) begin
      dmem_slow_en_b2      = 1'b1;
      dma_slow_wr_b2_gnt   = 1'b1;
      dmem_slow_addr_b2    = slow_dma_cmd_wr_addr;
      dmem_slow_wen_b2     = slow_dma_cmd_wr_strb;
      dmem_slow_wr_data_b2 = slow_dma_cmd_wr_data; 
    end else if (slow_dma_cmd_rd_addr[LINE_ADDR_BITS] && dma_slow_dmem_rd_en_r) begin
      dmem_slow_en_b2      = 1'b1;
      dma_slow_rd_b2_gnt   = 1'b1;
      dmem_slow_addr_b2    = slow_dma_cmd_rd_addr;
    end
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
    .doutb(core_imem_rd_data)
  );
  
  // Single cycle response DMEM, potentially BRAM
  wire [DATA_WIDTH-1:0] core_fast_rd_data_b1;
  wire [DATA_WIDTH-1:0] core_fast_rd_data_b2;
  
  mem_2rw_bram #(
    .BYTES_PER_LINE(STRB_WIDTH),
    .ADDR_WIDTH(FAST_DMEM_ADDR_WIDTH-LINE_ADDR_BITS-1)    
  ) dmem_fast_b1 (
    .clka(clk),
    .ena(data_dma_fast_en_b1),
    .rena(dma_fast_rd_b1_gnt),
    .wena(data_dma_fast_wen_b1),
    .addra(data_dma_fast_addr_b1[FAST_DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS+1]),
    .dina(data_dma_fast_wr_data_b1),
    .douta(data_dma_fast_rd_data_b1),
  
    .clkb(clk),
    .enb(core_fast_dmem_en && !core_dmem_addr[LINE_ADDR_BITS]),
    .renb((~|core_dmem_wen)),
    .wenb(core_dmem_wen),
    .addrb(core_dmem_addr[FAST_DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS+1]),
    .dinb(core_dmem_wr_data),
    .doutb(core_fast_rd_data_b1)
  );
  
  mem_2rw_bram #(
    .BYTES_PER_LINE(STRB_WIDTH),
    .ADDR_WIDTH(FAST_DMEM_ADDR_WIDTH-LINE_ADDR_BITS-1)    
  ) dmem_fast_b2 (
    .clka(clk),
    .ena(data_dma_fast_en_b2),
    .rena(dma_fast_rd_b2_gnt),
    .wena(data_dma_fast_wen_b2),
    .addra(data_dma_fast_addr_b2[FAST_DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS+1]),
    .dina(data_dma_fast_wr_data_b2),
    .douta(data_dma_fast_rd_data_b2),
  
    .clkb(clk),
    .enb(core_fast_dmem_en && core_dmem_addr[LINE_ADDR_BITS]),
    .renb((~|core_dmem_wen)),
    .wenb(core_dmem_wen),
    .addrb(core_dmem_addr[FAST_DMEM_ADDR_WIDTH-1:LINE_ADDR_BITS+1]),
    .dinb(core_dmem_wr_data),
    .doutb(core_fast_rd_data_b2)
  );
  
  // Two or more cycles response DMEM, potentially URAM
  wire [SLOW_DMEM_SEL_BITS-1:0] dmem_slow_rd_sel_b1 = 
          dmem_slow_addr_b1[SLOW_DMEM_ADDR_WIDTH-1:ADDR_WIDTH-SLOW_DMEM_SEL_BITS-1];
  wire [SLOW_DMEM_SEL_BITS-1:0] dmem_slow_rd_sel_b2 = 
          dmem_slow_addr_b2[SLOW_DMEM_ADDR_WIDTH-1:ADDR_WIDTH-SLOW_DMEM_SEL_BITS-1];

  wire [DATA_WIDTH-1:0] dmem_slow_rd_data_b1    [0:ACC_MEM_BLOCKS-1];
  wire [DATA_WIDTH-1:0] dmem_slow_rd_data_b2    [0:ACC_MEM_BLOCKS-1];
  reg  [DATA_WIDTH-1:0] dmem_slow_rd_data_b1_r  [0:ACC_MEM_BLOCKS-1];
  reg  [DATA_WIDTH-1:0] dmem_slow_rd_data_b2_r  [0:ACC_MEM_BLOCKS-1];
  
  genvar i;
  generate
    for (i=0; i < ACC_MEM_BLOCKS; i=i+1) begin: slow_mem_pair
  
      mem_2rw_uram #(
        .BYTES_PER_LINE(STRB_WIDTH),
        .ADDR_WIDTH($clog2(SLOW_M_B_LINES))    
      ) dmem_slow_b1 (
        .clk(clk),
      
        .ena(dmem_slow_en_b1 && (dmem_slow_rd_sel_b1==i)),
        .wena(dmem_slow_wen_b1),
        .addra(dmem_slow_addr_b1[SLOW_DMEM_ADDR_WIDTH-SLOW_DMEM_SEL_BITS-1:LINE_ADDR_BITS+1]),
        .dina(dmem_slow_wr_data_b1),
        .douta(dmem_slow_rd_data_b1[i]),
      
        .enb(acc_en_b1[i]), 
        .wenb(acc_wen_b1[i*STRB_WIDTH +: STRB_WIDTH]),
        .addrb(acc_addr_b1[i*ACC_ADDR_WIDTH +: ACC_ADDR_WIDTH]),
        .dinb(acc_wr_data_b1[i*DATA_WIDTH +: DATA_WIDTH]),
        .doutb(acc_rd_data_b1[i*DATA_WIDTH +: DATA_WIDTH])
      );
      
      mem_2rw_uram #(
        .BYTES_PER_LINE(STRB_WIDTH),
        .ADDR_WIDTH($clog2(SLOW_M_B_LINES))    
      ) dmem_slow_b2 (
        .clk(clk),
      
        .ena(dmem_slow_en_b2 && (dmem_slow_rd_sel_b2==i)),
        .wena(dmem_slow_wen_b2),
        .addra(dmem_slow_addr_b2[SLOW_DMEM_ADDR_WIDTH-SLOW_DMEM_SEL_BITS-1:LINE_ADDR_BITS+1]),
        .dina(dmem_slow_wr_data_b2),
        .douta(dmem_slow_rd_data_b2[i]),
        
        .enb(acc_en_b2[i]), 
        .wenb(acc_wen_b2[i*STRB_WIDTH +: STRB_WIDTH]),
        .addrb(acc_addr_b2[i*ACC_ADDR_WIDTH +: ACC_ADDR_WIDTH]),
        .dinb(acc_wr_data_b2[i*DATA_WIDTH +: DATA_WIDTH]),
        .doutb(acc_rd_data_b2[i*DATA_WIDTH +: DATA_WIDTH])
      );

      // 2nd cycle of slow mem
      always @ (posedge clk) begin
        dmem_slow_rd_data_b1_r[i] <= dmem_slow_rd_data_b1[i];
        dmem_slow_rd_data_b2_r[i] <= dmem_slow_rd_data_b2[i];
      end
  end
  endgenerate
   
  ////////////////////////////////////////////////////////////////////
  //////////////////// READ RESPONSE STATE ///////////////////////////
  ////////////////////////////////////////////////////////////////////

  // Also remembering memory block for slow dmem and register the output reads
  
  reg  [SLOW_DMEM_SEL_BITS-1:0] dmem_slow_rd_sel_b1_r; 
  reg  [SLOW_DMEM_SEL_BITS-1:0] dmem_slow_rd_sel_b2_r; 
  reg  [SLOW_DMEM_SEL_BITS-1:0] dmem_slow_rd_sel_b1_rr; 
  reg  [SLOW_DMEM_SEL_BITS-1:0] dmem_slow_rd_sel_b2_rr; 
  
  always @ (posedge clk) begin
    dmem_slow_rd_sel_b1_r  <= dmem_slow_rd_sel_b1; 
    dmem_slow_rd_sel_b2_r  <= dmem_slow_rd_sel_b2; 
    dmem_slow_rd_sel_b1_rr <= dmem_slow_rd_sel_b1_r; 
    dmem_slow_rd_sel_b2_rr <= dmem_slow_rd_sel_b2_r; 
  end
  
  wire [DATA_WIDTH-1:0] dma_fast_rd_data;
  reg  [DATA_WIDTH-1:0] dma_slow_rd_data;
  reg  [DATA_WIDTH-1:0] core_slow_rd_data;
  
  reg core_slow_rd_b1_rr;
  reg dma_slow_rd_bank_rr;
  
  // 3rd cycle of slow mem
  always @ (posedge clk) begin
    core_slow_rd_data <= core_slow_rd_b1_rr  ? dmem_slow_rd_data_b1_r[dmem_slow_rd_sel_b1_rr] 
                                             : dmem_slow_rd_data_b2_r[dmem_slow_rd_sel_b2_rr];
    dma_slow_rd_data  <= dma_slow_rd_bank_rr ? dmem_slow_rd_data_b2_r[dmem_slow_rd_sel_b2_rr] 
                                             : dmem_slow_rd_data_b1_r[dmem_slow_rd_sel_b1_rr];
  end
  
  assign dma_fast_rd_data = dma_fast_rd_bank_r  ? data_dma_fast_rd_data_b2 
                                                : data_dma_fast_rd_data_b1;
  
  
  // Saving valid and bank of read requests to direct them back for response
  reg dma_slow_rd_gnt_r; 
  reg dma_slow_rd_gnt_rr; 
  reg dma_slow_rd_gnt_rrr; 
  reg dma_fast_rd_gnt_r;
  reg dma_slow_rd_bank_r;
  reg dma_fast_rd_bank_r;
  
  reg core_fast_bank_r;
  reg core_slow_rd_r;
  reg core_fast_rd_r;
  reg core_slow_rd_rr;
  reg core_slow_rd_rrr;
  reg core_slow_rd_b1_r;
  
  always @(posedge clk)
    if(rst) begin
      dma_slow_rd_gnt_r   <= 1'b0;
      dma_slow_rd_gnt_rr  <= 1'b0;
      dma_slow_rd_gnt_rrr <= 1'b0;
      dma_fast_rd_gnt_r   <= 1'b0;
      dma_slow_rd_bank_rr <= 1'b0;
      dma_fast_rd_bank_r  <= 1'b0;
      
      core_fast_bank_r    <= 1'b0;
      core_slow_rd_r      <= 1'b0;
      core_fast_rd_r      <= 1'b0;
      core_slow_rd_rr     <= 1'b0;
      core_slow_rd_rrr    <= 1'b0;
      core_slow_rd_b1_r   <= 1'b0;
      core_slow_rd_b1_rr  <= 1'b0;
    end else begin
      dma_slow_rd_gnt_r   <= dma_slow_rd_b1_gnt || dma_slow_rd_b2_gnt;
      dma_slow_rd_gnt_rr  <= dma_slow_rd_gnt_r;
      dma_slow_rd_gnt_rrr <= dma_slow_rd_gnt_rr;
      dma_fast_rd_gnt_r   <= dma_fast_rd_b1_gnt || dma_fast_rd_b2_gnt;
      dma_slow_rd_bank_r  <= dma_slow_rd_b2_gnt;
      dma_slow_rd_bank_rr <= dma_slow_rd_bank_r;
      dma_fast_rd_bank_r  <= dma_fast_rd_b2_gnt;
      
      core_fast_bank_r    <= core_dmem_addr[LINE_ADDR_BITS];
      core_fast_rd_r      <= core_fast_dmem_en && ~(|core_dmem_wen);
      core_slow_rd_r      <= core_slow_dmem_en && ~(|core_dmem_wen);
      core_slow_rd_rr     <= core_slow_rd_r;
      core_slow_rd_rrr    <= core_slow_rd_rr;
      core_slow_rd_b1_r   <= core_slow_rd_b1;
      core_slow_rd_b1_rr  <= core_slow_rd_b1_r;
    end
   
  ////////////////////////////////////////////////////////////////////
  ///////////////// SELECTING READ RESPONSE DATA /////////////////////
  ////////////////////////////////////////////////////////////////////
  
  // FIFOes for read data response to dma, which might not always accept data
  wire                  dma_fast_fifo_valid;
  wire [DATA_WIDTH-1:0] dma_fast_fifo_rd_data;
  wire                  dma_slow_fifo_valid;
  wire [DATA_WIDTH-1:0] dma_slow_fifo_rd_data;
  
  simple_fifo # (
    .ADDR_WIDTH(3),
    .DATA_WIDTH(DATA_WIDTH)
  ) dma_fast_rd_resp_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
  
    .din_valid(dma_fast_rd_gnt_r), 
    .din(dma_fast_rd_data),
    .din_ready(),
    // never gets full since if not readyed a bubble is 
    // inserted to the pipe by not acceptign rd_req
   
    .dout_valid(dma_fast_fifo_valid),
    .dout(dma_fast_fifo_rd_data),
    // DMA should not read from both type of memories at once, 
    // but since priority is to slow mem it should be checked
    .dout_ready(dma_rd_resp_ready && !dma_slow_fifo_valid) 
  );
  
  simple_fifo # (
    .ADDR_WIDTH(4),
    .DATA_WIDTH(DATA_WIDTH)
  ) dma_slow_rd_resp_fifo (
    .clk(clk),
    .rst(rst),
    .clear(1'b0),
  
    .din_valid(dma_slow_rd_gnt_rrr), 
    .din(dma_slow_rd_data),
    .din_ready(), 
    // never gets full since if not readyed a bubble is 
    // inserted to the pipe by not acceptign rd_req
   
    .dout_valid(dma_slow_fifo_valid),
    .dout(dma_slow_fifo_rd_data),
    .dout_ready(dma_rd_resp_ready) // && !dma_fast_fifo_valid)
  );
  
  // Selecting output data based on state
  assign core_dmem_rd_data  = core_slow_rd_rrr    ? core_slow_rd_data : 
                              core_fast_bank_r    ? core_fast_rd_data_b2 : core_fast_rd_data_b1; 
  assign dma_rd_resp_data   = dma_slow_fifo_valid ? dma_slow_fifo_rd_data : dma_fast_fifo_rd_data;
  
  // Asserting valids
  assign core_dmem_rd_valid = core_slow_rd_rrr    || core_fast_rd_r;
  assign dma_rd_resp_valid  = dma_slow_fifo_valid || dma_fast_fifo_valid;
  
  // DMA request ready responses
  assign dma_cmd_wr_ready = slow_dma_cmd_wr_ready && fast_dma_cmd_wr_ready; //imem always accepts 
  assign dma_cmd_rd_ready = slow_dma_cmd_rd_ready && fast_dma_cmd_rd_ready
                            && dma_rd_resp_ready;
  
  // always @ (posedge clk)
  //   if (rst)
  //     out_of_bound <= 1'b0;
  //   else 
  //     out_of_bound <= (dma_fast_dmem_wr_en && (ram_cmd_wr_addr[ADDR_WIDTH-1])) ||
  //                     (dma_slow_dmem_wr_en && (|ram_cmd_wr_addr[ADDR_WIDTH-1:ADDR_WIDTH-2]))
  //                     (dma_fast_dmem_rd_en && (ram_cmd_rd_addr[ADDR_WIDTH-1])) ||
  //                     (dma_slow_dmem_rd_en && (|ram_cmd_rd_addr[ADDR_WIDTH-1:ADDR_WIDTH-2])) ||
  //                     (dma_imem_wr_en      && (|ram_cmd_wr_addr[ADDR_WIDTH-1:IMEM_ADDR_WIDTH]));
  assign out_of_bound = 1'b0;
  
endmodule
