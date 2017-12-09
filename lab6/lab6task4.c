
#include <avr/io.h>
#include <stdio.h>
#include <util/delay.h>

#define F_CPU 1843200UL
#define FOSC 1843200 // Clock Speed
#define SPEED_BAUD 2400
#define UBRR_value 47
#define START 0x0D
#define END 0x0A
#define MessageLen(x)  (sizeof(x) / sizeof((x)[0]))

void uart_init (void) {
	UBRR1L=UBRR_value;
	UCSR1B=(1<<TXEN1) | (1<<RXEN1);
}

void uart_trans(unsigned char data) {
	while (!(UCSR1A & (1<<UDRE1)));
	UDR1 = data;
}

unsigned char uart_read(void) {
	while (!(UCSR1A & (1<<RXC1))) ;
	return UDR1;
}

int calculate_chksum(char define[], int define_size, char *message) {
	int sum = 0;
	for(int i = 0; i < define_size; i++) {
		sum += (int)define[i];
	}
	for(int i = 0; i < strlen(message); i++) {
		sum += (int)message[i];
	}
	return (sum+13)%256;        // '/r =13'
}

void display(char memory, char *message) {
	char towrite[] = {'A','O','0','0','0','1'};
	towrite[0] = memory;
	char checksum[2]; 
	int sum = calculate_chksum(towrite, MessageLen(towrite), message);
	sprintf(checksum,"%02X",sum); 
	
	display_this(towrite, MessageLen(towrite), message, checksum);
}

void stahp() {
	char exec[7] = {'Z','D','0','0','1','3','C'};
	uart_trans(START);
	for(int i = 0; i < MessageLen(exec); i++) {
		uart_trans(exec[i]);
	}
	uart_trans(END);
}

void display_this(char towrite[], int command_size, char *message, char checksum[]) {
	uart_trans(START);
	for(int i = 0; i < command_size; i++){
		uart_trans(towrite[i]);
	}
	for (int i = 0; i < strlen(message); i++ ){
		uart_trans(message[i]);
	}
	uart_trans(checksum[0]);
	uart_trans(checksum[1]);
	uart_trans(END );
	
}

void get_chars(char line, char *message, int index) {
	char input = uart_read();
	
	if (input == '>') {
		display(line, message);
		stahp();
		return;
	}
	else {
		message[index] = input;
		index++;
		
		get_chars(line, message, index);
	}
}

unsigned char get_address() {
	char input = uart_read();
}

int main(void) {
	uart_init();
	
	char *message;
	message = malloc(48 * sizeof(int));
	int index = 0;
	char line;
	
	while (1) {
		line = get_address();
		get_chars(line ,message, index);
	}
}