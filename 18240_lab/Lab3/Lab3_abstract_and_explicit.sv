// Testbench and code for MyExplicitFSM and original MYAbstractFSM 


module dFlipFlop(
    output logic q,
    input logic d, clock, reset);

    always_ff @(posedge clock)
      if (reset == 1'b1)
        q <= 0;
      else
        q <= d;
endmodule: dFlipFlop

module myAbstractFSM (
  output logic [3:0] cMove,
  output logic win,
  input logic [3:0] hMove,
  input logic clock, reset);
  
  // S0-S5 are the different states for the FSM in binary states  0000 - 0101
  enum logic [2:0] {S0, S1, S2,S3,S4,S5} currState, nextState;
  always_comb begin
    case (currState)
      S0: begin
        if(hMove == 4'h9)
            nextState = S1;
        else
          nextState=S0; 
    end
      S1: begin 
        if (hMove == 4'h4)
            nextState = S2;
        else if(hMove == 4'h1|hMove==4'h2|
                hMove==4'h3|hMove == 4'h7|hMove ==4'h8) begin 
            nextState = S3;
            end
        else 
            nextState = S1; 
    end 
      S2: begin 
        if (hMove==4'h7|hMove == 4'h3|hMove == 4'h1)
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

module myExplicitFSM(
  output logic [3:0] cMove,
  output logic win,
  output logic q0, q1, q2, // connect to FF outputs(add more if needed)
  input logic [3:0] hmove,
  input logic clock, reset);

  logic d0, d1, d2; // connect to FF inputs (add more if needed)
  // Example instantiation of D-flip-flop.
  // Add more as necessary.
  dFlipFlop ff0(.d(d0), .q(q0), .*),
            ff1(.d(d1), .q(q1), .*),
            ff2(.d(d2), .q(q2), .*);
  // Next state logic goes here: combinational logic that drives
  // next state (d0, etc) based upon input hMove and the
  // current state (q0, q1, etc).
  
  // Setting a NOt valid state 
  assign isnotvalid = ~hmove[3] &  ~hmove[2] & ~hmove[1] & ~hmove[0] | //0
                    ~hmove[3] & hmove[2] & ~hmove[1] & hmove[0]|//5
                    ~hmove[3] & hmove[2] & hmove[1] & ~hmove[0]|//6
                    hmove[3] & ~hmove[2] & ~hmove[1] & hmove[0]|//9
                    hmove[3] & ~hmove[2] & hmove[1] & ~hmove[0]|//10
                    hmove[3] & ~hmove[2] & hmove[1] & hmove[0]|//11
                    hmove[3] & hmove[2]; //12-15

// giving all the hmoves a number so it is easier to type later 
  assign one= ~hmove[3] & ~hmove[2] & ~hmove[1] & hmove[0];//1
  assign two = ~hmove[3] & ~hmove[2] & hmove[1] & ~hmove[0];//2
  assign three= ~hmove[3] & ~hmove[2] & hmove[1] & hmove[0];//3
  assign four= ~hmove[3] & hmove[2] & ~hmove[1] & ~hmove[0];//4
  assign five= ~hmove[3] & hmove[2] & ~hmove[1] & hmove[0];//5
  assign six=  ~hmove[3] & hmove[2] & hmove[1] & ~hmove[0];//6
  assign seven = ~hmove[3] & hmove[2] & hmove[1] & hmove[0];//7
  assign eight = hmove[3] & ~hmove[2] & ~hmove[1] & ~hmove[0];//8
  assign nine= hmove[3] & ~hmove[2] & ~hmove[1] & hmove[0];//9

  // Transitions to different states 
  assign s0tos1 = ~q1&~q2&~q0 & (nine); // 6
  assign s1tos2= ~q1&~q2&q0 & (four); // 2
  assign s1tos3= ~q1&~q2&q0 & ~isnotvalid & ~(four); //4
  assign s2tos5= ~q2&q1&~q0 & eight ; //  7
  assign state2to4 = ~q2&q1&~q0 & (one | three | seven);//8

 // Reset states where it resets within itself 
  assign s1tos1 = ~q2 & ~q1 & q0 & isnotvalid; 
  assign s2tos2 = ~q2&q1&~q0 & (isnotvalid | four) ;
  assign s3tos3 = ~q2&q1&q0;
  assign state4to4 =  q2&~q1&~q0;
  assign state5to5 =  q2&~q1&q0;
 
// assigning the next states 
  assign d0= s0tos1|s1tos3|s2tos5|state5to5|s3tos3|s1tos1;
  assign d1= s1tos2|s3tos3|s1tos3|s2tos2;
  assign d2= state4to4|state5to5|s2tos5|state2to4;

// computer moves based on the states/ inputs 
  assign cMove[0] = ~q0&~q1&~q2 | q0&~q1&q2; //0 and 5
  assign cMove[1] = q0&~q1&q2 | q0&~q1&~q2 | ~q0&q1&~q2; //,5,2,1
  assign cMove[2] = q0&~q1&~q2 | q0&q1&~q2| ~q1&~q2&~q0| q0&~q1&q2; //0,3,5,1,
  assign cMove[3] = q2&~q1&~q0;
  assign win = (q2 & ~q1 & ~q0) | (q2 & ~q1 & q0) | (~q2 & q1 & q0);// 4,5,3

  // Your output logic goes here: combinational logic that
  // drives cMove and win based upon
  // current state (q0, etc) and hMove.
endmodule: myExplicitFSM

// //// Explicit  and abstract FSM Test Bench Tests Everything*(transitions)

// update begining to this for Abstract FSM TEstbench 
// logic [3:0] cMove;
//   logic win;
//   logic q2, q1, q0;
//   logic [3:0] hMove;
//   logic clock, reset;

//   myAbstractFSM f1(.*);

//   initial begin
//     clock = 0;
//     forever #5 clock = ~clock;
//   end
//   initial begin
//     $monitor($time,, "currState=%s, cMove=%d, hMove=%d, win=%b",
//               f1.currState.name, cMove, hMove, win);
//   // initialize values
//   hMove <= 4'h4; reset <= 1'b1;

// Explicit FSM Test Bench 
// // module myFSM_test();
// //   logic [3:0] cMove;
// //   logic win;
// //   logic q2, q1, q0;
// //   logic [3:0] hmove;
// //   logic clock, reset;

// //   myExplicitFSM f1(.*);

// //   initial begin
// //     clock = 0;
// //     forever #5 clock = ~clock;
// //   end
// //   initial begin
// //     $monitor($time,, "state=%d, cMove=%d, hMove=%d, win=%b",
// //               {q2, q1, q0}, cMove, hmove, win);
// //   // initialize values
// //   hmove <= 4'h4; reset <= 1'b1;
// //   // reset the FSM

// //   // win 9,4,7
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 9'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock)
// //   hmove <= 7'h7;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// // // win 9,1
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);

// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h1;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// // // stops working here 
// // //Win 9,4,8
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h8;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// // //win 9,4,1
// //   reset<=1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h1;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// // //Win 9,4,2
// //   reset<=1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h2;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);


// // // Win  9,4,3
// //   reset<=1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h3;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// // // win 9,4,4 and stay in place
// //   reset<=1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);


// // //Test 8 goes to Win value 9,4,5
// //   reset<=1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h5;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);


// //   //Win 9,4,8
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h1;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 3
// //   hmove <= 4'h8;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// // //9,4,8,5 stay in place
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);

// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h1;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 3
// //   hmove <= 4'h8;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= 4'h5;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);


// // //9,4,7,5 stay in place
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);

// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h1;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 3
// //   hmove <= 4'h7;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= 4'h5;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);


// //   // 9,4,7 Reset
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h1;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 3
// //   hmove <= 4'h7;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= reset;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);


// //   // 9,4 Reset
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= reset;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// //   // 9,4,8 Reset
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock);
// //   hmove<=4'h8;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= reset;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// //   // 9,4,random reset
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h4;
// //   @(posedge clock);
// //   hmove<=4'h1;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= reset;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// //   // 9,7 reset
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 2
// //   hmove <= 4'h7;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= reset;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// //   // 9 reset
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= reset;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// //   // 1 stay in place
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge

// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h1;
// //   @(posedge clock);


// //   //9,9 stayin place
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= 4'h9;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);


// //   //9,4,4 stayinplace
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= 4'h4;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= 4'h4;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// //   //9,3,3 stayinplace
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock); // begin cycle 1
// //   hmove <= 4'h9;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= 4'h3;
// //   @(posedge clock); // begin cycle 4
// //   hmove <= 4'h3;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);

// //   //reset
// //   reset <= 1'b1;
// //   @(posedge clock); // wait for a positive clock edge
// //   @(posedge clock); // one edge is enough, but what the heck
// //   @(posedge clock);
// //   @(posedge clock); // begin cycle 0
// //   reset <= 1'b0; // release the reset
// //   // start an example sequence -- not meaningful for the lab
// //   hmove <= 4'h4; // these changes are after the clock edge
// //                 // which means the state change happens
// //                 // AFTER the next clock edge
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock); // begin cycle 4
// //   hmove <= reset;
// //   // could check FSM outputs like so. Be careful about timing
// //   @(posedge clock);
// //   #1 $finish;

// // end
// // endmodule: myFSM_test


