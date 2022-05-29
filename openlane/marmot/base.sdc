# JTAG port
set TDO_port io_out[1]
set TDI_port io_in[2]
set TMS_port io_in[3]
set TCK_port io_in[4]

# create clock
create_clock [get_ports wb_clk_i] -name wb_clk_i -period $::env(CLOCK_PERIOD)

create_generated_clock -name slow_clock -add \
  -source [get_ports wb_clk_i] -master_clock [get_clocks wb_clk_i] \
  -divide_by 4 [get_nets \MarmotCaravelChip.MarmotCaravelPlatform.io_pins_aon_lfextclk_i_ival ]

create_clock [get_ports $TCK_port] -name jtag_TCK -period 100.0

# clock groups
set_clock_groups -name async_clock -asynchronous \
 -group [get_clocks {wb_clk_i slow_clock}] \
 -group [get_clocks {jtag_TCK}]\

set input_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
set output_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
puts "\[INFO\]: Setting output delay to: $output_delay_value"
puts "\[INFO\]: Setting input delay to: $input_delay_value"

# max fanout
set_max_fanout $::env(SYNTH_MAX_FANOUT) [current_design]

set clk_indx [lsearch [all_inputs] [get_port wb_clk_i]]
set tck_indx [lsearch [all_inputs] [get_port $TCK_port]]
set all_inputs_wo_clk [lreplace [all_inputs] $clk_indx $clk_indx]
set all_inputs_wo_clk [lreplace $all_inputs_wo_clk $tck_indx $tck_indx]

# input/output delay
set_input_delay  $input_delay_value  -clock [get_clocks wb_clk_i] $all_inputs_wo_clk
set_output_delay $output_delay_value -clock [get_clocks wb_clk_i] [all_outputs]

# input/output delay of JTAG port
set_input_delay  $input_delay_value  -clock [get_clocks jtag_TCK] [get_ports $TMS_port]
set_input_delay  $input_delay_value  -clock [get_clocks jtag_TCK] [get_ports $TDI_port]
set_output_delay $output_delay_value -clock [get_clocks jtag_TCK] [get_ports $TDO_port]

# TODO set this as parameter
set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]
set cap_load [expr $::env(SYNTH_CAP_LOAD) / 1000.0]
puts "\[INFO\]: Setting load to: $cap_load"
set_load  $cap_load [all_outputs]

puts "\[INFO\]: Setting clock uncertainity to: $::env(SYNTH_CLOCK_UNCERTAINITY)"
set_clock_uncertainty $::env(SYNTH_CLOCK_UNCERTAINITY) [all_clocks]

puts "\[INFO\]: Setting clock transition to: $::env(SYNTH_CLOCK_TRANSITION)"
set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [all_clocks]

set_propagated_clock [all_clocks]

puts "\[INFO\]: Setting timing derate to: [expr {$::env(SYNTH_TIMING_DERATE) * 10}] %"
set_timing_derate -early [expr {1-$::env(SYNTH_TIMING_DERATE)}]
set_timing_derate -late [expr {1+$::env(SYNTH_TIMING_DERATE)}]
