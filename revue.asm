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
pathka0  DB "as\ka0",0
pathkc0 DB "as\cutin",0
pathm0  DB "as\mahiru0",0
pathm1  DB "as\mahiru1",0
pathm2  DB "as\mahiru2",0
pathb0 DB "as\back_c0",0
orgKeyProc DW ?,?
keybuf DB 0;ASDW Enter,Backspace,Esc,reserve
lasttime DB 0
deltatime DB 0
metaCount DW 10
;14
rmeta0 DW 2,0,0,0,0,160,100;bg
rmeta1 DW 0,0,0,0,1,64,64;idle
rmeta2 DW 0,0,0,64,1,64,64;idle
rmeta3 DW 0,0,0,128,1,64,64;run
rmeta4 DW 0,0,0,192,1,64,64;run
rmeta5 DW 0,0,0,192,1,64,64;attack
rmeta6 DW 0,0,0,200,80,64,64;mahiru
rmeta7 DW 0,0,0,200,80,64,64;mahiru
rmeta8 DW 0,0,0,200,80,64,64;mahiru
rmeta9 DW 0,0,0,-300,0,320,200;cutin

;0mode(0:inactive 1:nomal,2:2x,3 mirror),1base(segment),2offset ,34position x&y,56original width&height

karen DW 0,0300h,20,80,0
;0:spirit,
;1:HIGH:anime count LOW:flags(0x1:running,0x2:face left, 0x4:anime id,0x8 attacking), 
;2:x,3:y,4:action count
mp DB 0
cutinCount DB 0
cutin DB 40,40,40,40,40,40,30,20,20,10,10,20,20,30,40,40,40,0
mahiru DB 8,2
;0:state count
;1:anime count
mahiruX DW 200
mahiruY DW 80
flyCount DB 0
mahiruflyX DW 12,12,12,12,12,12,12,12,12,12,0
mahiruflyY DW 15,10,5,1,-1,-5,-10,-15,5,1,-5,0

;888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	DATAPORT	DW	330H
	STATPORT	DW	331H
	ICOUNT		DB 	2
	OLD0A 		DW	0, 0
	POS			DW	0
	SCORE		DB	3CH,'m',3EH,'m',40H,'m',41H,'m',43H,'m',43H,'m',43H,41H,40H,'m',
				DB 	41H,'m',41H,'m',41H,40H,3EH,'m',3CH,'m',40H,'m',43H,'m','m','m',
				DB	3CH,'m',3EH,'m',40H,'m',41H,'m',43H,'m',43H,'m',43H,41H,40H,'m',
				DB 	41H,'m',41H,'m',41H,40H,3EH,'m',3CH,'m',40H,'m',3CH,'m','m','m','n'
	SCORE2		DB	48h,'m',47h,'m',48h,'m',4ch,'m',47h,'m','m','m','m','m','m','m',
				db	45h,'m',43h,'m',45h,'m',48h,'m',43h,'m','m','m','m','m','m','m',
				db	41h,'m',40h,'m',41h,'m',48h,'m',47h,'m','m','m',43h,'m','m','m',
				db	45h,'m',47h,'m',48h,'m',4ch,'m',4ah,'m','m','m','m','m','m','m',
				db 	48h,'m',47h,'m',48h,'m',4ch,'m',47h,'m','m','m',43h,'m','m','m',
				db	45h,'m',47h,'m',48h,'m',4ah,'m',4ch,'m','m','m',4ch,'m','m','m',
				db	4dh,'m',4ch,'m',4ah,'m',48h,'m',47h,'m',4ch,'m',44h,'m',47h,'m',
				db	45h,'m','m','m','m','m','m','m','m','m','m','m',45h,47h,48h,4ah,
				db	4ch,'m','m','m','m','m','m','m','m','m','m','m','n'
;0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

DATA ENDS

SBUF SEGMENT

BUFS0 DB 4096 DUP(?);karen
BUFS1 DB 4096 DUP(?);karen
BUFS2 DB 4096 DUP(?);karen
BUFS3 DB 4096 DUP(?);karen
BUFS4 DB 4096 DUP(?);mahiru
BUFS5 DB 4096 DUP(?);mahiru
BUFS6 DB 4096 DUP(?);mahiru
BUFS7 DB 4096 DUP(?);karen
BUFB1 DB 16000 DUP(?)
SBUF ENDS

SBUF2 SEGMENT
BUFC0 DB 64000 DUP(?);cutin
SBUF2 ENDS

RENDERBUF SEGMENT
DB 64000 DUP(?)
RENDERBUF ENDS

STC SEGMENT STACK 
    DW 32 DUP(?)
STC ENDS

CODE SEGMENT 
 ASSUME CS:CODE,DS:DATA,SS:STC
 
;88888888888888888888888888888888888888888888888888888888888888888888888888888888
	jmp START
	;*****定义一个宏***** 		显示字符
	SHOW MACRO b
		MOV DL,b
		MOV AH,2
		INT 21H
	ENDM
	
	KEYDOWN2 MACRO NEXT, KEYWORD, MIDI
		CMP AL, KEYWORD	
		JNZ NEXT
		MOV BL, MIDI
		PUSH BL
		CALL PRESS
	ENDM
	
	PRESS PROC NEAR
		POP BL
		SHOW BL
		MOV BH, BL
		POP BL
		MOV AL, 00H
		CALL PUT_MPU_OUT
		MOV AL, 96H
		CALL PUT_MPU_OUT
		MOV AL, BL
		CALL PUT_MPU_OUT
		MOV AL, 00H
		CALL PUT_MPU_OUT
		
		PUSH BH
		MOV AL, 00H
		CALL PUT_MPU_OUT
		MOV AL, 96H
		CALL PUT_MPU_OUT
		MOV AL, BH
		CALL PUT_MPU_OUT
		MOV AL, 64H
		CALL PUT_MPU_OUT
		RET
	PRESS ENDP
	
	IS_INPUT PROC NEAR
		MOV DX, STATPORT
		IN AL,DX
		AND AL, 80H
		RET
	IS_INPUT ENDP
	
	GET_MPU_IN PROC NEAR
		MOV DX, DATAPORT
		IN AL, DX
		RET
	GET_MPU_IN ENDP
	
	IS_OUTPUT PROC NEAR
		MOV DX, STATPORT
		IN AL, DX
		AND AL, 40H
		RET
	IS_OUTPUT ENDP
	
	PUT_MPU_OUT PROC NEAR
		MOV DX, DATAPORT
		OUT DX,AL
		RET
	PUT_MPU_OUT ENDP
	
	SET_UART PROC NEAR
		SR1:
			CALL IS_OUTPUT
			JNZ SHORT SR1
			
		MOV AL, 0FFH;
		OUT DX, AL;
		
		AGAIN:
			CALL IS_INPUT
			JNZ SHORT AGAIN
			
		CALL GET_MPU_IN
		CMP AL, 0FEH
		JNE SHORT AGAIN
		SR3:
			CALL IS_OUTPUT
			JNZ SHORT SR3
			
		MOV AL, 03FH
		OUT DX, AL
		RET
	SET_UART ENDP	
	
	READ0A PROC
		MOV AX,351CH
		INT 21H
		MOV WORD PTR OLD0A,BX
		MOV WORD PTR OLD0A+2,ES
		RET
	READ0A ENDP
	
	; WRITE0A PROC
		; MOV AX,CODE
		; MOV DS,AX
		; MOV DX,OFFSET SERVICE
		; MOV AX,251CH
		; INT 21H
		; RET
	; WRITE0A ENDP
	
	RESET PROC
		MOV DX,WORD PTR OLD0A
		MOV DS,WORD PTR OLD0A+2
		MOV AX,251CH
		INT 21H
		RET
	RESET ENDP
	
	; SERVICE PROC
		; MOV AX,DATA
		; MOV DS,AX
		; DEC ICOUNT
		; JNZ EXIT
			; ;do something
			; MOV SI,0
			; MOV SI,POS
			; MOV BL,[SCORE+SI]
			; CMP BL,'m'
			; JZ NORMAL
			; CMP BL,'n'
			; JZ RESET0A
			
			; MOV BL,[SCORE+SI]
			; PUSH BL
			; CALL PRESS
		; NORMAL:
			; INC POS
			; MOV ICOUNT,3
			; JMP EXIT
		; RESET0A:
			; MOV AX,0
			; MOV POS,AX
			; MOV ICOUNT,3
			; JMP EXIT
		; NOTHI:
			
		; EXIT: 
			
			; IRET
	; SERVICE ENDP
;000000000000000000000000000000000000000000000000000000000000000000000000000000000
	
 START: 
include startup.s;segment load, VGA settings, set interrupt

include level1.s

mov ax,DATA
mov ds,ax;segment

;888888888888888888888888888888888888888888888888888
		; pushf
		; push ax
		; push dx
		
		CALL SET_UART
		THAT:
		CALL IS_OUTPUT
		JNZ SHORT THAT
		
		; CALL READ0A
		; MOV AX,0
		; MOV POS,AX
		; CALL READ0A
		
		; CALL WRITE0A
		
		; pop dx
		; pop ax;
		; popf
		
;0000000000000000000000000000000000000000000000000

mainloop:
mov ah,0
;update

;game logic update
include update.s


;render
mov ax,RENDERBUF;
mov es,ax;
mov cx,metaCount;
lea bx,rmeta0
renderLoop:
push cx
push bx
call bitblt
pop bx
pop cx
add bx,14
loop renderLoop


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

		MOV AX,DATA
		MOV DS,AX
		DEC ICOUNT
		JNZ EXIT
			;do something
			MOV SI,0
			MOV SI,POS
			MOV BL,[SCORE+SI]
			CMP BL,'m'
			JZ NORMAL
			CMP BL,'n'
			JZ RESET0A
			
			MOV BL,[SCORE+SI]
			PUSH BL
			CALL PRESS
		NORMAL:
			INC POS
			MOV ICOUNT,3
			JMP EXIT
		RESET0A:
			MOV AX,0
			MOV POS,AX
			MOV ICOUNT,3
			JMP EXIT
		NOTHI:
			
		EXIT: 

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