Inicio, Input
		Store Opc
		
		//Caso 1
		Load Opc
		Subt Uno
		Skipcond 400
		Jump Caso2
		Load M16
		Store CONT
		JnS PintarHorizontal

// Caso 2
Caso2,  Load Opc
		Subt Dos
		Skipcond 400
		Jump Caso3
		JnS PintarVertical
		Jump Inicio

// Caso 3
Caso3, Load Opc
		Subt Tres
		Skipcond 400
		Jump Caso4
		Load N8
		Store CONT
		Load Cuatro
		Store CONT2
		Load NEGRO
		Store AUX
		Load BLANCO
		Store AUX2
		JnS PintarTablero
		Jump Inicio

// Caso 4
Caso4, Load Opc
		Subt Cuatro
		Skipcond 400
		Jump Caso5
		Load ROJO
		Store COLOR
		JnS PintarEspiral
		Jump Inicio

// Caso 5
Caso5, Load Opc
		Subt Cinco
		Skipcond 400
		Jump Inicio
		Halt

PintarHorizontal, hex 0
					Load D_BASE 
					Store D_PTR /apuntamos al inicio del display
		Horizontal, Load M16
					Store LIM  /asignar limite 16
					LOAD AZUL
					Store COLOR /asignar color
					Loadimmi 1
					Store INC /asignar inc, bajar en renglones
					JnS PINTAR
			
					LOAD CIAN
					Store COLOR
					LoadImmi 1
					Add D_PTR
					Store D_PTR
					JnS PINTAR
					LoadImmi 1
					Add D_PTR
					Store D_PTR
					Load CONT
					Subt Dos
					Store CONT
					SkipCond 0C00
					JumpI PintarHorizontal
					Jump Horizontal


PintarVertical, Hex 0
					Load D_BASE 
					Store D_PTR /apuntamos al inicio del display
					Load N128
					Store LIM  /asignar limite
					LOAD NARANJA
					Store COLOR /asignar color
					Loadimmi 2
					Store INC /asignar inc, bajar en renglones
					JnS PINTAR
			
					LOAD AMARILLO
					Store COLOR
					LoadImmi 1
					Add D_BASE
					Store D_PTR
					Load N128
					Store LIM  /asignar limite
					Loadimmi 2
					Store INC
					JnS PINTAR
					JumpI PintarVertical


PintarTablero, Hex 0
					Load D_BASE 
					Store D_PTR /apuntamos al inicio del display
			Ciclo,	Load Dos
					Store LIM  /asignar limite
					LOAD AUX
					Store COLOR /asignar color
					Loadimmi 1
					Store INC /asignar inc, bajar en renglones
					JnS PINTAR
					LoadImmi 1
					Add D_PTR
					Store D_PTR
					Load Dos
					Store LIM  /asignar limite
					LOAD AUX2
					Store COLOR /asignar color
					Loadimmi 1
					Store INC /asignar inc, bajar en renglones
					JnS PINTAR
					LoadImmi 1
					Add D_PTR
					Store D_PTR
					Load CONT
					Subt Uno
					Store CONT
					SkipCond 0C00
					Jump SaltarRenglon
					Jump Ciclo
					
		SaltarRenglon, Load D_PTR
					Add N32
					Store D_PTR
					Load N8
					Store CONT
					Load CONT2
					Subt Uno
					Store CONT2
					SkipCond 0C00
					Jump CambioColor
					Jump Ciclo
					
		CambioColor, LOAD NEGRO
					Store AUX2
					LOAD BLANCO
					STORE AUX
					Load Cuatro
					Store CONT2
					Load D_BASE
					Add N32
					Store D_PTR
					Load CONT3
					Subt Uno
					Store CONT3
					SkipCond 0C00
					JumpI PintarTablero
					Jump Ciclo

/=========================================
/ SUBRUTINA: PINTAR ESPIRAL
/ Prioridad: ABAJO > DERECHA > ARRIBA > IZQUIERDA
/ Requiere: COLOR establecido antes de llamar
/ Pintura: display 16x16 = 256 pixeles
/=========================================

PintarEspiral, HEX 0
        Load  D_BASE
        Store D_PTR
        LoadImmi 0
        Store CONT         /total pintados = 0
        Store CONT2        /dir = DOWN
        Store SP_T         /top = 0
        Store SP_L         /left = 0
        Load  N15
        Store SP_B         /bot = 15
        Store SP_R         /right = 15
        Load  M16
        Store INC          /INC inicial = +16
        Store AUX          /len inicial = 16

E_SEG,  Load  CONT
        Subt  N256
        SkipCond 0C00      /total < 256 -> seguir
        JumpI PintarEspiral      /total >= 256 -> fin

        Load  AUX
        Store LIM
        JnS   PINTAR       /pintar segmento
        Load  CONT
        Add   AUX
        Store CONT         /total += len

        /-- elegir transicion --
        Load  CONT2
        SkipCond 400
        Jump  E_N0

        /DOWN -> RIGHT: left++, INC=+1, D_PTR+1, len=right-left+1
        Load  SP_L
        Add   N1
        Store SP_L
        LoadImmi 1
        Store CONT2
        LoadImmi 1
        Store INC
        Load  D_PTR
        Add   N1
        Store D_PTR
        Load  SP_R
        Subt  SP_L
        Add   N1
        Store AUX
        Jump  E_SEG

E_N0,   Load  CONT2
        Subt  N1
        SkipCond 400
        Jump  E_N1

        /RIGHT -> UP: bot--, INC=-16, D_PTR-16, len=bot-top+1
        Load  SP_B
        Add   N_1
        Store SP_B
        LoadImmi 2
        Store CONT2
        Load  N16          /N16 = DEC -16
        Store INC
        Load  D_PTR
        Add   N16
        Store D_PTR
        Load  SP_B
        Subt  SP_T
        Add   N1
        Store AUX
        Jump  E_SEG

E_N1,   Load  CONT2
        Subt  N2
        SkipCond 400
        Jump  E_N2

        /UP -> LEFT: right--, INC=-1, D_PTR-1, len=right-left+1
        Load  SP_R
        Add   N_1
        Store SP_R
        LoadImmi 3
        Store CONT2
        Load  N_1
        Store INC
        Load  D_PTR
        Add   N_1
        Store D_PTR
        Load  SP_R
        Subt  SP_L
        Add   N1
        Store AUX
        Jump  E_SEG

  /LEFT -> DOWN: top++, INC=+16, D_PTR+16, len=bot-top+1
 E_N2,  Load  SP_T
        Add   N1
        Store SP_T
        LoadImmi 0
        Store CONT2
        Load  M16
        Store INC
        Load  D_PTR
        Add   M16
        Store D_PTR
        Load  SP_B
        Subt  SP_T
        Add   N1
        Store AUX
        Jump  E_SEG


/SUBRUTINA PINTAR
COLOR, HEX 0000
I_P, DEC 0
INC, DEC 0
LIM, DEC 0
PINTAR, HEX 0
		LoadImmi 0
		Store I_P
P_FOR, 	LOAD I_P
		Subt LIM
		SkipConD 0C00 /i<LIM
		Jump P_RETURN
		/PINTAR
		LOAD COLOR
		StoreI D_PTR
		/AVANZAR APUNTADOR
		Load D_PTR
		Add INC
		Store D_PTR
		/i++
		LOAD I_P
		Add N1
		Store I_P
		Jump P_FOR
P_RETURN,Load D_PTR
		Subt INC
		Store D_PTR /REGRESAR A LA ULTIMA CELDA PINTADA
		JumpI PINTAR

D_BASE, DEC 3840
D_FIN, HEX 0FFF
D_PTR, HEX 0F00
/R: X111 1100 0000 0000  -> HEX 7C00
/G: X000 0011 1110 0000  -> HEX 03E0
/B: X000 0000 0001 1111  -> HEX 001F
CIAN,     HEX 03FF
NARANJA,  HEX 7E00
AMARILLO, HEX 7FE0
ROJO, HEX 7C00
VERDE, HEX 03E0
AZUL, HEX 001F
NEGRO,  HEX 0000
BLANCO, HEX 7FFF
MORADO, HEX 481C
AUX, HEX 0000
AUX2, HEX 0000
N128, DEC 128
N32, DEC 32
M16, DEC 16
N8, DEC 8
N16, DEC -16
N15, DEC 15
N1, DEC 1
N2, DEC 2
CONT, DEC 0
CONT2, DEC 0
CONT3, DEC 2
Opc, DEC 0
Uno, DEC 1
Dos,  DEC 2
Tres, DEC 3
Cuatro, DEC 4
Cinco, DEC 5
SP_T, DEC 0
SP_B, DEC 0
SP_L, DEC 0
SP_R, DEC 0
N_1,  DEC -1
N256, DEC 256

