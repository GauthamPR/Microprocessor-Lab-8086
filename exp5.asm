data segment
	countMsg DB 0ah, 0dh, "Enter count(max 5): $"
	finalMsg DB 0ah, 0dh, "Sorted: $"
	searchMsg DB 0ah, 0dh, "Enter number to search: $"
	affirmMsg DB 0ah, 0dh, "The number is found at index: $"
	denyMsg DB 0ah, 0dh, "The number is not found$"
	searchNum DW ?
	space DB " $"
	opr1 db 0ah,0dh,"Enter number: $"
	count dw ?
	tempCount dw ?
	numbers DW 4Fh dup(0000h)
	num dw ?
	num1 dw ?
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
code segment
assume cs:code,ds:data
	start: 			mov ax,data
					mov ds,ax
					display countMsg
					read count
					MOV CX, count
					MOV tempCount, CX
					MOV DI, 0000h
	readNumbers: 	display opr1
					read numbers[DI]
					INC DI
					INC DI
					LOOP readNumbers
	fullTraverse:	MOV DI, 0000h
					DEC tempCount
					MOV CX, count
					DEC CX
					CMP tempCount, 0000h
					JE exit
	movePointer:	CMP CX, 0000h
					JE	fullTraverse
					MOV AX, numbers[DI]
					MOV BX, numbers[DI+2]
					DEC CX
					INC DI
					INC DI
					CMP AX, BX
					JLE movePointer
					MOV numbers[DI], AX
					MOV numbers[DI-2], BX
					JMP movePointer
	exit:			MOV CX, count
					MOV DI, 0000h
					display finalMsg
	printNumber:	MOV tempCount, CX
					print numbers[DI]
					display space
					MOV CX, tempCount
					INC DI
					INC DI
					LOOP printNumber
	searchNumber:	display searchMsg
					read searchNum
					MOV CX, count
					MOV DI, 0000h
	traverseArray:	MOV AX, searchNum
					CMP AX, numbers[DI]
					JE affirm
					INC DI
					INC DI
					LOOP traverseArray
					display denyMsg
					mov ah,4ch
					int 21h
	affirm:			display affirmMsg
					MOV AX, DI
					MOV BL, 0002h
					DIV BL
					print AX
					mov ah,4ch
					int 21h
code ends
end start