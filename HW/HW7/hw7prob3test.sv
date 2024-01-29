`default_nettype none

module hw7prob3_test();

  logic [6:0] score;
  logic       start, grade_it;
  logic       grade_A, grade_B, grade_C, grade_D, grade_R;
  logic       clock, reset_L;
  enum logic [1:0] {HW=2'b00, LAB=2'b01, EXAM=2'b10, CP=2'b11} score_type;

  hw7prob3 dut (.*);

  initial begin
    clock = 0;
    reset_L = 0;
    reset_L <= 1;
    forever #5 clock = ~clock;
  end

  initial
    $monitor($stime,,"sc(%d) tp(%b) st(%b) gi(%b)-> (%b%b%b%b%b)",
             score, score_type, start, grade_it,
             grade_A, grade_B, grade_C, grade_D, grade_R);
    

  initial begin
    score <= 7'd00; score_type <= HW; start <= 1'b0; grade_it <= 1'b0;
    @(posedge clock);  // Make sure we can start later than reset
    @(posedge clock);
    score <= 7'd50; score_type <= HW; start <= 1'b1; grade_it <= 1'b1;
    @(posedge clock);  // HW 50,L 0,E 0,CP 0, Total score = 12.5%, R
    score <= 7'd38;  score_type <= HW; start <= 1'b0; grade_it <= 1'b1;
    @(posedge clock);  // HW 88,L 0,E 0,CP 0, Total score = 22%, R
    score <= 7'd11;  score_type <= HW; start <= 1'b0; grade_it <= 1'b0;
    @(posedge clock);  // grade_it not asserted, no change
    score <= 7'd96;  score_type <= LAB; start <= 1'b0; grade_it <= 1'b1;
    @(posedge clock);  // HW 88,L 96,E 0,CP 0, Total score = 46%, R
    score <= 7'd32;   score_type <= EXAM; start <= 1'b0; grade_it <= 1'b1;
    @(posedge clock);  // HW 88,L 96,E 32,CP 0, Total score = 58%, R
    score <= 7'd16;  score_type <= CP; start <= 1'b0; grade_it <= 1'b1;
    @(posedge clock);  // HW 88,L 96,E 32,CP 16, Total score = 60%, D (exactly!)
    score <= 7'd08;  score_type <= CP; start <= 1'b0; grade_it <= 1'b1;
    @(posedge clock);  // HW 88,L 96,E 32,CP 24, Total score = 61%, D (still)
    score <= 7'd40;  score_type <= EXAM; start <= 1'b0; grade_it <= 1'b1;
    @(posedge clock);  // HW 88,L 96,E 72,CP 24, Total score = 76%, C
    score <= 7'd72;  score_type <= CP; start <= 1'b0; grade_it <= 1'b1;
    @(posedge clock);  // HW 88,L 96,E 72,CP 96, Total score = 85%, B
    score <= 7'd24;  score_type <= EXAM; start <= 1'b0; grade_it <= 1'b1;
    @(posedge clock);  // HW 88,L 96,E 96,CP 79, Total score = 94%, A
    grade_it <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    score <= 7'd100;  score_type <= EXAM; start <= 1'b1; grade_it <= 1'b0;
    @(posedge clock);  // Can we restart?  Can we do it without grading?
    grade_it <= 1'b1;
    @(posedge clock);  // HW 00,L 00,E 100,CP 00, Total score = 25%, R
    #1 $finish(2);
  end

endmodule : hw7prob3_test
