            MOV AX, [1000h]
            MOV CX, 0005h
loop1:      MOV BX, 000ah
            MOV DX, 0000h
            DIV BX
            MOV BX, [1003h]
            ROR BX, 4
            ADD BX, DX
            MOV [1003h], BX
            LOOP loop1
            HLT
            MOV CX, 0004h
loop2:      MOV BX, [1003h]
            ROL BX, 4
            MOV [1003h], BX
            AND BX, 000Fh
            MOV AX, [1006h]
            MOV DX, 000Ah
            MUL DX
            ADD AX, BX 
            MOV [1006h], AX
            LOOP loop2
            RET