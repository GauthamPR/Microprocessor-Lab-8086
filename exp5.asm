data SEGMENT
	msg1   DB 0ah, 0dh, "Enter how many: $"
	msg2   DB 0ah, 0dh, "Enter the number: $"
    msg3   DB 0ah, 0dh, "Enter Sub-string to replace with: $"
	affirm DB 0ah, 0dh, "Sub-String$"
	deny   DB 0ah, 0dh , "Not a Sub-string$"
	str    DB 2Fh dup('$')
	subString DB 2Fh dup('$')
    replaceStr DB 2Fh dup('$')
    finalMsg DB 0ah, 0dh, "Output: "
    finalStr DB 4Fh dup('$')
	lenStr DW 0000h
    lenSubStr DW 0000h
    lenReplaceStr DW 0000h
    index DW 0000h
	eos    DB '$'
data ENDS
code SEGMENT
	                 ASSUME CS:code, DS: data
	start:           MOV    AX, data
	                 MOV    DS, AX
	                 MOV    CX, 0000h
	                 LEA    DX, msg1
	                 MOV    AH, 09h
	                 INT    21h
	                 LEA    DI, str
	loopStrInput:    MOV    AH, 01h
	                 INT    21h
	                 CMP    AL, 0dh
	                 JE     subStrInput
	                 INC    CX
	                 MOV    [DI], AL
	                 INC    DI
	                 JMP    loopStrInput
	subStrInput:     MOV    lenStr, CX
	                 LEA    DX, msg2
	                 MOV    AH, 09h
	                 INT    21h
	                 LEA    DI, subString
	loopSubStrInput: MOV    AH, 01h
	                 INT    21h
	                 CMP    AL, 0dh
	                 JE     replaceStrInput
                     INC    lenSubStr
	                 MOV    [DI], AL
	                 INC    DI
	                 JMP    loopSubStrInput
    replaceStrInput: LEA    DX, msg3
	                 MOV    AH, 09h
	                 INT    21h
	                 LEA    DI, replaceStr
	loopReplaceStrInput: MOV    AH, 01h
	                 INT    21h
	                 CMP    AL, 0dh
	                 JE     checkStart
                     INC    lenReplaceStr
	                 MOV    [DI], AL
	                 INC    DI
	                 JMP    loopReplaceStrInput
	checkStart:      LEA    SI, subString
	                 LEA    DI, str
	                 MOV    AX, lenStr
	                 SUB    AX, CX
	                 ADD    DI, AX
	                 MOV    DX, [DI]
	                 MOV    BX, [SI]
	                 CMP    BL, DL
	                 JE     checkConsecutive
                     LEA    DI, finalStr
                     MOV    AX, index
	                 ADD    DI, AX
                     MOV    [DI], DX
                     INC    index
	                 LOOP   checkStart
	printDeny:       LEA    DX, finalMsg
	                 JMP    exit
	checkConsecutive:MOV    DX, [DI]
	                 MOV    BX, [SI]
	                 INC    DI
	                 INC    SI
	                 CMP    BL, '$'
	                 JE     startReplace
	                 CMP    BL, DL
	                 JE     checkConsecutive
                     DEC    CX
	                 JMP    checkStart
    startReplace:    LEA    SI, replaceStr
                     LEA    DI, finalStr
                     MOV    AX, lenStr
	                 SUB    AX, CX
	                 ADD    DI, AX
                     SUB    CX, lenSubStr
	doReplace:       MOV    AX, [SI]
                     MOV    [DI], AX
                     CMP    [SI], '$'
                     JE     checkStart
                     INC    SI
                     INC    index
                     INC    DI
	                 JMP    doReplace
	exit:            MOV    AH, 09h
	                 INT    21h
	                 MOV    AH, 4Ch
	                 INT    21h
code ENDS
END start