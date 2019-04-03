; http://www.vcfed.org/forum/archive/index.php/t-52356.html

; The master reset (CR0, CR1) must be set immediately after powerup.
; CR5 and CR6 should be programmed to define the state of RTS when later master resets are given

;  CS0 -> M1
;  CS1 -> A7
; -CS2 -> A6
;  RS  -> A0

; 10xxxxxx

. SER_CR = 0x80 ; Write
; 7 - CR7 Receive Interrupt Enable
; 6 - CR6 +-- Transmitter Control Bits
; 5 - CR5 +
; 4 - CR4   +
; 3 - CR3   +-- Word select (101 = 8bits, no parity, 1stop)
; 2 - CR2   +
; 1 - CR1     +-0- Counter divide (11 = master reset)
; 0 - CR0     +

. SER_SR = 0x80 ; Read
;  7 - IRQ  State of IRQ output (1 if interrupt is triggered). Clear by reading RX or writing TX.
;  6 - PE   Parity Error flag
;  5 - OVRN Receiver Overrun error flag
;  4 - FE   Framing Error
;  3 - CTS  Clear to Send
;  2 - DCD  Data Carrier Detect
;  1 - TDRE Transmit Data Register Empty
;  0 - RDFR Receive Data Register Full

. SER_TX = 0x81 ; Write
. SER_RX = 0x81 ; Read
