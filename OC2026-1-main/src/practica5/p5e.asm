%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   
	mov edx, msg		; edx = dirección de la cadena msg
	call puts			; imprime cadena msg terminada en valor nulo (0)

	mov edx, msg		; direccion del inicio de cadena
	mov ecx, 10			; indice en posicino 10
	mov byte [edx + ecx + 5], 'P' ; +5 para llegar a la posicion de p
	call puts

	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

section	.data
    msg	db  'abcdefghijklmnopqrstuvwxyz0123456789',0xa,0 


