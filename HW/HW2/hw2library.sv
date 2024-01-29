`default_nettype none

/*
 * Multiple testbenches and initial blocks exist.
 * use vlogan -sverilog -nc filename.sv
 *     vcs -sverilog -nc MODULE_NAME
 *     ./simv
 */
 
module Multiplexer
  (input  logic [7:0] I,
   input  logic [2:0] S,
   output logic       Y);

  /* always_comb
    case (S)
      3'h1 : Y = I[1];
      3'h2 : Y = I[2];
      3'h3 : Y = I[3];
      3'h4 : Y = I[4];
      3'h5 : Y = I[5];
      3'h6 : Y = I[6];
      3'h7 : Y = I[7];
      default : Y = I[0];
    endcase
*/

  assign Y = I[S];

endmodule : Multiplexer

module Multiplexer_test();

  logic [7:0] I;
  logic [2:0] S;
  logic       Y;

  Multiplexer dut(.*);

  initial begin
    $monitor("I(%b), S(%b) -> Y(%b)", I, S, Y);
    I = 8'h00;
       S = 3'h0;
    #5 S = 3'h1;
    #5 S = 3'h2;
    #5 S = 3'h6;
    #5 S = 3'h7;
    
    #5 I = 8'hFF;
       S = 3'h0;
    #5 S = 3'h1;
    #5 S = 3'h2;
    #5 S = 3'h6;
    #5 S = 3'h7;
    
    #5 I = 8'hF0;
       S = 3'h0;
    #5 S = 3'h1;
    #5 S = 3'h3;
    #5 S = 3'h4;
    #5 S = 3'h7;
    #5 $finish;
  end

endmodule : Multiplexer_test

module Comparator
  (input  logic [3:0] A, B,
   output logic       AeqB);

  assign AeqB = (A == B);

endmodule : Comparator

module Comparator_test();

  logic [3:0] A, B;
  logic       AeqB;

  Comparator dut(.*);

  initial begin
    $monitor("A(%h) B(%h) -> AeqB(%b)", A, B, AeqB);
       A = 4'h0; B = 4'h0;
    #5 A = 4'h1;
    #5 B = 4'h1;
    #5 B = 4'h2;
    #5 A = 4'hE;
    #5 B = 4'hD;
    #5 B = 4'hE;
    #5 B = 4'hF;
    #5 A = 4'hF;
    #5 A = 4'h0;
    #5 $finish;
  end

endmodule : Comparator_test

module Decoder
  (input  logic [2:0] I,
   input  logic       en,
   output logic [7:0] D);

  always_comb begin
    D = 8'b0;
    if (en == 1'b1)
      D[I] = 1'b1;
    end

endmodule : Decoder

module Decoder_test();

  logic [2:0] I;
  logic       en;
  logic [7:0] D;

  Decoder dut(.*);

  initial begin
    $monitor("en(%b) I(%b) -> D(%b)", en, I, D);
      en = 1'b0;
       I = 3'h0;
    #5 I = 3'h1;
    #5 I = 3'h6;
    #5 I = 3'h7;
    #5 en = 1'b1;
       I = 3'h0;
    #5 I = 3'h1;
    #5 I = 3'h3;
    #5 I = 3'h4;
    #5 I = 3'h6;
    #5 I = 3'h7;
    #5 $finish;
  end

endmodule : Decoder_test

module BarrelShifter
  (input  logic [15:0] V,  // Value
   input  logic [ 3:0] by,
   output logic [15:0] S); // Shifted
   
  assign S = V << by;
  
endmodule : BarrelShifter

module BarrelShifter_test();

  logic [15:0] V, S;
  logic [ 3:0] by;
  
  BarrelShifter dut(.*);
  
  initial begin
    $monitor("Value (%b) shifted by(%d) -> Shifted (%b)", V, by, S);
       V = 16'b1;
       by = 4'd0;
    #1 by = 4'd1;
    #1 by = 4'd2;
    #1 by = 4'd3;
    #1 by = 4'd4;
    #1 by = 4'd7;
    #1 by = 4'd8;
    #1 by = 4'd13;
    #1 by = 4'd14;
    #1 by = 4'd15;
    #1 V = 16'b1111_1111_1111_1110;
       by = 4'd0;
    #1 by = 4'd1;
    #1 by = 4'd2;
    #1 by = 4'd3;
    #1 by = 4'd4;
    #1 by = 4'd7;
    #1 by = 4'd8;
    #1 by = 4'd13;
    #1 by = 4'd14;
    #1 by = 4'd15;
    #1 $finish;
  end
  
endmodule : BarrelShifter_test

module Adder
  (input  logic [7:0] A, B,
   input  logic       Cin,
   output logic [7:0] Sum,
   output logic       Cout);

  assign {Cout, Sum} = A + B + Cin;

endmodule : Adder

module Adder_test();

  logic [7:0] A, B, Sum;
  logic       Cin, Cout;

  Adder dut (.*);

  initial begin
    $monitor("%h + %h + %b = %b + %h", A, B, Cin, Cout, Sum);
       A = 8'h00; B = 8'h00; Cin = 1'B0;
    #5 A = 8'h01;
    #5 B = 8'h03;
    #5 Cin = 1'B1;
    #5 A = 8'hFB;
    #5 B = 8'hF4;
    #5 Cin = 1'B0;
    #5 B = 8'h5;
    #5 $finish;
  end

endmodule : Adder_test

