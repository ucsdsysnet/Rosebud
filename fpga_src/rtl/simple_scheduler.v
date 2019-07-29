module simple_scheduler # (
  parameter CORE_COUNT      = 16,
  parameter DATA_WIDTH      = 64,
  parameter LEN_WIDTH       = 16,
  parameter EFF_ADDR_WIDTH  = 8,
  parameter SLOT_COUNT      = 8,
  parameter SLOT_START_ADDR = 8'h20,
  parameter SLOT_ADDR_STEP  = 8'h08,
  parameter DEST_WIDTH_IN   = $clog2(CORE_COUNT)+EFF_ADDR_WIDTH,
  parameter DEST_WIDTH_OUT  = $clog2(2), //output ports
  parameter STRB_WIDTH      = DATA_WIDTH/8,
  parameter USER_WIDTH_IN   = DEST_WIDTH_OUT,
  parameter USER_WIDTH_OUT  = DEST_WIDTH_IN,
  parameter CTRL_DEST_WIDTH = $clog2(CORE_COUNT),
  parameter CTRL_USER_WIDTH = $clog2(CORE_COUNT),
  parameter ENABLE_ILA      = 0
) (
  input                              clk,
  input                              rst,

  // Data line to/from Eth interfaces
  input  wire [2*DATA_WIDTH-1:0]     rx_axis_tdata,
  input  wire [2*STRB_WIDTH-1:0]     rx_axis_tkeep,
  input  wire [2-1:0]                rx_axis_tvalid, 
  output wire [2-1:0]                rx_axis_tready, 
  input  wire [2-1:0]                rx_axis_tlast,
  
  input  wire [2-1:0]                rx_fifo_overflow,
  input  wire [2-1:0]                rx_fifo_good_frame,
  input  wire [2-1:0]                tx_fifo_overflow,
  input  wire [2-1:0]                tx_fifo_bad_frame,
  input  wire [2-1:0]                tx_fifo_good_frame,

  output wire [2*DATA_WIDTH-1:0]     tx_axis_tdata,
  output wire [2*STRB_WIDTH-1:0]     tx_axis_tkeep,
  output wire [2-1:0]                tx_axis_tvalid, 
  input  wire [2-1:0]                tx_axis_tready, 
  output wire [2-1:0]                tx_axis_tlast,
  
  // DATA lines to/from cores
  output wire [2*DATA_WIDTH-1:0]     data_m_axis_tdata,
  output wire [2*STRB_WIDTH-1:0]     data_m_axis_tkeep,
  output wire [2*DEST_WIDTH_IN-1:0]  data_m_axis_tdest,
  output wire [2*USER_WIDTH_IN-1:0]  data_m_axis_tuser,
  output wire [2-1:0]                data_m_axis_tvalid,
  input  wire [2-1:0]                data_m_axis_tready,
  output wire [2-1:0]                data_m_axis_tlast,
  
  input  wire [2*DATA_WIDTH-1:0]     data_s_axis_tdata,
  input  wire [2*STRB_WIDTH-1:0]     data_s_axis_tkeep,
  input  wire [2*DEST_WIDTH_OUT-1:0] data_s_axis_tdest,
  input  wire [2*USER_WIDTH_OUT-1:0] data_s_axis_tuser,
  input  wire [2-1:0]                data_s_axis_tvalid, 
  output wire [2-1:0]                data_s_axis_tready, 
  input  wire [2-1:0]                data_s_axis_tlast,
      
  // Control lines to/from cores
  output wire [DATA_WIDTH-1:0]       ctrl_m_axis_tdata,
  output wire                        ctrl_m_axis_tvalid,
  input  wire                        ctrl_m_axis_tready,
  output wire                        ctrl_m_axis_tlast,
  output wire [CTRL_DEST_WIDTH-1:0]  ctrl_m_axis_tdest,

  input  wire [DATA_WIDTH-1:0]       ctrl_s_axis_tdata,
  input  wire                        ctrl_s_axis_tvalid,
  output wire                        ctrl_s_axis_tready,
  input  wire                        ctrl_s_axis_tlast,
  input  wire [CTRL_USER_WIDTH-1:0]  ctrl_s_axis_tuser
);
  
  // Adding tdest and tuser to input data from eth, dest based on 
  // rx_desc_fifo and stamp the incoming port
  wire [1:0] sending_last_word;
  reg  [DEST_WIDTH_IN-1:0] dest_r_0;
  reg  [DEST_WIDTH_IN-1:0] dest_r_1;
  reg  [1:0] dest_r_v;
  
  wire rx_desc_pop; // maybe used for error catching
  wire [USER_WIDTH_OUT-1:0] rx_desc_data; // , rx_desc_returned;
  wire rx_desc_v; // , rx_desc_returned_v;

  assign sending_last_word[0] = rx_axis_tvalid[0] && rx_axis_tlast[0] && rx_axis_tready[0];
  assign sending_last_word[1] = rx_axis_tvalid[1] && rx_axis_tlast[1] && rx_axis_tready[1];
  assign rx_desc_pop = (|(~dest_r_v)) || (|sending_last_word);

  always @ (posedge clk) begin
    if ((!dest_r_v[0]) || sending_last_word[0]) begin
      dest_r_0    <= rx_desc_data;
      dest_r_v[0] <= rx_desc_v;
      // If both happens take the desc for port 0, next cycle port 1 would be updated
      if (sending_last_word[1])
        dest_r_v[1] <= 1'b0;
    end 
    else if ((!dest_r_v[1]) || sending_last_word[1]) begin
      dest_r_1    <= rx_desc_data;
      dest_r_v[1] <= rx_desc_v;
    end
    if (rst) begin
      dest_r_v[0] <= 1'b0;
      dest_r_v[1] <= 1'b0;
    end 
  end

  wire [1:0] stall;

  assign data_m_axis_tdata  = rx_axis_tdata;
  assign data_m_axis_tkeep  = rx_axis_tkeep;
  assign data_m_axis_tvalid = rx_axis_tvalid & dest_r_v; 
  assign data_m_axis_tlast  = rx_axis_tlast;
  assign data_m_axis_tdest  = {dest_r_1,dest_r_0};
  assign data_m_axis_tuser  = {1'b1,1'b0}; // port number
  assign rx_axis_tready     = data_m_axis_tready & dest_r_v;
  
  assign tx_axis_tdata      = data_s_axis_tdata;
  assign tx_axis_tkeep      = data_s_axis_tkeep;
  assign tx_axis_tvalid     = data_s_axis_tvalid;  
  assign tx_axis_tlast      = data_s_axis_tlast;
  assign data_s_axis_tready = tx_axis_tready;

  // no further use for data_s_axis_tdest after its at correct port
 
  loaded_desc_fifo # (
    .CORE_COUNT(CORE_COUNT),
    .SLOT_COUNT(SLOT_COUNT),
    .START_ADDR(SLOT_START_ADDR),
    .ADDR_STEP(SLOT_ADDR_STEP),
    .SLOT_ADDR_WIDTH(EFF_ADDR_WIDTH)
  ) rx_desc_fifo (
    .clk(clk),
    .rst(rst),
  
    .din_valid(ctrl_s_axis_tvalid), 
    .din({ctrl_s_axis_tuser,ctrl_s_axis_tdata[15+EFF_ADDR_WIDTH:16]}),
    .din_ready(ctrl_s_axis_tready),
   
    .dout_valid(rx_desc_v),
    .dout(rx_desc_data),
    .dout_ready(rx_desc_pop)
  );
 
  // Core reset command
  reg [CTRL_DEST_WIDTH:0] core_rst_counter;
  always @ (posedge clk)
    if (rst)
        core_rst_counter <= 0;
    else
      if (ctrl_m_axis_tvalid && ctrl_m_axis_tready)
        core_rst_counter <= core_rst_counter + 1;
        
  assign ctrl_m_axis_tdata  = 64'hFFFFFFFF_FFFFFFFE;
  assign ctrl_m_axis_tlast  = 1'b1;
  assign ctrl_m_axis_tvalid = (core_rst_counter < CORE_COUNT);
  assign ctrl_m_axis_tdest  = core_rst_counter[CTRL_DEST_WIDTH-1:0];
 

if (ENABLE_ILA) begin
  wire trig_out_1, trig_out_2;
  wire ack_1, ack_2;

  reg [15:0] rx_count_0, rx_count_1, tx_count_0, tx_count_1;
  always @ (posedge clk)
    if (rst) begin
        rx_count_0 <= 16'd0;
        rx_count_1 <= 16'd0;
        tx_count_0 <= 16'd0;
        tx_count_1 <= 16'd0;
    end else begin
      if (rx_axis_tlast[0] && rx_axis_tvalid[0])
        rx_count_0 <= 16'd0;
      else if (rx_axis_tvalid[0])
        rx_count_0 <= rx_count_0 + 16'd1;

      if (rx_axis_tlast[1] && rx_axis_tvalid[1])
        rx_count_1 <= 16'd0;
      else if (rx_axis_tvalid[1])
        rx_count_1 <= rx_count_1 + 16'd1;

      if (tx_axis_tlast[0] && tx_axis_tvalid[0])
        tx_count_0 <= 16'd0;
      else if (tx_axis_tvalid[0])
        tx_count_0 <= tx_count_0 + 16'd1;

      if (tx_axis_tlast[1] && tx_axis_tvalid[1])
        tx_count_1 <= 16'd0;
      else if (tx_axis_tvalid[1])
        tx_count_1 <= tx_count_1 + 16'd1;
    end

  ila_4x64 debugger1 (
    .clk    (clk),
 
    .trig_out(trig_out_1),
    .trig_out_ack(ack_1),
    .trig_in (trig_out_2),
    .trig_in_ack(ack_2),
 
    .probe0 ({
       rx_axis_tkeep,
       data_m_axis_tdest,
       data_m_axis_tuser,
       rx_axis_tvalid, 
       rx_axis_tready, 
       rx_axis_tlast,
       rx_fifo_overflow,
       rx_fifo_good_frame,
       tx_fifo_overflow,
       sending_last_word,
       tx_fifo_good_frame
    }),
    
    .probe1 ({
       ctrl_s_axis_tdata[31:0],
       rx_count_0,
       ctrl_m_axis_tdest,
       ctrl_s_axis_tuser,
       ctrl_m_axis_tvalid,
       ctrl_m_axis_tready,
       ctrl_m_axis_tlast,
       ctrl_s_axis_tvalid,
       ctrl_s_axis_tready,
       ctrl_s_axis_tlast,
       dest_r_v
     
     }),
  
    .probe2 (rx_axis_tdata[63:0]),

    .probe3 (rx_axis_tdata[127:64])
  );

  ila_8x64 debugger2 (
    .clk    (clk),
 
    .trig_out(trig_out_2),
    .trig_out_ack(ack_2),
    .trig_in (trig_out_1),
    .trig_in_ack(ack_1),
   
    .probe0 ({
       data_s_axis_tkeep,
       data_s_axis_tuser,
       rx_desc_data,
       data_s_axis_tdest,
       data_s_axis_tvalid, 
       data_s_axis_tready, 
       data_s_axis_tlast,
       rx_desc_v, 
       rx_desc_pop
     }),
  
    .probe1 (ctrl_m_axis_tdata),
    
    .probe2 (data_s_axis_tdata[63:0]),

    .probe3 (data_s_axis_tdata[127:64]),
    
    .probe4 (tx_count_1), .probe5 (tx_count_0), 
    .probe6 (rx_count_1), .probe7 (rx_count_0)
 
  );
end

endmodule
