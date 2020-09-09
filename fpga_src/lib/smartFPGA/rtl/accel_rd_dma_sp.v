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
  input                       clk,
  input                       rst,

  // Desc input
  input  [DEST_WIDTH-1:0]     desc_accel_id,
  input  [ADDR_WIDTH-1:0]     desc_addr,
  input  [LEN_WIDTH-1:0]      desc_len,
  input                       desc_valid,
  output [ACCEL_COUNT-1:0]    accel_busy,

  // Memory read channels per bank, 
  // each channel address has one less bit
  output [MEM_ADDR_WIDTH-2:0] mem_b1_rd_addr,
  output                      mem_b1_rd_en,
  input  [DATA_WIDTH-1:0]     mem_b1_rd_data,
  
  output [MEM_ADDR_WIDTH-2:0] mem_b2_rd_addr,
  output                      mem_b2_rd_en,
  input  [DATA_WIDTH-1:0]     mem_b2_rd_data,

  // Read data output
  output [ACCEL_COUNT*8-1:0]  m_axis_tdata,
  output [ACCEL_COUNT-1:0]    m_axis_tlast,
  output [ACCEL_COUNT-1:0]    m_axis_tvalid,
  input  [ACCEL_COUNT-1:0]    m_axis_tready,
  input  [ACCEL_COUNT-1:0]    m_axis_stop
);

// *** First step of processing descriptor *** //
localparam LINE_CNT_WIDTH = LEN_WIDTH-MASK_BITS;

reg [MASK_BITS:0]        remainder_bytes;
reg [MASK_BITS-1:0]      rd_offset;
reg [MEM_ADDR_WIDTH-1:0] init_rd_addr;
reg [LINE_CNT_WIDTH-1:0] init_rd_count;
reg                      desc_v1;
reg [DEST_WIDTH-1:0]     desc_accel_id_r;

always @ (posedge clk) begin
  init_rd_addr    <= desc_addr[ADDR_WIDTH-1:MASK_BITS];
  rd_offset       <= desc_addr[MASK_BITS-1:0];
  init_rd_count   <= desc_len [LEN_WIDTH-1:MASK_BITS];
  remainder_bytes <= desc_len [MASK_BITS-1:0];
  desc_accel_id_r <= desc_accel_id;
  desc_v1         <= desc_valid;

  if (rst)
    desc_v1 <= 1'b0;
end

// *** Second step of processing descriptor and writing to req mem *** //

wire [LINE_CNT_WIDTH-1:0] rd_count_adjusted = (remainder_bytes == 0) ?
                                              init_rd_count : (init_rd_count+1);
wire [MASK_BITS-1:0]      rd_final_ptr      = remainder_bytes - 1;  
                                              // 0 becomes all 1s
wire [MEM_ADDR_WIDTH-1:0] req_rd_addr;
wire [LINE_CNT_WIDTH-1:0] req_rd_count;
wire [MASK_BITS-1:0]      req_rd_final_ptr;
wire [MASK_BITS-1:0]      req_rd_offset;

wire [ACCEL_COUNT-1:0] req_ack;
wire [DEST_WIDTH-1:0]  req_arb_enc;
wire                   req_arb_v;

wire [MEM_ADDR_WIDTH-1:0] req_rd_addr_n;
wire [LINE_CNT_WIDTH-1:0] req_rd_count_n;

localparam DESC_MEM_WIDTH = MEM_ADDR_WIDTH+LINE_CNT_WIDTH+MASK_BITS+MASK_BITS;
(* ram_style = "distributed" *) reg [DESC_MEM_WIDTH-1:0] req_mem [ACCEL_COUNT-1:0];
reg [ACCEL_COUNT-1:0] req_mem_v;

always @ (posedge clk)
  if (desc_v1)
    req_mem[desc_accel_id_r] <= {init_rd_addr, rd_count_adjusted, rd_final_ptr, rd_offset};

assign {req_rd_addr, req_rd_count, req_rd_final_ptr, req_rd_offset} = req_mem[req_arb_enc];

assign req_rd_addr_n  = req_rd_addr + 1;
assign req_rd_count_n = req_rd_count - 1;

always @ (posedge clk) begin
  if (desc_v1)
    req_mem_v[desc_accel_id_r] <= 1'b1;

  if (req_ack)
    req_mem_v[req_arb_enc] <= 1'b0;

  if (rst)
    req_mem_v <= {ACCEL_COUNT{1'b0}};

end

reg [ACCEL_COUNT-1:0]    accel_stop_r;
always @ (posedge clk) begin
  accel_stop_r <= accel_stop_r | m_axis_stop;
  if (desc_v1)
    accel_stop_r[desc_accel_id_r] <= 1'b0;
  if (rst)
    accel_stop_r <= {ACCEL_COUNT{1'b0}};
end

assign accel_busy = req_mem_v | act_mem_v;

// *** Active DMAs memory *** //
wire [DEST_WIDTH-1:0]     act_arb_enc;
wire                      act_arb_v;

wire [MEM_ADDR_WIDTH-1:0] act_rd_addr;
wire [LINE_CNT_WIDTH-1:0] act_rd_count;
wire [MASK_BITS-1:0]      act_rd_final_ptr;
wire [MASK_BITS-1:0]      act_rd_offset;

wire [MEM_ADDR_WIDTH-1:0] act_rd_addr_n;
wire [LINE_CNT_WIDTH-1:0] act_rd_count_n;

(* ram_style = "distributed" *) reg [DESC_MEM_WIDTH-1:0] act_mem [ACCEL_COUNT-1:0];
reg [ACCEL_COUNT-1:0] act_mem_v;

assign act_rd_addr_n  = act_rd_addr + 1;
assign act_rd_count_n = act_rd_count - 1;

always @ (posedge clk)
  // req has priority over act
  if (req_arb_v) begin
    act_mem[req_arb_enc] <= {req_rd_addr_n, req_rd_count_n, 
                             req_rd_final_ptr, req_rd_offset};
  end else if (act_arb_v) begin
    act_mem[act_arb_enc] <= {act_rd_addr_n, act_rd_count_n, 
                             act_rd_final_ptr, act_rd_offset};
  end

wire [ACCEL_COUNT-1:0] act_ack;

always @ (posedge clk) begin
  // req has priority over act
  if (req_arb_v)
    act_mem_v <= (act_mem_v | req_ack) & ~accel_stop_r;
  else if (act_arb_v && (act_rd_count==1))
    act_mem_v <= (act_mem_v & ~act_ack) & ~accel_stop_r;
  else
    act_mem_v <= act_mem_v & ~accel_stop_r;

  if (rst)
    act_mem_v <= {ACCEL_COUNT{1'b0}};

end

assign {act_rd_addr, act_rd_count, act_rd_final_ptr, act_rd_offset} = act_mem[act_arb_enc];

// ** Arbiter among both active mem and req mem entries ** //

wire [ACCEL_COUNT-1:0] accel_fifo_ready; // maybe almost full or block for a while

arbiter # (.PORTS(ACCEL_COUNT), .TYPE("ROUND_ROBIN")) req_arbiter (
  .clk (clk),
  .rst (rst),

  .request      (req_mem_v & ~req_ack & accel_fifo_ready),
  .acknowledge  ({ACCEL_COUNT{1'b0}}),

  .grant        (req_ack),
  .grant_valid  (req_arb_v),
  .grant_encoded(req_arb_enc)
);


arbiter # (.PORTS(ACCEL_COUNT), .TYPE("ROUND_ROBIN")) act_arbiter (
  .clk (clk),
  .rst (rst),

  .request      (req_arb_v ? act_mem_v & accel_fifo_ready : (act_mem_v & ~act_ack & accel_fifo_ready)),
  .acknowledge  ({ACCEL_COUNT{1'b0}}),

  .grant        (act_ack),
  .grant_valid  (act_arb_v),
  .grant_encoded(act_arb_enc)
);

// Send request to memory and register the output
// req has priority over act
wire [MASK_BITS-1:0] req_rd_ptr, act_rd_ptr;
wire                 req_rd_last, act_rd_last;

assign req_rd_last = (req_rd_count == 1);
assign act_rd_last = (act_rd_count == 1);

assign req_rd_ptr = req_rd_last ? req_rd_final_ptr : {MASK_BITS{1'b1}};
assign act_rd_ptr = req_rd_last ? act_rd_final_ptr : {MASK_BITS{1'b1}};

wire [MEM_ADDR_WIDTH-1:0] mem_rd_addr, mem_rd_addr_n;
wire [MASK_BITS-1:0] mem_rd_offset, mem_rd_ptr;
wire mem_rd_last, mem_rd_en;
wire [DEST_WIDTH-1:0] mem_rd_dest;

assign mem_rd_ptr    = req_arb_v ? req_rd_ptr : act_rd_ptr;
assign mem_rd_addr   = req_arb_v ? req_rd_addr : act_rd_addr;

assign mem_rd_offset = req_arb_v ? req_rd_offset : act_rd_offset;
assign mem_rd_ptr    = req_arb_v ? req_rd_ptr    : act_rd_ptr;
assign mem_rd_last   = req_arb_v ? req_rd_last   : act_rd_last;
assign mem_rd_dest   = req_arb_v ? req_arb_enc   : act_arb_enc;
assign mem_rd_en     = act_arb_v || req_arb_v;

assign mem_rd_addr_n = mem_rd_addr+1;
assign mem_b1_rd_addr = mem_rd_addr[0] ? mem_rd_addr_n[MEM_ADDR_WIDTH-1:1] :
                                         mem_rd_addr  [MEM_ADDR_WIDTH-1:1]; 
assign mem_b2_rd_addr = mem_rd_addr[0] ? mem_rd_addr  [MEM_ADDR_WIDTH-1:1] : 
                                         mem_rd_addr_n[MEM_ADDR_WIDTH-1:1]; 
assign mem_b1_rd_en   = mem_rd_en;
assign mem_b2_rd_en   = mem_rd_en;

// Register memory output

reg [DATA_WIDTH-1:0] mem_b1_rd_data_rr, mem_b2_rd_data_rr;
reg                  mem_rd_en_r, mem_rd_en_rr, mem_rd_en_rrr;

always @ (posedge clk) begin
  mem_b1_rd_data_rr <= mem_b1_rd_data;
  mem_b2_rd_data_rr <= mem_b2_rd_data;

  mem_rd_en_r   <= mem_rd_en;
  mem_rd_en_rr  <= mem_rd_en_r;
  mem_rd_en_rrr <= mem_rd_en_rr;
  if (rst) begin
    mem_rd_en_r   <= 1'b0;
    mem_rd_en_rr  <= 1'b0;
    mem_rd_en_rrr <= 1'b0;
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
  mem_rd_bank_r    <= mem_rd_addr[0];
  mem_rd_bank_rr   <= mem_rd_bank_r;
  mem_rd_ptr_r     <= mem_rd_ptr;
  mem_rd_ptr_rr    <= mem_rd_ptr_r;
  mem_rd_ptr_rrr   <= mem_rd_ptr_rr;
end

reg [DATA_WIDTH-1:0] mem_rd_data_rrr; 

always @ (posedge clk)
  mem_rd_data_rrr <= mem_rd_bank_rr ? ({mem_b1_rd_data_rr, mem_b2_rd_data_rr} >> (8*mem_rd_offset_rr)) : 
                                      ({mem_b2_rd_data_rr, mem_b1_rd_data_rr} >> (8*mem_rd_offset_rr));

genvar i;
generate
  for (i=0; i<ACCEL_COUNT; i=i+1) begin: accel_rd_fifos
    // FIFO outputs
    wire [MASK_BITS-1:0]  last_ptr;
    wire [DATA_WIDTH-1:0] accel_data;
    wire                  last_line, fifo_valid;

    reg  [MASK_BITS-1:0]  accel_ptr;
    reg  [7:0]            out_byte;
    reg                   out_last, out_valid;
    
    // Works with accel always asserting tready or 
    // accepting tvalid in same cycle
    wire out_ready = !m_axis_tvalid[i] || m_axis_tready[i];

    reg [$clog2(FIFO_LINES):0] counter;

    always @ (posedge clk) begin
      if (accel_stop_r[i]) 
        counter <= 0;
      else if (fifo_valid && out_ready && (accel_ptr==last_ptr)) begin
        if (!req_arb_v && !act_arb_v)
          counter <= counter - 1;
      end else if ((req_arb_v && req_ack[i]) ||
                   (act_arb_v && act_ack[i]))
        counter <= counter + 1;
      
      if (rst)
        counter <= 0;
    end
    
    // Gets simplified to single bit for FIFO_LINES power of 2
    assign accel_fifo_ready[i] = (counter <FIFO_LINES);

    simple_fifo # (
      .ADDR_WIDTH(1),
      .DATA_WIDTH(1+MASK_BITS+DATA_WIDTH)
    ) accel_fifo (
      .clk(clk),
      .rst(rst),
      .clear(accel_stop_r[i]),

      .din_valid(mem_rd_en_rrr && (mem_rd_dest_rrr==i)),
      .din({mem_rd_last_rrr, mem_rd_ptr_rrr, mem_rd_data_rrr}),
      .din_ready(),

      .dout_valid(fifo_valid),
      .dout({last_line, last_ptr, accel_data}),
      .dout_ready(out_ready && (accel_ptr==last_ptr))
    );

    always @ (posedge clk) begin
      if (fifo_valid && out_ready) begin
        if (accel_ptr==last_ptr)
          accel_ptr <= {MASK_BITS{1'b0}};
        else
          accel_ptr <= accel_ptr + 1;
      end

      if (rst)
        accel_ptr <= {MASK_BITS{1'b0}};
    end

    always @ (posedge clk) begin
      out_byte  <= accel_data[accel_ptr*8+:8];
      out_last  <= last_line && (accel_ptr==last_ptr);
      out_valid <= fifo_valid;
    end
      
    assign m_axis_tlast[i]      = out_last;
    assign m_axis_tdata[8*i+:8] = out_byte;
    assign m_axis_tvalid[i]     = out_valid;
      
  end
endgenerate

endmodule
