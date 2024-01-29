; Compute a 9-sided magic square, using RISC240 assembly language

       .ORG $FF0   ; Input Data
SIDE   .DW  $9     ; Size of the Magic Square
SQUARE .DW  $51    ; SIDE * SIDE (yep, doing the multiplication myself) 
BASE   .EQU $2000  ; Base address of destination array

       .ORG $1000  ; Code segment 
; following the given Python code
; # initialize memory to zero values
;    for i in range(squared):
;        memory[base + 2*i] = 0
;  i in R1
; 2*i in R2
; SQUARE in R7
         MV   R1, R0
MEMINIT  MV   R2, R1
         SLLI R2, R2, $1
         SW   R2, R0, BASE
         ADDI R1, R1, $1
         LW   R7, R0, SQUARE
         SLT  R0, R1, R7
         BRN  MEMINIT
; Done with R7
         
; # Set a column and row pointer to the square just below center
; col = side // 2
; row = side // 2 + 1
; col in R2
; row in R3
         LW   R2, R0, SIDE
         SRLI R2, R2, $1  ; Divide in half
         ADDI R3, R2, $1  
         
; # Insert the numbers 1..n^2
; for i in range(1,squared+1):
; i in R1
; SQUARE in R4 (to compare for equality against.  Works because Python
;               range is up-to-but-not-equal)
         MV   R1, R0
FOR      ADDI R1, R1, $1
         LW   R4, R0, SQUARE
         SLT  R0, R1, R4
         BRZ  DONE
; Done with R4

;     # Insert the number into memory, using current row/col pointers
;     memory[base + 2 * (row * side + col)] = i
; R4 for address calculations
         SLLI R4, R3, $3    ; Multiplying by 9 (static size) by Row*8+Row
         ADD  R4, R4, R3
         ADD  R4, R4, R2    ; Add column
         SLLI R4, R4, $1    ; Multiply by 2
         SW   R4, R1, BASE  ; Add Base and store R1 there
; done with R4
;     
;     # Update the row/col pointers to right and down, ensuring
;     #   they stay within the square
;     next_col = (col + 1) 
;     if next_col >= side:
;         next_col -= side
;     next_row = (row + 1) 
;     if next_row >= side:
;         next_row -= side
; next_col in R5
; next_row in R6
; side in R7
         ADDI R5, R2, $1
         LW   R7, R0, SIDE
         SLT  R0, R5, R7
         BRN  CHK_ROW
         SUB  R5, R5, R7         
CHK_ROW  ADDI R6, R3, $1
         SLT  R0, R6, R7
         BRN  CHK_FILLED
         SUB  R6, R6, R7
        
;     # Check if the updated row/col pointers indicate an already filled cell
;     if memory[base + 2 * (next_row * side + next_col)] == 0:
;         col = next_col
;         row = next_row
;     else: 
;         row += 2  # if they do, just drop the row by 2
;         if row >= side:
;             row -= side
; R4 for address calculations
CHK_FILLED SLLI R4, R6, $3  ; next_row * 8
           ADD  R4, R4, R6  ; plus next_row (multiply by 9)
           ADD  R4, R4, R5  ; plus next_col
           SLLI R4, R4, $1  ; times 2
           LW   R0, R4, BASE  ; Don't need the value, just check if it is zero
           BRZ  UPDATE
           ADDI R3, R3, $2  ; row += 2
           SLT  R0, R3, R7  ; row less than side?
           BRN  FOR
           SUB  R3, R3, R7
           BRA  FOR
UPDATE     MV   R2, R5
           MV   R3, R6
           BRA  FOR
           
DONE       STOP
           
