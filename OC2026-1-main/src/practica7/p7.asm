%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   
   
    
    mov edx,ncad
    call puts       ;imprime la cadena

    mov bx, word[len]      ;tamano maximo
    mov edx, cad            ;apunta a la cadena
    call capturar

    mov edx, cad
    call atoi


    mov edi, cadena_salida
    call itoa

    mov edx, resultado
    call puts

    mov edx, cadena_salida
    call puts

    mov edx, nlin
    call puts
    
    mov eax, 1
    mov ebx, 0
    int 0x80


;=======CAPTURAR========
capturar:
    push edx        ;guardar valores
    push cx         ;cx = contador
    push esi        ;esi = indice
    mov cx,bx       ;bx guarda el tamano maximo (64)
    dec cx          ;dec = restar
    mov esi, 0      ; esi = 0 (índice empieza en 0)

.ciclo:
    call getch
    cmp al,127      
    je .salir


    .guardar:
        call putchar       ;imprime el caracter
        mov [edx + esi],al
        cmp al, 0xa
        je .salir           ;si son iguales ve a ssalir
        inc esi             ;aumentar indice
        loop .ciclo

    .salir:
    mov byte[edx + esi], 0
    pop esi
    pop cx
    pop edx
    ret

;-==========ATOI==========

atoi:
    push edx        ;inicio de cadena
    push ecx        ;contador
    push ebx         ;auxiliar

    mov eax, 0      ;resultado = 0
    mov ebx, 1      ;signo 1


    .saltar_espacio:
        mov cl, [edx]
        cmp cl, ' '
        je .avanzar     ;si es 
        cmp cl, 9       ; 9 = tab
        je .avanzar
        cmp cl, '.'
        je .fin
        jmp .signo

    .avanzar:
        inc edx
        jmp .saltar_espacio

    ;=====Verificar signo======
    .signo:
        mov cl, [edx]
        cmp cl, '-'
        jne .verificar_mas
        mov ebx, -1
        inc edx
        jmp .convertir


    .verificar_mas:
        cmp cl, '+'
        jne .convertir
        inc edx
    
    ;=====Convertir=====
    .convertir:
        mov cl,[edx]

    .ciclo:
        cmp cl, '0'
        jb .fin             ;si cl<0 fin
        cmp cl, '9'
        ja .fin             ;si cl>9 fin

        ; MULTIPLICAR *10
        mov ecx, eax
        shl eax, 3          ; x * 8 shl = corrimeinto de bits
        shl ecx, 1          ; x * 2 
        add eax, ecx        ;2 + 8 = 10 -> eax = eax * 10

        movzx ecx, byte[edx]    ;convertir edx (byte = 8bits) a 32 bits (rellena el resto con ceros, para evitar basurra)
        sub ecx, '0'
        add eax, ecx

        inc edx
        mov cl, [edx]
        jmp .ciclo


        ;===FIN====
        .fin:
            cmp ebx, 1      ;si el signo es 1 salir
            je .salir
            neg eax         ; si no es 1 cambiar a negativo

        .salir:
            pop ebx
            pop ecx
            pop edx
            ret

itoa:                  
    push ebx
    push ecx
    push edx

    ;====CASO CERO====
    cmp eax, 0
    jne .verificar_signo

    mov byte[edi], '0'
    inc edi
    mov byte[edi], 0
    jmp .fin

    .verificar_signo:
        cmp eax, 0
        jge .dividir

        mov byte[edi], '-'
        inc edi
        neg eax                 ;cambiar a positivo

    .dividir:
        mov ebx, 10
        mov ecx, 0

    .ciclo:
        xor edx, edx           ;eax->cociente
        div ebx                ;edx->residuo(num a imprimir)
        add dl, '0'            ;dl->parte mas baja de edx(donde esta el num)
        push dx                ;guardar digito
        inc ecx
        cmp eax, 0
        jne .ciclo

    .escribir:
        pop dx
        mov byte[edi], dl
        inc edi
        loop .escribir
    
    mov byte[edi], 0            ;terminar cadena

     

    .fin:
        pop edx
        pop ecx
        pop ebx
        ret



    
section	.data
    ncad db 0xa,'Captura: ',0
    len dw 64
    cad	times 64 db 0
    cadena_salida times 64 db 0
    nlin db 0xa, 0
    resultado db 'Resultado: ',0
   