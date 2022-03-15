//--------------------------------------------------------------------
module data_arrays_0_ext(
  input RW0_clk,
  input [11:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [31:0] RW0_wdata,
  output [31:0] RW0_rdata,
  output [7:0]  ram_csb,
  output        ram_web,
  input  [31:0] ram_rdata0,
  input  [31:0] ram_rdata1,
  input  [31:0] ram_rdata2,
  input  [31:0] ram_rdata3,
  input  [31:0] ram_rdata4,
  input  [31:0] ram_rdata5,
  input  [31:0] ram_rdata6,
  input  [31:0] ram_rdata7
);

  wire [7:0]  ram_sel;
  reg  [7:0]  ram_rdata_sel;

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
  assign RW0_rdata = ram_rdata_sel[0] ? ram_rdata0 :
                     ram_rdata_sel[1] ? ram_rdata1 :
                     ram_rdata_sel[2] ? ram_rdata2 :
                     ram_rdata_sel[3] ? ram_rdata3 :
                     ram_rdata_sel[4] ? ram_rdata4 :
                     ram_rdata_sel[5] ? ram_rdata5 :
                     ram_rdata_sel[6] ? ram_rdata6 :
                     ram_rdata_sel[7] ? ram_rdata7 : 32'd0;
endmodule

//--------------------------------------------------------------------
module tag_array_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [39:0] RW0_wdata,
  output [39:0] RW0_rdata,
  output        ram_csb,
  output        ram_web,
  input  [31:0] ram_rdata0,
  input  [31:0] ram_rdata1
);

  // RAM chip select (active low)
  assign ram_csb = ~RW0_en;

  // RAM write enable (active low)
  assign ram_web = ~RW0_wmode;

  // RAM read data
  assign RW0_rdata = {ram_rdata1[19:0], ram_rdata0[19:0]};
endmodule

//--------------------------------------------------------------------
module data_arrays_0_0_ext(
  input RW0_clk,
  input [10:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [63:0] RW0_wdata,
  output [63:0] RW0_rdata,
  output [3:0]  ram_csb,
  output        ram_web,
  input  [63:0] ram_rdata0,
  input  [63:0] ram_rdata1,
  input  [63:0] ram_rdata2,
  input  [63:0] ram_rdata3
);

  wire [3:0]  ram_sel;
  reg  [3:0]  ram_rdata_sel;

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
  assign RW0_rdata = ram_rdata_sel[0] ? ram_rdata0 :
                     ram_rdata_sel[1] ? ram_rdata1 :
                     ram_rdata_sel[2] ? ram_rdata2 :
                     ram_rdata_sel[3] ? ram_rdata3 : 64'd0;
endmodule
