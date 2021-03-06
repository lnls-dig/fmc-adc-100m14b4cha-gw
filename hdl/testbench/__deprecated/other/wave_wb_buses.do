onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Local Clock}
add wave -noupdate /tb_spec/u1/clk20_vcxo_i
add wave -noupdate -divider L2P
add wave -noupdate /tb_spec/l2p_clkp
add wave -noupdate /tb_spec/l2p_clkn
add wave -noupdate -radix hexadecimal /tb_spec/l2p_data
add wave -noupdate -radix hexadecimal /tb_spec/l2p_data_32
add wave -noupdate /tb_spec/l2p_dframe
add wave -noupdate /tb_spec/l2p_valid
add wave -noupdate /tb_spec/l2p_edb
add wave -noupdate /tb_spec/l_wr_rdy
add wave -noupdate /tb_spec/p_rd_d_rdy
add wave -noupdate /tb_spec/l2p_rdy
add wave -noupdate /tb_spec/tx_error
add wave -noupdate -divider P2L
add wave -noupdate /tb_spec/p2l_clkp
add wave -noupdate /tb_spec/p2l_clkn
add wave -noupdate -radix hexadecimal /tb_spec/p2l_data
add wave -noupdate -radix hexadecimal /tb_spec/p2l_data_32
add wave -noupdate /tb_spec/p2l_dframe
add wave -noupdate /tb_spec/p2l_valid
add wave -noupdate /tb_spec/p2l_rdy
add wave -noupdate /tb_spec/p_wr_req
add wave -noupdate /tb_spec/p_wr_rdy
add wave -noupdate /tb_spec/rx_error
add wave -noupdate /tb_spec/vc_rdy
add wave -noupdate -divider IRQ
add wave -noupdate -radix hexadecimal /tb_spec/gpio
add wave -noupdate -divider {Wishbone DMA Interface}
add wave -noupdate /tb_spec/u1/sys_clk_125
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_dma_adr
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_dma_dat_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_dma_dat_o
add wave -noupdate /tb_spec/u1/wb_dma_sel
add wave -noupdate /tb_spec/u1/wb_dma_cyc
add wave -noupdate /tb_spec/u1/wb_dma_stb
add wave -noupdate /tb_spec/u1/wb_dma_we
add wave -noupdate /tb_spec/u1/wb_dma_ack
add wave -noupdate /tb_spec/u1/wb_dma_stall
add wave -noupdate -divider {Wishbone ADC to DDR}
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_ddr_adr
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_ddr_dat_o
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_ddr_sel
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_ddr_cyc
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_ddr_stb
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_ddr_we
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_ddr_ack
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_ddr_stall
add wave -noupdate -divider {Wishbone CSR master}
add wave -noupdate /tb_spec/u1/cnx_master_out
add wave -noupdate /tb_spec/u1/cnx_master_in
add wave -noupdate -divider {Wishbone CSR slaves}
add wave -noupdate -radix hexadecimal /tb_spec/u1/sys_clk_125
add wave -noupdate /tb_spec/u1/cnx_slave_out
add wave -noupdate /tb_spec/u1/cnx_slave_in
add wave -noupdate -divider IOs
add wave -noupdate /tb_spec/led_red
add wave -noupdate /tb_spec/led_green
add wave -noupdate -divider {FMC SPI}
add wave -noupdate /tb_spec/spi_din_i
add wave -noupdate /tb_spec/spi_dout_o
add wave -noupdate /tb_spec/spi_sck_o
add wave -noupdate /tb_spec/spi_cs_adc_n_o
add wave -noupdate /tb_spec/spi_cs_dac1_n_o
add wave -noupdate /tb_spec/spi_cs_dac2_n_o
add wave -noupdate /tb_spec/spi_cs_dac3_n_o
add wave -noupdate /tb_spec/spi_cs_dac4_n_o
add wave -noupdate -divider {FMC I2C}
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_mezzanine_0/cmp_fmc_sys_i2c/scl_pad_i
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_mezzanine_0/cmp_fmc_sys_i2c/scl_pad_o
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_mezzanine_0/cmp_fmc_sys_i2c/scl_padoen_o
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_mezzanine_0/cmp_fmc_sys_i2c/sda_pad_i
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_mezzanine_0/cmp_fmc_sys_i2c/sda_pad_o
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_mezzanine_0/cmp_fmc_sys_i2c/sda_padoen_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13971949 ps} 0}
configure wave -namecolwidth 464
configure wave -valuecolwidth 120
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {13728696 ps} {14811510 ps}
