`default_nettype none

module original
    (input logic a, b, c,
    output logic f);
    logic h, i;

    and a0(h, a, b);
    and a1(i, a, c);
    xor x0(f, h, i);

endmodule : original

module app
    (input logic a, b, c,
    output logic g);
    logic h, i;

    xor x0(h, b, c);
    and(g, a, h);
endmodule : app

module hw1prob11
    (output logic [2:0] vector,
    input logic f, g);
    initial begin
        $monitor($time, "c = %b, b= %b, a = %b, f = %b, g = %b",
            vector[2],vector[1],vector[0],f,g);
    for(vector = 3'b0; vector < 3'd7;vector++) begin
        #10
        if (f != g) begin
            $display("error message");
            end
        end
    #10 $finish; end

endmodule : hw1prob11

module system();
logic a, b, c, f, g;
    original org (.a(a),.b(b),.c(c),.f(f));
    app ap (.a(a),.b(b),.c(c),.g(g));
    hw1prob11 t (.vector({a,b,c}),.g(g),.f(f));


endmodule : system

