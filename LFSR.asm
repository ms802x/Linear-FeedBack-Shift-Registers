; This code is for 8051 microcontroller
; this part of the code generate all the sequence for a given seed and mask
GENERATE:
MOV DPTR,#200H           ; The place where the sequence will be stored at.
MOV R5,#255              ;this is used for looping 255 times
MOV A,P1                 ;Store the value of P1(seed) in A
L1: CLR C                ; HERE IS THE PART WHERE WE DO LFSR
RRC A                    ; rotate A through the carry
JNC Dntgle               ; if there is no carry we don't need to toggle the bits
XRL A,R7                 ; Here will toggle the mask with the value of Port 1
Dntgle: MOVX @DPTR,A     ; Store the value at 200H and so on ...
INC DPTR
DJNZ R5,L1
RET

; The checker is used to check whether the mask used is a unique
;polynomial or not.

CHECK:
MOV R1,#0                ; default R1=0, which mean no repetition. Here R1 works as a flag
MOV R6,#254              ; Number of Swaps
K0:
MOV DPTR,#200H
MOV R5,#254              ; This is for numbers sorting
K2: MOVX A,@DPTR
MOV R2,A                 ;Store A in R2
INC DPTR                 ; Increament DPTR
MOVX A,@DPTR             ;Take the next value and store it at A
CJNE A,02, KC            ; if A>R2, C=0, if A<R2 C=1
MOV R1,#1                ;Repetition Flag
KC: jNC K1               ; if C=0 then we don't need to sort
DEC DPL                  ; if C=1 decreament DPL
MOVX @DPTR,A             ; Store A in the lower address
XCH A,R2                 ; Exchange A,R2
INC DPL                  ; Increament DPL
MOVX @DPTR,A             ; Store A in the next address
K1: djnz R5,K2
djnz R6 ,K0
RET



;If the checker flag R1 was zero then the store function will store the mask at 400H location and so on.
;Otherwise it will wait until the next polynomial detected then it will store it at 401H

STR:
CJNE R1,#00,NEXT1 ; If R1=0, then this is a unique set
MOV DPH,#4H ; Load the higher byte of the DPTR with 4H
MOV DPL,04 ; R4 works as a counter
MOV A,r7 ; R7 is the value of the Mask
MOVX @DPTR,A ;Store the mask at 400H and so on.
INC R4 ; next time the code stores the mask at 401H
NEXT1: INC R7 ; go to next masks
RET


;In this part, our code will take the values from address 400H and will starts showing them consecutively each value with 1s delay.
DELAY:
MOV TMOD,#1H ;Timer in Mode 1
MOV R6,#0FFH ;Load R6 with FFH, this used to show all values
from 400F to 4FFH
MOV DPTR,#400H ; Move dptr to 200H
NC1: MOVX A,@DPTR ; Store the values at 200h ... and so on at A
MOV P3, A ; P3 will take the value of A
INC DPTR
MOV R0, #50 ; Loop 50times
AGAIN: MOV TH0, #0B8H ; initial value to be loaded
MOV TL0, #00H ; in Timer 0 registers
SETB TR0 ; start Timer0
WAIT: JNB TF0, WAIT ; check for overflow
CLR TF0 ; clear overflow flag
CLR TR0 ; stopTimer0
DJNZ R0, AGAIN ; decrement tR7 if not 0 then jump
DJNZ R6, NC1
RET ; end function and return
end
