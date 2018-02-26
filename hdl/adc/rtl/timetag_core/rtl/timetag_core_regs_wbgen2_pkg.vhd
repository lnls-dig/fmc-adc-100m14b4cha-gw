---------------------------------------------------------------------------------------
-- Title          : Wishbone slave core for Time-tagging core registers
---------------------------------------------------------------------------------------
-- File           : ../rtl/timetag_core_regs_wbgen2_pkg.vhd
-- Author         : auto-generated by wbgen2 from timetag_core_regs.wb
-- Created        : Fri Feb 23 15:43:42 2018
-- Standard       : VHDL'87
---------------------------------------------------------------------------------------
-- THIS FILE WAS GENERATED BY wbgen2 FROM SOURCE FILE timetag_core_regs.wb
-- DO NOT HAND-EDIT UNLESS IT'S ABSOLUTELY NECESSARY!
---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package timetag_core_wbgen2_pkg is
  
  
  -- Input registers (user design -> WB slave)
  
  type t_timetag_core_in_registers is record
    seconds_upper_i                          : std_logic_vector(7 downto 0);
    seconds_lower_i                          : std_logic_vector(31 downto 0);
    coarse_i                                 : std_logic_vector(27 downto 0);
    trig_tag_seconds_upper_i                 : std_logic_vector(7 downto 0);
    trig_tag_seconds_lower_i                 : std_logic_vector(31 downto 0);
    trig_tag_coarse_i                        : std_logic_vector(27 downto 0);
    acq_start_tag_seconds_upper_i            : std_logic_vector(7 downto 0);
    acq_start_tag_seconds_lower_i            : std_logic_vector(31 downto 0);
    acq_start_tag_coarse_i                   : std_logic_vector(27 downto 0);
    acq_stop_tag_seconds_upper_i             : std_logic_vector(7 downto 0);
    acq_stop_tag_seconds_lower_i             : std_logic_vector(31 downto 0);
    acq_stop_tag_coarse_i                    : std_logic_vector(27 downto 0);
    acq_end_tag_seconds_upper_i              : std_logic_vector(7 downto 0);
    acq_end_tag_seconds_lower_i              : std_logic_vector(31 downto 0);
    acq_end_tag_coarse_i                     : std_logic_vector(27 downto 0);
    end record;
  
  constant c_timetag_core_in_registers_init_value: t_timetag_core_in_registers := (
    seconds_upper_i => (others => '0'),
    seconds_lower_i => (others => '0'),
    coarse_i => (others => '0'),
    trig_tag_seconds_upper_i => (others => '0'),
    trig_tag_seconds_lower_i => (others => '0'),
    trig_tag_coarse_i => (others => '0'),
    acq_start_tag_seconds_upper_i => (others => '0'),
    acq_start_tag_seconds_lower_i => (others => '0'),
    acq_start_tag_coarse_i => (others => '0'),
    acq_stop_tag_seconds_upper_i => (others => '0'),
    acq_stop_tag_seconds_lower_i => (others => '0'),
    acq_stop_tag_coarse_i => (others => '0'),
    acq_end_tag_seconds_upper_i => (others => '0'),
    acq_end_tag_seconds_lower_i => (others => '0'),
    acq_end_tag_coarse_i => (others => '0')
    );
    
    -- Output registers (WB slave -> user design)
    
    type t_timetag_core_out_registers is record
      seconds_upper_o                          : std_logic_vector(7 downto 0);
      seconds_upper_load_o                     : std_logic;
      seconds_lower_o                          : std_logic_vector(31 downto 0);
      seconds_lower_load_o                     : std_logic;
      coarse_o                                 : std_logic_vector(27 downto 0);
      coarse_load_o                            : std_logic;
      time_trig_seconds_upper_o                : std_logic_vector(7 downto 0);
      time_trig_seconds_lower_o                : std_logic_vector(31 downto 0);
      time_trig_coarse_o                       : std_logic_vector(27 downto 0);
      end record;
    
    constant c_timetag_core_out_registers_init_value: t_timetag_core_out_registers := (
      seconds_upper_o => (others => '0'),
      seconds_upper_load_o => '0',
      seconds_lower_o => (others => '0'),
      seconds_lower_load_o => '0',
      coarse_o => (others => '0'),
      coarse_load_o => '0',
      time_trig_seconds_upper_o => (others => '0'),
      time_trig_seconds_lower_o => (others => '0'),
      time_trig_coarse_o => (others => '0')
      );
    function "or" (left, right: t_timetag_core_in_registers) return t_timetag_core_in_registers;
    function f_x_to_zero (x:std_logic) return std_logic;
    function f_x_to_zero (x:std_logic_vector) return std_logic_vector;
end package;

package body timetag_core_wbgen2_pkg is
function f_x_to_zero (x:std_logic) return std_logic is
begin
if x = '1' then
return '1';
else
return '0';
end if;
end function;
function f_x_to_zero (x:std_logic_vector) return std_logic_vector is
variable tmp: std_logic_vector(x'length-1 downto 0);
begin
for i in 0 to x'length-1 loop
if x(i) = '1' then
tmp(i):= '1';
else
tmp(i):= '0';
end if; 
end loop; 
return tmp;
end function;
function "or" (left, right: t_timetag_core_in_registers) return t_timetag_core_in_registers is
variable tmp: t_timetag_core_in_registers;
begin
tmp.seconds_upper_i := f_x_to_zero(left.seconds_upper_i) or f_x_to_zero(right.seconds_upper_i);
tmp.seconds_lower_i := f_x_to_zero(left.seconds_lower_i) or f_x_to_zero(right.seconds_lower_i);
tmp.coarse_i := f_x_to_zero(left.coarse_i) or f_x_to_zero(right.coarse_i);
tmp.trig_tag_seconds_upper_i := f_x_to_zero(left.trig_tag_seconds_upper_i) or f_x_to_zero(right.trig_tag_seconds_upper_i);
tmp.trig_tag_seconds_lower_i := f_x_to_zero(left.trig_tag_seconds_lower_i) or f_x_to_zero(right.trig_tag_seconds_lower_i);
tmp.trig_tag_coarse_i := f_x_to_zero(left.trig_tag_coarse_i) or f_x_to_zero(right.trig_tag_coarse_i);
tmp.acq_start_tag_seconds_upper_i := f_x_to_zero(left.acq_start_tag_seconds_upper_i) or f_x_to_zero(right.acq_start_tag_seconds_upper_i);
tmp.acq_start_tag_seconds_lower_i := f_x_to_zero(left.acq_start_tag_seconds_lower_i) or f_x_to_zero(right.acq_start_tag_seconds_lower_i);
tmp.acq_start_tag_coarse_i := f_x_to_zero(left.acq_start_tag_coarse_i) or f_x_to_zero(right.acq_start_tag_coarse_i);
tmp.acq_stop_tag_seconds_upper_i := f_x_to_zero(left.acq_stop_tag_seconds_upper_i) or f_x_to_zero(right.acq_stop_tag_seconds_upper_i);
tmp.acq_stop_tag_seconds_lower_i := f_x_to_zero(left.acq_stop_tag_seconds_lower_i) or f_x_to_zero(right.acq_stop_tag_seconds_lower_i);
tmp.acq_stop_tag_coarse_i := f_x_to_zero(left.acq_stop_tag_coarse_i) or f_x_to_zero(right.acq_stop_tag_coarse_i);
tmp.acq_end_tag_seconds_upper_i := f_x_to_zero(left.acq_end_tag_seconds_upper_i) or f_x_to_zero(right.acq_end_tag_seconds_upper_i);
tmp.acq_end_tag_seconds_lower_i := f_x_to_zero(left.acq_end_tag_seconds_lower_i) or f_x_to_zero(right.acq_end_tag_seconds_lower_i);
tmp.acq_end_tag_coarse_i := f_x_to_zero(left.acq_end_tag_coarse_i) or f_x_to_zero(right.acq_end_tag_coarse_i);
return tmp;
end function;
end package body;
