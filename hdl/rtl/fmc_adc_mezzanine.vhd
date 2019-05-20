-------------------------------------------------------------------------------
-- Title      : FMC ADC mezzanine
-- Project    : FMC ADC 100M 14B 4CHA gateware
-- URL        : http://www.ohwr.org/projects/fmc-adc-100m14b4cha-gw
-------------------------------------------------------------------------------
-- File       : fmc_adc_mezzanine.vhd
-- Company    : CERN (BE-CO-HT)
-- Created    : 2013-05-07
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: The FMC ADC mezzanine is wrapper around the fmc-adc-100ms core
-- and the other wishbone slaves connected to a FMC ADC mezzanine.
-------------------------------------------------------------------------------
-- Copyright (c) 2013-2018 CERN (BE-CO-HT)
-------------------------------------------------------------------------------
-- GNU LESSER GENERAL PUBLIC LICENSE
-------------------------------------------------------------------------------
-- This source file is free software; you can redistribute it and/or modify it
-- under the terms of the GNU Lesser General Public License as published by the
-- Free Software Foundation; either version 2.1 of the License, or (at your
-- option) any later version. This source is distributed in the hope that it
-- will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
-- of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-- See the GNU Lesser General Public License for more details. You should have
-- received a copy of the GNU Lesser General Public License along with this
-- source; if not, download it from http://www.gnu.org/licenses/lgpl-2.1.html
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


library work;
use work.fmc_adc_100Ms_core_pkg.all;
use work.wishbone_pkg.all;
use work.timetag_core_pkg.all;


entity fmc_adc_mezzanine is
  generic (
    g_MULTISHOT_RAM_SIZE : natural := 2048;
    -- Only used on Xilinx Spartan6 FPGAs
    g_SPARTAN6_USE_PLL   : boolean                        := TRUE;
    g_WB_MODE            : t_wishbone_interface_mode      := PIPELINED;
    g_WB_GRANULARITY     : t_wishbone_address_granularity := BYTE);
  port (
    -- Clock, reset
    sys_clk_i   : in std_logic;
    sys_rst_n_i : in std_logic;

    -- CSR wishbone interface
    wb_csr_slave_i : in  t_wishbone_slave_in;
    wb_csr_slave_o : out t_wishbone_slave_out;

    -- DDR wishbone interface
    wb_ddr_clk_i    : in  std_logic;
    wb_ddr_rst_n_i  : in  std_logic;
    wb_ddr_master_i : in  t_wishbone_master_data64_in;
    wb_ddr_master_o : out t_wishbone_master_data64_out;

    -- Interrupts and status
    ddr_wr_fifo_empty_i : in  std_logic;
    trig_irq_o          : out std_logic;
    acq_end_irq_o       : out std_logic;
    eic_irq_o           : out std_logic;
    acq_cfg_ok_o        : out std_logic;

    -- Alternate trigger input wishbone interface
    wb_trigin_slave_i : in  t_wishbone_slave_in;
    wb_trigin_slave_o : out t_wishbone_slave_out;

    -- Trigout wishbone interface
    wb_trigout_slave_i : in  t_wishbone_slave_in;
    wb_trigout_slave_o : out t_wishbone_slave_out;

    -- FMC interface
    ext_trigger_p_i : in std_logic;               -- External trigger
    ext_trigger_n_i : in std_logic;

    adc_dco_p_i  : in std_logic;                     -- ADC data clock
    adc_dco_n_i  : in std_logic;
    adc_fr_p_i   : in std_logic;                     -- ADC frame start
    adc_fr_n_i   : in std_logic;
    adc_outa_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (odd bits)
    adc_outa_n_i : in std_logic_vector(3 downto 0);
    adc_outb_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (even bits)
    adc_outb_n_i : in std_logic_vector(3 downto 0);

    gpio_dac_clr_n_o : out std_logic;             -- offset DACs clear (active low)
    gpio_led_acq_o   : out std_logic;             -- Mezzanine front panel power LED (PWR)
    gpio_led_trig_o  : out std_logic;             -- Mezzanine front panel trigger LED (TRIG)
    gpio_ssr_ch1_o   : out std_logic_vector(6 downto 0);  -- Channel 1 solid state relays control
    gpio_ssr_ch2_o   : out std_logic_vector(6 downto 0);  -- Channel 2 solid state relays control
    gpio_ssr_ch3_o   : out std_logic_vector(6 downto 0);  -- Channel 3 solid state relays control
    gpio_ssr_ch4_o   : out std_logic_vector(6 downto 0);  -- Channel 4 solid state relays control
    gpio_si570_oe_o  : out std_logic;             -- Si570 (programmable oscillator) output enable

    spi_din_i       : in  std_logic;              -- SPI data from FMC
    spi_dout_o      : out std_logic;              -- SPI data to FMC
    spi_sck_o       : out std_logic;              -- SPI clock
    spi_cs_adc_n_o  : out std_logic;              -- SPI ADC chip select (active low)
    spi_cs_dac1_n_o : out std_logic;  -- SPI channel 1 offset DAC chip select (active low)
    spi_cs_dac2_n_o : out std_logic;  -- SPI channel 2 offset DAC chip select (active low)
    spi_cs_dac3_n_o : out std_logic;  -- SPI channel 3 offset DAC chip select (active low)
    spi_cs_dac4_n_o : out std_logic;  -- SPI channel 4 offset DAC chip select (active low)

    si570_scl_b : inout std_logic;                -- I2C bus clock (Si570)
    si570_sda_b : inout std_logic;                -- I2C bus data (Si570)

    mezz_one_wire_b : inout std_logic;  -- Mezzanine 1-wire interface (DS18B20 thermometer + unique ID)

    sys_scl_b : inout std_logic;                  -- Mezzanine system I2C clock (EEPROM)
    sys_sda_b : inout std_logic;                  -- Mezzanine system I2C data (EEPROM)

    wr_tm_link_up_i    : in std_logic;            -- WR link status bit
    wr_tm_time_valid_i : in std_logic;            -- WR timecode valid status bit
    wr_tm_tai_i        : in std_logic_vector(39 downto 0);  -- WR timecode seconds
    wr_tm_cycles_i     : in std_logic_vector(27 downto 0);  -- WR timecode 8ns ticks
    wr_enable_i        : in std_logic);           -- enable white rabbit features on mezzanine

end fmc_adc_mezzanine;

architecture rtl of fmc_adc_mezzanine is

  ------------------------------------------------------------------------------
  -- SDB crossbar constants declaration
  ------------------------------------------------------------------------------

  -- Number of masters on the wishbone crossbar
  constant c_NUM_WB_MASTERS : integer := 1;

  -- Number of slaves on the wishbone crossbar
  constant c_NUM_WB_SLAVES : integer := 7;

  -- Wishbone master(s)
  constant c_WB_MASTER : integer := 0;

  -- Wishbone slave(s)
  constant c_WB_SLAVE_FMC_ADC     : integer := 0;  -- Mezzanine ADC core
  constant c_WB_SLAVE_FMC_SYS_I2C : integer := 1;  -- Mezzanine system I2C interface (EEPROM)
  constant c_WB_SLAVE_FMC_EIC     : integer := 2;  -- Mezzanine interrupt controller
  constant c_WB_SLAVE_FMC_I2C     : integer := 3;  -- Mezzanine I2C controller
  constant c_WB_SLAVE_FMC_ONEWIRE : integer := 4;  -- Mezzanine onewire interface
  constant c_WB_SLAVE_FMC_SPI     : integer := 5;  -- Mezzanine SPI interface
  constant c_WB_SLAVE_TIMETAG     : integer := 6;  -- Mezzanine timetag core

  -- Devices sdb description
  constant c_wb_adc_csr_sdb : t_sdb_device := (
    abi_class     => x"0000",                     -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                        -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"00000000000003FF",
      product     => (
        vendor_id => x"000000000000CE42",         -- CERN
        device_id => x"00000608",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-FMC-ADC-Core    ")));

  constant c_wb_timetag_sdb : t_sdb_device := (
    abi_class     => x"0000",                     -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                        -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"000000000000007F",
      product     => (
        vendor_id => x"000000000000CE42",         -- CERN
        device_id => x"00000604",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-Timetag-Core    ")));

  constant c_wb_fmc_adc_eic_sdb : t_sdb_device := (
    abi_class     => x"0000",                     -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                        -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"000000000000000F",
      product     => (
        vendor_id => x"000000000000CE42",         -- CERN
        device_id => x"26ec6086",                 -- "WB-FMC-ADC.EIC     " | md5sum | cut -c1-8
        version   => x"00000001",
        date      => x"20131204",
        name      => "WB-FMC-ADC.EIC     ")));

  -- sdb header address
  constant c_SDB_ADDRESS : t_wishbone_address := x"00000000";

  -- Wishbone crossbar layout
  constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(c_NUM_WB_SLAVES - 1 downto 0) :=
    (
      c_WB_SLAVE_FMC_ADC     => f_sdb_embed_device(c_wb_adc_csr_sdb, x"00001000"),
      c_WB_SLAVE_FMC_SYS_I2C => f_sdb_embed_device(c_xwb_i2c_master_sdb, x"00001400"),
      c_WB_SLAVE_FMC_EIC     => f_sdb_embed_device(c_wb_fmc_adc_eic_sdb, x"00001500"),
      c_WB_SLAVE_FMC_I2C     => f_sdb_embed_device(c_xwb_i2c_master_sdb, x"00001600"),
      c_WB_SLAVE_FMC_ONEWIRE => f_sdb_embed_device(c_xwb_onewire_master_sdb, x"00001700"),
      c_WB_SLAVE_FMC_SPI     => f_sdb_embed_device(c_xwb_spi_sdb, x"00001800"),
      c_WB_SLAVE_TIMETAG     => f_sdb_embed_device(c_wb_timetag_sdb, x"00001900")
      );


  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------

  -- Wishbone buse(s) from master(s) to crossbar slave port(s)
  signal cnx_master_out : t_wishbone_master_out_array(c_NUM_WB_MASTERS-1 downto 0);
  signal cnx_master_in  : t_wishbone_master_in_array(c_NUM_WB_MASTERS-1 downto 0);

  -- Wishbone buse(s) from crossbar master port(s) to slave(s)
  signal cnx_slave_out : t_wishbone_slave_out_array(c_NUM_WB_SLAVES-1 downto 0);
  signal cnx_slave_in  : t_wishbone_slave_in_array(c_NUM_WB_SLAVES-1 downto 0);

  signal wb_csr_out : t_wishbone_slave_in;
  signal wb_csr_in  : t_wishbone_slave_out;

  -- Mezzanine system I2C for EEPROM
  signal sys_scl_in   : std_logic;
  signal sys_scl_out  : std_logic;
  signal sys_scl_oe_n : std_logic;
  signal sys_sda_in   : std_logic;
  signal sys_sda_out  : std_logic;
  signal sys_sda_oe_n : std_logic;

  -- Mezzanine SPI
  signal spi_din_t : std_logic_vector(3 downto 0) := (others => '0');
  signal spi_ss_t  : std_logic_vector(7 downto 0);

  -- Mezzanine I2C for Si570
  signal si570_scl_in   : std_logic;
  signal si570_scl_out  : std_logic;
  signal si570_scl_oe_n : std_logic;
  signal si570_sda_in   : std_logic;
  signal si570_sda_out  : std_logic;
  signal si570_sda_oe_n : std_logic;

  -- Mezzanine 1-wire
  signal mezz_owr_en : std_logic_vector(0 downto 0);
  signal mezz_owr_i  : std_logic_vector(0 downto 0);

  -- Interrupts (eic)
  signal ddr_wr_fifo_empty_d : std_logic;
  signal ddr_wr_fifo_empty_p : std_logic;
  signal acq_end_irq_p       : std_logic;
  signal acq_end_extend      : std_logic;

  -- Time-tagging core
  signal trigger_p    : std_logic;
  signal acq_start_p  : std_logic;
  signal acq_stop_p   : std_logic;
  signal acq_end_p    : std_logic;
  signal trigger_tag  : t_timetag;
  signal time_trigger : std_logic;

  -- Alternative time trigger
  signal alt_trigin_enable_in  : std_logic;
  signal alt_trigin_enable_out : std_logic;
  signal alt_trigin_enable_wr  : std_logic;
  signal alt_trigin_tag        : t_timetag;
  signal alt_time_trigger      : std_logic;
  signal alt_trigin_secs       : std_logic_vector(63 downto 0);
  signal alt_trigin_cycs       : std_logic_vector(31 downto 0);
begin

  ------------------------------------------------------------------------------
  -- Main wishbone crossbar for mezzanine
  ------------------------------------------------------------------------------

  cmp_fmc_wb_slave_adapter_in : wb_slave_adapter
    generic map (
      g_master_use_struct  => TRUE,
      g_master_mode        => CLASSIC,
      g_master_granularity => BYTE,
      g_slave_use_struct   => TRUE,
      g_slave_mode         => g_WB_MODE,
      g_slave_granularity  => g_WB_GRANULARITY)
    port map (
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,
      slave_i   => wb_csr_slave_i,
      slave_o   => wb_csr_slave_o,
      master_i  => wb_csr_in,
      master_o  => wb_csr_out);

  -- Additional register to help timing
  cmp_xwb_register : xwb_register
    generic map (
      g_WB_MODE  => CLASSIC)
    port map (
      rst_n_i  => sys_rst_n_i,
      clk_i    => sys_clk_i,
      slave_i  => wb_csr_out,
      slave_o  => wb_csr_in,
      master_i => cnx_master_in(c_WB_MASTER),
      master_o => cnx_master_out(c_WB_MASTER));

  cmp_sdb_crossbar : xwb_sdb_crossbar
    generic map (
      g_VERBOSE     => FALSE,
      g_num_masters => c_NUM_WB_MASTERS,
      g_num_slaves  => c_NUM_WB_SLAVES,
      g_registered  => TRUE,
      g_wraparound  => TRUE,
      g_layout      => c_INTERCONNECT_LAYOUT,
      g_sdb_wb_mode => PIPELINED,
      g_sdb_addr    => c_SDB_ADDRESS)
    port map (
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,
      slave_i   => cnx_master_out,
      slave_o   => cnx_master_in,
      master_i  => cnx_slave_out,
      master_o  => cnx_slave_in);

  ------------------------------------------------------------------------------
  -- Mezzanine system managment I2C master
  --    Access to mezzanine EEPROM
  ------------------------------------------------------------------------------
  cmp_fmc_sys_i2c : xwb_i2c_master
    generic map(
      g_interface_mode      => CLASSIC,
      g_address_granularity => BYTE
      )
    port map (
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,

      slave_i => cnx_slave_in(c_WB_SLAVE_FMC_SYS_I2C),
      slave_o => cnx_slave_out(c_WB_SLAVE_FMC_SYS_I2C),
      desc_o  => open,

      scl_pad_i(0)    => sys_scl_in,
      scl_pad_o(0)    => sys_scl_out,
      scl_padoen_o(0) => sys_scl_oe_n,
      sda_pad_i(0)    => sys_sda_in,
      sda_pad_o(0)    => sys_sda_out,
      sda_padoen_o(0) => sys_sda_oe_n
      );

  -- Tri-state buffer for SDA and SCL
  sys_scl_b  <= sys_scl_out when sys_scl_oe_n = '0' else 'Z';
  sys_scl_in <= sys_scl_b;

  sys_sda_b  <= sys_sda_out when sys_sda_oe_n = '0' else 'Z';
  sys_sda_in <= sys_sda_b;

  ------------------------------------------------------------------------------
  -- Mezzanine SPI master
  --    Offset DACs control
  --    ADC control
  ------------------------------------------------------------------------------
  cmp_fmc_spi : xwb_spi
    generic map(
      g_interface_mode      => CLASSIC,
      g_address_granularity => BYTE
      )
    port map (
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,

      slave_i => cnx_slave_in(c_WB_SLAVE_FMC_SPI),
      slave_o => cnx_slave_out(c_WB_SLAVE_FMC_SPI),
      desc_o  => open,

      pad_cs_o   => spi_ss_t,
      pad_sclk_o => spi_sck_o,
      pad_mosi_o => spi_dout_o,
      pad_miso_i => spi_din_t(spi_din_t'LEFT)
      );

  -- Assign slave select lines
  spi_cs_adc_n_o  <= spi_ss_t(0);
  spi_cs_dac1_n_o <= spi_ss_t(1);
  spi_cs_dac2_n_o <= spi_ss_t(2);
  spi_cs_dac3_n_o <= spi_ss_t(3);
  spi_cs_dac4_n_o <= spi_ss_t(4);

  -- Add some FF after the input pin to solve timing problem
  p_fmc_spi : process (sys_clk_i)
  begin
    if rising_edge(sys_clk_i) then
      spi_din_t <= spi_din_t(spi_din_t'LEFT-1 downto 0) & spi_din_i;
    end if;
  end process p_fmc_spi;

  ------------------------------------------------------------------------------
  -- Mezzanine I2C
  --    Si570 control
  --
  -- Note: I2C registers are 8-bit wide, but accessed as 32-bit registers
  ------------------------------------------------------------------------------
  cmp_fmc_i2c : xwb_i2c_master
    generic map(
      g_interface_mode      => CLASSIC,
      g_address_granularity => BYTE
      )
    port map (
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,

      slave_i => cnx_slave_in(c_WB_SLAVE_FMC_I2C),
      slave_o => cnx_slave_out(c_WB_SLAVE_FMC_I2C),
      desc_o  => open,

      scl_pad_i(0)    => si570_scl_in,
      scl_pad_o(0)    => si570_scl_out,
      scl_padoen_o(0) => si570_scl_oe_n,
      sda_pad_i(0)    => si570_sda_in,
      sda_pad_o(0)    => si570_sda_out,
      sda_padoen_o(0) => si570_sda_oe_n
      );

  -- Tri-state buffer for SDA and SCL
  si570_scl_b  <= si570_scl_out when si570_scl_oe_n = '0' else 'Z';
  si570_scl_in <= si570_scl_b;

  si570_sda_b  <= si570_sda_out when si570_sda_oe_n = '0' else 'Z';
  si570_sda_in <= si570_sda_b;

  ------------------------------------------------------------------------------
  -- ADC core
  --    Solid State Relays control
  --    Si570 output enable
  --    Offset DACs control (CLR_N)
  --    ADC core control and status
  ------------------------------------------------------------------------------
  cmp_fmc_adc_100Ms_core : fmc_adc_100Ms_core
    generic map (
      g_WB_CSR_MODE        => CLASSIC,
      g_WB_CSR_GRANULARITY => BYTE,
      g_SPARTAN6_USE_PLL   => g_SPARTAN6_USE_PLL,
      g_MULTISHOT_RAM_SIZE => g_MULTISHOT_RAM_SIZE
      )
    port map(
      sys_clk_i   => sys_clk_i,
      sys_rst_n_i => sys_rst_n_i,

      wb_csr_slave_i => cnx_slave_in(c_WB_SLAVE_FMC_ADC),
      wb_csr_slave_o => cnx_slave_out(c_WB_SLAVE_FMC_ADC),

      wb_ddr_clk_i    => wb_ddr_clk_i,
      wb_ddr_rst_n_i  => wb_ddr_rst_n_i,
      wb_ddr_master_o => wb_ddr_master_o,
      wb_ddr_master_i => wb_ddr_master_i,

      acq_cfg_ok_o => acq_cfg_ok_o,

      wb_trigout_slave_i => wb_trigout_slave_i,
      wb_trigout_slave_o => wb_trigout_slave_o,

      trigger_p_o   => trigger_p,
      acq_start_p_o => acq_start_p,
      acq_stop_p_o  => acq_stop_p,
      acq_end_p_o   => acq_end_p,

      trigger_tag_i   => trigger_tag,
      time_trig_i     => time_trigger,
      alt_time_trig_i => alt_time_trigger,

      wr_tm_link_up_i    => wr_tm_link_up_i,
      wr_tm_time_valid_i => wr_tm_time_valid_i,
      wr_enable_i        => wr_enable_i,

      ext_trigger_p_i => ext_trigger_p_i,
      ext_trigger_n_i => ext_trigger_n_i,

      adc_dco_p_i  => adc_dco_p_i,
      adc_dco_n_i  => adc_dco_n_i,
      adc_fr_p_i   => adc_fr_p_i,
      adc_fr_n_i   => adc_fr_n_i,
      adc_outa_p_i => adc_outa_p_i,
      adc_outa_n_i => adc_outa_n_i,
      adc_outb_p_i => adc_outb_p_i,
      adc_outb_n_i => adc_outb_n_i,

      gpio_dac_clr_n_o => gpio_dac_clr_n_o,
      gpio_led_acq_o   => gpio_led_acq_o,
      gpio_led_trig_o  => gpio_led_trig_o,
      gpio_ssr_ch1_o   => gpio_ssr_ch1_o,
      gpio_ssr_ch2_o   => gpio_ssr_ch2_o,
      gpio_ssr_ch3_o   => gpio_ssr_ch3_o,
      gpio_ssr_ch4_o   => gpio_ssr_ch4_o,
      gpio_si570_oe_o  => gpio_si570_oe_o
      );

  ------------------------------------------------------------------------------
  -- Mezzanine 1-wire master
  --    DS18B20 (thermometer + unique ID)
  ------------------------------------------------------------------------------

  cmp_fmc_onewire : xwb_onewire_master
    generic map(
      g_interface_mode      => CLASSIC,
      g_address_granularity => BYTE,
      g_num_ports           => 1,
      g_ow_btp_normal       => "5.0",
      g_ow_btp_overdrive    => "1.0"
      )
    port map(
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,

      slave_i => cnx_slave_in(c_WB_SLAVE_FMC_ONEWIRE),
      slave_o => cnx_slave_out(c_WB_SLAVE_FMC_ONEWIRE),
      desc_o  => open,

      owr_pwren_o => open,
      owr_en_o    => mezz_owr_en,
      owr_i       => mezz_owr_i
      );

  mezz_one_wire_b <= '0' when mezz_owr_en(0) = '1' else 'Z';
  mezz_owr_i(0)   <= mezz_one_wire_b;

  ------------------------------------------------------------------------------
  -- FMC0 interrupt controller
  ------------------------------------------------------------------------------
  cmp_fmc0_eic : entity work.fmc_adc_eic
    port map(
      rst_n_i       => sys_rst_n_i,
      clk_sys_i     => sys_clk_i,
      wb_adr_i      => cnx_slave_in(c_WB_SLAVE_FMC_EIC).adr(3 downto 2),  -- cnx_slave_in.adr is byte address
      wb_dat_i      => cnx_slave_in(c_WB_SLAVE_FMC_EIC).dat,
      wb_dat_o      => cnx_slave_out(c_WB_SLAVE_FMC_EIC).dat,
      wb_cyc_i      => cnx_slave_in(c_WB_SLAVE_FMC_EIC).cyc,
      wb_sel_i      => cnx_slave_in(c_WB_SLAVE_FMC_EIC).sel,
      wb_stb_i      => cnx_slave_in(c_WB_SLAVE_FMC_EIC).stb,
      wb_we_i       => cnx_slave_in(c_WB_SLAVE_FMC_EIC).we,
      wb_ack_o      => cnx_slave_out(c_WB_SLAVE_FMC_EIC).ack,
      wb_stall_o    => cnx_slave_out(c_WB_SLAVE_FMC_EIC).stall,
      wb_int_o      => eic_irq_o,
      irq_trig_i    => trigger_p,
      irq_acq_end_i => acq_end_irq_p
      );

  -- Unused wishbone signals
  cnx_slave_out(c_WB_SLAVE_FMC_EIC).err <= '0';
  cnx_slave_out(c_WB_SLAVE_FMC_EIC).rty <= '0';

  -- Detects end of adc core writing to ddr
  p_ddr_wr_fifo_empty : process (sys_clk_i)
  begin
    if rising_edge(sys_clk_i) then
      ddr_wr_fifo_empty_d <= ddr_wr_fifo_empty_i;
    end if;
  end process p_ddr_wr_fifo_empty;

  ddr_wr_fifo_empty_p <= ddr_wr_fifo_empty_i and not(ddr_wr_fifo_empty_d);

  -- End of acquisition interrupt generation
  p_acq_end_extend : process (sys_clk_i)
  begin
    if rising_edge(sys_clk_i) then
      if sys_rst_n_i = '0' then
        acq_end_extend <= '0';
      elsif acq_end_p = '1' then
        acq_end_extend <= '1';
      elsif ddr_wr_fifo_empty_p = '1' then
        acq_end_extend <= '0';
      end if;
    end if;
  end process p_acq_end_extend;

  acq_end_irq_p <= ddr_wr_fifo_empty_p and acq_end_extend;

  trig_irq_o    <= trigger_p;
  acq_end_irq_o <= acq_end_irq_p;

  ------------------------------------------------------------------------------
  -- Time-tagging core
  ------------------------------------------------------------------------------
  cmp_timetag_core : entity work.timetag_core
    generic map (
      -- Systematic delay introduced to the time tag by the FMC-ADC-100M core.
      -- Measured experimentally.
      g_TAG_ADJUST => 24)
    port map(
      clk_i   => sys_clk_i,
      rst_n_i => sys_rst_n_i,

      trigger_p_i   => trigger_p,
      acq_start_p_i => acq_start_p,
      acq_stop_p_i  => acq_stop_p,
      acq_end_p_i   => acq_end_p,

      wr_enabled_i => wr_enable_i,

      wr_tm_time_valid_i => wr_tm_time_valid_i,
      wr_tm_tai_i        => wr_tm_tai_i,
      wr_tm_cycles_i     => wr_tm_cycles_i,

      trig_tag_o  => trigger_tag,
      time_trig_o => time_trigger,

      alt_trigin_enable_o    => alt_trigin_enable_in,
      alt_trigin_enable_i    => alt_trigin_enable_out,
      alt_trigin_enable_wr_i => alt_trigin_enable_wr,
      alt_trigin_tag_i       => alt_trigin_tag,
      alt_trigin_o           => alt_time_trigger,

      wb_adr_i => cnx_slave_in(c_WB_SLAVE_TIMETAG).adr(6 downto 2),  -- cnx_slave_in.adr is byte address
      wb_dat_i => cnx_slave_in(c_WB_SLAVE_TIMETAG).dat,
      wb_dat_o => cnx_slave_out(c_WB_SLAVE_TIMETAG).dat,
      wb_cyc_i => cnx_slave_in(c_WB_SLAVE_TIMETAG).cyc,
      wb_sel_i => cnx_slave_in(c_WB_SLAVE_TIMETAG).sel,
      wb_stb_i => cnx_slave_in(c_WB_SLAVE_TIMETAG).stb,
      wb_we_i  => cnx_slave_in(c_WB_SLAVE_TIMETAG).we,
      wb_ack_o => cnx_slave_out(c_WB_SLAVE_TIMETAG).ack
      );

  cmp_alt_trigin : entity work.alt_trigin
    port map (
      rst_n_i    => sys_rst_n_i,
      clk_i      => sys_clk_i,
      wb_i       => wb_trigin_slave_i,
      wb_o       => wb_trigin_slave_o,

      ctrl_enable_i  => alt_trigin_enable_in,
      ctrl_enable_o  => alt_trigin_enable_out,
      ctrl_wr_o      => alt_trigin_enable_wr,

      seconds_o      => alt_trigin_secs,
      cycles_o       => alt_trigin_cycs
      );

  alt_trigin_tag <= (seconds => alt_trigin_secs(39 downto 0),
                     coarse => alt_trigin_cycs(27 downto 0));

  -- Unused wishbone signals
  cnx_slave_out(c_WB_SLAVE_TIMETAG).err   <= '0';
  cnx_slave_out(c_WB_SLAVE_TIMETAG).rty   <= '0';
  cnx_slave_out(c_WB_SLAVE_TIMETAG).stall <= '0';

end rtl;
