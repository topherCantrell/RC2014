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

._CPU Z80

.include serial.asm

.input_buffer = 0x9000 ; 0x9100

#0x0000: ; ROM
0x8000:  ; RAM

  LD  SP,0  ; First on stack at FFFE,FFFF

main_loop:

  ; Read a line (with prompt)
  ; next token
  ; if none ... back to main_loop
  ; parse first character and next_token
  ; call appropriate function
  ; or print '??\n' and back to main_loop

  JP  main_loop

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
  ; TODO handle backspace
  RET
next_token:
  RET
parse_hex:
  RET
to_upper:
  RET

.include serial_fn.asm
