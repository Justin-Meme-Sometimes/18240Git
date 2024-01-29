module MagComp_test();
    logic [9:0] A,B;
    logic AeqB, AgtB, AltB;
    MagComp #(10) mag1(.*);

    initial begin
    $display($time,,"W = (10), A(%d), B(%d), A EQ B (%d) ,A GT B (%d),ALTB(%D)"
        , A, B, AeqB, AgtB, AltB);
        A = 10'd10; B=10'd0;
        #5 A=10'd12; B=10'd4;
        #5 A=10'd54; B=10'd24;
        #5 A=10'd31; B=10'd42;
        #5 A=10'd32; B=10'd32;

        $finish;
    end
endmodule

module Decoder_test();
    logic [3:0] I;
    logic en;
    logic [9:0] D;

    Decoder #(10) dec1(.*);


    initial begin
        $monitor($time,,"Width = (10), I(%d), D(%d), en (%d)"
        ,I ,D, en);
        #5 I=10'd3; en=1'd0;
        #5 I=10'd12; en=1'd1;
        #5 I=10'd83; en=1'd1;
        #5 I=10'd43; en=1'd0;
        #5 I=10'd33; en=1'd1;
        #5 I=10'd15; en=1'd1;
        $finish;
    end
endmodule

module Adder_test();
    logic [7:0] A,B;
    logic cin,cout;
    logic [7:0] S;
    Adder #(8) Add(.*);


    initial begin
        $monitor($time,,"Width = (8), A(%d), B(%d), cIn (%d), cOut (%d),S(%d)" ,
        A ,B, cin, cout,S);
        #5 A=8'd3; B = 8'd15; cin = 1'd0;
        #5 A=8'd12;B = 8'd12; cin = 1'd1;
        #5 A=8'd83;B = 8'd0;  cin = 1'd1;
        #5 A=8'd43;B = 8'd20; cin = 1'd0;

        $finish;
    end
endmodule

module Register_test();
    logic [7:0] Q , D;
    logic en,clock,clear;
    Register #(8) Register(.*);

    initial begin
        forever #5 clock = ~clock;
    end

    initial begin
        $monitor($time,,"Width = (8), D(%d), Q(%d), en (%d), clear (%d)"
        ,D ,Q, en, clear);
      #10 D = 8'd1;
        en = 1;
        clear = 1;
        @(posedge clock);
        @(posedge clock);
     #10 D = 8'd1;
        en = 0;
        clear = 0;
        @(posedge clock);
        @(posedge clock);
     #10 D = 8'd1;
        en = 0;
        clear = 0;
        @(posedge clock);
        @(posedge clock);
      #10 D = 8'd10;
        en = 0;
        clear = 0;
        @(posedge clock);
        @(posedge clock);

        $finish;
    end
endmodule

module Mux2to1_test();
    logic S;
    logic [7:0] I0, I1;
    logic [7:0] Y;

    Mux2to1 #(8) mux(.*);

    initial begin
        $monitor($time,, "S=%b, I0=%d, I1=%d, Y=%b",
             S, I0, I1, Y);
    #5 I0 = 8'd4; I1 = 8'd1; S = 1'd0;
    #5 I0 = 8'd14; I1 = 8'd32; S = 1'd1;
    #5 I0 = 8'd2; I1 = 8'd8; S = 1'd0;
    #5 I0 = 8'd30; I1 = 8'd32; S = 1'd1;
    #5 I0 = 8'd23; I1 = 8'd13; S = 1'd0;

    $finish;
    end
endmodule

module Multiplexer_test();
    logic Y;
    logic [7:0] I;
    logic [2:0] S;

    Multiplexer #(8) mux(.*);

    initial begin
        $monitor($time,, "I=%b, S=%d, Y=%b",
             S, I,Y);
    #5 I = 8'd4; S = 3'd1;
    #5 I = 8'd14; S = 3'd2;
    #5 I = 8'd2; S = 3'd3;
    #5 I = 8'd30; S = 3'd4;
    #5 I = 8'd23; S = 3'd2;

        $finish;
    end
endmodule :  Multiplexer_test;

module DFlipFlop_test();
    logic D;
    logic clock;
    logic reset_L, preset_L;
    logic Q;

    DFlipFlop ff(.*);

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        $monitor($time,,"D=%d, Q=%d,reset_L=%d,preset_L=%d"
        ,D,Q,reset_L,preset_L);

        #10 D = 1'b1;
        reset_L = 1'b1;
        preset_L = 1'b1;
        @(posedge clock);
        #10 D = 1'b1;
        reset_L = 1'b1;
        preset_L = 1'b1;
        @(posedge clock);
        #10 D = 1'b1;
        reset_L = 1'b1;
        preset_L = 1'b1;
        @(posedge clock);
        #10 D = 1'b0;
        reset_L = 1'b1;
        preset_L = 1'b0;
        @(posedge clock);

        $finish;
    end

endmodule

module Counter_test();
    logic en, clear, load, up;
    logic clock;
    logic [9:0]D;
    logic [9:0]Q;

    Counter #(10) count (.*);
    initial begin
        clock = 1'b0;
        forever #5 clock = ~clock;
    end

    initial begin
        $monitor($time,,"D=%d, Q=%d,clear=%d,load=%d,up=%d,en=%d",
        D,Q,clear,load,up,en);
    en = 1'b1;
    clear = 1'b1;
    load = 1'b1;
    up = 1'b1;
    D = 10'd4;
    @(posedge clock);
    @(posedge clock);
    load = 1'b0;
    @(posedge clock);
    @(posedge clock);
    up = 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    $finish;
    end
endmodule

module BarrelShiftRegister_test();

    logic [15:0] D;
    logic en;
    logic clock;
    logic load;
    logic [2:0] by;
    logic [15:0] Q;
    BarrelShiftRegister #(16) tb (.*);

    initial begin
        clock = 1'b0;
        forever #5 clock = ~clock;
    end

    initial begin
        $monitor($time,,"D=%d, Q=%d,load=%d,up=%d,en=%d",
        D,Q,load,by,en);

    en = 1'b1;
    load = 1'b1;
    by = 2'd3;
    D = 16'd4;
    @(posedge clock);
    load = 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    by = 2'd2;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    by = 2'd1;

    $finish;

    end
endmodule

module ShiftRegister_PIPO_test();

    logic [15:0] D;
    logic en;
    logic clock;
    logic load;
    logic left;
    logic [15:0] Q;
    ShiftRegister_PIPO #(16) tb (.*);

    initial begin
        clock = 1'b0;
        forever #5 clock = ~clock;
    end

    initial begin
        $monitor($time,,"D=%d, Q=%d,left=%d,up=%d,en=%d",
        D,Q,load,left,en);


    en = 1'b1;
    load = 1'b1;
    left = 1'd1;
    D = 15'd4;
    @(posedge clock);
    load = 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    left = 1'd0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    left = 1'd0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    $finish;
    end
endmodule

module ShiftRegister_SIPO_test();

    logic serial;
    logic en;
    logic clock;
    logic left;
    logic [15:0] Q;
    ShiftRegister_SIPO #(16) tb (.*);

    initial begin
        clock = 1'b0;
        forever #5 clock = ~clock;
    end

    initial begin
        $monitor($time,,"Serial=%d, Q=%d,left=%d,en=%d",
        serial,Q,left,en);


    en = 1'b1;
    left = 1'd1;
    serial = 1'd0;
    @(posedge clock);
    serial = 1'd1;
    @(posedge clock);
    @(posedge clock);
    serial = 1'd0;
    @(posedge clock);
    left = 1'd0;
    @(posedge clock);
    @(posedge clock);
    serial = 1'd0;
    @(posedge clock);
    @(posedge clock);
    left = 1'd1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    $finish;
    end
endmodule
module Memory_test();

endmodule
