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
; Function:  Serial communication using polled UART.
;
; Input ports: none.
; Connected RS232 RXD, TXD to PD2, PD3.
;
; Output ports: On-board LEDs connected to DDRB.
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information: None.
;
; Changes in program: 2017-10-08.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.equ UBBR_value = 12   ; 4800 as speed (osc.=1MHz, 4800 bps => UBBRR = 12)

.org 0x00
rjmp reset

.org 0x72

reset:
ldi r16, 0xFF			; PORTB output
out DDRB, r16
ldi r16, 0x55			; Init val to output
out PORTB, r16

ldi r16, UBBR_value		; store Prescaler val in UBRR1L
sts UBRR1L, r16			; connect cable to pin 2/3 on Port D

ldi r16, (1<<TXEN1) | (1<<RXEN1)  ; enable USART transmitter (set TX and RX enable flags)
sts UCSR1B, r16

main:
get_char:
lds r16, UCSR1A      ; read from USART to get character
sbrs r16, RXC1       ; new character, RXC1=1
rjmp get_char		 ; no char received RXC1=0

lds r17, UDR1		 ; read char in UDR

port_output:
com r17            ; invert bits to show binary on leds
out PORTB, r17	   ; write char to PORTB
com r17

put_char:
lds r16, UCSR1A    ; 
sbrs r16, UDRE1    ; buffer is empty = UDRE1 = 1
rjmp put_char	   ; buffer is not empty = UDRE1 = 0
sts UDR1, char	   ; write char to UDR1
rjmp main		   ; jump back to loop

