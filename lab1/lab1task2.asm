;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-05
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 1
; Title: How to use the PORTs. Digital input/output. Subroutine call.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Reading the switches and lighting up the corresponding 
; LED.
;
; Input ports: On-board switches connected to PORTA .
; 
; Output ports: On-board LEDs connected to PORTB.
;
; Subroutines: None.
; Included files: m2560def.inc
;
; Other information: Using a loop to read the switches and to turn 
; on the corresponding LED.
;
; Changes in program: None.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


.include "m2560def.inc"


ldi r16, 0xFF
out DDRB, r16                           ; All one's to DDRB, outputs 

ldi r16, 0b00000000
out DDRA, r16                           ; All zero's to DDRA, inputs

loop:
in r16, PINA                            ; read PINA
out PORTB, r16                          ; write in PORTB

rJmp loop
