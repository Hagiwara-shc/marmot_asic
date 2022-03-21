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

module Marmot
(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
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

    // IRQ
    output [2:0] irq,

    // RAM signals
    output [8:0]  data_arrays_0_ext_ram_addr,
    output        data_arrays_0_ext_ram_clk,
    output [31:0] data_arrays_0_ext_ram_wdata,
    output [3:0]  data_arrays_0_ext_ram_wmask,
    output [7:0]  data_arrays_0_ext_ram_csb,
    output        data_arrays_0_ext_ram_web,
    input  [31:0] data_arrays_0_ext_ram_rdata0,
    input  [31:0] data_arrays_0_ext_ram_rdata1,
    input  [31:0] data_arrays_0_ext_ram_rdata2,
    input  [31:0] data_arrays_0_ext_ram_rdata3,
//  input  [31:0] data_arrays_0_ext_ram_rdata4,
//  input  [31:0] data_arrays_0_ext_ram_rdata5,
//  input  [31:0] data_arrays_0_ext_ram_rdata6,
//  input  [31:0] data_arrays_0_ext_ram_rdata7,
    output [7:0]  data_arrays_0_ext_ram_csb1,
    output [8:0]  data_arrays_0_ext_ram_addr1,

    output [7:0]  tag_array_ext_ram_addr,
    output        tag_array_ext_ram_clk,
    output [63:0] tag_array_ext_ram_wdata,
    output [1:0]  tag_array_ext_ram_wmask,
    output        tag_array_ext_ram_csb,
    output        tag_array_ext_ram_web,
    input  [31:0] tag_array_ext_ram_rdata0,
    input  [31:0] tag_array_ext_ram_rdata1,
    output [1:0]  tag_array_ext_ram_csb1,
    output [7:0]  tag_array_ext_ram_addr1,

    output [8:0]  data_arrays_0_0_ext_ram_addr,
    output        data_arrays_0_0_ext_ram_clk,
    output [63:0] data_arrays_0_0_ext_ram_wdata,
    output [1:0]  data_arrays_0_0_ext_ram_wmask,
    output [3:0]  data_arrays_0_0_ext_ram_csb,
    output        data_arrays_0_0_ext_ram_web,
    input  [63:0] data_arrays_0_0_ext_ram_rdata0,
    input  [63:0] data_arrays_0_0_ext_ram_rdata1,
    input  [63:0] data_arrays_0_0_ext_ram_rdata2,
    input  [63:0] data_arrays_0_0_ext_ram_rdata3,
    output [7:0]  data_arrays_0_0_ext_ram_csb1,
    output [8:0]  data_arrays_0_0_ext_ram_addr1
);

    //------------------------------------------------------------------------------
    // RAM signals
    wire [11:0] data_arrays_0_ext_RW0_addr;
    wire        data_arrays_0_ext_RW0_clk;
    wire [31:0] data_arrays_0_ext_RW0_wdata;
    wire [3:0]  data_arrays_0_ext_RW0_wmask;
    wire        data_arrays_0_ext_RW0_en;
    wire        data_arrays_0_ext_RW0_wmode;
    wire [31:0] data_arrays_0_ext_RW0_rdata;
    wire [6:0]  tag_array_ext_RW0_addr;
    wire        tag_array_ext_RW0_clk;
    wire [39:0] tag_array_ext_RW0_wdata;
    wire [1:0]  tag_array_ext_RW0_wmask;
    wire        tag_array_ext_RW0_en;
    wire        tag_array_ext_RW0_wmode;
    wire [39:0] tag_array_ext_RW0_rdata;
    wire [10:0] data_arrays_0_0_ext_RW0_addr;
    wire        data_arrays_0_0_ext_RW0_clk;
    wire [63:0] data_arrays_0_0_ext_RW0_wdata;
    wire [1:0]  data_arrays_0_0_ext_RW0_wmask;
    wire        data_arrays_0_0_ext_RW0_en;
    wire        data_arrays_0_0_ext_RW0_wmode;
    wire [63:0] data_arrays_0_0_ext_RW0_rdata;

    //------------------------------------------------------------------------------
    // Wishbone Slave ports (WB MI A)
    reg wbs_ack_o;
    wire [31:0] wbs_dat_o;

    always @(posedge wb_clk_i) begin
      if (wb_rst_i) begin
        wbs_ack_o <= 1'b0;
      end
      else begin
        wbs_ack_o <= wbs_stb_i & wbs_cyc_i;
      end
    end

    assign wbs_dat_o = 32'd0;

    //------------------------------------------------------------------------------
    // Logic Analyzer Signals
    wire [127:0] la_data_out;

    assign la_data_out = 128'd0;

    //------------------------------------------------------------------------------
    // IRQ
    wire [2:0] irq;

    assign irq = 3'b000;

    //------------------------------------------------------------------------------
    // Clock and Reset to MarmotCaravelChip
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    wire clk;
    wire rst;

    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

    //------------------------------------------------------------------------------
    // MarmotCaravelChip (empty)
    assign io_out = la_data_in[`MPRJ_IO_PADS-1:0];
    assign io_oeb = la_data_in[`MPRJ_IO_PADS-1:0];
    assign data_arrays_0_ext_ram_addr = la_data_in[8:0];
    assign data_arrays_0_ext_ram_clk = clk;
    assign data_arrays_0_ext_ram_wdata = la_data_in[31:0];
    assign data_arrays_0_ext_ram_wmask = la_data_in[3:0];
    assign data_arrays_0_ext_ram_csb = la_data_in[7:0];
    assign data_arrays_0_ext_ram_web = la_data_in[0];
    assign data_arrays_0_ext_ram_csb1 = la_data_in[7:0];
    assign data_arrays_0_ext_ram_addr1 = la_data_in[8:0];
    assign tag_array_ext_ram_addr = la_data_in[7:0];
    assign tag_array_ext_ram_clk = clk;
    assign tag_array_ext_ram_wdata = la_data_in[63:0];
    assign tag_array_ext_ram_wmask = la_data_in[1:0];
    assign tag_array_ext_ram_csb = la_data_in[0];
    assign tag_array_ext_ram_web = la_data_in[0];
    assign tag_array_ext_ram_csb1 = la_data_in[1:0];
    assign tag_array_ext_ram_addr1 = la_data_in[7:0];
    assign data_arrays_0_0_ext_ram_addr = la_data_in[8:0];
    assign data_arrays_0_0_ext_ram_clk = clk;
    assign data_arrays_0_0_ext_ram_wdata = la_data_in[63:0];
    assign data_arrays_0_0_ext_ram_wmask = la_data_in[1:0];
    assign data_arrays_0_0_ext_ram_csb = la_data_in[3:0];
    assign data_arrays_0_0_ext_ram_web = la_data_in[0];
    assign data_arrays_0_0_ext_ram_csb1 = la_data_in[7:0];
    assign data_arrays_0_0_ext_ram_addr1 = la_data_in[8:0];

endmodule
