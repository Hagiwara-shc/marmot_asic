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

// RAM message control
`ifndef VERBOSE
  `define VERBOSE 0
`endif

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
  // RAM clock skew adjust
  wire [31:0] ram_clk_delay_sel;

  // DTIM RAM I/F
//wire [8:0]  data_arrays_0_ext_ram_addr;
//wire        data_arrays_0_ext_ram_clk;
//wire [31:0] data_arrays_0_ext_ram_wdata;
//wire [3:0]  data_arrays_0_ext_ram_wmask;
//wire [7:0]  data_arrays_0_ext_ram_csb;
//wire        data_arrays_0_ext_ram_web;
//wire [31:0] data_arrays_0_ext_ram_rdata0;
//wire [31:0] data_arrays_0_ext_ram_rdata1;
//wire [31:0] data_arrays_0_ext_ram_rdata2;
//wire [31:0] data_arrays_0_ext_ram_rdata3;
//wire [31:0] data_arrays_0_ext_ram_rdata4;
//wire [31:0] data_arrays_0_ext_ram_rdata5;
//wire [31:0] data_arrays_0_ext_ram_rdata6;
//wire [31:0] data_arrays_0_ext_ram_rdata7;
//wire [7:0]  data_arrays_0_ext_ram_csb1;
//wire [8:0]  data_arrays_0_ext_ram_addr1;

  // I-Cache Tag RAM I/F
  wire        tag_array_ext_ram_clk;
  wire        tag_array_ext_ram_csb;
  wire        tag_array_ext_ram_web;
  wire [7:0]  tag_array_ext_ram_addr;
  wire [63:0] tag_array_ext_ram_wdata;
  wire [1:0]  tag_array_ext_ram_wmask;
  wire [31:0] tag_array_ext_ram_rdata0;
  wire [31:0] tag_array_ext_ram_rdata1;
  wire        tag_array_ext_ram_csb1;
  wire [7:0]  tag_array_ext_ram_addr1;

  // I-Cache Data RAM I/F
  wire        data_arrays_0_0_ext_ram_clk0;
  wire        data_arrays_0_0_ext_ram_clk1;
  wire        data_arrays_0_0_ext_ram_clk2;
  wire        data_arrays_0_0_ext_ram_clk3;
  wire [3:0]  data_arrays_0_0_ext_ram_csb;
  wire        data_arrays_0_0_ext_ram_web0;
  wire        data_arrays_0_0_ext_ram_web1;
  wire        data_arrays_0_0_ext_ram_web2;
  wire        data_arrays_0_0_ext_ram_web3;
  wire [8:0]  data_arrays_0_0_ext_ram_addr00;
  wire [8:0]  data_arrays_0_0_ext_ram_addr01;
  wire [8:0]  data_arrays_0_0_ext_ram_addr02;
  wire [8:0]  data_arrays_0_0_ext_ram_addr03;
  wire [63:0] data_arrays_0_0_ext_ram_wdata0;
  wire [63:0] data_arrays_0_0_ext_ram_wdata1;
  wire [63:0] data_arrays_0_0_ext_ram_wdata2;
  wire [63:0] data_arrays_0_0_ext_ram_wdata3;
  wire [1:0]  data_arrays_0_0_ext_ram_wmask0;
  wire [1:0]  data_arrays_0_0_ext_ram_wmask1;
  wire [1:0]  data_arrays_0_0_ext_ram_wmask2;
  wire [1:0]  data_arrays_0_0_ext_ram_wmask3;
  wire [63:0] data_arrays_0_0_ext_ram_rdata0;
  wire [63:0] data_arrays_0_0_ext_ram_rdata1;
  wire [63:0] data_arrays_0_0_ext_ram_rdata2;
  wire [63:0] data_arrays_0_0_ext_ram_rdata3;
  wire [3:0]  data_arrays_0_0_ext_ram_csb1;
  wire [8:0]  data_arrays_0_0_ext_ram_addr10;
  wire [8:0]  data_arrays_0_0_ext_ram_addr11;
  wire [8:0]  data_arrays_0_0_ext_ram_addr12;
  wire [8:0]  data_arrays_0_0_ext_ram_addr13;

Marmot Marmot (
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif
    // Clock and Reset
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

    // RAM clock skew adjust
    .ram_clk_delay_sel(ram_clk_delay_sel),

    // DTIM RAM I/F
//  .data_arrays_0_ext_ram_addr(data_arrays_0_ext_ram_addr),
//  .data_arrays_0_ext_ram_clk(),
//  .data_arrays_0_ext_ram_wdata(data_arrays_0_ext_ram_wdata),
//  .data_arrays_0_ext_ram_wmask(data_arrays_0_ext_ram_wmask),
//  .data_arrays_0_ext_ram_csb(data_arrays_0_ext_ram_csb),
//  .data_arrays_0_ext_ram_web(data_arrays_0_ext_ram_web),
//  .data_arrays_0_ext_ram_rdata0(data_arrays_0_ext_ram_rdata0),
//  .data_arrays_0_ext_ram_rdata1(data_arrays_0_ext_ram_rdata1),
//  .data_arrays_0_ext_ram_rdata2(data_arrays_0_ext_ram_rdata2),
//  .data_arrays_0_ext_ram_rdata3(data_arrays_0_ext_ram_rdata3),
//  .data_arrays_0_ext_ram_rdata4(data_arrays_0_ext_ram_rdata4),
//  .data_arrays_0_ext_ram_rdata5(data_arrays_0_ext_ram_rdata5),
//  .data_arrays_0_ext_ram_rdata6(data_arrays_0_ext_ram_rdata6),
//  .data_arrays_0_ext_ram_rdata7(data_arrays_0_ext_ram_rdata7),
//  .data_arrays_0_ext_ram_csb1(data_arrays_0_ext_ram_csb1),
//  .data_arrays_0_ext_ram_addr1(data_arrays_0_ext_ram_addr1),

    // I-Cache Tag RAM I/F
    .tag_array_ext_ram_clk(),
    .tag_array_ext_ram_csb(tag_array_ext_ram_csb),
    .tag_array_ext_ram_web(tag_array_ext_ram_web),
    .tag_array_ext_ram_addr(tag_array_ext_ram_addr),
    .tag_array_ext_ram_wdata(tag_array_ext_ram_wdata),
    .tag_array_ext_ram_wmask(tag_array_ext_ram_wmask),
    .tag_array_ext_ram_rdata0(tag_array_ext_ram_rdata0),
    .tag_array_ext_ram_rdata1(tag_array_ext_ram_rdata1),
    .tag_array_ext_ram_csb1(tag_array_ext_ram_csb1),
    .tag_array_ext_ram_addr1(tag_array_ext_ram_addr1),

    // I-Cache Data RAM I/F
    .data_arrays_0_0_ext_ram_clk(),
    .data_arrays_0_0_ext_ram_csb(data_arrays_0_0_ext_ram_csb),
    .data_arrays_0_0_ext_ram_web0(data_arrays_0_0_ext_ram_web0),
    .data_arrays_0_0_ext_ram_web1(data_arrays_0_0_ext_ram_web1),
    .data_arrays_0_0_ext_ram_web2(data_arrays_0_0_ext_ram_web2),
    .data_arrays_0_0_ext_ram_web3(data_arrays_0_0_ext_ram_web3),
    .data_arrays_0_0_ext_ram_addr00(data_arrays_0_0_ext_ram_addr00),
    .data_arrays_0_0_ext_ram_addr01(data_arrays_0_0_ext_ram_addr01),
    .data_arrays_0_0_ext_ram_addr02(data_arrays_0_0_ext_ram_addr02),
    .data_arrays_0_0_ext_ram_addr03(data_arrays_0_0_ext_ram_addr03),
    .data_arrays_0_0_ext_ram_wdata0(data_arrays_0_0_ext_ram_wdata0),
    .data_arrays_0_0_ext_ram_wdata1(data_arrays_0_0_ext_ram_wdata1),
    .data_arrays_0_0_ext_ram_wdata2(data_arrays_0_0_ext_ram_wdata2),
    .data_arrays_0_0_ext_ram_wdata3(data_arrays_0_0_ext_ram_wdata3),
    .data_arrays_0_0_ext_ram_wmask0(data_arrays_0_0_ext_ram_wmask0),
    .data_arrays_0_0_ext_ram_wmask1(data_arrays_0_0_ext_ram_wmask1),
    .data_arrays_0_0_ext_ram_wmask2(data_arrays_0_0_ext_ram_wmask2),
    .data_arrays_0_0_ext_ram_wmask3(data_arrays_0_0_ext_ram_wmask3),
    .data_arrays_0_0_ext_ram_rdata0(data_arrays_0_0_ext_ram_rdata0),
    .data_arrays_0_0_ext_ram_rdata1(data_arrays_0_0_ext_ram_rdata1),
    .data_arrays_0_0_ext_ram_rdata2(data_arrays_0_0_ext_ram_rdata2),
    .data_arrays_0_0_ext_ram_rdata3(data_arrays_0_0_ext_ram_rdata3),
    .data_arrays_0_0_ext_ram_csb1(data_arrays_0_0_ext_ram_csb1),
    .data_arrays_0_0_ext_ram_addr10(data_arrays_0_0_ext_ram_addr10),
    .data_arrays_0_0_ext_ram_addr11(data_arrays_0_0_ext_ram_addr11),
    .data_arrays_0_0_ext_ram_addr12(data_arrays_0_0_ext_ram_addr12),
    .data_arrays_0_0_ext_ram_addr13(data_arrays_0_0_ext_ram_addr13)
);

//-----------------------------------------------------------------------
// DTIM RAMs
//-----------------------------------------------------------------------
`ifdef DO_NOT_DEFINE
  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram0 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_ram_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[0]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_ram_wmask),  // write mask
    .addr0  (data_arrays_0_ext_ram_addr),
    .din0   (data_arrays_0_ext_ram_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata0),
    .clk1   (data_arrays_0_ext_ram_clk),    // clock
    .csb1   (data_arrays_0_ext_ram_csb1[0]),// active low chip select
    .addr1  (data_arrays_0_ext_ram_addr1),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram1 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_ram_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[1]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_ram_wmask),  // write mask
    .addr0  (data_arrays_0_ext_ram_addr),
    .din0   (data_arrays_0_ext_ram_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata1),
    .clk1   (data_arrays_0_ext_ram_clk),    // clock
    .csb1   (data_arrays_0_ext_ram_csb1[1]),// active low chip select
    .addr1  (data_arrays_0_ext_ram_addr1),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram2 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_ram_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[2]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_ram_wmask),  // write mask
    .addr0  (data_arrays_0_ext_ram_addr),
    .din0   (data_arrays_0_ext_ram_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata2),
    .clk1   (data_arrays_0_ext_ram_clk),    // clock
    .csb1   (data_arrays_0_ext_ram_csb1[2]),// active low chip select
    .addr1  (data_arrays_0_ext_ram_addr1),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram3 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_ram_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[3]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_ram_wmask),  // write mask
    .addr0  (data_arrays_0_ext_ram_addr),
    .din0   (data_arrays_0_ext_ram_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata3),
    .clk1   (data_arrays_0_ext_ram_clk),    // clock
    .csb1   (data_arrays_0_ext_ram_csb1[3]),// active low chip select
    .addr1  (data_arrays_0_ext_ram_addr1),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram4 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_ram_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[4]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_ram_wmask),  // write mask
    .addr0  (data_arrays_0_ext_ram_addr),
    .din0   (data_arrays_0_ext_ram_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata4),
    .clk1   (data_arrays_0_ext_ram_clk),    // clock
    .csb1   (data_arrays_0_ext_ram_csb1[4]),// active low chip select
    .addr1  (data_arrays_0_ext_ram_addr1),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram5 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_ram_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[5]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_ram_wmask),  // write mask
    .addr0  (data_arrays_0_ext_ram_addr),
    .din0   (data_arrays_0_ext_ram_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata5),
    .clk1   (data_arrays_0_ext_ram_clk),    // clock
    .csb1   (data_arrays_0_ext_ram_csb1[5]),// active low chip select
    .addr1  (data_arrays_0_ext_ram_addr1),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram6 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_ram_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[6]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_ram_wmask),  // write mask
    .addr0  (data_arrays_0_ext_ram_addr),
    .din0   (data_arrays_0_ext_ram_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata6),
    .clk1   (data_arrays_0_ext_ram_clk),    // clock
    .csb1   (data_arrays_0_ext_ram_csb1[6]),// active low chip select
    .addr1  (data_arrays_0_ext_ram_addr1),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_ext_ram7 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_ext_ram_clk),    // clock
    .csb0   (data_arrays_0_ext_ram_csb[7]), // active low chip select
    .web0   (data_arrays_0_ext_ram_web),    // active low write control
    .wmask0 (data_arrays_0_ext_ram_wmask),  // write mask
    .addr0  (data_arrays_0_ext_ram_addr),
    .din0   (data_arrays_0_ext_ram_wdata),
    .dout0  (data_arrays_0_ext_ram_rdata7),
    .clk1   (data_arrays_0_ext_ram_clk),    // clock
    .csb1   (data_arrays_0_ext_ram_csb1[7]),// active low chip select
    .addr1  (data_arrays_0_ext_ram_addr1),
    .dout1  ()
  );
`endif // DO_NOT_DEFINE

//-----------------------------------------------------------------------
// I-Cache Tag RAMs
//-----------------------------------------------------------------------
  clk_skew_adjust u_clk_skew_adjust_0 (
    `ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
    `endif
      .clk_in(wb_clk_i),
      .sel(ram_clk_delay_sel[4:0]),
      .clk_out(tag_array_ext_ram_clk)
  );

  sky130_sram_1kbyte_1rw1r_32x256_8 #(.VERBOSE(`VERBOSE)) tag_array_ext_ram0h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (tag_array_ext_ram_clk),    // clock
    .csb0   (tag_array_ext_ram_csb),    // active low chip select
    .web0   (tag_array_ext_ram_web),    // active low write control
    .wmask0 ({4{tag_array_ext_ram_wmask[1]}}), // write mask
    .addr0  (tag_array_ext_ram_addr),
    .din0   (tag_array_ext_ram_wdata[63:32]),
    .dout0  (tag_array_ext_ram_rdata1),
    .clk1   (tag_array_ext_ram_clk),    // clock
    .csb1   (tag_array_ext_ram_csb1),   // active low chip select
    .addr1  (tag_array_ext_ram_addr1),
    .dout1  ()
  );

  sky130_sram_1kbyte_1rw1r_32x256_8 #(.VERBOSE(`VERBOSE)) tag_array_ext_ram0l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (tag_array_ext_ram_clk),    // clock
    .csb0   (tag_array_ext_ram_csb),    // active low chip select
    .web0   (tag_array_ext_ram_web),    // active low write control
    .wmask0 ({4{tag_array_ext_ram_wmask[0]}}), // write mask
    .addr0  (tag_array_ext_ram_addr),
    .din0   (tag_array_ext_ram_wdata[31:0]),
    .dout0  (tag_array_ext_ram_rdata0),
    .clk1   (tag_array_ext_ram_clk),    // clock
    .csb1   (tag_array_ext_ram_csb1),   // active low chip select
    .addr1  (tag_array_ext_ram_addr1),
    .dout1  ()
  );

//-----------------------------------------------------------------------
// I-Cache Data RAMs
//-----------------------------------------------------------------------
  clk_skew_adjust u_clk_skew_adjust_1 (
    `ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
    `endif
      .clk_in(wb_clk_i),
      .sel(ram_clk_delay_sel[9:5]),
      .clk_out(data_arrays_0_0_ext_ram_clk0)
  );

  clk_skew_adjust u_clk_skew_adjust_2 (
    `ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
    `endif
      .clk_in(wb_clk_i),
      .sel(ram_clk_delay_sel[14:10]),
      .clk_out(data_arrays_0_0_ext_ram_clk1)
  );

  clk_skew_adjust u_clk_skew_adjust_3 (
    `ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
    `endif
      .clk_in(wb_clk_i),
      .sel(ram_clk_delay_sel[19:15]),
      .clk_out(data_arrays_0_0_ext_ram_clk2)
  );

  clk_skew_adjust u_clk_skew_adjust_4 (
    `ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
    `endif
      .clk_in(wb_clk_i),
      .sel(ram_clk_delay_sel[24:20]),
      .clk_out(data_arrays_0_0_ext_ram_clk3)
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram0h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_ram_clk0),   // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[0]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web0),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_ram_wmask0[1]}}), // write mask
    .addr0  (data_arrays_0_0_ext_ram_addr00),
    .din0   (data_arrays_0_0_ext_ram_wdata0[63:32]),
    .dout0  (data_arrays_0_0_ext_ram_rdata0[63:32]),
    .clk1   (data_arrays_0_0_ext_ram_clk0),   // clock
    .csb1   (data_arrays_0_0_ext_ram_csb1[0]),// active low chip select
    .addr1  (data_arrays_0_0_ext_ram_addr10),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram0l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_ram_clk0),   // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[0]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web0),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_ram_wmask0[0]}}), // write mask
    .addr0  (data_arrays_0_0_ext_ram_addr00),
    .din0   (data_arrays_0_0_ext_ram_wdata0[31:0]),
    .dout0  (data_arrays_0_0_ext_ram_rdata0[31:0]),
    .clk1   (data_arrays_0_0_ext_ram_clk0),   // clock
    .csb1   (data_arrays_0_0_ext_ram_csb1[0]),// active low chip select
    .addr1  (data_arrays_0_0_ext_ram_addr10),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram1h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_ram_clk1),   // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[1]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web1),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_ram_wmask1[1]}}), // write mask
    .addr0  (data_arrays_0_0_ext_ram_addr01),
    .din0   (data_arrays_0_0_ext_ram_wdata1[63:32]),
    .dout0  (data_arrays_0_0_ext_ram_rdata1[63:32]),
    .clk1   (data_arrays_0_0_ext_ram_clk1),   // clock
    .csb1   (data_arrays_0_0_ext_ram_csb1[1]),// active low chip select
    .addr1  (data_arrays_0_0_ext_ram_addr11),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram1l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_ram_clk1),   // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[1]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web1),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_ram_wmask1[0]}}), // write mask
    .addr0  (data_arrays_0_0_ext_ram_addr01),
    .din0   (data_arrays_0_0_ext_ram_wdata1[31:0]),
    .dout0  (data_arrays_0_0_ext_ram_rdata1[31:0]),
    .clk1   (data_arrays_0_0_ext_ram_clk1),   // clock
    .csb1   (data_arrays_0_0_ext_ram_csb1[1]),// active low chip select
    .addr1  (data_arrays_0_0_ext_ram_addr11),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram2h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_ram_clk2),   // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[2]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web2),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_ram_wmask2[1]}}), // write mask
    .addr0  (data_arrays_0_0_ext_ram_addr02),
    .din0   (data_arrays_0_0_ext_ram_wdata2[63:32]),
    .dout0  (data_arrays_0_0_ext_ram_rdata2[63:32]),
    .clk1   (data_arrays_0_0_ext_ram_clk2),   // clock
    .csb1   (data_arrays_0_0_ext_ram_csb1[2]),// active low chip select
    .addr1  (data_arrays_0_0_ext_ram_addr12),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram2l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_ram_clk2),   // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[2]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web2),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_ram_wmask2[0]}}), // write mask
    .addr0  (data_arrays_0_0_ext_ram_addr02),
    .din0   (data_arrays_0_0_ext_ram_wdata2[31:0]),
    .dout0  (data_arrays_0_0_ext_ram_rdata2[31:0]),
    .clk1   (data_arrays_0_0_ext_ram_clk2),   // clock
    .csb1   (data_arrays_0_0_ext_ram_csb1[2]),// active low chip select
    .addr1  (data_arrays_0_0_ext_ram_addr12),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram3h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_ram_clk3),   // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[3]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web3),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_ram_wmask3[1]}}), // write mask
    .addr0  (data_arrays_0_0_ext_ram_addr03),
    .din0   (data_arrays_0_0_ext_ram_wdata3[63:32]),
    .dout0  (data_arrays_0_0_ext_ram_rdata3[63:32]),
    .clk1   (data_arrays_0_0_ext_ram_clk3),   // clock
    .csb1   (data_arrays_0_0_ext_ram_csb1[3]),// active low chip select
    .addr1  (data_arrays_0_0_ext_ram_addr13),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) data_arrays_0_0_ext_ram3l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (data_arrays_0_0_ext_ram_clk3),   // clock
    .csb0   (data_arrays_0_0_ext_ram_csb[3]), // active low chip select
    .web0   (data_arrays_0_0_ext_ram_web3),    // active low write control
    .wmask0 ({4{data_arrays_0_0_ext_ram_wmask3[0]}}), // write mask
    .addr0  (data_arrays_0_0_ext_ram_addr03),
    .din0   (data_arrays_0_0_ext_ram_wdata3[31:0]),
    .dout0  (data_arrays_0_0_ext_ram_rdata3[31:0]),
    .clk1   (data_arrays_0_0_ext_ram_clk3),   // clock
    .csb1   (data_arrays_0_0_ext_ram_csb1[3]),// active low chip select
    .addr1  (data_arrays_0_0_ext_ram_addr13),
    .dout1  ()
  );

endmodule	// user_project_wrapper

`default_nettype wire
