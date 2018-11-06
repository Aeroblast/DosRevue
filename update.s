cmp cutinCount,0
je noskill
jmp skill
noskill:

lea bx,karen;
mov si,4*2
cmp word ptr[bx+si],0;action count
je noaction
dec word ptr[bx+si]
jmp actioncountend
noaction:
mov si,1*2
and byte ptr[bx+si],255-1-8;running=false,attack=flase
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

test keybuf,08h;
jz skipkeyenter
;Key Enter start
mov si,2;LOW Byte flag
or byte ptr[bx+si],8;attack
mov si,4*2
mov word ptr[bx+si],2;action count
;Key Enter end
skipkeyenter:

mov cx,0;

mov bx,karen;the offset of meta
mov word ptr[bx],0;de active
lea bx,karen
mov si,2;flag
test byte ptr[bx+si],8h;attack
jnz isattack
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
jmp endisattack
isattack:

lea ax,rmeta5
mov karen,ax;attack
mov cx,3

;hit?
test byte ptr[bx+si],2h;face
jnz endisattack
mov si,2*2;x
cmp word ptr[bx+si],160;
jg onhit;x>160
jmp endisattack
onhit:
cmp mp,7;
jl noskill2
mov rmeta9,1
mov cutinCount,0
mov mp,0
mov bx,karen
mov [bx],word ptr 1
jmp skill
noskill2:

mov byte ptr mahiru+1,1
mov byte ptr mahiru,4
inc mp
endisattack:

mov bx,karen
mov word ptr[bx],1;enable

lea bx,karen
mov si,2
test byte ptr[bx+si],2h;face
jz faceright
mov bx,karen
add byte ptr[bx],2;mirror
neg cx;x offset
;bx : meta offset
faceright:
lea bx, karen
mov si,2*2;x
add word ptr[bx+si],cx;x + move
cmp word ptr[bx+si],0
jg noproblemleft
sub word ptr[bx+si],cx 
noproblemleft:

cmp word ptr[bx+si],180
jl noproblemright
sub word ptr[bx+si],cx 
noproblemright:


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


;mahiru part:
dec byte ptr mahiru+1;frame count
jnz mahiruend
cmp byte ptr mahiru,0;state?
je mahiruend
dec byte ptr mahiru;state count
jz mahiru0
mov byte ptr mahiru+1,2;not zero, still animated
test byte ptr mahiru,1;
jnz mahiruleft
jmp mahiruright
mahiru0:
mov rmeta6,1;
mov rmeta7,0
mov rmeta8,0
jmp mahiruend
mahiruleft:
mov rmeta6,0;
mov rmeta7,1
mov rmeta8,0
jmp mahiruend
mahiruright:
mov rmeta6,0;
mov rmeta7,0
mov rmeta8,1
mahiruend:

jmp skillend
skill:

mov si,word ptr cutinCount
and si,0ffh
lea bx,cutin
mov dh,0
mov dl,[bx+si]
cmp dl,0
je skillover
lea bx,rmeta9
mov si,3*2;
add [bx+si],dx;x
inc cutinCount
jmp skillend
skillover:
mov rmeta9+6,-300;x
mov cutinCount,0
mov flyCount,2
mov rmeta9,0
mov cx,0
jmp noskill2
skillend:

cmp flyCount,0
je nofly
lea bx,mahiruflyX
mov si,word ptr flyCount
and si,0ffh
mov ax,[bx+si]
cmp ax,0
je flyover

add mahiruX,ax

lea bx,mahiruflyY
mov si,word ptr flyCount
and si,0ffh
mov ax,[bx+si]

sub mahiruY,ax

mov ax,mahiruX
mov rmeta6+6,ax
mov rmeta7+6,ax
mov rmeta8+6,ax
mov ax,mahiruY
mov rmeta6+8,ax
mov rmeta7+8,ax
mov rmeta8+8,ax

inc flyCount
inc flyCount
jmp flyend
flyover:
jmp endgame
flyend:
nofly:
