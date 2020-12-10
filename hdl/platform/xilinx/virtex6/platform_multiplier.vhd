------------------------------------------------------------------------------
-- Title      : Generic Multiplier using platform specific primitives
------------------------------------------------------------------------------
-- Author     : Lucas Maziero Russo
-- Company    : CNPEM LNLS-DIG
-- Created    : 2020-01-29
-- Platform   : FPGA-generic
-------------------------------------------------------------------------------
-- Description: Generic Multiplier using platform specific primitives
-------------------------------------------------------------------------------
-- Copyright (c) 2020 CNPEM
-- Licensed under GNU Lesser General Public License (LGPL) v3.0
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2020-01-29  1.0      lucas.russo        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library unimacro;
use unimacro.vcomponents.all;

entity platform_multiplier is
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
end platform_multiplier;

architecture arch of platform_multiplier is

begin

   cmp_mult_macro : MULT_MACRO
   generic map (
      DEVICE                   => "VIRTEX6",
      LATENCY                  => g_LATENCY,
      WIDTH_A                  => g_WIDTH_A,
      WIDTH_B                  => g_WIDTH_B)
   port map (
      P                        => product_o,
      A                        => a_i,
      B                        => b_i,
      CE                       => ce_i,
      CLK                      => clk_i,
      RST                      => rst_i
   );

end architecture arch;
