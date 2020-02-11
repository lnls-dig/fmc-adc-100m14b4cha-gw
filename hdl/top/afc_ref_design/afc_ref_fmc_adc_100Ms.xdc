#######################################################################
##                      Artix 7 AMC V3                               ##
#######################################################################
#

#######################################################################
##                          Clocks                                   ##
#######################################################################

# FMC 0 clock
create_clock -period 2.500 -name fmc0_adc_dco_p_i [get_ports fmc0_adc_dco_p_i]

# FMC 0 generated clock for user logic
#
# 1. Get the complete name of the fs_clk NET
# 2. Get the pin name that is connected to this NET and filter it
#     so get only the OUT pins and the LEAF name of it (as opposed to
#     a hierarchical name)
# 3. This pin will be probably the Q pin of the driving FF, but for a timing,
#     analysis we want a valid startpoint. So, we get only this by using the all_fanin
#     command
create_generated_clock -name fmc0_fs_clk          [all_fanin -flat -startpoints_only [get_pins -of_objects [get_nets -hier -filter {NAME =~ *cmp_fmc_adc_0_mezzanine/cmp_fmc_adc_100Ms_core/fs_clk}]]]
set fmc0_fs_clk_period                            [get_property PERIOD [get_clocks fmc0_fs_clk]]

# FMC 1 clock
create_clock -period 2.500 -name fmc1_adc_dco_p_i [get_ports fmc1_adc_dco_p_i]

# FMC 0 generated clock for user logic
#
# 1. Get the complete name of the fs_clk NET
# 2. Get the pin name that is connected to this NET and filter it
#     so get only the OUT pins and the LEAF name of it (as opposed to
#     a hierarchical name)
# 3. This pin will be probably the Q pin of the driving FF, but for a timing,
#     analysis we want a valid startpoint. So, we get only this by using the all_fanin
#     command
create_generated_clock -name fmc1_fs_clk          [all_fanin -flat -startpoints_only [get_pins -of_objects [get_nets -hier -filter {NAME =~ *cmp_fmc_adc_1_mezzanine/cmp_fmc_adc_100Ms_core/fs_clk}]]]
set fmc1_fs_clk_period                            [get_property PERIOD [get_clocks fmc1_fs_clk]]

#######################################################################
##                          DELAYS                                   ##
#######################################################################

# From LTC2175-12/LTC2174-12/LTC2173-12 data sheet (page 06)
#
#Output Clock to Data Propagation Delay:
# tdata Rising/Falling Edge 0.35 * tSER (min) / 0.5 * tSER (typ) / 0.65 * tSER (max)
#                       1/800*1e3*0.35 = 0.43750 ns / 0.62500 ns (typ) / 0.81250 ns (max)
#
#This is setup for a 400MHz clock (2.5ns period).  The LTC2174 specifies
# tDATA as 0.35 *tSER to 0.65 * tSER.  The constraint adds an additional 100ps
# to each side to account for potential skew due to the pcb. So, the tDC ends up
# being 0.33750 ns to 0.91250 ns.  The value after IN in the constraint equal tDC min
# (0.33750 ns). The  value after VALID = Period/2 + tDC min – tDC max (2.5ns/2 + 0.33750ns -
# 0.91250 ns = 0.67500ns).  (The period is divided by two because the data is DDR.)
#
#
#         OFFSET
#        +---+
#
#             --------      --------
# CLK         |      |      |      |      |
#                    --------      --------
#        --------------------------------
# DATA   |      ||      ||      ||      |
#        --------------------------------
#
#        +------+
#         VALID
#

set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc0_adc_outa_p_i[*]}] -rise
set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc0_adc_outa_p_i[*]}] -rise
set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc0_adc_outa_p_i[*]}] -fall
set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc0_adc_outa_p_i[*]}] -fall
set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc0_adc_outb_p_i[*]}] -rise
set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc0_adc_outb_p_i[*]}] -rise
set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc0_adc_outb_p_i[*]}] -fall
set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc0_adc_outb_p_i[*]}] -fall

set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc0_adc_fr_p_i}] -rise
set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc0_adc_fr_p_i}] -rise
set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc0_adc_fr_p_i}] -fall
set_input_delay -clock [get_clocks fmc0_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc0_adc_fr_p_i}] -fall

set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc1_adc_outa_p_i[*]}] -rise
set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc1_adc_outa_p_i[*]}] -rise
set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc1_adc_outa_p_i[*]}] -fall
set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc1_adc_outa_p_i[*]}] -fall
set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc1_adc_outb_p_i[*]}] -rise
set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc1_adc_outb_p_i[*]}] -rise
set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc1_adc_outb_p_i[*]}] -fall
set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc1_adc_outb_p_i[*]}] -fall

set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc1_adc_fr_p_i}] -rise
set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc1_adc_fr_p_i}] -rise
set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -max -add_delay 0.33750 [get_ports {fmc1_adc_fr_p_i}] -fall
set_input_delay -clock [get_clocks fmc1_adc_dco_p_i] -min -add_delay 0.67500 [get_ports {fmc1_adc_fr_p_i}] -fall

#######################################################################
##                          DELAYS grouping                          ##
#######################################################################

# Constraint all IDELAY blocks to the same IDELAY control as the DDR 3, so the tool will replicate it as needed
set_property IODELAY_GROUP DDR_CORE_IODELAY_MIG0 [get_cells -hier -filter {NAME =~ *cmp_idelayctrl}]

#######################################################################
##                              CDC                                  ##
#######################################################################

# Synchronizer FF. Set the internal path of synchronizer to be very near each other,
# even though the ASYNC_REG property would take care of this
set_max_delay -datapath_only -from               [get_cells -hier -filter {NAME =~ *cmp_fmc_adc_*_mezzanine/*/cmp_ext_trig_sync/gc_sync_ffs_in}]  1.5

# CDC between Wishbone clock and FS clocks
# These are slow control registers taken care of synched by FFs.
# Give it 1x destination clock. Could be 2x, but lets keep things tight.
set_max_delay -datapath_only -from               [get_clocks clk_sys] -to [get_clocks fmc0_fs_clk]    $fmc0_fs_clk_period
set_max_delay -datapath_only -from               [get_clocks clk_sys] -to [get_clocks fmc1_fs_clk]    $fmc1_fs_clk_period

set_max_delay -datapath_only -from               [get_clocks fmc0_fs_clk]    -to [get_clocks clk_sys] $clk_sys_period
set_max_delay -datapath_only -from               [get_clocks fmc1_fs_clk]    -to [get_clocks clk_sys] $clk_sys_period

# CDC between Clk Aux (trigger clock) and FS clocks
# These are using pulse_synchronizer2 which is a full feedback sync.
# Give it 1x destination clock.
set_max_delay -datapath_only -from               [get_clocks clk_aux] -to [get_clocks fmc0_fs_clk]    $fmc0_fs_clk_period
set_max_delay -datapath_only -from               [get_clocks clk_aux] -to [get_clocks fmc1_fs_clk]    $fmc1_fs_clk_period

# CDC between FS clocks and Clk Aux (trigger clock)
# These are using pulse_synchronizer2 which is a full feedback sync.
# Give it 1x destination clock.
set_max_delay -datapath_only -from               [get_clocks fmc0_fs_clk] -to [get_clocks clk_aux]    $clk_aux_period
set_max_delay -datapath_only -from               [get_clocks fmc1_fs_clk] -to [get_clocks clk_aux]    $clk_aux_period

#######################################################################
##                      Placement Constraints                        ##
#######################################################################
