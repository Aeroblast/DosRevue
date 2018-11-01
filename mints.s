keyboardHandler:
; save our registers!
pushf
push ax
push dx
mov ax,ds
push ax
mov ax,DATA
mov ds,ax
; Read code
in al, 60h


test al, 80h;is keyup
jz keydown
;keyup
mov dx,1
and al,0ffh-80h;
keydown:

cmp al,1;ESC
jne keyi0
mov al,02h
jmp keyiend
keyi0:
cmp al,1eh;A
jne keyi1
mov al,80h
jmp keyiend
keyi1:cmp al,1fh;S
jne keyi2
mov al,40h
jmp keyiend
keyi2:cmp al,20h;D
jne keyi3
mov al,20h
jmp keyiend
keyi3:cmp al,11h;W
jne keyi4
mov al,10h
jmp keyiend
keyi4:cmp al,1ch;Enter
jne keyi5
mov al,08h
jmp keyiend
keyi5:cmp al,0eh;backspace
jne keyi6
mov al,04h
jmp keyiend
keyi6:
keyiend:

cmp dx,1
jz keyup0
xor keybuf,al
jmp keyint0
keyup0:
and keybuf,al
keyint0:


; Send EOI
mov al, 61h
out 20h, al
; return
pop ax
mov ds,ax
pop dx
pop ax
popf
iret

