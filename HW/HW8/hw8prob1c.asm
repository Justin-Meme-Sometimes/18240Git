
; this file has the value 21 and 19 in R1 and R2 then
; R6 adds 19+3 then the value 22 is added to 21       
        .ORG $100
        LI R1, $0015     ;
        LI R2, $0014     ;
        ADDI R6,R2,$003  ;
        ADD  R3,R1,R2    ;
DONE    STOP