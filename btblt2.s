bitblt proc ;bx:meta offset
;0:mode(0:inactive 1:nomal,2:2x,3 mirror),1:base(segment),2:offset ,3&4:position x&y,5&6 original width&height
mov ax,[bx];
cmp ax,0
jne bitbltconti
ret
bitbltconti:
 push ax;mode

mov si,4*2;
mov di,[bx+si];y temp
mov si,3*2;
mov bp,[bx+si];x temp

;we assert that there is no condition that y<0 && y+h(x2)>screenheight, same to x & width 

cmp di,0;y
jge bbcheckh;y>0
mov si,6*2
mov ax,[bx+si];h
mov dx,[bx];mode
cmp dx,2
jne bbskip0;
shl ax,1
bbskip0:
add ax,di;h(x2)+y, y is negative
 push ax;left lines
mov ax,0
sub ax,di;-y, positive
cmp dx,2
jne bbskip00;
shr ax,1;-y/2
bbskip00:
 push ax;src y cut
mov di,0;y temp
jmp bbskipcheckh

bbcheckh:
mov si,6*2
mov ax,[bx+si];src height
mov dx,[bx];mode
cmp dx,2
jne bitbltconti2;2x scale mode
shl ax,1;x2
bitbltconti2:
push ax;h(x2)
mov si,4*2
mov cx,[bx+si];y
add ax,cx;y+(2or1)*h
pop cx;h(x2)
sub ax,200;over height?
jl bbcheckhend;
sub cx,ax;left lines
bbcheckhend:
 push cx;dst left lines
mov cx,0
 push cx;src y cut
bbskipcheckh:

cmp bp,0;x
jge bbcheckw;x>0
mov si,5*2
mov ax,[bx+si];w
mov dx,[bx];mode
cmp dx,2
jne bbskip1;
shl ax,1
bbskip1:
add ax,bp;w(x2)+x, x is negative
 push ax;width
mov ax,0
sub ax,bp;-x, positive
cmp dx,2
jne bbskip10
shr ax,1;-x/2
bbskip10:
 push ax;src x cut
mov bp,0;x temp
jmp bbskipcheckw

bbcheckw:
mov si,5*2
mov ax,[bx+si];src w

mov dx,[bx];mode
cmp dx,2
jne bitbltconti3;2x scale mode
shl ax,1;x2
bitbltconti3:
push ax;w(x2)
mov si,3*2
mov cx,[bx+si];x
add ax,cx;x+(2or1)*w
sub ax,320;over width?
pop cx;w(x2)
jl bbcheckwend;
sub cx,ax;draw length
bbcheckwend:
 push cx;dst draw length
mov cx,0
 push cx;src x cut
bbskipcheckw:

mov ax,di;y temp
mov dx,320
mul dx;
add ax,bp;y*320+x,index of src (0,0)
 push ax;line start index

bbskip2:

mov si,5*2
mov ax,[bx+si];src w
 push ax
;cut: y*w+x
mov bp,sp;
add bp,4*2
mov dx,[bp];src cut y
mul dx;
sub bp,2*2
mov dx,[bp];src cut x
mov si,2*2;
mov cx,[bx+si];buf offset
add ax,dx;
add ax,cx
 push ax;src start index


mov si,1*2;
mov si,[bx+si];buf seg
mov ds,si
mov si,cx

;stack:
;0src index,1src width,2:vga line start index,3:src cut x,4:draw line length,
;5:src cut y,6:left lines,7:mode
mov bp,sp;
add bp,7*2
mov ax,[bp];mode
cmp ax,1;normal
je bitblt1
cmp ax,2;2x scale
je bitblt2pass

bitblt3:
mov bp,sp
add bp,2*2;line start index
mov di,[bp];
add bp,2*2;4:draw width
mov cx,[bp]
mov si,[bp]
mov bp,sp;
add si,[bp];src index+width
    bitblt30:
    mov al,ds:[si];
    cmp al,0ffh
    je bitblt3conti
    mov es:[di],al;
    bitblt3conti:
    dec si
    inc di
    loop bitblt30
mov ax,[bp];src index
add bp,1*2;src width
add ax,[bp]
mov bp,sp
mov [bp],ax;src index to next line
add bp,2*2;line start index
mov ax,320
add [bp],320;next line

add bp,4*2;left lines
dec WORD PTR SS:[bp];next lines
jnz bitblt3;





bitbltret:

mov ax,data
mov ds,ax
mov cx,8
bbpop:
pop ax
loop bbpop
ret
bitblt2pass:
jmp bitblt2

bitblt1:
mov bp,sp
add bp,2*2;line start index
mov di,[bp];
add bp,2*2;4:draw width
mov cx,[bp]
mov bp,sp;
mov si,[bp];src index
    bitblt10:
    mov al,ds:[si];
    cmp al,0ffh
    je bitblt1conti
    mov es:[di],al;
    bitblt1conti:
    inc si
    inc di
    loop bitblt10
mov ax,[bp];src index
add bp,1*2;src width
add ax,[bp]
mov bp,sp
mov [bp],ax;src index to next line
add bp,2*2;line start index
mov ax,320
add [bp],320;next line

add bp,4*2;left lines
dec WORD PTR SS:[bp];next lines
jnz bitblt1;
jmp bitbltret

bitblt2:
mov bp,sp
add bp,2*2;line start index
mov di,[bp];
add bp,2*2;4:draw width
mov cx,[bp]

mov bp,sp;
mov si,[bp];src index
    bitblt20:
    mov al,ds:[si];
    cmp al,0ffh
    je bitblt2conti
    mov es:[di],al;
    bitblt2conti:
    inc di
    test cx,1
    jz bb2secpix
    inc si
    bb2secpix:
    loop bitblt20

mov bp,sp
add bp,6*2;leftlines
mov ax,[bp]
test ax,1
jz bb2secline
mov bp,sp
mov ax,[bp];src index
add bp,1*2;src width
add ax,[bp]
mov bp,sp
mov [bp],ax;src index to next line
bb2secline:
mov bp,sp
add bp,2*2;line start index
mov ax,320
add [bp],320;next line
add bp,4*2;left lines
dec WORD PTR SS:[bp];next lines
jnz bitblt2;
jmp bitbltret

bitblt endp