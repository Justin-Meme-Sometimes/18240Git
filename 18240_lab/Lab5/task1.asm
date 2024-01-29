           
            .ORG $200        ; starts at $200
            LI r4, $FF00     ; Loads value for A
            LI r5, $FF00     ; Loads value for B
            SW r0, r4, $102  ; Stores A at 102
            SW r0, r5, $100  ; Stores B at 100
            LW r1 r0 $102    ; Loads word at Mem[102]
            LW r2 r0 $100    ; Loads word from Mem[100]
CLEAR       MV r3,r0         ; clears r3

