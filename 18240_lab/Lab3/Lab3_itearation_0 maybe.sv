module dFlipFlop(
    output logic q,
    input logic d, clock, reset);

    always_ff @(posedge clock)
      if (reset == 1'b1)
        q <= 0;
      else
        q <= d;
endmodule: dFlipFlop


module myExplicitFSM(
  output logic [3:0] cMove,
  output logic win,
  output logic q0, q1, q2, // connect to FF outputs(add more if needed)
  input logic [3:0] hMove,
  input logic clock, reset);
    
  logic d0, d1, d2 // connect to FF inputs (add more if needed)
  // Example instantiation of D-flip-flop.
  // Add more as necessary.
  dFlipFlop ff0(.d(d0), .q(q0), .*),
            ff1(.d(d1), .q(q1), .*),
            ff2(.d(d2), .q(q2), .*),
  // Next state logic goes here: combinational logic that drives
  // next state (d0, etc) based upon input hMove and the
  // current state (q0, q1, etc).
  
  //correct 
  assign d0 = (~q2& ~q1& ~q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] | //0
  ~q2&~q1&~q0 & hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |  //5&1
  ~q2&~q1&~q0 & ~hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |  //5&2
  ~q2&~q1&q0 & hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |   //5&3
  ~q2&~q1&~q0 & ~hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |  //5&4
  ~q2&~q1&~q0 & hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |   //5&5
  ~q2&~q1&~q0 & ~hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |   //5&6
  ~q2&~q1&~q0 & hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |    //5&7
  ~q2&~q1&~q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //5&8
  ~q2&~q1&~q0 & hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |   //5&9
  ~q2&~q1&~q0 & hMove[1] & hMove[1] &  ~hMove[2] & hMove[3] |   //5&11
  ~q2&~q1&~q0 & ~hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //5&12
  ~q2&~q1&~q0 & hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |    //5&13
  ~q2&~q1&~q0 & ~hMove[0] & hMove[1] & hMove[2] & hMove[3] |    //5&14
  ~q2&~q1&~q0 & hMove[0] & hMove[1] & hMove[2] & hMove[3] |    //5&15 
  q2&~q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |;  //2&8
  q2&~q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |;  //7&0
  q2&~q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |;  //7&1
  q2&~q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |;  //7&2
  q2&~q1&q0 & hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |;   //7&3
  q2&~q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |;  //7&4
  q2&~q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |;   //7&5
  q2&~q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |;   //7&6
  q2&~q1&q0 & hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |;    //7&7
  q2&~q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |;  //7&8
  q2&~q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |;   //7&9
  q2&~q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & hMove[3] |;   //7&10
  q2&~q1&q0 & hMove[0] & hMove[1] &  ~hMove[2] & hMove[3] |;   //7&11
  q2&~q1&q0 & ~hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |;   //7&12
  q2&~q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |;   //7&13
  q2&~q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & hMove[3] |;   //7&14
  q2&~q1&q0 & hMove[0] & hMove[1] & hMove[2] & hMove[3]);    //7&15;
   
  assign d1 = (~q2&~q1&~q0 & ~hMove[0] & hMove[1] & ~hMove[2] & hMove[3] |   //5&10
  ~q2&~q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |  //6&5
  ~q2&~q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |   //6&4
  ~q2&~q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |   //6&6
  ~q2&~q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |   //6&9
  ~q2&~q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //2&8
  q2&~q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |  //7&1
  q2&~q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |  //7&2
  q2&~q1&q0 & hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |   //7&3
  q2&~q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //7&4
  q2&~q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |   //7&5
  q2&~q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |   //7&6
  q2&~q1&q0 & hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |    //7&7
  q2&~q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //7&8
  q2&~q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |   //7&9
  q2&~q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & hMove[3] |   //7&10
  q2&~q1&q0 & hMove[0] & hMove[1] &  ~hMove[2] & hMove[3] |   //7&11
  q2&~q1&q0 & ~hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //7&12
  q2&~q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //7&13
  q2&~q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & hMove[3] |   //7&14
  q2&~q1&q0 & hMove[0] & hMove[1] & hMove[2] & hMove[3]);    //7&15;

  assign d2 = (~q2&~q1&~q0 & hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |  //5&1
  ~q2&~q1&~q0 & ~hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |  //5&2
  ~q2&~q1&~q0 & hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |   //5&3
  ~q2&~q1&~q0 & ~hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |  //5&4
  ~q2&~q1&~q0 & hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |   //5&5
  ~q2&~q1&~q0 & ~hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |   //5&6
  ~q2&~q1&~q0 & hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |    //5&7
  ~q2&~q1&~q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //5&8
  ~q2&~q1&~q0 & hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |   //5&9
  ~q2&~q1&~q0 & ~hMove[0] & hMove[1] & ~hMove[2] & hMove[3] |   //5&10
  ~q2&~q1&~q0 & hMove[1] & hMove[1] &  ~hMove[2] & hMove[3] |   //5&11
  ~q2&~q1&~q0 & ~hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //5&12
  ~q2&~q1&~q0 & hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |    //5&13
  ~q2&~q1&~q0 & ~hMove[0] & hMove[1] & hMove[2] & hMove[3] |    //5&14
  ~q2&~q1&~q0 & hMove[0] & hMove[1] & hMove[2] & hMove[3] |     //5&15
  ~q2&~q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |  //6&1
  ~q2&~q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |  //6&2
  ~q2&~q1&q0 & hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |   //6&3
  ~q2&~q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |   //6&5
  ~q2&~q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |   //6&6
  ~q2&~q1&q0 & hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |    //6&7
  ~q2&~q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //6&8
  ~q2&~q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |   //6&9
  ~q2&~q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & hMove[3] |   //6&10
  ~q2&~q1&q0 & hMove[0] & hMove[1] &  ~hMove[2] & hMove[3] |   //6&11
  ~q2&~q1&q0 & ~hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //6&12
  ~q2&~q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |    //6&13
  ~q2&~q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & hMove[3] |    //6&14
  ~q2&~q1&q0 & hMove[0] & hMove[1] & hMove[2] & hMove[3] |     //6&15;
  ~q2&q1&~q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //2&8
  q2&~q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |  //7&1
  q2&~q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |  //7&2
  q2&~q1&q0 & hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |   //7&3
  q2&~q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //7&4
  q2&~q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |   //7&5
  q2&~q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |   //7&6
  q2&~q1&q0 & hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |    //7&7
  q2&~q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //7&8
  q2&~q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |   //7&9
  q2&~q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & hMove[3] |   //7&10
  q2&~q1&q0 & hMove[0] & hMove[1] &  ~hMove[2] & hMove[3] |   //7&11
  q2&~q1&q0 & ~hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //7&12
  q2&~q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //7&13
  q2&~q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & hMove[3] |   //7&14
  q2&~q1&q0 & hMove[0] & hMove[1] & hMove[2] & hMove[3] |    //7&15;  
  ~q2&q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |  //4&0
  ~q2&q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |  //4&1
  ~q2&q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |  //4&2
  ~q2&q1&q0 & hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |   //4&3
  ~q2&q1&q0 & ~hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |  //4&4
  ~q2&q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |   //4&5
  ~q2&q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |   //4&6
  ~q2&q1&q0 & hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |    //4&7
  ~q2&q1&q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //4&8
  ~q2&q1&q0 & hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |   //4&9
  ~q2&q1&q0 & ~hMove[0] & hMove[1] & ~hMove[2] & hMove[3] |   //4&10
  ~q2&q1&q0 & hMove[0] & hMove[1] &  ~hMove[2] & hMove[3] |   //4&11
  ~q2&q1&q0 & ~hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //4&12
  ~q2&q1&q0 & hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //4&13
  ~q2&q1&q0 & ~hMove[0] & hMove[1] & hMove[2] & hMove[3] |   //4&14
  ~q2&q1&q0 & hMove[0] & hMove[1] & hMove[2] & hMove[3]);    //4&15; 

  assign d3 = (q2&~q1&q0 & hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |    //2&7
  q2&~q1&~q0 & hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |  //8&0-15
  q2&~q1&~q0 & hMove[0] & ~hMove[1] & ~hMove[2] & ~hMove[3] |  //8&1
  q2&~q1&~q0 & ~hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |  //8&2
  q2&~q1&~q0 & hMove[0] & hMove[1] & ~hMove[2] & ~hMove[3] |   //8&3
  q2&~q1&~q0 & ~hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |  //8&4
  q2&~q1&~q0 & hMove[0] & ~hMove[1] & hMove[2] & ~hMove[3] |   //8&5
  q2&~q1&~q0 & ~hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |   //8&6
  q2&~q1&~q0 & hMove[0] & hMove[1] & hMove[2] & ~hMove[3] |    //8&7
  q2&~q1&~q0 & ~hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |  //8&8
  q2&~q1&~q0 & hMove[0] & ~hMove[1] & ~hMove[2] & hMove[3] |   //8&9
  q2&~q1&~q0 & ~hMove[0] & hMove[1] & ~hMove[2] & hMove[3] |   //8&10
  q2&~q1&~q0 & hMove[0] & hMove[1] &  ~hMove[2] & hMove[3] |   //8&11
  q2&~q1&~q0 & ~hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //8&12
  q2&~q1&~q0 & hMove[0] & ~hMove[1] & hMove[2] & hMove[3] |   //8&13
  q2&~q1&~q0 & ~hMove[0] & hMove[1] & hMove[2] & hMove[3] |   //8&14
  q2&~q1&~q0 & hMove[0] & hMove[1] & hMove[2] & hMove[3]);    //8&15;
  

  assign cMove[0] = ~q0&~q1&~q2 | q0&~q1&q2;
  assign cMove[1] = ~q0&q1&~q2 | q0&~q1&~q2 | q0&~q1&q2
  assign cMove[2] = q0&~q1&~q2 | q0&q1&~q2;
  assign cMove[3] = q2&~q1&~q0;
  assign win = (q2 & ~q1 & ~q0) | (q2 & q1 & q0) | (~q2 & ~q1 & ~q0); 
  
  // Your output logic goes here: combinational logic that
  // drives cMove and win based upon
  // current state (q0, etc) and hMove.
endmodule: myExplicitFSM

module myFSM_test();
  logic [3:0] cMove;
  logic win;
  logic q2, q1, q0;
  logic [3:0] hMove;
  logic clock, reset;

  myAbstractFSM f1(.*);

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end
  initial begin
    $monitor($time,, "currState=%s, cMove=%d, hMove=%d, win=%b",
              f1.currState.name, cMove, hMove, win);
  // initialize values
  hMove <= 4'h4; reset <= 1'b1;
  // reset the FSM

  // win 9,4,7
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 9'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock)
  hMove <= 7'h7; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

// win 9,1
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);

  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h1;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

//Win 9,4,8
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h8;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

//win 9,4,1
  reset<=1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h1;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

//Win 9,4,2
  reset<=1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h2;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);


// Win  9,4,3
  reset<=1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h3;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

// win 9,4,4 and stay in place 
  reset<=1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);


//Test 8 goes to Win value 9,4,5
  reset<=1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h5;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);


  //Win 9,4,8
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h1;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 3
  hMove <= 4'h8;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

//9,4,8,5 stay in place 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);

  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h1;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 3
  hMove <= 4'h8;
  @(posedge clock); // begin cycle 4
  hMove <= 4'h5;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);


//9,4,7,5 stay in place 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);

  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h1;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 3
  hMove <= 4'h7;
  @(posedge clock); // begin cycle 4
  hMove <= 4'h5;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);


  // 9,4,7 Reset 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h1;
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 3
  hMove <= 4'h7;
  @(posedge clock); // begin cycle 4
  hMove <= reset; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);


  // 9,4 Reset 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock); // begin cycle 4
  hMove <= reset; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

  // 9,4,8 Reset 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock);
  hMove<=4'h8;
  @(posedge clock); // begin cycle 4
  hMove <= reset; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

  // 9,4,random reset 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h4;
  @(posedge clock);
  hMove<=4'h1;
  @(posedge clock); // begin cycle 4
  hMove <= reset; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

  // 9,7 reset 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 2
  hMove <= 4'h7;
  @(posedge clock); // begin cycle 4
  hMove <= reset; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

  // 9 reset 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 4
  hMove <= reset; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

  // 1 stay in place 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge

  @(posedge clock); // begin cycle 1
  hMove <= 4'h1;
  @(posedge clock);


  //9,9 stayin place 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 4
  hMove <= 4'h9; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);


  //9,4,4 stayinplace 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 4
  hMove <= 4'h4; 
  @(posedge clock); // begin cycle 4
  hMove <= 4'h4; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

  //9,3,3 stayinplace 
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock); // begin cycle 1
  hMove <= 4'h9;
  @(posedge clock); // begin cycle 4
  hMove <= 4'h3; 
  @(posedge clock); // begin cycle 4
  hMove <= 4'h3; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);

  //reset
  reset <= 1'b1;
  @(posedge clock); // wait for a positive clock edge
  @(posedge clock); // one edge is enough, but what the heck
  @(posedge clock);
  @(posedge clock); // begin cycle 0
  reset <= 1'b0; // release the reset
  // start an example sequence -- not meaningful for the lab
  hMove <= 4'h4; // these changes are after the clock edge
                // which means the state change happens
                // AFTER the next clock edge
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock); // begin cycle 4
  hMove <= reset; 
  // could check FSM outputs like so. Be careful about timing
  @(posedge clock);
  #1 $finish;

end
endmodule: myFSM_test


