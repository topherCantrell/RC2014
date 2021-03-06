; http://www.vcfed.org/forum/archive/index.php/t-52356.html

; The master reset (CR0, CR1) must be set immediately after powerup.
; CR5 and CR6 should be programmed to define the state of RTS when later master resets are given

;  CS0 -> M1
;  CS1 -> A7
; -CS2 -> A6
;  RS  -> A0

; 10xxxxxx

.SER_CR = 0x80 ; Write
; 7 - CR7 Receive Interrupt Enable
; 6 - CR6   +-- Transmitter Control Bits
; 5 - CR5   +   00=RTSlow_TXIoff, 01=RTSlow_TXIon, 10=RTShigh_TXIoff, 11=RTSlow_TXIoff_BRK
; 4 - CR4     +
; 3 - CR3     +-- Word select : 000=7E2, 001=7O2, 010=7E1, 011=7O1
; 2 - CR2     +                 100=8N2, 101=8N1, 110=8E1, 111=8O1
; 1 - CR1       +-- Counter divide
; 0 - CR0       +   00=By1, 01=By16, 10=By64, 11=MasterReset
.SER_CR_BY_1  = 0b0_00_000_00
.SER_CR_BY_16 = 0b0_00_000_01
.SER_CR_BY_64 = 0b0_00_000_10 ; Use this for RC2014 board
.SER_CR_RESET = 0b0_00_000_11
;
.SER_CR_7E2 = 0b0_00_000_00
.SER_CR_7O2 = 0b0_00_001_00
.SER_CR_7E1 = 0b0_00_010_00
.SER_CR_7O1 = 0b0_00_011_00
.SER_CR_8N2 = 0b0_00_100_00
.SER_CR_8N1 = 0b0_00_101_00
.SER_CR_8E1 = 0b0_00_110_00
.SER_CR_8O2 = 0b0_00_111_00
;
.SER_CR_RTSlow_TXIoff     = 0b0_00_000_00
.SER_CR_RTSlow_TXIon      = 0b0_00_000_01
.SER_CR_RTShigh_TXIoff    = 0b0_00_000_10
.SER_CR_RTSlow_TXIoff_BRK = 0b0_00_000_11
;
.SER_CR_RXI_Enable = 0b1_00_000_00

.SER_SR = 0x80 ; Read
;  7 - IRQ  State of IRQ output (1 if interrupt is triggered). Clear by reading RX or writing TX.
;  6 - PE   Parity Error flag
;  5 - OVRN Receiver Overrun error flag
;  4 - FE   Framing Error
;  3 - CTS  Clear to Send
;  2 - DCD  Data Carrier Detect
;  1 - TDRE Transmit Data Register Empty
;  0 - RDFR Receive Data Register Full
.SER_SR_RDFR = 0b00000001
.SER_SR_TDRE = 0b00000010
.SER_SR_DCD  = 0b00000100
.SER_SR_CTS  = 0b00001000
.SER_SR_FE   = 0b00010000
.SER_SR_OVRN = 0b00100000
.SER_SR_PE   = 0b01000000
.SER_SR_IRQ  = 0b10000000

; TX/RX data

.SER_TX = 0x81 ; Write
.SER_RX = 0x81 ; Read
