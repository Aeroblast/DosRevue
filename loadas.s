loadas proc;dx:path,cx:size,bx:offset onbuf,ax:buf segment
push bx
push ax
mov ah,3dh;open file
mov al,0;0:READ ONLY, 1:WRITE ONLY, 2:READ/WRITE.
;0-terminal string data segment offset
int 21h;
jnc opensucc0;
mov dx,ax;
call LOGU16;

opensucc0:
mov bx,ax;
;cx size to read
pop ax;
mov ds,ax;//segment
pop dx;offset
mov ah,3fh;read file 
int 21h;
mov ah,3eh;close file
int 21h;
mov ax,data
mov ds,ax

ret
loadas endp