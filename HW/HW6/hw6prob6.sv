module hw6prob6
  (input  logic        go,
   input  logic [12:0] inputA,
   output logic        done,
   output logic [12:0] sumOdd,
   input  logic        clock, reset);

  logic enable, isOdd;
  logic [1:0] sel;
  
  FSM fsm(.*);
  DP  datapath(.*);

endmodule: hw6prob6

module FSM
  (input  logic       go, isOdd,
   output logic       done, enable,
   output logic [1:0] sel,
   input  logic       clock, reset);

  enum logic [1:0] {INACTIVE, ACTIVE} currentState, nextState;

  always_ff @(posedge clock, posedge reset)
    if(reset)
      currentState <= INACTIVE;
    else
      currentState <= nextState;

  // Output Generation Logic
  always_comb begin
    {done, enable, sel} = 4'b0_0_00;
    case(currentState)
      INACTIVE: 
         if (go) begin
           enable = 1'b1;
           sel = (isOdd) ? 2'd2 : 2'd3;
         end
      ACTIVE:
         if (go) begin
           enable = isOdd;
           sel = (isOdd) ? 2'd1 : 2'd0;  // 0 is a don't care
           end
         else
           done = 1'b1;
    endcase
  end

  // Next State Generation Logic
  // Interesting!  The next state doesn't depend on the state, only the input
  always_comb
    nextState = (go) ? ACTIVE : INACTIVE;
  
endmodule: FSM

module DP
 #(parameter WIDTH = 13)
  (input  logic [WIDTH-1:0] inputA,
   input  logic             enable,
   input  logic [1:0]       sel,
   output logic [WIDTH-1:0] sumOdd,
   output logic             isOdd,
   input  logic             clock);

  assign isOdd = inputA[0];

  logic [WIDTH-1:0] sum, mux_out;
  Adder #(WIDTH) s(.A(sumOdd), 
                   .B(inputA), 
                   .Cin(1'b0), 
                   .Cout(), 
                   .S(sum));
  Mux4to1 #(WIDTH) m(.I0(sumOdd),
                     .I1(sum), 
                     .I2(inputA),
                     .I3('d0),
                     .S(sel), 
                     .Y(mux_out));

  Register #(WIDTH) r(.D(mux_out), 
                      .clear(1'b0), 
                      .en(enable), 
                      .clock(clock), 
                      .Q(sumOdd));

endmodule: DP

module Mux4to1
 #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] I0, I1, I2, I3,
   input  logic [1:0]       S,
   output logic [WIDTH-1:0] Y);

  logic [WIDTH-1:0] temp0, temp1;
  Mux2to1 #(WIDTH) m0(.I0,
                      .I1,
                      .S(S[0]),
                      .Y(temp0));
  Mux2to1 #(WIDTH) m1(.I0(I2),
                      .I1(I3),
                      .S(S[0]),
                      .Y(temp1));
  Mux2to1 #(WIDTH) m2(.I0(temp0),
                      .I1(temp1),
                      .S(S[1]),
                      .Y);
endmodule : Mux4to1

/*  TESTBENCH
module Mux4to1_test();

  logic [6:0] Y;
  logic [1:0] S;
  Mux4to1 #(7) dut(.I0(7'd12),
                   .I1(7'b1111111),
                   .I2(7'b1111000),
                   .I3(7'b0101010),
                   .S,
                   .Y);
  initial begin
    $monitor("S(%b), Y(%b)", S, Y);
    S=2'd0;
    #10;
    S=2'd1;
    #10;
    S=2'd2;
    #10;
    S=2'd3;
    #10;
    $finish();
  end

endmodule : Mux4to1_test

TESTBENCH */
