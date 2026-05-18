%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   
   
    mov edx,ncad
    call puts       ;imprime la cadena

    ;=====CADENA ORIGINAL====
    mov bx,word[len]    ;tamano maximo de la palabra
    mov edx,cad         ;apunta a cadena
    call capturar       ;llama a capturar

    mov al,[nlin]       ;salto de linea
    call putchar        ;Enter
    call puts           ;imprime la cadena

    mov al,[nlin]       ;saltos de linea
    call putchar

    ;=====IMPRIMIR MAYUSCULA====
    mov edx, cad        ;apuntar al inicio de la cadena
    call mayusculas        ;llamar a la funcion
    mov edx, mayus
    call puts
    mov edx, ncad
    call puts
    mov edx,cad
    call puts

    mov al,[nlin]       ;saltos de linea
    call putchar

    ;=====IMPRIMIR MINUSCULAS=====
    mov edx, cad
    call minusculas
    mov edx, min
    call puts
    mov edx, ncad
    call puts
    mov edx, cad
    call puts

    mov al,[nlin]       ;saltos de linea
    call putchar

    mov eax, 1
    int 0x80



    ;========CONVERTIR MAYUSCULA=======
    mov edx, cad
    call mayusculas

    mov edx, ncad
    call puts
    mov edx, cad
    call puts

	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

    capturar:
        push edx        ;guardar valores
        push cx         ;cx = contador
        push esi        ;esi = indice
        mov cx,bx       ;bx guarda el tamano maximo (64)
        dec cx          ;dec = restar
        mov esi, 0    ; esi = 0 (índice empieza en 0)

    .ciclo: 
        call getch      ;llama al a funcion
        cmp al,127      ; compara al != 127? 127 = backspace en ASCII
        jne .guardar    ;/VERDADERO = va a .guardar

         ;=============Si es backspace=========================
        cmp esi, 0          ; posicionarse en inicio
        je .ciclo           ; si esi = 0, saltar
        dec esi             ; retroceder índice 
        mov byte[edx + esi], 0      ; poner 0 en caracter borrado
        call borrar         ; borrar visualmente
        inc cx              ; recuperar espacio en el contador
        jmp .ciclo

       .guardar:

        call putchar             ;imprime el caracter
        mov [edx + esi],al        ;guradar la letra que esta en al en [edx]  
        cmp al,0xa                ;compara el salto de linea
        je .salir                 ;/VERDADERO = salir si son iguales
        inc esi                ;/FALSO = inc = avanzar
        loop .ciclo             ;repite el ciclo

        .salir:
        mov byte[edx + esi],0  ;guarda un 0 en la cadena
        pop esi
        pop cx
        pop edx
        ret             ;regresa el lugar donde llama la funcion

    borrar:
        push ax         ;guardar valor ax
        mov al,0x8      ;cargar valor 8 en AL
        call putchar    
        mov al,' '      ;carga espacio en blanco
        call putchar    ;borra visualmente el caracter anterior
        mov al,0x8
        call putchar   
        pop ax
        ret 

    itoa:
        push bx
        mov bl,100
        mov ah,0
        div bl
        mov bx,ax
        add al,'0'
        call putchar
        mov al,ah
        add al,'0'
        call putchar
    
    ;=====MAYUSCULAS====
    mayusculas:
        push edx

     .mayus_ciclo:
        mov al, [edx]
        cmp al, 0       ; caracter == 0?
        je .fin         ;si es verdadero salta a fin

        cmp al, 'a'     ; al < a?
        jb .sig         ; si es verdad salta a sig
        cmp al, 'z'
        ja .sig         ;al > z?

        sub al, 32      ;restar 32
        mov [edx], al

    .sig:
        inc edx         ;avanzar 
        jmp .mayus_ciclo

    .fin:
        pop edx
        ret

    ;=====MINUSCULAS=====

    minusculas:
        push edx

    .minus_ciclo:
        mov al, [edx]
        cmp al, 0
        je .fin2        ; al == 0?

        cmp al, 'A'     
        jb .sig2        ; si al < A ve a sig2
        cmp al, 'Z'
        ja .sig2

        add al, 32
        mov [edx], al

    .sig2:
        inc edx
        jmp .minus_ciclo

    .fin2:
        pop edx
        ret

    
section	.data
    ncad db 0xa,'Cadena: ',0
    mayus db 0xa,'MAYUSCULAS',0
    min db 0xa,'MINUSCULAS',0
    orig db 0xa,'ORIGINAL',0
    nlin db 0xa
    len db 64
    cad	times 64 db 0