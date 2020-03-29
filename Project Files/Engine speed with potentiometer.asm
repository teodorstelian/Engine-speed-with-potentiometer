
_Init_adc:

;Turatia motorului cu potentiometru.c,15 :: 		void Init_adc(){
;Turatia motorului cu potentiometru.c,16 :: 		ADMUX = 0b01000000;
	LDI        R27, 64
	OUT        ADMUX+0, R27
;Turatia motorului cu potentiometru.c,17 :: 		ADCSRA= 0b10000111;
	LDI        R27, 135
	OUT        ADCSRA+0, R27
;Turatia motorului cu potentiometru.c,19 :: 		}
L_end_Init_adc:
	RET
; end of _Init_adc

_readADC:

;Turatia motorului cu potentiometru.c,26 :: 		int readADC (char ch){
;Turatia motorului cu potentiometru.c,27 :: 		ADMUX &= 0b11100000;
	IN         R16, ADMUX+0
	ANDI       R16, 224
	OUT        ADMUX+0, R16
;Turatia motorului cu potentiometru.c,28 :: 		ADMUX |= ch;
	OR         R16, R2
	OUT        ADMUX+0, R16
;Turatia motorului cu potentiometru.c,29 :: 		ADCSRA |= (1<<6);
	IN         R27, ADCSRA+0
	SBR        R27, 64
	OUT        ADCSRA+0, R27
;Turatia motorului cu potentiometru.c,30 :: 		while (ADCSRA & (1<<6));
L_readADC0:
	IN         R16, ADCSRA+0
	SBRS       R16, 6
	JMP        L_readADC1
	JMP        L_readADC0
L_readADC1:
;Turatia motorului cu potentiometru.c,31 :: 		adc_l = ADCL;
	IN         R16, ADCL+0
	STS        _adc_l+0, R16
	LDI        R27, 0
	STS        _adc_l+1, R27
;Turatia motorului cu potentiometru.c,32 :: 		adc_h = ADCH;
	IN         R16, ADCH+0
	STS        _adc_h+0, R16
	LDI        R27, 0
	STS        _adc_h+1, R27
;Turatia motorului cu potentiometru.c,33 :: 		return (adc_h <<8|adc_l);
	LDS        R16, _adc_h+0
	LDS        R17, _adc_h+1
	MOV        R19, R16
	CLR        R18
	LDS        R16, _adc_l+0
	LDS        R17, _adc_l+1
	OR         R16, R18
	OR         R17, R19
;Turatia motorului cu potentiometru.c,34 :: 		}
L_end_readADC:
	RET
; end of _readADC

_init_timer:

;Turatia motorului cu potentiometru.c,37 :: 		void init_timer()
;Turatia motorului cu potentiometru.c,39 :: 		SREG = 1<<7;                  //Global Interrupt Enable
	LDI        R27, 128
	OUT        SREG+0, R27
;Turatia motorului cu potentiometru.c,40 :: 		TCCR0 = 0b00001011;           //CTC(Clear Timer on Compare Match)-3,6
	LDI        R27, 11
	OUT        TCCR0+0, R27
;Turatia motorului cu potentiometru.c,41 :: 		TCNT0 = 0;                    //se reseteaza la 0 registrul de numarare
	LDI        R27, 0
	OUT        TCNT0+0, R27
;Turatia motorului cu potentiometru.c,42 :: 		OCR0 = 125;                   //valoarea la care se reseteaza TCNT0 la egalitatea dintre TCNT0 si OCR0
	LDI        R27, 125
	OUT        OCR0+0, R27
;Turatia motorului cu potentiometru.c,43 :: 		TIMSK |= 0b00000010;          //daca TCNT0=OCR0, se genereaza o intrerupere
	IN         R27, TIMSK+0
	SBR        R27, 2
	OUT        TIMSK+0, R27
;Turatia motorului cu potentiometru.c,44 :: 		}
L_end_init_timer:
	RET
; end of _init_timer

_Timer0_OC_ISR:
	PUSH       R30
	PUSH       R31
	PUSH       R27
	IN         R27, SREG+0
	PUSH       R27

;Turatia motorului cu potentiometru.c,46 :: 		void Timer0_OC_ISR() iv IVT_ADDR_TIMER0_COMP {
;Turatia motorului cu potentiometru.c,47 :: 		if (ms==pot){
	PUSH       R2
	LDS        R18, _ms+0
	LDS        R19, _ms+1
	LDS        R16, _pot+0
	LDS        R17, _pot+1
	CP         R18, R16
	CPC        R19, R17
	BREQ       L__Timer0_OC_ISR31
	JMP        L_Timer0_OC_ISR2
L__Timer0_OC_ISR31:
;Turatia motorului cu potentiometru.c,48 :: 		if(caz==1) n++;
	LDS        R16, _caz+0
	LDS        R17, _caz+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR32
	CPI        R16, 1
L__Timer0_OC_ISR32:
	BREQ       L__Timer0_OC_ISR33
	JMP        L_Timer0_OC_ISR3
L__Timer0_OC_ISR33:
	LDS        R16, _n+0
	LDS        R17, _n+1
	SUBI       R16, 255
	SBCI       R17, 255
	STS        _n+0, R16
	STS        _n+1, R17
	JMP        L_Timer0_OC_ISR4
L_Timer0_OC_ISR3:
;Turatia motorului cu potentiometru.c,49 :: 		else if(caz==2) n--;
	LDS        R16, _caz+0
	LDS        R17, _caz+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR34
	CPI        R16, 2
L__Timer0_OC_ISR34:
	BREQ       L__Timer0_OC_ISR35
	JMP        L_Timer0_OC_ISR5
L__Timer0_OC_ISR35:
	LDS        R16, _n+0
	LDS        R17, _n+1
	SUBI       R16, 1
	SBCI       R17, 0
	STS        _n+0, R16
	STS        _n+1, R17
L_Timer0_OC_ISR5:
L_Timer0_OC_ISR4:
;Turatia motorului cu potentiometru.c,50 :: 		switch(n){
	JMP        L_Timer0_OC_ISR6
;Turatia motorului cu potentiometru.c,51 :: 		case 1:{ PORTA = 0b00010000 ;
L_Timer0_OC_ISR8:
	LDI        R27, 16
	OUT        PORTA+0, R27
;Turatia motorului cu potentiometru.c,52 :: 		PORTB = 0b00010000 ;
	LDI        R27, 16
	OUT        PORTB+0, R27
;Turatia motorului cu potentiometru.c,53 :: 		pot=readADC(6)/4;
	LDI        R27, 6
	MOV        R2, R27
	CALL       _readADC+0
	ASR        R17
	ROR        R16
	ASR        R17
	ROR        R16
	STS        _pot+0, R16
	STS        _pot+1, R17
;Turatia motorului cu potentiometru.c,54 :: 		if(caz==2) n=0;
	LDS        R16, _caz+0
	LDS        R17, _caz+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR36
	CPI        R16, 2
L__Timer0_OC_ISR36:
	BREQ       L__Timer0_OC_ISR37
	JMP        L_Timer0_OC_ISR9
L__Timer0_OC_ISR37:
	LDI        R27, 0
	STS        _n+0, R27
	STS        _n+1, R27
L_Timer0_OC_ISR9:
;Turatia motorului cu potentiometru.c,55 :: 		break;
	JMP        L_Timer0_OC_ISR7
;Turatia motorului cu potentiometru.c,57 :: 		case 2:{ PORTA = 0b00100000;
L_Timer0_OC_ISR10:
	LDI        R27, 32
	OUT        PORTA+0, R27
;Turatia motorului cu potentiometru.c,58 :: 		PORTB = 0b00100000;
	LDI        R27, 32
	OUT        PORTB+0, R27
;Turatia motorului cu potentiometru.c,59 :: 		pot=readADC(6)/4;
	LDI        R27, 6
	MOV        R2, R27
	CALL       _readADC+0
	ASR        R17
	ROR        R16
	ASR        R17
	ROR        R16
	STS        _pot+0, R16
	STS        _pot+1, R17
;Turatia motorului cu potentiometru.c,60 :: 		break;
	JMP        L_Timer0_OC_ISR7
;Turatia motorului cu potentiometru.c,62 :: 		case 3:{ PORTA = 0b00001000;
L_Timer0_OC_ISR11:
	LDI        R27, 8
	OUT        PORTA+0, R27
;Turatia motorului cu potentiometru.c,63 :: 		PORTB = 0b00001000;
	LDI        R27, 8
	OUT        PORTB+0, R27
;Turatia motorului cu potentiometru.c,64 :: 		pot=readADC(6)/4;
	LDI        R27, 6
	MOV        R2, R27
	CALL       _readADC+0
	ASR        R17
	ROR        R16
	ASR        R17
	ROR        R16
	STS        _pot+0, R16
	STS        _pot+1, R17
;Turatia motorului cu potentiometru.c,65 :: 		break;
	JMP        L_Timer0_OC_ISR7
;Turatia motorului cu potentiometru.c,67 :: 		case 4:{ PORTA = 0b10000000;
L_Timer0_OC_ISR12:
	LDI        R27, 128
	OUT        PORTA+0, R27
;Turatia motorului cu potentiometru.c,68 :: 		PORTB = 0b10000000;
	LDI        R27, 128
	OUT        PORTB+0, R27
;Turatia motorului cu potentiometru.c,69 :: 		pot=readADC(6)/4;
	LDI        R27, 6
	MOV        R2, R27
	CALL       _readADC+0
	ASR        R17
	ROR        R16
	ASR        R17
	ROR        R16
	STS        _pot+0, R16
	STS        _pot+1, R17
;Turatia motorului cu potentiometru.c,70 :: 		if(caz==1) n=0;
	LDS        R16, _caz+0
	LDS        R17, _caz+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR38
	CPI        R16, 1
L__Timer0_OC_ISR38:
	BREQ       L__Timer0_OC_ISR39
	JMP        L_Timer0_OC_ISR13
L__Timer0_OC_ISR39:
	LDI        R27, 0
	STS        _n+0, R27
	STS        _n+1, R27
L_Timer0_OC_ISR13:
;Turatia motorului cu potentiometru.c,71 :: 		break;
	JMP        L_Timer0_OC_ISR7
;Turatia motorului cu potentiometru.c,73 :: 		}
L_Timer0_OC_ISR6:
	LDS        R16, _n+0
	LDS        R17, _n+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR40
	CPI        R16, 1
L__Timer0_OC_ISR40:
	BRNE       L__Timer0_OC_ISR41
	JMP        L_Timer0_OC_ISR8
L__Timer0_OC_ISR41:
	LDS        R16, _n+0
	LDS        R17, _n+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR42
	CPI        R16, 2
L__Timer0_OC_ISR42:
	BRNE       L__Timer0_OC_ISR43
	JMP        L_Timer0_OC_ISR10
L__Timer0_OC_ISR43:
	LDS        R16, _n+0
	LDS        R17, _n+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR44
	CPI        R16, 3
L__Timer0_OC_ISR44:
	BRNE       L__Timer0_OC_ISR45
	JMP        L_Timer0_OC_ISR11
L__Timer0_OC_ISR45:
	LDS        R16, _n+0
	LDS        R17, _n+1
	CPI        R17, 0
	BRNE       L__Timer0_OC_ISR46
	CPI        R16, 4
L__Timer0_OC_ISR46:
	BRNE       L__Timer0_OC_ISR47
	JMP        L_Timer0_OC_ISR12
L__Timer0_OC_ISR47:
L_Timer0_OC_ISR7:
;Turatia motorului cu potentiometru.c,74 :: 		ms=0;
	LDI        R27, 0
	STS        _ms+0, R27
	STS        _ms+1, R27
;Turatia motorului cu potentiometru.c,75 :: 		}
	JMP        L_Timer0_OC_ISR14
L_Timer0_OC_ISR2:
;Turatia motorului cu potentiometru.c,76 :: 		else ms++;
	LDS        R16, _ms+0
	LDS        R17, _ms+1
	SUBI       R16, 255
	SBCI       R17, 255
	STS        _ms+0, R16
	STS        _ms+1, R17
L_Timer0_OC_ISR14:
;Turatia motorului cu potentiometru.c,77 :: 		}
L_end_Timer0_OC_ISR:
	POP        R2
	POP        R27
	OUT        SREG+0, R27
	POP        R27
	POP        R31
	POP        R30
	RETI
; end of _Timer0_OC_ISR

_rotire:

;Turatia motorului cu potentiometru.c,79 :: 		void rotire()
;Turatia motorului cu potentiometru.c,81 :: 		if(PINA & (1<<0)) caz++;
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	IN         R16, PINA+0
	SBRS       R16, 0
	JMP        L_rotire15
	LDS        R16, _caz+0
	LDS        R17, _caz+1
	SUBI       R16, 255
	SBCI       R17, 255
	STS        _caz+0, R16
	STS        _caz+1, R17
L_rotire15:
;Turatia motorului cu potentiometru.c,82 :: 		switch(caz)
	JMP        L_rotire16
;Turatia motorului cu potentiometru.c,84 :: 		case 1:{Lcd_Out(1, 1, "Direction: Right");            // Write message text on LCD
L_rotire18:
	LDI        R27, #lo_addr(?lstr1_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr1_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Turatia motorului cu potentiometru.c,85 :: 		Lcd_Out(2, 1, "Speed:");
	LDI        R27, #lo_addr(?lstr2_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr2_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 2
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Turatia motorului cu potentiometru.c,86 :: 		break;}
	JMP        L_rotire17
;Turatia motorului cu potentiometru.c,87 :: 		case 2:
L_rotire19:
;Turatia motorului cu potentiometru.c,89 :: 		Lcd_Out(1, 1, "Direction: Left");            // Write message text on LCD
	LDI        R27, #lo_addr(?lstr3_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr3_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Turatia motorului cu potentiometru.c,90 :: 		Lcd_Out(2, 1, "Speed:");
	LDI        R27, #lo_addr(?lstr4_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr4_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 2
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Turatia motorului cu potentiometru.c,91 :: 		caz=1;
	LDI        R27, 1
	STS        _caz+0, R27
	LDI        R27, 0
	STS        _caz+1, R27
;Turatia motorului cu potentiometru.c,92 :: 		break;
	JMP        L_rotire17
;Turatia motorului cu potentiometru.c,94 :: 		}
L_rotire16:
	LDS        R16, _caz+0
	LDS        R17, _caz+1
	CPI        R17, 0
	BRNE       L__rotire49
	CPI        R16, 1
L__rotire49:
	BRNE       L__rotire50
	JMP        L_rotire18
L__rotire50:
	LDS        R16, _caz+0
	LDS        R17, _caz+1
	CPI        R17, 0
	BRNE       L__rotire51
	CPI        R16, 2
L__rotire51:
	BRNE       L__rotire52
	JMP        L_rotire19
L__rotire52:
L_rotire17:
;Turatia motorului cu potentiometru.c,95 :: 		}
L_end_rotire:
	POP        R5
	POP        R4
	POP        R3
	POP        R2
	RET
; end of _rotire

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27

;Turatia motorului cu potentiometru.c,97 :: 		void main()  {
;Turatia motorului cu potentiometru.c,99 :: 		DDRC=0b11111111;
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	LDI        R27, 255
	OUT        DDRC+0, R27
;Turatia motorului cu potentiometru.c,100 :: 		Lcd_Init();                              // Initialize LCD
	CALL       _Lcd_Init+0
;Turatia motorului cu potentiometru.c,101 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;Turatia motorului cu potentiometru.c,102 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                // Cursor off
	LDI        R27, 12
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;Turatia motorului cu potentiometru.c,103 :: 		Lcd_Out(1,7,"Good");
	LDI        R27, #lo_addr(?lstr5_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr5_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R5, R27
	LDI        R27, 7
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Turatia motorului cu potentiometru.c,104 :: 		Lcd_Out(2,6,"Evening!");
	LDI        R27, #lo_addr(?lstr6_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr6_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R5, R27
	LDI        R27, 6
	MOV        R3, R27
	LDI        R27, 2
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Turatia motorului cu potentiometru.c,105 :: 		Delay_ms(200);
	LDI        R18, lo_addr(R9)
	LDI        R17, lo_addr(R30)
	LDI        R16, 229
L_main20:
	DEC        R16
	BRNE       L_main20
	DEC        R17
	BRNE       L_main20
	DEC        R18
	BRNE       L_main20
	NOP
;Turatia motorului cu potentiometru.c,106 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;Turatia motorului cu potentiometru.c,107 :: 		Lcd_Out(1,2,"I hope you will");
	LDI        R27, #lo_addr(?lstr7_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr7_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R5, R27
	LDI        R27, 2
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Turatia motorului cu potentiometru.c,108 :: 		Lcd_Out(2,4,"enjoy this!");
	LDI        R27, #lo_addr(?lstr8_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr8_Turatia_32motorului_32cu_32potentiometru+0)
	MOV        R5, R27
	LDI        R27, 4
	MOV        R3, R27
	LDI        R27, 2
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Turatia motorului cu potentiometru.c,109 :: 		Delay_ms(200);
	LDI        R18, lo_addr(R9)
	LDI        R17, lo_addr(R30)
	LDI        R16, 229
L_main22:
	DEC        R16
	BRNE       L_main22
	DEC        R17
	BRNE       L_main22
	DEC        R18
	BRNE       L_main22
	NOP
;Turatia motorului cu potentiometru.c,110 :: 		init_timer();
	CALL       _init_timer+0
;Turatia motorului cu potentiometru.c,111 :: 		Init_adc();
	CALL       _Init_adc+0
;Turatia motorului cu potentiometru.c,112 :: 		SREG |= 1<<7;
	IN         R27, SREG+0
	SBR        R27, 128
	OUT        SREG+0, R27
;Turatia motorului cu potentiometru.c,113 :: 		DDRA = 0b10111000;
	LDI        R27, 184
	OUT        DDRA+0, R27
;Turatia motorului cu potentiometru.c,114 :: 		DDRB = 0b10111000;  //Set last 4 as output and first 4 pins as input
	LDI        R27, 184
	OUT        DDRB+0, R27
;Turatia motorului cu potentiometru.c,115 :: 		Lcd_Cmd(_LCD_CLEAR);
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;Turatia motorului cu potentiometru.c,116 :: 		for(;;)
L_main24:
;Turatia motorului cu potentiometru.c,118 :: 		rotire();
	CALL       _rotire+0
;Turatia motorului cu potentiometru.c,119 :: 		IntToStr(100-(pot/2.5),txt);
	LDS        R16, _pot+0
	LDS        R17, _pot+1
	LDI        R18, 0
	SBRC       R17, 7
	LDI        R18, 255
	MOV        R19, R18
	CALL       _float_slong2fp+0
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 32
	LDI        R23, 64
	CALL       _float_fpdiv1+0
	MOVW       R20, R16
	MOVW       R22, R18
	LDI        R16, 0
	LDI        R17, 0
	LDI        R18, 200
	LDI        R19, 66
	CALL       _float_fpsub1+0
	CALL       _float_fpint+0
	LDI        R27, #lo_addr(_txt+0)
	MOV        R4, R27
	LDI        R27, hi_addr(_txt+0)
	MOV        R5, R27
	MOVW       R2, R16
	CALL       _IntToStr+0
;Turatia motorului cu potentiometru.c,120 :: 		Lcd_Out(2,9,txt);
	LDI        R27, #lo_addr(_txt+0)
	MOV        R4, R27
	LDI        R27, hi_addr(_txt+0)
	MOV        R5, R27
	LDI        R27, 9
	MOV        R3, R27
	LDI        R27, 2
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Turatia motorului cu potentiometru.c,121 :: 		}
	JMP        L_main24
;Turatia motorului cu potentiometru.c,122 :: 		}
L_end_main:
	JMP        L_end_main
; end of _main
