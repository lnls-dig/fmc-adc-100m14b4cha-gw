`define ADDR_FMC_ADC_100MS_CSR_CTL     10'h0
`define FMC_ADC_100MS_CSR_CTL_FSM_CMD_OFFSET 0
`define FMC_ADC_100MS_CSR_CTL_FSM_CMD 32'h00000003
`define FMC_ADC_100MS_CSR_CTL_FMC_CLK_OE_OFFSET 2
`define FMC_ADC_100MS_CSR_CTL_FMC_CLK_OE 32'h00000004
`define FMC_ADC_100MS_CSR_CTL_OFFSET_DAC_CLR_N_OFFSET 3
`define FMC_ADC_100MS_CSR_CTL_OFFSET_DAC_CLR_N 32'h00000008
`define FMC_ADC_100MS_CSR_CTL_MAN_BITSLIP_OFFSET 4
`define FMC_ADC_100MS_CSR_CTL_MAN_BITSLIP 32'h00000010
`define FMC_ADC_100MS_CSR_CTL_TEST_DATA_EN_OFFSET 5
`define FMC_ADC_100MS_CSR_CTL_TEST_DATA_EN 32'h00000020
`define FMC_ADC_100MS_CSR_CTL_TRIG_LED_OFFSET 6
`define FMC_ADC_100MS_CSR_CTL_TRIG_LED 32'h00000040
`define FMC_ADC_100MS_CSR_CTL_ACQ_LED_OFFSET 7
`define FMC_ADC_100MS_CSR_CTL_ACQ_LED 32'h00000080
`define ADDR_FMC_ADC_100MS_CSR_STA     10'h4
`define FMC_ADC_100MS_CSR_STA_FSM_OFFSET 0
`define FMC_ADC_100MS_CSR_STA_FSM 32'h00000007
`define FMC_ADC_100MS_CSR_STA_SERDES_PLL_OFFSET 3
`define FMC_ADC_100MS_CSR_STA_SERDES_PLL 32'h00000008
`define FMC_ADC_100MS_CSR_STA_SERDES_SYNCED_OFFSET 4
`define FMC_ADC_100MS_CSR_STA_SERDES_SYNCED 32'h00000010
`define FMC_ADC_100MS_CSR_STA_ACQ_CFG_OFFSET 5
`define FMC_ADC_100MS_CSR_STA_ACQ_CFG 32'h00000020
`define ADDR_FMC_ADC_100MS_CSR_TRIG_STAT 10'h8
`define FMC_ADC_100MS_CSR_TRIG_STAT_EXT_OFFSET 0
`define FMC_ADC_100MS_CSR_TRIG_STAT_EXT 32'h00000001
`define FMC_ADC_100MS_CSR_TRIG_STAT_SW_OFFSET 1
`define FMC_ADC_100MS_CSR_TRIG_STAT_SW 32'h00000002
`define FMC_ADC_100MS_CSR_TRIG_STAT_TIME_OFFSET 4
`define FMC_ADC_100MS_CSR_TRIG_STAT_TIME 32'h00000010
`define FMC_ADC_100MS_CSR_TRIG_STAT_CH1_OFFSET 8
`define FMC_ADC_100MS_CSR_TRIG_STAT_CH1 32'h00000100
`define FMC_ADC_100MS_CSR_TRIG_STAT_CH2_OFFSET 9
`define FMC_ADC_100MS_CSR_TRIG_STAT_CH2 32'h00000200
`define FMC_ADC_100MS_CSR_TRIG_STAT_CH3_OFFSET 10
`define FMC_ADC_100MS_CSR_TRIG_STAT_CH3 32'h00000400
`define FMC_ADC_100MS_CSR_TRIG_STAT_CH4_OFFSET 11
`define FMC_ADC_100MS_CSR_TRIG_STAT_CH4 32'h00000800
`define ADDR_FMC_ADC_100MS_CSR_TRIG_EN 10'hc
`define FMC_ADC_100MS_CSR_TRIG_EN_EXT_OFFSET 0
`define FMC_ADC_100MS_CSR_TRIG_EN_EXT 32'h00000001
`define FMC_ADC_100MS_CSR_TRIG_EN_SW_OFFSET 1
`define FMC_ADC_100MS_CSR_TRIG_EN_SW 32'h00000002
`define FMC_ADC_100MS_CSR_TRIG_EN_TIME_OFFSET 4
`define FMC_ADC_100MS_CSR_TRIG_EN_TIME 32'h00000010
`define FMC_ADC_100MS_CSR_TRIG_EN_CH1_OFFSET 8
`define FMC_ADC_100MS_CSR_TRIG_EN_CH1 32'h00000100
`define FMC_ADC_100MS_CSR_TRIG_EN_CH2_OFFSET 9
`define FMC_ADC_100MS_CSR_TRIG_EN_CH2 32'h00000200
`define FMC_ADC_100MS_CSR_TRIG_EN_CH3_OFFSET 10
`define FMC_ADC_100MS_CSR_TRIG_EN_CH3 32'h00000400
`define FMC_ADC_100MS_CSR_TRIG_EN_CH4_OFFSET 11
`define FMC_ADC_100MS_CSR_TRIG_EN_CH4 32'h00000800
`define ADDR_FMC_ADC_100MS_CSR_TRIG_POL 10'h10
`define FMC_ADC_100MS_CSR_TRIG_POL_EXT_OFFSET 0
`define FMC_ADC_100MS_CSR_TRIG_POL_EXT 32'h00000001
`define FMC_ADC_100MS_CSR_TRIG_POL_CH1_OFFSET 8
`define FMC_ADC_100MS_CSR_TRIG_POL_CH1 32'h00000100
`define FMC_ADC_100MS_CSR_TRIG_POL_CH2_OFFSET 9
`define FMC_ADC_100MS_CSR_TRIG_POL_CH2 32'h00000200
`define FMC_ADC_100MS_CSR_TRIG_POL_CH3_OFFSET 10
`define FMC_ADC_100MS_CSR_TRIG_POL_CH3 32'h00000400
`define FMC_ADC_100MS_CSR_TRIG_POL_CH4_OFFSET 11
`define FMC_ADC_100MS_CSR_TRIG_POL_CH4 32'h00000800
`define ADDR_FMC_ADC_100MS_CSR_EXT_TRIG_DLY 10'h14
`define ADDR_FMC_ADC_100MS_CSR_SW_TRIG 10'h18
`define ADDR_FMC_ADC_100MS_CSR_SHOTS   10'h1c
`define FMC_ADC_100MS_CSR_SHOTS_NB_OFFSET 0
`define FMC_ADC_100MS_CSR_SHOTS_NB 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_MULTI_DEPTH 10'h20
`define ADDR_FMC_ADC_100MS_CSR_SHOTS_CNT 10'h24
`define FMC_ADC_100MS_CSR_SHOTS_CNT_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_SHOTS_CNT_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_TRIG_POS 10'h28
`define ADDR_FMC_ADC_100MS_CSR_FS_FREQ 10'h2c
`define ADDR_FMC_ADC_100MS_CSR_SR      10'h30
`define FMC_ADC_100MS_CSR_SR_UNDERSAMPLE_OFFSET 0
`define FMC_ADC_100MS_CSR_SR_UNDERSAMPLE 32'hffffffff
`define ADDR_FMC_ADC_100MS_CSR_PRE_SAMPLES 10'h34
`define ADDR_FMC_ADC_100MS_CSR_POST_SAMPLES 10'h38
`define ADDR_FMC_ADC_100MS_CSR_SAMPLES_CNT 10'h3c
`define ADDR_FMC_ADC_100MS_CSR_CH1_CTL 10'h80
`define FMC_ADC_100MS_CSR_CH1_CTL_SSR_OFFSET 0
`define FMC_ADC_100MS_CSR_CH1_CTL_SSR 32'h0000007f
`define ADDR_FMC_ADC_100MS_CSR_CH1_STA 10'h84
`define FMC_ADC_100MS_CSR_CH1_STA_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH1_STA_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH1_GAIN 10'h88
`define FMC_ADC_100MS_CSR_CH1_GAIN_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH1_GAIN_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH1_OFFSET 10'h8c
`define FMC_ADC_100MS_CSR_CH1_OFFSET_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH1_OFFSET_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH1_SAT 10'h90
`define FMC_ADC_100MS_CSR_CH1_SAT_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH1_SAT_VAL 32'h00007fff
`define ADDR_FMC_ADC_100MS_CSR_CH1_TRIG_THRES 10'h94
`define FMC_ADC_100MS_CSR_CH1_TRIG_THRES_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH1_TRIG_THRES_VAL 32'h0000ffff
`define FMC_ADC_100MS_CSR_CH1_TRIG_THRES_HYST_OFFSET 16
`define FMC_ADC_100MS_CSR_CH1_TRIG_THRES_HYST 32'hffff0000
`define ADDR_FMC_ADC_100MS_CSR_CH1_TRIG_DLY 10'h98
`define ADDR_FMC_ADC_100MS_CSR_CH2_CTL 10'h100
`define FMC_ADC_100MS_CSR_CH2_CTL_SSR_OFFSET 0
`define FMC_ADC_100MS_CSR_CH2_CTL_SSR 32'h0000007f
`define ADDR_FMC_ADC_100MS_CSR_CH2_STA 10'h104
`define FMC_ADC_100MS_CSR_CH2_STA_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH2_STA_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH2_GAIN 10'h108
`define FMC_ADC_100MS_CSR_CH2_GAIN_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH2_GAIN_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH2_OFFSET 10'h10c
`define FMC_ADC_100MS_CSR_CH2_OFFSET_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH2_OFFSET_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH2_SAT 10'h110
`define FMC_ADC_100MS_CSR_CH2_SAT_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH2_SAT_VAL 32'h00007fff
`define ADDR_FMC_ADC_100MS_CSR_CH2_TRIG_THRES 10'h114
`define FMC_ADC_100MS_CSR_CH2_TRIG_THRES_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH2_TRIG_THRES_VAL 32'h0000ffff
`define FMC_ADC_100MS_CSR_CH2_TRIG_THRES_HYST_OFFSET 16
`define FMC_ADC_100MS_CSR_CH2_TRIG_THRES_HYST 32'hffff0000
`define ADDR_FMC_ADC_100MS_CSR_CH2_TRIG_DLY 10'h118
`define ADDR_FMC_ADC_100MS_CSR_CH3_CTL 10'h180
`define FMC_ADC_100MS_CSR_CH3_CTL_SSR_OFFSET 0
`define FMC_ADC_100MS_CSR_CH3_CTL_SSR 32'h0000007f
`define ADDR_FMC_ADC_100MS_CSR_CH3_STA 10'h184
`define FMC_ADC_100MS_CSR_CH3_STA_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH3_STA_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH3_GAIN 10'h188
`define FMC_ADC_100MS_CSR_CH3_GAIN_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH3_GAIN_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH3_OFFSET 10'h18c
`define FMC_ADC_100MS_CSR_CH3_OFFSET_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH3_OFFSET_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH3_SAT 10'h190
`define FMC_ADC_100MS_CSR_CH3_SAT_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH3_SAT_VAL 32'h00007fff
`define ADDR_FMC_ADC_100MS_CSR_CH3_TRIG_THRES 10'h194
`define FMC_ADC_100MS_CSR_CH3_TRIG_THRES_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH3_TRIG_THRES_VAL 32'h0000ffff
`define FMC_ADC_100MS_CSR_CH3_TRIG_THRES_HYST_OFFSET 16
`define FMC_ADC_100MS_CSR_CH3_TRIG_THRES_HYST 32'hffff0000
`define ADDR_FMC_ADC_100MS_CSR_CH3_TRIG_DLY 10'h198
`define ADDR_FMC_ADC_100MS_CSR_CH4_CTL 10'h200
`define FMC_ADC_100MS_CSR_CH4_CTL_SSR_OFFSET 0
`define FMC_ADC_100MS_CSR_CH4_CTL_SSR 32'h0000007f
`define ADDR_FMC_ADC_100MS_CSR_CH4_STA 10'h204
`define FMC_ADC_100MS_CSR_CH4_STA_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH4_STA_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH4_GAIN 10'h208
`define FMC_ADC_100MS_CSR_CH4_GAIN_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH4_GAIN_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH4_OFFSET 10'h20c
`define FMC_ADC_100MS_CSR_CH4_OFFSET_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH4_OFFSET_VAL 32'h0000ffff
`define ADDR_FMC_ADC_100MS_CSR_CH4_SAT 10'h210
`define FMC_ADC_100MS_CSR_CH4_SAT_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH4_SAT_VAL 32'h00007fff
`define ADDR_FMC_ADC_100MS_CSR_CH4_TRIG_THRES 10'h214
`define FMC_ADC_100MS_CSR_CH4_TRIG_THRES_VAL_OFFSET 0
`define FMC_ADC_100MS_CSR_CH4_TRIG_THRES_VAL 32'h0000ffff
`define FMC_ADC_100MS_CSR_CH4_TRIG_THRES_HYST_OFFSET 16
`define FMC_ADC_100MS_CSR_CH4_TRIG_THRES_HYST 32'hffff0000
`define ADDR_FMC_ADC_100MS_CSR_CH4_TRIG_DLY 10'h218
