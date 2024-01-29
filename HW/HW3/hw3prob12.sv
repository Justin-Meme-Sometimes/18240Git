module Decoder2_4
    (input logic [1:0]ab,
     output logic [3:0]out);

     always_comb begin
        case(ab)
            2'b00 : out = 4'd1;
            2'b01 : out = 4'd2;
            2'b10 : out = 4'd4;
            2'b11 : out = 4'd8;
            default : out = 4'd0;

        endcase
     end
endmodule : Decoder2_4

module tribuff
    (input logic data_output,
     input logic en_L,
     inout tri bus);

     assign bus = (~en_L) ? data_output : 1'bz;

endmodule: tribuff

module hw3prob12
    (input logic [1:0]ab,
     input logic c,d,
     output logic [3:0]out,
     tri logic f);

        logic y1, y2,y3;
        Decoder2_4 dec(.ab(ab),.out(out));
        or o1(y1, out[1],out[3]);
        or  o2(y2, c,d);
        xor x1(y3,c,d);
        tribuff t1 (.en_L(out[2]),.data_output(y2),.bus(f));
        tribuff t2 (.en_L(y1),.data_output(y3),.bus(f));

endmodule : hw3prob12

module hw3prob12_test
    (output logic [1:0]ab,
     output logic c,d,
     input logic [3:0]out,
     tri f);
        initial begin
        logic [3:0] vector;
        //vector = {ab[0],ab[1],c,d};
            for(vector = 4'd0; vector < 4'd15;vector++) begin
               assign ab = {vector[0],vector[1]};
               assign c = vector[2];
               assign d = vector[3];
                $monitor("a = %b, b = %b, c = %b, d = %b, f = %b",vector[0],
                vector[1],vector[2],vector[3],f);
                #10;
            end
            $finish;
         end
endmodule : hw3prob12_test
module top();
    logic [1:0] ab;
    logic c,d;
    logic [3:0] out;
    tri f;

    hw3prob12 DUT (.ab(ab),.c(c),.d(d),.out(out),.f(f));
    hw3prob12_test test (.ab(ab),.c(c),.d(d),.out(out),.f(f));


endmodule : top

