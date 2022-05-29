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

`timescale 1 ns / 100 ps

`define TB testbench
`define CARAVEL `TB.uut
`define CHIP `CARAVEL.mprj.Marmot.MarmotCaravelChip
`define PLATFORM `CHIP.MarmotCaravelPlatform
`define SYS `PLATFORM.sys
`define TILE `SYS.tile
`define CORE `TILE.core
`define UART0 `SYS.uart_0_1
`define UART1 `SYS.uart_1_1
`define UART2 `SYS.uart_2_1
`define UART3 `SYS.uart_3_1
`define UART4 `SYS.uart_4_1
`define TLSPIRAM `SYS.qspi_ram_0_1

module testbench;
  `include "io_mapping.v"

  localparam CLOCK_PERIOD = 25; // ns
  localparam MAX_CYCLE    = 100000;

  reg clock;
  wire clock_wire = clock;
  reg RSTB;
  reg CSB;

  reg power1, power2;

  wire gpio;
  wire [37:0] mprj_io;

`ifdef RTL
  wire        core_reset = `CORE.reset;
  wire [31:0] core_pc    = `CORE.coreMonitorBundle_pc;
  wire [31:0] core_cycle = `CORE.coreMonitorBundle_time;
`else
  wire        core_reset = 1'b0;
  wire [31:0] core_pc    = 32'd0;
  wire [31:0] core_cycle = 32'd0;
`endif

`ifdef PULLUP_IO
  genvar gen_i;
  generate
    for (gen_i = 0; gen_i < 38; gen_i = gen_i + 1) begin
      pullup(mprj_io[gen_i]);
    end
  endgenerate
`endif

  initial begin
    clock = 0;
  end

  always #(CLOCK_PERIOD/2) clock <= (clock === 1'b0);

  initial begin
    `ifdef WAVEFORM
      $dumpfile("marmot_test1.vcd");
      $dumpvars(0, testbench);
    `endif
  end

  // Timeout
  reg  [31:0] max_cycle;
  initial begin
    if (! $value$plusargs("max_cycle=%d", max_cycle)) begin
      max_cycle = MAX_CYCLE;
    end

    wait (core_reset === 1'b0);
    wait (core_cycle < 10);
    wait (core_cycle >= max_cycle);
    $display("\n*** Timeout ***");
    $finish;
  end

  // Pass
  initial begin
    wait (mprj_io[31:16] == 16'h1234);
    $display("\n*** Test Pass ***");
    $finish;
  end

  // Fail
  initial begin
    wait (mprj_io[31:16] == 16'hdead);
    $display("\n*** Test Fail ***");
    $finish;
  end

  initial begin
    RSTB <= 1'b0;
    #1000;
    RSTB <= 1'b1;     // Release reset
    #2000;
  end

  initial begin   // Power-up sequence
    power1 <= 1'b0;
    power2 <= 1'b0;
    #200;
    power1 <= 1'b1;
    #200;
    power2 <= 1'b1;
  end

  wire flash_csb;
  wire flash_clk;
  wire flash_io0;
  wire flash_io1;

  wire VDD1V8;
  wire VDD3V3;
  wire VSS;
    
  assign VDD3V3 = power1;
  assign VDD1V8 = power2;
  assign VSS = 1'b0;

  assign mprj_io[3] = 1;  // Force CSB high.
  assign mprj_io[0] = 0;  // Disable debug mode

  caravel uut (
    .vddio    (VDD3V3),
    .vddio_2  (VDD3V3),
    .vssio    (VSS),
    .vssio_2  (VSS),
    .vdda   (VDD3V3),
    .vssa   (VSS),
    .vccd   (VDD1V8),
    .vssd   (VSS),
    .vdda1    (VDD3V3),
    .vdda1_2  (VDD3V3),
    .vdda2    (VDD3V3),
    .vssa1    (VSS),
    .vssa1_2  (VSS),
    .vssa2    (VSS),
    .vccd1    (VDD1V8),
    .vccd2    (VDD1V8),
    .vssd1    (VSS),
    .vssd2    (VSS),
    .clock    (clock_wire),
    .gpio     (gpio),
    .mprj_io  (mprj_io),
    .flash_csb(flash_csb),
    .flash_clk(flash_clk),
    .flash_io0(flash_io0),
    .flash_io1(flash_io1),
    .resetb   (RSTB)
  );

  spiflash #(
    .FILENAME("marmot_test1.hex")
  ) spiflash (
    .csb(flash_csb),
    .clk(flash_clk),
    .io0(flash_io0),
    .io1(flash_io1),
    .io2(),
    .io3()
  );

//-------------------------------------------------------------------------------
// SPI Flash model for Marmot
MX25U3235F #(.Init_File("spi_flash.mem")) spi_flash
(
    .SCLK   (mprj_io[io_spi0_flash_sck]),
    .CS     (mprj_io[io_spi0_flash_csb]),
    .SI     (mprj_io[io_spi0_flash_io_0]),
    .SO     (mprj_io[io_spi0_flash_io_1]),
    .WP     (mprj_io[io_spi0_flash_io_2]),
    .SIO3   (mprj_io[io_spi0_flash_io_3])
);

//-------------------------------------------------------------------------------
// SPI RAM model for Marmot
`ifdef SIMULATOR_QUESTA
// SPI RAM model (APM APS6404L-3SQN_SQPI_PSRAM)
sqpi_model #(.VeriOutStr(1), .STOP_ON_ERROR(1)) spi_ram
(
    .SCK_i  (mprj_io[io_spi2_sck]),
    .nCE_i  (mprj_io[io_spi2_csb]),
    .SI_io  (mprj_io[io_spi2_io_0]),
    .SO_io  (mprj_io[io_spi2_io_1]),
    .nWP_io (mprj_io[io_spi2_io_2]),
    .NC_io  (mprj_io[io_spi2_io_3])
);
`else
// SPI Flash model
MX25U3235F spi_ram
(
    .SCLK   (mprj_io[io_spi2_sck]),
    .CS     (mprj_io[io_spi2_csb]),
    .SI     (mprj_io[io_spi2_io_0]),
    .SO     (mprj_io[io_spi2_io_1]),
    .WP     (mprj_io[io_spi2_io_2]),
    .SIO3   (mprj_io[io_spi2_io_3])
);
`endif

//-------------------------------------------------------------------------------
// UART model for Marmot
`ifdef UART_HIGH_SPEED
  `define CLKS_PER_BIT  16  // F_CLK / 16 baud
`else
  `define CLKS_PER_BIT ((1000/CLOCK_PERIOD)*1000000 / 115200)  // 115200 baud
  //`define CLKS_PER_BIT 104  // 12MHz / 115200 baud
`endif

uart_tb #(.CLKS_PER_BIT(`CLKS_PER_BIT)) uart0_tb
(
    .clk        (clock_wire),
    .rst        (~RSTB),
    .rxd        (mprj_io[io_uart0_tx]),
    .txd        (mprj_io[io_uart0_rx])
);

endmodule
`default_nettype wire
