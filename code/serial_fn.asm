; Needs serial.asm

initSerial:
        LD        A,SER_CR_RESET               ; Master reset ...
        OUT       (SER_CR),A                   ; ... the 6850
        LD        B,0                          ; (Delay may not be needed)
initWait1:
        DJNZ      initWait1                    ; Short delay (may not be needed)
        LD        A,SER_CR_BY_64 | SER_CR_8N1  ; 8N1 at 115200
        OUT       (SER_CR),A                   ; Set the serial protocol
initWait2:
        DJNZ      initWait2                    ; Short delay (may not be needed)
        RET

getChar:
; Wait for a character from the input.
; Return it in A
getChar_wait:
        IN        A,(SER_CR)      ; Data ready ...
        AND       SER_SR_RDFR     ; ... to be read?
        JR        Z,getChar_wait  ; 0=No ... wait for data
        IN        A,(SER_RX)      ; Read the data
        RET

sendChar:
; Wait for buffer to clear.
; Send character in A
        LD        B,A             ; We need A for I/O
sendChar_wait:
        IN        A,(SER_CR)      ; Buffer is ready ...
        AND       SER_SR_TDRE     ; ... for new data?
        JP        Z,sendChar_wait ; 0=No ... wait for ready
        LD        A,B             ; Back to A for I/O
        OUT       (SER_TX),A      ; Write the data
        RET

sendStr:
; Send a string of characters pointed to by HL
; (null terminated)
        LD        A,(HL)          ; Next character
        INC       HL              ; Bump pointer
        JP        Z,sendStr_out   ; 0 means We are done
        CALL      sendChar        ; Write the character
        JP        sendStr         ; Keep printing
