ENDL PROC  
  push ax
  push dx
  mov dl,0ah;//LF
  MOV AH,02h;
  int 21h
  pop dx
  pop ax
  ret
ENDL ENDP