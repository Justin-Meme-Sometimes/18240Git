`default_nettype none

module task2
    (input logic start,
     input logic [15:0] a , b,
     input logic clock,
     output logic done,
     output logic [1:0] ZN,
     output logic [15:0] out);

    logic B_N ,clr_counter,
          en_counter,load_reg,en_shift,en_product,lowBit,lowBit2,
          clr_product;

    logic [15:0] A,B,ABS_value, addNegA, product_val, 
        counted_val, addProductA,mux_out_2;

    //FSM
    FSM my_fsm(.*);

    //This is for checking B is negative
    assign B_N = b[15];
   
    //For shifting A when ready
    ShiftRegister_PIPO #(16) shift_reg_A(.D(a),.Q(A),.en(en_shift),.left('1),
        .load(load_reg),.clock(clock));

    //For checking the absolute value of B and shifting it when when ready

    assign addNegA = ~b + 1;
    Mux2to1 #(16) mux2to(.I1(addNegA),.I0(b),.S(B_N),.Y(B));

    ShiftRegister_PIPO #(16) shift1_reg_B_ABS(.D(B),.Q(ABS_value),
        .en(en_shift),.left('0),.load(load_reg),.clock(clock));

    //For counting if the loop has iterated 8 times
    Counter #(16) countUP (.D('0),.Q(counted_val),.en(en_counter),
        .clock(clock),.load('0),.clear(clr_counter),.up('1));
    
    //For calculating the product by checking the first bit of ABS_Value
    assign addProductA = product_val + A;
    //For checking the lowbit
    assign lowBit = ABS_value[0];
    Mux2to1 #(16) mux2to_1(.I1(addProductA),.I0(product_val),.S(lowBit),.Y(mux_out_2));
    Register #(16) product_register(.D(mux_out_2),.Q(product_val),.clear(clr_product),
        .en(en_product),.clock(clock));
    
    MagComp #(16) mag(.A(counted_val),.B(16'd8),.AeqB(done),.AgtB(),.AltB());
    
    //Determines the final lowbit
    logic [15:0] negative;
    assign lowBit2 = b[7];
    assign negative = ~product_val + 1;
    Mux2to1 #(16) mux2to_2(.I1(negative),.I0(product_val),.S(lowBit2),.Y(out));

endmodule 

module FSM
    (input logic start, clock, done,
    output logic en_counter, en_shift, en_product, clr_product, 
    clr_counter, load_reg);
  enum {START, MULTIPLY} state, nextState;
  logic not_start;

  always_ff @(posedge clock) begin
      state <= nextState;
    end
    always_comb begin
        en_counter = 0;
        en_shift = 0;
        en_product = 0;
        clr_product = 1;
        clr_counter = 1;
        load_reg = 0;
        case(state)
            START:begin
                if(~start) begin
                    en_counter = 0;
                    en_shift = 0;
                    en_product = 0;
                    clr_product = 0;
                    clr_counter = 0;
                    load_reg = 0;
                    nextState = START;
                end
                if(start) begin
                    en_counter = 0;
                    en_shift = 0;
                    en_product = 0;
                    clr_product = 1;
                    clr_counter = 1;
                    load_reg = 1;
                    nextState = MULTIPLY;
                end
            end
            MULTIPLY:begin 
                if(~done) begin
                    en_counter = 1;
                    en_shift = 1;
                    en_product = 1;
                    clr_product = 0;
                    clr_counter = 0;
                    load_reg = 0;
                    nextState = MULTIPLY;
                end
                if(done) begin
                    nextState = START;
                    en_counter = 0;
                    en_shift = 0;
                    en_product = 0;
                    clr_product = 0;
                    clr_counter = 0;
                    load_reg = 0;
                end
            end
        default: nextState = START;
        endcase 
    end

endmodule 

module task2_test();
    
  logic       [15:0] a,b;
  logic       start, done;
  logic       clock, reset_L;
  logic       [1:0] ZN;
  logic       [15:0] out;


  task2 dut (.*);

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  initial
  $monitor($stime,,"a(%d) b(%d) start(%d) done(%d) out(%d)",
           a,b,start,done,out);
  initial begin
    a = 16'd9;
    b = 16'd9;
    start = 0;
    @(posedge clock); //1 
    start = 1; 
    @(posedge clock); //2
    start = 0;
    @(posedge clock); //3
    @(posedge clock); //4
    @(posedge clock); //5
    @(posedge clock); //6
    @(posedge clock); //7
    @(posedge clock); //8
    @(posedge clock); //5
    @(posedge clock); //6
    @(posedge clock); //7
    @(posedge clock); //8
    #1 $finish(20);
  end
    
endmodule