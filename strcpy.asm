bits    64
default rel

global  main

extern  scanf
extern  printf

section .data
    format_s    db '%s', 0
    input_adress_format db 'Adress of the input data is: %X', 0xA, 0
    output_format db 'Copied string is: %s', 0xA, 0
    output_adress_format    db 'Adress of the output data is: %X', 0xA, 0

section .bss
    source  resb    1024  
    destination resb 1024

section .text
    main:
        ;setting stack offset
        sub rsp, 8
    
        ;Handling user input
        lea rsi,    [source]
        lea rdi,    [format_s]
        mov al, 0 
        call scanf wrt ..plt

        ;Printing adress of input data for demonstration purposes
        lea rsi, [source]
        lea rdi, [input_adress_format]
        mov al, 0
        call printf wrt ..plt
        
        ;Copying the string
        lea rsi,    [source]
        lea rdi,    [destination]
        mov rcx, 1024
        cld ;Clearing a flag so rep decrements rcx
        REP MOVSB
        mov byte [rdi], 0 ;Terminate with null character
        
        ;Printing from the new location
        lea rsi, [destination]
        lea rdi, [output_format]
        mov al, 0
        call printf wrt ..plt

        ;Print output adress for demonstration purposes
        lea rsi, [destination]
        lea rdi, [output_adress_format]
        mov al, 0
        call printf wrt ..plt

        ;Get rid of the offset, return
        add rsp,    8
        sub rax, rax
        ret
        

