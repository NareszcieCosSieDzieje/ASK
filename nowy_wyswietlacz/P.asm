$MOD842

;--------------------------------------macros-------------------------------------------
;P EQU #01010000B
;A EQU #01000001B	
;W EQU #01010111B	
;E EQU #01000101B	
;L EQU #01001100B
;K EQU #01001011B
;R EQU #01010010B
;Y EQU #01011001B
;C EQU #01000011B
;Z EQU #01011010B
;K EQU #01001011B
;A
;EMPTY EQU #00101101B	

LCD_D4  EQU P2.1
LCD_D5  EQU P2.0
LCD_D6  EQU P2.3
LCD_D7  EQU P2.2
LCD_E   EQU P2.5
LCD_RW  EQU P2.4
LCD_RS  EQU P2.7
LCD_KEY EQU P2.6
LCD_PORT EQU P2

LCD_DATA EQU 30h

;-----------------------------------------prog------------------------------------------
ORG 0000h
JMP init

init:
 MOV R0,#10
 MOV R1,#30
 CALL LCD_INIT
 CALL DISPLAY_MSG
JMP main

main: 
 m0:
  CALL DISPLAY_SHIFT ; z 10 razy wolno 
  CALL LONG_DELAY
  DJNZ R0,m0
 m1:
  CALL DISPLAY_SHIFT  ; z 30 szybko
  CALL SHORT_DELAY
  DJNZ R1,m1
 MOV R0,#10
 MOV R1,#30
JMP main 


org 40h
LCD_INIT:
 MOV LCD_PORT, #00h

 MOV LCD_DATA, #33h	;pierwsze slowo dodatkowe 
 ACALL LCD_WRITE4	;przeslanie 4 pierwszych bitow
 ACALL DELAY
 ACALL LCD_WRITE4	;przeslanie 4 mlodszych bitow
 ACALL DELAY
	
 MOV LCD_DATA, #32h	;dodatkowe drugie slowo
 ACALL LCD_WRITE4
 ACALL DELAY
 ACALL LCD_WRITE4
 ACALL DELAY         ;acall to krotki skok
	
 MOV LCD_DATA, #28h	;czterobitowy interfejs (F)
 ACALL LCD_WRITE4
 ACALL LCD_WRITE4
 ACALL DELAY
	
 MOV LCD_DATA, #01h	;czyszczenie ekranu i kursor na 0 (A)
 ACALL LCD_WRITE4
 ACALL LCD_WRITE4
 ACALL DELAY
	
 MOV LCD_DATA, #0Eh	;wlaczenie ekranu i kursora mrugajacego	(D)
 ACALL LCD_WRITE4
 ACALL LCD_WRITE4
 ACALL DELAY
	
 MOV LCD_DATA, #06h	;czyszczenie ekranu, kusor na 0	(A)
 ACALL LCD_WRITE4
 ACALL LCD_WRITE4
 ACALL DELAY
	
LCD_WRITE4:
 PUSH ACC
 CLR LCD_E
 MOV A, LCD_DATA	; LCD_DATA = zawartosc P2
 RLC A
 MOV LCD_D7, C
 RLC A			; przenies uwzgl bit przeniesienia C
 MOV LCD_D6, C
 RLC A
 MOV LCD_D5, C
 RLC A 
 MOV LCD_D4, C
 SETB LCD_E	; zapis
 CLR LCD_E
 MOV LCD_DATA, A
 POP ACC
RET ;reti


DELAY: 
 PUSH LCD_PORT ;odczyt BG
 CLR LCD_RS
 SETB LCD_D7
 SETB LCD_RW 
 SETB LCD_E
 JB LCD_D7,$ ;oczekiwanie na zgloszenoe gotowosci	
 POP LCD_PORT
RET

LCD_DISPLAY_CHAR:
 SETB LCD_RS
 ACALL LCD_WRITE4
 ACALL LCD_WRITE4
 ACALL DELAY
RET

LCD_NEXT_LINE:
 MOV LCD_PORT,#00h
 MOV LCD_DATA,#0C0h ;next line
 ACALL LCD_WRITE4
 ACALL LCD_WRITE4
 ACALL DELAY
RET


DISPLAY_SHIFT:
 CLR LCD_RS
 CLR LCD_RW
 MOV LCD_DATA,#00011100B
 ACALL LCD_WRITE4
 ACALL LCD_WRITE4
 ACALL DELAY
RET

SHORT_DELAY:
 MOV R7,#255
 sd0:
 MOV R6,#10
 DJNZ R6,$
 DJNZ R7,sd0
RET

LONG_DELAY:
 MOV R7,#255
 l1:MOV R6,#255
  l0:MOV R5,#10
   DJNZ R5,$
   DJNZ R6,l0
 DJNZ R7,l1
RET

;kazda linia 40 znakow
DISPLAY_BLANKS:
	MOV LCD_DATA, #00101101B	 ;null
	CALL LCD_DISPLAY_CHAR
	MOV LCD_DATA, #42            ;star
	CALL LCD_DISPLAY_CHAR
RET

DISPLAY_MSG:
	;------------wpisywanie do ekranu
	SETB LCD_RS
	CLR LCD_RW
	;-----------------------------------PAWEL nie mam ł trzeba specjlana pamiec miec
	MOV LCD_DATA, #01010000B
	CALL LCD_DISPLAY_CHAR
	MOV LCD_DATA, #01000001B
	CALL LCD_DISPLAY_CHAR
	MOV LCD_DATA, #01010111B	
	CALL LCD_DISPLAY_CHAR
	MOV LCD_DATA, #01000101B	
	CALL LCD_DISPLAY_CHAR
	MOV LCD_DATA, #01001100B
	CALL LCD_DISPLAY_CHAR
	;----------------------------------------przerwy
	dm0:
	MOV R2,#17
	CALL DISPLAY_BLANKS
	DJNZ R2,dm0
	MOV LCD_DATA, #00101101B ;ostatnia pozycja blank
	CALL LCD_DISPLAY_CHAR
	;--------------------------------------nowa linia
		ACALL LCD_NEXT_LINE
		;---------------------------------------KRYCZKA
	MOV LCD_DATA, #01001011B	
	CALL LCD_DISPLAY_CHAR
	MOV LCD_DATA, #01010010B	
	CALL LCD_DISPLAY_CHAR
	MOV LCD_DATA, #01011001B
	CALL LCD_DISPLAY_CHAR	
	MOV LCD_DATA, #01000011B
	CALL LCD_DISPLAY_CHAR
	MOV LCD_DATA, #01011010B
	CALL LCD_DISPLAY_CHAR	
	MOV LCD_DATA, #01001011B
	CALL LCD_DISPLAY_CHAR
	MOV LCD_DATA, #01000001B
	CALL LCD_DISPLAY_CHAR
	;------------------------------------------przerwy 
	dm1:
	MOV R2,#16
	CALL DISPLAY_BLANKS
	DJNZ R2,dm1
	MOV LCD_DATA, #00101101B ;ostatnia pozycja blank
	CALL LCD_DISPLAY_CHAR
RET


END


	
