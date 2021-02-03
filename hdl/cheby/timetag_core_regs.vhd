-- Do not edit.  Generated on Wed Feb 03 09:41:34 2021 by lerwys
-- With Cheby 1.4.dev0 and these options:
--  -i timetag_core_regs.cheby --gen-hdl=timetag_core_regs.vhd


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wishbone_pkg.all;

package timetag_core_regs_pkg is
  type t_timetag_core_master_out is record
    seconds_upper    : std_logic_vector(7 downto 0);
    seconds_upper_wr : std_logic;
    seconds_lower    : std_logic_vector(31 downto 0);
    seconds_lower_wr : std_logic;
    coarse           : std_logic_vector(27 downto 0);
    coarse_wr        : std_logic;
    time_trig_seconds_upper : std_logic_vector(7 downto 0);
    time_trig_seconds_lower : std_logic_vector(31 downto 0);
    time_trig_coarse : std_logic_vector(27 downto 0);
  end record t_timetag_core_master_out;
  subtype t_timetag_core_slave_in is t_timetag_core_master_out;

  type t_timetag_core_slave_out is record
    seconds_upper    : std_logic_vector(7 downto 0);
    seconds_lower    : std_logic_vector(31 downto 0);
    coarse           : std_logic_vector(27 downto 0);
    trig_tag_seconds_upper : std_logic_vector(7 downto 0);
    trig_tag_seconds_lower : std_logic_vector(31 downto 0);
    trig_tag_coarse  : std_logic_vector(27 downto 0);
    acq_start_tag_seconds_upper : std_logic_vector(7 downto 0);
    acq_start_tag_seconds_lower : std_logic_vector(31 downto 0);
    acq_start_tag_coarse : std_logic_vector(27 downto 0);
    acq_stop_tag_seconds_upper : std_logic_vector(7 downto 0);
    acq_stop_tag_seconds_lower : std_logic_vector(31 downto 0);
    acq_stop_tag_coarse : std_logic_vector(27 downto 0);
    acq_end_tag_seconds_upper : std_logic_vector(7 downto 0);
    acq_end_tag_seconds_lower : std_logic_vector(31 downto 0);
    acq_end_tag_coarse : std_logic_vector(27 downto 0);
  end record t_timetag_core_slave_out;
  subtype t_timetag_core_master_in is t_timetag_core_slave_out;
end timetag_core_regs_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wishbone_pkg.all;
use work.timetag_core_regs_pkg.all;

entity timetag_core_regs is
  port (
    rst_n_i              : in    std_logic;
    clk_i                : in    std_logic;
    wb_i                 : in    t_wishbone_slave_in;
    wb_o                 : out   t_wishbone_slave_out;
    -- Wires and registers
    timetag_core_i       : in    t_timetag_core_master_in;
    timetag_core_o       : out   t_timetag_core_master_out
  );
end timetag_core_regs;

architecture syn of timetag_core_regs is
  signal adr_int                        : std_logic_vector(6 downto 2);
  signal rd_req_int                     : std_logic;
  signal wr_req_int                     : std_logic;
  signal rd_ack_int                     : std_logic;
  signal wr_ack_int                     : std_logic;
  signal wb_en                          : std_logic;
  signal ack_int                        : std_logic;
  signal wb_rip                         : std_logic;
  signal wb_wip                         : std_logic;
  signal seconds_upper_wreq             : std_logic;
  signal seconds_lower_wreq             : std_logic;
  signal coarse_wreq                    : std_logic;
  signal time_trig_seconds_upper_reg    : std_logic_vector(7 downto 0);
  signal time_trig_seconds_upper_wreq   : std_logic;
  signal time_trig_seconds_upper_wack   : std_logic;
  signal time_trig_seconds_lower_reg    : std_logic_vector(31 downto 0);
  signal time_trig_seconds_lower_wreq   : std_logic;
  signal time_trig_seconds_lower_wack   : std_logic;
  signal time_trig_coarse_reg           : std_logic_vector(27 downto 0);
  signal time_trig_coarse_wreq          : std_logic;
  signal time_trig_coarse_wack          : std_logic;
  signal rd_ack_d0                      : std_logic;
  signal rd_dat_d0                      : std_logic_vector(31 downto 0);
  signal wr_req_d0                      : std_logic;
  signal wr_adr_d0                      : std_logic_vector(6 downto 2);
  signal wr_dat_d0                      : std_logic_vector(31 downto 0);
  signal wr_sel_d0                      : std_logic_vector(3 downto 0);
begin

  -- WB decode signals
  adr_int <= wb_i.adr(6 downto 2);
  wb_en <= wb_i.cyc and wb_i.stb;

  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        wb_rip <= '0';
      else
        wb_rip <= (wb_rip or (wb_en and not wb_i.we)) and not rd_ack_int;
      end if;
    end if;
  end process;
  rd_req_int <= (wb_en and not wb_i.we) and not wb_rip;

  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        wb_wip <= '0';
      else
        wb_wip <= (wb_wip or (wb_en and wb_i.we)) and not wr_ack_int;
      end if;
    end if;
  end process;
  wr_req_int <= (wb_en and wb_i.we) and not wb_wip;

  ack_int <= rd_ack_int or wr_ack_int;
  wb_o.ack <= ack_int;
  wb_o.stall <= not ack_int and wb_en;
  wb_o.rty <= '0';
  wb_o.err <= '0';

  -- pipelining for wr-in+rd-out
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        rd_ack_int <= '0';
        wr_req_d0 <= '0';
      else
        rd_ack_int <= rd_ack_d0;
        wb_o.dat <= rd_dat_d0;
        wr_req_d0 <= wr_req_int;
        wr_adr_d0 <= adr_int;
        wr_dat_d0 <= wb_i.dat;
        wr_sel_d0 <= wb_i.sel;
      end if;
    end if;
  end process;

  -- Register seconds_upper
  timetag_core_o.seconds_upper <= wr_dat_d0(7 downto 0);
  timetag_core_o.seconds_upper_wr <= seconds_upper_wreq;

  -- Register seconds_lower
  timetag_core_o.seconds_lower <= wr_dat_d0;
  timetag_core_o.seconds_lower_wr <= seconds_lower_wreq;

  -- Register coarse
  timetag_core_o.coarse <= wr_dat_d0(27 downto 0);
  timetag_core_o.coarse_wr <= coarse_wreq;

  -- Register time_trig_seconds_upper
  timetag_core_o.time_trig_seconds_upper <= time_trig_seconds_upper_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        time_trig_seconds_upper_reg <= "00000000";
        time_trig_seconds_upper_wack <= '0';
      else
        if time_trig_seconds_upper_wreq = '1' then
          time_trig_seconds_upper_reg <= wr_dat_d0(7 downto 0);
        end if;
        time_trig_seconds_upper_wack <= time_trig_seconds_upper_wreq;
      end if;
    end if;
  end process;

  -- Register time_trig_seconds_lower
  timetag_core_o.time_trig_seconds_lower <= time_trig_seconds_lower_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        time_trig_seconds_lower_reg <= "00000000000000000000000000000000";
        time_trig_seconds_lower_wack <= '0';
      else
        if time_trig_seconds_lower_wreq = '1' then
          time_trig_seconds_lower_reg <= wr_dat_d0;
        end if;
        time_trig_seconds_lower_wack <= time_trig_seconds_lower_wreq;
      end if;
    end if;
  end process;

  -- Register time_trig_coarse
  timetag_core_o.time_trig_coarse <= time_trig_coarse_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        time_trig_coarse_reg <= "0000000000000000000000000000";
        time_trig_coarse_wack <= '0';
      else
        if time_trig_coarse_wreq = '1' then
          time_trig_coarse_reg <= wr_dat_d0(27 downto 0);
        end if;
        time_trig_coarse_wack <= time_trig_coarse_wreq;
      end if;
    end if;
  end process;

  -- Register trig_tag_seconds_upper

  -- Register trig_tag_seconds_lower

  -- Register trig_tag_coarse

  -- Register acq_start_tag_seconds_upper

  -- Register acq_start_tag_seconds_lower

  -- Register acq_start_tag_coarse

  -- Register acq_stop_tag_seconds_upper

  -- Register acq_stop_tag_seconds_lower

  -- Register acq_stop_tag_coarse

  -- Register acq_end_tag_seconds_upper

  -- Register acq_end_tag_seconds_lower

  -- Register acq_end_tag_coarse

  -- Process for write requests.
  process (wr_adr_d0, wr_req_d0, time_trig_seconds_upper_wack, time_trig_seconds_lower_wack, time_trig_coarse_wack) begin
    seconds_upper_wreq <= '0';
    seconds_lower_wreq <= '0';
    coarse_wreq <= '0';
    time_trig_seconds_upper_wreq <= '0';
    time_trig_seconds_lower_wreq <= '0';
    time_trig_coarse_wreq <= '0';
    case wr_adr_d0(6 downto 2) is
    when "00000" =>
      -- Reg seconds_upper
      seconds_upper_wreq <= wr_req_d0;
      wr_ack_int <= wr_req_d0;
    when "00001" =>
      -- Reg seconds_lower
      seconds_lower_wreq <= wr_req_d0;
      wr_ack_int <= wr_req_d0;
    when "00010" =>
      -- Reg coarse
      coarse_wreq <= wr_req_d0;
      wr_ack_int <= wr_req_d0;
    when "00011" =>
      -- Reg time_trig_seconds_upper
      time_trig_seconds_upper_wreq <= wr_req_d0;
      wr_ack_int <= time_trig_seconds_upper_wack;
    when "00100" =>
      -- Reg time_trig_seconds_lower
      time_trig_seconds_lower_wreq <= wr_req_d0;
      wr_ack_int <= time_trig_seconds_lower_wack;
    when "00101" =>
      -- Reg time_trig_coarse
      time_trig_coarse_wreq <= wr_req_d0;
      wr_ack_int <= time_trig_coarse_wack;
    when "00110" =>
      -- Reg trig_tag_seconds_upper
      wr_ack_int <= wr_req_d0;
    when "00111" =>
      -- Reg trig_tag_seconds_lower
      wr_ack_int <= wr_req_d0;
    when "01000" =>
      -- Reg trig_tag_coarse
      wr_ack_int <= wr_req_d0;
    when "01001" =>
      -- Reg acq_start_tag_seconds_upper
      wr_ack_int <= wr_req_d0;
    when "01010" =>
      -- Reg acq_start_tag_seconds_lower
      wr_ack_int <= wr_req_d0;
    when "01011" =>
      -- Reg acq_start_tag_coarse
      wr_ack_int <= wr_req_d0;
    when "01100" =>
      -- Reg acq_stop_tag_seconds_upper
      wr_ack_int <= wr_req_d0;
    when "01101" =>
      -- Reg acq_stop_tag_seconds_lower
      wr_ack_int <= wr_req_d0;
    when "01110" =>
      -- Reg acq_stop_tag_coarse
      wr_ack_int <= wr_req_d0;
    when "01111" =>
      -- Reg acq_end_tag_seconds_upper
      wr_ack_int <= wr_req_d0;
    when "10000" =>
      -- Reg acq_end_tag_seconds_lower
      wr_ack_int <= wr_req_d0;
    when "10001" =>
      -- Reg acq_end_tag_coarse
      wr_ack_int <= wr_req_d0;
    when others =>
      wr_ack_int <= wr_req_d0;
    end case;
  end process;

  -- Process for read requests.
  process (adr_int, rd_req_int, timetag_core_i.seconds_upper, timetag_core_i.seconds_lower, timetag_core_i.coarse, time_trig_seconds_upper_reg, time_trig_seconds_lower_reg, time_trig_coarse_reg, timetag_core_i.trig_tag_seconds_upper, timetag_core_i.trig_tag_seconds_lower, timetag_core_i.trig_tag_coarse, timetag_core_i.acq_start_tag_seconds_upper, timetag_core_i.acq_start_tag_seconds_lower, timetag_core_i.acq_start_tag_coarse, timetag_core_i.acq_stop_tag_seconds_upper, timetag_core_i.acq_stop_tag_seconds_lower, timetag_core_i.acq_stop_tag_coarse, timetag_core_i.acq_end_tag_seconds_upper, timetag_core_i.acq_end_tag_seconds_lower, timetag_core_i.acq_end_tag_coarse) begin
    -- By default ack read requests
    rd_dat_d0 <= (others => 'X');
    case adr_int(6 downto 2) is
    when "00000" =>
      -- Reg seconds_upper
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(7 downto 0) <= timetag_core_i.seconds_upper;
      rd_dat_d0(31 downto 8) <= (others => '0');
    when "00001" =>
      -- Reg seconds_lower
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= timetag_core_i.seconds_lower;
    when "00010" =>
      -- Reg coarse
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(27 downto 0) <= timetag_core_i.coarse;
      rd_dat_d0(31 downto 28) <= (others => '0');
    when "00011" =>
      -- Reg time_trig_seconds_upper
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(7 downto 0) <= time_trig_seconds_upper_reg;
      rd_dat_d0(31 downto 8) <= (others => '0');
    when "00100" =>
      -- Reg time_trig_seconds_lower
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= time_trig_seconds_lower_reg;
    when "00101" =>
      -- Reg time_trig_coarse
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(27 downto 0) <= time_trig_coarse_reg;
      rd_dat_d0(31 downto 28) <= (others => '0');
    when "00110" =>
      -- Reg trig_tag_seconds_upper
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(7 downto 0) <= timetag_core_i.trig_tag_seconds_upper;
      rd_dat_d0(31 downto 8) <= (others => '0');
    when "00111" =>
      -- Reg trig_tag_seconds_lower
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= timetag_core_i.trig_tag_seconds_lower;
    when "01000" =>
      -- Reg trig_tag_coarse
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(27 downto 0) <= timetag_core_i.trig_tag_coarse;
      rd_dat_d0(31 downto 28) <= (others => '0');
    when "01001" =>
      -- Reg acq_start_tag_seconds_upper
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(7 downto 0) <= timetag_core_i.acq_start_tag_seconds_upper;
      rd_dat_d0(31 downto 8) <= (others => '0');
    when "01010" =>
      -- Reg acq_start_tag_seconds_lower
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= timetag_core_i.acq_start_tag_seconds_lower;
    when "01011" =>
      -- Reg acq_start_tag_coarse
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(27 downto 0) <= timetag_core_i.acq_start_tag_coarse;
      rd_dat_d0(31 downto 28) <= (others => '0');
    when "01100" =>
      -- Reg acq_stop_tag_seconds_upper
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(7 downto 0) <= timetag_core_i.acq_stop_tag_seconds_upper;
      rd_dat_d0(31 downto 8) <= (others => '0');
    when "01101" =>
      -- Reg acq_stop_tag_seconds_lower
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= timetag_core_i.acq_stop_tag_seconds_lower;
    when "01110" =>
      -- Reg acq_stop_tag_coarse
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(27 downto 0) <= timetag_core_i.acq_stop_tag_coarse;
      rd_dat_d0(31 downto 28) <= (others => '0');
    when "01111" =>
      -- Reg acq_end_tag_seconds_upper
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(7 downto 0) <= timetag_core_i.acq_end_tag_seconds_upper;
      rd_dat_d0(31 downto 8) <= (others => '0');
    when "10000" =>
      -- Reg acq_end_tag_seconds_lower
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= timetag_core_i.acq_end_tag_seconds_lower;
    when "10001" =>
      -- Reg acq_end_tag_coarse
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(27 downto 0) <= timetag_core_i.acq_end_tag_coarse;
      rd_dat_d0(31 downto 28) <= (others => '0');
    when others =>
      rd_ack_d0 <= rd_req_int;
    end case;
  end process;
end syn;
