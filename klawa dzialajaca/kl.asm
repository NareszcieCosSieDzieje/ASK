$MOD842
;f0 f1 flagz
w1 EQU P3.2
w2 EQU P3.3
k1 EQU P3.4
k2 EQU P3.5
k3 EQU P3.7
;k4 EQU P3.7
klaw EQU P3 

ORG 000h
JMP init

;wyswietlacz pamiec cg ram umiescic polskie znaki lcd

;ORG 003h 
;JMP button ;p3 odpowiada za przycisk tez takze rip przerwania sie robia caly czas

button:
 MOV R0,#10111111B
 MOV R1,#10111111B
 MOV R2,#10111111B
 MOV R3,#10111111B
 MOV R4,#0
RETI

init:
 ;MOV IE,#81h ;button
 MOV R0,#10111111B
 MOV R1,#10111111B
 MOV R2,#10111111B
 MOV R3,#10111111B
 MOV R4,#0
 MOV R5,#16 ; R5 nowy
 MOV R6,#0
 MOV R7,#0
 MOV A, #0
 MOV B, #0
 MOV P3,#11111111B
JMP main


main:
 m0:
 CALL display
 DJNZ R5,m0
 MOV R5,#16
 CALL logic
JMP main

logic:
MOV P3,#11111111B
w_1:
  CLR w1 
  JNB k1,w1k1 
  JNB k2,w1k2
  JNB k3,w1k3
  SETB w1
JMP w_2
 w1k1: MOV A,#1
       JMP w_1end
 w1k2: MOV A,#2
       JMP w_1end
 w1k3: MOV A,#3
       JMP w_1end
w_2:
  CLR w2
  JNB k1,w2k1
  JNB k2,w2k2
  JNB k3,w2k3
  SETB w2
RET
  w2k1: MOV A,#4
        JMP w_2end
  w2k2: MOV A,#5
        JMP w_2end
  w2k3: MOV A,#6
        JMP w_2end
w_1end: 
 SETB w1
 CALL logic_h ;logic_h tylko po zmianie
RET
w_2end:
 SETB w2
 CALL logic_h
RET

logic_h:
 CJNE R0,#10111111B,h0
 MOV R0,A
 MOV R4,#1
RET
 h0:CJNE R1,#10111111B,h1
 MOV B,R0 
 MOV R1,B
 MOV R0,A
 MOV R4,#2
RET
 h1:CJNE R2,#10111111B,h2
 MOV B,R1
 MOV R2,B
 MOV B,R0
 MOV R1,B
 MOV R0,A
 MOV R4,#3
RET
 h2: ;CJNE R3,#10111111B,h3
 MOV B,R2
 MOV R3,B
 MOV B,R1
 MOV R2,B
 MOV B,R0
 MOV R1,B
 MOV R0,A
 MOV R4,#4
RET

display:
 CJNE R4,#0,d0
 MOV P2,#10111111B
RET
 d0:
 CJNE R4,#1,d1
 MOV A,R0
 ADD A,#00000000B
 MOV P2,A
RET
 d1:
 CJNE R4,#2,d2
 MOV A,R0
 ADD A,#00000000B
 MOV P2,A
 CALL g_delay
 MOV A,R1
 ADD A,#00010000B
 MOV P2,A
RET
 d2:
 CJNE R4,#3,d3
 MOV A,R0
 ADD A,#00000000B
 MOV P2,A
 CALL g_delay
 MOV A,R1
 ADD A,#00010000B
 MOV P2,A
 CALL g_delay
 MOV A,R2
 ADD A,#00100000B
 MOV P2,A
RET
 d3:
 CJNE R4,#4,d4
 MOV A,R0
 ADD A,#00000000B
 MOV P2,A
 CALL g_delay
 MOV A,R1
 ADD A,#00010000B
 MOV P2,A
 CALL g_delay
 MOV A,R2
 ADD A,#00100000B
 MOV P2,A
 CALL g_delay
 MOV A,R3
 ADD A,#00110000B
 MOV P2,A
 CALL g_delay 
 d4:
RET

g_delay:
 MOV R7,#255
 g0:MOV R6,#4
 DJNZ R6,$
 DJNZ R7,g0
RET

s_delay:
 MOV R7,#100
 DJNZ R7,$
RET

l_delay:
 MOV R6,#100
 ld0:CALL s_delay
 DJNZ R6,ld0
RET 
 
END