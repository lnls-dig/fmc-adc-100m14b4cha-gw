-- Do not edit.  Generated on Wed Feb 03 09:41:32 2021 by lerwys
-- With Cheby 1.4.dev0 and these options:
--  -i spec_ref_fmc_adc_100Ms_mmap.cheby --gen-hdl=spec_ref_fmc_adc_100Ms_mmap.vhd


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wishbone_pkg.all;

entity spec_ref_fmc_adc_100m_mmap is
  port (
    rst_n_i              : in    std_logic;
    clk_i                : in    std_logic;
    wb_i                 : in    t_wishbone_slave_in;
    wb_o                 : out   t_wishbone_slave_out;

    -- a ROM containing the application metadata
    metadata_i           : in    t_wishbone_master_in;
    metadata_o           : out   t_wishbone_master_out;

    -- FMC ADC Mezzanine
    fmc_adc_mezzanine_i  : in    t_wishbone_master_in;
    fmc_adc_mezzanine_o  : out   t_wishbone_master_out
  );
end spec_ref_fmc_adc_100m_mmap;

architecture syn of spec_ref_fmc_adc_100m_mmap is
  signal adr_int                        : std_logic_vector(14 downto 2);
  signal rd_req_int                     : std_logic;
  signal wr_req_int                     : std_logic;
  signal rd_ack_int                     : std_logic;
  signal wr_ack_int                     : std_logic;
  signal wb_en                          : std_logic;
  signal ack_int                        : std_logic;
  signal wb_rip                         : std_logic;
  signal wb_wip                         : std_logic;
  signal metadata_re                    : std_logic;
  signal metadata_we                    : std_logic;
  signal metadata_wt                    : std_logic;
  signal metadata_rt                    : std_logic;
  signal metadata_tr                    : std_logic;
  signal metadata_wack                  : std_logic;
  signal metadata_rack                  : std_logic;
  signal fmc_adc_mezzanine_re           : std_logic;
  signal fmc_adc_mezzanine_we           : std_logic;
  signal fmc_adc_mezzanine_wt           : std_logic;
  signal fmc_adc_mezzanine_rt           : std_logic;
  signal fmc_adc_mezzanine_tr           : std_logic;
  signal fmc_adc_mezzanine_wack         : std_logic;
  signal fmc_adc_mezzanine_rack         : std_logic;
  signal rd_ack_d0                      : std_logic;
  signal rd_dat_d0                      : std_logic_vector(31 downto 0);
  signal wr_req_d0                      : std_logic;
  signal wr_adr_d0                      : std_logic_vector(14 downto 2);
  signal wr_dat_d0                      : std_logic_vector(31 downto 0);
  signal wr_sel_d0                      : std_logic_vector(3 downto 0);
begin

  -- WB decode signals
  adr_int <= wb_i.adr(14 downto 2);
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

  -- Interface metadata
  metadata_tr <= metadata_wt or metadata_rt;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        metadata_rt <= '0';
        metadata_wt <= '0';
      else
        metadata_rt <= (metadata_rt or metadata_re) and not metadata_rack;
        metadata_wt <= (metadata_wt or metadata_we) and not metadata_wack;
      end if;
    end if;
  end process;
  metadata_o.cyc <= metadata_tr;
  metadata_o.stb <= metadata_tr;
  metadata_wack <= metadata_i.ack and metadata_wt;
  metadata_rack <= metadata_i.ack and metadata_rt;
  metadata_o.adr <= ((25 downto 0 => '0') & adr_int(5 downto 2)) & (1 downto 0 => '0');
  metadata_o.sel <= wr_sel_d0;
  metadata_o.we <= metadata_wt;
  metadata_o.dat <= wr_dat_d0;

  -- Interface fmc_adc_mezzanine
  fmc_adc_mezzanine_tr <= fmc_adc_mezzanine_wt or fmc_adc_mezzanine_rt;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        fmc_adc_mezzanine_rt <= '0';
        fmc_adc_mezzanine_wt <= '0';
      else
        fmc_adc_mezzanine_rt <= (fmc_adc_mezzanine_rt or fmc_adc_mezzanine_re) and not fmc_adc_mezzanine_rack;
        fmc_adc_mezzanine_wt <= (fmc_adc_mezzanine_wt or fmc_adc_mezzanine_we) and not fmc_adc_mezzanine_wack;
      end if;
    end if;
  end process;
  fmc_adc_mezzanine_o.cyc <= fmc_adc_mezzanine_tr;
  fmc_adc_mezzanine_o.stb <= fmc_adc_mezzanine_tr;
  fmc_adc_mezzanine_wack <= fmc_adc_mezzanine_i.ack and fmc_adc_mezzanine_wt;
  fmc_adc_mezzanine_rack <= fmc_adc_mezzanine_i.ack and fmc_adc_mezzanine_rt;
  fmc_adc_mezzanine_o.adr <= ((18 downto 0 => '0') & adr_int(12 downto 2)) & (1 downto 0 => '0');
  fmc_adc_mezzanine_o.sel <= wr_sel_d0;
  fmc_adc_mezzanine_o.we <= fmc_adc_mezzanine_wt;
  fmc_adc_mezzanine_o.dat <= wr_dat_d0;

  -- Process for write requests.
  process (wr_adr_d0, wr_req_d0, metadata_wack, fmc_adc_mezzanine_wack) begin
    metadata_we <= '0';
    fmc_adc_mezzanine_we <= '0';
    case wr_adr_d0(14 downto 13) is
    when "01" =>
      -- Submap metadata
      metadata_we <= wr_req_d0;
      wr_ack_int <= metadata_wack;
    when "10" =>
      -- Submap fmc_adc_mezzanine
      fmc_adc_mezzanine_we <= wr_req_d0;
      wr_ack_int <= fmc_adc_mezzanine_wack;
    when others =>
      wr_ack_int <= wr_req_d0;
    end case;
  end process;

  -- Process for read requests.
  process (adr_int, rd_req_int, metadata_i.dat, metadata_rack, fmc_adc_mezzanine_i.dat, fmc_adc_mezzanine_rack) begin
    -- By default ack read requests
    rd_dat_d0 <= (others => 'X');
    metadata_re <= '0';
    fmc_adc_mezzanine_re <= '0';
    case adr_int(14 downto 13) is
    when "01" =>
      -- Submap metadata
      metadata_re <= rd_req_int;
      rd_dat_d0 <= metadata_i.dat;
      rd_ack_d0 <= metadata_rack;
    when "10" =>
      -- Submap fmc_adc_mezzanine
      fmc_adc_mezzanine_re <= rd_req_int;
      rd_dat_d0 <= fmc_adc_mezzanine_i.dat;
      rd_ack_d0 <= fmc_adc_mezzanine_rack;
    when others =>
      rd_ack_d0 <= rd_req_int;
    end case;
  end process;
end syn;
