
module data_arrays_0_ext(
  input RW0_clk,
  input [11:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [31:0] RW0_wdata,
  output [31:0] RW0_rdata
);

  wire [7:0]  ram_sel;
  wire [7:0]  ram_csb;
  wire        ram_web;
  reg  [7:0]  ram_rdata_sel;
  wire [31:0] ram_rdata[0:7];

  // RAM select
  assign ram_sel[0] = RW0_en & (RW0_addr[11:9] == 3'b000);
  assign ram_sel[1] = RW0_en & (RW0_addr[11:9] == 3'b001);
  assign ram_sel[2] = RW0_en & (RW0_addr[11:9] == 3'b010);
  assign ram_sel[3] = RW0_en & (RW0_addr[11:9] == 3'b011);
  assign ram_sel[4] = RW0_en & (RW0_addr[11:9] == 3'b100);
  assign ram_sel[5] = RW0_en & (RW0_addr[11:9] == 3'b101);
  assign ram_sel[6] = RW0_en & (RW0_addr[11:9] == 3'b110);
  assign ram_sel[7] = RW0_en & (RW0_addr[11:9] == 3'b111);

  // RAM chip select (active low)
  assign ram_csb = ~ram_sel;

  // RAM write enable (active low)
  assign ram_web = ~RW0_wmode;

  // RAM read data select
  always @(posedge RW0_clk) begin
    ram_rdata_sel <= ram_sel;
  end

  // RAM read data selector
  assign RW0_rdata = ram_rdata_sel[0] ? ram_rdata[0] :
                     ram_rdata_sel[1] ? ram_rdata[1] :
                     ram_rdata_sel[2] ? ram_rdata[2] :
                     ram_rdata_sel[3] ? ram_rdata[3] :
                     ram_rdata_sel[4] ? ram_rdata[4] :
                     ram_rdata_sel[5] ? ram_rdata[5] :
                     ram_rdata_sel[6] ? ram_rdata[6] :
                     ram_rdata_sel[7] ? ram_rdata[7] : 32'd0;

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram0 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[0]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 (RW0_wmask),  // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata),
    .dout0  (ram_rdata[0]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram1 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[1]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 (RW0_wmask),  // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata),
    .dout0  (ram_rdata[1]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram2 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[2]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 (RW0_wmask),  // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata),
    .dout0  (ram_rdata[2]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram3 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[3]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 (RW0_wmask),  // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata),
    .dout0  (ram_rdata[3]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram4 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[4]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 (RW0_wmask),  // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata),
    .dout0  (ram_rdata[4]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram5 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[5]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 (RW0_wmask),  // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata),
    .dout0  (ram_rdata[5]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram6 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[6]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 (RW0_wmask),  // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata),
    .dout0  (ram_rdata[6]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram7 (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[7]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 (RW0_wmask),  // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata),
    .dout0  (ram_rdata[7]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

endmodule

module tag_array_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [39:0] RW0_wdata,
  output [39:0] RW0_rdata
);

  wire        ram_csb;
  wire        ram_web;
  wire [31:0] ram_rdata[0:1];

  // RAM chip select (active low)
  assign ram_csb = ~RW0_en;

  // RAM write enable (active low)
  assign ram_web = ~RW0_wmode;

  // RAM read data
  assign RW0_rdata = {ram_rdata[1][19:0], ram_rdata[0][19:0]};

  sky130_sram_1kbyte_1rw1r_32x256_8 #(.VERBOSE(`VERBOSE)) ram0h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb),    // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 ({4{RW0_wmask[1]}}), // write mask
    .addr0  ({1'b0, RW0_addr}),
    .din0   ({12'd0, RW0_wdata[39:20]}),
    .dout0  (ram_rdata[1]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (8'd0),
    .dout1  ()
  );

  sky130_sram_1kbyte_1rw1r_32x256_8 #(.VERBOSE(`VERBOSE)) ram0l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb),    // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 ({4{RW0_wmask[0]}}), // write mask
    .addr0  ({1'b0, RW0_addr}),
    .din0   ({12'd0, RW0_wdata[19:0]}),
    .dout0  (ram_rdata[0]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (8'd0),
    .dout1  ()
  );

endmodule

module data_arrays_0_0_ext(
  input RW0_clk,
  input [10:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [63:0] RW0_wdata,
  output [63:0] RW0_rdata
);

  wire [3:0]  ram_sel;
  wire [3:0]  ram_csb;
  wire        ram_web;
  reg  [3:0]  ram_rdata_sel;
  wire [63:0] ram_rdata[0:3];

  // RAM select
  assign ram_sel[0] = RW0_en & (RW0_addr[10:9] == 2'b00);
  assign ram_sel[1] = RW0_en & (RW0_addr[10:9] == 2'b01);
  assign ram_sel[2] = RW0_en & (RW0_addr[10:9] == 2'b10);
  assign ram_sel[3] = RW0_en & (RW0_addr[10:9] == 2'b11);

  // RAM chip select (active low)
  assign ram_csb = ~ram_sel;

  // RAM write enable (active low)
  assign ram_web = ~RW0_wmode;

  // RAM read data select
  always @(posedge RW0_clk) begin
    ram_rdata_sel <= ram_sel;
  end

  // RAM read data selector
  assign RW0_rdata = ram_rdata_sel[0] ? ram_rdata[0] :
                     ram_rdata_sel[1] ? ram_rdata[1] :
                     ram_rdata_sel[2] ? ram_rdata[2] :
                     ram_rdata_sel[3] ? ram_rdata[3] : 64'd0;

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram0h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[0]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 ({4{RW0_wmask[1]}}), // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata[63:32]),
    .dout0  (ram_rdata[0][63:32]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram0l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[0]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 ({4{RW0_wmask[0]}}), // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata[31:0]),
    .dout0  (ram_rdata[0][31:0]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram1h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[1]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 ({4{RW0_wmask[1]}}), // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata[63:32]),
    .dout0  (ram_rdata[1][63:32]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram1l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[1]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 ({4{RW0_wmask[0]}}), // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata[31:0]),
    .dout0  (ram_rdata[1][31:0]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram2h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[2]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 ({4{RW0_wmask[1]}}), // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata[63:32]),
    .dout0  (ram_rdata[2][63:32]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram2l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[2]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 ({4{RW0_wmask[0]}}), // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata[31:0]),
    .dout0  (ram_rdata[2][31:0]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram3h (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[3]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 ({4{RW0_wmask[1]}}), // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata[63:32]),
    .dout0  (ram_rdata[3][63:32]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

  sky130_sram_2kbyte_1rw1r_32x512_8 #(.VERBOSE(`VERBOSE)) ram3l (
`ifdef USE_POWER_PINS
    .vccd1  (vccd1),
    .vssd1  (vssd1),
`endif
    .clk0   (RW0_clk),    // clock
    .csb0   (ram_csb[3]), // active low chip select
    .web0   (ram_web),    // active low write control
    .wmask0 ({4{RW0_wmask[0]}}), // write mask
    .addr0  (RW0_addr[8:0]),
    .din0   (RW0_wdata[31:0]),
    .dout0  (ram_rdata[3][31:0]),
    .clk1   (RW0_clk),   // clock
    .csb1   (1'b1),      // active low chip select
    .addr1  (9'd0),
    .dout1  ()
  );

endmodule
