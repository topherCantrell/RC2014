
._CPU = Z80

; Start of ROM
0x0000:

    LD   A,3       ; 0_00_000_11: Master reset ...
    OUT  (128),A   ; ... the serial chip

    LD   B,0
d1:
    DJNZ d1
d2:
    DJNZ d2
d3:
    DJNZ d3
d4:
    DJNZ d4

    LD   A,0x16    ; 22 0_00_101_10: 8N1 + DivideBy64 (115200)
    OUT  (128),A  ; Configure the serial chip

d1a:
    DJNZ d1a
d2a:
    DJNZ d2a
d3a:
    DJNZ d3a
d4a:
    DJNZ d4a

    LD   A,50     ; Send ...
    OUT  (129),A  ; ... '2'

stop:
    LD  A,(8192)  ; Strobe the A13 address line
    DJNZ stop
    JP   stop
