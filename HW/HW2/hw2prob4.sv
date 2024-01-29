`default_nettype none
/******
 *
 * A Minority gate outputs a one when less than half of the inputs are a one
 *
 */
module Minority
  (output logic y,
   input  logic a, b, c, d, e);
   
  assign y = (~a & ~b & ~c) | 
             (~a & ~b & ~d) | 
             (~a & ~b & ~e) | 
             (~a & ~c & ~d) | 
             (~a & ~c & ~e) | 
             (~a & ~d & ~e) | 
             (~b & ~c & ~d) | 
             (~b & ~c & ~e) | 
             (~b & ~d & ~e) | 
             (~c & ~d & ~e);
  
endmodule: Minority


module Minority_test();

  logic y;
  logic a, b, c, d, e;
  logic [4:0] vector;
  assign {a, b, c, d, e} = vector;
  
  Minority dut(.*);
  
  initial begin
    $monitor("a(%b) b(%b) c(%b) d(%b) e(%b) -> y(%b)", a, b, c, d, e, y);
    for (vector = 5'd0; vector != 5'h1F; vector++)
      #1;
    #1 $finish;
  end
  
endmodule : Minority_test