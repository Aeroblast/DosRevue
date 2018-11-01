endgame:

mov ax,data;
mov ds,ax;//data segment 
mov dx,orgKeyProc
mov cx,orgKeyProc+2
cli
mov ax,0
mov ds,ax
mov bx,36;9*4
mov [bx],dx;
mov bx,38;9*4+2
mov [bx],cx;restore the default keyboard porcess
sti





mov ah,0;//wait for end
int 16h;
mov ax,0003h;
int 10h;
mov ah,4ch;//return to dos
int 21h;