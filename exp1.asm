data segment
	opr1 db 0ah,0dh,"Enter A: $"
	opr2 db 0ah,0dh,"Enter B: $"
	resultSum db 0ah,0dh,"A+B: $ "
    resultDiff db 0ah, 0dh, "A-B: $"
    resultQuo db 0ah, 0dh, "A/B: $"
    resultPdt db 0ah, 0dh, "A*B: $"
	resultRem db 0ah, 0dh, "Remainder: $"
	num dw ?
	num1 dw ?
	a dw ?
	b dw ?
	sum  dw ?
    diff dw ?
    quo dw ?
    pdt dw ?
data ends

display macro msg
	mov dx,offset msg
	mov ah,09h
	int 21h
endm

read macro num
	local L1,exit
	mov ah,01h
	int 21h
	mov ah,00h
	sub ax,0030h
	mov num,ax
	L1:mov ah,01h
	int 21h
	cmp al,0dh
	je exit
	mov ah,00h
	sub ax,0030h
	mov num1,ax
	mov ax,num
	mov bx,000ah
	mul bx
	add ax,num1
	mov num,ax
	jmp L1
	exit:nop
endm

print macro num
    local L2,L3
	mov ax,num
	mov cx,0000h
	L2: mov dx,0000h
	mov bx,000ah
	div bx
	push dx
	inc cx
	cmp ax,0000h
	jne  L2
	L3: pop dx
	add dx,0030h
	mov ah,02h
	int 21h
	loop L3
endm
calculate macro num1, num2
	display resultSum
	mov cx,num1
    mov bx,num2
    add cx,bx
	mov sum,cx
	print sum
	display resultDiff
    mov cx,num1
	mov bx,num2
    sub cx, bx
    mov diff, cx
    print diff
	display resultPdt
    mov ax,num1
	mov bx,num2
    mul bx
    mov pdt, ax
    print pdt
	display resultQuo
    mov ax,num1
	mov bx,num2
	mov dx, 0000h
    div bx
    mov quo, ax
    print quo
endm
code segment
assume cs:code,ds:data
start: mov ax,data
    mov ds,ax
    display opr1
	read a
	display opr2
	read b
    calculate a, b
	mov ah,4ch
	int 21h
code ends
end start