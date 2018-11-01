lea bx,karen;
mov si,4*2
cmp word ptr[bx+si],0;action count
je noaction
dec word ptr[bx+si]
jmp actioncountend
noaction:
mov si,1*2
and byte ptr[bx+si],255-1;running=false
actioncountend:


test keybuf,80h;
jz skipkeya
;Key A start
mov si,2;LOW Byte flag
or byte ptr[bx+si],2;face left
or byte ptr[bx+si],1;running
mov si,4*2
mov word ptr[bx+si],9;action count


;Key A end
skipkeya:
test keybuf,40h;
jz skipkeys
;Key S start


;Key S end
skipkeys:
test keybuf,20h;
jz skipkeyd
;Key D start
mov si,2;LOW Byte flag
and byte ptr[bx+si],255-2;no face left
or byte ptr[bx+si],1;running
mov si,4*2
mov word ptr[bx+si],9;action count


;Key D end
skipkeyd:
test keybuf,10h;
jz skipkeyw
;Key W start


;Key W end
skipkeyw:

mov cx,0;

mov bx,karen;the offset of meta
mov word ptr[bx],0;de active
lea bx,karen
mov si,2;flag
test byte ptr[bx+si],1h;running
jnz isrunning
lea ax,rmeta1
mov karen,ax;idle
jmp endisrunning
isrunning:
lea ax,rmeta3
mov karen,ax;run0
mov cx,3;x offset
endisrunning:
test byte ptr[bx+si],4h;anime frame
jz animeframe0;
add karen,14;next meta
animeframe0:

mov bx,karen
mov word ptr[bx],1;enable

lea bx,karen
test byte ptr[bx+si],2h;face
jz faceright
mov bx,karen
add byte ptr[bx],2;mirror
neg cx;x offset
;bx : meta offset
faceright:
lea bx, karen
mov si,2*2;x
add word ptr[bx+si],cx;x +offset
cmp word ptr[bx+si],0
jg noproblemleft
sub word ptr[bx+si],cx 
noproblemleft:

mov bx,karen
lea di,karen;
add di,4;
mov ax,[di];x
mov si,6
mov word ptr[bx+si],ax;x
add di,2
mov ax,[di];y
mov si,8
mov word ptr[bx+si],ax;y

dec byte ptr karen+3
jnz skipchange
mov byte ptr karen+3,3
xor byte ptr karen+2,4;anime frame
skipchange:



