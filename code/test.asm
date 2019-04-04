
.include serial.asm

; Start of ROM
0x0000:

    DI             ; They should start off disabled, but just in case
    LD   A,0x03    ; 0_00_000_11: Master reset ...
    OUT  SER_CR,A  ; ... the serial chip

    LD   B,0       ; Pause
P1:
    DJNZ P1

    LD   A,0x16    ; 0_00_101_10: 8N1 + DivideBy64 (115200)
    OUT  SER_CR,A  ; Configure the serial chip

    LD   B,0       ; Pause
P2:
    DJNZ P2

Loop:
    LD   A,0x32    ; Send ...
    OUT  SER_TX,A  ; ... '2'

    LD   B,0       ; Pause
P3:
    DJNZ P3

    LD   A,66      ; Send ...
    OUT  SER_TX,A  ; ... 'B'

    LD   B,0       ; Pause
P4:
    DJNZ P4

    JR   Loop      ; Keep sending over and over
