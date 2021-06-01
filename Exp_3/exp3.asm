data SEGMENT
	msg1   DB 0ah, 0dh, "Enter String: $"
	msg2   DB 0ah, 0dh, "Enter Sub-string: $"
	affirm DB 0ah, 0dh, "Sub-String$"
	deny   DB 0ah, 0dh , "Not a Sub-string$"
	str    DB 0Fh dup('$')
	subString DB 0Fh dup('$')
	lenStr DW ?
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
	                 JE     checkStart
	                 MOV    [DI], AL
	                 INC    DI
	                 JMP    loopSubStrInput
	checkStart:      LEA    SI, subString
	                 LEA    DI, str
	                 MOV    AX, lenStr
	                 SUB    AX, CX
	                 ADD    DI, AX
	                 MOV    DX, [DI]
	                 MOV    BX, [SI]
	                 CMP    BL, DL
	                 JE     checkConsecutive
                     INC    DI
	                 LOOP   checkStart
	printDeny:       LEA    DX, deny
	                 JMP    exit
	checkConsecutive:MOV    DX, [DI]
	                 MOV    BX, [SI]
	                 INC    DI
	                 INC    SI
	                 CMP    BL, '$'
	                 JE     printAffirm
	                 CMP    BL, DL
	                 JE     checkConsecutive
	                 JMP    checkStart
	printAffirm:     LEA    DX, affirm
	exit:            MOV    AH, 09h
	                 INT    21h
	                 MOV    AH, 4Ch
	                 INT    21h
code ENDS
END start