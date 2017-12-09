;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-10-09
; Author:
; Student name 1 Ruth Dirnfeld
; Student name 2 Alexandra Bjäremo
;
; Lab number: 5
; Title: Display JHD202
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Electronic bingo machine
;
; Input ports: None.
;
; Output ports: LCD display connected to DDRE.
;
; Subroutines: Display initialization.
; Included files: m2560def.inc
;
; Other information: Clock set at 1MHz.
;
; Changes in program: 
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


.include "m2560def.inc"

.def Temp = r16
.def Data = r17
.def RS = r18
.def small_num = r19 
.def tens_num = r20 

.equ BITMODE4 = 0b00000010     ; 4-bit operation
.equ CLEAR = 0b00000001        ; Clear display
.equ DISPCTRL = 0b00001111     ; Display on, cursor on, blink on.  //DISP_CTRL
.equ VAL_MAX = 75
.equ VAL_MIN = 1

.equ LCD = 0b0011_0000         ; Prefix for outputting number on LCD


.cseg
.org 0x00
jmp reset

.org int0addr
jmp int_generateRandom

.org 0x72

reset:

; Init stack pointer
ldi Temp, HIGH(RAMEND)    ; Temp = high byte of ramend address
out SPH, Temp             ; sph = Temp
ldi Temp, LOW(RAMEND)     ; Temp = low byte of ramend address
out SPL, Temp             ; spl = Temp
    
; set LCD output port
ser Temp                  ; r16 = 0b11111111
out DDRE, Temp            ; port E = outputs ( Display JHD202A)
clr Temp                  ; r16 = 0
out DDRD, Temp 

; Initialize display
rcall init_disp

ldi Temp, (1<<int0)
out EIMSK, Temp
    
ldi Temp, (3<<ISC00)
sts EICRA, Temp
        
sei
    
rjmp reset_value

value_loop:   
cpi small_num, VAL_MAX
brge reset_value
inc small_num
rjmp value_loop

reset_value:
ldi small_num, VAL_MIN
rjmp value_loop

; Display subroutines
init_disp:
rcall power_up_wait       ; wait for display to power up
ldi Data, BITMODE4        ; 4-bit operation
rcall write_nibble        ; (in 8-bit mode)
rcall short_wait          ; wait min. 39 us
ldi Data, DISPCTRL        ; disp. on, blink on, curs. On
rcall write_cmd           ; send command
rcall short_wait          ; wait min. 39 us

clr_display:   
ldi Data, CLEAR           ; clr display
rcall write_cmd           ; send command
rcall long_wait           ; wait min. 1.53 ms
ret

; **
; ** write char/command
; **
write_char:        
ldi RS, 0b00100000        ; RS = high
rjmp write

write_cmd:     
clr RS                    ; RS = low

write:    
mov Temp, Data            ; copy Data
andi Data, 0b11110000     ; mask out high nibble
swap Data                 ; swap nibbles
or Data, RS               ; add register select
rcall write_nibble        ; send high nibble
mov Data, Temp            ; restore Data
andi Data, 0b00001111     ; mask out low nibble
or Data, RS               ; add register select

write_nibble:
rcall switch_output       ; Modify for display JHD202A, port E
nop                       ; wait 542nS
sbi PORTE, 5              ; enable high, JHD202A
nop
nop                       ; wait 542nS
cbi PORTE, 5              ; enable low, JHD202A
nop
nop                       ; wait 542nS
ret
; **
; ** busy_wait loop
; **
short_wait:    
clr zh                    ; approx 50 us
ldi zl, 30
rjmp wait_loop

long_wait:    
ldi zh, HIGH(1000)        ; approx 2 ms
ldi zh, LOW(1000)
rjmp wait_loop

dbnc_wait:    
ldi zh, HIGH(4600)        ; approx 10 ms
ldi zl, LOW(4600)
rjmp wait_loop

power_up_wait:
ldi zh, HIGH(9000)        ; approx 20 ms
ldi zl, LOW(9000)

wait_loop:    
sbiw z, 1                 ; 2 cycles
brne wait_loop            ; 2 cycles
ret
; **
; ** modify output signal to fit LCD JHD202A, connected to port E
; **
switch_output:
push Temp
clr Temp
sbrc Data, 0                ; D4 = 1?
ori Temp, 0b00000100            ; Set pin 2 
sbrc Data, 1                ; D5 = 1?
ori Temp, 0b00001000            ; Set pin 3 
sbrc Data, 2                ; D6 = 1?
ori Temp, 0b00000001            ; Set pin 0 
sbrc Data, 3                ; D7 = 1?
ori Temp, 0b00000010            ; Set pin 1 
sbrc Data, 4                ; E = 1?
ori Temp, 0b00100000            ; Set pin 5 
sbrc Data, 5                ; RS = 1?
ori Temp, 0b10000000            ; Set pin 7 (wrong in previous version)
out PORTE, Temp
pop Temp
ret

int_generateRandom:
lds Temp, PORTD
    
delay:
    ldi  r31, 130
    ldi  r30, 222
L1: dec  r30
    brne L1
    dec  r31
    brne L1
    nop

    lds r29, PORTD
    cp Temp, r29
    brne delay

    ldi tens_num, 0

increase_loop:
cpi small_num, 10
brge increase

rcall clr_display

ldi Data, LCD
or Data, tens_num
rcall write_char

ldi Data, LCD
or Data, small_num
rcall write_char

reti

increase:
subi small_num, 10
inc tens_num
rjmp increase_loop
