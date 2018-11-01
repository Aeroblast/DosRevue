;karen idle0
lea dx,pathki0;
mov cx,4096
lea bx,BUFS0
mov ax,SBUF
call loadas
lea ax,BUFS0
lea bx,rmeta1
mov si,4;
mov [bx+si],ax;
mov si,2
mov ax,SBUF
mov [bx+si],ax;buf seg
;karen idle1
lea dx,pathki1;
mov cx,4096
lea bx,BUFS1
mov ax,SBUF
call loadas
lea ax,BUFS1
lea bx,rmeta2
mov si,4;
mov [bx+si],ax;
mov si,2
mov ax,SBUF
mov [bx+si],ax;buf seg
;karen run 0
lea dx,pathkr0;
mov cx,4096
lea bx,BUFS2
mov ax,SBUF
call loadas
lea ax,BUFS2
lea bx,rmeta3
mov si,4;
mov [bx+si],ax;
mov si,2
mov ax,SBUF
mov [bx+si],ax;buf seg
;karen run 0
lea dx,pathkr1;
mov cx,4096
lea bx,BUFS3
mov ax,SBUF
call loadas
lea ax,BUFS3
lea bx,rmeta4
mov si,4;
mov [bx+si],ax;
mov si,2
mov ax,SBUF
mov [bx+si],ax;buf seg

;background
lea dx,pathb0;
mov cx,16000
lea bx,BUFB1
mov ax,SBUF
call loadas
lea ax,BUFB1
lea bx,rmeta0
mov si,4;
mov [bx+si],ax;
mov si,2
mov ax,SBUF
mov [bx+si],ax;buf seg

mov karen,offset rmeta1;