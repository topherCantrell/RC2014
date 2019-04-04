
.include serial.asm

; Start of ROM
0x0000:

    LD   SP,0xC000 ; Middle of RAM

    LD   A,0x03    ; 0_00_000_11: Master reset ...
    OUT  SER_CR,A  ; ... the serial chip

    CALL Delay

    LD   A,0x16    ; 0_00_101_10: 8N1 + DivideBy64 (115200)
    OUT  SER_CR,A  ; Configure the serial chip

    CALL Delay

Loop:
    LD   A,0x32    ; Send ...
    OUT  SER_TX,A  ; ... '2'

    CALL Delay

    LD   A,66      ; Send ...
    OUT  SER_TX,A  ; ... 'B'

    CALL Delay

    JR   Loop      ; Keep sending over and over

; 1 / 7,372,800 = 1.3566e-7 * 13 * 256 = 4.5e-4 seconds
; 4.5e-4 * 2048 = Almost 1 second
Delay:
    LD   DE,2048
Inner:
    DJNZ Inner     ; .0045ms spin
    DEC  DE        ; Do ...
    LD   A,D       ; ... outer ...
    OR   E         ; ... count ...
    JP   NZ,Inner  ; ... loop
    RET
