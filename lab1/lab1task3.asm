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
; Function: Using SW5 to light up LED0. 
;
; Input ports: On-board switches connected to PORTA .
; 
; Output ports: On-board LEDs connected to PORTB.
;
; Subroutines: None.
; Included files: m2560def.inc
;
; Other information: Using a loop to read the correct switch and to 
; turn on the corresponding LED.
;
; Changes in program: None.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

ldi r16, 0b00000001             ; One one to DDRB, output
out DDRB, r16

ldi r16, 0b11011111             ; One zero to DDRA, input
out DDRA, r16  

loop:

ldi r16, 0b11111111             
out PORTB, r16                  ; turn off all LEDs

in r16, PINA                    ; read PINA

cpi r16, 0                      ; check if switch is pressed
brne loop                       ; restart loop

ldi r16, 0b11111110            
out PORTB,r16                    ; turn on LED0

rJmp loop
