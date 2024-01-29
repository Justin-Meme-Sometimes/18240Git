`default_nettype none
module open

    (input logic A, B,
    output logic F, n_A, n_B, f1,f2,f3);


    not #1 n1(n_A, A),
           n2(n_B, B);
    xor #5 x1(f3,n_B, A);
    nand #4 nan1(f2,n_A,B);
    or #3 (f1,n_A,B);
    and #6 (F,f1,f2,f3);

endmodule : open

module testBench
    (input logic F,n_A, n_B,f1,f2,f3,
    output logic A, B);

    initial begin
$monitor($time, "A = %b, B = %b, n_A = %b, n_B = %b, f1 = %b, f2 = %b, f3 = %b, F = %b", A,B,n_A,n_B,f1,f2,f3,F);
        A = 1;
        B = 0;
        #13 A = 0;
        #13 B = 1;
       #13 $finish;
    end


endmodule: testBench

module system();
    logic a,b,n1,n2,f1,f2,f3,f;
    open o(.A(a),.B(b),.n_A(n1),.n_B(n2),.f1(f1),.f2(f2),.f3(f3),.F(f));
    testBench tB (.A(a),.B(b),.n_A(n1),.n_B(n2),.f1(f1),.f2(f2),.f3(f3),.F(f));


endmodule : system
