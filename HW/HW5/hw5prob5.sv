`default_nettype none

module dFlipFlop
  (output logic q,
  input logic d, clock, reset);

  always_ff @(posedge clock)
  if (reset == 1'b1)
    q <= 0;
  else
    q <= d;

endmodule: dFlipFlop

module hw5prob5();

  logic A,B;
  logic first,second,reset;

  dFlipFlop flip (.d(A),.clock(B),.q(first),.reset(reset));
  dFlipFlop flipf (.d(B),.clock(A),.q(second),.reset(reset));

  initial begin
       A = 0;
    #1 A = 1;
    #3 A = 0;
    #6 A = 1;
    #1 A = 0;
    #7 A = 1;
    #2 A = 0;
    #1 A = 1;
    #5 A = 0;
    #3 A = 1;
    #2 $finish();
  end

  initial begin
       B = 0;
    #3 B = 1;
    #2 B = 0;
    #2 B = 1;
    #5 B = 0;
    #1 B = 1;
    #2 B = 0;
    #2 B = 1;
    #2 B = 0;
    #3 B = 1;
    #5 B = 0;
  end

endmodule : hw5prob5

