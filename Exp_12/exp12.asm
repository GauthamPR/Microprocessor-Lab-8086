            MOV DI, 1000h
            MOV CX, 0003h
loop1:      MOV AX, [DI]
            MOV BX, [DI+2]
            INC DI
            INC DI
            CMP BX, AX
            JLE swap
            LOOP loop1
            HLT
swap:       MOV [DI-2], BX 
            MOV [DI], AX
            LOOP loop1