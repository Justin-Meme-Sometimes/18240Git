`default_nettype none
/******
 *
 * A procedural style 4-input XOR gate
 *
 *******/
module hw2prob3
  (output logic y,
   input  logic [3:0] a);
   
  assign y = a[3] ^ a[2] ^ a[1] ^ a[0];
  // alternate solution using xor reduction operator
  // assign y = ^ a;
  
endmodule : hw2prob3

module hw2prob3_test();

  logic y;
  logic [3:0] a;
  
  hw2prob3 dut(.*);
  
  initial begin
    $monitor("a(%b) -> y(%b)", a, y);
    for (a = 0; a != 4'hF; a++)
      #1;
    #1 $finish;
  end
  
endmodule : hw2prob3_test
