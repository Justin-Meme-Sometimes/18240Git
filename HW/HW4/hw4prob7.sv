`default_nettype none

module hw4prob7
  (input  logic clock, reset, a, b,
   output logic green, yellow, red);

   logic [1:0] state, next_state;

   always_comb begin
    next_state[1] = ~a&b | ~state[0]|state[1];
    next_state[0] = (~a&state[1]&state[0] | ~state[1]&~a&b | b&~state[1]
    &state[0] | ~state[1]&~state[0]&a&~b);
   end
   assign red = (~state[1]&state[0] | ~state[0]&~state[1] | state[0]|state[1]);
   assign yellow =(~state[1]&~state[0] | ~state[0]&state[1]);
   assign green =(state[1]&state[0] | ~state[0]&state[1]);
   always_ff @(posedge clock, negedge reset)
     if (~reset)
       state <= 2'b0;
     else
       state <= next_state;







endmodule: hw4prob7
