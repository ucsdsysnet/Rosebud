// Generator : SpinalHDL v1.4.0    git head : ecb5a80b713566f417ea3ea061f9969e73770a7f
// Date      : 16/09/2020, 00:32:53
// Component : VexRiscv


`define EnvCtrlEnum_defaultEncoding_type [0:0]
`define EnvCtrlEnum_defaultEncoding_NONE 1'b0
`define EnvCtrlEnum_defaultEncoding_XRET 1'b1

`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

`define Src2CtrlEnum_defaultEncoding_type [1:0]
`define Src2CtrlEnum_defaultEncoding_RS 2'b00
`define Src2CtrlEnum_defaultEncoding_IMI 2'b01
`define Src2CtrlEnum_defaultEncoding_IMS 2'b10
`define Src2CtrlEnum_defaultEncoding_PC 2'b11

`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10

`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11


module StreamFifoLowLatency (
  input               io_push_valid,
  output              io_push_ready,
  input               io_push_payload_error,
  input      [31:0]   io_push_payload_inst,
  output reg          io_pop_valid,
  input               io_pop_ready,
  output reg          io_pop_payload_error,
  output reg [31:0]   io_pop_payload_inst,
  input               io_flush,
  output     [0:0]    io_occupancy,
  input               clk,
  input               reset 
);
  wire                _zz_4_;
  wire       [0:0]    _zz_5_;
  reg                 _zz_1_;
  reg                 pushPtr_willIncrement;
  reg                 pushPtr_willClear;
  wire                pushPtr_willOverflowIfInc;
  wire                pushPtr_willOverflow;
  reg                 popPtr_willIncrement;
  reg                 popPtr_willClear;
  wire                popPtr_willOverflowIfInc;
  wire                popPtr_willOverflow;
  wire                ptrMatch;
  reg                 risingOccupancy;
  wire                empty;
  wire                full;
  wire                pushing;
  wire                popping;
  wire       [32:0]   _zz_2_;
  reg        [32:0]   _zz_3_;

  assign _zz_4_ = (! empty);
  assign _zz_5_ = _zz_2_[0 : 0];
  always @ (*) begin
    _zz_1_ = 1'b0;
    if(pushing)begin
      _zz_1_ = 1'b1;
    end
  end

  always @ (*) begin
    pushPtr_willIncrement = 1'b0;
    if(pushing)begin
      pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    pushPtr_willClear = 1'b0;
    if(io_flush)begin
      pushPtr_willClear = 1'b1;
    end
  end

  assign pushPtr_willOverflowIfInc = 1'b1;
  assign pushPtr_willOverflow = (pushPtr_willOverflowIfInc && pushPtr_willIncrement);
  always @ (*) begin
    popPtr_willIncrement = 1'b0;
    if(popping)begin
      popPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    popPtr_willClear = 1'b0;
    if(io_flush)begin
      popPtr_willClear = 1'b1;
    end
  end

  assign popPtr_willOverflowIfInc = 1'b1;
  assign popPtr_willOverflow = (popPtr_willOverflowIfInc && popPtr_willIncrement);
  assign ptrMatch = 1'b1;
  assign empty = (ptrMatch && (! risingOccupancy));
  assign full = (ptrMatch && risingOccupancy);
  assign pushing = (io_push_valid && io_push_ready);
  assign popping = (io_pop_valid && io_pop_ready);
  assign io_push_ready = (! full);
  always @ (*) begin
    if(_zz_4_)begin
      io_pop_valid = 1'b1;
    end else begin
      io_pop_valid = io_push_valid;
    end
  end

  assign _zz_2_ = _zz_3_;
  always @ (*) begin
    if(_zz_4_)begin
      io_pop_payload_error = _zz_5_[0];
    end else begin
      io_pop_payload_error = io_push_payload_error;
    end
  end

  always @ (*) begin
    if(_zz_4_)begin
      io_pop_payload_inst = _zz_2_[32 : 1];
    end else begin
      io_pop_payload_inst = io_push_payload_inst;
    end
  end

  assign io_occupancy = (risingOccupancy && ptrMatch);
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      risingOccupancy <= 1'b0;
    end else begin
      if((pushing != popping))begin
        risingOccupancy <= pushing;
      end
      if(io_flush)begin
        risingOccupancy <= 1'b0;
      end
    end
  end

  always @ (posedge clk) begin
    if(_zz_1_)begin
      _zz_3_ <= {io_push_payload_inst,io_push_payload_error};
    end
  end


endmodule

module VexRiscv (
  output              iBus_cmd_valid,
  input               iBus_cmd_ready,
  output     [31:0]   iBus_cmd_payload_pc,
  input               iBus_rsp_valid,
  input               iBus_rsp_payload_error,
  input      [31:0]   iBus_rsp_payload_inst,
  input               timerInterrupt,
  input               externalInterrupt,
  input               softwareInterrupt,
  output              dBus_cmd_valid,
  input               dBus_cmd_ready,
  output              dBus_cmd_payload_wr,
  output     [31:0]   dBus_cmd_payload_address,
  output     [31:0]   dBus_cmd_payload_data,
  output     [1:0]    dBus_cmd_payload_size,
  input               dBus_rsp_ready,
  input               dBus_rsp_error,
  input      [31:0]   dBus_rsp_data,
  input               clk,
  input               reset 
);
  wire                _zz_140_;
  wire                _zz_141_;
  wire       [31:0]   _zz_142_;
  wire       [31:0]   _zz_143_;
  reg        [31:0]   _zz_144_;
  wire                IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready;
  wire                IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid;
  wire                IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error;
  wire       [31:0]   IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst;
  wire       [0:0]    IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy;
  wire                _zz_145_;
  wire                _zz_146_;
  wire                _zz_147_;
  wire                _zz_148_;
  wire                _zz_149_;
  wire                _zz_150_;
  wire                _zz_151_;
  wire       [1:0]    _zz_152_;
  wire                _zz_153_;
  wire                _zz_154_;
  wire                _zz_155_;
  wire                _zz_156_;
  wire                _zz_157_;
  wire                _zz_158_;
  wire                _zz_159_;
  wire                _zz_160_;
  wire                _zz_161_;
  wire                _zz_162_;
  wire                _zz_163_;
  wire       [1:0]    _zz_164_;
  wire                _zz_165_;
  wire       [0:0]    _zz_166_;
  wire       [0:0]    _zz_167_;
  wire       [0:0]    _zz_168_;
  wire       [0:0]    _zz_169_;
  wire       [0:0]    _zz_170_;
  wire       [0:0]    _zz_171_;
  wire       [0:0]    _zz_172_;
  wire       [0:0]    _zz_173_;
  wire       [32:0]   _zz_174_;
  wire       [31:0]   _zz_175_;
  wire       [32:0]   _zz_176_;
  wire       [0:0]    _zz_177_;
  wire       [0:0]    _zz_178_;
  wire       [0:0]    _zz_179_;
  wire       [2:0]    _zz_180_;
  wire       [2:0]    _zz_181_;
  wire       [31:0]   _zz_182_;
  wire       [11:0]   _zz_183_;
  wire       [31:0]   _zz_184_;
  wire       [19:0]   _zz_185_;
  wire       [11:0]   _zz_186_;
  wire       [31:0]   _zz_187_;
  wire       [31:0]   _zz_188_;
  wire       [19:0]   _zz_189_;
  wire       [11:0]   _zz_190_;
  wire       [2:0]    _zz_191_;
  wire       [0:0]    _zz_192_;
  wire       [2:0]    _zz_193_;
  wire       [0:0]    _zz_194_;
  wire       [2:0]    _zz_195_;
  wire       [0:0]    _zz_196_;
  wire       [2:0]    _zz_197_;
  wire       [0:0]    _zz_198_;
  wire       [2:0]    _zz_199_;
  wire       [2:0]    _zz_200_;
  wire       [0:0]    _zz_201_;
  wire       [2:0]    _zz_202_;
  wire       [4:0]    _zz_203_;
  wire       [11:0]   _zz_204_;
  wire       [11:0]   _zz_205_;
  wire       [31:0]   _zz_206_;
  wire       [31:0]   _zz_207_;
  wire       [31:0]   _zz_208_;
  wire       [31:0]   _zz_209_;
  wire       [31:0]   _zz_210_;
  wire       [31:0]   _zz_211_;
  wire       [31:0]   _zz_212_;
  wire       [11:0]   _zz_213_;
  wire       [19:0]   _zz_214_;
  wire       [11:0]   _zz_215_;
  wire       [31:0]   _zz_216_;
  wire       [31:0]   _zz_217_;
  wire       [31:0]   _zz_218_;
  wire       [11:0]   _zz_219_;
  wire       [19:0]   _zz_220_;
  wire       [11:0]   _zz_221_;
  wire       [2:0]    _zz_222_;
  wire       [0:0]    _zz_223_;
  wire       [0:0]    _zz_224_;
  wire       [0:0]    _zz_225_;
  wire       [0:0]    _zz_226_;
  wire       [0:0]    _zz_227_;
  wire       [0:0]    _zz_228_;
  wire       [1:0]    _zz_229_;
  wire       [31:0]   _zz_230_;
  wire       [31:0]   _zz_231_;
  wire       [31:0]   _zz_232_;
  wire                _zz_233_;
  wire       [0:0]    _zz_234_;
  wire       [10:0]   _zz_235_;
  wire       [31:0]   _zz_236_;
  wire       [31:0]   _zz_237_;
  wire       [31:0]   _zz_238_;
  wire                _zz_239_;
  wire       [0:0]    _zz_240_;
  wire       [4:0]    _zz_241_;
  wire       [31:0]   _zz_242_;
  wire       [31:0]   _zz_243_;
  wire       [31:0]   _zz_244_;
  wire       [31:0]   _zz_245_;
  wire       [31:0]   _zz_246_;
  wire                _zz_247_;
  wire                _zz_248_;
  wire                _zz_249_;
  wire       [31:0]   _zz_250_;
  wire       [31:0]   _zz_251_;
  wire                _zz_252_;
  wire       [0:0]    _zz_253_;
  wire       [0:0]    _zz_254_;
  wire                _zz_255_;
  wire                _zz_256_;
  wire                _zz_257_;
  wire       [1:0]    _zz_258_;
  wire       [1:0]    _zz_259_;
  wire                _zz_260_;
  wire       [0:0]    _zz_261_;
  wire       [18:0]   _zz_262_;
  wire       [31:0]   _zz_263_;
  wire       [31:0]   _zz_264_;
  wire       [31:0]   _zz_265_;
  wire       [31:0]   _zz_266_;
  wire       [31:0]   _zz_267_;
  wire       [31:0]   _zz_268_;
  wire       [31:0]   _zz_269_;
  wire       [31:0]   _zz_270_;
  wire                _zz_271_;
  wire                _zz_272_;
  wire                _zz_273_;
  wire       [1:0]    _zz_274_;
  wire       [1:0]    _zz_275_;
  wire                _zz_276_;
  wire       [0:0]    _zz_277_;
  wire       [16:0]   _zz_278_;
  wire       [31:0]   _zz_279_;
  wire       [31:0]   _zz_280_;
  wire       [31:0]   _zz_281_;
  wire       [31:0]   _zz_282_;
  wire       [31:0]   _zz_283_;
  wire       [31:0]   _zz_284_;
  wire                _zz_285_;
  wire       [0:0]    _zz_286_;
  wire       [0:0]    _zz_287_;
  wire                _zz_288_;
  wire       [0:0]    _zz_289_;
  wire       [13:0]   _zz_290_;
  wire       [31:0]   _zz_291_;
  wire       [31:0]   _zz_292_;
  wire       [31:0]   _zz_293_;
  wire                _zz_294_;
  wire       [0:0]    _zz_295_;
  wire       [0:0]    _zz_296_;
  wire                _zz_297_;
  wire       [0:0]    _zz_298_;
  wire       [9:0]    _zz_299_;
  wire       [31:0]   _zz_300_;
  wire       [31:0]   _zz_301_;
  wire       [31:0]   _zz_302_;
  wire       [31:0]   _zz_303_;
  wire       [0:0]    _zz_304_;
  wire       [1:0]    _zz_305_;
  wire       [0:0]    _zz_306_;
  wire       [0:0]    _zz_307_;
  wire                _zz_308_;
  wire       [0:0]    _zz_309_;
  wire       [5:0]    _zz_310_;
  wire       [31:0]   _zz_311_;
  wire       [31:0]   _zz_312_;
  wire       [31:0]   _zz_313_;
  wire       [31:0]   _zz_314_;
  wire       [31:0]   _zz_315_;
  wire                _zz_316_;
  wire       [0:0]    _zz_317_;
  wire       [0:0]    _zz_318_;
  wire       [5:0]    _zz_319_;
  wire       [5:0]    _zz_320_;
  wire                _zz_321_;
  wire       [0:0]    _zz_322_;
  wire       [2:0]    _zz_323_;
  wire       [31:0]   _zz_324_;
  wire                _zz_325_;
  wire       [0:0]    _zz_326_;
  wire       [2:0]    _zz_327_;
  wire                _zz_328_;
  wire       [0:0]    _zz_329_;
  wire       [0:0]    _zz_330_;
  wire       [2:0]    _zz_331_;
  wire       [2:0]    _zz_332_;
  wire                _zz_333_;
  wire                _zz_334_;
  wire       [31:0]   _zz_335_;
  wire                _zz_336_;
  wire                _zz_337_;
  wire       [31:0]   _zz_338_;
  wire       [31:0]   _zz_339_;
  wire       [31:0]   _zz_340_;
  wire                _zz_341_;
  wire                _zz_342_;
  wire       [31:0]   _zz_343_;
  wire       [31:0]   _zz_344_;
  wire                _zz_345_;
  wire                _zz_346_;
  wire                _zz_347_;
  wire                _zz_348_;
  wire                _zz_349_;
  wire                decode_PREDICTION_HAD_BRANCHED2;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_1_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_2_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_3_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_4_;
  wire       `EnvCtrlEnum_defaultEncoding_type decode_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_5_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_6_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_7_;
  wire       `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_8_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_9_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_10_;
  wire                decode_SRC_LESS_UNSIGNED;
  wire       [1:0]    execute_MEMORY_ADDRESS_LOW;
  wire                decode_BYPASSABLE_EXECUTE_STAGE;
  wire                decode_MEMORY_ENABLE;
  wire                decode_IS_CSR;
  wire       `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_11_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_12_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_13_;
  wire                execute_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_MEMORY_STAGE;
  wire                decode_CSR_READ_OPCODE;
  wire                decode_MEMORY_STORE;
  wire       `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_14_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_15_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_16_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_17_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_18_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_19_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_20_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_21_;
  wire       [31:0]   writeBack_REGFILE_WRITE_DATA;
  wire       [31:0]   execute_REGFILE_WRITE_DATA;
  wire                decode_SRC2_FORCE_ZERO;
  wire       [31:0]   memory_PC;
  wire       [31:0]   writeBack_FORMAL_PC_NEXT;
  wire       [31:0]   memory_FORMAL_PC_NEXT;
  wire       [31:0]   execute_FORMAL_PC_NEXT;
  wire       [31:0]   decode_FORMAL_PC_NEXT;
  wire       `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_22_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_23_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_24_;
  wire                decode_CSR_WRITE_OPCODE;
  wire       [31:0]   execute_BRANCH_CALC;
  wire                execute_BRANCH_DO;
  wire       [31:0]   execute_PC;
  wire                execute_PREDICTION_HAD_BRANCHED2;
  wire       [31:0]   execute_RS1;
  wire                execute_BRANCH_COND_RESULT;
  wire       `BranchCtrlEnum_defaultEncoding_type execute_BRANCH_CTRL;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_25_;
  wire                decode_RS2_USE;
  wire                decode_RS1_USE;
  wire                execute_REGFILE_WRITE_VALID;
  wire                execute_BYPASSABLE_EXECUTE_STAGE;
  wire                memory_REGFILE_WRITE_VALID;
  wire                memory_BYPASSABLE_MEMORY_STAGE;
  wire                writeBack_REGFILE_WRITE_VALID;
  reg        [31:0]   decode_RS2;
  reg        [31:0]   decode_RS1;
  wire       [31:0]   execute_SHIFT_RIGHT;
  wire       `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_26_;
  wire                execute_SRC_LESS_UNSIGNED;
  wire                execute_SRC2_FORCE_ZERO;
  wire                execute_SRC_USE_SUB_LESS;
  wire       [31:0]   _zz_27_;
  wire       `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_28_;
  wire       `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_29_;
  wire                decode_SRC_USE_SUB_LESS;
  wire                decode_SRC_ADD_ZERO;
  wire       [31:0]   execute_SRC_ADD_SUB;
  wire                execute_SRC_LESS;
  wire       `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_30_;
  wire       [31:0]   execute_SRC2;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_31_;
  wire       [31:0]   _zz_32_;
  wire       [31:0]   _zz_33_;
  wire                _zz_34_;
  reg                 _zz_35_;
  reg                 decode_REGFILE_WRITE_VALID;
  wire                decode_LEGAL_INSTRUCTION;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_36_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_37_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_38_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_39_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_40_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_41_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_42_;
  reg        [31:0]   _zz_43_;
  wire       [31:0]   execute_SRC1;
  wire                execute_CSR_READ_OPCODE;
  wire                execute_CSR_WRITE_OPCODE;
  wire                execute_IS_CSR;
  wire       `EnvCtrlEnum_defaultEncoding_type memory_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_44_;
  wire       `EnvCtrlEnum_defaultEncoding_type execute_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_45_;
  wire       `EnvCtrlEnum_defaultEncoding_type writeBack_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_46_;
  reg        [31:0]   _zz_47_;
  wire       [31:0]   memory_INSTRUCTION;
  wire       [1:0]    memory_MEMORY_ADDRESS_LOW;
  wire       [31:0]   memory_MEMORY_READ_DATA;
  wire                memory_ALIGNEMENT_FAULT;
  wire       [31:0]   memory_REGFILE_WRITE_DATA;
  wire                memory_MEMORY_STORE;
  wire                memory_MEMORY_ENABLE;
  wire       [31:0]   execute_SRC_ADD;
  wire       [31:0]   execute_RS2;
  wire       [31:0]   execute_INSTRUCTION;
  wire                execute_MEMORY_STORE;
  wire                execute_MEMORY_ENABLE;
  wire                execute_ALIGNEMENT_FAULT;
  wire       `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_48_;
  reg        [31:0]   _zz_49_;
  reg        [31:0]   _zz_50_;
  wire       [31:0]   decode_PC;
  wire       [31:0]   decode_INSTRUCTION;
  wire       [31:0]   writeBack_PC;
  wire       [31:0]   writeBack_INSTRUCTION;
  wire                decode_arbitration_haltItself;
  reg                 decode_arbitration_haltByOther;
  reg                 decode_arbitration_removeIt;
  wire                decode_arbitration_flushIt;
  reg                 decode_arbitration_flushNext;
  wire                decode_arbitration_isValid;
  wire                decode_arbitration_isStuck;
  wire                decode_arbitration_isStuckByOthers;
  wire                decode_arbitration_isFlushed;
  wire                decode_arbitration_isMoving;
  wire                decode_arbitration_isFiring;
  reg                 execute_arbitration_haltItself;
  wire                execute_arbitration_haltByOther;
  reg                 execute_arbitration_removeIt;
  wire                execute_arbitration_flushIt;
  reg                 execute_arbitration_flushNext;
  reg                 execute_arbitration_isValid;
  wire                execute_arbitration_isStuck;
  wire                execute_arbitration_isStuckByOthers;
  wire                execute_arbitration_isFlushed;
  wire                execute_arbitration_isMoving;
  wire                execute_arbitration_isFiring;
  reg                 memory_arbitration_haltItself;
  wire                memory_arbitration_haltByOther;
  reg                 memory_arbitration_removeIt;
  wire                memory_arbitration_flushIt;
  reg                 memory_arbitration_flushNext;
  reg                 memory_arbitration_isValid;
  wire                memory_arbitration_isStuck;
  wire                memory_arbitration_isStuckByOthers;
  wire                memory_arbitration_isFlushed;
  wire                memory_arbitration_isMoving;
  wire                memory_arbitration_isFiring;
  wire                writeBack_arbitration_haltItself;
  wire                writeBack_arbitration_haltByOther;
  reg                 writeBack_arbitration_removeIt;
  wire                writeBack_arbitration_flushIt;
  reg                 writeBack_arbitration_flushNext;
  reg                 writeBack_arbitration_isValid;
  wire                writeBack_arbitration_isStuck;
  wire                writeBack_arbitration_isStuckByOthers;
  wire                writeBack_arbitration_isFlushed;
  wire                writeBack_arbitration_isMoving;
  wire                writeBack_arbitration_isFiring;
  wire       [31:0]   lastStageInstruction /* verilator public */ ;
  wire       [31:0]   lastStagePc /* verilator public */ ;
  wire                lastStageIsValid /* verilator public */ ;
  wire                lastStageIsFiring /* verilator public */ ;
  reg                 IBusSimplePlugin_fetcherHalt;
  reg                 IBusSimplePlugin_incomingInstruction;
  wire                IBusSimplePlugin_predictionJumpInterface_valid;
  (* keep , syn_keep *) wire       [31:0]   IBusSimplePlugin_predictionJumpInterface_payload /* synthesis syn_keep = 1 */ ;
  reg                 IBusSimplePlugin_decodePrediction_cmd_hadBranch;
  wire                IBusSimplePlugin_decodePrediction_rsp_wasWrong;
  wire                IBusSimplePlugin_pcValids_0;
  wire                IBusSimplePlugin_pcValids_1;
  wire                IBusSimplePlugin_pcValids_2;
  wire                IBusSimplePlugin_pcValids_3;
  reg                 DBusSimplePlugin_memoryExceptionPort_valid;
  reg        [3:0]    DBusSimplePlugin_memoryExceptionPort_payload_code;
  wire       [31:0]   DBusSimplePlugin_memoryExceptionPort_payload_badAddr;
  wire                CsrPlugin_inWfi /* verilator public */ ;
  wire                CsrPlugin_thirdPartyWake;
  reg                 CsrPlugin_jumpInterface_valid;
  reg        [31:0]   CsrPlugin_jumpInterface_payload;
  wire                CsrPlugin_exceptionPendings_0;
  wire                CsrPlugin_exceptionPendings_1;
  wire                CsrPlugin_exceptionPendings_2;
  wire                CsrPlugin_exceptionPendings_3;
  wire                contextSwitching;
  reg        [1:0]    CsrPlugin_privilege;
  wire                CsrPlugin_forceMachineWire;
  wire                CsrPlugin_allowInterrupts;
  wire                CsrPlugin_allowException;
  wire                decodeExceptionPort_valid;
  wire       [3:0]    decodeExceptionPort_payload_code;
  wire       [31:0]   decodeExceptionPort_payload_badAddr;
  wire                BranchPlugin_jumpInterface_valid;
  wire       [31:0]   BranchPlugin_jumpInterface_payload;
  wire                IBusSimplePlugin_externalFlush;
  wire                IBusSimplePlugin_jump_pcLoad_valid;
  wire       [31:0]   IBusSimplePlugin_jump_pcLoad_payload;
  wire       [2:0]    _zz_51_;
  wire       [2:0]    _zz_52_;
  wire                _zz_53_;
  wire                _zz_54_;
  wire                IBusSimplePlugin_fetchPc_output_valid;
  wire                IBusSimplePlugin_fetchPc_output_ready;
  wire       [31:0]   IBusSimplePlugin_fetchPc_output_payload;
  reg        [31:0]   IBusSimplePlugin_fetchPc_pcReg /* verilator public */ ;
  reg                 IBusSimplePlugin_fetchPc_correction;
  reg                 IBusSimplePlugin_fetchPc_correctionReg;
  wire                IBusSimplePlugin_fetchPc_corrected;
  reg                 IBusSimplePlugin_fetchPc_pcRegPropagate;
  reg                 IBusSimplePlugin_fetchPc_booted;
  reg                 IBusSimplePlugin_fetchPc_inc;
  reg        [31:0]   IBusSimplePlugin_fetchPc_pc;
  reg                 IBusSimplePlugin_fetchPc_flushed;
  wire                IBusSimplePlugin_iBusRsp_redoFetch;
  wire                IBusSimplePlugin_iBusRsp_stages_0_input_valid;
  wire                IBusSimplePlugin_iBusRsp_stages_0_input_ready;
  wire       [31:0]   IBusSimplePlugin_iBusRsp_stages_0_input_payload;
  wire                IBusSimplePlugin_iBusRsp_stages_0_output_valid;
  wire                IBusSimplePlugin_iBusRsp_stages_0_output_ready;
  wire       [31:0]   IBusSimplePlugin_iBusRsp_stages_0_output_payload;
  reg                 IBusSimplePlugin_iBusRsp_stages_0_halt;
  wire                IBusSimplePlugin_iBusRsp_stages_1_input_valid;
  wire                IBusSimplePlugin_iBusRsp_stages_1_input_ready;
  wire       [31:0]   IBusSimplePlugin_iBusRsp_stages_1_input_payload;
  wire                IBusSimplePlugin_iBusRsp_stages_1_output_valid;
  wire                IBusSimplePlugin_iBusRsp_stages_1_output_ready;
  wire       [31:0]   IBusSimplePlugin_iBusRsp_stages_1_output_payload;
  wire                IBusSimplePlugin_iBusRsp_stages_1_halt;
  wire                _zz_55_;
  wire                _zz_56_;
  wire                IBusSimplePlugin_iBusRsp_flush;
  wire                _zz_57_;
  wire                _zz_58_;
  reg                 _zz_59_;
  reg                 IBusSimplePlugin_iBusRsp_readyForError;
  wire                IBusSimplePlugin_iBusRsp_output_valid;
  wire                IBusSimplePlugin_iBusRsp_output_ready;
  wire       [31:0]   IBusSimplePlugin_iBusRsp_output_payload_pc;
  wire                IBusSimplePlugin_iBusRsp_output_payload_rsp_error;
  wire       [31:0]   IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
  wire                IBusSimplePlugin_iBusRsp_output_payload_isRvc;
  wire                IBusSimplePlugin_injector_decodeInput_valid;
  wire                IBusSimplePlugin_injector_decodeInput_ready;
  wire       [31:0]   IBusSimplePlugin_injector_decodeInput_payload_pc;
  wire                IBusSimplePlugin_injector_decodeInput_payload_rsp_error;
  wire       [31:0]   IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  wire                IBusSimplePlugin_injector_decodeInput_payload_isRvc;
  reg                 _zz_60_;
  reg        [31:0]   _zz_61_;
  reg                 _zz_62_;
  reg        [31:0]   _zz_63_;
  reg                 _zz_64_;
  reg                 IBusSimplePlugin_injector_nextPcCalc_valids_0;
  reg                 IBusSimplePlugin_injector_nextPcCalc_valids_1;
  reg                 IBusSimplePlugin_injector_nextPcCalc_valids_2;
  reg                 IBusSimplePlugin_injector_nextPcCalc_valids_3;
  reg                 IBusSimplePlugin_injector_nextPcCalc_valids_4;
  reg        [31:0]   IBusSimplePlugin_injector_formal_rawInDecode;
  wire                _zz_65_;
  reg        [18:0]   _zz_66_;
  wire                _zz_67_;
  reg        [10:0]   _zz_68_;
  wire                _zz_69_;
  reg        [18:0]   _zz_70_;
  reg                 _zz_71_;
  wire                _zz_72_;
  reg        [10:0]   _zz_73_;
  wire                _zz_74_;
  reg        [18:0]   _zz_75_;
  wire                IBusSimplePlugin_cmd_valid;
  wire                IBusSimplePlugin_cmd_ready;
  wire       [31:0]   IBusSimplePlugin_cmd_payload_pc;
  wire                IBusSimplePlugin_pending_inc;
  wire                IBusSimplePlugin_pending_dec;
  reg        [2:0]    IBusSimplePlugin_pending_value;
  wire       [2:0]    IBusSimplePlugin_pending_next;
  wire                IBusSimplePlugin_cmdFork_canEmit;
  wire                IBusSimplePlugin_rspJoin_rspBuffer_output_valid;
  wire                IBusSimplePlugin_rspJoin_rspBuffer_output_ready;
  wire                IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error;
  wire       [31:0]   IBusSimplePlugin_rspJoin_rspBuffer_output_payload_inst;
  reg        [2:0]    IBusSimplePlugin_rspJoin_rspBuffer_discardCounter;
  wire                IBusSimplePlugin_rspJoin_rspBuffer_flush;
  wire       [31:0]   IBusSimplePlugin_rspJoin_fetchRsp_pc;
  reg                 IBusSimplePlugin_rspJoin_fetchRsp_rsp_error;
  wire       [31:0]   IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst;
  wire                IBusSimplePlugin_rspJoin_fetchRsp_isRvc;
  wire                IBusSimplePlugin_rspJoin_join_valid;
  wire                IBusSimplePlugin_rspJoin_join_ready;
  wire       [31:0]   IBusSimplePlugin_rspJoin_join_payload_pc;
  wire                IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  wire       [31:0]   IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  wire                IBusSimplePlugin_rspJoin_join_payload_isRvc;
  wire                IBusSimplePlugin_rspJoin_exceptionDetected;
  wire                _zz_76_;
  wire                _zz_77_;
  reg                 execute_DBusSimplePlugin_skipCmd;
  reg        [31:0]   _zz_78_;
  reg        [3:0]    _zz_79_;
  wire       [3:0]    execute_DBusSimplePlugin_formalMask;
  reg        [31:0]   memory_DBusSimplePlugin_rspShifted;
  wire                _zz_80_;
  reg        [31:0]   _zz_81_;
  wire                _zz_82_;
  reg        [31:0]   _zz_83_;
  reg        [31:0]   memory_DBusSimplePlugin_rspFormated;
  wire       [1:0]    CsrPlugin_misa_base;
  wire       [25:0]   CsrPlugin_misa_extensions;
  wire       [1:0]    CsrPlugin_mtvec_mode;
  wire       [29:0]   CsrPlugin_mtvec_base;
  reg        [31:0]   CsrPlugin_mepc;
  reg                 CsrPlugin_mstatus_MIE;
  reg                 CsrPlugin_mstatus_MPIE;
  reg        [1:0]    CsrPlugin_mstatus_MPP;
  reg                 CsrPlugin_mip_MEIP;
  reg                 CsrPlugin_mip_MTIP;
  reg                 CsrPlugin_mip_MSIP;
  reg                 CsrPlugin_mie_MEIE;
  reg                 CsrPlugin_mie_MTIE;
  reg                 CsrPlugin_mie_MSIE;
  reg                 CsrPlugin_mcause_interrupt;
  reg        [3:0]    CsrPlugin_mcause_exceptionCode;
  reg        [31:0]   CsrPlugin_mtval;
  reg        [63:0]   CsrPlugin_mcycle = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  reg        [63:0]   CsrPlugin_minstret = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  wire                _zz_84_;
  wire                _zz_85_;
  wire                _zz_86_;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  reg        [3:0]    CsrPlugin_exceptionPortCtrl_exceptionContext_code;
  reg        [31:0]   CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
  wire       [1:0]    CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped;
  wire       [1:0]    CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
  reg                 CsrPlugin_interrupt_valid;
  reg        [3:0]    CsrPlugin_interrupt_code /* verilator public */ ;
  reg        [1:0]    CsrPlugin_interrupt_targetPrivilege;
  wire                CsrPlugin_exception;
  wire                CsrPlugin_lastStageWasWfi;
  reg                 CsrPlugin_pipelineLiberator_pcValids_0;
  reg                 CsrPlugin_pipelineLiberator_pcValids_1;
  reg                 CsrPlugin_pipelineLiberator_pcValids_2;
  wire                CsrPlugin_pipelineLiberator_active;
  reg                 CsrPlugin_pipelineLiberator_done;
  wire                CsrPlugin_interruptJump /* verilator public */ ;
  reg                 CsrPlugin_hadException;
  reg        [1:0]    CsrPlugin_targetPrivilege;
  reg        [3:0]    CsrPlugin_trapCause;
  reg        [1:0]    CsrPlugin_xtvec_mode;
  reg        [29:0]   CsrPlugin_xtvec_base;
  reg                 execute_CsrPlugin_wfiWake;
  wire                execute_CsrPlugin_blockedBySideEffects;
  reg                 execute_CsrPlugin_illegalAccess;
  reg                 execute_CsrPlugin_illegalInstruction;
  wire       [31:0]   execute_CsrPlugin_readData;
  wire                execute_CsrPlugin_writeInstruction;
  wire                execute_CsrPlugin_readInstruction;
  wire                execute_CsrPlugin_writeEnable;
  wire                execute_CsrPlugin_readEnable;
  wire       [31:0]   execute_CsrPlugin_readToWriteData;
  reg        [31:0]   execute_CsrPlugin_writeData;
  wire       [11:0]   execute_CsrPlugin_csrAddress;
  wire       [24:0]   _zz_87_;
  wire                _zz_88_;
  wire                _zz_89_;
  wire                _zz_90_;
  wire                _zz_91_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_92_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_93_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_94_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_95_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_96_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_97_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_98_;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress1;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress2;
  wire       [31:0]   decode_RegFilePlugin_rs1Data;
  wire       [31:0]   decode_RegFilePlugin_rs2Data;
  reg                 lastStageRegFileWrite_valid /* verilator public */ ;
  wire       [4:0]    lastStageRegFileWrite_payload_address /* verilator public */ ;
  wire       [31:0]   lastStageRegFileWrite_payload_data /* verilator public */ ;
  reg                 _zz_99_;
  reg        [31:0]   execute_IntAluPlugin_bitwise;
  reg        [31:0]   _zz_100_;
  reg        [31:0]   _zz_101_;
  wire                _zz_102_;
  reg        [19:0]   _zz_103_;
  wire                _zz_104_;
  reg        [19:0]   _zz_105_;
  reg        [31:0]   _zz_106_;
  reg        [31:0]   execute_SrcPlugin_addSub;
  wire                execute_SrcPlugin_less;
  wire       [4:0]    execute_FullBarrelShifterPlugin_amplitude;
  reg        [31:0]   _zz_107_;
  wire       [31:0]   execute_FullBarrelShifterPlugin_reversed;
  reg        [31:0]   _zz_108_;
  reg                 _zz_109_;
  reg                 _zz_110_;
  reg                 _zz_111_;
  reg        [4:0]    _zz_112_;
  reg        [31:0]   _zz_113_;
  wire                _zz_114_;
  wire                _zz_115_;
  wire                _zz_116_;
  wire                _zz_117_;
  wire                _zz_118_;
  wire                _zz_119_;
  wire                execute_BranchPlugin_eq;
  wire       [2:0]    _zz_120_;
  reg                 _zz_121_;
  reg                 _zz_122_;
  wire                _zz_123_;
  reg        [19:0]   _zz_124_;
  wire                _zz_125_;
  reg        [10:0]   _zz_126_;
  wire                _zz_127_;
  reg        [18:0]   _zz_128_;
  reg                 _zz_129_;
  wire                execute_BranchPlugin_missAlignedTarget;
  reg        [31:0]   execute_BranchPlugin_branch_src1;
  reg        [31:0]   execute_BranchPlugin_branch_src2;
  wire                _zz_130_;
  reg        [19:0]   _zz_131_;
  wire                _zz_132_;
  reg        [10:0]   _zz_133_;
  wire                _zz_134_;
  reg        [18:0]   _zz_135_;
  wire       [31:0]   execute_BranchPlugin_branchAdder;
  reg                 decode_to_execute_CSR_WRITE_OPCODE;
  reg        `Src1CtrlEnum_defaultEncoding_type decode_to_execute_SRC1_CTRL;
  reg        [31:0]   decode_to_execute_FORMAL_PC_NEXT;
  reg        [31:0]   execute_to_memory_FORMAL_PC_NEXT;
  reg        [31:0]   memory_to_writeBack_FORMAL_PC_NEXT;
  reg        [31:0]   decode_to_execute_PC;
  reg        [31:0]   execute_to_memory_PC;
  reg        [31:0]   memory_to_writeBack_PC;
  reg                 decode_to_execute_SRC2_FORCE_ZERO;
  reg                 decode_to_execute_SRC_USE_SUB_LESS;
  reg        [31:0]   decode_to_execute_RS1;
  reg        [31:0]   execute_to_memory_REGFILE_WRITE_DATA;
  reg        [31:0]   memory_to_writeBack_REGFILE_WRITE_DATA;
  reg        `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg        `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg        [31:0]   decode_to_execute_RS2;
  reg        `Src2CtrlEnum_defaultEncoding_type decode_to_execute_SRC2_CTRL;
  reg                 decode_to_execute_MEMORY_STORE;
  reg                 execute_to_memory_MEMORY_STORE;
  reg                 decode_to_execute_CSR_READ_OPCODE;
  reg                 decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg                 execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg        `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg                 decode_to_execute_IS_CSR;
  reg        [31:0]   decode_to_execute_INSTRUCTION;
  reg        [31:0]   execute_to_memory_INSTRUCTION;
  reg        [31:0]   memory_to_writeBack_INSTRUCTION;
  reg                 decode_to_execute_MEMORY_ENABLE;
  reg                 execute_to_memory_MEMORY_ENABLE;
  reg                 decode_to_execute_REGFILE_WRITE_VALID;
  reg                 execute_to_memory_REGFILE_WRITE_VALID;
  reg                 memory_to_writeBack_REGFILE_WRITE_VALID;
  reg                 decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg        [1:0]    execute_to_memory_MEMORY_ADDRESS_LOW;
  reg                 decode_to_execute_SRC_LESS_UNSIGNED;
  reg                 execute_to_memory_ALIGNEMENT_FAULT;
  reg        `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg        `EnvCtrlEnum_defaultEncoding_type decode_to_execute_ENV_CTRL;
  reg        `EnvCtrlEnum_defaultEncoding_type execute_to_memory_ENV_CTRL;
  reg        `EnvCtrlEnum_defaultEncoding_type memory_to_writeBack_ENV_CTRL;
  reg                 decode_to_execute_PREDICTION_HAD_BRANCHED2;
  reg                 execute_CsrPlugin_csr_768;
  reg                 execute_CsrPlugin_csr_836;
  reg                 execute_CsrPlugin_csr_772;
  reg                 execute_CsrPlugin_csr_834;
  reg        [31:0]   _zz_136_;
  reg        [31:0]   _zz_137_;
  reg        [31:0]   _zz_138_;
  reg        [31:0]   _zz_139_;
  `ifndef SYNTHESIS
  reg [31:0] _zz_1__string;
  reg [31:0] _zz_2__string;
  reg [31:0] _zz_3__string;
  reg [31:0] _zz_4__string;
  reg [31:0] decode_ENV_CTRL_string;
  reg [31:0] _zz_5__string;
  reg [31:0] _zz_6__string;
  reg [31:0] _zz_7__string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_8__string;
  reg [63:0] _zz_9__string;
  reg [63:0] _zz_10__string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_11__string;
  reg [71:0] _zz_12__string;
  reg [71:0] _zz_13__string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_14__string;
  reg [23:0] _zz_15__string;
  reg [23:0] _zz_16__string;
  reg [31:0] _zz_17__string;
  reg [31:0] _zz_18__string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_19__string;
  reg [39:0] _zz_20__string;
  reg [39:0] _zz_21__string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_22__string;
  reg [95:0] _zz_23__string;
  reg [95:0] _zz_24__string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_25__string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_26__string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_28__string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_29__string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_30__string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_31__string;
  reg [71:0] _zz_36__string;
  reg [39:0] _zz_37__string;
  reg [63:0] _zz_38__string;
  reg [31:0] _zz_39__string;
  reg [31:0] _zz_40__string;
  reg [95:0] _zz_41__string;
  reg [23:0] _zz_42__string;
  reg [31:0] memory_ENV_CTRL_string;
  reg [31:0] _zz_44__string;
  reg [31:0] execute_ENV_CTRL_string;
  reg [31:0] _zz_45__string;
  reg [31:0] writeBack_ENV_CTRL_string;
  reg [31:0] _zz_46__string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_48__string;
  reg [23:0] _zz_92__string;
  reg [95:0] _zz_93__string;
  reg [31:0] _zz_94__string;
  reg [31:0] _zz_95__string;
  reg [63:0] _zz_96__string;
  reg [39:0] _zz_97__string;
  reg [71:0] _zz_98__string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [31:0] decode_to_execute_ENV_CTRL_string;
  reg [31:0] execute_to_memory_ENV_CTRL_string;
  reg [31:0] memory_to_writeBack_ENV_CTRL_string;
  `endif

  reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;

  assign _zz_145_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_146_ = 1'b1;
  assign _zz_147_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_148_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_149_ = (execute_arbitration_isValid && execute_IS_CSR);
  assign _zz_150_ = (CsrPlugin_hadException || CsrPlugin_interruptJump);
  assign _zz_151_ = (writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET));
  assign _zz_152_ = writeBack_INSTRUCTION[29 : 28];
  assign _zz_153_ = ((dBus_rsp_ready && dBus_rsp_error) && (! memory_MEMORY_STORE));
  assign _zz_154_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_155_ = (1'b0 || (! 1'b1));
  assign _zz_156_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_157_ = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_158_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_159_ = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_160_ = (CsrPlugin_mstatus_MIE || (CsrPlugin_privilege < (2'b11)));
  assign _zz_161_ = ((_zz_84_ && 1'b1) && (! 1'b0));
  assign _zz_162_ = ((_zz_85_ && 1'b1) && (! 1'b0));
  assign _zz_163_ = ((_zz_86_ && 1'b1) && (! 1'b0));
  assign _zz_164_ = memory_INSTRUCTION[13 : 12];
  assign _zz_165_ = execute_INSTRUCTION[13];
  assign _zz_166_ = _zz_87_[19 : 19];
  assign _zz_167_ = _zz_87_[8 : 8];
  assign _zz_168_ = _zz_87_[20 : 20];
  assign _zz_169_ = _zz_87_[23 : 23];
  assign _zz_170_ = _zz_87_[12 : 12];
  assign _zz_171_ = _zz_87_[1 : 1];
  assign _zz_172_ = _zz_87_[0 : 0];
  assign _zz_173_ = _zz_87_[24 : 24];
  assign _zz_174_ = ($signed(_zz_176_) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_175_ = _zz_174_[31 : 0];
  assign _zz_176_ = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_177_ = _zz_87_[9 : 9];
  assign _zz_178_ = _zz_87_[16 : 16];
  assign _zz_179_ = _zz_87_[5 : 5];
  assign _zz_180_ = (_zz_51_ - (3'b001));
  assign _zz_181_ = {IBusSimplePlugin_fetchPc_inc,(2'b00)};
  assign _zz_182_ = {29'd0, _zz_181_};
  assign _zz_183_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_184_ = {{_zz_66_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_185_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_186_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_187_ = {{_zz_68_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_188_ = {{_zz_70_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_189_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_190_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_191_ = (IBusSimplePlugin_pending_value + _zz_193_);
  assign _zz_192_ = IBusSimplePlugin_pending_inc;
  assign _zz_193_ = {2'd0, _zz_192_};
  assign _zz_194_ = IBusSimplePlugin_pending_dec;
  assign _zz_195_ = {2'd0, _zz_194_};
  assign _zz_196_ = (IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid && (IBusSimplePlugin_rspJoin_rspBuffer_discardCounter != (3'b000)));
  assign _zz_197_ = {2'd0, _zz_196_};
  assign _zz_198_ = IBusSimplePlugin_pending_dec;
  assign _zz_199_ = {2'd0, _zz_198_};
  assign _zz_200_ = (memory_MEMORY_STORE ? (3'b110) : (3'b100));
  assign _zz_201_ = execute_SRC_LESS;
  assign _zz_202_ = (3'b100);
  assign _zz_203_ = execute_INSTRUCTION[19 : 15];
  assign _zz_204_ = execute_INSTRUCTION[31 : 20];
  assign _zz_205_ = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_206_ = ($signed(_zz_207_) + $signed(_zz_210_));
  assign _zz_207_ = ($signed(_zz_208_) + $signed(_zz_209_));
  assign _zz_208_ = execute_SRC1;
  assign _zz_209_ = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_210_ = (execute_SRC_USE_SUB_LESS ? _zz_211_ : _zz_212_);
  assign _zz_211_ = 32'h00000001;
  assign _zz_212_ = 32'h0;
  assign _zz_213_ = execute_INSTRUCTION[31 : 20];
  assign _zz_214_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_215_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_216_ = {_zz_124_,execute_INSTRUCTION[31 : 20]};
  assign _zz_217_ = {{_zz_126_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_218_ = {{_zz_128_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_219_ = execute_INSTRUCTION[31 : 20];
  assign _zz_220_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_221_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_222_ = (3'b100);
  assign _zz_223_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_224_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_225_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_226_ = execute_CsrPlugin_writeData[11 : 11];
  assign _zz_227_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_228_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_229_ = {_zz_54_,_zz_53_};
  assign _zz_230_ = 32'h0000107f;
  assign _zz_231_ = (decode_INSTRUCTION & 32'h0000207f);
  assign _zz_232_ = 32'h00002073;
  assign _zz_233_ = ((decode_INSTRUCTION & 32'h0000407f) == 32'h00004063);
  assign _zz_234_ = ((decode_INSTRUCTION & 32'h0000207f) == 32'h00002013);
  assign _zz_235_ = {((decode_INSTRUCTION & 32'h0000603f) == 32'h00000023),{((decode_INSTRUCTION & 32'h0000207f) == 32'h00000003),{((decode_INSTRUCTION & _zz_236_) == 32'h00000003),{(_zz_237_ == _zz_238_),{_zz_239_,{_zz_240_,_zz_241_}}}}}};
  assign _zz_236_ = 32'h0000505f;
  assign _zz_237_ = (decode_INSTRUCTION & 32'h0000707b);
  assign _zz_238_ = 32'h00000063;
  assign _zz_239_ = ((decode_INSTRUCTION & 32'h0000607f) == 32'h0000000f);
  assign _zz_240_ = ((decode_INSTRUCTION & 32'hfe00007f) == 32'h00000033);
  assign _zz_241_ = {((decode_INSTRUCTION & 32'hbc00707f) == 32'h00005013),{((decode_INSTRUCTION & 32'hfc00307f) == 32'h00001013),{((decode_INSTRUCTION & _zz_242_) == 32'h00005033),{(_zz_243_ == _zz_244_),(_zz_245_ == _zz_246_)}}}};
  assign _zz_242_ = 32'hbe00707f;
  assign _zz_243_ = (decode_INSTRUCTION & 32'hbe00707f);
  assign _zz_244_ = 32'h00000033;
  assign _zz_245_ = (decode_INSTRUCTION & 32'hdfffffff);
  assign _zz_246_ = 32'h10200073;
  assign _zz_247_ = decode_INSTRUCTION[31];
  assign _zz_248_ = decode_INSTRUCTION[31];
  assign _zz_249_ = decode_INSTRUCTION[7];
  assign _zz_250_ = (decode_INSTRUCTION & 32'h00000044);
  assign _zz_251_ = 32'h0;
  assign _zz_252_ = ((decode_INSTRUCTION & _zz_263_) == 32'h0);
  assign _zz_253_ = (_zz_264_ == _zz_265_);
  assign _zz_254_ = (_zz_266_ == _zz_267_);
  assign _zz_255_ = ((decode_INSTRUCTION & _zz_268_) == 32'h00001050);
  assign _zz_256_ = ((decode_INSTRUCTION & _zz_269_) == 32'h00002050);
  assign _zz_257_ = ((decode_INSTRUCTION & _zz_270_) == 32'h00005010);
  assign _zz_258_ = {_zz_271_,_zz_272_};
  assign _zz_259_ = (2'b00);
  assign _zz_260_ = (_zz_273_ != (1'b0));
  assign _zz_261_ = (_zz_274_ != _zz_275_);
  assign _zz_262_ = {_zz_276_,{_zz_277_,_zz_278_}};
  assign _zz_263_ = 32'h00000018;
  assign _zz_264_ = (decode_INSTRUCTION & 32'h00006004);
  assign _zz_265_ = 32'h00002000;
  assign _zz_266_ = (decode_INSTRUCTION & 32'h00005004);
  assign _zz_267_ = 32'h00001000;
  assign _zz_268_ = 32'h00001050;
  assign _zz_269_ = 32'h00002050;
  assign _zz_270_ = 32'h00007054;
  assign _zz_271_ = ((decode_INSTRUCTION & 32'h40003054) == 32'h40001010);
  assign _zz_272_ = ((decode_INSTRUCTION & 32'h00007054) == 32'h00001010);
  assign _zz_273_ = ((decode_INSTRUCTION & 32'h00000058) == 32'h0);
  assign _zz_274_ = {(_zz_279_ == _zz_280_),(_zz_281_ == _zz_282_)};
  assign _zz_275_ = (2'b00);
  assign _zz_276_ = ((_zz_283_ == _zz_284_) != (1'b0));
  assign _zz_277_ = (_zz_285_ != (1'b0));
  assign _zz_278_ = {(_zz_286_ != _zz_287_),{_zz_288_,{_zz_289_,_zz_290_}}};
  assign _zz_279_ = (decode_INSTRUCTION & 32'h00002010);
  assign _zz_280_ = 32'h00002000;
  assign _zz_281_ = (decode_INSTRUCTION & 32'h00005000);
  assign _zz_282_ = 32'h00001000;
  assign _zz_283_ = (decode_INSTRUCTION & 32'h00001000);
  assign _zz_284_ = 32'h00001000;
  assign _zz_285_ = ((decode_INSTRUCTION & 32'h00003000) == 32'h00002000);
  assign _zz_286_ = ((decode_INSTRUCTION & 32'h00000064) == 32'h00000024);
  assign _zz_287_ = (1'b0);
  assign _zz_288_ = (((decode_INSTRUCTION & _zz_291_) == 32'h00004010) != (1'b0));
  assign _zz_289_ = ((_zz_292_ == _zz_293_) != (1'b0));
  assign _zz_290_ = {(_zz_294_ != (1'b0)),{(_zz_295_ != _zz_296_),{_zz_297_,{_zz_298_,_zz_299_}}}};
  assign _zz_291_ = 32'h00004014;
  assign _zz_292_ = (decode_INSTRUCTION & 32'h00006014);
  assign _zz_293_ = 32'h00002010;
  assign _zz_294_ = ((decode_INSTRUCTION & 32'h00003050) == 32'h00000050);
  assign _zz_295_ = ((decode_INSTRUCTION & 32'h0) == 32'h0);
  assign _zz_296_ = (1'b0);
  assign _zz_297_ = ({_zz_90_,(_zz_300_ == _zz_301_)} != (2'b00));
  assign _zz_298_ = ((_zz_302_ == _zz_303_) != (1'b0));
  assign _zz_299_ = {({_zz_304_,_zz_305_} != (3'b000)),{(_zz_306_ != _zz_307_),{_zz_308_,{_zz_309_,_zz_310_}}}};
  assign _zz_300_ = (decode_INSTRUCTION & 32'h0000001c);
  assign _zz_301_ = 32'h00000004;
  assign _zz_302_ = (decode_INSTRUCTION & 32'h00000058);
  assign _zz_303_ = 32'h00000040;
  assign _zz_304_ = ((decode_INSTRUCTION & _zz_311_) == 32'h00000040);
  assign _zz_305_ = {(_zz_312_ == _zz_313_),(_zz_314_ == _zz_315_)};
  assign _zz_306_ = _zz_89_;
  assign _zz_307_ = (1'b0);
  assign _zz_308_ = ({_zz_316_,_zz_91_} != (2'b00));
  assign _zz_309_ = ({_zz_317_,_zz_318_} != (2'b00));
  assign _zz_310_ = {(_zz_319_ != _zz_320_),{_zz_321_,{_zz_322_,_zz_323_}}};
  assign _zz_311_ = 32'h00000044;
  assign _zz_312_ = (decode_INSTRUCTION & 32'h00002014);
  assign _zz_313_ = 32'h00002010;
  assign _zz_314_ = (decode_INSTRUCTION & 32'h40000034);
  assign _zz_315_ = 32'h40000030;
  assign _zz_316_ = ((decode_INSTRUCTION & 32'h00000014) == 32'h00000004);
  assign _zz_317_ = ((decode_INSTRUCTION & _zz_324_) == 32'h00000004);
  assign _zz_318_ = _zz_91_;
  assign _zz_319_ = {_zz_90_,{_zz_325_,{_zz_326_,_zz_327_}}};
  assign _zz_320_ = 6'h0;
  assign _zz_321_ = ({_zz_88_,_zz_328_} != (2'b00));
  assign _zz_322_ = ({_zz_329_,_zz_330_} != (2'b00));
  assign _zz_323_ = {(_zz_331_ != _zz_332_),{_zz_333_,_zz_334_}};
  assign _zz_324_ = 32'h00000044;
  assign _zz_325_ = ((decode_INSTRUCTION & 32'h00001010) == 32'h00001010);
  assign _zz_326_ = ((decode_INSTRUCTION & _zz_335_) == 32'h00002010);
  assign _zz_327_ = {_zz_89_,{_zz_336_,_zz_337_}};
  assign _zz_328_ = ((decode_INSTRUCTION & 32'h00000070) == 32'h00000020);
  assign _zz_329_ = _zz_88_;
  assign _zz_330_ = ((decode_INSTRUCTION & _zz_338_) == 32'h0);
  assign _zz_331_ = {(_zz_339_ == _zz_340_),{_zz_341_,_zz_342_}};
  assign _zz_332_ = (3'b000);
  assign _zz_333_ = ((_zz_343_ == _zz_344_) != (1'b0));
  assign _zz_334_ = ({_zz_345_,_zz_346_} != (2'b00));
  assign _zz_335_ = 32'h00002010;
  assign _zz_336_ = ((decode_INSTRUCTION & 32'h0000000c) == 32'h00000004);
  assign _zz_337_ = ((decode_INSTRUCTION & 32'h00000028) == 32'h0);
  assign _zz_338_ = 32'h00000020;
  assign _zz_339_ = (decode_INSTRUCTION & 32'h00000050);
  assign _zz_340_ = 32'h00000040;
  assign _zz_341_ = ((decode_INSTRUCTION & 32'h00003040) == 32'h00000040);
  assign _zz_342_ = ((decode_INSTRUCTION & 32'h00000038) == 32'h0);
  assign _zz_343_ = (decode_INSTRUCTION & 32'h00000020);
  assign _zz_344_ = 32'h00000020;
  assign _zz_345_ = ((decode_INSTRUCTION & 32'h00000034) == 32'h00000020);
  assign _zz_346_ = ((decode_INSTRUCTION & 32'h00000064) == 32'h00000020);
  assign _zz_347_ = execute_INSTRUCTION[31];
  assign _zz_348_ = execute_INSTRUCTION[31];
  assign _zz_349_ = execute_INSTRUCTION[7];
  assign _zz_142_ = RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
  assign _zz_143_ = RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
  always @ (posedge clk) begin
    if(_zz_35_) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  StreamFifoLowLatency IBusSimplePlugin_rspJoin_rspBuffer_c ( 
    .io_push_valid            (iBus_rsp_valid                                                  ), //i
    .io_push_ready            (IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready              ), //o
    .io_push_payload_error    (iBus_rsp_payload_error                                          ), //i
    .io_push_payload_inst     (iBus_rsp_payload_inst[31:0]                                     ), //i
    .io_pop_valid             (IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid               ), //o
    .io_pop_ready             (_zz_140_                                                        ), //i
    .io_pop_payload_error     (IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error       ), //o
    .io_pop_payload_inst      (IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst[31:0]  ), //o
    .io_flush                 (_zz_141_                                                        ), //i
    .io_occupancy             (IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy               ), //o
    .clk                      (clk                                                             ), //i
    .reset                    (reset                                                           )  //i
  );
  always @(*) begin
    case(_zz_229_)
      2'b00 : begin
        _zz_144_ = CsrPlugin_jumpInterface_payload;
      end
      2'b01 : begin
        _zz_144_ = BranchPlugin_jumpInterface_payload;
      end
      default : begin
        _zz_144_ = IBusSimplePlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(_zz_1_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_1__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_1__string = "XRET";
      default : _zz_1__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_2_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_2__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_2__string = "XRET";
      default : _zz_2__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_3_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_3__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_3__string = "XRET";
      default : _zz_3__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_4_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_4__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_4__string = "XRET";
      default : _zz_4__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_ENV_CTRL_string = "XRET";
      default : decode_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_5_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_5__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_5__string = "XRET";
      default : _zz_5__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_6_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_6__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_6__string = "XRET";
      default : _zz_6__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_7_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_7__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_7__string = "XRET";
      default : _zz_7__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_ALU_CTRL_string = "BITWISE ";
      default : decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_8_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_8__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_8__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_8__string = "BITWISE ";
      default : _zz_8__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_9_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_9__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_9__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_9__string = "BITWISE ";
      default : _zz_9__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_10_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_10__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_10__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_10__string = "BITWISE ";
      default : _zz_10__string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_11_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_11__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_11__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_11__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_11__string = "SRA_1    ";
      default : _zz_11__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_12_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_12__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_12__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_12__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_12__string = "SRA_1    ";
      default : _zz_12__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_13_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_13__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_13__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_13__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_13__string = "SRA_1    ";
      default : _zz_13__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_SRC2_CTRL_string = "PC ";
      default : decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_14_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_14__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_14__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_14__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_14__string = "PC ";
      default : _zz_14__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_15_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_15__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_15__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_15__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_15__string = "PC ";
      default : _zz_15__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_16_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_16__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_16__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_16__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_16__string = "PC ";
      default : _zz_16__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_17_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_17__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_17__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_17__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_17__string = "JALR";
      default : _zz_17__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_18_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_18__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_18__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_18__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_18__string = "JALR";
      default : _zz_18__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_19_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_19__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_19__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_19__string = "AND_1";
      default : _zz_19__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_20_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_20__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_20__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_20__string = "AND_1";
      default : _zz_20__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_21_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_21__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_21__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_21__string = "AND_1";
      default : _zz_21__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_SRC1_CTRL_string = "URS1        ";
      default : decode_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_22_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_22__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_22__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_22__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_22__string = "URS1        ";
      default : _zz_22__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_23_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_23__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_23__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_23__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_23__string = "URS1        ";
      default : _zz_23__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_24_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_24__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_24__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_24__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_24__string = "URS1        ";
      default : _zz_24__string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : execute_BRANCH_CTRL_string = "JALR";
      default : execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_25_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_25__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_25__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_25__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_25__string = "JALR";
      default : _zz_25__string = "????";
    endcase
  end
  always @(*) begin
    case(execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_26_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_26__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_26__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_26__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_26__string = "SRA_1    ";
      default : _zz_26__string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : execute_SRC2_CTRL_string = "PC ";
      default : execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_28_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_28__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_28__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_28__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_28__string = "PC ";
      default : _zz_28__string = "???";
    endcase
  end
  always @(*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : execute_SRC1_CTRL_string = "URS1        ";
      default : execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_29_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_29__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_29__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_29__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_29__string = "URS1        ";
      default : _zz_29__string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : execute_ALU_CTRL_string = "BITWISE ";
      default : execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_30_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_30__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_30__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_30__string = "BITWISE ";
      default : _zz_30__string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_31_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_31__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_31__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_31__string = "AND_1";
      default : _zz_31__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_36_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_36__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_36__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_36__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_36__string = "SRA_1    ";
      default : _zz_36__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_37_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_37__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_37__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_37__string = "AND_1";
      default : _zz_37__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_38_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_38__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_38__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_38__string = "BITWISE ";
      default : _zz_38__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_39_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_39__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_39__string = "XRET";
      default : _zz_39__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_40_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_40__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_40__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_40__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_40__string = "JALR";
      default : _zz_40__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_41_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_41__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_41__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_41__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_41__string = "URS1        ";
      default : _zz_41__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_42_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_42__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_42__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_42__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_42__string = "PC ";
      default : _zz_42__string = "???";
    endcase
  end
  always @(*) begin
    case(memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_ENV_CTRL_string = "XRET";
      default : memory_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_44_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_44__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_44__string = "XRET";
      default : _zz_44__string = "????";
    endcase
  end
  always @(*) begin
    case(execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_ENV_CTRL_string = "XRET";
      default : execute_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_45_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_45__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_45__string = "XRET";
      default : _zz_45__string = "????";
    endcase
  end
  always @(*) begin
    case(writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : writeBack_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : writeBack_ENV_CTRL_string = "XRET";
      default : writeBack_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_46_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_46__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_46__string = "XRET";
      default : _zz_46__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_BRANCH_CTRL_string = "JALR";
      default : decode_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_48_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_48__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_48__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_48__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_48__string = "JALR";
      default : _zz_48__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_92_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_92__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_92__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_92__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_92__string = "PC ";
      default : _zz_92__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_93_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_93__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_93__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_93__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_93__string = "URS1        ";
      default : _zz_93__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_94_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_94__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_94__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_94__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_94__string = "JALR";
      default : _zz_94__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_95_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_95__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_95__string = "XRET";
      default : _zz_95__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_96_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_96__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_96__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_96__string = "BITWISE ";
      default : _zz_96__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_97_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_97__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_97__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_97__string = "AND_1";
      default : _zz_97__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_98_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_98__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_98__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_98__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_98__string = "SRA_1    ";
      default : _zz_98__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_to_execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_to_execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_to_execute_SRC1_CTRL_string = "URS1        ";
      default : decode_to_execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_to_execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_to_execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_to_execute_SRC2_CTRL_string = "PC ";
      default : decode_to_execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_to_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_to_execute_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_to_execute_ENV_CTRL_string = "XRET";
      default : decode_to_execute_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_to_memory_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_to_memory_ENV_CTRL_string = "XRET";
      default : execute_to_memory_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(memory_to_writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_to_writeBack_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_to_writeBack_ENV_CTRL_string = "XRET";
      default : memory_to_writeBack_ENV_CTRL_string = "????";
    endcase
  end
  `endif

  assign decode_PREDICTION_HAD_BRANCHED2 = IBusSimplePlugin_decodePrediction_cmd_hadBranch;
  assign _zz_1_ = _zz_2_;
  assign _zz_3_ = _zz_4_;
  assign decode_ENV_CTRL = _zz_5_;
  assign _zz_6_ = _zz_7_;
  assign decode_ALU_CTRL = _zz_8_;
  assign _zz_9_ = _zz_10_;
  assign decode_SRC_LESS_UNSIGNED = _zz_166_[0];
  assign execute_MEMORY_ADDRESS_LOW = dBus_cmd_payload_address[1 : 0];
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_167_[0];
  assign decode_MEMORY_ENABLE = _zz_168_[0];
  assign decode_IS_CSR = _zz_169_[0];
  assign decode_SHIFT_CTRL = _zz_11_;
  assign _zz_12_ = _zz_13_;
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_170_[0];
  assign decode_CSR_READ_OPCODE = (decode_INSTRUCTION[13 : 7] != 7'h20);
  assign decode_MEMORY_STORE = _zz_171_[0];
  assign decode_SRC2_CTRL = _zz_14_;
  assign _zz_15_ = _zz_16_;
  assign _zz_17_ = _zz_18_;
  assign decode_ALU_BITWISE_CTRL = _zz_19_;
  assign _zz_20_ = _zz_21_;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign execute_REGFILE_WRITE_DATA = _zz_100_;
  assign decode_SRC2_FORCE_ZERO = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  assign memory_PC = execute_to_memory_PC;
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = (decode_PC + 32'h00000004);
  assign decode_SRC1_CTRL = _zz_22_;
  assign _zz_23_ = _zz_24_;
  assign decode_CSR_WRITE_OPCODE = (! (((decode_INSTRUCTION[14 : 13] == (2'b01)) && (decode_INSTRUCTION[19 : 15] == 5'h0)) || ((decode_INSTRUCTION[14 : 13] == (2'b11)) && (decode_INSTRUCTION[19 : 15] == 5'h0))));
  assign execute_BRANCH_CALC = {execute_BranchPlugin_branchAdder[31 : 1],(1'b0)};
  assign execute_BRANCH_DO = ((execute_PREDICTION_HAD_BRANCHED2 != execute_BRANCH_COND_RESULT) || execute_BranchPlugin_missAlignedTarget);
  assign execute_PC = decode_to_execute_PC;
  assign execute_PREDICTION_HAD_BRANCHED2 = decode_to_execute_PREDICTION_HAD_BRANCHED2;
  assign execute_RS1 = decode_to_execute_RS1;
  assign execute_BRANCH_COND_RESULT = _zz_122_;
  assign execute_BRANCH_CTRL = _zz_25_;
  assign decode_RS2_USE = _zz_172_[0];
  assign decode_RS1_USE = _zz_173_[0];
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS2 = decode_RegFilePlugin_rs2Data;
    if(_zz_111_)begin
      if((_zz_112_ == decode_INSTRUCTION[24 : 20]))begin
        decode_RS2 = _zz_113_;
      end
    end
    if(_zz_145_)begin
      if(_zz_146_)begin
        if(_zz_115_)begin
          decode_RS2 = _zz_32_;
        end
      end
    end
    if(_zz_147_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_117_)begin
          decode_RS2 = _zz_47_;
        end
      end
    end
    if(_zz_148_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_119_)begin
          decode_RS2 = _zz_43_;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS1 = decode_RegFilePlugin_rs1Data;
    if(_zz_111_)begin
      if((_zz_112_ == decode_INSTRUCTION[19 : 15]))begin
        decode_RS1 = _zz_113_;
      end
    end
    if(_zz_145_)begin
      if(_zz_146_)begin
        if(_zz_114_)begin
          decode_RS1 = _zz_32_;
        end
      end
    end
    if(_zz_147_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_116_)begin
          decode_RS1 = _zz_47_;
        end
      end
    end
    if(_zz_148_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_118_)begin
          decode_RS1 = _zz_43_;
        end
      end
    end
  end

  assign execute_SHIFT_RIGHT = _zz_175_;
  assign execute_SHIFT_CTRL = _zz_26_;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign _zz_27_ = execute_PC;
  assign execute_SRC2_CTRL = _zz_28_;
  assign execute_SRC1_CTRL = _zz_29_;
  assign decode_SRC_USE_SUB_LESS = _zz_177_[0];
  assign decode_SRC_ADD_ZERO = _zz_178_[0];
  assign execute_SRC_ADD_SUB = execute_SrcPlugin_addSub;
  assign execute_SRC_LESS = execute_SrcPlugin_less;
  assign execute_ALU_CTRL = _zz_30_;
  assign execute_SRC2 = _zz_106_;
  assign execute_ALU_BITWISE_CTRL = _zz_31_;
  assign _zz_32_ = writeBack_REGFILE_WRITE_DATA;
  assign _zz_33_ = writeBack_INSTRUCTION;
  assign _zz_34_ = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_35_ = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_35_ = 1'b1;
    end
  end

  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_179_[0];
    if((decode_INSTRUCTION[11 : 7] == 5'h0))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  assign decode_LEGAL_INSTRUCTION = ({((decode_INSTRUCTION & 32'h0000005f) == 32'h00000017),{((decode_INSTRUCTION & 32'h0000007f) == 32'h0000006f),{((decode_INSTRUCTION & 32'h0000106f) == 32'h00000003),{((decode_INSTRUCTION & _zz_230_) == 32'h00001073),{(_zz_231_ == _zz_232_),{_zz_233_,{_zz_234_,_zz_235_}}}}}}} != 18'h0);
  always @ (*) begin
    _zz_43_ = execute_REGFILE_WRITE_DATA;
    if(_zz_149_)begin
      _zz_43_ = execute_CsrPlugin_readData;
    end
    if(execute_arbitration_isValid)begin
      case(execute_SHIFT_CTRL)
        `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
          _zz_43_ = _zz_108_;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_43_ = execute_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
  end

  assign execute_SRC1 = _zz_101_;
  assign execute_CSR_READ_OPCODE = decode_to_execute_CSR_READ_OPCODE;
  assign execute_CSR_WRITE_OPCODE = decode_to_execute_CSR_WRITE_OPCODE;
  assign execute_IS_CSR = decode_to_execute_IS_CSR;
  assign memory_ENV_CTRL = _zz_44_;
  assign execute_ENV_CTRL = _zz_45_;
  assign writeBack_ENV_CTRL = _zz_46_;
  always @ (*) begin
    _zz_47_ = memory_REGFILE_WRITE_DATA;
    if((memory_arbitration_isValid && memory_MEMORY_ENABLE))begin
      _zz_47_ = memory_DBusSimplePlugin_rspFormated;
    end
  end

  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign memory_MEMORY_READ_DATA = dBus_rsp_data;
  assign memory_ALIGNEMENT_FAULT = execute_to_memory_ALIGNEMENT_FAULT;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign memory_MEMORY_STORE = execute_to_memory_MEMORY_STORE;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_SRC_ADD = execute_SrcPlugin_addSub;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign execute_MEMORY_STORE = decode_to_execute_MEMORY_STORE;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  assign execute_ALIGNEMENT_FAULT = (((dBus_cmd_payload_size == (2'b10)) && (dBus_cmd_payload_address[1 : 0] != (2'b00))) || ((dBus_cmd_payload_size == (2'b01)) && (dBus_cmd_payload_address[0 : 0] != (1'b0))));
  assign decode_BRANCH_CTRL = _zz_48_;
  always @ (*) begin
    _zz_49_ = execute_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_49_ = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_50_ = decode_FORMAL_PC_NEXT;
    if(IBusSimplePlugin_predictionJumpInterface_valid)begin
      _zz_50_ = IBusSimplePlugin_predictionJumpInterface_payload;
    end
  end

  assign decode_PC = IBusSimplePlugin_injector_decodeInput_payload_pc;
  assign decode_INSTRUCTION = IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  assign decode_arbitration_haltItself = 1'b0;
  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if(CsrPlugin_pipelineLiberator_active)begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if(({(writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),{(memory_arbitration_isValid && (memory_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),(execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET))}} != (3'b000)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if((decode_arbitration_isValid && (_zz_109_ || _zz_110_)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_removeIt = 1'b0;
    if(decodeExceptionPort_valid)begin
      decode_arbitration_removeIt = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_flushIt = 1'b0;
  always @ (*) begin
    decode_arbitration_flushNext = 1'b0;
    if(IBusSimplePlugin_predictionJumpInterface_valid)begin
      decode_arbitration_flushNext = 1'b1;
    end
    if(decodeExceptionPort_valid)begin
      decode_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if(((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! dBus_cmd_ready)) && (! execute_DBusSimplePlugin_skipCmd)) && (! _zz_77_)))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(_zz_149_)begin
      if(execute_CsrPlugin_blockedBySideEffects)begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign execute_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  assign execute_arbitration_flushIt = 1'b0;
  always @ (*) begin
    execute_arbitration_flushNext = 1'b0;
    if(BranchPlugin_jumpInterface_valid)begin
      execute_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    memory_arbitration_haltItself = 1'b0;
    if((((memory_arbitration_isValid && memory_MEMORY_ENABLE) && (! memory_MEMORY_STORE)) && ((! dBus_rsp_ready) || 1'b0)))begin
      memory_arbitration_haltItself = 1'b1;
    end
  end

  assign memory_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    memory_arbitration_removeIt = 1'b0;
    if(DBusSimplePlugin_memoryExceptionPort_valid)begin
      memory_arbitration_removeIt = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  assign memory_arbitration_flushIt = 1'b0;
  always @ (*) begin
    memory_arbitration_flushNext = 1'b0;
    if(DBusSimplePlugin_memoryExceptionPort_valid)begin
      memory_arbitration_flushNext = 1'b1;
    end
  end

  assign writeBack_arbitration_haltItself = 1'b0;
  assign writeBack_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(writeBack_arbitration_isFlushed)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  assign writeBack_arbitration_flushIt = 1'b0;
  always @ (*) begin
    writeBack_arbitration_flushNext = 1'b0;
    if(_zz_150_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_151_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
  end

  assign lastStageInstruction = writeBack_INSTRUCTION;
  assign lastStagePc = writeBack_PC;
  assign lastStageIsValid = writeBack_arbitration_isValid;
  assign lastStageIsFiring = writeBack_arbitration_isFiring;
  always @ (*) begin
    IBusSimplePlugin_fetcherHalt = 1'b0;
    if(({CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValids_memory,{CsrPlugin_exceptionPortCtrl_exceptionValids_execute,CsrPlugin_exceptionPortCtrl_exceptionValids_decode}}} != (4'b0000)))begin
      IBusSimplePlugin_fetcherHalt = 1'b1;
    end
    if(_zz_150_)begin
      IBusSimplePlugin_fetcherHalt = 1'b1;
    end
    if(_zz_151_)begin
      IBusSimplePlugin_fetcherHalt = 1'b1;
    end
  end

  always @ (*) begin
    IBusSimplePlugin_incomingInstruction = 1'b0;
    if(IBusSimplePlugin_iBusRsp_stages_1_input_valid)begin
      IBusSimplePlugin_incomingInstruction = 1'b1;
    end
    if(IBusSimplePlugin_injector_decodeInput_valid)begin
      IBusSimplePlugin_incomingInstruction = 1'b1;
    end
  end

  assign CsrPlugin_inWfi = 1'b0;
  assign CsrPlugin_thirdPartyWake = 1'b0;
  always @ (*) begin
    CsrPlugin_jumpInterface_valid = 1'b0;
    if(_zz_150_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
    if(_zz_151_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_payload = 32'h0;
    if(_zz_150_)begin
      CsrPlugin_jumpInterface_payload = {CsrPlugin_xtvec_base,(2'b00)};
    end
    if(_zz_151_)begin
      case(_zz_152_)
        2'b11 : begin
          CsrPlugin_jumpInterface_payload = CsrPlugin_mepc;
        end
        default : begin
        end
      endcase
    end
  end

  assign CsrPlugin_forceMachineWire = 1'b0;
  assign CsrPlugin_allowInterrupts = 1'b1;
  assign CsrPlugin_allowException = 1'b1;
  assign IBusSimplePlugin_externalFlush = ({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != (4'b0000));
  assign IBusSimplePlugin_jump_pcLoad_valid = ({BranchPlugin_jumpInterface_valid,{CsrPlugin_jumpInterface_valid,IBusSimplePlugin_predictionJumpInterface_valid}} != (3'b000));
  assign _zz_51_ = {IBusSimplePlugin_predictionJumpInterface_valid,{BranchPlugin_jumpInterface_valid,CsrPlugin_jumpInterface_valid}};
  assign _zz_52_ = (_zz_51_ & (~ _zz_180_));
  assign _zz_53_ = _zz_52_[1];
  assign _zz_54_ = _zz_52_[2];
  assign IBusSimplePlugin_jump_pcLoad_payload = _zz_144_;
  always @ (*) begin
    IBusSimplePlugin_fetchPc_correction = 1'b0;
    if(IBusSimplePlugin_jump_pcLoad_valid)begin
      IBusSimplePlugin_fetchPc_correction = 1'b1;
    end
  end

  assign IBusSimplePlugin_fetchPc_corrected = (IBusSimplePlugin_fetchPc_correction || IBusSimplePlugin_fetchPc_correctionReg);
  always @ (*) begin
    IBusSimplePlugin_fetchPc_pcRegPropagate = 1'b0;
    if(IBusSimplePlugin_iBusRsp_stages_1_input_ready)begin
      IBusSimplePlugin_fetchPc_pcRegPropagate = 1'b1;
    end
  end

  always @ (*) begin
    IBusSimplePlugin_fetchPc_pc = (IBusSimplePlugin_fetchPc_pcReg + _zz_182_);
    if(IBusSimplePlugin_jump_pcLoad_valid)begin
      IBusSimplePlugin_fetchPc_pc = IBusSimplePlugin_jump_pcLoad_payload;
    end
    IBusSimplePlugin_fetchPc_pc[0] = 1'b0;
    IBusSimplePlugin_fetchPc_pc[1] = 1'b0;
  end

  always @ (*) begin
    IBusSimplePlugin_fetchPc_flushed = 1'b0;
    if(IBusSimplePlugin_jump_pcLoad_valid)begin
      IBusSimplePlugin_fetchPc_flushed = 1'b1;
    end
  end

  assign IBusSimplePlugin_fetchPc_output_valid = ((! IBusSimplePlugin_fetcherHalt) && IBusSimplePlugin_fetchPc_booted);
  assign IBusSimplePlugin_fetchPc_output_payload = IBusSimplePlugin_fetchPc_pc;
  assign IBusSimplePlugin_iBusRsp_redoFetch = 1'b0;
  assign IBusSimplePlugin_iBusRsp_stages_0_input_valid = IBusSimplePlugin_fetchPc_output_valid;
  assign IBusSimplePlugin_fetchPc_output_ready = IBusSimplePlugin_iBusRsp_stages_0_input_ready;
  assign IBusSimplePlugin_iBusRsp_stages_0_input_payload = IBusSimplePlugin_fetchPc_output_payload;
  always @ (*) begin
    IBusSimplePlugin_iBusRsp_stages_0_halt = 1'b0;
    if((IBusSimplePlugin_iBusRsp_stages_0_input_valid && ((! IBusSimplePlugin_cmdFork_canEmit) || (! IBusSimplePlugin_cmd_ready))))begin
      IBusSimplePlugin_iBusRsp_stages_0_halt = 1'b1;
    end
  end

  assign _zz_55_ = (! IBusSimplePlugin_iBusRsp_stages_0_halt);
  assign IBusSimplePlugin_iBusRsp_stages_0_input_ready = (IBusSimplePlugin_iBusRsp_stages_0_output_ready && _zz_55_);
  assign IBusSimplePlugin_iBusRsp_stages_0_output_valid = (IBusSimplePlugin_iBusRsp_stages_0_input_valid && _zz_55_);
  assign IBusSimplePlugin_iBusRsp_stages_0_output_payload = IBusSimplePlugin_iBusRsp_stages_0_input_payload;
  assign IBusSimplePlugin_iBusRsp_stages_1_halt = 1'b0;
  assign _zz_56_ = (! IBusSimplePlugin_iBusRsp_stages_1_halt);
  assign IBusSimplePlugin_iBusRsp_stages_1_input_ready = (IBusSimplePlugin_iBusRsp_stages_1_output_ready && _zz_56_);
  assign IBusSimplePlugin_iBusRsp_stages_1_output_valid = (IBusSimplePlugin_iBusRsp_stages_1_input_valid && _zz_56_);
  assign IBusSimplePlugin_iBusRsp_stages_1_output_payload = IBusSimplePlugin_iBusRsp_stages_1_input_payload;
  assign IBusSimplePlugin_iBusRsp_flush = (IBusSimplePlugin_externalFlush || IBusSimplePlugin_iBusRsp_redoFetch);
  assign IBusSimplePlugin_iBusRsp_stages_0_output_ready = _zz_57_;
  assign _zz_57_ = ((1'b0 && (! _zz_58_)) || IBusSimplePlugin_iBusRsp_stages_1_input_ready);
  assign _zz_58_ = _zz_59_;
  assign IBusSimplePlugin_iBusRsp_stages_1_input_valid = _zz_58_;
  assign IBusSimplePlugin_iBusRsp_stages_1_input_payload = IBusSimplePlugin_fetchPc_pcReg;
  always @ (*) begin
    IBusSimplePlugin_iBusRsp_readyForError = 1'b1;
    if(IBusSimplePlugin_injector_decodeInput_valid)begin
      IBusSimplePlugin_iBusRsp_readyForError = 1'b0;
    end
    if((! IBusSimplePlugin_pcValids_0))begin
      IBusSimplePlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign IBusSimplePlugin_iBusRsp_output_ready = ((1'b0 && (! IBusSimplePlugin_injector_decodeInput_valid)) || IBusSimplePlugin_injector_decodeInput_ready);
  assign IBusSimplePlugin_injector_decodeInput_valid = _zz_60_;
  assign IBusSimplePlugin_injector_decodeInput_payload_pc = _zz_61_;
  assign IBusSimplePlugin_injector_decodeInput_payload_rsp_error = _zz_62_;
  assign IBusSimplePlugin_injector_decodeInput_payload_rsp_inst = _zz_63_;
  assign IBusSimplePlugin_injector_decodeInput_payload_isRvc = _zz_64_;
  assign IBusSimplePlugin_pcValids_0 = IBusSimplePlugin_injector_nextPcCalc_valids_1;
  assign IBusSimplePlugin_pcValids_1 = IBusSimplePlugin_injector_nextPcCalc_valids_2;
  assign IBusSimplePlugin_pcValids_2 = IBusSimplePlugin_injector_nextPcCalc_valids_3;
  assign IBusSimplePlugin_pcValids_3 = IBusSimplePlugin_injector_nextPcCalc_valids_4;
  assign IBusSimplePlugin_injector_decodeInput_ready = (! decode_arbitration_isStuck);
  assign decode_arbitration_isValid = IBusSimplePlugin_injector_decodeInput_valid;
  assign _zz_65_ = _zz_183_[11];
  always @ (*) begin
    _zz_66_[18] = _zz_65_;
    _zz_66_[17] = _zz_65_;
    _zz_66_[16] = _zz_65_;
    _zz_66_[15] = _zz_65_;
    _zz_66_[14] = _zz_65_;
    _zz_66_[13] = _zz_65_;
    _zz_66_[12] = _zz_65_;
    _zz_66_[11] = _zz_65_;
    _zz_66_[10] = _zz_65_;
    _zz_66_[9] = _zz_65_;
    _zz_66_[8] = _zz_65_;
    _zz_66_[7] = _zz_65_;
    _zz_66_[6] = _zz_65_;
    _zz_66_[5] = _zz_65_;
    _zz_66_[4] = _zz_65_;
    _zz_66_[3] = _zz_65_;
    _zz_66_[2] = _zz_65_;
    _zz_66_[1] = _zz_65_;
    _zz_66_[0] = _zz_65_;
  end

  always @ (*) begin
    IBusSimplePlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_184_[31]));
    if(_zz_71_)begin
      IBusSimplePlugin_decodePrediction_cmd_hadBranch = 1'b0;
    end
  end

  assign _zz_67_ = _zz_185_[19];
  always @ (*) begin
    _zz_68_[10] = _zz_67_;
    _zz_68_[9] = _zz_67_;
    _zz_68_[8] = _zz_67_;
    _zz_68_[7] = _zz_67_;
    _zz_68_[6] = _zz_67_;
    _zz_68_[5] = _zz_67_;
    _zz_68_[4] = _zz_67_;
    _zz_68_[3] = _zz_67_;
    _zz_68_[2] = _zz_67_;
    _zz_68_[1] = _zz_67_;
    _zz_68_[0] = _zz_67_;
  end

  assign _zz_69_ = _zz_186_[11];
  always @ (*) begin
    _zz_70_[18] = _zz_69_;
    _zz_70_[17] = _zz_69_;
    _zz_70_[16] = _zz_69_;
    _zz_70_[15] = _zz_69_;
    _zz_70_[14] = _zz_69_;
    _zz_70_[13] = _zz_69_;
    _zz_70_[12] = _zz_69_;
    _zz_70_[11] = _zz_69_;
    _zz_70_[10] = _zz_69_;
    _zz_70_[9] = _zz_69_;
    _zz_70_[8] = _zz_69_;
    _zz_70_[7] = _zz_69_;
    _zz_70_[6] = _zz_69_;
    _zz_70_[5] = _zz_69_;
    _zz_70_[4] = _zz_69_;
    _zz_70_[3] = _zz_69_;
    _zz_70_[2] = _zz_69_;
    _zz_70_[1] = _zz_69_;
    _zz_70_[0] = _zz_69_;
  end

  always @ (*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_71_ = _zz_187_[1];
      end
      default : begin
        _zz_71_ = _zz_188_[1];
      end
    endcase
  end

  assign IBusSimplePlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusSimplePlugin_decodePrediction_cmd_hadBranch);
  assign _zz_72_ = _zz_189_[19];
  always @ (*) begin
    _zz_73_[10] = _zz_72_;
    _zz_73_[9] = _zz_72_;
    _zz_73_[8] = _zz_72_;
    _zz_73_[7] = _zz_72_;
    _zz_73_[6] = _zz_72_;
    _zz_73_[5] = _zz_72_;
    _zz_73_[4] = _zz_72_;
    _zz_73_[3] = _zz_72_;
    _zz_73_[2] = _zz_72_;
    _zz_73_[1] = _zz_72_;
    _zz_73_[0] = _zz_72_;
  end

  assign _zz_74_ = _zz_190_[11];
  always @ (*) begin
    _zz_75_[18] = _zz_74_;
    _zz_75_[17] = _zz_74_;
    _zz_75_[16] = _zz_74_;
    _zz_75_[15] = _zz_74_;
    _zz_75_[14] = _zz_74_;
    _zz_75_[13] = _zz_74_;
    _zz_75_[12] = _zz_74_;
    _zz_75_[11] = _zz_74_;
    _zz_75_[10] = _zz_74_;
    _zz_75_[9] = _zz_74_;
    _zz_75_[8] = _zz_74_;
    _zz_75_[7] = _zz_74_;
    _zz_75_[6] = _zz_74_;
    _zz_75_[5] = _zz_74_;
    _zz_75_[4] = _zz_74_;
    _zz_75_[3] = _zz_74_;
    _zz_75_[2] = _zz_74_;
    _zz_75_[1] = _zz_74_;
    _zz_75_[0] = _zz_74_;
  end

  assign IBusSimplePlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_73_,{{{_zz_247_,decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_75_,{{{_zz_248_,_zz_249_},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusSimplePlugin_cmd_valid;
  assign IBusSimplePlugin_cmd_ready = iBus_cmd_ready;
  assign iBus_cmd_payload_pc = IBusSimplePlugin_cmd_payload_pc;
  assign IBusSimplePlugin_pending_next = (_zz_191_ - _zz_195_);
  assign IBusSimplePlugin_cmdFork_canEmit = (IBusSimplePlugin_iBusRsp_stages_0_output_ready && (IBusSimplePlugin_pending_value != (3'b111)));
  assign IBusSimplePlugin_cmd_valid = (IBusSimplePlugin_iBusRsp_stages_0_input_valid && IBusSimplePlugin_cmdFork_canEmit);
  assign IBusSimplePlugin_pending_inc = (IBusSimplePlugin_cmd_valid && IBusSimplePlugin_cmd_ready);
  assign IBusSimplePlugin_cmd_payload_pc = {IBusSimplePlugin_iBusRsp_stages_0_input_payload[31 : 2],(2'b00)};
  assign IBusSimplePlugin_rspJoin_rspBuffer_flush = ((IBusSimplePlugin_rspJoin_rspBuffer_discardCounter != (3'b000)) || IBusSimplePlugin_iBusRsp_flush);
  assign IBusSimplePlugin_rspJoin_rspBuffer_output_valid = (IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid && (IBusSimplePlugin_rspJoin_rspBuffer_discardCounter == (3'b000)));
  assign IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error = IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error;
  assign IBusSimplePlugin_rspJoin_rspBuffer_output_payload_inst = IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst;
  assign _zz_140_ = (IBusSimplePlugin_rspJoin_rspBuffer_output_ready || IBusSimplePlugin_rspJoin_rspBuffer_flush);
  assign IBusSimplePlugin_pending_dec = (IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid && _zz_140_);
  assign IBusSimplePlugin_rspJoin_fetchRsp_pc = IBusSimplePlugin_iBusRsp_stages_1_output_payload;
  always @ (*) begin
    IBusSimplePlugin_rspJoin_fetchRsp_rsp_error = IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error;
    if((! IBusSimplePlugin_rspJoin_rspBuffer_output_valid))begin
      IBusSimplePlugin_rspJoin_fetchRsp_rsp_error = 1'b0;
    end
  end

  assign IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst = IBusSimplePlugin_rspJoin_rspBuffer_output_payload_inst;
  assign IBusSimplePlugin_rspJoin_exceptionDetected = 1'b0;
  assign IBusSimplePlugin_rspJoin_join_valid = (IBusSimplePlugin_iBusRsp_stages_1_output_valid && IBusSimplePlugin_rspJoin_rspBuffer_output_valid);
  assign IBusSimplePlugin_rspJoin_join_payload_pc = IBusSimplePlugin_rspJoin_fetchRsp_pc;
  assign IBusSimplePlugin_rspJoin_join_payload_rsp_error = IBusSimplePlugin_rspJoin_fetchRsp_rsp_error;
  assign IBusSimplePlugin_rspJoin_join_payload_rsp_inst = IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst;
  assign IBusSimplePlugin_rspJoin_join_payload_isRvc = IBusSimplePlugin_rspJoin_fetchRsp_isRvc;
  assign IBusSimplePlugin_iBusRsp_stages_1_output_ready = (IBusSimplePlugin_iBusRsp_stages_1_output_valid ? (IBusSimplePlugin_rspJoin_join_valid && IBusSimplePlugin_rspJoin_join_ready) : IBusSimplePlugin_rspJoin_join_ready);
  assign IBusSimplePlugin_rspJoin_rspBuffer_output_ready = (IBusSimplePlugin_rspJoin_join_valid && IBusSimplePlugin_rspJoin_join_ready);
  assign _zz_76_ = (! IBusSimplePlugin_rspJoin_exceptionDetected);
  assign IBusSimplePlugin_rspJoin_join_ready = (IBusSimplePlugin_iBusRsp_output_ready && _zz_76_);
  assign IBusSimplePlugin_iBusRsp_output_valid = (IBusSimplePlugin_rspJoin_join_valid && _zz_76_);
  assign IBusSimplePlugin_iBusRsp_output_payload_pc = IBusSimplePlugin_rspJoin_join_payload_pc;
  assign IBusSimplePlugin_iBusRsp_output_payload_rsp_error = IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  assign IBusSimplePlugin_iBusRsp_output_payload_rsp_inst = IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  assign IBusSimplePlugin_iBusRsp_output_payload_isRvc = IBusSimplePlugin_rspJoin_join_payload_isRvc;
  assign _zz_77_ = 1'b0;
  always @ (*) begin
    execute_DBusSimplePlugin_skipCmd = 1'b0;
    if(execute_ALIGNEMENT_FAULT)begin
      execute_DBusSimplePlugin_skipCmd = 1'b1;
    end
  end

  assign dBus_cmd_valid = (((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! execute_arbitration_isStuckByOthers)) && (! execute_arbitration_isFlushed)) && (! execute_DBusSimplePlugin_skipCmd)) && (! _zz_77_));
  assign dBus_cmd_payload_wr = execute_MEMORY_STORE;
  assign dBus_cmd_payload_size = execute_INSTRUCTION[13 : 12];
  always @ (*) begin
    case(dBus_cmd_payload_size)
      2'b00 : begin
        _zz_78_ = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_78_ = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_78_ = execute_RS2[31 : 0];
      end
    endcase
  end

  assign dBus_cmd_payload_data = _zz_78_;
  always @ (*) begin
    case(dBus_cmd_payload_size)
      2'b00 : begin
        _zz_79_ = (4'b0001);
      end
      2'b01 : begin
        _zz_79_ = (4'b0011);
      end
      default : begin
        _zz_79_ = (4'b1111);
      end
    endcase
  end

  assign execute_DBusSimplePlugin_formalMask = (_zz_79_ <<< dBus_cmd_payload_address[1 : 0]);
  assign dBus_cmd_payload_address = execute_SRC_ADD;
  always @ (*) begin
    DBusSimplePlugin_memoryExceptionPort_valid = 1'b0;
    if(_zz_153_)begin
      DBusSimplePlugin_memoryExceptionPort_valid = 1'b1;
    end
    if(memory_ALIGNEMENT_FAULT)begin
      DBusSimplePlugin_memoryExceptionPort_valid = 1'b1;
    end
    if((! ((memory_arbitration_isValid && memory_MEMORY_ENABLE) && (1'b1 || (! memory_arbitration_isStuckByOthers)))))begin
      DBusSimplePlugin_memoryExceptionPort_valid = 1'b0;
    end
  end

  always @ (*) begin
    DBusSimplePlugin_memoryExceptionPort_payload_code = (4'bxxxx);
    if(_zz_153_)begin
      DBusSimplePlugin_memoryExceptionPort_payload_code = (4'b0101);
    end
    if(memory_ALIGNEMENT_FAULT)begin
      DBusSimplePlugin_memoryExceptionPort_payload_code = {1'd0, _zz_200_};
    end
  end

  assign DBusSimplePlugin_memoryExceptionPort_payload_badAddr = memory_REGFILE_WRITE_DATA;
  always @ (*) begin
    memory_DBusSimplePlugin_rspShifted = memory_MEMORY_READ_DATA;
    case(memory_MEMORY_ADDRESS_LOW)
      2'b01 : begin
        memory_DBusSimplePlugin_rspShifted[7 : 0] = memory_MEMORY_READ_DATA[15 : 8];
      end
      2'b10 : begin
        memory_DBusSimplePlugin_rspShifted[15 : 0] = memory_MEMORY_READ_DATA[31 : 16];
      end
      2'b11 : begin
        memory_DBusSimplePlugin_rspShifted[7 : 0] = memory_MEMORY_READ_DATA[31 : 24];
      end
      default : begin
      end
    endcase
  end

  assign _zz_80_ = (memory_DBusSimplePlugin_rspShifted[7] && (! memory_INSTRUCTION[14]));
  always @ (*) begin
    _zz_81_[31] = _zz_80_;
    _zz_81_[30] = _zz_80_;
    _zz_81_[29] = _zz_80_;
    _zz_81_[28] = _zz_80_;
    _zz_81_[27] = _zz_80_;
    _zz_81_[26] = _zz_80_;
    _zz_81_[25] = _zz_80_;
    _zz_81_[24] = _zz_80_;
    _zz_81_[23] = _zz_80_;
    _zz_81_[22] = _zz_80_;
    _zz_81_[21] = _zz_80_;
    _zz_81_[20] = _zz_80_;
    _zz_81_[19] = _zz_80_;
    _zz_81_[18] = _zz_80_;
    _zz_81_[17] = _zz_80_;
    _zz_81_[16] = _zz_80_;
    _zz_81_[15] = _zz_80_;
    _zz_81_[14] = _zz_80_;
    _zz_81_[13] = _zz_80_;
    _zz_81_[12] = _zz_80_;
    _zz_81_[11] = _zz_80_;
    _zz_81_[10] = _zz_80_;
    _zz_81_[9] = _zz_80_;
    _zz_81_[8] = _zz_80_;
    _zz_81_[7 : 0] = memory_DBusSimplePlugin_rspShifted[7 : 0];
  end

  assign _zz_82_ = (memory_DBusSimplePlugin_rspShifted[15] && (! memory_INSTRUCTION[14]));
  always @ (*) begin
    _zz_83_[31] = _zz_82_;
    _zz_83_[30] = _zz_82_;
    _zz_83_[29] = _zz_82_;
    _zz_83_[28] = _zz_82_;
    _zz_83_[27] = _zz_82_;
    _zz_83_[26] = _zz_82_;
    _zz_83_[25] = _zz_82_;
    _zz_83_[24] = _zz_82_;
    _zz_83_[23] = _zz_82_;
    _zz_83_[22] = _zz_82_;
    _zz_83_[21] = _zz_82_;
    _zz_83_[20] = _zz_82_;
    _zz_83_[19] = _zz_82_;
    _zz_83_[18] = _zz_82_;
    _zz_83_[17] = _zz_82_;
    _zz_83_[16] = _zz_82_;
    _zz_83_[15 : 0] = memory_DBusSimplePlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_164_)
      2'b00 : begin
        memory_DBusSimplePlugin_rspFormated = _zz_81_;
      end
      2'b01 : begin
        memory_DBusSimplePlugin_rspFormated = _zz_83_;
      end
      default : begin
        memory_DBusSimplePlugin_rspFormated = memory_DBusSimplePlugin_rspShifted;
      end
    endcase
  end

  always @ (*) begin
    CsrPlugin_privilege = (2'b11);
    if(CsrPlugin_forceMachineWire)begin
      CsrPlugin_privilege = (2'b11);
    end
  end

  assign CsrPlugin_misa_base = (2'b01);
  assign CsrPlugin_misa_extensions = 26'h0000042;
  assign CsrPlugin_mtvec_mode = (2'b00);
  assign CsrPlugin_mtvec_base = 30'h00000001;
  assign _zz_84_ = (CsrPlugin_mip_MTIP && CsrPlugin_mie_MTIE);
  assign _zz_85_ = (CsrPlugin_mip_MSIP && CsrPlugin_mie_MSIE);
  assign _zz_86_ = (CsrPlugin_mip_MEIP && CsrPlugin_mie_MEIE);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b11);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege = ((CsrPlugin_privilege < CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped) ? CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped : CsrPlugin_privilege);
  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_decode = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
    if(decodeExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_execute = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
    if(execute_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_memory = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
    if(DBusSimplePlugin_memoryExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
    if(writeBack_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = 1'b0;
    end
  end

  assign CsrPlugin_exceptionPendings_0 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  assign CsrPlugin_exceptionPendings_1 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  assign CsrPlugin_exceptionPendings_2 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  assign CsrPlugin_exceptionPendings_3 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  assign CsrPlugin_exception = (CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack && CsrPlugin_allowException);
  assign CsrPlugin_lastStageWasWfi = 1'b0;
  assign CsrPlugin_pipelineLiberator_active = ((CsrPlugin_interrupt_valid && CsrPlugin_allowInterrupts) && decode_arbitration_isValid);
  always @ (*) begin
    CsrPlugin_pipelineLiberator_done = CsrPlugin_pipelineLiberator_pcValids_2;
    if(({CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute}} != (3'b000)))begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
    if(CsrPlugin_hadException)begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
  end

  assign CsrPlugin_interruptJump = ((CsrPlugin_interrupt_valid && CsrPlugin_pipelineLiberator_done) && CsrPlugin_allowInterrupts);
  always @ (*) begin
    CsrPlugin_targetPrivilege = CsrPlugin_interrupt_targetPrivilege;
    if(CsrPlugin_hadException)begin
      CsrPlugin_targetPrivilege = CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
    end
  end

  always @ (*) begin
    CsrPlugin_trapCause = CsrPlugin_interrupt_code;
    if(CsrPlugin_hadException)begin
      CsrPlugin_trapCause = CsrPlugin_exceptionPortCtrl_exceptionContext_code;
    end
  end

  always @ (*) begin
    CsrPlugin_xtvec_mode = (2'bxx);
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_mode = CsrPlugin_mtvec_mode;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    CsrPlugin_xtvec_base = 30'h0;
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_base = CsrPlugin_mtvec_base;
      end
      default : begin
      end
    endcase
  end

  assign contextSwitching = CsrPlugin_jumpInterface_valid;
  assign execute_CsrPlugin_blockedBySideEffects = ({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00));
  always @ (*) begin
    execute_CsrPlugin_illegalAccess = 1'b1;
    if(execute_CsrPlugin_csr_768)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_836)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_772)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_834)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if((CsrPlugin_privilege < execute_CsrPlugin_csrAddress[9 : 8]))begin
      execute_CsrPlugin_illegalAccess = 1'b1;
    end
    if(((! execute_arbitration_isValid) || (! execute_IS_CSR)))begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
  end

  always @ (*) begin
    execute_CsrPlugin_illegalInstruction = 1'b0;
    if((execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)))begin
      if((CsrPlugin_privilege < execute_INSTRUCTION[29 : 28]))begin
        execute_CsrPlugin_illegalInstruction = 1'b1;
      end
    end
  end

  assign execute_CsrPlugin_writeInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_WRITE_OPCODE);
  assign execute_CsrPlugin_readInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_READ_OPCODE);
  assign execute_CsrPlugin_writeEnable = ((execute_CsrPlugin_writeInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readEnable = ((execute_CsrPlugin_readInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readToWriteData = execute_CsrPlugin_readData;
  always @ (*) begin
    case(_zz_165_)
      1'b0 : begin
        execute_CsrPlugin_writeData = execute_SRC1;
      end
      default : begin
        execute_CsrPlugin_writeData = (execute_INSTRUCTION[12] ? (execute_CsrPlugin_readToWriteData & (~ execute_SRC1)) : (execute_CsrPlugin_readToWriteData | execute_SRC1));
      end
    endcase
  end

  assign execute_CsrPlugin_csrAddress = execute_INSTRUCTION[31 : 20];
  assign _zz_88_ = ((decode_INSTRUCTION & 32'h00000004) == 32'h00000004);
  assign _zz_89_ = ((decode_INSTRUCTION & 32'h00000050) == 32'h00000010);
  assign _zz_90_ = ((decode_INSTRUCTION & 32'h00000048) == 32'h00000048);
  assign _zz_91_ = ((decode_INSTRUCTION & 32'h00004050) == 32'h00004050);
  assign _zz_87_ = {({(_zz_250_ == _zz_251_),{_zz_252_,{_zz_253_,_zz_254_}}} != (4'b0000)),{({_zz_255_,_zz_256_} != (2'b00)),{(_zz_257_ != (1'b0)),{(_zz_258_ != _zz_259_),{_zz_260_,{_zz_261_,_zz_262_}}}}}};
  assign _zz_92_ = _zz_87_[4 : 3];
  assign _zz_42_ = _zz_92_;
  assign _zz_93_ = _zz_87_[7 : 6];
  assign _zz_41_ = _zz_93_;
  assign _zz_94_ = _zz_87_[11 : 10];
  assign _zz_40_ = _zz_94_;
  assign _zz_95_ = _zz_87_[13 : 13];
  assign _zz_39_ = _zz_95_;
  assign _zz_96_ = _zz_87_[15 : 14];
  assign _zz_38_ = _zz_96_;
  assign _zz_97_ = _zz_87_[18 : 17];
  assign _zz_37_ = _zz_97_;
  assign _zz_98_ = _zz_87_[22 : 21];
  assign _zz_36_ = _zz_98_;
  assign decodeExceptionPort_valid = (decode_arbitration_isValid && (! decode_LEGAL_INSTRUCTION));
  assign decodeExceptionPort_payload_code = (4'b0010);
  assign decodeExceptionPort_payload_badAddr = decode_INSTRUCTION;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION[24 : 20];
  assign decode_RegFilePlugin_rs1Data = _zz_142_;
  assign decode_RegFilePlugin_rs2Data = _zz_143_;
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_34_ && writeBack_arbitration_isFiring);
    if(_zz_99_)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  assign lastStageRegFileWrite_payload_address = _zz_33_[11 : 7];
  assign lastStageRegFileWrite_payload_data = _zz_32_;
  always @ (*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
    endcase
  end

  always @ (*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_BITWISE : begin
        _zz_100_ = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_100_ = {31'd0, _zz_201_};
      end
      default : begin
        _zz_100_ = execute_SRC_ADD_SUB;
      end
    endcase
  end

  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_101_ = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_101_ = {29'd0, _zz_202_};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_101_ = {execute_INSTRUCTION[31 : 12],12'h0};
      end
      default : begin
        _zz_101_ = {27'd0, _zz_203_};
      end
    endcase
  end

  assign _zz_102_ = _zz_204_[11];
  always @ (*) begin
    _zz_103_[19] = _zz_102_;
    _zz_103_[18] = _zz_102_;
    _zz_103_[17] = _zz_102_;
    _zz_103_[16] = _zz_102_;
    _zz_103_[15] = _zz_102_;
    _zz_103_[14] = _zz_102_;
    _zz_103_[13] = _zz_102_;
    _zz_103_[12] = _zz_102_;
    _zz_103_[11] = _zz_102_;
    _zz_103_[10] = _zz_102_;
    _zz_103_[9] = _zz_102_;
    _zz_103_[8] = _zz_102_;
    _zz_103_[7] = _zz_102_;
    _zz_103_[6] = _zz_102_;
    _zz_103_[5] = _zz_102_;
    _zz_103_[4] = _zz_102_;
    _zz_103_[3] = _zz_102_;
    _zz_103_[2] = _zz_102_;
    _zz_103_[1] = _zz_102_;
    _zz_103_[0] = _zz_102_;
  end

  assign _zz_104_ = _zz_205_[11];
  always @ (*) begin
    _zz_105_[19] = _zz_104_;
    _zz_105_[18] = _zz_104_;
    _zz_105_[17] = _zz_104_;
    _zz_105_[16] = _zz_104_;
    _zz_105_[15] = _zz_104_;
    _zz_105_[14] = _zz_104_;
    _zz_105_[13] = _zz_104_;
    _zz_105_[12] = _zz_104_;
    _zz_105_[11] = _zz_104_;
    _zz_105_[10] = _zz_104_;
    _zz_105_[9] = _zz_104_;
    _zz_105_[8] = _zz_104_;
    _zz_105_[7] = _zz_104_;
    _zz_105_[6] = _zz_104_;
    _zz_105_[5] = _zz_104_;
    _zz_105_[4] = _zz_104_;
    _zz_105_[3] = _zz_104_;
    _zz_105_[2] = _zz_104_;
    _zz_105_[1] = _zz_104_;
    _zz_105_[0] = _zz_104_;
  end

  always @ (*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_106_ = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_106_ = {_zz_103_,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_106_ = {_zz_105_,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_106_ = _zz_27_;
      end
    endcase
  end

  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_206_;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_107_[0] = execute_SRC1[31];
    _zz_107_[1] = execute_SRC1[30];
    _zz_107_[2] = execute_SRC1[29];
    _zz_107_[3] = execute_SRC1[28];
    _zz_107_[4] = execute_SRC1[27];
    _zz_107_[5] = execute_SRC1[26];
    _zz_107_[6] = execute_SRC1[25];
    _zz_107_[7] = execute_SRC1[24];
    _zz_107_[8] = execute_SRC1[23];
    _zz_107_[9] = execute_SRC1[22];
    _zz_107_[10] = execute_SRC1[21];
    _zz_107_[11] = execute_SRC1[20];
    _zz_107_[12] = execute_SRC1[19];
    _zz_107_[13] = execute_SRC1[18];
    _zz_107_[14] = execute_SRC1[17];
    _zz_107_[15] = execute_SRC1[16];
    _zz_107_[16] = execute_SRC1[15];
    _zz_107_[17] = execute_SRC1[14];
    _zz_107_[18] = execute_SRC1[13];
    _zz_107_[19] = execute_SRC1[12];
    _zz_107_[20] = execute_SRC1[11];
    _zz_107_[21] = execute_SRC1[10];
    _zz_107_[22] = execute_SRC1[9];
    _zz_107_[23] = execute_SRC1[8];
    _zz_107_[24] = execute_SRC1[7];
    _zz_107_[25] = execute_SRC1[6];
    _zz_107_[26] = execute_SRC1[5];
    _zz_107_[27] = execute_SRC1[4];
    _zz_107_[28] = execute_SRC1[3];
    _zz_107_[29] = execute_SRC1[2];
    _zz_107_[30] = execute_SRC1[1];
    _zz_107_[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_107_ : execute_SRC1);
  always @ (*) begin
    _zz_108_[0] = execute_SHIFT_RIGHT[31];
    _zz_108_[1] = execute_SHIFT_RIGHT[30];
    _zz_108_[2] = execute_SHIFT_RIGHT[29];
    _zz_108_[3] = execute_SHIFT_RIGHT[28];
    _zz_108_[4] = execute_SHIFT_RIGHT[27];
    _zz_108_[5] = execute_SHIFT_RIGHT[26];
    _zz_108_[6] = execute_SHIFT_RIGHT[25];
    _zz_108_[7] = execute_SHIFT_RIGHT[24];
    _zz_108_[8] = execute_SHIFT_RIGHT[23];
    _zz_108_[9] = execute_SHIFT_RIGHT[22];
    _zz_108_[10] = execute_SHIFT_RIGHT[21];
    _zz_108_[11] = execute_SHIFT_RIGHT[20];
    _zz_108_[12] = execute_SHIFT_RIGHT[19];
    _zz_108_[13] = execute_SHIFT_RIGHT[18];
    _zz_108_[14] = execute_SHIFT_RIGHT[17];
    _zz_108_[15] = execute_SHIFT_RIGHT[16];
    _zz_108_[16] = execute_SHIFT_RIGHT[15];
    _zz_108_[17] = execute_SHIFT_RIGHT[14];
    _zz_108_[18] = execute_SHIFT_RIGHT[13];
    _zz_108_[19] = execute_SHIFT_RIGHT[12];
    _zz_108_[20] = execute_SHIFT_RIGHT[11];
    _zz_108_[21] = execute_SHIFT_RIGHT[10];
    _zz_108_[22] = execute_SHIFT_RIGHT[9];
    _zz_108_[23] = execute_SHIFT_RIGHT[8];
    _zz_108_[24] = execute_SHIFT_RIGHT[7];
    _zz_108_[25] = execute_SHIFT_RIGHT[6];
    _zz_108_[26] = execute_SHIFT_RIGHT[5];
    _zz_108_[27] = execute_SHIFT_RIGHT[4];
    _zz_108_[28] = execute_SHIFT_RIGHT[3];
    _zz_108_[29] = execute_SHIFT_RIGHT[2];
    _zz_108_[30] = execute_SHIFT_RIGHT[1];
    _zz_108_[31] = execute_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    _zz_109_ = 1'b0;
    if(_zz_154_)begin
      if(_zz_155_)begin
        if(_zz_114_)begin
          _zz_109_ = 1'b1;
        end
      end
    end
    if(_zz_156_)begin
      if(_zz_157_)begin
        if(_zz_116_)begin
          _zz_109_ = 1'b1;
        end
      end
    end
    if(_zz_158_)begin
      if(_zz_159_)begin
        if(_zz_118_)begin
          _zz_109_ = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_109_ = 1'b0;
    end
  end

  always @ (*) begin
    _zz_110_ = 1'b0;
    if(_zz_154_)begin
      if(_zz_155_)begin
        if(_zz_115_)begin
          _zz_110_ = 1'b1;
        end
      end
    end
    if(_zz_156_)begin
      if(_zz_157_)begin
        if(_zz_117_)begin
          _zz_110_ = 1'b1;
        end
      end
    end
    if(_zz_158_)begin
      if(_zz_159_)begin
        if(_zz_119_)begin
          _zz_110_ = 1'b1;
        end
      end
    end
    if((! decode_RS2_USE))begin
      _zz_110_ = 1'b0;
    end
  end

  assign _zz_114_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_115_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_116_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_117_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_118_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_119_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_120_ = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_120_ == (3'b000))) begin
        _zz_121_ = execute_BranchPlugin_eq;
    end else if((_zz_120_ == (3'b001))) begin
        _zz_121_ = (! execute_BranchPlugin_eq);
    end else if((((_zz_120_ & (3'b101)) == (3'b101)))) begin
        _zz_121_ = (! execute_SRC_LESS);
    end else begin
        _zz_121_ = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_122_ = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_122_ = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_122_ = 1'b1;
      end
      default : begin
        _zz_122_ = _zz_121_;
      end
    endcase
  end

  assign _zz_123_ = _zz_213_[11];
  always @ (*) begin
    _zz_124_[19] = _zz_123_;
    _zz_124_[18] = _zz_123_;
    _zz_124_[17] = _zz_123_;
    _zz_124_[16] = _zz_123_;
    _zz_124_[15] = _zz_123_;
    _zz_124_[14] = _zz_123_;
    _zz_124_[13] = _zz_123_;
    _zz_124_[12] = _zz_123_;
    _zz_124_[11] = _zz_123_;
    _zz_124_[10] = _zz_123_;
    _zz_124_[9] = _zz_123_;
    _zz_124_[8] = _zz_123_;
    _zz_124_[7] = _zz_123_;
    _zz_124_[6] = _zz_123_;
    _zz_124_[5] = _zz_123_;
    _zz_124_[4] = _zz_123_;
    _zz_124_[3] = _zz_123_;
    _zz_124_[2] = _zz_123_;
    _zz_124_[1] = _zz_123_;
    _zz_124_[0] = _zz_123_;
  end

  assign _zz_125_ = _zz_214_[19];
  always @ (*) begin
    _zz_126_[10] = _zz_125_;
    _zz_126_[9] = _zz_125_;
    _zz_126_[8] = _zz_125_;
    _zz_126_[7] = _zz_125_;
    _zz_126_[6] = _zz_125_;
    _zz_126_[5] = _zz_125_;
    _zz_126_[4] = _zz_125_;
    _zz_126_[3] = _zz_125_;
    _zz_126_[2] = _zz_125_;
    _zz_126_[1] = _zz_125_;
    _zz_126_[0] = _zz_125_;
  end

  assign _zz_127_ = _zz_215_[11];
  always @ (*) begin
    _zz_128_[18] = _zz_127_;
    _zz_128_[17] = _zz_127_;
    _zz_128_[16] = _zz_127_;
    _zz_128_[15] = _zz_127_;
    _zz_128_[14] = _zz_127_;
    _zz_128_[13] = _zz_127_;
    _zz_128_[12] = _zz_127_;
    _zz_128_[11] = _zz_127_;
    _zz_128_[10] = _zz_127_;
    _zz_128_[9] = _zz_127_;
    _zz_128_[8] = _zz_127_;
    _zz_128_[7] = _zz_127_;
    _zz_128_[6] = _zz_127_;
    _zz_128_[5] = _zz_127_;
    _zz_128_[4] = _zz_127_;
    _zz_128_[3] = _zz_127_;
    _zz_128_[2] = _zz_127_;
    _zz_128_[1] = _zz_127_;
    _zz_128_[0] = _zz_127_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_129_ = (_zz_216_[1] ^ execute_RS1[1]);
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_129_ = _zz_217_[1];
      end
      default : begin
        _zz_129_ = _zz_218_[1];
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = (execute_BRANCH_COND_RESULT && _zz_129_);
  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src1 = execute_RS1;
      end
      default : begin
        execute_BranchPlugin_branch_src1 = execute_PC;
      end
    endcase
  end

  assign _zz_130_ = _zz_219_[11];
  always @ (*) begin
    _zz_131_[19] = _zz_130_;
    _zz_131_[18] = _zz_130_;
    _zz_131_[17] = _zz_130_;
    _zz_131_[16] = _zz_130_;
    _zz_131_[15] = _zz_130_;
    _zz_131_[14] = _zz_130_;
    _zz_131_[13] = _zz_130_;
    _zz_131_[12] = _zz_130_;
    _zz_131_[11] = _zz_130_;
    _zz_131_[10] = _zz_130_;
    _zz_131_[9] = _zz_130_;
    _zz_131_[8] = _zz_130_;
    _zz_131_[7] = _zz_130_;
    _zz_131_[6] = _zz_130_;
    _zz_131_[5] = _zz_130_;
    _zz_131_[4] = _zz_130_;
    _zz_131_[3] = _zz_130_;
    _zz_131_[2] = _zz_130_;
    _zz_131_[1] = _zz_130_;
    _zz_131_[0] = _zz_130_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_131_,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_133_,{{{_zz_347_,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_135_,{{{_zz_348_,_zz_349_},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_222_};
        end
      end
    endcase
  end

  assign _zz_132_ = _zz_220_[19];
  always @ (*) begin
    _zz_133_[10] = _zz_132_;
    _zz_133_[9] = _zz_132_;
    _zz_133_[8] = _zz_132_;
    _zz_133_[7] = _zz_132_;
    _zz_133_[6] = _zz_132_;
    _zz_133_[5] = _zz_132_;
    _zz_133_[4] = _zz_132_;
    _zz_133_[3] = _zz_132_;
    _zz_133_[2] = _zz_132_;
    _zz_133_[1] = _zz_132_;
    _zz_133_[0] = _zz_132_;
  end

  assign _zz_134_ = _zz_221_[11];
  always @ (*) begin
    _zz_135_[18] = _zz_134_;
    _zz_135_[17] = _zz_134_;
    _zz_135_[16] = _zz_134_;
    _zz_135_[15] = _zz_134_;
    _zz_135_[14] = _zz_134_;
    _zz_135_[13] = _zz_134_;
    _zz_135_[12] = _zz_134_;
    _zz_135_[11] = _zz_134_;
    _zz_135_[10] = _zz_134_;
    _zz_135_[9] = _zz_134_;
    _zz_135_[8] = _zz_134_;
    _zz_135_[7] = _zz_134_;
    _zz_135_[6] = _zz_134_;
    _zz_135_[5] = _zz_134_;
    _zz_135_[4] = _zz_134_;
    _zz_135_[3] = _zz_134_;
    _zz_135_[2] = _zz_134_;
    _zz_135_[1] = _zz_134_;
    _zz_135_[0] = _zz_134_;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign BranchPlugin_jumpInterface_valid = ((execute_arbitration_isValid && execute_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = execute_BRANCH_CALC;
  assign IBusSimplePlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  assign _zz_24_ = decode_SRC1_CTRL;
  assign _zz_22_ = _zz_41_;
  assign _zz_29_ = decode_to_execute_SRC1_CTRL;
  assign _zz_21_ = decode_ALU_BITWISE_CTRL;
  assign _zz_19_ = _zz_37_;
  assign _zz_31_ = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_18_ = decode_BRANCH_CTRL;
  assign _zz_48_ = _zz_40_;
  assign _zz_25_ = decode_to_execute_BRANCH_CTRL;
  assign _zz_16_ = decode_SRC2_CTRL;
  assign _zz_14_ = _zz_42_;
  assign _zz_28_ = decode_to_execute_SRC2_CTRL;
  assign _zz_13_ = decode_SHIFT_CTRL;
  assign _zz_11_ = _zz_36_;
  assign _zz_26_ = decode_to_execute_SHIFT_CTRL;
  assign _zz_10_ = decode_ALU_CTRL;
  assign _zz_8_ = _zz_38_;
  assign _zz_30_ = decode_to_execute_ALU_CTRL;
  assign _zz_7_ = decode_ENV_CTRL;
  assign _zz_4_ = execute_ENV_CTRL;
  assign _zz_2_ = memory_ENV_CTRL;
  assign _zz_5_ = _zz_39_;
  assign _zz_45_ = decode_to_execute_ENV_CTRL;
  assign _zz_44_ = execute_to_memory_ENV_CTRL;
  assign _zz_46_ = memory_to_writeBack_ENV_CTRL;
  assign decode_arbitration_isFlushed = (({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,execute_arbitration_flushNext}} != (3'b000)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,{execute_arbitration_flushIt,decode_arbitration_flushIt}}} != (4'b0000)));
  assign execute_arbitration_isFlushed = (({writeBack_arbitration_flushNext,memory_arbitration_flushNext} != (2'b00)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,execute_arbitration_flushIt}} != (3'b000)));
  assign memory_arbitration_isFlushed = ((writeBack_arbitration_flushNext != (1'b0)) || ({writeBack_arbitration_flushIt,memory_arbitration_flushIt} != (2'b00)));
  assign writeBack_arbitration_isFlushed = (1'b0 || (writeBack_arbitration_flushIt != (1'b0)));
  assign decode_arbitration_isStuckByOthers = (decode_arbitration_haltByOther || (((1'b0 || execute_arbitration_isStuck) || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign decode_arbitration_isStuck = (decode_arbitration_haltItself || decode_arbitration_isStuckByOthers);
  assign decode_arbitration_isMoving = ((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt));
  assign decode_arbitration_isFiring = ((decode_arbitration_isValid && (! decode_arbitration_isStuck)) && (! decode_arbitration_removeIt));
  assign execute_arbitration_isStuckByOthers = (execute_arbitration_haltByOther || ((1'b0 || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign execute_arbitration_isStuck = (execute_arbitration_haltItself || execute_arbitration_isStuckByOthers);
  assign execute_arbitration_isMoving = ((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt));
  assign execute_arbitration_isFiring = ((execute_arbitration_isValid && (! execute_arbitration_isStuck)) && (! execute_arbitration_removeIt));
  assign memory_arbitration_isStuckByOthers = (memory_arbitration_haltByOther || (1'b0 || writeBack_arbitration_isStuck));
  assign memory_arbitration_isStuck = (memory_arbitration_haltItself || memory_arbitration_isStuckByOthers);
  assign memory_arbitration_isMoving = ((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt));
  assign memory_arbitration_isFiring = ((memory_arbitration_isValid && (! memory_arbitration_isStuck)) && (! memory_arbitration_removeIt));
  assign writeBack_arbitration_isStuckByOthers = (writeBack_arbitration_haltByOther || 1'b0);
  assign writeBack_arbitration_isStuck = (writeBack_arbitration_haltItself || writeBack_arbitration_isStuckByOthers);
  assign writeBack_arbitration_isMoving = ((! writeBack_arbitration_isStuck) && (! writeBack_arbitration_removeIt));
  assign writeBack_arbitration_isFiring = ((writeBack_arbitration_isValid && (! writeBack_arbitration_isStuck)) && (! writeBack_arbitration_removeIt));
  always @ (*) begin
    _zz_136_ = 32'h0;
    if(execute_CsrPlugin_csr_768)begin
      _zz_136_[12 : 11] = CsrPlugin_mstatus_MPP;
      _zz_136_[7 : 7] = CsrPlugin_mstatus_MPIE;
      _zz_136_[3 : 3] = CsrPlugin_mstatus_MIE;
    end
  end

  always @ (*) begin
    _zz_137_ = 32'h0;
    if(execute_CsrPlugin_csr_836)begin
      _zz_137_[11 : 11] = CsrPlugin_mip_MEIP;
      _zz_137_[7 : 7] = CsrPlugin_mip_MTIP;
      _zz_137_[3 : 3] = CsrPlugin_mip_MSIP;
    end
  end

  always @ (*) begin
    _zz_138_ = 32'h0;
    if(execute_CsrPlugin_csr_772)begin
      _zz_138_[11 : 11] = CsrPlugin_mie_MEIE;
      _zz_138_[7 : 7] = CsrPlugin_mie_MTIE;
      _zz_138_[3 : 3] = CsrPlugin_mie_MSIE;
    end
  end

  always @ (*) begin
    _zz_139_ = 32'h0;
    if(execute_CsrPlugin_csr_834)begin
      _zz_139_[31 : 31] = CsrPlugin_mcause_interrupt;
      _zz_139_[3 : 0] = CsrPlugin_mcause_exceptionCode;
    end
  end

  assign execute_CsrPlugin_readData = ((_zz_136_ | _zz_137_) | (_zz_138_ | _zz_139_));
  assign _zz_141_ = 1'b0;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      IBusSimplePlugin_fetchPc_pcReg <= 32'h0;
      IBusSimplePlugin_fetchPc_correctionReg <= 1'b0;
      IBusSimplePlugin_fetchPc_booted <= 1'b0;
      IBusSimplePlugin_fetchPc_inc <= 1'b0;
      _zz_59_ <= 1'b0;
      _zz_60_ <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusSimplePlugin_pending_value <= (3'b000);
      IBusSimplePlugin_rspJoin_rspBuffer_discardCounter <= (3'b000);
      CsrPlugin_mstatus_MIE <= 1'b0;
      CsrPlugin_mstatus_MPIE <= 1'b0;
      CsrPlugin_mstatus_MPP <= (2'b11);
      CsrPlugin_mie_MEIE <= 1'b0;
      CsrPlugin_mie_MTIE <= 1'b0;
      CsrPlugin_mie_MSIE <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      CsrPlugin_interrupt_valid <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_0 <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_1 <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_2 <= 1'b0;
      CsrPlugin_hadException <= 1'b0;
      execute_CsrPlugin_wfiWake <= 1'b0;
      _zz_99_ <= 1'b1;
      _zz_111_ <= 1'b0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      memory_to_writeBack_REGFILE_WRITE_DATA <= 32'h0;
      memory_to_writeBack_INSTRUCTION <= 32'h0;
    end else begin
      if(IBusSimplePlugin_fetchPc_correction)begin
        IBusSimplePlugin_fetchPc_correctionReg <= 1'b1;
      end
      if((IBusSimplePlugin_fetchPc_output_valid && IBusSimplePlugin_fetchPc_output_ready))begin
        IBusSimplePlugin_fetchPc_correctionReg <= 1'b0;
      end
      IBusSimplePlugin_fetchPc_booted <= 1'b1;
      if((IBusSimplePlugin_fetchPc_correction || IBusSimplePlugin_fetchPc_pcRegPropagate))begin
        IBusSimplePlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusSimplePlugin_fetchPc_output_valid && IBusSimplePlugin_fetchPc_output_ready))begin
        IBusSimplePlugin_fetchPc_inc <= 1'b1;
      end
      if(((! IBusSimplePlugin_fetchPc_output_valid) && IBusSimplePlugin_fetchPc_output_ready))begin
        IBusSimplePlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusSimplePlugin_fetchPc_booted && ((IBusSimplePlugin_fetchPc_output_ready || IBusSimplePlugin_fetchPc_correction) || IBusSimplePlugin_fetchPc_pcRegPropagate)))begin
        IBusSimplePlugin_fetchPc_pcReg <= IBusSimplePlugin_fetchPc_pc;
      end
      if(IBusSimplePlugin_iBusRsp_flush)begin
        _zz_59_ <= 1'b0;
      end
      if(_zz_57_)begin
        _zz_59_ <= (IBusSimplePlugin_iBusRsp_stages_0_output_valid && (! 1'b0));
      end
      if(decode_arbitration_removeIt)begin
        _zz_60_ <= 1'b0;
      end
      if(IBusSimplePlugin_iBusRsp_output_ready)begin
        _zz_60_ <= (IBusSimplePlugin_iBusRsp_output_valid && (! IBusSimplePlugin_externalFlush));
      end
      if(IBusSimplePlugin_fetchPc_flushed)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if((! (! IBusSimplePlugin_iBusRsp_stages_1_input_ready)))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if(IBusSimplePlugin_fetchPc_flushed)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if((! (! IBusSimplePlugin_injector_decodeInput_ready)))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= IBusSimplePlugin_injector_nextPcCalc_valids_0;
      end
      if(IBusSimplePlugin_fetchPc_flushed)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if(IBusSimplePlugin_fetchPc_flushed)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if((! execute_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= IBusSimplePlugin_injector_nextPcCalc_valids_1;
      end
      if(IBusSimplePlugin_fetchPc_flushed)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if(IBusSimplePlugin_fetchPc_flushed)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= IBusSimplePlugin_injector_nextPcCalc_valids_2;
      end
      if(IBusSimplePlugin_fetchPc_flushed)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(IBusSimplePlugin_fetchPc_flushed)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if((! writeBack_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= IBusSimplePlugin_injector_nextPcCalc_valids_3;
      end
      if(IBusSimplePlugin_fetchPc_flushed)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      IBusSimplePlugin_pending_value <= IBusSimplePlugin_pending_next;
      IBusSimplePlugin_rspJoin_rspBuffer_discardCounter <= (IBusSimplePlugin_rspJoin_rspBuffer_discardCounter - _zz_197_);
      if(IBusSimplePlugin_iBusRsp_flush)begin
        IBusSimplePlugin_rspJoin_rspBuffer_discardCounter <= (IBusSimplePlugin_pending_value - _zz_199_);
      end
      if((! decode_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
      end
      if((! execute_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= (CsrPlugin_exceptionPortCtrl_exceptionValids_decode && (! decode_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
      end
      if((! memory_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= (CsrPlugin_exceptionPortCtrl_exceptionValids_execute && (! execute_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
      end
      if((! writeBack_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= (CsrPlugin_exceptionPortCtrl_exceptionValids_memory && (! memory_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      end
      CsrPlugin_interrupt_valid <= 1'b0;
      if(_zz_160_)begin
        if(_zz_161_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_162_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_163_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
      end
      if(CsrPlugin_pipelineLiberator_active)begin
        if((! execute_arbitration_isStuck))begin
          CsrPlugin_pipelineLiberator_pcValids_0 <= 1'b1;
        end
        if((! memory_arbitration_isStuck))begin
          CsrPlugin_pipelineLiberator_pcValids_1 <= CsrPlugin_pipelineLiberator_pcValids_0;
        end
        if((! writeBack_arbitration_isStuck))begin
          CsrPlugin_pipelineLiberator_pcValids_2 <= CsrPlugin_pipelineLiberator_pcValids_1;
        end
      end
      if(((! CsrPlugin_pipelineLiberator_active) || decode_arbitration_removeIt))begin
        CsrPlugin_pipelineLiberator_pcValids_0 <= 1'b0;
        CsrPlugin_pipelineLiberator_pcValids_1 <= 1'b0;
        CsrPlugin_pipelineLiberator_pcValids_2 <= 1'b0;
      end
      if(CsrPlugin_interruptJump)begin
        CsrPlugin_interrupt_valid <= 1'b0;
      end
      CsrPlugin_hadException <= CsrPlugin_exception;
      if(_zz_150_)begin
        case(CsrPlugin_targetPrivilege)
          2'b11 : begin
            CsrPlugin_mstatus_MIE <= 1'b0;
            CsrPlugin_mstatus_MPIE <= CsrPlugin_mstatus_MIE;
            CsrPlugin_mstatus_MPP <= CsrPlugin_privilege;
          end
          default : begin
          end
        endcase
      end
      if(_zz_151_)begin
        case(_zz_152_)
          2'b11 : begin
            CsrPlugin_mstatus_MPP <= (2'b00);
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= 1'b1;
          end
          default : begin
          end
        endcase
      end
      execute_CsrPlugin_wfiWake <= (({_zz_86_,{_zz_85_,_zz_84_}} != (3'b000)) || CsrPlugin_thirdPartyWake);
      _zz_99_ <= 1'b0;
      _zz_111_ <= (_zz_34_ && writeBack_arbitration_isFiring);
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_47_;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
      end
      if(((! execute_arbitration_isStuck) || execute_arbitration_removeIt))begin
        execute_arbitration_isValid <= 1'b0;
      end
      if(((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt)))begin
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end
      if(((! memory_arbitration_isStuck) || memory_arbitration_removeIt))begin
        memory_arbitration_isValid <= 1'b0;
      end
      if(((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt)))begin
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end
      if(((! writeBack_arbitration_isStuck) || writeBack_arbitration_removeIt))begin
        writeBack_arbitration_isValid <= 1'b0;
      end
      if(((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt)))begin
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end
      if(execute_CsrPlugin_csr_768)begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mstatus_MPP <= execute_CsrPlugin_writeData[12 : 11];
          CsrPlugin_mstatus_MPIE <= _zz_223_[0];
          CsrPlugin_mstatus_MIE <= _zz_224_[0];
        end
      end
      if(execute_CsrPlugin_csr_772)begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mie_MEIE <= _zz_226_[0];
          CsrPlugin_mie_MTIE <= _zz_227_[0];
          CsrPlugin_mie_MSIE <= _zz_228_[0];
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(IBusSimplePlugin_iBusRsp_output_ready)begin
      _zz_61_ <= IBusSimplePlugin_iBusRsp_output_payload_pc;
      _zz_62_ <= IBusSimplePlugin_iBusRsp_output_payload_rsp_error;
      _zz_63_ <= IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
      _zz_64_ <= IBusSimplePlugin_iBusRsp_output_payload_isRvc;
    end
    if(IBusSimplePlugin_injector_decodeInput_ready)begin
      IBusSimplePlugin_injector_formal_rawInDecode <= IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
    end
    `ifndef SYNTHESIS
      `ifdef FORMAL
        assert((! (((dBus_rsp_ready && memory_MEMORY_ENABLE) && memory_arbitration_isValid) && memory_arbitration_isStuck)))
      `else
        if(!(! (((dBus_rsp_ready && memory_MEMORY_ENABLE) && memory_arbitration_isValid) && memory_arbitration_isStuck))) begin
          $display("FAILURE DBusSimplePlugin doesn't allow memory stage stall when read happend");
          $finish;
        end
      `endif
    `endif
    CsrPlugin_mip_MEIP <= externalInterrupt;
    CsrPlugin_mip_MTIP <= timerInterrupt;
    CsrPlugin_mip_MSIP <= softwareInterrupt;
    CsrPlugin_mcycle <= (CsrPlugin_mcycle + 64'h0000000000000001);
    if(writeBack_arbitration_isFiring)begin
      CsrPlugin_minstret <= (CsrPlugin_minstret + 64'h0000000000000001);
    end
    if(decodeExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= decodeExceptionPort_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= decodeExceptionPort_payload_badAddr;
    end
    if(DBusSimplePlugin_memoryExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= DBusSimplePlugin_memoryExceptionPort_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= DBusSimplePlugin_memoryExceptionPort_payload_badAddr;
    end
    if(_zz_160_)begin
      if(_zz_161_)begin
        CsrPlugin_interrupt_code <= (4'b0111);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_162_)begin
        CsrPlugin_interrupt_code <= (4'b0011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_163_)begin
        CsrPlugin_interrupt_code <= (4'b1011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
    end
    if(_zz_150_)begin
      case(CsrPlugin_targetPrivilege)
        2'b11 : begin
          CsrPlugin_mcause_interrupt <= (! CsrPlugin_hadException);
          CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
          CsrPlugin_mepc <= writeBack_PC;
          if(CsrPlugin_hadException)begin
            CsrPlugin_mtval <= CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
          end
        end
        default : begin
        end
      endcase
    end
    _zz_112_ <= _zz_33_[11 : 7];
    _zz_113_ <= _zz_32_;
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_23_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= _zz_50_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= _zz_49_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= memory_FORMAL_PC_NEXT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= decode_PC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= _zz_27_;
    end
    if(((! writeBack_arbitration_isStuck) && (! CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack)))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_43_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_20_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_17_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= decode_RS2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_15_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_STORE <= decode_MEMORY_STORE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_STORE <= execute_MEMORY_STORE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_12_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CSR <= decode_IS_CSR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ALIGNEMENT_FAULT <= execute_ALIGNEMENT_FAULT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_9_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ENV_CTRL <= _zz_6_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ENV_CTRL <= _zz_3_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_ENV_CTRL <= _zz_1_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_768 <= (decode_INSTRUCTION[31 : 20] == 12'h300);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_836 <= (decode_INSTRUCTION[31 : 20] == 12'h344);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_772 <= (decode_INSTRUCTION[31 : 20] == 12'h304);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_834 <= (decode_INSTRUCTION[31 : 20] == 12'h342);
    end
    if(execute_CsrPlugin_csr_836)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mip_MSIP <= _zz_225_[0];
      end
    end
  end


endmodule
