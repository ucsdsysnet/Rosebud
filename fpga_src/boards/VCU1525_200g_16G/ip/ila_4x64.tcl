
create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila_4x64

set_property -dict [list \
    CONFIG.C_PROBE3_WIDTH {64} \
    CONFIG.C_PROBE2_WIDTH {64} \
    CONFIG.C_PROBE1_WIDTH {64} \
    CONFIG.C_PROBE0_WIDTH {64} \
    CONFIG.C_DATA_DEPTH {2048} \
    CONFIG.C_NUM_OF_PROBES {4} \
    CONFIG.C_TRIGOUT_EN {true} \
    CONFIG.C_INPUT_PIPE_STAGES {2} \
    CONFIG.C_PROBE3_MU_CNT {2} \
    CONFIG.C_PROBE2_MU_CNT {2} \
    CONFIG.C_PROBE1_MU_CNT {2} \
    CONFIG.C_PROBE0_MU_CNT {2} \
    CONFIG.C_TRIGIN_EN {true} \
    CONFIG.ALL_PROBE_SAME_MU_CNT {2}
] [get_ips ila_4x64]

