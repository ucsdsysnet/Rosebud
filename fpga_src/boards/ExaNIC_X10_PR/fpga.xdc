# XDC constraints for the ExaNIC X10
# part: xcku035-fbva676-2-e

# General configuration
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Type2 [current_design]
set_property CONFIG_MODE BPI16 [current_design]

# 100 MHz system clock
set_property -dict {LOC D18 IOSTANDARD LVDS} [get_ports clk_100mhz_p]
set_property -dict {LOC C18 IOSTANDARD LVDS} [get_ports clk_100mhz_n]
create_clock -period 10.000 -name clk_100mhz [get_ports clk_100mhz_p]

# LEDs
set_property -dict {LOC A25 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports {sfp_1_led[0]}]
set_property -dict {LOC A24 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports {sfp_1_led[1]}]
set_property -dict {LOC E23 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports {sfp_2_led[0]}]
set_property -dict {LOC D26 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports {sfp_2_led[1]}]
set_property -dict {LOC C23 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports {sma_led[0]}]
set_property -dict {LOC D23 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports {sma_led[1]}]

# GPIO
#set_property -dict {LOC W26  IOSTANDARD LVCMOS18} [get_ports gpio[0]]
#set_property -dict {LOC Y26  IOSTANDARD LVCMOS18} [get_ports gpio[1]]
#set_property -dict {LOC AB26 IOSTANDARD LVCMOS18} [get_ports gpio[2]]
#set_property -dict {LOC AC26 IOSTANDARD LVCMOS18} [get_ports gpio[3]]

# SMA
set_property -dict {LOC B17 IOSTANDARD LVCMOS18} [get_ports sma_in]
set_property -dict {LOC B16 IOSTANDARD LVCMOS18} [get_ports sma_out]
set_property -dict {LOC B19 IOSTANDARD LVCMOS18} [get_ports sma_out_en]
set_property -dict {LOC C16 IOSTANDARD LVCMOS18} [get_ports sma_term_en]

# SFP+ Interfaces
set_property -dict {LOC D2} [get_ports sfp_1_rx_p]
#set_property -dict {LOC D1  } [get_ports sfp_1_rx_n] ;# MGTHRXP0_227 GTHE3_CHANNEL_X0Y12 / GTHE3_COMMON_X0Y3
set_property -dict {LOC E4} [get_ports sfp_1_tx_p]
#set_property -dict {LOC E3  } [get_ports sfp_1_tx_n] ;# MGTHTXP0_227 GTHE3_CHANNEL_X0Y12 / GTHE3_COMMON_X0Y3
set_property -dict {LOC C4} [get_ports sfp_2_rx_p]
#set_property -dict {LOC C3  } [get_ports sfp_2_rx_n] ;# MGTHRXP1_227 GTHE3_CHANNEL_X0Y13 / GTHE3_COMMON_X0Y3
set_property -dict {LOC D6} [get_ports sfp_2_tx_p]
#set_property -dict {LOC D5  } [get_ports sfp_2_tx_n] ;# MGTHTXP1_227 GTHE3_CHANNEL_X0Y13 / GTHE3_COMMON_X0Y3
set_property -dict {LOC H6} [get_ports sfp_mgt_refclk_p]
#set_property -dict {LOC H5  } [get_ports sfp_mgt_refclk_n] ;# MGTREFCLK0N_227 from X2
set_property -dict {LOC AA12 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports sfp_1_tx_disable]
set_property -dict {LOC W14 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports sfp_2_tx_disable]
set_property PACKAGE_PIN C24 [get_ports sfp_1_npres]
set_property IOSTANDARD LVCMOS18 [get_ports sfp_1_npres]
set_property PULLUP true [get_ports sfp_1_npres]
set_property PACKAGE_PIN D24 [get_ports sfp_2_npres]
set_property IOSTANDARD LVCMOS18 [get_ports sfp_2_npres]
set_property PULLUP true [get_ports sfp_2_npres]
set_property PACKAGE_PIN W13 [get_ports sfp_1_los]
set_property IOSTANDARD LVCMOS18 [get_ports sfp_1_los]
set_property PULLUP true [get_ports sfp_1_los]
set_property PACKAGE_PIN AB12 [get_ports sfp_2_los]
set_property IOSTANDARD LVCMOS18 [get_ports sfp_2_los]
set_property PULLUP true [get_ports sfp_2_los]
set_property -dict {LOC B25 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports sfp_1_rs]
set_property -dict {LOC D25 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports sfp_2_rs]
set_property PACKAGE_PIN W11 [get_ports sfp_i2c_scl]
set_property IOSTANDARD LVCMOS18 [get_ports sfp_i2c_scl]
set_property SLEW SLOW [get_ports sfp_i2c_scl]
set_property DRIVE 12 [get_ports sfp_i2c_scl]
set_property PULLUP true [get_ports sfp_i2c_scl]
set_property PACKAGE_PIN Y11 [get_ports sfp_1_i2c_sda]
set_property IOSTANDARD LVCMOS18 [get_ports sfp_1_i2c_sda]
set_property SLEW SLOW [get_ports sfp_1_i2c_sda]
set_property DRIVE 12 [get_ports sfp_1_i2c_sda]
set_property PULLUP true [get_ports sfp_1_i2c_sda]
set_property PACKAGE_PIN Y13 [get_ports sfp_2_i2c_sda]
set_property IOSTANDARD LVCMOS18 [get_ports sfp_2_i2c_sda]
set_property SLEW SLOW [get_ports sfp_2_i2c_sda]
set_property DRIVE 12 [get_ports sfp_2_i2c_sda]
set_property PULLUP true [get_ports sfp_2_i2c_sda]

# 161.1328125 MHz MGT reference clock
create_clock -period 6.206 -name sfp_mgt_refclk [get_ports sfp_mgt_refclk_p]

# I2C interface
set_property PACKAGE_PIN B26 [get_ports eeprom_i2c_scl]
set_property IOSTANDARD LVCMOS18 [get_ports eeprom_i2c_scl]
set_property SLEW SLOW [get_ports eeprom_i2c_scl]
set_property DRIVE 12 [get_ports eeprom_i2c_scl]
set_property PULLUP true [get_ports eeprom_i2c_scl]
set_property PACKAGE_PIN C26 [get_ports eeprom_i2c_sda]
set_property IOSTANDARD LVCMOS18 [get_ports eeprom_i2c_sda]
set_property SLEW SLOW [get_ports eeprom_i2c_sda]
set_property DRIVE 12 [get_ports eeprom_i2c_sda]
set_property PULLUP true [get_ports eeprom_i2c_sda]

# PCIe Interface
set_property -dict {LOC P2} [get_ports {pcie_rx_p[0]}]
#set_property -dict {LOC P1  } [get_ports {pcie_rx_n[0]}] ;# MGTHTXN3_225 GTHE3_CHANNEL_X0Y7 / GTHE3_COMMON_X0Y1
set_property -dict {LOC R4} [get_ports {pcie_tx_p[0]}]
#set_property -dict {LOC R3  } [get_ports {pcie_tx_n[0]}] ;# MGTHTXN3_225 GTHE3_CHANNEL_X0Y7 / GTHE3_COMMON_X0Y1
set_property -dict {LOC T2} [get_ports {pcie_rx_p[1]}]
#set_property -dict {LOC T1  } [get_ports {pcie_rx_n[1]}] ;# MGTHTXN2_225 GTHE3_CHANNEL_X0Y6 / GTHE3_COMMON_X0Y1
set_property -dict {LOC U4} [get_ports {pcie_tx_p[1]}]
#set_property -dict {LOC U3  } [get_ports {pcie_tx_n[1]}] ;# MGTHTXN2_225 GTHE3_CHANNEL_X0Y6 / GTHE3_COMMON_X0Y1
set_property -dict {LOC V2} [get_ports {pcie_rx_p[2]}]
#set_property -dict {LOC V1  } [get_ports {pcie_rx_n[2]}] ;# MGTHTXN1_225 GTHE3_CHANNEL_X0Y5 / GTHE3_COMMON_X0Y1
set_property -dict {LOC W4} [get_ports {pcie_tx_p[2]}]
#set_property -dict {LOC W3  } [get_ports {pcie_tx_n[2]}] ;# MGTHTXN1_225 GTHE3_CHANNEL_X0Y5 / GTHE3_COMMON_X0Y1
set_property -dict {LOC Y2} [get_ports {pcie_rx_p[3]}]
#set_property -dict {LOC Y1  } [get_ports {pcie_rx_n[3]}] ;# MGTHTXN0_225 GTHE3_CHANNEL_X0Y4 / GTHE3_COMMON_X0Y1
set_property -dict {LOC AA4} [get_ports {pcie_tx_p[3]}]
#set_property -dict {LOC AA3 } [get_ports {pcie_tx_n[3]}] ;# MGTHTXN0_225 GTHE3_CHANNEL_X0Y4 / GTHE3_COMMON_X0Y1
set_property -dict {LOC AB2} [get_ports {pcie_rx_p[4]}]
#set_property -dict {LOC AB1 } [get_ports {pcie_rx_n[4]}] ;# MGTHTXN3_224 GTHE3_CHANNEL_X0Y3 / GTHE3_COMMON_X0Y0
set_property -dict {LOC AB6} [get_ports {pcie_tx_p[4]}]
#set_property -dict {LOC AB5 } [get_ports {pcie_tx_n[4]}] ;# MGTHTXN3_224 GTHE3_CHANNEL_X0Y3 / GTHE3_COMMON_X0Y0
set_property -dict {LOC AD2} [get_ports {pcie_rx_p[5]}]
#set_property -dict {LOC AD1 } [get_ports {pcie_rx_n[5]}] ;# MGTHTXN2_224 GTHE3_CHANNEL_X0Y2 / GTHE3_COMMON_X0Y0
set_property -dict {LOC AC4} [get_ports {pcie_tx_p[5]}]
#set_property -dict {LOC AC3 } [get_ports {pcie_tx_n[5]}] ;# MGTHTXN2_224 GTHE3_CHANNEL_X0Y2 / GTHE3_COMMON_X0Y0
set_property -dict {LOC AE4} [get_ports {pcie_rx_p[6]}]
#set_property -dict {LOC AE3 } [get_ports {pcie_rx_n[6]}] ;# MGTHTXN1_224 GTHE3_CHANNEL_X0Y1 / GTHE3_COMMON_X0Y0
set_property -dict {LOC AD6} [get_ports {pcie_tx_p[6]}]
#set_property -dict {LOC AD5 } [get_ports {pcie_tx_n[6]}] ;# MGTHTXN1_224 GTHE3_CHANNEL_X0Y1 / GTHE3_COMMON_X0Y0
set_property -dict {LOC AF2} [get_ports {pcie_rx_p[7]}]
#set_property -dict {LOC AF1 } [get_ports {pcie_rx_n[7]}] ;# MGTHTXN0_224 GTHE3_CHANNEL_X0Y0 / GTHE3_COMMON_X0Y0
set_property -dict {LOC AF6} [get_ports {pcie_tx_p[7]}]
#set_property -dict {LOC AF5 } [get_ports {pcie_tx_n[7]}] ;# MGTHTXN0_224 GTHE3_CHANNEL_X0Y0 / GTHE3_COMMON_X0Y0
set_property -dict {LOC T6} [get_ports pcie_mgt_refclk_p]
#set_property -dict {LOC T5  } [get_ports pcie_mgt_refclk_n] ;# MGTREFCLK0N_225
set_property LOC PCIE_3_1_X0Y0 [get_cells pcie3_ultrascale_inst/inst/pcie3_uscale_top_inst/pcie3_uscale_wrapper_inst/PCIE_3_1_inst]
set_property PACKAGE_PIN AC22 [get_ports pcie_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_reset_n]
set_property PULLUP true [get_ports pcie_reset_n]

# 100 MHz MGT reference clock
create_clock -period 10.000 -name pcie_mgt_refclk [get_ports pcie_mgt_refclk_p]

# Flash
set_property -dict {LOC AE10 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[0]}]
set_property -dict {LOC AC8 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[1]}]
set_property -dict {LOC AD10 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[2]}]
set_property -dict {LOC AD9 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[3]}]
set_property -dict {LOC AC11 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[4]}]
set_property -dict {LOC AF10 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[5]}]
set_property -dict {LOC AF14 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[6]}]
set_property -dict {LOC AE12 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[7]}]
set_property -dict {LOC AD14 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[8]}]
set_property -dict {LOC AF13 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[9]}]
set_property -dict {LOC AE13 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[10]}]
set_property -dict {LOC AD8 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[11]}]
set_property -dict {LOC AC13 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[12]}]
set_property -dict {LOC AD13 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[13]}]
set_property -dict {LOC AA14 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[14]}]
set_property -dict {LOC AB15 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_dq[15]}]
set_property -dict {LOC AD11 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[0]}]
set_property -dict {LOC AE11 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[1]}]
set_property -dict {LOC AF12 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[2]}]
set_property -dict {LOC AB11 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[3]}]
set_property -dict {LOC AB9 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[4]}]
set_property -dict {LOC AB14 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[5]}]
set_property -dict {LOC AA10 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[6]}]
set_property -dict {LOC AA9 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[7]}]
set_property -dict {LOC W10 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[8]}]
set_property -dict {LOC AA13 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[9]}]
set_property -dict {LOC Y15 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[10]}]
set_property -dict {LOC AC12 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[11]}]
set_property -dict {LOC V12 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[12]}]
set_property -dict {LOC V11 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[13]}]
set_property -dict {LOC Y12 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[14]}]
set_property -dict {LOC W9 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[15]}]
set_property -dict {LOC Y8 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[16]}]
set_property -dict {LOC W8 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[17]}]
set_property -dict {LOC W15 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[18]}]
set_property -dict {LOC AA15 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[19]}]
set_property -dict {LOC AE16 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[20]}]
set_property -dict {LOC AF15 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[21]}]
set_property -dict {LOC AE15 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports {flash_addr[22]}]
set_property PACKAGE_PIN AD15 [get_ports flash_region]
set_property IOSTANDARD LVCMOS18 [get_ports flash_region]
set_property PULLUP true [get_ports flash_region]
set_property -dict {LOC AC9 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports flash_ce_n]
set_property -dict {LOC AC14 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports flash_oe_n]
set_property -dict {LOC AB10 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports flash_we_n]
set_property -dict {LOC Y10 IOSTANDARD LVCMOS18 DRIVE 16} [get_ports flash_adv_n]

create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list {core_inst/riscv_cores[0].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X1Y60:SLICE_X19Y89}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X0Y24:DSP48E2_X2Y35}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X0Y24:RAMB18_X1Y35}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X0Y12:RAMB36_X1Y17}
set_property SNAPPING_MODE ON [get_pblocks pblock_1]
create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list {core_inst/riscv_cores[1].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X26Y60:SLICE_X44Y89}
resize_pblock [get_pblocks pblock_2] -add {DSP48E2_X4Y24:DSP48E2_X6Y35}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X3Y24:RAMB18_X4Y35}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X3Y12:RAMB36_X4Y17}
set_property SNAPPING_MODE ON [get_pblocks pblock_2]
create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list {core_inst/riscv_cores[2].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X57Y60:SLICE_X74Y89}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X9Y24:DSP48E2_X12Y35}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X6Y24:RAMB18_X7Y35}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X6Y12:RAMB36_X7Y17}
set_property SNAPPING_MODE ON [get_pblocks pblock_3]
create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list {core_inst/riscv_cores[3].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X78Y60:SLICE_X95Y89}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X14Y24:DSP48E2_X15Y35}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X8Y24:RAMB18_X9Y35}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X8Y12:RAMB36_X9Y17}
set_property SNAPPING_MODE ON [get_pblocks pblock_4]
create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list {core_inst/riscv_cores[4].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X1Y120:SLICE_X19Y149}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X0Y48:DSP48E2_X2Y59}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X0Y48:RAMB18_X1Y59}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X0Y24:RAMB36_X1Y29}
set_property SNAPPING_MODE ON [get_pblocks pblock_5]
create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list {core_inst/riscv_cores[5].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X26Y120:SLICE_X44Y149}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X4Y48:DSP48E2_X6Y59}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X3Y48:RAMB18_X4Y59}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X3Y24:RAMB36_X4Y29}
set_property SNAPPING_MODE ON [get_pblocks pblock_6]
create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list {core_inst/riscv_cores[6].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X57Y120:SLICE_X74Y149}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X9Y48:DSP48E2_X12Y59}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X6Y48:RAMB18_X7Y59}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X6Y24:RAMB36_X7Y29}
set_property SNAPPING_MODE ON [get_pblocks pblock_7]
create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list {core_inst/riscv_cores[7].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X78Y120:SLICE_X95Y149}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X14Y48:DSP48E2_X15Y59}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X8Y48:RAMB18_X9Y59}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X8Y24:RAMB36_X9Y29}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]
create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list {core_inst/riscv_cores[8].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X1Y180:SLICE_X19Y209}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X0Y72:DSP48E2_X2Y83}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X0Y72:RAMB18_X1Y83}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X0Y36:RAMB36_X1Y41}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]
create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list {core_inst/riscv_cores[9].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X26Y180:SLICE_X44Y209}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X4Y72:DSP48E2_X6Y83}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X3Y72:RAMB18_X4Y83}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X3Y36:RAMB36_X4Y41}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]
create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list {core_inst/riscv_cores[10].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X57Y180:SLICE_X74Y209}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X9Y72:DSP48E2_X12Y83}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X6Y72:RAMB18_X7Y83}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X6Y36:RAMB36_X7Y41}
set_property SNAPPING_MODE ON [get_pblocks pblock_11]
create_pblock pblock_12
add_cells_to_pblock [get_pblocks pblock_12] [get_cells -quiet [list {core_inst/riscv_cores[11].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_12] -add {SLICE_X78Y180:SLICE_X95Y209}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X14Y72:DSP48E2_X15Y83}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X8Y72:RAMB18_X9Y83}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X8Y36:RAMB36_X9Y41}
set_property SNAPPING_MODE ON [get_pblocks pblock_12]
create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list {core_inst/riscv_cores[12].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X1Y240:SLICE_X19Y269}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X0Y96:DSP48E2_X2Y107}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X0Y96:RAMB18_X1Y107}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X0Y48:RAMB36_X1Y53}
set_property SNAPPING_MODE ON [get_pblocks pblock_13]
create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list {core_inst/riscv_cores[13].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X26Y240:SLICE_X44Y269}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X4Y96:DSP48E2_X6Y107}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X3Y96:RAMB18_X4Y107}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X3Y48:RAMB36_X4Y53}
set_property SNAPPING_MODE ON [get_pblocks pblock_14]
create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list {core_inst/riscv_cores[14].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X57Y240:SLICE_X74Y269}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X9Y96:DSP48E2_X12Y107}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X6Y96:RAMB18_X7Y107}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X6Y48:RAMB36_X7Y53}
set_property SNAPPING_MODE ON [get_pblocks pblock_15]
create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list {core_inst/riscv_cores[15].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X78Y240:SLICE_X95Y269}
resize_pblock [get_pblocks pblock_16] -add {DSP48E2_X14Y96:DSP48E2_X15Y107}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X8Y96:RAMB18_X9Y107}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X8Y48:RAMB36_X9Y53}
set_property SNAPPING_MODE ON [get_pblocks pblock_16]
