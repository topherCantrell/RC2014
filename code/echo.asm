._CPU = Z80

.include serial.asm

; Simple echo program. Read a character and write back
; the character+1.

; 0x0000:  ; Start of ROM
0x8000:    ; Start of RAM

        LD        SP,0        ; Backs up to FFFE,FFFF
        CALL      initSerial  ; Initialize the serial
mainLoop:
        CALL      getChar     ; Read a character
        ADD       1           ; Add one (proof we did something)
        CALL      sendChar    ; Echo back
        JP        mainLoop    ; Forever

.include serial_fn.asm
