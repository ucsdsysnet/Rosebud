module riscv_axis_dma # (
  parameter DATA_WIDTH       = 64,   
  parameter ADDR_WIDTH       = 16,   
  parameter STRB_WIDTH       = (DATA_WIDTH/8),
  parameter PORT_COUNT       = 4,
  parameter RECV_DESC_DEPTH  = 8,
  parameter INTERLEAVE       = 0,
  parameter LEN_WIDTH        = 16,
  parameter ADDR_LEAD_ZERO   = 8,
  parameter PORT_WIDTH       = $clog2(PORT_COUNT),
  parameter DEST_WIDTH_IN    = ADDR_WIDTH-ADDR_LEAD_ZERO,
  parameter DEST_WIDTH_OUT   = PORT_WIDTH,
  parameter USER_WIDTH_IN    = PORT_WIDTH,
  parameter USER_WIDTH_OUT   = ADDR_WIDTH-ADDR_LEAD_ZERO,
  parameter MASK_BITS        = $clog2(STRB_WIDTH)
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

  ////////////////////////////////////////////////////////////////////////////////
  ///////////////////////// WRITE FROM AXIS TO MEM ///////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////

  // A pipeline register for the input from AXIS 
  reg                      wr_data_en;
  reg  [DATA_WIDTH-1:0]    wr_data_1;
  reg  [STRB_WIDTH-1:0]    wr_strb_1;
  reg  [DATA_WIDTH-1:0]    wr_data_2;
  reg  [STRB_WIDTH-1:0]    wr_strb_2;
  reg                      wr_last;
  reg                      extra_cycle_r;
  wire [ADDR_WIDTH-1:0]    wr_addr;
  reg  [ADDR_WIDTH-1:0]    next_wr_addr;
  reg                      wr_first_pkt;
  wire                     wr_ready;
  
  wire [ADDR_WIDTH-1:0] full_addr = {s_axis_tdest,{(ADDR_LEAD_ZERO-4){1'b0}},4'h2};

  // For first data, Latch the start address, incoming port and slot 
  // for creating descriptor
  reg [ADDR_WIDTH-1:0]    wr_start_addr;
  reg [PORT_WIDTH-1:0]    incoming_port;
  reg  [MASK_BITS:0]      wr_offset;
  reg [DEST_WIDTH_IN-1:0] wr_slot;
  
  wire latch_info = (((~wr_data_en) || (wr_last_pkt && wr_ready)) 
                      && s_axis_tvalid && s_axis_tready);

  // Latch metadata in first cycle
  // Also move forward the pipeline when data is sent
  always @ (posedge clk) begin
    if (latch_info) begin
      wr_start_addr <= full_addr;
      wr_offset     <= {1'b1,{MASK_BITS{1'b0}}} - {1'b0, full_addr[MASK_BITS-1:0]};
      wr_slot       <= s_axis_tdest;
      incoming_port <= s_axis_tuser;
    end
  
    if (extra_cycle && wr_data_en && wr_ready) begin
      wr_strb_1 <= {STRB_WIDTH{1'b0}};
      wr_last   <= 1'b0;
    end else if (s_axis_tvalid && s_axis_tready) begin
      wr_data_1 <= s_axis_tdata;
      wr_strb_1 <= s_axis_tkeep;
      wr_last   <= s_axis_tlast;
    end

    if (wr_data_en && wr_ready) begin
      wr_data_2 <= wr_data_1;
      extra_cycle_r <= extra_cycle;
    end

    // invalidate the data in last stage
    if (wr_last_pkt && wr_ready) 
      wr_strb_2 <= {STRB_WIDTH{1'b0}};
    else if (wr_data_en && wr_ready) 
      wr_strb_2 <= wr_strb_1;

    if (rst) begin
      wr_last <= 1'b0;
      extra_cycle_r <= 1'b0;
      wr_strb_1 <= {STRB_WIDTH{1'b0}};
      wr_strb_2 <= {STRB_WIDTH{1'b0}};
    end
  end
  
  wire extra_cycle = wr_last && (|(wr_strb_1 >> wr_offset));

  // Simple valid_ready control. If we can write out we can read in.
  // So axis_ready is connected to mem ready and write en to mem
  // is asserted when there is new data or stays asserted if it was 
  // not taken. Also if the data is taken but it needs extra cycle 
  // it stays valid.
  always @ (posedge clk)
    if (rst)
      wr_data_en <= 1'b0;
    else
      wr_data_en <= (s_axis_tvalid && s_axis_tready) ||
                    (wr_data_en && (~wr_ready)) || 
                    (wr_data_en && wr_ready && extra_cycle);

  assign s_axis_tready = wr_ready & (~extra_cycle);

  // First packet is when there is new data and can be accpted 
  // (wr_ready is s_axis_tready). It can happen if there was 
  // no data last cycle, or if there was and it was last data.
  // Also if the data cannot go out it keeps its first_pkt state 
  always @ (posedge clk)
    if (rst)
      wr_first_pkt <= 1'b0;
    else 
      wr_first_pkt <= latch_info || (wr_first_pkt && !wr_ready);
      
  // If there is need for extra cycle the wr_last_pkt would be asserted then
  wire wr_last_pkt = wr_data_en && ((wr_last && !extra_cycle) || (extra_cycle_r));
  reg  wr_last_pkt_r;  // Used for enquing the descriptor FIFO
  always @ (posedge clk)
    wr_last_pkt_r  <= wr_last_pkt && wr_ready;
  
  // Calculating the write address
  always @ (posedge clk)
    if (wr_data_en && wr_ready)
      next_wr_addr <= wr_addr + STRB_WIDTH;
  
  wire [ADDR_WIDTH-1:0] wr_aligned_addr = {wr_start_addr[ADDR_WIDTH-1:MASK_BITS],{MASK_BITS{1'b0}}};
  assign wr_addr = wr_first_pkt ? wr_aligned_addr : next_wr_addr;
  
  // count number of bytes in the last data 
  // It can accept zeros in the input strb
  reg [$clog2(STRB_WIDTH):0] one_count;
  integer i;
  always @ (*) begin
    one_count = STRB_WIDTH;
    for (i=STRB_WIDTH-1; i>=0; i=i-1)
      if (!mem_wr_strb[i])
        one_count = one_count-1;
  end

  // Calculate total bytes 
  reg [LEN_WIDTH-1:0] wr_pkt_len;
  always @ (posedge clk)
    if (rst)
        wr_pkt_len <= 0;
    else if (wr_data_en && wr_ready) begin 
      if (wr_first_pkt)
        wr_pkt_len <= one_count;
      else
        wr_pkt_len <= wr_pkt_len + one_count;
    end
    
  // Descriptor FIFO. One cycle after last data is transmitted
  // the descriptor is ready to be enqued 
  wire desc_fifo_ready;
  wire [ADDR_WIDTH-1:0]    base_addr;
  wire [PORT_WIDTH-1:0]    pkt_port;
  wire [DEST_WIDTH_IN-1:0] pkt_slot;
  wire [LEN_WIDTH-1:0]     pkt_len;
  
  simple_fifo # (
    .ADDR_WIDTH($clog2(RECV_DESC_DEPTH)),
    .DATA_WIDTH(ADDR_WIDTH+PORT_WIDTH+DEST_WIDTH_IN+LEN_WIDTH)
  ) recvd_desc_fifo (
    .clk(clk),
    .rst(rst),
  
    .din_valid(wr_last_pkt_r),
    .din({wr_start_addr, incoming_port, wr_slot, wr_pkt_len}),
    .din_ready(desc_fifo_ready),
   
    .dout_valid(recv_desc_valid),
    .dout({base_addr, pkt_port, pkt_slot, pkt_len}),
    .dout_ready(recv_desc_ready)
  );

  // Making the desired descriptor 
  assign recv_desc  = {base_addr, 
                    {(8-PORT_WIDTH){1'b0}},pkt_port,
                    {(8-DEST_WIDTH_IN){1'b0}},pkt_slot,
                    {(16-LEN_WIDTH){1'b0}},pkt_len};

  assign mem_wr_en   = wr_data_en;
  assign mem_wr_addr = wr_addr;
  assign mem_wr_last = wr_last_pkt;
  assign wr_ready    = mem_wr_ready;
  assign mem_wr_data = {wr_data_1,wr_data_2} >> {wr_offset,3'd0};
  assign mem_wr_strb = {wr_strb_1,wr_strb_2} >> wr_offset;

  ////////////////////////////////////////////////////////////////////////////////
  ///////////////////////// READ FROM MEM TO AIXS ////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  
  // State machine to have an init state between idle and processing to calculate
  // offset and so. 
  localparam IDLE = 2'b00;
  localparam INIT = 2'b01;
  localparam PROC = 2'b10;
  localparam ERR  = 2'b11;
  
  reg [1:0] state_r, state_n;
  reg       to_drop; 

  always @ (posedge clk)
    if (rst)
      state_r <= IDLE;
    else
      state_r <= state_n;

  always @ (*) begin
    state_n = state_r;
    case (state_r)
      IDLE: if (send_desc_valid) state_n = INIT;
      INIT: if (to_drop) state_n = IDLE; else state_n = PROC;
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

  
  always @ (posedge clk)
    if (send_desc_ready && send_desc_valid) begin
      send_base_addr  <= send_desc[ADDR_WIDTH+31:32];
      send_len        <= send_desc[LEN_WIDTH-1:0];
      send_port       <= send_desc[PORT_WIDTH+23:24];
      send_orig_addr  <= send_desc[USER_WIDTH_OUT+15:16];
      // Lower bits of base_addr and send_len
      remainder_bytes <= send_desc[MASK_BITS+31:32] +
                         send_desc[MASK_BITS-1:0];
      to_drop         <= (send_desc[LEN_WIDTH-1:0]==0);
    end
  
  assign send_desc_ready = (state_r == IDLE);
  assign pkt_sent        = (to_drop&&(state_r==INIT)) || 
                    (m_axis_tvalid && m_axis_tready && m_axis_tlast);

  // Calculating offset, number of words and final tkeep in INIT state
  reg [ADDR_WIDTH-1:0]          alligned_rd_addr;
  reg [MASK_BITS-1:0]           rd_offset;
  reg [LEN_WIDTH-MASK_BITS-1:0] rd_word_count;
  reg [STRB_WIDTH-1:0]          rd_final_tkeep;

  wire [1:0] extra_words = (remainder_bytes == 0) ? 2'd0: 
                           (remainder_bytes[MASK_BITS] + 2'd1); 
  
  // number of 0s in last tkeep. 0 becomes 0 due to dropping the MSB. 
  wire [MASK_BITS-1:0] tkeep_zeros  = STRB_WIDTH - send_len[MASK_BITS-1:0];

  // Initialize offset, word_count, final tkeep and strat address. Also when 
  // a data was recieved address and remainig words are updated.
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

  // During processing there are 2 pipeline registers for data and output data 
  // is selected based on offset. data left is for last 2 words in pipe. 
  // Depending on the offset and the remainder bytes they should be transfered 
  // in one or two.
  reg [1:0] data_left;
  always @ (posedge clk)
    if (rst)
      data_left <= 2'd0;
    else if (state_r != PROC)
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

  // 2 pipe registers with valid. There is no need for individual ready signals.
  reg  [DATA_WIDTH-1:0] read_reg_1;
  reg  [DATA_WIDTH-1:0] read_reg_2;
  reg read_reg_1_v, read_reg_2_v;
  always @ (posedge clk) begin
    if (rst) begin
      read_reg_1_v <= 1'b0;
      read_reg_2_v <= 1'b0;
    end
    // since mem_rd_data_ready is high when m_axis_tready,
    // is asserted, it means the data can go out and pipe can go forward
    // This covers when mem is ready and axis is ready or not. Also if 
    // its the first word coming in. 
    if (mem_rd_data_v && mem_rd_data_ready) begin
      read_reg_1   <= mem_rd_data;
      read_reg_1_v <= 1'b1;
      read_reg_2   <= read_reg_1;
      read_reg_2_v <= read_reg_1_v;
    end 
    // After loading data is done and the last 1 or 2 words are being sent 
    // (based on the rx_offset and remainder_bytes two registers might be 
    // 1 or 2 data values), the pipe is being emptied if it's not blocked by axis
    // This case does not depend on input memory any more and just waits to 
    // be emptied over axis. 
    else if ((data_left!=2'd0) && (!(m_axis_tvalid && !m_axis_tready))) begin
      read_reg_1_v <= 1'b0;
      read_reg_2   <= read_reg_1;
      // If there are 2 words read_reg_2 stays valid for another cycle
      // otherwise both registers become not valid 
      read_reg_2_v <= (data_left==2'd2);
    end
    // If data was sent but no new data received we deassert the valid
    // of second stage not to repeat the same data. We cannot move the 
    // pipe forward since in case of having offset we need both 
    // registers to be valid for send and cannot insert a non_valid gap.
    // This is case is when mem is not ready but axis is.
    else if (m_axis_tvalid && m_axis_tready) begin
      read_reg_2_v <= 1'b0;
    end
    // If both of mem and axis are not ready there is no change.
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
