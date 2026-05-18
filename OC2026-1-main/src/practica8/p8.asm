%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   
   
; ======Capturar numeros =====
mov ecx, 5              ;contador
mov edi, arreglo
call capturar_arreglo


; =====mostrar arreglo=====
mov edx, nlin
call puts

mov edx, original
call puts

mov edx, nlin
call puts

mov ecx, 5
mov edi, arreglo
call mostrar_arreglo

;====ordenar arreglo===
mov ecx, 5
mov edi, arreglo
call ordenar

;======Arreglo ordenado====
mov edx, nlin
call puts

mov edx, ordenado
call puts

mov edx, nlin
call puts

mov ecx, 5
mov edi, arreglo
call mostrar_arreglo

;salida 
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
    jne .guardar


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
            pop edx
            pop ecx
            pop ebx
            ret

;=========ITOA========
itoa:                  
       
    push ebx
    push ecx
    push edx

        ;====CASO 0====
        cmp eax, 0
        jne .continuar

        mov byte[edi], '0'
        inc edi
        mov byte[edi], 0
        jmp .fin

        .continuar:
            ;===signo====
            cmp eax, 0
            jge .positivo

            neg eax
            mov byte[edi], '-'
            inc edi

        .positivo:
            mov ebx, 10
            mov ecx, 0      ;contador

        .ciclo:
            xor edx, edx
            div ebx

            add dl, '0'
            push dx
            inc ecx

            cmp eax, 0
            jne .ciclo
                
        ;==Sacar de la pila====
        .escribir:
            pop dx
            mov [edi], dl 
            inc edi
            loop .escribir

            ;==FIN DE CADENA===
            mov byte [edi], 0

        .fin:

        pop edx
        pop ecx
        pop ebx
        ret

;=======CAPTURAR ARREGLO======
capturar_arreglo:
    push ecx
    push edi

.ciclo:
    mov edx, ncad
    call puts

    mov bx, word[len]
    mov edx, cad
    call capturar

    mov edx, cad
    call atoi

    mov [edi], eax
    add edi, 4
    
    loop .ciclo

    pop edi
    pop ecx
    ret





;========ORDENAR_ARREGLO======
ordenar:

    push ecx
    push edi
    push esi
    push edx

    mov ecx, 4      

.repetir:
    mov esi, edi        ;inicio de arreglo
    mov edx, 4          ;contador interno

.ciclo:

    mov eax, [esi] 
    mov ebx, [esi+4]

    cmp eax, ebx
    jle .continuar             ;jle=menor o igual

    mov [esi], ebx
    mov [esi+4], eax

    .continuar:
        add esi, 4
        dec edx
        jnz .ciclo


        loop .repetir

        pop edx
        pop esi
        pop edi
        pop ecx
        ret

;====MOSTRAR ARREGLO=====
mostrar_arreglo:
    push ecx 
    push edi
    push esi

    mov esi, edi

.ciclo2:
    mov eax, [esi]

    mov edi, cadena_salida
    call itoa

    mov edx, corchete
    call puts

    mov edx, cadena_salida
    call puts

    mov edx, nlin
    call puts

    add esi, 4
    loop .ciclo2

pop esi
pop edi
pop ecx
ret

    
section	.data
    ncad db 0xa,'Num: ',0
    len dw 64
    cad	times 64 db 0
    cadena_salida times 64 db 0
    nlin db 0xa,0
    corchete db ' ',0
    original db ' ORIGINAL', 0
    ordenado db ' ORDENADO', 0
    

section .bss
   
   