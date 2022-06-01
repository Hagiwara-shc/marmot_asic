# JTAG port
set TDO_port io_out[1]
set TDI_port io_in[2]
set TMS_port io_in[3]
set TCK_port io_in[4]

# create clock
create_clock [get_ports wb_clk_i] -name wb_clk_i -period $::env(CLOCK_PERIOD)

#create_generated_clock -name data_arrays_0_ext_ram_clk -add \
#  -source [get_ports wb_clk_i] -master_clock [get_clocks wb_clk_i] -divide_by 1 \
#  -comment {DTIM RAM clk} [get_ports data_arrays_0_ext_ram_clk]

create_generated_clock -name tag_array_ext_ram_clk -add \
  -source [get_ports wb_clk_i] -master_clock [get_clocks wb_clk_i] -divide_by 1 \
  -comment {I-Cache Tag RAM clk} [get_ports tag_array_ext_ram_clk]

create_generated_clock -name data_arrays_0_0_ext_ram_clk -add \
  -source [get_ports wb_clk_i] -master_clock [get_clocks wb_clk_i] -divide_by 1 \
  -comment {I-Cache Data RAM clk} [get_ports data_arrays_0_0_ext_ram_clk]

create_generated_clock -name slow_clock -add \
  -source [get_ports wb_clk_i] -master_clock [get_clocks wb_clk_i] -divide_by 4 \
  -comment {AON clk} [get_nets \MarmotCaravelChip.MarmotCaravelPlatform.io_pins_aon_lfextclk_i_ival ]

create_clock [get_ports $TCK_port] -name jtag_TCK -period 100.0

# clock groups
set_clock_groups -name async_clock -asynchronous \
 -group [get_clocks {wb_clk_i tag_array_ext_ram_clk data_arrays_0_0_ext_ram_clk slow_clock}] \
 -group [get_clocks {jtag_TCK}]\

# max delay for RAM clocks
#set MAX_DELAY_RAM_CLOCK 6.0
#set_max_delay $MAX_DELAY_RAM_CLOCK -from [get_ports wb_clk_i] -to [get_ports data_arrays_0_ext_ram_clk]
#set_max_delay $MAX_DELAY_RAM_CLOCK -from [get_ports wb_clk_i] -to [get_ports tag_array_ext_ram_clk]
#set_max_delay $MAX_DELAY_RAM_CLOCK -from [get_ports wb_clk_i] -to [get_ports data_arrays_0_0_ext_ram_clk]

# input/output delay
set input_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
set output_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
puts "\[INFO\]: Setting output delay to: $output_delay_value"
puts "\[INFO\]: Setting input delay to: $input_delay_value"

set input_delay_value_ram [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT_RAM)]
set output_delay_value_ram [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT_RAM)]
puts "\[INFO\]: Setting output delay for RAM to: $output_delay_value_ram"
puts "\[INFO\]: Setting input delay for RAM to: $input_delay_value_ram"

set all_inputs_wo_clk [all_inputs]
set clk_indx [lsearch $all_inputs_wo_clk [get_port wb_clk_i]]
set all_inputs_wo_clk [lreplace [all_inputs] $clk_indx $clk_indx]

set tck_indx [lsearch $all_inputs_wo_clk [get_port $TCK_port]]
set all_inputs_wo_clk [lreplace $all_inputs_wo_clk $tck_indx $tck_indx]

set_input_delay  $input_delay_value  -clock [get_clocks wb_clk_i] $all_inputs_wo_clk
set_output_delay $output_delay_value -clock [get_clocks wb_clk_i] [all_outputs]

# DTIM RAM port
#set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_rdata0[*]
#set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_rdata1[*]
#set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_rdata2[*]
#set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_rdata3[*]
#set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_rdata4[*]
#set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_rdata5[*]
#set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_rdata6[*]
#set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_rdata7[*]
#set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_csb[*]
#set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_web
#set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_addr[*]
#set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_wdata[*]
#set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_wmask[*]
#set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_csb1[*]
#set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_ext_ram_clk] data_arrays_0_ext_ram_addr1[*]

# I-Cache Tag RAM port
set_output_delay $output_delay_value_ram -clock [get_clocks tag_array_ext_ram_clk] [get_ports tag_array_ext_ram_csb]
set_output_delay $output_delay_value_ram -clock [get_clocks tag_array_ext_ram_clk] [get_ports tag_array_ext_ram_web]
set_output_delay $output_delay_value_ram -clock [get_clocks tag_array_ext_ram_clk] [get_ports tag_array_ext_ram_addr[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks tag_array_ext_ram_clk] [get_ports tag_array_ext_ram_wdata[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks tag_array_ext_ram_clk] [get_ports tag_array_ext_ram_wmask[*]]
set_input_delay  $input_delay_value_ram  -clock [get_clocks tag_array_ext_ram_clk] [get_ports tag_array_ext_ram_rdata0[*]]
set_input_delay  $input_delay_value_ram  -clock [get_clocks tag_array_ext_ram_clk] [get_ports tag_array_ext_ram_rdata1[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks tag_array_ext_ram_clk] [get_ports tag_array_ext_ram_csb1]
set_output_delay $output_delay_value_ram -clock [get_clocks tag_array_ext_ram_clk] [get_ports tag_array_ext_ram_addr1[*]]

# I-Cache Data RAM port]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_csb[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_web*]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_addr00[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_addr01[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_addr02[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_addr03[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_wdata0[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_wdata1[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_wdata2[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_wdata3[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_wmask0[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_wmask1[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_wmask2[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_wmask3[*]]
set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_rdata0[*]]
set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_rdata1[*]]
set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_rdata2[*]]
set_input_delay  $input_delay_value_ram  -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_rdata3[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_csb1[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_addr10[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_addr11[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_addr12[*]]
set_output_delay $output_delay_value_ram -clock [get_clocks data_arrays_0_0_ext_ram_clk] [get_ports data_arrays_0_0_ext_ram_addr13[*]]

# JTAG port
set_input_delay  $input_delay_value  -clock [get_clocks jtag_TCK] [get_ports $TMS_port]
set_input_delay  $input_delay_value  -clock [get_clocks jtag_TCK] [get_ports $TDI_port]
set_output_delay $output_delay_value -clock [get_clocks jtag_TCK] [get_ports $TDO_port]

# max fanout
set_max_fanout $::env(SYNTH_MAX_FANOUT) [current_design]

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
