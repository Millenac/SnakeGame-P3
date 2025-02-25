;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR                EQU     0Ah
FIM_TEXTO         EQU     '@'
IO_READ           EQU     FFFFh
IO_WRITE          EQU     FFFEh
IO_STATUS         EQU     FFFDh
INITIAL_SP        EQU     FDFFh
CURSOR		      EQU     FFFCh
CURSOR_INIT	  	  EQU	  FFFFh

;padrao de bits para geracao de numero aleatorio
RND_MASK		EQU	8016h	; 1000 0000 0001 0110b
LSB_MASK		EQU	0001h	; Mascara para testar o bit menos significativo do Random_Var
PRIME_NUMBER_1	EQU 11d
PRIME_NUMBER_2	EQU 13d

;define quantos bits devem ser deslocados para calcular a posição da linha na tela
ROW_SHIFT		    EQU	    8d

;comprimento de linha e coluna da tela
LINE_SIZE	        EQU     80d
COLUMN_SIZE       	EQU     24d

LIMIT_COLUMN        EQU     78d
LIMIT_LINE          EQU     20d


;parametros para confugurar o timer
TIMER_UNITS       	EQU     FFF6h
TIMER_SET         	EQU     FFF7h

;parametros para movimentação da cobra
LEFT  				EQU     0d
RIGHT 				EQU     1d
UP   				EQU     2d
DOWN  				EQU     3d

ON                	EQU     1d
OFF                 EQU     0d

;variaveis que guardando o visual da cobra
SNAKE_HEAD			EQU		'o'
SNAKE_BODY			EQU		'o'
CLEAN_TAIL			EQU 	' '

;velocidade - qnt menor mais rapido a cobra fica
TIME_TO_MOVE      	EQU     3d

;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).b
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------
                ORIG    	8000h
TelaGame0		STR			' SCORE:000                                                   by: Millena Almeida'                                                                               
TelaGame1		STR			'################################################################################'
TelaGame2		STR			'#                                                                              #'
TelaGame3		STR			'#                                                                              #'
TelaGame4		STR			'#                                                                              #'
TelaGame5		STR			'#                                                                              #'
TelaGame6		STR			'#                                                                              #'
TelaGame7		STR			'#                                                                              #'
TelaGame8		STR			'#                                                                              #'
TelaGame9		STR			'#                                                                              #'
TelaGame10		STR			'#                                                                              #'
TelaGame11		STR			'#                                       *                                      #'
TelaGame12		STR			'#                                                                              #'
TelaGame13		STR			'#                                                                              #'
TelaGame14		STR			'#                                                                              #'
TelaGame15		STR			'#                                                                              #'
TelaGame16		STR			'#                                                                              #'
TelaGame17		STR			'#                                                                              #'
TelaGame18		STR			'#                                                                              #'
TelaGame19		STR			'#                                                                              #'
TelaGame20		STR			'#                                                                              #'
TelaGame21		STR			'#                                                                              #'
TelaGame22		STR			'#                                                                              #'
TelaGame23		STR			'################################################################################'


TelaGameOver0	STR			' ############################################################################## '
TelaGameOver1	STR			' #                                                                            # '
TelaGameOver2	STR			' #                                                                            # '
TelaGameOver3	STR			' #                                                                            # '
TelaGameOver4	STR			' #                  ######        #       ###   ###    #####                  # '
TelaGameOver5	STR			' #                 #             # #      #  # #  #   #                       # '
TelaGameOver6	STR			' #                 #    ###     #   #     #   #   #   ######                  # '
TelaGameOver7	STR			' #                 #      #    #######    #       #   #                       # '
TelaGameOver8	STR			' #                  ######    #       #   #       #    #####                  # '
TelaGameOver9	STR			' #                                                                            # '
TelaGameOver10	STR			' #                                                                            # '
TelaGameOver11	STR			' #                      ####   #       #   #####   ######                     # '
TelaGameOver12	STR			' #                     #    #   #     #   #        #    #                     # '
TelaGameOver13	STR			' #                     #    #    #   #    ######   ######                     # '
TelaGameOver14	STR			' #                     #    #     # #     #        #   #                      # '
TelaGameOver15	STR			' #                      ####       #       #####   #    #                     # '
TelaGameOver16	STR			' #                                                                            # '
TelaGameOver17	STR			' #                                                                            # '
TelaGameOver18	STR			' #                                                                            # '
TelaGameOver19	STR			' #                                 SCORE:                                     # '
TelaGameOver20	STR			' #                                                                            # '
TelaGameOver21	STR			' #                                                                            # '
TelaGameOver22	STR			' #                                                                            # '
TelaGameOver23	STR			' ############################################################################## '

StringToPrint 		 WORD   0d  ;endereco da string
LineNumber			 WORD   0d  ;linha que vai ser printada

;posição inicial da snake
SnakeHeadLine		 WORD    11d
SnakeHeadColumn	  	 WORD    37d

;posição inicial da fruta
LineFruit            WORD   11d 
ColumnFruit          WORD   40d

;ultima tecla pressionada
LastKeyPressed       WORD   LEFT

;parametros da cobra 
SnakeVector         TAB     1560d  ;tam max que cabe dentro da tela do game
SnakeSize           WORD    1d   

;parametros do score - inicialmente começam com 0 
ScoreTen			WORD    '0'
ScoreUnit			WORD    '0'
ScoreHundred        WORD    '0'
SnakeScore 			WORD    0d

;parametros da rotina random
Random_Var		    WORD	A5A5h  ; 1010 0101 1010 0101
RandomState 	    WORD	1d

;------------------------------------------------------------------------------
; ZONA III: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h

INT0			WORD	UpKey			;Move para cima
INT1			WORD	DownKey			;Move para baixo
INT2			WORD	LeftKey			;Move para esquerda
INT3			WORD	RightKey		;Move para direita

                ORIG    FE0Fh
INT15           WORD    Timer

;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidasw
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main
                
;----------------------------------------------------------------
; Rotina: ConfigureTimer
;----------------------------------------------------------------
ConfigureTimer: PUSH R1

                MOV R1, TIME_TO_MOVE
                MOV M[ TIMER_UNITS ], R1
                MOV R1, ON
                MOV M[ TIMER_SET ], R1

          		POP R1

          		RET

;----------------------------------------------------------------
; Rotina: Timer
;----------------------------------------------------------------
Timer:  PUSH R1

        CALL MoveSnake
        CALL ConfigureTimer

        POP R1

        RTI

;------------------------------------------------------------------------------
; Função: RandomV1
;
; Random: Rotina que gera um valor aleatório - guardado em M[Random_Var]
;------------------------------------------------------------------------------
RandomV1:	    PUSH	  R1

                MOV	    R1, LSB_MASK
                AND	    R1, M[ Random_Var ] ; R1 = bit menos significativo de M[Random_Var]
                BR.Z	Rnd_Rotate
                MOV	    R1, RND_MASK
                XOR	    M[ Random_Var ], R1

Rnd_Rotate:	    ROR	    M[ Random_Var ], 1
                POP	    R1
                RET
;------------------------------------------------------------------------------
; Função: RandomV2 (versão 2)
;
; Random: Rotina que gera um valor aleatório - guardado em M[Random_Var]
; Entradas: 
; Saidas:   M[Random_Var]
;------------------------------------------------------------------------------
RandomV2:	PUSH R1
			PUSH R2
			PUSH R3
			PUSH R4

			MOV R1, M[ RandomState ]
			MOV R2, PRIME_NUMBER_1
			MOV R3, PRIME_NUMBER_2

			MUL R1, R2 ; Atenção: O resultado da operacao fica em R1 e R2!!!
			ADD R2, R3 ; Vamos usar os 16 bits menos significativos da MUL
			MOV M[ RandomState ], R2
            MOV M[ Random_Var ], R2

			POP R4
			POP R3
			POP R2
			POP R1

			RET

;----------------------------------------------------------------
; Rotina: MoveSnake
; Faz as comparações das teclas e move a cobra para direção desejada
;----------------------------------------------------------------
MoveSnake:  PUSH R1

            MOV R1, M[ LastKeyPressed ]
 
            CMP R1, RIGHT
            CALL.Z MoveSnakeRight

            CMP R1, LEFT
            CALL.Z MoveSnakeLeft

            CMP R1, UP
            CALL.Z MoveSnakeUp

            CMP R1, DOWN
            CALL.Z MoveSnakeDown	

			CALL PrintSnake
			CALL UpdatePosition
            CALL SnakeCollision           
            CALL EatFruit ;é chamado o EatFruit pq a posição inicial da fruta já é pre definida (dentro da EatFruit é chamado a função para gerar novas frutas - NewFruit)

			POP R1
			RET

;----------------------------------------------------------------
; Rotina: NewFruit
; Gera uma nova fruta na tela
;----------------------------------------------------------------
NewFruit:   POP R1
            POP R2
            POP R3

            CALL RandomV1
            MOV R1, M[Random_Var]
            MOV R2, LIMIT_LINE
            DIV R1, R2
            ADD R2, 2
            MOV M[LineFruit], R2

            CALL RandomV2
            MOV R1, M[Random_Var]
            MOV R2, LIMIT_COLUMN
            DIV R1, R2
            ADD R2, 1
            MOV M[ColumnFruit], R2

            ;desenha a nova fruta
            MOV R1, M[LineFruit]
            MOV R2, M[ColumnFruit]
            SHL R1, ROW_SHIFT
            OR R1, R2
            MOV M[CURSOR], R1
            MOV R3, '*'
            MOV M[IO_WRITE], R3

            CALL FruitOnSnake

            POP R3
            POP R2
            POP R1
            RET
;----------------------------------------------------------------
; Rotina: EatFruit
; verifica se a cobra comeu a fruta 
;----------------------------------------------------------------
EatFruit:       PUSH R1
                PUSH R2
                PUSH R3

                MOV R1, M[LineFruit]
                MOV R2, M[SnakeHeadLine]
                CMP R1, R2
                JMP.NZ EatFruitEnd

                MOV R2, M[ColumnFruit]
                MOV R1, M[SnakeHeadColumn]
                CMP R1, R2
                JMP.NZ EatFruitEnd

                ;como a cobra comeu a fruta é feito o inc nela e é feito a atualização do score
                CALL GrowSnake    
                CALL NewFruit          

EatFruitEnd:    POP R3
                POP R2
                POP R1
                RET

;------------------------------------------------------------------------------
; Rotina FruitOnSnake
; Verifica se a fruta deu spawn em cima do corpo da cobra
;------------------------------------------------------------------------------
FruitOnSnake:   PUSH R1
                PUSH R2
                PUSH R3

                MOV R1, M[ LineFruit ]
                MOV R2, M[ ColumnFruit ]
                SHL R1, ROW_SHIFT
                OR  R2, R1 ;r2 agora guarda a posição da fruta

                MOV R3, 0d

                ;o loop vai comparar a posição da fruta com cada parte da fruta
LoopCheck:     CMP R1, M[R3 + SnakeVector]
                JMP.Z NewFruit ;caso vdd, chama a função NewFruit para gerar a fruta numa posição diferente

                INC R3 ;vai incremenando para percorrer toda parte da cobra
                CMP R3, M[SnakeSize]
                JMP.NZ LoopCheck

                POP R3 
                POP R2
                POP R1
                RET

;----------------------------------------------------------------
; Rotina: GrowSnake
; Faz o tamanho da cobra crecer e atualiza o score
;----------------------------------------------------------------
GrowSnake:  PUSH R1

            INC M [SnakeSize]
            CALL Score

            POP R1
            RET
;------------------------------------------------------------------------------
; Rotina PrintSnake
; Faz o print da cobra na tela do game
;------------------------------------------------------------------------------
PrintSnake:    PUSH    R1
               PUSH    R2
               PUSH    R3

               ; faz o print da cabeça
               MOV     R1, M [ SnakeHeadLine ]
               SHL     R1, ROW_SHIFT
               MOV     R2, M [ SnakeHeadColumn ]
               OR      R1, R2
             
			   MOV     M [ CURSOR ], R1
			   MOV     R1, SNAKE_HEAD
               MOV     M [ IO_WRITE ], R1

               ; faz o print do corpo
               MOV     R1, 0d

PrintSnakeLoop:	MOV     R2, M [ R1 + SnakeVector ] 
               	MOV     R3, SNAKE_BODY
               	MOV     M [ CURSOR ], R2
               	MOV     M [ IO_WRITE ], R3

               	INC     R1
               	CMP     R1, M [ SnakeSize ]       
               	JMP.NZ  PrintSnakeLoop

                CALL    RemoveTail 

               	POP     R3
               	POP     R2
               	POP     R1
               	RET

;------------------------------------------------------------------------------
; Rotina RemoveTail
; Apaga a última posição depois da cauda evitando que a cobra deixe rastro conforme se move
;------------------------------------------------------------------------------
RemoveTail:    PUSH    R1

               MOV     R1, CLEAN_TAIL             
               MOV     M [ IO_WRITE ], R1    

               POP     R1
               RET

;------------------------------------------------------------------------------
; Rotina UpdatePosition
; Faz deslocamento de todas as partes do corpo da cobra para a posição anterior
;------------------------------------------------------------------------------
UpdatePosition: PUSH R1
				PUSH R2
				PUSH R3

				MOV	R2, M[ SnakeSize ]

                ;loop começa da cauda para a cabeça
                ;cada segmento da cobra recebe a posição do segmento anterior, garantindo que o corpo siga a cabeça
LoopPosition:	MOV R1, R2
				DEC R1
				MOV R3, M[ R1 + SnakeVector]
				MOV M[ R2 + SnakeVector ], R3

				DEC R2
				;verifica se chegou ao inicio
				CMP R2, 0d
				JMP.NZ LoopPosition

				;faz atualização da posição de acordo com a nova posição
				MOV R2, M[ SnakeHeadLine ]
				MOV R3, M[ SnakeHeadColumn ]
				SHL R2, ROW_SHIFT
				OR  R2, R3
				MOV M[ SnakeVector ], R2				

				POP R3
				POP R2
				POP R1
				RET
;----------------------------------------------------------------
; Rotina: SnakeCollision
; Verifica se a cobra colidiu consigo mesma
;----------------------------------------------------------------
SnakeCollision: PUSH R1
                PUSH R2
                PUSH R3

                MOV R1, M[ SnakeVector ]
                MOV R2, 0d

LoopCollision:  INC R2
                MOV R3, M[R2 + SnakeVector]
                CMP R1, R3
                JMP.Z PrintLose
                CMP R2, M[SnakeSize]
                JMP.NZ LoopCollision

                POP R3
                POP R2
                POP R1
                RET

;----------------------------------------------------------------
; Rotina: Score
; Atualiza o sistema de pontuação do game, incrementando a unidade, dezena e centena
;----------------------------------------------------------------
Score:  PUSH R1
        PUSH R2
        PUSH R3

        INC M[ SnakeScore ]       
        MOV R1, M[ ScoreUnit ]      ;carregando o valor atual da unidade
        MOV R2, M[ ScoreTen ]       ;carregando o valor atual da dezena
        MOV R3, '9'                 ;valor '9' em ASCII para comparação

        CMP R1, R3                  ;compara se a dezena é 9 se for 9 é feita a atualização da unidade
        JMP.Z UpdateTen             

UpdateUnit: INC R1                      ;incrementa a unidade              
            MOV M[ ScoreUnit ], R1      
            JMP ShowScore

UpdateTen:  MOV R1, '0'                 ;reseta a unidade para zero caso ela chegue no 0
            MOV M[ ScoreUnit ], R1
            INC R2                      
            MOV M[ ScoreTen ], R2

            CMP R2, R3                  ;compara se a dezena é 9 se for 9 é feita a atualização da centena
            JMP.Z UpdateHundred         ;se for 9, atualiza a centena
            JMP ShowScore

UpdateHundred:  MOV R2, '0'                 ;reseta a dezena para zero
                MOV M[ ScoreTen ], R2
                MOV R3, M[ ScoreHundred ]   ;carrega o valor atual da centena
                INC R3                      ;incrementa a centena
                MOV M[ ScoreHundred ], R3

            ; Faz o print na tela da pontuação atualizada
ShowScore:  MOV R3, 7d                  ;coluna para a centena
            MOV R2, 0d                  
            SHL R2, ROW_SHIFT           
            OR R2, R3
            MOV M[ CURSOR ], R2       
            MOV R1, M[ ScoreHundred ]     
            MOV M[ IO_WRITE ], R1     

            MOV R3, 8d                  ;coluna para a dezena
            MOV R2, 0d                
            SHL R2, ROW_SHIFT           
            OR R2, R3
            MOV M[ CURSOR ], R2       
            MOV R1, M[ ScoreTen ]     
            MOV M[ IO_WRITE ], R1     
   
            MOV R3, 9d                  ;coluna para a unidade
            MOV R2, 0d               
            SHL R2, ROW_SHIFT           
            OR R2, R3
            MOV M[ CURSOR ], R2       
            MOV R1, M[ ScoreUnit ]    
            MOV M[ IO_WRITE ], R1     

EndScore:   POP R3
            POP R2
            POP R1
            RET

;------------------------------------------------------------------------------
; Rotina: UpKey (interrupções para mudar a direção da cobra)
;------------------------------------------------------------------------------	
UpKey:      PUSH    R1

			;evita que a cobra volte em direção contraria
            MOV     R1, M[ LastKeyPressed ]
            CMP     R1, DOWN
            JMP.Z   EndUpKey

            MOV     R1, UP
            MOV     M[ LastKeyPressed ], R1

EndUpKey:   POP     R1
            RTI

;------------------------------------------------------------------------------
; Rotina: DownKey (interrupções para mudar a direção da cobra)
;------------------------------------------------------------------------------	
DownKey:    PUSH    R1

			;evita que a cobra volte em direção contraria
            MOV     R1, M[ LastKeyPressed ]
            CMP     R1, UP
            JMP.Z   EndDownKey

            MOV     R1, DOWN
            MOV     M[ LastKeyPressed ], R1

EndDownKey: POP     R1
            RTI

;------------------------------------------------------------------------------
; Rotina: LeftKey (interrupções para mudar a direção da cobra)
;------------------------------------------------------------------------------	
LeftKey:  	PUSH    R1

			;evita que a cobra volte em direção contraria
            MOV     R1, M[ LastKeyPressed ]
            CMP     R1, RIGHT
            JMP.Z   EndLeftKey

            MOV     R1, LEFT
            MOV     M[ LastKeyPressed ], R1

EndLeftKey: POP     R1
            RTI

;------------------------------------------------------------------------------
; Rotina: RightKey (interrupções para mudar a direção da cobra)
;------------------------------------------------------------------------------	
RightKey:  		PUSH    R1

				;evita que a cobra volte em direção contraria
            	MOV     R1, M[ LastKeyPressed ]
            	CMP     R1, LEFT
            	JMP.Z   EndRightKey

            	MOV     R1, RIGHT
            	MOV     M[ LastKeyPressed ], R1

EndRightKey:  	POP     R1
            	RTI

;----------------------------------------------------------------
; Rotina: MoveSnakeRight
; Move a cobra para a direita e verifica se a cobra colidiu com a borda
;----------------------------------------------------------------
MoveSnakeRight: PUSH R1

                MOV R1, M[SnakeHeadColumn]
                CMP R1, 78
                JMP.Z LoseRight

                INC M[SnakeHeadColumn]
                JMP EndMoveRight

LoseRight:      CALL PrintLose

EndMoveRight:   POP R1
                RET

;----------------------------------------------------------------
; Rotina: MoveSnakeLeft
; Move a cobra para a esquerda e verifica se a cobra colidiu com a borda
;----------------------------------------------------------------
MoveSnakeLeft:  PUSH R1              

                MOV R1, M[SnakeHeadColumn]
                CMP R1, 1
                JMP.Z LoseLeft

                DEC M[SnakeHeadColumn] 
                JMP EndMoveLeft

LoseLeft:       CALL PrintLose

EndMoveLeft:    POP R1
                RET
;----------------------------------------------------------------
; Rotina: MoveSnakeUp
; Move a cobra para cima e verifica se a cobra colidiu com a borda
;----------------------------------------------------------------
MoveSnakeUp:    PUSH R1

                MOV R1, M[SnakeHeadLine]
                CMP R1, 2
                JMP.Z LoseUp

                DEC M[SnakeHeadLine]
                JMP EndMoveUp

LoseUp:         CALL PrintLose

EndMoveUp:      POP R1
                RET

;----------------------------------------------------------------
; Rotina: MoveSnakeDown
; Move a cobra para baixo e verifica se a cobra colidiu com a borda
;----------------------------------------------------------------
MoveSnakeDown:  PUSH R1

                MOV R1, M[SnakeHeadLine]
                CMP R1, 22
                JMP.Z LoseDown

                INC M[SnakeHeadLine]
                JMP EndMoveDown

LoseDown:       CALL PrintLose

EndMoveDown:    POP R1
                RET
;----------------------------------------------------------------
; Rotina: PrintLineMap (print de cada caracter de cada linha)
;----------------------------------------------------------------
PrintLineMap:   PUSH R1 ;linha
				PUSH R2 ;coluna
				PUSH R3 ;caracter da string 
				PUSH R4

				MOV R4, M[ StringToPrint ] ;posição inicial da string que vai ser printada 

cycleColumn:	MOV R2, 0d  

cycleLine: 		MOV R1, M[ LineNumber] 

				MOV R3, M[ R4 ] ;pega caracter atual da string
				SHL R1, ROW_SHIFT
				OR R1, R2
				MOV M[ CURSOR ], R1
				MOV M[ IO_WRITE ], R3
				INC R2
				INC R4
				CMP R2, LINE_SIZE
				JMP.NZ cycleLine

				MOV R1, M[ LineNumber]
				INC R1
				MOV M[ LineNumber], R1
				CMP R1, COLUMN_SIZE
				JMP.NZ cycleColumn

				POP R4
				POP R3
				POP R2
				POP R1

				RET

;----------------------------------------------------------------
; Rotina: PrintMap
;----------------------------------------------------------------
PrintMap:	PUSH R1

		  	MOV  R1, TelaGame0
		  	MOV  M[ StringToPrint ], R1
		  	MOV  R1, 0d
   		  	MOV  M[ LineNumber ], R1

		  	CALL PrintLineMap

		  	POP R1

		  	RET
		  
;----------------------------------------------------------------
; Rotina: PrintLose
; Exibe a tela de game over e o score final 
;----------------------------------------------------------------
PrintLose:  PUSH R1
            PUSH R2
            PUSH R3

            ;exibe a tela de game over
            MOV R1, TelaGameOver0
            MOV M[ StringToPrint ], R1
            MOV R1, 0d
            MOV M[ LineNumber ], R1
            CALL PrintLineMap 

            ;config a linha e coluna para a centena do score
            MOV R1, 19d         
            SHL R1, ROW_SHIFT    
            MOV R2, 41d          ;coluna 41
            OR R1, R2            
            MOV M[ CURSOR ], R1

            MOV R3, M[ ScoreHundred ] ;print da centena 
            MOV M[ IO_WRITE ], R3  

            ;config a linha e coluna para a dezena do score
            MOV R1, 19d          
            SHL R1, ROW_SHIFT
            MOV R2, 42d          ; coluna 42 
            OR R1, R2            
            MOV M[ CURSOR ], R1

            MOV R3, M[ ScoreTen ]  ; print da dezena
            MOV M[ IO_WRITE ], R3 

            ;condig a linha e coluna para a unidade do score
            MOV R1, 19d          
            SHL R1, ROW_SHIFT
            MOV R2, 43d          ; coluna 43
            OR R1, R2            
            MOV M[ CURSOR ], R1

            MOV R3, M[ ScoreUnit ] ; print da unidade 
            MOV M[ IO_WRITE ], R3  

            ;finaliza o programa
            CALL Halt

            POP R3
            POP R2
            POP R1

            RTI 

;-----------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:	ENI
		MOV		R1, INITIAL_SP
		MOV		SP, R1		 		; We need to initialize the stack
		MOV		R1, CURSOR_INIT		; We need to initialize the cursor
		MOV		M[ CURSOR ], R1		; with value CURSOR_INIT

		MOV 	R1, M[SnakeHeadLine]
		MOV 	R1, M[ SnakeHeadColumn]

        CALL 	PrintMap
		CALL 	ConfigureTimer
		

Cycle: 			BR		Cycle
Halt:           BR		Halt
