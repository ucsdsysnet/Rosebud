/*

Copyright (c) 2018 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * Ultrascale PCIe AXI DMA Write
 */
module pcie_us_axi_dma_wr #
(
    // Width of PCIe AXI stream interfaces in bits
    parameter AXIS_PCIE_DATA_WIDTH = 256,
    // PCIe AXI stream tkeep signal width (words per cycle)
    parameter AXIS_PCIE_KEEP_WIDTH = (AXIS_PCIE_DATA_WIDTH/32),
    // Width of AXI data bus in bits
    parameter AXI_DATA_WIDTH = AXIS_PCIE_DATA_WIDTH,
    // Width of AXI address bus in bits
    parameter AXI_ADDR_WIDTH = 64,
    // Width of AXI wstrb (width of data bus in words)
    parameter AXI_STRB_WIDTH = (AXI_DATA_WIDTH/8),
    // Width of AXI ID signal
    parameter AXI_ID_WIDTH = 8,
    // Maximum AXI burst length to generate
    parameter AXI_MAX_BURST_LEN = 256,
    // PCIe address width
    parameter PCIE_ADDR_WIDTH = 64,
    // Length field width
    parameter LEN_WIDTH = 20,
    // Tag field width
    parameter TAG_WIDTH = 8
)
(
    input  wire                            clk,
    input  wire                            rst,

    /*
     * AXI input (RQ from read DMA)
     */
    input  wire [AXIS_PCIE_DATA_WIDTH-1:0] s_axis_rq_tdata,
    input  wire [AXIS_PCIE_KEEP_WIDTH-1:0] s_axis_rq_tkeep,
    input  wire                            s_axis_rq_tvalid,
    output wire                            s_axis_rq_tready,
    input  wire                            s_axis_rq_tlast,
    input  wire [59:0]                     s_axis_rq_tuser,

    /*
     * AXI output (RQ)
     */
    output wire [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_rq_tdata,
    output wire [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_rq_tkeep,
    output wire                            m_axis_rq_tvalid,
    input  wire                            m_axis_rq_tready,
    output wire                            m_axis_rq_tlast,
    output wire [59:0]                     m_axis_rq_tuser,

    /*
     * AXI write descriptor input
     */
    input  wire [PCIE_ADDR_WIDTH-1:0]      s_axis_write_desc_pcie_addr,
    input  wire [AXI_ADDR_WIDTH-1:0]       s_axis_write_desc_axi_addr,
    input  wire [LEN_WIDTH-1:0]            s_axis_write_desc_len,
    input  wire [TAG_WIDTH-1:0]            s_axis_write_desc_tag,
    input  wire                            s_axis_write_desc_valid,
    output wire                            s_axis_write_desc_ready,

    /*
     * AXI write descriptor status output
     */
    output wire [TAG_WIDTH-1:0]            m_axis_write_desc_status_tag,
    output wire                            m_axis_write_desc_status_valid,

    /*
     * AXI master interface
     */
    output wire [AXI_ID_WIDTH-1:0]         m_axi_arid,
    output wire [AXI_ADDR_WIDTH-1:0]       m_axi_araddr,
    output wire [7:0]                      m_axi_arlen,
    output wire [2:0]                      m_axi_arsize,
    output wire [1:0]                      m_axi_arburst,
    output wire                            m_axi_arlock,
    output wire [3:0]                      m_axi_arcache,
    output wire [2:0]                      m_axi_arprot,
    output wire                            m_axi_arvalid,
    input  wire                            m_axi_arready,
    input  wire [AXI_ID_WIDTH-1:0]         m_axi_rid,
    input  wire [AXI_DATA_WIDTH-1:0]       m_axi_rdata,
    input  wire [1:0]                      m_axi_rresp,
    input  wire                            m_axi_rlast,
    input  wire                            m_axi_rvalid,
    output wire                            m_axi_rready,

    /*
     * Configuration
     */
    input  wire                            enable,
    input  wire [15:0]                     requester_id,
    input  wire                            requester_id_enable,
    input  wire [2:0]                      max_payload_size
);

parameter AXI_WORD_WIDTH = AXI_STRB_WIDTH;
parameter AXI_WORD_SIZE = AXI_DATA_WIDTH/AXI_WORD_WIDTH;
parameter AXI_BURST_SIZE = $clog2(AXI_STRB_WIDTH);
parameter AXI_MAX_BURST_SIZE = AXI_MAX_BURST_LEN*AXI_WORD_WIDTH;

parameter AXIS_PCIE_WORD_WIDTH = AXIS_PCIE_KEEP_WIDTH;
parameter AXIS_PCIE_WORD_SIZE = AXIS_PCIE_DATA_WIDTH/AXIS_PCIE_WORD_WIDTH;

parameter OFFSET_WIDTH = $clog2(AXI_DATA_WIDTH/8);
parameter WORD_LEN_WIDTH = LEN_WIDTH - $clog2(AXIS_PCIE_KEEP_WIDTH);
parameter CYCLE_COUNT_WIDTH = 13-AXI_BURST_SIZE;

parameter TLP_CMD_FIFO_ADDR_WIDTH = 3;

// bus width assertions
initial begin
    if (AXIS_PCIE_DATA_WIDTH != 64 && AXIS_PCIE_DATA_WIDTH != 128 && AXIS_PCIE_DATA_WIDTH != 256) begin
        $error("Error: PCIe interface width must be 64, 128, or 256 (instance %m)");
        $finish;
    end

    if (AXIS_PCIE_KEEP_WIDTH * 32 != AXIS_PCIE_DATA_WIDTH) begin
        $error("Error: PCIe interface requires dword (32-bit) granularity (instance %m)");
        $finish;
    end

    if (AXI_DATA_WIDTH != AXIS_PCIE_DATA_WIDTH) begin
        $error("Error: AXI interface width must match PCIe interface width (instance %m)");
        $finish;
    end

    if (AXI_STRB_WIDTH * 8 != AXI_DATA_WIDTH) begin
        $error("Error: AXI interface requires byte (8-bit) granularity (instance %m)");
        $finish;
    end

    if (AXI_MAX_BURST_LEN < 1 || AXI_MAX_BURST_LEN > 256) begin
        $error("Error: AXI_MAX_BURST_LEN must be between 1 and 256 (instance %m)");
        $finish;
    end
end

localparam [3:0]
    REQ_MEM_READ = 4'b0000,
    REQ_MEM_WRITE = 4'b0001,
    REQ_IO_READ = 4'b0010,
    REQ_IO_WRITE = 4'b0011,
    REQ_MEM_FETCH_ADD = 4'b0100,
    REQ_MEM_SWAP = 4'b0101,
    REQ_MEM_CAS = 4'b0110,
    REQ_MEM_READ_LOCKED = 4'b0111,
    REQ_CFG_READ_0 = 4'b1000,
    REQ_CFG_READ_1 = 4'b1001,
    REQ_CFG_WRITE_0 = 4'b1010,
    REQ_CFG_WRITE_1 = 4'b1011,
    REQ_MSG = 4'b1100,
    REQ_MSG_VENDOR = 4'b1101,
    REQ_MSG_ATS = 4'b1110;

localparam [2:0]
    CPL_STATUS_SC  = 3'b000, // successful completion
    CPL_STATUS_UR  = 3'b001, // unsupported request
    CPL_STATUS_CRS = 3'b010, // configuration request retry status
    CPL_STATUS_CA  = 3'b100; // completer abort

localparam [1:0]
    AXI_STATE_IDLE = 2'd0,
    AXI_STATE_START = 2'd1,
    AXI_STATE_REQ = 2'd2;

reg [1:0] axi_state_reg = AXI_STATE_IDLE, axi_state_next;

localparam [2:0]
    TLP_STATE_IDLE = 3'd0,
    TLP_STATE_HEADER_1 = 3'd1,
    TLP_STATE_HEADER_2 = 3'd2,
    TLP_STATE_TRANSFER = 3'd3,
    TLP_STATE_PASSTHROUGH = 3'd4;

reg [2:0] tlp_state_reg = TLP_STATE_IDLE, tlp_state_next;

// datapath control signals
reg transfer_in_save;

reg tlp_cmd_ready;

reg [PCIE_ADDR_WIDTH-1:0] pcie_addr_reg = {PCIE_ADDR_WIDTH{1'b0}}, pcie_addr_next;
reg [AXI_ADDR_WIDTH-1:0] axi_addr_reg = {AXI_ADDR_WIDTH{1'b0}}, axi_addr_next;
reg [LEN_WIDTH-1:0] op_count_reg = {LEN_WIDTH{1'b0}}, op_count_next;
reg [LEN_WIDTH-1:0] tr_count_reg = {LEN_WIDTH{1'b0}}, tr_count_next;
reg [LEN_WIDTH-1:0] tlp_count_reg = {LEN_WIDTH{1'b0}}, tlp_count_next;

reg [PCIE_ADDR_WIDTH-1:0] tlp_addr_reg = {PCIE_ADDR_WIDTH{1'b0}}, tlp_addr_next;
reg [11:0] tlp_len_reg = 12'd0, tlp_len_next;
reg [OFFSET_WIDTH-1:0] offset_reg = {OFFSET_WIDTH{1'b0}}, offset_next;
reg [9:0] dword_count_reg = 10'd0, dword_count_next;
reg [CYCLE_COUNT_WIDTH-1:0] input_cycle_count_reg = {CYCLE_COUNT_WIDTH{1'b0}}, input_cycle_count_next;
reg [CYCLE_COUNT_WIDTH-1:0] output_cycle_count_reg = {CYCLE_COUNT_WIDTH{1'b0}}, output_cycle_count_next;
reg input_active_reg = 1'b0, input_active_next;
reg bubble_cycle_reg = 1'b0, bubble_cycle_next;
reg last_cycle_reg = 1'b0, last_cycle_next;
reg last_tlp_reg = 1'b0, last_tlp_next;
reg [TAG_WIDTH-1:0] tag_reg = {TAG_WIDTH{1'b0}}, tag_next;

reg [PCIE_ADDR_WIDTH-1:0] tlp_cmd_addr_reg = {PCIE_ADDR_WIDTH{1'b0}}, tlp_cmd_addr_next;
reg [11:0] tlp_cmd_len_reg = 12'd0, tlp_cmd_len_next;
reg [9:0] tlp_cmd_dword_len_reg = 10'd0, tlp_cmd_dword_len_next;
reg [CYCLE_COUNT_WIDTH-1:0] tlp_cmd_input_cycle_len_reg = {CYCLE_COUNT_WIDTH{1'b0}}, tlp_cmd_input_cycle_len_next;
reg [CYCLE_COUNT_WIDTH-1:0] tlp_cmd_output_cycle_len_reg = {CYCLE_COUNT_WIDTH{1'b0}}, tlp_cmd_output_cycle_len_next;
reg [OFFSET_WIDTH-1:0] tlp_cmd_offset_reg = {OFFSET_WIDTH{1'b0}}, tlp_cmd_offset_next;
reg [TAG_WIDTH-1:0] tlp_cmd_tag_reg = {TAG_WIDTH{1'b0}}, tlp_cmd_tag_next;
reg tlp_cmd_bubble_cycle_reg = 1'b0, tlp_cmd_bubble_cycle_next;
reg tlp_cmd_last_reg = 1'b0, tlp_cmd_last_next;
reg tlp_cmd_valid_reg = 1'b0, tlp_cmd_valid_next;

reg [10:0] max_payload_size_dw_reg = 11'd0;

reg s_axis_rq_tready_reg = 1'b0, s_axis_rq_tready_next;

reg s_axis_write_desc_ready_reg = 1'b0, s_axis_write_desc_ready_next;

reg [TAG_WIDTH-1:0] m_axis_write_desc_status_tag_reg = {TAG_WIDTH{1'b0}}, m_axis_write_desc_status_tag_next;
reg m_axis_write_desc_status_valid_reg = 1'b0, m_axis_write_desc_status_valid_next;

reg [AXI_ADDR_WIDTH-1:0] m_axi_araddr_reg = {AXI_ADDR_WIDTH{1'b0}}, m_axi_araddr_next;
reg [7:0] m_axi_arlen_reg = 8'd0, m_axi_arlen_next;
reg m_axi_arvalid_reg = 1'b0, m_axi_arvalid_next;
reg m_axi_rready_reg = 1'b0, m_axi_rready_next;

reg [AXI_DATA_WIDTH-1:0] save_axi_rdata_reg = {AXI_DATA_WIDTH{1'b0}};

wire [AXI_DATA_WIDTH-1:0] shift_axi_rdata = {m_axi_rdata, save_axi_rdata_reg} >> ((AXI_STRB_WIDTH-offset_reg)*AXI_WORD_SIZE);

// internal datapath
reg  [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_rq_tdata_int;
reg  [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_rq_tkeep_int;
reg                             m_axis_rq_tvalid_int;
reg                             m_axis_rq_tready_int_reg = 1'b0;
reg                             m_axis_rq_tlast_int;
reg  [59:0]                     m_axis_rq_tuser_int;
wire                            m_axis_rq_tready_int_early;

assign s_axis_rq_tready = s_axis_rq_tready_reg;

assign s_axis_write_desc_ready = s_axis_write_desc_ready_reg;

assign m_axis_write_desc_status_tag = m_axis_write_desc_status_tag_reg;
assign m_axis_write_desc_status_valid = m_axis_write_desc_status_valid_reg;

assign m_axi_arid = {AXI_ID_WIDTH{1'b0}};
assign m_axi_araddr = m_axi_araddr_reg;
assign m_axi_arlen = m_axi_arlen_reg;
assign m_axi_arsize = AXI_BURST_SIZE;
assign m_axi_arburst = 2'b01;
assign m_axi_arlock = 1'b0;
assign m_axi_arcache = 4'b0011;
assign m_axi_arprot = 3'b010;
assign m_axi_arvalid = m_axi_arvalid_reg;
assign m_axi_rready = m_axi_rready_reg;

wire [PCIE_ADDR_WIDTH-1:0] pcie_addr_plus_max_payload = pcie_addr_reg + {max_payload_size_dw_reg, 2'b00};
wire [PCIE_ADDR_WIDTH-1:0] pcie_addr_plus_op_count = pcie_addr_reg + op_count_reg;
wire [PCIE_ADDR_WIDTH-1:0] pcie_addr_plus_tlp_count = pcie_addr_reg + tlp_count_reg;

wire [AXI_ADDR_WIDTH-1:0] axi_addr_plus_max_burst = axi_addr_reg + AXI_MAX_BURST_SIZE;
wire [AXI_ADDR_WIDTH-1:0] axi_addr_plus_op_count = axi_addr_reg + op_count_reg;
wire [AXI_ADDR_WIDTH-1:0] axi_addr_plus_tlp_count = axi_addr_reg + tlp_count_reg;

always @* begin
    axi_state_next = AXI_STATE_IDLE;

    s_axis_write_desc_ready_next = 1'b0;

    m_axi_araddr_next = m_axi_araddr_reg;
    m_axi_arlen_next = m_axi_arlen_reg;
    m_axi_arvalid_next = m_axi_arvalid_reg && !m_axi_arready;

    pcie_addr_next = pcie_addr_reg;
    axi_addr_next = axi_addr_reg;
    op_count_next = op_count_reg;
    tr_count_next = tr_count_reg;
    tlp_count_next = tlp_count_reg;

    tlp_cmd_addr_next = tlp_cmd_addr_reg;
    tlp_cmd_len_next = tlp_cmd_len_reg;
    tlp_cmd_dword_len_next = tlp_cmd_dword_len_reg;
    tlp_cmd_input_cycle_len_next = tlp_cmd_input_cycle_len_reg;
    tlp_cmd_output_cycle_len_next = tlp_cmd_output_cycle_len_reg;
    tlp_cmd_offset_next = tlp_cmd_offset_reg;
    tlp_cmd_tag_next = tlp_cmd_tag_reg;
    tlp_cmd_bubble_cycle_next = tlp_cmd_bubble_cycle_reg;
    tlp_cmd_last_next = tlp_cmd_last_reg;
    tlp_cmd_valid_next = tlp_cmd_valid_reg && !tlp_cmd_ready;

    // TLP segmentation and AXI read request generation
    case (axi_state_reg)
        AXI_STATE_IDLE: begin
            // idle state, wait for incoming descriptor
            s_axis_write_desc_ready_next = !tlp_cmd_valid_reg && enable;

            if (s_axis_write_desc_ready & s_axis_write_desc_valid) begin
                s_axis_write_desc_ready_next = 1'b0;
                pcie_addr_next = s_axis_write_desc_pcie_addr;
                axi_addr_next = s_axis_write_desc_axi_addr;
                op_count_next = s_axis_write_desc_len;
                tlp_cmd_tag_next = s_axis_write_desc_tag;
                axi_state_next = AXI_STATE_START;
            end else begin
                axi_state_next = AXI_STATE_IDLE;
            end
        end
        AXI_STATE_START: begin
            // start state, compute TLP length
            if (!tlp_cmd_valid_reg) begin
                if (op_count_reg <= {max_payload_size_dw_reg, 2'b00}-pcie_addr_reg[1:0]) begin
                    // packet smaller than max payload size
                    if (pcie_addr_reg[12] != pcie_addr_plus_op_count[12]) begin
                        // crosses 4k boundary
                        tlp_count_next = 13'h1000 - pcie_addr_reg[11:0];
                    end else begin
                        // does not cross 4k boundary, send one TLP
                        tlp_count_next = op_count_reg;
                    end
                end else begin
                    // packet larger than max payload size
                    if (pcie_addr_reg[12] != pcie_addr_plus_max_payload[12]) begin
                        // crosses 4k boundary
                        tlp_count_next = 13'h1000 - pcie_addr_reg[11:0];
                    end else begin
                        // does not cross 4k boundary, send one TLP
                        tlp_count_next = {max_payload_size_dw_reg, 2'b00}-pcie_addr_reg[1:0];
                    end
                end

                tlp_cmd_input_cycle_len_next = (tlp_count_next + axi_addr_reg[OFFSET_WIDTH-1:0] - 1) >> AXI_BURST_SIZE;
                if (AXIS_PCIE_DATA_WIDTH == 256) begin
                    tlp_cmd_output_cycle_len_next = (tlp_count_next + 16+pcie_addr_reg[1:0] - 1) >> AXI_BURST_SIZE;
                end else begin
                    tlp_cmd_output_cycle_len_next = (tlp_count_next + pcie_addr_reg[1:0] - 1) >> AXI_BURST_SIZE;
                end

                pcie_addr_next = pcie_addr_reg + tlp_count_next;
                op_count_next = op_count_reg - tlp_count_next;

                tlp_cmd_addr_next = pcie_addr_reg;
                tlp_cmd_len_next = tlp_count_next;
                tlp_cmd_dword_len_next = (tlp_count_next + pcie_addr_reg[1:0] + 3) >> 2;
                if (AXIS_PCIE_DATA_WIDTH == 256) begin
                    tlp_cmd_offset_next = 16+pcie_addr_reg[1:0]-axi_addr_reg[OFFSET_WIDTH-1:0];
                    tlp_cmd_bubble_cycle_next = axi_addr_reg[OFFSET_WIDTH-1:0] > 16+pcie_addr_reg[1:0];
                end else begin
                    tlp_cmd_offset_next = pcie_addr_reg[1:0]-axi_addr_reg[OFFSET_WIDTH-1:0];
                    tlp_cmd_bubble_cycle_next = axi_addr_reg[OFFSET_WIDTH-1:0] > pcie_addr_reg[1:0];
                end
                tlp_cmd_last_next = op_count_next == 0;
                tlp_cmd_valid_next = 1'b1;

                axi_state_next = AXI_STATE_REQ;
            end else begin
                axi_state_next = AXI_STATE_START;
            end
        end
        AXI_STATE_REQ: begin
            // request state, generate AXI read requests
            if (!m_axi_arvalid) begin
                if (tlp_count_reg <= AXI_MAX_BURST_SIZE-axi_addr_reg[OFFSET_WIDTH-1:0]) begin
                    // packet smaller than max burst size
                    if (axi_addr_reg[12] != axi_addr_plus_tlp_count[12]) begin
                        // crosses 4k boundary
                        tr_count_next = 13'h1000 - axi_addr_reg[11:0];
                    end else begin
                        // does not cross 4k boundary, send one request
                        tr_count_next = tlp_count_reg;
                    end
                end else begin
                    // packet larger than max burst size
                    if (axi_addr_reg[12] != axi_addr_plus_max_burst[12]) begin
                        // crosses 4k boundary
                        tr_count_next = 13'h1000 - axi_addr_reg[11:0];
                    end else begin
                        // does not cross 4k boundary, send one request
                        tr_count_next = AXI_MAX_BURST_SIZE - axi_addr_reg[OFFSET_WIDTH-1:0];
                    end
                end

                m_axi_araddr_next = axi_addr_reg;
                m_axi_arlen_next = (tr_count_next + axi_addr_reg[OFFSET_WIDTH-1:0] - 1) >> AXI_BURST_SIZE;
                m_axi_arvalid_next = 1;

                axi_addr_next = axi_addr_reg + tr_count_next;
                tlp_count_next = tlp_count_reg - tr_count_next;

                if (tlp_count_next != 0) begin
                    axi_state_next = AXI_STATE_REQ;
                end else if (op_count_next != 0) begin
                    axi_state_next = AXI_STATE_START;
                end else begin
                    s_axis_write_desc_ready_next = !tlp_cmd_valid_reg && enable;
                    axi_state_next = AXI_STATE_IDLE;
                end
            end else begin
                axi_state_next = AXI_STATE_REQ;
            end
        end
    endcase
end

wire [3:0] first_be = 4'b1111 << tlp_addr_reg[1:0];
wire [3:0] last_be = 4'b1111 >> (3 - ((tlp_addr_reg[1:0] + tlp_len_reg[1:0] - 1) & 3));

always @* begin
    tlp_state_next = TLP_STATE_IDLE;

    transfer_in_save = 1'b0;

    tlp_cmd_ready = 1'b0;

    s_axis_rq_tready_next = 1'b0;

    m_axis_write_desc_status_tag_next = m_axis_write_desc_status_tag_reg;
    m_axis_write_desc_status_valid_next = 1'b0;

    m_axi_rready_next = 1'b0;

    tlp_addr_next = tlp_addr_reg;
    tlp_len_next = tlp_len_reg;
    dword_count_next = dword_count_reg;
    offset_next = offset_reg;
    input_cycle_count_next = input_cycle_count_reg;
    output_cycle_count_next = output_cycle_count_reg;
    input_active_next = input_active_reg;
    bubble_cycle_next = bubble_cycle_reg;
    last_cycle_next = last_cycle_reg;
    last_tlp_next = last_tlp_reg;
    tag_next = tag_reg;

    m_axis_rq_tdata_int = {AXIS_PCIE_DATA_WIDTH{1'b0}};
    m_axis_rq_tkeep_int = {AXIS_PCIE_KEEP_WIDTH{1'b0}};
    m_axis_rq_tvalid_int = 1'b0;
    m_axis_rq_tlast_int = 1'b0;
    m_axis_rq_tuser_int = 60'd0;

    m_axis_rq_tdata_int[1:0] = 2'b0; // address type
    m_axis_rq_tdata_int[63:2] = tlp_addr_reg[PCIE_ADDR_WIDTH-1:2]; // address
    if (AXIS_PCIE_DATA_WIDTH > 64) begin
        m_axis_rq_tdata_int[74:64] = dword_count_reg; // DWORD count
        m_axis_rq_tdata_int[78:75] = REQ_MEM_WRITE; // request type - memory write
        m_axis_rq_tdata_int[79] = 1'b0; // poisoned request
        m_axis_rq_tdata_int[95:80] = requester_id;
        m_axis_rq_tdata_int[103:96] = 8'd0; // tag
        m_axis_rq_tdata_int[119:104] = 16'd0; // completer ID
        m_axis_rq_tdata_int[120] = requester_id_enable; // requester ID enable
        m_axis_rq_tdata_int[123:121] = 3'b000; // traffic class
        m_axis_rq_tdata_int[126:124] = 3'b000; // attr
        m_axis_rq_tdata_int[127] = 1'b0; // force ECRC
    end

    if (AXIS_PCIE_DATA_WIDTH == 256) begin
        m_axis_rq_tkeep_int = 8'b00001111;
    end else if (AXIS_PCIE_DATA_WIDTH == 128) begin
        m_axis_rq_tkeep_int = 4'b1111;
    end else if (AXIS_PCIE_DATA_WIDTH == 64) begin
        m_axis_rq_tkeep_int = 2'b11;
    end

    m_axis_rq_tuser_int[3:0] = dword_count_reg == 1 ? first_be & last_be : first_be; // first BE
    m_axis_rq_tuser_int[7:4] = dword_count_reg == 1 ? 4'b0000 : last_be; // last BE
    m_axis_rq_tuser_int[10:8] = 3'd0; // addr_offset
    m_axis_rq_tuser_int[11] = 1'b0; // discontinue
    m_axis_rq_tuser_int[12] = 1'b0; // tph_present
    m_axis_rq_tuser_int[14:13] = 2'b00; // tph_type
    m_axis_rq_tuser_int[15] = 1'b0; // tph_indirect_tag_en
    m_axis_rq_tuser_int[23:16] = 8'd0; // tph_st_tag
    m_axis_rq_tuser_int[27:24] = 4'd0; // seq_num
    m_axis_rq_tuser_int[59:28] = 32'd0; // parity

    // AXI read response processing and TLP generation
    case (tlp_state_reg)
        TLP_STATE_IDLE: begin
            // idle state, wait for command
            s_axis_rq_tready_next = m_axis_rq_tready_int_early;

            // pass through read request TLP
            m_axis_rq_tdata_int = s_axis_rq_tdata;
            m_axis_rq_tkeep_int = s_axis_rq_tkeep;
            m_axis_rq_tvalid_int = s_axis_rq_tready && s_axis_rq_tvalid;
            m_axis_rq_tlast_int = s_axis_rq_tlast;
            m_axis_rq_tuser_int = s_axis_rq_tuser;

            m_axi_rready_next = 1'b0;

            tlp_addr_next = tlp_cmd_addr_reg;
            tlp_len_next = tlp_cmd_len_reg;
            dword_count_next = tlp_cmd_dword_len_reg;
            offset_next = tlp_cmd_offset_reg;
            input_cycle_count_next = tlp_cmd_input_cycle_len_reg;
            output_cycle_count_next = tlp_cmd_output_cycle_len_reg;
            input_active_next = 1'b1;
            bubble_cycle_next = tlp_cmd_bubble_cycle_reg;
            last_cycle_next = tlp_cmd_output_cycle_len_reg == 0;
            last_tlp_next = tlp_cmd_last_reg;
            tag_next = tlp_cmd_tag_reg;

            if (s_axis_rq_tready && s_axis_rq_tvalid) begin
                // pass through read request TLP
                if (s_axis_rq_tlast) begin
                    tlp_state_next = TLP_STATE_IDLE;
                end else begin
                    tlp_state_next = TLP_STATE_PASSTHROUGH;
                end
            end else if (tlp_cmd_valid_reg) begin
                s_axis_rq_tready_next = 1'b0;
                tlp_cmd_ready = 1'b1;
                if (AXIS_PCIE_DATA_WIDTH == 256) begin
                    m_axi_rready_next = m_axis_rq_tready_int_early;
                end else if (AXIS_PCIE_DATA_WIDTH == 128) begin
                    m_axi_rready_next = m_axis_rq_tready_int_early && bubble_cycle_next;
                end else begin
                    m_axi_rready_next = 1'b0;
                end
                tlp_state_next = TLP_STATE_HEADER_1;
            end else begin
                tlp_state_next = TLP_STATE_IDLE;
            end
        end
        TLP_STATE_HEADER_1: begin
            // header 1 state, send TLP header
            if (AXIS_PCIE_DATA_WIDTH == 256) begin
                m_axi_rready_next = m_axis_rq_tready_int_early && input_active_reg;

                if (m_axis_rq_tready_int_reg && ((m_axi_rready && m_axi_rvalid) || !input_active_reg)) begin
                    transfer_in_save = m_axi_rready && m_axi_rvalid;

                    if (bubble_cycle_reg) begin
                        if (input_active_reg) begin
                            input_cycle_count_next = input_cycle_count_reg - 1;
                            input_active_next = input_cycle_count_reg != 0;
                        end
                        bubble_cycle_next = 1'b0;
                        m_axi_rready_next = m_axis_rq_tready_int_early && input_active_next;
                        tlp_state_next = TLP_STATE_HEADER_1;
                    end else begin
                        dword_count_next = dword_count_reg - 4;
                        if (input_active_reg) begin
                            input_cycle_count_next = input_cycle_count_reg - 1;
                            input_active_next = input_cycle_count_reg != 0;
                        end
                        output_cycle_count_next = output_cycle_count_reg - 1;
                        last_cycle_next = output_cycle_count_next == 0;

                        m_axis_rq_tdata_int[255:128] = shift_axi_rdata[255:128];
                        m_axis_rq_tvalid_int = 1'b1;
                        if (dword_count_reg >= 4) begin
                            m_axis_rq_tkeep_int = 8'b11111111;
                        end else begin
                            m_axis_rq_tkeep_int = 8'b11111111 >> (4 - dword_count_reg);
                        end

                        if (last_cycle_reg) begin
                            m_axis_rq_tlast_int = 1'b1;
                            if (last_tlp_reg) begin
                                m_axis_write_desc_status_tag_next = tag_reg;
                                m_axis_write_desc_status_valid_next = 1'b1;
                            end

                            // skip idle state if possible
                            tlp_addr_next = tlp_cmd_addr_reg;
                            tlp_len_next = tlp_cmd_len_reg;
                            dword_count_next = tlp_cmd_dword_len_reg;
                            offset_next = tlp_cmd_offset_reg;
                            input_cycle_count_next = tlp_cmd_input_cycle_len_reg;
                            output_cycle_count_next = tlp_cmd_output_cycle_len_reg;
                            input_active_next = 1'b1;
                            bubble_cycle_next = tlp_cmd_bubble_cycle_reg;
                            last_cycle_next = tlp_cmd_output_cycle_len_reg == 0;
                            last_tlp_next = tlp_cmd_last_reg;
                            tag_next = tlp_cmd_tag_reg;

                            if (tlp_cmd_valid_reg) begin
                                tlp_cmd_ready = 1'b1;
                                if (AXIS_PCIE_DATA_WIDTH == 256) begin
                                    m_axi_rready_next = m_axis_rq_tready_int_early;
                                end else if (AXIS_PCIE_DATA_WIDTH == 128) begin
                                    m_axi_rready_next = m_axis_rq_tready_int_early && bubble_cycle_next;
                                end else begin
                                    m_axi_rready_next = 1'b0;
                                end
                                tlp_state_next = TLP_STATE_HEADER_1;
                            end else begin
                                s_axis_rq_tready_next = m_axis_rq_tready_int_early;
                                m_axi_rready_next = 0;
                                tlp_state_next = TLP_STATE_IDLE;
                            end
                        end else begin
                            m_axi_rready_next = m_axis_rq_tready_int_early && input_active_next;
                            tlp_state_next = TLP_STATE_TRANSFER;
                        end
                    end
                end else begin
                    tlp_state_next = TLP_STATE_HEADER_1;
                end
            end else begin
                if (m_axis_rq_tready_int_reg) begin
                    m_axis_rq_tvalid_int = 1'b1;

                    if (AXIS_PCIE_DATA_WIDTH == 128) begin
                        m_axi_rready_next = m_axis_rq_tready_int_early;
                        if ((m_axi_rready && m_axi_rvalid) && bubble_cycle_reg) begin
                            transfer_in_save = 1'b1;
                            if (input_active_reg) begin
                                input_cycle_count_next = input_cycle_count_reg - 1;
                                input_active_next = input_cycle_count_reg != 0;
                            end
                            bubble_cycle_next = 1'b0;
                            m_axi_rready_next = m_axis_rq_tready_int_early && input_active_next;
                        end
                        tlp_state_next = TLP_STATE_TRANSFER;
                    end else begin
                        m_axi_rready_next = m_axis_rq_tready_int_early && bubble_cycle_reg;
                        tlp_state_next = TLP_STATE_HEADER_2;
                    end
                end else begin
                    tlp_state_next = TLP_STATE_HEADER_1;
                end
            end
        end
        TLP_STATE_HEADER_2: begin
            // header 2 state, send rest of TLP header (64 bit interface only)
            if (m_axis_rq_tready_int_reg) begin
                m_axis_rq_tdata_int[10:0] = dword_count_reg; // DWORD count
                m_axis_rq_tdata_int[14:11] = 4'b0001; // request type - memory write
                m_axis_rq_tdata_int[15] = 1'b0; // poisoned request
                m_axis_rq_tdata_int[31:16] = requester_id;
                m_axis_rq_tdata_int[39:32] = 8'd0; // tag
                m_axis_rq_tdata_int[55:40] = 16'd0; // completer ID
                m_axis_rq_tdata_int[56] = requester_id_enable; // requester ID enable
                m_axis_rq_tdata_int[59:57] = 3'b000; // traffic class
                m_axis_rq_tdata_int[62:60] = 3'b000; // attr
                m_axis_rq_tdata_int[63] = 1'b0; // force ECRC
                m_axis_rq_tvalid_int = 1'b1;
                m_axis_rq_tkeep_int = 2'b11;

                m_axi_rready_next = m_axis_rq_tready_int_early;
                if ((m_axi_rready && m_axi_rvalid) && bubble_cycle_reg) begin
                    transfer_in_save = 1'b1;
                    if (input_active_reg) begin
                        input_cycle_count_next = input_cycle_count_reg - 1;
                        input_active_next = input_cycle_count_reg != 0;
                    end
                    bubble_cycle_next = 1'b0;
                    m_axi_rready_next = m_axis_rq_tready_int_early && input_active_next;
                end
                tlp_state_next = TLP_STATE_TRANSFER;
            end else begin
                tlp_state_next = TLP_STATE_HEADER_2;
            end
        end
        TLP_STATE_TRANSFER: begin
            // transfer state, transfer data
            m_axi_rready_next = m_axis_rq_tready_int_early && input_active_reg;

            if (m_axis_rq_tready_int_reg && ((m_axi_rready && m_axi_rvalid) || !input_active_reg)) begin
                transfer_in_save = 1'b1;

                if (bubble_cycle_reg) begin
                    if (input_active_reg) begin
                        input_cycle_count_next = input_cycle_count_reg - 1;
                        input_active_next = input_cycle_count_reg != 0;
                    end
                    bubble_cycle_next = 1'b0;
                    m_axi_rready_next = m_axis_rq_tready_int_early && input_active_next;
                    tlp_state_next = TLP_STATE_TRANSFER;
                end else begin
                    dword_count_next = dword_count_reg - AXI_STRB_WIDTH/4;
                    if (input_active_reg) begin
                        input_cycle_count_next = input_cycle_count_reg - 1;
                        input_active_next = input_cycle_count_reg != 0;
                    end
                    output_cycle_count_next = output_cycle_count_reg - 1;
                    last_cycle_next = output_cycle_count_next == 0;

                    m_axis_rq_tdata_int = shift_axi_rdata;
                    m_axis_rq_tvalid_int = 1'b1;
                    if (dword_count_reg >= AXI_STRB_WIDTH/4) begin
                        m_axis_rq_tkeep_int = {AXI_STRB_WIDTH{1'b1}};
                    end else begin
                        m_axis_rq_tkeep_int = {AXI_STRB_WIDTH{1'b1}} >> (AXI_STRB_WIDTH - dword_count_reg);
                    end

                    if (last_cycle_reg) begin
                        m_axis_rq_tlast_int = 1'b1;
                        if (last_tlp_reg) begin
                            m_axis_write_desc_status_tag_next = tag_reg;
                            m_axis_write_desc_status_valid_next = 1'b1;
                        end

                        // skip idle state if possible
                        tlp_addr_next = tlp_cmd_addr_reg;
                        tlp_len_next = tlp_cmd_len_reg;
                        dword_count_next = tlp_cmd_dword_len_reg;
                        offset_next = tlp_cmd_offset_reg;
                        input_cycle_count_next = tlp_cmd_input_cycle_len_reg;
                        output_cycle_count_next = tlp_cmd_output_cycle_len_reg;
                        input_active_next = 1'b1;
                        bubble_cycle_next = tlp_cmd_bubble_cycle_reg;
                        last_cycle_next = tlp_cmd_output_cycle_len_reg == 0;
                        last_tlp_next = tlp_cmd_last_reg;
                        tag_next = tlp_cmd_tag_reg;

                        if (tlp_cmd_valid_reg) begin
                            tlp_cmd_ready = 1'b1;
                            if (AXIS_PCIE_DATA_WIDTH == 256) begin
                                m_axi_rready_next = m_axis_rq_tready_int_early;
                            end else if (AXIS_PCIE_DATA_WIDTH == 128) begin
                                m_axi_rready_next = m_axis_rq_tready_int_early && bubble_cycle_next;
                            end else begin
                                m_axi_rready_next = 1'b0;
                            end
                            tlp_state_next = TLP_STATE_HEADER_1;
                        end else begin
                            s_axis_rq_tready_next = m_axis_rq_tready_int_early;
                            m_axi_rready_next = 0;
                            tlp_state_next = TLP_STATE_IDLE;
                        end
                    end else begin
                        m_axi_rready_next = m_axis_rq_tready_int_early && input_active_next;
                        tlp_state_next = TLP_STATE_TRANSFER;
                    end
                end
            end else begin
                tlp_state_next = TLP_STATE_TRANSFER;
            end
        end
        TLP_STATE_PASSTHROUGH: begin
            // passthrough state, pass through read request TLP
            s_axis_rq_tready_next = m_axis_rq_tready_int_early;

            // pass through read request TLP
            m_axis_rq_tdata_int = s_axis_rq_tdata;
            m_axis_rq_tkeep_int = s_axis_rq_tkeep;
            m_axis_rq_tvalid_int = s_axis_rq_tready && s_axis_rq_tvalid;
            m_axis_rq_tlast_int = s_axis_rq_tlast;
            m_axis_rq_tuser_int = s_axis_rq_tuser;

            if (s_axis_rq_tready && s_axis_rq_tvalid && s_axis_rq_tlast) begin
                tlp_state_next = TLP_STATE_IDLE;
            end else begin
                tlp_state_next = TLP_STATE_PASSTHROUGH;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (rst) begin
        axi_state_reg <= AXI_STATE_IDLE;
        tlp_state_reg <= TLP_STATE_IDLE;
        tlp_cmd_valid_reg <= 1'b0;
        s_axis_rq_tready_reg <= 1'b0;
        s_axis_write_desc_ready_reg <= 1'b0;
        m_axis_write_desc_status_valid_reg <= 1'b0;
        m_axi_arvalid_reg <= 1'b0;
        m_axi_rready_reg <= 1'b0;
    end else begin
        axi_state_reg <= axi_state_next;
        tlp_state_reg <= tlp_state_next;
        tlp_cmd_valid_reg <= tlp_cmd_valid_next;
        s_axis_rq_tready_reg <= s_axis_rq_tready_next;
        s_axis_write_desc_ready_reg <= s_axis_write_desc_ready_next;
        m_axis_write_desc_status_valid_reg <= m_axis_write_desc_status_valid_next;
        m_axi_arvalid_reg <= m_axi_arvalid_next;
        m_axi_rready_reg <= m_axi_rready_next;
    end

    pcie_addr_reg <= pcie_addr_next;
    axi_addr_reg <= axi_addr_next;
    op_count_reg <= op_count_next;
    tr_count_reg <= tr_count_next;
    tlp_count_reg <= tlp_count_next;

    tlp_addr_reg <= tlp_addr_next;
    tlp_len_reg <= tlp_len_next;
    dword_count_reg <= dword_count_next;
    offset_reg <= offset_next;
    input_cycle_count_reg <= input_cycle_count_next;
    output_cycle_count_reg <= output_cycle_count_next;
    input_active_reg <= input_active_next;
    bubble_cycle_reg <= bubble_cycle_next;
    last_cycle_reg <= last_cycle_next;
    last_tlp_reg <= last_tlp_next;
    tag_reg <= tag_next;

    tlp_cmd_addr_reg <= tlp_cmd_addr_next;
    tlp_cmd_len_reg <= tlp_cmd_len_next;
    tlp_cmd_dword_len_reg <= tlp_cmd_dword_len_next;
    tlp_cmd_input_cycle_len_reg <= tlp_cmd_input_cycle_len_next;
    tlp_cmd_output_cycle_len_reg <= tlp_cmd_output_cycle_len_next;
    tlp_cmd_offset_reg <= tlp_cmd_offset_next;
    tlp_cmd_bubble_cycle_reg <= tlp_cmd_bubble_cycle_next;
    tlp_cmd_tag_reg <= tlp_cmd_tag_next;
    tlp_cmd_last_reg <= tlp_cmd_last_next;

    m_axis_write_desc_status_tag_reg <= m_axis_write_desc_status_tag_next;

    m_axi_araddr_reg <= m_axi_araddr_next;
    m_axi_arlen_reg <= m_axi_arlen_next;

    max_payload_size_dw_reg <= 11'd32 << (max_payload_size > 5 ? 5 : max_payload_size);

    if (transfer_in_save) begin
        save_axi_rdata_reg <= m_axi_rdata;
    end
end

// output datapath logic (PCIe TLP)
reg [AXIS_PCIE_DATA_WIDTH-1:0] m_axis_rq_tdata_reg = {AXIS_PCIE_DATA_WIDTH{1'b0}};
reg [AXIS_PCIE_KEEP_WIDTH-1:0] m_axis_rq_tkeep_reg = {AXIS_PCIE_KEEP_WIDTH{1'b0}};
reg                            m_axis_rq_tvalid_reg = 1'b0, m_axis_rq_tvalid_next;
reg                            m_axis_rq_tlast_reg = 1'b0;
reg [59:0]                     m_axis_rq_tuser_reg = 60'd0;

reg [AXIS_PCIE_DATA_WIDTH-1:0] temp_m_axis_rq_tdata_reg = {AXIS_PCIE_DATA_WIDTH{1'b0}};
reg [AXIS_PCIE_KEEP_WIDTH-1:0] temp_m_axis_rq_tkeep_reg = {AXIS_PCIE_KEEP_WIDTH{1'b0}};
reg                            temp_m_axis_rq_tvalid_reg = 1'b0, temp_m_axis_rq_tvalid_next;
reg                            temp_m_axis_rq_tlast_reg = 1'b0;
reg [59:0]                     temp_m_axis_rq_tuser_reg = 60'd0;

// datapath control
reg store_axis_rq_int_to_output;
reg store_axis_rq_int_to_temp;
reg store_axis_rq_temp_to_output;

assign m_axis_rq_tdata = m_axis_rq_tdata_reg;
assign m_axis_rq_tkeep = m_axis_rq_tkeep_reg;
assign m_axis_rq_tvalid = m_axis_rq_tvalid_reg;
assign m_axis_rq_tlast = m_axis_rq_tlast_reg;
assign m_axis_rq_tuser = m_axis_rq_tuser_reg;

// enable ready input next cycle if output is ready or the temp reg will not be filled on the next cycle (output reg empty or no input)
assign m_axis_rq_tready_int_early = m_axis_rq_tready || (!temp_m_axis_rq_tvalid_reg && (!m_axis_rq_tvalid_reg || !m_axis_rq_tvalid_int));

always @* begin
    // transfer sink ready state to source
    m_axis_rq_tvalid_next = m_axis_rq_tvalid_reg;
    temp_m_axis_rq_tvalid_next = temp_m_axis_rq_tvalid_reg;

    store_axis_rq_int_to_output = 1'b0;
    store_axis_rq_int_to_temp = 1'b0;
    store_axis_rq_temp_to_output = 1'b0;

    if (m_axis_rq_tready_int_reg) begin
        // input is ready
        if (m_axis_rq_tready || !m_axis_rq_tvalid_reg) begin
            // output is ready or currently not valid, transfer data to output
            m_axis_rq_tvalid_next = m_axis_rq_tvalid_int;
            store_axis_rq_int_to_output = 1'b1;
        end else begin
            // output is not ready, store input in temp
            temp_m_axis_rq_tvalid_next = m_axis_rq_tvalid_int;
            store_axis_rq_int_to_temp = 1'b1;
        end
    end else if (m_axis_rq_tready) begin
        // input is not ready, but output is ready
        m_axis_rq_tvalid_next = temp_m_axis_rq_tvalid_reg;
        temp_m_axis_rq_tvalid_next = 1'b0;
        store_axis_rq_temp_to_output = 1'b1;
    end
end

always @(posedge clk) begin
    if (rst) begin
        m_axis_rq_tvalid_reg <= 1'b0;
        m_axis_rq_tready_int_reg <= 1'b0;
        temp_m_axis_rq_tvalid_reg <= 1'b0;
    end else begin
        m_axis_rq_tvalid_reg <= m_axis_rq_tvalid_next;
        m_axis_rq_tready_int_reg <= m_axis_rq_tready_int_early;
        temp_m_axis_rq_tvalid_reg <= temp_m_axis_rq_tvalid_next;
    end

    // datapath
    if (store_axis_rq_int_to_output) begin
        m_axis_rq_tdata_reg <= m_axis_rq_tdata_int;
        m_axis_rq_tkeep_reg <= m_axis_rq_tkeep_int;
        m_axis_rq_tlast_reg <= m_axis_rq_tlast_int;
        m_axis_rq_tuser_reg <= m_axis_rq_tuser_int;
    end else if (store_axis_rq_temp_to_output) begin
        m_axis_rq_tdata_reg <= temp_m_axis_rq_tdata_reg;
        m_axis_rq_tkeep_reg <= temp_m_axis_rq_tkeep_reg;
        m_axis_rq_tlast_reg <= temp_m_axis_rq_tlast_reg;
        m_axis_rq_tuser_reg <= temp_m_axis_rq_tuser_reg;
    end

    if (store_axis_rq_int_to_temp) begin
        temp_m_axis_rq_tdata_reg <= m_axis_rq_tdata_int;
        temp_m_axis_rq_tkeep_reg <= m_axis_rq_tkeep_int;
        temp_m_axis_rq_tlast_reg <= m_axis_rq_tlast_int;
        temp_m_axis_rq_tuser_reg <= m_axis_rq_tuser_int;
    end
end

endmodule
