;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-10-05
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 4
; Title: Timer and UART.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Square wave generator.
;
; Input ports: None.
;
; Output ports: On-board LEDs connected to DDRB.
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information: Clock set at 1MHz.
;
; Changes in program: 2017-10-06.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.org 0x00
jmp restart
.org OVF0addr				; address for Timer/Counter0 Overflow interrupt
jmp timer0int

.org 0x72

restart:
ldi r20, high (RAMEND)		; R20 = high part of RAMEND address
out SPH, r20				; SPH = high part of RAMEND address
ldi r20, low (RAMEND)		; R20 = low part of RAMEND address
out SPL, r20

ldi r16, 0x01				; set data direction registers.
out DDRB, r16				; set B port as output ports

ldi r17, 0x00
out PORTB, r17

ldi r16, 0x05				; setting up prescaler value to TCCR0
out TCCR0B, r16				; CS2 - CS2 = 101, osc.clock / 1024 -> timer counts every ms. (1000 times / second)

ldi r16, (1<<TOIE0)			; timer 0 enable flag, TOIE0
sts TIMSK0, r16				; to register TIMSK

ldi r16, 100				; starting value for counter
out TCNT0 , r16				; counter register
sei							; enable global interrupt
ldi r18, 0					; help counter

start: 
rjmp start					; main loop

timer0int:
push r16					; timer interrupt routine
in r16, SREG				; save SREG on stack
push r16
							; reset counter value
ldi r16, 100
out TCNT0, r16
inc r18						; increment counter
cpi r18, 5					; check if "tick" is reached - when r16 equals 5
brne continue
ldi r18, 0
com r17						; flip/invert
out PORTB, r17				; push new state to PORTB

continue: 
nop
pop r16						; restore SREG
out SREG, r16
pop r16						; restore register
reti						; return from interrupt

; source: Slides from lecture 7
