MOV CX, [1000h]
MOV AX, 0001
MOV DX, 0000
something: MUL CX
LOOP something
MOV [1002h], AX
MOV [1004h], DX 
HLT