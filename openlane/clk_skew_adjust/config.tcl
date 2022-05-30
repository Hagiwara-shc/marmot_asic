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

# Cell library
set ::env(LIB_SYNTH) [glob $script_dir/../../libs.ref/sky130_fd_sc_hd__tt_025C_1v80_for_clk_skew_adjust.lib]
set ::env(LIB_TYPICAL) $::env(LIB_SYNTH)
set ::env(LIB_FASTEST) $::env(LIB_SYNTH)
set ::env(LIB_SLOWEST) $::env(LIB_SYNTH)

# Define
set ::env(SYNTH_DEFINES) "SYNTHESIS"
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(DESIGN_IS_CORE) 0
set ::env(DESIGN_NAME) clk_skew_adjust

set ::env(VERILOG_INCLUDE_DIRS) [glob $script_dir/../../verilog/lib]

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
  $script_dir/../../verilog/lib/clk_skew_adjust.gv \
  $script_dir/../../verilog/lib/ctech_cells.sv"

set ::env(CLOCK_PORT) ""
#set ::env(CLOCK_PORT) "clk_in"
#set ::env(CLOCK_PERIOD) 10

set ::env(CLOCK_TREE_SYNTH) 0

set ::env(BASE_SDC_FILE) $script_dir/base.sdc
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(FP_CORE_UTIL) 30
set ::env(PL_TIME_DRIVEN) 1
set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) 0.35

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
