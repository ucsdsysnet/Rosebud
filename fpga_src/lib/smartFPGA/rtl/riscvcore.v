module riscvcore #(
  parameter CORE_ID_WIDTH   = 4,
  parameter SLOT_COUNT      = 8,
  parameter SLOT_WIDTH      = $clog2(SLOT_COUNT+1),

  parameter IMEM_SIZE       = 65536,
  parameter DMEM_SIZE       = 32768,
  parameter PMEM_SIZE       = 1048576,
  parameter PMEM_SEG_SIZE   = 131072,
  parameter PMEM_SEG_COUNT  = 8,
  parameter BC_REGION_SIZE  = 4048
)(
    input                        clk,
    input                        rst,
    input                        init_rst,
    input  [CORE_ID_WIDTH-1:0]   core_id,
    
    output                       dmem_en,
    output                       pmem_en,
    output                       exio_en,
    output                       mem_wen,
    output [3:0]                 mem_strb,
    output [24:0]                mem_addr,
    output [31:0]                mem_wr_data,
    input  [31:0]                mem_rd_data,
    input                        mem_rd_valid,
    
    output                       imem_ren,
    output [24:0]                imem_addr,
    input  [31:0]                imem_rd_data,
    input                        imem_rd_valid,

    input  [63:0]                in_desc,
    input                        in_desc_valid,
    output                       in_desc_taken,

    input  [4:0]                 recv_dram_tag,
    input                        recv_dram_tag_valid,

    output [63:0]                out_desc,
    output                       out_desc_valid,
    output [63:0]                out_desc_dram_addr,
    input                        out_desc_ready,

    output [SLOT_WIDTH-1:0]      slot_wr_ptr, 
    output [24:0]                slot_wr_addr,
    output                       slot_wr_valid,
    output                       slot_for_hdr,
    input                        slot_wr_ready,

    input                        core_msg_ready,
    input                        interrupt_in,
    output                       interrupt_in_ack
);

// Core to memory signals
wire [31:0] mem_wr_data, dmem_read_data; 
wire [31:0] dmem_addr, imem_addr_n;
wire [4:0]  dmem_wr_strb;
wire [1:0]  dmem_byte_count;
wire        dmem_v;

reg [7:0]  mask_r;
reg        imem_access_err, dmem_access_err;
reg        io_access_err, pmem_access_err;
reg        timer_interrupt;
reg        io_ren_r;
wire       dram_recv_any;

VexRiscv core (
      .clk(clk),
      .reset(rst),

      .iBus_cmd_valid(imem_ren),
      .iBus_cmd_ready(1'b1),
      .iBus_cmd_payload_pc(imem_addr_n),
      .iBus_rsp_valid(imem_rd_valid),
      .iBus_rsp_payload_error(imem_access_err && mask_r[0]),
      .iBus_rsp_payload_inst(imem_rd_data),

      .dBus_cmd_valid(dmem_v),
      .dBus_cmd_ready(1'b1),
      .dBus_cmd_payload_wr(mem_wen),
      .dBus_cmd_payload_address(dmem_addr),
      .dBus_cmd_payload_data(mem_wr_data),
      .dBus_cmd_payload_size(dmem_byte_count),
      .dBus_rsp_ready(mem_rd_valid || io_ren_r),
      .dBus_rsp_error((dmem_access_err  || io_access_err || 
                       pmem_access_err) && mask_r[1]),
      .dBus_rsp_data(dmem_read_data),
      
      .timerInterrupt(timer_interrupt && mask_r[5]), 
      .externalInterrupt((interrupt_in && mask_r[4])  || 
                         (dram_recv_any && mask_r[6]) || 
                         (in_desc_valid && mask_r[7])),
      .softwareInterrupt(1'b0)
);

// Conversion from core dmem_byte_count to normal byte mask
assign dmem_wr_strb = ((!mem_wen) || (!dmem_v)) ? 5'h0 : 
								     	 (dmem_byte_count == 2'd0) ? (5'h01 << dmem_addr[1:0]) :
                       (dmem_byte_count == 2'd1) ? (5'h03 << dmem_addr[1:0]) :
                       5'h0f;

// Memory address decoding 
wire   internal_io = dmem_addr[24:22]==3'b000;
wire   external_io = dmem_addr[24:22]==3'b001;
wire   data_mem    = dmem_addr[24:23]==2'b01;
wire   packet_mem  = dmem_addr[24]   ==1'b1;

wire   io_read     = internal_io && dmem_v && (!mem_wen);
wire   io_write    = internal_io && dmem_v && mem_wen; 
assign dmem_en     = dmem_v && data_mem;
assign pmem_en     = dmem_v && packet_mem;
assign exio_en     = dmem_v && external_io;

// selecting input/output data 
assign imem_addr      = imem_addr_n[24:0];
assign dmem_read_data = io_ren_r ? io_read_data : mem_rd_data;
assign mem_strb       = dmem_wr_strb[3:0];
assign mem_addr       = dmem_addr;
 
///////////////////////////////////////////////////////////////////////////
///////////////////////////// IO WRITES ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////

// localparam RESERVED      = 5'b00000; NULL pointer
localparam SEND_DESC_TYPE   = 5'b00001; 
localparam SEND_DESC_ADDR_L = 5'b00010; 
localparam SEND_DESC_ADDR_H = 5'b00011; 
localparam WR_DRAM_ADDR_L   = 5'b00100; 
localparam WR_DRAM_ADDR_H   = 5'b00101;
localparam SLOT_LUT_ADDR    = 5'b00110;
localparam TIMER_STP_ADDR   = 5'b00111;
localparam DRAM_FLAG_ADDR   = 5'b01000;
localparam DEBUG_REG_ADDR   = 5'b01001;
localparam SEND_DESC_STRB   = 5'b01010;
localparam RD_DESC_STRB     = 5'b01011;
localparam DRAM_FLAG_RST    = 5'b01100;
localparam SLOT_LUT_STRB    = 5'b01101;
localparam MASK_WR          = 5'b01110;
localparam INTERRUPT_ACK    = 5'b01111;

reg [63:0] dram_wr_addr_r;
reg [31:0] timer_step_r;
reg [31:0] debug_reg;

reg [63:0] out_desc_data_r;
reg [3:0]  out_desc_type_r;
reg [31:0] slot_info_data_r;
reg out_desc_v_r;

integer i;
always @ (posedge clk) begin
    if (io_write) begin
        for (i = 0; i < 4; i = i + 1) 
            if (dmem_wr_strb[i] == 1'b1) 
                case (dmem_addr[6:2])
                    SEND_DESC_ADDR_L: out_desc_data_r[i*8 +: 8]    <= mem_wr_data[i*8 +: 8];
                    SEND_DESC_ADDR_H: out_desc_data_r[32+i*8 +: 8] <= mem_wr_data[i*8 +: 8];
                    WR_DRAM_ADDR_L:   dram_wr_addr_r[i*8 +: 8]      <= mem_wr_data[i*8 +: 8];
                    WR_DRAM_ADDR_H:   dram_wr_addr_r[32+i*8 +: 8]   <= mem_wr_data[i*8 +: 8];
                    SLOT_LUT_ADDR:    slot_info_data_r[i*8 +: 8]    <= mem_wr_data[i*8 +: 8];
                    TIMER_STP_ADDR:   timer_step_r[i*8 +: 8]        <= mem_wr_data[i*8 +: 8];
                    DEBUG_REG_ADDR:   debug_reg[i*8 +: 8]           <= mem_wr_data[i*8 +: 8];
                endcase

        if (dmem_addr[6:2]==SEND_DESC_TYPE)
            out_desc_type_r <= mem_wr_data[3:0];
        if (dmem_addr[6:2]==MASK_WR)
            mask_r          <= mem_wr_data[7:0];
    end

    if (rst) begin
      timer_step_r <= 32'h00000001;
      mask_r       <= 8'h1F;
    end
end

// Remaining addresses
wire timer_step_wen = io_write && (dmem_addr[6:2]==TIMER_STP_ADDR);
wire dram_flags_wen = io_write && (dmem_addr[6:2]==DRAM_FLAG_ADDR);
wire send_out_desc  = io_write && (dmem_addr[6:2]==SEND_DESC_STRB) && mem_wr_data[0];
wire dram_flag_rst  = io_write && (dmem_addr[6:2]==DRAM_FLAG_RST);
wire interrupt_ack  = io_write && (dmem_addr[6:2]==INTERRUPT_ACK);

wire temp = io_write && (dmem_addr[6:2]==SEND_DESC_ADDR_H);

always @ (posedge clk) begin
    if (rst) 
            out_desc_v_r <= 1'b0;
    else begin
        if (send_out_desc)
            out_desc_v_r <= 1'b1;
        if (out_desc_v_r && out_desc_ready)
            out_desc_v_r <= 1'b0;
    end
end

// Slot header goes to data mem and packet to packet mem, 
// So MSB of slot_wr_addr is determined by being header or not. 
assign slot_for_hdr    = slot_info_data_r[31];
assign slot_wr_valid   = io_write && (dmem_addr[6:2]==SLOT_LUT_STRB) && mem_wr_data[0];
assign slot_wr_addr    = {~slot_for_hdr,slot_info_data_r[23:0]};
assign slot_wr_ptr     = slot_info_data_r[24+:SLOT_WIDTH];

assign out_desc           = {out_desc_type_r, out_desc_data_r[59:0]};
assign out_desc_valid     = out_desc_v_r;
assign out_desc_dram_addr = dram_wr_addr_r;
assign in_desc_taken      = io_write && (dmem_addr[6:2]==RD_DESC_STRB) && mem_wr_data[0];

///////////////////////////////////////////////////////////////////////////
////////////////////////////// IO READS ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////

localparam RD_DESC_ADDR_L   = 5'b10000;
localparam RD_DESC_ADDR_H   = 5'b10001;
localparam RD_D_FLAGS_ADDR  = 5'b10010;
localparam RD_STAT_ADDR     = 5'b10011;
localparam RD_ID_ADDR       = 5'b10100;
localparam RD_TIMER_L_ADDR  = 5'b10101;
localparam RD_TIMER_H_ADDR  = 5'b10110;
localparam RD_INT_F_ADDR    = 5'b10111;
localparam RD_ACT_SLOT_ADDR = 5'b11000;
localparam RD_IMEM_SIZE     = 5'b11001;
localparam RD_DMEM_SIZE     = 5'b11010;
localparam RD_PMEM_SIZE     = 5'b11011;
localparam RD_PMEM_SEG_SIZE = 5'b11100;
localparam RD_PMEM_SEG_CNT  = 5'b11101;
localparam RD_BC_SIZE       = 5'b11110;
// localparam RESERVED      = 5'b11111;

reg [31:0]         io_read_data;
reg [31:0]         dram_recv_flag;
reg [63:0]         internal_timer;
reg [SLOT_COUNT:1] slots_in_prog;

always @ (posedge clk)
    if (rst)
        io_ren_r <= 1'b0;
    else
        io_ren_r <= io_read; 

always @ (posedge clk)
    if (io_read)
        case (dmem_addr[6:2])
            RD_DESC_ADDR_L:   if (in_desc_valid) io_read_data <= in_desc[31:0];
            RD_DESC_ADDR_H:   if (in_desc_valid) io_read_data <= in_desc[63:32];
            RD_D_FLAGS_ADDR:  io_read_data <= dram_recv_flag;
            RD_STAT_ADDR:     io_read_data <= {7'd0,core_msg_ready, 7'd0,slot_wr_ready,
                                               7'd0,out_desc_ready, 7'd0,in_desc_valid};
            RD_ID_ADDR:       io_read_data <= {{(32-CORE_ID_WIDTH){1'b0}},core_id};
            RD_TIMER_L_ADDR:  io_read_data <= internal_timer[31:0];
            RD_TIMER_H_ADDR:  io_read_data <= internal_timer[63:32];
            RD_INT_F_ADDR:    io_read_data <= {16'd0, mask_r, 
                                               in_desc_valid, dram_recv_any, 
                                               timer_interrupt, interrupt_in, 
                                               io_access_err, pmem_access_err,
                                               dmem_access_err, imem_access_err};
            RD_ACT_SLOT_ADDR: io_read_data <= {{(32-SLOT_COUNT){1'b0}}, slots_in_prog};
            RD_IMEM_SIZE:     io_read_data <= IMEM_SIZE;
            RD_DMEM_SIZE:     io_read_data <= DMEM_SIZE;
            RD_PMEM_SIZE:     io_read_data <= PMEM_SIZE;
            RD_PMEM_SEG_SIZE: io_read_data <= PMEM_SEG_SIZE;
            RD_PMEM_SEG_CNT:  io_read_data <= PMEM_SEG_COUNT;
            RD_BC_SIZE:       io_read_data <= BC_REGION_SIZE;
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

always @ (posedge clk)
  if (rst || timer_step_wen) begin
    interrupt_time  <= 32'd0;
    timer_interrupt <= 1'b0;
  end else if (interrupt_time == timer_step_r) begin
    interrupt_time  <= 32'd0;
    timer_interrupt <= 1'b1;
  end else begin
    interrupt_time  <= interrupt_time + 32'd1;
    if (interrupt_ack && mem_wr_data[5])
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
//////////////////////// ACTIVE SLOTS STATE/// ////////////////////////////
///////////////////////////////////////////////////////////////////////////
wire done_w_slot = ((out_desc[63:60] == 4'd0) ||
                    (out_desc[63:60] == 4'd1) ||
                    (out_desc[63:60] == 4'd2));

always @ (posedge clk)
    if (init_rst)
        slots_in_prog <= {SLOT_COUNT{1'b0}};
    else if (in_desc_valid && in_desc_taken)
        slots_in_prog[in_desc[16+:SLOT_WIDTH]]  <= 1'b1;
    else if (done_w_slot && out_desc_valid && out_desc_ready)
        slots_in_prog[out_desc[16+:SLOT_WIDTH]] <= 1'b0;

// TODO: Add error catching

///////////////////////////////////////////////////////////////////////////
/////////////////////// ADDRESS ERROR CATCHING ////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Register the error ack so a simple sync reg would be enough to respond
// assuming the code waits a cycle before resetting it, which is the case
// when responding to an interrupt. 
reg ext_err_ack;
always @ (posedge clk)
  if (rst || (interrupt_ack && mem_wr_data[4]))
    ext_err_ack <= 1'b0;
  else if (interrupt_ack && mem_wr_data[4])
    ext_err_ack <= 1'b1;

assign interrupt_in_ack = ext_err_ack;

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
    imem_ren_r        <= 1'b0; 
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
		end else begin
        imem_access_err <= !(interrupt_ack && mem_wr_data[0]) && (imem_access_err || 
                           (imem_ren_r && (imem_addr_r >= IMEM_SIZE)));

        dmem_access_err <= !(interrupt_ack && mem_wr_data[1]) && (dmem_access_err || 
                             (dmem_en_r && (dmem_addr_r[22:0] >= DMEM_SIZE)));
        
        pmem_access_err <= !(interrupt_ack && mem_wr_data[2]) && (pmem_access_err || 
                             (pmem_en_r && (dmem_addr_r[23:0] >= PMEM_SIZE)));
                       
        io_access_err   <= !(interrupt_ack && mem_wr_data[3]) && (io_access_err || 
                             (intio_en_r && (dmem_addr_r[21:0] >= 22'h000080)));
    end

endmodule
