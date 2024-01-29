`default_nettype none

module hw1prob4
  (input logic a, b, c,
   output logic f, g, h);
    logic n_a, n_b, n_c, i, j, k, l;
    not n1 (n_a, a),
        n2 (n_b, b),
        n3 (n_c, c);

    and a1(i,n_a,b),
        a2(j,a,n_b,c),
        a3(k,n_a,c),
        a4(l,b,c);

    or  o1(f, i,j),
        o2(g,i,k,l);
    xor x1(h,n_a,n_b,n_c);
endmodule : hw1prob4
