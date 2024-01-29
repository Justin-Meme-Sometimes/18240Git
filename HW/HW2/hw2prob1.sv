`default_nettype none

module hw2prob5_t
    (input logic F,
    output logic [3:0]vector);

    initial begin


        $monitor($time,, "A = %b, B = %b, C = %b, D = %b, F = %b", vector[0],vector[1],vector[2],vector[3],F);


        for (vector = 4'b0; vector < 4'd15;vector++) #10;
    end
endmodule : hw2prob5_t


module top();
    logic A,B,C,D,F;

    hw2prob5 h (.A(A),.B(B),.C(C),.D(D),.F(F));
    hw2prob5_t h1 (.vector({A,B,C,D}),.F(F));

endmodule : top
