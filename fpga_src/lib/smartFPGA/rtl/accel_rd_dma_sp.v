module accel_rd_dma_sp # (
  parameter DATA_WIDTH     = 128, // each bank
  parameter KEEP_WIDTH     = (DATA_WIDTH/8),
  parameter ADDR_WIDTH     = 17,  // 128KB
  parameter ACCEL_COUNT    = 64,
  parameter DEST_WIDTH     = $clog2(ACCEL_COUNT),
  parameter LEN_WIDTH      = 14, // up to 16K

  parameter MASK_BITS      = $clog2(KEEP_WIDTH),
  parameter MEM_ADDR_WIDTH = ADDR_WIDTH-MASK_BITS,
  parameter FIFO_LINES     = 2
) (
  input  wire                              clk,
  input  wire                              rst,

  // Descriptor input
  input  wire [DEST_WIDTH-1:0]             desc_accel_id,
  input  wire [ADDR_WIDTH-1:0]             desc_addr,
  input  wire [LEN_WIDTH-1:0]              desc_len,
  input  wire                              desc_valid,

  // Accelerator stop and status
  input  wire [ACCEL_COUNT-1:0]            accel_stop,
  output reg  [ACCEL_COUNT-1:0]            accel_busy,

  // Memory read channels per bank,
  // each channel address has one less bit
  output reg  [MEM_ADDR_WIDTH-2:0]         mem_b1_rd_addr,
  output reg                               mem_b1_rd_en,
  input  wire [DATA_WIDTH-1:0]             mem_b1_rd_data,

  output reg  [MEM_ADDR_WIDTH-2:0]         mem_b2_rd_addr,
  output reg                               mem_b2_rd_en,
  input  wire [DATA_WIDTH-1:0]             mem_b2_rd_data,

  // Read data output
  output wire [ACCEL_COUNT*DATA_WIDTH-1:0] m_axis_tdata,
  output wire [ACCEL_COUNT*MASK_BITS-1:0]  m_axis_tuser,
  output wire [ACCEL_COUNT-1:0]            m_axis_tlast,
  output wire [ACCEL_COUNT-1:0]            m_axis_tvalid,
  input  wire [ACCEL_COUNT-1:0]            m_axis_tready
);

// *** Parse the descriptor into memory address, offset, number of lines
// to be read, and last byte pointer in last read. *** //
localparam LINE_CNT_WIDTH = LEN_WIDTH-MASK_BITS;

reg [ACCEL_COUNT-1:0] accel_stop_r;

reg [MASK_BITS-1:0]      req_rd_offset;
reg [MASK_BITS-1:0]      req_rd_final_ptr;
reg [MEM_ADDR_WIDTH-1:0] req_rd_addr;
reg [LINE_CNT_WIDTH-1:0] req_rd_count;
reg                      req_rd_v;
reg [DEST_WIDTH-1:0]     req_rd_dest;
reg [ACCEL_COUNT-1:0]    req_rd_dest_1hot;

wire [MASK_BITS-1:0] remainder_bytes = desc_len [MASK_BITS-1:0];

always @ (posedge clk) begin
  req_rd_addr      <= desc_addr[ADDR_WIDTH-1:MASK_BITS];
  req_rd_offset    <= desc_addr[MASK_BITS-1:0];
  req_rd_count     <= (remainder_bytes == 0) ? desc_len [LEN_WIDTH-1:MASK_BITS] :
                                               desc_len [LEN_WIDTH-1:MASK_BITS]+1;
  req_rd_final_ptr <= remainder_bytes - 1; // 0 becomes all 1s
  req_rd_dest      <= desc_accel_id;
  req_rd_dest_1hot <= 1 << desc_accel_id;
  req_rd_v         <= desc_valid;

  if (rst)
    req_rd_v <= 1'b0;
end

// *** Active DMAs memory *** //
localparam DESC_MEM_WIDTH = MEM_ADDR_WIDTH+LINE_CNT_WIDTH+MASK_BITS+MASK_BITS;
(* ram_style = "distributed" *) reg [DESC_MEM_WIDTH-1:0] act_mem [ACCEL_COUNT-1:0];
reg [ACCEL_COUNT-1:0] act_mem_v;

wire [MEM_ADDR_WIDTH-1:0] act_rd_addr;
wire [LINE_CNT_WIDTH-1:0] act_rd_count;
wire [MASK_BITS-1:0]      act_rd_final_ptr;
wire [MASK_BITS-1:0]      act_rd_offset;

// arbiter signals
wire [DEST_WIDTH-1:0]     act_arb_enc;
wire                      act_arb_v;
wire [ACCEL_COUNT-1:0]    act_ack;

// MSB trim for next address and count
wire [MEM_ADDR_WIDTH-1:0] req_rd_addr_n  = req_rd_addr  + 1;
wire [LINE_CNT_WIDTH-1:0] req_rd_count_n = req_rd_count - 1;
wire [MEM_ADDR_WIDTH-1:0] act_rd_addr_n  = act_rd_addr  + 1;
wire [LINE_CNT_WIDTH-1:0] act_rd_count_n = act_rd_count - 1;
wire req_rd_last;

always @ (posedge clk)
  // req has priority over act
  if (req_rd_v)
    act_mem[req_rd_dest] <= {req_rd_addr_n, req_rd_count_n,
                             req_rd_final_ptr, req_rd_offset};
  else if (act_arb_v)
    act_mem[act_arb_enc] <= {act_rd_addr_n, act_rd_count_n,
                             act_rd_final_ptr, act_rd_offset};

always @ (posedge clk) begin
  if (req_rd_v && !req_rd_last)
    act_mem_v <= (act_mem_v | req_rd_dest_1hot) & ~accel_stop_r;
  else if (act_arb_v && (act_rd_count==1))
    act_mem_v <= (act_mem_v & ~act_ack) & ~accel_stop_r;
  else
    act_mem_v <= act_mem_v & ~accel_stop_r;

  if (rst)
    act_mem_v <= {ACCEL_COUNT{1'b0}};
end

assign {act_rd_addr, act_rd_count, act_rd_final_ptr, act_rd_offset} = act_mem[act_arb_enc];

// ** Arbiter among active memory entries ** //
wire [ACCEL_COUNT-1:0] accel_fifo_ready;

arbiter # (.PORTS(ACCEL_COUNT), .TYPE("ROUND_ROBIN")) act_arbiter (
  .clk (clk),
  .rst (rst),

  // if req_rd_v is asserted, last request was ignored
  .request      (req_rd_v ? (act_mem_v & accel_fifo_ready) :
                            (act_mem_v & accel_fifo_ready & ~act_ack)),
  .acknowledge  ({ACCEL_COUNT{1'b0}}),

  .grant        (act_ack),
  .grant_valid  (act_arb_v),
  .grant_encoded(act_arb_enc)
);

// Send request to memory, with an input register
reg [MASK_BITS-1:0]  mem_rd_offset, mem_rd_ptr;
reg [DEST_WIDTH-1:0] mem_rd_dest;
reg                  mem_rd_last, mem_rd_bank;

assign req_rd_last = (req_rd_count == 1);
wire   act_rd_last = (act_rd_count == 1);

wire [MASK_BITS-1:0] req_rd_ptr = req_rd_last ?
                                  req_rd_final_ptr : {MASK_BITS{1'b1}};
wire [MASK_BITS-1:0] act_rd_ptr = act_rd_last ?
                                  act_rd_final_ptr : {MASK_BITS{1'b1}};

wire [MEM_ADDR_WIDTH-1:0] mem_rd_addr   = req_rd_v ? req_rd_addr : act_rd_addr;
wire [MEM_ADDR_WIDTH-1:0] mem_rd_addr_n = mem_rd_addr+1;

always @ (posedge clk) begin
  mem_rd_ptr     <= req_rd_v ? req_rd_ptr : act_rd_ptr;
  mem_rd_offset  <= req_rd_v ? req_rd_offset : act_rd_offset;
  mem_rd_last    <= req_rd_v ? req_rd_last   : act_rd_last;
  mem_rd_dest    <= req_rd_v ? req_rd_dest   : act_arb_enc;

  mem_b1_rd_en   <= act_arb_v || req_rd_v;
  mem_b2_rd_en   <= act_arb_v || req_rd_v;

  mem_b1_rd_addr <= mem_rd_addr[0] ? mem_rd_addr_n[MEM_ADDR_WIDTH-1:1] :
                                     mem_rd_addr  [MEM_ADDR_WIDTH-1:1] ;
  mem_b2_rd_addr <= mem_rd_addr[0] ? mem_rd_addr  [MEM_ADDR_WIDTH-1:1] :
                                     mem_rd_addr_n[MEM_ADDR_WIDTH-1:1] ;
  mem_rd_bank    <= mem_rd_addr[0];

  if (rst) begin
    mem_b1_rd_en <= 1'b0;
    mem_b2_rd_en <= 1'b0;
  end
end

// Register memory output
reg [DATA_WIDTH-1:0] mem_b1_rd_data_rr, mem_b2_rd_data_rr;
reg                  mem_b1_rd_en_r, mem_b2_rd_en_r,
                     mem_rd_en_rr, mem_rd_en_rrr;

always @ (posedge clk) begin
  mem_b1_rd_data_rr <= mem_b1_rd_data;
  mem_b2_rd_data_rr <= mem_b2_rd_data;

  mem_b1_rd_en_r <= mem_b1_rd_en;
  mem_b2_rd_en_r <= mem_b2_rd_en;
  mem_rd_en_rr   <= mem_b1_rd_en_r;
  mem_rd_en_rrr  <= mem_rd_en_rr;
  if (rst) begin
    mem_b1_rd_en_r <= 1'b0;
    mem_b2_rd_en_r <= 1'b0;
    mem_rd_en_rr   <= 1'b0;
    mem_rd_en_rrr  <= 1'b0;
  end
end

// Accompanying metadata
reg                  mem_rd_last_r, mem_rd_last_rr, mem_rd_last_rrr;
reg                  mem_rd_bank_r, mem_rd_bank_rr;
reg [DEST_WIDTH-1:0] mem_rd_dest_r, mem_rd_dest_rr, mem_rd_dest_rrr;
reg [MASK_BITS-1:0]  mem_rd_offset_r, mem_rd_offset_rr;
reg [MASK_BITS-1:0]  mem_rd_ptr_r, mem_rd_ptr_rr, mem_rd_ptr_rrr;

always @ (posedge clk) begin
  mem_rd_last_r    <= mem_rd_last;
  mem_rd_last_rr   <= mem_rd_last_r;
  mem_rd_last_rrr  <= mem_rd_last_rr;
  mem_rd_dest_r    <= mem_rd_dest;
  mem_rd_dest_rr   <= mem_rd_dest_r;
  mem_rd_dest_rrr  <= mem_rd_dest_rr;
  mem_rd_offset_r  <= mem_rd_offset;
  mem_rd_offset_rr <= mem_rd_offset_r;
  mem_rd_bank_r    <= mem_rd_bank;
  mem_rd_bank_rr   <= mem_rd_bank_r;
  mem_rd_ptr_r     <= mem_rd_ptr;
  mem_rd_ptr_rr    <= mem_rd_ptr_r;
  mem_rd_ptr_rrr   <= mem_rd_ptr_rr;
end

reg [DATA_WIDTH-1:0] mem_rd_data_rrr;

always @ (posedge clk)
  mem_rd_data_rrr <= mem_rd_bank_rr ? ({mem_b1_rd_data_rr, mem_b2_rd_data_rr} >> (8*mem_rd_offset_rr)) :
                                      ({mem_b2_rd_data_rr, mem_b1_rd_data_rr} >> (8*mem_rd_offset_rr));

always @ (posedge clk) begin
  accel_stop_r <= accel_stop_r | accel_stop;
  if (desc_valid)
    accel_stop_r[desc_accel_id] <= 1'b0;
  if (rst)
    accel_stop_r <= {ACCEL_COUNT{1'b0}};
end

always @ (posedge clk) begin
  if (req_rd_v)
    accel_busy <= (accel_busy | req_rd_dest_1hot) & ~accel_stop_r &
                 ~(m_axis_tvalid & m_axis_tlast & m_axis_tready);
  else
    accel_busy <= accel_busy & ~accel_stop_r &
                ~(m_axis_tvalid & m_axis_tlast & m_axis_tready);

  if (rst)
    accel_busy <= {ACCEL_COUNT{1'b0}};
end

genvar i;
generate
  for (i=0; i<ACCEL_COUNT; i=i+1) begin: accel_rd_fifos

    // Counter to avoid overflow
    reg [$clog2(FIFO_LINES):0] counter;

    always @ (posedge clk) begin

      if (accel_stop_r[i])
        counter <= 0;
      else if (m_axis_tvalid[i] && m_axis_tready[i]) begin
        if (!(req_rd_v && req_rd_dest_1hot[i]) && !(act_arb_v && act_ack[i]))
          counter <= counter - 1;
        // else, both asserted, no change
      end else if ((req_rd_v && req_rd_dest_1hot[i]) || (act_arb_v && act_ack[i]))
        counter <= counter + 1;

      if (rst)
        counter <= 0;
    end

    // Gets simplified to single bit for FIFO_LINES power of 2
    assign accel_fifo_ready[i] = (counter < FIFO_LINES);

    simple_fifo # (
      .ADDR_WIDTH($clog2(FIFO_LINES)),
      .DATA_WIDTH(1+MASK_BITS+DATA_WIDTH)
    ) accel_fifo (
      .clk(clk),
      .rst(rst),
      .clear(accel_stop_r[i]),

      .din_valid(mem_rd_en_rrr && (mem_rd_dest_rrr==i)),
      .din({mem_rd_last_rrr, mem_rd_ptr_rrr, mem_rd_data_rrr}),
      .din_ready(),

      .dout_valid(m_axis_tvalid[i]),
      .dout({m_axis_tlast[i], m_axis_tuser[i*MASK_BITS+:MASK_BITS],
             m_axis_tdata[i*DATA_WIDTH+:DATA_WIDTH]}),
      .dout_ready(m_axis_tready[i])
    );

  end
endgenerate

endmodule

module accel_width_conv # (
  parameter DATA_IN_WIDTH  = 128,
  parameter DATA_OUT_WIDTH = 8,
  // TUSER is offset of last valid byte
  parameter USER_WIDTH     = $clog2(DATA_IN_WIDTH/8)
) (
  input  wire                      clk,
  input  wire                      rst,

  // Read data input
  input  wire [DATA_IN_WIDTH-1:0]  s_axis_tdata,
  input  wire [USER_WIDTH-1:0]     s_axis_tuser,
  input  wire                      s_axis_tlast,
  input  wire                      s_axis_tvalid,
  output wire                      s_axis_tready,

  // Read data output
  output reg  [DATA_OUT_WIDTH-1:0] m_axis_tdata,
  output reg                       m_axis_tlast,
  output reg                       m_axis_tvalid,
  input  wire                      m_axis_tready
);

    localparam SKIP_BITS = $clog2(DATA_OUT_WIDTH/8);
    localparam PTR_WIDTH = USER_WIDTH-SKIP_BITS;

    reg [PTR_WIDTH-1:0] rd_ptr;

    // out_ready works with accel always asserting tready or
    // accepting tvalid in same cycle
    wire out_ready  = !m_axis_tvalid || m_axis_tready;
    wire last_chunk = (rd_ptr==s_axis_tuser[USER_WIDTH-1:SKIP_BITS]);

    assign s_axis_tready = out_ready && last_chunk;

    always @ (posedge clk) begin
      // Since data is coming from a FIFO, tvalid drop without
      // tready assertion means there was a stop signal and
      // rd_ptr needs to be reset. In normal mode and no
      // tvalid it keeps the rd_ptr to be zero.
      if (!s_axis_tvalid)
        rd_ptr <= {PTR_WIDTH{1'b0}};
      else if (out_ready) begin
        if (last_chunk)
          rd_ptr <= {PTR_WIDTH{1'b0}};
        else
          rd_ptr <= rd_ptr + 1;
      end

      if (rst)
        rd_ptr <= {PTR_WIDTH{1'b0}};
    end

    // Register the outputs
    always @ (posedge clk) begin
      m_axis_tdata   <= s_axis_tdata[rd_ptr*DATA_OUT_WIDTH+:DATA_OUT_WIDTH];
      m_axis_tlast   <= s_axis_tlast && last_chunk;
      m_axis_tvalid  <= s_axis_tvalid;
    end

endmodule
