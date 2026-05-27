
 
section .text
    global set_bit
    global get_bit

;pone a 1 el bit en la posicion indicada
;dentro del byte

; void set_bit(unsigned char *valor, unsigned char bit)

set_bit:
    push ebp
    mov ebp, esp
    push ebx
    push ecx
 
    mov ebx, [ebp+8]       ; ebx =puntero a vael valor a modificar
    mov ecx, dword[ebp+12] ; ecx = bit posicion
 
    mov al,1             ; al =00000001
    shl al,cl            ; al =mascara con 1 en la posicion 
 
    or [ebx], al          
 
    pop  ecx
    pop  ebx
    pop  ebp
    ret

; unsigned char get_bit(unsigned char value, unsigned char bit)

; Retorna 1 si el bit en la posicion indicada esta activo,
; 0 en caso contrario.

get_bit:
    push ebp
    mov ebp, esp
    push ecx
 
    mov eax, dword[ebp+8]  ; eax =valor
    mov ecx, dword [ebp+12] ; ecx= posicion bit
 
    shr eax, cl             ; desplaza valor cl posiciones a la derecha
    and eax, 1              
 
    pop ecx
    pop ebp
    ret