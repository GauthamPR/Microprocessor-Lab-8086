MOV AX,[1000h]
MOV BX,[1002h] 
MOV CX,0000h 
ADD AX,BX 
MOV [1004h],AX
JNC jump
INC CL 
jump: MOV [1006h],CX
HLT
MOV AX,[1000h] 
MOV BX,[1002h]
SUB AX,BX
jumpSub: MOV [1008h],AX
HLT
MOV AX,[1000h]
MOV BX,[1002h]
MUL BX
MOV [100Ch], AX
MOV [100Eh], DX
HLT
MOV AX,[1002h]
MOV BX,[1000h]
MOV DX, 0000h
DIV BX
MOV [1010h], AX
MOV [1012h], DX
HLT