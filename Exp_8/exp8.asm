MOV AX,[1000h]
MOV BX,[1002h]
AND AX, BX 
MOV [1004h],AX
HLT
MOV AX,[1000h] 
MOV BX,[1002h]
OR AX,BX
MOV [1006h],AX
HLT
MOV AX,[1000h]
NOT AX
MOV [1008h], AX
HLT
MOV AX,[1000h]
MOV BX,[1002h]
XOR AX, BX
MOV [100Ah], AX
HLT