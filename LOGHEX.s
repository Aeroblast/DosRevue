 LOGHEX PROC
  mov bx,dx;
  MOV CL,16;

  MOV DL,'0';//0x
  MOV AH,02h
  int 21h
  MOV DL,'x';
  MOV AH,02h
  int 21h;//0x END

  LOGHEX0:
  SUB CL,4;
  pushf;

  MOV DX,BX;//GET NUMBER 
  SHR DX,CL;
  AND DL,0fh;//GET NUMBER END
  
  CMP DL,9;//TO CHAR 
  JA LOGHEX1
  ADD DL,'0';
  JMP LOGHEX2;
LOGHEX1:
  ADD DL,'A'-10;
LOGHEX2:
  MOV AH,02h;//OUT
  int 21h

  popf
  jnz LOGHEX0;

  RET
 LOGHEX ENDP