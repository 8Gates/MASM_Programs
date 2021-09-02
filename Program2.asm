TITLE Fibonacci Numbers

; Author: Chad Smith
; Last Modified: 04/19/2020
; OSU email address: smitcha4@oregonstate.edu
; Course number/section: CS 271
; Project Number: 2                Due Date: 04/19/2020
; Description:
; Display the program title and programmer’s name. Get the user’s name, and greet the user. 
; Prompt the user to enter the number of Fibonacci terms to be displayed. 
; Advise the user to enter an integer in the range [1 .. 46].
; Get and validate the user input (n).
; Calculate and display all of the Fibonacci numbers up to and including the nth term.  
; The results should be displayed 5 terms per line with at least 5 spaces between terms.
; Display a parting message that includes the user’s name, and terminate the program. 

INCLUDE Irvine32.inc

UPPER_LIMIT = 46

.data

authorsIntro		BYTE	"Program 2: Fibonacci Numbers by Chad Smith", 0
userNamePrompt		BYTE	"What's your name? ", 0
greetUserMsg		BYTE	"Nice to meet you ", 0 
instructInput1		BYTE	"Enter the number of Fibonacci terms to be displayed.", 0
instructInput2		BYTE	"Give the number as an integer in the range [1 .. 46].", 0
askNumTermsMsg		BYTE	"How many Fibonacci terms do you want? ", 0
outOfRangeMsg		BYTE	"Out of range. Enter a number in the range [1 .. 46].", 0
byeUserMsg			BYTE	"Thanks for participating. Goodbye ", 0
byeUserMsg2			BYTE	" and have a great day.", 0
extraCredit			BYTE	"**EC: Display the numbers in aligned columns.", 0
extraCredit2		BYTE	"**EC: Implements the use of custom Procedures.", 0
buffer				BYTE	21 DUP(0)		; maximum length for name input (including 0 value)
userName			QWORD	?, 0
usersInteger		DWORD	?
var1				DWORD	0				
var1_copy			DWORD	1
var2				DWORD	1
columnLength		DWORD	?				; white space length after each sequence number
iterationLength		DWORD	?				; length of fibonacci sequence number 
loopCounter			DWORD	0
whiteSpace17		BYTE	17 DUP(" "), 0
whiteSpace16		BYTE	16 DUP(" "), 0
whiteSpace15		BYTE	15 DUP(" "), 0
whiteSpace14		BYTE	14 DUP(" "), 0
whiteSpace13		BYTE	13 DUP(" "), 0
whiteSpace12		BYTE	12 DUP(" "), 0
whiteSpace11		BYTE	11 DUP(" "), 0
whiteSpace10		BYTE	10 DUP(" "), 0
whiteSpace9			BYTE	9 DUP(" "), 0

.code
main PROC

Introduction PROC
; Procedure displays introductory information, gets User's name and greets the User.
; Display programmer's name and program title
call	CrLf
mov		edx, OFFSET authorsIntro
call	WriteString
call	CrLf

; Display extra credit message
mov		edx, OFFSET extraCredit
call	WriteString
call	CrLf
mov		edx, OFFSET extraCredit2
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
Introduction ENDP

UserInstructions PROC
; Procedure displays instructions for the User.
call	CrLf
mov		edx, OFFSET instructInput1
call	WriteString
call	CrLf
mov		edx, OFFSET instructInput2
call	WriteString
call	CrLf
UserInstructions ENDP

GetUserData PROC
; Procedure gets integer from User, loops until User input is within specified range
jmp		GetData

InputRangeError:				; this block runs when user input is out of range
mov		edx, OFFSET outOfRangeMsg
call	WriteString				; display error message 
call	CrLf

GetData:
; Asks for number of terms and stores value in usersInteger
mov		edx, OFFSET askNumTermsMsg
call	WriteString
call	ReadInt
mov		usersInteger, eax
call	CrLf

; Input validation, if x is less than 1, jump back to Input_Range_Error block
mov		eax, usersInteger
mov		ebx, 1
cmp		eax, ebx
jl		InputRangeError

; Input validation, if x is greater than 46, jump back to Input_Range_Error block
mov		eax, usersInteger
mov		ebx, UPPER_LIMIT
cmp		eax, ebx
jg		InputRangeError

; set up loop counter for number of iterations
mov		ecx, usersInteger
GetUserData ENDP

DisplayFibs PROC
; Procedure displays the Fibonacci Sequence in formatted columns

StartFibs:
; copy var1 into var1_copy
mov		eax, var1
mov		ebx, var2
mov		var1_copy, eax 

; move var2 into var1, add var1 and var1_copy, store sum in var2 (next num in Fib sequence)
mov		var1, ebx
add		ebx, var1_copy
mov		var2, ebx		

inc		loopCounter					; increment the loop counter by 1 

; writes number and jumps to write white spaces
mov		eax, var1
call	WriteDec
jmp		WhiteSpace					; this jump is to determine number of trailing white spaces needed 

Continue_2:
; continue looping
loop	StartFibs

; jump to TheEnd to display the parting message 
call	CrlF
jmp		EndingFibs

WhiteSpace:
; determines length of current sequence number and jumps to write whitespaces
cmp		eax, 10
jl		length1
cmp		eax, 100
jl		length2
cmp		eax, 1000
jl		length3
cmp		eax, 10000
jl		length4
cmp		eax, 100000
jl		length5
cmp		eax, 1000000
jl		length6
cmp		eax, 10000000
jl		length7
cmp		eax, 100000000
jl		length8
cmp		eax, 1000000000
jl		length9

; moves whitespaces into edx and jumps to write them thus formatting columns
length1:
mov		edx, OFFSET whiteSpace17
jmp		Continue_1

length2:
mov		edx, OFFSET whiteSpace16
jmp		Continue_1

length3:
mov		edx, OFFSET whiteSpace15
jmp		Continue_1

length4:
mov		edx, OFFSET whiteSpace14
jmp		Continue_1

length5:
mov		edx, OFFSET whiteSpace13
jmp		Continue_1

length6:
mov		edx, OFFSET whiteSpace12
jmp		Continue_1

length7:
mov		edx, OFFSET whiteSpace11
jmp		Continue_1

length8:
mov		edx, OFFSET whiteSpace10
jmp		Continue_1

length9:
mov		edx, OFFSET whiteSpace9

Continue_1:
; writes white spaces 
call	WriteString	

; prints a new line after 5 additional numbers in the sequence have been written
xor		edx, edx			; sets edx register to 0
mov		ebx, 5
div		ebx					; divides eax(loopCounter) by 5 
cmp		edx, 0				; if the remainder is 0, the loop counter is a multiple of 5 
je		NewLine				; jumps to print a new line if counter is a multiple of 5 
jmp		Continue_2

NewLine:
; print new line and continue
call	CrLf
jmp		Continue_2

EndingFibs:
DisplayFibs ENDP

Farewell PROC
; Procedure displays parting message and exits the program
call	CrLf
mov		edx, OFFSET byeUserMsg
call	WriteString
mov		edx, OFFSET userName
call	WriteString
mov		edx, OFFSET byeUserMsg2
call	WriteString
call	CrLf
FareWell ENDP

	exit	; exit to operating system
main ENDP

END main

