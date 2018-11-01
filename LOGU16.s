 LOGU16 PROC
    push ax
    push bx
    push cx
    push dx;
    push si;

  mov si,10000;
  mov cx,1;
  mov ax,dx;

lu16loop0:
  mov dx,0;

  div si;

  push dx;//var A
  mov dl,al;
jcxz lu16skip0;//0 for already printing
  cmp dl,0;
jz lu16skip1;
  mov cx,0;
lu16skip0:
  add dl,30h;
  mov ah,2;
  int 21h;
lu16skip1:
  mov ax,si;
  mov dx,0;
  mov bx,10;
  div bx;
  cmp ax,1;
je lu16break0;
  mov si,ax;
  pop ax;  //var A
jmp lu16loop0;

lu16break0:
  pop dx;
  add dl,30h;
  mov ah,2;
  int 21h;

pop si;
pop dx;
pop cx;
pop bx;
pop ax;
  RET
 LOGU16 ENDP