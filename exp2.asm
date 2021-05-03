data SEGMENT
	msg1   DB 0ah, 0dh, "Enter the string: $"
	affirm DB 0ah, 0dh, "The string is palindrome$"
	deny   DB 0ah, 0dh, "The string is not palindrome$"
	str    DB 0Fh dup('$')
data ENDS
code SEGMENT
	              ASSUME CS:code, DS:data
	start:        MOV    AX, data
	              MOV    DS, AX
	              LEA    DX, msg1
	              MOV    AH, 09h
	              INT    21h
	              LEA    DI, str
	              MOV    CX, 0000h
	l1:           MOV    AH, 01h
	              INT    21h
	              CMP    AL, 0dh
	              JE     break
	              MOV    [DI], AL
	              INC    DI
	              INC    CX
	              PUSH   AX
	              JMP    l1
	break:        LEA    DI, str
	check:        POP    DX
	              MOV    BX, [DI]
	              INC    DI
	              CMP    BL, DL
	              JNE    notPalindrome
	              LOOP   check
	              LEA    DX, affirm
	              JMP    exit
	notPalindrome:LEA    DX, deny
	              JMP    exit
	exit:         MOV    AH, 09h
	              INT    21h
	              MOV    AH,4ch
	              INT    21h
code ENDS
END start