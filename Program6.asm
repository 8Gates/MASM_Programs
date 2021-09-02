TITLE Assignment 6

; Author: Chad Smith
; Last Modified: 06/03/2020
; OSU email address: smitcha4@oregonstate.edu
; Course number/section: CS 271
; Project Number: 6                Due Date: 06/07/2020
; Description: Implements and tests self written ReadVal and WriteVal procedures. WriteVal uses
; stosb and ReadVal uses lodsb in their conversions. Procedures invoke the mgetString and displayString
; macros. The test program gets and displays 10 signed integers which fit into 32-bit registers and 
; displays their calculated sum and rounded average. 
 
INCLUDE Irvine32.inc

MAXSIZE = 100

;*************************************************************************************************
;mGetString macro : getString req, stringSize req, usersInputLenth req 
; - Description: reads user input 
; - Preconditions: valid array (for edx) and valid loop counter (for ecx)
; - Receives: inString (array address), stringSize (SIZEOF inString)
; - Returns: inString (getString parameter), inputLength (usersInputLength)
;*************************************************************************************************
mGetString	MACRO	getString, stringSize
; save registers
push	edx
push	ecx

mov		edx, getString
mov		ecx, stringSize
call	ReadString				; string in inString

; restore registers 
pop		edx
pop		ecx
ENDM

;*************************************************************************************************
;mDisplayString macro : someString (array) required 
; - Description: writes provided string to console window
; - preconditions: valid filled array (for WriteString)
; - receives: someString (array) 
; - returns: N/A
;*************************************************************************************************
mDisplayString	MACRO	someString
; save registers
push	edx
push	ecx

mov		edx, someString			; the OFFSET of the string was passed as the argument 
call	WriteString

; restore registers 
pop		edx
pop		ecx
ENDM

.data

titleMsg		BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
authorMsg		BYTE	"Written by: Chad Smith", 0 
instructMsg1	BYTE	"Please provide 10 signed decimal integers.", 0 
instructMsg2	BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instructMsg3	BYTE	"After you have finished inputting the raw numbers I will display a list", 0
instructMsg4	BYTE	"of the integers, their sum, and their average value.", 0
enterNumMsg		BYTE	"Please enter a signed integer: ", 0
ErrorMsg		BYTE	"Error: The input was not a signed integer or it was too big. Try again. ", 0
commaSpace		BYTE	", ", 0
youEnteredMsg	BYTE	"You entered the following numbers: ", 0
sumMsg			BYTE	"The sum of these numbers is: ", 0 
averageMsg		BYTE	"The rounded average is: ", 0
thanksMsg		BYTE	"Thanks for playing!", 0

sumIntegers		DWORD	?
averageIntegers	DWORD	0
inString		QWORD	MAXSIZE DUP(?) ; QWORD
outString		QWORD	MAXSIZE DUP(?) ; QWORD
stringSize		DWORD	SIZEOF inString
usersInt		DWORD	? 
usersIntSize	DWORD	SIZEOF usersInt
stringArray		QWORD	?
stringArraySize	DWORD	SIZE stringArray
testArray		QWORD	?

.code
main PROC

; display title message and user instructions
mov		edx, OFFSET titleMsg
call	WriteString
call	crlf
mov		edx, OFFSET authorMsg
call	WriteString
call	crlf
mov		edx, OFFSET instructMsg1
call	WriteString
call	crlf
mov		edx, OFFSET instructMsg2
call	WriteString
call	crlf
mov		edx, OFFSET instructMsg3
call	WriteString
call	crlf
mov		edx, OFFSET instructMsg4
call	WriteString
call	crlf

mov		edi, offset testArray
mov		ecx, 10

readVal_Loop:

push	OFFSET enterNumMsg	; ebp + 24  
push	OFFSET ErrorMsg		; ebp + 20 
push	OFFSET usersInt		; ebp + 16
push	stringSize			; ebp + 12
push	OFFSET inString		; ebp + 8
call	readVal

mov		eax, usersInt
mov		[edi], eax			; store usersInt in testArray
add		edi, 4

loop	readVal_Loop

; display messsage for numbers entered, 
mov		edx, OFFSET youEnteredMsg
call	WriteString

; moves OFFSETs to registers and set loopCounter 
mov		esi, OFFSET testArray
mov		edi, OFFSET usersInt
mov		ecx, 10

writeVal_Loop:
; move testArray value into usersInt, start summing the values
mov		eax, [esi]			; testArray in eax
mov		[edi], eax			; move into usersInt
add		sumIntegers, eax

push	OFFSET stringArray	; ebp + 12
push	OFFSET usersInt		; ebp + 8
call	writeVal

; write comma after each displayed integer except for the last number displayed
mov		ebx, 1
cmp		ecx, ebx
je		afterComma
mov		edx, OFFSET commaSpace
call	WriteString

afterComma:
; clears needed space in stringArray for next test iteration 
xor		eax,eax
mov		edi, OFFSET stringArray
mov		[edi], eax
add		edi, 4
mov		[edi], eax
add		edi, 4
mov		[edi], eax

; clears needed space in usersInt for next test iteration
xor		eax,eax
mov		edi, OFFSET usersInt
mov		[edi], eax

; add 4 to esi and loop back  
add		esi, 4
loop	writeVal_Loop

; display sum message 
call	crlf
mov		edx, OFFSET sumMsg
call	WriteString
mov		eax, sumIntegers
cmp		eax, 0
jge		printUnsigned
call	WriteInt		; writeInt with sign
call	crlf
jmp		findAverage
printUnsigned:
call	WriteDec		; writeInt without sign
call	crlf

findAverage:
; find and average and round up or down 
xor		edx, edx
mov		ebx, 10			; divide by 10
cdq						; sign extend the registers in case of division with negative integer 
idiv	ebx
mov		ecx, 5 
cmp		edx, ecx		; check remainder for rounding 
jl		roundDown
add		eax, 1			; round up

roundDown:
; write message to screen and write integer with sign 
mov		edx, OFFSET averageMsg
call	WriteString
cmp		eax, 0
jge		printDec
call	WriteInt		; writeInt with sign 
call	crlf
mov		edx, OFFSET thanksMsg
call	WriteString
call	crlf
jmp		exiting

printDec:
; writeInt without sign and thanks message 
call	WriteDec
call	crlf
mov		edx, OFFSET thanksMsg
call	WriteString
call	crlf

exiting:
	exit			;exit to operating system
main ENDP

;*************************************************************************************************
;writeVal proc
; - summary description: Converts received numeric value to string of digits using stosb, integers
;	may be signed or unsigned. 
; - preconditions: parameter for usersInt is a signed integer and macro mDistplayString is 
;	defined for writing the converted value 
; - postconditions: all registers are restored prior to exiting
; - receives: stringArray(reference), usersInt(reference)
; - returns: stringArray (string of digits)
;*************************************************************************************************
writeVal PROC
; save registers
push	ebp
mov		ebp, esp
push	eax
push	ebx
push	ecx
push	edx
push	esi
push	edi

mov		edi, [ebp+12]		; offset of array into edi 
mov		eax, [ebp+8]		; address of usersInt in eax
mov		eax, [eax]			; value of usersInt in eax

; check for negative number 
mov		edx, 0				; set edx (negative flag) as 0 for positive integer 
cmp		eax, 0
jge		setupLoop
; number is negative, make positive and use edx for negative number flag 
mov		ebx, -1
mul		ebx
mov		edx, -1

setupLoop:
push	edx					; save negative integer flag edx  
mov		edx, 0				; loopCounter 
mov		ebx, 10				; divisor 
cld							; clear the direction flag

mainLoop:
push	edx
xor		edx, edx
div		ebx
push	eax					; save eax which holds the quotient 
mov		eax, edx			; move remainder into eax
push	ebx					; save ebx 
mov		ebx, 48
add		eax, ebx
pop		ebx					; restore ebx
stosb						; use stosb to store remainder in array

pop		eax					; restore eax
pop		edx					; restore loopCounter
inc		edx					
cmp		eax, 0				; if eax is 0 the number is finished
jg		mainLoop
; outside edx holds the loopCounter, on the stack is the negative flag waiting to be pushed 

; prep for next loop
mov		edi, edx			; length of integer in edi
mov		ecx, edi
mov		esi, [ebp+12]
pop		edx					; restore negative integer flag 

pushLoop:
; this loop pushes the stringArray ASCII codes onto the stack 
mov		eax, [esi]
push	eax
inc		esi
loop	pushLoop

; if edx is not less than 0 then jump over adding '-' to denote negative integer  
mov		esi, [ebp+12]		; testArray address to esi
mov		ecx, 0
cmp		edx, ecx
jge		prepPopLoop

; instert '-' into beginning of stringArray and increment esi
mov		byte ptr [esi], '-'
inc		esi

prepPopLoop:
; length of integer in ecx
mov		ecx, edi

popLoop:
; this loop pops the stored ASCII codes into stringArray, reversing the order 
pop		eax
mov		[esi], al
inc		esi
loop	popLoop

mDisplayString [ebp+12]

; displayString [ebp+8]
pop		edi
pop		esi
pop		edx
pop		ecx
pop		ebx
pop		eax
pop		ebp
ret		12
writeVal ENDP


;*************************************************************************************************
;readVal proc
; - summary description: prompts the user for integer input. Validates input and converts into
;	string representation. 
; - preconditions: defined mGetString macro for reading user input, valid parameters, no 
;	register preconditions exist
; - postconditions: all registers restored 
; - receives: enterNumMsg (ref), ErrorMsg(ref), usersInt(ref), stringSize(value), inString (ref)
; - returns: usersInt (string representation)
;*************************************************************************************************
readVal PROC
; save registers
push	ebp
mov		ebp, esp
push	edi
push	esi
push	eax
push	ebx
push	ecx
push	edx

; prompt the user to enter an integer and jump over invalidInput block
mov		edx, [ebp+24]
call	WriteString
jmp		Continue1

invalidInput:
; display invalid input message and request the user to try again
mov		edx, [ebp+20]
call	WriteString
call	Crlf
mov		edx, [ebp+24]
call	WriteString

Continue1:
mGetString [ebp+8], [ebp+12]	; arguments passed are inString, stringSize	 

mov		esi, [ebp+8]			; offset of inString into esi
mov		ecx, eax				; size of string (loop counter) in ecx
cmp		eax, 11					; 1st input validation check, length should be <12
jg		invalidInput
je		length11
cmp		eax, 10
je		length10
jmp		movingOn
cld

length11:
; validation for length 11 of user input 
lodsb
cmp		al, 47					; possibly + or -
jg		InvalidInput			; length is 11 and 1st byte is not + or -		
cmp		al, 45
jne		ContinueAgain					
mov		ebx, -1					; flag the sign as nega 
ContinueAgain:
lodsb							;+2
cmp		al, 50
jg		invalidInput			; 2nd byte is > 2
jl		movingOn

lodsb							;+2,1
cmp		al, 49
jg		invalidInput			; 3rd byte is > 1
jl		movingOn

lodsb							;+2,14
cmp		al, 52
jg		invalidInput			; 4th byte is > 4
jl		movingOn

lodsb							;+2,147,
cmp		al, 55
jg		invalidInput			; 5th byte is > 7
jl		movingOn

lodsb							;+2,147,4
cmp		al, 52
jg		invalidInput			; 6th byte is > 4
jl		movingOn

lodsb							;+2,147,48
cmp		al, 56
jg		invalidInput			; 7th byte is > 8
jl		movingOn

lodsb							;+2,147,483,
cmp		al, 51
jg		invalidInput			; 8th byte is > 3
jl		movingOn

lodsb							;+2,147,483,6
cmp		al, 54
jg		invalidInput			; 9th byte is > 6
jl		movingOn

lodsb							;+2,147,483,64
cmp		al, 52
jg		invalidInput			; 10th byte is > 4
jl		movingOn

cmp		ebx, 0
jge		positiveSign

; if sign is negative check if last byte is 8 or less 
lodsb							;-2,147,483,648
cmp		al, 56
jg		invalidInput			; 11th byte is > 8
jmp		movingOn

positiveSign:
; if sign is positive check if last byte is 7 or less
lodsb							;+2,147,483,647
cmp		al, 55
jg		invalidInput			; 11th byte is > 7 if positive
jmp		movingOn

; part of validation loop for length 10 of user input 
length10:
mov		esi, [ebp+8]			; offset of inString into esi
lodsb
cmp		al, 47					; possibly + or -
jl		movingOn				; length is 10 and 1st byte is + or -	-		

cmp		al, 50					; 2
jg		invalidInput			; 1st byte is > 2
jl		movingOn

lodsb							; 2,1
cmp		al, 49
jg		invalidInput			; 2nd byte is > 1
jl		movingOn

lodsb							; 2,14
cmp		al, 52
jg		invalidInput			; 3rd byte is > 4
jl		movingOn

lodsb							; 2,147,
cmp		al, 55
jg		invalidInput			; 4th byte is > 7
jl		movingOn

lodsb							; 2,147,4
cmp		al, 52
jg		invalidInput			; 5th byte is > 4
jl		movingOn

lodsb							; 2,147,48
cmp		al, 56
jg		invalidInput			; 6th byte is > 8
jl		movingOn

lodsb							; 2,147,483,
cmp		al, 51
jg		invalidInput			; 7th byte is > 3
jl		movingOn

lodsb							; 2,147,483,6
cmp		al, 54
jg		invalidInput			; 8th byte is > 6
jl		movingOn

lodsb							; 2,147,483,64
cmp		al, 52
jg		invalidInput			; 9th byte is > 4
jl		movingOn

lodsb							; 2,147,483,648
cmp		al, 55
jg		invalidInput			; 10th byte is > 7
jl		movingOn

movingOn:
mov		edx, 0					; accumulator 
mov		ebx, 0					; used to determine if 1st byte is + or - 
cld								; clear the direction flag

mov		esi, [ebp+8]			; offset of inString into esi
validationLoop:
; load each byte of input string for validation, store in outString 
lodsb
cmp		al, 47
jle		checkSign				; decimal code is less than 48
cmp		al, 58
jge		invalidInput			; decimal code is greater than 57

sub		al, 48					; convert string number to number

push	eax						; save eax for to use multiplication 
mov		eax, edx
mov		edx, 10					
mul		edx

mov		edx, eax				
pop		eax						; restore eax's numeric value 
add		edx, eax
jmp		Continue2

checkSign:
; This block is reached if decimal code is less than 48. Check for + and - codes.
cmp		ebx, 0
jne		invalidInput			; don't check sign if not on the first iteration
cmp		al, 43
je		Continue2				; input is '+'
cmp		al, 45
je		NegativeFlag			; input is '-'
jmp		invalidInput			; input is outside of instructed parameters
jmp		Continue2

NegativeFlag:
mov		ebx, -1					; flag the number as negative
Continue2:
; if ebx = -1 retain the # as a negative input flag, otherwise increment ebx so the 
; procedure knows it is not on the first iteration
cmp		ebx, -1
je		Next1
inc		ebx
Next1:
loop	validationLoop

; if ebx flag is set to -1, multiply the converted input by -1 for negative result 
mov		eax, edx
cmp		ebx, -1
jne		Next2
mov		edx, -1
mul		edx

Next2:
; pass the converted integer to [ebp+16] 'usersInt' variable  
xor		edx, edx
mov		edx, [ebp+16]
mov		[edx], eax 

; restore registers 
pop		edx
pop		ecx
pop		ebx
pop		eax
pop		esi
pop		edi
pop		ebp
ret		18
readVal ENDP

END main


