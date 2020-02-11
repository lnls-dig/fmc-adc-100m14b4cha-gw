library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package platform_specific_pkg is

  --------------------------------------------------------------------
  -- Components
  --------------------------------------------------------------------
  component platform_multiplier
    generic (
      g_LATENCY : natural := 0;                                           -- Desired clock cycle latency, 0-4
      g_WIDTH_A : natural := 18;                                          -- Multiplier A-input bus width, 1-25
      g_WIDTH_B : natural := 18);                                         -- Multiplier B-input bus width, 1-18
    port (
      product_o  : out std_logic_vector(g_WIDTH_A+g_WIDTH_B-1 downto 0);  -- Multiplier ouput, WIDTH_A+WIDTH_B
      a_i        : in std_logic_vector(g_WIDTH_A-1 downto 0);             -- Multiplier input A, WIDTH_A
      b_i        : in std_logic_vector(g_WIDTH_B-1 downto 0);             -- Multiplier input B, WIDTH_B
      ce_i       : in std_logic;                                          -- 1-bit active high input clock enable
      clk_i      : in std_logic;                                          -- 1-bit positive edge clock input
      rst_i      : in std_logic);                                         -- 1-bit input active high reset
  end component;

  component ltc2174_2l16b_receiver
    generic (
      -- Use PLL or MMCM. In some cases, only MMCM  can be used depending on
      -- the buffer types
      g_USE_PLL              : boolean := TRUE;
      -- DDR should be used is the combination og g_SERIAL_CLK_BUF + g_PARALLEL_CLK_BUF
      -- for SDR does not meet the requirements. See XAPP585 (v1.1.2) July 18, 2018,
      -- table 2, page 3, for the maximum rates on each mode
      g_USE_SDR              : boolean := FALSE;
      -- Buffer Types. For appropriate selection see XAPP585 (v1.1.2) July 18, 2018
      -- table 2, page 3. The fastest clock possible for SDR is the combination of
      -- BUFIO for serial clock + BUFR for parallel clock.
      -- Buffer type for serial clock. Options are : BUFG, BUFIO, BUFH and BUFR
      g_SERIAL_CLK_BUF       : string := "BUFIO";
      -- Buffer type for serial clock. Options are : BUFG, BUFH and BUFR
      g_PARALLEL_CLK_BUF     : string := "BUFR");
    port (
      -- ADC data clock
      adc_dco_p_i     : in  std_logic;
      adc_dco_n_i     : in  std_logic;
      -- ADC frame start
      adc_fr_p_i      : in  std_logic;
      adc_fr_n_i      : in  std_logic;
      -- ADC serial data in (odd bits)
      adc_outa_p_i    : in  std_logic_vector(3 downto 0);
      adc_outa_n_i    : in  std_logic_vector(3 downto 0);
      -- ADC serial data in (even bits)
      adc_outb_p_i    : in  std_logic_vector(3 downto 0);
      adc_outb_n_i    : in  std_logic_vector(3 downto 0);
      -- Async reset input (active high) for iserdes
      serdes_arst_i   : in  std_logic := '0';
      -- Manual bitslip command (optional)
      serdes_bslip_i  : in  std_logic := '0';
      -- Indication that SERDES is ok and locked to
      -- frame start pattern
      serdes_synced_o : out std_logic;
      -- ADC parallel data out
      --  (15:0)  = CH1, (31:16) = CH2, (47:32) = CH3, (63:48) = CH4
      --  The two LSBs of each channel are always '0'
      adc_data_o      : out std_logic_vector(63 downto 0);
      -- ADC divided clock, for FPGA logic
      adc_clk_o       : out std_logic);
  end component;

end platform_specific_pkg;
