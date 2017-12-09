;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-17
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 2
; Title: Subroutines
;
; Hardware: STK600, CPU ATmega2560
;
; Function: A program that is able to count the number of changes on a switch.
;
; Input ports: On-board switches connected to PORTA.
; 
; Output ports: On-board LEDs connected to PORTB.
;
; Subroutines: None.
;
; Included files: m2560def.inc
;
; Other information: Using a loop to make the counter work infinitely.
;					 Clock set at 1MHz.
;
; Changes in program: File created - 2017-09-18.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.def counter = r17 

ldi counter, 0x00
rjmp main

switch:
inc counter		; pushed

loop:
in r16, PINA	; read PINA
cpi r16, 0xFF 	; release all switches
brne loop
inc counter		; released

out DDRB, counter

main:
in r16, PINA	; read PINA
cpi r16, 0xFE	; switch 0 is pushed
breq switch

rjmp main

