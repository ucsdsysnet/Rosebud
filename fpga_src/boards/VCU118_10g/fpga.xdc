# XDC constraints for the Xilinx VCU118 board
# part: xcvu9p-flga2104-2L-e

# General configuration
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN DIV-1 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 8 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]

# System clocks
# 300 MHz
#set_property -dict {LOC G31  IOSTANDARD DIFF_SSTL12} [get_ports clk_300mhz_p]
#set_property -dict {LOC F31  IOSTANDARD DIFF_SSTL12} [get_ports clk_300mhz_n]
#create_clock -period 3.333 -name clk_300mhz [get_ports clk_300mhz_p]

# 250 MHz
#set_property -dict {LOC E12  IOSTANDARD DIFF_SSTL12} [get_ports clk_250mhz_1_p]
#set_property -dict {LOC D12  IOSTANDARD DIFF_SSTL12} [get_ports clk_250mhz_1_n]
#create_clock -period 4 -name clk_250mhz_1 [get_ports clk_250mhz_1_p]

#set_property -dict {LOC AW26 IOSTANDARD DIFF_SSTL12} [get_ports clk_250mhz_2_p]
#set_property -dict {LOC AW27 IOSTANDARD DIFF_SSTL12} [get_ports clk_250mhz_2_n]
#create_clock -period 4 -name clk_250mhz_2 [get_ports clk_250mhz_2_p]

# 125 MHz
set_property -dict {LOC AY24 IOSTANDARD LVDS} [get_ports clk_125mhz_p]
set_property -dict {LOC AY23 IOSTANDARD LVDS} [get_ports clk_125mhz_n]
create_clock -period 8.000 -name clk_125mhz [get_ports clk_125mhz_p]

# 90 MHz
#set_property -dict {LOC AL20 IOSTANDARD LVCMOS18} [get_ports clk_90mhz]
#create_clock -period 11.111 -name clk_90mhz [get_ports clk_90mhz]

# LEDs
set_property -dict {LOC AT32 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[0]}]
set_property -dict {LOC AV34 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[1]}]
set_property -dict {LOC AY30 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[2]}]
set_property -dict {LOC BB32 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[3]}]
set_property -dict {LOC BF32 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[4]}]
set_property -dict {LOC AU37 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[5]}]
set_property -dict {LOC AV36 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[6]}]
set_property -dict {LOC BA37 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {led[7]}]

# Reset button
#set_property -dict {LOC L19  IOSTANDARD LVCMOS12} [get_ports reset]

# Push buttons
set_property -dict {LOC BB24 IOSTANDARD LVCMOS18} [get_ports btnu]
set_property -dict {LOC BF22 IOSTANDARD LVCMOS18} [get_ports btnl]
set_property -dict {LOC BE22 IOSTANDARD LVCMOS18} [get_ports btnd]
set_property -dict {LOC BE23 IOSTANDARD LVCMOS18} [get_ports btnr]
set_property -dict {LOC BD23 IOSTANDARD LVCMOS18} [get_ports btnc]

# DIP switches
set_property -dict {LOC B17 IOSTANDARD LVCMOS12} [get_ports {sw[0]}]
set_property -dict {LOC G16 IOSTANDARD LVCMOS12} [get_ports {sw[1]}]
set_property -dict {LOC J16 IOSTANDARD LVCMOS12} [get_ports {sw[2]}]
set_property -dict {LOC D21 IOSTANDARD LVCMOS12} [get_ports {sw[3]}]

# PMOD0
set_property -dict {LOC AY14 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {pmod0[0]}]
set_property -dict {LOC AY15 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {pmod0[1]}]
set_property -dict {LOC AW15 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {pmod0[2]}]
set_property -dict {LOC AV15 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {pmod0[3]}]
set_property -dict {LOC AV16 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {pmod0[4]}]
set_property -dict {LOC AU16 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {pmod0[5]}]
set_property -dict {LOC AT15 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {pmod0[6]}]
set_property -dict {LOC AT16 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports {pmod0[7]}]

# PMOD1
set_property -dict {LOC N28 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {pmod1[0]}]
set_property -dict {LOC M30 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {pmod1[1]}]
set_property -dict {LOC N30 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {pmod1[2]}]
set_property -dict {LOC P30 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {pmod1[3]}]
set_property -dict {LOC P29 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {pmod1[4]}]
set_property -dict {LOC L31 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {pmod1[5]}]
set_property -dict {LOC M31 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {pmod1[6]}]
set_property -dict {LOC R29 IOSTANDARD LVCMOS12 SLEW SLOW DRIVE 8} [get_ports {pmod1[7]}]

# UART
#set_property -dict {LOC BB21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports uart_txd]
#set_property -dict {LOC AW25 IOSTANDARD LVCMOS18} [get_ports uart_rxd]
#set_property -dict {LOC BB22 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports uart_rts]
#set_property -dict {LOC AY25 IOSTANDARD LVCMOS18} [get_ports uart_cts]

# Gigabit Ethernet SGMII PHY
#set_property -dict {LOC AU24 IOSTANDARD LVDS} [get_ports phy_sgmii_rx_p]
#set_property -dict {LOC AV24 IOSTANDARD LVDS} [get_ports phy_sgmii_rx_n]
#set_property -dict {LOC AU21 IOSTANDARD LVDS} [get_ports phy_sgmii_tx_p]
#set_property -dict {LOC AV21 IOSTANDARD LVDS} [get_ports phy_sgmii_tx_n]
#set_property -dict {LOC AT22 IOSTANDARD LVDS} [get_ports phy_sgmii_clk_p]
#set_property -dict {LOC AU22 IOSTANDARD LVDS} [get_ports phy_sgmii_clk_n]
#set_property -dict {LOC BA21 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports phy_reset_n]
#set_property -dict {LOC AR24 IOSTANDARD LVCMOS18} [get_ports phy_int_n]
#set_property -dict {LOC AR23 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports phy_mdio]
#set_property -dict {LOC AV23 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports phy_mdc]

# 625 MHz ref clock from SGMII PHY
#create_clock -period 1.600 -name phy_sgmii_clk [get_ports phy_sgmii_clk_p]

# QSFP28 Interfaces
set_property -dict {LOC V7} [get_ports qsfp1_tx1_p]
#set_property -dict {LOC V6  } [get_ports qsfp1_tx1_n] ;# MGTYTXP0_231 GTYE3_CHANNEL_X1Y48 / GTYE3_COMMON_X1Y12
set_property -dict {LOC Y2} [get_ports qsfp1_rx1_p]
#set_property -dict {LOC Y1  } [get_ports qsfp1_rx1_n] ;# MGTYTXP1_231 GTYE3_CHANNEL_X1Y48 / GTYE3_COMMON_X1Y12
set_property -dict {LOC T7} [get_ports qsfp1_tx2_p]
#set_property -dict {LOC T6  } [get_ports qsfp1_tx2_n] ;# MGTYTXP2_231 GTYE3_CHANNEL_X1Y49 / GTYE3_COMMON_X1Y12
set_property -dict {LOC W4} [get_ports qsfp1_rx2_p]
#set_property -dict {LOC W3  } [get_ports qsfp1_rx2_n] ;# MGTYTXP3_231 GTYE3_CHANNEL_X1Y49 / GTYE3_COMMON_X1Y12
set_property -dict {LOC P7} [get_ports qsfp1_tx3_p]
#set_property -dict {LOC P6  } [get_ports qsfp1_tx3_n] ;# MGTYTXP0_231 GTYE3_CHANNEL_X1Y50 / GTYE3_COMMON_X1Y12
set_property -dict {LOC V2} [get_ports qsfp1_rx3_p]
#set_property -dict {LOC V1  } [get_ports qsfp1_rx3_n] ;# MGTYTXP1_231 GTYE3_CHANNEL_X1Y50 / GTYE3_COMMON_X1Y12
set_property -dict {LOC M7} [get_ports qsfp1_tx4_p]
#set_property -dict {LOC M6  } [get_ports qsfp1_tx4_n] ;# MGTYTXP2_231 GTYE3_CHANNEL_X1Y51 / GTYE3_COMMON_X1Y12
set_property -dict {LOC U4} [get_ports qsfp1_rx4_p]
#set_property -dict {LOC U3  } [get_ports qsfp1_rx4_n] ;# MGTYTXP3_231 GTYE3_CHANNEL_X1Y51 / GTYE3_COMMON_X1Y12
set_property -dict {LOC W9} [get_ports qsfp1_mgt_refclk_0_p]
#set_property -dict {LOC W8  } [get_ports qsfp1_mgt_refclk_0_n] ;# MGTREFCLK0N_231 from U38.5
#set_property -dict {LOC U9  } [get_ports qsfp1_mgt_refclk_1_p] ;# MGTREFCLK1P_231 from U57.28
#set_property -dict {LOC U8  } [get_ports qsfp1_mgt_refclk_1_n] ;# MGTREFCLK1N_231 from U57.29
#set_property -dict {LOC AM23 IOSTANDARD LVDS} [get_ports qsfp1_recclk_p] ;# to U57.16
#set_property -dict {LOC AM22 IOSTANDARD LVDS} [get_ports qsfp1_recclk_n] ;# to U57.17
set_property -dict {LOC AM21 IOSTANDARD LVCMOS18} [get_ports qsfp1_modsell]
set_property -dict {LOC BA22 IOSTANDARD LVCMOS18} [get_ports qsfp1_resetl]
set_property -dict {LOC AL21 IOSTANDARD LVCMOS18} [get_ports qsfp1_modprsl]
set_property -dict {LOC AP21 IOSTANDARD LVCMOS18} [get_ports qsfp1_intl]
set_property -dict {LOC AN21 IOSTANDARD LVCMOS18} [get_ports qsfp1_lpmode]

# 156.25 MHz MGT reference clock
create_clock -period 6.400 -name qsfp1_mgt_refclk_0 [get_ports qsfp1_mgt_refclk_0_p]

set_property -dict {LOC L5} [get_ports qsfp2_tx1_p]
#set_property -dict {LOC L4  } [get_ports qsfp2_tx1_n] ;# MGTYTXP0_232 GTYE3_CHANNEL_X1Y52 / GTYE3_COMMON_X1Y13
set_property -dict {LOC T2} [get_ports qsfp2_rx1_p]
#set_property -dict {LOC T1  } [get_ports qsfp2_rx1_n] ;# MGTYTXP1_232 GTYE3_CHANNEL_X1Y52 / GTYE3_COMMON_X1Y13
set_property -dict {LOC K7} [get_ports qsfp2_tx2_p]
#set_property -dict {LOC K6  } [get_ports qsfp2_tx2_n] ;# MGTYTXP2_232 GTYE3_CHANNEL_X1Y53 / GTYE3_COMMON_X1Y13
set_property -dict {LOC R4} [get_ports qsfp2_rx2_p]
#set_property -dict {LOC R3  } [get_ports qsfp2_rx2_n] ;# MGTYTXP3_232 GTYE3_CHANNEL_X1Y53 / GTYE3_COMMON_X1Y13
set_property -dict {LOC J5} [get_ports qsfp2_tx3_p]
#set_property -dict {LOC J4  } [get_ports qsfp2_tx3_n] ;# MGTYTXP0_232 GTYE3_CHANNEL_X1Y54 / GTYE3_COMMON_X1Y13
set_property -dict {LOC P2} [get_ports qsfp2_rx3_p]
#set_property -dict {LOC P1  } [get_ports qsfp2_rx3_n] ;# MGTYTXP1_232 GTYE3_CHANNEL_X1Y54 / GTYE3_COMMON_X1Y13
set_property -dict {LOC H7} [get_ports qsfp2_tx4_p]
#set_property -dict {LOC H6  } [get_ports qsfp2_tx4_n] ;# MGTYTXP2_232 GTYE3_CHANNEL_X1Y55 / GTYE3_COMMON_X1Y13
set_property -dict {LOC M2} [get_ports qsfp2_rx4_p]
#set_property -dict {LOC M1  } [get_ports qsfp2_rx4_n] ;# MGTYTXP3_232 GTYE3_CHANNEL_X1Y55 / GTYE3_COMMON_X1Y13
#set_property -dict {LOC R9  } [get_ports qsfp2_mgt_refclk_0_p] ;# MGTREFCLK0P_232 from U104.13
#set_property -dict {LOC R8  } [get_ports qsfp2_mgt_refclk_0_n] ;# MGTREFCLK0N_232 from U104.14
#set_property -dict {LOC N9  } [get_ports qsfp2_mgt_refclk_1_p] ;# MGTREFCLK1P_232 from U57.35
#set_property -dict {LOC N8  } [get_ports qsfp2_mgt_refclk_1_n] ;# MGTREFCLK1N_232 from U57.34
#set_property -dict {LOC AP23 IOSTANDARD LVDS} [get_ports qsfp2_recclk_p] ;# to U57.12
#set_property -dict {LOC AP22 IOSTANDARD LVDS} [get_ports qsfp2_recclk_n] ;# to U57.13
set_property -dict {LOC AN23 IOSTANDARD LVCMOS18} [get_ports qsfp2_modsell]
set_property -dict {LOC AY22 IOSTANDARD LVCMOS18} [get_ports qsfp2_resetl]
set_property -dict {LOC AN24 IOSTANDARD LVCMOS18} [get_ports qsfp2_modprsl]
set_property -dict {LOC AT21 IOSTANDARD LVCMOS18} [get_ports qsfp2_intl]
set_property -dict {LOC AT24 IOSTANDARD LVCMOS18} [get_ports qsfp2_lpmode]

# 156.25 MHz MGT reference clock
#create_clock -period 6.400 -name qsfp2_mgt_refclk_0 [get_ports qsfp2_mgt_refclk_0_p]

# I2C interface
set_property -dict {LOC AM24 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports i2c_scl]
set_property -dict {LOC AL24 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 8} [get_ports i2c_sda]

# PCIe Interface
set_property -dict {LOC AA4} [get_ports {pcie_rx_p[0]}]
#set_property -dict {LOC AA3  } [get_ports {pcie_rx_n[0]}]  ;# MGTYTXP3_227 GTYE3_CHANNEL_X0Y7 / GTYE3_COMMON_X0Y1
set_property -dict {LOC Y7} [get_ports {pcie_tx_p[0]}]
#set_property -dict {LOC Y6   } [get_ports {pcie_tx_n[0]}]  ;# MGTYTXP3_227 GTYE3_CHANNEL_X0Y7 / GTYE3_COMMON_X0Y1
set_property -dict {LOC AB2} [get_ports {pcie_rx_p[1]}]
#set_property -dict {LOC AB1  } [get_ports {pcie_rx_n[1]}]  ;# MGTYTXP2_227 GTYE3_CHANNEL_X0Y6 / GTYE3_COMMON_X0Y1
set_property -dict {LOC AB7} [get_ports {pcie_tx_p[1]}]
#set_property -dict {LOC AB6  } [get_ports {pcie_tx_n[1]}]  ;# MGTYTXP2_227 GTYE3_CHANNEL_X0Y6 / GTYE3_COMMON_X0Y1
set_property -dict {LOC AC4} [get_ports {pcie_rx_p[2]}]
#set_property -dict {LOC AC3  } [get_ports {pcie_rx_n[2]}]  ;# MGTYTXP1_227 GTYE3_CHANNEL_X0Y5 / GTYE3_COMMON_X0Y1
set_property -dict {LOC AD7} [get_ports {pcie_tx_p[2]}]
#set_property -dict {LOC AD6  } [get_ports {pcie_tx_n[2]}]  ;# MGTYTXP1_227 GTYE3_CHANNEL_X0Y5 / GTYE3_COMMON_X0Y1
set_property -dict {LOC AD2} [get_ports {pcie_rx_p[3]}]
#set_property -dict {LOC AD1  } [get_ports {pcie_rx_n[3]}]  ;# MGTYTXP0_227 GTYE3_CHANNEL_X0Y4 / GTYE3_COMMON_X0Y1
set_property -dict {LOC AF7} [get_ports {pcie_tx_p[3]}]
#set_property -dict {LOC AF6  } [get_ports {pcie_tx_n[3]}]  ;# MGTYTXP0_227 GTYE3_CHANNEL_X0Y4 / GTYE3_COMMON_X0Y1
set_property -dict {LOC AE4} [get_ports {pcie_rx_p[4]}]
#set_property -dict {LOC AE3  } [get_ports {pcie_rx_n[4]}]  ;# MGTYTXP3_226 GTYE3_CHANNEL_X0Y3 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AH7} [get_ports {pcie_tx_p[4]}]
#set_property -dict {LOC AH6  } [get_ports {pcie_tx_n[4]}]  ;# MGTYTXP3_226 GTYE3_CHANNEL_X0Y3 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AF2} [get_ports {pcie_rx_p[5]}]
#set_property -dict {LOC AF1  } [get_ports {pcie_rx_n[5]}]  ;# MGTYTXP2_226 GTYE3_CHANNEL_X0Y2 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AK7} [get_ports {pcie_tx_p[5]}]
#set_property -dict {LOC AK6  } [get_ports {pcie_tx_n[5]}]  ;# MGTYTXP2_226 GTYE3_CHANNEL_X0Y2 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AG4} [get_ports {pcie_rx_p[6]}]
#set_property -dict {LOC AG3  } [get_ports {pcie_rx_n[6]}]  ;# MGTYTXP1_226 GTYE3_CHANNEL_X0Y1 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AM7} [get_ports {pcie_tx_p[6]}]
#set_property -dict {LOC AM6  } [get_ports {pcie_tx_n[6]}]  ;# MGTYTXP1_226 GTYE3_CHANNEL_X0Y1 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AH2} [get_ports {pcie_rx_p[7]}]
#set_property -dict {LOC AH1  } [get_ports {pcie_rx_n[7]}]  ;# MGTYTXP0_226 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AN5} [get_ports {pcie_tx_p[7]}]
#set_property -dict {LOC AN4  } [get_ports {pcie_tx_n[7]}]  ;# MGTYTXP0_226 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AJ4} [get_ports {pcie_rx_p[8]}]
#set_property -dict {LOC AJ3  } [get_ports {pcie_rx_n[8]}]  ;# MGTYTXP3_225 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AP7} [get_ports {pcie_tx_p[8]}]
#set_property -dict {LOC AP6  } [get_ports {pcie_tx_n[8]}]  ;# MGTYTXP3_225 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AK2} [get_ports {pcie_rx_p[9]}]
#set_property -dict {LOC AK1  } [get_ports {pcie_rx_n[9]}]  ;# MGTYTXP2_225 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AR5} [get_ports {pcie_tx_p[9]}]
#set_property -dict {LOC AR4  } [get_ports {pcie_tx_n[9]}]  ;# MGTYTXP2_225 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AM2} [get_ports {pcie_rx_p[10]}]
#set_property -dict {LOC AM1  } [get_ports {pcie_rx_n[10]}] ;# MGTYTXP1_225 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AT7} [get_ports {pcie_tx_p[10]}]
#set_property -dict {LOC AT6  } [get_ports {pcie_tx_n[10]}] ;# MGTYTXP1_225 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AP2} [get_ports {pcie_rx_p[11]}]
#set_property -dict {LOC AP1  } [get_ports {pcie_rx_n[11]}] ;# MGTYTXP0_225 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AU5} [get_ports {pcie_tx_p[11]}]
#set_property -dict {LOC AU4  } [get_ports {pcie_tx_n[11]}] ;# MGTYTXP0_225 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AT2} [get_ports {pcie_rx_p[12]}]
#set_property -dict {LOC AT1  } [get_ports {pcie_rx_n[12]}] ;# MGTYTXP3_224 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AW5} [get_ports {pcie_tx_p[12]}]
#set_property -dict {LOC AW4  } [get_ports {pcie_tx_n[12]}] ;# MGTYTXP3_224 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AV2} [get_ports {pcie_rx_p[13]}]
#set_property -dict {LOC AV1  } [get_ports {pcie_rx_n[13]}] ;# MGTYTXP2_224 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC BA5} [get_ports {pcie_tx_p[13]}]
#set_property -dict {LOC BA4  } [get_ports {pcie_tx_n[13]}] ;# MGTYTXP2_224 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC AY2} [get_ports {pcie_rx_p[14]}]
#set_property -dict {LOC AY1  } [get_ports {pcie_rx_n[14]}] ;# MGTYTXP1_224 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC BC5} [get_ports {pcie_tx_p[14]}]
#set_property -dict {LOC BC4  } [get_ports {pcie_tx_n[14]}] ;# MGTYTXP1_224 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC BB2} [get_ports {pcie_rx_p[15]}]
#set_property -dict {LOC BB1  } [get_ports {pcie_rx_n[15]}] ;# MGTYTXP0_224 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
set_property -dict {LOC BE5} [get_ports {pcie_tx_p[15]}]
#set_property -dict {LOC BE4  } [get_ports {pcie_tx_n[15]}] ;# MGTYTXP0_224 GTYE3_CHANNEL_X0Y0 / GTYE3_COMMON_X0Y0
#set_property -dict {LOC AC9  } [get_ports pcie_refclk_1_p] ;# MGTREFCLK0P_227
#set_property -dict {LOC AC8  } [get_ports pcie_refclk_1_n] ;# MGTREFCLK0N_227
set_property -dict {LOC AL9} [get_ports pcie_refclk_2_p]
#set_property -dict {LOC AL8  } [get_ports pcie_refclk_2_n] ;# MGTREFCLK0N_225
set_property PACKAGE_PIN AM17 [get_ports pcie_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_reset_n]
set_property PULLUP true [get_ports pcie_reset_n]

# 100 MHz MGT reference clock
#create_clock -period 10 -name pcie_mgt_refclk_1 [get_ports pcie_refclk_1_p]
create_clock -period 10.000 -name pcie_mgt_refclk_2 [get_ports pcie_refclk_2_p]



create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list {core_inst/riscv_cores[0].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X31Y300:SLICE_X54Y359}
resize_pblock [get_pblocks pblock_1] -add {DSP48E2_X5Y120:DSP48E2_X7Y143}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X3Y120:RAMB18_X3Y143}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X3Y60:RAMB36_X3Y71}
resize_pblock [get_pblocks pblock_1] -add {URAM288_X0Y80:URAM288_X0Y95}
set_property SNAPPING_MODE ON [get_pblocks pblock_1]
create_pblock pblock_2
add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list {core_inst/riscv_cores[1].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_2] -add {SLICE_X31Y360:SLICE_X54Y419}
resize_pblock [get_pblocks pblock_2] -add {DSP48E2_X5Y144:DSP48E2_X7Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB18_X3Y144:RAMB18_X3Y167}
resize_pblock [get_pblocks pblock_2] -add {RAMB36_X3Y72:RAMB36_X3Y83}
resize_pblock [get_pblocks pblock_2] -add {URAM288_X0Y96:URAM288_X0Y111}
set_property SNAPPING_MODE ON [get_pblocks pblock_2]
create_pblock pblock_3
add_cells_to_pblock [get_pblocks pblock_3] [get_cells -quiet [list {core_inst/riscv_cores[2].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_3] -add {SLICE_X64Y300:SLICE_X87Y359}
resize_pblock [get_pblocks pblock_3] -add {DSP48E2_X9Y120:DSP48E2_X10Y143}
resize_pblock [get_pblocks pblock_3] -add {RAMB18_X5Y120:RAMB18_X6Y143}
resize_pblock [get_pblocks pblock_3] -add {RAMB36_X5Y60:RAMB36_X6Y71}
resize_pblock [get_pblocks pblock_3] -add {URAM288_X1Y80:URAM288_X1Y95}
set_property SNAPPING_MODE ON [get_pblocks pblock_3]
create_pblock pblock_4
add_cells_to_pblock [get_pblocks pblock_4] [get_cells -quiet [list {core_inst/riscv_cores[3].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_4] -add {SLICE_X64Y360:SLICE_X87Y419}
resize_pblock [get_pblocks pblock_4] -add {DSP48E2_X9Y144:DSP48E2_X10Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB18_X5Y144:RAMB18_X6Y167}
resize_pblock [get_pblocks pblock_4] -add {RAMB36_X5Y72:RAMB36_X6Y83}
resize_pblock [get_pblocks pblock_4] -add {URAM288_X1Y96:URAM288_X1Y111}
set_property SNAPPING_MODE ON [get_pblocks pblock_4]
create_pblock pblock_5
add_cells_to_pblock [get_pblocks pblock_5] [get_cells -quiet [list {core_inst/riscv_cores[4].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_5] -add {SLICE_X31Y420:SLICE_X54Y479}
resize_pblock [get_pblocks pblock_5] -add {DSP48E2_X5Y168:DSP48E2_X7Y191}
resize_pblock [get_pblocks pblock_5] -add {RAMB18_X3Y168:RAMB18_X3Y191}
resize_pblock [get_pblocks pblock_5] -add {RAMB36_X3Y84:RAMB36_X3Y95}
resize_pblock [get_pblocks pblock_5] -add {URAM288_X0Y112:URAM288_X0Y127}
set_property SNAPPING_MODE ON [get_pblocks pblock_5]
create_pblock pblock_6
add_cells_to_pblock [get_pblocks pblock_6] [get_cells -quiet [list {core_inst/riscv_cores[5].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_6] -add {SLICE_X31Y480:SLICE_X51Y539}
resize_pblock [get_pblocks pblock_6] -add {DSP48E2_X5Y192:DSP48E2_X7Y215}
resize_pblock [get_pblocks pblock_6] -add {RAMB18_X3Y192:RAMB18_X3Y215}
resize_pblock [get_pblocks pblock_6] -add {RAMB36_X3Y96:RAMB36_X3Y107}
resize_pblock [get_pblocks pblock_6] -add {URAM288_X0Y128:URAM288_X0Y143}
set_property SNAPPING_MODE ON [get_pblocks pblock_6]
create_pblock pblock_7
add_cells_to_pblock [get_pblocks pblock_7] [get_cells -quiet [list {core_inst/riscv_cores[6].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_7] -add {SLICE_X64Y420:SLICE_X87Y479}
resize_pblock [get_pblocks pblock_7] -add {DSP48E2_X9Y168:DSP48E2_X10Y191}
resize_pblock [get_pblocks pblock_7] -add {RAMB18_X5Y168:RAMB18_X6Y191}
resize_pblock [get_pblocks pblock_7] -add {RAMB36_X5Y84:RAMB36_X6Y95}
resize_pblock [get_pblocks pblock_7] -add {URAM288_X1Y112:URAM288_X1Y127}
set_property SNAPPING_MODE ON [get_pblocks pblock_7]
create_pblock pblock_8
add_cells_to_pblock [get_pblocks pblock_8] [get_cells -quiet [list {core_inst/riscv_cores[7].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_8] -add {SLICE_X64Y480:SLICE_X87Y539}
resize_pblock [get_pblocks pblock_8] -add {DSP48E2_X9Y192:DSP48E2_X10Y215}
resize_pblock [get_pblocks pblock_8] -add {RAMB18_X5Y192:RAMB18_X6Y215}
resize_pblock [get_pblocks pblock_8] -add {RAMB36_X5Y96:RAMB36_X6Y107}
resize_pblock [get_pblocks pblock_8] -add {URAM288_X1Y128:URAM288_X1Y143}
set_property SNAPPING_MODE ON [get_pblocks pblock_8]
create_pblock pblock_9
add_cells_to_pblock [get_pblocks pblock_9] [get_cells -quiet [list {core_inst/riscv_cores[8].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_9] -add {SLICE_X31Y600:SLICE_X54Y659}
resize_pblock [get_pblocks pblock_9] -add {DSP48E2_X5Y240:DSP48E2_X7Y263}
resize_pblock [get_pblocks pblock_9] -add {RAMB18_X3Y240:RAMB18_X3Y263}
resize_pblock [get_pblocks pblock_9] -add {RAMB36_X3Y120:RAMB36_X3Y131}
resize_pblock [get_pblocks pblock_9] -add {URAM288_X0Y160:URAM288_X0Y175}
set_property SNAPPING_MODE ON [get_pblocks pblock_9]
create_pblock pblock_10
add_cells_to_pblock [get_pblocks pblock_10] [get_cells -quiet [list {core_inst/riscv_cores[9].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_10] -add {SLICE_X31Y660:SLICE_X54Y719}
resize_pblock [get_pblocks pblock_10] -add {DSP48E2_X5Y264:DSP48E2_X7Y287}
resize_pblock [get_pblocks pblock_10] -add {RAMB18_X3Y264:RAMB18_X3Y287}
resize_pblock [get_pblocks pblock_10] -add {RAMB36_X3Y132:RAMB36_X3Y143}
resize_pblock [get_pblocks pblock_10] -add {URAM288_X0Y176:URAM288_X0Y191}
set_property SNAPPING_MODE ON [get_pblocks pblock_10]
create_pblock pblock_11
add_cells_to_pblock [get_pblocks pblock_11] [get_cells -quiet [list {core_inst/riscv_cores[10].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_11] -add {SLICE_X64Y600:SLICE_X87Y659}
resize_pblock [get_pblocks pblock_11] -add {DSP48E2_X9Y240:DSP48E2_X10Y263}
resize_pblock [get_pblocks pblock_11] -add {RAMB18_X5Y240:RAMB18_X6Y263}
resize_pblock [get_pblocks pblock_11] -add {RAMB36_X5Y120:RAMB36_X6Y131}
resize_pblock [get_pblocks pblock_11] -add {URAM288_X1Y160:URAM288_X1Y175}
set_property SNAPPING_MODE ON [get_pblocks pblock_11]
create_pblock pblock_12
add_cells_to_pblock [get_pblocks pblock_12] [get_cells -quiet [list {core_inst/riscv_cores[11].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_12] -add {SLICE_X64Y660:SLICE_X87Y719}
resize_pblock [get_pblocks pblock_12] -add {DSP48E2_X9Y264:DSP48E2_X10Y287}
resize_pblock [get_pblocks pblock_12] -add {RAMB18_X5Y264:RAMB18_X6Y287}
resize_pblock [get_pblocks pblock_12] -add {RAMB36_X5Y132:RAMB36_X6Y143}
resize_pblock [get_pblocks pblock_12] -add {URAM288_X1Y176:URAM288_X1Y191}
set_property SNAPPING_MODE ON [get_pblocks pblock_12]
create_pblock pblock_13
add_cells_to_pblock [get_pblocks pblock_13] [get_cells -quiet [list {core_inst/riscv_cores[12].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_13] -add {SLICE_X31Y720:SLICE_X54Y779}
resize_pblock [get_pblocks pblock_13] -add {DSP48E2_X5Y288:DSP48E2_X7Y311}
resize_pblock [get_pblocks pblock_13] -add {RAMB18_X3Y288:RAMB18_X3Y311}
resize_pblock [get_pblocks pblock_13] -add {RAMB36_X3Y144:RAMB36_X3Y155}
resize_pblock [get_pblocks pblock_13] -add {URAM288_X0Y192:URAM288_X0Y207}
set_property SNAPPING_MODE ON [get_pblocks pblock_13]
create_pblock pblock_14
add_cells_to_pblock [get_pblocks pblock_14] [get_cells -quiet [list {core_inst/riscv_cores[13].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_14] -add {SLICE_X31Y780:SLICE_X54Y839}
resize_pblock [get_pblocks pblock_14] -add {DSP48E2_X5Y312:DSP48E2_X7Y335}
resize_pblock [get_pblocks pblock_14] -add {RAMB18_X3Y312:RAMB18_X3Y335}
resize_pblock [get_pblocks pblock_14] -add {RAMB36_X3Y156:RAMB36_X3Y167}
resize_pblock [get_pblocks pblock_14] -add {URAM288_X0Y208:URAM288_X0Y223}
set_property SNAPPING_MODE ON [get_pblocks pblock_14]
create_pblock pblock_15
add_cells_to_pblock [get_pblocks pblock_15] [get_cells -quiet [list {core_inst/riscv_cores[14].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_15] -add {SLICE_X64Y720:SLICE_X87Y779}
resize_pblock [get_pblocks pblock_15] -add {DSP48E2_X9Y288:DSP48E2_X10Y311}
resize_pblock [get_pblocks pblock_15] -add {RAMB18_X5Y288:RAMB18_X6Y311}
resize_pblock [get_pblocks pblock_15] -add {RAMB36_X5Y144:RAMB36_X6Y155}
resize_pblock [get_pblocks pblock_15] -add {URAM288_X1Y192:URAM288_X1Y207}
set_property SNAPPING_MODE ON [get_pblocks pblock_15]
create_pblock pblock_16
add_cells_to_pblock [get_pblocks pblock_16] [get_cells -quiet [list {core_inst/riscv_cores[15].riscv_block_inst}]]
resize_pblock [get_pblocks pblock_16] -add {SLICE_X64Y780:SLICE_X87Y839}
resize_pblock [get_pblocks pblock_16] -add {DSP48E2_X9Y312:DSP48E2_X10Y335}
resize_pblock [get_pblocks pblock_16] -add {RAMB18_X5Y312:RAMB18_X6Y335}
resize_pblock [get_pblocks pblock_16] -add {RAMB36_X5Y156:RAMB36_X6Y167}
resize_pblock [get_pblocks pblock_16] -add {URAM288_X1Y208:URAM288_X1Y223}
set_property SNAPPING_MODE ON [get_pblocks pblock_16]

# set_input_delay -clock [get_clocks -of_objects [get_pins pcie4_uscale_plus_inst/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] 0.000 [get_ports {pcie_reset_n qsfp1_intl qsfp1_modprsl qsfp2_intl qsfp2_modprsl}]
# set_output_delay -clock [get_clocks -of_objects [get_pins pcie4_uscale_plus_inst/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] 0.000 [get_ports {qsfp1_modsell qsfp1_resetl qsfp2_modsell qsfp2_resetl}]
# set_input_delay -clock [get_clocks -of_objects [get_pins pcie4_uscale_plus_inst/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] 0.000 [get_ports -filter { NAME =~  "*" && DIRECTION == "INOUT" }]
# set_output_delay -clock [get_clocks -of_objects [get_pins pcie4_uscale_plus_inst/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] 0.000 [get_ports -filter { NAME =~  "*" && DIRECTION == "INOUT" }]



