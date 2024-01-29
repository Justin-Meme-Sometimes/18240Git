module Divider_C
    (input logic a,b,c,d,
    output logic e,f,g,h);

    logic n_c,n_b,n_a,n_d;
    logic X,X1,X2,X3,X4,X5;

        not n1(n_b,b),
            n2(n_a,a),
         n3(n_c,c),
         n4(n_d,d);

        and a1(e,a,n_c);

        and b1(X,n_a,b),
        b2(X1,n_a,n_c,b),
        b3(X2,a,n_c,d),
        b4(g,a,n_b,c,d),
        b5(X4,b,n_c),
        b6(X5,n_a,b,d);

    or o1(f,X,X1,X2),
       o2(h,X4,X5);

endmodule: Divider_C

module Divider_D
    (input logic a,b,c,d,
    output logic e,f,g,h);

    assign e = a & ~c;
    assign f = ~a&b |  ~a&b&~c | a&~c&d;
    assign g = a&~b&c&d;
    assign h = b&~c | ~a&b&d;

endmodule: Divider_D
