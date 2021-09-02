TITLE Integer Accumulator

; Author: Chad Smith
; Last Modified: 04/29/2020
; OSU email address: smitcha4@oregonstate.edu
; Course number/section: CS 271
; Project Number: 3                Due Date: 05/03/2020
; Description: 
; 1) Display the program title and programmer’s name. 
; 2) Get the user’s name, and greet the user. 
; 3) Display instructions for the user. 
; 4) Repeatedly prompt the user to enter a number. 
; 5) Calculate the (rounded integer) average of the valid numbers.
; 6) Display # of valid numbers along with their sum, maximum, minimum and rounded average values.
;	 If no valid numbers were entered skip to the parting message. Display parting message. 

INCLUDE Irvine32.inc

LIMIT_88 = -88
LIMIT_55 = -55
LIMIT_40 = -40
LIMIT_1 = -1

.data

authorsIntro		BYTE	"Program 3: Integer Accumulator by Chad Smith", 0
userNamePrompt		BYTE	"What's your name? ", 0
greetUserMsg		BYTE	"Nice to meet you ", 0 
instructInput1		BYTE	"Please enter numbers in range [-88, -55] or [-40, -1].", 0
instructInput2		BYTE	"Enter a non-negative number when you are finished to see results.", 0
askNumMsg			BYTE	" Enter number: ", 0
invalidMsg			BYTE	"Invalid number! Valid range [-88, -55], [-40, -1] or >-1 to exit.", 0
failureMsg			BYTE	"It can be difficult following instructions. Let's try again soon!", 0
numsEntered			BYTE	"You entered ", 0
validNums			BYTE	" valid numbers.", 0
maxNumMsg			BYTE	"The maximum valid number is ", 0
minNumMsg			BYTE	"The minimum valid number is ", 0
sumNumMsg			BYTE	"The sum of your valid numbers is ", 0
roundAvgMsg			BYTE	"The rounded average is ", 0
byeUserMsg			BYTE	"Thanks for participating. Goodbye ", 0
byeUserMsg2			BYTE	" and have a great day.", 0
extraCredit			BYTE	"**EC: Lines numbered for user input. Increments line number for valid number entries", 0
buffer				BYTE	21 DUP(0)		; maximum length for name input (including 0 value)
userName			QWORD	?, 0
usersInt			DWORD	?
integerSum			DWORD	0
minimumInt			DWORD	0
maximumInt			DWORD	-89
roundAvg			DWORD	?
loopCounter			DWORD	1
remainder			DWORD	?
period				DWORD	".", 0

.code
main PROC

; Display programmer's name and program title
call	CrLf
mov		edx, OFFSET authorsIntro
call	WriteString
call	CrLf

; Display extra credit message
mov		edx, OFFSET extraCredit
call	WriteString
call	CrLf

; Ask for User's name and store in variable
call	CrLf
mov		edx, OFFSET userNamePrompt
call	WriteString
mov		edx, OFFSET userName	; location in memory where user input is stored
mov		ecx, SIZEOF	buffer		; maximum length for name is 20 letters/characters
call	ReadString				; store user's name in userName address
call	CrLf

; Greet the User
mov		edx, OFFSET greetUserMsg
call	WriteString
mov		edx, OFFSET userName
call	WriteString
call	CrLf

; Display Instructions for the User
call	CrLf
mov		edx, OFFSET instructInput1
call	WriteString
call	CrLf
mov		edx, OFFSET instructInput2
call	WriteString
call	CrLf
jmp		Prompt_Input			; jump to start input validation

Invalid_Num:
; Display invalid number input message for user
mov		edx, OFFSET invalidMsg
call	WriteString
call	Crlf

Prompt_Input:
; Prompt user for number 
mov		eax, loopCounter
call	WriteDec
mov		edx, OFFSET period
call	WriteString
mov		edx, OFFSET askNumMsg
call	WriteString
call	ReadInt
mov		usersInt, eax

Validation_1:
; Validates if user input is greater than -1 (via the sign flag); If yes, jump	 
jns		PositiveInteger

Validation_2:
; Validates if user input is greater than or equal to -40 
; If yes the number is valid, If no continue to validate
mov		ebx, LIMIT_40
cmp		eax, ebx
jge		Valid_Num

; Validate user input is less than -55 
; If yes the number is invalid, If no continue to validate
mov		ebx, LIMIT_55
cmp		eax, ebx
jg		Invalid_Num

; Validate user input is less than -88
; If yes the number is invalid, If no the number is valid
mov		ebx, LIMIT_88
cmp		eax, ebx
jl		Invalid_Num

Valid_Num:
; The input is valid, increment loop counter by 1
inc		loopCounter

Minimum_Check:
; Checks if input is the minimum thus far
mov		ebx, minimumInt
cmp		eax, ebx
jge		Maximum_Check				; not the minimum thus far, jump to check maximum
mov		minimumInt, eax

Maximum_Check:
; Checks if input is the maximum thus far
mov		eax, usersInt
mov		ebx, maximumInt
cmp		eax, ebx
jle		Integer_Sum					; not the maximum thus far, jump to add to sum 
mov		maximumInt, eax

Integer_Sum:
; Adds the input to integerSum and jumps to prompt additional input
mov		eax, integerSum
add		eax, usersInt
mov		integerSum, eax
jmp		Prompt_Input

PositiveInteger:
; A number greater than -1 was entered, results are displayed in the following blocks

; checks if the counter was ever incremented ie did the user enter any valid numbers
dec		loopCounter				; counter starts at 1 (for line numbering) decrement to compare
mov		eax, 0
cmp		eax, loopCounter
je		No_Valid_Inputs			; jumps if loopCounter is 0
jmp		Valid_Inputs

No_Valid_Inputs:
; The user did not input any valid numbers; display special message and skip to Parting label
call	Crlf
mov		edx, OFFSET failureMsg
call	WriteString
call	Crlf
jmp	Parting

Valid_Inputs:
; Number of valid inputs is displayed
mov		edx, OFFSET numsEntered
call	WriteString
mov		eax, loopCounter
call	WriteDec
mov		edx, OFFSET validNums
call	WriteString
call	Crlf

; Maximum valid input is displayed 
mov		edx, OFFSET maxNumMsg
call	WriteString
mov		eax, maximumInt
call	WriteInt
call	Crlf

; Minimum valid input is displayed
mov		edx, OFFSET minNumMsg
call	WriteString
mov		eax, minimumInt
call	WriteInt
call	Crlf

; Sum of the valid inputs is displayed 
mov		edx, OFFSET sumNumMsg
call	WriteString
mov		eax, integerSum
call	WriteInt
call	Crlf

; Rounded average of valid inputs is calculated and displayed
mov		eax, integerSum
cdq								; extends sign bit of eax into the edx register
idiv	loopCounter
mov		roundAvg, eax
neg		edx
mov		remainder, edx
mov		eax, loopCounter		; loopCounter will act as the divisor
sub		eax, remainder			; (divisor - remainder) for deciding to round up or down
cmp		eax, remainder			; if (divisor-remainder) > remainder then truncation was valid
jge		Continue
dec		roundAvg				; truncation was not valid, manually round by decrementing 1 

Continue:
; Display the rounded average information
mov		edx, OFFSET roundAvgMsg
call	WriteString
mov		eax, roundAvg
call	WriteInt
call	Crlf

Parting:
; Display the parting message
mov		edx, OFFSET byeUserMsg
call	WriteString
mov		edx, OFFSET userName
call	WriteString
mov		edx, OFFSET byeUserMsg2
call	WriteString
call	Crlf

	exit	; exit to operating system

main ENDP

END main