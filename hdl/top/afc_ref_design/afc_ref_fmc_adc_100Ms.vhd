------------------------------------------------------------------------------
-- Title      : AFC design with Acquisition Core + Trigger Muxes + FMC-ADC-100M board
------------------------------------------------------------------------------
-- Author     : Lucas Maziero Russo
-- Company    : CNPEM LNLS-DIG
-- Created    : 2020-01-24
-- Platform   : FPGA-generic
-------------------------------------------------------------------------------
-- Description: AFC design with Acquisition Core + Trigger Muxes + FMC-ADC-100M board
-------------------------------------------------------------------------------
-- Copyright (c) 2020 CNPEM
-- Licensed under GNU Lesser General Public License (LGPL) v3.0
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2020-01-24  1.0      lucas.russo        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
-- Main Wishbone Definitions
use work.wishbone_pkg.all;
-- Custom Wishbone Modules
use work.ifc_wishbone_pkg.all;
-- Custom common cores
use work.ifc_common_pkg.all;
-- Trigger definitions
use work.trigger_common_pkg.all;
-- Trigger Modules
use work.trigger_pkg.all;
-- AFC definitions
use work.afc_base_pkg.all;
-- AFC Acq definitions
use work.afc_base_acq_pkg.all;
-- IP cores constants
use work.ipcores_pkg.all;
-- Meta Package
use work.synthesis_descriptor_pkg.all;
-- Data Acquisition core
use work.acq_core_pkg.all;
-- AXI cores
use work.pcie_cntr_axi_pkg.all;
-- FMC ADC 100M core
use work.fmc_adc_mezzanine_pkg.all;

entity afc_ref_fmc_adc_100Ms is
port (
  ---------------------------------------------------------------------------
  -- Clocking pins
  ---------------------------------------------------------------------------
  sys_clk_p_i                                : in std_logic;
  sys_clk_n_i                                : in std_logic;

  aux_clk_p_i                                : in std_logic;
  aux_clk_n_i                                : in std_logic;

  ---------------------------------------------------------------------------
  -- Reset Button
  ---------------------------------------------------------------------------
  sys_rst_button_n_i                         : in std_logic := '1';

  ---------------------------------------------------------------------------
  -- UART pins
  ---------------------------------------------------------------------------

  uart_rxd_i                                 : in  std_logic := '1';
  uart_txd_o                                 : out std_logic;

  ---------------------------------------------------------------------------
  -- Trigger pins
  ---------------------------------------------------------------------------
  trig_dir_o                                 : out   std_logic_vector(c_NUM_TRIG-1 downto 0);
  trig_b                                     : inout std_logic_vector(c_NUM_TRIG-1 downto 0);

  ---------------------------------------------------------------------------
  -- AFC Diagnostics
  ---------------------------------------------------------------------------

  diag_spi_cs_i                              : in std_logic := '0';
  diag_spi_si_i                              : in std_logic := '0';
  diag_spi_so_o                              : out std_logic;
  diag_spi_clk_i                             : in std_logic := '0';

  ---------------------------------------------------------------------------
  -- ADN4604ASVZ
  ---------------------------------------------------------------------------
  adn4604_vadj2_clk_updt_n_o                 : out std_logic;

  ---------------------------------------------------------------------------
  -- PCIe pins
  ---------------------------------------------------------------------------

  -- DDR3 memory pins
  ddr3_dq_b                                  : inout std_logic_vector(c_ddr_dq_width-1 downto 0);
  ddr3_dqs_p_b                               : inout std_logic_vector(c_ddr_dqs_width-1 downto 0);
  ddr3_dqs_n_b                               : inout std_logic_vector(c_ddr_dqs_width-1 downto 0);
  ddr3_addr_o                                : out   std_logic_vector(c_ddr_row_width-1 downto 0);
  ddr3_ba_o                                  : out   std_logic_vector(c_ddr_bank_width-1 downto 0);
  ddr3_cs_n_o                                : out   std_logic_vector(0 downto 0);
  ddr3_ras_n_o                               : out   std_logic;
  ddr3_cas_n_o                               : out   std_logic;
  ddr3_we_n_o                                : out   std_logic;
  ddr3_reset_n_o                             : out   std_logic;
  ddr3_ck_p_o                                : out   std_logic_vector(c_ddr_ck_width-1 downto 0);
  ddr3_ck_n_o                                : out   std_logic_vector(c_ddr_ck_width-1 downto 0);
  ddr3_cke_o                                 : out   std_logic_vector(c_ddr_cke_width-1 downto 0);
  ddr3_dm_o                                  : out   std_logic_vector(c_ddr_dm_width-1 downto 0);
  ddr3_odt_o                                 : out   std_logic_vector(c_ddr_odt_width-1 downto 0);

  -- PCIe transceivers
  pci_exp_rxp_i                              : in  std_logic_vector(c_pcielanes - 1 downto 0);
  pci_exp_rxn_i                              : in  std_logic_vector(c_pcielanes - 1 downto 0);
  pci_exp_txp_o                              : out std_logic_vector(c_pcielanes - 1 downto 0);
  pci_exp_txn_o                              : out std_logic_vector(c_pcielanes - 1 downto 0);

  -- PCI clock and reset signals
  pcie_clk_p_i                               : in std_logic;
  pcie_clk_n_i                               : in std_logic;

  ---------------------------------------------------------------------------
  -- User LEDs
  ---------------------------------------------------------------------------
  leds_o                                     : out std_logic_vector(2 downto 0);

  ---------------------------------------------------------------------------
  -- FMC interface
  ---------------------------------------------------------------------------

  board_i2c_scl_b                            : inout std_logic;
  board_i2c_sda_b                            : inout std_logic;

  ---------------------------------------------------------------------------
  -- Flash memory SPI interface
  ---------------------------------------------------------------------------
  --
  -- spi_sclk_o                              : out std_logic;
  -- spi_cs_n_o                              : out std_logic;
  -- spi_mosi_o                              : out std_logic;
  -- spi_miso_i                              : in  std_logic := '0'

  ---------------------------------------------------------------------------
  -- FMC slot 0 - FMC ADC 100Ms
  ---------------------------------------------------------------------------

  fmc0_adc_ext_trigger_p_i : in std_logic;        -- External trigger
  fmc0_adc_ext_trigger_n_i : in std_logic;

  fmc0_adc_dco_p_i  : in std_logic;                     -- ADC data clock
  fmc0_adc_dco_n_i  : in std_logic;
  fmc0_adc_fr_p_i   : in std_logic;                     -- ADC frame start
  fmc0_adc_fr_n_i   : in std_logic;
  fmc0_adc_outa_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (odd bits)
  fmc0_adc_outa_n_i : in std_logic_vector(3 downto 0);
  fmc0_adc_outb_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (even bits)
  fmc0_adc_outb_n_i : in std_logic_vector(3 downto 0);

  fmc0_adc_spi_din_i       : in  std_logic;       -- SPI data from FMC
  fmc0_adc_spi_dout_o      : out std_logic;       -- SPI data to FMC
  fmc0_adc_spi_sck_o       : out std_logic;       -- SPI clock
  fmc0_adc_spi_cs_adc_n_o  : out std_logic;       -- SPI ADC chip select (active low)
  fmc0_adc_spi_cs_dac1_n_o : out std_logic;  -- SPI channel 1 offset DAC chip select (active low)
  fmc0_adc_spi_cs_dac2_n_o : out std_logic;  -- SPI channel 2 offset DAC chip select (active low)
  fmc0_adc_spi_cs_dac3_n_o : out std_logic;  -- SPI channel 3 offset DAC chip select (active low)
  fmc0_adc_spi_cs_dac4_n_o : out std_logic;  -- SPI channel 4 offset DAC chip select (active low)

  fmc0_adc_gpio_dac_clr_n_o : out std_logic;      -- offset DACs clear (active low)
  fmc0_adc_gpio_led_acq_o   : out std_logic;      -- Mezzanine front panel power LED (PWR)
  fmc0_adc_gpio_led_trig_o  : out std_logic;      -- Mezzanine front panel trigger LED (TRIG)
  fmc0_adc_gpio_ssr_ch1_o   : out std_logic_vector(6 downto 0);  -- Channel 1 solid state relays control
  fmc0_adc_gpio_ssr_ch2_o   : out std_logic_vector(6 downto 0);  -- Channel 2 solid state relays control
  fmc0_adc_gpio_ssr_ch3_o   : out std_logic_vector(6 downto 0);  -- Channel 3 solid state relays control
  fmc0_adc_gpio_ssr_ch4_o   : out std_logic_vector(6 downto 0);  -- Channel 4 solid state relays control
  fmc0_adc_gpio_si570_oe_o  : out std_logic;      -- Si570 (programmable oscillator) output enable

  fmc0_adc_si570_scl_b : inout std_logic;         -- I2C bus clock (Si570)
  fmc0_adc_si570_sda_b : inout std_logic;         -- I2C bus data (Si570)

  fmc0_adc_one_wire_b : inout std_logic;  -- Mezzanine 1-wire interface (DS18B20 thermometer + unique ID)

  ---------------------------------------------------------------------------
  -- FMC slot 0 management
  ---------------------------------------------------------------------------

  -- fmc0_prsnt_m2c_n_i : in    std_logic;       -- Mezzanine present (active low)
  -- fmc0_scl_b         : inout std_logic;       -- Mezzanine system I2C clock (EEPROM)
  -- fmc0_sda_b         : inout std_logic        -- Mezzanine system I2C data (EEPROM)

  ---------------------------------------------------------------------------
  -- FMC slot 1 - FMC ADC 100Ms
  ---------------------------------------------------------------------------

  fmc1_adc_ext_trigger_p_i : in std_logic;        -- External trigger
  fmc1_adc_ext_trigger_n_i : in std_logic;

  fmc1_adc_dco_p_i  : in std_logic;                     -- ADC data clock
  fmc1_adc_dco_n_i  : in std_logic;
  fmc1_adc_fr_p_i   : in std_logic;                     -- ADC frame start
  fmc1_adc_fr_n_i   : in std_logic;
  fmc1_adc_outa_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (odd bits)
  fmc1_adc_outa_n_i : in std_logic_vector(3 downto 0);
  fmc1_adc_outb_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (even bits)
  fmc1_adc_outb_n_i : in std_logic_vector(3 downto 0);

  fmc1_adc_spi_din_i       : in  std_logic;       -- SPI data from FMC
  fmc1_adc_spi_dout_o      : out std_logic;       -- SPI data to FMC
  fmc1_adc_spi_sck_o       : out std_logic;       -- SPI clock
  fmc1_adc_spi_cs_adc_n_o  : out std_logic;       -- SPI ADC chip select (active low)
  fmc1_adc_spi_cs_dac1_n_o : out std_logic;  -- SPI channel 1 offset DAC chip select (active low)
  fmc1_adc_spi_cs_dac2_n_o : out std_logic;  -- SPI channel 2 offset DAC chip select (active low)
  fmc1_adc_spi_cs_dac3_n_o : out std_logic;  -- SPI channel 3 offset DAC chip select (active low)
  fmc1_adc_spi_cs_dac4_n_o : out std_logic;  -- SPI channel 4 offset DAC chip select (active low)

  fmc1_adc_gpio_dac_clr_n_o : out std_logic;      -- offset DACs clear (active low)
  fmc1_adc_gpio_led_acq_o   : out std_logic;      -- Mezzanine front panel power LED (PWR)
  fmc1_adc_gpio_led_trig_o  : out std_logic;      -- Mezzanine front panel trigger LED (TRIG)
  fmc1_adc_gpio_ssr_ch1_o   : out std_logic_vector(6 downto 0);  -- Channel 1 solid state relays control
  fmc1_adc_gpio_ssr_ch2_o   : out std_logic_vector(6 downto 0);  -- Channel 2 solid state relays control
  fmc1_adc_gpio_ssr_ch3_o   : out std_logic_vector(6 downto 0);  -- Channel 3 solid state relays control
  fmc1_adc_gpio_ssr_ch4_o   : out std_logic_vector(6 downto 0);  -- Channel 4 solid state relays control
  fmc1_adc_gpio_si570_oe_o  : out std_logic;      -- Si570 (programmable oscillator) output enable

  fmc1_adc_si570_scl_b : inout std_logic;         -- I2C bus clock (Si570)
  fmc1_adc_si570_sda_b : inout std_logic;         -- I2C bus data (Si570)

  fmc1_adc_one_wire_b : inout std_logic  -- Mezzanine 1-wire interface (DS18B20 thermometer + unique ID)

  ---------------------------------------------------------------------------
  -- FMC slot 0 management
  ---------------------------------------------------------------------------

  -- fmc1_prsnt_m2c_n_i : in    std_logic;       -- Mezzanine present (active low)
  -- fmc1_scl_b         : inout std_logic;       -- Mezzanine system I2C clock (EEPROM)
  -- fmc1_sda_b         : inout std_logic        -- Mezzanine system I2C data (EEPROM)
);
end entity afc_ref_fmc_adc_100Ms;

architecture top of afc_ref_fmc_adc_100Ms is

  -----------------------------------------------------------------------------
  -- General constants
  -----------------------------------------------------------------------------

  constant c_7SERIES_SERIAL_CLK_BUF          : string := "BUFIO";
  constant c_7SERIES_PARALLEL_CLK_BUF        : string := "BUFR";
  constant c_NUM_USER_IRQ                    : natural := 1;

  -- Wishbone
  constant c_num_fmc_adc_100m_cores          : natural := 2;

  -- Trigger core IDs
  constant c_fmc_adc_0_id                    : natural := 0;
  constant c_fmc_adc_1_id                    : natural := 1;

  constant c_slv_fmc_adc_100m_core_ids       : t_natural_array(c_num_fmc_adc_100m_cores-1 downto 0) :=
        f_gen_ramp(0, c_num_fmc_adc_100m_cores);

  -----------------------------------------------------------------------------
  -- FMC signals
  -----------------------------------------------------------------------------

  type t_fmc_logic_array is array (natural range <>) of std_logic;
  type t_fmc_data_array is array (natural range <>) of std_logic_vector(15 downto 0);

  signal fs_clk                              : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fs_rst_n                            : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);

  signal fmc_adc_data_ch3                    : t_fmc_data_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_data_ch2                    : t_fmc_data_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_data_ch1                    : t_fmc_data_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_data_ch0                    : t_fmc_data_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_data_valid                  : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);

  signal fmc_adc_sw_trigger                  : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_ext_trigger                 : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_aux_time_trigger            : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_time_trigger                : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_int4_trigger                : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_int3_trigger                : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_int2_trigger                : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_int1_trigger                : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_pulse_trigger               : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);

  signal fmc_adc_irq                         : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal fmc_adc_acq_cfg_ok                  : t_fmc_logic_array(c_num_fmc_adc_100m_cores-1 downto 0);

  -- Wishbone bus from user afc_base_acq to FMC mezzanine
  signal wb_fmc_master_out                   : t_wishbone_master_out_array(c_num_fmc_adc_100m_cores-1 downto 0);
  signal wb_fmc_master_in                    : t_wishbone_master_in_array(c_num_fmc_adc_100m_cores-1 downto 0);

  -----------------------------------------------------------------------------
  -- Acquisition signals
  -----------------------------------------------------------------------------

  constant c_acq_fifo_size                   : natural := 256;

  -- Number of acquisition cores. Same as the number of FMCs
  constant c_acq_num_cores                   : natural := c_num_fmc_adc_100m_cores;
  -- Acquisition core IDs
  constant c_acq_core_0_id                   : natural := 0;
  constant c_acq_core_1_id                   : natural := 1;

  -- Type of DDR3 core interface
  constant c_ddr_interface_type              : string := "AXIS";

  constant c_acq_addr_width                  : natural := c_ddr_addr_width;
  -- Post-Mortem Acq Cores dont need Multishot. So, set them to 0
  constant c_acq_multishot_ram_size          : t_property_value_array(c_acq_num_cores-1 downto 0) := (2048, 2048);
  constant c_acq_ddr_addr_res_width          : natural := 32;
  constant c_acq_ddr_addr_diff               : natural := c_acq_ddr_addr_res_width-c_ddr_addr_width;

  -- Number of channels per acquisition core
  constant c_acq_num_channels                : natural := 1; -- ADC for each FMC
  -- Acquisition channels IDs
  constant c_acq_adc_id                      : natural := 0;

  constant c_facq_params_adc                 : t_facq_chan_param := (
    width                                    => to_unsigned(64, c_acq_chan_cmplt_width_log2),
    num_atoms                                => to_unsigned(4, c_acq_num_atoms_width_log2),
    atom_width                               => to_unsigned(16, c_acq_atom_width_log2) -- 2^4 = 16-bit
  );

  constant c_facq_channels                   : t_facq_chan_param_array(c_acq_num_channels-1 downto 0) :=
  (
     c_acq_adc_id            => c_facq_params_adc
  );

  signal acq_chan_array                      : t_facq_chan_array2d(c_acq_num_cores-1 downto 0, c_acq_num_channels-1 downto 0);

  -- Acquisition clocks
  signal fs_clk_array                        : std_logic_vector(c_acq_num_cores-1 downto 0);
  signal fs_rst_n_array                      : std_logic_vector(c_acq_num_cores-1 downto 0);
  signal fs_ce_array                         : std_logic_vector(c_acq_num_cores-1 downto 0);

  -----------------------------------------------------------------------------
  -- Trigger signals
  -----------------------------------------------------------------------------

  constant c_trig_mux_num_cores              : natural  := 2;
  constant c_trig_mux_sync_edge              : string   := "positive";
  constant c_trig_mux_num_channels           : natural  := 10; -- Arbitrary for now
  constant c_trig_mux_intern_num             : positive := c_trig_mux_num_channels + c_acq_num_channels;
  constant c_trig_mux_rcv_intern_num         : positive := 2; -- 2 FMCs
  constant c_trig_mux_mux_num_cores          : natural  := c_acq_num_cores;
  constant c_trig_mux_out_resolver           : string   := "fanout";
  constant c_trig_mux_in_resolver            : string   := "or";
  constant c_trig_mux_with_input_sync        : boolean  := true;
  constant c_trig_mux_with_output_sync       : boolean  := true;

  -- Trigger RCV intern IDs
  constant c_trig_rcv_intern_chan_1_id       : natural := 0; -- Internal Channel 1
  constant c_trig_rcv_intern_chan_2_id       : natural := 1; -- Internal Channel 2

  -- Trigger core IDs
  constant c_trig_mux_0_id                   : natural := 0;
  constant c_trig_mux_1_id                   : natural := 1;

  signal trig_ref_clk                        : std_logic;
  signal trig_ref_rst_n                      : std_logic;

  signal trig_rcv_intern                     : t_trig_channel_array2d(c_trig_mux_num_cores-1 downto 0, c_trig_mux_rcv_intern_num-1 downto 0);
  signal trig_pulse_transm                   : t_trig_channel_array2d(c_trig_mux_num_cores-1 downto 0, c_trig_mux_intern_num-1 downto 0);
  signal trig_pulse_rcv                      : t_trig_channel_array2d(c_trig_mux_num_cores-1 downto 0, c_trig_mux_intern_num-1 downto 0);

  signal trig_fmc1_channel_1                 : t_trig_channel;
  signal trig_fmc1_channel_2                 : t_trig_channel;
  signal trig_fmc2_channel_1                 : t_trig_channel;
  signal trig_fmc2_channel_2                 : t_trig_channel;

  -----------------------------------------------------------------------------
  -- User Signals
  -----------------------------------------------------------------------------

  constant c_user_num_cores                  : natural := c_num_fmc_adc_100m_cores;

  constant c_user_sdb_record_array           : t_sdb_record_array(c_user_num_cores-1 downto 0) :=
  (
    c_fmc_adc_0_id           => f_sdb_auto_bridge(c_FMC_100M_BRIDGE_SDB,        true),               -- FMC 100M Core 0
    c_fmc_adc_1_id           => f_sdb_auto_bridge(c_FMC_100M_BRIDGE_SDB,        true)                -- FMC 100M Core 1
  );

  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------

  signal clk_sys                             : std_logic;
  signal clk_sys_rstn                        : std_logic;
  signal clk_sys_rst                         : std_logic;
  signal clk_aux                             : std_logic;
  signal clk_aux_rstn                        : std_logic;
  signal clk_200mhz                          : std_logic;
  signal clk_200mhz_rstn                     : std_logic;
  signal clk_pcie                            : std_logic;
  signal clk_pcie_rstn                       : std_logic;
  signal clk_trig_ref                        : std_logic;
  signal clk_trig_ref_rstn                   : std_logic;

  signal pcb_rev_id                          : std_logic_vector(3 downto 0);

  signal irq_user                            : std_logic_vector(c_NUM_USER_IRQ + 5 downto 6) := (others => '0');

  signal trig_out                            : t_trig_channel_array(c_NUM_TRIG-1 downto 0);
  signal trig_in                             : t_trig_channel_array(c_NUM_TRIG-1 downto 0) := (others => c_trig_channel_dummy);

  signal trig_dbg                            : std_logic_vector(c_NUM_TRIG-1 downto 0);
  signal trig_dbg_data_sync                  : std_logic_vector(c_NUM_TRIG-1 downto 0);
  signal trig_dbg_data_degliteched           : std_logic_vector(c_NUM_TRIG-1 downto 0);

  signal user_wb_out                         : t_wishbone_master_out_array(c_user_num_cores-1 downto 0);
  signal user_wb_in                          : t_wishbone_master_in_array(c_user_num_cores-1 downto 0) := (others => c_DUMMY_WB_MASTER_IN);

begin

  cmp_afc_base_acq : afc_base_acq
    generic map (
      g_DIVCLK_DIVIDE                          => 1,
      g_CLKBOUT_MULT_F                         => 8,
      g_CLK0_DIVIDE_F                          => 8, -- Can be anything > 100MHz in th ecase of the FMC-ADC-100M
      g_CLK1_DIVIDE                            => 5, -- Must be 200 MHz
      --  If true, instantiate a VIC/UART/DIAG/SPI.
      g_WITH_VIC                               => true,
      g_WITH_UART_MASTER                       => true,
      g_WITH_DIAG                              => true,
      g_WITH_TRIGGER                           => true,
      g_WITH_SPI                               => false,
      g_WITH_BOARD_I2C                         => true,
      g_ACQ_NUM_CORES                          => c_acq_num_cores,
      g_TRIG_MUX_NUM_CORES                     => c_trig_mux_num_cores,
      g_USER_NUM_CORES                         => c_user_num_cores,
      -- Acquisition module generics
      g_ACQ_NUM_CHANNELS                       => c_acq_num_channels,
      g_ACQ_MULTISHOT_RAM_SIZE                 => c_acq_multishot_ram_size,
      g_ACQ_FIFO_FC_SIZE                       => c_acq_fifo_size,
      g_FACQ_CHANNELS                          => c_facq_channels,
      -- Trigger Mux generic
      g_TRIG_MUX_SYNC_EDGE                     => c_trig_mux_sync_edge,
      g_TRIG_MUX_INTERN_NUM                    => c_trig_mux_intern_num,
      g_TRIG_MUX_RCV_INTERN_NUM                => c_trig_mux_rcv_intern_num,
      g_TRIG_MUX_OUT_RESOLVER                  => c_trig_mux_out_resolver,
      g_TRIG_MUX_IN_RESOLVER                   => c_trig_mux_in_resolver,
      g_TRIG_MUX_WITH_INPUT_SYNC               => c_trig_mux_with_input_sync,
      g_TRIG_MUX_WITH_OUTPUT_SYNC              => c_trig_mux_with_output_sync,
      -- User generic. Must be g_USER_NUM_CORES length
      g_USER_SDB_RECORD_ARRAY                  => c_user_sdb_record_array,
      -- Auxiliary clock used to sync incoming triggers in the trigger module.
      -- If false, trigger will be synch'ed with clk_sys
      g_WITH_AUX_CLK                           => true,
      -- Number of user interrupts
      g_NUM_USER_IRQ                           => c_NUM_USER_IRQ
    )
    port map (
      ---------------------------------------------------------------------------
      -- Clocking pins
      ---------------------------------------------------------------------------
      sys_clk_p_i                              => sys_clk_p_i,
      sys_clk_n_i                              => sys_clk_n_i,

      aux_clk_p_i                              => aux_clk_p_i,
      aux_clk_n_i                              => aux_clk_n_i,

      ---------------------------------------------------------------------------
      -- Reset Button
      ---------------------------------------------------------------------------
      sys_rst_button_n_i                       => sys_rst_button_n_i,

      ---------------------------------------------------------------------------
      -- UART pins
      ---------------------------------------------------------------------------

      uart_rxd_i                               => uart_rxd_i,
      uart_txd_o                               => uart_txd_o,

      ---------------------------------------------------------------------------
      -- Trigger pins
      ---------------------------------------------------------------------------
      trig_dir_o                               => trig_dir_o,
      trig_b                                   => trig_b,

      ---------------------------------------------------------------------------
      -- AFC Diagnostics
      ---------------------------------------------------------------------------

      diag_spi_cs_i                            => diag_spi_cs_i,
      diag_spi_si_i                            => diag_spi_si_i,
      diag_spi_so_o                            => diag_spi_so_o,
      diag_spi_clk_i                           => diag_spi_clk_i,

      ---------------------------------------------------------------------------
      -- ADN4604ASVZ
      ---------------------------------------------------------------------------
      adn4604_vadj2_clk_updt_n_o               => adn4604_vadj2_clk_updt_n_o,

      ---------------------------------------------------------------------------
      -- PCIe pins
      ---------------------------------------------------------------------------

      -- DDR3 memory pins
      ddr3_dq_b                                => ddr3_dq_b,
      ddr3_dqs_p_b                             => ddr3_dqs_p_b,
      ddr3_dqs_n_b                             => ddr3_dqs_n_b,
      ddr3_addr_o                              => ddr3_addr_o,
      ddr3_ba_o                                => ddr3_ba_o,
      ddr3_cs_n_o                              => ddr3_cs_n_o,
      ddr3_ras_n_o                             => ddr3_ras_n_o,
      ddr3_cas_n_o                             => ddr3_cas_n_o,
      ddr3_we_n_o                              => ddr3_we_n_o,
      ddr3_reset_n_o                           => ddr3_reset_n_o,
      ddr3_ck_p_o                              => ddr3_ck_p_o,
      ddr3_ck_n_o                              => ddr3_ck_n_o,
      ddr3_cke_o                               => ddr3_cke_o,
      ddr3_dm_o                                => ddr3_dm_o,
      ddr3_odt_o                               => ddr3_odt_o,

      -- PCIe transceivers
      pci_exp_rxp_i                            => pci_exp_rxp_i,
      pci_exp_rxn_i                            => pci_exp_rxn_i,
      pci_exp_txp_o                            => pci_exp_txp_o,
      pci_exp_txn_o                            => pci_exp_txn_o,

      -- PCI clock and reset signals
      pcie_clk_p_i                             => pcie_clk_p_i,
      pcie_clk_n_i                             => pcie_clk_n_i,

      ---------------------------------------------------------------------------
      -- User LEDs
      ---------------------------------------------------------------------------
      leds_o                                   => leds_o,

      ---------------------------------------------------------------------------
      -- FMC interface
      ---------------------------------------------------------------------------

      board_i2c_scl_b                          => board_i2c_scl_b,
      board_i2c_sda_b                          => board_i2c_sda_b,

      ---------------------------------------------------------------------------
      -- Flash memory SPI interface
      ---------------------------------------------------------------------------
     --
     -- spi_sclk_o                               => spi_sclk_o,
     -- spi_cs_n_o                               => spi_cs_n_o,
     -- spi_mosi_o                               => spi_mosi_o,
     -- spi_miso_i                               => spi_miso_i,
     --
      ---------------------------------------------------------------------------
      -- Miscellanous AFC pins
      ---------------------------------------------------------------------------

      -- PCB version
      pcb_rev_id_i                             => pcb_rev_id,

      ---------------------------------------------------------------------------
      --  User part
      ---------------------------------------------------------------------------

      --  Clocks and reset.
      clk_sys_o                                => clk_sys,
      rst_sys_n_o                              => clk_sys_rstn,

      clk_aux_o                                => clk_aux,
      rst_aux_n_o                              => clk_aux_rstn,

      clk_200mhz_o                             => clk_200mhz,
      rst_200mhz_n_o                           => clk_200mhz_rstn,

      clk_pcie_o                               => clk_pcie,
      rst_pcie_n_o                             => clk_pcie_rstn,

      clk_trig_ref_o                           => clk_trig_ref,
      rst_trig_ref_n_o                         => clk_trig_ref_rstn,

      --  Interrupts
      irq_user_i                               => irq_user,

      -- Acquisition
      fs_clk_array_i                           => fs_clk_array,
      fs_ce_array_i                            => fs_ce_array,
      fs_rst_n_array_i                         => fs_rst_n_array,

      acq_chan_array_i                         => acq_chan_array,

      -- Triggers                                 -- Triggers
      trig_rcv_intern_i                        => trig_rcv_intern,
      trig_pulse_transm_i                      => trig_pulse_transm,
      trig_pulse_rcv_o                         => trig_pulse_rcv,

      trig_dbg_o                               => trig_dbg,
      trig_dbg_data_sync_o                     => trig_dbg_data_sync,
      trig_dbg_data_degliteched_o              => trig_dbg_data_degliteched,

      --  The wishbone bus from the pcie/host to the application
      --  LSB addresses are not available (used by the carrier).
      --  For the exact used addresses see SDB Description.
      --  This is a pipelined wishbone with byte granularity.
      user_wb_o                                 => user_wb_out,
      user_wb_i                                 => user_wb_in
    );

  pcb_rev_id <= (others => '0');

  gen_wishbone_fmc_adc_100m_idx : for i in 0 to c_num_fmc_adc_100m_cores-1 generate

    wb_fmc_master_out(i) <= user_wb_out(c_slv_fmc_adc_100m_core_ids(i));
    user_wb_in(c_slv_fmc_adc_100m_core_ids(i)) <= wb_fmc_master_in(i);

  end generate;

  ----------------------------------------------------------------------
  --                     IDELAYCTRL for FMC ADCs                      --
  ----------------------------------------------------------------------

  cmp_idelayctrl : idelayctrl
  port map(
    rst                                     => clk_sys_rst,
    refclk                                  => clk_200mhz,
    rdy                                     => open
  );

  clk_sys_rst <= not clk_sys_rstn;

  ----------------------------------------------------------------------
  --                          FMC 0 ADC 100Ms                         --
  ----------------------------------------------------------------------

  cmp_fmc_adc_0_mezzanine : fmc_adc_mezzanine
  generic map (
    -- We are not using the Acquisition engine from fmc_adc_mezzanine
    g_MULTISHOT_RAM_SIZE                   => 0,
    g_7SERIES_SERIAL_CLK_BUF               => c_7SERIES_SERIAL_CLK_BUF,
    g_7SERIES_PARALLEL_CLK_BUF             => c_7SERIES_PARALLEL_CLK_BUF,
    g_SPARTAN6_USE_PLL                     => FALSE,
    g_WITH_SDB_CROSSBAR                    => TRUE,
    g_WB_MODE                              => PIPELINED,
    g_WB_GRANULARITY                       => BYTE
  )
  port map (
    sys_clk_i                              => clk_sys,
    sys_rst_n_i                            => clk_sys_rstn,

    wb_csr_slave_i                         => wb_fmc_master_out(c_fmc_adc_0_id),
    wb_csr_slave_o                         => wb_fmc_master_in(c_fmc_adc_0_id),

    wb_ddr_clk_i                           => '0',
    wb_ddr_rst_n_i                         => '0',
    wb_ddr_master_i                        => c_DUMMY_WB_MASTER_D64_IN,
    wb_ddr_master_o                        => open,

    fs_clk_o                               => fs_clk(c_fmc_adc_0_id),
    fs_rst_n_o                             => fs_rst_n(c_fmc_adc_0_id),

    adc_data_ch3_o                         => open,
    adc_data_ch2_o                         => open,
    adc_data_ch1_o                         => open,
    adc_data_ch0_o                         => open,

    adc_sw_trigger_o                       => open,
    adc_ext_trigger_o                      => open,
    adc_aux_time_trigger_o                 => open,
    adc_time_trigger_o                     => open,
    adc_int4_trigger_o                     => open,
    adc_int3_trigger_o                     => open,
    adc_int2_trigger_o                     => open,
    adc_int1_trigger_o                     => open,
    adc_pulse_trigger_o                    => open,

    adc_data_ch3_sys_clk_o                 => fmc_adc_data_ch3(c_fmc_adc_0_id),
    adc_data_ch2_sys_clk_o                 => fmc_adc_data_ch2(c_fmc_adc_0_id),
    adc_data_ch1_sys_clk_o                 => fmc_adc_data_ch1(c_fmc_adc_0_id),
    adc_data_ch0_sys_clk_o                 => fmc_adc_data_ch0(c_fmc_adc_0_id),
    adc_data_valid_sys_clk_o               => fmc_adc_data_valid(c_fmc_adc_0_id),

    adc_sw_trigger_sys_clk_o               => fmc_adc_sw_trigger(c_fmc_adc_0_id),
    adc_ext_trigger_sys_clk_o              => fmc_adc_ext_trigger(c_fmc_adc_0_id),
    adc_aux_time_trigger_sys_clk_o         => fmc_adc_aux_time_trigger(c_fmc_adc_0_id),
    adc_time_trigger_sys_clk_o             => fmc_adc_time_trigger(c_fmc_adc_0_id),
    adc_int4_trigger_sys_clk_o             => fmc_adc_int4_trigger(c_fmc_adc_0_id),
    adc_int3_trigger_sys_clk_o             => fmc_adc_int3_trigger(c_fmc_adc_0_id),
    adc_int2_trigger_sys_clk_o             => fmc_adc_int2_trigger(c_fmc_adc_0_id),
    adc_int1_trigger_sys_clk_o             => fmc_adc_int1_trigger(c_fmc_adc_0_id),
    adc_pulse_trigger_sys_clk_o            => fmc_adc_pulse_trigger(c_fmc_adc_0_id),

    ddr_wr_fifo_empty_i                    => '1',
    trig_irq_o                             => open,
    acq_end_irq_o                          => open,
    eic_irq_o                              => fmc_adc_irq(c_fmc_adc_0_id),
    acq_cfg_ok_o                           => fmc_adc_acq_cfg_ok(c_fmc_adc_0_id),

    ext_trigger_p_i                        => fmc0_adc_ext_trigger_p_i,
    ext_trigger_n_i                        => fmc0_adc_ext_trigger_n_i,

    adc_dco_p_i                            => fmc0_adc_dco_p_i,
    adc_dco_n_i                            => fmc0_adc_dco_n_i,
    adc_fr_p_i                             => fmc0_adc_fr_p_i,
    adc_fr_n_i                             => fmc0_adc_fr_n_i,
    adc_outa_p_i                           => fmc0_adc_outa_p_i,
    adc_outa_n_i                           => fmc0_adc_outa_n_i,
    adc_outb_p_i                           => fmc0_adc_outb_p_i,
    adc_outb_n_i                           => fmc0_adc_outb_n_i,

    gpio_dac_clr_n_o                       => fmc0_adc_gpio_dac_clr_n_o,
    gpio_led_acq_o                         => fmc0_adc_gpio_led_acq_o,
    gpio_led_trig_o                        => fmc0_adc_gpio_led_trig_o,
    gpio_ssr_ch1_o                         => fmc0_adc_gpio_ssr_ch1_o,
    gpio_ssr_ch2_o                         => fmc0_adc_gpio_ssr_ch2_o,
    gpio_ssr_ch3_o                         => fmc0_adc_gpio_ssr_ch3_o,
    gpio_ssr_ch4_o                         => fmc0_adc_gpio_ssr_ch4_o,
    gpio_si570_oe_o                        => fmc0_adc_gpio_si570_oe_o,

    spi_din_i                              => fmc0_adc_spi_din_i,
    spi_dout_o                             => fmc0_adc_spi_dout_o,
    spi_sck_o                              => fmc0_adc_spi_sck_o,
    spi_cs_adc_n_o                         => fmc0_adc_spi_cs_adc_n_o,
    spi_cs_dac1_n_o                        => fmc0_adc_spi_cs_dac1_n_o,
    spi_cs_dac2_n_o                        => fmc0_adc_spi_cs_dac2_n_o,
    spi_cs_dac3_n_o                        => fmc0_adc_spi_cs_dac3_n_o,
    spi_cs_dac4_n_o                        => fmc0_adc_spi_cs_dac4_n_o,

    si570_scl_b                            => fmc0_adc_si570_scl_b,
    si570_sda_b                            => fmc0_adc_si570_sda_b,

    mezz_one_wire_b                        => fmc0_adc_one_wire_b,

    wr_tm_link_up_i                        => '0',
    wr_tm_time_valid_i                     => '0',
    wr_tm_tai_i                            => (others => '0'),
    wr_tm_cycles_i                         => (others => '0'),
    wr_enable_i                            => '0'
  );

  ----------------------------------------------------------------------
  --                          FMC 1 ADC 100Ms                         --
  ----------------------------------------------------------------------

  cmp_fmc_adc_1_mezzanine : fmc_adc_mezzanine
  generic map (
    -- We are not using the Acquisition engine from fmc_adc_mezzanine
    g_MULTISHOT_RAM_SIZE                   => 0,
    g_7SERIES_SERIAL_CLK_BUF               => c_7SERIES_SERIAL_CLK_BUF,
    g_7SERIES_PARALLEL_CLK_BUF             => c_7SERIES_PARALLEL_CLK_BUF,
    g_SPARTAN6_USE_PLL                     => FALSE,
    g_WITH_SDB_CROSSBAR                    => TRUE,
    g_WB_MODE                              => PIPELINED,
    g_WB_GRANULARITY                       => BYTE
  )
  port map (
    sys_clk_i                              => clk_sys,
    sys_rst_n_i                            => clk_sys_rstn,

    wb_csr_slave_i                         => wb_fmc_master_out(c_fmc_adc_1_id),
    wb_csr_slave_o                         => wb_fmc_master_in(c_fmc_adc_1_id),

    wb_ddr_clk_i                           => '0',
    wb_ddr_rst_n_i                         => '0',
    wb_ddr_master_i                        => c_DUMMY_WB_MASTER_D64_IN,
    wb_ddr_master_o                        => open,

    fs_clk_o                               => fs_clk(c_fmc_adc_1_id),
    fs_rst_n_o                             => fs_rst_n(c_fmc_adc_1_id),

    adc_data_ch3_o                         => open,
    adc_data_ch2_o                         => open,
    adc_data_ch1_o                         => open,
    adc_data_ch0_o                         => open,

    adc_sw_trigger_o                       => open,
    adc_ext_trigger_o                      => open,
    adc_aux_time_trigger_o                 => open,
    adc_time_trigger_o                     => open,
    adc_int4_trigger_o                     => open,
    adc_int3_trigger_o                     => open,
    adc_int2_trigger_o                     => open,
    adc_int1_trigger_o                     => open,
    adc_pulse_trigger_o                    => open,

    adc_data_ch3_sys_clk_o                 => fmc_adc_data_ch3(c_fmc_adc_1_id),
    adc_data_ch2_sys_clk_o                 => fmc_adc_data_ch2(c_fmc_adc_1_id),
    adc_data_ch1_sys_clk_o                 => fmc_adc_data_ch1(c_fmc_adc_1_id),
    adc_data_ch0_sys_clk_o                 => fmc_adc_data_ch0(c_fmc_adc_1_id),
    adc_data_valid_sys_clk_o               => fmc_adc_data_valid(c_fmc_adc_1_id),

    adc_sw_trigger_sys_clk_o               => fmc_adc_sw_trigger(c_fmc_adc_1_id),
    adc_ext_trigger_sys_clk_o              => fmc_adc_ext_trigger(c_fmc_adc_1_id),
    adc_aux_time_trigger_sys_clk_o         => fmc_adc_aux_time_trigger(c_fmc_adc_1_id),
    adc_time_trigger_sys_clk_o             => fmc_adc_time_trigger(c_fmc_adc_1_id),
    adc_int4_trigger_sys_clk_o             => fmc_adc_int4_trigger(c_fmc_adc_1_id),
    adc_int3_trigger_sys_clk_o             => fmc_adc_int3_trigger(c_fmc_adc_1_id),
    adc_int2_trigger_sys_clk_o             => fmc_adc_int2_trigger(c_fmc_adc_1_id),
    adc_int1_trigger_sys_clk_o             => fmc_adc_int1_trigger(c_fmc_adc_1_id),
    adc_pulse_trigger_sys_clk_o            => fmc_adc_pulse_trigger(c_fmc_adc_1_id),

    ddr_wr_fifo_empty_i                    => '1',
    trig_irq_o                             => open,
    acq_end_irq_o                          => open,
    eic_irq_o                              => fmc_adc_irq(c_fmc_adc_1_id),
    acq_cfg_ok_o                           => fmc_adc_acq_cfg_ok(c_fmc_adc_1_id),

    ext_trigger_p_i                        => fmc1_adc_ext_trigger_p_i,
    ext_trigger_n_i                        => fmc1_adc_ext_trigger_n_i,

    adc_dco_p_i                            => fmc1_adc_dco_p_i,
    adc_dco_n_i                            => fmc1_adc_dco_n_i,
    adc_fr_p_i                             => fmc1_adc_fr_p_i,
    adc_fr_n_i                             => fmc1_adc_fr_n_i,
    adc_outa_p_i                           => fmc1_adc_outa_p_i,
    adc_outa_n_i                           => fmc1_adc_outa_n_i,
    adc_outb_p_i                           => fmc1_adc_outb_p_i,
    adc_outb_n_i                           => fmc1_adc_outb_n_i,

    gpio_dac_clr_n_o                       => fmc1_adc_gpio_dac_clr_n_o,
    gpio_led_acq_o                         => fmc1_adc_gpio_led_acq_o,
    gpio_led_trig_o                        => fmc1_adc_gpio_led_trig_o,
    gpio_ssr_ch1_o                         => fmc1_adc_gpio_ssr_ch1_o,
    gpio_ssr_ch2_o                         => fmc1_adc_gpio_ssr_ch2_o,
    gpio_ssr_ch3_o                         => fmc1_adc_gpio_ssr_ch3_o,
    gpio_ssr_ch4_o                         => fmc1_adc_gpio_ssr_ch4_o,
    gpio_si570_oe_o                        => fmc1_adc_gpio_si570_oe_o,

    spi_din_i                              => fmc1_adc_spi_din_i,
    spi_dout_o                             => fmc1_adc_spi_dout_o,
    spi_sck_o                              => fmc1_adc_spi_sck_o,
    spi_cs_adc_n_o                         => fmc1_adc_spi_cs_adc_n_o,
    spi_cs_dac1_n_o                        => fmc1_adc_spi_cs_dac1_n_o,
    spi_cs_dac2_n_o                        => fmc1_adc_spi_cs_dac2_n_o,
    spi_cs_dac3_n_o                        => fmc1_adc_spi_cs_dac3_n_o,
    spi_cs_dac4_n_o                        => fmc1_adc_spi_cs_dac4_n_o,

    si570_scl_b                            => fmc1_adc_si570_scl_b,
    si570_sda_b                            => fmc1_adc_si570_sda_b,

    mezz_one_wire_b                        => fmc1_adc_one_wire_b,

    wr_tm_link_up_i                        => '0',
    wr_tm_time_valid_i                     => '0',
    wr_tm_tai_i                            => (others => '0'),
    wr_tm_cycles_i                         => (others => '0'),
    wr_enable_i                            => '0'
  );

  ----------------------------------------------------------------------
  --                          Acquisition                             --
  ----------------------------------------------------------------------

  gen_acq_clks : for i in 0 to c_acq_num_cores-1 generate

    fs_clk_array(i)   <= clk_sys;
    fs_ce_array(i)    <= '1';
    fs_rst_n_array(i) <= clk_sys_rstn;

  end generate;

  --------------------
  -- ADC 1 data
  --------------------

  acq_chan_array(c_acq_core_0_id, c_acq_adc_id).val(to_integer(c_facq_channels(c_acq_adc_id).width)-1 downto 0) <=
                                                                 fmc_adc_data_ch3(c_fmc_adc_0_id) &
                                                                 fmc_adc_data_ch2(c_fmc_adc_0_id) &
                                                                 fmc_adc_data_ch1(c_fmc_adc_0_id) &
                                                                 fmc_adc_data_ch0(c_fmc_adc_0_id);
  acq_chan_array(c_acq_core_0_id, c_acq_adc_id).dvalid        <= fmc_adc_data_valid(c_fmc_adc_0_id);
  acq_chan_array(c_acq_core_0_id, c_acq_adc_id).trig          <= trig_pulse_rcv(c_trig_mux_0_id, c_acq_adc_id).pulse;

  --------------------
  -- ADC 2 data
  --------------------

  acq_chan_array(c_acq_core_1_id, c_acq_adc_id).val(to_integer(c_facq_channels(c_acq_adc_id).width)-1 downto 0) <=
                                                                 fmc_adc_data_ch3(c_fmc_adc_1_id) &
                                                                 fmc_adc_data_ch2(c_fmc_adc_1_id) &
                                                                 fmc_adc_data_ch1(c_fmc_adc_1_id) &
                                                                 fmc_adc_data_ch0(c_fmc_adc_1_id);
  acq_chan_array(c_acq_core_1_id, c_acq_adc_id).dvalid        <= fmc_adc_data_valid(c_fmc_adc_1_id);
  acq_chan_array(c_acq_core_1_id, c_acq_adc_id).trig          <= trig_pulse_rcv(c_trig_mux_1_id, c_acq_adc_id).pulse;

  ----------------------------------------------------------------------
  --                          Trigger                                 --
  ----------------------------------------------------------------------

  trig_ref_clk <= clk_trig_ref;
  trig_ref_rst_n <= clk_trig_ref_rstn;

  -- Assign FMCs trigger pulses to trigger channel interfaces
  trig_fmc1_channel_1.pulse <= fmc_adc_pulse_trigger(c_fmc_adc_0_id);
  trig_fmc1_channel_2.pulse <= fmc_adc_ext_trigger(c_fmc_adc_0_id);

  trig_fmc2_channel_1.pulse <= fmc_adc_pulse_trigger(c_fmc_adc_1_id);
  trig_fmc2_channel_2.pulse <= fmc_adc_ext_trigger(c_fmc_adc_1_id);

  -- Assign intern triggers to trigger module
  trig_rcv_intern(c_trig_mux_0_id, c_trig_rcv_intern_chan_1_id) <= trig_fmc1_channel_1;
  trig_rcv_intern(c_trig_mux_0_id, c_trig_rcv_intern_chan_2_id) <= trig_fmc1_channel_2;
  trig_rcv_intern(c_trig_mux_1_id, c_trig_rcv_intern_chan_1_id) <= trig_fmc2_channel_1;
  trig_rcv_intern(c_trig_mux_1_id, c_trig_rcv_intern_chan_2_id) <= trig_fmc2_channel_2;

end architecture top;
