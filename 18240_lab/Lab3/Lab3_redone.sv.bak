
module myAbstractFSM (
  output logic [3:0] cMove,
  output logic [15:0] cHis, hHis,
  output logic win,
  input logic [3:0] hMove,
  input logic clock, reset, nenter, new_game);
  enum logic [4:0] {S0, S1, S2, S3, S4, S5, S6, S7, 
  S8, S9, S10, S11, S12, S13, S14, S15, S16, buff1,
  buff2, buff3, buff4, buff5, buff6, buff7,  
  Swin, Swin1}  
  currState, nextState;
  logic isnotvalid; 

  assign isnotvalid =   ~hMove[3] &  ~hMove[2] & ~hMove[1] & ~hMove[0] | //0
                        hMove[3] & ~hMove[2] & hMove[1] & ~hMove[0]|//10
                        hMove[3] & ~hMove[2] & hMove[1] & hMove[0]|//11
                        hMove[3] & hMove[2]; //12-15

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
    nextState = currState; 
    case(currState)
      S0:begin //S0, output=5, next_state = S6
        isnotvalid = isnotvalid|five;
        if (nenter) nextState = S6;       
        else if (nenter & isnotvalid) nextState = S0;  
      end 
      S1:begin //S1, output=6, next_state = S7
        isnotvalid = isnotvalid|five|nine|six;
        if(nenter) nextState=S7;
        else if (nenter & isnotvalid) nextState = S1;
      end
      S2: begin //S2, output=2, next_state = S8
        isnotvalid = isnotvalid|five|six|nine|four|two;
        if (nenter) nextState = S8;
        else if (nenter & isnotvalid) nextState = S2;
      end
      S4: begin //S4, output=8, next_state = sWin
        if (nenter) nextState = Swin;
        else if (nenter & not_valid_when_win) nextState = S4; 
      end
      S5: begin //S5, output=7, next_state = sWin
        if (nenter) nextState = Swin;
        else if (nenter & not_valid_when_win) nextState = S5; 
      end
      //These states are the intermediate states
      S6:begin
        isnotvalid = isnotvalid|five;
        //between state 0 and state 1
        if (~nenter & hMove == 4'h9) nextState = S1;
        else if ( ~nenter & isnotvalid) nextState = S0;
      end
      S7:begin
        //between state 1 and 2
        isnotvalid = isnotvalid|five|six|nine|four;
        if (~nenter & hMove == 4'h4) nextState= S2;          
        else if ( ~nenter & hMove == 4'h1) nextState=S9;
        else if ( ~nenter & hMove == 4'h2) nextState=S10;
        else if ( ~nenter & hMove == 4'h3) nextState=S11;
        else if ( ~nenter & hMove == 4'h7) nextState=S12;
        else if ( ~nenter & hMove == 4'h8) nextState=S13;
        else if ( ~nenter & isnotvalid) nextState= S1; 
      end
      S8:begin 
        //between states 2, 7 and 8
        isnotvalid = isnotvalid|five|six|nine|two|four;
        if (~nenter & hMove == 4'h7) nextState = S4;
        else if (~nenter & hMove == 4'h8) nextState = S5;
        else if (~nenter & hMove == 4'h1) nextState = S14;
        else if (~nenter & hMove == 4'h3) nextState = S15;
        else if( ~nenter & isnotvalid) nextState = S2; 
      end
      //if we are in these win states stay in these win states
      S9: if(new_game)nextState = buff1;
      S10: if(new_game)nextState = buff2;
      S11: if(new_game)nextState = buff3;
      S12: if(new_game)nextState = buff4;
      S13: if(new_game)nextState = buff5;
      S14: if(new_game)nextState = buff6;
      S15: if(new_game)nextState = buff7;
      buff1,buff2,buff3,buff4,buff5,buff6,buff7:
      if (~new_game && ~nenter) nextState = S0;
  endcase
  // Output logic defined here
  win = 1'b0;
  cMove = 4'h1; //default case for the hex on fpga
  cHis = 16'd0;
  hHis = 16'd0;
  unique case (currState)
    //maybe set win to 0 in every state
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
    //end states states start here
    S9, S10, S11, S12, S13: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h5,4'h6,4'h0,4'h0};
        hHis = {hMove,4'h9,4'h0,4'h0};
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
    buff1, buff2, buff3, buff4, buff5: begin
        win = 1'b1;
        cMove = 4'h4;
        cHis = {4'h5,4'h6,4'h0,4'h0};
        hHis = {hMove,4'h9,4'h0,4'h0};
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
  endcase
 end

always_ff @(posedge clock)
  if (reset || (win & ~new_game))
    currState <= S0; // or whatever the reset state is
  else
    currState <= nextState;
endmodule: myAbstractFSM