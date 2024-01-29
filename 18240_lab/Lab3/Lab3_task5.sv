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

module myAbstractFSM (
  output logic [3:0] cMove,
  output logic [15:0] cHis, hHis,
  output logic win,
  input logic [3:0] hMove,
  input logic clock, reset, nenter, new_game);
  //not state 4 and not used and we use default encoding
  enum logic [4:0] {S0, S1, S2, S3, S4, S5, S6, S7,
  S8, S9, S10, S11, S12, S13, S14, S15, S16, buff1,
  buff2, buff3, buff4, buff5, buff6, buff7,buff8,buff9,
  Swin, Swin1}
  currState, nextState;
  logic isnotvalid;
  logic not_valid_when_win;
  logic one,two,three,four,five,six,seven,eight,nine;
  //defines what is not valid
  assign isnotvalid =   ~hMove[3] &  ~hMove[2] & ~hMove[1] & ~hMove[0] | //0
                        hMove[3] & ~hMove[2] & hMove[1] & ~hMove[0]|//10
                        hMove[3] & ~hMove[2] & hMove[1] & hMove[0]|//11
                        hMove[3] & hMove[2]; //12-15
  //defines one-nine to hMove
  assign one = ~hMove[3] & ~hMove[2] & ~hMove[1] & hMove[0]; //1
  assign two = ~hMove[3] & ~hMove[2] & hMove[1] & ~hMove[0]; //2
  assign three = ~hMove[3] & ~hMove[2] & hMove[1] & hMove[0];//3
  assign four = ~hMove[3] & hMove[2] & ~hMove[1] & ~hMove[0]; //4
  assign five = ~hMove[3] & hMove[2] & ~hMove[1] & hMove[0]; //5
  assign six =  ~hMove[3] & hMove[2] & hMove[1] & ~hMove[0]; //6
  assign seven = ~hMove[3] & hMove[2] & hMove[1] & hMove[0]; //7
  assign eight = hMove[3] & ~hMove[2] & ~hMove[1] & ~hMove[0]; //8
  assign nine =  hMove[3] & ~hMove[2] & ~hMove[1] & hMove[0];//9
  assign not_valid_when_win = (isnotvalid | one | two | three | four |
  five | six | seven | eight | nine);

  always_comb begin
  //currState = S0;
    nextState = currState;
    case(currState)
      S0:begin //S0, output=5, next_state = S6
        if (nenter) nextState = S6;
        else if (nenter & isnotvalid) nextState = S0;
        else nextState = S0;
      end
      S1:begin //S1, output=6, next_state = S7
        if(nenter) nextState=S7;
        else if (nenter & isnotvalid|five|nine|six) nextState = S1;
        else nextState = S1;
      end
      S2: begin //S2, output=2, next_state = S8
        if (nenter) nextState = S8;
        else if (nenter & isnotvalid|five|six|nine|four|two) nextState = S2;
        else nextState = S2;
      end
      S4: begin //S4, output=8, next_state = sWin
        if (new_game) nextState = buff8;
        else if (nenter & not_valid_when_win) nextState = S4;
        else nextState = S4;
      end
      S5: begin //S5, output=7, next_state = sWin
        if (new_game) nextState = buff9;
        else if (nenter & not_valid_when_win) nextState = S5;
        else nextState = S5;
      end
      //These states are the intermediate states
      S6:begin
        //between state 0 and state 1
        if (~nenter & hMove == 4'h9) nextState = S1;
        else if ( ~nenter & isnotvalid) nextState = S0; //S6
        else nextState = S0;
      end
      S7:begin
        //between state 1 and 2 cases on hMove
        if (~nenter & hMove == 4'h4) nextState= S2;
        else if ( ~nenter & hMove == 4'h1) nextState=S9;
        else if ( ~nenter & hMove == 4'h2) nextState=S10;
        else if ( ~nenter & hMove == 4'h3) nextState=S11;
        else if ( ~nenter & hMove == 4'h7) nextState=S12;
        else if ( ~nenter & hMove == 4'h8) nextState=S13;
        else if ( ~nenter & isnotvalid|five|six|nine|four) nextState= S1; //S1
        else nextState = S1;
      end
      S8:begin
        //between states 2, 7 and 8 cases on hMove
        if (~nenter & hMove == 4'h7) nextState = S4;
        else if (~nenter & hMove == 4'h8) nextState = S5;
        else if (~nenter & hMove == 4'h1) nextState = S14;
        else if (~nenter & hMove == 4'h3) nextState = S15;
        else if( ~nenter & isnotvalid|five|six|nine|two|four) nextState = S2;
        // S2
        else nextState = S2;
      end
    //if we are in these win states stay in these win states
    //also if we are in win states then check if new_game is pressed
    //and win
      S9: begin
        if (new_game && win)nextState = buff1;
        else nextState = S9;
      end
      S10: begin
        if (new_game && win)nextState = buff2;
        else nextState = S10;
      end
      S11: begin
        if (new_game && win)nextState = buff3;
        else nextState  = S11;
      end
      S12: begin
       if (new_game && win)nextState = buff4;
       else nextState = S12;
      end
      S13: begin
        if (new_game && win)nextState = buff5;
        else nextState = S13;
      end
      S14: begin
        if (new_game && win)nextState = buff6;
        else nextState = S14;
      end
      S15: begin
        if (new_game && win) nextState = buff7;
        else nextState = S15;
      end
      //check if buffer and new_game released and nenter released
      //then reset to S0
      buff1,buff2,buff3,buff4,buff5,buff6,buff7,buff8,buff9:
      if (~new_game && ~nenter) nextState = S0;
  endcase
  // Output logic defined here
  win = 1'b0;
  cMove = 4'h1; //default case for the hex on fpga
  cHis = 16'd0;
  hHis = 16'd0;
  unique case (currState)
    //This shows states S0-S15 and outputs cMove,win,cHis,hHis
    S0: begin
        cMove = 4'h5;
        win = 1'b0;
        cHis={4'h5,4'h0,4'h0,4'h0};
        hHis={4'h0,4'h0,4'h0,4'h0};
    end
    S1: begin
        cMove = 4'h6;
        win = 1'b0;
        cHis={4'h5,4'h6,4'h0,4'h0};
        hHis={4'h9,4'h0,4'h0,4'h0};
        end
    S2: begin
        cMove = 4'h2;
        win = 1'b0;
        cHis={4'h2,4'h5,4'h6,4'h0};
        hHis={4'h4,4'h9,4'h0,4'h0};
    end
    S4: begin
        win = 1'b1;
        cMove = 4'h8;
        cHis = {4'h2, 4'h5, 4'h6, 4'h8};
        hHis = {4'h4, 4'h7, 4'h9, 4'h0};
    end
    S5: begin
        win = 1'b1;
        cMove = 4'h7;
        cHis = {4'h2, 4'h5, 4'h6, 4'h7};
        hHis = {4'h4, 4'h8,4'h9, 4'h0};
    end
    S6: begin
        win = 1'b0;
        cMove = 4'h5;
        cHis = {4'h5,4'h0,4'h0,4'h0};
        hHis = {4'h0,4'h0,4'h0,4'h0};
    end
    S7: begin
        win = 1'b0;
        cMove = 4'h6;
        cHis={4'h5,4'h6,4'h0,4'h0};
        hHis={4'h9,4'h0,4'h0,4'h0};
    end
    S8: begin
        win = 1'b0;
        cMove = 4'h2;
        cHis = {4'h2,4'h5,4'h6,4'h0};
        hHis = {4'h4,4'h9,4'h0,4'h0};
    end
    //win_condition states start here
    //outputs cHis,cMove,win,and cMove
    S9: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h4,4'h5,4'h6,4'h0};
        hHis = {4'h1,4'h9,4'h0,4'h0};
    end
    S10: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h4,4'h5,4'h6,4'h0};
        hHis = {4'h2,4'h9,4'h0,4'h0};
    end
    S11: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h4,4'h5,4'h6,4'h0};
        hHis = {4'h3,4'h9,4'h0,4'h0};
    end
    S12: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h4,4'h5,4'h6,4'h0};
        hHis = {4'h7,4'h9,4'h0,4'h0};
    end
    S13: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h4,4'h5,4'h6,4'h0};
        hHis = {4'h8,4'h9,4'h0,4'h0};
    end
    S14: begin
        win = 1'b1;
        cMove = 4'h8;
        cHis = {4'h2,4'h5,4'h6,4'h8};
        hHis = {4'h1,4'h4,4'h9,4'h0};
    end
    S15: begin
        win = 1'b1;
        cMove = 4'h8;
        cHis = {4'h2,4'h5,4'h6,4'h8};
        hHis = {4'h3,4'h4,4'h9,4'h0};
    end
  //buffer states between newgame and an end state
  //These states output a win and cHis, and hHis,
  //cHis and hHis represent the computer history
  //hHis represents the human history
    buff1: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h4,4'h5,4'h6,4'h0};
        hHis = {4'h1,4'h9,4'h0,4'h0};
    end
    buff2: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h4,4'h5,4'h6,4'h0};
        hHis = {4'h2,4'h9,4'h0,4'h0};
    end
    buff3: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h4,4'h5,4'h6,4'h0};
        hHis = {4'h3,4'h9,4'h0,4'h0};
    end
    buff4: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h4,4'h5,4'h6,4'h0};
        hHis = {4'h7,4'h9,4'h0,4'h0};
    end
    buff5: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h4,4'h5,4'h6,4'h0};
        hHis = {4'h8,4'h9,4'h0,4'h0};
    end
    buff6: begin
        win = 1'b1;
        cMove = 4'h8;
        cHis = {4'h2,4'h5,4'h6,4'h8};
        hHis = {4'h1,4'h4,4'h9,4'h0};
    end
    buff7: begin
        win = 1'b1;
        cMove = 4'h8;
        cHis = {4'h2,4'h5,4'h6,4'h8};
        hHis = {4'h3,4'h4,4'h9,4'h0};
    end
    buff8: begin
        win = 1'b1;
        cMove = 4'h8;
        cHis = {4'h2, 4'h5, 4'h6, 4'h8};
        hHis = {4'h4, 4'h7, 4'h9, 4'h0};
    end
    buff9: begin
        win = 1'b1;
        cMove = 4'h7;
        cHis = {4'h2, 4'h5, 4'h6, 4'h7};
        hHis = {4'h4, 4'h8,4'h9, 4'h0};
  end
  endcase
 end

always_ff @(posedge clock, posedge reset)
  if (reset)
    currState <= S0; // or whatever the reset state is
  else
    currState <= nextState;
endmodule: myAbstractFSM
