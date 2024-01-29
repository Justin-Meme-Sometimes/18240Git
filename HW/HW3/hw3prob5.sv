module bcdAdd
    (input logic [3:0] a, b,
    input logic carryIn,
    output logic [3:0] sum,
    output logic carryOut);

    logic [4:0] sum_t;

    assign sum_t = a + b + carryIn;
    assign carryOut = (sum_t >= 10) ? 1 : 0;
    assign sum = (sum_t >= 10) ? sum_t-10 : sum_t[3:0];
endmodule : bcdAdd

module bcdAdd_test
    (input logic [3:0] sum,
    input logic carryOut,
    output logic [3:0] a,b,
    output logic carryIn);
    initial begin
        $monitor($time,"sum = %b, carryOut = %b, a = %b, b = %b, carryIn = %b",
                sum,carryOut,a,b,carryIn);

        a = 4'd5; b = 4'd5; carryIn = 1'd0;
        #10;
        if(Sum != 4'd0 || carryOut != 4'd1)begin
            $display("error");
        end
        a = 4'd1; b = 4'd3; carryIn = 1'd0;
        #10;
        if(Sum != 4'd4 || carryOut != 4'd0)begin
            $display("error");
        end
        a = 4'd9; b = 4'd9; carryIn = 1'd0;
        #10;
        if(Sum != 4'd8 ||  carryOut != 4'd1)begin
            $display("error");
        end
        $finish;
    end

endmodule : bcdAdd_test
module top();
    logic [3:0] a,  b, sum;
    logic carryIn, carryOut;
        bcdAdd DUT (.a(a),.b(b),.carryIn(carryIn),.sum(sum),
        .carryOut(carryOut));
        bcdAdd_test test(.a(a),.b(b),.carryIn(carryIn),.sum(sum),
        .carryOut(carryOut));



endmodule : top
