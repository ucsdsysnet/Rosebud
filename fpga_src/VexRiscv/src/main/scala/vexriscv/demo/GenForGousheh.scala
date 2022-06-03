package vexriscv.demo

import vexriscv.plugin._
import vexriscv.{plugin, VexRiscv, VexRiscvConfig}
import spinal.core._

/**
 * Created by spinalvm on 15.06.17.
 * Modified by Moein on 2019-21.
 */
object GenForGousheh extends App{
  def cpu() = new VexRiscv(
    config = VexRiscvConfig(
      plugins = List(
        // new BSWAP32,
        // new BSWAP16,
        // new FIRST1,
        // new TAIL_ZERO,
        new IBusSimplePlugin(
          resetVector = 0x00000000l,
          cmdForkOnSecondStage = false,
          cmdForkPersistence = false,
          prediction = NONE, // STATIC, // DYNAMIC_TARGET, // NONE,
          catchAccessFault = false,
          compressedGen = false,
          busLatencyMin = 1
        ),
        new DBusSimplePlugin(
          catchAddressMisaligned = true,
          catchAccessFault = true,
          earlyInjection = true
        ),
        new CsrPlugin(CsrPluginConfig.smallest(0x00000004l)),
        new DecoderSimplePlugin(
          catchIllegalInstruction = true
        ),
        new RegFilePlugin(
          regFileReadyKind = plugin.ASYNC,
          zeroBoot = false
        ),
        new IntAluPlugin,
        new SrcPlugin(
          separatedAddSub = false,
          executeInsertion = true
        ),
        new FullBarrelShifterPlugin(
          earlyInjection = false
        ),
        new HazardSimplePlugin(
          bypassExecute           = true,
          bypassMemory            = true,
          bypassWriteBack         = true,
          bypassWriteBackBuffer   = true,
          pessimisticUseSrc       = false,
          pessimisticWriteRegFile = false,
          pessimisticAddressMatch = false
        ),
        // new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset"))),
        new BranchPlugin(
          earlyBranch = true,
          catchAddressMisaligned = true
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
  )

  SpinalVerilog(cpu())
}
