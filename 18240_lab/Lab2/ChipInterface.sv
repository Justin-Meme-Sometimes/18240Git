module ChipInterface
  (output logic [6:0] HEX7, HEX6, // magic_constant
  HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
   output logic [7:0] LEDG,
   input logic [17:0] SW,
   input logic [3:0] KEY,
   input logic CLOCK_50); // needed for enter_9_bcd
  logic [3:0] num1, num2, num3,
  num4, num5, num6,
  num7, num8, num9;
  logic [7:0] magic_constant;
  logic it_is_magic;
  enter_9_bcd e(.entry(SW[3:0]),
  .selector(SW[7:4]),
  .enableL(KEY[0]),
  .zeroL(KEY[2]),
  .set_defaultL(KEY[1]),
  .clock(CLOCK_50),
  .*);
  IsMagic im(.*);
  // Your code here.
  // Output it_is_magic to all 8 bits of LEDG

  assign LEDG = (it_is_magic==1)? 8'b1111_1111: 8'b0000_0000;
  BCDtoSevenSegment seg1 (.bcd({magic_constant[3],magic_constant[2]
  ,magic_constant[1],magic_constant[0]}),.segment(HEX6));
  BCDtoSevenSegment seg2 (.bcd({magic_constant[7],magic_constant[6]
  ,magic_constant[5],magic_constant[4]}),.segment(HEX7));

  // Display magic_constant on the 7 segment display
endmodule : ChipInterface
