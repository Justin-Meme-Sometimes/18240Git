        .ORG    $100
start   LI      R6, $0     ; R6 <- $0 (immediate)
        LI      R7, $1     ; R7 <- $1 (immediate)

loop    SLTI    R0, R7, $D ; R7 - D (result discarded)
        BRZ     done       ; branch if R7 == D
        ADD     R6, R6, R7 ; R6 <- R6 + R7
        ADD     R7, R7, R6 ; R7 <- R7 + R6
        BRA     loop       ; branch always ("go to")

done    STOP               ; all done

