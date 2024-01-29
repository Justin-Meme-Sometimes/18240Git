`default_nettype none
module hw2prob8
  (input logic [10:0]year,
   output logic leap4_100_400);

     logic [10:0] q;
     assign q = year >> 2;
     always_comb begin
        if (q+q+q+q == year)
            leap4_100_400 = 1'b1;
        else
            leap4_100_400 = 1'b0;
        case(year)
            11'd100: leap4_100_400 = 0;
            11'd200: leap4_100_400 = 0;
            11'd300: leap4_100_400 = 0;
            11'd400: leap4_100_400 = 1;
            11'd500: leap4_100_400 = 0;
            11'd600: leap4_100_400 = 0;
            11'd700: leap4_100_400 = 0;
            11'd800: leap4_100_400 = 1;
            11'd900: leap4_100_400 = 0;
            11'd1000: leap4_100_400 = 0;
            11'd1100: leap4_100_400 = 0;
            11'd1200: leap4_100_400 = 1;
            11'd1300: leap4_100_400 = 0;
            11'd1400: leap4_100_400 = 0;
            11'd1500: leap4_100_400 = 0;
            11'd1600: leap4_100_400 = 1;
            11'd1700: leap4_100_400 = 0;
            11'd1800: leap4_100_400  = 0;
            11'd1900: leap4_100_400 = 0;
            11'd2000: leap4_100_400 = 1;
            endcase
      end

endmodule : hw2prob8

module hw2prob8_test
    (input logic leap4_100_400,
    output logic [10:0]year);

    initial begin
    $monitor($time,,"year = %b, leap4_100_400 = %b",year,leap4_100_400);
        for (year = 11'd2000; year <= 11'd2021;year++) #10;
        $display("This output is from 0-2000 checking for leap year");
        for (year = 11'd000; year < 11'd2000;year = year + 100) #10;
        #10;
    $finish;
    end
endmodule : hw2prob8_test;

module top();
    logic [10:0]year, leap4_100_400;
    hw2prob8 DUT (.year(year), .leap4_100_400(leap4_100_400));
    hw2prob8_test test (.year(year),.leap4_100_400(leap4_100_400));
endmodule : top
