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
`define USER_PROJECT_WRAPPER `CARAVEL.mprj
`define MARMOT `USER_PROJECT_WRAPPER.Marmot
`define CHIP `MARMOT.MarmotCaravelChip
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

  localparam CLOCK_PERIOD = 40; // ns
  localparam TCK_PERIOD = 100;
  localparam MAX_CYCLE    = 200000;
  localparam MAX_EXCEPTION_PC_COUNT = 100;

  reg clock;
  wire clock_wire = clock;
  reg RSTB;
  reg tck;
  reg CSB;

  reg power1, power2;

  wire gpio;
  wire [37:0] mprj_io;

  wire        reset = `MARMOT.wb_rst_i;

`ifdef SIM
  wire [31:0] PC    = `CORE.coreMonitorBundle_pc;
`else
  wire [31:0] PC    = {`MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[31] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[30] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[29] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[28] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[27] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[26] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[25] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[24] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[23] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[22] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[21] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[20] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[19] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[18] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[17] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[16] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[15] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[14] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[13] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[12] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[11] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[10] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[9] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[8] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[7] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[6] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[5] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[4] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[3] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[2] ,
                       `MARMOT.\MarmotCaravelChip.MarmotCaravelPlatform.sys.tile.core.coreMonitorBundle_pc[1] ,
                       1'b0};
`endif

//-------------------------------------------------------------------------------
// Timeformat
  initial begin
    $timeformat(-9, 0, " ns", 12);
  end

//-------------------------------------------------------------------------------
// Pull-up
`ifdef PULLUP_IO
  genvar gen_i;
  generate
    for (gen_i = 0; gen_i < 38; gen_i = gen_i + 1) begin
      pullup(mprj_io[gen_i]);
    end
  endgenerate
`endif

//-------------------------------------------------------------------------------
// Clock
  initial begin
    clock = 0;
    tck = 0;
  end

  always #(CLOCK_PERIOD/2) clock <= (clock === 1'b0);
  always #(TCK_PERIOD/2) tck <= (tck === 1'b0);

//-------------------------------------------------------------------------------
// Waveform
  initial begin
    `ifdef WAVEFORM
      $dumpfile("marmot_test1.vcd");
      $dumpvars(0, `TB);
    `endif
  end

//-------------------------------------------------------------------------------
// Initialize FFs for gate level sim.
`ifdef GL
  `include "init_ff.v"
`endif

//-------------------------------------------------------------------------------
// SDF annotate
`ifdef ENABLE_SDF
  initial begin
    $sdf_annotate("../../../mgmt_core_wrapper/sdf/DFFRAM.sdf", `CARAVEL.soc.DFFRAM_0 );
    $sdf_annotate("../../../mgmt_core_wrapper/sdf/mgmt_core.sdf", `CARAVEL.soc.core);
    $sdf_annotate("../../../mgmt_core_wrapper/sdf/mgmt_core_wrapper.sdf", `CARAVEL.soc);
    $sdf_annotate("../../../sdf/user_project_wrapper.sdf.gz", `USER_PROJECT_WRAPPER);
    $sdf_annotate("../../../sdf/Marmot.sdf.gz", `MARMOT);
    $sdf_annotate("../../../sdf/clk_skew_adjust.sdf.gz", `USER_PROJECT_WRAPPER.u_clk_skew_adjust_0);
    $sdf_annotate("../../../sdf/clk_skew_adjust.sdf.gz", `USER_PROJECT_WRAPPER.u_clk_skew_adjust_1);
    $sdf_annotate("../../../sdf/clk_skew_adjust.sdf.gz", `USER_PROJECT_WRAPPER.u_clk_skew_adjust_2);
    $sdf_annotate("../../../sdf/clk_skew_adjust.sdf.gz", `USER_PROJECT_WRAPPER.u_clk_skew_adjust_3);
    $sdf_annotate("../../../sdf/clk_skew_adjust.sdf.gz", `USER_PROJECT_WRAPPER.u_clk_skew_adjust_4);
  end
`endif

//-------------------------------------------------------------------------------
// Count cycle
  reg [31:0] cycle;
  initial begin
    cycle = 0;
  end

  always @(posedge clock) begin
    cycle = cycle + 1;
  end

//-------------------------------------------------------------------------------
// Monitor PC
  integer exception_pc_count;

  always @ (posedge clock) begin
  //if ($test$plusargs("pc_monitor")) begin
      if (cycle % 1000 == 0) begin
        $fwrite(32'h80000002, "[%t] %10d pc=%08x\n", $time, cycle, PC);
      end
  //end

    // Finish on PC=x
    if (^PC === 1'bx) begin
      $display("[%t] PC=xxxxxxxx", $time);
      repeat (50) @(posedge clock);
      $finish;
    end

    // Finish on exception
    if (PC == 32'h00000000 || PC == 32'h00000002) begin
      exception_pc_count <= exception_pc_count + 1;
      if (exception_pc_count > MAX_EXCEPTION_PC_COUNT) begin
        $display("[%t] Exception occurred.", $time);
        $finish;
      end
    end
    else begin
      exception_pc_count <= 0;
    end
  end

//-------------------------------------------------------------------------------
// Timeout
  reg  [31:0] max_cycle;
  initial begin
    if (! $value$plusargs("max_cycle=%d", max_cycle)) begin
      max_cycle = MAX_CYCLE;
    end

    wait (reset === 1'b0);
    wait (cycle < 10);
    wait (cycle >= max_cycle);
    $display("\n*** Timeout ***");
    $finish;
  end

//-------------------------------------------------------------------------------
// Pass
  initial begin
    wait (mprj_io[31:16] == 16'h1234);
    $display("\n*** Test Pass ***");
    $finish;
  end

//-------------------------------------------------------------------------------
// Fail
  initial begin
    wait (mprj_io[31:16] == 16'hdead);
    $display("\n*** Test Fail ***");
    $finish;
  end

//-------------------------------------------------------------------------------
// Reset
  initial begin
    RSTB <= 1'b0;
    #1000;
    RSTB <= 1'b1;     // Release reset
    #2000;
  end

//-------------------------------------------------------------------------------
// Power-up sequence
  initial begin
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

//-------------------------------------------------------------------------------
// JTAG
  assign mprj_io[io_TCK] = tck;
  //assign mprj_io[io_TMS] = 1; // same pin as CSB
  assign mprj_io[io_TDI] = 0;

//-------------------------------------------------------------------------------
// Caravel
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

//-------------------------------------------------------------------------------
// SPI Flash for Mgmt. SoC
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
