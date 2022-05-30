# create clock
#create_clock [get_ports clk_in] -name clk_in -period $::env(CLOCK_PERIOD)
#
#create_generated_clock -name clk_out -add \
#  -source [get_ports clk_in] -master_clock [get_clocks clk_in] -divide_by 1 \
#  -comment {Output clk} [get_ports clk_out]

# min and max delay
#set_min_delay 3.0 -from [get_ports clk_in] -to [get_ports clk_out]
#set_max_delay 8.0 -from [get_ports clk_in] -to [get_ports clk_out]

# false path: static clock skew adjust signals
set_false_path -from [get_ports sel[*]]

# max fanout
#set_max_fanout $::env(SYNTH_MAX_FANOUT) [current_design]

# TODO set this as parameter
#set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]
set cap_load [expr $::env(SYNTH_CAP_LOAD) / 1000.0]
puts "\[INFO\]: Setting load to: $cap_load"
set_load  $cap_load [all_outputs]

#puts "\[INFO\]: Setting clock uncertainity to: $::env(SYNTH_CLOCK_UNCERTAINITY)"
#set_clock_uncertainty $::env(SYNTH_CLOCK_UNCERTAINITY) [all_clocks]
#
#puts "\[INFO\]: Setting clock transition to: $::env(SYNTH_CLOCK_TRANSITION)"
#set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [all_clocks]
#
#set_propagated_clock [all_clocks]

#puts "\[INFO\]: Setting timing derate to: [expr {$::env(SYNTH_TIMING_DERATE) * 10}] %"
#set_timing_derate -early [expr {1-$::env(SYNTH_TIMING_DERATE)}]
#set_timing_derate -late [expr {1+$::env(SYNTH_TIMING_DERATE)}]

