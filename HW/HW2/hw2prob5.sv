`default_nettype none
/******
 *
 * F = A'B'CD + A'B + ABD + A(B'CD' + C'D)
 * Implemented with an 8-1 Mux
 *
 */
module hw2prob5
  (input  logic A, B, C, D,
   output logic F);

  logic notD;
  not n(notD, D);
  
  // Implementing F = 
  // A B C D F
  // 0 0 0 0 0
  // 0 0 0 1 0  0
  // 0 0 1 0 0
  // 0 0 1 1 1  D
  // 0 1 0 0 1
  // 0 1 0 1 1  1
  // 0 1 1 0 1
  // 0 1 1 1 1  1
  // 1 0 0 0 0
  // 1 0 0 1 1  D
  // 1 0 1 0 1
  // 1 0 1 1 0  notD
  // 1 1 0 0 0
  // 1 1 0 1 1  D
  // 1 1 1 0 0
  // 1 1 1 1 1  D
  multiplexer8 m(.I0(1'b0), .I1(D), .I2(1'b1), .I3(1'b1),
                 .I4(D), .I5(notD), .I6(D), .I7(D),
                 .S({A, B, C}), .Y(F));
                
endmodule : hw2prob5

module hw2prob5_test();

  logic A, B, C, D, F;
  logic expected;
  logic [3:0] vector;
  
  assign {A, B, C, D} = vector;
  
  assign expected = ~A&~B&C&D | ~A&B | A&B&D | A & (~B&C&~D | ~C&D);
  
  hw2prob5 dut (.*);
  
  initial begin
    for (vector = 0; vector != 4'b1111; vector++) begin
      #1;
      if (F != expected) $display ("oops %b (%b != %b)", vector, F, expected);
    end
    #1;
    if (F != expected) $display ("oops %b (%b != %b)", vector, F, expected);
    $finish;    
  end
  
endmodule : hw2prob5_test

module multiplexer8
  (input  logic       I0, I1, I2, I3, I4, I5, I6, I7,
   input  logic [2:0] S,
   output logic       Y);

   
  always_comb
    case (S)
      0: Y = I0;
      1: Y = I1;
      2: Y = I2;
      3: Y = I3;
      4: Y = I4;
      5: Y = I5;
      6: Y = I6;
      default: Y = I7;
    endcase
    
endmodule : multiplexer8

module multiplexer8_test();

  logic       I0, I1, I2, I3, I4, I5, I6, I7, Y;
  logic [2:0] S;
  logic [3:0] vector;
  
  multiplexer8 dut(.*);
  
  assign S = vector[2:0];

  initial begin
    {I7, I6, I5, I4, I3, I2, I1, I0} = 8'b1111_1111;
    for (vector = 4'b0000; vector < 4'b1000; vector++) begin
      #1;
      if (Y !== 1'b1)
        $display("OOPS!  I(%b%b%b%b_%b%b%b%b), S(%b) -> Y(%b) not 1",
            I7, I6, I5, I4, I3, I2, I1, I0, S, Y);
      end
    {I7, I6, I5, I4, I3, I2, I1, I0} = 8'b0000_0000;
    for (vector = 4'b0000; vector < 4'b1000; vector++) begin
      #1;
      if (Y !== 1'b0)
        $display("OOPS!  I(%b%b%b%b_%b%b%b%b), S(%b) -> Y(%b) not 0",
            I7, I6, I5, I4, I3, I2, I1, I0, S, Y);
      end
  end
    

endmodule : multiplexer8_test
