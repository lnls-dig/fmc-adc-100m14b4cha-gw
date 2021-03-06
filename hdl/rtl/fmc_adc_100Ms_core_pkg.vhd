-------------------------------------------------------------------------------
-- Title      : FMC ADC 100Ms/s core package
-- Project    : FMC ADC 100M 14B 4CHA gateware
-- URL        : http://www.ohwr.org/projects/fmc-adc-100m14b4cha-gw
-------------------------------------------------------------------------------
-- File       : fmc_adc_100Ms_core_pkg.vhd
-- Author(s)  : Matthieu Cattin <matthieu.cattin@cern.ch>
--              Theodor Stana <t.stana@cern.ch>
--              Dimitrios Lampridis  <dimitrios.lampridis@cern.ch>
-- Company    : CERN (BE-CO-HT)
-- Created    : 2012-11-16
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Package for FMC ADC 100Ms/s core.
-------------------------------------------------------------------------------
-- Copyright (c) 2011-2018 CERN (BE-CO-HT)
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
-- Revisions  :
-- Date        Version  Author
-- 2012-11-16  1.0      Matthieu Cattin
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.timetag_core_defs_pkg.all;
use work.wishbone_pkg.all;

package fmc_adc_100Ms_core_pkg is

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------


  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------
  component fmc_adc_100Ms_core
    generic (
      g_MULTISHOT_RAM_SIZE : natural                        := 2048;
      -- Only used on Xilinx 7-series
      g_7SERIES_SERIAL_CLK_BUF   : string                   := "BUFIO";
      -- Buffer type for serial clock. Options are : BUFG, BUFH and BUFR
      g_7SERIES_PARALLEL_CLK_BUF : string                   := "BUFR";
      -- Only used on Xilinx Spartan6 FPGAs
      g_SPARTAN6_USE_PLL   : boolean                        := TRUE;
      -- External trigger delay calibration value
      g_TRIG_DELAY_EXT     : natural                        := 7;
      -- Software and time trigger delay calibration value
      g_TRIG_DELAY_SW      : natural                        := 9;
      -- WB interface configuration
      g_WB_CSR_MODE        : t_wishbone_interface_mode      := PIPELINED;
      g_WB_CSR_GRANULARITY : t_wishbone_address_granularity := BYTE);
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

      -- ADC data aligned with trigger, synch'ed with fs_clk
      fs_clk_o   : out std_logic;
      fs_rst_n_o : out std_logic;

      adc_data_ch3_o   : out std_logic_vector(15 downto 0);
      adc_data_ch2_o   : out std_logic_vector(15 downto 0);
      adc_data_ch1_o   : out std_logic_vector(15 downto 0);
      adc_data_ch0_o   : out std_logic_vector(15 downto 0);
      adc_data_valid_o : out std_logic;

      adc_sw_trigger_o       : out std_logic;
      adc_ext_trigger_o      : out std_logic;
      adc_aux_time_trigger_o : out std_logic;
      adc_time_trigger_o     : out std_logic;
      adc_int4_trigger_o     : out std_logic;
      adc_int3_trigger_o     : out std_logic;
      adc_int2_trigger_o     : out std_logic;
      adc_int1_trigger_o     : out std_logic;
      adc_pulse_trigger_o    : out std_logic;

      -- ADC data aligned with trigger, synch'ed with sys_clk
      adc_data_ch3_sys_clk_o   : out std_logic_vector(15 downto 0);
      adc_data_ch2_sys_clk_o   : out std_logic_vector(15 downto 0);
      adc_data_ch1_sys_clk_o   : out std_logic_vector(15 downto 0);
      adc_data_ch0_sys_clk_o   : out std_logic_vector(15 downto 0);
      adc_data_valid_sys_clk_o : out std_logic;

      adc_sw_trigger_sys_clk_o       : out std_logic;
      adc_ext_trigger_sys_clk_o      : out std_logic;
      adc_aux_time_trigger_sys_clk_o : out std_logic;
      adc_time_trigger_sys_clk_o     : out std_logic;
      adc_int4_trigger_sys_clk_o     : out std_logic;
      adc_int3_trigger_sys_clk_o     : out std_logic;
      adc_int2_trigger_sys_clk_o     : out std_logic;
      adc_int1_trigger_sys_clk_o     : out std_logic;
      adc_pulse_trigger_sys_clk_o    : out std_logic;

      -- Acquisition configuration status flag
      acq_cfg_ok_o : out std_logic;

      -- Trigout wishbone interface
      wb_trigout_slave_i : in  t_wishbone_slave_in;
      wb_trigout_slave_o : out t_wishbone_slave_out;

      -- Events output pulses
      trigger_p_o   : out std_logic;
      acq_start_p_o : out std_logic;
      acq_stop_p_o  : out std_logic;
      acq_end_p_o   : out std_logic;

      -- Trigger time-tag input
      trigger_tag_i   : in t_timetag;
      time_trig_i     : in std_logic;
      aux_time_trig_i : in std_logic;

      -- WR status (for trigout).
      wr_tm_link_up_i    : in std_logic;
      wr_tm_time_valid_i : in std_logic;
      wr_enable_i        : in std_logic;

      -- FMC interface
      ext_trigger_p_i : in std_logic;             -- External trigger
      ext_trigger_n_i : in std_logic;

      adc_dco_p_i  : in std_logic;                     -- ADC data clock
      adc_dco_n_i  : in std_logic;
      adc_fr_p_i   : in std_logic;                     -- ADC frame start
      adc_fr_n_i   : in std_logic;
      adc_outa_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (odd bits)
      adc_outa_n_i : in std_logic_vector(3 downto 0);
      adc_outb_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (even bits)
      adc_outb_n_i : in std_logic_vector(3 downto 0);

      gpio_dac_clr_n_o : out std_logic;           -- offset DACs clear (active low)
      gpio_led_acq_o   : out std_logic;           -- Mezzanine front panel power LED (PWR)
      gpio_led_trig_o  : out std_logic;           -- Mezzanine front panel trigger LED (TRIG)
      gpio_ssr_ch1_o   : out std_logic_vector(6 downto 0);  -- Channel 1 solid state relays control
      gpio_ssr_ch2_o   : out std_logic_vector(6 downto 0);  -- Channel 2 solid state relays control
      gpio_ssr_ch3_o   : out std_logic_vector(6 downto 0);  -- Channel 3 solid state relays control
      gpio_ssr_ch4_o   : out std_logic_vector(6 downto 0);  -- Channel 4 solid state relays control
      gpio_si570_oe_o  : out std_logic);          -- Si570 (programmable oscillator) output enable

  end component fmc_adc_100Ms_core;

end fmc_adc_100Ms_core_pkg;
