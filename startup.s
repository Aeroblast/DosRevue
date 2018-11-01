mov ax,0a000h;
mov es,ax;//VGA Buffer

mov ax,0
mov ds,ax
    cli

mov bx,36;9*4 IRQ9 keyboard
lea ax,keyboardHandler
mov dx,[bx];
mov [bx],ax
mov bx,38;9*4+2
mov cx,[bx]
mov [bx], cs
    sti

mov ax,data;
mov ds,ax;//data segment 

mov orgKeyProc,dx
mov orgKeyProc+2,cx
mov ax,0013h;
int 10h;//VGA

lea dx,pathc0;
mov cx,768
lea bx,BUFS0
mov ax,SBUF
call loadas


mov ax,SBUF;
mov ds,ax
mov dx,03c8h;vga palette
lea si,BUFS0
mov al,0
out dx,al;
mov cx,768
inc dx
loop0:
mov al,[si]
shr al,1
shr al,1
out dx,al
inc si
loop loop0

mov ax,data
mov ds,ax;

mov ah,2ch;time
int 21h
mov lasttime,dl;