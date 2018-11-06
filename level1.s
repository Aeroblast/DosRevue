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
;karen run 1
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
;karen attack
lea dx,pathka0;
mov cx,4096
lea bx,BUFS7
mov ax,SBUF
call loadas
lea ax,BUFS7
lea bx,rmeta5
mov si,4;
mov [bx+si],ax;
mov si,2
mov ax,SBUF
mov [bx+si],ax;buf seg
;karen cutin
lea dx,pathkc0;
mov cx,64000
lea bx,BUFC0
mov ax,SBUF2
call loadas
lea ax,BUFC0
lea bx,rmeta9
mov si,4;
mov [bx+si],ax;
mov si,2
mov ax,SBUF2
mov [bx+si],ax;buf seg


;mahiru
lea dx,pathm0;
mov cx,4096
lea bx,BUFS4
mov ax,SBUF
call loadas
lea ax,BUFS4
lea bx,rmeta6
mov si,4;
mov [bx+si],ax;
mov si,2
mov ax,SBUF
mov [bx+si],ax;buf seg

;mahiru
lea dx,pathm1;
mov cx,4096
lea bx,BUFS5
mov ax,SBUF
call loadas
lea ax,BUFS5
lea bx,rmeta7
mov si,4;
mov [bx+si],ax;
mov si,2
mov ax,SBUF
mov [bx+si],ax;buf seg

;mahiru
lea dx,pathm2;
mov cx,4096
lea bx,BUFS6
mov ax,SBUF
call loadas
lea ax,BUFS6
lea bx,rmeta8
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