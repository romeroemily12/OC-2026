/ MENU
MENU,   LOAD CERO
        STORE OP
        INPUT
        STORE OP

        LOAD OP
        SUBT UNO
        SKIPCOND 400/ OP == 1?
        JUMP CASE2/FALSO
        JNS CAPTURA_AB/VERDADERO
        JUMP MENU

CASE2,  LOAD OP
        SUBT DOS
        SKIPCOND 400 /OP == 2?
        JUMP CASE3
        JnS COMPARAR
        LOAD R
        OUTPUT
        JUMP MENU

CASE3,  LOAD OP
        SUBT TRES
        SKIPCOND 400 
        JUMP CASE4
        JnS POTENCIA_AB
        LOAD R
        OUTPUT
        JUMP MENU

CASE4,  LOAD OP
        SUBT CUATRO
        SKIPCOND 400
        JUMP MENU
        HALT
		
/SUBRUTINAS

CAPTURA_AB, HEX 000
        INPUT
        STORE A
        INPUT
        STORE B
        JumpI CAPTURA_AB


COMPARAR, HEX 000
        LOAD A
        SUBT B
        SKIPCOND 000/A<B?
        JnS MULTI_A_MAYOR
        JnS MULTI_A_MENOR
        JumpI COMPARAR


MULTI_A_MENOR, HEX 000
        LOAD CERO
        STORE R
        STORE I

FOR1,   LOAD A
        SUBT I
        SKIPCOND 800
        JUMP FIN_MENOR

        LOAD R
        ADD B
        STORE R

        LOAD I
        ADD UNO
        STORE I
        JUMP FOR1

FIN_MENOR, JumpI MULTI_A_MENOR


MULTI_A_MAYOR, HEX 000
        LOAD CERO
        STORE R
        STORE I

FOR2,   LOAD B
        SUBT I
        SKIPCOND 800
        JUMP FIN_MAYOR

        LOAD R
        ADD A
        STORE R

        LOAD I
        ADD UNO
        STORE I
        JUMP FOR2

FIN_MAYOR, JumpI MULTI_A_MAYOR


POTENCIA_AB, HEX 000
        LOAD B
        SKIPCOND 400 /B==0?
        JUMP POT_INICIO

        LOAD UNO
        STORE R/RESULTADO==1
        JumpI POTENCIA_AB


POT_INICIO,LOAD UNO
        STORE R
        LOAD B
        STORE CONT

POT_CICLO,LOAD CONT
        SKIPCOND 400 /CONT ==0?
        JUMP POT_MULT
        JumpI POTENCIA_AB


POT_MULT,JnS MULTI_R_A /R = R * A
        LOAD CONT
        SUBT UNO
        STORE CONT
        JUMP POT_CICLO


MULTI_R_A, HEX 000
        LOAD CERO
        STORE TEMP_R
        STORE I

MRA_CICLO,LOAD R
        SUBT I
        SKIPCOND 800
        JUMP FIN

        LOAD TEMP_R
        ADD A
        STORE TEMP_R

        LOAD I
        ADD UNO
        STORE I
        JUMP MRA_CICLO

FIN,LOAD TEMP_R
        STORE R
        JumpI MULTI_R_A




OP,      DEC 0
A,       DEC 0
B,       DEC 0
R,       DEC 0
CONT,    DEC 0
I,       DEC 0
TEMP_R,  DEC 0

UNO,     DEC 1
CERO,    DEC 0
DOS,     DEC 2
TRES,    DEC 3
CUATRO,  DEC 4
