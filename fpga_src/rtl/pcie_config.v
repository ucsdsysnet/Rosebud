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
  parameter PORTS_PER_IF            = 1
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
    
  // I2C
  input  wire                               sfp_i2c_scl_i,
  output reg                                sfp_i2c_scl_o,
  output wire                               sfp_i2c_scl_t,
  input  wire                               sfp_1_i2c_sda_i,
  output reg                                sfp_1_i2c_sda_o,
  output wire                               sfp_1_i2c_sda_t,
  input  wire                               sfp_2_i2c_sda_i,
  output reg                                sfp_2_i2c_sda_o,
  output wire                               sfp_2_i2c_sda_t,

  input  wire                               eeprom_i2c_scl_i,
  output reg                                eeprom_i2c_scl_o,
  output wire                               eeprom_i2c_scl_t,
  input  wire                               eeprom_i2c_sda_i,
  output reg                                eeprom_i2c_sda_o,
  output wire                               eeprom_i2c_sda_t,

  // BPI Flash
  input  wire [15:0]                        flash_dq_i,
  output reg  [15:0]                        flash_dq_o,
  output reg                                flash_dq_oe,
  output reg  [22:0]                        flash_addr,
  output reg                                flash_region,
  output reg                                flash_region_oe,
  output reg                                flash_ce_n,
  output reg                                flash_oe_n,
  output reg                                flash_we_n,
  output reg                                flash_adv_n,
  
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

// FW and board IDs
parameter FW_ID = 32'd0;
parameter FW_VER = {16'd0, 16'd1};
parameter BOARD_ID = {16'h1ce4, 16'h0003};
parameter BOARD_VER = {16'd0, 16'd1};

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
reg  [HOST_DMA_TAG_WIDTH-1:0]  host_dma_read_status_tags;
reg  [HOST_DMA_TAG_WIDTH-1:0]  host_dma_write_status_tags;
         
assign axil_ctrl_bresp  = 2'b00;
assign axil_ctrl_rresp  = 2'b00;

assign sfp_i2c_scl_t    = sfp_i2c_scl_o;
assign sfp_1_i2c_sda_t  = sfp_1_i2c_sda_o;
assign sfp_2_i2c_sda_t  = sfp_2_i2c_sda_o;
assign eeprom_i2c_scl_t = eeprom_i2c_scl_o;
assign eeprom_i2c_sda_t = eeprom_i2c_sda_o;

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
        pcie_dma_enable            <= 1'b0;
        income_cores_r             <= {CORE_COUNT{1'b0}};
        cores_to_be_reset_r        <= {CORE_COUNT{1'b0}};
        core_for_slot_count_r      <= {CORE_WIDTH{1'b0}};
  
        sfp_i2c_scl_o              <= 1'b1;
        sfp_1_i2c_sda_o            <= 1'b1;
        sfp_2_i2c_sda_o            <= 1'b1;
        eeprom_i2c_scl_o           <= 1'b1;
        eeprom_i2c_sda_o           <= 1'b1;
        
        flash_dq_o                 <= 16'd0;
        flash_dq_oe                <= 1'b0;
        flash_addr                 <= 23'd0;
        flash_region               <= 1'b0;
        flash_region_oe            <= 1'b0;
        flash_ce_n                 <= 1'b1;
        flash_oe_n                 <= 1'b1;
        flash_we_n                 <= 1'b1;
        flash_adv_n                <= 1'b1;

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
                    if (axil_ctrl_wstrb[2]) begin
                        sfp_i2c_scl_o   <= axil_ctrl_wdata[16];
                        sfp_1_i2c_sda_o <= axil_ctrl_wdata[17];
                        sfp_2_i2c_sda_o <= axil_ctrl_wdata[18];
                    end
                    if (axil_ctrl_wstrb[3]) begin
                        eeprom_i2c_scl_o <= axil_ctrl_wdata[24];
                        eeprom_i2c_sda_o <= axil_ctrl_wdata[25];
                    end
                end

                // Flash
                16'h0144: begin
                    // Flash address
                    flash_addr   <= axil_ctrl_wdata[22:0];
                    flash_region <= axil_ctrl_wdata[23];
                end
                16'h0148: flash_dq_o <= axil_ctrl_wdata; // Flash data
                16'h014C: begin
                    // Flash control
                    if (axil_ctrl_wstrb[0]) begin
                        flash_ce_n  <= axil_ctrl_wdata[0];
                        flash_oe_n  <= axil_ctrl_wdata[1];
                        flash_we_n  <= axil_ctrl_wdata[2];
                        flash_adv_n <= axil_ctrl_wdata[3];
                    end
                    if (axil_ctrl_wstrb[1]) begin
                        flash_dq_oe <= axil_ctrl_wdata[8];
                    end
                    if (axil_ctrl_wstrb[2]) begin
                        flash_region_oe <= axil_ctrl_wdata[16];
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
                
                // GPIO
                16'h0100: begin
                    // GPIO out
                    axil_ctrl_rdata[16] <= sfp_i2c_scl_o;
                    axil_ctrl_rdata[17] <= sfp_1_i2c_sda_o;
                    axil_ctrl_rdata[18] <= sfp_2_i2c_sda_o;
                    axil_ctrl_rdata[24] <= eeprom_i2c_scl_o;
                    axil_ctrl_rdata[25] <= eeprom_i2c_sda_o;
                end
                16'h0104: begin
                    // GPIO in
                    axil_ctrl_rdata[16] <= sfp_i2c_scl_i;
                    axil_ctrl_rdata[17] <= sfp_1_i2c_sda_i;
                    axil_ctrl_rdata[18] <= sfp_2_i2c_sda_i;
                    axil_ctrl_rdata[24] <= eeprom_i2c_scl_i;
                    axil_ctrl_rdata[25] <= eeprom_i2c_sda_i;
                end
                
                // Flash
                16'h0140: axil_ctrl_rdata <= 32'd0; // Flash ID
                16'h0144: begin
                    // Flash address
                    axil_ctrl_rdata[22:0] <= flash_addr;
                    axil_ctrl_rdata[23]   <= flash_region;
                end
                16'h0148: axil_ctrl_rdata <= flash_dq_i; // Flash data
                16'h014C: begin
                    // Flash control
                    axil_ctrl_rdata[0]  <= flash_ce_n; // chip enable (inverted)
                    axil_ctrl_rdata[1]  <= flash_oe_n; // output enable (inverted)
                    axil_ctrl_rdata[2]  <= flash_we_n; // write enable (inverted)
                    axil_ctrl_rdata[3]  <= flash_adv_n; // address valid (inverted)
                    axil_ctrl_rdata[8]  <= flash_dq_oe; // data output enable
                    axil_ctrl_rdata[16] <= flash_region_oe; // region output enable (addr bit 23)
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

// assign msi_irq[0] = host_dma_read_desc_status_valid || host_dma_write_desc_status_valid;
assign msi_irq = if_msi_irq;

// A core to be reset cannot be an incoming core. 
// Simplifies logic in controller. 
always @ (posedge pcie_clk)
  if (pcie_rst)
    income_cores_rr <= {CORE_COUNT{1'b0}};
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
