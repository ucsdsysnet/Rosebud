module slot_fifo_loader # (
  parameter MAX_SLOT_COUNT = 8,
  parameter DEST_COUNT     = 16,
  parameter DEST_WIDTH     = $clog2(DEST_COUNT),
  parameter DATA_WIDTH     = $clog2(MAX_SLOT_COUNT+1)
) (
  input clk,
  input rst,

  input                   req_valid,
  input  [DEST_WIDTH-1:0] req_dest,
  input  [DATA_WIDTH-1:0] slot_count,
  output                  req_ready,

  output [DEST_COUNT-1:0] clear_fifo,
  output [DEST_COUNT-1:0] out_slot_valid,
  output [DATA_WIDTH-1:0] out_slot
  // No ready signal since we are initializing a fifo 
  // and we have full control
);

  //STATES for FSM
  localparam IDLE = 2'b00;
  localparam INIT = 2'b01;
  localparam PROC = 2'b10;
  localparam ERR  = 2'b11;
  
  reg  [DATA_WIDTH-1:0] slot_count_r, remained_slots;
  reg  [DEST_COUNT-1:0] dest_dec_r;
  reg  [1:0] state_r, state_n;
  reg  no_slot;
  wire load_done;

  always @ (posedge clk)
    if (rst)
      state_r <= IDLE;
    else
      state_r <= state_n;


  always @ (*) begin
    state_n = state_r;
    case (state_r)
      IDLE: if (req_valid) state_n = INIT;
      INIT: if (no_slot)   state_n = IDLE; else state_n = PROC;
      PROC: if (load_done) state_n = IDLE;
      ERR:  state_n = ERR;
    endcase
  end

  always @ (posedge clk) begin
    // state = IDLE
    if (req_valid && req_ready) begin
      dest_dec_r     <= 1 << req_dest;
      slot_count_r   <= slot_count;
      no_slot        <= (slot_count == {DATA_WIDTH{1'b0}});
    end

    // We max up slots to MAX_SLOT_COUNT
    if (state_r == INIT) begin
      remained_slots <= (slot_count_r > MAX_SLOT_COUNT) ? 
                        MAX_SLOT_COUNT : slot_count_r;
    end
    // stat = PROC
    if (out_slot_valid)
      remained_slots <= remained_slots - {{(DATA_WIDTH-1){1'b0}},1'b1};

    if (rst) begin
      remained_slots <= {DATA_WIDTH{1'b0}};
      slot_count_r   <= {DATA_WIDTH{1'b0}};
      no_slot        <= 1'b0;
      dest_dec_r     <= {DEST_COUNT{1'b0}};
    end
  end
  
  assign load_done      = out_slot_valid &&
                          (remained_slots=={{(DATA_WIDTH-1){1'b0}},1'b1});

  assign req_ready      = (state_r==IDLE);
  assign clear_fifo     = (state_r==INIT) ? dest_dec_r : {DEST_COUNT{1'b0}};
  assign out_slot_valid = (state_r==PROC) ? dest_dec_r : {DEST_COUNT{1'b0}};

  assign out_slot       = remained_slots;

endmodule
