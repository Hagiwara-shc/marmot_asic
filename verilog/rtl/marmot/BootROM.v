module BootROM(
  input clock,
  input oe,
  input me,
  input [10:0] address,
  output [31:0] q
);
  reg [31:0] out;

  always @(posedge clock) begin
    if (me) begin
      `include "rom.vh"
    end
  end

  assign q = oe ? out : 32'b0;

endmodule

