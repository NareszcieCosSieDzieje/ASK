$MOD842

ORG 000h
JMP init

ORG 03h
JMP wd


init:
  CLR EA
  SETB WDWR
  MOV IE,#81h
  MOV A,#0
  MOV R0, #0
  MOV R1, #0
  MOV R2, #0
  MOV R3, #0
  MOV R4, #0
  MOV R5, #0
  MOV R6, #0
  MOV R7, #0
  MOV TIMECON, #000100001B
JMP main



main:
 CALL logic
 CALL display_sec 
JMP main

wd:
 CLR EA
 SETB WDWR
 MOV WDCON, #01110010B
 SETB EA
 CALL delay
 CALL delay
RETI


logic:
 MOV A, SEC
 CJNE A, #10, l_0
 MOV SEC, #0
 CJNE R1,#9,l_1
 MOV R0, #0
 MOV R1, #0
l_0:  
 MOV R0, SEC
 RET
l_1:
 INC R1
RET

display_sec:
 MOV A,R0
 ADD A, #00000000B  
 MOV P2, A
 CALL delay
 MOV A,R1
 ADD A, #00010000B  
 MOV P2, A
 CALL delay
RET
 
delay:
 MOV R6, #8
d0:
 DJNZ R7, $
 DJNZ R6, d0
RET

END