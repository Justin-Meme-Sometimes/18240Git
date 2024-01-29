`default_nettype none
/******
 *
 * A test of the Shannon Expansion Theorem.  A six-input function is 
 * implemented and compared against the four-input functions that are 
 * derived as Shannon Cofactors.  The cofactors are put back together 
 * using the Expansion Theorem.
 *
 */
module hw2prob6
  (input  logic a, b, c, d, e, f,
   output logic g, g00, g01, g10, g11);

  assign g = (~a | ~c | ~e | ~f) &
             (~a | ~b |  d |  e | ~f) &
             (~c | ~d | ~e | ~f) &
             (~c |  d |  e | f) &
             (a  | ~b | ~c | ~d | e) &
             (a  |  b | ~c | f) &
             (~a |  b |  c | ~d | ~e | ~f) &
             (~a | ~b | ~e | ~f) &
             (~(a ^ d) | b | e | f) &
             (~a |  b | ~e | f) &
             (~b |  c |  d | e) &
             (a  | ~b |  c | ~d | ~e) &
             (a  |  b |  d | ~e);
  
  assign g00 = ~a & ~(b ^ d ^ e) |
               a & b & e |
               a & d & ~e;
               
  assign g01 = ~a & ~(b ^ d ^ e) |
               d & ~e |
               a & ~b & ~d;
               
  assign g10 = b & e |
               a & d & ~e;
               
  assign g11 = ~b & ~e |
               ~a & b & ~d |
               a & d & ~e;
               
endmodule : hw2prob6

module hw2prob6_test();

  logic a, b, c, d, e, f;
  logic g, g00, g01, g10, g11;

  hw2prob6 dut (.*);
  
  logic [6:0] vector;
  assign {c, f, a, b, d, e} = vector[5:0];
  
  logic g_from_co;
  assign g_from_co = ~c & ~f & g00 |
                     ~c &  f & g01 |
                      c & ~f & g10 |
                      c &  f & g11;
  
  initial begin
    for (vector = 7'b0; vector!= 7'b100_0000; vector++)
      #1 if (g != g_from_co)
          $display("Ooops! cf(%b%b) abde(%b%b%b%b) G(%b) FromCofactors(%b): %b%b%b%b",
                   c, f, a, b, d, e, g, g_from_co, g00, g01, g10, g11);
    
    #1 $finish;
  end
  
endmodule : hw2prob6_test
          
