TITLE Program 1: Elementary Arithmetic

; Author: Chad Smith
; Last Modified: 04/12/2020
; OSU email address: smitcha4@oregonstate.edu
; Course number/section: CS 271
; Project Number: 1                Due Date: 04/12/2020
; Description:
; 1. Display your name and program title on the output screen. 
; 2. Display instructions for the user. 
; 3. Prompt the user to enter three numbers (A, B, C) in descending order. 
; 4. Calculate and display the sum and differences: (A+B, A-B, A+C, A-C, B+C, B-C, A+B+C). 
; 5. Display a terminating message.

INCLUDE Irvine32.inc

.data

extra_credit_1		BYTE	"**EC: Program repeats until the user chooses to quit.", 0
extra_credit_2		BYTE	"**EC: Program checks if numbers are in non-descending order.", 0
extra_credit_3		BYTE	"**EC: Handles negative results and computes B-A, C-A, C-B, C-B-A.", 0

authorsIntro		BYTE	"Program 1: Elementary Arithmetic by Chad Smith", 0
userInstructions	BYTE	"Enter 3 numbers A > B > C, and I'll display the sums and differences.", 0
numberPrompt_A		BYTE	"First number: ", 0
numberPrompt_B		BYTE	"Second number: ", 0
numberPrompt_C		BYTE	"Third number: ", 0
continue_prompt		BYTE	"Enter '1' to continue or '0' to exit.", 0
error_descending	BYTE	"ERROR: The numbers are not in descending order! ", 0
terminate			BYTE	"Terminating program..Good-bye", 0

plus				BYTE	" + ", 0
minus				BYTE	" - ", 0
equals				BYTE	" = ", 0
A_sub_C_Message		BYTE	"A-C=", 0
B_add_C_Message		BYTE	"B+C=", 0
B_sub_C_Message		BYTE	"B-C=", 0
sum_ABC_Message		BYTE	"A+B+C=", 0

number_A			DWORD		?
number_B			DWORD		?
number_C			DWORD		?
A_add_B				DWORD		?
A_sub_B				DWORD		?
A_add_C				DWORD		?
A_sub_C				DWORD		?
B_add_C				DWORD		?
B_sub_C				DWORD		?
sum_ABC				DWORD		?

; Extra Credit Variables
B_sub_A				DWORD		?
C_sub_A				DWORD		?
C_sub_B				DWORD		?
sub_CBA				DWORD		?

.code
main PROC


beginning:		; the starting point of loop if the user would like to replay the program

	; Display programmer's name, program title and extra credit done
	call	CrLf
	mov		edx, OFFSET authorsIntro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_credit_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_credit_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_credit_3
	call	WriteString
	call	CrLf
	call	CrLf

	; Display instructions for the user
	mov		edx, OFFSET userInstructions
	call	WriteString
	call	CrLf

	; Prompt user for first number and store in number_A
	call	CrLf
	mov		edx, OFFSET numberPrompt_A
	call	WriteString
	call	ReadInt
	mov		number_A, eax

	; Prompt user for second number and store in number_B
	mov		edx, OFFSET numberPrompt_B
	call	WriteString
	call	ReadInt 
	mov		number_B, eax

	; Prompt user for third number and store in number_C
	mov		edx, OFFSET numberPrompt_C
	call	WriteString
	call	ReadInt
	mov		number_C, eax
	call	CrLf

	; compares A nd B for descending order 
	mov		eax, number_A
	mov		ebx, number_B
	cmp		ebx, eax
	jnl		not_descending				; if ebx is not less than eax then jump to not_descending
	
	; compares B and C for descending order 
	mov		eax, number_B
	mov		ebx, number_C
	cmp		ebx, eax			
	jnl		not_descending				; if ebx is not less than eax then jump to not_descending

; ************************************** A+B Section **************************************
	mov		eax, number_A
	add		eax, number_B			
	mov		A_add_B, eax				; stores A+B in A_add_B
	
	; Displays either unsigned number_A or signed number_A
	mov		eax, number_A
	cmp		eax, 0						; determines if number_A is negative
	jl		A_Is_Negative				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_1				
A_Is_Negative:						
	call	WriteInt


Continue_1:	
	; Displays plus sign and either unsigned number_B or signed number_B
	mov		edx, OFFSET plus
	call	WriteString				
	mov		eax, number_B
	cmp		eax, 0						; determines if number_B is negative
	jl		B_Is_Negative				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_2
B_Is_Negative:
	call	WriteInt


Continue_2:
	; Displays equals sign and either unsigned A_add_B or signed A_add_B
	mov		edx, OFFSET equals
	call	WriteString				
	mov		eax, A_add_B
	cmp		eax, 0						; determines if A_add_B is negative
	jl		A_add_B_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_3
A_add_B_Is_Negative:
	call	WriteInt

; ************************************** A-B Section **************************************
Continue_3:
	; Calculates A-B
	mov		eax, number_A
	sub		eax, number_B
	mov		A_sub_B, eax				; stores A-B in A_sub_B
	call	CrLf

	; Displays either unsigned number_A or signed number_A
	mov		eax, number_A
	cmp		eax, 0						; determines if number_A is negative
	jl		A_Is_Negative1				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_4				
A_Is_Negative1:						
	call	WriteInt


Continue_4:
	; Displays minus sign and either unsigned number_B or signed number_B
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number_B
	cmp		eax, 0						; determines if number_B is negative
	jl		B_Is_Negative1				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_5
B_Is_Negative1:
	call	WriteInt


Continue_5:
	; Displays equals sign and either unsigned A_sub_B or signed A_sub_B
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, A_sub_B
	cmp		eax, 0						; determines if A_sub_B is negative
	jl		A_sub_B_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_6
A_sub_B_Is_Negative:
	call	WriteInt

; ************************************** A+C Section **************************************
Continue_6:
	; Calculates A+C
	mov		eax, number_A
	add		eax, number_C
	mov		A_add_C, eax				; stores A+C in A_add_C
	call	CrLf

	; Displays either unsigned number_A or signed number_A
	mov		eax, number_A
	cmp		eax, 0						; determines if number_A is negative
	jl		A_Is_Negative3				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_7
A_Is_Negative3:
	call	WriteInt

Continue_7:
	; Displays plus sign and either unsigned number_C or signed number_C
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, number_C
	cmp		eax, 0						; determines if number_C is negative
	jl		C_Is_Negative				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_8
C_Is_Negative:
	call	WriteInt

Continue_8:
	; Displays equal sign either unsigned A_add_C or signed A_add_C
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, A_add_C
	cmp		eax, 0						; determines if A+C is negative
	jl		A_add_C_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_9
A_add_C_Is_Negative:
	call	WriteInt

; ************************************** A-C Section **************************************
Continue_9:
	; Calculates A-C
	mov		eax, number_A
	sub		eax, number_C			
	mov		A_sub_C, eax				; stores A-C in A_sub_C
	call	CrLf
	; ; Displays either unsigned number_A or signed number_A
	mov		eax, number_A
	cmp		eax, 0						; determines if number_A is negative
	jl		A_Is_Negative4				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_10				
A_Is_Negative4:						
	call	WriteInt

Continue_10:
	; Displays minus sign and either unsigned number_C or signed number_C
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number_C
	cmp		eax, 0						; determines if number_C is negative
	jl		C_Is_Negative1				; if negative jump to display the signed int
	call	WriteDec					; if negative jump to display the signed int
	call	Continue_11
C_Is_Negative1:
	call	WriteInt

Continue_11:
	; Displays equal sign and either unsigned A_sub_C or signed A_sub_C
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, A_sub_C
	cmp		eax, 0						; determines if A_sub_B is negative
	jl		A_sub_C_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_12
A_sub_C_Is_Negative:
	call	WriteInt

	; ************************************** B+C Section **************************************
Continue_12:
	; Calculates B+C
	mov		eax, number_B
	add		eax, number_C
	mov		B_add_C, eax				; stores B+C in B_add_C
	call	CrLf	
	
	; Displays either unsigned number_B or signed number_B
	mov		eax, number_B
	cmp		eax, 0						; determines if number_B is negative
	jl		B_Is_Negative2				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_13
B_Is_Negative2:
	call	WriteInt

Continue_13:
	; Displays plus sign and either unsigned number_C or signed number_C
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, number_C
	cmp		eax, 0						; determines if number_C is negative
	jl		C_Is_Negative2				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_14
C_Is_Negative2:
	call	WriteInt

Continue_14:
	; Displays equal sign and either unsigned B_add_C or signed B_add_C
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, B_add_C
	cmp		eax, 0						; determines if B+C is negative
	jl		B_add_C_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_15
B_add_C_Is_Negative:
	call	WriteInt

	; ************************************** B-C Section **************************************
Continue_15:
	; Calculates B-C
	mov		eax, number_B
	sub		eax, number_C
	mov		B_sub_C, eax				; stores B-C in in B_sub_C 
	call	CrLf

	; Displays either unsigned number_B or signed number_B
	mov		eax, number_B
	cmp		eax, 0						; determines if number_B is negative
	jl		B_Is_Negative3				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_16
B_Is_Negative3:
	call	WriteInt

Continue_16:
	; Displays minus sign and either unsigned number_C or signed number_C
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number_C
	cmp		eax, 0						; determines if number_C is negative
	jl		C_Is_Negative3				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_17
C_Is_Negative3:
	call	WriteInt

Continue_17:
	; Displays equal sign and either unsigned B_sub_C or signed B_sub_C
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, B_sub_C
	cmp		eax, 0						; determines if B-C is negative
	jl		B_sub_C_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	CrLf
	call	Continue_18
B_sub_C_Is_Negative:
	call	WriteInt
	call	CrLf

	; ************************************** A+B+C Section **************************************
Continue_18:
	; Calculates A+B+C
	mov		eax, A_add_B
	add		eax, number_C
	mov		sum_ABC, eax				; stores A+B+C in sum_ABC
	
	; Displays either unsigned number_A or signed number_A
	mov		eax, number_A		
	cmp		eax, 0						; determines if number_A is negative
	jl		A_Is_Negative5				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_19
A_Is_Negative5:
	call	WriteInt

Continue_19:
	; Displays plus sign and either unsigned number_B or signed number_B
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, number_B
	cmp		eax, 0						; determines if number_B is negative
	jl		B_Is_Negative4				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_20
B_Is_Negative4:
	call	WriteInt

Continue_20:
	; Displays plus sign and either unsigned number_C or signed number_C
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, number_C
	cmp		eax, 0						; determines if number_C is negative
	jl		C_Is_Negative4				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_21
C_Is_Negative4:
	call	WriteInt

Continue_21:
	; Displays equal sign and either unsigned sum_ABC or signed sum_ABC
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sum_ABC
	cmp		eax, 0						; determines if A+B+C is negative
	jl		Sum_ABC_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_22
Sum_ABC_Is_Negative:
	call	WriteInt

; Proceeding to Extra Credit Portion 3.2 handling B-A, C-A, C-B, C-B-A

; ************************************** B-A Section **************************************
Continue_22:
	; Calculates B-A
	call	CrLf
	mov		eax, number_B
	sub		eax, number_A
	mov		B_sub_A, eax				; stores B-A in B_sub_A
	call	CrLf
	
	; Displays either unsigned number_B or signed number_B
	mov		eax, number_B
	cmp		eax, 0						; determines if number_B is negative
	jl		B_Is_Negative5				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_23			
B_Is_Negative5:						
	call	WriteInt

Continue_23:
	; Displays minus sign and either unsigned number_A or signed number_A
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number_A
	cmp		eax, 0						; determines if number_A is negative
	jl		A_Is_Negative6				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_24
A_Is_Negative6:
	call	WriteInt

Continue_24:
	; Displays equal sign and either unsigned B_sub_A or signed B_sub_A
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, B_sub_A
	cmp		eax, 0						; determines if B-A is negative
	jl		B_sub_A_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_25
B_sub_A_Is_Negative:
	call	WriteInt

; ************************************** C-A Section **************************************
Continue_25:
	; Calculates C-A
	mov		eax, number_C
	sub		eax, number_A
	mov		C_sub_A, eax				; stores C-A in C_sub_A 
	call	CrLf
	
	; Displays either unsigned number_C or signed number_C
	mov		eax, number_C
	cmp		eax, 0						; determines if number_C is negative
	jl		C_Is_Negative5				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_26			
C_Is_Negative5:						
	call	WriteInt

Continue_26:
	; Displays minus sign and either unsigned number_A or signed number_A
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number_A
	cmp		eax, 0						; determines if number_A is negative
	jl		A_Is_Negative7				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_27
A_Is_Negative7:
	call	WriteInt

Continue_27:
	; Displays equal sign and either unsigned C_sub_A or signed C_sub_A
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, C_sub_A
	cmp		eax, 0						; determines if C-A is negative
	jl		C_sub_A_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_28
C_sub_A_Is_Negative:
	call	WriteInt

; ************************************** C-B Section **************************************
Continue_28:
	; Calculates C-B
	mov		eax, number_C
	sub		eax, number_B
	mov		C_sub_B, eax				; stores C-B in C_sub_B
	call	CrLf
	
	; Displays either unsigned number_C or signed number_C
	mov		eax, number_C
	cmp		eax, 0						; determines if number_C is negative
	jl		C_Is_Negative6				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_29				
C_Is_Negative6:						
	call	WriteInt

Continue_29:
	; Displays minus sign and either unsigned number_B or signed number_B
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number_B
	cmp		eax, 0						; determines if number_B is negative
	jl		B_Is_Negative6				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_30
B_Is_Negative6:
	call	WriteInt

Continue_30:
	; Displays equal sign and either unsigned C_sub_B or signed C_sub_B
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, C_sub_B
	cmp		eax, 0						; determines if C-B is negative
	jl		C_sub_B_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_31
C_sub_B_Is_Negative:
	call	WriteInt

; ************************************** C-B-A Section **************************************
Continue_31:
	; Calculates C-B-A
	call	CrLf
	mov		eax, C_sub_B
	sub		eax, number_A
	mov		sub_CBA, eax				; stores C-B-A in sub_CBA

	; Displays either unsigned number_C or signed number_C
	mov		eax, number_C
	cmp		eax, 0						; determines if number_C is negative
	jl		C_Is_Negative7				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_32
C_Is_Negative7:
	call	WriteInt

Continue_32:
	; Displays minus sign and either unsigned number_B or signed number_B
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number_B			
	cmp		eax, 0						; determines if number_B is negative
	jl		B_Is_Negative7				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_33
B_Is_Negative7:
	call	WriteInt

Continue_33:
	; Displays minus sign and either unsigned number_A or signed number_A
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, number_A			
	cmp		eax, 0						; determines if number_A is negative
	jl		A_Is_Negative8				; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	Continue_34
A_Is_Negative8:
	call	WriteInt

Continue_34:
	; Displays equal sign and either unsigned sub_CBA or signed sub_CBA
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sub_CBA
	cmp		eax, 0						; determines if C-B-A is negative
	jl		sub_CBA_Is_Negative			; if negative jump to display the signed int
	call	WriteDec					; if positive display the unsigned int
	call	CrLf
	call	Continue_35
Sub_CBA_Is_Negative:
	call	WriteInt
	call	CrLf

Continue_35:
	; asks if user would like to continue or exit the program
	call	CrLf
	mov		edx, OFFSET continue_prompt
	call	WriteString
	call	ReadInt
	cmp		eax, 1						; compares user input in eax register to 1
	jl		exiting						; if the previous comparison was 'less than' then jump to exiting:
	jmp		beginning					; the comparison was not less than therefore jump to beginning:


exiting: 
	; Display the terminating message
	mov		edx, OFFSET terminate
	call	WriteString
	call	CrLf

	exit								; exit to operating system

not_descending:
	; this portion of code is reached when B is not less than A, and/or C is not less than B
	call	CrLf
	mov		edx, OFFSET error_descending	
	call	WriteString					; displays the not descending error message 
	call	CrLf
	mov		edx, OFFSET terminate		
	call	WriteString
	call	CrLf

	exit								; exit the operating system

main ENDP

END main