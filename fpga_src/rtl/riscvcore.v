module riscvcore #(
  parameter DATA_WIDTH      = 64,
  parameter ADDR_WIDTH      = 16,
  parameter IMEM_SIZE_BYTES = 8192,
  parameter DMEM_SIZE_BYTES = 32768,
  parameter COHERENT_START  = 16'h6FFF,
  parameter CORE_ID         = 0,
  parameter SLOT_PTR_WIDTH  = 3,
  parameter STRB_WIDTH      = DATA_WIDTH/8,
  parameter LINE_ADDR_BITS  = $clog2(STRB_WIDTH),
  parameter IMEM_ADDR_WIDTH = $clog2(IMEM_SIZE_BYTES),
  parameter DMEM_ADDR_WIDTH = $clog2(DMEM_SIZE_BYTES)
)(
    input                        clk,
    input                        rst,
    
    output                       ext_dmem_en,
    output                       ext_dmem_ren,
    output [STRB_WIDTH-1:0]      ext_dmem_wen,
    output [ADDR_WIDTH-1:0]      ext_dmem_addr,
    output [DATA_WIDTH-1:0]      ext_dmem_wr_data,
    input  [DATA_WIDTH-1:0]      ext_dmem_rd_data,
    input                        ext_dmem_ready,

    output                       ext_imem_ren,
    output [ADDR_WIDTH-1:0]      ext_imem_addr,
    input  [DATA_WIDTH-1:0]      ext_imem_rd_data,

    input  [63:0]                in_desc,
    input                        in_desc_valid,
    output                       in_desc_taken,

    output [63:0]                data_desc,
    output                       data_desc_valid,
    output [63:0]                dram_wr_addr,
    input                        data_desc_ready,

    output [SLOT_PTR_WIDTH-1:0]  slot_wr_ptr, 
    output [ADDR_WIDTH-1:0]      slot_wr_addr,
    output                       slot_wr_valid,
    input                        slot_wr_ready,

    output [31:0]                core_msg_data,
    output [DMEM_ADDR_WIDTH-1:0] core_msg_addr,
    output [3:0]                 core_msg_strb,
    output                       core_msg_valid,
    input                        core_msg_ready,

    input                        interrupt_in,
    output                       interrupt_in_ack
);


// Core to memory signals
wire [31:0] imem_read_data, dmem_wr_data, dmem_read_data; 
wire [31:0] imem_addr, dmem_addr;
wire dmem_v, dmem_wr_en, imem_v;
reg  dmem_read_ready, imem_read_ready;
reg  imem_access_err, dmem_access_err;
reg  io_access_data_err, io_byte_access_err;
wire [1:0] dmem_byte_count;
wire io_not_mem = dmem_addr[ADDR_WIDTH-1];
wire [4:0] dmem_word_write_mask;
reg timer_interrupt;

VexRiscv core (
      .clk(clk),
      .reset(rst),

      .iBus_cmd_valid(imem_v),
      .iBus_cmd_ready(1'b1),
      .iBus_cmd_payload_pc(imem_addr),
      .iBus_rsp_valid(imem_read_ready),
      .iBus_rsp_payload_error(imem_access_err), //1'b0),
      .iBus_rsp_payload_inst(imem_read_data),

      .dBus_cmd_valid(dmem_v),
      .dBus_cmd_ready(ext_dmem_ready),
      .dBus_cmd_payload_wr(dmem_wr_en),
      .dBus_cmd_payload_address(dmem_addr),
      .dBus_cmd_payload_data(dmem_wr_data),
      .dBus_cmd_payload_size(dmem_byte_count),
      .dBus_rsp_ready(dmem_read_ready),
      .dBus_rsp_error(dmem_access_err || io_access_data_err || io_byte_access_err), // 1'b0),
      .dBus_rsp_data(dmem_read_data),
      
      .timerInterrupt(timer_interrupt), 
      .externalInterrupt(interrupt_in),
      .softwareInterrupt(1'b0)
);

///////////////////////////////////////////////////////////////////////////
///////////////////////////// IO WRITES ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////

localparam DATA_DESC_ADDR = 4'b0000;//???;
localparam WR_DRAM_ADDR   = 4'b0001;//???;
localparam SETTING_ADDR   = 4'b0010;//???;
localparam SLOT_LUT_ADDR  = 5'b00110;//??;
// localparam RESERVED_4  = 5'b00111;//??;

// localparam RESERVED_8  = 4'b0100;//???;
// localparam RESERVED_8  = 4'b0101;//???;
// localparam RESERVED_8  = 4'b0110;//???;

localparam DATA_DESC_STRB = 7'b0111000;//;
localparam RD_DESC_STRB   = 7'b0111001;//;
localparam SETTING_STRB   = 7'b0111010;//;
localparam SLOT_LUT_STRB  = 7'b0111011;//;
localparam RESET_TIMER    = 7'b0111100;//;
localparam ERR_CLEAR_STRB = 7'b0111101;//;
// localparam RESERVED_1  = 7'b0111110;//;
// localparam RESERVED_1  = 7'b0111111;//;

localparam IO_BYTE_ACCESS = 4'b0111;//??;
localparam IO_WRITE_ADDRS = 1'b0;//??????;

wire io_write = io_not_mem && dmem_v && dmem_wr_en && ext_dmem_ready; 

wire data_desc_wen  = io_write && (dmem_addr[6:3]==DATA_DESC_ADDR);
wire dram_addr_wen  = io_write && (dmem_addr[6:3]==WR_DRAM_ADDR);
wire setting_wen    = io_write && (dmem_addr[6:3]==SETTING_ADDR);
wire slot_info_wen  = io_write && (dmem_addr[6:2]==SLOT_LUT_ADDR);

wire send_data_desc = io_write && (dmem_addr[6:0]==DATA_DESC_STRB);
wire rd_desc_done   = io_write && (dmem_addr[6:0]==RD_DESC_STRB);
wire setting_apply  = io_write && (dmem_addr[6:0]==SETTING_STRB);
wire slot_wen       = io_write && (dmem_addr[6:0]==SLOT_LUT_STRB);
wire reset_timer    = io_write && (dmem_addr[6:0]==RESET_TIMER);
wire error_clear    = io_write && (dmem_addr[6:0]==ERR_CLEAR_STRB);

reg [63:0] setting_r;
reg [63:0] dram_wr_addr_r;

reg [63:0] data_desc_data_r;
reg [63:0] setting_data_r;
reg [31:0] slot_info_data_r;
reg data_desc_v_r;

assign dram_wr_addr = dram_wr_addr_r;
// Byte writable data_desc
wire [7:0]  wr_desc_mask = {4'd0, dmem_word_write_mask[3:0]} << {dmem_addr[2], 2'd0};
wire [63:0] wr_desc_din  = {32'd0, dmem_wr_data} << {dmem_addr[2], 5'd0};

// byte output is replicated on all 4 locations, so first bit is correct no matter
// LSB of address
wire strb_asserted = dmem_wr_data[0]; 

integer i;
always @ (posedge clk) begin
    if (data_desc_wen)
        for (i = 0; i < 8; i = i + 1) 
            if (wr_desc_mask[i] == 1'b1) 
                data_desc_data_r[i*8 +: 8] <= wr_desc_din[i*8 +: 8];
   if (setting_wen)
        for (i = 0; i < 8; i = i + 1) 
            if (wr_desc_mask[i] == 1'b1) 
                setting_data_r[i*8 +: 8] <= wr_desc_din[i*8 +: 8];
    if (slot_info_wen)
        for (i = 0; i < 4; i = i + 1) 
            if (wr_desc_mask[i] == 1'b1) 
                slot_info_data_r[i*8 +: 8] <= wr_desc_din[i*8 +: 8];
    if (dram_addr_wen)
        for (i = 0; i < 8; i = i + 1) 
            if (wr_desc_mask[i] == 1'b1) 
                dram_wr_addr_r[i*8 +: 8] <= wr_desc_din[i*8 +: 8];
end

always @ (posedge clk) begin
    if (rst) begin
            data_desc_v_r <= 1'b0;
            setting_r     <= 64'd0;
    end else begin
        if (send_data_desc && strb_asserted)
            data_desc_v_r <= 1'b1;
        if (data_desc_v_r && data_desc_ready)
            data_desc_v_r <= 1'b0;
        
        if (setting_apply && strb_asserted)
          setting_r <= setting_data_r;
    end
end

assign slot_wr_addr    = slot_info_data_r[ADDR_WIDTH-1:0]; 
assign slot_wr_ptr     = slot_info_data_r[31:24] - 1;
assign slot_wr_valid   = slot_wen && strb_asserted;

assign data_desc       = data_desc_data_r;
assign data_desc_valid = data_desc_v_r;

///////////////////////////////////////////////////////////////////////////
////////////////////////////// IO READS ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////

localparam RD_DESC_ADDR    = 4'b1000;//???;
localparam RD_SETTING_ADDR = 4'b1001;//???;
localparam RD_STAT_ADDR    = 5'b10100;//??;
localparam RD_ID_ADDR      = 5'b10101;//??;
localparam RD_TIMER_ADDR   = 5'b10110;//??;
// localparam RESERVED_4   = 5'b10111;//???;
// localparam RESERVED_32  = 2'b11;//?????;

localparam IO_READ_ADDRS   = 1'b1;//??????;
localparam IO_SPACE        = 64+32;

wire io_read  = io_not_mem && dmem_v && (!dmem_wr_en) && ext_dmem_ready;

wire in_desc_ren    = io_read  && (dmem_addr[6:3]==RD_DESC_ADDR);
wire setting_ren    = io_read  && (dmem_addr[6:3]==RD_SETTING_ADDR);
wire stat_ren       = io_read  && (dmem_addr[6:2]==RD_STAT_ADDR);
wire id_ren         = io_read  && (dmem_addr[6:2]==RD_ID_ADDR);
wire timer_ren      = io_read  && (dmem_addr[6:2]==RD_TIMER_ADDR);

reg [31:0] io_read_data;
reg        io_ren_r;
reg [31:0] internal_timer;

always @ (posedge clk)
    if (rst)
        io_ren_r <= 1'b0;
    else
        io_ren_r <= in_desc_ren || stat_ren || id_ren ||
                    setting_ren || timer_ren;

always @ (posedge clk) begin
    if (in_desc_ren)
        if (in_desc_valid)
            if (dmem_addr[2])
                io_read_data    <= in_desc[63:32];
            else
                io_read_data    <= in_desc[31:0];
        else
                io_read_data    <= 64'd0;
 
    if (id_ren)
        io_read_data <= CORE_ID;
 
    if (stat_ren)
        io_read_data <= {7'd0,core_msg_ready, 7'd0,slot_wr_ready,
                         8'd0, 7'd0,data_desc_ready};
 
    if (setting_ren)
        if (dmem_addr[2]) 
            io_read_data <= setting_r[63:32];
        else
            io_read_data <= setting_r[31:0];

    if (timer_ren)
        io_read_data <= internal_timer;
end

assign in_desc_taken = rd_desc_done && strb_asserted;

///////////////////////////////////////////////////////////////////////////
//////////////////////// INTERNAL 32-BIT TIMER ////////////////////////////
///////////////////////////////////////////////////////////////////////////
always @ (posedge clk)
  if (rst || reset_timer)
    internal_timer <= 32'd0;
  else
    internal_timer <= internal_timer + 32'd1;

always @ (posedge clk)
  if (rst || reset_timer)
    timer_interrupt <= 1'b0;
  else if (internal_timer[9:0] == {10{1'b1}})
    timer_interrupt <= 1'b1;

///////////////////////////////////////////////////////////////////////////
/////////////////////// WORD LENGTH ADJUSTMENT ////////////////////////////
///////////////////////////////////////////////////////////////////////////
wire [DATA_WIDTH-1:0] imem_data_out;
wire [DATA_WIDTH-1:0] dmem_data_in, dmem_data_out; 
wire [STRB_WIDTH-1:0] dmem_line_write_mask;

// Conversion from core dmem_byte_count to normal byte mask
assign dmem_word_write_mask = ((!dmem_wr_en) || (!dmem_v)) ? 5'h0 : 
								     			 	  (dmem_byte_count == 2'd0) ? (5'h01 << dmem_addr[1:0]) :
                              (dmem_byte_count == 2'd1) ? (5'h03 << dmem_addr[1:0]) :
                              5'h0f;

if (STRB_WIDTH==4) begin
    assign dmem_read_data = io_ren_r ? io_read_data : dmem_data_out;
    assign dmem_line_write_mask = dmem_word_write_mask[3:0];
    assign dmem_data_in   = dmem_wr_data;
end else begin
    wire [DATA_WIDTH-1:0] dmem_data_out_shifted; 
    reg  [LINE_ADDR_BITS-3:0] dmem_latched_addr;
    localparam REMAINED_BYTES = STRB_WIDTH-4;
    localparam REMAINED_BITS  = 8*REMAINED_BYTES;

    always @ (posedge clk)
        dmem_latched_addr <= dmem_addr[LINE_ADDR_BITS-1:2];

    assign dmem_data_out_shifted = dmem_data_out >> {dmem_latched_addr, 5'd0};
    assign dmem_read_data = io_ren_r ? io_read_data : dmem_data_out_shifted[31:0];
    assign dmem_line_write_mask = 
                         {{REMAINED_BYTES{1'b0}}, dmem_word_write_mask[3:0]} 
                         << {dmem_addr[LINE_ADDR_BITS-1:2], 2'd0};
    assign dmem_data_in =  
                         {{REMAINED_BITS{1'b0}}, dmem_wr_data} 
                         << {dmem_addr[LINE_ADDR_BITS-1:2], 5'd0};
end

if (STRB_WIDTH==4) begin
    assign imem_read_data = imem_data_out;
end else begin
    wire [DATA_WIDTH-1:0] imem_data_out_shifted;
    reg [LINE_ADDR_BITS-3:0] imem_latched_addr;

    always @ (posedge clk)
        imem_latched_addr <= imem_addr[LINE_ADDR_BITS-1:2];

    assign imem_data_out_shifted = imem_data_out >> {imem_latched_addr, 5'd0};
    assign imem_read_data = imem_data_out_shifted[31:0];
end

always @ (posedge clk)
    if (rst) begin
		    dmem_read_ready    <= 1'b0;
		    imem_read_ready    <= 1'b0;
		end else begin
			  dmem_read_ready <= dmem_v && ext_dmem_ready;
		    imem_read_ready <= imem_v;
    end

// connection to dmem and imem
  assign ext_dmem_en       = dmem_v && (!io_not_mem);
  assign ext_dmem_ren      = !(|dmem_line_write_mask);
  assign ext_dmem_wen      = dmem_line_write_mask;
  assign ext_dmem_addr     = dmem_addr;
  assign ext_dmem_wr_data  = dmem_data_in;
  assign dmem_data_out     = ext_dmem_rd_data;

  assign ext_imem_ren     = imem_v;
  assign ext_imem_addr    = imem_addr;
  assign imem_data_out    = ext_imem_rd_data;

///////////////////////////////////////////////////////////////////////////
/////////////////////// ADDRESS ERROR CATCHING ////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Register addresses and enables for error catching 
reg [31:0] imem_addr_r, dmem_addr_r;
reg dmem_v_r, dmem_wr_en_r, imem_v_r;
reg [1:0] dmem_byte_count_r;

wire io_not_mem_r = dmem_addr_r[ADDR_WIDTH-1];

always @ (posedge clk) begin
  imem_addr_r       <= imem_addr;
  dmem_addr_r       <= dmem_addr;
  dmem_v_r          <= dmem_v && ext_dmem_ready;
  imem_v_r          <= imem_v;
  dmem_wr_en_r      <= dmem_wr_en;
  dmem_byte_count_r <= dmem_byte_count;
  if (rst) begin
    dmem_v_r        <= 1'b0;
    imem_v_r        <= 1'b0;
    dmem_wr_en_r    <= 1'b0;
  end 
end

// Register the error ack so a simple sync reg would be enough to respond
// assuming the code keeps waits a cycle before resetting it.
reg ack_error;
always @ (posedge clk)
  if (rst || (error_clear && !strb_asserted))
    ack_error <= 1'b0;
  else if (error_clear && strb_asserted)
    ack_error <= 1'b1;

assign interrupt_in_ack = ack_error;

always @ (posedge clk)
    if (rst || ack_error) begin
        imem_access_err    <= 1'b0;
        dmem_access_err    <= 1'b0;
        io_access_data_err <= 1'b0;
        io_byte_access_err <= 1'b0;
		end else begin
        imem_access_err <= imem_access_err || (imem_v_r && 
                                (imem_addr_r >= (1 << IMEM_ADDR_WIDTH)));

        dmem_access_err <= dmem_access_err || (dmem_v_r && 
                                ((!io_not_mem_r && (dmem_addr_r >= (1 << DMEM_ADDR_WIDTH)))
                                || (dmem_addr_r >= ((1 << (ADDR_WIDTH-1))+IO_SPACE))));
                       
        io_access_data_err <= io_access_data_err || (io_not_mem_r && dmem_v_r && 
                          ((dmem_wr_en_r && !(dmem_addr_r[6]==IO_WRITE_ADDRS)) || 
                          (!dmem_wr_en_r && !(dmem_addr_r[6]==IO_READ_ADDRS))));

        io_byte_access_err <= io_byte_access_err || (io_not_mem_r && dmem_v_r && 
                          (dmem_byte_count_r != 2'd0) && (dmem_addr_r[6:3]==IO_BYTE_ACCESS));

    end

///////////////////////////////////////////////////////////////////////////
///////////////////// CORE BROADCAST MESSAGING ////////////////////////////
///////////////////////////////////////////////////////////////////////////

// Any write after the coherent point would become a message. No registering
// to save a clock cycle, assuming proper power of 2 COHERENT START
assign core_msg_data  = dmem_wr_data;
assign core_msg_addr  = dmem_addr[DMEM_ADDR_WIDTH-1:0];
assign core_msg_strb  = dmem_word_write_mask[3:0];
assign core_msg_valid = dmem_v && dmem_wr_en && ext_dmem_ready && 
      (dmem_addr >= COHERENT_START) && (dmem_addr < (1 << DMEM_ADDR_WIDTH));

endmodule
