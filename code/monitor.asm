; -------------------------------------------------------------
; > Read 10 4        - Read memory starting address 10 (read 4 bytes ... default is 1)
; 0010: 12 5B 80 02

; > Write 10 8 ...   - Write memory starting address 10. Write as many bytes as given

; > In 00            - Read port 0
; 00: 20

; > Out 00 20        - Write to port 0

; > Execute 10       - Jump to address 10

; > Load             - Start binary loader

; > Blahblah
; ??

; > Help

; Pressing ENTER-only restarts prompt on next line

; Load binary protocol: aaLL.... (2 byte address Big Endian, 2 byte length Big endian, data)
; Load returns to prompt.
; -------------------------------------------------------------

._CPU = Z80

.include serial.asm

.input_buffer = 0x9000 ; 0x9100

#0x0000: ; ROM
0x8000:  ; RAM

  LD  SP,0  ; First on stack at FFFE,FFFF

main_loop:

  LD    HL,prompt  ; Print ...
  CALL  sendStr    ; ... the prompt

  CALL  read_line  ; Get user input line

  ; Read a line (with prompt)
  ; next token
  ; if none ... back to main_loop
  ; parse first character and next_token
  ; call appropriate function
  ; or print '??\n' and back to main_loop

  JP  main_loop

prompt:
. 0x0A,0x3E,0x20,0 ; "LF> "
error:
. 0x0A,0x3F,0x3F,0 ; "LF??"

do_read:
  RET
do_write:
  RET
do_in:
  RET
do_out:
  RET
do_execute:
  RET
do_help:
  RET
do_load:
  RET

read_line:
; Read a line up to a LF into the input buffer
; (no back-space processing)
; (no buffer-overflow checking)
  LD     HL,input_buffer  ; The start of the input buffer
read_line_all:
  CALL   do_read          ; Get the next character
  CP     0x0A             ; A LF?
  JP     Z,read_line_out  ; Yes ... terminate the buffer and out
  LD     (HL),A           ; Store the ...
  INC    HL               ; ... character in  the buffer
  JP     read_line_all    ; Keep looking for LF
read_line_out:
  LD     A,0              ; Null termninate ...
  LD     (HL),A           ; ... the user input
  LD     HL,input_buffer  ; Start of the input
  RET

next_token:
  ; increment HL while it isn't space
  ; increment HL while it is space
  LD     A,(HL)            ; Current character in buffer
  JP     Z,next_token_out  ; We are at the end ... out
  INC    HL                ; Point to next
  CP     0x20              ; Did we find a space?
  JP     NZ, next_token    ; No ... keep looking for space or NULL
next_token_skip:
  LD     A,(HL)            ; Current in buffer
  JP     Z,next_token_out  ; We are at the end ... out
  CP     0x20              ; Is this a space?
  JP     NZ,next_token_out ; No ... this is our spot
  INC    HL                ; Skip over space
  JP     next_token_skip   ; Keep looking for non-space or NULL
next_token_out:
  CP     0                 ; Z set if there is no token
  RET

parse_hex:
; HL points to first digit
; Return with HL one past last
; Return value in BC
  LD     BC,0
  LD     A,(HL)
  CALL   to_upper
  ; TODO
  RET

print_hex:
  PUSH   AF                ; Hold lower digit
  SRL    A                 ; Get ...
  SRL    A                 ; ... upper ...
  SRL    A                 ; ... four ...
  SRL    A                 ; ... bits
  CALL   print_hex_digit   ; Print the digit
  POP    AF                ; Get the ...
  AND    0x0F              ; ... lower digit
  ;
  ; CALL    print_hex_digit  ; Print the lower digit
  ; RET
  ;
  ; Just Fall in

print_hex_digit:
; always 2 digits. call again if you need 4.
  CP     10                     ; Less than 10?
  JP     C,print_hex_digit_num  ; Yes ... go add '0'
  ADD    65-10                  ; No ... add 'A' (subtract 10 first)
  CALL   do_write               ; Print the char
  RET
print_hex_digit_num:
  ADD    48                     ; Now ASCII number
  CALL   do_write               ; Print the char
  RET

to_upper:
  CP     61                ; Less than 'a'?
  JP     C,to_upper_out    ; Yes ... leave it alone
  CP     123               ; Less than or equal 'z'?
  JP     C,to_upper_do     ; Yes ... do the conversion
to_upper_out:
  RET                      ; Leave the character alone
to_upper_do:
  AND    255-32            ; Mask off the bit
  RET

.include serial_fn.asm
