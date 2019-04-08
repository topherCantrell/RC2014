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

.include serial_fn.asm
