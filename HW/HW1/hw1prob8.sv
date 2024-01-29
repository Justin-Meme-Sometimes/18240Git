module hw1prob8
   (output logic a, b);
   initial begin
    a = 0;
    b = 1;
    #3 a = 1;
       b = 0;
    #3 a = 0;
    #2 b = 1;
    #5 b = 0;
       a = 1;
    #1 a = 0;
    #4 $finish; end

endmodule : hw1prob8
module top();
    logic a,b;
    hw1prob8 t(.a(a),.b(b));
endmodule : top
