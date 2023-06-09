bits    64                    
default rel                  

global  main                 
extern  printf               
extern  scanf                

section .data                
    	inputFormat	db '%lf', 0
    	result db '%f^(1/2) = %f', 0xA, 0 ; output format
	increment dq 0.125

section .bss                 
	input resq 1             

section .text                
	main:                        
	    sub     rsp, 8           
	    lea     rdi, [inputFormat]  
	    lea     rsi, [input]        
	    mov     al, 0               ; al - number of float values to read
	    call    scanf wrt ..plt     

	    sub     rdx, rdx            
	    movq    xmm6, rdx           
	    movlpd  xmm7, [increment]   
	    movlpd  xmm5, [input]       

	loop:                           
	    movsd    xmm0, xmm6	       	; current value copied to xmm0
    	sqrtsd   xmm1, xmm0		; the result is in xmm1
	    lea     rdi, [result]     	
	    mov     al, 2               
	    call    printf wrt ..plt   	

	    movsd   xmm0, xmm6          ; copy value again, because printf changes the value in xmm0
	    cmpltsd xmm0, xmm5		; check if xmm0 < xmm1
	    movq    rax, xmm0           ; copy the comparison result to RAX
	    cmp     rax, -1            	; if rax = -1 then set ZF = 1
	    addsd   xmm6, xmm7          ; add increment
	    jz      loop                ; loop if ZF flag is set

	return:                         
	    mov     rax, 0              
	    add     rsp, 8              
	    ret                          

