$MOD842
;f0 f1 bity flagi
w1 EQU P3.2
w2 EQU P3.3
k1 EQU P3.4
k2 EQU P3.5
k3 EQU P3.7
;k4 EQU P3.7
klaw EQU P3 

ORG 000h
JMP init

init:
 MOV R0,#0
 MOV R1,#0
 MOV R2,#0
 MOV R3,#0
 MOV R4,#0
 MOV R5,#0
 MOV R6,#0
 MOV R7,#0
 MOV A, #0
 MOV B, #0
 MOV P3,#11111111B
JMP main


main:
 CALL logic
 ;CALL s_delay ; moze dluzszy
 CALL display
 ;CALL l_delay
JMP main

;setb w1 w2
logic:
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
 CALL logic_h
RET
w_2end:
 SETB w2
 CALL logic_h
RET

logic_h:
 CJNE R0,#0,h0
 MOV R0,A
 RET
 h0:CJNE R1,#0,h1
 PUSH R0
 POP R1
 ;MOV R1,R0
 MOV R0,A
 RET
 h1:CJNE R2,#0,h2
 PUSH R1
 POP R2
 ;MOV R2,R1
 PUSH R0
 POP R1
 ;MOV R1,R0
 MOV R0,A
 RET
 h2:CJNE R3,#0,h3
 PUSH R2
 POP R3
 PUSH R1
 POP R2
 PUSH R0
 POP R1
 ;MOV R3,R2
 ;MOV R2,R1
 ;MOV R1,R0
 MOV R0,A
 RET
 h3:
 MOV R0,#0
 MOV R1,#0
 MOV R2,#0
 MOV R3,#0
RET


	  
display:
 MOV A,R0
 ADD A,#00010000B
 MOV P2,A
RET

s_delay:
 MOV R7,#255
 DJNZ R7,$
RET

l_delay:
 ld0: MOV R6,#100
      CALL s_delay
 DJNZ R6,ld0
RET 
 
 
END



