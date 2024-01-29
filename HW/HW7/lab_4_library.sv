//change back to RangeChecker
//change back to value
module RangeCheck
    #(parameter  WIDTH = 8)
    (input logic [WIDTH-1:0] low,
    input logic [WIDTH-1:0] high,
    input logic [WIDTH-1:0] val,
    output logic is_between);

    assign is_between = (low <= val  &&  val <= high) ? 1'b1: 1'b0;
endmodule