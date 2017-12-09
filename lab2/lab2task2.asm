;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-16
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 1
; Title: How to use the PORTs. Digital input/output. Subroutine call.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Rolling the electronical dice by randomly generating the number 
; with the switch
;
; Input ports: On-board switches connected to PORTA.
;
; Output ports: On-board LEDs connected to PORTB.
;
; Subroutines: Loops to help with the rolling of the dice and outputting.
; Included files: m2560def.inc
;
; Other information: Clock set at 1MHz
;
; Changes in program: None
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

ldi r16, 0xFF 			
out DDRB, r16 			; All one's to DDRB, output

ldi r16, 0x00 
out DDRA, r16 			; All zero's to DDRA, input

ldi r17,1				; r17 to help with output 

loop:

in r18, PINA			; read PINA
cpi r18, 0xFF			; check if button is pressed
breq output
inc r17					; increment r17
cpi r17, 7				; check if value is 7
brne jmpLoop
ldi r17, 1
jmpLoop:
rjmp loop

;Checking which value is registered
output:
cpi r17, 1				
breq one
cpi r17, 2				
breq two
cpi r17, 3				
breq three
cpi r17, 4				
breq four
cpi r17, 5				
breq five
cpi r17, 6				
breq six

; Depending on the value turn on corresponding LEDs
one:
ldi r16, 0b0001_0000
out DDRB, r16
rjmp loop
two:
ldi r16, 0b0100_0100
out DDRB, r16
rjmp loop
three:
ldi r16, 0b0101_0100
out DDRB, r16
rjmp loop
four:
ldi r16, 0b1100_0110
out DDRB, r16
rjmp loop
five:
ldi r16, 0b1101_0110
out DDRB, r16
rjmp loop
six:
ldi r16, 0b1110_1110
out DDRB, r16
rjmp loop



