TITLE Sort & Count Random Integers 

; Author: Chad Smith
; Last Modified: 05/19/2020
; OSU email address: smitcha4@oregonstate.edu
; Course number/section: CS 271
; Project Number: 5                Due Date: 05/24/2020
; Description: Generates 200 random numbers in the range of 10-23 (inclusive), displays the list,
; sorts the list, displays the median value, displays the list sorted in ascending order, and then
; displays the number of instances of each value in the list. 

INCLUDE Irvine32.inc

; define constants
LO = 10
HI = 29
RANGE = HI-LO+1
ARRAYSIZE = 200

.data

; Messages to be displayed to user 
titleMsg		BYTE	"Sorting & Counting Random Integers!", 0
authorMsg		BYTE	"Programmed by Chad Smith", 0
instructMsg1	BYTE	"This program generates 200 random numbers in the range [10 ... 29], displays", 0
instructMsg2	BYTE	"the original list, sorts the list, displays the median value, displays the", 0
instructMsg3	BYTE	"list sorted in ascending order then the number of instances of each value.", 0
unsortedMsg		BYTE	"Your unsorted random numbers:", 0
medianMsg		BYTE	"List Median: ", 0
sortedMsg		BYTE	"Your sorted random numbers:", 0
instancesMsg	BYTE	"Your list of instances of each number, starting with the number of 10s:", 0
goodbyeMsg		BYTE	"Goodbye and thanks for using my program!", 0 

; Arrays and double space for formatting 
array			DWORD	ARRAYSIZE DUP(?)
counts          DWORD   RANGE DUP(0)
twoSpace		BYTE	"  ", 0

.code
main PROC

; push messages to be displayed on the stack and call Introduction procedure
push	OFFSET titleMsg		; ebp + 24
push	OFFSET authorMsg	; ebp + 20
push	OFFSET instructMsg1 ; ebp + 16
push	OFFSET instructMsg2 ; ebp + 12
push	OFFSET instructMsg3 ; ebp + 8
call	introduction

; push arguments and call fillArray
push	OFFSET array		; ebp + 24
push	LO					; ebp + 20
push	HI					; ebp + 16
push	ARRAYSIZE			; ebp + 12
push	RANGE				; ebp + 8
call	fillArray

; push arguments and call displayList
push	OFFSET array		; ebp + 16
push	ARRAYSIZE			; ebp + 12	
push	OFFSET unsortedMsg	; ebp + 8
call	displayList

; push arguments and call sortList
push	OFFSET array		; ebp + 12
push	ARRAYSIZE			; ebp + 8
call	sortList

; push arguments and call diplsayMedian
push    OFFSET medianMsg    ; ebp + 16 
push    OFFSET array        ; ebp + 12
push    ARRAYSIZE           ; ebp + 8
call	displayMedian

; push arguments and call displayList
push	OFFSET array		; ebp + 16
push	ARRAYSIZE			; ebp + 12	
push	OFFSET sortedMsg	; ebp + 8
call	displayList

; push arguments and call countList
push    OFFSET array        ; ebp + 24
push    ARRAYSIZE           ; ebp + 20
push    OFFSET counts       ; ebp + 16
push    LO                  ; ebp + 12
push    RANGE               ; ebp + 8 
call	countList

; push arguments and call displayList
push	OFFSET counts		; ebp + 16
push	RANGE   			; ebp + 12	
push	OFFSET instancesMsg	; ebp + 8
call	displayList

	exit	; exit to operating system
main ENDP

;-----------------------------------------------------------------------------------------------
;Introduction
;
;Description: Displays the title, author's name and program information to the user.
;
;Preconditions: N/A 
;
;Postconditions: N/A
;
;Receives: titleMsg, authorMsg, instructMsg1, instructMsg2 and instructMsg3 should all 
;have been pushed on the stack prior to the procedure call.
;
;Returns: N/A
;-----------------------------------------------------------------------------------------------
introduction PROC
; save registers
push	ebp
mov		ebp, esp
push	edx

; display titleMsg
mov		edx, [ebp+24]
call	WriteString
call	Crlf

; display authorMsg
mov		edx, [ebp+20]
call	WriteString
call	Crlf

; display instructMsg1
mov		edx, [ebp+16]
call	WriteString
call	Crlf

; display instructMsg2
mov		edx, [ebp+12]
call	WriteString
call	Crlf

; display instructMsg3
mov		edx, [ebp+8]
call	WriteString
call	Crlf

; restore registers 
pop		edx
pop		ebp
ret
introduction ENDP


;-----------------------------------------------------------------------------------------------
;fillArray
;
;Description: Accepts a low, high and range integer. Accepts an array and an arraz size integer.
;  Fills the array with random integers in the range provided given various arguments. 
;
;Preconditions: HI argument must be greater than LO. The array provided should be at least the 
;  size of the ARRAYSIZE argument.
;
;Postconditions: N/A
;
;Receives: the offset of an array, LO (integer 10), HI (integer 29), ARRAYSIZE (integer 200) and
;  RANGE(integer 20)
;
;Returns: array is returned filled with integers between 10 and 29 (inclusive)
;  
;-----------------------------------------------------------------------------------------------
fillArray PROC
; save registers 
push	ebp
mov		ebp, esp
push	eax
push	ebx
push	ecx
push	esi

call	Randomize		; call only once to initialize the sequence using the system's clock
mov		ecx, [ebp+12]	; loop counter set to ARRAYSIZE (200)
mov		esi, [ebp+24]	; address of the array in esi

loop1:
mov		eax, [ebp+8]	; RANGE (HI-LO+1) added to eax
call	RandomRange
add		eax, [ebp+20]	; LO added to random num to have num between 10 and 29 in eax
mov		ebx, eax		; value to be added to array in ebx
mov		[esi], ebx		; ebx added to array 
add		esi, 4			; incrememnt memory location for array 
loop	loop1

; restore registers 
pop		esi
pop		ecx
pop		ebx
pop		eax
pop		ebp
ret
fillArray ENDP


;-----------------------------------------------------------------------------------------------
;sortList
;
;Description: accepts an array and ARRAYSIZE then returns the array sorted in ascending order 
;
;Preconditions: the passed array should be filled with integers. The ARRAYSIZE should be an
;  integer value that is equal to the number of elements in the array argument.
;
;Postconditions: N/A
;
;Receives: the offset of an array and ARRAYSIZE (integer 200)
;
;Returns: the received array is returned sorted in ascending order
;-----------------------------------------------------------------------------------------------
sortList PROC
; push registers for storage 
push    ebp
mov     ebp, esp
push    eax
push	ebx
push    ecx
push    edx
push    esi

mov		ecx, [ebp+8]        ; set outer loop to iterate once for each element 

OuterLoop:
mov		edx, ecx            ; store ecx for OuterLoop
mov		ecx, [ebp+8]
dec		ecx					; ecx loop counter = 199
mov		esi, [ebp+12]		; array memory address
add		esi, 4				; get 1st element in array 

InnerLoop:
mov		eax, [esi]		    ; eax holds element in back (1 index position behind ebx)
sub     esi, 4
mov     ebx, [esi]          ; ebx holds element in front (1 index position in front of eax)
add     esi, 4
cmp		eax, ebx            ; if eax is greater than ebx a swap will not take place 
jg		Continue

; swap the index values, [n] becomes [n-1] while [n-1] becomes [n]
sub     esi, 4
push    [esi]
push    eax
pop     [esi]
add     esi, 4
pop     [esi]

Continue:
add		esi, 4              ; move forward in the array 
loop	InnerLoop
mov		ecx, edx			; restore loop counter for Outer Loop
loop	OuterLoop

; restore all registers 
pop     esi
pop     edx
pop     ecx
pop		ebx
pop     eax
pop		ebp
RET
sortList ENDP


;-----------------------------------------------------------------------------------------------
;displayMedian
;
;Description: Accepts an array of size 200 filled with integers and displays the median number 
;	rounded to the nearest whole number. 
;
;Preconditions: the array must be a size of 200 filled with integers.  
;
;Postconditions: N/A 
;
;Receives: the offset of medianMsg (string), the offset of the array and ARRAYSIZE integer value 
;
;Returns: N/A
;-----------------------------------------------------------------------------------------------
displayMedian PROC
; save registers 
push    ebp
mov     ebp, esp
push    eax
push    ebx
push    edx
push    esi

; array location in esi and message in edx
mov     esi, [ebp+12]
mov     edx, [ebp+16]
call    Crlf
call    WriteString 

; median of 200 is average of elements n/2 and n/2+1 (396 and 400 incremented positions from ebp)
add     esi, 396            ; 1st middle value in esi
mov     eax, [esi]
add     esi, 4              ; 2nd middle value in esi
add     eax, [esi]
mov     ebx, 2              ; ebx set to 2 for division and in turn the median
xor     edx, edx
div     ebx

; if there is no remainder no rounding need occur, if the remainder is 1 of 2 round up 1
mov     ebx, 0
cmp     edx, ebx
je      PrintMedian         ; remainder is 0, do not round up 
inc     eax                 ; rounding up, the remainder is 1 with a divisor of 2 

PrintMedian:
; print median number of list to screen 
call    WriteDec

; restore registers 
pop     esi
pop     edx
pop     ebx
pop     eax
pop     ebp
ret
displayMedian ENDP


;-----------------------------------------------------------------------------------------------
;displayList
;
;Description: displays a message to the user and displays the array argument,  20 numbers per 
;	line with two spaces between each integer. 
;
;Preconditions: for correct formatting integers in array should have a ones place and tens place
;	ARRAYSIZE integer should be the size of the array.
;
;Postconditions: N/A 
;
;Receives: offset of an array, ARRAYSIZE integer value and OFFSET of unsortedMsg string
;
;Returns: N/A
;-----------------------------------------------------------------------------------------------
displayList PROC
; save registers 
push	ebp
mov		ebp, esp
push	eax
push	ecx
push	edx
push	esi
push	edi

; move location of parameters into registers 
mov		edx, [ebp+8]	; message to be displayed stored in edx
call	Crlf
call	WriteString
mov		ecx, [ebp+12]	; loop counter set to ARRAYSIZE
mov		edi, [ebp+16]	; address of the array in edi

displayLoop:
; evaluates if a new line is needed
xor		edx, edx
mov		eax, ecx		; move loop counter to eax
mov		esi, 20			; if loop counter is divisible by 20 a new line is to be displayed 
div		esi
cmp		edx, 0
je		NewLine			; jump to display a new line 
jmp		Continue

NewLine:
call	Crlf

Continue:
; displays the element to the screen followed by 2 spaces
mov		eax, [edi]
call	WriteDec
mov		edx, OFFSET twoSpace
call	WriteString

; incrememnt memory location for array and start next iteration of loop
add		edi, 4
loop	displayLoop
call    Crlf

; restores registers
pop		edi
pop		esi
pop		edx
pop		ecx
pop		eax
pop		ebp
ret
displayList ENDP


;-----------------------------------------------------------------------------------------------
;countList
;
;Description: Fills and returns the array counts with integer values. These integers represent 
;	the number of times a value is seen in the array parameter. 
;
;Preconditions: array argument should be filled with integers, ARRAYSIZE should be equal to the
;	size of array, HI should be an integer value greater than the integer value of LO. 
;
;Postconditions: N/A
;
;Receives: offset of the array, ARRAYSIZE integer value, offset of counts array, LO integer
;	value and RANGE integer value. 
;
;Returns: counts array is returned filled with integer values
;-----------------------------------------------------------------------------------------------
countList PROC
; save registers 
push    ebp
mov     ebp, esp
push	eax
push	ebx
push	ecx
push	edx
push	esi
push	edi


mov     ecx, [ebp+8]        ; set counter to RANGE (20)
mov     esi, [ebp+24]       ; get address of array in to esi
mov     edi, [ebp+16]       ; get address of counts array in to edi 
mov     eax, [ebp+12]       ; get LO into eax, this is the comparison value used for counting 

countOuterLoop:
; loops 20 times, filling the counts array with ebx from inner loop

; initialize registers for inner loop and save register for outer loop
mov     ebx, 0              ; counts number of times number appears in array 
push    ecx                 ; save countOuterLoop counter
push    eax
push    esi
mov     ecx, [ebp+20]       ; set inner loop counter to ARRAYSIZE (200)  

countInnerLoop:
; loops 200 times, each element for comparison with eax is stored in edx 
mov     edx, [esi]
cmp     eax, edx
jne     ContinueCountInnerLoop 
inc     ebx                 ; eax and edx are a match, increment counter to be stored in counts array

ContinueCountInnerLoop:
; move forward in array and start the next iteration of innerloop
add     esi, 4
loop    countInnerLoop

; innerLoop has ended, restore needed registers excluding ebx 
pop     esi
pop     eax                 
pop     ecx

mov     [edi], ebx          ; filling counts array 
add     edi, 4              ; move to next element in counts array 
inc     eax                 ; eax 1st value is 10 and last value is 29
loop    countOuterLoop

; restore registers 
pop		edi
pop		esi
pop		edx
pop		ecx
pop		ebx
pop		eax
pop     ebp
ret
countList ENDP

END main
