bits    64
default rel

global  main

extern scanf
extern  printf

section .data
    input_prompt db 'Enter up to 100 numbers (end input by entering nonnumerical character):  ', 0xA, 0
    input_format db '%d', 0
    output_prompt db 'Sorted array:', 0xA, 0
    output_format db '%d ', 0
section .bss
    int_array resd 100
    array_length resq 1
section .text
    main:
        ;Setting stack offset
        sub rsp, 8

        ;Printing input_prompt
        lea rdi, [input_prompt]
        mov al, 0           ;0 floating point arguments
        call printf wrt ..plt
        
        ;Handling input
        lea r14, [int_array] ; r14 stores the adress of the first element in the array
        mov r15, 0        ; r15 stores current index

        INPUT_LOOP:
            lea rsi, [r14 + r15*4]; each iteration 4(size of int) is added to the adress
            lea rdi, [input_format]
            mov al, 0
            call scanf wrt ..plt
            cmp rax, 0 ; compare return value of scanf with 0 -> jump if end of input
            je SORT_ARRAY
            inc r15 ;increment current index
            cmp r15, 100 ;compare current length of the array with max_length -> jump if full
            je  SORT_ARRAY
            jmp INPUT_LOOP       

        SORT_ARRAY:
            mov QWORD[array_length], r15 ;save the length of the array in memory
            mov r8, 0 ;index of the outer loop (i) is stored in r8
            OUTER_LOOP:
                mov rcx, QWORD[array_length] ;set second index(j) to the length of the array for another loop
                dec rcx ;decrement length by one to handle index 0
                INNER_LOOP:
                    cmp rcx, r8 ;compare j and i -> if j is less or equal than i begin new outer loop
                    jle NEXT_OUTER

                    lea r10, [r14 + rcx * 4] ; get adress of j-th element in the array
                    mov r11D, DWORD [r10] ; access j-th element in an array
                    mov r12D, DWORD [r10-4]; access j-1 element in an array
                    cmp r11D,  r12D ;check if value at arr[j] is greater or equal arr[j-1] -> if yes loop, if not swap
                    jge NEXT_INNER
               
                    XCHG [r10-4], r11D
                    XCHG [r10], r11D
                    jmp NEXT_INNER

        NEXT_INNER:
        dec rcx ; decrement j
        jmp INNER_LOOP

        NEXT_OUTER:
        inc r8 ; increment i
        cmp r8, [array_length] ;check if sorting was performed for all elements, if not -> continue sorting
        jl OUTER_LOOP


        ;Print output prompt
        lea rdi, [output_prompt]
        mov al, 0 ;0 floating point arguments
        call printf wrt ..plt

        ;Print the sorted array
        mov r13, QWORD[array_length] ;store array_length in r15.
        sub r15, r15
        PRINT_LOOP:
            lea rbx, [r14 + r15*4] ;each iteration add 4 (size of int) to the adress
            mov rsi, [rbx]
            lea rdi, [output_format]
            mov al, 0
            call printf wrt ..plt
            inc r15
            cmp r15, r13 ;compare current iteration number with array_length -> if less print next number, otherwise finish
            jl PRINT_LOOP
            jmp END_AND_RETURN
                    
        END_AND_RETURN:
            add rsp,    8 ;get rid of the offset and return
            sub rax, rax
            ret