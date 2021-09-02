TITLE Composite Numbers

; Author: Chad Smith
; Last Modified: 05/09/2020
; OSU email address: smitcha4@oregonstate.edu
; Course number/section: CS 271
; Project Number: 4                Due Date: 05/10/2020
; Description: The user is instructed to enter the number of composites to be displayed, and is 
; prompted to enter an integer in the range [1 .. 400].  The user enters a number, n, and the 
; program verifies that 1 <= n <= 400.  If n is out of range, the user is reprompted until s/he 
; enters a value in the specified range.  The program then calculates and displays all of the
; composite numbers up to and including the nth composite.  The results should be displayed 10 
; composites per line with at least 3 spaces between the numbers. 

INCLUDE Irvine32.inc

MIN_LIMIT = 1
MAX_LIMIT = 400
ROW_LENGTH = 10

.data

authorsIntro		BYTE	"Program 4: Composite Numbers by Chad Smith", 0
extraCredit			BYTE	"**EC: Align the output in columns.", 0
userInstructions	BYTE	"Enter the number of composite numbers you would like to see.", 0
parameterMsg		BYTE	"I'll accept orders for up to 400 composites.", 0
enterNumMsg			BYTE	"Enter the number of composites to display [1 .. 400]: ", 0
outOfRangeMsg		BYTE	"Out of range. Try again.", 0
byeUserMsg			BYTE	"Thanks for participating and have a great day.", 0
notInRange			BYTE	0
maxIteration		DWORD	495		; 400th composite number is 495
numComposites		DWORD	?
loopCounter1		DWORD	1
loopCounter2		DWORD	?
usersInt			DWORD	?
ECX_Holder			DWORD	?

whiteSpace5			BYTE	5 DUP(" "), 0
whiteSpace6			BYTE	6 DUP(" "), 0
whiteSpace7			BYTE	7 DUP(" "), 0

.code
main PROC

call	Introduction
call	GetUserData
call	ShowComposites
call	Farewell

	exit	; exit to operating system
main ENDP


;-------------------------------------------------------------------------------------
;Introduction
;
;Description: Displays program's title and author's name. Displays instructions for 
;the user. 
;
;Preconditions: N/A
;
;Postconditions: edx is cleared (xor edx, edx) 
;
;Receives: authorsIntro, extraCredit, userInstructions, parameterMsg
;
;Returns: N/A
;-------------------------------------------------------------------------------------
Introduction PROC
; displays program's title and author's name
call	Crlf
mov		edx, OFFSET authorsIntro
call	WriteString
call	Crlf
mov		edx, OFFSET extraCredit
call	WriteString
call	Crlf
call	Crlf

; displays instructions to user 
mov		edx, OFFSET userInstructions
call	WriteString
call	Crlf
mov		edx, OFFSET parameterMsg
call	WriteString
call	Crlf
xor		edx, edx			; clear the edx register

ret
Introduction ENDP


;-------------------------------------------------------------------------------------
;GetUserData
;
;Description: Displays message for input, gets integer input from user and stores in 
;usersInt. Calls Validate procedure to set EBX to 1 if input is out of range. If out 
;of range this procedure jumps back to the beginning to request input. 
;
;Preconditions: requires the Validate procedure be defined for input validation 
;
;Postconditions: edx contains offset of enterNumMsg, eax holds user's integer input,
; ebx contains 0 or 1
;
;Receives: enterNumMsg, user input (during procedure after prompt), MIN_LIMIT constant
; for range checking of input 
;
;Returns: usersInt variable (holds user's integer input)
;-------------------------------------------------------------------------------------
GetUserData PROC
GetData:
; prompt user for input and store input in usersInt
mov		edx, OFFSET enterNumMsg
call	WriteString
call	ReadInt
mov		usersInt, eax

mov		EBX, 0			; zero will be used to signify input is within range
call	Validate		; validate user input
cmp		EBX, MIN_LIMIT
jge		GetData			; ebx is not zero and input was out of range

ret
GetUserData ENDP


;-------------------------------------------------------------------------------------
;Validate
;
;Description: Validates if input (n) is valid (1 <= n <= 400). If input is out of
;range EBX is changed to 1.
;
;Preconditions: eax holds user's integer input, ebx holds 0 
;
;Postconditions: eax cleared (with xor), edx cleared (with xor),
;
;Receives: MIN_LIMIT and MAX_LIMIT for integer range checking, outOfRangeMsg
;
;Returns: EBX retuned holding 1 if users integer is out of rang otherwise remains 0, 
;-------------------------------------------------------------------------------------
Validate PROC
; checks if input is less than 1
cmp		eax, MIN_LIMIT
jl		OutOfRange

; checks if input is greater than 400
cmp		eax, MAX_LIMIT
jg		OutOfRange

; input is within range, jump to exit procedure
jmp		ExitProcedure

OutOfRange:
; displays message that input was not in range and increments notInRange
mov		edx, OFFSET outOfRangeMsg
call	WriteString
call	Crlf
mov		EBX, 1	; 1 flags that the input is not in range

ExitProcedure:
; clear registers used, except for EBX, prior to exiting
call	Crlf
xor		eax, eax
xor		edx, edx
ret
Validate ENDP


;-------------------------------------------------------------------------------------
;ShowComposites
;
;Description: Sets max number of iterations, calls IsComposite procedure to display 
; composite numbers equal to integer requested by the user. 
;
;Preconditions: usersInt should have been validated to be within range [1..400] 
;
;Postconditions: eax holds quotient from division, ebx holds 10, edx holds remainder 
; from division, ECX counter should be 0
;
;Receives: maxIteration, numComposites, usersInt, loopCounter1, loopCounter2
;
;Returns: loopCounter1, (via IsComposite procedure: loopCounter2 and numComposites)
;-------------------------------------------------------------------------------------
ShowComposites PROC
; set max number of iterations
mov		ECX, maxIteration

Loop1:
; if numComposites has been incremented enough times to equal userInt, jump to Exiting
mov		eax, numComposites
cmp		eax, usersInt
je		Exiting
mov		loopCounter2, 1			; initialize loopCounter2 to 1 
mov		eax, loopCounter1

; call IsComposite procedure, increment loopCounter1 and loop 
call	IsComposite
inc		loopCounter1
loop	Loop1

Exiting:
ret
ShowComposites ENDP


;-------------------------------------------------------------------------------------
;IsComposite
;
;Description: Validates if number is composite, displays composite, formats 10 integers
; per line
;
;Preconditions: loopCounter2 should be initialized to 1, ECX should hold loopCounter1
;
;Postconditions: eax holds quotient from division, ebx holds 10, edx holds remainder 
; from division
;
;Receives: ECX counter for Loop1, loopCounter2 (initialized to 1), numComposites, 
; whiteSpace7, whiteSpace6, whiteSpace5, ECX_HOLDER 
;
;Returns: ECX which should be set to original value when procedure started, loopCounter1,
; loopCounter2, numComposites 
;-------------------------------------------------------------------------------------
IsComposite PROC
mov		ECX_Holder, ECX			; save ECX state in ECX_Holder
xor		ECX, ECX
mov		ECX, loopCounter1		; set 2nd loop to loop loopCounter1 number of times

Loop2:
; if the loopCounter1(n) is (n <= 1) or (n >= usersInt) it is not a composite
mov		eax, loopCounter2
cmp		eax, 1	
jle		EndIteration
cmp		eax, loopCounter1
jge		EndIteration

; if looptCounter1 is evenly divisble by loopCounter2 jump to PrintComposite, else
; jump to EndIteration 
mov		eax, loopCounter1
xor		edx, edx			; clear edx register
div		loopCounter2
cmp		edx, 0
je		PrintComposite
jmp		EndIteration

; increment loopCounter2 by 1 and either continue loop or jump to ClearECX to 
; return the loop counter to its original state prior to Loop2 
EndIteration:
inc		loopCounter2
loop	Loop2
jmp		ClearECX

; increments numComposites and calls writeDec for output 
PrintComposite:
inc		numComposites
mov		eax, loopCounter1
call	WriteDec

; determines length of current sequence number and jumps to write whitespaces
cmp		eax, 10
jl		length1
cmp		eax, 100
jl		length2
cmp		eax, 1000
jl		length3

; determines the number of white spaces needed after printing integer for formatting
length1:
mov		edx, OFFSET whiteSpace7
call	WriteString
jmp		Ending
length2:
mov		edx, OFFSET whiteSpace6
call	WriteString
jmp		Ending
length3:
mov		edx, OFFSET whiteSpace5
call	WriteString

Ending:
; jumps to print a new line if numComposites is a multiple of 10 (ie 10 integers
; have been printed to screen) otherwise jumps to ClearECX
mov		eax, numComposites
mov		ebx, 10
xor		edx, edx
div		ebx
cmp		edx, 0
je		NewLine
jmp		ClearECX

NewLine:
; 10 integers have been diplayed on a line, start next line 
call	Crlf

ClearECX:
; ECX returned to original state when procedure was called
mov		ECX, ECX_Holder
ret
IsComposite ENDP


;-------------------------------------------------------------------------------------
;Farewell
;
;Description: Displays parting message to user
;
;Preconditions: N/A
;
;Postconditions: edx cleared (xor edx, edx)
;
;Receives: byeUserMsg
;
;Returns: N/A
;-------------------------------------------------------------------------------------
Farewell PROC
; displays parting message to user
mov		edx, OFFSET byeUserMsg
call	Crlf
call	WriteString
call	Crlf
xor		edx, edx		; clears EDX register 
ret
Farewell ENDP

END main