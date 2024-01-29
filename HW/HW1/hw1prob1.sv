module hw1prob1
    (input logic a, b, c, d,
    output logic f, g);

    logic h, i, j, k, l;

    not  n0(i, b);
    not n1(h, d);
    and  a0(j, a, b, h);
    or  o0(k, b, c, i);
    xor  x0(l, i, b);
    nor n3(f, i, j, k);
    and  a1(g, d, c, l);
endmodule : hw1prob1

module randCircuitTester
 (output logic [3:0] vector,
  input logic f, g);

   initial begin
    $monitor($time,,
     "d = %b, c = %b, b = %b, a = %b,f = %b, g =%b",
     vector[3], vector[2], vector[1], vector[0], f ,g);
     for (vector = 4'b0; vector < 4'd15;vector++) #5;
     #4 $finish;
     end

endmodule: randCircuitTester



module top();
   logic wire_a, wire_b, wire_c, wire_d, wire_f,wire_g;
    hw1prob1 DUT (.a(wire_a),.b(wire_b),.c(wire_c),.d(wire_d),.f(wire_f),.g(wire_g));
    randCircuitTester testBench (.vector({wire_a,wire_b,wire_c,wire_d}),.f(wire_f),.g(wire_g));

endmodule :  top
