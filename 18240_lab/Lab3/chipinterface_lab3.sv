module chipinterface_lab3
    (output logic [17:0]LEDR, // for the cMove
     output logic [7:0]LEDG, // win
     output logic [6:0] HEX0,//cmove
     output logic [6:0] HEX1,//cmove
     output logic [6:0] HEX2,//cmove
     output logic [6:0] HEX3,//cmove
     output logic [6:0] HEX4,//hmove
     output logic [6:0] HEX5,//hmove
     output logic [6:0] HEX6,//hmove
     output logic [6:0] HEX7,//hmove
     input logic CLOCK_50, // clock
     input logic [17:0]SW,// hmove and reset
     input logic [3:0]KEY);//enter, new_game

  logic [3:0] cMove;
  logic win;
  logic q2, q1, q0;
  logic [3:0] hMove;
  logic clock, reset, new_game, enter;
  logic currState;
  logic [15:0] hHis, cHis;


  logic newgame, nenter;
  logic intermediate_1, intermediate_2;

  //Synchronizes with key3 and key0
  dFlipFlop d (.d(KEY[3]), .clock(CLOCK_50),.reset(SW[17]), .q(intermediate_2));
  dFlipFlop d0 (.d(intermediate_2), .clock(CLOCK_50),
  .reset(SW[17]), .q(nenter));

  dFlipFlop d2 (.d(KEY[0]), .clock(CLOCK_50),.reset(SW[17]),
  .q(intermediate_1));
  dFlipFlop d3 (.d(intermediate_1), .clock(CLOCK_50),.reset(SW[17]),
  .q(newgame));

  myAbstractFSM Af(.reset(SW[17]),.clock(CLOCK_50), .hMove(SW[3:0]),
                    .new_game(~newgame), .nenter(~nenter), .cMove(LEDR[3:0]),
                    .*) ;


  always_comb begin
    if (win == 1'b1)begin
        LEDG[0] = 1'b1;
    end else begin
        LEDG[0] = 1'b0;
    end
  end

  //assigning cHis and hHis to HEX
  assign LEDR[17:14] = cHis[3:0];
  BCDtoSevenSegment B1(.bcd(cHis[3:0]), .segment(HEX0));
  BCDtoSevenSegment B2(.bcd(cHis[7:4]), .segment(HEX1));
  BCDtoSevenSegment B3(.bcd(cHis[11:8]), .segment(HEX2));
  BCDtoSevenSegment B4(.bcd(cHis[15:12]), .segment(HEX3));
  BCDtoSevenSegment B5(.bcd(hHis[3:0]), .segment(HEX4));
  BCDtoSevenSegment B6(.bcd(hHis[7:4]), .segment(HEX5));
  BCDtoSevenSegment B7(.bcd(hHis[11:8]), .segment(HEX6));
  BCDtoSevenSegment B8(.bcd(hHis[15:12]), .segment(HEX7));
endmodule

module BCDtoSevenSegment
    (input logic [3:0] bcd,
     output logic [6:0] segment);
     always_comb begin
        case(bcd)
            4'd0: segment = 7'b111_1111;
            4'd1: segment = 7'b111_1001;
            4'd2: segment = 7'b010_0100;
            4'd3: segment = 7'b011_0000;
            4'd4: segment = 7'b001_1001;
            4'd5: segment = 7'b001_0010;
            4'd6: segment = 7'b000_0010;
            4'd7: segment = 7'b111_1000;
            4'd8: segment = 7'b000_0000;
            4'd9: segment = 7'b001_1000;
            default: segment = 7'b111_1111;
        endcase
     end
 endmodule: BCDtoSevenSegment
