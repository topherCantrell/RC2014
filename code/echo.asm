._CPU = Z80

.include serial.asm

; Simple echo program. Read a character and write back
; the character+1.

0x0000:
        CALL      initSerial
mainLoop:
        CALL      getChar
        ADD       1
        CALL      sendChar
        JP        mainLoop

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
        LD        B,A
sendChar_wait:
        IN        A,(SER_CR)      ; Buffer is ready ...
        AND       SER_SR_TDRE     ; ... for new data?
        JP        Z,sendChar_wait ; 0=No ... wait for ready
        OUT       (SER_TX),A      ; Write the data
        RET
