`default_nettype none
module hw2prob7
  (input logic [10:0]year,
   output logic leap4);

     logic [10:0]q;
     assign q = year >> 2;
     always_comb begin
        if (q+q+q+q == year)
            leap4 = 1;
        else
            leap4 = 0;
      end

endmodule : hw2prob7

module hw2prob7_test
    (input logic leap4,
    output logic [10:0]year);

    initial begin
    $monitor($time,,"year = %b, leap4 = %b",year,leap4);
        for (year = 11'd2000; year <= 11'd2021;year++) #10;
    #10
    $finish;
    end
endmodule : hw2prob7_test;

module top();
    logic [10:0]year, leap4;
    hw2prob7 DUT (.year(year),.leap4(leap4));
    hw2prob7_test tb (.year(year),.leap4(leap4));
endmodule : top
