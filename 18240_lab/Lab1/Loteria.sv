`default_nettype none

module Loteria
  (input logic a,b,c,d,e,f,
   output logic win, error);

  logic a_not, b_not, c_not, d_not, f_not;

  logic win_logic0, win_logic1, win_logic2,
        win_logic3, win_logic4;
  logic win_sub0, win_sub1, win_sub0_not, win_sub1_not;

  not n0(a_not, a),
      n1(b_not, b),
      n2(c_not, c),
      n3(d_not, d),
      n4(f_not, f);

  nor w0(win_logic0, b, f),
      w1(win_logic1, c, d),
      w2(win_logic2, b_not, c),
      w3(win_logic3, c_not, f_not),
      w4(win_logic4, a, d_not, e),
      w5(win_sub0, win_logic0, win_logic1, win_logic2),
      w6(win_sub1, win_logic3, win_logic4),
      w7(win_sub0_not, win_sub0, win_sub0),
      w8(win_sub1_not, win_sub1, win_sub1),
      w9(win, win_sub0_not, win_sub1_not);

  logic error_logic0, error_logic1, error_logic2,
        error_logic3, error_logic4, error_logic5;
  logic error_sub0, error_sub1, error_sub0_not, error_sub1_not;

  nor e0(error_logic0, c, e),
      e1(error_logic1, a, b_not),
      e2(error_logic2, e, b),
      e3(error_logic3, b, c_not, f_not),
      e4(error_logic4, a, c),
      e5(error_logic5, b, c, d),
      e6(error_sub0, error_logic0, error_logic1, error_logic2),
      e7(error_sub1, error_logic3, error_logic4, error_logic5),
      e8(error_sub0_not, error_sub0, error_sub0),
      e9(error_sub1_not, error_sub1, error_sub1),
      e10(error, error_sub0_not, error_sub1_not);



endmodule: Loteria


module LoteriaSOP
  (input logic a,b,c,d,e,f,
   output logic win, error);

  logic b_not, c_not, d_not, e_not, f_not;

  logic win_logic0, win_logic1, win_logic2, win_logic3;
  logic win_logic2_sub, win_logic2_sub_not, win_logic3_sub, win_logic3_sub_not;

  not n0(b_not, b),
      n1(c_not, c),
      n2(d_not, d),
      n3(e_not, e),
      n4(f_not, f);

  nand w0(win_logic0, b, c, d_not, e_not),
       w1(win_logic1, c, e, f_not),
       w2(win_logic2_sub, a, b_not, c_not),
       w3(win_logic2_sub_not, win_logic2, win_logic2),
       w4(win_logic2, win_logic2_sub_not, d, f),
       w5(win_logic3_sub, b_not, c_not, d),
       w6(win_logic3_sub_not, win_logic3_sub, win_logic3_sub),
       w7(win_logic3, win_logic3_sub_not, e, f),
       w8(win, win_logic0, win_logic1, win_logic2, win_logic3);

  logic error_logic0, error_logic1, error_logic2,
        error_logic3;

  nand e0(error_logic0, a, b, c),
       e1(error_logic1, a, b, e),
       e2(error_logic2, b_not, c, e, f_not),
       e3(error_logic3, a, c_not, d, e),
       e10(error, error_logic0, error_logic1, error_logic2, error_logic3);



endmodule: LoteriaSOP

module Loteria_test
  (output logic [5:0]vector,
   input logic win, error);



  initial begin
    $monitor($time,, "f = %b, e = %b, d = %b, c = %b, b = %b, a = %b, win = %b,err = %b",
             vector[5], vector[4], vector[3], vector[2], vector[1], vector[0], win, error);
    vector = 6'd7;
    #10
    vector = 6'd24;
    #10
    vector =6'd26;
    #10
    vector = 6'd27;
    #10
    vector = 6'd17;
    #10
    vector = 6'd32;
    #10
    vector = 6'd39;
    #10
    vector = 6'd38;
    #10
    vector = 6'd50;
    #10
    vector = 6'd59;
    //for(vector = 6'b0; vector < 6'd55; vector += 6'd1) #10;

    $finish;

  end


endmodule: Loteria_test

module top();
    logic win, error, a, b, c, d, e, f;

    LoteriaSOP  DUT (.a, .b, .c, .d, .e, .f, .win, .error);
    Loteria_test T (.vector({a, b, c, d, e, f}), .win, .error);

endmodule: top
