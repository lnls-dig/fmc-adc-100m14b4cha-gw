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
create_generated_clock -name fmc0_fs_clk          [all_fanin -flat -startpoints_only [get_pins -of_objects [get_nets -hier -filter {NAME =~ *cmp_fmc_adc_0_mezzanine/cmp_fmc_adc_100Ms_core/fs_clk}]] -filter {IS_LEAF && (DIRECTION == "OUT")}]
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
create_generated_clock -name fmc1_fs_clk          [all_fanin -flat -startpoints_only [get_pins -of_objects [get_nets -hier -filter {NAME =~ *cmp_fmc_adc_1_mezzanine/cmp_fmc_adc_100Ms_core/fs_clk}]] -filter {IS_LEAF && (DIRECTION == "OUT")}]
set fmc1_fs_clk_period                            [get_property PERIOD [get_clocks fmc1_fs_clk]]

#######################################################################
##                              CDC                                  ##
#######################################################################

# Synchronizer FF
set_max_delay -datapath_only -from               [get_cells -hier -filter {NAME =~ *cmp_fmc_adc_*_mezzanine/*/cmp_ext_trig_sync/gc_sync_ffs_in}]  1.5 ns

#######################################################################
##                      Placement Constraints                        ##
#######################################################################
