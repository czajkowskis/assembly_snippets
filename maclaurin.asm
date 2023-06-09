bits 	64
default rel
global  main
extern 	printf
extern 	scanf

section .data
	inputFormat  db '%i %lf', 0
	outputFormat	db 'e^%f = %f', 0xA, 0
	    
	i       dd 1	; loop index
	result	dq 1.0  ; series
	num	dq 1.0 	; numerator
	den	dq 1.0	; denominator

section .bss
	k       resd 1 	
	x       resq 1 	

section .text
	main:
	
		sub 	rsp, 8
		lea 	rdx, [x]
		lea 	rsi, [k]
		lea 	rdi, [inputFormat]
		mov 	al, 0
		call 	scanf wrt ..plt
		mov 	eax, [k]	; store the number of components(k) in eax
			
	calculateMaclaurin:
	
		movlpd 	xmm2, [num]
		mulsd  	xmm2, [x]	; numerator *= x
		movlpd 	[num], xmm2
		
		movss   xmm3, [i]
		CVTDQ2PD xmm3, xmm3	; converts int to double
		movlpd 	xmm4, [den]	; denominator *= i
		mulsd  	xmm4, xmm3
		movlpd 	[den], xmm4
		
		movlpd 	xmm5, [result]
		divsd 	xmm2, xmm4	; series += numerator / denominator
		addsd  	xmm5, xmm2
		movlpd 	[result], xmm5
		
		
		cmp 	eax, [i]	; check if k < i, if yes print the result
		jl  	printResult
		mov 	rcx,[i]	
		inc 	rcx		; increment i
		mov 	[i], rcx
		jmp 	calculateMaclaurin
		
		
	printResult:
	
		movlpd  xmm0, [x]
		movlpd 	xmm1, [result]
		lea    	rdi,  [outputFormat]
		mov    	al, 2
		call 	printf wrt ..plt
	
	
	return:   
	                      
	    	mov     rax, 0              
	    	add     rsp, 8  
	    	ret