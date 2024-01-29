module hw7prob3
    (input  logic [6:0] score,
     input  logic [1:0] score_type,
     input  logic       start, grade_it,
     output logic       grade_A, grade_B, grade_C, grade_D, grade_R,
     input  logic       clock, reset_L);

     logic reset_HW, reset_exam, reset_lab, reset_p;

     FSM fsm1(.*);

     logic [6:0] sum1, sum2, sum3, sum4, score_out;
     logic [6:0] sum1_pre, sum2_pre, sum3_pre, sum4_pre;
     logic HW, lab, exam, part;
     logic [6:0] score_HW, score_exam, score_lab, score_p;
     logic [6:0] grade;
     

     Mux2to1 #(7) mux5(.S(grade_it), .I1(score), .I0(7'd0), .Y(score_out));

     Adder #(7) Add1(.A(score_out), .B(score_HW), .sum(sum1_pre), .cout(), 
                     .cin(1'd0));
     Adder #(7) Add2(.A(score_out), .B(score_exam), .sum(sum2_pre), .cout(), 
                     .cin(1'd0));
     Adder #(7) Add3(.A(score_out), .B(score_lab), .sum(sum3_pre), .cout(), 
                     .cin(1'd0));
     Adder #(7) Add4(.A(score_out), .B(score_p), .sum(sum4_pre), .cout(), 
                     .cin(1'd0));

     Mux2to1 #(7) mux1(.S(start), .I0(sum1_pre), .I1(score), .Y(sum1));
     Mux2to1 #(7) mux2(.S(start), .I0(sum2_pre), .I1(score), .Y(sum2));
     Mux2to1 #(7) mux3(.S(start), .I0(sum3_pre), .I1(score), .Y(sum3));
     Mux2to1 #(7) mux4(.S(start), .I0(sum4_pre), .I1(score), .Y(sum4));

     MagComp #(2) comp1(.A(2'b00), .B(score_type), .AeqB(HW), .AgtB(), .AltB());
     MagComp #(2) comp2(.A(2'b01), .B(score_type), .AeqB(lab), .AgtB(),.AltB());
     MagComp #(2) comp3(.A(2'b10), .B(score_type), .AeqB(exam),.AgtB(),.AltB());
     MagComp #(2) comp4(.A(2'b11), .B(score_type), .AeqB(part),.AgtB(),.AltB());

     Register #(7) reg1(.D(sum1), .Q(score_HW), .en(HW), .clear(reset_HW), 
                        .clock(clock));
     Register #(7) reg2(.D(sum2), .Q(score_exam), .en(exam), .clear(reset_exam),
                        .clock(clock));
     Register #(7) reg3(.D(sum3), .Q(score_lab), .en(lab), .clear(reset_lab), 
                        .clock(clock));
     Register #(7) reg4(.D(sum4), .Q(score_p), .en(part), .clear(reset_p), 
                        .clock(clock));

     
     logic [6:0] temp_exam, temp_HW, temp_exam2, temp_lab, temp_p;
     assign temp_HW = score_HW >> 2;
     assign temp_exam = score_exam >> 2;
     assign temp_exam2 = score_exam >> 3;
     assign temp_lab = score_lab >> 2;
     assign temp_p = score_p >> 3;

     logic [6:0] out1, out2, out3;

     Adder #(7) Add5(.A(temp_exam), .B(temp_exam2), .sum(out1), .cout(), 
                     .cin(1'd0));
     Adder #(7) Add6(.A(temp_HW), .B(out1), .sum(out2), .cout(), 
                     .cin(1'd0));
     Adder #(7) Add7(.A(out2), .B(temp_lab), .sum(out3), .cout(), 
                     .cin(1'd0));
     Adder #(7) Add8(.A(out3), .B(temp_p), .sum(grade), .cout(), 
                     .cin(1'd0));

     RangeCheck #(7) checkA(.high(7'd100), .low(7'd90), .val(grade), 
                            .is_between(grade_A));
     RangeCheck #(7) checkB(.high(7'd89), .low(7'd80), .val(grade), 
                            .is_between(grade_B));
     RangeCheck #(7) checkC(.high(7'd79), .low(7'd70), .val(grade),
                            .is_between(grade_C));
     RangeCheck #(7) checkD(.high(7'd69), .low(7'd60), .val(grade), 
                            .is_between(grade_D));
     RangeCheck #(7) checkR(.high(7'd59), .low(7'd0), .val(grade), 
                            .is_between(grade_R));

endmodule: hw7prob3

module FSM
    (input  logic start, reset_L, grade_it, clock,
     input  logic [1:0] score_type,
     output logic reset_HW, reset_lab, reset_exam, reset_p);

     enum logic {Start, AddScore} currState, nextState;

     always_comb begin
        reset_HW = 1'b1;
        reset_lab = 1'b1; 
        reset_exam = 1'b1; 
        reset_p = 1'b1;
        case(currState)
            start: begin
                if (start == 0) begin
                    nextState = Start;
                end
                else if (start == 1) begin
                    nextState = AddScore;
                    reset_HW = 1'b1;
                    reset_lab = 1'b1; 
                    reset_exam = 1'b1; 
                    reset_p = 1'b1;
                end
            end
            AddScore: begin
                if (start == 0) begin
                    nextState = AddScore;
                    reset_HW = 1'b0;
                    reset_lab = 1'b0; 
                    reset_exam = 1'b0; 
                    reset_p = 1'b0;
                end
                if (start == 1) begin
                    nextState = AddScore;
                    reset_HW = 1'b1;
                    reset_lab = 1'b1; 
                    reset_exam = 1'b1; 
                    reset_p = 1'b1;
                end
            end
        endcase
     end
     always_ff @(posedge clock, negedge reset_L) begin
        if (~reset_L)
            currState <= Start;
        else
            currState <= nextState;
     end


endmodule: FSM