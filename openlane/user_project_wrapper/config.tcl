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

# Base Configurations. Don't Touch
# section begin

set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

# YOU ARE NOT ALLOWED TO CHANGE ANY VARIABLES DEFINED IN THE FIXED WRAPPER CFGS 
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper/fixed_wrapper_cfgs.tcl

# YOU CAN CHANGE ANY VARIABLES DEFINED IN THE DEFAULT WRAPPER CFGS BY OVERRIDING THEM IN THIS CONFIG.TCL
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper/default_wrapper_cfgs.tcl

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_project_wrapper
#section end

# User Configurations

# save some time
set ::env(RUN_KLAYOUT_XOR) 0
set ::env(RUN_KLAYOUT_DRC) 0
# no point in running DRC with magic once openram is in because it will find 3M issues
# try to turn off all DRC checking so the flow completes and use precheck for DRC instead.
set ::env(MAGIC_DRC_USE_GDS) 0
set ::env(RUN_MAGIC_DRC) 0
set ::env(QUIT_ON_MAGIC_DRC) 0

set ::env(ROUTING_CORES) 4

# Define
set ::env(SYNTH_DEFINES) "MARMOT_EMPTY"

## Source Verilog Files
set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

## Clock configurations
set ::env(CLOCK_PORT) "wb_clk_i"
#set ::env(CLOCK_NET) "Marmot.clk"

set ::env(CLOCK_PERIOD) "40"

set ::env(FP_PDN_HPITCH) 105
set ::env(FP_PDN_VPITCH) 100

#set ::env(FP_PDN_HWIDTH) 2.9

## Internal Macros
### Macro PDN Connections
set ::env(FP_PDN_MACRO_HOOKS) "\
	Marmot vccd1 vssd1 \
        data_arrays_0_0_ext_ram0l vccd1 vssd1 \
        data_arrays_0_0_ext_ram0h vccd1 vssd1 \
        data_arrays_0_0_ext_ram1l vccd1 vssd1 \
        data_arrays_0_0_ext_ram1h vccd1 vssd1 \
        data_arrays_0_0_ext_ram2l vccd1 vssd1 \
        data_arrays_0_0_ext_ram2h vccd1 vssd1 \
        data_arrays_0_0_ext_ram3l vccd1 vssd1 \
        data_arrays_0_0_ext_ram3h vccd1 vssd1 \
        tag_array_ext_ram0l vccd1 vssd1 \
        tag_array_ext_ram0h vccd1 vssd1"

### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/marmot/Marmot.v \
        $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/verilog/sky130_sram_2kbyte_1rw1r_32x512_8.v \
        $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/verilog/sky130_sram_1kbyte_1rw1r_32x256_8.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/Marmot.lef \
        $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/lef/sky130_sram_2kbyte_1rw1r_32x512_8.lef \
        $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_32x256_8.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/Marmot.gds.gz \
        $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/gds/sky130_sram_2kbyte_1rw1r_32x512_8.gds \
        $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/gds/sky130_sram_1kbyte_1rw1r_32x256_8.gds"

set ::env(EXTRA_LIBS) "\
        $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/lib/sky130_sram_1kbyte_1rw1r_32x256_8_TT_1p8V_25C.lib \
        $::env(PDK_ROOT)/sky130A/libs.ref/sky130_sram_macros/lib/sky130_sram_2kbyte_1rw1r_32x512_8_TT_1p8V_25C.lib"

# Obstruction over SRAMs
set ::env(GLB_RT_OBS) " \
    met1  150.00  150.00  833.10  566.54,
    met2  150.00  150.00  833.10  566.54,
    met3  150.00  150.00  833.10  566.54,
    met4  150.00  150.00  833.10  566.54,
    met1  150.00  710.00  833.10 1126.54,
    met2  150.00  710.00  833.10 1126.54,
    met3  150.00  710.00  833.10 1126.54,
    met4  150.00  710.00  833.10 1126.54,
    met1  150.00 1270.00  833.10 1686.54,
    met2  150.00 1270.00  833.10 1686.54,
    met3  150.00 1270.00  833.10 1686.54,
    met4  150.00 1270.00  833.10 1686.54,
    met1  150.00 1830.00  833.10 2246.54,
    met2  150.00 1830.00  833.10 2246.54,
    met3  150.00 1830.00  833.10 2246.54,
    met4  150.00 1830.00  833.10 2246.54,
    met1  150.00 2390.00  833.10 2806.54,
    met2  150.00 2390.00  833.10 2806.54,
    met3  150.00 2390.00  833.10 2806.54,
    met4  150.00 2390.00  833.10 2806.54,
    met1  150.00 2950.00  833.10 3366.54,
    met2  150.00 2950.00  833.10 3366.54,
    met3  150.00 2950.00  833.10 3366.54,
    met4  150.00 2950.00  833.10 3366.54,
    met1 1000.00 2270.00 1683.10 2686.54,
    met2 1000.00 2270.00 1683.10 2686.54,
    met3 1000.00 2270.00 1683.10 2686.54,
    met4 1000.00 2270.00 1683.10 2686.54,
    met1 2050.00 2270.00 2733.10 2686.54,
    met2 2050.00 2270.00 2733.10 2686.54,
    met3 2050.00 2270.00 2733.10 2686.54,
    met4 2050.00 2270.00 2733.10 2686.54,
    met1 1200.00 2890.00 1679.78 3287.50,
    met2 1200.00 2890.00 1679.78 3287.50,
    met3 1200.00 2890.00 1679.78 3287.50,
    met4 1200.00 2890.00 1679.78 3287.50,
    met1 2050.00 2890.00 2529.78 3287.50,
    met2 2050.00 2890.00 2529.78 3287.50,
    met3 2050.00 2890.00 2529.78 3287.50,
    met4 2050.00 2890.00 2529.78 3287.50"

# set ::env(GLB_RT_MAXLAYER) 5
set ::env(RT_MAX_LAYER) {met4}

set ::env(GLB_RT_ALLOW_CONGESTION) 1

# disable pdn check nodes becuase it hangs with multiple power domains.
# any issue with pdn connections will be flagged with LVS so it is not a critical check.
set ::env(FP_PDN_CHECK_NODES) 0

# The following is because there are no std cells in the example wrapper project.
set ::env(SYNTH_TOP_LEVEL) 1
set ::env(PL_RANDOM_GLB_PLACEMENT) 1

set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0

set ::env(FP_PDN_ENABLE_RAILS) 0

set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0
