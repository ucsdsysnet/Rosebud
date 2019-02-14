// Generator : SpinalHDL v1.3.1    git head : 9fe87c98746a5306cb1d5a828db7af3137723649
// Date      : 13/02/2019, 21:20:31
// Component : VexRiscv


`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

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

`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

`define EnvCtrlEnum_defaultEncoding_type [0:0]
`define EnvCtrlEnum_defaultEncoding_NONE 1'b0
`define EnvCtrlEnum_defaultEncoding_XRET 1'b1

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10
`define AluBitwiseCtrlEnum_defaultEncoding_SRC1 2'b11

`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11

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
  wire [0:0] _zz_5_;
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
  assign _zz_5_ = _zz_2_[0 : 0];
  always @ (*) begin
    _zz_1_ = 1'b0;
    pushPtr_willIncrement = 1'b0;
    if(pushing)begin
      _zz_1_ = 1'b1;
      pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    pushPtr_willClear = 1'b0;
    popPtr_willClear = 1'b0;
    if(io_flush)begin
      pushPtr_willClear = 1'b1;
      popPtr_willClear = 1'b1;
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

  assign popPtr_willOverflowIfInc = 1'b1;
  assign popPtr_willOverflow = (popPtr_willOverflowIfInc && popPtr_willIncrement);
  assign ptrMatch = 1'b1;
  assign empty = (ptrMatch && (! risingOccupancy));
  assign full = (ptrMatch && risingOccupancy);
  assign pushing = (io_push_valid && io_push_ready);
  assign popping = (io_pop_valid && io_pop_ready);
  assign io_push_ready = (! full);
  always @ (*) begin
    if((! empty))begin
      io_pop_valid = 1'b1;
      io_pop_payload_error = _zz_5_[0];
      io_pop_payload_inst = _zz_2_[32 : 1];
    end else begin
      io_pop_valid = io_push_valid;
      io_pop_payload_error = io_push_payload_error;
      io_pop_payload_inst = io_push_payload_inst;
    end
  end

  assign _zz_2_ = _zz_3_;
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
  wire  _zz_157_;
  wire [31:0] _zz_158_;
  wire [31:0] _zz_159_;
  wire  IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready;
  wire  IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid;
  wire  IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error;
  wire [31:0] IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst;
  wire [0:0] IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy;
  wire  _zz_160_;
  wire  _zz_161_;
  wire  _zz_162_;
  wire [1:0] _zz_163_;
  wire [1:0] _zz_164_;
  wire  _zz_165_;
  wire [1:0] _zz_166_;
  wire [1:0] _zz_167_;
  wire [2:0] _zz_168_;
  wire [31:0] _zz_169_;
  wire [2:0] _zz_170_;
  wire [0:0] _zz_171_;
  wire [2:0] _zz_172_;
  wire [0:0] _zz_173_;
  wire [2:0] _zz_174_;
  wire [0:0] _zz_175_;
  wire [2:0] _zz_176_;
  wire [0:0] _zz_177_;
  wire [2:0] _zz_178_;
  wire [2:0] _zz_179_;
  wire [1:0] _zz_180_;
  wire [1:0] _zz_181_;
  wire [0:0] _zz_182_;
  wire [0:0] _zz_183_;
  wire [0:0] _zz_184_;
  wire [0:0] _zz_185_;
  wire [0:0] _zz_186_;
  wire [0:0] _zz_187_;
  wire [0:0] _zz_188_;
  wire [0:0] _zz_189_;
  wire [0:0] _zz_190_;
  wire [0:0] _zz_191_;
  wire [2:0] _zz_192_;
  wire [4:0] _zz_193_;
  wire [11:0] _zz_194_;
  wire [11:0] _zz_195_;
  wire [31:0] _zz_196_;
  wire [31:0] _zz_197_;
  wire [31:0] _zz_198_;
  wire [31:0] _zz_199_;
  wire [1:0] _zz_200_;
  wire [31:0] _zz_201_;
  wire [1:0] _zz_202_;
  wire [1:0] _zz_203_;
  wire [32:0] _zz_204_;
  wire [31:0] _zz_205_;
  wire [32:0] _zz_206_;
  wire [19:0] _zz_207_;
  wire [11:0] _zz_208_;
  wire [11:0] _zz_209_;
  wire [0:0] _zz_210_;
  wire [0:0] _zz_211_;
  wire [0:0] _zz_212_;
  wire [0:0] _zz_213_;
  wire [0:0] _zz_214_;
  wire [0:0] _zz_215_;
  wire [31:0] _zz_216_;
  wire [31:0] _zz_217_;
  wire  _zz_218_;
  wire  _zz_219_;
  wire  _zz_220_;
  wire [0:0] _zz_221_;
  wire [0:0] _zz_222_;
  wire [1:0] _zz_223_;
  wire [1:0] _zz_224_;
  wire  _zz_225_;
  wire [0:0] _zz_226_;
  wire [16:0] _zz_227_;
  wire [31:0] _zz_228_;
  wire [31:0] _zz_229_;
  wire [31:0] _zz_230_;
  wire [0:0] _zz_231_;
  wire [0:0] _zz_232_;
  wire [1:0] _zz_233_;
  wire [1:0] _zz_234_;
  wire  _zz_235_;
  wire [0:0] _zz_236_;
  wire [13:0] _zz_237_;
  wire [31:0] _zz_238_;
  wire [31:0] _zz_239_;
  wire  _zz_240_;
  wire  _zz_241_;
  wire [0:0] _zz_242_;
  wire [0:0] _zz_243_;
  wire [1:0] _zz_244_;
  wire [1:0] _zz_245_;
  wire  _zz_246_;
  wire [0:0] _zz_247_;
  wire [9:0] _zz_248_;
  wire [31:0] _zz_249_;
  wire [31:0] _zz_250_;
  wire [31:0] _zz_251_;
  wire [31:0] _zz_252_;
  wire [31:0] _zz_253_;
  wire [31:0] _zz_254_;
  wire [0:0] _zz_255_;
  wire [1:0] _zz_256_;
  wire [4:0] _zz_257_;
  wire [4:0] _zz_258_;
  wire  _zz_259_;
  wire [0:0] _zz_260_;
  wire [6:0] _zz_261_;
  wire [31:0] _zz_262_;
  wire [31:0] _zz_263_;
  wire [31:0] _zz_264_;
  wire [31:0] _zz_265_;
  wire [31:0] _zz_266_;
  wire [0:0] _zz_267_;
  wire [1:0] _zz_268_;
  wire [31:0] _zz_269_;
  wire [31:0] _zz_270_;
  wire [0:0] _zz_271_;
  wire [0:0] _zz_272_;
  wire [0:0] _zz_273_;
  wire [0:0] _zz_274_;
  wire  _zz_275_;
  wire [0:0] _zz_276_;
  wire [3:0] _zz_277_;
  wire [31:0] _zz_278_;
  wire [31:0] _zz_279_;
  wire [31:0] _zz_280_;
  wire [31:0] _zz_281_;
  wire [31:0] _zz_282_;
  wire [31:0] _zz_283_;
  wire [31:0] _zz_284_;
  wire [31:0] _zz_285_;
  wire [0:0] _zz_286_;
  wire [0:0] _zz_287_;
  wire [0:0] _zz_288_;
  wire [0:0] _zz_289_;
  wire  _zz_290_;
  wire [0:0] _zz_291_;
  wire [0:0] _zz_292_;
  wire [31:0] _zz_293_;
  wire [31:0] _zz_294_;
  wire  _zz_295_;
  wire [0:0] _zz_296_;
  wire [0:0] _zz_297_;
  wire [31:0] _zz_298_;
  wire [31:0] _zz_299_;
  wire [31:0] _zz_300_;
  wire [31:0] _zz_301_;
  wire  _zz_302_;
  wire [0:0] _zz_303_;
  wire [9:0] _zz_304_;
  wire [31:0] _zz_305_;
  wire [31:0] _zz_306_;
  wire [31:0] _zz_307_;
  wire  _zz_308_;
  wire [0:0] _zz_309_;
  wire [3:0] _zz_310_;
  wire  decode_MEMORY_ENABLE;
  wire [31:0] writeBack_FORMAL_PC_NEXT;
  wire [31:0] memory_FORMAL_PC_NEXT;
  wire [31:0] execute_FORMAL_PC_NEXT;
  wire [31:0] decode_FORMAL_PC_NEXT;
  wire `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_1_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_2_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_3_;
  wire  execute_BYPASSABLE_MEMORY_STAGE;
  wire  decode_BYPASSABLE_MEMORY_STAGE;
  wire `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_4_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_5_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_6_;
  wire `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_7_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_8_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_9_;
  wire  decode_SRC_LESS_UNSIGNED;
  wire [31:0] memory_PC;
  wire `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_10_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_11_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_12_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_13_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_14_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_15_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_16_;
  wire `EnvCtrlEnum_defaultEncoding_type decode_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_17_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_18_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_19_;
  wire  decode_BYPASSABLE_EXECUTE_STAGE;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_20_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_21_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_22_;
  wire [1:0] execute_MEMORY_ADDRESS_LOW;
  wire `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_23_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_24_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_25_;
  wire  decode_CSR_WRITE_OPCODE;
  wire [31:0] writeBack_REGFILE_WRITE_DATA;
  wire [31:0] execute_REGFILE_WRITE_DATA;
  wire  decode_CSR_READ_OPCODE;
  wire  decode_IS_CSR;
  wire  decode_SRC_USE_SUB_LESS;
  wire [31:0] execute_BRANCH_CALC;
  wire  execute_BRANCH_DO;
  wire [31:0] _zz_26_;
  wire [31:0] execute_PC;
  wire [31:0] execute_RS1;
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
  wire  execute_SRC_USE_SUB_LESS;
  wire [31:0] _zz_34_;
  wire `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_35_;
  wire [31:0] _zz_36_;
  wire `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_37_;
  wire [31:0] _zz_38_;
  wire [31:0] execute_SRC_ADD_SUB;
  wire  execute_SRC_LESS;
  wire `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_39_;
  wire [31:0] _zz_40_;
  wire [31:0] execute_SRC2;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_41_;
  wire [31:0] _zz_42_;
  wire [31:0] _zz_43_;
  wire  _zz_44_;
  reg  _zz_45_;
  wire [31:0] _zz_46_;
  wire [31:0] _zz_47_;
  reg  decode_REGFILE_WRITE_VALID;
  wire  decode_LEGAL_INSTRUCTION;
  wire  decode_INSTRUCTION_READY;
  wire  _zz_48_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_49_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_50_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_51_;
  wire  _zz_52_;
  wire  _zz_53_;
  wire  _zz_54_;
  wire  _zz_55_;
  wire  _zz_56_;
  wire  _zz_57_;
  wire  _zz_58_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_59_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_60_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_61_;
  wire  _zz_62_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_63_;
  wire  _zz_64_;
  reg [31:0] _zz_65_;
  wire [31:0] execute_SRC1;
  wire  execute_CSR_READ_OPCODE;
  wire  execute_CSR_WRITE_OPCODE;
  wire  execute_IS_CSR;
  wire `EnvCtrlEnum_defaultEncoding_type memory_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_66_;
  wire `EnvCtrlEnum_defaultEncoding_type execute_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_67_;
  wire  _zz_68_;
  wire  _zz_69_;
  wire `EnvCtrlEnum_defaultEncoding_type writeBack_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_70_;
  reg [31:0] _zz_71_;
  wire [1:0] memory_MEMORY_ADDRESS_LOW;
  wire [31:0] memory_MEMORY_READ_DATA;
  wire [31:0] memory_REGFILE_WRITE_DATA;
  wire  memory_ALIGNEMENT_FAULT;
  wire [31:0] memory_INSTRUCTION;
  wire  memory_MEMORY_ENABLE;
  wire [31:0] _zz_72_;
  wire [1:0] _zz_73_;
  wire [31:0] execute_RS2;
  wire [31:0] execute_SRC_ADD;
  wire [31:0] execute_INSTRUCTION;
  wire  execute_ALIGNEMENT_FAULT;
  wire  execute_MEMORY_ENABLE;
  wire  _zz_74_;
  reg  IBusSimplePlugin_rspJoin_issueDetected;
  reg [31:0] _zz_75_;
  wire [31:0] _zz_76_;
  wire [31:0] _zz_77_;
  wire [31:0] _zz_78_;
  wire [31:0] writeBack_PC /* verilator public */ ;
  wire [31:0] writeBack_INSTRUCTION /* verilator public */ ;
  wire [31:0] decode_PC /* verilator public */ ;
  wire [31:0] decode_INSTRUCTION /* verilator public */ ;
  wire  decode_arbitration_haltItself /* verilator public */ ;
  reg  decode_arbitration_haltByOther;
  reg  decode_arbitration_removeIt;
  reg  decode_arbitration_flushAll /* verilator public */ ;
  wire  decode_arbitration_redoIt;
  wire  decode_arbitration_isValid /* verilator public */ ;
  wire  decode_arbitration_isStuck;
  wire  decode_arbitration_isStuckByOthers;
  wire  decode_arbitration_isFlushed;
  wire  decode_arbitration_isMoving;
  wire  decode_arbitration_isFiring;
  reg  execute_arbitration_haltItself;
  wire  execute_arbitration_haltByOther;
  reg  execute_arbitration_removeIt;
  reg  execute_arbitration_flushAll;
  wire  execute_arbitration_redoIt;
  reg  execute_arbitration_isValid;
  wire  execute_arbitration_isStuck;
  wire  execute_arbitration_isStuckByOthers;
  wire  execute_arbitration_isFlushed;
  wire  execute_arbitration_isMoving;
  wire  execute_arbitration_isFiring;
  reg  memory_arbitration_haltItself;
  wire  memory_arbitration_haltByOther;
  reg  memory_arbitration_removeIt;
  reg  memory_arbitration_flushAll;
  wire  memory_arbitration_redoIt;
  reg  memory_arbitration_isValid;
  wire  memory_arbitration_isStuck;
  wire  memory_arbitration_isStuckByOthers;
  wire  memory_arbitration_isFlushed;
  wire  memory_arbitration_isMoving;
  wire  memory_arbitration_isFiring;
  wire  writeBack_arbitration_haltItself;
  wire  writeBack_arbitration_haltByOther;
  reg  writeBack_arbitration_removeIt;
  wire  writeBack_arbitration_flushAll;
  wire  writeBack_arbitration_redoIt;
  reg  writeBack_arbitration_isValid /* verilator public */ ;
  wire  writeBack_arbitration_isStuck;
  wire  writeBack_arbitration_isStuckByOthers;
  wire  writeBack_arbitration_isFlushed;
  wire  writeBack_arbitration_isMoving;
  wire  writeBack_arbitration_isFiring /* verilator public */ ;
  reg  _zz_79_;
  wire  _zz_80_;
  reg  _zz_81_;
  reg  memory_exception_agregat_valid;
  reg [3:0] memory_exception_agregat_payload_code;
  wire [31:0] memory_exception_agregat_payload_badAddr;
  reg  _zz_82_;
  reg [31:0] _zz_83_;
  wire  contextSwitching;
  reg [1:0] CsrPlugin_privilege;
  wire  decodeExceptionPort_valid;
  wire [3:0] decodeExceptionPort_1_code;
  wire [31:0] decodeExceptionPort_1_badAddr;
  wire  _zz_84_;
  wire [31:0] _zz_85_;
  reg  execute_exception_agregat_valid;
  wire [3:0] execute_exception_agregat_payload_code;
  wire [31:0] execute_exception_agregat_payload_badAddr;
  wire  IBusSimplePlugin_jump_pcLoad_valid;
  wire [31:0] IBusSimplePlugin_jump_pcLoad_payload;
  wire [1:0] _zz_86_;
  wire  IBusSimplePlugin_fetchPc_preOutput_valid;
  wire  IBusSimplePlugin_fetchPc_preOutput_ready;
  wire [31:0] IBusSimplePlugin_fetchPc_preOutput_payload;
  wire  _zz_87_;
  wire  IBusSimplePlugin_fetchPc_output_valid;
  wire  IBusSimplePlugin_fetchPc_output_ready;
  wire [31:0] IBusSimplePlugin_fetchPc_output_payload;
  reg [31:0] IBusSimplePlugin_fetchPc_pcReg /* verilator public */ ;
  reg  IBusSimplePlugin_fetchPc_inc;
  reg  IBusSimplePlugin_fetchPc_propagatePc;
  reg [31:0] IBusSimplePlugin_fetchPc_pc;
  reg  IBusSimplePlugin_fetchPc_samplePcNext;
  reg  _zz_88_;
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
  wire  _zz_89_;
  wire  _zz_90_;
  wire  _zz_91_;
  wire  _zz_92_;
  reg  _zz_93_;
  reg  IBusSimplePlugin_iBusRsp_readyForError;
  wire  IBusSimplePlugin_iBusRsp_inputBeforeStage_valid;
  wire  IBusSimplePlugin_iBusRsp_inputBeforeStage_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_pc;
  wire  IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_raw;
  wire  IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_isRvc;
  wire  IBusSimplePlugin_injector_decodeInput_valid;
  wire  IBusSimplePlugin_injector_decodeInput_ready;
  wire [31:0] IBusSimplePlugin_injector_decodeInput_payload_pc;
  wire  IBusSimplePlugin_injector_decodeInput_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  wire  IBusSimplePlugin_injector_decodeInput_payload_isRvc;
  reg  _zz_94_;
  reg [31:0] _zz_95_;
  reg  _zz_96_;
  reg [31:0] _zz_97_;
  reg  _zz_98_;
  reg  IBusSimplePlugin_injector_nextPcCalc_valids_0;
  reg  IBusSimplePlugin_injector_nextPcCalc_0;
  reg  IBusSimplePlugin_injector_nextPcCalc_1;
  reg  IBusSimplePlugin_injector_nextPcCalc_2;
  reg  IBusSimplePlugin_injector_nextPcCalc_3;
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
  wire  _zz_99_;
  wire  IBusSimplePlugin_rspJoin_join_valid;
  wire  IBusSimplePlugin_rspJoin_join_ready;
  wire [31:0] IBusSimplePlugin_rspJoin_join_payload_pc;
  wire  IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  wire  IBusSimplePlugin_rspJoin_join_payload_isRvc;
  wire  _zz_100_;
  wire  execute_DBusSimplePlugin_cmdSent;
  reg [31:0] _zz_101_;
  reg [3:0] _zz_102_;
  wire [3:0] execute_DBusSimplePlugin_formalMask;
  reg [31:0] memory_DBusSimplePlugin_rspShifted;
  wire  _zz_103_;
  reg [31:0] _zz_104_;
  wire  _zz_105_;
  reg [31:0] _zz_106_;
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
  wire [31:0] CsrPlugin_medeleg;
  wire [31:0] CsrPlugin_mideleg;
  wire  _zz_107_;
  wire  _zz_108_;
  wire  _zz_109_;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
  wire  CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  reg [3:0] CsrPlugin_exceptionPortCtrl_exceptionContext_code;
  reg [31:0] CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
  wire [1:0] CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
  wire  decode_exception_agregat_valid;
  wire [3:0] decode_exception_agregat_payload_code;
  wire [31:0] decode_exception_agregat_payload_badAddr;
  wire [1:0] _zz_110_;
  wire  _zz_111_;
  reg  CsrPlugin_interrupt;
  reg [3:0] CsrPlugin_interruptCode /* verilator public */ ;
  wire [1:0] CsrPlugin_interruptTargetPrivilege;
  wire  CsrPlugin_exception;
  wire  CsrPlugin_lastStageWasWfi;
  reg  CsrPlugin_pipelineLiberator_done;
  wire  CsrPlugin_interruptJump /* verilator public */ ;
  reg  CsrPlugin_hadException;
  reg [1:0] CsrPlugin_targetPrivilege;
  reg [3:0] CsrPlugin_trapCause;
  wire  execute_CsrPlugin_blockedBySideEffects;
  reg  execute_CsrPlugin_illegalAccess;
  reg  execute_CsrPlugin_illegalInstruction;
  reg [31:0] execute_CsrPlugin_readData;
  wire  execute_CsrPlugin_writeInstruction;
  wire  execute_CsrPlugin_readInstruction;
  wire  execute_CsrPlugin_writeEnable;
  wire  execute_CsrPlugin_readEnable;
  reg [31:0] execute_CsrPlugin_writeData;
  wire [11:0] execute_CsrPlugin_csrAddress;
  wire [22:0] _zz_112_;
  wire  _zz_113_;
  wire  _zz_114_;
  wire  _zz_115_;
  wire  _zz_116_;
  wire  _zz_117_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_118_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_119_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_120_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_121_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_122_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_123_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_124_;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress1;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress2;
  wire [31:0] decode_RegFilePlugin_rs1Data;
  wire [31:0] decode_RegFilePlugin_rs2Data;
  reg  writeBack_RegFilePlugin_regFileWrite_valid /* verilator public */ ;
  wire [4:0] writeBack_RegFilePlugin_regFileWrite_payload_address /* verilator public */ ;
  wire [31:0] writeBack_RegFilePlugin_regFileWrite_payload_data /* verilator public */ ;
  reg  _zz_125_;
  reg [31:0] execute_IntAluPlugin_bitwise;
  reg [31:0] _zz_126_;
  reg [31:0] _zz_127_;
  wire  _zz_128_;
  reg [19:0] _zz_129_;
  wire  _zz_130_;
  reg [19:0] _zz_131_;
  reg [31:0] _zz_132_;
  wire [31:0] execute_SrcPlugin_addSub;
  wire  execute_SrcPlugin_less;
  wire [4:0] execute_FullBarrelShifterPlugin_amplitude;
  reg [31:0] _zz_133_;
  wire [31:0] execute_FullBarrelShifterPlugin_reversed;
  reg [31:0] _zz_134_;
  reg  _zz_135_;
  reg  _zz_136_;
  wire  _zz_137_;
  reg  _zz_138_;
  reg [4:0] _zz_139_;
  reg [31:0] _zz_140_;
  wire  _zz_141_;
  wire  _zz_142_;
  wire  _zz_143_;
  wire  _zz_144_;
  wire  _zz_145_;
  wire  _zz_146_;
  wire  execute_BranchPlugin_eq;
  wire [2:0] _zz_147_;
  reg  _zz_148_;
  reg  _zz_149_;
  wire [31:0] execute_BranchPlugin_branch_src1;
  wire  _zz_150_;
  reg [10:0] _zz_151_;
  wire  _zz_152_;
  reg [19:0] _zz_153_;
  wire  _zz_154_;
  reg [18:0] _zz_155_;
  reg [31:0] _zz_156_;
  wire [31:0] execute_BranchPlugin_branch_src2;
  wire [31:0] execute_BranchPlugin_branchAdder;
  reg  decode_to_execute_SRC_USE_SUB_LESS;
  reg  decode_to_execute_IS_CSR;
  reg  decode_to_execute_CSR_READ_OPCODE;
  reg  execute_to_memory_ALIGNEMENT_FAULT;
  reg [31:0] execute_to_memory_REGFILE_WRITE_DATA;
  reg [31:0] memory_to_writeBack_REGFILE_WRITE_DATA;
  reg  decode_to_execute_CSR_WRITE_OPCODE;
  reg `Src1CtrlEnum_defaultEncoding_type decode_to_execute_SRC1_CTRL;
  reg [1:0] execute_to_memory_MEMORY_ADDRESS_LOW;
  reg `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg  decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg [31:0] decode_to_execute_RS2;
  reg [31:0] decode_to_execute_INSTRUCTION;
  reg [31:0] execute_to_memory_INSTRUCTION;
  reg [31:0] memory_to_writeBack_INSTRUCTION;
  reg `EnvCtrlEnum_defaultEncoding_type decode_to_execute_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type execute_to_memory_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type memory_to_writeBack_ENV_CTRL;
  reg [31:0] decode_to_execute_RS1;
  reg `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg [31:0] decode_to_execute_PC;
  reg [31:0] execute_to_memory_PC;
  reg [31:0] memory_to_writeBack_PC;
  reg  decode_to_execute_SRC_LESS_UNSIGNED;
  reg `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg `Src2CtrlEnum_defaultEncoding_type decode_to_execute_SRC2_CTRL;
  reg  decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg  execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg  decode_to_execute_REGFILE_WRITE_VALID;
  reg  execute_to_memory_REGFILE_WRITE_VALID;
  reg  memory_to_writeBack_REGFILE_WRITE_VALID;
  reg `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg [31:0] decode_to_execute_FORMAL_PC_NEXT;
  reg [31:0] execute_to_memory_FORMAL_PC_NEXT;
  reg [31:0] memory_to_writeBack_FORMAL_PC_NEXT;
  reg  decode_to_execute_MEMORY_ENABLE;
  reg  execute_to_memory_MEMORY_ENABLE;
  `ifndef SYNTHESIS
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_1__string;
  reg [63:0] _zz_2__string;
  reg [63:0] _zz_3__string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_4__string;
  reg [23:0] _zz_5__string;
  reg [23:0] _zz_6__string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_7__string;
  reg [31:0] _zz_8__string;
  reg [31:0] _zz_9__string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_10__string;
  reg [71:0] _zz_11__string;
  reg [71:0] _zz_12__string;
  reg [31:0] _zz_13__string;
  reg [31:0] _zz_14__string;
  reg [31:0] _zz_15__string;
  reg [31:0] _zz_16__string;
  reg [31:0] decode_ENV_CTRL_string;
  reg [31:0] _zz_17__string;
  reg [31:0] _zz_18__string;
  reg [31:0] _zz_19__string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_20__string;
  reg [39:0] _zz_21__string;
  reg [39:0] _zz_22__string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_23__string;
  reg [95:0] _zz_24__string;
  reg [95:0] _zz_25__string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_27__string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_30__string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_35__string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_37__string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_39__string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_41__string;
  reg [39:0] _zz_49__string;
  reg [23:0] _zz_50__string;
  reg [95:0] _zz_51__string;
  reg [63:0] _zz_59__string;
  reg [71:0] _zz_60__string;
  reg [31:0] _zz_61__string;
  reg [31:0] _zz_63__string;
  reg [31:0] memory_ENV_CTRL_string;
  reg [31:0] _zz_66__string;
  reg [31:0] execute_ENV_CTRL_string;
  reg [31:0] _zz_67__string;
  reg [31:0] writeBack_ENV_CTRL_string;
  reg [31:0] _zz_70__string;
  reg [31:0] _zz_118__string;
  reg [31:0] _zz_119__string;
  reg [71:0] _zz_120__string;
  reg [63:0] _zz_121__string;
  reg [95:0] _zz_122__string;
  reg [23:0] _zz_123__string;
  reg [39:0] _zz_124__string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [31:0] decode_to_execute_ENV_CTRL_string;
  reg [31:0] execute_to_memory_ENV_CTRL_string;
  reg [31:0] memory_to_writeBack_ENV_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  `endif

  reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;
  assign _zz_160_ = (CsrPlugin_hadException || CsrPlugin_interruptJump);
  assign _zz_161_ = (writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET));
  assign _zz_162_ = (IBusSimplePlugin_fetchPc_preOutput_valid && IBusSimplePlugin_fetchPc_preOutput_ready);
  assign _zz_163_ = memory_INSTRUCTION[13 : 12];
  assign _zz_164_ = writeBack_INSTRUCTION[29 : 28];
  assign _zz_165_ = execute_INSTRUCTION[13];
  assign _zz_166_ = (_zz_86_ & (~ _zz_167_));
  assign _zz_167_ = (_zz_86_ - (2'b01));
  assign _zz_168_ = {IBusSimplePlugin_fetchPc_inc,(2'b00)};
  assign _zz_169_ = {29'd0, _zz_168_};
  assign _zz_170_ = (IBusSimplePlugin_pendingCmd + _zz_172_);
  assign _zz_171_ = (IBusSimplePlugin_cmd_valid && IBusSimplePlugin_cmd_ready);
  assign _zz_172_ = {2'd0, _zz_171_};
  assign _zz_173_ = iBus_rsp_valid;
  assign _zz_174_ = {2'd0, _zz_173_};
  assign _zz_175_ = (iBus_rsp_valid && (IBusSimplePlugin_rspJoin_discardCounter != (3'b000)));
  assign _zz_176_ = {2'd0, _zz_175_};
  assign _zz_177_ = iBus_rsp_valid;
  assign _zz_178_ = {2'd0, _zz_177_};
  assign _zz_179_ = (memory_INSTRUCTION[5] ? (3'b110) : (3'b100));
  assign _zz_180_ = (_zz_110_ & (~ _zz_181_));
  assign _zz_181_ = (_zz_110_ - (2'b01));
  assign _zz_182_ = _zz_112_[1 : 1];
  assign _zz_183_ = _zz_112_[8 : 8];
  assign _zz_184_ = _zz_112_[9 : 9];
  assign _zz_185_ = _zz_112_[11 : 11];
  assign _zz_186_ = _zz_112_[12 : 12];
  assign _zz_187_ = _zz_112_[13 : 13];
  assign _zz_188_ = _zz_112_[14 : 14];
  assign _zz_189_ = _zz_112_[15 : 15];
  assign _zz_190_ = _zz_112_[22 : 22];
  assign _zz_191_ = execute_SRC_LESS;
  assign _zz_192_ = (3'b100);
  assign _zz_193_ = execute_INSTRUCTION[19 : 15];
  assign _zz_194_ = execute_INSTRUCTION[31 : 20];
  assign _zz_195_ = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_196_ = ($signed(_zz_197_) + $signed(_zz_201_));
  assign _zz_197_ = ($signed(_zz_198_) + $signed(_zz_199_));
  assign _zz_198_ = execute_SRC1;
  assign _zz_199_ = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_200_ = (execute_SRC_USE_SUB_LESS ? _zz_202_ : _zz_203_);
  assign _zz_201_ = {{30{_zz_200_[1]}}, _zz_200_};
  assign _zz_202_ = (2'b01);
  assign _zz_203_ = (2'b00);
  assign _zz_204_ = ($signed(_zz_206_) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_205_ = _zz_204_[31 : 0];
  assign _zz_206_ = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_207_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_208_ = execute_INSTRUCTION[31 : 20];
  assign _zz_209_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_210_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_211_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_212_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_213_ = execute_CsrPlugin_writeData[11 : 11];
  assign _zz_214_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_215_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_216_ = (decode_INSTRUCTION & (32'b00000000000000000000000001000100));
  assign _zz_217_ = (32'b00000000000000000000000001000000);
  assign _zz_218_ = ((decode_INSTRUCTION & (32'b01000000000000000000000000110000)) == (32'b01000000000000000000000000110000));
  assign _zz_219_ = ((decode_INSTRUCTION & (32'b00000000000000000010000000010100)) == (32'b00000000000000000010000000010000));
  assign _zz_220_ = ((decode_INSTRUCTION & (32'b00000000000000000001000000000000)) == (32'b00000000000000000001000000000000));
  assign _zz_221_ = _zz_116_;
  assign _zz_222_ = ((decode_INSTRUCTION & _zz_228_) == (32'b00000000000000000010000000000000));
  assign _zz_223_ = {_zz_116_,(_zz_229_ == _zz_230_)};
  assign _zz_224_ = (2'b00);
  assign _zz_225_ = ({_zz_116_,_zz_115_} != (2'b00));
  assign _zz_226_ = ({_zz_231_,_zz_232_} != (2'b00));
  assign _zz_227_ = {(_zz_233_ != _zz_234_),{_zz_235_,{_zz_236_,_zz_237_}}};
  assign _zz_228_ = (32'b00000000000000000011000000000000);
  assign _zz_229_ = (decode_INSTRUCTION & (32'b00000000000000000000000001110000));
  assign _zz_230_ = (32'b00000000000000000000000000100000);
  assign _zz_231_ = _zz_113_;
  assign _zz_232_ = _zz_117_;
  assign _zz_233_ = {((decode_INSTRUCTION & _zz_238_) == (32'b00000000000000000000000000000100)),_zz_117_};
  assign _zz_234_ = (2'b00);
  assign _zz_235_ = (((decode_INSTRUCTION & _zz_239_) == (32'b00000000000000000000000000000000)) != (1'b0));
  assign _zz_236_ = ({_zz_240_,_zz_241_} != (2'b00));
  assign _zz_237_ = {({_zz_242_,_zz_243_} != (2'b00)),{(_zz_244_ != _zz_245_),{_zz_246_,{_zz_247_,_zz_248_}}}};
  assign _zz_238_ = (32'b00000000000000000000000001000100);
  assign _zz_239_ = (32'b00000000000000000000000001010000);
  assign _zz_240_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000110100)) == (32'b00000000000000000000000000100000));
  assign _zz_241_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001100100)) == (32'b00000000000000000000000000100000));
  assign _zz_242_ = ((decode_INSTRUCTION & _zz_249_) == (32'b00000000000000000010000000000000));
  assign _zz_243_ = ((decode_INSTRUCTION & _zz_250_) == (32'b00000000000000000001000000000000));
  assign _zz_244_ = {(_zz_251_ == _zz_252_),(_zz_253_ == _zz_254_)};
  assign _zz_245_ = (2'b00);
  assign _zz_246_ = (_zz_114_ != (1'b0));
  assign _zz_247_ = ({_zz_255_,_zz_256_} != (3'b000));
  assign _zz_248_ = {(_zz_257_ != _zz_258_),{_zz_259_,{_zz_260_,_zz_261_}}};
  assign _zz_249_ = (32'b00000000000000000010000000010000);
  assign _zz_250_ = (32'b00000000000000000101000000000000);
  assign _zz_251_ = (decode_INSTRUCTION & (32'b00000000000000000001000001010000));
  assign _zz_252_ = (32'b00000000000000000001000001010000);
  assign _zz_253_ = (decode_INSTRUCTION & (32'b00000000000000000010000001010000));
  assign _zz_254_ = (32'b00000000000000000010000001010000);
  assign _zz_255_ = ((decode_INSTRUCTION & _zz_262_) == (32'b00000000000000000000000001000000));
  assign _zz_256_ = {(_zz_263_ == _zz_264_),(_zz_265_ == _zz_266_)};
  assign _zz_257_ = {_zz_116_,{_zz_115_,{_zz_267_,_zz_268_}}};
  assign _zz_258_ = (5'b00000);
  assign _zz_259_ = ((_zz_269_ == _zz_270_) != (1'b0));
  assign _zz_260_ = ({_zz_271_,_zz_272_} != (2'b00));
  assign _zz_261_ = {(_zz_273_ != _zz_274_),{_zz_275_,{_zz_276_,_zz_277_}}};
  assign _zz_262_ = (32'b00000000000000000000000001010000);
  assign _zz_263_ = (decode_INSTRUCTION & (32'b00000000000000000000000000110000));
  assign _zz_264_ = (32'b00000000000000000000000000000000);
  assign _zz_265_ = (decode_INSTRUCTION & (32'b00000000000000000011000001000000));
  assign _zz_266_ = (32'b00000000000000000000000001000000);
  assign _zz_267_ = ((decode_INSTRUCTION & _zz_278_) == (32'b00000000000000000001000000010000));
  assign _zz_268_ = {(_zz_279_ == _zz_280_),_zz_114_};
  assign _zz_269_ = (decode_INSTRUCTION & (32'b00000000000000000000000000000000));
  assign _zz_270_ = (32'b00000000000000000000000000000000);
  assign _zz_271_ = ((decode_INSTRUCTION & _zz_281_) == (32'b00000000000000000000000000100100));
  assign _zz_272_ = ((decode_INSTRUCTION & _zz_282_) == (32'b00000000000000000100000000010000));
  assign _zz_273_ = ((decode_INSTRUCTION & _zz_283_) == (32'b00000000000000000010000000010000));
  assign _zz_274_ = (1'b0);
  assign _zz_275_ = ((_zz_284_ == _zz_285_) != (1'b0));
  assign _zz_276_ = ({_zz_286_,_zz_287_} != (2'b00));
  assign _zz_277_ = {(_zz_288_ != _zz_289_),{_zz_290_,{_zz_291_,_zz_292_}}};
  assign _zz_278_ = (32'b00000000000000000001000000010000);
  assign _zz_279_ = (decode_INSTRUCTION & (32'b00000000000000000010000000010000));
  assign _zz_280_ = (32'b00000000000000000010000000010000);
  assign _zz_281_ = (32'b00000000000000000000000001100100);
  assign _zz_282_ = (32'b00000000000000000100000000010100);
  assign _zz_283_ = (32'b00000000000000000110000000010100);
  assign _zz_284_ = (decode_INSTRUCTION & (32'b00000000000000000111000001010100));
  assign _zz_285_ = (32'b00000000000000000101000000010000);
  assign _zz_286_ = ((decode_INSTRUCTION & (32'b01000000000000000011000001010100)) == (32'b01000000000000000001000000010000));
  assign _zz_287_ = ((decode_INSTRUCTION & (32'b00000000000000000111000001010100)) == (32'b00000000000000000001000000010000));
  assign _zz_288_ = _zz_113_;
  assign _zz_289_ = (1'b0);
  assign _zz_290_ = (((decode_INSTRUCTION & (32'b00000000000000000000000001011000)) == (32'b00000000000000000000000001000000)) != (1'b0));
  assign _zz_291_ = ({(_zz_293_ == _zz_294_),{_zz_295_,{_zz_296_,_zz_297_}}} != (4'b0000));
  assign _zz_292_ = (((decode_INSTRUCTION & _zz_298_) == (32'b00000000000000000000000001010000)) != (1'b0));
  assign _zz_293_ = (decode_INSTRUCTION & (32'b00000000000000000000000001000100));
  assign _zz_294_ = (32'b00000000000000000000000000000000);
  assign _zz_295_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000011000)) == (32'b00000000000000000000000000000000));
  assign _zz_296_ = ((decode_INSTRUCTION & (32'b00000000000000000110000000000100)) == (32'b00000000000000000010000000000000));
  assign _zz_297_ = ((decode_INSTRUCTION & (32'b00000000000000000101000000000100)) == (32'b00000000000000000001000000000000));
  assign _zz_298_ = (32'b00000000000000000011000001010000);
  assign _zz_299_ = (32'b00000000000000000001000001111111);
  assign _zz_300_ = (decode_INSTRUCTION & (32'b00000000000000000010000001111111));
  assign _zz_301_ = (32'b00000000000000000010000001110011);
  assign _zz_302_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001111111)) == (32'b00000000000000000100000001100011));
  assign _zz_303_ = ((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000010000000010011));
  assign _zz_304_ = {((decode_INSTRUCTION & (32'b00000000000000000110000000111111)) == (32'b00000000000000000000000000100011)),{((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_305_) == (32'b00000000000000000000000000000011)),{(_zz_306_ == _zz_307_),{_zz_308_,{_zz_309_,_zz_310_}}}}}};
  assign _zz_305_ = (32'b00000000000000000101000001011111);
  assign _zz_306_ = (decode_INSTRUCTION & (32'b00000000000000000111000001111011));
  assign _zz_307_ = (32'b00000000000000000000000001100011);
  assign _zz_308_ = ((decode_INSTRUCTION & (32'b11111110000000000000000001111111)) == (32'b00000000000000000000000000110011));
  assign _zz_309_ = ((decode_INSTRUCTION & (32'b10111100000000000111000001111111)) == (32'b00000000000000000101000000010011));
  assign _zz_310_ = {((decode_INSTRUCTION & (32'b11111100000000000011000001111111)) == (32'b00000000000000000001000000010011)),{((decode_INSTRUCTION & (32'b10111110000000000111000001111111)) == (32'b00000000000000000101000000110011)),{((decode_INSTRUCTION & (32'b10111110000000000111000001111111)) == (32'b00000000000000000000000000110011)),((decode_INSTRUCTION & (32'b11011111111111111111111111111111)) == (32'b00010000001000000000000001110011))}}};
  always @ (posedge clk) begin
    if(_zz_45_) begin
      RegFilePlugin_regFile[writeBack_RegFilePlugin_regFileWrite_payload_address] <= writeBack_RegFilePlugin_regFileWrite_payload_data;
    end
  end

  assign _zz_158_ = RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
  assign _zz_159_ = RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
  StreamFifoLowLatency IBusSimplePlugin_rspJoin_rspBuffer_c ( 
    .io_push_valid(iBus_rsp_takeWhen_valid),
    .io_push_ready(IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready),
    .io_push_payload_error(iBus_rsp_takeWhen_payload_error),
    .io_push_payload_inst(iBus_rsp_takeWhen_payload_inst),
    .io_pop_valid(IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid),
    .io_pop_ready(IBusSimplePlugin_rspJoin_rspBufferOutput_ready),
    .io_pop_payload_error(IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error),
    .io_pop_payload_inst(IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst),
    .io_flush(_zz_157_),
    .io_occupancy(IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy),
    .clk(clk),
    .reset(reset) 
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(decode_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_ALU_CTRL_string = "BITWISE ";
      default : decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_1_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_1__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_1__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_1__string = "BITWISE ";
      default : _zz_1__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_2_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_2__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_2__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_2__string = "BITWISE ";
      default : _zz_2__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_3_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_3__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_3__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_3__string = "BITWISE ";
      default : _zz_3__string = "????????";
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
    case(_zz_4_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_4__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_4__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_4__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_4__string = "PC ";
      default : _zz_4__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_5_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_5__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_5__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_5__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_5__string = "PC ";
      default : _zz_5__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_6_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_6__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_6__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_6__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_6__string = "PC ";
      default : _zz_6__string = "???";
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
    case(_zz_7_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_7__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_7__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_7__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_7__string = "JALR";
      default : _zz_7__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_8_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_8__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_8__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_8__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_8__string = "JALR";
      default : _zz_8__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_9_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_9__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_9__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_9__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_9__string = "JALR";
      default : _zz_9__string = "????";
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
    case(_zz_10_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_10__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_10__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_10__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_10__string = "SRA_1    ";
      default : _zz_10__string = "?????????";
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
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_13__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_13__string = "XRET";
      default : _zz_13__string = "????";
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
    case(decode_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_ENV_CTRL_string = "XRET";
      default : decode_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_17_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_17__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_17__string = "XRET";
      default : _zz_17__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_18_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_18__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_18__string = "XRET";
      default : _zz_18__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_19_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_19__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_19__string = "XRET";
      default : _zz_19__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_ALU_BITWISE_CTRL_string = "AND_1";
      `AluBitwiseCtrlEnum_defaultEncoding_SRC1 : decode_ALU_BITWISE_CTRL_string = "SRC1 ";
      default : decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_20_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_20__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_20__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_20__string = "AND_1";
      `AluBitwiseCtrlEnum_defaultEncoding_SRC1 : _zz_20__string = "SRC1 ";
      default : _zz_20__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_21_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_21__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_21__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_21__string = "AND_1";
      `AluBitwiseCtrlEnum_defaultEncoding_SRC1 : _zz_21__string = "SRC1 ";
      default : _zz_21__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_22_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_22__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_22__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_22__string = "AND_1";
      `AluBitwiseCtrlEnum_defaultEncoding_SRC1 : _zz_22__string = "SRC1 ";
      default : _zz_22__string = "?????";
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
    case(_zz_25_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_25__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_25__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_25__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_25__string = "URS1        ";
      default : _zz_25__string = "????????????";
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
    case(_zz_39_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_39__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_39__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_39__string = "BITWISE ";
      default : _zz_39__string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : execute_ALU_BITWISE_CTRL_string = "AND_1";
      `AluBitwiseCtrlEnum_defaultEncoding_SRC1 : execute_ALU_BITWISE_CTRL_string = "SRC1 ";
      default : execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_41_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_41__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_41__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_41__string = "AND_1";
      `AluBitwiseCtrlEnum_defaultEncoding_SRC1 : _zz_41__string = "SRC1 ";
      default : _zz_41__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_49_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_49__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_49__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_49__string = "AND_1";
      `AluBitwiseCtrlEnum_defaultEncoding_SRC1 : _zz_49__string = "SRC1 ";
      default : _zz_49__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_50_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_50__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_50__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_50__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_50__string = "PC ";
      default : _zz_50__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_51_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_51__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_51__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_51__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_51__string = "URS1        ";
      default : _zz_51__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_59_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_59__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_59__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_59__string = "BITWISE ";
      default : _zz_59__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_60_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_60__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_60__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_60__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_60__string = "SRA_1    ";
      default : _zz_60__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_61_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_61__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_61__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_61__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_61__string = "JALR";
      default : _zz_61__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_63_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_63__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_63__string = "XRET";
      default : _zz_63__string = "????";
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
    case(_zz_66_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_66__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_66__string = "XRET";
      default : _zz_66__string = "????";
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
    case(_zz_67_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_67__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_67__string = "XRET";
      default : _zz_67__string = "????";
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
    case(_zz_70_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_70__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_70__string = "XRET";
      default : _zz_70__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_118_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_118__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_118__string = "XRET";
      default : _zz_118__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_119_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_119__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_119__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_119__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_119__string = "JALR";
      default : _zz_119__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_120_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_120__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_120__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_120__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_120__string = "SRA_1    ";
      default : _zz_120__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_121_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_121__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_121__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_121__string = "BITWISE ";
      default : _zz_121__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_122_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_122__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_122__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_122__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_122__string = "URS1        ";
      default : _zz_122__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_123_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_123__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_123__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_123__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_123__string = "PC ";
      default : _zz_123__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_124_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_124__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_124__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_124__string = "AND_1";
      `AluBitwiseCtrlEnum_defaultEncoding_SRC1 : _zz_124__string = "SRC1 ";
      default : _zz_124__string = "?????";
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
      `AluBitwiseCtrlEnum_defaultEncoding_SRC1 : decode_to_execute_ALU_BITWISE_CTRL_string = "SRC1 ";
      default : decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
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
    case(decode_to_execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_to_execute_SHIFT_CTRL_string = "?????????";
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
    case(decode_to_execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  `endif

  assign decode_MEMORY_ENABLE = _zz_52_;
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = _zz_76_;
  assign decode_ALU_CTRL = _zz_1_;
  assign _zz_2_ = _zz_3_;
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_58_;
  assign decode_SRC2_CTRL = _zz_4_;
  assign _zz_5_ = _zz_6_;
  assign decode_BRANCH_CTRL = _zz_7_;
  assign _zz_8_ = _zz_9_;
  assign decode_SRC_LESS_UNSIGNED = _zz_54_;
  assign memory_PC = execute_to_memory_PC;
  assign decode_SHIFT_CTRL = _zz_10_;
  assign _zz_11_ = _zz_12_;
  assign _zz_13_ = _zz_14_;
  assign _zz_15_ = _zz_16_;
  assign decode_ENV_CTRL = _zz_17_;
  assign _zz_18_ = _zz_19_;
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_56_;
  assign decode_ALU_BITWISE_CTRL = _zz_20_;
  assign _zz_21_ = _zz_22_;
  assign execute_MEMORY_ADDRESS_LOW = _zz_73_;
  assign decode_SRC1_CTRL = _zz_23_;
  assign _zz_24_ = _zz_25_;
  assign decode_CSR_WRITE_OPCODE = _zz_69_;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign execute_REGFILE_WRITE_DATA = _zz_40_;
  assign decode_CSR_READ_OPCODE = _zz_68_;
  assign decode_IS_CSR = _zz_55_;
  assign decode_SRC_USE_SUB_LESS = _zz_48_;
  assign execute_BRANCH_CALC = _zz_26_;
  assign execute_BRANCH_DO = _zz_28_;
  assign execute_PC = decode_to_execute_PC;
  assign execute_RS1 = decode_to_execute_RS1;
  assign execute_BRANCH_CTRL = _zz_27_;
  assign decode_RS2_USE = _zz_53_;
  assign decode_RS1_USE = _zz_62_;
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS2 = _zz_46_;
    decode_RS1 = _zz_47_;
    if(_zz_138_)begin
      if((_zz_139_ == decode_INSTRUCTION[19 : 15]))begin
        decode_RS1 = _zz_140_;
      end
      if((_zz_139_ == decode_INSTRUCTION[24 : 20]))begin
        decode_RS2 = _zz_140_;
      end
    end
    if((writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID))begin
      if(1'b1)begin
        if(_zz_141_)begin
          decode_RS1 = _zz_42_;
        end
        if(_zz_142_)begin
          decode_RS2 = _zz_42_;
        end
      end
    end
    if((memory_arbitration_isValid && memory_REGFILE_WRITE_VALID))begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_143_)begin
          decode_RS1 = _zz_71_;
        end
        if(_zz_144_)begin
          decode_RS2 = _zz_71_;
        end
      end
    end
    if((execute_arbitration_isValid && execute_REGFILE_WRITE_VALID))begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_145_)begin
          decode_RS1 = _zz_65_;
        end
        if(_zz_146_)begin
          decode_RS2 = _zz_65_;
        end
      end
    end
  end

  assign execute_SHIFT_RIGHT = _zz_29_;
  assign execute_SHIFT_CTRL = _zz_30_;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign _zz_34_ = execute_PC;
  assign execute_SRC2_CTRL = _zz_35_;
  assign execute_SRC1_CTRL = _zz_37_;
  assign execute_SRC_ADD_SUB = _zz_33_;
  assign execute_SRC_LESS = _zz_31_;
  assign execute_ALU_CTRL = _zz_39_;
  assign execute_SRC2 = _zz_36_;
  assign execute_ALU_BITWISE_CTRL = _zz_41_;
  assign _zz_42_ = writeBack_REGFILE_WRITE_DATA;
  assign _zz_43_ = writeBack_INSTRUCTION;
  assign _zz_44_ = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_45_ = 1'b0;
    if(writeBack_RegFilePlugin_regFileWrite_valid)begin
      _zz_45_ = 1'b1;
    end
  end

  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_57_;
    if((decode_INSTRUCTION[11 : 7] == (5'b00000)))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  assign decode_LEGAL_INSTRUCTION = _zz_64_;
  assign decode_INSTRUCTION_READY = 1'b1;
  always @ (*) begin
    _zz_65_ = execute_REGFILE_WRITE_DATA;
    execute_arbitration_haltItself = 1'b0;
    if(((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! dBus_cmd_ready)) && (! execute_ALIGNEMENT_FAULT)) && (! execute_DBusSimplePlugin_cmdSent)))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if((execute_arbitration_isValid && execute_IS_CSR))begin
      _zz_65_ = execute_CsrPlugin_readData;
      if(execute_CsrPlugin_blockedBySideEffects)begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
    case(execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
        _zz_65_ = _zz_134_;
      end
      `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
        _zz_65_ = execute_SHIFT_RIGHT;
      end
      default : begin
      end
    endcase
  end

  assign execute_SRC1 = _zz_38_;
  assign execute_CSR_READ_OPCODE = decode_to_execute_CSR_READ_OPCODE;
  assign execute_CSR_WRITE_OPCODE = decode_to_execute_CSR_WRITE_OPCODE;
  assign execute_IS_CSR = decode_to_execute_IS_CSR;
  assign memory_ENV_CTRL = _zz_66_;
  assign execute_ENV_CTRL = _zz_67_;
  assign writeBack_ENV_CTRL = _zz_70_;
  always @ (*) begin
    _zz_71_ = memory_REGFILE_WRITE_DATA;
    if((memory_arbitration_isValid && memory_MEMORY_ENABLE))begin
      _zz_71_ = memory_DBusSimplePlugin_rspFormated;
    end
  end

  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign memory_MEMORY_READ_DATA = _zz_72_;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign memory_ALIGNEMENT_FAULT = execute_to_memory_ALIGNEMENT_FAULT;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_SRC_ADD = _zz_32_;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign execute_ALIGNEMENT_FAULT = _zz_74_;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  always @ (*) begin
    IBusSimplePlugin_rspJoin_issueDetected = 1'b0;
    _zz_81_ = 1'b0;
    if(((IBusSimplePlugin_rspJoin_join_valid && IBusSimplePlugin_rspJoin_join_payload_rsp_error) && (! _zz_99_)))begin
      IBusSimplePlugin_rspJoin_issueDetected = 1'b1;
      _zz_81_ = IBusSimplePlugin_iBusRsp_readyForError;
    end
  end

  always @ (*) begin
    _zz_75_ = execute_FORMAL_PC_NEXT;
    if(_zz_84_)begin
      _zz_75_ = _zz_85_;
    end
  end

  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  assign decode_PC = _zz_78_;
  assign decode_INSTRUCTION = _zz_77_;
  assign decode_arbitration_haltItself = 1'b0;
  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if((CsrPlugin_interrupt && decode_arbitration_isValid))begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if(({(memory_arbitration_isValid && (memory_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),(execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET))} != (2'b00)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if((decode_arbitration_isValid && (_zz_135_ || _zz_136_)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_removeIt = 1'b0;
    if(decode_exception_agregat_valid)begin
      decode_arbitration_removeIt = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_flushAll = 1'b0;
    execute_arbitration_removeIt = 1'b0;
    CsrPlugin_exceptionPortCtrl_exceptionValids_execute = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
    if(execute_exception_agregat_valid)begin
      decode_arbitration_flushAll = 1'b1;
      execute_arbitration_removeIt = 1'b1;
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b0;
    end
    if(_zz_84_)begin
      decode_arbitration_flushAll = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_redoIt = 1'b0;
  assign execute_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    execute_arbitration_flushAll = 1'b0;
    if(memory_exception_agregat_valid)begin
      execute_arbitration_flushAll = 1'b1;
    end
  end

  assign execute_arbitration_redoIt = 1'b0;
  always @ (*) begin
    memory_arbitration_haltItself = 1'b0;
    if((((memory_arbitration_isValid && memory_MEMORY_ENABLE) && (! memory_INSTRUCTION[5])) && (! dBus_rsp_ready)))begin
      memory_arbitration_haltItself = 1'b1;
    end
  end

  assign memory_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    memory_arbitration_removeIt = 1'b0;
    if(memory_exception_agregat_valid)begin
      memory_arbitration_removeIt = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    memory_arbitration_flushAll = 1'b0;
    _zz_82_ = 1'b0;
    _zz_83_ = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    if(_zz_160_)begin
      _zz_82_ = 1'b1;
      _zz_83_ = {CsrPlugin_mtvec_base,(2'b00)};
      memory_arbitration_flushAll = 1'b1;
    end
    if(_zz_161_)begin
      _zz_83_ = CsrPlugin_mepc;
      _zz_82_ = 1'b1;
      memory_arbitration_flushAll = 1'b1;
    end
  end

  assign memory_arbitration_redoIt = 1'b0;
  assign writeBack_arbitration_haltItself = 1'b0;
  assign writeBack_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(writeBack_arbitration_isFlushed)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  assign writeBack_arbitration_flushAll = 1'b0;
  assign writeBack_arbitration_redoIt = 1'b0;
  always @ (*) begin
    _zz_79_ = 1'b0;
    if(({CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,{CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode}}} != (4'b0000)))begin
      _zz_79_ = 1'b1;
    end
  end

  assign _zz_80_ = 1'b0;
  assign IBusSimplePlugin_jump_pcLoad_valid = ({_zz_84_,_zz_82_} != (2'b00));
  assign _zz_86_ = {_zz_84_,_zz_82_};
  assign IBusSimplePlugin_jump_pcLoad_payload = (_zz_166_[0] ? _zz_83_ : _zz_85_);
  assign _zz_87_ = (! _zz_79_);
  assign IBusSimplePlugin_fetchPc_output_valid = (IBusSimplePlugin_fetchPc_preOutput_valid && _zz_87_);
  assign IBusSimplePlugin_fetchPc_preOutput_ready = (IBusSimplePlugin_fetchPc_output_ready && _zz_87_);
  assign IBusSimplePlugin_fetchPc_output_payload = IBusSimplePlugin_fetchPc_preOutput_payload;
  always @ (*) begin
    IBusSimplePlugin_fetchPc_propagatePc = 1'b0;
    if((IBusSimplePlugin_iBusRsp_stages_1_input_valid && IBusSimplePlugin_iBusRsp_stages_1_input_ready))begin
      IBusSimplePlugin_fetchPc_propagatePc = 1'b1;
    end
  end

  always @ (*) begin
    IBusSimplePlugin_fetchPc_pc = (IBusSimplePlugin_fetchPc_pcReg + _zz_169_);
    IBusSimplePlugin_fetchPc_samplePcNext = 1'b0;
    if(IBusSimplePlugin_fetchPc_propagatePc)begin
      IBusSimplePlugin_fetchPc_samplePcNext = 1'b1;
    end
    if(IBusSimplePlugin_jump_pcLoad_valid)begin
      IBusSimplePlugin_fetchPc_samplePcNext = 1'b1;
      IBusSimplePlugin_fetchPc_pc = IBusSimplePlugin_jump_pcLoad_payload;
    end
    if(_zz_162_)begin
      IBusSimplePlugin_fetchPc_samplePcNext = 1'b1;
    end
    IBusSimplePlugin_fetchPc_pc[0] = 1'b0;
    IBusSimplePlugin_fetchPc_pc[1] = 1'b0;
  end

  assign IBusSimplePlugin_fetchPc_preOutput_valid = _zz_88_;
  assign IBusSimplePlugin_fetchPc_preOutput_payload = IBusSimplePlugin_fetchPc_pc;
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

  assign _zz_89_ = (! IBusSimplePlugin_iBusRsp_stages_0_halt);
  assign IBusSimplePlugin_iBusRsp_stages_0_input_ready = (IBusSimplePlugin_iBusRsp_stages_0_output_ready && _zz_89_);
  assign IBusSimplePlugin_iBusRsp_stages_0_output_valid = (IBusSimplePlugin_iBusRsp_stages_0_input_valid && _zz_89_);
  assign IBusSimplePlugin_iBusRsp_stages_0_output_payload = IBusSimplePlugin_iBusRsp_stages_0_input_payload;
  assign IBusSimplePlugin_iBusRsp_stages_1_halt = 1'b0;
  assign _zz_90_ = (! IBusSimplePlugin_iBusRsp_stages_1_halt);
  assign IBusSimplePlugin_iBusRsp_stages_1_input_ready = (IBusSimplePlugin_iBusRsp_stages_1_output_ready && _zz_90_);
  assign IBusSimplePlugin_iBusRsp_stages_1_output_valid = (IBusSimplePlugin_iBusRsp_stages_1_input_valid && _zz_90_);
  assign IBusSimplePlugin_iBusRsp_stages_1_output_payload = IBusSimplePlugin_iBusRsp_stages_1_input_payload;
  assign IBusSimplePlugin_iBusRsp_stages_0_output_ready = _zz_91_;
  assign _zz_91_ = ((1'b0 && (! _zz_92_)) || IBusSimplePlugin_iBusRsp_stages_1_input_ready);
  assign _zz_92_ = _zz_93_;
  assign IBusSimplePlugin_iBusRsp_stages_1_input_valid = _zz_92_;
  assign IBusSimplePlugin_iBusRsp_stages_1_input_payload = IBusSimplePlugin_fetchPc_pcReg;
  always @ (*) begin
    IBusSimplePlugin_iBusRsp_readyForError = 1'b1;
    if(IBusSimplePlugin_injector_decodeInput_valid)begin
      IBusSimplePlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_ready = ((1'b0 && (! IBusSimplePlugin_injector_decodeInput_valid)) || IBusSimplePlugin_injector_decodeInput_ready);
  assign IBusSimplePlugin_injector_decodeInput_valid = _zz_94_;
  assign IBusSimplePlugin_injector_decodeInput_payload_pc = _zz_95_;
  assign IBusSimplePlugin_injector_decodeInput_payload_rsp_error = _zz_96_;
  assign IBusSimplePlugin_injector_decodeInput_payload_rsp_inst = _zz_97_;
  assign IBusSimplePlugin_injector_decodeInput_payload_isRvc = _zz_98_;
  assign IBusSimplePlugin_injector_decodeInput_ready = (! decode_arbitration_isStuck);
  assign decode_arbitration_isValid = (IBusSimplePlugin_injector_decodeInput_valid && (! IBusSimplePlugin_injector_decodeRemoved));
  assign _zz_78_ = IBusSimplePlugin_injector_decodeInput_payload_pc;
  assign _zz_77_ = IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  assign _zz_76_ = (decode_PC + (32'b00000000000000000000000000000100));
  assign iBus_cmd_valid = IBusSimplePlugin_cmd_valid;
  assign IBusSimplePlugin_cmd_ready = iBus_cmd_ready;
  assign iBus_cmd_payload_pc = IBusSimplePlugin_cmd_payload_pc;
  assign IBusSimplePlugin_pendingCmdNext = (_zz_170_ - _zz_174_);
  assign IBusSimplePlugin_cmd_valid = ((IBusSimplePlugin_iBusRsp_stages_0_input_valid && IBusSimplePlugin_iBusRsp_stages_0_output_ready) && (IBusSimplePlugin_pendingCmd != (3'b111)));
  assign IBusSimplePlugin_cmd_payload_pc = {IBusSimplePlugin_iBusRsp_stages_0_input_payload[31 : 2],(2'b00)};
  assign iBus_rsp_takeWhen_valid = (iBus_rsp_valid && (! (IBusSimplePlugin_rspJoin_discardCounter != (3'b000))));
  assign iBus_rsp_takeWhen_payload_error = iBus_rsp_payload_error;
  assign iBus_rsp_takeWhen_payload_inst = iBus_rsp_payload_inst;
  assign _zz_157_ = (IBusSimplePlugin_jump_pcLoad_valid || _zz_80_);
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
  assign _zz_99_ = 1'b0;
  assign IBusSimplePlugin_rspJoin_join_valid = (IBusSimplePlugin_iBusRsp_stages_1_output_valid && IBusSimplePlugin_rspJoin_rspBufferOutput_valid);
  assign IBusSimplePlugin_rspJoin_join_payload_pc = IBusSimplePlugin_rspJoin_fetchRsp_pc;
  assign IBusSimplePlugin_rspJoin_join_payload_rsp_error = IBusSimplePlugin_rspJoin_fetchRsp_rsp_error;
  assign IBusSimplePlugin_rspJoin_join_payload_rsp_inst = IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst;
  assign IBusSimplePlugin_rspJoin_join_payload_isRvc = IBusSimplePlugin_rspJoin_fetchRsp_isRvc;
  assign IBusSimplePlugin_iBusRsp_stages_1_output_ready = (IBusSimplePlugin_iBusRsp_stages_1_output_valid ? (IBusSimplePlugin_rspJoin_join_valid && IBusSimplePlugin_rspJoin_join_ready) : IBusSimplePlugin_rspJoin_join_ready);
  assign IBusSimplePlugin_rspJoin_rspBufferOutput_ready = (IBusSimplePlugin_rspJoin_join_valid && IBusSimplePlugin_rspJoin_join_ready);
  assign _zz_100_ = (! _zz_99_);
  assign IBusSimplePlugin_rspJoin_join_ready = (IBusSimplePlugin_iBusRsp_inputBeforeStage_ready && _zz_100_);
  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_valid = (IBusSimplePlugin_rspJoin_join_valid && _zz_100_);
  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_pc = IBusSimplePlugin_rspJoin_join_payload_pc;
  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_error = IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_raw = IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  assign IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_isRvc = IBusSimplePlugin_rspJoin_join_payload_isRvc;
  assign execute_DBusSimplePlugin_cmdSent = 1'b0;
  assign _zz_74_ = (((dBus_cmd_payload_size == (2'b10)) && (dBus_cmd_payload_address[1 : 0] != (2'b00))) || ((dBus_cmd_payload_size == (2'b01)) && (dBus_cmd_payload_address[0 : 0] != (1'b0))));
  assign dBus_cmd_valid = (((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! execute_arbitration_isStuckByOthers)) && (! execute_arbitration_isFlushed)) && (! execute_ALIGNEMENT_FAULT)) && (! execute_DBusSimplePlugin_cmdSent));
  assign dBus_cmd_payload_wr = execute_INSTRUCTION[5];
  assign dBus_cmd_payload_address = execute_SRC_ADD;
  assign dBus_cmd_payload_size = execute_INSTRUCTION[13 : 12];
  always @ (*) begin
    case(dBus_cmd_payload_size)
      2'b00 : begin
        _zz_101_ = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_101_ = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_101_ = execute_RS2[31 : 0];
      end
    endcase
  end

  assign dBus_cmd_payload_data = _zz_101_;
  assign _zz_73_ = dBus_cmd_payload_address[1 : 0];
  always @ (*) begin
    case(dBus_cmd_payload_size)
      2'b00 : begin
        _zz_102_ = (4'b0001);
      end
      2'b01 : begin
        _zz_102_ = (4'b0011);
      end
      default : begin
        _zz_102_ = (4'b1111);
      end
    endcase
  end

  assign execute_DBusSimplePlugin_formalMask = (_zz_102_ <<< dBus_cmd_payload_address[1 : 0]);
  assign _zz_72_ = dBus_rsp_data;
  always @ (*) begin
    memory_exception_agregat_valid = ((dBus_rsp_ready && dBus_rsp_error) && (! memory_INSTRUCTION[5]));
    memory_exception_agregat_payload_code = (4'b0101);
    if(memory_ALIGNEMENT_FAULT)begin
      memory_exception_agregat_payload_code = {1'd0, _zz_179_};
      memory_exception_agregat_valid = 1'b1;
    end
    if((! ((memory_arbitration_isValid && memory_MEMORY_ENABLE) && 1'b1)))begin
      memory_exception_agregat_valid = 1'b0;
    end
  end

  assign memory_exception_agregat_payload_badAddr = memory_REGFILE_WRITE_DATA;
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

  assign _zz_103_ = (memory_DBusSimplePlugin_rspShifted[7] && (! memory_INSTRUCTION[14]));
  always @ (*) begin
    _zz_104_[31] = _zz_103_;
    _zz_104_[30] = _zz_103_;
    _zz_104_[29] = _zz_103_;
    _zz_104_[28] = _zz_103_;
    _zz_104_[27] = _zz_103_;
    _zz_104_[26] = _zz_103_;
    _zz_104_[25] = _zz_103_;
    _zz_104_[24] = _zz_103_;
    _zz_104_[23] = _zz_103_;
    _zz_104_[22] = _zz_103_;
    _zz_104_[21] = _zz_103_;
    _zz_104_[20] = _zz_103_;
    _zz_104_[19] = _zz_103_;
    _zz_104_[18] = _zz_103_;
    _zz_104_[17] = _zz_103_;
    _zz_104_[16] = _zz_103_;
    _zz_104_[15] = _zz_103_;
    _zz_104_[14] = _zz_103_;
    _zz_104_[13] = _zz_103_;
    _zz_104_[12] = _zz_103_;
    _zz_104_[11] = _zz_103_;
    _zz_104_[10] = _zz_103_;
    _zz_104_[9] = _zz_103_;
    _zz_104_[8] = _zz_103_;
    _zz_104_[7 : 0] = memory_DBusSimplePlugin_rspShifted[7 : 0];
  end

  assign _zz_105_ = (memory_DBusSimplePlugin_rspShifted[15] && (! memory_INSTRUCTION[14]));
  always @ (*) begin
    _zz_106_[31] = _zz_105_;
    _zz_106_[30] = _zz_105_;
    _zz_106_[29] = _zz_105_;
    _zz_106_[28] = _zz_105_;
    _zz_106_[27] = _zz_105_;
    _zz_106_[26] = _zz_105_;
    _zz_106_[25] = _zz_105_;
    _zz_106_[24] = _zz_105_;
    _zz_106_[23] = _zz_105_;
    _zz_106_[22] = _zz_105_;
    _zz_106_[21] = _zz_105_;
    _zz_106_[20] = _zz_105_;
    _zz_106_[19] = _zz_105_;
    _zz_106_[18] = _zz_105_;
    _zz_106_[17] = _zz_105_;
    _zz_106_[16] = _zz_105_;
    _zz_106_[15 : 0] = memory_DBusSimplePlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_163_)
      2'b00 : begin
        memory_DBusSimplePlugin_rspFormated = _zz_104_;
      end
      2'b01 : begin
        memory_DBusSimplePlugin_rspFormated = _zz_106_;
      end
      default : begin
        memory_DBusSimplePlugin_rspFormated = memory_DBusSimplePlugin_rspShifted;
      end
    endcase
  end

  assign CsrPlugin_misa_base = (2'b01);
  assign CsrPlugin_misa_extensions = (26'b00000000000000000001000010);
  assign CsrPlugin_mtvec_mode = (2'b00);
  assign CsrPlugin_mtvec_base = (30'b000000000000000000000010000000);
  assign CsrPlugin_medeleg = (32'b00000000000000000000000000000000);
  assign CsrPlugin_mideleg = (32'b00000000000000000000000000000000);
  assign _zz_107_ = (CsrPlugin_mip_MTIP && CsrPlugin_mie_MTIE);
  assign _zz_108_ = (CsrPlugin_mip_MSIP && CsrPlugin_mie_MSIE);
  assign _zz_109_ = (CsrPlugin_mip_MEIP && CsrPlugin_mie_MEIE);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege = (2'b11);
  assign decode_exception_agregat_valid = ({decodeExceptionPort_valid,_zz_81_} != (2'b00));
  assign _zz_110_ = {decodeExceptionPort_valid,_zz_81_};
  assign _zz_111_ = _zz_180_[0];
  assign decode_exception_agregat_payload_code = (_zz_111_ ? (4'b0001) : decodeExceptionPort_1_code);
  assign decode_exception_agregat_payload_badAddr = (_zz_111_ ? IBusSimplePlugin_rspJoin_join_payload_pc : decodeExceptionPort_1_badAddr);
  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_decode = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
    if(decode_exception_agregat_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_memory = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
    if(memory_exception_agregat_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b0;
    end
  end

  assign CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  always @ (*) begin
    CsrPlugin_interrupt = 1'b0;
    CsrPlugin_interruptCode = (4'bxxxx);
    if(CsrPlugin_mstatus_MIE)begin
      if(({_zz_109_,{_zz_108_,_zz_107_}} != (3'b000)))begin
        CsrPlugin_interrupt = 1'b1;
      end
      if(_zz_107_)begin
        CsrPlugin_interruptCode = (4'b0111);
      end
      if(_zz_108_)begin
        CsrPlugin_interruptCode = (4'b0011);
      end
      if(_zz_109_)begin
        CsrPlugin_interruptCode = (4'b1011);
      end
    end
    if((! 1'b1))begin
      CsrPlugin_interrupt = 1'b0;
    end
  end

  assign CsrPlugin_interruptTargetPrivilege = (2'b11);
  assign CsrPlugin_exception = (CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack && 1'b1);
  assign CsrPlugin_lastStageWasWfi = 1'b0;
  always @ (*) begin
    CsrPlugin_pipelineLiberator_done = ((! ({writeBack_arbitration_isValid,{memory_arbitration_isValid,execute_arbitration_isValid}} != (3'b000))) && IBusSimplePlugin_injector_nextPcCalc_3);
    if(({CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute}} != (3'b000)))begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
    if(CsrPlugin_hadException)begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
  end

  assign CsrPlugin_interruptJump = (CsrPlugin_interrupt && CsrPlugin_pipelineLiberator_done);
  always @ (*) begin
    CsrPlugin_targetPrivilege = CsrPlugin_interruptTargetPrivilege;
    if(CsrPlugin_hadException)begin
      CsrPlugin_targetPrivilege = CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
    end
  end

  always @ (*) begin
    CsrPlugin_trapCause = CsrPlugin_interruptCode;
    if(CsrPlugin_hadException)begin
      CsrPlugin_trapCause = CsrPlugin_exceptionPortCtrl_exceptionContext_code;
    end
  end

  assign contextSwitching = _zz_82_;
  assign _zz_69_ = (! (((decode_INSTRUCTION[14 : 13] == (2'b01)) && (decode_INSTRUCTION[19 : 15] == (5'b00000))) || ((decode_INSTRUCTION[14 : 13] == (2'b11)) && (decode_INSTRUCTION[19 : 15] == (5'b00000)))));
  assign _zz_68_ = (decode_INSTRUCTION[13 : 7] != (7'b0100000));
  assign execute_CsrPlugin_blockedBySideEffects = ({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00));
  always @ (*) begin
    execute_CsrPlugin_illegalAccess = 1'b1;
    execute_CsrPlugin_readData = (32'b00000000000000000000000000000000);
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
        execute_CsrPlugin_readData[12 : 11] = CsrPlugin_mstatus_MPP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mstatus_MPIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mstatus_MIE;
      end
      12'b001101000001 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mepc;
      end
      12'b001101000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mip_MEIP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mip_MTIP;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mip_MSIP;
      end
      12'b001101000011 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mtval;
      end
      12'b001100000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mie_MEIE;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mie_MTIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mie_MSIE;
      end
      12'b001101000010 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
        execute_CsrPlugin_readData[31 : 31] = CsrPlugin_mcause_interrupt;
        execute_CsrPlugin_readData[3 : 0] = CsrPlugin_mcause_exceptionCode;
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
      if((execute_INSTRUCTION[29 : 28] != CsrPlugin_privilege))begin
        execute_CsrPlugin_illegalInstruction = 1'b1;
      end
    end
  end

  assign execute_CsrPlugin_writeInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_WRITE_OPCODE);
  assign execute_CsrPlugin_readInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_READ_OPCODE);
  assign execute_CsrPlugin_writeEnable = ((execute_CsrPlugin_writeInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readEnable = ((execute_CsrPlugin_readInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  always @ (*) begin
    case(_zz_165_)
      1'b0 : begin
        execute_CsrPlugin_writeData = execute_SRC1;
      end
      default : begin
        execute_CsrPlugin_writeData = (execute_INSTRUCTION[12] ? (execute_CsrPlugin_readData & (~ execute_SRC1)) : (execute_CsrPlugin_readData | execute_SRC1));
      end
    endcase
  end

  assign execute_CsrPlugin_csrAddress = execute_INSTRUCTION[31 : 20];
  assign _zz_113_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000010100)) == (32'b00000000000000000000000000000100));
  assign _zz_114_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001010000)) == (32'b00000000000000000000000000010000));
  assign _zz_115_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000100000)) == (32'b00000000000000000000000000000000));
  assign _zz_116_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000000100)) == (32'b00000000000000000000000000000100));
  assign _zz_117_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001010000)) == (32'b00000000000000000100000001010000));
  assign _zz_112_ = {({(_zz_216_ == _zz_217_),{_zz_218_,_zz_219_}} != (3'b000)),{({_zz_220_,_zz_116_} != (2'b00)),{({_zz_221_,_zz_222_} != (2'b00)),{(_zz_223_ != _zz_224_),{_zz_225_,{_zz_226_,_zz_227_}}}}}};
  assign _zz_64_ = ({((decode_INSTRUCTION & (32'b00000000000000000000000001011111)) == (32'b00000000000000000000000000010111)),{((decode_INSTRUCTION & (32'b00000000000000000000000001111111)) == (32'b00000000000000000000000001101111)),{((decode_INSTRUCTION & (32'b00000000000000000001000001101111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_299_) == (32'b00000000000000000001000001110011)),{(_zz_300_ == _zz_301_),{_zz_302_,{_zz_303_,_zz_304_}}}}}}} != (17'b00000000000000000));
  assign _zz_118_ = _zz_112_[0 : 0];
  assign _zz_63_ = _zz_118_;
  assign _zz_62_ = _zz_182_[0];
  assign _zz_119_ = _zz_112_[3 : 2];
  assign _zz_61_ = _zz_119_;
  assign _zz_120_ = _zz_112_[5 : 4];
  assign _zz_60_ = _zz_120_;
  assign _zz_121_ = _zz_112_[7 : 6];
  assign _zz_59_ = _zz_121_;
  assign _zz_58_ = _zz_183_[0];
  assign _zz_57_ = _zz_184_[0];
  assign _zz_56_ = _zz_185_[0];
  assign _zz_55_ = _zz_186_[0];
  assign _zz_54_ = _zz_187_[0];
  assign _zz_53_ = _zz_188_[0];
  assign _zz_52_ = _zz_189_[0];
  assign _zz_122_ = _zz_112_[17 : 16];
  assign _zz_51_ = _zz_122_;
  assign _zz_123_ = _zz_112_[19 : 18];
  assign _zz_50_ = _zz_123_;
  assign _zz_124_ = _zz_112_[21 : 20];
  assign _zz_49_ = _zz_124_;
  assign _zz_48_ = _zz_190_[0];
  assign decodeExceptionPort_valid = ((decode_arbitration_isValid && decode_INSTRUCTION_READY) && (! decode_LEGAL_INSTRUCTION));
  assign decodeExceptionPort_1_code = (4'b0010);
  assign decodeExceptionPort_1_badAddr = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION[24 : 20];
  assign decode_RegFilePlugin_rs1Data = _zz_158_;
  assign decode_RegFilePlugin_rs2Data = _zz_159_;
  assign _zz_47_ = decode_RegFilePlugin_rs1Data;
  assign _zz_46_ = decode_RegFilePlugin_rs2Data;
  always @ (*) begin
    writeBack_RegFilePlugin_regFileWrite_valid = (_zz_44_ && writeBack_arbitration_isFiring);
    if(_zz_125_)begin
      writeBack_RegFilePlugin_regFileWrite_valid = 1'b1;
    end
  end

  assign writeBack_RegFilePlugin_regFileWrite_payload_address = _zz_43_[11 : 7];
  assign writeBack_RegFilePlugin_regFileWrite_payload_data = _zz_42_;
  always @ (*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = execute_SRC1;
      end
    endcase
  end

  always @ (*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_BITWISE : begin
        _zz_126_ = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_126_ = {31'd0, _zz_191_};
      end
      default : begin
        _zz_126_ = execute_SRC_ADD_SUB;
      end
    endcase
  end

  assign _zz_40_ = _zz_126_;
  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_127_ = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_127_ = {29'd0, _zz_192_};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_127_ = {execute_INSTRUCTION[31 : 12],(12'b000000000000)};
      end
      default : begin
        _zz_127_ = {27'd0, _zz_193_};
      end
    endcase
  end

  assign _zz_38_ = _zz_127_;
  assign _zz_128_ = _zz_194_[11];
  always @ (*) begin
    _zz_129_[19] = _zz_128_;
    _zz_129_[18] = _zz_128_;
    _zz_129_[17] = _zz_128_;
    _zz_129_[16] = _zz_128_;
    _zz_129_[15] = _zz_128_;
    _zz_129_[14] = _zz_128_;
    _zz_129_[13] = _zz_128_;
    _zz_129_[12] = _zz_128_;
    _zz_129_[11] = _zz_128_;
    _zz_129_[10] = _zz_128_;
    _zz_129_[9] = _zz_128_;
    _zz_129_[8] = _zz_128_;
    _zz_129_[7] = _zz_128_;
    _zz_129_[6] = _zz_128_;
    _zz_129_[5] = _zz_128_;
    _zz_129_[4] = _zz_128_;
    _zz_129_[3] = _zz_128_;
    _zz_129_[2] = _zz_128_;
    _zz_129_[1] = _zz_128_;
    _zz_129_[0] = _zz_128_;
  end

  assign _zz_130_ = _zz_195_[11];
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
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_132_ = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_132_ = {_zz_129_,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_132_ = {_zz_131_,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_132_ = _zz_34_;
      end
    endcase
  end

  assign _zz_36_ = _zz_132_;
  assign execute_SrcPlugin_addSub = _zz_196_;
  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign _zz_33_ = execute_SrcPlugin_addSub;
  assign _zz_32_ = execute_SrcPlugin_addSub;
  assign _zz_31_ = execute_SrcPlugin_less;
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_133_[0] = execute_SRC1[31];
    _zz_133_[1] = execute_SRC1[30];
    _zz_133_[2] = execute_SRC1[29];
    _zz_133_[3] = execute_SRC1[28];
    _zz_133_[4] = execute_SRC1[27];
    _zz_133_[5] = execute_SRC1[26];
    _zz_133_[6] = execute_SRC1[25];
    _zz_133_[7] = execute_SRC1[24];
    _zz_133_[8] = execute_SRC1[23];
    _zz_133_[9] = execute_SRC1[22];
    _zz_133_[10] = execute_SRC1[21];
    _zz_133_[11] = execute_SRC1[20];
    _zz_133_[12] = execute_SRC1[19];
    _zz_133_[13] = execute_SRC1[18];
    _zz_133_[14] = execute_SRC1[17];
    _zz_133_[15] = execute_SRC1[16];
    _zz_133_[16] = execute_SRC1[15];
    _zz_133_[17] = execute_SRC1[14];
    _zz_133_[18] = execute_SRC1[13];
    _zz_133_[19] = execute_SRC1[12];
    _zz_133_[20] = execute_SRC1[11];
    _zz_133_[21] = execute_SRC1[10];
    _zz_133_[22] = execute_SRC1[9];
    _zz_133_[23] = execute_SRC1[8];
    _zz_133_[24] = execute_SRC1[7];
    _zz_133_[25] = execute_SRC1[6];
    _zz_133_[26] = execute_SRC1[5];
    _zz_133_[27] = execute_SRC1[4];
    _zz_133_[28] = execute_SRC1[3];
    _zz_133_[29] = execute_SRC1[2];
    _zz_133_[30] = execute_SRC1[1];
    _zz_133_[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_133_ : execute_SRC1);
  assign _zz_29_ = _zz_205_;
  always @ (*) begin
    _zz_134_[0] = execute_SHIFT_RIGHT[31];
    _zz_134_[1] = execute_SHIFT_RIGHT[30];
    _zz_134_[2] = execute_SHIFT_RIGHT[29];
    _zz_134_[3] = execute_SHIFT_RIGHT[28];
    _zz_134_[4] = execute_SHIFT_RIGHT[27];
    _zz_134_[5] = execute_SHIFT_RIGHT[26];
    _zz_134_[6] = execute_SHIFT_RIGHT[25];
    _zz_134_[7] = execute_SHIFT_RIGHT[24];
    _zz_134_[8] = execute_SHIFT_RIGHT[23];
    _zz_134_[9] = execute_SHIFT_RIGHT[22];
    _zz_134_[10] = execute_SHIFT_RIGHT[21];
    _zz_134_[11] = execute_SHIFT_RIGHT[20];
    _zz_134_[12] = execute_SHIFT_RIGHT[19];
    _zz_134_[13] = execute_SHIFT_RIGHT[18];
    _zz_134_[14] = execute_SHIFT_RIGHT[17];
    _zz_134_[15] = execute_SHIFT_RIGHT[16];
    _zz_134_[16] = execute_SHIFT_RIGHT[15];
    _zz_134_[17] = execute_SHIFT_RIGHT[14];
    _zz_134_[18] = execute_SHIFT_RIGHT[13];
    _zz_134_[19] = execute_SHIFT_RIGHT[12];
    _zz_134_[20] = execute_SHIFT_RIGHT[11];
    _zz_134_[21] = execute_SHIFT_RIGHT[10];
    _zz_134_[22] = execute_SHIFT_RIGHT[9];
    _zz_134_[23] = execute_SHIFT_RIGHT[8];
    _zz_134_[24] = execute_SHIFT_RIGHT[7];
    _zz_134_[25] = execute_SHIFT_RIGHT[6];
    _zz_134_[26] = execute_SHIFT_RIGHT[5];
    _zz_134_[27] = execute_SHIFT_RIGHT[4];
    _zz_134_[28] = execute_SHIFT_RIGHT[3];
    _zz_134_[29] = execute_SHIFT_RIGHT[2];
    _zz_134_[30] = execute_SHIFT_RIGHT[1];
    _zz_134_[31] = execute_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    _zz_135_ = 1'b0;
    _zz_136_ = 1'b0;
    if((writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID))begin
      if((1'b0 || (! 1'b1)))begin
        if(_zz_141_)begin
          _zz_135_ = 1'b1;
        end
        if(_zz_142_)begin
          _zz_136_ = 1'b1;
        end
      end
    end
    if((memory_arbitration_isValid && memory_REGFILE_WRITE_VALID))begin
      if((1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE)))begin
        if(_zz_143_)begin
          _zz_135_ = 1'b1;
        end
        if(_zz_144_)begin
          _zz_136_ = 1'b1;
        end
      end
    end
    if((execute_arbitration_isValid && execute_REGFILE_WRITE_VALID))begin
      if((1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE)))begin
        if(_zz_145_)begin
          _zz_135_ = 1'b1;
        end
        if(_zz_146_)begin
          _zz_136_ = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_135_ = 1'b0;
    end
    if((! decode_RS2_USE))begin
      _zz_136_ = 1'b0;
    end
  end

  assign _zz_137_ = (_zz_44_ && writeBack_arbitration_isFiring);
  assign _zz_141_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_142_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_143_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_144_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_145_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_146_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_147_ = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_147_ == (3'b000))) begin
        _zz_148_ = execute_BranchPlugin_eq;
    end else if((_zz_147_ == (3'b001))) begin
        _zz_148_ = (! execute_BranchPlugin_eq);
    end else if((((_zz_147_ & (3'b101)) == (3'b101)))) begin
        _zz_148_ = (! execute_SRC_LESS);
    end else begin
        _zz_148_ = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_149_ = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_149_ = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_149_ = 1'b1;
      end
      default : begin
        _zz_149_ = _zz_148_;
      end
    endcase
  end

  assign _zz_28_ = _zz_149_;
  assign execute_BranchPlugin_branch_src1 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JALR) ? execute_RS1 : execute_PC);
  assign _zz_150_ = _zz_207_[19];
  always @ (*) begin
    _zz_151_[10] = _zz_150_;
    _zz_151_[9] = _zz_150_;
    _zz_151_[8] = _zz_150_;
    _zz_151_[7] = _zz_150_;
    _zz_151_[6] = _zz_150_;
    _zz_151_[5] = _zz_150_;
    _zz_151_[4] = _zz_150_;
    _zz_151_[3] = _zz_150_;
    _zz_151_[2] = _zz_150_;
    _zz_151_[1] = _zz_150_;
    _zz_151_[0] = _zz_150_;
  end

  assign _zz_152_ = _zz_208_[11];
  always @ (*) begin
    _zz_153_[19] = _zz_152_;
    _zz_153_[18] = _zz_152_;
    _zz_153_[17] = _zz_152_;
    _zz_153_[16] = _zz_152_;
    _zz_153_[15] = _zz_152_;
    _zz_153_[14] = _zz_152_;
    _zz_153_[13] = _zz_152_;
    _zz_153_[12] = _zz_152_;
    _zz_153_[11] = _zz_152_;
    _zz_153_[10] = _zz_152_;
    _zz_153_[9] = _zz_152_;
    _zz_153_[8] = _zz_152_;
    _zz_153_[7] = _zz_152_;
    _zz_153_[6] = _zz_152_;
    _zz_153_[5] = _zz_152_;
    _zz_153_[4] = _zz_152_;
    _zz_153_[3] = _zz_152_;
    _zz_153_[2] = _zz_152_;
    _zz_153_[1] = _zz_152_;
    _zz_153_[0] = _zz_152_;
  end

  assign _zz_154_ = _zz_209_[11];
  always @ (*) begin
    _zz_155_[18] = _zz_154_;
    _zz_155_[17] = _zz_154_;
    _zz_155_[16] = _zz_154_;
    _zz_155_[15] = _zz_154_;
    _zz_155_[14] = _zz_154_;
    _zz_155_[13] = _zz_154_;
    _zz_155_[12] = _zz_154_;
    _zz_155_[11] = _zz_154_;
    _zz_155_[10] = _zz_154_;
    _zz_155_[9] = _zz_154_;
    _zz_155_[8] = _zz_154_;
    _zz_155_[7] = _zz_154_;
    _zz_155_[6] = _zz_154_;
    _zz_155_[5] = _zz_154_;
    _zz_155_[4] = _zz_154_;
    _zz_155_[3] = _zz_154_;
    _zz_155_[2] = _zz_154_;
    _zz_155_[1] = _zz_154_;
    _zz_155_[0] = _zz_154_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_156_ = {{_zz_151_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_156_ = {_zz_153_,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        _zz_156_ = {{_zz_155_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
      end
    endcase
  end

  assign execute_BranchPlugin_branch_src2 = _zz_156_;
  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign _zz_26_ = {execute_BranchPlugin_branchAdder[31 : 1],(1'b0)};
  assign _zz_84_ = ((execute_arbitration_isValid && (! execute_arbitration_isStuckByOthers)) && execute_BRANCH_DO);
  assign _zz_85_ = execute_BRANCH_CALC;
  always @ (*) begin
    execute_exception_agregat_valid = ((execute_arbitration_isValid && execute_BRANCH_DO) && _zz_85_[1]);
    if(1'b0)begin
      execute_exception_agregat_valid = 1'b0;
    end
  end

  assign execute_exception_agregat_payload_code = (4'b0000);
  assign execute_exception_agregat_payload_badAddr = _zz_85_;
  assign _zz_25_ = decode_SRC1_CTRL;
  assign _zz_23_ = _zz_51_;
  assign _zz_37_ = decode_to_execute_SRC1_CTRL;
  assign _zz_22_ = decode_ALU_BITWISE_CTRL;
  assign _zz_20_ = _zz_49_;
  assign _zz_41_ = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_19_ = decode_ENV_CTRL;
  assign _zz_16_ = execute_ENV_CTRL;
  assign _zz_14_ = memory_ENV_CTRL;
  assign _zz_17_ = _zz_63_;
  assign _zz_67_ = decode_to_execute_ENV_CTRL;
  assign _zz_66_ = execute_to_memory_ENV_CTRL;
  assign _zz_70_ = memory_to_writeBack_ENV_CTRL;
  assign _zz_12_ = decode_SHIFT_CTRL;
  assign _zz_10_ = _zz_60_;
  assign _zz_30_ = decode_to_execute_SHIFT_CTRL;
  assign _zz_9_ = decode_BRANCH_CTRL;
  assign _zz_7_ = _zz_61_;
  assign _zz_27_ = decode_to_execute_BRANCH_CTRL;
  assign _zz_6_ = decode_SRC2_CTRL;
  assign _zz_4_ = _zz_50_;
  assign _zz_35_ = decode_to_execute_SRC2_CTRL;
  assign _zz_3_ = decode_ALU_CTRL;
  assign _zz_1_ = _zz_59_;
  assign _zz_39_ = decode_to_execute_ALU_CTRL;
  assign decode_arbitration_isFlushed = ({writeBack_arbitration_flushAll,{memory_arbitration_flushAll,{execute_arbitration_flushAll,decode_arbitration_flushAll}}} != (4'b0000));
  assign execute_arbitration_isFlushed = ({writeBack_arbitration_flushAll,{memory_arbitration_flushAll,execute_arbitration_flushAll}} != (3'b000));
  assign memory_arbitration_isFlushed = ({writeBack_arbitration_flushAll,memory_arbitration_flushAll} != (2'b00));
  assign writeBack_arbitration_isFlushed = (writeBack_arbitration_flushAll != (1'b0));
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
      CsrPlugin_privilege <= (2'b11);
      IBusSimplePlugin_fetchPc_pcReg <= (32'b00000000000000000000000000000000);
      IBusSimplePlugin_fetchPc_inc <= 1'b0;
      _zz_88_ <= 1'b0;
      _zz_93_ <= 1'b0;
      _zz_94_ <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_0 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_1 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_2 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_3 <= 1'b0;
      IBusSimplePlugin_injector_decodeRemoved <= 1'b0;
      IBusSimplePlugin_pendingCmd <= (3'b000);
      IBusSimplePlugin_rspJoin_discardCounter <= (3'b000);
      CsrPlugin_mstatus_MIE <= 1'b0;
      CsrPlugin_mstatus_MPIE <= 1'b0;
      CsrPlugin_mstatus_MPP <= (2'b11);
      CsrPlugin_mip_MEIP <= 1'b0;
      CsrPlugin_mip_MTIP <= 1'b0;
      CsrPlugin_mip_MSIP <= 1'b0;
      CsrPlugin_mie_MEIE <= 1'b0;
      CsrPlugin_mie_MTIE <= 1'b0;
      CsrPlugin_mie_MSIE <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      CsrPlugin_hadException <= 1'b0;
      _zz_125_ <= 1'b1;
      _zz_138_ <= 1'b0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      memory_to_writeBack_REGFILE_WRITE_DATA <= (32'b00000000000000000000000000000000);
      memory_to_writeBack_INSTRUCTION <= (32'b00000000000000000000000000000000);
    end else begin
      if(IBusSimplePlugin_fetchPc_propagatePc)begin
        IBusSimplePlugin_fetchPc_inc <= 1'b0;
      end
      if(IBusSimplePlugin_jump_pcLoad_valid)begin
        IBusSimplePlugin_fetchPc_inc <= 1'b0;
      end
      if(_zz_162_)begin
        IBusSimplePlugin_fetchPc_inc <= 1'b1;
      end
      if(IBusSimplePlugin_fetchPc_samplePcNext)begin
        IBusSimplePlugin_fetchPc_pcReg <= IBusSimplePlugin_fetchPc_pc;
      end
      _zz_88_ <= 1'b1;
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        _zz_93_ <= 1'b0;
      end
      if(_zz_91_)begin
        _zz_93_ <= IBusSimplePlugin_iBusRsp_stages_0_output_valid;
      end
      if(IBusSimplePlugin_iBusRsp_inputBeforeStage_ready)begin
        _zz_94_ <= IBusSimplePlugin_iBusRsp_inputBeforeStage_valid;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        _zz_94_ <= 1'b0;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if((! (! IBusSimplePlugin_iBusRsp_stages_1_input_ready)))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_injector_nextPcCalc_0 <= 1'b0;
      end
      if((! (! IBusSimplePlugin_injector_decodeInput_ready)))begin
        IBusSimplePlugin_injector_nextPcCalc_0 <= IBusSimplePlugin_injector_nextPcCalc_valids_0;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_injector_nextPcCalc_0 <= 1'b0;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_injector_nextPcCalc_1 <= 1'b0;
      end
      if((! execute_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_1 <= IBusSimplePlugin_injector_nextPcCalc_0;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_injector_nextPcCalc_1 <= 1'b0;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_injector_nextPcCalc_2 <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_2 <= IBusSimplePlugin_injector_nextPcCalc_1;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_injector_nextPcCalc_2 <= 1'b0;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_injector_nextPcCalc_3 <= 1'b0;
      end
      if((! writeBack_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_3 <= IBusSimplePlugin_injector_nextPcCalc_2;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_injector_nextPcCalc_3 <= 1'b0;
      end
      if(decode_arbitration_removeIt)begin
        IBusSimplePlugin_injector_decodeRemoved <= 1'b1;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_injector_decodeRemoved <= 1'b0;
      end
      IBusSimplePlugin_pendingCmd <= IBusSimplePlugin_pendingCmdNext;
      IBusSimplePlugin_rspJoin_discardCounter <= (IBusSimplePlugin_rspJoin_discardCounter - _zz_176_);
      if((IBusSimplePlugin_jump_pcLoad_valid || _zz_80_))begin
        IBusSimplePlugin_rspJoin_discardCounter <= (IBusSimplePlugin_pendingCmd - _zz_178_);
      end
      CsrPlugin_mip_MEIP <= externalInterrupt;
      CsrPlugin_mip_MTIP <= timerInterrupt;
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
      CsrPlugin_hadException <= CsrPlugin_exception;
      if(_zz_160_)begin
        CsrPlugin_privilege <= CsrPlugin_targetPrivilege;
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
      if(_zz_161_)begin
        case(_zz_164_)
          2'b11 : begin
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPP <= (2'b00);
            CsrPlugin_mstatus_MPIE <= 1'b1;
            CsrPlugin_privilege <= CsrPlugin_mstatus_MPP;
          end
          default : begin
          end
        endcase
      end
      _zz_125_ <= 1'b0;
      _zz_138_ <= _zz_137_;
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_71_;
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
            CsrPlugin_mstatus_MPIE <= _zz_210_[0];
            CsrPlugin_mstatus_MIE <= _zz_211_[0];
          end
        end
        12'b001101000001 : begin
        end
        12'b001101000100 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mip_MSIP <= _zz_212_[0];
          end
        end
        12'b001101000011 : begin
        end
        12'b001100000100 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mie_MEIE <= _zz_213_[0];
            CsrPlugin_mie_MTIE <= _zz_214_[0];
            CsrPlugin_mie_MSIE <= _zz_215_[0];
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
      _zz_95_ <= IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_pc;
      _zz_96_ <= IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_error;
      _zz_97_ <= IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_raw;
      _zz_98_ <= IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_isRvc;
    end
    if(IBusSimplePlugin_injector_decodeInput_ready)begin
      IBusSimplePlugin_injector_formal_rawInDecode <= IBusSimplePlugin_iBusRsp_inputBeforeStage_payload_rsp_raw;
    end
    if(!(! (((dBus_rsp_ready && memory_MEMORY_ENABLE) && memory_arbitration_isValid) && memory_arbitration_isStuck))) begin
      $display("ERROR DBusSimplePlugin doesn't allow memory stage stall when read happend");
    end
    CsrPlugin_mcycle <= (CsrPlugin_mcycle + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    if(writeBack_arbitration_isFiring)begin
      CsrPlugin_minstret <= (CsrPlugin_minstret + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    end
    if(decode_exception_agregat_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= decode_exception_agregat_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= decode_exception_agregat_payload_badAddr;
    end
    if(execute_exception_agregat_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= execute_exception_agregat_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= execute_exception_agregat_payload_badAddr;
    end
    if(memory_exception_agregat_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= memory_exception_agregat_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= memory_exception_agregat_payload_badAddr;
    end
    if((CsrPlugin_exception || CsrPlugin_interruptJump))begin
      case(CsrPlugin_privilege)
        2'b11 : begin
          CsrPlugin_mepc <= writeBack_PC;
        end
        default : begin
        end
      endcase
    end
    if(_zz_160_)begin
      case(CsrPlugin_targetPrivilege)
        2'b11 : begin
          CsrPlugin_mcause_interrupt <= (! CsrPlugin_hadException);
          CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
          CsrPlugin_mtval <= CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
        end
        default : begin
        end
      endcase
    end
    if(_zz_137_)begin
      _zz_139_ <= _zz_43_[11 : 7];
      _zz_140_ <= _zz_42_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CSR <= decode_IS_CSR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ALIGNEMENT_FAULT <= execute_ALIGNEMENT_FAULT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_65_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_24_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_21_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= decode_RS2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ENV_CTRL <= _zz_18_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ENV_CTRL <= _zz_15_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_ENV_CTRL <= _zz_13_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_11_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= decode_PC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= _zz_34_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_8_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_5_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
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
      decode_to_execute_ALU_CTRL <= _zz_2_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= decode_FORMAL_PC_NEXT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= _zz_75_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= memory_FORMAL_PC_NEXT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
      end
      12'b001101000001 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mepc <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001101000100 : begin
      end
      12'b001101000011 : begin
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

