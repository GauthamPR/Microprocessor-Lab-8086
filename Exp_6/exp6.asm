data segment
	wdthMsg           DB 0ah, 0dh, "Enter wdth of matrices: $""
	heightMsg         DB 0ah, 0dh, "Enter height of matrices: $"
	mtx1Msg           DB 0ah, 0dh, "Enter matrix 1: $"
	mtx2Msg           DB 0ah, 0dh, "Enter matrix 2: $"
	newline           DB 0ah, 0dh, "$"
	finalMsg          DB 0ah, 0dh, "Sum: $"
	finalTransposeMsg DB 0ah, 0dh, "Transpose: $"
	space             DB " $"
	convertedNum      DW ?
	endOfTranspose    DW ?
	mtx1              DW 4Fh dup(0000h)
	mtx2              DW 4Fh dup(0000h)
	sum               DW 4Fh dup(0000h)
	num               dw ?
	num1              dw ?
	wdth              dw ?
	height            dw ?
	lngth             dw ?
data ends

display macro msg
	        mov dx,offset msg
	        mov ah,09h
	        int 21h
endm

read macro num
	     local L1,exit
	     mov   ah,01h
	     int   21h
	     mov   ah,00h
	     sub   ax,0030h
	     mov   num,ax
	L1:  mov   ah,01h
	     int   21h
	     cmp   al,0dh
	     je    exit
	     mov   ah,00h
	     sub   ax,0030h
	     mov   num1,ax
	     mov   ax,num
	     mov   bx,000ah
	     mul   bx
	     add   ax,num1
	     mov   num,ax
	     jmp   L1
	exit:nop
endm
print macro num
	      local L2,L3
	      mov   ax,num
	      mov   cx,0000h
	L2:   mov   dx,0000h
	      mov   bx,000ah
	      div   bx
	      push  dx
	      inc   cx
	      cmp   ax,0000h
	      jne   L2
	L3:   pop   dx
	      add   dx,0030h
	      mov   ah,02h
	      int   21h
	      loop  L3
endm
code segment
	            assume  cs:code,ds:data
	start:      mov     ax,data
                  mov     ds,ax
                  display wdthMsg
                  read    wdth
                  display heightMsg
                  read    height
                  MOV     AX, wdth
                  MOV     BX, height
                  MUL     BX
                  MOV     lngth, AX
                  ADD     AX, wdth
                  DEC     AX
                  MOV     endOfTranspose, AX
                  display mtx1Msg
                  MOV     CX, lngth
                  MOV     DI, 0000h
	temp:       read    mtx1[DI]
                  INC     DI
                  display newline
                  LOOP    temp
                  display mtx2Msg
                  MOV     CX, lngth
                  MOV     DI, 0000h
	temp2:      read    mtx2[DI]
                  INC     DI
                  display newline
                  LOOP    temp2
                  MOV     CX, lngth
                  MOV     DI, 0000h
	L1:         MOV     AX, mtx1[DI]
                  MOV     BX, mtx2[DI]
                  ADD     AX, BX
                  MOV     sum[DI], AX
                  INC     DI
                  LOOP    L1
                  display finalMsg
                  MOV     DI, 0000h
	L2:         MOV     AX, sum[DI]
                  MOV     AH, 00h
                  MOV     convertedNum, AX
                  MOV     AX, DI
                  MOV     BX, wdth
                  DIV     BL
                  CMP     AH, 0000h
                  JNE     printNumber
                  display newline
	printNumber:print   convertedNum
                  display space
                  INC     DI
                  CMP     DI, lngth
                  JNE     L2
                  display newline
                  display finalTransposeMsg
                  display newline
                  MOV     DI, 0000h
	transpose:  MOV     AX, sum[DI]
                  MOV     AH, 00h
                  MOV     convertedNum, AX
                  MOV     AX, DI
                  MOV     BX, wdth
                  DIV     BL
	printTNumber:print   convertedNum
                  display space
                  ADD     DI, wdth
                  CMP     DI, endOfTranspose
                  JE      exit
                  CMP     DI, lngth
                  JGE     something
                  JMP     transpose
	something:  MOV     AX, DI
                  MOV     BX, lngth
                  DIV     BL
                  MOV     BH, 00h
                  MOV     BL, AH
                  MOV     DI, BX
                  INC     DI
                  display newline
                  JMP     transpose
	exit:       mov     ah,4ch
	            int     21h
code ends
end start