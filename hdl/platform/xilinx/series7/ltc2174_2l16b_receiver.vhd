------------------------------------------------------------------------------
-- Title      : LTC2174 receiver for Xilinx Series 7
------------------------------------------------------------------------------
-- Author     : Lucas Maziero Russo
-- Company    : CNPEM LNLS-DIG
-- Created    : 2020-01-29
-- Platform   : FPGA-generic
-------------------------------------------------------------------------------
-- Description: This module implements all the platform-specific logic necessary to receive
-- data from an LTC2174 working in 2-lane, 16-bit serialization mode.
-------------------------------------------------------------------------------
-- Copyright (c) 2020 CNPEM
-- Licensed under GNU Lesser General Public License (LGPL) v3.0
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2020-01-29  1.0      lucas.russo        Created
-------------------------------------------------------------------------------
--
-- Based on ltc2174_2l16b_receiver for Spartan 6

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity ltc2174_2l16b_receiver is
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
    g_PARALLEL_CLK_BUF     : string := "BUFG");
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

end ltc2174_2l16b_receiver;

architecture arch of ltc2174_2l16b_receiver is

  -- Clock signals
  signal pll_clkin      : std_logic;
  signal pll_clkfbin    : std_logic;
  signal pll_clkfbout   : std_logic;
  signal clk_serdes_pre : std_logic;
  signal clk_serdes_buf : std_logic;
  signal pll_locked     : std_logic;
  signal pll_clkout0    : std_logic;
  signal pll_clkout1    : std_logic;

  signal adc_dco           : std_logic;
  signal adc_fr            : std_logic;
  signal adc_outa          : std_logic_vector(3 downto 0);
  signal adc_outb          : std_logic_vector(3 downto 0);
  signal clk_serdes_p      : std_logic;
  signal clk_serdes_n      : std_logic;
  signal clk_div_int_p     : std_logic;
  signal clk_div_int_n     : std_logic;
  signal clk_div_buf       : std_logic;
  signal serdes_strobe     : std_logic                    := '0';
  signal serdes_auto_bslip : std_logic                    := '0';
  signal serdes_bitslip    : std_logic                    := '0';
  signal serdes_synced     : std_logic                    := '0';
  signal serdes_m2s_shift  : std_logic_vector(8 downto 0) := (others => '0');
  signal serdes_s2m_shift  : std_logic_vector(8 downto 0) := (others => '0');
  signal serdes_serial_in  : std_logic_vector(8 downto 0) := (others => '0');
  signal serdes_out_fr     : std_logic_vector(7 downto 0) := (others => '0');

  signal bitslip_sreg : unsigned(7 downto 0) := to_unsigned(1, 8);

  type serdes_array is array (0 to 8) of std_logic_vector(7 downto 0);
  signal serdes_parallel_out : serdes_array := (others => (others => '0'));

  -- used to select the data rate of the ISERDES blocks
  function f_data_rate_sel (
    constant SDR : boolean)
    return string is
  begin
    if SDR = TRUE then
      return "SDR";
    else
      return "DDR";
    end if;
  end function f_data_rate_sel;

begin  -- architecture arch

  ------------------------------------------------------------------------------
  -- Differential input buffers per input pair
  ------------------------------------------------------------------------------

  -- ADC data clock
  cmp_adc_dco_buf : IBUFGDS
    generic map (
      DIFF_TERM    => TRUE,
      IBUF_LOW_PWR => TRUE,
      IOSTANDARD   => "LVDS_25")
    port map (
      I  => adc_dco_p_i,
      IB => adc_dco_n_i,
      O  => adc_dco);

  -- ADC frame start
  cmp_adc_fr_buf : IBUFDS
    generic map (
      DIFF_TERM    => TRUE,
      IBUF_LOW_PWR => TRUE,
      IOSTANDARD   => "LVDS_25")
    port map (
      I  => adc_fr_p_i,
      IB => adc_fr_n_i,
      O  => adc_fr);

  gen_adc_data_buf : for I in 0 to 3 generate

    cmp_adc_outa_buf : IBUFDS
      generic map (
        DIFF_TERM    => TRUE,
        IBUF_LOW_PWR => TRUE,
        IOSTANDARD   => "LVDS_25")
      port map (
        I  => adc_outa_p_i(i),
        IB => adc_outa_n_i(i),
        O  => adc_outa(i));

    cmp_adc_outb_buf : IBUFDS
      generic map (
        DIFF_TERM    => TRUE,
        IBUF_LOW_PWR => TRUE,
        IOSTANDARD   => "LVDS_25")
      port map (
        I  => adc_outb_p_i(i),
        IB => adc_outb_n_i(i),
        O  => adc_outb(i));

  end generate gen_adc_data_buf;

  -- We don't need BUFIO or any type of buffer to connect to MMCM/PLL, as in
  -- Spartan6
  pll_clkin <= adc_dco;

  ------------------------------------------------------------------------------
  -- Clock generation for deserializer
  --
  -- SDR scheme proposed in XAPP585 (v1.1.2) July 18, 2018.
  ------------------------------------------------------------------------------

  -- XAPP585, v1.1.2, page 7, figure 2, without calibration. Calibration can be
  -- added later if needed.
  gen_sdr_clks : if g_USE_SDR generate

    gen_pll : if g_USE_PLL generate

      cmp_dco_pll : PLLE2_ADV
        generic map(
          BANDWIDTH           => "OPTIMIZED",
          -- We multiply the incoming clock by 2 and divide by 8, because LTC2174
          -- uses DDR reception scheme and we want SERDES to operate on SDR.
          CLKFBOUT_MULT       => 2,
          CLKIN1_PERIOD       => 2.5,
          CLKOUT0_DIVIDE      => 8,
          CLKOUT1_DIVIDE      => 1,
          COMPENSATION        => "ZHOLD",
          DIVCLK_DIVIDE       => 1,
          REF_JITTER1         => 0.01)
        port map (
          CLKFBOUT => pll_clkfbout,
          CLKOUT0  => pll_clkout0,
          CLKOUT1  => pll_clkout1,
          CLKOUT2  => open,
          CLKOUT3  => open,
          CLKOUT4  => open,
          CLKOUT5  => open,
          DO       => open,
          DRDY     => open,
          PWRDWN   => '0',
          DADDR    => "0000000",
          DCLK     => '0',
          DEN      => '0',
          DI       => X"0000",
          DWE      => '0',
          LOCKED   => pll_locked,
          CLKFBIN  => pll_clkfbin,
          CLKIN1   => pll_clkin,
          CLKIN2   => '0',
          CLKINSEL => '1',
          RST      => '0');

    end generate gen_pll;

    gen_mmcm : if not g_USE_PLL generate

      cmp_dco_mmcm : MMCME2_ADV
        generic map(
          BANDWIDTH           => "OPTIMIZED",
          -- We multiply the incoming clock by 2 and divide by 8, because LTC2174
          -- uses DDR reception scheme and we want SERDES to operate on SDR.
          CLKFBOUT_MULT_F     => 2.000,
          CLKIN1_PERIOD       => 2.5,
          CLKOUT0_DIVIDE_F    => 8.000,
          CLKOUT1_DIVIDE      => 1,
          COMPENSATION        => "ZHOLD",
          DIVCLK_DIVIDE       => 1,
          REF_JITTER1         => 0.01)
        port map (
          CLKFBOUT => pll_clkfbout,
          CLKOUT0  => pll_clkout0,
          CLKOUT1  => pll_clkout1,
          CLKOUT2  => open,
          CLKOUT3  => open,
          CLKOUT4  => open,
          CLKOUT5  => open,
          DO       => open,
          DRDY     => open,
          PWRDWN   => '0',
          DADDR    => "0000000",
          DCLK     => '0',
          DEN      => '0',
          DI       => X"0000",
          DWE      => '0',
          PSCLK    => '0',
          PSEN     => '0',
          PSINCDEC => '0',
          LOCKED   => pll_locked,
          CLKFBIN  => pll_clkfbin,
          CLKIN1   => pll_clkin,
          CLKIN2   => '0',
          CLKINSEL => '1',
          RST      => '0');

    end generate gen_mmcm;

    -- For SDR scheme use an additional BUFG for the feedback and use the CLK0
    -- CLK1 as serial and parallel clocks, respectively.
    cmp_fb_bufg : BUFG
      port map (
        I => pll_clkfbout,
        O => pll_clkfbin);

    clk_serdes_pre <= pll_clkout1;
    -- clk_serdes_buf is not used in SDR scheme

  end generate gen_sdr_clks;

  ------------------------------------------------------------------------------
  -- Clock generation for deserializer
  --
  -- DDR scheme proposed in XAPP585 (v1.1.2) July 18, 2018.
  ------------------------------------------------------------------------------

  -- XAPP585, v1.1.2, page 7, figure 2, without calibration. Calibration can be
  -- added later if needed.
  gen_ddr_clks : if not g_USE_SDR generate

    gen_pll : if g_USE_PLL generate

      cmp_dco_pll : PLLE2_ADV
        generic map(
          BANDWIDTH           => "OPTIMIZED",
          -- We multiply the incoming clock by 2 and divide by 16, because LTC2174
          -- uses DDR reception scheme and we want SERDES to operate on DDR.
          CLKFBOUT_MULT       => 2,
          CLKIN1_PERIOD       => 2.5,
          CLKOUT0_DIVIDE      => 8,
          CLKOUT1_DIVIDE      => 2,
          COMPENSATION        => "ZHOLD",
          DIVCLK_DIVIDE       => 1,
          REF_JITTER1         => 0.01)
        port map (
          CLKFBOUT => pll_clkfbout,
          CLKOUT0  => pll_clkout0,
          CLKOUT1  => pll_clkout1,
          CLKOUT2  => open,
          CLKOUT3  => open,
          CLKOUT4  => open,
          CLKOUT5  => open,
          DO       => open,
          DRDY     => open,
          PWRDWN   => '0',
          DADDR    => "0000000",
          DCLK     => '0',
          DEN      => '0',
          DI       => X"0000",
          DWE      => '0',
          LOCKED   => pll_locked,
          CLKFBIN  => pll_clkfbin,
          CLKIN1   => pll_clkin,
          CLKIN2   => '0',
          CLKINSEL => '1',
          RST      => '0');

    end generate gen_pll;

    gen_mmcm : if not g_USE_PLL generate

      cmp_dco_mmcm : MMCME2_ADV
        generic map(
          BANDWIDTH           => "OPTIMIZED",
          -- We multiply the incoming clock by 2 and divide by 16, because LTC2174
          -- uses DDR reception scheme and we want SERDES to operate on DDR.
          CLKFBOUT_MULT_F     => 2.000,
          CLKIN1_PERIOD       => 2.5,
          CLKOUT0_DIVIDE_F    => 8.000,
          CLKOUT1_DIVIDE      => 2,
          COMPENSATION        => "ZHOLD",
          DIVCLK_DIVIDE       => 1,
          REF_JITTER1         => 0.01)
        port map (
          CLKFBOUT => pll_clkfbout,
          CLKOUT0  => pll_clkout0,
          CLKOUT1  => pll_clkout1,
          CLKOUT2  => open,
          CLKOUT3  => open,
          CLKOUT4  => open,
          CLKOUT5  => open,
          DO       => open,
          DRDY     => open,
          PWRDWN   => '0',
          DADDR    => "0000000",
          DCLK     => '0',
          DEN      => '0',
          DI       => X"0000",
          DWE      => '0',
          PSCLK    => '0',
          PSEN     => '0',
          PSINCDEC => '0',
          LOCKED   => pll_locked,
          CLKFBIN  => pll_clkfbin,
          CLKIN1   => pll_clkin,
          CLKIN2   => '0',
          CLKINSEL => '1',
          RST      => '0');

    end generate gen_mmcm;

    -- We can't use BUFIO for feedback clock, so if serial_clock if BUFIO,
    -- use a BUFG for that.
    gen_bufg_fb_clk : if g_SERIAL_CLK_BUF = "BUFIO" generate
      cmp_fb_bufg : BUFG
        port map (
          I => pll_clkfbout,
          O => pll_clkfbin);

      clk_serdes_pre <= pll_clkout1;
      -- clk_serdes_buf is not used in DDR scheme
    end generate gen_bufg_fb_clk;

    -- If not BUFIO dor DDR clock we can save one BUFG and use the same
    -- buffer for feedback and driving logic
    gen_other_fb_clk : if g_SERIAL_CLK_BUF /= "BUFIO" generate
      -- For DDR scheme just get the clkfbout and clkfbin as
      -- SERDES clock
      clk_serdes_pre <= pll_clkfbout;
      pll_clkfbin    <= clk_serdes_buf;
  end generate gen_other_fb_clk;

  end generate gen_ddr_clks;

  -- Data clock for SERDES serial data

  gen_mmcm_serial_clk_bufg : if g_SERIAL_CLK_BUF = "BUFG" generate
    cmp_bufg : BUFG
      port map (
        I => clk_serdes_pre,
        O => clk_serdes_buf);
  end generate gen_mmcm_serial_clk_bufg;

  gen_mmcm_serial_clk_bufio : if g_SERIAL_CLK_BUF = "BUFIO" generate
    cmp_bufio : BUFIO
      port map (
        I => clk_serdes_pre,
        O => clk_serdes_buf);
  end generate gen_mmcm_serial_clk_bufio;

  gen_mmcm_serial_clk_bufr : if g_SERIAL_CLK_BUF = "BUFR" generate
    cmp_bufr : BUFR
      generic map (
        BUFR_DIVIDE => "1")
      port map (
        I   => clk_serdes_pre,
        CE  => '1',
        CLR => '0',
        O   => clk_serdes_buf);
  end generate gen_mmcm_serial_clk_bufr;

  gen_mmcm_serial_clk_bufh : if g_SERIAL_CLK_BUF = "BUFH" generate
    cmp_bufh : BUFH
      port map (
        I   => clk_serdes_pre,
        O   => clk_serdes_buf);
  end generate gen_mmcm_serial_clk_bufh;

  -- Divided clock for SERDES parallel data

  gen_mmcm_parallel_clk_bufg : if g_PARALLEL_CLK_BUF = "BUFG" generate
    cmp_bufg : BUFG
      port map(
        I => pll_clkout0,
        O => clk_div_buf);
  end generate gen_mmcm_parallel_clk_bufg;

  gen_mmcm_parallel_clk_bufio : if g_PARALLEL_CLK_BUF = "BUFR" generate
    cmp_bufr : BUFR
      generic map (
        BUFR_DIVIDE => "1")
      port map (
        I => pll_clkout0,
        CE  => '1',
        CLR => '0',
        O => clk_div_buf);
  end generate gen_mmcm_parallel_clk_bufio;

  gen_mmcm_parallel_clk_bufh : if g_PARALLEL_CLK_BUF = "BUFH" generate
    cmp_bufh : BUFH
      port map(
        I => pll_clkout0,
        O => clk_div_buf);
  end generate gen_mmcm_parallel_clk_bufh;

  -- SERDES clock
  clk_serdes_p <= clk_serdes_buf;
  clk_serdes_n <= not clk_serdes_buf;

  -- Parallel clock
  clk_div_int_p <= clk_div_buf;
  clk_div_int_n <= not clk_div_buf;

  -- drive out the divided clock, to be used by the FPGA logic
  adc_clk_o <= clk_div_int_p;

  ------------------------------------------------------------------------------
  -- Bitslip mechanism for deserializer
  ------------------------------------------------------------------------------

  p_auto_bitslip : process (clk_div_buf)
  begin
    if rising_edge(clk_div_buf) then
      -- Shift register to generate bitslip enable once every 8 clock ticks
      bitslip_sreg <= bitslip_sreg(0) & bitslip_sreg(bitslip_sreg'length-1 downto 1);

      -- Generate bitslip and synced signal
      if(bitslip_sreg(bitslip_sreg'LEFT) = '1') then
        -- use fr_n pattern (fr_p and fr_n are swapped on the adc mezzanine)
        if(serdes_out_fr /= "00001111") then
          serdes_auto_bslip <= '1';
          serdes_synced     <= '0';
        else
          serdes_auto_bslip <= '0';
          serdes_synced     <= '1';
        end if;
      else
        serdes_auto_bslip <= '0';
      end if;
    end if;
  end process p_auto_bitslip;

  serdes_bitslip  <= serdes_auto_bslip or serdes_bslip_i;
  serdes_synced_o <= serdes_synced and pll_locked;

  ------------------------------------------------------------------------------
  -- Data deserializer
  --
  -- For the ISERDES, we use the template proposed in ug471_7Series_SelectIO,
  -- (v1.10) May 8, 2018, pages 143-158. No cascading is needed since 7-series
  -- support up to 8 bits per SERDES.
  ------------------------------------------------------------------------------

  -- serdes inputs forming
  serdes_serial_in <= adc_fr
                      & adc_outa(3) & adc_outb(3)
                      & adc_outa(2) & adc_outb(2)
                      & adc_outa(1) & adc_outb(1)
                      & adc_outa(0) & adc_outb(0);

  gen_adc_data_iserdes : for I in 0 to 8 generate

    cmp_adc_iserdes : ISERDESE2
      generic map (
        DATA_RATE      => f_data_rate_sel(g_USE_SDR),
        DATA_WIDTH     => 8,
        INTERFACE_TYPE => "NETWORKING",
        IOBDELAY       => "IBUF",
        SERDES_MODE    => "MASTER")
      port map (
        D            => serdes_serial_in(I),
        DDLY         => '0',
        CE1          => '1',
        CE2          => '1',
        CLK          => clk_serdes_p,
        CLKB         => clk_serdes_n,
        RST          => serdes_arst_i,
        CLKDIV       => clk_div_int_p,
        CLKDIVP      => '0',
        OCLK         => '0',
        OCLKB        => '0',
        DYNCLKSEL    => '0',
        DYNCLKDIVSEL => '0',
        SHIFTIN1     => '0',
        SHIFTIN2     => '0',
        BITSLIP      => serdes_bitslip,
        O            => open,
        Q1           => serdes_parallel_out(I)(7),
        Q2           => serdes_parallel_out(I)(6),
        Q3           => serdes_parallel_out(I)(5),
        Q4           => serdes_parallel_out(I)(4),
        Q5           => serdes_parallel_out(I)(3),
        Q6           => serdes_parallel_out(I)(2),
        Q7           => serdes_parallel_out(I)(1),
        Q8           => serdes_parallel_out(I)(0),
        OFB          => '0',
        SHIFTOUT1    => open,
        SHIFTOUT2    => open);

  end generate gen_adc_data_iserdes;

  -- Get the Frame start directly from the iserdes output
  serdes_out_fr <= serdes_parallel_out(8);

  -- Data re-ordering for serdes outputs
  gen_serdes_dout_reorder : for I in 0 to 3 generate
    gen_serdes_dout_reorder_bits : for J in 0 to 7 generate
      -- OUT#B: even bits
      adc_data_o(I*16 + 2*J)     <= serdes_parallel_out(2*I)(J);
      -- OUT#A: odd bits
      adc_data_o(I*16 + 2*J + 1) <= serdes_parallel_out(2*I + 1)(J);
    end generate gen_serdes_dout_reorder_bits;
  end generate gen_serdes_dout_reorder;

end architecture arch;
