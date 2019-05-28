 $MOD842

 ORG 000h
 JMP init

 ORG C0H
 JMP wd ;watchdog interrupt

 init:
  ;MOV A, #0
  MOV B, #0 
  MOV R0, #0
  MOV R1, #0
  MOV R2, #0
  MOV R3, #0
  MOV R4, #0
  MOV R5, #0
  MOV R6, #0
  MOV R7, #0
  CLR EA
  SETB WDWR
  MOV WDCON, # 01101010B ; tryb 1k mili sekund 4 bit od prawej to interrupt watchdoga nie wylaca go ea
  ;wlacz przerwania SETB EA/MOV IE,#83;
  ;inne rzeczy
 JMP main
 
main:
 JB B.0, display_hrs ; miedzy przzejsciem z godzin na minuty dluzszy delay dac !!
 CALL display_min_to_sec
JMP main

 wd:
 CJNE R0,#5,check
 JMP details
 check:
 CJNE R0,#10,l2_main 
 details:
 CPL B.0 ;SETB B.0   ; set bit for displaying hrs when changes occur to the hr value
 l2__main:
 CJNE R0,#9, l2_0
 MOV R0, #0
 CJNE R1,#5, l2_1
 MOV R1, #0
 CJNE R2,#9, l2_2
 MOV R2, #0
 CJNE R3,#5, l2_3
 MOV R3, #0
 CJNE R4,#3, l2_4
 MOV R4, #0
 CJNE R5,#2, l2_5
 MOV R4, #0
 l2_0:
  INC R0
  JMP l2_end
 l2_1:
  INC R1
  JMP l2_end
 l2_2:
  INC R2
  JMP l2_end
 l2_3:
  INC R3
  JMP l2_end
 l2_4:
  INC R4
  JMP l2_end
 l2_5:
  INC R5
  JMP l2_end
 l2_end: 
RETI


display_hrs:
  MOV A, R4
  ADD A, #01010000B ;ma kropke bo tak
  MOV P2, A
  CALL delay
  MOV A, R5
  ADD A, #00100000B
  MOV P2, A
  CALL delay  
 JMP main 

 display_min_to_sec:
 MOV A, R0
 ADD A, #00000000B
 MOV P2, A
 CALL delay
 MOV A, R1
 ADD A, #00010000B
 MOV P2, A
 CALL delay
 MOV A, R2
 ADD A, #01100000B
 MOV P2, A
 CALL delay
 MOV A, R3
 ADD A, #00110000B
 MOV P2, A
 CALL delay
RET

delay: 
 MOV R6, #8
 d0:
  MOV R7, #255
  DJNZ R7, $
  DJNZ R6, d0
RET





END