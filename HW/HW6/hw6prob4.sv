`default_nettype none

module serialMagComp  
  (input  logic A, B, // MSB first!
   input  logic clock, reset_L,
   output logic AgtB, AltB, AeqB);

  logic Dgt, Dlt;
  
  assign AeqB = ~(AgtB | AltB);
  assign Dgt = (A & ~B & ~AltB) | AgtB;
  assign Dlt = (B & ~A & ~AgtB) | AltB;
  
  dFlipFlop gt(.D(Dgt),
               .Q(AgtB),
               .clock,
               .reset_L,
               .preset_L(1'b1)
               );
               
  dFlipFlop lt(.D(Dlt),
               .Q(AltB),
               .clock,
               .reset_L,
               .preset_L(1'b1)
               );

endmodule : serialMagComp

module serialMagComp_test();

  logic A, B;
  logic clock, reset;
  logic AgtB, AltB, AeqB;
  
  serialMagComp dut(.*);
  
  initial begin
    clock = 0;
    reset = 1;
    reset <= 0;
    forever #2 clock = ~clock;
  end

  initial begin
    $monitor("A(%b) B(%b) -> AgtB(%b) AeqB(%b) AltB(%b)",
              A, B, AgtB, AeqB, AltB);
              
    A <= 0; B <= 0;
    @(posedge clock);
    @(posedge clock);
    A <= 1; B <= 1;
    @(posedge clock);
    @(posedge clock);
    A <= 0;
    @(posedge clock);
    A <= 1;
    @(posedge clock);
    B <= 0;
    @(posedge clock);
    @(posedge clock);
    $finish;
  end
  
endmodule : serialMagComp_test