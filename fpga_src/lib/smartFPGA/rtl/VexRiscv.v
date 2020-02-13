// Generator : SpinalHDL v1.3.6    git head : 9bf01e7f360e003fac1dd5ca8b8f4bffec0e52b8
// Date      : 13/02/2020, 02:15:11
// Component : VexRiscv


`define Src2CtrlEnum_defaultEncoding_type [1:0]
`define Src2CtrlEnum_defaultEncoding_RS 2'b00
`define Src2CtrlEnum_defaultEncoding_IMI 2'b01
`define Src2CtrlEnum_defaultEncoding_IMS 2'b10
`define Src2CtrlEnum_defaultEncoding_PC 2'b11

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10

`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11

`define EnvCtrlEnum_defaultEncoding_type [0:0]
`define EnvCtrlEnum_defaultEncoding_NONE 1'b0
`define EnvCtrlEnum_defaultEncoding_XRET 1'b1

`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11

`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

module StreamFifoLowLatency (
      input   io_push_valid,
      output  io_push_ready,
      input   io_push_payload_error,
      input  [31:0] io_push_payload_inst,
      output reg  io_pop_valid,
      input   io_pop_ready,
      output reg  io_pop_payload_error,
      output reg [31:0] io_pop_payload_inst,
      input   io_flush,
      output [0:0] io_occupancy,
      input   clk,
      input   reset);
  wire  _zz_5_;
  wire [0:0] _zz_6_;
  reg  _zz_1_;
  reg  pushPtr_willIncrement;
  reg  pushPtr_willClear;
  wire  pushPtr_willOverflowIfInc;
  wire  pushPtr_willOverflow;
  reg  popPtr_willIncrement;
  reg  popPtr_willClear;
  wire  popPtr_willOverflowIfInc;
  wire  popPtr_willOverflow;
  wire  ptrMatch;
  reg  risingOccupancy;
  wire  empty;
  wire  full;
  wire  pushing;
  wire  popping;
  wire [32:0] _zz_2_;
  wire [32:0] _zz_3_;
  reg [32:0] _zz_4_;
  assign _zz_5_ = (! empty);
  assign _zz_6_ = _zz_2_[0 : 0];
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
    if(_zz_5_)begin
      io_pop_valid = 1'b1;
    end else begin
      io_pop_valid = io_push_valid;
    end
  end

  assign _zz_2_ = _zz_3_;
  always @ (*) begin
    if(_zz_5_)begin
      io_pop_payload_error = _zz_6_[0];
    end else begin
      io_pop_payload_error = io_push_payload_error;
    end
  end

  always @ (*) begin
    if(_zz_5_)begin
      io_pop_payload_inst = _zz_2_[32 : 1];
    end else begin
      io_pop_payload_inst = io_push_payload_inst;
    end
  end

  assign io_occupancy = (risingOccupancy && ptrMatch);
  assign _zz_3_ = _zz_4_;
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
      _zz_4_ <= {io_push_payload_inst,io_push_payload_error};
    end
  end

endmodule

module VexRiscv (
      output  iBus_cmd_valid,
      input   iBus_cmd_ready,
      output [31:0] iBus_cmd_payload_pc,
      input   iBus_rsp_valid,
      input   iBus_rsp_payload_error,
      input  [31:0] iBus_rsp_payload_inst,
      input   timerInterrupt,
      input   externalInterrupt,
      input   softwareInterrupt,
      output  dBus_cmd_valid,
      input   dBus_cmd_ready,
      output  dBus_cmd_payload_wr,
      output [31:0] dBus_cmd_payload_address,
      output [31:0] dBus_cmd_payload_data,
      output [1:0] dBus_cmd_payload_size,
      input   dBus_rsp_ready,
      input   dBus_rsp_error,
      input  [31:0] dBus_rsp_data,
      input   clk,
      input   reset);
  wire [31:0] _zz_185_;
  wire [31:0] _zz_186_;
  wire  IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready;
  wire  IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid;
  wire  IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error;
  wire [31:0] IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst;
  wire [0:0] IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy;
  wire  _zz_187_;
  wire  _zz_188_;
  wire  _zz_189_;
  wire  _zz_190_;
  wire  _zz_191_;
  wire  _zz_192_;
  wire  _zz_193_;
  wire [1:0] _zz_194_;
  wire  _zz_195_;
  wire  _zz_196_;
  wire  _zz_197_;
  wire  _zz_198_;
  wire  _zz_199_;
  wire  _zz_200_;
  wire  _zz_201_;
  wire  _zz_202_;
  wire  _zz_203_;
  wire  _zz_204_;
  wire  _zz_205_;
  wire [1:0] _zz_206_;
  wire  _zz_207_;
  wire [31:0] _zz_208_;
  wire [1:0] _zz_209_;
  wire [1:0] _zz_210_;
  wire [2:0] _zz_211_;
  wire [31:0] _zz_212_;
  wire [2:0] _zz_213_;
  wire [0:0] _zz_214_;
  wire [2:0] _zz_215_;
  wire [0:0] _zz_216_;
  wire [2:0] _zz_217_;
  wire [0:0] _zz_218_;
  wire [2:0] _zz_219_;
  wire [0:0] _zz_220_;
  wire [2:0] _zz_221_;
  wire [2:0] _zz_222_;
  wire [0:0] _zz_223_;
  wire [0:0] _zz_224_;
  wire [0:0] _zz_225_;
  wire [0:0] _zz_226_;
  wire [0:0] _zz_227_;
  wire [0:0] _zz_228_;
  wire [0:0] _zz_229_;
  wire [0:0] _zz_230_;
  wire [0:0] _zz_231_;
  wire [0:0] _zz_232_;
  wire [0:0] _zz_233_;
  wire [0:0] _zz_234_;
  wire [0:0] _zz_235_;
  wire [0:0] _zz_236_;
  wire [0:0] _zz_237_;
  wire [2:0] _zz_238_;
  wire [4:0] _zz_239_;
  wire [11:0] _zz_240_;
  wire [11:0] _zz_241_;
  wire [31:0] _zz_242_;
  wire [31:0] _zz_243_;
  wire [31:0] _zz_244_;
  wire [31:0] _zz_245_;
  wire [31:0] _zz_246_;
  wire [31:0] _zz_247_;
  wire [31:0] _zz_248_;
  wire [32:0] _zz_249_;
  wire [31:0] _zz_250_;
  wire [32:0] _zz_251_;
  wire [19:0] _zz_252_;
  wire [11:0] _zz_253_;
  wire [11:0] _zz_254_;
  wire [0:0] _zz_255_;
  wire [0:0] _zz_256_;
  wire [0:0] _zz_257_;
  wire [0:0] _zz_258_;
  wire [0:0] _zz_259_;
  wire [0:0] _zz_260_;
  wire [31:0] _zz_261_;
  wire [31:0] _zz_262_;
  wire  _zz_263_;
  wire [3:0] _zz_264_;
  wire [3:0] _zz_265_;
  wire  _zz_266_;
  wire [0:0] _zz_267_;
  wire [21:0] _zz_268_;
  wire [31:0] _zz_269_;
  wire [31:0] _zz_270_;
  wire  _zz_271_;
  wire [0:0] _zz_272_;
  wire [0:0] _zz_273_;
  wire [31:0] _zz_274_;
  wire [31:0] _zz_275_;
  wire [0:0] _zz_276_;
  wire [0:0] _zz_277_;
  wire [1:0] _zz_278_;
  wire [1:0] _zz_279_;
  wire  _zz_280_;
  wire [0:0] _zz_281_;
  wire [18:0] _zz_282_;
  wire [31:0] _zz_283_;
  wire [31:0] _zz_284_;
  wire [31:0] _zz_285_;
  wire [31:0] _zz_286_;
  wire [31:0] _zz_287_;
  wire [31:0] _zz_288_;
  wire [31:0] _zz_289_;
  wire  _zz_290_;
  wire [0:0] _zz_291_;
  wire [0:0] _zz_292_;
  wire  _zz_293_;
  wire [0:0] _zz_294_;
  wire [15:0] _zz_295_;
  wire [31:0] _zz_296_;
  wire [31:0] _zz_297_;
  wire [31:0] _zz_298_;
  wire [31:0] _zz_299_;
  wire [31:0] _zz_300_;
  wire [31:0] _zz_301_;
  wire [0:0] _zz_302_;
  wire [1:0] _zz_303_;
  wire [1:0] _zz_304_;
  wire [1:0] _zz_305_;
  wire  _zz_306_;
  wire [0:0] _zz_307_;
  wire [11:0] _zz_308_;
  wire [31:0] _zz_309_;
  wire [31:0] _zz_310_;
  wire [31:0] _zz_311_;
  wire [31:0] _zz_312_;
  wire [31:0] _zz_313_;
  wire [31:0] _zz_314_;
  wire [31:0] _zz_315_;
  wire [31:0] _zz_316_;
  wire [31:0] _zz_317_;
  wire  _zz_318_;
  wire [0:0] _zz_319_;
  wire [0:0] _zz_320_;
  wire  _zz_321_;
  wire [0:0] _zz_322_;
  wire [0:0] _zz_323_;
  wire  _zz_324_;
  wire [0:0] _zz_325_;
  wire [8:0] _zz_326_;
  wire [31:0] _zz_327_;
  wire [31:0] _zz_328_;
  wire [31:0] _zz_329_;
  wire [31:0] _zz_330_;
  wire [31:0] _zz_331_;
  wire [0:0] _zz_332_;
  wire [0:0] _zz_333_;
  wire [0:0] _zz_334_;
  wire [0:0] _zz_335_;
  wire  _zz_336_;
  wire [0:0] _zz_337_;
  wire [5:0] _zz_338_;
  wire [31:0] _zz_339_;
  wire [31:0] _zz_340_;
  wire [31:0] _zz_341_;
  wire [31:0] _zz_342_;
  wire [31:0] _zz_343_;
  wire  _zz_344_;
  wire [5:0] _zz_345_;
  wire [5:0] _zz_346_;
  wire  _zz_347_;
  wire [0:0] _zz_348_;
  wire [2:0] _zz_349_;
  wire [31:0] _zz_350_;
  wire [31:0] _zz_351_;
  wire  _zz_352_;
  wire [0:0] _zz_353_;
  wire [1:0] _zz_354_;
  wire [31:0] _zz_355_;
  wire [31:0] _zz_356_;
  wire [31:0] _zz_357_;
  wire [31:0] _zz_358_;
  wire [31:0] _zz_359_;
  wire [31:0] _zz_360_;
  wire [0:0] _zz_361_;
  wire [0:0] _zz_362_;
  wire [0:0] _zz_363_;
  wire [0:0] _zz_364_;
  wire [0:0] _zz_365_;
  wire [0:0] _zz_366_;
  wire [31:0] _zz_367_;
  wire [31:0] _zz_368_;
  wire [31:0] _zz_369_;
  wire  _zz_370_;
  wire [0:0] _zz_371_;
  wire [12:0] _zz_372_;
  wire [31:0] _zz_373_;
  wire [31:0] _zz_374_;
  wire [31:0] _zz_375_;
  wire  _zz_376_;
  wire [0:0] _zz_377_;
  wire [6:0] _zz_378_;
  wire [31:0] _zz_379_;
  wire [31:0] _zz_380_;
  wire [31:0] _zz_381_;
  wire  _zz_382_;
  wire [0:0] _zz_383_;
  wire [0:0] _zz_384_;
  wire [31:0] memory_PC;
  wire  decode_IS_BSWAP_32;
  wire `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_1_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_2_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_3_;
  wire  decode_IS_BSWAP_16;
  wire  decode_IS_CSR;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_4_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_5_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_6_;
  wire  execute_BYPASSABLE_MEMORY_STAGE;
  wire  decode_BYPASSABLE_MEMORY_STAGE;
  wire [31:0] writeBack_FORMAL_PC_NEXT;
  wire [31:0] memory_FORMAL_PC_NEXT;
  wire [31:0] execute_FORMAL_PC_NEXT;
  wire [31:0] decode_FORMAL_PC_NEXT;
  wire `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_7_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_8_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_9_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_10_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_11_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_12_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_13_;
  wire `EnvCtrlEnum_defaultEncoding_type decode_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_14_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_15_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_16_;
  wire [1:0] execute_MEMORY_ADDRESS_LOW;
  wire  decode_SRC2_FORCE_ZERO;
  wire [31:0] writeBack_REGFILE_WRITE_DATA;
  wire [31:0] execute_REGFILE_WRITE_DATA;
  wire `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_17_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_18_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_19_;
  wire  decode_MEMORY_ENABLE;
  wire  decode_CSR_READ_OPCODE;
  wire  decode_IS_TAIL_ZERO;
  wire  decode_SRC_LESS_UNSIGNED;
  wire  decode_MEMORY_STORE;
  wire `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_20_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_21_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_22_;
  wire  decode_CSR_WRITE_OPCODE;
  wire `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_23_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_24_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_25_;
  wire  decode_BYPASSABLE_EXECUTE_STAGE;
  wire [31:0] execute_BRANCH_CALC;
  wire  execute_BRANCH_DO;
  wire [31:0] _zz_26_;
  wire [31:0] execute_PC;
  wire `BranchCtrlEnum_defaultEncoding_type execute_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_27_;
  wire  _zz_28_;
  wire  decode_RS2_USE;
  wire  decode_RS1_USE;
  wire  execute_REGFILE_WRITE_VALID;
  wire  execute_BYPASSABLE_EXECUTE_STAGE;
  wire  memory_REGFILE_WRITE_VALID;
  wire  memory_BYPASSABLE_MEMORY_STAGE;
  wire  writeBack_REGFILE_WRITE_VALID;
  reg [31:0] decode_RS2;
  reg [31:0] decode_RS1;
  wire [31:0] execute_SHIFT_RIGHT;
  wire [31:0] _zz_29_;
  wire `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_30_;
  wire  _zz_31_;
  wire [31:0] _zz_32_;
  wire [31:0] _zz_33_;
  wire  execute_SRC_LESS_UNSIGNED;
  wire  execute_SRC2_FORCE_ZERO;
  wire  execute_SRC_USE_SUB_LESS;
  wire [31:0] _zz_34_;
  wire `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_35_;
  wire [31:0] _zz_36_;
  wire `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_37_;
  wire [31:0] _zz_38_;
  wire  decode_SRC_USE_SUB_LESS;
  wire  decode_SRC_ADD_ZERO;
  wire  _zz_39_;
  wire [31:0] execute_SRC_ADD_SUB;
  wire  execute_SRC_LESS;
  wire `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_40_;
  wire [31:0] _zz_41_;
  wire [31:0] execute_SRC2;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_42_;
  wire [31:0] _zz_43_;
  wire [31:0] _zz_44_;
  wire  _zz_45_;
  reg  _zz_46_;
  wire [31:0] _zz_47_;
  wire [31:0] _zz_48_;
  reg  decode_REGFILE_WRITE_VALID;
  wire  decode_LEGAL_INSTRUCTION;
  wire  decode_INSTRUCTION_READY;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_49_;
  wire  _zz_50_;
  wire  _zz_51_;
  wire  _zz_52_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_53_;
  wire  _zz_54_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_55_;
  wire  _zz_56_;
  wire  _zz_57_;
  wire  _zz_58_;
  wire  _zz_59_;
  wire  _zz_60_;
  wire  _zz_61_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_62_;
  wire  _zz_63_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_64_;
  wire  _zz_65_;
  wire  _zz_66_;
  wire  _zz_67_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_68_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_69_;
  wire  _zz_70_;
  wire [31:0] execute_SRC1;
  wire  execute_CSR_READ_OPCODE;
  wire  execute_CSR_WRITE_OPCODE;
  wire  execute_IS_CSR;
  wire `EnvCtrlEnum_defaultEncoding_type memory_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_71_;
  wire `EnvCtrlEnum_defaultEncoding_type execute_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_72_;
  wire  _zz_73_;
  wire  _zz_74_;
  wire `EnvCtrlEnum_defaultEncoding_type writeBack_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_75_;
  reg [31:0] _zz_76_;
  wire [31:0] memory_INSTRUCTION;
  wire [1:0] memory_MEMORY_ADDRESS_LOW;
  wire [31:0] memory_MEMORY_READ_DATA;
  wire  memory_ALIGNEMENT_FAULT;
  wire [31:0] memory_REGFILE_WRITE_DATA;
  wire  memory_MEMORY_STORE;
  wire  memory_MEMORY_ENABLE;
  wire [31:0] _zz_77_;
  wire [31:0] execute_SRC_ADD;
  wire [1:0] _zz_78_;
  wire [31:0] execute_RS2;
  wire [31:0] execute_INSTRUCTION;
  wire  execute_MEMORY_STORE;
  wire  execute_MEMORY_ENABLE;
  wire  execute_ALIGNEMENT_FAULT;
  wire  _zz_79_;
  reg [31:0] _zz_80_;
  wire [31:0] decode_PC;
  wire [31:0] _zz_81_;
  wire [31:0] _zz_82_;
  wire [31:0] _zz_83_;
  wire [31:0] decode_INSTRUCTION;
  wire  execute_IS_TAIL_ZERO;
  wire  execute_IS_BSWAP_16;
  reg [31:0] _zz_84_;
  wire  execute_IS_BSWAP_32;
  wire [31:0] execute_RS1;
  wire [31:0] writeBack_PC;
  wire [31:0] writeBack_INSTRUCTION;
  wire  decode_arbitration_haltItself;
  reg  decode_arbitration_haltByOther;
  reg  decode_arbitration_removeIt;
  wire  decode_arbitration_flushIt;
  reg  decode_arbitration_flushNext;
  wire  decode_arbitration_isValid;
  wire  decode_arbitration_isStuck;
  wire  decode_arbitration_isStuckByOthers;
  wire  decode_arbitration_isFlushed;
  wire  decode_arbitration_isMoving;
  wire  decode_arbitration_isFiring;
  reg  execute_arbitration_haltItself;
  wire  execute_arbitration_haltByOther;
  reg  execute_arbitration_removeIt;
  wire  execute_arbitration_flushIt;
  reg  execute_arbitration_flushNext;
  reg  execute_arbitration_isValid;
  wire  execute_arbitration_isStuck;
  wire  execute_arbitration_isStuckByOthers;
  wire  execute_arbitration_isFlushed;
  wire  execute_arbitration_isMoving;
  wire  execute_arbitration_isFiring;
  reg  memory_arbitration_haltItself;
  wire  memory_arbitration_haltByOther;
  reg  memory_arbitration_removeIt;
  wire  memory_arbitration_flushIt;
  reg  memory_arbitration_flushNext;
  reg  memory_arbitration_isValid;
  wire  memory_arbitration_isStuck;
  wire  memory_arbitration_isStuckByOthers;
  wire  memory_arbitration_isFlushed;
  wire  memory_arbitration_isMoving;
  wire  memory_arbitration_isFiring;
  wire  writeBack_arbitration_haltItself;
  wire  writeBack_arbitration_haltByOther;
  reg  writeBack_arbitration_removeIt;
  wire  writeBack_arbitration_flushIt;
  reg  writeBack_arbitration_flushNext;
  reg  writeBack_arbitration_isValid;
  wire  writeBack_arbitration_isStuck;
  wire  writeBack_arbitration_isStuckByOthers;
  wire  writeBack_arbitration_isFlushed;
  wire  writeBack_arbitration_isMoving;
  wire  writeBack_arbitration_isFiring;
  wire [31:0] lastStageInstruction /* verilator public */ ;
  wire [31:0] lastStagePc /* verilator public */ ;
  wire  lastStageIsValid /* verilator public */ ;
  wire  lastStageIsFiring /* verilator public */ ;
  reg  IBusSimplePlugin_fetcherHalt;
  reg  IBusSimplePlugin_fetcherflushIt;
  reg  IBusSimplePlugin_incomingInstruction;
  wire  IBusSimplePlugin_pcValids_0;
  wire  IBusSimplePlugin_pcValids_1;
  wire  IBusSimplePlugin_pcValids_2;
  wire  IBusSimplePlugin_pcValids_3;
  reg  DBusSimplePlugin_memoryExceptionPort_valid;
  reg [3:0] DBusSimplePlugin_memoryExceptionPort_payload_code;
  wire [31:0] DBusSimplePlugin_memoryExceptionPort_payload_badAddr;
  reg  CsrPlugin_jumpInterface_valid;
  reg [31:0] CsrPlugin_jumpInterface_payload;
  wire  CsrPlugin_exceptionPendings_0;
  wire  CsrPlugin_exceptionPendings_1;
  wire  CsrPlugin_exceptionPendings_2;
  wire  CsrPlugin_exceptionPendings_3;
  wire  contextSwitching;
  reg [1:0] CsrPlugin_privilege;
  wire  CsrPlugin_forceMachineWire;
  wire  CsrPlugin_allowInterrupts;
  wire  CsrPlugin_allowException;
  wire  decodeExceptionPort_valid;
  wire [3:0] decodeExceptionPort_payload_code;
  wire [31:0] decodeExceptionPort_payload_badAddr;
  wire  BranchPlugin_jumpInterface_valid;
  wire [31:0] BranchPlugin_jumpInterface_payload;
  reg  BranchPlugin_branchExceptionPort_valid;
  wire [3:0] BranchPlugin_branchExceptionPort_payload_code;
  wire [31:0] BranchPlugin_branchExceptionPort_payload_badAddr;
  wire [31:0] execute_BSWAP32_rs1;
  reg [31:0] execute_BSWAP32_rd;
  wire [31:0] execute_BSWAP16_rs1;
  reg [31:0] execute_BSWAP16_rd;
  wire [31:0] execute_TAIL_ZERO_rs1;
  reg [31:0] execute_TAIL_ZERO_rd;
  wire [31:0] _zz_85_;
  wire [32:0] _zz_86_;
  wire  _zz_87_;
  wire  _zz_88_;
  wire  _zz_89_;
  wire  _zz_90_;
  wire  _zz_91_;
  wire  _zz_92_;
  wire  _zz_93_;
  wire  _zz_94_;
  wire  _zz_95_;
  wire  _zz_96_;
  wire  _zz_97_;
  wire  _zz_98_;
  wire  _zz_99_;
  wire  _zz_100_;
  wire  _zz_101_;
  wire  _zz_102_;
  wire  _zz_103_;
  wire  _zz_104_;
  wire  _zz_105_;
  wire  _zz_106_;
  wire  _zz_107_;
  wire  _zz_108_;
  wire  _zz_109_;
  wire  _zz_110_;
  wire  _zz_111_;
  wire  _zz_112_;
  wire  _zz_113_;
  wire  _zz_114_;
  wire  _zz_115_;
  wire  _zz_116_;
  wire  _zz_117_;
  wire  _zz_118_;
  wire  IBusSimplePlugin_jump_pcLoad_valid;
  wire [31:0] IBusSimplePlugin_jump_pcLoad_payload;
  wire [1:0] _zz_119_;
  wire  IBusSimplePlugin_fetchPc_output_valid;
  wire  IBusSimplePlugin_fetchPc_output_ready;
  wire [31:0] IBusSimplePlugin_fetchPc_output_payload;
  reg [31:0] IBusSimplePlugin_fetchPc_pcReg /* verilator public */ ;
  reg  IBusSimplePlugin_fetchPc_corrected;
  reg  IBusSimplePlugin_fetchPc_pcRegPropagate;
  reg  IBusSimplePlugin_fetchPc_booted;
  reg  IBusSimplePlugin_fetchPc_inc;
  reg [31:0] IBusSimplePlugin_fetchPc_pc;
  wire  IBusSimplePlugin_iBusRsp_stages_0_input_valid;
  wire  IBusSimplePlugin_iBusRsp_stages_0_input_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_stages_0_input_payload;
  wire  IBusSimplePlugin_iBusRsp_stages_0_output_valid;
  wire  IBusSimplePlugin_iBusRsp_stages_0_output_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_stages_0_output_payload;
  reg  IBusSimplePlugin_iBusRsp_stages_0_halt;
  wire  IBusSimplePlugin_iBusRsp_stages_0_inputSample;
  wire  IBusSimplePlugin_iBusRsp_stages_1_input_valid;
  wire  IBusSimplePlugin_iBusRsp_stages_1_input_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_stages_1_input_payload;
  wire  IBusSimplePlugin_iBusRsp_stages_1_output_valid;
  wire  IBusSimplePlugin_iBusRsp_stages_1_output_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_stages_1_output_payload;
  wire  IBusSimplePlugin_iBusRsp_stages_1_halt;
  wire  IBusSimplePlugin_iBusRsp_stages_1_inputSample;
  wire  _zz_120_;
  wire  _zz_121_;
  wire  _zz_122_;
  wire  _zz_123_;
  reg  _zz_124_;
  reg  IBusSimplePlugin_iBusRsp_readyForError;
  wire  IBusSimplePlugin_iBusRsp_inputBeforeStage_valid;
  wire  IBusSimplePlugin_iBusRsp_inputBeforeStage_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_pc;
  wire  IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_inst;
  wire  IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_isRvc;
  wire  IBusSimplePlugin_injector_decodeInput_valid;
  wire  IBusSimplePlugin_injector_decodeInput_ready;
  wire [31:0] IBusSimplePlugin_injector_decodeInput_payload_pc;
  wire  IBusSimplePlugin_injector_decodeInput_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  wire  IBusSimplePlugin_injector_decodeInput_payload_isRvc;
  reg  _zz_125_;
  reg [31:0] _zz_126_;
  reg  _zz_127_;
  reg [31:0] _zz_128_;
  reg  _zz_129_;
  reg  IBusSimplePlugin_injector_nextPcCalc_valids_0;
  reg  IBusSimplePlugin_injector_nextPcCalc_valids_1;
  reg  IBusSimplePlugin_injector_nextPcCalc_valids_2;
  reg  IBusSimplePlugin_injector_nextPcCalc_valids_3;
  reg  IBusSimplePlugin_injector_nextPcCalc_valids_4;
  reg  IBusSimplePlugin_injector_decodeRemoved;
  reg [31:0] IBusSimplePlugin_injector_formal_rawInDecode;
  wire  IBusSimplePlugin_cmd_valid;
  wire  IBusSimplePlugin_cmd_ready;
  wire [31:0] IBusSimplePlugin_cmd_payload_pc;
  reg [2:0] IBusSimplePlugin_pendingCmd;
  wire [2:0] IBusSimplePlugin_pendingCmdNext;
  reg [2:0] IBusSimplePlugin_rspJoin_discardCounter;
  wire  IBusSimplePlugin_rspJoin_rspBufferOutput_valid;
  wire  IBusSimplePlugin_rspJoin_rspBufferOutput_ready;
  wire  IBusSimplePlugin_rspJoin_rspBufferOutput_payload_error;
  wire [31:0] IBusSimplePlugin_rspJoin_rspBufferOutput_payload_inst;
  wire  iBus_rsp_takeWhen_valid;
  wire  iBus_rsp_takeWhen_payload_error;
  wire [31:0] iBus_rsp_takeWhen_payload_inst;
  wire [31:0] IBusSimplePlugin_rspJoin_fetchRsp_pc;
  reg  IBusSimplePlugin_rspJoin_fetchRsp_rsp_error;
  wire [31:0] IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst;
  wire  IBusSimplePlugin_rspJoin_fetchRsp_isRvc;
  wire  IBusSimplePlugin_rspJoin_join_valid;
  wire  IBusSimplePlugin_rspJoin_join_ready;
  wire [31:0] IBusSimplePlugin_rspJoin_join_payload_pc;
  wire  IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  wire  IBusSimplePlugin_rspJoin_join_payload_isRvc;
  wire  IBusSimplePlugin_rspJoin_exceptionDetected;
  wire  IBusSimplePlugin_rspJoin_redoRequired;
  wire  _zz_130_;
  wire  _zz_131_;
  reg  execute_DBusSimplePlugin_skipCmd;
  reg [31:0] _zz_132_;
  reg [3:0] _zz_133_;
  wire [3:0] execute_DBusSimplePlugin_formalMask;
  reg [31:0] memory_DBusSimplePlugin_rspShifted;
  wire  _zz_134_;
  reg [31:0] _zz_135_;
  wire  _zz_136_;
  reg [31:0] _zz_137_;
  reg [31:0] memory_DBusSimplePlugin_rspFormated;
  wire [1:0] CsrPlugin_misa_base;
  wire [25:0] CsrPlugin_misa_extensions;
  wire [1:0] CsrPlugin_mtvec_mode;
  wire [29:0] CsrPlugin_mtvec_base;
  reg [31:0] CsrPlugin_mepc;
  reg  CsrPlugin_mstatus_MIE;
  reg  CsrPlugin_mstatus_MPIE;
  reg [1:0] CsrPlugin_mstatus_MPP;
  reg  CsrPlugin_mip_MEIP;
  reg  CsrPlugin_mip_MTIP;
  reg  CsrPlugin_mip_MSIP;
  reg  CsrPlugin_mie_MEIE;
  reg  CsrPlugin_mie_MTIE;
  reg  CsrPlugin_mie_MSIE;
  reg  CsrPlugin_mcause_interrupt;
  reg [3:0] CsrPlugin_mcause_exceptionCode;
  reg [31:0] CsrPlugin_mtval;
  reg [63:0] CsrPlugin_mcycle = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  reg [63:0] CsrPlugin_minstret = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  wire  _zz_138_;
  wire  _zz_139_;
  wire  _zz_140_;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  reg [3:0] CsrPlugin_exceptionPortCtrl_exceptionContext_code;
  reg [31:0] CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
  wire [1:0] CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped;
  wire [1:0] CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
  reg  CsrPlugin_interrupt_valid;
  reg [3:0] CsrPlugin_interrupt_code /* verilator public */ ;
  reg [1:0] CsrPlugin_interrupt_targetPrivilege;
  wire  CsrPlugin_exception;
  wire  CsrPlugin_lastStageWasWfi;
  reg  CsrPlugin_pipelineLiberator_done;
  wire  CsrPlugin_interruptJump /* verilator public */ ;
  reg  CsrPlugin_hadException;
  reg [1:0] CsrPlugin_targetPrivilege;
  reg [3:0] CsrPlugin_trapCause;
  reg [1:0] CsrPlugin_xtvec_mode;
  reg [29:0] CsrPlugin_xtvec_base;
  wire  execute_CsrPlugin_inWfi /* verilator public */ ;
  reg  execute_CsrPlugin_wfiWake;
  wire  execute_CsrPlugin_blockedBySideEffects;
  reg  execute_CsrPlugin_illegalAccess;
  reg  execute_CsrPlugin_illegalInstruction;
  reg [31:0] execute_CsrPlugin_readData;
  wire  execute_CsrPlugin_writeInstruction;
  wire  execute_CsrPlugin_readInstruction;
  wire  execute_CsrPlugin_writeEnable;
  wire  execute_CsrPlugin_readEnable;
  wire [31:0] execute_CsrPlugin_readToWriteData;
  reg [31:0] execute_CsrPlugin_writeData;
  wire [11:0] execute_CsrPlugin_csrAddress;
  wire [27:0] _zz_141_;
  wire  _zz_142_;
  wire  _zz_143_;
  wire  _zz_144_;
  wire  _zz_145_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_146_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_147_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_148_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_149_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_150_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_151_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_152_;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress1;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress2;
  wire [31:0] decode_RegFilePlugin_rs1Data;
  wire [31:0] decode_RegFilePlugin_rs2Data;
  reg  lastStageRegFileWrite_valid /* verilator public */ ;
  wire [4:0] lastStageRegFileWrite_payload_address /* verilator public */ ;
  wire [31:0] lastStageRegFileWrite_payload_data /* verilator public */ ;
  reg  _zz_153_;
  reg [31:0] execute_IntAluPlugin_bitwise;
  reg [31:0] _zz_154_;
  reg [31:0] _zz_155_;
  wire  _zz_156_;
  reg [19:0] _zz_157_;
  wire  _zz_158_;
  reg [19:0] _zz_159_;
  reg [31:0] _zz_160_;
  reg [31:0] execute_SrcPlugin_addSub;
  wire  execute_SrcPlugin_less;
  wire [4:0] execute_FullBarrelShifterPlugin_amplitude;
  reg [31:0] _zz_161_;
  wire [31:0] execute_FullBarrelShifterPlugin_reversed;
  reg [31:0] _zz_162_;
  reg  _zz_163_;
  reg  _zz_164_;
  wire  _zz_165_;
  reg  _zz_166_;
  reg [4:0] _zz_167_;
  reg [31:0] _zz_168_;
  wire  _zz_169_;
  wire  _zz_170_;
  wire  _zz_171_;
  wire  _zz_172_;
  wire  _zz_173_;
  wire  _zz_174_;
  wire  execute_BranchPlugin_eq;
  wire [2:0] _zz_175_;
  reg  _zz_176_;
  reg  _zz_177_;
  wire [31:0] execute_BranchPlugin_branch_src1;
  wire  _zz_178_;
  reg [10:0] _zz_179_;
  wire  _zz_180_;
  reg [19:0] _zz_181_;
  wire  _zz_182_;
  reg [18:0] _zz_183_;
  reg [31:0] _zz_184_;
  wire [31:0] execute_BranchPlugin_branch_src2;
  wire [31:0] execute_BranchPlugin_branchAdder;
  reg  decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg  decode_to_execute_CSR_WRITE_OPCODE;
  reg `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg  execute_to_memory_ALIGNEMENT_FAULT;
  reg  decode_to_execute_MEMORY_STORE;
  reg  execute_to_memory_MEMORY_STORE;
  reg  decode_to_execute_SRC_LESS_UNSIGNED;
  reg  decode_to_execute_IS_TAIL_ZERO;
  reg  decode_to_execute_CSR_READ_OPCODE;
  reg  decode_to_execute_SRC_USE_SUB_LESS;
  reg  decode_to_execute_MEMORY_ENABLE;
  reg  execute_to_memory_MEMORY_ENABLE;
  reg `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg [31:0] execute_to_memory_REGFILE_WRITE_DATA;
  reg [31:0] memory_to_writeBack_REGFILE_WRITE_DATA;
  reg [31:0] decode_to_execute_INSTRUCTION;
  reg [31:0] execute_to_memory_INSTRUCTION;
  reg [31:0] memory_to_writeBack_INSTRUCTION;
  reg [31:0] decode_to_execute_RS2;
  reg  decode_to_execute_SRC2_FORCE_ZERO;
  reg [1:0] execute_to_memory_MEMORY_ADDRESS_LOW;
  reg `EnvCtrlEnum_defaultEncoding_type decode_to_execute_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type execute_to_memory_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type memory_to_writeBack_ENV_CTRL;
  reg `Src1CtrlEnum_defaultEncoding_type decode_to_execute_SRC1_CTRL;
  reg [31:0] decode_to_execute_FORMAL_PC_NEXT;
  reg [31:0] execute_to_memory_FORMAL_PC_NEXT;
  reg [31:0] memory_to_writeBack_FORMAL_PC_NEXT;
  reg  decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg  execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg  decode_to_execute_IS_CSR;
  reg [31:0] decode_to_execute_RS1;
  reg  decode_to_execute_IS_BSWAP_16;
  reg `Src2CtrlEnum_defaultEncoding_type decode_to_execute_SRC2_CTRL;
  reg  decode_to_execute_REGFILE_WRITE_VALID;
  reg  execute_to_memory_REGFILE_WRITE_VALID;
  reg  memory_to_writeBack_REGFILE_WRITE_VALID;
  reg  decode_to_execute_IS_BSWAP_32;
  reg [31:0] decode_to_execute_PC;
  reg [31:0] execute_to_memory_PC;
  reg [31:0] memory_to_writeBack_PC;
  `ifndef SYNTHESIS
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_1__string;
  reg [23:0] _zz_2__string;
  reg [23:0] _zz_3__string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_4__string;
  reg [39:0] _zz_5__string;
  reg [39:0] _zz_6__string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_7__string;
  reg [95:0] _zz_8__string;
  reg [95:0] _zz_9__string;
  reg [31:0] _zz_10__string;
  reg [31:0] _zz_11__string;
  reg [31:0] _zz_12__string;
  reg [31:0] _zz_13__string;
  reg [31:0] decode_ENV_CTRL_string;
  reg [31:0] _zz_14__string;
  reg [31:0] _zz_15__string;
  reg [31:0] _zz_16__string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_17__string;
  reg [31:0] _zz_18__string;
  reg [31:0] _zz_19__string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_20__string;
  reg [63:0] _zz_21__string;
  reg [63:0] _zz_22__string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_23__string;
  reg [71:0] _zz_24__string;
  reg [71:0] _zz_25__string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_27__string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_30__string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_35__string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_37__string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_40__string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_42__string;
  reg [95:0] _zz_49__string;
  reg [23:0] _zz_53__string;
  reg [39:0] _zz_55__string;
  reg [71:0] _zz_62__string;
  reg [63:0] _zz_64__string;
  reg [31:0] _zz_68__string;
  reg [31:0] _zz_69__string;
  reg [31:0] memory_ENV_CTRL_string;
  reg [31:0] _zz_71__string;
  reg [31:0] execute_ENV_CTRL_string;
  reg [31:0] _zz_72__string;
  reg [31:0] writeBack_ENV_CTRL_string;
  reg [31:0] _zz_75__string;
  reg [31:0] _zz_146__string;
  reg [31:0] _zz_147__string;
  reg [63:0] _zz_148__string;
  reg [71:0] _zz_149__string;
  reg [39:0] _zz_150__string;
  reg [23:0] _zz_151__string;
  reg [95:0] _zz_152__string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  reg [31:0] decode_to_execute_ENV_CTRL_string;
  reg [31:0] execute_to_memory_ENV_CTRL_string;
  reg [31:0] memory_to_writeBack_ENV_CTRL_string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  `endif

  reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;
  assign _zz_187_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_188_ = 1'b1;
  assign _zz_189_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_190_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_191_ = (execute_arbitration_isValid && execute_IS_CSR);
  assign _zz_192_ = (CsrPlugin_hadException || CsrPlugin_interruptJump);
  assign _zz_193_ = (writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET));
  assign _zz_194_ = writeBack_INSTRUCTION[29 : 28];
  assign _zz_195_ = ((dBus_rsp_ready && dBus_rsp_error) && (! memory_MEMORY_STORE));
  assign _zz_196_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_197_ = (1'b0 || (! 1'b1));
  assign _zz_198_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_199_ = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_200_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_201_ = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_202_ = (CsrPlugin_mstatus_MIE || (CsrPlugin_privilege < (2'b11)));
  assign _zz_203_ = ((_zz_138_ && 1'b1) && (! 1'b0));
  assign _zz_204_ = ((_zz_139_ && 1'b1) && (! 1'b0));
  assign _zz_205_ = ((_zz_140_ && 1'b1) && (! 1'b0));
  assign _zz_206_ = memory_INSTRUCTION[13 : 12];
  assign _zz_207_ = execute_INSTRUCTION[13];
  assign _zz_208_ = (_zz_85_ - (32'b00000000000000000000000000000001));
  assign _zz_209_ = (_zz_119_ & (~ _zz_210_));
  assign _zz_210_ = (_zz_119_ - (2'b01));
  assign _zz_211_ = {IBusSimplePlugin_fetchPc_inc,(2'b00)};
  assign _zz_212_ = {29'd0, _zz_211_};
  assign _zz_213_ = (IBusSimplePlugin_pendingCmd + _zz_215_);
  assign _zz_214_ = (IBusSimplePlugin_cmd_valid && IBusSimplePlugin_cmd_ready);
  assign _zz_215_ = {2'd0, _zz_214_};
  assign _zz_216_ = iBus_rsp_valid;
  assign _zz_217_ = {2'd0, _zz_216_};
  assign _zz_218_ = (iBus_rsp_valid && (IBusSimplePlugin_rspJoin_discardCounter != (3'b000)));
  assign _zz_219_ = {2'd0, _zz_218_};
  assign _zz_220_ = iBus_rsp_valid;
  assign _zz_221_ = {2'd0, _zz_220_};
  assign _zz_222_ = (memory_MEMORY_STORE ? (3'b110) : (3'b100));
  assign _zz_223_ = _zz_141_[3 : 3];
  assign _zz_224_ = _zz_141_[4 : 4];
  assign _zz_225_ = _zz_141_[5 : 5];
  assign _zz_226_ = _zz_141_[8 : 8];
  assign _zz_227_ = _zz_141_[11 : 11];
  assign _zz_228_ = _zz_141_[12 : 12];
  assign _zz_229_ = _zz_141_[14 : 14];
  assign _zz_230_ = _zz_141_[15 : 15];
  assign _zz_231_ = _zz_141_[16 : 16];
  assign _zz_232_ = _zz_141_[17 : 17];
  assign _zz_233_ = _zz_141_[20 : 20];
  assign _zz_234_ = _zz_141_[23 : 23];
  assign _zz_235_ = _zz_141_[24 : 24];
  assign _zz_236_ = _zz_141_[25 : 25];
  assign _zz_237_ = execute_SRC_LESS;
  assign _zz_238_ = (3'b100);
  assign _zz_239_ = execute_INSTRUCTION[19 : 15];
  assign _zz_240_ = execute_INSTRUCTION[31 : 20];
  assign _zz_241_ = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_242_ = ($signed(_zz_243_) + $signed(_zz_246_));
  assign _zz_243_ = ($signed(_zz_244_) + $signed(_zz_245_));
  assign _zz_244_ = execute_SRC1;
  assign _zz_245_ = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_246_ = (execute_SRC_USE_SUB_LESS ? _zz_247_ : _zz_248_);
  assign _zz_247_ = (32'b00000000000000000000000000000001);
  assign _zz_248_ = (32'b00000000000000000000000000000000);
  assign _zz_249_ = ($signed(_zz_251_) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_250_ = _zz_249_[31 : 0];
  assign _zz_251_ = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_252_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_253_ = execute_INSTRUCTION[31 : 20];
  assign _zz_254_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_255_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_256_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_257_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_258_ = execute_CsrPlugin_writeData[11 : 11];
  assign _zz_259_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_260_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_261_ = (decode_INSTRUCTION & (32'b00000000000000000000000000010100));
  assign _zz_262_ = (32'b00000000000000000000000000000100);
  assign _zz_263_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001000100)) == (32'b00000000000000000000000000000100));
  assign _zz_264_ = {(_zz_269_ == _zz_270_),{_zz_271_,{_zz_272_,_zz_273_}}};
  assign _zz_265_ = (4'b0000);
  assign _zz_266_ = ((_zz_274_ == _zz_275_) != (1'b0));
  assign _zz_267_ = ({_zz_276_,_zz_277_} != (2'b00));
  assign _zz_268_ = {(_zz_278_ != _zz_279_),{_zz_280_,{_zz_281_,_zz_282_}}};
  assign _zz_269_ = (decode_INSTRUCTION & (32'b00000000000000000000000001000100));
  assign _zz_270_ = (32'b00000000000000000000000000000000);
  assign _zz_271_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000011000)) == (32'b00000000000000000000000000000000));
  assign _zz_272_ = ((decode_INSTRUCTION & _zz_283_) == (32'b00000000000000000010000000000000));
  assign _zz_273_ = ((decode_INSTRUCTION & _zz_284_) == (32'b00000000000000000001000000000000));
  assign _zz_274_ = (decode_INSTRUCTION & (32'b00000000000000000000000001011000));
  assign _zz_275_ = (32'b00000000000000000000000000000000);
  assign _zz_276_ = _zz_144_;
  assign _zz_277_ = ((decode_INSTRUCTION & _zz_285_) == (32'b00000000000000000000000000100000));
  assign _zz_278_ = {_zz_144_,(_zz_286_ == _zz_287_)};
  assign _zz_279_ = (2'b00);
  assign _zz_280_ = ((_zz_288_ == _zz_289_) != (1'b0));
  assign _zz_281_ = (_zz_290_ != (1'b0));
  assign _zz_282_ = {(_zz_291_ != _zz_292_),{_zz_293_,{_zz_294_,_zz_295_}}};
  assign _zz_283_ = (32'b00000000000000000110000000000100);
  assign _zz_284_ = (32'b00000000000000000101000000000100);
  assign _zz_285_ = (32'b00000000000000000000000001110000);
  assign _zz_286_ = (decode_INSTRUCTION & (32'b00000000000000000000000000100000));
  assign _zz_287_ = (32'b00000000000000000000000000000000);
  assign _zz_288_ = (decode_INSTRUCTION & (32'b00000100000000000011000001010100));
  assign _zz_289_ = (32'b00000100000000000001000000010000);
  assign _zz_290_ = ((decode_INSTRUCTION & (32'b00000000000000000001000000000000)) == (32'b00000000000000000001000000000000));
  assign _zz_291_ = ((decode_INSTRUCTION & (32'b00000000000000000011000000000000)) == (32'b00000000000000000010000000000000));
  assign _zz_292_ = (1'b0);
  assign _zz_293_ = ({(_zz_296_ == _zz_297_),(_zz_298_ == _zz_299_)} != (2'b00));
  assign _zz_294_ = ((_zz_300_ == _zz_301_) != (1'b0));
  assign _zz_295_ = {({_zz_302_,_zz_303_} != (3'b000)),{(_zz_304_ != _zz_305_),{_zz_306_,{_zz_307_,_zz_308_}}}};
  assign _zz_296_ = (decode_INSTRUCTION & (32'b00000000000000000010000000010000));
  assign _zz_297_ = (32'b00000000000000000010000000000000);
  assign _zz_298_ = (decode_INSTRUCTION & (32'b00000000000000000101000000000000));
  assign _zz_299_ = (32'b00000000000000000001000000000000);
  assign _zz_300_ = (decode_INSTRUCTION & (32'b00000100000000000011000001100100));
  assign _zz_301_ = (32'b00000100000000000011000000100000);
  assign _zz_302_ = ((decode_INSTRUCTION & _zz_309_) == (32'b00000000000000000000000001000000));
  assign _zz_303_ = {(_zz_310_ == _zz_311_),(_zz_312_ == _zz_313_)};
  assign _zz_304_ = {(_zz_314_ == _zz_315_),(_zz_316_ == _zz_317_)};
  assign _zz_305_ = (2'b00);
  assign _zz_306_ = ({_zz_318_,{_zz_319_,_zz_320_}} != (3'b000));
  assign _zz_307_ = (_zz_321_ != (1'b0));
  assign _zz_308_ = {(_zz_322_ != _zz_323_),{_zz_324_,{_zz_325_,_zz_326_}}};
  assign _zz_309_ = (32'b00000000000000000000000001000100);
  assign _zz_310_ = (decode_INSTRUCTION & (32'b00000000000000000010000000010100));
  assign _zz_311_ = (32'b00000000000000000010000000010000);
  assign _zz_312_ = (decode_INSTRUCTION & (32'b01000000000000000000000000110100));
  assign _zz_313_ = (32'b01000000000000000000000000110000);
  assign _zz_314_ = (decode_INSTRUCTION & (32'b00000000000000000000000000110100));
  assign _zz_315_ = (32'b00000000000000000000000000100000);
  assign _zz_316_ = (decode_INSTRUCTION & (32'b00000100000000000000000001100100));
  assign _zz_317_ = (32'b00000000000000000000000000100000);
  assign _zz_318_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001010000)) == (32'b00000000000000000000000001000000));
  assign _zz_319_ = ((decode_INSTRUCTION & _zz_327_) == (32'b00000000000000000000000001000000));
  assign _zz_320_ = ((decode_INSTRUCTION & _zz_328_) == (32'b00000000000000000000000000000000));
  assign _zz_321_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001100100)) == (32'b00000000000000000000000000100100));
  assign _zz_322_ = ((decode_INSTRUCTION & _zz_329_) == (32'b00000000000000000000000000100000));
  assign _zz_323_ = (1'b0);
  assign _zz_324_ = ((_zz_330_ == _zz_331_) != (1'b0));
  assign _zz_325_ = ({_zz_332_,_zz_333_} != (2'b00));
  assign _zz_326_ = {(_zz_334_ != _zz_335_),{_zz_336_,{_zz_337_,_zz_338_}}};
  assign _zz_327_ = (32'b00000000000000000011000001000000);
  assign _zz_328_ = (32'b00000000000000000000000000111000);
  assign _zz_329_ = (32'b00000000000000000000000000100000);
  assign _zz_330_ = (decode_INSTRUCTION & (32'b00000000000000000111000001010100));
  assign _zz_331_ = (32'b00000000000000000101000000010000);
  assign _zz_332_ = ((decode_INSTRUCTION & _zz_339_) == (32'b01000000000000000001000000010000));
  assign _zz_333_ = ((decode_INSTRUCTION & _zz_340_) == (32'b00000000000000000001000000010000));
  assign _zz_334_ = ((decode_INSTRUCTION & _zz_341_) == (32'b00000000000000000000000000000000));
  assign _zz_335_ = (1'b0);
  assign _zz_336_ = ((_zz_342_ == _zz_343_) != (1'b0));
  assign _zz_337_ = (_zz_344_ != (1'b0));
  assign _zz_338_ = {(_zz_345_ != _zz_346_),{_zz_347_,{_zz_348_,_zz_349_}}};
  assign _zz_339_ = (32'b01000000000000000011000001010100);
  assign _zz_340_ = (32'b00000100000000000111000001010100);
  assign _zz_341_ = (32'b00000000000000000000000000000000);
  assign _zz_342_ = (decode_INSTRUCTION & (32'b00000000000000000100000000010100));
  assign _zz_343_ = (32'b00000000000000000100000000010000);
  assign _zz_344_ = ((decode_INSTRUCTION & (32'b00000000000000000110000000010100)) == (32'b00000000000000000010000000010000));
  assign _zz_345_ = {_zz_142_,{(_zz_350_ == _zz_351_),{_zz_352_,{_zz_353_,_zz_354_}}}};
  assign _zz_346_ = (6'b000000);
  assign _zz_347_ = ({(_zz_355_ == _zz_356_),(_zz_357_ == _zz_358_)} != (2'b00));
  assign _zz_348_ = ((_zz_359_ == _zz_360_) != (1'b0));
  assign _zz_349_ = {({_zz_361_,_zz_362_} != (2'b00)),{(_zz_363_ != _zz_364_),(_zz_365_ != _zz_366_)}};
  assign _zz_350_ = (decode_INSTRUCTION & (32'b00000000000000000001000000010000));
  assign _zz_351_ = (32'b00000000000000000001000000010000);
  assign _zz_352_ = ((decode_INSTRUCTION & (32'b00000000000000000010000000010000)) == (32'b00000000000000000010000000010000));
  assign _zz_353_ = _zz_143_;
  assign _zz_354_ = {((decode_INSTRUCTION & (32'b00000000000000000000000000001100)) == (32'b00000000000000000000000000000100)),((decode_INSTRUCTION & (32'b00000000000000000000000000101000)) == (32'b00000000000000000000000000000000))};
  assign _zz_355_ = (decode_INSTRUCTION & (32'b00000000000000000001000001010000));
  assign _zz_356_ = (32'b00000000000000000001000001010000);
  assign _zz_357_ = (decode_INSTRUCTION & (32'b00000000000000000010000001010000));
  assign _zz_358_ = (32'b00000000000000000010000001010000);
  assign _zz_359_ = (decode_INSTRUCTION & (32'b00000100000000000011000000110100));
  assign _zz_360_ = (32'b00000100000000000000000000110000);
  assign _zz_361_ = _zz_142_;
  assign _zz_362_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000011100)) == (32'b00000000000000000000000000000100));
  assign _zz_363_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001011000)) == (32'b00000000000000000000000001000000));
  assign _zz_364_ = (1'b0);
  assign _zz_365_ = ((decode_INSTRUCTION & (32'b00000000000000000011000001010000)) == (32'b00000000000000000000000001010000));
  assign _zz_366_ = (1'b0);
  assign _zz_367_ = (32'b00000000000000000001000001111111);
  assign _zz_368_ = (decode_INSTRUCTION & (32'b00000000000000000010000001111111));
  assign _zz_369_ = (32'b00000000000000000010000001110011);
  assign _zz_370_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001111111)) == (32'b00000000000000000100000001100011));
  assign _zz_371_ = ((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000010000000010011));
  assign _zz_372_ = {((decode_INSTRUCTION & (32'b00000000000000000110000000111111)) == (32'b00000000000000000000000000100011)),{((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_373_) == (32'b00000000000000000000000000000011)),{(_zz_374_ == _zz_375_),{_zz_376_,{_zz_377_,_zz_378_}}}}}};
  assign _zz_373_ = (32'b00000000000000000101000001011111);
  assign _zz_374_ = (decode_INSTRUCTION & (32'b00000000000000000111000001111011));
  assign _zz_375_ = (32'b00000000000000000000000001100011);
  assign _zz_376_ = ((decode_INSTRUCTION & (32'b00000000000000000110000001111111)) == (32'b00000000000000000000000000001111));
  assign _zz_377_ = ((decode_INSTRUCTION & (32'b11111110000000000000000001111111)) == (32'b00000000000000000000000000110011));
  assign _zz_378_ = {((decode_INSTRUCTION & (32'b10111100000000000111000001111111)) == (32'b00000000000000000101000000010011)),{((decode_INSTRUCTION & (32'b11111100000000000011000001111111)) == (32'b00000000000000000001000000010011)),{((decode_INSTRUCTION & _zz_379_) == (32'b00000110000000000001000000110011)),{(_zz_380_ == _zz_381_),{_zz_382_,{_zz_383_,_zz_384_}}}}}};
  assign _zz_379_ = (32'b11111110000000000101000001111111);
  assign _zz_380_ = (decode_INSTRUCTION & (32'b10111110000000000111000001111111));
  assign _zz_381_ = (32'b00000000000000000101000000110011);
  assign _zz_382_ = ((decode_INSTRUCTION & (32'b11111110000000000110000001111111)) == (32'b00000110000000000000000000110011));
  assign _zz_383_ = ((decode_INSTRUCTION & (32'b10111110000000000111000001111111)) == (32'b00000000000000000000000000110011));
  assign _zz_384_ = ((decode_INSTRUCTION & (32'b11011111111111111111111111111111)) == (32'b00010000001000000000000001110011));
  always @ (posedge clk) begin
    if(_zz_46_) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  assign _zz_185_ = RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
  assign _zz_186_ = RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
  StreamFifoLowLatency IBusSimplePlugin_rspJoin_rspBuffer_c ( 
    .io_push_valid(iBus_rsp_takeWhen_valid),
    .io_push_ready(IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready),
    .io_push_payload_error(iBus_rsp_takeWhen_payload_error),
    .io_push_payload_inst(iBus_rsp_takeWhen_payload_inst),
    .io_pop_valid(IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid),
    .io_pop_ready(IBusSimplePlugin_rspJoin_rspBufferOutput_ready),
    .io_pop_payload_error(IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error),
    .io_pop_payload_inst(IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst),
    .io_flush(IBusSimplePlugin_fetcherflushIt),
    .io_occupancy(IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy),
    .clk(clk),
    .reset(reset) 
  );
  `ifndef SYNTHESIS
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
    case(_zz_1_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_1__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_1__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_1__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_1__string = "PC ";
      default : _zz_1__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_2_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_2__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_2__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_2__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_2__string = "PC ";
      default : _zz_2__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_3_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_3__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_3__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_3__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_3__string = "PC ";
      default : _zz_3__string = "???";
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
    case(_zz_4_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_4__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_4__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_4__string = "AND_1";
      default : _zz_4__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_5_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_5__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_5__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_5__string = "AND_1";
      default : _zz_5__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_6_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_6__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_6__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_6__string = "AND_1";
      default : _zz_6__string = "?????";
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
    case(_zz_7_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_7__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_7__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_7__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_7__string = "URS1        ";
      default : _zz_7__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_8_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_8__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_8__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_8__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_8__string = "URS1        ";
      default : _zz_8__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_9_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_9__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_9__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_9__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_9__string = "URS1        ";
      default : _zz_9__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_10_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_10__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_10__string = "XRET";
      default : _zz_10__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_11_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_11__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_11__string = "XRET";
      default : _zz_11__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_12_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_12__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_12__string = "XRET";
      default : _zz_12__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_13_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_13__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_13__string = "XRET";
      default : _zz_13__string = "????";
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
    case(_zz_14_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_14__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_14__string = "XRET";
      default : _zz_14__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_15_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_15__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_15__string = "XRET";
      default : _zz_15__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_16_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_16__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_16__string = "XRET";
      default : _zz_16__string = "????";
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
    case(_zz_19_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_19__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_19__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_19__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_19__string = "JALR";
      default : _zz_19__string = "????";
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
    case(_zz_20_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_20__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_20__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_20__string = "BITWISE ";
      default : _zz_20__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_21_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_21__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_21__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_21__string = "BITWISE ";
      default : _zz_21__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_22_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_22__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_22__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_22__string = "BITWISE ";
      default : _zz_22__string = "????????";
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
    case(_zz_23_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_23__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_23__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_23__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_23__string = "SRA_1    ";
      default : _zz_23__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_24_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_24__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_24__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_24__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_24__string = "SRA_1    ";
      default : _zz_24__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_25_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_25__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_25__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_25__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_25__string = "SRA_1    ";
      default : _zz_25__string = "?????????";
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
    case(_zz_27_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_27__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_27__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_27__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_27__string = "JALR";
      default : _zz_27__string = "????";
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
    case(_zz_30_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_30__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_30__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_30__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_30__string = "SRA_1    ";
      default : _zz_30__string = "?????????";
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
    case(_zz_35_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_35__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_35__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_35__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_35__string = "PC ";
      default : _zz_35__string = "???";
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
    case(_zz_37_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_37__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_37__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_37__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_37__string = "URS1        ";
      default : _zz_37__string = "????????????";
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
    case(_zz_40_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_40__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_40__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_40__string = "BITWISE ";
      default : _zz_40__string = "????????";
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
    case(_zz_42_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_42__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_42__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_42__string = "AND_1";
      default : _zz_42__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_49_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_49__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_49__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_49__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_49__string = "URS1        ";
      default : _zz_49__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_53_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_53__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_53__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_53__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_53__string = "PC ";
      default : _zz_53__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_55_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_55__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_55__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_55__string = "AND_1";
      default : _zz_55__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_62_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_62__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_62__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_62__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_62__string = "SRA_1    ";
      default : _zz_62__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_64_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_64__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_64__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_64__string = "BITWISE ";
      default : _zz_64__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_68_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_68__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_68__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_68__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_68__string = "JALR";
      default : _zz_68__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_69_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_69__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_69__string = "XRET";
      default : _zz_69__string = "????";
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
    case(_zz_71_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_71__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_71__string = "XRET";
      default : _zz_71__string = "????";
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
    case(_zz_72_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_72__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_72__string = "XRET";
      default : _zz_72__string = "????";
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
    case(_zz_75_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_75__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_75__string = "XRET";
      default : _zz_75__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_146_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_146__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_146__string = "XRET";
      default : _zz_146__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_147_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_147__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_147__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_147__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_147__string = "JALR";
      default : _zz_147__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_148_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_148__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_148__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_148__string = "BITWISE ";
      default : _zz_148__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_149_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_149__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_149__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_149__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_149__string = "SRA_1    ";
      default : _zz_149__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_150_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_150__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_150__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_150__string = "AND_1";
      default : _zz_150__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_151_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_151__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_151__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_151__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_151__string = "PC ";
      default : _zz_151__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_152_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_152__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_152__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_152__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_152__string = "URS1        ";
      default : _zz_152__string = "????????????";
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
    case(decode_to_execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
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
    case(decode_to_execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_to_execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_to_execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_to_execute_SRC2_CTRL_string = "PC ";
      default : decode_to_execute_SRC2_CTRL_string = "???";
    endcase
  end
  `endif

  assign memory_PC = execute_to_memory_PC;
  assign decode_IS_BSWAP_32 = _zz_67_;
  assign decode_SRC2_CTRL = _zz_1_;
  assign _zz_2_ = _zz_3_;
  assign decode_IS_BSWAP_16 = _zz_54_;
  assign decode_IS_CSR = _zz_66_;
  assign decode_ALU_BITWISE_CTRL = _zz_4_;
  assign _zz_5_ = _zz_6_;
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_63_;
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = _zz_81_;
  assign decode_SRC1_CTRL = _zz_7_;
  assign _zz_8_ = _zz_9_;
  assign _zz_10_ = _zz_11_;
  assign _zz_12_ = _zz_13_;
  assign decode_ENV_CTRL = _zz_14_;
  assign _zz_15_ = _zz_16_;
  assign execute_MEMORY_ADDRESS_LOW = _zz_78_;
  assign decode_SRC2_FORCE_ZERO = _zz_39_;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign execute_REGFILE_WRITE_DATA = _zz_41_;
  assign decode_BRANCH_CTRL = _zz_17_;
  assign _zz_18_ = _zz_19_;
  assign decode_MEMORY_ENABLE = _zz_52_;
  assign decode_CSR_READ_OPCODE = _zz_73_;
  assign decode_IS_TAIL_ZERO = _zz_57_;
  assign decode_SRC_LESS_UNSIGNED = _zz_56_;
  assign decode_MEMORY_STORE = _zz_61_;
  assign decode_ALU_CTRL = _zz_20_;
  assign _zz_21_ = _zz_22_;
  assign decode_CSR_WRITE_OPCODE = _zz_74_;
  assign decode_SHIFT_CTRL = _zz_23_;
  assign _zz_24_ = _zz_25_;
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_50_;
  assign execute_BRANCH_CALC = _zz_26_;
  assign execute_BRANCH_DO = _zz_28_;
  assign execute_PC = decode_to_execute_PC;
  assign execute_BRANCH_CTRL = _zz_27_;
  assign decode_RS2_USE = _zz_59_;
  assign decode_RS1_USE = _zz_51_;
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS2 = _zz_47_;
    if(_zz_166_)begin
      if((_zz_167_ == decode_INSTRUCTION[24 : 20]))begin
        decode_RS2 = _zz_168_;
      end
    end
    if(_zz_187_)begin
      if(_zz_188_)begin
        if(_zz_170_)begin
          decode_RS2 = _zz_43_;
        end
      end
    end
    if(_zz_189_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_172_)begin
          decode_RS2 = _zz_76_;
        end
      end
    end
    if(_zz_190_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_174_)begin
          decode_RS2 = _zz_84_;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS1 = _zz_48_;
    if(_zz_166_)begin
      if((_zz_167_ == decode_INSTRUCTION[19 : 15]))begin
        decode_RS1 = _zz_168_;
      end
    end
    if(_zz_187_)begin
      if(_zz_188_)begin
        if(_zz_169_)begin
          decode_RS1 = _zz_43_;
        end
      end
    end
    if(_zz_189_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_171_)begin
          decode_RS1 = _zz_76_;
        end
      end
    end
    if(_zz_190_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_173_)begin
          decode_RS1 = _zz_84_;
        end
      end
    end
  end

  assign execute_SHIFT_RIGHT = _zz_29_;
  assign execute_SHIFT_CTRL = _zz_30_;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign _zz_34_ = execute_PC;
  assign execute_SRC2_CTRL = _zz_35_;
  assign execute_SRC1_CTRL = _zz_37_;
  assign decode_SRC_USE_SUB_LESS = _zz_58_;
  assign decode_SRC_ADD_ZERO = _zz_60_;
  assign execute_SRC_ADD_SUB = _zz_33_;
  assign execute_SRC_LESS = _zz_31_;
  assign execute_ALU_CTRL = _zz_40_;
  assign execute_SRC2 = _zz_36_;
  assign execute_ALU_BITWISE_CTRL = _zz_42_;
  assign _zz_43_ = writeBack_REGFILE_WRITE_DATA;
  assign _zz_44_ = writeBack_INSTRUCTION;
  assign _zz_45_ = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_46_ = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_46_ = 1'b1;
    end
  end

  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_65_;
    if((decode_INSTRUCTION[11 : 7] == (5'b00000)))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  assign decode_LEGAL_INSTRUCTION = _zz_70_;
  assign decode_INSTRUCTION_READY = 1'b1;
  assign execute_SRC1 = _zz_38_;
  assign execute_CSR_READ_OPCODE = decode_to_execute_CSR_READ_OPCODE;
  assign execute_CSR_WRITE_OPCODE = decode_to_execute_CSR_WRITE_OPCODE;
  assign execute_IS_CSR = decode_to_execute_IS_CSR;
  assign memory_ENV_CTRL = _zz_71_;
  assign execute_ENV_CTRL = _zz_72_;
  assign writeBack_ENV_CTRL = _zz_75_;
  always @ (*) begin
    _zz_76_ = memory_REGFILE_WRITE_DATA;
    if((memory_arbitration_isValid && memory_MEMORY_ENABLE))begin
      _zz_76_ = memory_DBusSimplePlugin_rspFormated;
    end
  end

  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign memory_MEMORY_READ_DATA = _zz_77_;
  assign memory_ALIGNEMENT_FAULT = execute_to_memory_ALIGNEMENT_FAULT;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign memory_MEMORY_STORE = execute_to_memory_MEMORY_STORE;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_SRC_ADD = _zz_32_;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign execute_MEMORY_STORE = decode_to_execute_MEMORY_STORE;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  assign execute_ALIGNEMENT_FAULT = _zz_79_;
  always @ (*) begin
    _zz_80_ = execute_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_80_ = BranchPlugin_jumpInterface_payload;
    end
  end

  assign decode_PC = _zz_83_;
  assign decode_INSTRUCTION = _zz_82_;
  assign execute_IS_TAIL_ZERO = decode_to_execute_IS_TAIL_ZERO;
  assign execute_IS_BSWAP_16 = decode_to_execute_IS_BSWAP_16;
  always @ (*) begin
    _zz_84_ = execute_REGFILE_WRITE_DATA;
    if(execute_IS_BSWAP_32)begin
      _zz_84_ = execute_BSWAP32_rd;
    end
    if(execute_IS_BSWAP_16)begin
      _zz_84_ = execute_BSWAP16_rd;
    end
    if(execute_IS_TAIL_ZERO)begin
      _zz_84_ = execute_TAIL_ZERO_rd;
    end
    if(_zz_191_)begin
      _zz_84_ = execute_CsrPlugin_readData;
    end
    if(execute_arbitration_isValid)begin
      case(execute_SHIFT_CTRL)
        `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
          _zz_84_ = _zz_162_;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_84_ = execute_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
  end

  assign execute_IS_BSWAP_32 = decode_to_execute_IS_BSWAP_32;
  assign execute_RS1 = decode_to_execute_RS1;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  assign decode_arbitration_haltItself = 1'b0;
  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if((CsrPlugin_interrupt_valid && CsrPlugin_allowInterrupts))begin
      decode_arbitration_haltByOther = decode_arbitration_isValid;
    end
    if(({(writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),{(memory_arbitration_isValid && (memory_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),(execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET))}} != (3'b000)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if((decode_arbitration_isValid && (_zz_163_ || _zz_164_)))begin
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
    if(decodeExceptionPort_valid)begin
      decode_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if(((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! dBus_cmd_ready)) && (! execute_DBusSimplePlugin_skipCmd)) && (! _zz_131_)))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(_zz_191_)begin
      if(execute_CsrPlugin_blockedBySideEffects)begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign execute_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(BranchPlugin_branchExceptionPort_valid)begin
      execute_arbitration_removeIt = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  assign execute_arbitration_flushIt = 1'b0;
  always @ (*) begin
    execute_arbitration_flushNext = 1'b0;
    if(BranchPlugin_branchExceptionPort_valid)begin
      execute_arbitration_flushNext = 1'b1;
    end
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
    if(_zz_192_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_193_)begin
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
    if(_zz_192_)begin
      IBusSimplePlugin_fetcherHalt = 1'b1;
    end
    if(_zz_193_)begin
      IBusSimplePlugin_fetcherHalt = 1'b1;
    end
  end

  always @ (*) begin
    IBusSimplePlugin_fetcherflushIt = 1'b0;
    if(({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != (4'b0000)))begin
      IBusSimplePlugin_fetcherflushIt = 1'b1;
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

  always @ (*) begin
    CsrPlugin_jumpInterface_valid = 1'b0;
    if(_zz_192_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
    if(_zz_193_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_payload = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    if(_zz_192_)begin
      CsrPlugin_jumpInterface_payload = {CsrPlugin_xtvec_base,(2'b00)};
    end
    if(_zz_193_)begin
      case(_zz_194_)
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
  assign execute_BSWAP32_rs1 = execute_RS1;
  always @ (*) begin
    execute_BSWAP32_rd[31 : 24] = execute_BSWAP32_rs1[7 : 0];
    execute_BSWAP32_rd[23 : 16] = execute_BSWAP32_rs1[15 : 8];
    execute_BSWAP32_rd[15 : 8] = execute_BSWAP32_rs1[23 : 16];
    execute_BSWAP32_rd[7 : 0] = execute_BSWAP32_rs1[31 : 24];
  end

  assign execute_BSWAP16_rs1 = execute_RS1;
  always @ (*) begin
    execute_BSWAP16_rd[31 : 24] = execute_BSWAP16_rs1[7 : 0];
    execute_BSWAP16_rd[23 : 16] = execute_BSWAP16_rs1[15 : 8];
    execute_BSWAP16_rd[15 : 8] = execute_BSWAP16_rs1[7 : 0];
    execute_BSWAP16_rd[7 : 0] = execute_BSWAP16_rs1[15 : 8];
  end

  assign execute_TAIL_ZERO_rs1 = execute_RS1;
  assign _zz_85_ = execute_TAIL_ZERO_rs1;
  assign _zz_86_ = {(! (execute_TAIL_ZERO_rs1 != (32'b00000000000000000000000000000000))),(_zz_85_ & (~ _zz_208_))};
  assign _zz_87_ = _zz_86_[3];
  assign _zz_88_ = _zz_86_[5];
  assign _zz_89_ = _zz_86_[6];
  assign _zz_90_ = _zz_86_[7];
  assign _zz_91_ = _zz_86_[9];
  assign _zz_92_ = _zz_86_[10];
  assign _zz_93_ = _zz_86_[11];
  assign _zz_94_ = _zz_86_[12];
  assign _zz_95_ = _zz_86_[13];
  assign _zz_96_ = _zz_86_[14];
  assign _zz_97_ = _zz_86_[15];
  assign _zz_98_ = _zz_86_[17];
  assign _zz_99_ = _zz_86_[18];
  assign _zz_100_ = _zz_86_[19];
  assign _zz_101_ = _zz_86_[20];
  assign _zz_102_ = _zz_86_[21];
  assign _zz_103_ = _zz_86_[22];
  assign _zz_104_ = _zz_86_[23];
  assign _zz_105_ = _zz_86_[24];
  assign _zz_106_ = _zz_86_[25];
  assign _zz_107_ = _zz_86_[26];
  assign _zz_108_ = _zz_86_[27];
  assign _zz_109_ = _zz_86_[28];
  assign _zz_110_ = _zz_86_[29];
  assign _zz_111_ = _zz_86_[30];
  assign _zz_112_ = _zz_86_[31];
  assign _zz_113_ = _zz_86_[32];
  assign _zz_114_ = (((((((((((((((_zz_86_[1] || _zz_87_) || _zz_88_) || _zz_90_) || _zz_91_) || _zz_93_) || _zz_95_) || _zz_97_) || _zz_98_) || _zz_100_) || _zz_102_) || _zz_104_) || _zz_106_) || _zz_108_) || _zz_110_) || _zz_112_);
  assign _zz_115_ = (((((((((((((((_zz_86_[2] || _zz_87_) || _zz_89_) || _zz_90_) || _zz_92_) || _zz_93_) || _zz_96_) || _zz_97_) || _zz_99_) || _zz_100_) || _zz_103_) || _zz_104_) || _zz_107_) || _zz_108_) || _zz_111_) || _zz_112_);
  assign _zz_116_ = (((((((((((((((_zz_86_[4] || _zz_88_) || _zz_89_) || _zz_90_) || _zz_94_) || _zz_95_) || _zz_96_) || _zz_97_) || _zz_101_) || _zz_102_) || _zz_103_) || _zz_104_) || _zz_109_) || _zz_110_) || _zz_111_) || _zz_112_);
  assign _zz_117_ = (((((((((((((((_zz_86_[8] || _zz_91_) || _zz_92_) || _zz_93_) || _zz_94_) || _zz_95_) || _zz_96_) || _zz_97_) || _zz_105_) || _zz_106_) || _zz_107_) || _zz_108_) || _zz_109_) || _zz_110_) || _zz_111_) || _zz_112_);
  assign _zz_118_ = (((((((((((((((_zz_86_[16] || _zz_98_) || _zz_99_) || _zz_100_) || _zz_101_) || _zz_102_) || _zz_103_) || _zz_104_) || _zz_105_) || _zz_106_) || _zz_107_) || _zz_108_) || _zz_109_) || _zz_110_) || _zz_111_) || _zz_112_);
  always @ (*) begin
    execute_TAIL_ZERO_rd[5 : 0] = {_zz_113_,{_zz_118_,{_zz_117_,{_zz_116_,{_zz_115_,_zz_114_}}}}};
    execute_TAIL_ZERO_rd[31 : 6] = (26'b00000000000000000000000000);
  end

  assign IBusSimplePlugin_jump_pcLoad_valid = ({BranchPlugin_jumpInterface_valid,CsrPlugin_jumpInterface_valid} != (2'b00));
  assign _zz_119_ = {BranchPlugin_jumpInterface_valid,CsrPlugin_jumpInterface_valid};
  assign IBusSimplePlugin_jump_pcLoad_payload = (_zz_209_[0] ? CsrPlugin_jumpInterface_payload : BranchPlugin_jumpInterface_payload);
  always @ (*) begin
    IBusSimplePlugin_fetchPc_corrected = 1'b0;
    if(IBusSimplePlugin_jump_pcLoad_valid)begin
      IBusSimplePlugin_fetchPc_corrected = 1'b1;
    end
  end

  always @ (*) begin
    IBusSimplePlugin_fetchPc_pcRegPropagate = 1'b0;
    if(IBusSimplePlugin_iBusRsp_stages_1_input_ready)begin
      IBusSimplePlugin_fetchPc_pcRegPropagate = 1'b1;
    end
  end

  always @ (*) begin
    IBusSimplePlugin_fetchPc_pc = (IBusSimplePlugin_fetchPc_pcReg + _zz_212_);
    if(IBusSimplePlugin_jump_pcLoad_valid)begin
      IBusSimplePlugin_fetchPc_pc = IBusSimplePlugin_jump_pcLoad_payload;
    end
    IBusSimplePlugin_fetchPc_pc[0] = 1'b0;
    IBusSimplePlugin_fetchPc_pc[1] = 1'b0;
  end

  assign IBusSimplePlugin_fetchPc_output_valid = ((! IBusSimplePlugin_fetcherHalt) && IBusSimplePlugin_fetchPc_booted);
  assign IBusSimplePlugin_fetchPc_output_payload = IBusSimplePlugin_fetchPc_pc;
  assign IBusSimplePlugin_iBusRsp_stages_0_input_valid = IBusSimplePlugin_fetchPc_output_valid;
  assign IBusSimplePlugin_fetchPc_output_ready = IBusSimplePlugin_iBusRsp_stages_0_input_ready;
  assign IBusSimplePlugin_iBusRsp_stages_0_input_payload = IBusSimplePlugin_fetchPc_output_payload;
  assign IBusSimplePlugin_iBusRsp_stages_0_inputSample = 1'b1;
  always @ (*) begin
    IBusSimplePlugin_iBusRsp_stages_0_halt = 1'b0;
    if((IBusSimplePlugin_iBusRsp_stages_0_input_valid && ((! IBusSimplePlugin_cmd_valid) || (! IBusSimplePlugin_cmd_ready))))begin
      IBusSimplePlugin_iBusRsp_stages_0_halt = 1'b1;
    end
  end

  assign _zz_120_ = (! IBusSimplePlugin_iBusRsp_stages_0_halt);
  assign IBusSimplePlugin_iBusRsp_stages_0_input_ready = (IBusSimplePlugin_iBusRsp_stages_0_output_ready && _zz_120_);
  assign IBusSimplePlugin_iBusRsp_stages_0_output_valid = (IBusSimplePlugin_iBusRsp_stages_0_input_valid && _zz_120_);
  assign IBusSimplePlugin_iBusRsp_stages_0_output_payload = IBusSimplePlugin_iBusRsp_stages_0_input_payload;
  assign IBusSimplePlugin_iBusRsp_stages_1_halt = 1'b0;
  assign _zz_121_ = (! IBusSimplePlugin_iBusRsp_stages_1_halt);
  assign IBusSimplePlugin_iBusRsp_stages_1_input_ready = (IBusSimplePlugin_iBusRsp_stages_1_output_ready && _zz_121_);
  assign IBusSimplePlugin_iBusRsp_stages_1_output_valid = (IBusSimplePlugin_iBusRsp_stages_1_input_valid && _zz_121_);
  assign IBusSimplePlugin_iBusRsp_stages_1_output_payload = IBusSimplePlugin_iBusRsp_stages_1_input_payload;
  assign IBusSimplePlugin_iBusRsp_stages_0_output_ready = _zz_122_;
  assign _zz_122_ = ((1'b0 && (! _zz_123_)) || IBusSimplePlugin_iBusRsp_stages_1_input_ready);
  assign _zz_123_ = _zz_124_;
  assign IBusSimplePlugin_iBusRsp_stages_1_input_valid = _zz_123_;
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

  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_ready = ((1'b0 && (! IBusSimplePlugin_injector_decodeInput_valid)) || IBusSimplePlugin_injector_decodeInput_ready);
  assign IBusSimplePlugin_injector_decodeInput_valid = _zz_125_;
  assign IBusSimplePlugin_injector_decodeInput_payload_pc = _zz_126_;
  assign IBusSimplePlugin_injector_decodeInput_payload_rsp_error = _zz_127_;
  assign IBusSimplePlugin_injector_decodeInput_payload_rsp_inst = _zz_128_;
  assign IBusSimplePlugin_injector_decodeInput_payload_isRvc = _zz_129_;
  assign IBusSimplePlugin_pcValids_0 = IBusSimplePlugin_injector_nextPcCalc_valids_1;
  assign IBusSimplePlugin_pcValids_1 = IBusSimplePlugin_injector_nextPcCalc_valids_2;
  assign IBusSimplePlugin_pcValids_2 = IBusSimplePlugin_injector_nextPcCalc_valids_3;
  assign IBusSimplePlugin_pcValids_3 = IBusSimplePlugin_injector_nextPcCalc_valids_4;
  assign IBusSimplePlugin_injector_decodeInput_ready = (! decode_arbitration_isStuck);
  assign decode_arbitration_isValid = (IBusSimplePlugin_injector_decodeInput_valid && (! IBusSimplePlugin_injector_decodeRemoved));
  assign _zz_83_ = IBusSimplePlugin_injector_decodeInput_payload_pc;
  assign _zz_82_ = IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  assign _zz_81_ = (decode_PC + (32'b00000000000000000000000000000100));
  assign iBus_cmd_valid = IBusSimplePlugin_cmd_valid;
  assign IBusSimplePlugin_cmd_ready = iBus_cmd_ready;
  assign iBus_cmd_payload_pc = IBusSimplePlugin_cmd_payload_pc;
  assign IBusSimplePlugin_pendingCmdNext = (_zz_213_ - _zz_217_);
  assign IBusSimplePlugin_cmd_valid = ((IBusSimplePlugin_iBusRsp_stages_0_input_valid && IBusSimplePlugin_iBusRsp_stages_0_output_ready) && (IBusSimplePlugin_pendingCmd != (3'b111)));
  assign IBusSimplePlugin_cmd_payload_pc = {IBusSimplePlugin_iBusRsp_stages_0_input_payload[31 : 2],(2'b00)};
  assign iBus_rsp_takeWhen_valid = (iBus_rsp_valid && (! (IBusSimplePlugin_rspJoin_discardCounter != (3'b000))));
  assign iBus_rsp_takeWhen_payload_error = iBus_rsp_payload_error;
  assign iBus_rsp_takeWhen_payload_inst = iBus_rsp_payload_inst;
  assign IBusSimplePlugin_rspJoin_rspBufferOutput_valid = IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid;
  assign IBusSimplePlugin_rspJoin_rspBufferOutput_payload_error = IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error;
  assign IBusSimplePlugin_rspJoin_rspBufferOutput_payload_inst = IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst;
  assign IBusSimplePlugin_rspJoin_fetchRsp_pc = IBusSimplePlugin_iBusRsp_stages_1_output_payload;
  always @ (*) begin
    IBusSimplePlugin_rspJoin_fetchRsp_rsp_error = IBusSimplePlugin_rspJoin_rspBufferOutput_payload_error;
    if((! IBusSimplePlugin_rspJoin_rspBufferOutput_valid))begin
      IBusSimplePlugin_rspJoin_fetchRsp_rsp_error = 1'b0;
    end
  end

  assign IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst = IBusSimplePlugin_rspJoin_rspBufferOutput_payload_inst;
  assign IBusSimplePlugin_rspJoin_exceptionDetected = 1'b0;
  assign IBusSimplePlugin_rspJoin_redoRequired = 1'b0;
  assign IBusSimplePlugin_rspJoin_join_valid = (IBusSimplePlugin_iBusRsp_stages_1_output_valid && IBusSimplePlugin_rspJoin_rspBufferOutput_valid);
  assign IBusSimplePlugin_rspJoin_join_payload_pc = IBusSimplePlugin_rspJoin_fetchRsp_pc;
  assign IBusSimplePlugin_rspJoin_join_payload_rsp_error = IBusSimplePlugin_rspJoin_fetchRsp_rsp_error;
  assign IBusSimplePlugin_rspJoin_join_payload_rsp_inst = IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst;
  assign IBusSimplePlugin_rspJoin_join_payload_isRvc = IBusSimplePlugin_rspJoin_fetchRsp_isRvc;
  assign IBusSimplePlugin_iBusRsp_stages_1_output_ready = (IBusSimplePlugin_iBusRsp_stages_1_output_valid ? (IBusSimplePlugin_rspJoin_join_valid && IBusSimplePlugin_rspJoin_join_ready) : IBusSimplePlugin_rspJoin_join_ready);
  assign IBusSimplePlugin_rspJoin_rspBufferOutput_ready = (IBusSimplePlugin_rspJoin_join_valid && IBusSimplePlugin_rspJoin_join_ready);
  assign _zz_130_ = (! (IBusSimplePlugin_rspJoin_exceptionDetected || IBusSimplePlugin_rspJoin_redoRequired));
  assign IBusSimplePlugin_rspJoin_join_ready = (IBusSimplePlugin_iBusRsp_inputBeforeStage_ready && _zz_130_);
  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_valid = (IBusSimplePlugin_rspJoin_join_valid && _zz_130_);
  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_pc = IBusSimplePlugin_rspJoin_join_payload_pc;
  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_error = IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_inst = IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_isRvc = IBusSimplePlugin_rspJoin_join_payload_isRvc;
  assign _zz_131_ = 1'b0;
  assign _zz_79_ = (((dBus_cmd_payload_size == (2'b10)) && (dBus_cmd_payload_address[1 : 0] != (2'b00))) || ((dBus_cmd_payload_size == (2'b01)) && (dBus_cmd_payload_address[0 : 0] != (1'b0))));
  always @ (*) begin
    execute_DBusSimplePlugin_skipCmd = 1'b0;
    if(execute_ALIGNEMENT_FAULT)begin
      execute_DBusSimplePlugin_skipCmd = 1'b1;
    end
  end

  assign dBus_cmd_valid = (((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! execute_arbitration_isStuckByOthers)) && (! execute_arbitration_isFlushed)) && (! execute_DBusSimplePlugin_skipCmd)) && (! _zz_131_));
  assign dBus_cmd_payload_wr = execute_MEMORY_STORE;
  assign dBus_cmd_payload_size = execute_INSTRUCTION[13 : 12];
  always @ (*) begin
    case(dBus_cmd_payload_size)
      2'b00 : begin
        _zz_132_ = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_132_ = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_132_ = execute_RS2[31 : 0];
      end
    endcase
  end

  assign dBus_cmd_payload_data = _zz_132_;
  assign _zz_78_ = dBus_cmd_payload_address[1 : 0];
  always @ (*) begin
    case(dBus_cmd_payload_size)
      2'b00 : begin
        _zz_133_ = (4'b0001);
      end
      2'b01 : begin
        _zz_133_ = (4'b0011);
      end
      default : begin
        _zz_133_ = (4'b1111);
      end
    endcase
  end

  assign execute_DBusSimplePlugin_formalMask = (_zz_133_ <<< dBus_cmd_payload_address[1 : 0]);
  assign dBus_cmd_payload_address = execute_SRC_ADD;
  assign _zz_77_ = dBus_rsp_data;
  always @ (*) begin
    DBusSimplePlugin_memoryExceptionPort_valid = 1'b0;
    if(_zz_195_)begin
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
    if(_zz_195_)begin
      DBusSimplePlugin_memoryExceptionPort_payload_code = (4'b0101);
    end
    if(memory_ALIGNEMENT_FAULT)begin
      DBusSimplePlugin_memoryExceptionPort_payload_code = {1'd0, _zz_222_};
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

  assign _zz_134_ = (memory_DBusSimplePlugin_rspShifted[7] && (! memory_INSTRUCTION[14]));
  always @ (*) begin
    _zz_135_[31] = _zz_134_;
    _zz_135_[30] = _zz_134_;
    _zz_135_[29] = _zz_134_;
    _zz_135_[28] = _zz_134_;
    _zz_135_[27] = _zz_134_;
    _zz_135_[26] = _zz_134_;
    _zz_135_[25] = _zz_134_;
    _zz_135_[24] = _zz_134_;
    _zz_135_[23] = _zz_134_;
    _zz_135_[22] = _zz_134_;
    _zz_135_[21] = _zz_134_;
    _zz_135_[20] = _zz_134_;
    _zz_135_[19] = _zz_134_;
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
    _zz_135_[7 : 0] = memory_DBusSimplePlugin_rspShifted[7 : 0];
  end

  assign _zz_136_ = (memory_DBusSimplePlugin_rspShifted[15] && (! memory_INSTRUCTION[14]));
  always @ (*) begin
    _zz_137_[31] = _zz_136_;
    _zz_137_[30] = _zz_136_;
    _zz_137_[29] = _zz_136_;
    _zz_137_[28] = _zz_136_;
    _zz_137_[27] = _zz_136_;
    _zz_137_[26] = _zz_136_;
    _zz_137_[25] = _zz_136_;
    _zz_137_[24] = _zz_136_;
    _zz_137_[23] = _zz_136_;
    _zz_137_[22] = _zz_136_;
    _zz_137_[21] = _zz_136_;
    _zz_137_[20] = _zz_136_;
    _zz_137_[19] = _zz_136_;
    _zz_137_[18] = _zz_136_;
    _zz_137_[17] = _zz_136_;
    _zz_137_[16] = _zz_136_;
    _zz_137_[15 : 0] = memory_DBusSimplePlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_206_)
      2'b00 : begin
        memory_DBusSimplePlugin_rspFormated = _zz_135_;
      end
      2'b01 : begin
        memory_DBusSimplePlugin_rspFormated = _zz_137_;
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
  assign CsrPlugin_misa_extensions = (26'b00000000000000000001000010);
  assign CsrPlugin_mtvec_mode = (2'b00);
  assign CsrPlugin_mtvec_base = (30'b000000000000000000000000000001);
  assign _zz_138_ = (CsrPlugin_mip_MTIP && CsrPlugin_mie_MTIE);
  assign _zz_139_ = (CsrPlugin_mip_MSIP && CsrPlugin_mie_MSIE);
  assign _zz_140_ = (CsrPlugin_mip_MEIP && CsrPlugin_mie_MEIE);
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
    if(BranchPlugin_branchExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b1;
    end
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
  always @ (*) begin
    CsrPlugin_pipelineLiberator_done = ((! ({writeBack_arbitration_isValid,{memory_arbitration_isValid,execute_arbitration_isValid}} != (3'b000))) && IBusSimplePlugin_pcValids_3);
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
    CsrPlugin_xtvec_base = (30'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_base = CsrPlugin_mtvec_base;
      end
      default : begin
      end
    endcase
  end

  assign contextSwitching = CsrPlugin_jumpInterface_valid;
  assign _zz_74_ = (! (((decode_INSTRUCTION[14 : 13] == (2'b01)) && (decode_INSTRUCTION[19 : 15] == (5'b00000))) || ((decode_INSTRUCTION[14 : 13] == (2'b11)) && (decode_INSTRUCTION[19 : 15] == (5'b00000)))));
  assign _zz_73_ = (decode_INSTRUCTION[13 : 7] != (7'b0100000));
  assign execute_CsrPlugin_inWfi = 1'b0;
  assign execute_CsrPlugin_blockedBySideEffects = ({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00));
  always @ (*) begin
    execute_CsrPlugin_illegalAccess = 1'b1;
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001100000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000010 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      default : begin
      end
    endcase
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

  always @ (*) begin
    execute_CsrPlugin_readData = (32'b00000000000000000000000000000000);
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
        execute_CsrPlugin_readData[12 : 11] = CsrPlugin_mstatus_MPP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mstatus_MPIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mstatus_MIE;
      end
      12'b001101000100 : begin
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mip_MEIP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mip_MTIP;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mip_MSIP;
      end
      12'b001100000100 : begin
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mie_MEIE;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mie_MTIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mie_MSIE;
      end
      12'b001101000010 : begin
        execute_CsrPlugin_readData[31 : 31] = CsrPlugin_mcause_interrupt;
        execute_CsrPlugin_readData[3 : 0] = CsrPlugin_mcause_exceptionCode;
      end
      default : begin
      end
    endcase
  end

  assign execute_CsrPlugin_writeInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_WRITE_OPCODE);
  assign execute_CsrPlugin_readInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_READ_OPCODE);
  assign execute_CsrPlugin_writeEnable = ((execute_CsrPlugin_writeInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readEnable = ((execute_CsrPlugin_readInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readToWriteData = execute_CsrPlugin_readData;
  always @ (*) begin
    case(_zz_207_)
      1'b0 : begin
        execute_CsrPlugin_writeData = execute_SRC1;
      end
      default : begin
        execute_CsrPlugin_writeData = (execute_INSTRUCTION[12] ? (execute_CsrPlugin_readToWriteData & (~ execute_SRC1)) : (execute_CsrPlugin_readToWriteData | execute_SRC1));
      end
    endcase
  end

  assign execute_CsrPlugin_csrAddress = execute_INSTRUCTION[31 : 20];
  assign _zz_142_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001001000)) == (32'b00000000000000000000000001001000));
  assign _zz_143_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001010000)) == (32'b00000000000000000000000000010000));
  assign _zz_144_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000000100)) == (32'b00000000000000000000000000000100));
  assign _zz_145_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001010000)) == (32'b00000000000000000100000001010000));
  assign _zz_141_ = {({(_zz_261_ == _zz_262_),_zz_145_} != (2'b00)),{({_zz_263_,_zz_145_} != (2'b00)),{(_zz_143_ != (1'b0)),{(_zz_264_ != _zz_265_),{_zz_266_,{_zz_267_,_zz_268_}}}}}};
  assign _zz_70_ = ({((decode_INSTRUCTION & (32'b00000000000000000000000001011111)) == (32'b00000000000000000000000000010111)),{((decode_INSTRUCTION & (32'b00000000000000000000000001111111)) == (32'b00000000000000000000000001101111)),{((decode_INSTRUCTION & (32'b00000000000000000001000001101111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_367_) == (32'b00000000000000000001000001110011)),{(_zz_368_ == _zz_369_),{_zz_370_,{_zz_371_,_zz_372_}}}}}}} != (20'b00000000000000000000));
  assign _zz_146_ = _zz_141_[0 : 0];
  assign _zz_69_ = _zz_146_;
  assign _zz_147_ = _zz_141_[2 : 1];
  assign _zz_68_ = _zz_147_;
  assign _zz_67_ = _zz_223_[0];
  assign _zz_66_ = _zz_224_[0];
  assign _zz_65_ = _zz_225_[0];
  assign _zz_148_ = _zz_141_[7 : 6];
  assign _zz_64_ = _zz_148_;
  assign _zz_63_ = _zz_226_[0];
  assign _zz_149_ = _zz_141_[10 : 9];
  assign _zz_62_ = _zz_149_;
  assign _zz_61_ = _zz_227_[0];
  assign _zz_60_ = _zz_228_[0];
  assign _zz_59_ = _zz_229_[0];
  assign _zz_58_ = _zz_230_[0];
  assign _zz_57_ = _zz_231_[0];
  assign _zz_56_ = _zz_232_[0];
  assign _zz_150_ = _zz_141_[19 : 18];
  assign _zz_55_ = _zz_150_;
  assign _zz_54_ = _zz_233_[0];
  assign _zz_151_ = _zz_141_[22 : 21];
  assign _zz_53_ = _zz_151_;
  assign _zz_52_ = _zz_234_[0];
  assign _zz_51_ = _zz_235_[0];
  assign _zz_50_ = _zz_236_[0];
  assign _zz_152_ = _zz_141_[27 : 26];
  assign _zz_49_ = _zz_152_;
  assign decodeExceptionPort_valid = ((decode_arbitration_isValid && decode_INSTRUCTION_READY) && (! decode_LEGAL_INSTRUCTION));
  assign decodeExceptionPort_payload_code = (4'b0010);
  assign decodeExceptionPort_payload_badAddr = decode_INSTRUCTION;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION[24 : 20];
  assign decode_RegFilePlugin_rs1Data = _zz_185_;
  assign decode_RegFilePlugin_rs2Data = _zz_186_;
  assign _zz_48_ = decode_RegFilePlugin_rs1Data;
  assign _zz_47_ = decode_RegFilePlugin_rs2Data;
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_45_ && writeBack_arbitration_isFiring);
    if(_zz_153_)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  assign lastStageRegFileWrite_payload_address = _zz_44_[11 : 7];
  assign lastStageRegFileWrite_payload_data = _zz_43_;
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
        _zz_154_ = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_154_ = {31'd0, _zz_237_};
      end
      default : begin
        _zz_154_ = execute_SRC_ADD_SUB;
      end
    endcase
  end

  assign _zz_41_ = _zz_154_;
  assign _zz_39_ = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_155_ = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_155_ = {29'd0, _zz_238_};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_155_ = {execute_INSTRUCTION[31 : 12],(12'b000000000000)};
      end
      default : begin
        _zz_155_ = {27'd0, _zz_239_};
      end
    endcase
  end

  assign _zz_38_ = _zz_155_;
  assign _zz_156_ = _zz_240_[11];
  always @ (*) begin
    _zz_157_[19] = _zz_156_;
    _zz_157_[18] = _zz_156_;
    _zz_157_[17] = _zz_156_;
    _zz_157_[16] = _zz_156_;
    _zz_157_[15] = _zz_156_;
    _zz_157_[14] = _zz_156_;
    _zz_157_[13] = _zz_156_;
    _zz_157_[12] = _zz_156_;
    _zz_157_[11] = _zz_156_;
    _zz_157_[10] = _zz_156_;
    _zz_157_[9] = _zz_156_;
    _zz_157_[8] = _zz_156_;
    _zz_157_[7] = _zz_156_;
    _zz_157_[6] = _zz_156_;
    _zz_157_[5] = _zz_156_;
    _zz_157_[4] = _zz_156_;
    _zz_157_[3] = _zz_156_;
    _zz_157_[2] = _zz_156_;
    _zz_157_[1] = _zz_156_;
    _zz_157_[0] = _zz_156_;
  end

  assign _zz_158_ = _zz_241_[11];
  always @ (*) begin
    _zz_159_[19] = _zz_158_;
    _zz_159_[18] = _zz_158_;
    _zz_159_[17] = _zz_158_;
    _zz_159_[16] = _zz_158_;
    _zz_159_[15] = _zz_158_;
    _zz_159_[14] = _zz_158_;
    _zz_159_[13] = _zz_158_;
    _zz_159_[12] = _zz_158_;
    _zz_159_[11] = _zz_158_;
    _zz_159_[10] = _zz_158_;
    _zz_159_[9] = _zz_158_;
    _zz_159_[8] = _zz_158_;
    _zz_159_[7] = _zz_158_;
    _zz_159_[6] = _zz_158_;
    _zz_159_[5] = _zz_158_;
    _zz_159_[4] = _zz_158_;
    _zz_159_[3] = _zz_158_;
    _zz_159_[2] = _zz_158_;
    _zz_159_[1] = _zz_158_;
    _zz_159_[0] = _zz_158_;
  end

  always @ (*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_160_ = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_160_ = {_zz_157_,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_160_ = {_zz_159_,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_160_ = _zz_34_;
      end
    endcase
  end

  assign _zz_36_ = _zz_160_;
  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_242_;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign _zz_33_ = execute_SrcPlugin_addSub;
  assign _zz_32_ = execute_SrcPlugin_addSub;
  assign _zz_31_ = execute_SrcPlugin_less;
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_161_[0] = execute_SRC1[31];
    _zz_161_[1] = execute_SRC1[30];
    _zz_161_[2] = execute_SRC1[29];
    _zz_161_[3] = execute_SRC1[28];
    _zz_161_[4] = execute_SRC1[27];
    _zz_161_[5] = execute_SRC1[26];
    _zz_161_[6] = execute_SRC1[25];
    _zz_161_[7] = execute_SRC1[24];
    _zz_161_[8] = execute_SRC1[23];
    _zz_161_[9] = execute_SRC1[22];
    _zz_161_[10] = execute_SRC1[21];
    _zz_161_[11] = execute_SRC1[20];
    _zz_161_[12] = execute_SRC1[19];
    _zz_161_[13] = execute_SRC1[18];
    _zz_161_[14] = execute_SRC1[17];
    _zz_161_[15] = execute_SRC1[16];
    _zz_161_[16] = execute_SRC1[15];
    _zz_161_[17] = execute_SRC1[14];
    _zz_161_[18] = execute_SRC1[13];
    _zz_161_[19] = execute_SRC1[12];
    _zz_161_[20] = execute_SRC1[11];
    _zz_161_[21] = execute_SRC1[10];
    _zz_161_[22] = execute_SRC1[9];
    _zz_161_[23] = execute_SRC1[8];
    _zz_161_[24] = execute_SRC1[7];
    _zz_161_[25] = execute_SRC1[6];
    _zz_161_[26] = execute_SRC1[5];
    _zz_161_[27] = execute_SRC1[4];
    _zz_161_[28] = execute_SRC1[3];
    _zz_161_[29] = execute_SRC1[2];
    _zz_161_[30] = execute_SRC1[1];
    _zz_161_[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_161_ : execute_SRC1);
  assign _zz_29_ = _zz_250_;
  always @ (*) begin
    _zz_162_[0] = execute_SHIFT_RIGHT[31];
    _zz_162_[1] = execute_SHIFT_RIGHT[30];
    _zz_162_[2] = execute_SHIFT_RIGHT[29];
    _zz_162_[3] = execute_SHIFT_RIGHT[28];
    _zz_162_[4] = execute_SHIFT_RIGHT[27];
    _zz_162_[5] = execute_SHIFT_RIGHT[26];
    _zz_162_[6] = execute_SHIFT_RIGHT[25];
    _zz_162_[7] = execute_SHIFT_RIGHT[24];
    _zz_162_[8] = execute_SHIFT_RIGHT[23];
    _zz_162_[9] = execute_SHIFT_RIGHT[22];
    _zz_162_[10] = execute_SHIFT_RIGHT[21];
    _zz_162_[11] = execute_SHIFT_RIGHT[20];
    _zz_162_[12] = execute_SHIFT_RIGHT[19];
    _zz_162_[13] = execute_SHIFT_RIGHT[18];
    _zz_162_[14] = execute_SHIFT_RIGHT[17];
    _zz_162_[15] = execute_SHIFT_RIGHT[16];
    _zz_162_[16] = execute_SHIFT_RIGHT[15];
    _zz_162_[17] = execute_SHIFT_RIGHT[14];
    _zz_162_[18] = execute_SHIFT_RIGHT[13];
    _zz_162_[19] = execute_SHIFT_RIGHT[12];
    _zz_162_[20] = execute_SHIFT_RIGHT[11];
    _zz_162_[21] = execute_SHIFT_RIGHT[10];
    _zz_162_[22] = execute_SHIFT_RIGHT[9];
    _zz_162_[23] = execute_SHIFT_RIGHT[8];
    _zz_162_[24] = execute_SHIFT_RIGHT[7];
    _zz_162_[25] = execute_SHIFT_RIGHT[6];
    _zz_162_[26] = execute_SHIFT_RIGHT[5];
    _zz_162_[27] = execute_SHIFT_RIGHT[4];
    _zz_162_[28] = execute_SHIFT_RIGHT[3];
    _zz_162_[29] = execute_SHIFT_RIGHT[2];
    _zz_162_[30] = execute_SHIFT_RIGHT[1];
    _zz_162_[31] = execute_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    _zz_163_ = 1'b0;
    if(_zz_196_)begin
      if(_zz_197_)begin
        if(_zz_169_)begin
          _zz_163_ = 1'b1;
        end
      end
    end
    if(_zz_198_)begin
      if(_zz_199_)begin
        if(_zz_171_)begin
          _zz_163_ = 1'b1;
        end
      end
    end
    if(_zz_200_)begin
      if(_zz_201_)begin
        if(_zz_173_)begin
          _zz_163_ = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_163_ = 1'b0;
    end
  end

  always @ (*) begin
    _zz_164_ = 1'b0;
    if(_zz_196_)begin
      if(_zz_197_)begin
        if(_zz_170_)begin
          _zz_164_ = 1'b1;
        end
      end
    end
    if(_zz_198_)begin
      if(_zz_199_)begin
        if(_zz_172_)begin
          _zz_164_ = 1'b1;
        end
      end
    end
    if(_zz_200_)begin
      if(_zz_201_)begin
        if(_zz_174_)begin
          _zz_164_ = 1'b1;
        end
      end
    end
    if((! decode_RS2_USE))begin
      _zz_164_ = 1'b0;
    end
  end

  assign _zz_165_ = (_zz_45_ && writeBack_arbitration_isFiring);
  assign _zz_169_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_170_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_171_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_172_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_173_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_174_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_175_ = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_175_ == (3'b000))) begin
        _zz_176_ = execute_BranchPlugin_eq;
    end else if((_zz_175_ == (3'b001))) begin
        _zz_176_ = (! execute_BranchPlugin_eq);
    end else if((((_zz_175_ & (3'b101)) == (3'b101)))) begin
        _zz_176_ = (! execute_SRC_LESS);
    end else begin
        _zz_176_ = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_177_ = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_177_ = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_177_ = 1'b1;
      end
      default : begin
        _zz_177_ = _zz_176_;
      end
    endcase
  end

  assign _zz_28_ = _zz_177_;
  assign execute_BranchPlugin_branch_src1 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JALR) ? execute_RS1 : execute_PC);
  assign _zz_178_ = _zz_252_[19];
  always @ (*) begin
    _zz_179_[10] = _zz_178_;
    _zz_179_[9] = _zz_178_;
    _zz_179_[8] = _zz_178_;
    _zz_179_[7] = _zz_178_;
    _zz_179_[6] = _zz_178_;
    _zz_179_[5] = _zz_178_;
    _zz_179_[4] = _zz_178_;
    _zz_179_[3] = _zz_178_;
    _zz_179_[2] = _zz_178_;
    _zz_179_[1] = _zz_178_;
    _zz_179_[0] = _zz_178_;
  end

  assign _zz_180_ = _zz_253_[11];
  always @ (*) begin
    _zz_181_[19] = _zz_180_;
    _zz_181_[18] = _zz_180_;
    _zz_181_[17] = _zz_180_;
    _zz_181_[16] = _zz_180_;
    _zz_181_[15] = _zz_180_;
    _zz_181_[14] = _zz_180_;
    _zz_181_[13] = _zz_180_;
    _zz_181_[12] = _zz_180_;
    _zz_181_[11] = _zz_180_;
    _zz_181_[10] = _zz_180_;
    _zz_181_[9] = _zz_180_;
    _zz_181_[8] = _zz_180_;
    _zz_181_[7] = _zz_180_;
    _zz_181_[6] = _zz_180_;
    _zz_181_[5] = _zz_180_;
    _zz_181_[4] = _zz_180_;
    _zz_181_[3] = _zz_180_;
    _zz_181_[2] = _zz_180_;
    _zz_181_[1] = _zz_180_;
    _zz_181_[0] = _zz_180_;
  end

  assign _zz_182_ = _zz_254_[11];
  always @ (*) begin
    _zz_183_[18] = _zz_182_;
    _zz_183_[17] = _zz_182_;
    _zz_183_[16] = _zz_182_;
    _zz_183_[15] = _zz_182_;
    _zz_183_[14] = _zz_182_;
    _zz_183_[13] = _zz_182_;
    _zz_183_[12] = _zz_182_;
    _zz_183_[11] = _zz_182_;
    _zz_183_[10] = _zz_182_;
    _zz_183_[9] = _zz_182_;
    _zz_183_[8] = _zz_182_;
    _zz_183_[7] = _zz_182_;
    _zz_183_[6] = _zz_182_;
    _zz_183_[5] = _zz_182_;
    _zz_183_[4] = _zz_182_;
    _zz_183_[3] = _zz_182_;
    _zz_183_[2] = _zz_182_;
    _zz_183_[1] = _zz_182_;
    _zz_183_[0] = _zz_182_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_184_ = {{_zz_179_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_184_ = {_zz_181_,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        _zz_184_ = {{_zz_183_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
      end
    endcase
  end

  assign execute_BranchPlugin_branch_src2 = _zz_184_;
  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign _zz_26_ = {execute_BranchPlugin_branchAdder[31 : 1],(1'b0)};
  assign BranchPlugin_jumpInterface_valid = ((execute_arbitration_isValid && execute_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = execute_BRANCH_CALC;
  always @ (*) begin
    BranchPlugin_branchExceptionPort_valid = ((execute_arbitration_isValid && execute_BRANCH_DO) && BranchPlugin_jumpInterface_payload[1]);
    if(1'b0)begin
      BranchPlugin_branchExceptionPort_valid = 1'b0;
    end
  end

  assign BranchPlugin_branchExceptionPort_payload_code = (4'b0000);
  assign BranchPlugin_branchExceptionPort_payload_badAddr = BranchPlugin_jumpInterface_payload;
  assign _zz_25_ = decode_SHIFT_CTRL;
  assign _zz_23_ = _zz_62_;
  assign _zz_30_ = decode_to_execute_SHIFT_CTRL;
  assign _zz_22_ = decode_ALU_CTRL;
  assign _zz_20_ = _zz_64_;
  assign _zz_40_ = decode_to_execute_ALU_CTRL;
  assign _zz_19_ = decode_BRANCH_CTRL;
  assign _zz_17_ = _zz_68_;
  assign _zz_27_ = decode_to_execute_BRANCH_CTRL;
  assign _zz_16_ = decode_ENV_CTRL;
  assign _zz_13_ = execute_ENV_CTRL;
  assign _zz_11_ = memory_ENV_CTRL;
  assign _zz_14_ = _zz_69_;
  assign _zz_72_ = decode_to_execute_ENV_CTRL;
  assign _zz_71_ = execute_to_memory_ENV_CTRL;
  assign _zz_75_ = memory_to_writeBack_ENV_CTRL;
  assign _zz_9_ = decode_SRC1_CTRL;
  assign _zz_7_ = _zz_49_;
  assign _zz_37_ = decode_to_execute_SRC1_CTRL;
  assign _zz_6_ = decode_ALU_BITWISE_CTRL;
  assign _zz_4_ = _zz_55_;
  assign _zz_42_ = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_3_ = decode_SRC2_CTRL;
  assign _zz_1_ = _zz_53_;
  assign _zz_35_ = decode_to_execute_SRC2_CTRL;
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
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      IBusSimplePlugin_fetchPc_pcReg <= (32'b00000000000000000000000000000000);
      IBusSimplePlugin_fetchPc_booted <= 1'b0;
      IBusSimplePlugin_fetchPc_inc <= 1'b0;
      _zz_124_ <= 1'b0;
      _zz_125_ <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusSimplePlugin_injector_decodeRemoved <= 1'b0;
      IBusSimplePlugin_pendingCmd <= (3'b000);
      IBusSimplePlugin_rspJoin_discardCounter <= (3'b000);
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
      CsrPlugin_hadException <= 1'b0;
      execute_CsrPlugin_wfiWake <= 1'b0;
      _zz_153_ <= 1'b1;
      _zz_166_ <= 1'b0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      memory_to_writeBack_REGFILE_WRITE_DATA <= (32'b00000000000000000000000000000000);
      memory_to_writeBack_INSTRUCTION <= (32'b00000000000000000000000000000000);
    end else begin
      IBusSimplePlugin_fetchPc_booted <= 1'b1;
      if((IBusSimplePlugin_fetchPc_corrected || IBusSimplePlugin_fetchPc_pcRegPropagate))begin
        IBusSimplePlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusSimplePlugin_fetchPc_output_valid && IBusSimplePlugin_fetchPc_output_ready))begin
        IBusSimplePlugin_fetchPc_inc <= 1'b1;
      end
      if(((! IBusSimplePlugin_fetchPc_output_valid) && IBusSimplePlugin_fetchPc_output_ready))begin
        IBusSimplePlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusSimplePlugin_fetchPc_booted && ((IBusSimplePlugin_fetchPc_output_ready || IBusSimplePlugin_fetcherflushIt) || IBusSimplePlugin_fetchPc_pcRegPropagate)))begin
        IBusSimplePlugin_fetchPc_pcReg <= IBusSimplePlugin_fetchPc_pc;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        _zz_124_ <= 1'b0;
      end
      if(_zz_122_)begin
        _zz_124_ <= IBusSimplePlugin_iBusRsp_stages_0_output_valid;
      end
      if(IBusSimplePlugin_iBusRsp_inputBeforeStage_ready)begin
        _zz_125_ <= IBusSimplePlugin_iBusRsp_inputBeforeStage_valid;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        _zz_125_ <= 1'b0;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if((! (! IBusSimplePlugin_iBusRsp_stages_1_input_ready)))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if((! (! IBusSimplePlugin_injector_decodeInput_ready)))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= IBusSimplePlugin_injector_nextPcCalc_valids_0;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if((! execute_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= IBusSimplePlugin_injector_nextPcCalc_valids_1;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= IBusSimplePlugin_injector_nextPcCalc_valids_2;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if((! writeBack_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= IBusSimplePlugin_injector_nextPcCalc_valids_3;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if(decode_arbitration_removeIt)begin
        IBusSimplePlugin_injector_decodeRemoved <= 1'b1;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_decodeRemoved <= 1'b0;
      end
      IBusSimplePlugin_pendingCmd <= IBusSimplePlugin_pendingCmdNext;
      IBusSimplePlugin_rspJoin_discardCounter <= (IBusSimplePlugin_rspJoin_discardCounter - _zz_219_);
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_rspJoin_discardCounter <= (IBusSimplePlugin_pendingCmd - _zz_221_);
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
      if(_zz_202_)begin
        if(_zz_203_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_204_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_205_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
      end
      CsrPlugin_hadException <= CsrPlugin_exception;
      if(_zz_192_)begin
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
      if(_zz_193_)begin
        case(_zz_194_)
          2'b11 : begin
            CsrPlugin_mstatus_MPP <= (2'b00);
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= 1'b1;
          end
          default : begin
          end
        endcase
      end
      execute_CsrPlugin_wfiWake <= ({_zz_140_,{_zz_139_,_zz_138_}} != (3'b000));
      _zz_153_ <= 1'b0;
      _zz_166_ <= _zz_165_;
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_76_;
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
      case(execute_CsrPlugin_csrAddress)
        12'b001100000000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mstatus_MPP <= execute_CsrPlugin_writeData[12 : 11];
            CsrPlugin_mstatus_MPIE <= _zz_255_[0];
            CsrPlugin_mstatus_MIE <= _zz_256_[0];
          end
        end
        12'b001101000100 : begin
        end
        12'b001100000100 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mie_MEIE <= _zz_258_[0];
            CsrPlugin_mie_MTIE <= _zz_259_[0];
            CsrPlugin_mie_MSIE <= _zz_260_[0];
          end
        end
        12'b001101000010 : begin
        end
        default : begin
        end
      endcase
    end
  end

  always @ (posedge clk) begin
    if(IBusSimplePlugin_iBusRsp_inputBeforeStage_ready)begin
      _zz_126_ <= IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_pc;
      _zz_127_ <= IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_error;
      _zz_128_ <= IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_inst;
      _zz_129_ <= IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_isRvc;
    end
    if(IBusSimplePlugin_injector_decodeInput_ready)begin
      IBusSimplePlugin_injector_formal_rawInDecode <= IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_inst;
    end
    if(!(! (((dBus_rsp_ready && memory_MEMORY_ENABLE) && memory_arbitration_isValid) && memory_arbitration_isStuck))) begin
      $display("ERROR DBusSimplePlugin doesn't allow memory stage stall when read happend");
    end
    CsrPlugin_mip_MEIP <= externalInterrupt;
    CsrPlugin_mip_MTIP <= timerInterrupt;
    CsrPlugin_mip_MSIP <= softwareInterrupt;
    CsrPlugin_mcycle <= (CsrPlugin_mcycle + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    if(writeBack_arbitration_isFiring)begin
      CsrPlugin_minstret <= (CsrPlugin_minstret + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    end
    if(decodeExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= decodeExceptionPort_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= decodeExceptionPort_payload_badAddr;
    end
    if(BranchPlugin_branchExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= BranchPlugin_branchExceptionPort_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= BranchPlugin_branchExceptionPort_payload_badAddr;
    end
    if(DBusSimplePlugin_memoryExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= DBusSimplePlugin_memoryExceptionPort_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= DBusSimplePlugin_memoryExceptionPort_payload_badAddr;
    end
    if(_zz_202_)begin
      if(_zz_203_)begin
        CsrPlugin_interrupt_code <= (4'b0111);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_204_)begin
        CsrPlugin_interrupt_code <= (4'b0011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_205_)begin
        CsrPlugin_interrupt_code <= (4'b1011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
    end
    if(_zz_192_)begin
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
    if(_zz_165_)begin
      _zz_167_ <= _zz_44_[11 : 7];
      _zz_168_ <= _zz_43_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_24_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_21_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ALIGNEMENT_FAULT <= execute_ALIGNEMENT_FAULT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_STORE <= decode_MEMORY_STORE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_STORE <= execute_MEMORY_STORE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_TAIL_ZERO <= decode_IS_TAIL_ZERO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_18_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_84_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= decode_RS2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ENV_CTRL <= _zz_15_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ENV_CTRL <= _zz_12_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_ENV_CTRL <= _zz_10_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_8_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= decode_FORMAL_PC_NEXT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= _zz_80_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= memory_FORMAL_PC_NEXT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_5_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CSR <= decode_IS_CSR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_BSWAP_16 <= decode_IS_BSWAP_16;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_2_;
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
      decode_to_execute_IS_BSWAP_32 <= decode_IS_BSWAP_32;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= decode_PC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= _zz_34_;
    end
    if(((! writeBack_arbitration_isStuck) && (! CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack)))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
      end
      12'b001101000100 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mip_MSIP <= _zz_257_[0];
        end
      end
      12'b001100000100 : begin
      end
      12'b001101000010 : begin
      end
      default : begin
      end
    endcase
  end

endmodule

