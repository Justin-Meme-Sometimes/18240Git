// Original Chip Interface to go back to if we mess up task 5 
//chipinterface from task 1-4

`default_nettype none 
module chipInterface
    (output logic [6:0]HEX0, // for the cMove 
     output logic [16:0]LEDG, // win
     input logic [3:0] KEY, // clock
     input logic [17:0] SW); // reset
         
    logic [3:0] cMove;
    logic win;
    logic q2, q1, q0;
    logic [3:0] hMove;
    logic clock, reset;

  myAbstractFSM Af(.reset(SW[17]),.clock(KEY[0]),.hMove(SW[3:0]), .*);


  always_comb begin 
    if (win == 1'b1)begin 
        LEDG[0] = 1'b1; 
    end else begin 
        LEDG[0] = 1'b0; 
    end 
  end 
  BCDtoSevenSegment B(.bcd(cMove[3:0]), .segment(HEX0));

endmodule : chipInterface

module BCDtoSevenSegment
    (input logic [3:0] bcd,
     output logic [6:0] segment);
     always_comb begin
        case(bcd)
            4'd0: segment = 7'b100_0000;
            4'd1: segment = 7'b111_1001;
            4'd2: segment = 7'b010_0100;
            4'd3: segment = 7'b101_0000;
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