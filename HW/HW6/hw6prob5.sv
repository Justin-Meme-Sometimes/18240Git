`default_nettype none
/*
 * Code taken straight from lecture slides
 *
 * Hardware thread to count the number of bits that are set in a 30-bit
 * input value.
 */
module OnesCount
 #(parameter w = 30)
 (input  logic                   d_in_ready,
  input  logic                   clock, reset,
  output logic                   d_out_ready,
  input  logic           [w-1:0] d_in,
  output logic [$clog2(w+1)-1:0] d_out);

  logic [w-1:0]p_out;
  logic lowBit, ShiftReg,Sload;
  logic Sshift, Oclr;
  logic Oinc;

  logic [$clog2(w)-1:0] SC;
  logic lowBit;
  assign lowBit = p_out[0];

  fsm #(w) control (.*);

  ShiftReg_PIPO_Right #(w) sr (.D(d_in), .Q(p_out), .clock(clock),
  .load(Oclr), .en(~Sshift_L), .left(0'd0));

  counter #($clog2(w)) sc (.clock(clock), .D(30'd0),
  .en(~Oinc_L), .Q(SC), .up(1), .load(Oclr), .clear(0));

  compare #(w) cmp (.A(p_out),.B(30'd0),.eq(ShiftReg));



endmodule: OnesCount

module fsm
 #(parameter w = 30)
  (input  logic clock, reset, ShiftReg,
   input  logic d_in_ready, lowBit,
   output logic Sload, Sshift, Oclr, Oinc, d_out_ready);

  enum logic {A = 1'b0, B = 1'b1} cur_state, n_state;

  always_comb begin
    case (cur_state)
      A: begin  //State A
         n_state = d_in_ready ? B : A;
         Sload = d_in_ready ? 1 : 0;
         Oclr  = d_in_ready ? 1: 0;
         Sshift = 0;
         Oinc   = 0;
         d_out_ready = 0; // D_out_ready
         end
      B: begin  //State B
         n_state  = (ShiftReg)? A : B;
         Sload  = 0;
         Oclr   = 0;
         Sshift = (~ShiftReg) ? 1 : 0;
         Oinc = (~ShiftReg)? lowBit : 0;
         d_out_ready = (ShiftReg) ? 1 : 0;
         end
    endcase
  end

  always_ff @(posedge clock, posedge reset)
    if (reset)
      cur_state <= A;
    else
      cur_state <= n_state;

endmodule: fsm

module Ones_Count_tb();
logic clock, reset, d_out_ready,d_in_ready;
logic [29:0] d_in;
logic [4:0] d_out;

initial begin
  forever #5 clock = ~clock;
end
  Ones_Count_tb(.*);
initial begin
 d_in_ready = 1'b0;
 @(posedge clock);
 d_in_ready = 1'b1;
 @(posedge clock);

 d_in_ready = 1'b0;
 d_in = 2;
 @(posedge clock);
 @(posedge clock);
 d_in_ready = 1'b1;
 @(posedge clock);
 @(posedge clock);


 d_in_ready = 1'b0;
 d_in = 3;
 @(posedge clock);
 @(posedge clock);
 d_in_ready = 1'b1;
 @(posedge clock);
 @(posedge clock);
 @(posedge clock);
 //ez
$finish;
end

endmodule
