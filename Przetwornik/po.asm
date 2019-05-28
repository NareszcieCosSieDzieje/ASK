$MOD842

ORG 000h
JMP init

ORG 033h
JMP val
JMP main

init:
MOV B,#10
MOV A,#0
MOV R0,#0
MOV R1,#0
MOV R2,#0
MOV R3,#0
MOV R4,#0
MOV R5,#0
MOV R6,#0
MOV R7,#0
;MOV IE, #11000000B
;SETB T2CON.2
SETB TR2
SETB EA
SETB EADC
MOV ADCCON1, #10000010B
JMP main

val:
MOV A, ADCDATAH
RL A
RL A
RL A
RL A
ANL A, #11110000B
MOV R1, A
MOV A, ADCDATAL
RR A
RR A
RR A
RR A
ANL A, #00001111B
ADD A,R1
MOV R0, A
MOV B,#10
DIV AB
MOV R2,B
MOV B,#10
DIV AB
MOV R3,B
MOV R4,A
RETI

main:
CALL display
JMP main


display:
 MOV A, R2
 ADD A, #00000000B
 MOV P2, A
 CALL delay
 MOV A, R3
 ADD A, #00010000B
 MOV P2, A
 CALL delay
 MOV A, R4
 ADD A, #00100000B
 MOV P2, A
 CALL delay
RET

delay:
  MOV R6,#255
  d_0: MOV R7,#10
  DJNZ R7,$
  DJNZ R6, d_0
RET



END