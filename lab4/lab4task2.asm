
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
rjmp restart
.org OVF0addr
rjmp timer0int
.org INT0addr
rjmp increase
.org INT1addr
rjmp decrease

.def LED = r17
.def counter = r18
.def duty_counter = r19

.equ max_counter = 20

.org 0x72

restart:
ldi r20, high (RAMEND)		; R20 = high part of RAMEND address
out SPH, r20				; SPH = high part of RAMEND address
ldi r20, low (RAMEND)		; R20 = low part of RAMEND address
out SPL, r20

ldi r16, 0x01				; set data direction registers.
out DDRB, r16				; set B port as output ports

ldi LED, 0x00
out PORTB, LED

ldi r16, 0x04				; setting up prescaler value to TCCR0
out TCCR0B, r16				; CS2 - CS2 = 101, osc.clock / 1024 -> timer counts every ms. (1000 times / second)

ldi r16, (1<<TOIE0)			; timer 0 enable flag, TOIE0EIMSK 0
sts TIMSK0, r16				; to register TIMSK

ldi r16, 205				; starting value for counter
out TCNT0 , r16				; counter register

ldi r16, 0x03				; INT0 and INT1 enabled
out EIMSK, r16

ldi r16, 0x0F 				; falling and rising edge
sts EICRA, r16
sei 						; enable global interrupt

ldi counter, 0
ldi duty_counter, 10

start: 						;The relative jump uses two cycles.
nop
rjmp start

timer0int:
push r16					; timer interrupt routine
in r16, SREG				; save SREG on stack
push r16
							; reset counter value
ldi r16, 205
out TCNT0, r16

inc counter					; increment counter
cp duty_counter, counter
brlt led_off

ldi LED, 0x00
rjmp continue

led_off:
ldi LED, 0xFF

continue:
cpi counter, max_counter
brne continue2
ldi counter, 0

continue2: 
nop
out portB, LED
pop r16
out SREG, r16
pop r16
reti

increase:
cpi duty_counter, max_counter
brge after_inc
inc duty_counter

after_inc: 
nop
reti

decrease:
cpi duty_counter, 1
brlt after_dec
dec duty_counter

after_dec: 
nop
reti
