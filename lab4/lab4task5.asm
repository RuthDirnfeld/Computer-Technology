;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-10-07
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 4
; Title: Timer and UART.
;
; Hardware: STK600, CPU ATmega2560
;
; Function:  Serial communication using interrupt based UART.
;
; Input ports: none.
; Connected RS232 RXD, TXD to PD2, PD3.
;
; Output ports: On-board LEDs connected to DDRB.
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information: Clock set at 1MHz.
;
; Changes in program: 2017-10-08.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.equ UBBR_value = 12   ; 4800 as speed (osc.=1MHz, 4800 bps => UBBRR = 12)

.org 0x00
rjmp reset
.org URXC1addr             ; interrupt address
rjmp main  

.org 0x72

reset:
ldi r20 , HIGH (RAMEND) ; R20 = high part of RAMEND address
out SPH ,r20			; SPH = high part of RAMEND address
ldi r20 , LOW (RAMEND)  ; R20 = low part of RAMEND address
out SPL ,r20
						; Initialising output port
ldi r16 , 0xFF			; Set data direction registers
out DDRB , r16			; PORTB output
ldi r16, 0x55			; Init val to output
out PORTB, r16

ldi r16 , UBBR_value
sts UBRR1L , r16

;ldi r16, 0b10011000
ldi r16 , (1<< TXEN1 ) | (1<< RXEN1 ) | (1<< RXCIE1 )
sts UCSR1B , r16

sei						;Set up global interrupt flag

loop: 
nop
rjmp loop

main:
get_char:
lds r16 , UCSR1A		; read from USART to get character
lds r17 , UDR1
rcall port_out
rcall put_char
reti					; return from interrupt

port_out:
mov r16 , r17
com r16					; invert bits to show binary on leds
out PORTB , r16			; write char to PORTB
ret

/*
com r17
out PORTB, r17
com r17
*/
put_char:
lds r16 , UCSR1A
sbrs r16 , UDRE1		; buffer is empty = UDRE1 = 1
rjmp put_char			; buffer is not empty = UDRE1 = 0
sts UDR1 , r17			; write char to UDR1
ret