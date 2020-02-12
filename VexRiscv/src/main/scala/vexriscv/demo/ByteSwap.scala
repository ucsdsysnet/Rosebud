package vexriscv.demo

import spinal.core._
import spinal.lib._
import vexriscv.plugin.Plugin
import vexriscv.{Stageable, DecoderService, VexRiscv}

//Instruction encoding :
//0000011----------000-----0110011
//       |RS2||RS1|   |RD |
//
//Note :  RS1, RS2, RD positions follow the RISC-V spec and are common for all instruction of the ISA

class BSWAP32 extends Plugin[VexRiscv]{
  //Define the concept of IS_BSWAP_32 signals, which specify if the current instruction is destined for ths plugin
  object IS_BSWAP_32 extends Stageable(Bool)

  //Callback to setup the plugin and ask for different services
  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    //Retrieve the DecoderService instance
    val decoderService = pipeline.service(classOf[DecoderService])

    //Specify the IS_BSWAP_32 default value when instruction are decoded
    decoderService.addDefault(IS_BSWAP_32, False)

    //Specify the instruction decoding which should be applied when the instruction match the 'key' parttern
    decoderService.add(
      key = M"0000011----------000-----0110011",

      //Decoding specification when the 'key' pattern is recognized in the instruction
      List(
        IS_BSWAP_32              -> True,
        REGFILE_WRITE_VALID      -> True, //Enable the register file write
        BYPASSABLE_EXECUTE_STAGE -> True, //Notify the hazard management unit that the instruction result is already accessible in the EXECUTE stage (Bypass ready)
        BYPASSABLE_MEMORY_STAGE  -> True, //Same as above but for the memory stage
        RS1_USE                  -> True, //Notify the hazard management unit that this instruction use the RS1 value
        RS2_USE                  -> False //Same than above but for RS2.
      )
    )
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    //Add a new scope on the execute stage (used to give a name to signals)
    execute plug new Area {
      //Define some signals used internally to the plugin
      val rs1 = execute.input(RS1).asUInt //32 bits UInt value of the regfile[RS1]
      // val rs2 = execute.input(RS2).asUInt
      val rd = UInt(32 bits)

      //Do some computation
      rd(31 downto 24) := rs1(7 downto 0)
      rd(23 downto 16) := rs1(15 downto 8)
      rd(15 downto 8) := rs1(23 downto 16)
      rd(7 downto 0) := rs1(31 downto 24)

      //When the instruction is a SIMD_ADD one, then write the result into the register file data path.
      when(execute.input(IS_BSWAP_32)) {
        execute.output(REGFILE_WRITE_DATA) := rd.asBits
      }
    }
  }
}

//Instruction encoding :
//0000011----------001-----0110011
//       |RS2||RS1|   |RD |
//
//Note :  RS1, RS2, RD positions follow the RISC-V spec and are common for all instruction of the ISA

class BSWAP16 extends Plugin[VexRiscv]{
  //Define the concept of IS_BSWAP_16 signals, which specify if the current instruction is destined for ths plugin
  object IS_BSWAP_16 extends Stageable(Bool)

  //Callback to setup the plugin and ask for different services
  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    //Retrieve the DecoderService instance
    val decoderService = pipeline.service(classOf[DecoderService])

    //Specify the IS_BSWAP_16 default value when instruction are decoded
    decoderService.addDefault(IS_BSWAP_16, False)

    //Specify the instruction decoding which should be applied when the instruction match the 'key' parttern
    decoderService.add(
      key = M"0000011----------001-----0110011",

      //Decoding specification when the 'key' pattern is recognized in the instruction
      List(
        IS_BSWAP_16              -> True,
        REGFILE_WRITE_VALID      -> True, //Enable the register file write
        BYPASSABLE_EXECUTE_STAGE -> True, //Notify the hazard management unit that the instruction result is already accessible in the EXECUTE stage (Bypass ready)
        BYPASSABLE_MEMORY_STAGE  -> True, //Same as above but for the memory stage
        RS1_USE                  -> True, //Notify the hazard management unit that this instruction use the RS1 value
        RS2_USE                  -> False //Same than above but for RS2.
      )
    )
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    //Add a new scope on the execute stage (used to give a name to signals)
    execute plug new Area {
      //Define some signals used internally to the plugin
      val rs1 = execute.input(RS1).asUInt //32 bits UInt value of the regfile[RS1]
      // val rs2 = execute.input(RS2).asUInt
      val rd = UInt(32 bits)

      //Do some computation
      rd(31 downto 24) := rs1(7 downto 0)
      rd(23 downto 16) := rs1(15 downto 8)
      rd(15 downto 8) := rs1(7 downto 0)
      rd(7 downto 0) := rs1(15 downto 8)

      //When the instruction is a SIMD_ADD one, then write the result into the register file data path.
      when(execute.input(IS_BSWAP_16)) {
        execute.output(REGFILE_WRITE_DATA) := rd.asBits
      }
    }
  }
}

//Instruction encoding :
//0000011----------010-----0110011
//       |RS2||RS1|   |RD |
//
//Note :  RS1, RS2, RD positions follow the RISC-V spec and are common for all instruction of the ISA
class FIRST1 extends Plugin[VexRiscv]{
  //Define the concept of IS_BSWAP_16 signals, which specify if the current instruction is destined for ths plugin
  object IS_FIRST1 extends Stageable(Bool)

  //Callback to setup the plugin and ask for different services
  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    //Retrieve the DecoderService instance
    val decoderService = pipeline.service(classOf[DecoderService])

    //Specify the IS_BSWAP_16 default value when instruction are decoded
    decoderService.addDefault(IS_FIRST1, False)

    //Specify the instruction decoding which should be applied when the instruction match the 'key' parttern
    decoderService.add(
      key = M"0000011----------010-----0110011",

      //Decoding specification when the 'key' pattern is recognized in the instruction
      List(
        IS_FIRST1                -> True,
        REGFILE_WRITE_VALID      -> True, //Enable the register file write
        BYPASSABLE_EXECUTE_STAGE -> True, //Notify the hazard management unit that the instruction result is already accessible in the EXECUTE stage (Bypass ready)
        BYPASSABLE_MEMORY_STAGE  -> True, //Same as above but for the memory stage
        RS1_USE                  -> True, //Notify the hazard management unit that this instruction use the RS1 value
        RS2_USE                  -> False //Same than above but for RS2.
      )
    )
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    //Add a new scope on the execute stage (used to give a name to signals)
    execute plug new Area {
      //Define some signals used internally to the plugin
      val rs1 = execute.input(RS1).asUInt //32 bits UInt value of the regfile[RS1]
      // val rs2 = execute.input(RS2).asUInt
      val rd = UInt(32 bits)

      //Do some computation
      rd(4 downto 0)  := OHToUInt(OHMasking.first(rs1))
      rd(31 downto 5) := 0

      //When the instruction is a SIMD_ADD one, then write the result into the register file data path.
      when(execute.input(IS_FIRST1)) {
        execute.output(REGFILE_WRITE_DATA) := rd.asBits
      }
    }
  }
}

//Instruction encoding :
//0000011----------011-----0110011
//       |RS2||RS1|   |RD |
//
//Note :  RS1, RS2, RD positions follow the RISC-V spec and are common for all instruction of the ISA
class LEAD_ZERO extends Plugin[VexRiscv]{
  //Define the concept of IS_BSWAP_16 signals, which specify if the current instruction is destined for ths plugin
  object IS_LEAD_ZERO extends Stageable(Bool)

  //Callback to setup the plugin and ask for different services
  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    //Retrieve the DecoderService instance
    val decoderService = pipeline.service(classOf[DecoderService])

    //Specify the IS_BSWAP_16 default value when instruction are decoded
    decoderService.addDefault(IS_LEAD_ZERO, False)

    //Specify the instruction decoding which should be applied when the instruction match the 'key' parttern
    decoderService.add(
      key = M"0000011----------011-----0110011",

      //Decoding specification when the 'key' pattern is recognized in the instruction
      List(
        IS_LEAD_ZERO             -> True,
        REGFILE_WRITE_VALID      -> True, //Enable the register file write
        BYPASSABLE_EXECUTE_STAGE -> True, //Notify the hazard management unit that the instruction result is already accessible in the EXECUTE stage (Bypass ready)
        BYPASSABLE_MEMORY_STAGE  -> True, //Same as above but for the memory stage
        RS1_USE                  -> True, //Notify the hazard management unit that this instruction use the RS1 value
        RS2_USE                  -> False //Same than above but for RS2.
      )
    )
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    //Add a new scope on the execute stage (used to give a name to signals)
    execute plug new Area {
      //Define some signals used internally to the plugin
      val rs1 = execute.input(RS1).asUInt //32 bits UInt value of the regfile[RS1]
      // val rs2 = execute.input(RS2).asUInt
      val rd = UInt(32 bits)

      //Do some computation
      rd(5 downto 0)  := OHToUInt(!rs1.orR ## OHMasking.first(rs1))
      rd(31 downto 6) := 0

      //When the instruction is a SIMD_ADD one, then write the result into the register file data path.
      when(execute.input(IS_LEAD_ZERO)) {
        execute.output(REGFILE_WRITE_DATA) := rd.asBits
      }
    }
  }
}
