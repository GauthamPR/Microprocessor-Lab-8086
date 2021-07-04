            MOV DI, 1000h
            MOV CX, 0004h
            MOV AX, 0000h
loop1:      MOV BX, 000ah
            MUL BX
            MOV BX, [DI]
            MOV BH, 00h
            SUB BX, 0030h
            INC DI
            ADD AX, BX
            LOOP loop1
            MOV [1005h], AX
            HLT
            MOV DI, 100Bh
            MOV CX, 0004h
            MOV AX, [1005h]
loop2:      MOV BX, 000ah
            MOV DX, 0000h
            DIV BX
            ADD DX, 0030h
            MOV [DI], DL
            DEC DI
            LOOP loop2
            RET