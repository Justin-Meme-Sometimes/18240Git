`default_nettype none
module dFlipFlop(
    output logic q,
    input logic d, clock, reset);

    always_ff @(posedge clock)
      if (reset == 1'b1)
        q <= 0;
      else
        q <= d;
endmodule: dFlipFlop

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


module myAbstractFSM (
  output logic [3:0] cMove,
  output logic win,
  input logic [3:0] hMove,
  input logic clock, reset);
  enum logic [2:0] {S0, S1, S2,S3,S4,S5} currState, nextState;
  // Increase bitwidth if you need more than eight states
  // Don't specify state encoding values
  // Use sensible state names
  // Next state logic is defined here. You are basically
  // transcribing the "next-state" column of the state transition
  // table into a SystemVerilog case statement.
  always_comb begin
    case (currState)
      S0: begin
      // Assign a value to nextState based on input
      // This is an example, not a solution to part of the lab
      nextState = (hMove == 4'h9) ? S0 : S1;
    end
      S1: begin 
        if (hMove == 4'h4)
            nextState = S2;
        else if (hMove == 4'h1 | hMove==4'h2 | hMove==4'h3 | hMove == 4'h7 | hMove ==4'h8) 
            nextState = S3;
        else 
            nextState = S1; 
    end 
      S2: begin 
        if (hMove==4'h7 | hMove == 4'h3 | hMove == 4'h1)
            nextState = S4;
        else if (hMove==4'h8)
            nextState = S5;
        else 
            nextState = S2; 
    end
    S3: begin 
      nextState = S3;
    end
    S4: begin 
      nextState = S4;
    end
    S5: begin 
      nextState = S5;
    end
    // ...
    // one case for each state in your FSM
    // ...
    default: begin
      nextState = S0;
    end
  endcase
end
// Output logic defined here. You are basically transcribing
// the output column of the state transition table into a
// SystemVerilog case statement.
// Remember, if this is a Moore machine, this logic should only
// depend on the current state. Mealy also involves inputs.
always_comb begin
  cMove = 4'b0000; win = 1'b0;
  unique case (currState)
    S0: cMove = 4'b0101;
    S1: begin
          win = 1'b0;
          cMove = 4'b0110;
        end
    S2: begin
          win = 1'b0;
          cMove = 4'b0010;
        end
    S3: begin
          win = 1'b1;
          cMove = 4'b0100;
        end
    S4: begin
          win = 1'b1;
          cMove = 4'b1000;
        end
    S5: begin
          win = 1'b1;
          cMove = 4'b0111;
        end
    // ...
    // one case for each state in your FSM
    // ...
    // no default statement needed, due to unique case
  endcase
end
// Synchronous state update described here as an always_ff block.
// In essence, these are your flip flops that will hold the state
// This doesn't do anything interesting except to capture the new
// state value on each clock edge. Also, synchronous reset.
always_ff @(posedge clock)
  if (reset)
    currState <= S0; // or whatever the reset state is
  else
    currState <= nextState;
endmodule: myAbstractFSM