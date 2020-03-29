#line 1 "C:/Users/Teo/Desktop/Proiect DE/Turatia motorului cu potentiometru.c"
sbit LCD_RS at PORTC0_bit;
sbit LCD_EN at PORTC1_bit;
sbit LCD_D4 at PORTC4_bit;
sbit LCD_D5 at PORTC5_bit;
sbit LCD_D6 at PORTC6_bit;
sbit LCD_D7 at PORTC7_bit;

sbit LCD_RS_Direction at DDC0_bit;
sbit LCD_EN_Direction at DDC2_bit;
sbit LCD_D4_Direction at DDC4_bit;
sbit LCD_D5_Direction at DDC5_bit;
sbit LCD_D6_Direction at DDC6_bit;
sbit LCD_D7_Direction at DDC7_bit;

void Init_adc(){
ADMUX = 0b01000000;
ADCSRA= 0b10000111;

}

int ms=0,ms2=0,n=0,m=0,h=0,adc_l,adc_h;
int pot=99;
char txt[4];
int caz=1;

int readADC (char ch){
ADMUX &= 0b11100000;
ADMUX |= ch;
ADCSRA |= (1<<6);
while (ADCSRA & (1<<6));
adc_l = ADCL;
adc_h = ADCH;
return (adc_h <<8|adc_l);
}


void init_timer()
{
 SREG = 1<<7;
 TCCR0 = 0b00001011;
 TCNT0 = 0;
 OCR0 = 125;
 TIMSK |= 0b00000010;
}

void Timer0_OC_ISR() iv IVT_ADDR_TIMER0_COMP {
if (ms==pot){
 if(caz==1) n++;
 else if(caz==2) n--;
 switch(n){
 case 1:{ PORTA = 0b00010000 ;
 PORTB = 0b00010000 ;
 pot=readADC(6)/4;
 if(caz==2) n=0;
 break;
 }
 case 2:{ PORTA = 0b00100000;
 PORTB = 0b00100000;
 pot=readADC(6)/4;
 break;
 }
 case 3:{ PORTA = 0b00001000;
 PORTB = 0b00001000;
 pot=readADC(6)/4;
 break;
 }
 case 4:{ PORTA = 0b10000000;
 PORTB = 0b10000000;
 pot=readADC(6)/4;
 if(caz==1) n=0;
 break;
 }
}
 ms=0;
 }
 else ms++;
}

void rotire()
{
 if(PINA & (1<<0)) caz++;
 switch(caz)
 {
 case 1:{Lcd_Out(1, 1, "Direction: Right");
 Lcd_Out(2, 1, "Speed:");
 break;}
 case 2:
 {
 Lcd_Out(1, 1, "Direction: Left");
 Lcd_Out(2, 1, "Speed:");
 caz=1;
 break;
 }
}
}

void main() {

 DDRC=0b11111111;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,7,"Good");
 Lcd_Out(2,6,"Evening!");
 Delay_ms(200);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,2,"I hope you will");
 Lcd_Out(2,4,"enjoy this!");
 Delay_ms(200);
 init_timer();
 Init_adc();
 SREG |= 1<<7;
 DDRA = 0b10111000;
 DDRB = 0b10111000;
 Lcd_Cmd(_LCD_CLEAR);
 for(;;)
 {
 rotire();
 IntToStr(100-(pot/2.5),txt);
 Lcd_Out(2,9,txt);
 }
 }
