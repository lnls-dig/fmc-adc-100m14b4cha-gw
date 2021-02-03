-- Do not edit.  Generated on Wed Feb 03 09:41:33 2021 by lerwys
-- With Cheby 1.4.dev0 and these options:
--  -i fmc_adc_mezzanine_mmap.cheby --gen-hdl=fmc_adc_mezzanine_mmap.vhd


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wishbone_pkg.all;

entity fmc_adc_mezzanine_mmap is
  port (
    rst_n_i              : in    std_logic;
    clk_i                : in    std_logic;
    wb_i                 : in    t_wishbone_slave_in;
    wb_o                 : out   t_wishbone_slave_out;

    -- FMC ADC 100M CSR
    fmc_adc_100m_csr_i   : in    t_wishbone_master_in;
    fmc_adc_100m_csr_o   : out   t_wishbone_master_out;

    -- FMC ADC Embedded Interrupt Controller
    fmc_adc_eic_i        : in    t_wishbone_master_in;
    fmc_adc_eic_o        : out   t_wishbone_master_out;

    -- Si570 control I2C master
    si570_i2c_master_i   : in    t_wishbone_master_in;
    si570_i2c_master_o   : out   t_wishbone_master_out;

    -- DS18B20 OneWire master
    ds18b20_onewire_master_i : in    t_wishbone_master_in;
    ds18b20_onewire_master_o : out   t_wishbone_master_out;

    -- Mezzanine SPI master (ADC control + DAC offsets)
    fmc_spi_master_i     : in    t_wishbone_master_in;
    fmc_spi_master_o     : out   t_wishbone_master_out;

    -- Timetag Core
    timetag_core_i       : in    t_wishbone_master_in;
    timetag_core_o       : out   t_wishbone_master_out
  );
end fmc_adc_mezzanine_mmap;

architecture syn of fmc_adc_mezzanine_mmap is
  signal adr_int                        : std_logic_vector(12 downto 2);
  signal rd_req_int                     : std_logic;
  signal wr_req_int                     : std_logic;
  signal rd_ack_int                     : std_logic;
  signal wr_ack_int                     : std_logic;
  signal wb_en                          : std_logic;
  signal ack_int                        : std_logic;
  signal wb_rip                         : std_logic;
  signal wb_wip                         : std_logic;
  signal fmc_adc_100m_csr_re            : std_logic;
  signal fmc_adc_100m_csr_we            : std_logic;
  signal fmc_adc_100m_csr_wt            : std_logic;
  signal fmc_adc_100m_csr_rt            : std_logic;
  signal fmc_adc_100m_csr_tr            : std_logic;
  signal fmc_adc_100m_csr_wack          : std_logic;
  signal fmc_adc_100m_csr_rack          : std_logic;
  signal fmc_adc_eic_re                 : std_logic;
  signal fmc_adc_eic_we                 : std_logic;
  signal fmc_adc_eic_wt                 : std_logic;
  signal fmc_adc_eic_rt                 : std_logic;
  signal fmc_adc_eic_tr                 : std_logic;
  signal fmc_adc_eic_wack               : std_logic;
  signal fmc_adc_eic_rack               : std_logic;
  signal si570_i2c_master_re            : std_logic;
  signal si570_i2c_master_we            : std_logic;
  signal si570_i2c_master_wt            : std_logic;
  signal si570_i2c_master_rt            : std_logic;
  signal si570_i2c_master_tr            : std_logic;
  signal si570_i2c_master_wack          : std_logic;
  signal si570_i2c_master_rack          : std_logic;
  signal ds18b20_onewire_master_re      : std_logic;
  signal ds18b20_onewire_master_we      : std_logic;
  signal ds18b20_onewire_master_wt      : std_logic;
  signal ds18b20_onewire_master_rt      : std_logic;
  signal ds18b20_onewire_master_tr      : std_logic;
  signal ds18b20_onewire_master_wack    : std_logic;
  signal ds18b20_onewire_master_rack    : std_logic;
  signal fmc_spi_master_re              : std_logic;
  signal fmc_spi_master_we              : std_logic;
  signal fmc_spi_master_wt              : std_logic;
  signal fmc_spi_master_rt              : std_logic;
  signal fmc_spi_master_tr              : std_logic;
  signal fmc_spi_master_wack            : std_logic;
  signal fmc_spi_master_rack            : std_logic;
  signal timetag_core_re                : std_logic;
  signal timetag_core_we                : std_logic;
  signal timetag_core_wt                : std_logic;
  signal timetag_core_rt                : std_logic;
  signal timetag_core_tr                : std_logic;
  signal timetag_core_wack              : std_logic;
  signal timetag_core_rack              : std_logic;
  signal rd_ack_d0                      : std_logic;
  signal rd_dat_d0                      : std_logic_vector(31 downto 0);
  signal wr_req_d0                      : std_logic;
  signal wr_adr_d0                      : std_logic_vector(12 downto 2);
  signal wr_dat_d0                      : std_logic_vector(31 downto 0);
  signal wr_sel_d0                      : std_logic_vector(3 downto 0);
begin

  -- WB decode signals
  adr_int <= wb_i.adr(12 downto 2);
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

  -- Interface fmc_adc_100m_csr
  fmc_adc_100m_csr_tr <= fmc_adc_100m_csr_wt or fmc_adc_100m_csr_rt;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        fmc_adc_100m_csr_rt <= '0';
        fmc_adc_100m_csr_wt <= '0';
      else
        fmc_adc_100m_csr_rt <= (fmc_adc_100m_csr_rt or fmc_adc_100m_csr_re) and not fmc_adc_100m_csr_rack;
        fmc_adc_100m_csr_wt <= (fmc_adc_100m_csr_wt or fmc_adc_100m_csr_we) and not fmc_adc_100m_csr_wack;
      end if;
    end if;
  end process;
  fmc_adc_100m_csr_o.cyc <= fmc_adc_100m_csr_tr;
  fmc_adc_100m_csr_o.stb <= fmc_adc_100m_csr_tr;
  fmc_adc_100m_csr_wack <= fmc_adc_100m_csr_i.ack and fmc_adc_100m_csr_wt;
  fmc_adc_100m_csr_rack <= fmc_adc_100m_csr_i.ack and fmc_adc_100m_csr_rt;
  fmc_adc_100m_csr_o.adr <= ((22 downto 0 => '0') & adr_int(8 downto 2)) & (1 downto 0 => '0');
  fmc_adc_100m_csr_o.sel <= wr_sel_d0;
  fmc_adc_100m_csr_o.we <= fmc_adc_100m_csr_wt;
  fmc_adc_100m_csr_o.dat <= wr_dat_d0;

  -- Interface fmc_adc_eic
  fmc_adc_eic_tr <= fmc_adc_eic_wt or fmc_adc_eic_rt;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        fmc_adc_eic_rt <= '0';
        fmc_adc_eic_wt <= '0';
      else
        fmc_adc_eic_rt <= (fmc_adc_eic_rt or fmc_adc_eic_re) and not fmc_adc_eic_rack;
        fmc_adc_eic_wt <= (fmc_adc_eic_wt or fmc_adc_eic_we) and not fmc_adc_eic_wack;
      end if;
    end if;
  end process;
  fmc_adc_eic_o.cyc <= fmc_adc_eic_tr;
  fmc_adc_eic_o.stb <= fmc_adc_eic_tr;
  fmc_adc_eic_wack <= fmc_adc_eic_i.ack and fmc_adc_eic_wt;
  fmc_adc_eic_rack <= fmc_adc_eic_i.ack and fmc_adc_eic_rt;
  fmc_adc_eic_o.adr <= ((27 downto 0 => '0') & adr_int(3 downto 2)) & (1 downto 0 => '0');
  fmc_adc_eic_o.sel <= wr_sel_d0;
  fmc_adc_eic_o.we <= fmc_adc_eic_wt;
  fmc_adc_eic_o.dat <= wr_dat_d0;

  -- Interface si570_i2c_master
  si570_i2c_master_tr <= si570_i2c_master_wt or si570_i2c_master_rt;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        si570_i2c_master_rt <= '0';
        si570_i2c_master_wt <= '0';
      else
        si570_i2c_master_rt <= (si570_i2c_master_rt or si570_i2c_master_re) and not si570_i2c_master_rack;
        si570_i2c_master_wt <= (si570_i2c_master_wt or si570_i2c_master_we) and not si570_i2c_master_wack;
      end if;
    end if;
  end process;
  si570_i2c_master_o.cyc <= si570_i2c_master_tr;
  si570_i2c_master_o.stb <= si570_i2c_master_tr;
  si570_i2c_master_wack <= si570_i2c_master_i.ack and si570_i2c_master_wt;
  si570_i2c_master_rack <= si570_i2c_master_i.ack and si570_i2c_master_rt;
  si570_i2c_master_o.adr <= ((23 downto 0 => '0') & adr_int(7 downto 2)) & (1 downto 0 => '0');
  si570_i2c_master_o.sel <= wr_sel_d0;
  si570_i2c_master_o.we <= si570_i2c_master_wt;
  si570_i2c_master_o.dat <= wr_dat_d0;

  -- Interface ds18b20_onewire_master
  ds18b20_onewire_master_tr <= ds18b20_onewire_master_wt or ds18b20_onewire_master_rt;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        ds18b20_onewire_master_rt <= '0';
        ds18b20_onewire_master_wt <= '0';
      else
        ds18b20_onewire_master_rt <= (ds18b20_onewire_master_rt or ds18b20_onewire_master_re) and not ds18b20_onewire_master_rack;
        ds18b20_onewire_master_wt <= (ds18b20_onewire_master_wt or ds18b20_onewire_master_we) and not ds18b20_onewire_master_wack;
      end if;
    end if;
  end process;
  ds18b20_onewire_master_o.cyc <= ds18b20_onewire_master_tr;
  ds18b20_onewire_master_o.stb <= ds18b20_onewire_master_tr;
  ds18b20_onewire_master_wack <= ds18b20_onewire_master_i.ack and ds18b20_onewire_master_wt;
  ds18b20_onewire_master_rack <= ds18b20_onewire_master_i.ack and ds18b20_onewire_master_rt;
  ds18b20_onewire_master_o.adr <= ((27 downto 0 => '0') & adr_int(3 downto 2)) & (1 downto 0 => '0');
  ds18b20_onewire_master_o.sel <= wr_sel_d0;
  ds18b20_onewire_master_o.we <= ds18b20_onewire_master_wt;
  ds18b20_onewire_master_o.dat <= wr_dat_d0;

  -- Interface fmc_spi_master
  fmc_spi_master_tr <= fmc_spi_master_wt or fmc_spi_master_rt;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        fmc_spi_master_rt <= '0';
        fmc_spi_master_wt <= '0';
      else
        fmc_spi_master_rt <= (fmc_spi_master_rt or fmc_spi_master_re) and not fmc_spi_master_rack;
        fmc_spi_master_wt <= (fmc_spi_master_wt or fmc_spi_master_we) and not fmc_spi_master_wack;
      end if;
    end if;
  end process;
  fmc_spi_master_o.cyc <= fmc_spi_master_tr;
  fmc_spi_master_o.stb <= fmc_spi_master_tr;
  fmc_spi_master_wack <= fmc_spi_master_i.ack and fmc_spi_master_wt;
  fmc_spi_master_rack <= fmc_spi_master_i.ack and fmc_spi_master_rt;
  fmc_spi_master_o.adr <= ((26 downto 0 => '0') & adr_int(4 downto 2)) & (1 downto 0 => '0');
  fmc_spi_master_o.sel <= wr_sel_d0;
  fmc_spi_master_o.we <= fmc_spi_master_wt;
  fmc_spi_master_o.dat <= wr_dat_d0;

  -- Interface timetag_core
  timetag_core_tr <= timetag_core_wt or timetag_core_rt;
  process (clk_i) begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        timetag_core_rt <= '0';
        timetag_core_wt <= '0';
      else
        timetag_core_rt <= (timetag_core_rt or timetag_core_re) and not timetag_core_rack;
        timetag_core_wt <= (timetag_core_wt or timetag_core_we) and not timetag_core_wack;
      end if;
    end if;
  end process;
  timetag_core_o.cyc <= timetag_core_tr;
  timetag_core_o.stb <= timetag_core_tr;
  timetag_core_wack <= timetag_core_i.ack and timetag_core_wt;
  timetag_core_rack <= timetag_core_i.ack and timetag_core_rt;
  timetag_core_o.adr <= ((24 downto 0 => '0') & adr_int(6 downto 2)) & (1 downto 0 => '0');
  timetag_core_o.sel <= wr_sel_d0;
  timetag_core_o.we <= timetag_core_wt;
  timetag_core_o.dat <= wr_dat_d0;

  -- Process for write requests.
  process (wr_adr_d0, wr_req_d0, fmc_adc_100m_csr_wack, fmc_adc_eic_wack, si570_i2c_master_wack, ds18b20_onewire_master_wack, fmc_spi_master_wack, timetag_core_wack) begin
    fmc_adc_100m_csr_we <= '0';
    fmc_adc_eic_we <= '0';
    si570_i2c_master_we <= '0';
    ds18b20_onewire_master_we <= '0';
    fmc_spi_master_we <= '0';
    timetag_core_we <= '0';
    case wr_adr_d0(12 downto 9) is
    when "1000" =>
      -- Submap fmc_adc_100m_csr
      fmc_adc_100m_csr_we <= wr_req_d0;
      wr_ack_int <= fmc_adc_100m_csr_wack;
    when "1010" =>
      -- Submap fmc_adc_eic
      fmc_adc_eic_we <= wr_req_d0;
      wr_ack_int <= fmc_adc_eic_wack;
    when "1011" =>
      case wr_adr_d0(8 downto 8) is
      when "0" =>
        -- Submap si570_i2c_master
        si570_i2c_master_we <= wr_req_d0;
        wr_ack_int <= si570_i2c_master_wack;
      when "1" =>
        -- Submap ds18b20_onewire_master
        ds18b20_onewire_master_we <= wr_req_d0;
        wr_ack_int <= ds18b20_onewire_master_wack;
      when others =>
        wr_ack_int <= wr_req_d0;
      end case;
    when "1100" =>
      case wr_adr_d0(8 downto 7) is
      when "00" =>
        -- Submap fmc_spi_master
        fmc_spi_master_we <= wr_req_d0;
        wr_ack_int <= fmc_spi_master_wack;
      when "10" =>
        -- Submap timetag_core
        timetag_core_we <= wr_req_d0;
        wr_ack_int <= timetag_core_wack;
      when others =>
        wr_ack_int <= wr_req_d0;
      end case;
    when others =>
      wr_ack_int <= wr_req_d0;
    end case;
  end process;

  -- Process for read requests.
  process (adr_int, rd_req_int, fmc_adc_100m_csr_i.dat, fmc_adc_100m_csr_rack, fmc_adc_eic_i.dat, fmc_adc_eic_rack, si570_i2c_master_i.dat, si570_i2c_master_rack, ds18b20_onewire_master_i.dat, ds18b20_onewire_master_rack, fmc_spi_master_i.dat, fmc_spi_master_rack, timetag_core_i.dat, timetag_core_rack) begin
    -- By default ack read requests
    rd_dat_d0 <= (others => 'X');
    fmc_adc_100m_csr_re <= '0';
    fmc_adc_eic_re <= '0';
    si570_i2c_master_re <= '0';
    ds18b20_onewire_master_re <= '0';
    fmc_spi_master_re <= '0';
    timetag_core_re <= '0';
    case adr_int(12 downto 9) is
    when "1000" =>
      -- Submap fmc_adc_100m_csr
      fmc_adc_100m_csr_re <= rd_req_int;
      rd_dat_d0 <= fmc_adc_100m_csr_i.dat;
      rd_ack_d0 <= fmc_adc_100m_csr_rack;
    when "1010" =>
      -- Submap fmc_adc_eic
      fmc_adc_eic_re <= rd_req_int;
      rd_dat_d0 <= fmc_adc_eic_i.dat;
      rd_ack_d0 <= fmc_adc_eic_rack;
    when "1011" =>
      case adr_int(8 downto 8) is
      when "0" =>
        -- Submap si570_i2c_master
        si570_i2c_master_re <= rd_req_int;
        rd_dat_d0 <= si570_i2c_master_i.dat;
        rd_ack_d0 <= si570_i2c_master_rack;
      when "1" =>
        -- Submap ds18b20_onewire_master
        ds18b20_onewire_master_re <= rd_req_int;
        rd_dat_d0 <= ds18b20_onewire_master_i.dat;
        rd_ack_d0 <= ds18b20_onewire_master_rack;
      when others =>
        rd_ack_d0 <= rd_req_int;
      end case;
    when "1100" =>
      case adr_int(8 downto 7) is
      when "00" =>
        -- Submap fmc_spi_master
        fmc_spi_master_re <= rd_req_int;
        rd_dat_d0 <= fmc_spi_master_i.dat;
        rd_ack_d0 <= fmc_spi_master_rack;
      when "10" =>
        -- Submap timetag_core
        timetag_core_re <= rd_req_int;
        rd_dat_d0 <= timetag_core_i.dat;
        rd_ack_d0 <= timetag_core_rack;
      when others =>
        rd_ack_d0 <= rd_req_int;
      end case;
    when others =>
      rd_ack_d0 <= rd_req_int;
    end case;
  end process;
end syn;
