-- Do not edit.  Generated on Wed Feb 03 09:41:35 2021 by lerwys
-- With Cheby 1.4.dev0 and these options:
--  -i fmc_adc_100Ms_csr.cheby --gen-hdl=fmc_adc_100Ms_csr.vhd


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wishbone_pkg.all;

package fmc_adc_100ms_csr_pkg is
  type t_fmc_adc_100ms_csr_master_out is record
    ctl_fsm_cmd      : std_logic_vector(1 downto 0);
    ctl_fmc_clk_oe   : std_logic;
    ctl_offset_dac_clr_n : std_logic;
    ctl_man_bitslip  : std_logic;
    ctl_test_data_en : std_logic;
    ctl_trig_led     : std_logic;
    ctl_acq_led      : std_logic;
    ctl_clear_trig_stat : std_logic;
    ctl_wr           : std_logic;
    trig_en_ext      : std_logic;
    trig_en_sw       : std_logic;
    trig_en_time     : std_logic;
    trig_en_aux_time : std_logic;
    trig_en_ch1      : std_logic;
    trig_en_ch2      : std_logic;
    trig_en_ch3      : std_logic;
    trig_en_ch4      : std_logic;
    trig_pol_ext     : std_logic;
    trig_pol_ch1     : std_logic;
    trig_pol_ch2     : std_logic;
    trig_pol_ch3     : std_logic;
    trig_pol_ch4     : std_logic;
    ext_trig_dly     : std_logic_vector(31 downto 0);
    sw_trig          : std_logic_vector(31 downto 0);
    sw_trig_wr       : std_logic;
    shots_nbr        : std_logic_vector(15 downto 0);
    shots_remain     : std_logic_vector(15 downto 0);
    downsample       : std_logic_vector(31 downto 0);
    pre_samples      : std_logic_vector(31 downto 0);
    post_samples     : std_logic_vector(31 downto 0);
    ch1_ctl_ssr      : std_logic_vector(6 downto 0);
    ch1_calib_gain   : std_logic_vector(15 downto 0);
    ch1_calib_offset : std_logic_vector(15 downto 0);
    ch1_sat_val      : std_logic_vector(14 downto 0);
    ch1_trig_thres_val : std_logic_vector(15 downto 0);
    ch1_trig_thres_hyst : std_logic_vector(15 downto 0);
    ch1_trig_dly     : std_logic_vector(31 downto 0);
    ch2_ctl_ssr      : std_logic_vector(6 downto 0);
    ch2_calib_gain   : std_logic_vector(15 downto 0);
    ch2_calib_offset : std_logic_vector(15 downto 0);
    ch2_sat_val      : std_logic_vector(14 downto 0);
    ch2_trig_thres_val : std_logic_vector(15 downto 0);
    ch2_trig_thres_hyst : std_logic_vector(15 downto 0);
    ch2_trig_dly     : std_logic_vector(31 downto 0);
    ch3_ctl_ssr      : std_logic_vector(6 downto 0);
    ch3_calib_gain   : std_logic_vector(15 downto 0);
    ch3_calib_offset : std_logic_vector(15 downto 0);
    ch3_sat_val      : std_logic_vector(14 downto 0);
    ch3_trig_thres_val : std_logic_vector(15 downto 0);
    ch3_trig_thres_hyst : std_logic_vector(15 downto 0);
    ch3_trig_dly     : std_logic_vector(31 downto 0);
    ch4_ctl_ssr      : std_logic_vector(6 downto 0);
    ch4_calib_gain   : std_logic_vector(15 downto 0);
    ch4_calib_offset : std_logic_vector(15 downto 0);
    ch4_sat_val      : std_logic_vector(14 downto 0);
    ch4_trig_thres_val : std_logic_vector(15 downto 0);
    ch4_trig_thres_hyst : std_logic_vector(15 downto 0);
    ch4_trig_dly     : std_logic_vector(31 downto 0);
  end record t_fmc_adc_100ms_csr_master_out;
  subtype t_fmc_adc_100ms_csr_slave_in is t_fmc_adc_100ms_csr_master_out;

  type t_fmc_adc_100ms_csr_slave_out is record
    ctl_fsm_cmd      : std_logic_vector(1 downto 0);
    ctl_man_bitslip  : std_logic;
    ctl_clear_trig_stat : std_logic;
    sta_fsm          : std_logic_vector(2 downto 0);
    sta_serdes_pll   : std_logic;
    sta_serdes_synced : std_logic;
    sta_acq_cfg      : std_logic;
    trig_stat_ext    : std_logic;
    trig_stat_sw     : std_logic;
    trig_stat_time   : std_logic;
    trig_stat_ch1    : std_logic;
    trig_stat_ch2    : std_logic;
    trig_stat_ch3    : std_logic;
    trig_stat_ch4    : std_logic;
    trig_en_sw       : std_logic;
    trig_en_aux_time : std_logic;
    shots_remain     : std_logic_vector(15 downto 0);
    multi_depth      : std_logic_vector(31 downto 0);
    trig_pos         : std_logic_vector(31 downto 0);
    fs_freq          : std_logic_vector(31 downto 0);
    samples_cnt      : std_logic_vector(31 downto 0);
    ch1_sta_val      : std_logic_vector(15 downto 0);
    ch2_sta_val      : std_logic_vector(15 downto 0);
    ch3_sta_val      : std_logic_vector(15 downto 0);
    ch4_sta_val      : std_logic_vector(15 downto 0);
  end record t_fmc_adc_100ms_csr_slave_out;
  subtype t_fmc_adc_100ms_csr_master_in is t_fmc_adc_100ms_csr_slave_out;
end fmc_adc_100ms_csr_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wishbone_pkg.all;
use work.fmc_adc_100ms_csr_pkg.all;

entity fmc_adc_100ms_csr is
  port (
    rst_n_i              : in    std_logic;
    clk_i                : in    std_logic;
    wb_i                 : in    t_wishbone_slave_in;
    wb_o                 : out   t_wishbone_slave_out;
    -- Wires and registers
    fmc_adc_100ms_csr_i  : in    t_fmc_adc_100ms_csr_master_in;
    fmc_adc_100ms_csr_o  : out   t_fmc_adc_100ms_csr_master_out
  );
end fmc_adc_100ms_csr;

architecture syn of fmc_adc_100ms_csr is
  signal adr_int                        : std_logic_vector(8 downto 2);
  signal rd_req_int                     : std_logic;
  signal wr_req_int                     : std_logic;
  signal rd_ack_int                     : std_logic;
  signal wr_ack_int                     : std_logic;
  signal wb_en                          : std_logic;
  signal ack_int                        : std_logic;
  signal wb_rip                         : std_logic;
  signal wb_wip                         : std_logic;
  signal ctl_fmc_clk_oe_reg             : std_logic;
  signal ctl_offset_dac_clr_n_reg       : std_logic;
  signal ctl_test_data_en_reg           : std_logic;
  signal ctl_trig_led_reg               : std_logic;
  signal ctl_acq_led_reg                : std_logic;
  signal ctl_wreq                       : std_logic;
  signal ctl_wack                       : std_logic;
  signal trig_en_ext_reg                : std_logic;
  signal trig_en_time_reg               : std_logic;
  signal trig_en_ch1_reg                : std_logic;
  signal trig_en_ch2_reg                : std_logic;
  signal trig_en_ch3_reg                : std_logic;
  signal trig_en_ch4_reg                : std_logic;
  signal trig_en_wreq                   : std_logic;
  signal trig_en_wack                   : std_logic;
  signal trig_pol_ext_reg               : std_logic;
  signal trig_pol_ch1_reg               : std_logic;
  signal trig_pol_ch2_reg               : std_logic;
  signal trig_pol_ch3_reg               : std_logic;
  signal trig_pol_ch4_reg               : std_logic;
  signal trig_pol_wreq                  : std_logic;
  signal trig_pol_wack                  : std_logic;
  signal ext_trig_dly_reg               : std_logic_vector(31 downto 0);
  signal ext_trig_dly_wreq              : std_logic;
  signal ext_trig_dly_wack              : std_logic;
  signal sw_trig_wreq                   : std_logic;
  signal shots_nbr_reg                  : std_logic_vector(15 downto 0);
  signal shots_wreq                     : std_logic;
  signal shots_wack                     : std_logic;
  signal downsample_reg                 : std_logic_vector(31 downto 0);
  signal downsample_wreq                : std_logic;
  signal downsample_wack                : std_logic;
  signal pre_samples_reg                : std_logic_vector(31 downto 0);
  signal pre_samples_wreq               : std_logic;
  signal pre_samples_wack               : std_logic;
  signal post_samples_reg               : std_logic_vector(31 downto 0);
  signal post_samples_wreq              : std_logic;
  signal post_samples_wack              : std_logic;
  signal ch1_ctl_ssr_reg                : std_logic_vector(6 downto 0);
  signal ch1_ctl_wreq                   : std_logic;
  signal ch1_ctl_wack                   : std_logic;
  signal ch1_calib_gain_reg             : std_logic_vector(15 downto 0);
  signal ch1_calib_offset_reg           : std_logic_vector(15 downto 0);
  signal ch1_calib_wreq                 : std_logic;
  signal ch1_calib_wack                 : std_logic;
  signal ch1_sat_val_reg                : std_logic_vector(14 downto 0);
  signal ch1_sat_wreq                   : std_logic;
  signal ch1_sat_wack                   : std_logic;
  signal ch1_trig_thres_val_reg         : std_logic_vector(15 downto 0);
  signal ch1_trig_thres_hyst_reg        : std_logic_vector(15 downto 0);
  signal ch1_trig_thres_wreq            : std_logic;
  signal ch1_trig_thres_wack            : std_logic;
  signal ch1_trig_dly_reg               : std_logic_vector(31 downto 0);
  signal ch1_trig_dly_wreq              : std_logic;
  signal ch1_trig_dly_wack              : std_logic;
  signal ch2_ctl_ssr_reg                : std_logic_vector(6 downto 0);
  signal ch2_ctl_wreq                   : std_logic;
  signal ch2_ctl_wack                   : std_logic;
  signal ch2_calib_gain_reg             : std_logic_vector(15 downto 0);
  signal ch2_calib_offset_reg           : std_logic_vector(15 downto 0);
  signal ch2_calib_wreq                 : std_logic;
  signal ch2_calib_wack                 : std_logic;
  signal ch2_sat_val_reg                : std_logic_vector(14 downto 0);
  signal ch2_sat_wreq                   : std_logic;
  signal ch2_sat_wack                   : std_logic;
  signal ch2_trig_thres_val_reg         : std_logic_vector(15 downto 0);
  signal ch2_trig_thres_hyst_reg        : std_logic_vector(15 downto 0);
  signal ch2_trig_thres_wreq            : std_logic;
  signal ch2_trig_thres_wack            : std_logic;
  signal ch2_trig_dly_reg               : std_logic_vector(31 downto 0);
  signal ch2_trig_dly_wreq              : std_logic;
  signal ch2_trig_dly_wack              : std_logic;
  signal ch3_ctl_ssr_reg                : std_logic_vector(6 downto 0);
  signal ch3_ctl_wreq                   : std_logic;
  signal ch3_ctl_wack                   : std_logic;
  signal ch3_calib_gain_reg             : std_logic_vector(15 downto 0);
  signal ch3_calib_offset_reg           : std_logic_vector(15 downto 0);
  signal ch3_calib_wreq                 : std_logic;
  signal ch3_calib_wack                 : std_logic;
  signal ch3_sat_val_reg                : std_logic_vector(14 downto 0);
  signal ch3_sat_wreq                   : std_logic;
  signal ch3_sat_wack                   : std_logic;
  signal ch3_trig_thres_val_reg         : std_logic_vector(15 downto 0);
  signal ch3_trig_thres_hyst_reg        : std_logic_vector(15 downto 0);
  signal ch3_trig_thres_wreq            : std_logic;
  signal ch3_trig_thres_wack            : std_logic;
  signal ch3_trig_dly_reg               : std_logic_vector(31 downto 0);
  signal ch3_trig_dly_wreq              : std_logic;
  signal ch3_trig_dly_wack              : std_logic;
  signal ch4_ctl_ssr_reg                : std_logic_vector(6 downto 0);
  signal ch4_ctl_wreq                   : std_logic;
  signal ch4_ctl_wack                   : std_logic;
  signal ch4_calib_gain_reg             : std_logic_vector(15 downto 0);
  signal ch4_calib_offset_reg           : std_logic_vector(15 downto 0);
  signal ch4_calib_wreq                 : std_logic;
  signal ch4_calib_wack                 : std_logic;
  signal ch4_sat_val_reg                : std_logic_vector(14 downto 0);
  signal ch4_sat_wreq                   : std_logic;
  signal ch4_sat_wack                   : std_logic;
  signal ch4_trig_thres_val_reg         : std_logic_vector(15 downto 0);
  signal ch4_trig_thres_hyst_reg        : std_logic_vector(15 downto 0);
  signal ch4_trig_thres_wreq            : std_logic;
  signal ch4_trig_thres_wack            : std_logic;
  signal ch4_trig_dly_reg               : std_logic_vector(31 downto 0);
  signal ch4_trig_dly_wreq              : std_logic;
  signal ch4_trig_dly_wack              : std_logic;
  signal rd_ack_d0                      : std_logic;
  signal rd_dat_d0                      : std_logic_vector(31 downto 0);
  signal wr_req_d0                      : std_logic;
  signal wr_adr_d0                      : std_logic_vector(8 downto 2);
  signal wr_dat_d0                      : std_logic_vector(31 downto 0);
  signal wr_sel_d0                      : std_logic_vector(3 downto 0);
begin

  -- WB decode signals
  adr_int <= wb_i.adr(8 downto 2);
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

  -- Register ctl
  fmc_adc_100ms_csr_o.ctl_fsm_cmd <= wr_dat_d0(1 downto 0);
  fmc_adc_100ms_csr_o.ctl_fmc_clk_oe <= ctl_fmc_clk_oe_reg;
  fmc_adc_100ms_csr_o.ctl_offset_dac_clr_n <= ctl_offset_dac_clr_n_reg;
  fmc_adc_100ms_csr_o.ctl_man_bitslip <= wr_dat_d0(4);
  fmc_adc_100ms_csr_o.ctl_test_data_en <= ctl_test_data_en_reg;
  fmc_adc_100ms_csr_o.ctl_trig_led <= ctl_trig_led_reg;
  fmc_adc_100ms_csr_o.ctl_acq_led <= ctl_acq_led_reg;
  fmc_adc_100ms_csr_o.ctl_clear_trig_stat <= wr_dat_d0(8);
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ctl_fmc_clk_oe_reg <= '0';
        ctl_offset_dac_clr_n_reg <= '0';
        ctl_test_data_en_reg <= '0';
        ctl_trig_led_reg <= '0';
        ctl_acq_led_reg <= '0';
        ctl_wack <= '0';
      else
        if ctl_wreq = '1' then
          ctl_fmc_clk_oe_reg <= wr_dat_d0(2);
          ctl_offset_dac_clr_n_reg <= wr_dat_d0(3);
          ctl_test_data_en_reg <= wr_dat_d0(5);
          ctl_trig_led_reg <= wr_dat_d0(6);
          ctl_acq_led_reg <= wr_dat_d0(7);
        end if;
        ctl_wack <= ctl_wreq;
      end if;
    end if;
  end process;
  fmc_adc_100ms_csr_o.ctl_wr <= ctl_wack;

  -- Register sta

  -- Register trig_stat

  -- Register trig_en
  fmc_adc_100ms_csr_o.trig_en_ext <= trig_en_ext_reg;
  fmc_adc_100ms_csr_o.trig_en_sw <= wr_dat_d0(1);
  fmc_adc_100ms_csr_o.trig_en_time <= trig_en_time_reg;
  fmc_adc_100ms_csr_o.trig_en_aux_time <= wr_dat_d0(5);
  fmc_adc_100ms_csr_o.trig_en_ch1 <= trig_en_ch1_reg;
  fmc_adc_100ms_csr_o.trig_en_ch2 <= trig_en_ch2_reg;
  fmc_adc_100ms_csr_o.trig_en_ch3 <= trig_en_ch3_reg;
  fmc_adc_100ms_csr_o.trig_en_ch4 <= trig_en_ch4_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        trig_en_ext_reg <= '0';
        trig_en_time_reg <= '0';
        trig_en_ch1_reg <= '0';
        trig_en_ch2_reg <= '0';
        trig_en_ch3_reg <= '0';
        trig_en_ch4_reg <= '0';
        trig_en_wack <= '0';
      else
        if trig_en_wreq = '1' then
          trig_en_ext_reg <= wr_dat_d0(0);
          trig_en_time_reg <= wr_dat_d0(4);
          trig_en_ch1_reg <= wr_dat_d0(8);
          trig_en_ch2_reg <= wr_dat_d0(9);
          trig_en_ch3_reg <= wr_dat_d0(10);
          trig_en_ch4_reg <= wr_dat_d0(11);
        end if;
        trig_en_wack <= trig_en_wreq;
      end if;
    end if;
  end process;

  -- Register trig_pol
  fmc_adc_100ms_csr_o.trig_pol_ext <= trig_pol_ext_reg;
  fmc_adc_100ms_csr_o.trig_pol_ch1 <= trig_pol_ch1_reg;
  fmc_adc_100ms_csr_o.trig_pol_ch2 <= trig_pol_ch2_reg;
  fmc_adc_100ms_csr_o.trig_pol_ch3 <= trig_pol_ch3_reg;
  fmc_adc_100ms_csr_o.trig_pol_ch4 <= trig_pol_ch4_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        trig_pol_ext_reg <= '0';
        trig_pol_ch1_reg <= '0';
        trig_pol_ch2_reg <= '0';
        trig_pol_ch3_reg <= '0';
        trig_pol_ch4_reg <= '0';
        trig_pol_wack <= '0';
      else
        if trig_pol_wreq = '1' then
          trig_pol_ext_reg <= wr_dat_d0(0);
          trig_pol_ch1_reg <= wr_dat_d0(8);
          trig_pol_ch2_reg <= wr_dat_d0(9);
          trig_pol_ch3_reg <= wr_dat_d0(10);
          trig_pol_ch4_reg <= wr_dat_d0(11);
        end if;
        trig_pol_wack <= trig_pol_wreq;
      end if;
    end if;
  end process;

  -- Register ext_trig_dly
  fmc_adc_100ms_csr_o.ext_trig_dly <= ext_trig_dly_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ext_trig_dly_reg <= "00000000000000000000000000000000";
        ext_trig_dly_wack <= '0';
      else
        if ext_trig_dly_wreq = '1' then
          ext_trig_dly_reg <= wr_dat_d0;
        end if;
        ext_trig_dly_wack <= ext_trig_dly_wreq;
      end if;
    end if;
  end process;

  -- Register sw_trig
  fmc_adc_100ms_csr_o.sw_trig <= wr_dat_d0;
  fmc_adc_100ms_csr_o.sw_trig_wr <= sw_trig_wreq;

  -- Register shots
  fmc_adc_100ms_csr_o.shots_nbr <= shots_nbr_reg;
  fmc_adc_100ms_csr_o.shots_remain <= wr_dat_d0(31 downto 16);
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        shots_nbr_reg <= "0000000000000000";
        shots_wack <= '0';
      else
        if shots_wreq = '1' then
          shots_nbr_reg <= wr_dat_d0(15 downto 0);
        end if;
        shots_wack <= shots_wreq;
      end if;
    end if;
  end process;

  -- Register multi_depth

  -- Register trig_pos

  -- Register fs_freq

  -- Register downsample
  fmc_adc_100ms_csr_o.downsample <= downsample_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        downsample_reg <= "00000000000000000000000000000000";
        downsample_wack <= '0';
      else
        if downsample_wreq = '1' then
          downsample_reg <= wr_dat_d0;
        end if;
        downsample_wack <= downsample_wreq;
      end if;
    end if;
  end process;

  -- Register pre_samples
  fmc_adc_100ms_csr_o.pre_samples <= pre_samples_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        pre_samples_reg <= "00000000000000000000000000000000";
        pre_samples_wack <= '0';
      else
        if pre_samples_wreq = '1' then
          pre_samples_reg <= wr_dat_d0;
        end if;
        pre_samples_wack <= pre_samples_wreq;
      end if;
    end if;
  end process;

  -- Register post_samples
  fmc_adc_100ms_csr_o.post_samples <= post_samples_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        post_samples_reg <= "00000000000000000000000000000000";
        post_samples_wack <= '0';
      else
        if post_samples_wreq = '1' then
          post_samples_reg <= wr_dat_d0;
        end if;
        post_samples_wack <= post_samples_wreq;
      end if;
    end if;
  end process;

  -- Register samples_cnt

  -- Register ch1_ctl
  fmc_adc_100ms_csr_o.ch1_ctl_ssr <= ch1_ctl_ssr_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch1_ctl_ssr_reg <= "0000000";
        ch1_ctl_wack <= '0';
      else
        if ch1_ctl_wreq = '1' then
          ch1_ctl_ssr_reg <= wr_dat_d0(6 downto 0);
        end if;
        ch1_ctl_wack <= ch1_ctl_wreq;
      end if;
    end if;
  end process;

  -- Register ch1_sta

  -- Register ch1_calib
  fmc_adc_100ms_csr_o.ch1_calib_gain <= ch1_calib_gain_reg;
  fmc_adc_100ms_csr_o.ch1_calib_offset <= ch1_calib_offset_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch1_calib_gain_reg <= "0000000000000000";
        ch1_calib_offset_reg <= "0000000000000000";
        ch1_calib_wack <= '0';
      else
        if ch1_calib_wreq = '1' then
          ch1_calib_gain_reg <= wr_dat_d0(15 downto 0);
          ch1_calib_offset_reg <= wr_dat_d0(31 downto 16);
        end if;
        ch1_calib_wack <= ch1_calib_wreq;
      end if;
    end if;
  end process;

  -- Register ch1_sat
  fmc_adc_100ms_csr_o.ch1_sat_val <= ch1_sat_val_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch1_sat_val_reg <= "000000000000000";
        ch1_sat_wack <= '0';
      else
        if ch1_sat_wreq = '1' then
          ch1_sat_val_reg <= wr_dat_d0(14 downto 0);
        end if;
        ch1_sat_wack <= ch1_sat_wreq;
      end if;
    end if;
  end process;

  -- Register ch1_trig_thres
  fmc_adc_100ms_csr_o.ch1_trig_thres_val <= ch1_trig_thres_val_reg;
  fmc_adc_100ms_csr_o.ch1_trig_thres_hyst <= ch1_trig_thres_hyst_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch1_trig_thres_val_reg <= "0000000000000000";
        ch1_trig_thres_hyst_reg <= "0000000000000000";
        ch1_trig_thres_wack <= '0';
      else
        if ch1_trig_thres_wreq = '1' then
          ch1_trig_thres_val_reg <= wr_dat_d0(15 downto 0);
          ch1_trig_thres_hyst_reg <= wr_dat_d0(31 downto 16);
        end if;
        ch1_trig_thres_wack <= ch1_trig_thres_wreq;
      end if;
    end if;
  end process;

  -- Register ch1_trig_dly
  fmc_adc_100ms_csr_o.ch1_trig_dly <= ch1_trig_dly_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch1_trig_dly_reg <= "00000000000000000000000000000000";
        ch1_trig_dly_wack <= '0';
      else
        if ch1_trig_dly_wreq = '1' then
          ch1_trig_dly_reg <= wr_dat_d0;
        end if;
        ch1_trig_dly_wack <= ch1_trig_dly_wreq;
      end if;
    end if;
  end process;

  -- Register ch2_ctl
  fmc_adc_100ms_csr_o.ch2_ctl_ssr <= ch2_ctl_ssr_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch2_ctl_ssr_reg <= "0000000";
        ch2_ctl_wack <= '0';
      else
        if ch2_ctl_wreq = '1' then
          ch2_ctl_ssr_reg <= wr_dat_d0(6 downto 0);
        end if;
        ch2_ctl_wack <= ch2_ctl_wreq;
      end if;
    end if;
  end process;

  -- Register ch2_sta

  -- Register ch2_calib
  fmc_adc_100ms_csr_o.ch2_calib_gain <= ch2_calib_gain_reg;
  fmc_adc_100ms_csr_o.ch2_calib_offset <= ch2_calib_offset_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch2_calib_gain_reg <= "0000000000000000";
        ch2_calib_offset_reg <= "0000000000000000";
        ch2_calib_wack <= '0';
      else
        if ch2_calib_wreq = '1' then
          ch2_calib_gain_reg <= wr_dat_d0(15 downto 0);
          ch2_calib_offset_reg <= wr_dat_d0(31 downto 16);
        end if;
        ch2_calib_wack <= ch2_calib_wreq;
      end if;
    end if;
  end process;

  -- Register ch2_sat
  fmc_adc_100ms_csr_o.ch2_sat_val <= ch2_sat_val_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch2_sat_val_reg <= "000000000000000";
        ch2_sat_wack <= '0';
      else
        if ch2_sat_wreq = '1' then
          ch2_sat_val_reg <= wr_dat_d0(14 downto 0);
        end if;
        ch2_sat_wack <= ch2_sat_wreq;
      end if;
    end if;
  end process;

  -- Register ch2_trig_thres
  fmc_adc_100ms_csr_o.ch2_trig_thres_val <= ch2_trig_thres_val_reg;
  fmc_adc_100ms_csr_o.ch2_trig_thres_hyst <= ch2_trig_thres_hyst_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch2_trig_thres_val_reg <= "0000000000000000";
        ch2_trig_thres_hyst_reg <= "0000000000000000";
        ch2_trig_thres_wack <= '0';
      else
        if ch2_trig_thres_wreq = '1' then
          ch2_trig_thres_val_reg <= wr_dat_d0(15 downto 0);
          ch2_trig_thres_hyst_reg <= wr_dat_d0(31 downto 16);
        end if;
        ch2_trig_thres_wack <= ch2_trig_thres_wreq;
      end if;
    end if;
  end process;

  -- Register ch2_trig_dly
  fmc_adc_100ms_csr_o.ch2_trig_dly <= ch2_trig_dly_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch2_trig_dly_reg <= "00000000000000000000000000000000";
        ch2_trig_dly_wack <= '0';
      else
        if ch2_trig_dly_wreq = '1' then
          ch2_trig_dly_reg <= wr_dat_d0;
        end if;
        ch2_trig_dly_wack <= ch2_trig_dly_wreq;
      end if;
    end if;
  end process;

  -- Register ch3_ctl
  fmc_adc_100ms_csr_o.ch3_ctl_ssr <= ch3_ctl_ssr_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch3_ctl_ssr_reg <= "0000000";
        ch3_ctl_wack <= '0';
      else
        if ch3_ctl_wreq = '1' then
          ch3_ctl_ssr_reg <= wr_dat_d0(6 downto 0);
        end if;
        ch3_ctl_wack <= ch3_ctl_wreq;
      end if;
    end if;
  end process;

  -- Register ch3_sta

  -- Register ch3_calib
  fmc_adc_100ms_csr_o.ch3_calib_gain <= ch3_calib_gain_reg;
  fmc_adc_100ms_csr_o.ch3_calib_offset <= ch3_calib_offset_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch3_calib_gain_reg <= "0000000000000000";
        ch3_calib_offset_reg <= "0000000000000000";
        ch3_calib_wack <= '0';
      else
        if ch3_calib_wreq = '1' then
          ch3_calib_gain_reg <= wr_dat_d0(15 downto 0);
          ch3_calib_offset_reg <= wr_dat_d0(31 downto 16);
        end if;
        ch3_calib_wack <= ch3_calib_wreq;
      end if;
    end if;
  end process;

  -- Register ch3_sat
  fmc_adc_100ms_csr_o.ch3_sat_val <= ch3_sat_val_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch3_sat_val_reg <= "000000000000000";
        ch3_sat_wack <= '0';
      else
        if ch3_sat_wreq = '1' then
          ch3_sat_val_reg <= wr_dat_d0(14 downto 0);
        end if;
        ch3_sat_wack <= ch3_sat_wreq;
      end if;
    end if;
  end process;

  -- Register ch3_trig_thres
  fmc_adc_100ms_csr_o.ch3_trig_thres_val <= ch3_trig_thres_val_reg;
  fmc_adc_100ms_csr_o.ch3_trig_thres_hyst <= ch3_trig_thres_hyst_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch3_trig_thres_val_reg <= "0000000000000000";
        ch3_trig_thres_hyst_reg <= "0000000000000000";
        ch3_trig_thres_wack <= '0';
      else
        if ch3_trig_thres_wreq = '1' then
          ch3_trig_thres_val_reg <= wr_dat_d0(15 downto 0);
          ch3_trig_thres_hyst_reg <= wr_dat_d0(31 downto 16);
        end if;
        ch3_trig_thres_wack <= ch3_trig_thres_wreq;
      end if;
    end if;
  end process;

  -- Register ch3_trig_dly
  fmc_adc_100ms_csr_o.ch3_trig_dly <= ch3_trig_dly_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch3_trig_dly_reg <= "00000000000000000000000000000000";
        ch3_trig_dly_wack <= '0';
      else
        if ch3_trig_dly_wreq = '1' then
          ch3_trig_dly_reg <= wr_dat_d0;
        end if;
        ch3_trig_dly_wack <= ch3_trig_dly_wreq;
      end if;
    end if;
  end process;

  -- Register ch4_ctl
  fmc_adc_100ms_csr_o.ch4_ctl_ssr <= ch4_ctl_ssr_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch4_ctl_ssr_reg <= "0000000";
        ch4_ctl_wack <= '0';
      else
        if ch4_ctl_wreq = '1' then
          ch4_ctl_ssr_reg <= wr_dat_d0(6 downto 0);
        end if;
        ch4_ctl_wack <= ch4_ctl_wreq;
      end if;
    end if;
  end process;

  -- Register ch4_sta

  -- Register ch4_calib
  fmc_adc_100ms_csr_o.ch4_calib_gain <= ch4_calib_gain_reg;
  fmc_adc_100ms_csr_o.ch4_calib_offset <= ch4_calib_offset_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch4_calib_gain_reg <= "0000000000000000";
        ch4_calib_offset_reg <= "0000000000000000";
        ch4_calib_wack <= '0';
      else
        if ch4_calib_wreq = '1' then
          ch4_calib_gain_reg <= wr_dat_d0(15 downto 0);
          ch4_calib_offset_reg <= wr_dat_d0(31 downto 16);
        end if;
        ch4_calib_wack <= ch4_calib_wreq;
      end if;
    end if;
  end process;

  -- Register ch4_sat
  fmc_adc_100ms_csr_o.ch4_sat_val <= ch4_sat_val_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch4_sat_val_reg <= "000000000000000";
        ch4_sat_wack <= '0';
      else
        if ch4_sat_wreq = '1' then
          ch4_sat_val_reg <= wr_dat_d0(14 downto 0);
        end if;
        ch4_sat_wack <= ch4_sat_wreq;
      end if;
    end if;
  end process;

  -- Register ch4_trig_thres
  fmc_adc_100ms_csr_o.ch4_trig_thres_val <= ch4_trig_thres_val_reg;
  fmc_adc_100ms_csr_o.ch4_trig_thres_hyst <= ch4_trig_thres_hyst_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch4_trig_thres_val_reg <= "0000000000000000";
        ch4_trig_thres_hyst_reg <= "0000000000000000";
        ch4_trig_thres_wack <= '0';
      else
        if ch4_trig_thres_wreq = '1' then
          ch4_trig_thres_val_reg <= wr_dat_d0(15 downto 0);
          ch4_trig_thres_hyst_reg <= wr_dat_d0(31 downto 16);
        end if;
        ch4_trig_thres_wack <= ch4_trig_thres_wreq;
      end if;
    end if;
  end process;

  -- Register ch4_trig_dly
  fmc_adc_100ms_csr_o.ch4_trig_dly <= ch4_trig_dly_reg;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ch4_trig_dly_reg <= "00000000000000000000000000000000";
        ch4_trig_dly_wack <= '0';
      else
        if ch4_trig_dly_wreq = '1' then
          ch4_trig_dly_reg <= wr_dat_d0;
        end if;
        ch4_trig_dly_wack <= ch4_trig_dly_wreq;
      end if;
    end if;
  end process;

  -- Process for write requests.
  process (wr_adr_d0, wr_req_d0, ctl_wack, trig_en_wack, trig_pol_wack, ext_trig_dly_wack, shots_wack, downsample_wack, pre_samples_wack, post_samples_wack, ch1_ctl_wack, ch1_calib_wack, ch1_sat_wack, ch1_trig_thres_wack, ch1_trig_dly_wack, ch2_ctl_wack, ch2_calib_wack, ch2_sat_wack, ch2_trig_thres_wack, ch2_trig_dly_wack, ch3_ctl_wack, ch3_calib_wack, ch3_sat_wack, ch3_trig_thres_wack, ch3_trig_dly_wack, ch4_ctl_wack, ch4_calib_wack, ch4_sat_wack, ch4_trig_thres_wack, ch4_trig_dly_wack) begin
    ctl_wreq <= '0';
    trig_en_wreq <= '0';
    trig_pol_wreq <= '0';
    ext_trig_dly_wreq <= '0';
    sw_trig_wreq <= '0';
    shots_wreq <= '0';
    downsample_wreq <= '0';
    pre_samples_wreq <= '0';
    post_samples_wreq <= '0';
    ch1_ctl_wreq <= '0';
    ch1_calib_wreq <= '0';
    ch1_sat_wreq <= '0';
    ch1_trig_thres_wreq <= '0';
    ch1_trig_dly_wreq <= '0';
    ch2_ctl_wreq <= '0';
    ch2_calib_wreq <= '0';
    ch2_sat_wreq <= '0';
    ch2_trig_thres_wreq <= '0';
    ch2_trig_dly_wreq <= '0';
    ch3_ctl_wreq <= '0';
    ch3_calib_wreq <= '0';
    ch3_sat_wreq <= '0';
    ch3_trig_thres_wreq <= '0';
    ch3_trig_dly_wreq <= '0';
    ch4_ctl_wreq <= '0';
    ch4_calib_wreq <= '0';
    ch4_sat_wreq <= '0';
    ch4_trig_thres_wreq <= '0';
    ch4_trig_dly_wreq <= '0';
    case wr_adr_d0(8 downto 2) is
    when "0000000" =>
      -- Reg ctl
      ctl_wreq <= wr_req_d0;
      wr_ack_int <= ctl_wack;
    when "0000001" =>
      -- Reg sta
      wr_ack_int <= wr_req_d0;
    when "0000010" =>
      -- Reg trig_stat
      wr_ack_int <= wr_req_d0;
    when "0000011" =>
      -- Reg trig_en
      trig_en_wreq <= wr_req_d0;
      wr_ack_int <= trig_en_wack;
    when "0000100" =>
      -- Reg trig_pol
      trig_pol_wreq <= wr_req_d0;
      wr_ack_int <= trig_pol_wack;
    when "0000101" =>
      -- Reg ext_trig_dly
      ext_trig_dly_wreq <= wr_req_d0;
      wr_ack_int <= ext_trig_dly_wack;
    when "0000110" =>
      -- Reg sw_trig
      sw_trig_wreq <= wr_req_d0;
      wr_ack_int <= wr_req_d0;
    when "0000111" =>
      -- Reg shots
      shots_wreq <= wr_req_d0;
      wr_ack_int <= shots_wack;
    when "0001000" =>
      -- Reg multi_depth
      wr_ack_int <= wr_req_d0;
    when "0001001" =>
      -- Reg trig_pos
      wr_ack_int <= wr_req_d0;
    when "0001010" =>
      -- Reg fs_freq
      wr_ack_int <= wr_req_d0;
    when "0001011" =>
      -- Reg downsample
      downsample_wreq <= wr_req_d0;
      wr_ack_int <= downsample_wack;
    when "0001100" =>
      -- Reg pre_samples
      pre_samples_wreq <= wr_req_d0;
      wr_ack_int <= pre_samples_wack;
    when "0001101" =>
      -- Reg post_samples
      post_samples_wreq <= wr_req_d0;
      wr_ack_int <= post_samples_wack;
    when "0001110" =>
      -- Reg samples_cnt
      wr_ack_int <= wr_req_d0;
    when "0100000" =>
      -- Reg ch1_ctl
      ch1_ctl_wreq <= wr_req_d0;
      wr_ack_int <= ch1_ctl_wack;
    when "0100001" =>
      -- Reg ch1_sta
      wr_ack_int <= wr_req_d0;
    when "0100010" =>
      -- Reg ch1_calib
      ch1_calib_wreq <= wr_req_d0;
      wr_ack_int <= ch1_calib_wack;
    when "0100011" =>
      -- Reg ch1_sat
      ch1_sat_wreq <= wr_req_d0;
      wr_ack_int <= ch1_sat_wack;
    when "0100100" =>
      -- Reg ch1_trig_thres
      ch1_trig_thres_wreq <= wr_req_d0;
      wr_ack_int <= ch1_trig_thres_wack;
    when "0100101" =>
      -- Reg ch1_trig_dly
      ch1_trig_dly_wreq <= wr_req_d0;
      wr_ack_int <= ch1_trig_dly_wack;
    when "0110000" =>
      -- Reg ch2_ctl
      ch2_ctl_wreq <= wr_req_d0;
      wr_ack_int <= ch2_ctl_wack;
    when "0110001" =>
      -- Reg ch2_sta
      wr_ack_int <= wr_req_d0;
    when "0110010" =>
      -- Reg ch2_calib
      ch2_calib_wreq <= wr_req_d0;
      wr_ack_int <= ch2_calib_wack;
    when "0110011" =>
      -- Reg ch2_sat
      ch2_sat_wreq <= wr_req_d0;
      wr_ack_int <= ch2_sat_wack;
    when "0110100" =>
      -- Reg ch2_trig_thres
      ch2_trig_thres_wreq <= wr_req_d0;
      wr_ack_int <= ch2_trig_thres_wack;
    when "0110101" =>
      -- Reg ch2_trig_dly
      ch2_trig_dly_wreq <= wr_req_d0;
      wr_ack_int <= ch2_trig_dly_wack;
    when "1000000" =>
      -- Reg ch3_ctl
      ch3_ctl_wreq <= wr_req_d0;
      wr_ack_int <= ch3_ctl_wack;
    when "1000001" =>
      -- Reg ch3_sta
      wr_ack_int <= wr_req_d0;
    when "1000010" =>
      -- Reg ch3_calib
      ch3_calib_wreq <= wr_req_d0;
      wr_ack_int <= ch3_calib_wack;
    when "1000011" =>
      -- Reg ch3_sat
      ch3_sat_wreq <= wr_req_d0;
      wr_ack_int <= ch3_sat_wack;
    when "1000100" =>
      -- Reg ch3_trig_thres
      ch3_trig_thres_wreq <= wr_req_d0;
      wr_ack_int <= ch3_trig_thres_wack;
    when "1000101" =>
      -- Reg ch3_trig_dly
      ch3_trig_dly_wreq <= wr_req_d0;
      wr_ack_int <= ch3_trig_dly_wack;
    when "1010000" =>
      -- Reg ch4_ctl
      ch4_ctl_wreq <= wr_req_d0;
      wr_ack_int <= ch4_ctl_wack;
    when "1010001" =>
      -- Reg ch4_sta
      wr_ack_int <= wr_req_d0;
    when "1010010" =>
      -- Reg ch4_calib
      ch4_calib_wreq <= wr_req_d0;
      wr_ack_int <= ch4_calib_wack;
    when "1010011" =>
      -- Reg ch4_sat
      ch4_sat_wreq <= wr_req_d0;
      wr_ack_int <= ch4_sat_wack;
    when "1010100" =>
      -- Reg ch4_trig_thres
      ch4_trig_thres_wreq <= wr_req_d0;
      wr_ack_int <= ch4_trig_thres_wack;
    when "1010101" =>
      -- Reg ch4_trig_dly
      ch4_trig_dly_wreq <= wr_req_d0;
      wr_ack_int <= ch4_trig_dly_wack;
    when others =>
      wr_ack_int <= wr_req_d0;
    end case;
  end process;

  -- Process for read requests.
  process (adr_int, rd_req_int, fmc_adc_100ms_csr_i.ctl_fsm_cmd, ctl_fmc_clk_oe_reg, ctl_offset_dac_clr_n_reg, fmc_adc_100ms_csr_i.ctl_man_bitslip, ctl_test_data_en_reg, ctl_trig_led_reg, ctl_acq_led_reg, fmc_adc_100ms_csr_i.ctl_clear_trig_stat, fmc_adc_100ms_csr_i.sta_fsm, fmc_adc_100ms_csr_i.sta_serdes_pll, fmc_adc_100ms_csr_i.sta_serdes_synced, fmc_adc_100ms_csr_i.sta_acq_cfg, fmc_adc_100ms_csr_i.trig_stat_ext, fmc_adc_100ms_csr_i.trig_stat_sw, fmc_adc_100ms_csr_i.trig_stat_time, fmc_adc_100ms_csr_i.trig_stat_ch1, fmc_adc_100ms_csr_i.trig_stat_ch2, fmc_adc_100ms_csr_i.trig_stat_ch3, fmc_adc_100ms_csr_i.trig_stat_ch4, trig_en_ext_reg, fmc_adc_100ms_csr_i.trig_en_sw, trig_en_time_reg, fmc_adc_100ms_csr_i.trig_en_aux_time, trig_en_ch1_reg, trig_en_ch2_reg, trig_en_ch3_reg, trig_en_ch4_reg, trig_pol_ext_reg, trig_pol_ch1_reg, trig_pol_ch2_reg, trig_pol_ch3_reg, trig_pol_ch4_reg, ext_trig_dly_reg, shots_nbr_reg, fmc_adc_100ms_csr_i.shots_remain, fmc_adc_100ms_csr_i.multi_depth, fmc_adc_100ms_csr_i.trig_pos, fmc_adc_100ms_csr_i.fs_freq, downsample_reg, pre_samples_reg, post_samples_reg, fmc_adc_100ms_csr_i.samples_cnt, ch1_ctl_ssr_reg, fmc_adc_100ms_csr_i.ch1_sta_val, ch1_calib_gain_reg, ch1_calib_offset_reg, ch1_sat_val_reg, ch1_trig_thres_val_reg, ch1_trig_thres_hyst_reg, ch1_trig_dly_reg, ch2_ctl_ssr_reg, fmc_adc_100ms_csr_i.ch2_sta_val, ch2_calib_gain_reg, ch2_calib_offset_reg, ch2_sat_val_reg, ch2_trig_thres_val_reg, ch2_trig_thres_hyst_reg, ch2_trig_dly_reg, ch3_ctl_ssr_reg, fmc_adc_100ms_csr_i.ch3_sta_val, ch3_calib_gain_reg, ch3_calib_offset_reg, ch3_sat_val_reg, ch3_trig_thres_val_reg, ch3_trig_thres_hyst_reg, ch3_trig_dly_reg, ch4_ctl_ssr_reg, fmc_adc_100ms_csr_i.ch4_sta_val, ch4_calib_gain_reg, ch4_calib_offset_reg, ch4_sat_val_reg, ch4_trig_thres_val_reg, ch4_trig_thres_hyst_reg, ch4_trig_dly_reg) begin
    -- By default ack read requests
    rd_dat_d0 <= (others => 'X');
    case adr_int(8 downto 2) is
    when "0000000" =>
      -- Reg ctl
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(1 downto 0) <= fmc_adc_100ms_csr_i.ctl_fsm_cmd;
      rd_dat_d0(2) <= ctl_fmc_clk_oe_reg;
      rd_dat_d0(3) <= ctl_offset_dac_clr_n_reg;
      rd_dat_d0(4) <= fmc_adc_100ms_csr_i.ctl_man_bitslip;
      rd_dat_d0(5) <= ctl_test_data_en_reg;
      rd_dat_d0(6) <= ctl_trig_led_reg;
      rd_dat_d0(7) <= ctl_acq_led_reg;
      rd_dat_d0(8) <= fmc_adc_100ms_csr_i.ctl_clear_trig_stat;
      rd_dat_d0(31 downto 9) <= (others => '0');
    when "0000001" =>
      -- Reg sta
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(2 downto 0) <= fmc_adc_100ms_csr_i.sta_fsm;
      rd_dat_d0(3) <= fmc_adc_100ms_csr_i.sta_serdes_pll;
      rd_dat_d0(4) <= fmc_adc_100ms_csr_i.sta_serdes_synced;
      rd_dat_d0(5) <= fmc_adc_100ms_csr_i.sta_acq_cfg;
      rd_dat_d0(31 downto 6) <= (others => '0');
    when "0000010" =>
      -- Reg trig_stat
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(0) <= fmc_adc_100ms_csr_i.trig_stat_ext;
      rd_dat_d0(1) <= fmc_adc_100ms_csr_i.trig_stat_sw;
      rd_dat_d0(3 downto 2) <= (others => '0');
      rd_dat_d0(4) <= fmc_adc_100ms_csr_i.trig_stat_time;
      rd_dat_d0(7 downto 5) <= (others => '0');
      rd_dat_d0(8) <= fmc_adc_100ms_csr_i.trig_stat_ch1;
      rd_dat_d0(9) <= fmc_adc_100ms_csr_i.trig_stat_ch2;
      rd_dat_d0(10) <= fmc_adc_100ms_csr_i.trig_stat_ch3;
      rd_dat_d0(11) <= fmc_adc_100ms_csr_i.trig_stat_ch4;
      rd_dat_d0(31 downto 12) <= (others => '0');
    when "0000011" =>
      -- Reg trig_en
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(0) <= trig_en_ext_reg;
      rd_dat_d0(1) <= fmc_adc_100ms_csr_i.trig_en_sw;
      rd_dat_d0(3 downto 2) <= (others => '0');
      rd_dat_d0(4) <= trig_en_time_reg;
      rd_dat_d0(5) <= fmc_adc_100ms_csr_i.trig_en_aux_time;
      rd_dat_d0(7 downto 6) <= (others => '0');
      rd_dat_d0(8) <= trig_en_ch1_reg;
      rd_dat_d0(9) <= trig_en_ch2_reg;
      rd_dat_d0(10) <= trig_en_ch3_reg;
      rd_dat_d0(11) <= trig_en_ch4_reg;
      rd_dat_d0(31 downto 12) <= (others => '0');
    when "0000100" =>
      -- Reg trig_pol
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(0) <= trig_pol_ext_reg;
      rd_dat_d0(7 downto 1) <= (others => '0');
      rd_dat_d0(8) <= trig_pol_ch1_reg;
      rd_dat_d0(9) <= trig_pol_ch2_reg;
      rd_dat_d0(10) <= trig_pol_ch3_reg;
      rd_dat_d0(11) <= trig_pol_ch4_reg;
      rd_dat_d0(31 downto 12) <= (others => '0');
    when "0000101" =>
      -- Reg ext_trig_dly
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= ext_trig_dly_reg;
    when "0000110" =>
      -- Reg sw_trig
      rd_ack_d0 <= rd_req_int;
    when "0000111" =>
      -- Reg shots
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= shots_nbr_reg;
      rd_dat_d0(31 downto 16) <= fmc_adc_100ms_csr_i.shots_remain;
    when "0001000" =>
      -- Reg multi_depth
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= fmc_adc_100ms_csr_i.multi_depth;
    when "0001001" =>
      -- Reg trig_pos
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= fmc_adc_100ms_csr_i.trig_pos;
    when "0001010" =>
      -- Reg fs_freq
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= fmc_adc_100ms_csr_i.fs_freq;
    when "0001011" =>
      -- Reg downsample
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= downsample_reg;
    when "0001100" =>
      -- Reg pre_samples
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= pre_samples_reg;
    when "0001101" =>
      -- Reg post_samples
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= post_samples_reg;
    when "0001110" =>
      -- Reg samples_cnt
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= fmc_adc_100ms_csr_i.samples_cnt;
    when "0100000" =>
      -- Reg ch1_ctl
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(6 downto 0) <= ch1_ctl_ssr_reg;
      rd_dat_d0(31 downto 7) <= (others => '0');
    when "0100001" =>
      -- Reg ch1_sta
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= fmc_adc_100ms_csr_i.ch1_sta_val;
      rd_dat_d0(31 downto 16) <= (others => '0');
    when "0100010" =>
      -- Reg ch1_calib
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= ch1_calib_gain_reg;
      rd_dat_d0(31 downto 16) <= ch1_calib_offset_reg;
    when "0100011" =>
      -- Reg ch1_sat
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(14 downto 0) <= ch1_sat_val_reg;
      rd_dat_d0(31 downto 15) <= (others => '0');
    when "0100100" =>
      -- Reg ch1_trig_thres
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= ch1_trig_thres_val_reg;
      rd_dat_d0(31 downto 16) <= ch1_trig_thres_hyst_reg;
    when "0100101" =>
      -- Reg ch1_trig_dly
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= ch1_trig_dly_reg;
    when "0110000" =>
      -- Reg ch2_ctl
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(6 downto 0) <= ch2_ctl_ssr_reg;
      rd_dat_d0(31 downto 7) <= (others => '0');
    when "0110001" =>
      -- Reg ch2_sta
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= fmc_adc_100ms_csr_i.ch2_sta_val;
      rd_dat_d0(31 downto 16) <= (others => '0');
    when "0110010" =>
      -- Reg ch2_calib
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= ch2_calib_gain_reg;
      rd_dat_d0(31 downto 16) <= ch2_calib_offset_reg;
    when "0110011" =>
      -- Reg ch2_sat
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(14 downto 0) <= ch2_sat_val_reg;
      rd_dat_d0(31 downto 15) <= (others => '0');
    when "0110100" =>
      -- Reg ch2_trig_thres
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= ch2_trig_thres_val_reg;
      rd_dat_d0(31 downto 16) <= ch2_trig_thres_hyst_reg;
    when "0110101" =>
      -- Reg ch2_trig_dly
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= ch2_trig_dly_reg;
    when "1000000" =>
      -- Reg ch3_ctl
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(6 downto 0) <= ch3_ctl_ssr_reg;
      rd_dat_d0(31 downto 7) <= (others => '0');
    when "1000001" =>
      -- Reg ch3_sta
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= fmc_adc_100ms_csr_i.ch3_sta_val;
      rd_dat_d0(31 downto 16) <= (others => '0');
    when "1000010" =>
      -- Reg ch3_calib
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= ch3_calib_gain_reg;
      rd_dat_d0(31 downto 16) <= ch3_calib_offset_reg;
    when "1000011" =>
      -- Reg ch3_sat
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(14 downto 0) <= ch3_sat_val_reg;
      rd_dat_d0(31 downto 15) <= (others => '0');
    when "1000100" =>
      -- Reg ch3_trig_thres
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= ch3_trig_thres_val_reg;
      rd_dat_d0(31 downto 16) <= ch3_trig_thres_hyst_reg;
    when "1000101" =>
      -- Reg ch3_trig_dly
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= ch3_trig_dly_reg;
    when "1010000" =>
      -- Reg ch4_ctl
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(6 downto 0) <= ch4_ctl_ssr_reg;
      rd_dat_d0(31 downto 7) <= (others => '0');
    when "1010001" =>
      -- Reg ch4_sta
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= fmc_adc_100ms_csr_i.ch4_sta_val;
      rd_dat_d0(31 downto 16) <= (others => '0');
    when "1010010" =>
      -- Reg ch4_calib
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= ch4_calib_gain_reg;
      rd_dat_d0(31 downto 16) <= ch4_calib_offset_reg;
    when "1010011" =>
      -- Reg ch4_sat
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(14 downto 0) <= ch4_sat_val_reg;
      rd_dat_d0(31 downto 15) <= (others => '0');
    when "1010100" =>
      -- Reg ch4_trig_thres
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0(15 downto 0) <= ch4_trig_thres_val_reg;
      rd_dat_d0(31 downto 16) <= ch4_trig_thres_hyst_reg;
    when "1010101" =>
      -- Reg ch4_trig_dly
      rd_ack_d0 <= rd_req_int;
      rd_dat_d0 <= ch4_trig_dly_reg;
    when others =>
      rd_ack_d0 <= rd_req_int;
    end case;
  end process;
end syn;
