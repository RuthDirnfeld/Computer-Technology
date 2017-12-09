;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-25
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 3
; Title: Interrupts.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Turning ON and OFF a LED with a push button.
;
; Input ports: On-board switches connected to DDRD.
;
; Output ports: On-board LEDs connected to DDRB.
;
; Subroutines: interrupt_0, interrupt_1
; Included files: m2560def.inc
;
; Other information: None.
;
; Changes in program: None.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


.include"m2560def.inc"

.org 0x00
rjmp start

.org INT0addr
rjmp interrupt_0
.org INT1addr
rjmp interrupt_1

.org 0x72

start:
ldi r16, HIGH(RAMEND) ; MSB part av address to RAMEND
out SPH, r16 ; store in SPH
ldi r16, LOW(RAMEND) ; LSB part av address to RAMEND
out SPL, r16 ; store in SPL

ldi r20, 0x00
out DDRD, r20			; all zero's to DDRD, input

ldi r20, 0xFF
out DDRB, r20			; all one's to DDRB, outputs

ldi r20, 0x03			; INT0 and INT1 enabled
out EIMSK, r20

ldi r20, 0x08			; INT1 falling edge, INT0 rising edge
sts EICRA, r20

sei						; global interrupt enable

ldi r20, 0xF7
out PORTB, r20

main:
nop
rjmp main

interrupt_0:			
interrupt_1:
andi r20, 0x08			; isolating the bit corresponding to LED3
com r20					; inverting the bit
out PORTB, r20			; outing to LED3
reti					; return from interrupt

