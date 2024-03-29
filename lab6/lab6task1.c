
#include<avr/io.h>
#include<stdio.h>
#include <stdlib.h>
//#define BAUD 2400
//#define UBRR_VAL 47

void uart_int(void);
void uart_trans(unsigned char data);

int main(void){
	uart_int();
	char towrite[50];
	char* temp ="\rAO0001R";
	int i;
	int checksum=0;
	for (i=0;i<8;i++){
		checksum+=temp[i];
	}
	
	checksum=checksum%256;
	
	sprintf(towrite,"%s%02X\n", temp, checksum);
	
	for(i=0;i<11;i++){
		uart_trans(towrite[i]);
	}
	
	temp ="\rZD0013C\n";
	
	for(i=0;i<9;i++){
		uart_trans(temp[i]);
	}
	
	return 0;
}

void uart_int(void){
	UBRR1L=25;
	UCSR1B =(1<<TXEN1) | (1<<RXEN1);
	
}
void uart_trans(unsigned char data){
	while(!(UCSR1A & (1<<UDRE1)));
	UDR1 = data;
}
