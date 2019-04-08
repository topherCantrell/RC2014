._CPU = Z80

.include serial.asm

; aaLL....
;
; aa   = address (2 byte big endian)
; LL   = length (2 byte big endian)
; .... = data one byte at a time;
; Program is then execute at aa

0x0000:
        LD        SP,0         ; First on stack is at FFFE,FFFF

        CALL      initSerial   ; Prepare the serial communication

        CALL      getChar      ; Destination
        LD        H,A
        CALL      getChar
        LD        L,A

        CALL      getChar      ; Length
        LD        D,A
        CALL      getChar
        LD        E,A

        PUSH      HL           ; We'll RET after loading to jump to this address

loadLoop:
		CALL      getChar      ; Get byte
		LD        (HL),A       ; Store it to RAM
		INC       HL           ; Bump the destination pointer
		DEC       DE           ; Decrement the length
		LD        A,D          ; All ...
		OR        E            ; ... loaded?
		JP        NZ,loadLoop  ; No ... still more to do

        RET                    ; Jump to the loaded code

.include serial_fn.asm
