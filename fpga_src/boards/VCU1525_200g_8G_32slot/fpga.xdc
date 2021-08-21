# XDC constraints for the Xilinx VCU1525 board
# part: xcvu9p-fsgd2104-2L-e

# General configuration
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN DIV-1 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]

# System clocks
# 300 MHz (DDR 0)
#set_property -dict {LOC AY37 IOSTANDARD LVDS} [get_ports clk_300mhz_0_p]
#set_property -dict {LOC AY38 IOSTANDARD LVDS} [get_ports clk_300mhz_0_n]
#create_clock -period 3.333 -name clk_300mhz_0 [get_ports clk_300mhz_0_p]

# 300 MHz (DDR 1)
#set_property -dict {LOC AW20 IOSTANDARD LVDS} [get_ports clk_300mhz_1_p]
#set_property -dict {LOC AW19 IOSTANDARD LVDS} [get_ports clk_300mhz_1_n]
#create_clock -period 3.333 -name clk_300mhz_1 [get_ports clk_300mhz_1_p]

# 300 MHz (DDR 2)
#set_property -dict {LOC F32  IOSTANDARD LVDS} [get_ports clk_300mhz_2_p]
#set_property -dict {LOC E32  IOSTANDARD LVDS} [get_ports clk_300mhz_2_n]
#create_clock -period 3.333 -name clk_300mhz_2 [get_ports clk_300mhz_2_p]

# 300 MHz (DDR 3)
#set_property -dict {LOC J16  IOSTANDARD LVDS} [get_ports clk_300mhz_3_p]
#set_property -dict {LOC H16  IOSTANDARD LVDS} [get_ports clk_300mhz_3_n]
#create_clock -period 3.333 -name clk_300mhz_3 [get_ports clk_300mhz_3_p]

# SI570 user clock
#set_property -dict {LOC AU19 IOSTANDARD LVDS} [get_ports clk_user_p]
#set_property -dict {LOC AV19 IOSTANDARD LVDS} [get_ports clk_user_n]
#create_clock -period 6.400 -name clk_user [get_ports clk_user_p]

# LEDs
set_property -dict {LOC BC21 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[0]}]
set_property -dict {LOC BB21 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[1]}]
set_property -dict {LOC BA20 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[2]}]

# Reset button
#set_property -dict {LOC AL20 IOSTANDARD LVCMOS12} [get_ports reset]

# DIP switches
set_property -dict {LOC AN22 IOSTANDARD LVCMOS12} [get_ports {sw[0]}]
set_property -dict {LOC AM19 IOSTANDARD LVCMOS12} [get_ports {sw[1]}]
set_property -dict {LOC AL19 IOSTANDARD LVCMOS12} [get_ports {sw[2]}]
set_property -dict {LOC AP20 IOSTANDARD LVCMOS12} [get_ports {sw[3]}]

# UART
#set_property -dict {LOC BB20 IOSTANDARD LVCMOS12} [get_ports uart_txd]
#set_property -dict {LOC BF18 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports uart_rxd]

# QSFP28 Interfaces
set_property -dict {LOC N9} [get_ports qsfp0_tx1_p]
#set_property -dict {LOC N8  } [get_ports qsfp0_tx1_n] ;# MGTYTXN0_231 GTYE4_CHANNEL_X1Y48 / GTYE4_COMMON_X1Y12
set_property -dict {LOC N4} [get_ports qsfp0_rx1_p]
#set_property -dict {LOC N3  } [get_ports qsfp0_rx1_n] ;# MGTYRXN0_231 GTYE4_CHANNEL_X1Y48 / GTYE4_COMMON_X1Y12
set_property -dict {LOC M7} [get_ports qsfp0_tx2_p]
#set_property -dict {LOC M6  } [get_ports qsfp0_tx2_n] ;# MGTYTXN1_231 GTYE4_CHANNEL_X1Y49 / GTYE4_COMMON_X1Y12
set_property -dict {LOC M2} [get_ports qsfp0_rx2_p]
#set_property -dict {LOC M1  } [get_ports qsfp0_rx2_n] ;# MGTYRXN1_231 GTYE4_CHANNEL_X1Y49 / GTYE4_COMMON_X1Y12
set_property -dict {LOC L9} [get_ports qsfp0_tx3_p]
#set_property -dict {LOC L8  } [get_ports qsfp0_tx3_n] ;# MGTYTXN2_231 GTYE4_CHANNEL_X1Y50 / GTYE4_COMMON_X1Y12
set_property -dict {LOC L4} [get_ports qsfp0_rx3_p]
#set_property -dict {LOC L3  } [get_ports qsfp0_rx3_n] ;# MGTYRXN2_231 GTYE4_CHANNEL_X1Y50 / GTYE4_COMMON_X1Y12
set_property -dict {LOC K7} [get_ports qsfp0_tx4_p]
#set_property -dict {LOC K6  } [get_ports qsfp0_tx4_n] ;# MGTYTXN3_231 GTYE4_CHANNEL_X1Y51 / GTYE4_COMMON_X1Y12
set_property -dict {LOC K2} [get_ports qsfp0_rx4_p]
#set_property -dict {LOC K1  } [get_ports qsfp0_rx4_n] ;# MGTYRXN3_231 GTYE4_CHANNEL_X1Y51 / GTYE4_COMMON_X1Y12
#set_property -dict {LOC M11 } [get_ports qsfp0_mgt_refclk_0_p] ;# MGTREFCLK0P_231 from U14.4 via U43.13
#set_property -dict {LOC M10 } [get_ports qsfp0_mgt_refclk_0_n] ;# MGTREFCLK0N_231 from U14.5 via U43.14
set_property -dict {LOC K11} [get_ports qsfp0_mgt_refclk_1_p]
#set_property -dict {LOC K10 } [get_ports qsfp0_mgt_refclk_1_n] ;# MGTREFCLK1N_231 from U9.17
set_property -dict {LOC BE16 IOSTANDARD LVCMOS12} [get_ports qsfp0_modsell]
set_property -dict {LOC BE17 IOSTANDARD LVCMOS12} [get_ports qsfp0_resetl]
set_property -dict {LOC BE20 IOSTANDARD LVCMOS12} [get_ports qsfp0_modprsl]
set_property -dict {LOC BE21 IOSTANDARD LVCMOS12} [get_ports qsfp0_intl]
set_property -dict {LOC BD18 IOSTANDARD LVCMOS12} [get_ports qsfp0_lpmode]
set_property -dict {LOC AT22 IOSTANDARD LVCMOS12} [get_ports qsfp0_refclk_reset]
set_property -dict {LOC AT20 IOSTANDARD LVCMOS12} [get_ports {qsfp0_fs[0]}]
set_property -dict {LOC AU22 IOSTANDARD LVCMOS12} [get_ports {qsfp0_fs[1]}]

# 156.25 MHz MGT reference clock (from SI570)
#create_clock -period 6.400 -name qsfp0_mgt_refclk_0 [get_ports qsfp0_mgt_refclk_0_p]

# 156.25 MHz MGT reference clock (from SI5335, FS = 0b01)
#create_clock -period 6.400 -name qsfp0_mgt_refclk_1 [get_ports qsfp0_mgt_refclk_1_p]

# 161.1328125 MHz MGT reference clock (from SI5335, FS = 0b10)
#create_clock -period 6.206 -name qsfp0_mgt_refclk_1 [get_ports qsfp0_mgt_refclk_1_p]

set_property -dict {LOC U9} [get_ports qsfp1_tx1_p]
#set_property -dict {LOC U8  } [get_ports qsfp1_tx1_n] ;# MGTYTXN0_230 GTYE4_CHANNEL_X1Y44 / GTYE4_COMMON_X1Y11
set_property -dict {LOC U4} [get_ports qsfp1_rx1_p]
#set_property -dict {LOC U3  } [get_ports qsfp1_rx1_n] ;# MGTYRXN0_230 GTYE4_CHANNEL_X1Y44 / GTYE4_COMMON_X1Y11
set_property -dict {LOC T7} [get_ports qsfp1_tx2_p]
#set_property -dict {LOC T6  } [get_ports qsfp1_tx2_n] ;# MGTYTXN1_230 GTYE4_CHANNEL_X1Y45 / GTYE4_COMMON_X1Y11
set_property -dict {LOC T2} [get_ports qsfp1_rx2_p]
#set_property -dict {LOC T1  } [get_ports qsfp1_rx2_n] ;# MGTYRXN1_230 GTYE4_CHANNEL_X1Y45 / GTYE4_COMMON_X1Y11
set_property -dict {LOC R9} [get_ports qsfp1_tx3_p]
#set_property -dict {LOC R8  } [get_ports qsfp1_tx3_n] ;# MGTYTXN2_230 GTYE4_CHANNEL_X1Y46 / GTYE4_COMMON_X1Y11
set_property -dict {LOC R4} [get_ports qsfp1_rx3_p]
#set_property -dict {LOC R3  } [get_ports qsfp1_rx3_n] ;# MGTYRXN2_230 GTYE4_CHANNEL_X1Y46 / GTYE4_COMMON_X1Y11
set_property -dict {LOC P7} [get_ports qsfp1_tx4_p]
#set_property -dict {LOC P6  } [get_ports qsfp1_tx4_n] ;# MGTYTXN3_230 GTYE4_CHANNEL_X1Y47 / GTYE4_COMMON_X1Y11
set_property -dict {LOC P2} [get_ports qsfp1_rx4_p]
#set_property -dict {LOC P1  } [get_ports qsfp1_rx4_n] ;# MGTYRXN3_230 GTYE4_CHANNEL_X1Y47 / GTYE4_COMMON_X1Y11
#set_property -dict {LOC T11 } [get_ports qsfp1_mgt_refclk_0_p] ;# MGTREFCLK0P_230 from U14.4 via U43.15
#set_property -dict {LOC T10 } [get_ports qsfp1_mgt_refclk_0_n] ;# MGTREFCLK0N_230 from U14.5 via U43.16
set_property -dict {LOC P11} [get_ports qsfp1_mgt_refclk_1_p]
#set_property -dict {LOC P10 } [get_ports qsfp1_mgt_refclk_1_n] ;# MGTREFCLK1N_230 from U12.17
set_property -dict {LOC AY20 IOSTANDARD LVCMOS12} [get_ports qsfp1_modsell]
set_property -dict {LOC BC18 IOSTANDARD LVCMOS12} [get_ports qsfp1_resetl]
set_property -dict {LOC BC19 IOSTANDARD LVCMOS12} [get_ports qsfp1_modprsl]
set_property -dict {LOC AV21 IOSTANDARD LVCMOS12} [get_ports qsfp1_intl]
set_property -dict {LOC AV22 IOSTANDARD LVCMOS12} [get_ports qsfp1_lpmode]
set_property -dict {LOC AR21 IOSTANDARD LVCMOS12} [get_ports qsfp1_refclk_reset]
set_property -dict {LOC AR22 IOSTANDARD LVCMOS12} [get_ports {qsfp1_fs[0]}]
set_property -dict {LOC AU20 IOSTANDARD LVCMOS12} [get_ports {qsfp1_fs[1]}]

# 156.25 MHz MGT reference clock (from SI570)
#create_clock -period 6.400 -name qsfp1_mgt_refclk_0 [get_ports qsfp1_mgt_refclk_0_p]

# 156.25 MHz MGT reference clock (from SI5335, FS = 0b01)
#create_clock -period 6.400 -name qsfp1_mgt_refclk_1 [get_ports qsfp1_mgt_refclk_1_p]

# 161.1328125 MHz MGT reference clock (from SI5335, FS = 0b10)
#create_clock -period 6.206 -name qsfp1_mgt_refclk_1 [get_ports qsfp1_mgt_refclk_1_p]

# I2C interface
#set_property -dict {LOC BF19 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports i2c_mux_reset]
set_property -dict {LOC BF20 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports i2c_scl]
set_property -dict {LOC BF17 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports i2c_sda]

# PCIe Interface
set_property -dict {LOC AF2} [get_ports {pcie_rx_p[0]}]
#set_property -dict {LOC AF1  } [get_ports {pcie_rx_n[0]}]  ;# MGTYRXN3_227 GTYE4_CHANNEL_X1Y35 / GTYE4_COMMON_X1Y8
set_property -dict {LOC AF7} [get_ports {pcie_tx_p[0]}]
#set_property -dict {LOC AF6  } [get_ports {pcie_tx_n[0]}]  ;# MGTYTXN3_227 GTYE4_CHANNEL_X1Y35 / GTYE4_COMMON_X1Y8
set_property -dict {LOC AG4} [get_ports {pcie_rx_p[1]}]
#set_property -dict {LOC AG3  } [get_ports {pcie_rx_n[1]}]  ;# MGTYRXN2_227 GTYE4_CHANNEL_X1Y34 / GTYE4_COMMON_X1Y8
set_property -dict {LOC AG9} [get_ports {pcie_tx_p[1]}]
#set_property -dict {LOC AG8  } [get_ports {pcie_tx_n[1]}]  ;# MGTYTXN2_227 GTYE4_CHANNEL_X1Y34 / GTYE4_COMMON_X1Y8
set_property -dict {LOC AH2} [get_ports {pcie_rx_p[2]}]
#set_property -dict {LOC AH1  } [get_ports {pcie_rx_n[2]}]  ;# MGTYRXN1_227 GTYE4_CHANNEL_X1Y33 / GTYE4_COMMON_X1Y8
set_property -dict {LOC AH7} [get_ports {pcie_tx_p[2]}]
#set_property -dict {LOC AH6  } [get_ports {pcie_tx_n[2]}]  ;# MGTYTXN1_227 GTYE4_CHANNEL_X1Y33 / GTYE4_COMMON_X1Y8
set_property -dict {LOC AJ4} [get_ports {pcie_rx_p[3]}]
#set_property -dict {LOC AJ3  } [get_ports {pcie_rx_n[3]}]  ;# MGTYRXN0_227 GTYE4_CHANNEL_X1Y32 / GTYE4_COMMON_X1Y8
set_property -dict {LOC AJ9} [get_ports {pcie_tx_p[3]}]
#set_property -dict {LOC AJ8  } [get_ports {pcie_tx_n[3]}]  ;# MGTYTXN0_227 GTYE4_CHANNEL_X1Y32 / GTYE4_COMMON_X1Y8
set_property -dict {LOC AK2} [get_ports {pcie_rx_p[4]}]
#set_property -dict {LOC AK1  } [get_ports {pcie_rx_n[4]}]  ;# MGTYRXN3_226 GTYE4_CHANNEL_X1Y31 / GTYE4_COMMON_X1Y7
set_property -dict {LOC AK7} [get_ports {pcie_tx_p[4]}]
#set_property -dict {LOC AK6  } [get_ports {pcie_tx_n[4]}]  ;# MGTYTXN3_226 GTYE4_CHANNEL_X1Y31 / GTYE4_COMMON_X1Y7
set_property -dict {LOC AL4} [get_ports {pcie_rx_p[5]}]
#set_property -dict {LOC AL3  } [get_ports {pcie_rx_n[5]}]  ;# MGTYRXN2_226 GTYE4_CHANNEL_X1Y30 / GTYE4_COMMON_X1Y7
set_property -dict {LOC AL9} [get_ports {pcie_tx_p[5]}]
#set_property -dict {LOC AL8  } [get_ports {pcie_tx_n[5]}]  ;# MGTYTXN2_226 GTYE4_CHANNEL_X1Y30 / GTYE4_COMMON_X1Y7
set_property -dict {LOC AM2} [get_ports {pcie_rx_p[6]}]
#set_property -dict {LOC AM1  } [get_ports {pcie_rx_n[6]}]  ;# MGTYRXN1_226 GTYE4_CHANNEL_X1Y29 / GTYE4_COMMON_X1Y7
set_property -dict {LOC AM7} [get_ports {pcie_tx_p[6]}]
#set_property -dict {LOC AM6  } [get_ports {pcie_tx_n[6]}]  ;# MGTYTXN1_226 GTYE4_CHANNEL_X1Y29 / GTYE4_COMMON_X1Y7
set_property -dict {LOC AN4} [get_ports {pcie_rx_p[7]}]
#set_property -dict {LOC AN3  } [get_ports {pcie_rx_n[7]}]  ;# MGTYRXN0_226 GTYE4_CHANNEL_X1Y28 / GTYE4_COMMON_X1Y7
set_property -dict {LOC AN9} [get_ports {pcie_tx_p[7]}]
#set_property -dict {LOC AN8  } [get_ports {pcie_tx_n[7]}]  ;# MGTYTXN0_226 GTYE4_CHANNEL_X1Y28 / GTYE4_COMMON_X1Y7
set_property -dict {LOC AP2} [get_ports {pcie_rx_p[8]}]
#set_property -dict {LOC AP1  } [get_ports {pcie_rx_n[8]}]  ;# MGTYRXN3_225 GTYE4_CHANNEL_X1Y27 / GTYE4_COMMON_X1Y6
set_property -dict {LOC AP7} [get_ports {pcie_tx_p[8]}]
#set_property -dict {LOC AP6  } [get_ports {pcie_tx_n[8]}]  ;# MGTYTXN3_225 GTYE4_CHANNEL_X1Y27 / GTYE4_COMMON_X1Y6
set_property -dict {LOC AR4} [get_ports {pcie_rx_p[9]}]
#set_property -dict {LOC AR3  } [get_ports {pcie_rx_n[9]}]  ;# MGTYRXN2_225 GTYE4_CHANNEL_X1Y26 / GTYE4_COMMON_X1Y6
set_property -dict {LOC AR9} [get_ports {pcie_tx_p[9]}]
#set_property -dict {LOC AR8  } [get_ports {pcie_tx_n[9]}]  ;# MGTYTXN2_225 GTYE4_CHANNEL_X1Y26 / GTYE4_COMMON_X1Y6
set_property -dict {LOC AT2} [get_ports {pcie_rx_p[10]}]
#set_property -dict {LOC AT1  } [get_ports {pcie_rx_n[10]}] ;# MGTYRXN1_225 GTYE4_CHANNEL_X1Y25 / GTYE4_COMMON_X1Y6
set_property -dict {LOC AT7} [get_ports {pcie_tx_p[10]}]
#set_property -dict {LOC AT6  } [get_ports {pcie_tx_n[10]}] ;# MGTYTXN1_225 GTYE4_CHANNEL_X1Y25 / GTYE4_COMMON_X1Y6
set_property -dict {LOC AU4} [get_ports {pcie_rx_p[11]}]
#set_property -dict {LOC AU3  } [get_ports {pcie_rx_n[11]}] ;# MGTYRXN0_225 GTYE4_CHANNEL_X1Y24 / GTYE4_COMMON_X1Y6
set_property -dict {LOC AU9} [get_ports {pcie_tx_p[11]}]
#set_property -dict {LOC AU8  } [get_ports {pcie_tx_n[11]}] ;# MGTYTXN0_225 GTYE4_CHANNEL_X1Y24 / GTYE4_COMMON_X1Y6
set_property -dict {LOC AV2} [get_ports {pcie_rx_p[12]}]
#set_property -dict {LOC AV1  } [get_ports {pcie_rx_n[12]}] ;# MGTYRXN3_224 GTYE4_CHANNEL_X1Y23 / GTYE4_COMMON_X1Y5
set_property -dict {LOC AV7} [get_ports {pcie_tx_p[12]}]
#set_property -dict {LOC AV6  } [get_ports {pcie_tx_n[12]}] ;# MGTYTXN3_224 GTYE4_CHANNEL_X1Y23 / GTYE4_COMMON_X1Y5
set_property -dict {LOC AW4} [get_ports {pcie_rx_p[13]}]
#set_property -dict {LOC AW3  } [get_ports {pcie_rx_n[13]}] ;# MGTYRXN2_224 GTYE4_CHANNEL_X1Y22 / GTYE4_COMMON_X1Y5
set_property -dict {LOC BB5} [get_ports {pcie_tx_p[13]}]
#set_property -dict {LOC BB4  } [get_ports {pcie_tx_n[13]}] ;# MGTYTXN2_224 GTYE4_CHANNEL_X1Y22 / GTYE4_COMMON_X1Y5
set_property -dict {LOC BA2} [get_ports {pcie_rx_p[14]}]
#set_property -dict {LOC BA1  } [get_ports {pcie_rx_n[14]}] ;# MGTYRXN1_224 GTYE4_CHANNEL_X1Y21 / GTYE4_COMMON_X1Y5
set_property -dict {LOC BD5} [get_ports {pcie_tx_p[14]}]
#set_property -dict {LOC BD4  } [get_ports {pcie_tx_n[14]}] ;# MGTYTXN1_224 GTYE4_CHANNEL_X1Y21 / GTYE4_COMMON_X1Y5
set_property -dict {LOC BC2} [get_ports {pcie_rx_p[15]}]
#set_property -dict {LOC BC1  } [get_ports {pcie_rx_n[15]}] ;# MGTYRXN0_224 GTYE4_CHANNEL_X1Y20 / GTYE4_COMMON_X1Y5
set_property -dict {LOC BF5} [get_ports {pcie_tx_p[15]}]
#set_property -dict {LOC BF4  } [get_ports {pcie_tx_n[15]}] ;# MGTYTXN0_224 GTYE4_CHANNEL_X1Y20 / GTYE4_COMMON_X1Y5
set_property -dict {LOC AM11} [get_ports pcie_refclk_p]
#set_property -dict {LOC AM10 } [get_ports pcie_refclk_n] ;# MGTREFCLK0N_226
set_property PACKAGE_PIN BD21 [get_ports pcie_reset_n]
set_property IOSTANDARD LVCMOS12 [get_ports pcie_reset_n]
set_property PULLUP true [get_ports pcie_reset_n]

# 100 MHz MGT reference clock
create_clock -period 10.000 -name pcie_mgt_refclk_1 [get_ports pcie_refclk_p]
create_clock -period 20.000 -name cfg_mgt_refclk_1 [get_pins startupe3_inst/CFGMCLK]

# Input and Output delays
set_input_delay 0.000 [get_ports {qsfp0_intl qsfp0_modprsl}]
set_input_delay 0.000 [get_ports {qsfp1_intl qsfp1_modprsl}]
set_input_delay 0.000 [get_ports pcie_reset_n]
set_input_delay 0.000 [get_ports {i2c_sda i2c_scl}]

set_false_path -from [get_ports {qsfp0_intl qsfp0_modprsl}]
set_false_path -from [get_ports {qsfp1_intl qsfp1_modprsl}]
set_false_path -from [get_ports pcie_reset_n]
set_false_path -from [get_ports {i2c_sda i2c_scl}]

set_output_delay 0.000 [get_ports {qsfp0_lpmode qsfp0_resetl qsfp0_refclk_reset}]
set_output_delay 0.000 [get_ports {qsfp1_lpmode qsfp1_resetl qsfp1_refclk_reset}]
set_output_delay 0.000 [get_ports {i2c_sda i2c_scl}]

set_false_path -to [get_ports {qsfp0_lpmode qsfp0_resetl qsfp0_refclk_reset}]
set_false_path -to [get_ports {qsfp1_lpmode qsfp1_resetl qsfp1_refclk_reset}]
set_false_path -to [get_ports {i2c_sda i2c_scl}]

# Gousheh PBlocks, PR
create_pblock Gousheh_1
add_cells_to_pblock [get_pblocks Gousheh_1] [get_cells -quiet [list {core_inst/riscv_cores[0].pr_wrapper}]]
resize_pblock [get_pblocks Gousheh_1] -add {SLICE_X13Y0:SLICE_X83Y119}
resize_pblock [get_pblocks Gousheh_1] -add {DSP48E2_X1Y0:DSP48E2_X9Y47}
resize_pblock [get_pblocks Gousheh_1] -add {IOB_X0Y0:IOB_X0Y103}
resize_pblock [get_pblocks Gousheh_1] -add {LAGUNA_X2Y0:LAGUNA_X11Y119}
resize_pblock [get_pblocks Gousheh_1] -add {RAMB18_X1Y0:RAMB18_X5Y47}
resize_pblock [get_pblocks Gousheh_1] -add {RAMB36_X1Y0:RAMB36_X5Y23}
resize_pblock [get_pblocks Gousheh_1] -add {URAM288_X0Y0:URAM288_X1Y31}
set_property HD.PARTPIN_RANGE {SLICE_X13Y105:SLICE_X83Y119} [get_pins -regexp {core_inst/riscv_cores\[0\].pr_wrapper/(?!clk).*}]
set_property SNAPPING_MODE ON [get_pblocks Gousheh_1]
set_property IS_SOFT FALSE [get_pblocks Gousheh_1]
create_pblock Gousheh_2
add_cells_to_pblock [get_pblocks Gousheh_2] [get_cells -quiet [list {core_inst/riscv_cores[1].pr_wrapper}]]
resize_pblock [get_pblocks Gousheh_2] -add {SLICE_X86Y0:SLICE_X155Y119}
resize_pblock [get_pblocks Gousheh_2] -add {DSP48E2_X10Y0:DSP48E2_X17Y47}
resize_pblock [get_pblocks Gousheh_2] -add {IOB_X1Y0:IOB_X1Y103}
resize_pblock [get_pblocks Gousheh_2] -add {LAGUNA_X12Y0:LAGUNA_X21Y119}
resize_pblock [get_pblocks Gousheh_2] -add {RAMB18_X6Y0:RAMB18_X10Y47}
resize_pblock [get_pblocks Gousheh_2] -add {RAMB36_X6Y0:RAMB36_X10Y23}
resize_pblock [get_pblocks Gousheh_2] -add {URAM288_X2Y0:URAM288_X3Y31}
set_property HD.PARTPIN_RANGE {SLICE_X86Y105:SLICE_X155Y119} [get_pins -regexp {core_inst/riscv_cores\[1\].pr_wrapper/(?!clk).*}]
set_property SNAPPING_MODE ON [get_pblocks Gousheh_2]
set_property IS_SOFT FALSE [get_pblocks Gousheh_2]
create_pblock Gousheh_3
add_cells_to_pblock [get_pblocks Gousheh_3] [get_cells -quiet [list {core_inst/riscv_cores[2].pr_wrapper}]]
resize_pblock [get_pblocks Gousheh_3] -add {SLICE_X13Y150:SLICE_X83Y269}
resize_pblock [get_pblocks Gousheh_3] -add {DSP48E2_X1Y60:DSP48E2_X9Y107}
resize_pblock [get_pblocks Gousheh_3] -add {IOB_X0Y130:IOB_X0Y233}
resize_pblock [get_pblocks Gousheh_3] -add {RAMB18_X1Y60:RAMB18_X5Y107}
resize_pblock [get_pblocks Gousheh_3] -add {RAMB36_X1Y30:RAMB36_X5Y53}
resize_pblock [get_pblocks Gousheh_3] -add {URAM288_X0Y40:URAM288_X1Y71}
set_property HD.PARTPIN_RANGE {SLICE_X13Y255:SLICE_X18Y269 SLICE_X21Y255:SLICE_X32Y269 SLICE_X35Y255:SLICE_X46Y269 SLICE_X49Y255:SLICE_X54Y269 SLICE_X56Y255:SLICE_X61Y269 SLICE_X64Y255:SLICE_X77Y269 SLICE_X80Y255:SLICE_X83Y269} [get_pins -regexp {core_inst/riscv_cores\[2\].pr_wrapper/(?!clk).*}]
set_property SNAPPING_MODE ON [get_pblocks Gousheh_3]
set_property IS_SOFT FALSE [get_pblocks Gousheh_3]
create_pblock Gousheh_4
add_cells_to_pblock [get_pblocks Gousheh_4] [get_cells -quiet [list {core_inst/riscv_cores[3].pr_wrapper}]]
resize_pblock [get_pblocks Gousheh_4] -add {SLICE_X86Y150:SLICE_X155Y269}
resize_pblock [get_pblocks Gousheh_4] -add {DSP48E2_X10Y60:DSP48E2_X17Y107}
resize_pblock [get_pblocks Gousheh_4] -add {IOB_X1Y130:IOB_X1Y233}
resize_pblock [get_pblocks Gousheh_4] -add {RAMB18_X6Y60:RAMB18_X10Y107}
resize_pblock [get_pblocks Gousheh_4] -add {RAMB36_X6Y30:RAMB36_X10Y53}
resize_pblock [get_pblocks Gousheh_4] -add {URAM288_X2Y40:URAM288_X3Y71}
set_property HD.PARTPIN_RANGE {SLICE_X86Y255:SLICE_X89Y269 SLICE_X92Y255:SLICE_X103Y269 SLICE_X106Y255:SLICE_X111Y269 SLICE_X113Y255:SLICE_X118Y269 SLICE_X121Y255:SLICE_X134Y269 SLICE_X137Y255:SLICE_X149Y269 SLICE_X152Y255:SLICE_X155Y269} [get_pins -regexp {core_inst/riscv_cores\[3\].pr_wrapper/(?!clk).*}]
set_property SNAPPING_MODE ON [get_pblocks Gousheh_4]
set_property IS_SOFT FALSE [get_pblocks Gousheh_4]
create_pblock Gousheh_5
add_cells_to_pblock [get_pblocks Gousheh_5] [get_cells -quiet [list {core_inst/riscv_cores[4].pr_wrapper}]]
resize_pblock [get_pblocks Gousheh_5] -add {SLICE_X22Y630:SLICE_X89Y749}
resize_pblock [get_pblocks Gousheh_5] -add {DSP48E2_X3Y252:DSP48E2_X10Y299}
resize_pblock [get_pblocks Gousheh_5] -add {IOB_X0Y546:IOB_X0Y649}
resize_pblock [get_pblocks Gousheh_5] -add {RAMB18_X2Y252:RAMB18_X6Y299}
resize_pblock [get_pblocks Gousheh_5] -add {RAMB36_X2Y126:RAMB36_X6Y149}
resize_pblock [get_pblocks Gousheh_5] -add {URAM288_X0Y168:URAM288_X1Y199}
set_property HD.PARTPIN_RANGE {SLICE_X22Y630:SLICE_X32Y644 SLICE_X35Y630:SLICE_X46Y644 SLICE_X49Y630:SLICE_X54Y644 SLICE_X56Y630:SLICE_X61Y644 SLICE_X64Y630:SLICE_X77Y644 SLICE_X80Y630:SLICE_X89Y644} [get_pins -regexp {core_inst/riscv_cores\[4\].pr_wrapper/(?!clk).*}]
set_property SNAPPING_MODE ON [get_pblocks Gousheh_5]
set_property IS_SOFT FALSE [get_pblocks Gousheh_5]
create_pblock Gousheh_6
add_cells_to_pblock [get_pblocks Gousheh_6] [get_cells -quiet [list {core_inst/riscv_cores[5].pr_wrapper}]]
resize_pblock [get_pblocks Gousheh_6] -add {SLICE_X92Y630:SLICE_X160Y749}
resize_pblock [get_pblocks Gousheh_6] -add {CFGIO_SITE_X0Y2:CFGIO_SITE_X0Y2}
resize_pblock [get_pblocks Gousheh_6] -add {CONFIG_SITE_X0Y2:CONFIG_SITE_X0Y2}
resize_pblock [get_pblocks Gousheh_6] -add {DSP48E2_X11Y252:DSP48E2_X17Y299}
resize_pblock [get_pblocks Gousheh_6] -add {IOB_X1Y546:IOB_X1Y649}
resize_pblock [get_pblocks Gousheh_6] -add {RAMB18_X7Y252:RAMB18_X11Y299}
resize_pblock [get_pblocks Gousheh_6] -add {RAMB36_X7Y126:RAMB36_X11Y149}
resize_pblock [get_pblocks Gousheh_6] -add {URAM288_X2Y168:URAM288_X3Y199}
set_property HD.PARTPIN_RANGE {SLICE_X92Y630:SLICE_X103Y644 SLICE_X106Y630:SLICE_X111Y644 SLICE_X113Y630:SLICE_X118Y644 SLICE_X121Y630:SLICE_X134Y644 SLICE_X137Y630:SLICE_X149Y644 SLICE_X152Y630:SLICE_X155Y644 SLICE_X158Y630:SLICE_X160Y644} [get_pins -regexp {core_inst/riscv_cores\[5\].pr_wrapper/(?!clk).*}]
set_property SNAPPING_MODE ON [get_pblocks Gousheh_6]
set_property IS_SOFT FALSE [get_pblocks Gousheh_6]
create_pblock Gousheh_7
add_cells_to_pblock [get_pblocks Gousheh_7] [get_cells -quiet [list {core_inst/riscv_cores[6].pr_wrapper}]]
resize_pblock [get_pblocks Gousheh_7] -add {SLICE_X21Y780:SLICE_X89Y899}
resize_pblock [get_pblocks Gousheh_7] -add {DSP48E2_X2Y312:DSP48E2_X10Y359}
resize_pblock [get_pblocks Gousheh_7] -add {IOB_X0Y676:IOB_X0Y779}
resize_pblock [get_pblocks Gousheh_7] -add {LAGUNA_X4Y600:LAGUNA_X11Y719}
resize_pblock [get_pblocks Gousheh_7] -add {RAMB18_X2Y312:RAMB18_X6Y359}
resize_pblock [get_pblocks Gousheh_7] -add {RAMB36_X2Y156:RAMB36_X6Y179}
resize_pblock [get_pblocks Gousheh_7] -add {URAM288_X0Y208:URAM288_X1Y239}
set_property HD.PARTPIN_RANGE {SLICE_X22Y780:SLICE_X89Y794} [get_pins -regexp {core_inst/riscv_cores\[6\].pr_wrapper/(?!clk).*}]
set_property SNAPPING_MODE ON [get_pblocks Gousheh_7]
set_property IS_SOFT FALSE [get_pblocks Gousheh_7]
create_pblock Gousheh_8
add_cells_to_pblock [get_pblocks Gousheh_8] [get_cells -quiet [list {core_inst/riscv_cores[7].pr_wrapper}]]
resize_pblock [get_pblocks Gousheh_8] -add {SLICE_X92Y780:SLICE_X160Y899}
resize_pblock [get_pblocks Gousheh_8] -add {DSP48E2_X11Y312:DSP48E2_X17Y359}
resize_pblock [get_pblocks Gousheh_8] -add {ILKNE4_X1Y7:ILKNE4_X1Y8}
resize_pblock [get_pblocks Gousheh_8] -add {IOB_X1Y676:IOB_X1Y779}
resize_pblock [get_pblocks Gousheh_8] -add {LAGUNA_X14Y600:LAGUNA_X21Y719}
resize_pblock [get_pblocks Gousheh_8] -add {RAMB18_X7Y312:RAMB18_X11Y359}
resize_pblock [get_pblocks Gousheh_8] -add {RAMB36_X7Y156:RAMB36_X11Y179}
resize_pblock [get_pblocks Gousheh_8] -add {URAM288_X2Y208:URAM288_X3Y239}
set_property HD.PARTPIN_RANGE {SLICE_X92Y780:SLICE_X160Y794} [get_pins -regexp {core_inst/riscv_cores\[7\].pr_wrapper/(?!clk).*}]
set_property SNAPPING_MODE ON [get_pblocks Gousheh_8]
set_property IS_SOFT FALSE [get_pblocks Gousheh_8]


# Wrapper PBlocks
create_pblock Wrapper_1
add_cells_to_pblock [get_pblocks Wrapper_1] [get_cells -quiet [list {core_inst/riscv_cores[0].core_wrapper} \
  {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers[0].output_register/slr_dest_0/srl_fifo_0}]]
resize_pblock [get_pblocks Wrapper_1] -add {SLICE_X13Y120:SLICE_X83Y134}
resize_pblock [get_pblocks Wrapper_1] -add {DSP48E2_X1Y48:DSP48E2_X9Y53}
resize_pblock [get_pblocks Wrapper_1] -add {RAMB18_X1Y48:RAMB18_X5Y53}
resize_pblock [get_pblocks Wrapper_1] -add {RAMB36_X1Y24:RAMB36_X5Y26}
set_property IS_SOFT TRUE [get_pblocks Wrapper_1]
create_pblock Wrapper_2
add_cells_to_pblock [get_pblocks Wrapper_2] [get_cells -quiet [list {core_inst/riscv_cores[1].core_wrapper} \
  {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers[1].output_register/slr_dest_0/srl_fifo_0}]]
resize_pblock [get_pblocks Wrapper_2] -add {SLICE_X86Y120:SLICE_X155Y134}
resize_pblock [get_pblocks Wrapper_2] -add {DSP48E2_X10Y48:DSP48E2_X17Y53}
resize_pblock [get_pblocks Wrapper_2] -add {RAMB18_X6Y48:RAMB18_X10Y53}
resize_pblock [get_pblocks Wrapper_2] -add {RAMB36_X6Y24:RAMB36_X10Y26}
set_property IS_SOFT TRUE [get_pblocks Wrapper_2]
create_pblock Wrapper_3
add_cells_to_pblock [get_pblocks Wrapper_3] [get_cells -quiet [list {core_inst/riscv_cores[2].core_wrapper} \
  {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers[2].output_register/slr_dest_0/srl_fifo_0}]]
resize_pblock [get_pblocks Wrapper_3] -add {SLICE_X13Y270:SLICE_X83Y284}
resize_pblock [get_pblocks Wrapper_3] -add {DSP48E2_X1Y108:DSP48E2_X9Y113}
resize_pblock [get_pblocks Wrapper_3] -add {RAMB18_X1Y108:RAMB18_X5Y113}
resize_pblock [get_pblocks Wrapper_3] -add {RAMB36_X1Y54:RAMB36_X5Y56}
set_property IS_SOFT TRUE [get_pblocks Wrapper_3]
create_pblock Wrapper_4
add_cells_to_pblock [get_pblocks Wrapper_4] [get_cells -quiet [list {core_inst/riscv_cores[3].core_wrapper} \
  {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers[3].output_register/slr_dest_0/srl_fifo_0}]]
resize_pblock [get_pblocks Wrapper_4] -add {SLICE_X86Y270:SLICE_X155Y284}
resize_pblock [get_pblocks Wrapper_4] -add {DSP48E2_X10Y108:DSP48E2_X17Y113}
resize_pblock [get_pblocks Wrapper_4] -add {RAMB18_X6Y108:RAMB18_X10Y113}
resize_pblock [get_pblocks Wrapper_4] -add {RAMB36_X6Y54:RAMB36_X10Y56}
set_property IS_SOFT TRUE [get_pblocks Wrapper_4]
create_pblock Wrapper_5
add_cells_to_pblock [get_pblocks Wrapper_5] [get_cells -quiet [list {core_inst/riscv_cores[4].core_wrapper} \
  {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers[4].output_register/slr_dest_0/srl_fifo_0}]]
resize_pblock [get_pblocks Wrapper_5] -add {SLICE_X22Y615:SLICE_X89Y629}
resize_pblock [get_pblocks Wrapper_5] -add {DSP48E2_X3Y246:DSP48E2_X10Y251}
resize_pblock [get_pblocks Wrapper_5] -add {RAMB18_X2Y246:RAMB18_X6Y251}
resize_pblock [get_pblocks Wrapper_5] -add {RAMB36_X2Y123:RAMB36_X6Y125}
set_property IS_SOFT TRUE [get_pblocks Wrapper_5]
create_pblock Wrapper_6
add_cells_to_pblock [get_pblocks Wrapper_6] [get_cells -quiet [list {core_inst/riscv_cores[5].core_wrapper} \
  {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers[5].output_register/slr_dest_0/srl_fifo_0}]]
resize_pblock [get_pblocks Wrapper_6] -add {SLICE_X92Y615:SLICE_X160Y629}
resize_pblock [get_pblocks Wrapper_6] -add {DSP48E2_X11Y246:DSP48E2_X17Y251}
resize_pblock [get_pblocks Wrapper_6] -add {RAMB18_X7Y246:RAMB18_X11Y251}
resize_pblock [get_pblocks Wrapper_6] -add {RAMB36_X7Y123:RAMB36_X11Y125}
set_property IS_SOFT TRUE [get_pblocks Wrapper_6]
create_pblock Wrapper_7
add_cells_to_pblock [get_pblocks Wrapper_7] [get_cells -quiet [list {core_inst/riscv_cores[6].core_wrapper} \
  {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers[6].output_register/slr_dest_0/srl_fifo_0}]]
resize_pblock [get_pblocks Wrapper_7] -add {SLICE_X22Y765:SLICE_X89Y779}
resize_pblock [get_pblocks Wrapper_7] -add {DSP48E2_X3Y306:DSP48E2_X10Y311}
resize_pblock [get_pblocks Wrapper_7] -add {RAMB18_X2Y306:RAMB18_X6Y311}
resize_pblock [get_pblocks Wrapper_7] -add {RAMB36_X2Y153:RAMB36_X6Y155}
set_property IS_SOFT TRUE [get_pblocks Wrapper_7]
create_pblock Wrapper_8
add_cells_to_pblock [get_pblocks Wrapper_8] [get_cells -quiet [list {core_inst/riscv_cores[7].core_wrapper} \
  {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers[7].output_register/slr_dest_0/srl_fifo_0}]]
resize_pblock [get_pblocks Wrapper_8] -add {SLICE_X92Y765:SLICE_X160Y779}
resize_pblock [get_pblocks Wrapper_8] -add {DSP48E2_X11Y306:DSP48E2_X17Y311}
resize_pblock [get_pblocks Wrapper_8] -add {RAMB18_X7Y306:RAMB18_X11Y311}
resize_pblock [get_pblocks Wrapper_8] -add {RAMB36_X7Y153:RAMB36_X11Y155}
set_property IS_SOFT TRUE [get_pblocks Wrapper_8]

# CMAC PBlock
create_pblock MAC_n_FIFOs
add_cells_to_pblock [get_pblocks MAC_n_FIFOs] [get_cells -quiet [list {core_inst/MAC_async_FIFO[0].mac_rx_async_fifo_inst} {core_inst/MAC_async_FIFO[0].mac_tx_async_fifo_inst} {core_inst/MAC_async_FIFO[1].mac_rx_async_fifo_inst} {core_inst/MAC_async_FIFO[1].mac_tx_async_fifo_inst}]]
resize_pblock [get_pblocks MAC_n_FIFOs] -add {SLICE_X0Y615:SLICE_X16Y899}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {CMACE4_X0Y6:CMACE4_X0Y8}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {DSP48E2_X0Y246:DSP48E2_X1Y359}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {ILKNE4_X0Y6:ILKNE4_X0Y6}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {PCIE40E4_X0Y5:PCIE40E4_X0Y5}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {RAMB18_X0Y246:RAMB18_X1Y359}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {RAMB36_X0Y123:RAMB36_X1Y179}
set_property IS_SOFT TRUE [get_pblocks MAC_n_FIFOs]
# set_property EXCLUDE_PLACEMENT 1 [get_pblocks MAC_n_FIFOs]

# Center PBlock for first level switches, loopback module, and stat readers
create_pblock Switch_n_MSGs
add_cells_to_pblock [get_pblocks Switch_n_MSGs] [get_cells -quiet [list \
    core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/sw_lvl1 \
    {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers[*].output_register/slr_source_0} \
    core_inst/data_out_sw/shrink.axis_switch_2lvl_shrink_inst/last_level_sw.sw_lvl2 \
    {core_inst/data_out_sw/shrink.axis_switch_2lvl_shrink_inst/input_registers[*].input_register/slr_dest_0} \
    core_inst/ctrl_in_sw/grow.axis_switch_2lvl_grow_inst/sw_lvl1 \
    core_inst/dram_ctrl_in_sw/grow.axis_switch_2lvl_grow_inst/sw_lvl1 \
    core_inst/dram_ctrl_out_sw/shrink.axis_switch_2lvl_shrink_inst/last_level_arbiter.sw_lvl2 \
    {core_inst/MAC_async_FIFO[*].mac_rx_pipeline/slr_dest_0} \
    {core_inst/MAC_async_FIFO[*].mac_tx_pipeline/slr_source_0} \
    core_inst/interface_incoming_stat \
    core_inst/interface_outgoing_stat \
    core_inst/loopback_msg_fifo_inst \
    sync_reset_125mhz_inst]]
resize_pblock [get_pblocks Switch_n_MSGs] -add {SLICE_X0Y570:SLICE_X168Y599 SLICE_X0Y540:SLICE_X128Y569 SLICE_X88Y360:SLICE_X128Y539 SLICE_X0Y300:SLICE_X128Y359}
resize_pblock [get_pblocks Switch_n_MSGs] -add {DSP48E2_X15Y228:DSP48E2_X18Y239 DSP48E2_X11Y120:DSP48E2_X14Y239 DSP48E2_X0Y216:DSP48E2_X10Y239 DSP48E2_X0Y120:DSP48E2_X10Y143}
resize_pblock [get_pblocks Switch_n_MSGs] -add {LAGUNA_X18Y420:LAGUNA_X23Y479 LAGUNA_X0Y240:LAGUNA_X17Y479}
resize_pblock [get_pblocks Switch_n_MSGs] -add {RAMB18_X9Y228:RAMB18_X11Y239 RAMB18_X7Y120:RAMB18_X8Y239 RAMB18_X0Y216:RAMB18_X6Y239 RAMB18_X0Y120:RAMB18_X6Y143}
resize_pblock [get_pblocks Switch_n_MSGs] -add {RAMB36_X9Y114:RAMB36_X11Y119 RAMB36_X7Y60:RAMB36_X8Y119 RAMB36_X0Y108:RAMB36_X6Y119 RAMB36_X0Y60:RAMB36_X6Y71}
resize_pblock [get_pblocks Switch_n_MSGs] -add {URAM288_X2Y80:URAM288_X3Y159 URAM288_X0Y144:URAM288_X1Y159 URAM288_X0Y80:URAM288_X1Y95}
set_property IS_SOFT TRUE [get_pblocks Switch_n_MSGs]

# Rest of SLR crossing registers location
create_pblock SLR2_edge
add_cells_to_pblock [get_pblocks SLR2_edge] [get_cells -quiet -regexp { \
    {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers\[[4-7]\].output_register/slr_dest_0/laguna_s_payload_d_reg\[.*\]} \
    {core_inst/data_out_sw/shrink.axis_switch_2lvl_shrink_inst/input_registers\[[4-7]\].input_register/slr_source_0/laguna_m_payload_i_reg\[.*\]} \
    {core_inst/MAC_async_FIFO\[.*\].mac_rx_pipeline/slr_source_0/laguna_m_payload_i_reg\[.*\]} \
    {core_inst/MAC_async_FIFO\[.*\].mac_tx_pipeline/slr_dest_0/laguna_s_payload_d_reg\[.*\]}}]
resize_pblock [get_pblocks SLR2_edge] -add {LAGUNA_X0Y480:LAGUNA_X23Y599}
set_property EXCLUDE_PLACEMENT 1 [get_pblocks SLR2_edge]
set_property IS_SOFT FALSE [get_pblocks SLR2_edge]

create_pblock SLR0_edge
add_cells_to_pblock [get_pblocks SLR0_edge] [get_cells -quiet -regexp { \
    {core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/output_registers\[[0-3]\].output_register/slr_dest_0/laguna_s_payload_d_reg\[.*\]} \
    {core_inst/data_out_sw/shrink.axis_switch_2lvl_shrink_inst/input_registers\[[0-3]\].input_register/slr_source_0/laguna_m_payload_i_reg\[.*\]}}]
resize_pblock [get_pblocks SLR0_edge] -add {LAGUNA_X0Y120:LAGUNA_X23Y239}
set_property EXCLUDE_PLACEMENT 1 [get_pblocks SLR0_edge]
set_property IS_SOFT FALSE [get_pblocks SLR0_edge]

# Scheduler PBlock, PR
create_pblock User_Scheduler
add_cells_to_pblock [get_pblocks User_Scheduler] [get_cells -quiet [list core_inst/scheduler_PR_inst]]
resize_pblock [get_pblocks User_Scheduler] -add {SLICE_X0Y360:SLICE_X87Y539}
resize_pblock [get_pblocks User_Scheduler] -add {CMACE4_X0Y4:CMACE4_X0Y4}
resize_pblock [get_pblocks User_Scheduler] -add {DSP48E2_X0Y144:DSP48E2_X10Y215}
resize_pblock [get_pblocks User_Scheduler] -add {GTYE4_CHANNEL_X0Y24:GTYE4_CHANNEL_X0Y35}
resize_pblock [get_pblocks User_Scheduler] -add {GTYE4_COMMON_X0Y6:GTYE4_COMMON_X0Y8}
resize_pblock [get_pblocks User_Scheduler] -add {ILKNE4_X0Y3:ILKNE4_X0Y3}
resize_pblock [get_pblocks User_Scheduler] -add {IOB_X0Y312:IOB_X0Y467}
resize_pblock [get_pblocks User_Scheduler] -add {PCIE40E4_X0Y3:PCIE40E4_X0Y3}
resize_pblock [get_pblocks User_Scheduler] -add {RAMB18_X0Y144:RAMB18_X6Y215}
resize_pblock [get_pblocks User_Scheduler] -add {RAMB36_X0Y72:RAMB36_X6Y107}
resize_pblock [get_pblocks User_Scheduler] -add {URAM288_X0Y96:URAM288_X1Y143}
set_property HD.PARTPIN_RANGE {SLICE_X80Y360:SLICE_X87Y539} [get_pins [list core_inst/scheduler_PR_inst/data_s* core_inst/scheduler_PR_inst/ctrl* core_inst/scheduler_PR_inst/host_cmd* core_inst/scheduler_PR_inst/rst]]
set_property HD.PARTPIN_RANGE {SLICE_X0Y535:SLICE_X50Y539} [get_pins core_inst/scheduler_PR_inst/tx_axis*]
set_property HD.PARTPIN_RANGE {SLICE_X0Y535:SLICE_X50Y539} [get_pins core_inst/scheduler_PR_inst/rx_axis*]
set_property HD.PARTPIN_RANGE {SLICE_X0Y360:SLICE_X79Y364} [get_pins core_inst/scheduler_PR_inst/data_m*]
set_property SNAPPING_MODE ON [get_pblocks User_Scheduler]
set_property IS_SOFT FALSE [get_pblocks User_Scheduler]

# Corundum_pblock and Gousheh PCIe controller
# create_pblock Corundum_pblock
# add_cells_to_pblock [get_pblocks Corundum_pblock] [get_cells -quiet [list core_inst/host_cmd_rd_data_sync_reg core_inst/pcie_config_inst core_inst/pcie_controller_inst/pcie_cont_read_inst core_inst/pcie_controller_inst/pcie_cont_write_inst core_inst/pcie_controller_inst/virtual_ports.corundum_inst]]

# PCIe IP and PCIe DMA modules
create_pblock PCIe_pblock
add_cells_to_pblock [get_pblocks PCIe_pblock] [get_cells -quiet [list core_inst/pcie_controller_inst/cq_reg core_inst/pcie_controller_inst/dma_if_pcie_us_inst core_inst/pcie_controller_inst/pcie_us_axil_master_inst core_inst/pcie_controller_inst/rc_reg core_inst/pcie_controller_inst/status_error_cor_pm_inst core_inst/pcie_controller_inst/status_error_uncor_pm_inst core_inst/pcie_controller_inst/virtual_ports.dma_if_mux_inst pcie4_uscale_plus_inst pcie_us_cfg_inst pcie_us_msi_inst]]
resize_pblock [get_pblocks PCIe_pblock] -add {SLICE_X129Y300:SLICE_X168Y569}
resize_pblock [get_pblocks PCIe_pblock] -add {CFGIO_SITE_X0Y1:CFGIO_SITE_X0Y1}
resize_pblock [get_pblocks PCIe_pblock] -add {CONFIG_SITE_X0Y1:CONFIG_SITE_X0Y1}
resize_pblock [get_pblocks PCIe_pblock] -add {DSP48E2_X15Y120:DSP48E2_X18Y227}
resize_pblock [get_pblocks PCIe_pblock] -add {GTYE4_CHANNEL_X1Y20:GTYE4_CHANNEL_X1Y35}
resize_pblock [get_pblocks PCIe_pblock] -add {GTYE4_COMMON_X1Y5:GTYE4_COMMON_X1Y8}
resize_pblock [get_pblocks PCIe_pblock] -add {ILKNE4_X1Y4:ILKNE4_X1Y4}
resize_pblock [get_pblocks PCIe_pblock] -add {PCIE40E4_X1Y2:PCIE40E4_X1Y2}
resize_pblock [get_pblocks PCIe_pblock] -add {RAMB18_X9Y120:RAMB18_X11Y227}
resize_pblock [get_pblocks PCIe_pblock] -add {RAMB36_X9Y60:RAMB36_X11Y113}
resize_pblock [get_pblocks PCIe_pblock] -add {SYSMONE4_X0Y1:SYSMONE4_X0Y1}
# set_property IS_SOFT FALSE [get_pblocks PCIe_pblock]
