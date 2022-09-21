.data
entradaA: .asciiz "\nEntre com o valor de a:"
entradaB: .asciiz "\nEntre com o valor de b:"
entradaN: .asciiz "\nEntre com o valor de n:"
multiplos: .asciiz "\nOs multiplos de a, b: "
msg_erro: .asciiz "O valor deve ser inteiro positivo."

.text	
main:
	Estrutura:
		jal Leitura_a_b_n					#vai para Leitura_a_b_n, le os valores a, b e n
		mul $a0, $s7, 4         			#$a0 = N*4
		li $v0, 9               			#codigo SysCall para alocacao dinamica
		syscall								#aloca o vetor com n posicoes
		move $a3, $v0 						#a3 recebe endereco base do vetor
		jal ProcuraMultiplos				#pula para ProcuraMultiplos, vai buscar os multiplos de a e b
		jal OrdenaVetor						#pula para OrdenaVetor, vai ordenar o vetor em ordem crescente
		la $a0, multiplos					#passando a mensagem que estava na memoria na variavel "multiplos" para o registrador de argumento $a0 (string a ser escrita)
		li $v0, 4							#usando o codigo SysCall para escrever strings
		syscall								#vai imprimir $a0
		jal ImprimeVet						#pula para ImprimeVet, imprime o vetor
		li $v0, 10							#codigo para finalizar o programa
		syscall								#finaliza o programa
        	

	Leitura_a_b_n:
		la $a0, entradaN					#Carrega em a0 o endereco da msg de entrada de n
		li $v0, 4							#Codigo de impressao de string e imprime
		syscall
		li $v0, 5							#Codigo de leitura de inteiro, le o valor e armazena em v0
		syscall
		move $s7, $v0						#s7 recebe valor de N lido
		la $a0, entradaA					#Carrega em a0 o endereco da msg de entrada de a
		li $v0, 4							#Codigo de impressao de string e imprime
		syscall
		li $v0, 5							#Codigo de leitura de inteiro, le o valor e armazena em v0
		syscall
		move $s6, $v0						#s6 recebe valor de a lid
		la $a0, entradaB					#Carrega em a0 o endereco da msg de entrada de b
		li $v0, 4							#Codigo de impressao de string e imprime
		syscall
		li $v0, 5							#Codigo de leitura de inteiro, le o valor e armazena em v0
		syscall
		move $s5, $v0						#s5 recebe valor de b lido
		jr $ra								#retorna para a instrucao que chamou Leitura_a_b_n
	

	ProcuraMultiplos:
		li $a0, 1							#Valor usado pra buscar multiplos, vai de 1 ate indefinido, quando vetor estiver cheio para de incrementar
		li $t0, 0							#contador i = 0
		VerificaMultiplos:	
			div $a0, $s6					#divide X / a
			mfhi $t9						#t9 recebe o resto
			beqz $t9, Armazena_Valor		#se o resto for 0 armazena o valor
			div $a0, $s5					#divide X / b
			mfhi $t9						#t9 recebe o resto
			beqz $t9, Armazena_Valor		#se o resto for 0 armazena o valor
			addi $a0, $a0, 1				#Valor de X incrementado
		Verifica:
			blt $t0, $s7, VerificaMultiplos	#se o contador for menor que tamanho do vetor salta pro VerificaMultiplos
			jr $ra							#retorna para a instrucao que chamou ProcuraMultiplos
		Armazena_Valor:
			mul $t1, $t0, 4						#t1 recebe i * 4(bytes)
			add $t9, $a3, $t1					#t9 recebe = endereco base do vetor + posicao calculada
			sw $a0, ($t9)						#armazena o valor atual no vetor
			addi $a0, $a0, 1					#Valor de X incrementado
			addi $t0, $t0, 1					#i++
			j Verifica							#pula para verifica
	

	OrdenaVetor:
		move $t1, $s7						#t1 recebe tamanho do vetor
		subi $t1, $t1, 1             		#Subtrai 1 do valor de $t1(indice j)
		Percorre_j:                			#Funciona como um for(j = N-1 ; j>=1 ; j--)
			li $t0, 0               		#t0(i) = 0
			beq $t0, $t1, RetornaOrdena		#Se $t0 for igual a $t1(i == j) entao vai pro RetornaOrdena
			move $t8, $a3           		#Armazena em $t8 o endereco base do vetor
			move $t9, $a3           		#Armazena em $t9 o endereco base do vetor
			add $t9, $t9, 4         		#$t9 avanca 4 bytes no vetor [i+1]
			Percorre_i:                 	#Funciona como: for(i = 0 ; i<j ; i++)
				lw $s1, ($t8)               #$s1 recebe o valor armazenado no endereco $t8(elemento i do vetor)
				lw $s2, ($t9)               #$s2 recebe o valor armazenado no endereco $t9(elemento i+1 do vetor)
				ble $s1, $s2, Continua	 	#Se vetor[i] < vetor[i+1] continua                 
				sw $s2, ($t8)               #Caso seja maior troca de posicao deixando na posicao i o elemento que estava em i+1
				sw $s1, ($t9)               #Caso seja maior troca de posicao deixando na posicao i+1 o elemento que estava em i
			Continua:
				add $t8, $t8, 4         	#Incrementa em $t8 o valor da proxima posicao do vetor
				add $t9, $t9, 4         	#Incrementa em $t9 o valor da proxima posicao do vetor
				addi $t0, $t0, 1        	#Incrementa o indice $t0(i) em +1
				blt $t0, $t1, Percorre_i	#Se $t0 for menor que $t1(i < j) entao vai para o label Percorre_i
				subi $t1, $t1, 1            #Subtrai 1 do valor de $t1(indice j)
				bge $t1, 1, Percorre_j      #Se $t1 for maior ou igual a 1( j >= 1) vai para o label Percorre_j		
		RetornaOrdena: 
			jr $ra							#retorna para a instrucao que chamou OrdenaVetor



	ImprimeVet:
		li $t0, 0                   		#Inicializa $t0 com 0 que sera o contador (i)
		Laco_Escrita:
			beq $t0, $s7, RetornaEscrita	#se i for >= N retorna
			mul $t1, $t0, 4					#t1 recebe i * 4(bytes)
			add $t9, $a3, $t1				#t9 recebe = endereco base + posicao calculada
			lw $a0, ($t9)               	#Carrega em $a0 o valor da posicao (i) do vetor
			li $v0, 1                   	#Codigo syscall para escrita de inteiros        
			syscall                    		#Chamada de sistema para escrita do inteiro
			li $a0, 32                  	#Codigo SysCall de ASCII para escrever espaco
			li $v0, 11                  	#Codigo SysCall para imprimir caracteres
			syscall                     	#Chamada de sistema para impressao do espaco
			add $t0, $t0, 1             	#i++
			j Laco_Escrita					#pula para Laco_Escrita
		RetornaEscrita: 
			jr $ra							#retorna para a instrucao que chamou ImprimeVet
				
	