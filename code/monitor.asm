; -------------------------------------------------------------
; Two-byte values in MSB-first
;
; 1aaLL    - Read LL bytes beginning at aa
; 2aaLL... - Write LL byte beginning at aa
; 3p       - Read the port p
; 4pV      - Write the value V to port p
; 5aa      - Execute address aa
;
; Anything else: responds with "Here2" (2=version)
; -------------------------------------------------------------

._CPU = Z80

.include serial.asm

0x0000: ; ROM
#0x8000:  ; RAM

  LD    SP,0         ; First on stack at FFFE,FFFF
  CALL  initSerial

main_loop:

  CALL  getChar

  CP    1
  JP    Z,fn_read

  CP    2
  JP    Z,fn_write

  CP    3
  JP    Z,fn_read_port

  CP    4
  JP    Z,fn_write_port

  CP    5
  JP    Z,fn_execute

fn_ping:
  LD    HL,ping_string
  CALL  sendStr
  LD    A,0
  CALL  send_char
  JP    main_loop

fn_read_port:
  CALL      getChar       ; Port
  LD        C,A
  IN        A,(C)
  CALL      sendChar
  JP        main_loop

fn_write_port:
  CALL      getChar       ; Port
  LD        C,A
  CALL      getChar
  OUT       (C),A
  JP        main_loop

fn_read:
  CALL      getChar       ; Destination
  LD        H,A
  CALL      getChar
  LD        L,A
  CALL      getChar       ; Length
  LD        D,A
  CALL      getChar
  LD        E,A
read_loop:
  LD        A,(HL)        ; Read from memory
  CALL      sendChar      ; Write to serial
  INC       HL            ; Bump the destination pointer
  DEC       DE            ; Decrement the length
  LD        A,D           ; All ...
  OR        E             ; ... done?
  JP        NZ,read_loop  ; No ... still more to do
  JP        main_loop

fn_write:
  CALL      getChar       ; Destination
  LD        H,A
  CALL      getChar
  LD        L,A
  CALL      getChar       ; Length
  LD        D,A
  CALL      getChar
  LD        E,A
write_loop:
  CALL      getChar       ; Get byte
  LD        (HL),A        ; Store it to RAM
  INC       HL            ; Bump the destination pointer
  DEC       DE            ; Decrement the length
  LD        A,D           ; All ...
  OR        E             ; ... loaded?
  JP        NZ,write_loop ; No ... still more to do
  JP        main_loop

fn_execute:
  CALL      getChar       ; Destination
  LD        H,A
  CALL      getChar
  LD        L,A
  JP        (HL)          ; Jump to the destination

ping_string:
. 0x48,0x65,0x72,0x65,50,0

.include serial_fn.asm
