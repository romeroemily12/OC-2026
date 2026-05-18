
%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

 %macro FOR 3
    push ecx
    push edx
    mov ecx,%1
    .%3:
        call %2
    loop .%3
    pop edx
    pop ecx
%endmacro

%macro PROTO_ENTRADA
    push ebp
    mov ebp,esp 
%endmacro

%macro PROT_SALIDA
    mov esp, ebp
    pop ebp
%endmacro


section	.text
	global maximo
    global minimo
    global suma
	


maximo:
    push ebp
    mov ebp, esp
    push esi
    push edi

    mov esi, [ebp + 8]      ;primer elemento
    mov ecx, [ebp + 12]     ;tamano = contador

    mov eax, [esi]          ;max provisional
    add esi, 4              ;siguiente elemento
    dec ecx

    push ecx
    FOR ecx, funcion_max, ciclo1
    pop ecx

    pop edi
    pop esi
    pop ebp
    ret

funcion_max:
    mov edi, [esi]
    cmp edi, eax
    jle .avanzar
    mov eax, edi

    .avanzar:
    add esi, 4
    ret


minimo:
    push ebp
    mov ebp, esp        ;esp = cima de pila

    push esi
    push edi

    mov esi, [ebp + 8]          ;esi = direccion primer elemento
    mov ecx, [ebp + 12]

    mov eax, [esi]              ;min provisional(primer elemento)
    add esi, 4                  ;siguiente elemento

    push ecx
    FOR ecx, funcion_min, ciclo2
    pop ecx

    pop edi
    pop esi
    pop ebp
    ret

funcion_min:
    mov edi, [esi]
    cmp edi, eax
    jge .avanzar2
    mov eax, edi

    .avanzar2:
    add esi, 4
    ret

suma:
    push ebp

    mov ebp, esp

    push esi
    push edi

    mov esi, [ebp +8]
    mov ecx, [ebp +12]

    mov eax, 0

    push ecx
    FOR ecx, sumatoria, ciclo3
    pop ecx

    pop edi
    pop esi
    pop ebp
    ret

sumatoria:
 
    mov edi, [esi]
    add eax, edi
    add esi, 4
    ret


    






section .data
    nl db 10          ; salto de línea





;esp -> puntero a la cima de la pila
; ebp -> pasamos lo de esp para no perder esp