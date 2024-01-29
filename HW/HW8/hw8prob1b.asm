
; this file coverts the number 21 to its 2's complement form
        .ORG $100
        LI R1, $0015     ;
        NOT  R1,R1       ; 
        ADDI  R1,R1,$1   ;
DONE    STOP