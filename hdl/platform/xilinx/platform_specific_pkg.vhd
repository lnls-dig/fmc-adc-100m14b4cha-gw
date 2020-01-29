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

end platform_specific_pkg;
