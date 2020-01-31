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
