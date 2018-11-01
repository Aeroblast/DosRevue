DEBUG MACRO X
push dx
MOV DX,X
CALL LOGHEX
CALL ENDL
pop dx
mov ah,0;//wait for end
;int 16h;
ENDM

DATA SEGMENT
pathc0 DB "as\c0.ACT",0
pathki0  DB "as\ki0",0
pathki1  DB "as\ki1",0
pathkr0  DB "as\kr0",0
pathkr1  DB "as\kr1",0
pathb0 DB "as\back_c0",0
orgKeyProc DW ?,?
keybuf DB 0;ASDW Enter,Backspace,Esc,reserve
lasttime DB 0
deltatime DB 0
rmeta0 DW 2,0,0,0,0,160,100
rmeta1 DW 0,0,0,0,1,64,64
rmeta2 DW 0,0,0,64,1,64,64
rmeta3 DW 0,0,0,128,1,64,64
rmeta4 DW 0,0,0,192,1,64,64
rmeta5 DW 0,0,0,20,80,64,64
rmeta6 DW 0,0,0,20,80,64,64
;0mode(0:inactive 1:nomal,2:2x,3 mirror),1base(segment),2offset ,34position x&y,56original width&height

karen DW 0,0300h,20,80,0
;0:spirit,1:HIGH:anime count LOW:flags(0x1:running,0x2:face left, 0x4:anime id), 
;2:x,3:y,4:action count

DATA ENDS

SBUF SEGMENT

BUFS0 DB 4096 DUP(?)
BUFS1 DB 4096 DUP(?)
BUFS2 DB 4096 DUP(?)
BUFS3 DB 4096 DUP(?)
BUFB1 DB 16000 DUP(?)
SBUF ENDS

RENDERBUF SEGMENT
DB 64000 DUP(?)
RENDERBUF ENDS

STC SEGMENT STACK 
    DW 32 DUP(?)
STC ENDS

CODE SEGMENT 
 ASSUME CS:CODE,DS:DATA,SS:STC
 START: 
include startup.s;segment load, VGA settings, set interrupt

include level1.s

mov ax,DATA
mov ds,ax;segment


mainloop:
mov ah,0
;update

;game logic update
include update.s


;render
mov ax,RENDERBUF;
mov es,ax;
lea bx,rmeta0
call bitblt
lea bx,rmeta1
call bitblt
lea bx,rmeta2
call bitblt
lea bx,rmeta3
call bitblt
lea bx,rmeta4
call bitblt

test keybuf,02h
jnz endgame;
;clear
mov keybuf,0

;wait for 55ms sign and copy our buffer to video buffer
mov ax,40h
mov ds,ax
mov bx,6ch
mov ax,[bx]
timertick0:
cmp ax,[bx]
je timertick0

mov ax,0a000h;vga
mov es,ax;
mov ax,RENDERBUF;
mov ds,ax
mov cx,32000;
mov si,0
toscreen:
mov dx,ds:[si]
mov es:[si],dx
inc si
inc si
loop toscreen

mov ax,data;
mov ds,ax

jmp mainloop;




include END.s;wait for end, restore video mode

include btblt2.s;process, bx:meta offset, will not protect reg

include loadas.s;proc, dx:path,cx:size,bx:offset in buf,ax:buf segment, segment changed after excu

include LOGU16.s
include LOGHEX.s
include ENDL.s

include mints.s

CODE ENDS

END START