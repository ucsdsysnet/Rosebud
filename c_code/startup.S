# #define r_type_insn(_f7, _rs2, _rs1, _f3, _rd, _opc) \
# .word (((_f7) << 25) | ((_rs2) << 20) | ((_rs1) << 15) | ((_f3) << 12) | ((_rd) << 7) | ((_opc) << 0))
# 
# #define TAIL_ZERO(_rd, _rs1) \
#   r_type_insn(0b0000011, 0b00000, _rs1, 0b011, _rd, 0b0110011)

.section .vectors
.align 4

    # reset vector entry point
reset_vector:
    j _start
    # interrupt handler entry point
int_vector:
    j int_handler

    .weak int_handler
    .set int_handler, dummy_handler

    # dummy handler
dummy_handler:
    j dummy_handler

    .section .text
    .global _start
_start:
    # set initial SP
    la sp, _end_stack
    # enable timer and external interrupts
    li a0, 0x880
    csrw mie,a0
    # enable interrupts
    li a0, 0x1808
    csrw mstatus,a0
    # jump to main
    jal main

    # loop if main returns
1:
    j 1b

