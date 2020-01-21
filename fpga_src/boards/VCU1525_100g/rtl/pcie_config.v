module pcie_config # (
  parameter PCIE_ADDR_WIDTH         = 64,
  parameter PCIE_RAM_ADDR_WIDTH     = 32,
  parameter PCIE_DMA_LEN_WIDTH      = 16,
  parameter HOST_DMA_TAG_WIDTH      = 32,
  parameter AXIL_DATA_WIDTH         = 32,
  parameter AXIL_STRB_WIDTH         = (AXIL_DATA_WIDTH/8),
  parameter AXIL_ADDR_WIDTH         = 32,
  parameter CORE_COUNT              = 16,
  parameter CORE_SLOT_WIDTH         = 4,
  parameter CORE_WIDTH              = $clog2(CORE_COUNT),
  parameter IF_COUNT                = 2,
  parameter PORTS_PER_IF            = 1,
  parameter FW_ID                   = 32'd0,
  parameter FW_VER                  = {16'd0, 16'd1},
  parameter BOARD_ID                = {16'h1ce4, 16'h0003},
  parameter BOARD_VER               = {16'd0, 16'd1},
  parameter FPGA_ID                 = 32'h3823093
) (
  input  wire                               sys_clk,
  input  wire                               sys_rst,
  input  wire                               pcie_clk,
  input  wire                               pcie_rst,
 
  // AXI lite
  input  wire [AXIL_ADDR_WIDTH-1:0]         axil_ctrl_awaddr,
  input  wire [2:0]                         axil_ctrl_awprot,
  input  wire                               axil_ctrl_awvalid,
  output reg                                axil_ctrl_awready,
  input  wire [AXIL_DATA_WIDTH-1:0]         axil_ctrl_wdata,
  input  wire [AXIL_STRB_WIDTH-1:0]         axil_ctrl_wstrb,
  input  wire                               axil_ctrl_wvalid,
  output reg                                axil_ctrl_wready,
  output wire [1:0]                         axil_ctrl_bresp,
  output reg                                axil_ctrl_bvalid,
  input  wire                               axil_ctrl_bready,
  input  wire [AXIL_ADDR_WIDTH-1:0]         axil_ctrl_araddr,
  input  wire [2:0]                         axil_ctrl_arprot,
  input  wire                               axil_ctrl_arvalid,
  output reg                                axil_ctrl_arready,
  output reg  [AXIL_DATA_WIDTH-1:0]         axil_ctrl_rdata,
  output wire [1:0]                         axil_ctrl_rresp,
  output reg                                axil_ctrl_rvalid,
  input  wire                               axil_ctrl_rready,

  // DMA requests from Host
  output reg  [PCIE_ADDR_WIDTH-1:0]         host_dma_read_desc_pcie_addr,
  output reg  [PCIE_RAM_ADDR_WIDTH-1:0]     host_dma_read_desc_ram_addr,
  output reg  [PCIE_DMA_LEN_WIDTH-1:0]      host_dma_read_desc_len,
  output reg  [HOST_DMA_TAG_WIDTH-1:0]      host_dma_read_desc_tag,
  output reg                                host_dma_read_desc_valid,
  input  wire                               host_dma_read_desc_ready,
  input  wire [HOST_DMA_TAG_WIDTH-1:0]      host_dma_read_desc_status_tag,
  input  wire                               host_dma_read_desc_status_valid,

  output reg  [PCIE_ADDR_WIDTH-1:0]         host_dma_write_desc_pcie_addr,
  output reg  [PCIE_RAM_ADDR_WIDTH-1:0]     host_dma_write_desc_ram_addr,
  output reg  [PCIE_DMA_LEN_WIDTH-1:0]      host_dma_write_desc_len,
  output reg  [HOST_DMA_TAG_WIDTH-1:0]      host_dma_write_desc_tag,
  output reg                                host_dma_write_desc_valid,
  input  wire                               host_dma_write_desc_ready,
  input  wire [HOST_DMA_TAG_WIDTH-1:0]      host_dma_write_desc_status_tag,
  input  wire                               host_dma_write_desc_status_valid,
    
  // I2C and config
  input  wire                               i2c_scl_i,
  output reg                                i2c_scl_o,
  output reg                                i2c_scl_t,
  input  wire                               i2c_sda_i,
  output reg                                i2c_sda_o,
  output reg                                i2c_sda_t,
  
  output reg                                qsfp0_modsell,
  output reg                                qsfp0_resetl,
  input  wire                               qsfp0_modprsl,
  input  wire                               qsfp0_intl,
  output reg                                qsfp0_lpmode,

  output reg                                qsfp1_modsell,
  output reg                                qsfp1_resetl,
  input  wire                               qsfp1_modprsl,
  input  wire                               qsfp1_intl,
  output reg                                qsfp1_lpmode,
    
  // Cores reset
  output wire [CORE_WIDTH-1:0]              reset_dest,
  output wire                               reset_value,
  output wire                               reset_valid,
  input  wire                               reset_ready,

  output wire [CORE_COUNT-1:0]              income_cores, 
  output wire [CORE_COUNT-1:0]              cores_to_be_reset,
  output wire [CORE_WIDTH-1:0]              core_for_slot_count,
  input  wire [CORE_SLOT_WIDTH-1:0]         slot_count,
  
  output reg                                pcie_dma_enable,
  input  wire [31:0]                        if_msi_irq,
  output wire [31:0]                        msi_irq
);

// Interface and port count, and address space allocation. If corundum is used.
parameter IF_AXIL_ADDR_WIDTH  = AXIL_ADDR_WIDTH-$clog2(IF_COUNT);
parameter AXIL_CSR_ADDR_WIDTH = IF_AXIL_ADDR_WIDTH-5-$clog2((PORTS_PER_IF+3)/8);

// Registers set by AXIL
reg  [CORE_WIDTH+1-1:0]    pcie_core_reset;
reg                        pcie_core_reset_valid;
wire                       pcie_core_reset_ready;
reg  [CORE_COUNT-1:0]      income_cores_r;
reg  [CORE_COUNT-1:0]      income_cores_rr;
reg  [CORE_COUNT-1:0]      cores_to_be_reset_r;
reg  [CORE_WIDTH-1:0]      core_for_slot_count_r;
wire [CORE_SLOT_WIDTH-1:0] slot_count_r;

// State registers for readback
reg [HOST_DMA_TAG_WIDTH-1:0]  host_dma_read_status_tags;
reg [HOST_DMA_TAG_WIDTH-1:0]  host_dma_write_status_tags;
  
assign axil_ctrl_bresp  = 2'b00;
assign axil_ctrl_rresp  = 2'b00;
  
reg i2c_scl_i_r;
reg i2c_scl_o_r;
reg i2c_sda_i_r;
reg i2c_sda_o_r;
reg qsfp0_modsell_r;
reg qsfp0_resetl_r;
reg qsfp0_modprsl_r;
reg qsfp0_intl_r;
reg qsfp0_lpmode_r;
reg qsfp1_modsell_r;
reg qsfp1_resetl_r;
reg qsfp1_modprsl_r;
reg qsfp1_intl_r;
reg qsfp1_lpmode_r;

reg i2c_scl_i_rr;
reg i2c_scl_o_rr;
reg i2c_scl_t_rr;
reg i2c_sda_i_rr;
reg i2c_sda_o_rr;
reg i2c_sda_t_rr;
reg qsfp0_modsell_rr;
reg qsfp0_resetl_rr;
reg qsfp0_modprsl_rr;
reg qsfp0_intl_rr;
reg qsfp0_lpmode_rr;
reg qsfp1_modsell_rr;
reg qsfp1_resetl_rr;
reg qsfp1_modprsl_rr;
reg qsfp1_intl_rr;
reg qsfp1_lpmode_rr;
 
always @(posedge pcie_clk) begin
    if (pcie_rst) begin
        axil_ctrl_awready          <= 1'b0;
        axil_ctrl_wready           <= 1'b0;
        axil_ctrl_bvalid           <= 1'b0;
        axil_ctrl_arready          <= 1'b0;
        axil_ctrl_rvalid           <= 1'b0;

        host_dma_read_desc_valid   <= 1'b0;
        host_dma_write_desc_valid  <= 1'b0;
        pcie_core_reset_valid      <= 1'b0;
        host_dma_read_status_tags  <= {HOST_DMA_TAG_WIDTH{1'b0}};
        host_dma_write_status_tags <= {HOST_DMA_TAG_WIDTH{1'b0}};
        pcie_dma_enable            <= 1'b1;
        income_cores_r             <= {CORE_COUNT{1'b1}};
        cores_to_be_reset_r        <= {CORE_COUNT{1'b0}};
        core_for_slot_count_r      <= {CORE_WIDTH{1'b0}};
  
        qsfp0_modsell_r            <= 1'b1;
        qsfp1_modsell_r            <= 1'b1;
        qsfp0_lpmode_r             <= 1'b0;
        qsfp1_lpmode_r             <= 1'b0;
        qsfp0_resetl_r             <= 1'b1;
        qsfp1_resetl_r             <= 1'b1;
        i2c_scl_o_r                <= 1'b1;
        i2c_sda_o_r                <= 1'b1;

    end else begin

        axil_ctrl_awready <= 1'b0;
        axil_ctrl_wready  <= 1'b0;
        axil_ctrl_bvalid  <= axil_ctrl_bvalid && !axil_ctrl_bready;
        axil_ctrl_arready <= 1'b0;
        axil_ctrl_rvalid  <= axil_ctrl_rvalid && !axil_ctrl_rready;

        host_dma_read_desc_valid         <= host_dma_read_desc_valid && !host_dma_read_desc_ready;
        host_dma_write_desc_valid        <= host_dma_write_desc_valid && !host_dma_read_desc_ready;
        pcie_core_reset_valid            <= pcie_core_reset_valid && !pcie_core_reset_ready; 

        if (axil_ctrl_awvalid && axil_ctrl_wvalid && !axil_ctrl_bvalid) begin
            // write operation
            axil_ctrl_awready <= 1'b1;
            axil_ctrl_wready  <= 1'b1;
            axil_ctrl_bvalid  <= 1'b1;

            case ({axil_ctrl_awaddr[15:2], 2'b00})
                // GPIO
                16'h0100: begin
                    // GPIO out
                    if (axil_ctrl_wstrb[1]) begin
                        qsfp0_modsell_r <= axil_ctrl_wdata[9];
                        qsfp1_modsell_r <= axil_ctrl_wdata[11];
                    end
                    if (axil_ctrl_wstrb[0]) begin
                        qsfp0_resetl_r <= axil_ctrl_wdata[0];
                        qsfp0_lpmode_r <= axil_ctrl_wdata[2];
                        qsfp1_resetl_r <= axil_ctrl_wdata[4];
                        qsfp1_lpmode_r <= axil_ctrl_wdata[6];
                    end
                    if (axil_ctrl_wstrb[2]) begin
                        i2c_scl_o_r <= axil_ctrl_wdata[16];
                        i2c_sda_o_r <= axil_ctrl_wdata[17];
                    end
                end

                // Cores control
                16'h0400: pcie_dma_enable <= axil_ctrl_wdata;
                16'h0404: begin 
                    pcie_core_reset       <= axil_ctrl_wdata[CORE_WIDTH:0];
                    pcie_core_reset_valid <= 1'b1;
                end
                16'h0408: income_cores_r <= axil_ctrl_wdata[CORE_COUNT-1:0];
                16'h040C: cores_to_be_reset_r <= axil_ctrl_wdata[CORE_COUNT-1:0];
                16'h0410: core_for_slot_count_r <= axil_ctrl_wdata[CORE_WIDTH-1:0];

                // DMA request
                16'h0440: host_dma_read_desc_pcie_addr[31:0] <= axil_ctrl_wdata;
                16'h0444: host_dma_read_desc_pcie_addr[63:32] <= axil_ctrl_wdata;
                16'h0448: host_dma_read_desc_ram_addr[31:0] <= axil_ctrl_wdata;
                16'h0450: host_dma_read_desc_len <= axil_ctrl_wdata;
                16'h0454: begin
                    host_dma_read_desc_tag <= axil_ctrl_wdata;
                    host_dma_read_desc_valid <= 1'b1;
                end
                16'h0460: host_dma_write_desc_pcie_addr[31:0] <= axil_ctrl_wdata;
                16'h0464: host_dma_write_desc_pcie_addr[63:32] <= axil_ctrl_wdata;
                16'h0468: host_dma_write_desc_ram_addr[31:0] <= axil_ctrl_wdata;
                16'h0470: host_dma_write_desc_len <= axil_ctrl_wdata;
                16'h0474: begin
                    host_dma_write_desc_tag <= axil_ctrl_wdata;
                    host_dma_write_desc_valid <= 1'b1;
                end
            endcase
        end

        if (axil_ctrl_arvalid && !axil_ctrl_rvalid) begin
            // read operation
            axil_ctrl_arready <= 1'b1;
            axil_ctrl_rvalid  <= 1'b1;
            axil_ctrl_rdata   <= {AXIL_DATA_WIDTH{1'b0}};

            case ({axil_ctrl_araddr[15:2], 2'b00})
                16'h0000: axil_ctrl_rdata <= FW_ID;      // fw_id
                16'h0004: axil_ctrl_rdata <= FW_VER;     // fw_ver
                16'h0008: axil_ctrl_rdata <= BOARD_ID;   // board_id
                16'h000C: axil_ctrl_rdata <= BOARD_VER;  // board_ver
                16'h0010: axil_ctrl_rdata <= 0;          // phc_count
                16'h0014: axil_ctrl_rdata <= 16'h0200;   // phc_offset
                16'h0018: axil_ctrl_rdata <= 16'h0080;   // phc_stride
                16'h0020: axil_ctrl_rdata <= IF_COUNT;   // if_count
                16'h0024: axil_ctrl_rdata <= 2**IF_AXIL_ADDR_WIDTH; // if_stride
                16'h002C: axil_ctrl_rdata <= 2**AXIL_CSR_ADDR_WIDTH; // if_ctrl_offset
                16'h0040: axil_ctrl_rdata <= FPGA_ID;    // fpga_id 

                // GPIO
                16'h0100: begin
                    // GPIO out
                    axil_ctrl_rdata[9]  <= qsfp0_modsell_r;
                    axil_ctrl_rdata[11] <= qsfp1_modsell_r;
                    axil_ctrl_rdata[0]  <= qsfp0_resetl_r;
                    axil_ctrl_rdata[2]  <= qsfp0_lpmode_r;
                    axil_ctrl_rdata[4]  <= qsfp1_resetl_r;
                    axil_ctrl_rdata[6]  <= qsfp1_lpmode_r;
                    axil_ctrl_rdata[16] <= i2c_scl_o_r;
                    axil_ctrl_rdata[17] <= i2c_sda_o_r;
                end
                16'h0104: begin
                    // GPIO in
                    axil_ctrl_rdata[8]  <= qsfp0_modprsl_rr;
                    axil_ctrl_rdata[9]  <= qsfp0_modsell_rr;
                    axil_ctrl_rdata[10] <= qsfp1_modprsl_rr;
                    axil_ctrl_rdata[11] <= qsfp1_modsell_rr;
                    axil_ctrl_rdata[0]  <= qsfp0_resetl_rr;
                    axil_ctrl_rdata[1]  <= qsfp0_intl_rr;
                    axil_ctrl_rdata[2]  <= qsfp0_lpmode_rr;
                    axil_ctrl_rdata[4]  <= qsfp1_resetl_rr;
                    axil_ctrl_rdata[5]  <= qsfp1_intl_rr;
                    axil_ctrl_rdata[6]  <= qsfp1_lpmode_rr;
                    axil_ctrl_rdata[16] <= i2c_scl_i_rr;
                    axil_ctrl_rdata[17] <= i2c_sda_i_rr;
                end
                
                // Cores control and DMA request response
                16'h0400: axil_ctrl_rdata <= pcie_dma_enable;
                16'h0410: axil_ctrl_rdata <= slot_count_r;
                16'h0458: axil_ctrl_rdata <= host_dma_read_status_tags;
                16'h0478: axil_ctrl_rdata <= host_dma_write_status_tags;
            endcase
        end
        
        if (axil_ctrl_arvalid && !axil_ctrl_rvalid && ({axil_ctrl_araddr[15:2], 2'd0}==16'h0454))
            if (!host_dma_read_desc_status_valid)
                host_dma_read_status_tags <= {HOST_DMA_TAG_WIDTH{1'b0}};
            else
                host_dma_read_status_tags <= host_dma_read_desc_status_tag;
        else if (host_dma_read_desc_status_valid)
          host_dma_read_status_tags <= host_dma_read_status_tags | host_dma_read_desc_status_tag;
        
        if (axil_ctrl_arvalid && !axil_ctrl_rvalid && ({axil_ctrl_araddr[15:2], 2'd0}==16'h0474))
            if (!host_dma_write_desc_status_valid)
                host_dma_write_status_tags <= {HOST_DMA_TAG_WIDTH{1'b0}};
            else
                host_dma_write_status_tags <= host_dma_write_desc_status_tag;
        else if (host_dma_write_desc_status_valid)
          host_dma_write_status_tags <= host_dma_write_status_tags | host_dma_write_desc_status_tag;
  
    end
end

// One level register before i2c and flash input/outputs for better timing
always @(posedge pcie_clk)
    if (pcie_rst) begin
        qsfp0_modsell    <= 1'b1;
        qsfp1_modsell    <= 1'b1;
        qsfp0_lpmode     <= 1'b0;
        qsfp1_lpmode     <= 1'b0;
        qsfp0_resetl     <= 1'b1;
        qsfp1_resetl     <= 1'b1;
        i2c_scl_o        <= 1'b1;
        i2c_scl_t        <= 1'b1;
        i2c_sda_o        <= 1'b1;
        i2c_sda_t        <= 1'b1;
        qsfp0_modsell_rr <= 1'b1;
        qsfp1_modsell_rr <= 1'b1;
        qsfp0_lpmode_rr  <= 1'b0;
        qsfp1_lpmode_rr  <= 1'b0;
        qsfp0_resetl_rr  <= 1'b1;
        qsfp1_resetl_rr  <= 1'b1;
        i2c_scl_o_rr     <= 1'b1;
        i2c_scl_t_rr     <= 1'b1;
        i2c_sda_o_rr     <= 1'b1;
        i2c_sda_t_rr     <= 1'b1;

        i2c_scl_i_rr     <= 1'b1;
        i2c_sda_i_rr     <= 1'b1;
        qsfp0_modprsl_rr <= 1'b0;
        qsfp1_modprsl_rr <= 1'b0;
        qsfp0_intl_rr    <= 1'b0;
        qsfp1_intl_rr    <= 1'b0;
        i2c_scl_i_r      <= 1'b1;
        i2c_sda_i_r      <= 1'b1;
        qsfp0_modprsl_r  <= 1'b0;
        qsfp1_modprsl_r  <= 1'b0;
        qsfp0_intl_r     <= 1'b0;
        qsfp1_intl_r     <= 1'b0;
    end else begin
        qsfp0_modsell    <= qsfp0_modsell_rr;   
        qsfp1_modsell    <= qsfp1_modsell_rr;   
        qsfp0_lpmode     <= qsfp0_lpmode_rr;    
        qsfp1_lpmode     <= qsfp1_lpmode_rr;    
        qsfp0_resetl     <= qsfp0_resetl_rr;    
        qsfp1_resetl     <= qsfp1_resetl_rr;    
        i2c_scl_o        <= i2c_scl_o_rr;       
        i2c_scl_t        <= i2c_scl_t_rr;       
        i2c_sda_o        <= i2c_sda_o_rr;       
        i2c_sda_t        <= i2c_sda_o_rr;       
        qsfp0_modsell_rr <= qsfp0_modsell_r;   
        qsfp1_modsell_rr <= qsfp1_modsell_r;   
        qsfp0_lpmode_rr  <= qsfp0_lpmode_r;    
        qsfp1_lpmode_rr  <= qsfp1_lpmode_r;    
        qsfp0_resetl_rr  <= qsfp0_resetl_r;    
        qsfp1_resetl_rr  <= qsfp1_resetl_r;    
        i2c_scl_o_rr     <= i2c_scl_o_r;       
        i2c_scl_t_rr     <= i2c_scl_o_r;       
        i2c_sda_o_rr     <= i2c_sda_o_r;       
        i2c_sda_t_rr     <= i2c_sda_o_r;       

        i2c_scl_i_rr     <= i2c_scl_i_r;     
        i2c_sda_i_rr     <= i2c_sda_i_r;     
        qsfp0_modprsl_rr <= qsfp0_modprsl_r; 
        qsfp1_modprsl_rr <= qsfp1_modprsl_r; 
        qsfp0_intl_rr    <= qsfp0_intl_r;    
        qsfp1_intl_rr    <= qsfp1_intl_r;    
        i2c_scl_i_r      <= i2c_scl_i;     
        i2c_sda_i_r      <= i2c_sda_i;     
        qsfp0_modprsl_r  <= qsfp0_modprsl; 
        qsfp1_modprsl_r  <= qsfp1_modprsl; 
        qsfp0_intl_r     <= qsfp0_intl;    
        qsfp1_intl_r     <= qsfp1_intl;    
    end

// assign msi_irq[0] = host_dma_read_desc_status_valid || host_dma_write_desc_status_valid;
assign msi_irq = if_msi_irq;

// A core to be reset cannot be an incoming core. 
// Simplifies logic in controller. 
always @ (posedge pcie_clk)
  if (pcie_rst)
    income_cores_rr <= {CORE_COUNT{1'b1}};
  else
    income_cores_rr <= income_cores_r & (~cores_to_be_reset_r);

// Time domain crossing
simple_async_fifo # (
  .DEPTH(3),
  .DATA_WIDTH(CORE_WIDTH+1)
) cores_reset_cmd_async_fifo (
  .async_rst(sys_rst),

  .din_clk(pcie_clk),
  .din_valid(pcie_core_reset_valid),
  .din(pcie_core_reset),
  .din_ready(pcie_core_reset_ready),
 
  .dout_clk(sys_clk),
  .dout_valid(reset_valid),
  .dout({reset_dest,reset_value}),
  .dout_ready(reset_ready)
);

simple_sync_sig # (
  .RST_VAL(1'b0),
  .WIDTH(CORE_COUNT+CORE_COUNT+CORE_WIDTH)
) scheduler_cmd_syncer (
  .dst_clk(sys_clk),
  .dst_rst(sys_rst),
  .in({income_cores_rr,cores_to_be_reset_r,core_for_slot_count_r}),
  .out({income_cores,cores_to_be_reset,core_for_slot_count})
);

simple_sync_sig # (
  .RST_VAL(1'b0),
  .WIDTH(CORE_SLOT_WIDTH)
) slot_count_syncer (
  .dst_clk(pcie_clk),
  .dst_rst(pcie_rst),
  .in(slot_count),
  .out(slot_count_r)
);

endmodule
