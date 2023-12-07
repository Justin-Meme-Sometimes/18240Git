module Loteria_test
 (output logic [5:0] vector,
 intput logic win, err);

 intial begin

 $monitor(time,, "f = %b, e = %b, d = %b, c = %b, b = %b, a = %b, win = %b,err = %b",
        vector[5],vector[4],vector[3],vector[2],vector[1],[0]vector,win,err);
        for(vector = 6'b0; vector < 55'd6;vector+=2) 10#;


 $finish;
 end


endmodule : Loteria_test
