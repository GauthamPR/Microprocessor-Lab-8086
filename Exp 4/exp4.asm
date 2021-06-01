data SEGMENT
	msg1   DB 0ah, 0dh, "Enter String: $"
	msg2   DB 0ah, 0dh, "Enter Sub-string to replace: $"
    msg3   DB 0ah, 0dh, "Enter string to replace with: $"
	str    DB 2Fh dup('$')
	subString DB 2Fh dup('$')
    replaceStr DB 2Fh dup('$')
    finalMsg DB 0ah, 0dh, "Output: "
    finalStr DB 4Fh dup('$')
	lenSubStr DW 0000h
	restorePoint DW ?
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
					 MOV	restorePoint, DI
	loopStrInput:    MOV    AH, 01h
	                 INT    21h
	                 CMP    AL, 0dh
	                 JE     subStrInput
	                 MOV    [DI], AL
	                 INC    DI
					 INC	CX
	                 JMP    loopStrInput
	subStrInput:     LEA    DX, msg2
	                 MOV    AH, 09h
	                 INT    21h
	                 LEA    DI, subString
	loopSubStrInput: MOV    AH, 01h
	                 INT    21h
	                 CMP    AL, 0dh
	                 JE     replaceStrInput
					 INC	lenSubStr
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
	                 MOV    [DI], AL
	                 INC    DI
	                 JMP    loopReplaceStrInput
	checkStart:      LEA    SI, subString
	                 MOV    DI, restorePoint
	                 MOV    DX, [DI]
	                 MOV    BX, [SI]
					 INC	restorePoint
	                 CMP    BL, DL
	                 JE     checkConsecutive
	resumeCheckStart:MOV    DI, restorePoint
	                 MOV    DX, [DI-1]
                     LEA    DI, finalStr
	                 ADD    DI, index
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
	                 JMP    resumeCheckStart
    startReplace:    LEA    SI, replaceStr
                     LEA    DI, finalStr
	                 ADD	DI, index
                     SUB    CX, lenSubStr
					 MOV 	AX, restorePoint
					 ADD	AX, lenSubStr
					 DEC	AX
					 MOV	restorePoint, AX
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