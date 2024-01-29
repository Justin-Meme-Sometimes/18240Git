`default_nettype none
module MagComp_test;

  logic AltB, AeqB, AgtB;
  logic [1:0] A, B;
  logic [4:0] vector;
  
  assign {A, B} = vector[3:0];
  
  MagComp #(2) dut(.*);
    
  initial begin
    for (vector = 5'b0; vector < 5'b10000; vector++)
      begin 
        #1 assert (((A  > B) && AgtB) || ((A <= B) && ~AgtB)) else $error("%h > %h -> %b", A, B, AgtB);
           assert (((A  < B) && AltB) || ((A >= B) && ~AltB)) else $error("%h < %h -> %b", A, B, AltB);
           assert (((A == B) && AeqB) || ((A != B) && ~AeqB)) else $error("%h = %h -> %b", A, B, AeqB);
      end
    $finish;
  end
endmodule : MagComp_test

module Adder_test;

  logic [3:0] A, B;
  logic       Cin;
  logic [3:0] S;
  logic       Cout;
  
  logic [9:0] vector;
  assign {Cin, A, B} = vector[8:0];
  
  Adder #(4) dut(.*);
  
  initial begin
    for (vector = 10'b0; vector < 10'b10_0000_0000; vector++) 
      #1 assert (A + B + Cin === {Cout,S}) else $error("%h + %h + %b ?=? %b %h", A, B, Cin, Cout, S);
    $finish;
  end  
  
endmodule : Adder_test

module Multiplexer_test;

  logic [7:0] I;
  logic [2:0] S;
  logic       Y;
  
  Multiplexer dut(.*);
  
  logic [3:0] vector;
  assign S = vector[2:0];
  
  initial begin
    I = 8'b1011_0011;
    for (vector=4'b0; vector < 4'b1000; vector++)
      #1 if ((vector == 4'd0) || (vector == 4'd1) || (vector == 4'd4) || 
             (vector == 4'd5) || (vector == 4'd7))
           assert (Y === 1'b1) else $error("Output not 1 for select of %h", S);
         else
           assert (Y === 1'b0) else $error("Output not 0 for select of %h", S);
    $finish;
  end
  
endmodule : Multiplexer_test

module Mux2to1_test;

  logic [1:0] I0, I1;
  logic       S;
  logic [1:0] Y;
  
  logic [5:0] vector;
  assign {S, I1, I0} = vector[4:0];
  
  Mux2to1 #(2) dut(.*);
  
  initial begin
    for(vector = 6'b0; vector <= 6'h1F; vector++)
      #1 if (S === 1'd0) begin
            if (Y !== I0) $display("Output %h doesn't match Input %h for Select of 0", Y, I0);
            end
         else 
            if (Y !== I1) $display("Output %h doesn't match Input %h for Select of 1", Y, I1);
    $finish;
  end
  
endmodule : Mux2to1_test

module Decoder_test;

  logic [2:0] I;
  logic       en;
  logic [7:0] D;
  
  logic [4:0] vector;
  assign {en, I} = vector[3:0];

  Decoder #(8) dut(.*);
  
  logic [7:0] expected[16] = {8'h0, 8'h0, 8'h0, 8'h0, 
                              8'h0, 8'h0, 8'h0, 8'h0,
                              8'h1, 8'h2, 8'h4, 8'h8,
                              8'h10, 8'h20, 8'h40, 8'h80};
  
  initial begin
    for(vector = 5'd0; vector < 5'b1_0000; vector++)
      #1 assert (D === expected[vector[3:0]]) else $error ("Error: D(%h) en(%b), I(%h)",D, en, I);
    $finish;
  end
  
endmodule : Decoder_test

module Register_test;

  logic [7:0] D;
  logic       en, clear, clock;
  logic [7:0] Q;
  
  Register dut(.*);
  
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end
  
  initial begin
    $monitor("D(%b) clear(%b) en(%b) -> Q(%b)", D, clear, en, Q);
    D <= 8'b0111_0001; clear <= 0; en <= 1;
    #7;
    D <= 8'b1000_1110; en <= 0;
    #20;
    clear <= 1;
    #10;
    $finish;
  end
  
endmodule : Register_test

module Counter_test;
  
  logic [3:0] D, Q;
  logic       en, clear, load, clock;

  Counter #(4) dut(.up(1'b1), .*);

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  property chk_clear;
    @(posedge clock) clear |=> (Q === 4'd0);
  endproperty
  
  assert property (chk_clear) else $error("Clear: %d, %h", $stime, Q); 
    
  property chk_load;
    logic [3:0] old_D;
    @(posedge clock) (load & ~clear, old_D = D) |=> (Q == old_D);
  endproperty
  
  assert property (chk_load) else $error("Load: %d, %h", $stime, Q);
  
  property chk_count;
    logic [3:0] old_Q;
    @(posedge clock) (en & ~load & ~clear, old_Q = Q) |=> (Q === old_Q + 1);
  endproperty
        
  initial begin
    en <= 0; clear <= 1; load <= 0; 
    D <= 4'b1110;
    @(posedge clock);
    clear <= 0;
    @(posedge clock);
    en <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    load <= 1;
    @(posedge clock);
    load <= 0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    clear <= 1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    $finish;
  end
    
endmodule : Counter_test


