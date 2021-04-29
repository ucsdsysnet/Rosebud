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
create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list {core_inst/riscv_cores[0].pr_wrapper}]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X13Y0:SLICE_X41Y239}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X1Y0:DSP48E2_X5Y95}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X1Y0:RAMB18_X2Y95}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X1Y0:RAMB36_X2Y47}
resize_pblock [get_pblocks pblock_1] -add {URAM288_X0Y0:URAM288_X0Y63}
set_property HD.PARTPIN_RANGE {SLICE_X13Y234:SLICE_X41Y239} [get_pins core_inst/riscv_cores[0].pr_wrapper/*]
set_property SNAPPING_MODE ON [get_pblocks pblock_1]
set_property IS_SOFT FALSE [get_pblocks pblock_1]
create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list {core_inst/riscv_cores[1].pr_wrapper}]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X50Y0:SLICE_X79Y239}
resize_pblock [get_pblocks pblock_2] -add {DSP48E2_X7Y0:DSP48E2_X8Y95}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X4Y0:RAMB18_X4Y95}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X4Y0:RAMB36_X4Y47}
resize_pblock [get_pblocks pblock_2] -add {URAM288_X1Y0:URAM288_X1Y63}
set_property HD.PARTPIN_RANGE {SLICE_X50Y234:SLICE_X54Y239 SLICE_X56Y234:SLICE_X79Y239} [get_pins core_inst/riscv_cores[1].pr_wrapper/*]
set_property SNAPPING_MODE ON [get_pblocks pblock_2]
set_property IS_SOFT FALSE [get_pblocks pblock_2]
create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list {core_inst/riscv_cores[2].pr_wrapper}]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X85Y0:SLICE_X114Y239}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X10Y0:DSP48E2_X13Y95}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X6Y0:RAMB18_X7Y95}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X6Y0:RAMB36_X7Y47}
resize_pblock [get_pblocks pblock_3] -add {URAM288_X2Y0:URAM288_X2Y63}
set_property HD.PARTPIN_RANGE {SLICE_X86Y234:SLICE_X111Y239 SLICE_X113Y234:SLICE_X114Y239} [get_pins core_inst/riscv_cores[2].pr_wrapper/*]
set_property SNAPPING_MODE ON [get_pblocks pblock_3]
set_property IS_SOFT FALSE [get_pblocks pblock_3]
create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list {core_inst/riscv_cores[3].pr_wrapper}]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X121Y0:SLICE_X152Y239}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X15Y0:DSP48E2_X17Y95}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X9Y0:RAMB18_X9Y95}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X9Y0:RAMB36_X9Y47}
resize_pblock [get_pblocks pblock_4] -add {URAM288_X3Y0:URAM288_X3Y63}
set_property HD.PARTPIN_RANGE {SLICE_X121Y234:SLICE_X152Y239} [get_pins core_inst/riscv_cores[3].pr_wrapper/*]
set_property SNAPPING_MODE ON [get_pblocks pblock_4]
set_property IS_SOFT FALSE [get_pblocks pblock_4]
create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list {core_inst/riscv_cores[4].pr_wrapper}]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X21Y660:SLICE_X48Y899}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X2Y264:DSP48E2_X6Y359}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X2Y264:RAMB18_X2Y359}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X2Y132:RAMB36_X2Y179}
resize_pblock [get_pblocks pblock_5] -add {URAM288_X0Y176:URAM288_X0Y239}
set_property HD.PARTPIN_RANGE {SLICE_X21Y660:SLICE_X48Y665} [get_pins core_inst/riscv_cores[4].pr_wrapper/*]
set_property SNAPPING_MODE ON [get_pblocks pblock_5]
set_property IS_SOFT FALSE [get_pblocks pblock_5]
create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list {core_inst/riscv_cores[5].pr_wrapper}]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X53Y660:SLICE_X82Y899}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X8Y264:DSP48E2_X9Y359}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X4Y264:RAMB18_X4Y359}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X4Y132:RAMB36_X4Y179}
resize_pblock [get_pblocks pblock_6] -add {URAM288_X1Y176:URAM288_X1Y239}
set_property HD.PARTPIN_RANGE {SLICE_X53Y660:SLICE_X54Y665 SLICE_X56Y660:SLICE_X82Y665} [get_pins core_inst/riscv_cores[5].pr_wrapper/*]
set_property SNAPPING_MODE ON [get_pblocks pblock_6]
set_property IS_SOFT FALSE [get_pblocks pblock_6]
create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list {core_inst/riscv_cores[6].pr_wrapper}]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X87Y660:SLICE_X115Y899}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X10Y264:DSP48E2_X13Y359}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X7Y264:RAMB18_X8Y359}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X7Y132:RAMB36_X8Y179}
resize_pblock [get_pblocks pblock_7] -add {URAM288_X2Y176:URAM288_X2Y239}
set_property HD.PARTPIN_RANGE {SLICE_X87Y660:SLICE_X111Y665 SLICE_X113Y660:SLICE_X115Y665} [get_pins core_inst/riscv_cores[6].pr_wrapper/*]
set_property SNAPPING_MODE ON [get_pblocks pblock_7]
set_property IS_SOFT FALSE [get_pblocks pblock_7]
create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list {core_inst/riscv_cores[7].pr_wrapper}]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X121Y660:SLICE_X152Y899}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X15Y264:DSP48E2_X17Y359}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X9Y264:RAMB18_X9Y359}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X9Y132:RAMB36_X9Y179}
resize_pblock [get_pblocks pblock_8] -add {URAM288_X3Y176:URAM288_X3Y239}
set_property HD.PARTPIN_RANGE {SLICE_X121Y660:SLICE_X152Y665} [get_pins core_inst/riscv_cores[7].pr_wrapper/*]
set_property SNAPPING_MODE ON [get_pblocks pblock_8]
set_property IS_SOFT FALSE [get_pblocks pblock_8]


create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list {core_inst/riscv_cores[0].core_wrapper}]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X13Y240:SLICE_X41Y284}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X1Y96:RAMB18_X2Y113}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X1Y48:RAMB36_X2Y56}
set_property IS_SOFT TRUE [get_pblocks pblock_9]
create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list {core_inst/riscv_cores[1].core_wrapper}]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X50Y240:SLICE_X79Y284}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X4Y96:RAMB18_X4Y113}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X4Y48:RAMB36_X4Y56}
set_property IS_SOFT TRUE [get_pblocks pblock_10]
create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list {core_inst/riscv_cores[2].core_wrapper}]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X85Y240:SLICE_X114Y284}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X6Y96:RAMB18_X7Y113}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X6Y48:RAMB36_X7Y56}
set_property IS_SOFT TRUE [get_pblocks pblock_11]
create_pblock pblock_12
add_cells_to_pblock [get_pblocks pblock_12] [get_cells -quiet [list {core_inst/riscv_cores[3].core_wrapper}]]
resize_pblock [get_pblocks pblock_12] -add {SLICE_X121Y240:SLICE_X154Y284}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X9Y96:RAMB18_X9Y113}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X9Y48:RAMB36_X9Y56}
set_property IS_SOFT TRUE [get_pblocks pblock_12]
create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list {core_inst/riscv_cores[4].core_wrapper}]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X21Y615:SLICE_X48Y659}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X2Y246:RAMB18_X2Y263}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X2Y123:RAMB36_X2Y131}
set_property IS_SOFT TRUE [get_pblocks pblock_13]
create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list {core_inst/riscv_cores[5].core_wrapper}]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X53Y615:SLICE_X82Y659}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X4Y246:RAMB18_X4Y263}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X4Y123:RAMB36_X4Y131}
set_property IS_SOFT TRUE [get_pblocks pblock_14]
create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list {core_inst/riscv_cores[6].core_wrapper}]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X87Y615:SLICE_X115Y659}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X7Y246:RAMB18_X8Y263}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X7Y123:RAMB36_X8Y131}
set_property IS_SOFT TRUE [get_pblocks pblock_15]
create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list {core_inst/riscv_cores[7].core_wrapper}]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X121Y615:SLICE_X154Y659}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X9Y246:RAMB18_X9Y263}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X9Y123:RAMB36_X9Y131}
set_property IS_SOFT TRUE [get_pblocks pblock_16]

# CMAC PBlock
create_pblock MAC_n_FIFOs
add_cells_to_pblock [get_pblocks MAC_n_FIFOs] [get_cells -quiet [list {core_inst/MAC_async_FIFO[0].mac_rx_async_fifo_inst} {core_inst/MAC_async_FIFO[0].mac_tx_async_fifo_inst} {core_inst/MAC_async_FIFO[1].mac_rx_async_fifo_inst} {core_inst/MAC_async_FIFO[1].mac_tx_async_fifo_inst}]]
resize_pblock [get_pblocks MAC_n_FIFOs] -add {SLICE_X0Y600:SLICE_X16Y899}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {CMACE4_X0Y6:CMACE4_X0Y8}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {DSP48E2_X0Y240:DSP48E2_X1Y359}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {ILKNE4_X0Y6:ILKNE4_X0Y6}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {LAGUNA_X0Y480:LAGUNA_X1Y719}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {PCIE40E4_X0Y5:PCIE40E4_X0Y5}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {RAMB18_X0Y240:RAMB18_X1Y359}
resize_pblock [get_pblocks MAC_n_FIFOs] -add {RAMB36_X0Y120:RAMB36_X1Y179}
set_property EXCLUDE_PLACEMENT 1 [get_pblocks MAC_n_FIFOs]
set_property IS_SOFT FALSE [get_pblocks MAC_n_FIFOs]

# Center PBlock for first level switches, loopback module, and stat readers
create_pblock Switch_n_MSGs
add_cells_to_pblock [get_pblocks Switch_n_MSGs] [get_cells -quiet [list {core_inst/MAC_async_FIFO[0].mac_rx_pipeline/pipe_reg[1].reg_inst} {core_inst/MAC_async_FIFO[0].mac_tx_pipeline/pipe_reg[0].reg_inst} {core_inst/MAC_async_FIFO[1].mac_rx_pipeline/pipe_reg[1].reg_inst} {core_inst/MAC_async_FIFO[1].mac_tx_pipeline/pipe_reg[0].reg_inst} core_inst/ctrl_in_sw/grow.axis_switch_2lvl_grow_inst/sw_lvl1 core_inst/data_in_sw/grow.axis_switch_2lvl_grow_inst/sw_lvl1 core_inst/data_out_sw/shrink.axis_switch_2lvl_shrink_inst/last_level_sw.sw_lvl2 core_inst/dram_ctrl_in_sw/grow.axis_switch_2lvl_grow_inst/sw_lvl1 core_inst/dram_ctrl_out_sw/shrink.axis_switch_2lvl_shrink_inst/last_level_arbiter.sw_lvl2 core_inst/interface_incoming_stat core_inst/interface_outgoing_stat core_inst/loopback_msg_fifo_inst {core_inst/pcie_controller_inst/virtual_ports.mac_fifos.tx_rx_fifos[0].rx_pipeline_reg/pipe_reg[0].reg_inst} {core_inst/pcie_controller_inst/virtual_ports.mac_fifos.tx_rx_fifos[0].tx_pipeline_reg/pipe_reg[1].reg_inst} sync_reset_125mhz_inst]]
resize_pblock [get_pblocks Switch_n_MSGs] -add {SLICE_X0Y570:SLICE_X168Y599 SLICE_X0Y540:SLICE_X108Y569 SLICE_X55Y360:SLICE_X108Y539 SLICE_X0Y300:SLICE_X108Y359}
resize_pblock [get_pblocks Switch_n_MSGs] -add {DSP48E2_X14Y228:DSP48E2_X18Y239 DSP48E2_X8Y120:DSP48E2_X13Y239 DSP48E2_X0Y216:DSP48E2_X7Y239 DSP48E2_X0Y120:DSP48E2_X7Y143}
resize_pblock [get_pblocks Switch_n_MSGs] -add {LAGUNA_X16Y420:LAGUNA_X23Y479 LAGUNA_X0Y240:LAGUNA_X15Y479}
resize_pblock [get_pblocks Switch_n_MSGs] -add {RAMB18_X8Y228:RAMB18_X11Y239 RAMB18_X4Y120:RAMB18_X7Y239 RAMB18_X0Y216:RAMB18_X3Y239 RAMB18_X0Y120:RAMB18_X3Y143}
resize_pblock [get_pblocks Switch_n_MSGs] -add {RAMB36_X8Y114:RAMB36_X11Y119 RAMB36_X4Y60:RAMB36_X7Y119 RAMB36_X0Y108:RAMB36_X3Y119 RAMB36_X0Y60:RAMB36_X3Y71}
resize_pblock [get_pblocks Switch_n_MSGs] -add {URAM288_X3Y152:URAM288_X3Y159 URAM288_X1Y80:URAM288_X2Y159 URAM288_X0Y144:URAM288_X0Y159 URAM288_X0Y80:URAM288_X0Y95}
set_property IS_SOFT TRUE [get_pblocks Switch_n_MSGs]

# Scheduler PBlock, PR
create_pblock User_Scheduler
add_cells_to_pblock [get_pblocks User_Scheduler] [get_cells -quiet [list core_inst/scheduler_PR_inst]]
resize_pblock [get_pblocks User_Scheduler] -add {SLICE_X0Y360:SLICE_X54Y539}
resize_pblock [get_pblocks User_Scheduler] -add {CMACE4_X0Y4:CMACE4_X0Y4}
resize_pblock [get_pblocks User_Scheduler] -add {DSP48E2_X0Y144:DSP48E2_X7Y215}
resize_pblock [get_pblocks User_Scheduler] -add {GTYE4_CHANNEL_X0Y24:GTYE4_CHANNEL_X0Y35}
resize_pblock [get_pblocks User_Scheduler] -add {GTYE4_COMMON_X0Y6:GTYE4_COMMON_X0Y8}
resize_pblock [get_pblocks User_Scheduler] -add {ILKNE4_X0Y3:ILKNE4_X0Y3}
resize_pblock [get_pblocks User_Scheduler] -add {PCIE40E4_X0Y3:PCIE40E4_X0Y3}
resize_pblock [get_pblocks User_Scheduler] -add {RAMB18_X0Y144:RAMB18_X3Y215}
resize_pblock [get_pblocks User_Scheduler] -add {RAMB36_X0Y72:RAMB36_X3Y107}
resize_pblock [get_pblocks User_Scheduler] -add {URAM288_X0Y96:URAM288_X0Y143}
set_property HD.PARTPIN_RANGE {SLICE_X50Y360:SLICE_X54Y539} [get_pins [list core_inst/scheduler_PR_inst/data_s* core_inst/scheduler_PR_inst/ctrl* core_inst/scheduler_PR_inst/host_cmd* core_inst/scheduler_PR_inst/rst]]
set_property HD.PARTPIN_RANGE {SLICE_X0Y535:SLICE_X50Y539} [get_pins core_inst/scheduler_PR_inst/tx_axis*]
set_property HD.PARTPIN_RANGE {SLICE_X0Y535:SLICE_X50Y539} [get_pins core_inst/scheduler_PR_inst/rx_axis*]
set_property HD.PARTPIN_RANGE {SLICE_X0Y360:SLICE_X50Y364} [get_pins core_inst/scheduler_PR_inst/data_m*]
set_property SNAPPING_MODE ON [get_pblocks User_Scheduler]
set_property IS_SOFT FALSE [get_pblocks User_Scheduler]

# Corundum_pblock and Gousheh PCIe controller
create_pblock Corundum_pblock
add_cells_to_pblock [get_pblocks Corundum_pblock] [get_cells -quiet [list core_inst/host_cmd_rd_data_sync_reg core_inst/pcie_config_inst core_inst/pcie_controller_inst/pcie_cont_read_inst core_inst/pcie_controller_inst/pcie_cont_write_inst core_inst/pcie_controller_inst/virtual_ports.corundum_inst {core_inst/pcie_controller_inst/virtual_ports.mac_fifos.tx_rx_fifos[0].rx_pipeline_reg/pipe_reg[1].reg_inst} {core_inst/pcie_controller_inst/virtual_ports.mac_fifos.tx_rx_fifos[0].tx_pipeline_reg/pipe_reg[0].reg_inst}]]
resize_pblock [get_pblocks Corundum_pblock] -add {SLICE_X109Y300:SLICE_X139Y569}
resize_pblock [get_pblocks Corundum_pblock] -add {DSP48E2_X14Y120:DSP48E2_X15Y227}
resize_pblock [get_pblocks Corundum_pblock] -add {IOB_X1Y260:IOB_X1Y493}
resize_pblock [get_pblocks Corundum_pblock] -add {LAGUNA_X16Y300:LAGUNA_X19Y419}
resize_pblock [get_pblocks Corundum_pblock] -add {RAMB18_X8Y120:RAMB18_X9Y227}
resize_pblock [get_pblocks Corundum_pblock] -add {RAMB36_X8Y60:RAMB36_X9Y113}
resize_pblock [get_pblocks Corundum_pblock] -add {URAM288_X3Y80:URAM288_X3Y151}
set_property IS_SOFT TRUE [get_pblocks Corundum_pblock]

# PCIe IP and PCIe DMA modules
create_pblock PCIe_pblock
add_cells_to_pblock [get_pblocks PCIe_pblock] [get_cells -quiet [list core_inst/pcie_controller_inst/cq_reg core_inst/pcie_controller_inst/dma_if_pcie_us_inst core_inst/pcie_controller_inst/pcie_us_axil_master_inst core_inst/pcie_controller_inst/rc_reg core_inst/pcie_controller_inst/status_error_cor_pm_inst core_inst/pcie_controller_inst/status_error_uncor_pm_inst core_inst/pcie_controller_inst/virtual_ports.dma_if_mux_inst pcie4_uscale_plus_inst pcie_us_cfg_inst pcie_us_msi_inst]]
resize_pblock [get_pblocks PCIe_pblock] -add {SLICE_X140Y300:SLICE_X168Y569}
resize_pblock [get_pblocks PCIe_pblock] -add {DSP48E2_X16Y120:DSP48E2_X18Y227}
resize_pblock [get_pblocks PCIe_pblock] -add {ILKNE4_X1Y4:ILKNE4_X1Y4}
resize_pblock [get_pblocks PCIe_pblock] -add {LAGUNA_X20Y240:LAGUNA_X23Y419}
resize_pblock [get_pblocks PCIe_pblock] -add {PCIE40E4_X1Y2:PCIE40E4_X1Y2}
resize_pblock [get_pblocks PCIe_pblock] -add {RAMB18_X10Y120:RAMB18_X11Y227}
resize_pblock [get_pblocks PCIe_pblock] -add {RAMB36_X10Y60:RAMB36_X11Y113}
resize_pblock [get_pblocks PCIe_pblock] -add {SYSMONE4_X0Y1:SYSMONE4_X0Y1}
set_property EXCLUDE_PLACEMENT 1 [get_pblocks PCIe_pblock]
set_property IS_SOFT FALSE [get_pblocks PCIe_pblock]

