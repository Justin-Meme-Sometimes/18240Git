        .ORG $1000     ;


        LI r2, $1       ;
        LI r3, $0       ;
        SUB r3, r3, r2  ;
        BRN HERE        ;
        BRA NOTHERE     ;

HERE    LI r3, $1       ;
NOTHERE MV r3, r3       ;