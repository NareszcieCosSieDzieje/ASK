 $MOD842

 ORG 000h
  JMP init

 init:
  MOV TIMECON, #00000001B  ; wlacz licznik czasu
  MOV SEC, #0 ;tylko sekundy obczajamy
  MOV A, #0
  MOV B, #0 
  MOV R0, #0
  MOV R1, #0
  MOV R2, #0
  MOV R3, #0
  MOV R4, #0
  MOV R5, #0
  MOV R6, #0
  MOV R7, #0
JMP main

main:
 CALL logic2                                ; --- lub logic1 zaleznie od wyboru ---
 JB B.0, display_hrs ; miedzy przzejsciem z godzin na minuty dluzszy delay dac !!
 CALL display_min_to_sec
JMP main

;sekundy sie musialy wyzerowac do zmiany godziny wiec moge movem sprawdzac wartosci SEC
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
 

logic2: ;tic checked up to 10 secs
 MOV A,SEC 
 CJNE A,#5,check
 JMP details
 check:
 CJNE A,#10,l2_main 
 details:
 CPL B.0 ;SETB B.0   ; set bit for displaying hrs when changes occur to the hr value
 l2_main:
 CJNE A,#10, l2_0
 MOV SEC, #0 ; reset seconds
 MOV R0, #0
 CJNE R1,#5, l2_1
 MOV R1, #0
 CJNE R2,#9, l2_2
 MOV R2, #0
 CJNE R3,#5, l2_3
 MOV R3, #0
 CJNE R4,#4, l2_4
 MOV R4, #0
 CJNE R5,#2, l2_5
 MOV R4, #0
 l2_0:
  MOV R0,A
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
RET


delay: ;used for displaying numbers
 MOV R6, #8
 d0:
  MOV R7, #255
  DJNZ R7, $
  DJNZ R6, d0
RET


END