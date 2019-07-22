module riscv_axis_dma # (
  parameter DATA_WIDTH       = 64,   
  parameter ADDR_WIDTH       = 16,   
  parameter STRB_WIDTH       = (DATA_WIDTH/8),
  parameter PORT_COUNT       = 4,
  parameter SLOT_COUNT       = 4,
  parameter INTERLEAVE       = 0,
  parameter LEN_WIDTH        = 16,
  parameter LEAD_ZERO        = 8,
  parameter PORT_WIDTH       = $clog2(PORT_COUNT),
  parameter DEST_WIDTH_IN    = ADDR_WIDTH-LEAD_ZERO,
  parameter DEST_WIDTH_OUT   = PORT_WIDTH,
  parameter USER_WIDTH_IN    = PORT_WIDTH,
  parameter USER_WIDTH_OUT   = ADDR_WIDTH-LEAD_ZERO
)(
  input  wire                      clk,
  input  wire                      rst,

  // ---------------- AXIS INTERFACE --------------- // 
  // Incoming data
  input  wire [DATA_WIDTH-1:0]     s_axis_tdata,
  input  wire [STRB_WIDTH-1:0]     s_axis_tkeep,
  input  wire                      s_axis_tvalid,
  output wire                      s_axis_tready,
  input  wire                      s_axis_tlast,
  // tdest is the MSB of start address
  input  wire [DEST_WIDTH_IN-1:0]  s_axis_tdest,
  // tuser is the incoming port 
  input  wire [USER_WIDTH_IN-1:0]  s_axis_tuser,
  
  // Outgoing data
  output wire [DATA_WIDTH-1:0]     m_axis_tdata,
  output wire [STRB_WIDTH-1:0]     m_axis_tkeep,
  output wire                      m_axis_tvalid,
  input  wire                      m_axis_tready,
  output wire                      m_axis_tlast,
  output wire [DEST_WIDTH_OUT-1:0] m_axis_tdest,
  // tuser is the MSB of original slot start address
  output wire [USER_WIDTH_OUT-1:0] m_axis_tuser,

  // -------------- MEMORY INTERFACE -------------- // 
  // Write port
  output wire                      mem_wr_en,
  output wire [STRB_WIDTH-1:0]     mem_wr_strb,
  output wire [ADDR_WIDTH-1:0]     mem_wr_addr,
  output wire [DATA_WIDTH-1:0]     mem_wr_data,
  output wire                      mem_wr_last,
  input  wire                      mem_wr_ready,

  // Read port
  output wire                      mem_rd_en,
  output wire [ADDR_WIDTH-1:0]     mem_rd_addr,
  output wire                      mem_rd_last,
  input  wire                      mem_rd_ready,

  input  wire [DATA_WIDTH-1:0]     mem_rd_data,
  input  wire                      mem_rd_data_v,
  output wire                      mem_rd_data_ready,
 
  // ---------------- DESCRIPTORS ----------------- //
  // Output receive descriptor
  output wire                      recv_desc_valid,
  input  wire                      recv_desc_ready,
  output wire [63:0]               recv_desc,

  // Input send descriptor
  input  wire                      send_desc_valid,
  output wire                      send_desc_ready,
  input  wire [63:0]               send_desc,
  output wire                      pkt_sent
);

  // A pipeline register for the input and converting to 
  // native memory interface based on start address in tuser
  reg                      wr_data_en;
  reg  [DATA_WIDTH-1:0]    wr_data;
  reg  [STRB_WIDTH-1:0]    wr_strb;
  reg                      wr_last;
  reg  [DEST_WIDTH_IN-1:0] wr_dest;
  reg  [USER_WIDTH_IN-1:0] wr_user;
  wire [ADDR_WIDTH-1:0]    wr_addr;
  reg  [ADDR_WIDTH-1:0]    next_wr_addr;
  reg                      wr_first_pkt;
  wire                     wr_ready;

  // Latch the start address, incoming port and slot for creating descriptor
  reg [ADDR_WIDTH-1:0]    wr_start_addr;
  reg [PORT_WIDTH-1:0]    incoming_port;
  reg [DEST_WIDTH_IN-1:0] wr_slot;
  reg [LEN_WIDTH-1:0]     wr_pkt_len;

  always @ (posedge clk)
    if (rst) begin
      wr_data_en <= 1'b0;
    end else begin
      wr_data_en <= (s_axis_tvalid && s_axis_tready) ||
                    (wr_data_en && (~wr_ready));
    end
  
  always @ (posedge clk) 
    if (s_axis_tvalid && s_axis_tready) begin
      wr_data <= s_axis_tdata;
      wr_strb <= s_axis_tkeep;
      wr_last <= s_axis_tlast;
      wr_dest <= s_axis_tdest;
      wr_user <= s_axis_tuser;
    end
  
  assign s_axis_tready = wr_ready;
  
  always @ (posedge clk)
    if (rst)
      wr_first_pkt <= 1'b0;
    else
      wr_first_pkt <= ((((~wr_data_en) || (wr_data_en && wr_last))
                       && s_axis_tvalid && wr_ready) 
                       || (wr_first_pkt && (~wr_ready)));
  
  wire wr_last_pkt = wr_data_en && wr_ready && wr_last;
  reg  wr_last_pkt_r;

  always @ (posedge clk) begin
    wr_last_pkt_r   <= wr_last_pkt;
    if (wr_data_en && wr_ready)
      next_wr_addr    <= wr_addr + STRB_WIDTH;
    if (wr_first_pkt) begin
      wr_start_addr <= {wr_dest,{LEAD_ZERO{1'b0}}};
      wr_slot       <= wr_dest;
      incoming_port <= wr_user;
    end
  end
  
  assign wr_addr = wr_first_pkt ? {wr_dest,{LEAD_ZERO{1'b0}}} : next_wr_addr;

  reg [$clog2(STRB_WIDTH)-1:0] one_count;
  integer i;
  
  always @ (*) begin
    one_count = STRB_WIDTH;
    for (i=STRB_WIDTH-1; i>=0; i=i-1)
      if (!wr_strb[i])
        one_count = i;
  end

  always @ (posedge clk)
    if (rst)
        wr_pkt_len <= 0;
    else if (wr_first_pkt) begin
      if(!wr_ready)
        wr_pkt_len <= 0;
      else if (wr_ready && wr_last)
        wr_pkt_len <= one_count;
      else if (wr_ready)
        wr_pkt_len <= STRB_WIDTH;
    end else if (wr_data_en && wr_ready) begin
      if (wr_last)
        wr_pkt_len <= wr_pkt_len + one_count;
      else
        wr_pkt_len <= wr_pkt_len + STRB_WIDTH;
    end
    
  wire desc_fifo_ready, desc_v, desc_deque;
  wire [ADDR_WIDTH-1:0]    base_addr;
  wire [PORT_WIDTH-1:0]    pkt_port;
  wire [DEST_WIDTH_IN-1:0] pkt_slot;
  wire [LEN_WIDTH-1:0]     pkt_len;
  
  simple_fifo # (
    .ADDR_WIDTH($clog2(SLOT_COUNT)),
    .DATA_WIDTH(ADDR_WIDTH+PORT_WIDTH+DEST_WIDTH_IN+LEN_WIDTH)
  ) recvd_desc_fifo (
    .clk(clk),
    .rst(rst),
  
    .din_valid(wr_last_pkt_r),
    .din({wr_start_addr, incoming_port, wr_slot, wr_pkt_len}),
    .din_ready(desc_fifo_ready),
   
    .dout_valid(desc_v),
    .dout({base_addr, pkt_port, pkt_slot, pkt_len}),
    .dout_ready(desc_deque)
  );
  
  assign recv_desc_valid = desc_v;
  assign desc_deque = recv_desc_ready;
  assign recv_desc  = {base_addr, 
                    {(8-PORT_WIDTH){1'b0}},pkt_port,
                    {(8-DEST_WIDTH_IN){1'b0}},pkt_slot,
                    {(16-LEN_WIDTH){1'b0}},pkt_len};

  assign mem_wr_en   = wr_data_en;
  assign mem_wr_strb = wr_strb;
  assign mem_wr_addr = wr_addr;
  assign mem_wr_data = wr_data;
  assign mem_wr_last = wr_last_pkt;
  assign wr_ready    = mem_wr_ready;

  // READ PORTION
  
  // STATES
  localparam IDLE = 2'b00;
  localparam INIT = 2'b01;
  localparam PROC = 2'b10;
  localparam ERR  = 2'b11;
  
  reg [1:0] state_r, state_n;

  always @ (posedge clk)
    if (rst)
      state_r <= IDLE;
    else
      state_r <= state_n;
  
  always @ (*) begin
    state_n = state_r;
    case (state_r)
      IDLE: if (send_desc_valid) state_n = INIT;
      INIT: state_n = PROC;
      PROC: if (pkt_sent) state_n = IDLE;
      ERR:  state_n = ERR;
    endcase
  end
  
  // Parsing the descriptor
  reg [ADDR_WIDTH-1:0]     send_base_addr;
  reg [LEN_WIDTH-1:0]      send_len;
  reg [PORT_WIDTH-1:0]     send_port;
  reg [USER_WIDTH_OUT-1:0] send_orig_addr;
  reg [MASK_BITS:0]        remainder_bytes;
  
  localparam MASK_BITS = $clog2(STRB_WIDTH);
  
  always @ (posedge clk)
    if (send_desc_ready && send_desc_valid) begin
      send_base_addr  <= send_desc[ADDR_WIDTH+31:32];
      send_len        <= send_desc[LEN_WIDTH-1:0];
      send_port       <= send_desc[PORT_WIDTH+23:24];
      send_orig_addr  <= send_desc[USER_WIDTH_OUT+15:16];
      // Lower bits of base_addr and send_len
      remainder_bytes <= send_desc[MASK_BITS+31:32] +
                         send_desc[MASK_BITS-1:0];
    end
  
  assign send_desc_ready = (state_r == IDLE);
  assign pkt_sent        = (m_axis_tvalid && 
                            m_axis_tready && m_axis_tlast);

  // Calculating offset, number of words and final tkeep in INIT state

  reg [ADDR_WIDTH-1:0]          alligned_rd_addr;
  reg [MASK_BITS-1:0]           rd_offset;
  reg [LEN_WIDTH-MASK_BITS-1:0] rd_word_count;
  reg [STRB_WIDTH-1:0]          rd_final_tkeep;

  wire [1:0]            extra_words = (remainder_bytes == 0) ? 2'd0: 
                                      (remainder_bytes[MASK_BITS] + 2'd1); 
  // 0 becomes 0 due to dropping the MSB. 
  wire [MASK_BITS-1:0] tkeep_zeros  = STRB_WIDTH - 
                                      send_len[MASK_BITS-1:0];

  // Add tuser and tdest or mayybe last always block is enough
  always @ (posedge clk) begin
    if (rst) begin
      rd_offset        <= 0;
      rd_word_count    <= 0;
      rd_final_tkeep   <= {STRB_WIDTH{1'b1}};
    end
    if (state_r==IDLE) begin
      rd_offset        <= 0;
      rd_word_count    <= 0;
      rd_final_tkeep   <= {STRB_WIDTH{1'b1}};
    end 
    else if (state_r==INIT) begin
      rd_offset        <= send_base_addr[MASK_BITS-1:0];
      rd_word_count    <= send_len[LEN_WIDTH-1:MASK_BITS] + extra_words;
      rd_final_tkeep   <= {{(STRB_WIDTH-1){1'b0}},{STRB_WIDTH{1'b1}}} >> tkeep_zeros;
      alligned_rd_addr <= {send_base_addr[ADDR_WIDTH-1:MASK_BITS],{MASK_BITS{1'b0}}};
    
    end 
    else if (mem_rd_en && mem_rd_ready) begin
      rd_word_count    <= rd_word_count - 1; 
      alligned_rd_addr <= alligned_rd_addr + STRB_WIDTH;
    end
  end

  // PROC state, 2 pipeline registers for data and selecting the output 
  // based on offset
  reg  [DATA_WIDTH-1:0] read_reg_1;
  reg  [DATA_WIDTH-1:0] read_reg_2;
  reg read_reg_1_v, read_reg_2_v;

  reg [1:0] data_left;
  // data left is for last 2 words in pipe. Depending on the offset 
  // they should be transfered in one transaction or two. 
  always @ (posedge clk)
    if (rst)
      data_left <= 2'd0;
    else if (state_r !== PROC)
      data_left <= 2'd0;
    else if ((rd_word_count == 0) && mem_rd_data_ready && mem_rd_data_v)
      if (rd_offset == 0)
        data_left <= 2'd2;
      // If the remainder bytes don't cause overflow to next word, 
      // It means there are 2 words left to be sent. 
      else if (!remainder_bytes[MASK_BITS])
        data_left <= 2'd2;
      else 
        data_left <= 2'd1;
    // If data/empty register is sent out reduce remaining
    else if ((data_left>2'd0) && (!(m_axis_tvalid && !m_axis_tready)))
        data_left <= data_left - 2'd1;

  // 2 pipe registers with valid. There is no need for individual ready signals 
  always @ (posedge clk) begin
    if (rst) begin
      read_reg_1_v <= 1'b0;
      read_reg_2_v <= 1'b0;
    end 
    // since mem_rd_data_ready is high when m_axis_tready,
    // is asserted, it means the data can go out and I would have 
    // space on read_reg_2
    if (mem_rd_data_v && mem_rd_data_ready) begin
      read_reg_1   <= mem_rd_data;
      read_reg_1_v <= 1'b1;
      read_reg_2   <= read_reg_1;
      read_reg_2_v <= read_reg_1_v;
    end 
    // emptying the pipe if it's not blocked by axis
    else if ((data_left!=2'd0) && (!(m_axis_tvalid && !m_axis_tready))) begin
      read_reg_1_v <= 1'b0;
      read_reg_2   <= read_reg_1;
      // If there are 2 words read_reg_2 stays valid for another cycle
      // otherwise both registers become not valid 
      read_reg_2_v <= (data_left==2'd2);
    end
  end

  // If I'm not ready to get data then I deassert my address valid too. 
  // The sender module has to keep its valid and data until ready! 
  assign mem_rd_data_ready = !(m_axis_tvalid && (!m_axis_tready));
  assign mem_rd_en         = (rd_word_count > 0) && mem_rd_data_ready;
  assign mem_rd_addr       = alligned_rd_addr;
  assign mem_rd_last       = (rd_word_count == 1);

  assign m_axis_tdata  = {read_reg_1,read_reg_2} >> {rd_offset,3'd0};
  assign m_axis_tvalid = read_reg_2_v;
  assign m_axis_tlast  = (data_left == 2'd1);
  assign m_axis_tkeep  = m_axis_tlast ? rd_final_tkeep : {STRB_WIDTH{1'b1}};
  assign m_axis_tdest  = send_port;
  assign m_axis_tuser  = send_orig_addr;

endmodule
