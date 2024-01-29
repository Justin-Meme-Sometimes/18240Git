`default_nettype none
module BCDOneDigitAdd
  (input logic [3:0] A, B,
   input logic Cin,
   output logic [3:0] Sum,
   output logic Cout);

   logic [4:0] Sum_temp;

   assign Sum_temp = A + B + Cin;
   assign Cout = (Sum_temp >= 10) ? 1 : 0;
   assign Sum = (Sum_temp >= 10) ? Sum_temp-10 : Sum_temp[3:0];
endmodule: BCDOneDigitAdd

// module BCDOneDigitAdd_test();
//   logic [3:0] A,B,Sum;
//   logic Cin,Cout;
//   BCDOneDigitAdd run(.*);
//   initial begin
//     $monitor($time, "A = %b, B= %b,Sum = %b,Cin = %b,Cout=%b",
//                      A, B,Sum,Cin,Cout);
//                      Cin=0;
//                      A=4'b0001;
//                      B=4'b0001;
//     #10;
//     A=4'b0010;
//     B=4'b0001;
//     #10;
//     A=4'b1000;
//     B=4'b1000;
//     #10;
//     A=4'b1111;
//     B=4'b1111;

//     #10 $finish;
//   end
// endmodule: BCDOneDigitAdd_test

module Adders
  (input logic [7:0]A,B,
   output logic [7:0] Sum);
   logic [3:0] Aone,Aten,Bone,Bten;
   logic [3:0] sum1,sum2;
   logic carry1,carry2;
   assign Bone = B[3:0];
   assign Bten = B[7:4];
   assign Aone = A[3:0];
   assign Aten = A[7:4];
   BCDOneDigitAdd B1(.A(Aone),.B(Bone),.Cin(1'b0),.Sum(sum1),.Cout(carry1));
   BCDOneDigitAdd B2(.A(Aten),.B(Bten),.Cin(carry1),.Sum(sum2),.Cout(carry2));
   assign Sum = {sum2,sum1};

endmodule: Adders

// module Adders_test();
//   logic [7:0] A,B,Sum;
//   Adders run(.*);
//   initial begin
//     $monitor($time, "A = %b, B= %b,Sum = %b",
//                      A, B,Sum);
//                      A=8'b0000_0001;
//                      B=8'b0000_0001;
//     #10;
//     A=8'b0001_0001;
//     B=8'b0000_0001;
//     #10;
//     A=8'b0001_0001;
//     B=8'b0001_0001;
//     #10;
//     A=8'b0001_1001;
//     B=8'b0001_1001;

//     #10 $finish;
//   end
// endmodule: Adders_test
module addRow
  (input logic [3:0]A,B,C,
   output logic [7:0]sum);
   logic [7:0] sum1;
   Adders A1(.A(A),.B(B),.Sum(sum1));
   Adders A2(.A(sum1),.B(C),.Sum(sum));
endmodule: addRow

// module addRow_test();
//   logic [3:0] A,B,C;
//   logic [7:0] sum;
//   addRow ar(.*);
//   initial begin
//     $monitor($time, "A = %b, B= %b,C = %b,sum = %b",
//                      A, B,C,sum);
//                      A=4'b0001;
//                      B=4'b0001;
//                      C=4'b0001;
//     #10;
//     A=4'b1001;
//     B=4'b1001;
//     C=4'b1001;
//     #10;
//     A=4'b1001;
//     B=4'b0001;
//     C=4'b0001;
//     #10;
//     A=4'b1111;
//     B=4'b1111;
//     C=4'b1111;

//     #10 $finish;
//   end
// endmodule: addRow_test
module Comparator
  (input logic [3:0] A,
   input logic [3:0] B,
   output logic AeqB);
  assign AeqB = (A==B);
endmodule: Comparator
module ComparatorTwoDigit
 (input logic [7:0] A,
  input logic [7:0] B,
  output logic AeqB);
  logic onesEqual,tensEqual;
  Comparator c1(.A(A[3:0]),.B(B[3:0]),.AeqB(onesEqual));
  Comparator c2(.A(A[7:4]),.B(B[7:4]),.AeqB(tensEqual));
  assign AeqB = onesEqual & tensEqual;
endmodule: ComparatorTwoDigit


module decoder
    (input logic [3:0] in,
     output logic [15:0] out);
     always_comb begin
        case(in)
        4'd1: out = 16'd1;
        4'd2: out = 16'd2;
        4'd3: out = 16'd4;
        4'd4: out = 16'd8;
        4'd5: out = 16'd16;
        4'd6: out = 16'd32;
        4'd7: out = 16'd64;
        4'd8: out = 16'd128;
        4'd9: out = 16'd256;
        default: out = 16'd0;
        endcase
    end

endmodule : decoder

// module decoder_test();
//   logic [3:0] in;
//   logic [15:0] out;
//   decoder d(.*);
//   initial begin
//     $monitor($time, "in = %b,out%b",
//                      in,out);
//                      in = 4'b001;
//     #10;
//     in = 4'b0011;
//     #10;
//     in = 4'b0101;
//     #10;
//     in = 4'b1001;
//     #10;
//     #10 $finish;
//   end

// endmodule: decoder_test

module isGreaterThan9
    (input logic [3:0] num1,num2,num3,
    input logic [3:0] num4,num5,num6,
    input logic [3:0] num7,num8,num9,
    output logic greaterThanNine);
    logic a,b,c,d,e,f,g,h,i;
    assign a = num1 <= 9;
    assign b = num2 <= 9;
    assign c = num3 <= 9;
    assign d = num4 <= 9;
    assign e = num5 <= 9;
    assign f = num6 <= 9;
    assign g = num7 <= 9;
    assign h = num8 <= 9;
    assign i = num9 <= 9;
    assign greaterThanNine = a & b & c & d & e & f & g & h & i;
endmodule : isGreaterThan9

// module isGreaterThan9_test();
//   logic [3:0] num1,num2,num3,num4,num5,num6,num7,num8,num9;
//   logic greaterThanNine;
//   isGreaterThan9 igt(.*);
//   initial begin
//     $monitor($time, "num1=%b,num2=%b,num3=%b,num4=%b,num5=%b,num6=%b,num7=%b,num8=%b,num9=%b, greaterThanNine = %b",
//                      num1,num2,num3,num4,num5,num6,num7,num8,num9,greaterThanNine);
//                      num1 = 4'b0001;
//                      num2 = 4'b0010;
//                      num3 = 4'b0100;
//                      num4 = 4'b1000;
//                      num5 = 4'b1001;
//                      num6 = 4'b1011;
//                      num7 = 4'b1010;
//                      num8 = 4'b1001;
//                      num9 = 4'b1111;
//     #10;
//     num1 = 4'b0001;
//     num2 = 4'b0010;
//     num3 = 4'b0100;
//     num4 = 4'b1000;
//     num5 = 4'b1001;
//     num6 = 4'b1001;
//     num7 = 4'b1000;
//     num8 = 4'b1001;
//     num9 = 4'b1001;
//     #10 $finish;
//   end

// endmodule:isGreaterThan9_test
 module BCDtoSevenSegment
     (input logic [3:0] bcd,
     output logic [6:0] segment);
     always_comb begin
         case(bcd)
             4'd0: segment = 7'b000_0001;
             4'd1: segment = 7'b111_1001;
             4'd2: segment = 7'b010_0100;
             4'd3: segment = 7'b011_0000;
             4'd4: segment = 7'b001_1001;
             4'd5: segment = 7'b001_0010;
             4'd6: segment = 7'b000_0010;
             4'd7: segment = 7'b111_1000;
             4'd8: segment = 7'b000_0000;
             4'd9: segment = 7'b001_1000;
             4'd10: segment = 7'b000_1000;
             4'd11: segment = 7'b000_0011;
             4'd12: segment = 7'b100_0110;
             4'd13: segment = 7'b010_0001;
             4'd14: segment = 7'b000_0110;
             4'd15: segment = 7'b000_1110;
             default: segment = 7'b1111111;
         endcase
     end


 endmodule : BCDtoSevenSegment
module checkValue
    (input logic [3:0] num1,num2,num3,
    input logic [3:0] num4,num5,num6,
    input logic [3:0] num7,num8,num9,
    output logic isMagic);

    logic [15:0]out1,out2,out3,out4,out5,out6,out7,out8,out9;

    logic greaterThanNine;
    logic [15:0] combinedOut;
    isGreaterThan9 great(.num1(num1),.num2(num2),.num3(num3),.num4(num4),
    .num5(num5),.num6(num6),.num7(num7),.num8(num8),.num9(num9),.greaterThanNine
    (greaterThanNine));


    decoder d1 (.in(num1),.out(out1));
    decoder d2 (.in(num2),.out(out2));
    decoder d3 (.in(num3),.out(out3));
    decoder d4 (.in(num4),.out(out4));
    decoder d5 (.in(num5),.out(out5));
    decoder d6 (.in(num6),.out(out6));
    decoder d7 (.in(num7),.out(out7));
    decoder d8 (.in(num8),.out(out8));
    decoder d9 (.in(num9),.out(out9));

    assign combinedOut = (out1 | out2 | out3 | out4 | out5 | out6 | out7 |
    out8 | out9);

    always_comb begin
        if((combinedOut != 9'b111111111) || greaterThanNine==0) begin
            isMagic = 1'b0;
        end else begin
            isMagic = 1'b1;
        end
    end
endmodule : checkValue

// module checkValue_test();
//   logic [3:0] num1,num2,num3,num4,num5,num6,num7,num8,num9;
//   logic isMagic;
//   logic [15:0] combinedOut;
//   checkValue cv(.*);

//   initial begin
//     $monitor($time, "num1=%b,num2=%b,num3=%b,num4=%b,num5=%b,num6=%b,num7=%b,num8=%b,num9=%b,combinedOut = %b, isMagic = %b",
//                      num1,num2,num3,num4,num5,num6,num7,num8,num9,combinedOut,isMagic);
//                      num1 = 4'b0001;
//                      num2 = 4'b0010;
//                      num3 = 4'b0011;
//                      num4 = 4'b0100;
//                      num5 = 4'b0101;
//                      num6 = 4'b0110;
//                      num7 = 4'b0111;
//                      num8 = 4'b1000;
//                      num9 = 4'b1001;
//     #10;
//     num1 = 4'b0011;
//     num2 = 4'b0010;
//     num3 = 4'b0111;
//     num4 = 4'b0100;
//     num5 = 4'b1001;
//     num6 = 4'b0110;
//     num7 = 4'b001;
//     num8 = 4'b1000;
//     num9 = 4'b0101;
//     #10;
//     num1 = 4'b0010;
//     num2 = 4'b0010;
//     num3 = 4'b0110;
//     num4 = 4'b0100;
//     num5 = 4'b1001;
//     num6 = 4'b0110;
//     num7 = 4'b001;
//     num8 = 4'b1000;
//     num9 = 4'b0101;
//     #10;
//     num1 = 4'b0011;
//     num2 = 4'b0010;
//     num3 = 4'b0111;
//     num4 = 4'b0100;
//     num5 = 4'b1011;
//     num6 = 4'b0110;
//     num7 = 4'b001;
//     num8 = 4'b1000;
//     num9 = 4'b0101;
//     #10 $finish;
//   end
// endmodule: checkValue_test
module checkSums
  (input logic [3:0] a,b,c,d,e,f,g,h,i,
   output logic [7:0] sum);
   logic [7:0] sumRow1,sumRow2,sumRow3,sumCol1,sumCol2,sumCol3,sumDiag1,sumDiag2;
   logic compare1,compare2,compare3,compare4,compare5,compare6,compare7,compare8;
   ComparatorTwoDigit CR1(.A(sumRow1),.B(sumRow2),.AeqB(compare1));
   ComparatorTwoDigit CR2(.A(sumRow1),.B(sumRow3),.AeqB(compare2));
   ComparatorTwoDigit CR3(.A(sumRow1),.B(sumCol1),.AeqB(compare3));
   ComparatorTwoDigit CR4(.A(sumRow1),.B(sumCol2),.AeqB(compare4));
   ComparatorTwoDigit CR5(.A(sumRow1),.B(sumCol3),.AeqB(compare5));
   ComparatorTwoDigit CR6(.A(sumRow1),.B(sumDiag1),.AeqB(compare6));
   ComparatorTwoDigit CR7(.A(sumRow1),.B(sumDiag2),.AeqB(compare7));
   addRow r1(.A(a),.B(b),.C(c),.sum(sumRow1));
   addRow r2(.A(d),.B(e),.C(f),.sum(sumRow2));
   addRow r3(.A(g),.B(h),.C(i),.sum(sumRow3));
   addRow c1(.A(a),.B(d),.C(g),.sum(sumCol1));
   addRow c2(.A(b),.B(e),.C(h),.sum(sumCol2));
   addRow c3(.A(c),.B(f),.C(i),.sum(sumCol3));
   addRow d1(.A(a),.B(e),.C(i),.sum(sumDiag1));
   addRow d2(.A(c),.B(e),.C(g),.sum(sumDiag2));
   assign sum = (compare1 & compare2 & compare3 & compare4 & compare5 & compare6 & compare7) ? sumRow1 : 8'b0000_0000;
endmodule: checkSums

// module checkSums_test();
//   logic [3:0] a,b,c,d,e,f,g,h,i;
//   logic [7:0] sum;
//   checkSums cs(.*);
//   initial begin
//     $monitor($time, "a = %b, b= %b,c = %b,d = %b, e= %b,f = %b,g = %b, h= %b,i = %b,sum = %b",
//                      a, b,c,d,e,f,g,h,i,sum);
//                      a = 4'b1000;
//                      b = 4'b0001;
//                      c = 4'b0110;
//                      d = 4'b0011;
//                      e = 4'b0101;
//                      f = 4'b0111;
//                      g = 4'b0100;
//                      h = 4'b1001;
//                      i = 4'b0010;
//     #10;
//     a = 4'b0011;
//     b = 4'b0010;
//     c = 4'b0111;
//     d = 4'b0100;
//     e = 4'b1001;
//     f = 4'b0110;
//     g = 4'b001;
//     h = 4'b1000;
//     i = 4'b0101;
//     #10;
//     a = 4'b0010;
//     b = 4'b0010;
//     c = 4'b0110;
//     d = 4'b0100;
//     e = 4'b1001;
//     f = 4'b0110;
//     g = 4'b001;
//     h = 4'b1000;
//     i = 4'b0101;
//     #10;
//     a = 4'b0011;
//     b = 4'b0010;
//     c = 4'b0111;
//     d = 4'b0100;
//     e = 4'b1011;
//     f = 4'b0110;
//     g = 4'b001;
//     h = 4'b1000;
//     i = 4'b0101;

//     #10 $finish;
//   end

// endmodule: checkSums_test

module IsMagic
  (input logic [3:0] num1, num2, num3, //top row, L to R
   input logic [3:0] num4, num5, num6, //middle row
   input logic [3:0] num7, num8, num9, //bottom row
   output logic [7:0] magic_constant, //2 BCD digits
   output logic it_is_magic);
   logic [7:0]sum;
   logic checkVals;
   checkValue CV(.num1(num1),.num2(num2),.num3(num3),.num4(num4),.num5(num5),
    .num6(num6),.num7(num7),.num8(num8),.num9(num9),.isMagic(checkVals));
   checkSums CS(.a(num1),.b(num2),.c(num3),.d(num4),.e(num5),.f(num6),.g(num7),.h(num8),.i(num9),.sum(sum));
    always_comb begin
      if ((checkVals == 1'b1) && (sum != 8'b0000_0000)) begin
         it_is_magic = 1'b1;
         magic_constant = sum;
      end else begin
         it_is_magic = 1'b0;
         magic_constant = 8'b0000_0000;
      end
   end

endmodule: IsMagic

module isMagic_test();
logic [3:0] num1,num2,num3,num4,num5,num6,num7,num8,num9;
 logic [7:0] magic_constant;
  logic it_is_magic;
  logic checkVals;
  IsMagic(.*);
    initial begin
    $monitor($time, "num1=%b,num2=%b,num3=%b,num4=%b,num5=%b,num6=%b,num7=%b,num8=%b,num9=%b,magic_constant = %b, checkvals = %b,it_is_magic = %b",
                     num1,num2,num3,num4,num5,num6,num7,num8,num9,magic_constant,checkVals,it_is_magic);
                     num1 = 4'b1000;
                     num2 = 4'b0001;
                     num3 = 4'b0110;
                     num4 = 4'b0011;
                     num5 = 4'b0101;
                     num6 = 4'b0111;
                     num7 = 4'b0100;
                     num8 = 4'b1001;
                     num9 = 4'b0010;
    #10;
    num1 = 4'b0011;
    num2 = 4'b0010;
    num3 = 4'b0111;
    num4 = 4'b0100;
    num5 = 4'b1001;
    num6 = 4'b0110;
    num7 = 4'b001;
    num8 = 4'b1000;
    num9 = 4'b0101;
    #10;
    num1 = 4'b0010;
    num2 = 4'b0010;
    num3 = 4'b0110;
    num4 = 4'b0100;
    num5 = 4'b1001;
    num6 = 4'b0110;
    num7 = 4'b001;
    num8 = 4'b1000;
    num9 = 4'b0101;
    #10;
    num1 = 4'b0011;
    num2 = 4'b0010;
    num3 = 4'b0111;
    num4 = 4'b0100;
    num5 = 4'b1011;
    num6 = 4'b0110;
    num7 = 4'b001;
    num8 = 4'b1000;
    num9 = 4'b0101;
    #10 $finish;
  end
endmodule: isMagic_test


module enter_9_bcd
  (input  logic [3:0] entry,
   input  logic [3:0] selector,
   input  logic       enableL, zeroL, set_defaultL, clock,
   output logic [3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9);

  logic enableL_async, enableL_sync;
  logic zeroL_async, zeroL_sync;
  logic set_defaultL_async, set_defaultL_sync;

  // 2FF Synchronization
  always_ff @(posedge clock) begin
    enableL_async      <= enableL;
    enableL_sync       <= enableL_async;
    zeroL_async        <= zeroL;
    zeroL_sync         <= zeroL_async;
    set_defaultL_async <= set_defaultL;
    set_defaultL_sync  <= set_defaultL_async;
  end

  always_ff @(posedge clock) begin
    if (~zeroL_sync) begin
      num1 <= 4'b0000;
      num2 <= 4'b0000;
      num3 <= 4'b0000;
      num4 <= 4'b0000;
      num5 <= 4'b0000;
      num6 <= 4'b0000;
      num7 <= 4'b0000;
      num8 <= 4'b0000;
      num9 <= 4'b0000;
    end
    else if (~set_defaultL_sync) begin
      num1 <= 4'b1000;
      num2 <= 4'b0001;
      num3 <= 4'b0110;
      num4 <= 4'b0011;
      num5 <= 4'b0101;
      num6 <= 4'b0111;
      num7 <= 4'b0100;
      num8 <= 4'b1001;
      num9 <= 4'b0010;
    end
    else if (~enableL_sync)
    unique case (selector)
      4'b0001: num1 <= entry;
      4'b0010: num2 <= entry;
      4'b0011: num3 <= entry;
      4'b0100: num4 <= entry;
      4'b0101: num5 <= entry;
      4'b0110: num6 <= entry;
      4'b0111: num7 <= entry;
      4'b1000: num8 <= entry;
      4'b1001: num9 <= entry;
    endcase
  end

endmodule: enter_9_bcd

