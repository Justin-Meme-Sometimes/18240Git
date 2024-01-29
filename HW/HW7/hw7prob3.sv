`default_nettype none

module MagComp
  #(parameter   WIDTH = 8)
  (output logic             AltB, AeqB, AgtB,
   input  logic [WIDTH-1:0] A, B);

  assign AeqB = (A == B);
  assign AltB = (A <  B);
  assign AgtB = (A >  B);

endmodule: MagComp

// An Adder is a combinational sum generator.
module Adder
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] A, B,
   input  logic             cin,
   output logic [WIDTH-1:0] sum,
   output logic             cout);
   
   assign {cout, sum} = A + B + cin;
   
endmodule : Adder

// The Multiplexer chooses one of WIDTH bits
module Multiplexer
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0]         I,
   input  logic [$clog2(WIDTH)-1:0] S,
   output logic                     Y);
   
   assign Y = I[S];
   
endmodule : Multiplexer

// The 2-to-1 Multiplexer chooses one of two multi-bit inputs.
module Mux2to1
  #(parameter WIDTH = 8)
  (input  logic [WIDTH-1:0] I0, I1,
   input  logic             S,
   output logic [WIDTH-1:0] Y);
   
  assign Y = (S) ? I1 : I0;
  
endmodule : Mux2to1

// The Decoder converts from binary to one-hot codes.
module Decoder
  #(parameter WIDTH=8)
  (input  logic [$clog2(WIDTH)-1:0] I,
   input  logic                     en,
   output logic [WIDTH-1:0]         D);
   
  always_comb begin
    D = '0;
    if (en)
      D[I] = 1'b1;
  end
  
endmodule : Decoder

// A DFlipFlop stores the input bit synchronously with the clock signal.
// preset and reset are asynchronous inputs.
module DFlipFlop
  (input  logic D,
   input  logic preset_L, reset_L, clock,
   output logic Q);
   
  always_ff @(posedge clock, negedge preset_L, negedge reset_L)
    if (~preset_L & reset_L)
      Q <= 1'b1;
    else if (~reset_L & preset_L)
      Q <= 1'b0;
    else if (~reset_L & ~preset_L)
      Q <= 1'bX;
    else
      Q <= D;
    
endmodule : DFlipFlop

// A Register stores a multi-bit value.  
// Enable has priority over Clear
module Register
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] D,
   input  logic             en, clear, clock,
   output logic [WIDTH-1:0] Q);
   
  always_ff @(posedge clock)
    if (en)
      Q <= D;
    else if (clear)
      Q <= '0;
      
endmodule : Register

// A binary up-down counter.
// Clear has priority over Load, which has priority over Enable
module Counter
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] D,
   input  logic             en, clear, load, clock, up,
   output logic [WIDTH-1:0] Q);
   
  always_ff @(posedge clock)
    if (clear)
      Q <= {WIDTH {1'b0}};
    else if (load)
      Q <= D;
    else if (en)
      if (up)
        Q <= Q + 1'b1;
      else
        Q <= Q - 1'b1;
        
endmodule : Counter

// A Synchronizer takes an asynchronous input and changes it to synchronized
module Synchronizer
  (input  logic async, clock,
   output logic sync);
 
  logic metastable;
    
  DFlipFlop one(.D(async),
                .Q(metastable),
                .clock,
                .preset_L(1'b1), 
                .reset_L(1'b1)
               );

  DFlipFlop two(.D(metastable),
                .Q(sync),
                .clock,
                .preset_L(1'b1), 
                .reset_L(1'b1)
               );

endmodule : Synchronizer

// A PIPO Shift Register, with controllable shift direction
// Load has priority over shifting.
module ShiftRegister_PIPO
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] D,
   input  logic             en, left, load, clock,
   output logic [WIDTH-1:0] Q);
   
  always_ff @(posedge clock)
    if (load)
      Q <= D;
    else if (en)
      if (left)
        Q <= {Q[WIDTH-2:0], 1'b0};
      else
        Q <= {1'b0, Q[WIDTH-1:1]};
        
endmodule : ShiftRegister_PIPO

// A SIPO Shift Register, with controllable shift direction
// Load has priority over shifting.
module ShiftRegister_SIPO
  #(parameter WIDTH=8)
  (input  logic             serial,
   input  logic             en, left, clock,
   output logic [WIDTH-1:0] Q);
   
  always_ff @(posedge clock)
    if (en)
      if (left)
        Q <= {Q[WIDTH-2:0], serial};
      else
        Q <= {serial, Q[WIDTH-1:1]};
        
endmodule : ShiftRegister_SIPO

// A BSR shifts bits to the left by a variable amount
module BarrelShiftRegister
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] D,
   input  logic             en, load, clock,
   input  logic [      1:0] by,
   output logic [WIDTH-1:0] Q);
   
  logic [WIDTH-1:0] shifted;
  always_comb
    case (by)
      default: shifted = Q;
      2'b01: shifted = {Q[WIDTH-2:0], 1'b0};
      2'b10: shifted = {Q[WIDTH-3:0], 2'b0};
      2'b11: shifted = {Q[WIDTH-4:0], 3'b0};
    endcase
   
  always_ff @(posedge clock)
    if (load)
        Q <= D;
    else if (en)
        Q <= shifted;
    
endmodule : BarrelShiftRegister

module RangeCheck
    #(parameter  WIDTH = 8)
    (input logic [WIDTH-1:0] low,
    input logic [WIDTH-1:0] high,
    input logic [WIDTH-1:0] val,
    output logic is_between);

    assign is_between = (low <= val  &&  val <= high) ? 1'b1: 1'b0;
endmodule

module hw7prob3
    (input logic [6:0] score,
    input logic [1:0] score_type,
    input logic start, grade_it,
    output logic grade_A, grade_B, grade_C, grade_D, grade_R,
    input logic clock, reset_L);

    logic [6:0] new_score,start_H,start_E,start_L,start_P,
                add_H,add_E,add_L,add_P,
                divided_H,divided_E_1,divided_E_2,divided_L,
                score_H,score_E,score_L,score_P,
                divided_P,fin_1,fin_2,final_val,combined_E_val;
    logic hw_en, lab_en, exam_en, class_p_en,reset_all;
  
     
    my_fsm fsm (.*);
    //set en to be edited at start
    Mux2to1 #(7) choose_gradeIt(.I0(7'b0),.I1(score),.Y(new_score),
        .S(grade_it));
    MagComp #(2) hw_comp (.A(2'b00),.B(score_type), .AeqB(hw_en), 
                .AgtB(), .AltB());
    MagComp #(2) lab_comp (.A(2'b01),.B(score_type), .AeqB(lab_en), 
                .AgtB(), .AltB());
    MagComp #(2) class_partipation_comp (.A(2'b10),.B(score_type), 
                .AeqB(exam_en), .AgtB(), .AltB());
    MagComp #(2) exam_comp (.A(2'b11),.B(score_type), .AeqB(class_p_en), 
                .AgtB(), .AltB());
    //scpre_H,E,L,P need values initially
    
    Adder #(7) hw_add (.A(new_score), .B(score_H),.cin(1'd0),.cout(),
        .sum(add_H));
    Adder #(7) exam_add (.A(new_score), .B(score_E),.cin(1'd0),.cout(),
        .sum(add_E));
    Adder #(7) lab_add (.A(new_score), .B(score_L),.cin(1'd0),.cout(),
        .sum(add_L));
    Adder #(7) class_particiaption_add (.A(new_score), .B(score_P),.cin(1'd0),
        .cout(),.sum(add_P));

    Mux2to1 #(7) choose_start_H(.I1(new_score),.I0(add_H),.Y(start_H),
        .S(start));
    Mux2to1 #(7) choose_start_E(.I1(new_score),.I0(add_E),.Y(start_E),
        .S(start));
    Mux2to1 #(7) choose_start_L(.I1(new_score),.I0(add_L),.Y(start_L),
        .S(start));
    Mux2to1 #(7) choose_start_P(.I1(new_score),.I0(add_P),.Y(start_P),
        .S(start));



    //issue is with either with add or score
    Register #(7) reg_H(.D(start_H), .Q(score_H), .en(hw_en),.clock(clock),
        .clear(reset_all));
    Register #(7) reg_E(.D(start_E), .Q(score_E), .en(exam_en),.clock(clock),
        .clear(reset_all));
    Register #(7) reg_L(.D(start_L), .Q(score_L), .en(lab_en),.clock(clock),
        .clear(reset_all));
    Register #(7) reg_P(.D(start_P), .Q(score_P), .en(class_p_en),.clock(clock),
        .clear(reset_all));
    
    assign divided_H = score_H >> 2;
    assign divided_E_1 = score_E >> 2;
    assign divided_E_2 = score_E >> 3;
    assign divided_L =  score_L  >> 2;
    assign divided_P = score_P  >> 3;

    Adder #(7) add_combine_E (.A(divided_E_1), .B(divided_E_2),.cin(1'd0),
        .cout(),.sum(combined_E_val));

    Adder #(7) add_fin1 (.A(combined_E_val), .B(divided_H),.cin(1'd0),
        .cout(),.sum(fin_1));
    Adder #(7) add_fin2 (.A(fin_1), .B(divided_L),.cin(1'd0),
        .cout(),.sum(fin_2));
    Adder #(7) add_fin3 (.A(fin_2), .B(divided_P),.cin(1'd0),
        .cout(),.sum(final_val));

    RangeCheck #(7) R_Checker(.low(7'd0),.high(7'd59),.val(final_val),
        .is_between(grade_R));
    RangeCheck#(7) D_Checker(.low(7'd60),.high(7'd69),.val(final_val),
        .is_between(grade_D));
    RangeCheck #(7) C_Checker(.low(7'd70),.high(7'd79),.val(final_val),
        .is_between(grade_C));
    RangeCheck #(7) B_Checker(.low(7'd80),.high(7'd89),.val(final_val),
        .is_between(grade_B));
    RangeCheck #(7) A_Checker(.low(7'd90),.high(7'd100),.val(final_val),
        .is_between(grade_A));
endmodule

module my_fsm
    (input logic start, grade_it, reset_L, clock,
    input logic [1:0] score_type,
    output logic reset_all);
  enum {INIT, SHIFTING} state, nextState;
  
  always_ff @(posedge clock, negedge reset_L) begin
    if (~reset_L)
      state <= INIT;
    else
      state <= nextState;
  end
    always_comb begin
        reset_all = 1'b1;
        case(state)
            INIT:begin
              if(~start) begin
                nextState = INIT;
                reset_all = 1'b1;
              end
              if(start) begin 
                nextState = SHIFTING;
                reset_all = 1'b1;
              end
            end
            SHIFTING:begin 
                if(~start) begin
                nextState = SHIFTING;
                reset_all = 1'b0;
              end
                if(start) begin 
                nextState = SHIFTING;
                reset_all = 1'b1;
              end
            end
        endcase 
    end

endmodule