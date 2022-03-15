// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*--------------------------------------*/
/* User project is instantiated  here   */
/*--------------------------------------*/
  // For data_arrays_0_ext
  wire [11:0] data_arrays_0_ext_RW0_addr;
  wire        data_arrays_0_ext_RW0_clk;
  wire [31:0] data_arrays_0_ext_RW0_wdata;
  wire [3:0]  data_arrays_0_ext_RW0_wmask;
  wire [7:0]  data_arrays_0_ext_ram_csb;
  wire        data_arrays_0_ext_ram_web;
  wire [31:0] data_arrays_0_ext_ram_rdata0;
  wire [31:0] data_arrays_0_ext_ram_rdata1;
  wire [31:0] data_arrays_0_ext_ram_rdata2;
  wire [31:0] data_arrays_0_ext_ram_rdata3;
  wire [31:0] data_arrays_0_ext_ram_rdata4;
  wire [31:0] data_arrays_0_ext_ram_rdata5;
  wire [31:0] data_arrays_0_ext_ram_rdata6;
  wire [31:0] data_arrays_0_ext_ram_rdata7;

  // For tag_array_ext
  wire [6:0]  tag_array_ext_RW0_addr;
  wire        tag_array_ext_RW0_clk;
  wire [39:0] tag_array_ext_RW0_wdata;
  wire [1:0]  tag_array_ext_RW0_wmask;
  wire        tag_array_ext_ram_csb;
  wire        tag_array_ext_ram_web;
  wire [31:0] tag_array_ext_ram_rdata0;
  wire [31:0] tag_array_ext_ram_rdata1;

  // For data_arrays_0_0_ext
  wire [10:0] data_arrays_0_0_ext_RW0_addr;
  wire        data_arrays_0_0_ext_RW0_clk;
  wire [63:0] data_arrays_0_0_ext_RW0_wdata;
  wire [1:0]  data_arrays_0_0_ext_RW0_wmask;
  wire [3:0]  data_arrays_0_0_ext_ram_csb;
  wire        data_arrays_0_0_ext_ram_web;
  wire [63:0] data_arrays_0_0_ext_ram_rdata0;
  wire [63:0] data_arrays_0_0_ext_ram_rdata1;
  wire [63:0] data_arrays_0_0_ext_ram_rdata2;
  wire [63:0] data_arrays_0_0_ext_ram_rdata3;

Marmot Marmot (
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),

    // MGMT SoC Wishbone Slave

    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_dat_o(wbs_dat_o),

    // Logic Analyzer

    .la_data_in(la_data_in),
    .la_data_out(la_data_out),
    .la_oenb (la_oenb),

    // IO Pads

    .io_in (io_in),
    .io_out(io_out),
    .io_oeb(io_oeb),

    // IRQ
    .irq(user_irq),

    // RAM Signals
    .data_arrays_0_ext_RW0_addr(data_arrays_0_ext_RW0_addr),
    .data_arrays_0_ext_RW0_clk(data_arrays_0_ext_RW0_clk),
    .data_arrays_0_ext_RW0_wdata(data_arrays_0_ext_RW0_wdata),
    .data_arrays_0_ext_RW0_wmask(data_arrays_0_ext_RW0_wmask),
    .data_arrays_0_ext_ram_csb(data_arrays_0_ext_ram_csb),
    .data_arrays_0_ext_ram_web(data_arrays_0_ext_ram_web),
    .data_arrays_0_ext_ram_rdata0(data_arrays_0_ext_ram_rdata0),
    .data_arrays_0_ext_ram_rdata1(data_arrays_0_ext_ram_rdata1),
    .data_arrays_0_ext_ram_rdata2(data_arrays_0_ext_ram_rdata2),
    .data_arrays_0_ext_ram_rdata3(data_arrays_0_ext_ram_rdata3),
    .data_arrays_0_ext_ram_rdata4(data_arrays_0_ext_ram_rdata4),
    .data_arrays_0_ext_ram_rdata5(data_arrays_0_ext_ram_rdata5),
    .data_arrays_0_ext_ram_rdata6(data_arrays_0_ext_ram_rdata6),
    .data_arrays_0_ext_ram_rdata7(data_arrays_0_ext_ram_rdata7),
    .tag_array_ext_RW0_addr(tag_array_ext_RW0_addr),
    .tag_array_ext_RW0_clk(tag_array_ext_RW0_clk),
    .tag_array_ext_RW0_wdata(tag_array_ext_RW0_wdata),
    .tag_array_ext_RW0_wmask(tag_array_ext_RW0_wmask),
    .tag_array_ext_ram_csb(tag_array_ext_ram_csb),
    .tag_array_ext_ram_web(tag_array_ext_ram_web),
    .tag_array_ext_ram_rdata0(tag_array_ext_ram_rdata0),
    .tag_array_ext_ram_rdata1(tag_array_ext_ram_rdata1),
    .data_arrays_0_0_ext_RW0_addr(data_arrays_0_0_ext_RW0_addr),
    .data_arrays_0_0_ext_RW0_clk(data_arrays_0_0_ext_RW0_clk),
    .data_arrays_0_0_ext_RW0_wdata(data_arrays_0_0_ext_RW0_wdata),
    .data_arrays_0_0_ext_RW0_wmask(data_arrays_0_0_ext_RW0_wmask),
    .data_arrays_0_0_ext_ram_csb(data_arrays_0_0_ext_ram_csb),
    .data_arrays_0_0_ext_ram_web(data_arrays_0_0_ext_ram_web),
    .data_arrays_0_0_ext_ram_rdata0(data_arrays_0_0_ext_ram_rdata0),
    .data_arrays_0_0_ext_ram_rdata1(data_arrays_0_0_ext_ram_rdata1),
    .data_arrays_0_0_ext_ram_rdata2(data_arrays_0_0_ext_ram_rdata2),
    .data_arrays_0_0_ext_ram_rdata3(data_arrays_0_0_ext_ram_rdata3)
);

`ifndef VERBOSE
  `define VERBOSE 0
`endif

//-----------------------------------------------------------------------
// RAMs for data_arrays_0_ext
//-----------------------------------------------------------------------

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram0 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[0]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_RW0_wmask),  // write mask
    .addr0  (data_arrays_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_ext_RW0_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata0),
    .clk1   (data_arrays_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram1 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[1]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_RW0_wmask),  // write mask
    .addr0  (data_arrays_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_ext_RW0_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata1),
    .clk1   (data_arrays_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram2 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[2]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_RW0_wmask),  // write mask
    .addr0  (data_arrays_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_ext_RW0_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata2),
    .clk1   (data_arrays_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram3 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[3]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_RW0_wmask),  // write mask
    .addr0  (data_arrays_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_ext_RW0_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata3),
    .clk1   (data_arrays_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram4 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[4]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_RW0_wmask),  // write mask
    .addr0  (data_arrays_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_ext_RW0_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata4),
    .clk1   (data_arrays_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram5 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[5]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_RW0_wmask),  // write mask
    .addr0  (data_arrays_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_ext_RW0_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata5),
    .clk1   (data_arrays_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram6 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[6]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_RW0_wmask),  // write mask
    .addr0  (data_arrays_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_ext_RW0_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata6),
    .clk1   (data_arrays_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram7 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[7]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_RW0_wmask),  // write mask
    .addr0  (data_arrays_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_ext_RW0_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata7),
    .clk1   (data_arrays_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

//-----------------------------------------------------------------------
// RAMs for tag_array_ext
//-----------------------------------------------------------------------

  sky130_sram_1kbyte_1rw1r_32x256_8 #(.VERBOSE(`VERBOSE)) tag_array_ext_ram0h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (tag_array_ext_RW0_clk),    // clock
    .csb0   (tag_array_ext_ram_csb),    // active low chip select
    .web0   (tag_array_ext_ram_web),    // active low write control
    .wmask0 ({4{tag_array_ext_RW0_wmask[1]}}), // write mask
    .addr0  ({1'b0, tag_array_ext_RW0_addr}),
    .din0   ({12'd0, tag_array_ext_RW0_wdata[39:20]}),
    .dout0  (tag_array_ext_ram_rdata1),
    .clk1   (tag_array_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (8'd0),
    .dout1  ()
  );

  sky130_sram_1kbyte_1rw1r_32x256_8 #(.VERBOSE(`VERBOSE)) tag_array_ext_ram0l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (tag_array_ext_RW0_clk),    // clock
    .csb0   (tag_array_ext_ram_csb),    // active low chip select
    .web0   (tag_array_ext_ram_web),    // active low write control
    .wmask0 ({4{tag_array_ext_RW0_wmask[0]}}), // write mask
    .addr0  ({1'b0, tag_array_ext_RW0_addr}),
    .din0   ({12'd0, tag_array_ext_RW0_wdata[19:0]}),
    .dout0  (tag_array_ext_ram_rdata0),
    .clk1   (tag_array_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (8'd0),
    .dout1  ()
  );

//-----------------------------------------------------------------------
// RAMs for  data_arrays_0_0_ext
//-----------------------------------------------------------------------

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram0h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[0]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_RW0_wmask[1]}}), // write mask
    .addr0  (data_arrays_0_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_0_ext_RW0_wdata[63:32]),
    .dout0  (data_arrays_0_0_ext_ram_rdata0[63:32]),
    .clk1   (data_arrays_0_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram0l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[0]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_RW0_wmask[0]}}), // write mask
    .addr0  (data_arrays_0_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_0_ext_RW0_wdata[31:0]),
    .dout0  (data_arrays_0_0_ext_ram_rdata0[31:0]),
    .clk1   (data_arrays_0_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram1h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[1]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_RW0_wmask[1]}}), // write mask
    .addr0  (data_arrays_0_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_0_ext_RW0_wdata[63:32]),
    .dout0  (data_arrays_0_0_ext_ram_rdata1[63:32]),
    .clk1   (data_arrays_0_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram1l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[1]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_RW0_wmask[0]}}), // write mask
    .addr0  (data_arrays_0_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_0_ext_RW0_wdata[31:0]),
    .dout0  (data_arrays_0_0_ext_ram_rdata1[31:0]),
    .clk1   (data_arrays_0_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram2h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[2]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_RW0_wmask[1]}}), // write mask
    .addr0  (data_arrays_0_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_0_ext_RW0_wdata[63:32]),
    .dout0  (data_arrays_0_0_ext_ram_rdata2[63:32]),
    .clk1   (data_arrays_0_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram2l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[2]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_RW0_wmask[0]}}), // write mask
    .addr0  (data_arrays_0_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_0_ext_RW0_wdata[31:0]),
    .dout0  (data_arrays_0_0_ext_ram_rdata2[31:0]),
    .clk1   (data_arrays_0_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram3h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[3]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_RW0_wmask[1]}}), // write mask
    .addr0  (data_arrays_0_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_0_ext_RW0_wdata[63:32]),
    .dout0  (data_arrays_0_0_ext_ram_rdata3[63:32]),
    .clk1   (data_arrays_0_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram3l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_RW0_clk),    // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[3]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_RW0_wmask[0]}}), // write mask
    .addr0  (data_arrays_0_0_ext_RW0_addr[8:0]),
    .din0   (data_arrays_0_0_ext_RW0_wdata[31:0]),
    .dout0  (data_arrays_0_0_ext_ram_rdata3[31:0]),
    .clk1   (data_arrays_0_0_ext_RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

endmodule	// user_project_wrapper

`default_nettype wire
