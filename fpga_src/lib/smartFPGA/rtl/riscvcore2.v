module riscvcore #(
  parameter IMEM_SIZE      = 65536,
  parameter DMEM_SIZE      = 32768,
  parameter PMEM_SIZE      = 1048576,
  parameter PMEM_SEG_SIZE  = 131072,
  parameter PMEM_SEG_COUNT = 8,
  parameter DMEM_ADDR_WIDTH = $clog2(DMEM_SIZE)
)(
    input                        clk,
    input                        rst,
    input                        init_rst,

    // Data memory interface
    output                       dmem_en,
    output                       pmem_en,
    output                       exio_en,
    output                       mem_wen,
    input                        mem_ready,
    output [3:0]                 mem_strb,
    output [24:0]                mem_addr,
    output [31:0]                mem_wr_data,
    input  [31:0]                mem_rd_data,
    input                        mem_rd_valid,

    // Instruction memory interface
    output                       imem_ren,
    output [24:0]                imem_addr,
    input  [31:0]                imem_rd_data,
    input                        imem_rd_valid,

    // Packet descriptor input and output
    input  [63:0]                in_desc,
    input                        in_desc_valid,
    output                       in_desc_taken,

    output [63:0]                out_desc,
    output                       out_desc_valid,
    output [63:0]                out_desc_dram_addr,
    input                        out_desc_ready,

    // Status and debug input
    input  [31:0]                active_slots,
    input  [15:0]                bc_region_size,
    input  [7:0]                 core_id,
    input  [7:0]                 max_slot_count,
    input  [63:0]                debug_in,
    input                        core_msg_ready,
    input  [DMEM_ADDR_WIDTH-1:0] bc_msg_in_addr,
    input                        bc_msg_in_valid,

    // slot addr write, debug and status output
    output [31:0]                slot_wr_data,
    output                       slot_wr_valid,
    input                        slot_wr_ready,
    output [63:0]                debug_out,
    output                       debug_out_l_valid,
    output                       debug_out_h_valid,
    output [7:0]                 core_errors,
    output                       ready_to_evict,

    // External IO error
    input                        ext_io_err,
    output                       ext_io_err_ack,

    // Interrupts
    input                        evict_int,
    output                       evict_int_ack,
    input                        poke_int,
    output                       poke_int_ack,
    input  [4:0]                 recv_dram_tag,
    input                        recv_dram_tag_valid
);

// Core to memory signals
wire [31:0] dmem_read_data;
wire [31:0] dmem_addr, imem_addr_n;
wire [4:0]  dmem_wr_strb;
wire [1:0]  dmem_byte_count;
wire        dmem_v;

reg [7:0]  int_mask;
reg        imem_access_err, dmem_access_err;
reg        io_access_err, pmem_access_err;
reg        bc_int_err;
reg        timer_interrupt;
reg        io_ren_r;
wire       dram_recv_any;
wire       bc_interrupt;
wire       io_we_ready;

VexRiscv core (
      .clk(clk),
      .reset(rst),

      .iBus_cmd_valid(imem_ren),
      .iBus_cmd_ready(1'b1),
      .iBus_cmd_payload_pc(imem_addr_n),
      .iBus_rsp_valid(imem_rd_valid),
      .iBus_rsp_payload_error(imem_access_err && int_mask[6]),
      .iBus_rsp_payload_inst(imem_rd_data),

      .dBus_cmd_valid(dmem_v),
      .dBus_cmd_ready(mem_ready && io_wr_ready),
      .dBus_cmd_payload_wr(mem_wen),
      .dBus_cmd_payload_address(dmem_addr),
      .dBus_cmd_payload_data(mem_wr_data),
      .dBus_cmd_payload_size(dmem_byte_count),
      .dBus_rsp_ready(mem_rd_valid || io_ren_r),
      .dBus_rsp_error((dmem_access_err  || io_access_err ||
                       pmem_access_err) && int_mask[7]),
      .dBus_rsp_data(dmem_read_data),

      .timerInterrupt(timer_interrupt   && int_mask[2]),
      .externalInterrupt((ext_io_err    && int_mask[5]) ||
                         (poke_int      && int_mask[4]) ||
                         (bc_interrupt  && int_mask[3]) ||
                         (dram_recv_any && int_mask[1]) ||
                         (in_desc_valid && int_mask[0]) ||
                         evict_int),
      .softwareInterrupt(1'b0)
);

// Conversion from core dmem_byte_count to normal byte mask
assign dmem_wr_strb = ((!mem_wen) || (!dmem_v)) ? 5'h0 :
								     	 (dmem_byte_count == 2'd0) ? (5'h01 << dmem_addr[1:0]) :
                       (dmem_byte_count == 2'd1) ? (5'h03 << dmem_addr[1:0]) :
                       5'h0f;

// Memory address decoding
wire internal_io = dmem_addr[24:22]==3'b000;
wire external_io = dmem_addr[24:22]==3'b001;
wire data_mem    = dmem_addr[24:23]==2'b01;
wire packet_mem  = dmem_addr[24]   ==1'b1;

assign dmem_en   = dmem_v && data_mem;
assign pmem_en   = dmem_v && packet_mem;
assign exio_en   = dmem_v && external_io;

wire [5:0] io_addr  = dmem_addr[7:2];
wire       io_read  = internal_io && dmem_v && (!mem_wen);
wire       io_write = internal_io && dmem_v && mem_wen;
reg [31:0] io_read_data;

// selecting input/output data
assign imem_addr      = imem_addr_n[24:0];
assign dmem_read_data = io_ren_r ? io_read_data : mem_rd_data;
assign mem_strb       = dmem_wr_strb[3:0];
assign mem_addr       = dmem_addr;

///////////////////////////////////////////////////////////////////////////
///////////////////////////// IO WRITES ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////

// localparam RESERVED      = 6'b000000; NULL pointer
// localparam RESERVED      = 6'b000001;
localparam SEND_DESC_ADDR_L = 6'b000010;
localparam SEND_DESC_ADDR_H = 6'b000011;
localparam WR_DRAM_ADDR_L   = 6'b000100;
localparam WR_DRAM_ADDR_H   = 6'b000101;
localparam SLOT_LUT_ADDR    = 6'b000110;
localparam TIMER_STP_ADDR   = 6'b000111;
localparam DRAM_FLAG_ADDR   = 6'b001000;
localparam READY_TO_EVICT   = 6'b001001;
localparam SEND_DESC_TYPE   = 6'b001010;
localparam RD_DESC_STRB     = 6'b001011;
localparam DRAM_FLAG_RST    = 6'b001100;
localparam SLOT_LUT_STRB    = 6'b001101;
localparam MASK_WR          = 6'b001110;
localparam INTERRUPT_ACK    = 6'b001111;
localparam DEBUG_REG_ADDR_L = 6'b010000;
localparam DEBUG_REG_ADDR_H = 6'b010001;
localparam BC_MASK_REG      = 6'b010010;
localparam BC_EQUAL_REG     = 6'b010011;
localparam BC_INT_EN        = 6'b010100;

reg [63:0] dram_wr_addr_r;
reg [31:0] timer_step_r;
reg [63:0] debug_register;

reg [63:0] out_desc_data_r;
reg [3:0]  out_desc_type_r;
reg [31:0] slot_info_data_r;
reg        ready_to_evict_r;
reg        bc_int_en;

reg [DMEM_ADDR_WIDTH-1:0] bc_mask_reg, bc_equal_reg;

integer i;
always @ (posedge clk) begin
    if (io_write) begin
        for (i = 0; i < 4; i = i + 1)
            if (dmem_wr_strb[i] == 1'b1)
                case (io_addr)
                    SEND_DESC_ADDR_L: out_desc_data_r[i*8 +: 8]    <= mem_wr_data[i*8 +: 8];
                    SEND_DESC_ADDR_H: out_desc_data_r[32+i*8 +: 8] <= mem_wr_data[i*8 +: 8];
                    WR_DRAM_ADDR_L:   dram_wr_addr_r[i*8 +: 8]     <= mem_wr_data[i*8 +: 8];
                    WR_DRAM_ADDR_H:   dram_wr_addr_r[32+i*8 +: 8]  <= mem_wr_data[i*8 +: 8];
                    SLOT_LUT_ADDR:    slot_info_data_r[i*8 +: 8]   <= mem_wr_data[i*8 +: 8];
                    TIMER_STP_ADDR:   timer_step_r[i*8 +: 8]       <= mem_wr_data[i*8 +: 8];
                    DEBUG_REG_ADDR_L: debug_register[i*8 +: 8]     <= mem_wr_data[i*8 +: 8];
                    DEBUG_REG_ADDR_H: debug_register[32+i*8 +: 8]  <= mem_wr_data[i*8 +: 8];
                    default: begin end
                endcase

        if (io_addr==BC_MASK_REG)
            bc_mask_reg <= mem_wr_data[DMEM_ADDR_WIDTH-1:0];
        if (io_addr==BC_EQUAL_REG)
            bc_equal_reg <= mem_wr_data[DMEM_ADDR_WIDTH-1:0];
        if (io_addr==BC_INT_EN)
            bc_int_en <= mem_wr_data[0];
        if (io_addr==SEND_DESC_TYPE) // it's both type and strb
            out_desc_type_r <= mem_wr_data[3:0];
        if (io_addr==MASK_WR)
            int_mask         <= mem_wr_data[7:0];
        if (io_addr==READY_TO_EVICT)
            ready_to_evict_r <= mem_wr_data[0];

    end

    if (rst) begin
      timer_step_r     <= 32'h00000001;
      int_mask         <= 8'hF0;
      ready_to_evict_r <= 1'b0;
    end
end

// Remaining addresses
wire timer_step_wen = io_write && (io_addr==TIMER_STP_ADDR);
wire dram_flags_wen = io_write && (io_addr==DRAM_FLAG_ADDR);
wire send_out_desc  = io_write && (io_addr==SEND_DESC_TYPE);
wire dram_flag_rst  = io_write && (io_addr==DRAM_FLAG_RST);
wire interrupt_ack  = io_write && (io_addr==INTERRUPT_ACK);
wire debug_reg_wr_l = io_write && (io_addr==DEBUG_REG_ADDR_L);
wire debug_reg_wr_h = io_write && (io_addr==DEBUG_REG_ADDR_H);

reg out_desc_v_r, debug_reg_wr_l_r, debug_reg_wr_h_r;

always @ (posedge clk) begin
    if (rst) begin
            out_desc_v_r     <= 1'b0;
            debug_reg_wr_l_r <= 1'b0;
            debug_reg_wr_h_r <= 1'b0;
    end else begin
        debug_reg_wr_l_r <= debug_reg_wr_l;
        debug_reg_wr_h_r <= debug_reg_wr_h;
        if (send_out_desc)
            out_desc_v_r <= 1'b1;
        if (out_desc_v_r && out_desc_ready)
            out_desc_v_r <= 1'b0;
    end
end

assign slot_wr_valid      = io_write && (io_addr==SLOT_LUT_STRB) && mem_wr_data[0];
assign slot_wr_data       = slot_info_data_r;

assign debug_out          = debug_register;
assign debug_out_l_valid  = debug_reg_wr_l_r;
assign debug_out_h_valid  = debug_reg_wr_h_r;

assign out_desc           = {out_desc_type_r, out_desc_data_r[59:0]};
assign out_desc_valid     = out_desc_v_r;
assign out_desc_dram_addr = dram_wr_addr_r;
assign io_wr_ready        = !send_out_desc || out_desc_ready;
assign in_desc_taken      = io_write && (io_addr==RD_DESC_STRB) && mem_wr_data[0];

assign ready_to_evict     = ready_to_evict_r;

///////////////////////////////////////////////////////////////////////////
////////////////////////////// IO READS ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////

localparam RD_DESC_ADDR_L   = 6'b100000;
localparam RD_DESC_ADDR_H   = 6'b100001;
localparam RD_D_FLAGS_ADDR  = 6'b100010;
localparam RD_STAT_ADDR     = 6'b100011;
localparam RD_ID_ADDR       = 6'b100100;
localparam RD_TIMER_L_ADDR  = 6'b100101;
localparam RD_TIMER_H_ADDR  = 6'b100110;
localparam RD_INT_F_ADDR    = 6'b100111;
localparam RD_ACT_SLOT_ADDR = 6'b101000;
localparam RD_IMEM_SIZE     = 6'b101001;
localparam RD_DMEM_SIZE     = 6'b101010;
localparam RD_PMEM_SIZE     = 6'b101011;
localparam RD_PMEM_SEG_SIZE = 6'b101100;
localparam RD_PMEM_SEG_CNT  = 6'b101101;
localparam RD_BC_SIZE       = 6'b101110;
localparam MAX_SLOT_CNT     = 6'b101111;
localparam DEBUG_IN_ADDR_L  = 6'b110000;
localparam DEBUG_IN_ADDR_H  = 6'b110001;
localparam RD_BC_MASK       = 6'b110010;
localparam RD_BC_EQUAL      = 6'b110011;
localparam RD_BC_ADDR       = 6'b110100;

reg [31:0] dram_recv_flag;
reg [63:0] internal_timer;

wire [DMEM_ADDR_WIDTH-1:0] bc_msg_in_addr_f;

always @ (posedge clk)
    if (rst)
        io_ren_r <= 1'b0;
    else
        io_ren_r <= io_read;

// User interrupts are masked, but error ones are not
wire [7:0] int_flags = {1'd0, evict_int, ext_io_err, poke_int, bc_interrupt,
                        timer_interrupt, dram_recv_any, in_desc_valid}
                        & {2'b01, int_mask[5:0]};
always @ (posedge clk)
    if (io_read)
        case (io_addr)
            RD_DESC_ADDR_L:   if (in_desc_valid) io_read_data <= in_desc[31:0];
            RD_DESC_ADDR_H:   if (in_desc_valid) io_read_data <= in_desc[63:32];
            RD_D_FLAGS_ADDR:  io_read_data <= dram_recv_flag;
            RD_STAT_ADDR:     io_read_data <= {7'd0,core_msg_ready, 7'd0,slot_wr_ready,
                                               7'd0,out_desc_ready, 7'd0,in_desc_valid};
            RD_ID_ADDR:       io_read_data <= {24'd0, core_id};
            RD_TIMER_L_ADDR:  io_read_data <= internal_timer[31:0];
            RD_TIMER_H_ADDR:  io_read_data <= internal_timer[63:32];
            RD_INT_F_ADDR:    io_read_data <= {8'd0, int_flags,
                                               int_mask,
                                               3'd0, bc_int_err,
                                               io_access_err, pmem_access_err,
                                               dmem_access_err, imem_access_err};
            RD_ACT_SLOT_ADDR: io_read_data <= active_slots;
            RD_IMEM_SIZE:     io_read_data <= IMEM_SIZE;
            RD_DMEM_SIZE:     io_read_data <= DMEM_SIZE;
            RD_PMEM_SIZE:     io_read_data <= PMEM_SIZE;
            RD_PMEM_SEG_SIZE: io_read_data <= PMEM_SEG_SIZE;
            RD_PMEM_SEG_CNT:  io_read_data <= PMEM_SEG_COUNT;
            RD_BC_SIZE:       io_read_data <= bc_region_size;
            MAX_SLOT_CNT:     io_read_data <= max_slot_count;
            DEBUG_IN_ADDR_L:  io_read_data <= debug_in[31:0];
            DEBUG_IN_ADDR_H:  io_read_data <= debug_in[63:32];
            RD_BC_MASK:       io_read_data <= {{(32-DMEM_ADDR_WIDTH){1'b0}},
                                              bc_mask_reg};
            RD_BC_EQUAL:      io_read_data <= {{(32-DMEM_ADDR_WIDTH){1'b0}},
                                              bc_equal_reg};
            RD_BC_ADDR:       io_read_data <= {{(32-DMEM_ADDR_WIDTH){1'b0}},
                                              bc_msg_in_addr_f};
            default: begin end
            // default is to keep the value
        endcase

///////////////////////////////////////////////////////////////////////////
//////////////////////// INTERNAL 32-BIT TIMER ////////////////////////////
///////////////////////////////////////////////////////////////////////////
always @ (posedge clk)
  if (init_rst)
    internal_timer <= 64'd0;
  else
    internal_timer <= internal_timer + 64'd1;

reg [31:0] interrupt_time;
wire timer_int_ack;

always @ (posedge clk)
  if (rst || timer_step_wen) begin
    interrupt_time  <= 32'd0;
    timer_interrupt <= 1'b0;
  end else if (interrupt_time == timer_step_r) begin
    interrupt_time  <= 32'd0;
    timer_interrupt <= 1'b1;
  end else begin
    interrupt_time  <= interrupt_time + 32'd1;
    if (timer_int_ack)
      timer_interrupt <= 1'b0;
  end

///////////////////////////////////////////////////////////////////////////
/////////////////////////// DRAM RECV FLAGS ///////////////////////////////
///////////////////////////////////////////////////////////////////////////
reg [4:0]  recv_dram_tag_r;
reg        recv_dram_tag_valid_r;

// Register the input to improve timing
always @ (posedge clk) begin
  recv_dram_tag_r         <= recv_dram_tag;
  recv_dram_tag_valid_r   <= recv_dram_tag_valid;
  if (rst)
    recv_dram_tag_valid_r <= 1'b0;
end

always @ (posedge clk)
  if (rst)
    dram_recv_flag <= 32'd0;
  else begin
    if (dram_flags_wen)
        for (i = 0; i < 4; i = i + 1)
            if (dmem_wr_strb[i] == 1'b1)
                dram_recv_flag[i*8 +: 8] <= mem_wr_data[i*8 +: 8];

    if (dram_flag_rst)
      dram_recv_flag[mem_wr_data[4:0]] <= 1'b0;

    // Incoming dram recv has higher priority than core reset on same bit
    if (recv_dram_tag_valid_r)
      dram_recv_flag[recv_dram_tag_r] <= 1'b1;

    dram_recv_flag[0] <= 1'b0; // synthesizer will hardwire it
  end

assign dram_recv_any = | dram_recv_flag;


///////////////////////////////////////////////////////////////////////////
//////////////////////// BC MSG FILTER AND FIFO ///////////////////////////
///////////////////////////////////////////////////////////////////////////

reg [DMEM_ADDR_WIDTH-1:0] bc_msg_in_addr_r;
reg                       bc_msg_in_valid_r;
wire                      bc_int_ack;
wire                      bc_int_ready;

// Select which address bits to match, and the match value
always @ (posedge clk) begin
  bc_msg_in_addr_r  <= bc_msg_in_addr;
  bc_msg_in_valid_r <= bc_msg_in_valid && bc_int_en &&
                     ((bc_msg_in_addr & bc_mask_reg) == bc_equal_reg);
  if (rst)
    bc_msg_in_valid_r <= 1'b0;
end

simple_fifo # (
  .ADDR_WIDTH(4),
  .DATA_WIDTH(DMEM_ADDR_WIDTH)
) bc_interrupt_fifo (
  .clk(clk),
  .rst(rst),
  .clear(!bc_int_en),

  .din_valid(bc_msg_in_valid_r),
  .din(bc_msg_in_addr_r),
  .din_ready(bc_int_ready), // For now assume we have space

  .dout_valid(bc_interrupt),
  .dout(bc_msg_in_addr_f),
  .dout_ready(bc_int_ack),

  .full()
);

///////////////////////////////////////////////////////////////////////////
///////////// ADDRESS ERROR CATCHING & INTERRUPT ACK //////////////////////
///////////////////////////////////////////////////////////////////////////
// Register addresses and enables for error catching
reg [31:0] imem_addr_r, dmem_addr_r;
reg imem_ren_r, dmem_en_r, pmem_en_r, intio_en_r;

always @ (posedge clk) begin
  imem_addr_r       <= imem_addr;
  dmem_addr_r       <= dmem_addr;
  imem_ren_r        <= imem_ren;
  intio_en_r        <= internal_io && dmem_v;
  dmem_en_r         <= dmem_en;
  pmem_en_r         <= pmem_en;
  if (rst) begin
    imem_ren_r      <= 1'b0;
    intio_en_r      <= 1'b0;
    dmem_en_r       <= 1'b0;
    pmem_en_r       <= 1'b0;
  end
end

// Each error stays asserted until it is reset by corresponding bit when interrupt_ack is asserted
always @ (posedge clk)
    if (rst) begin
        imem_access_err <= 1'b0;
        dmem_access_err <= 1'b0;
        pmem_access_err <= 1'b0;
        io_access_err   <= 1'b0;
        bc_int_err      <= 1'b0;
		end else begin
        imem_access_err <= !(interrupt_ack && mem_wr_data[4]) && (imem_access_err ||
                           (imem_ren_r && (imem_addr_r >= IMEM_SIZE)));

        dmem_access_err <= !(interrupt_ack && mem_wr_data[5]) && (dmem_access_err ||
                             (dmem_en_r && (dmem_addr_r[22:0] >= DMEM_SIZE)));

        pmem_access_err <= !(interrupt_ack && mem_wr_data[6]) && (pmem_access_err ||
                             (pmem_en_r && (dmem_addr_r[23:0] >= PMEM_SIZE)));

        io_access_err   <= !(interrupt_ack && mem_wr_data[7]) && (io_access_err ||
                             (intio_en_r && (dmem_addr_r[21:0] >= 22'h000100)));
        bc_int_err      <= bc_int_en && (bc_int_err || (bc_msg_in_valid_r && !bc_int_ready));
    end

assign timer_int_ack  = interrupt_ack && mem_wr_data[0];
assign poke_int_ack   = interrupt_ack && mem_wr_data[1];
assign evict_int_ack  = interrupt_ack && mem_wr_data[2];
assign ext_io_err_ack = interrupt_ack && mem_wr_data[3];
assign bc_int_ack     = interrupt_ack && mem_wr_data[8];

assign core_errors    = {3'd0, ext_io_err, io_access_err, pmem_access_err, dmem_access_err, imem_access_err};

endmodule