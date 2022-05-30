# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(ROUTING_CORES) 4

# Define
set ::env(SYNTH_DEFINES) "SYNTHESIS"
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(DESIGN_IS_CORE) 0
set ::env(DESIGN_NAME) Marmot

set ::env(VERILOG_INCLUDE_DIRS) [glob $script_dir/../../verilog/rtl/marmot]

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
  $script_dir/../../verilog/lib/clk_skew_adjust.gv \
  $script_dir/../../verilog/lib/ctech_cells.sv \
	[glob $script_dir/../../verilog/rtl/marmot/*.v]"

set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_PERIOD) 40
set ::env(IO_PCT)     0.2
set ::env(IO_PCT_RAM) 0.3

#set ::env(SYNTH_CAP_LOAD) 70

set ::env(BASE_SDC_FILE) $script_dir/base.sdc

#set ::env(SYNTH_STRATEGY) "AREA 0"
#set ::env(SYNTH_NO_FLAT) 1

set ::env(FP_CORE_UTIL) 30
#set ::env(FP_SIZING) absolute
#set ::env(DIE_AREA) "0 0 1757 1767"

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(PL_TIME_DRIVEN) 1
set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) 0.33
set ::env(PL_RESIZER_HOLD_SLACK_MARGIN)  0.3
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) 0.3

set ::env(CTS_TOLERANCE) 30
#set ::env(CTS_CLK_BUFFER_LIST) "sky130_fd_sc_hd__clkbuf_8"
#set ::env(CTS_SINK_CLUSTERING_SIZE) "16"
#set ::env(CLOCK_BUFFER_FANOUT) "8"

set ::env(CELL_PAD) 2

# Maximum layer used for routing is metal 4.
# This is because this macro will be inserted in a top level (user_project_wrapper) 
# where the PDN is planned on metal 5. So, to avoid having shorts between routes
# in this macro and the top level metal 5 stripes, we have to restrict routes to metal4.  
# 
# set ::env(GLB_RT_MAXLAYER) 5

set ::env(RT_MAX_LAYER) {met4}

# You can draw more power domains if you need to 
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]

set ::env(DIODE_INSERTION_STRATEGY) 4 
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1
