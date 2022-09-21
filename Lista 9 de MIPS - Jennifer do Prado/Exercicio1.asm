.data
	entradaN: .asciiz "\nEntre com o valor inteiro de N (0 < N): "
	Ent1: .asciiz "Insira o valor de Vet["
	Ent2: .asciiz "]: "
	msg_erro: .asciiz "O valor digitado tem que ser inteiro maior que 0.\n"
	Vet1: .asciiz "\nVet1: "
	Vet2: .asciiz "\n\nVet2: "

.text
main:
	N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        blt $v0, 1, Erro        #caso o valor digitado que esta no registrador de valor $v0 for menor que o inteiro "1", vai para Erro
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0
		
	Estrutura:      	
		jal leitura_Vet			#le os elementos do vetor Vet1
		jal inverte_vetor		#vai inverter o vetor Vet1 e guardar em Vet2
		la $a0, Vet1			#passando a mensagem que estava na memoria na variavel "Vet1" para o registrador de argumento $a0 (string a ser escrita)
		li $v0, 4				#usando o codigo SysCall para escrever strings
		syscall					#vai imprimir a mensagem que esta em $a0
		move $a0, $a3			#move para $a0 o endereco do vetor Vet1
		jal escrita_Vet			#escreve os elementos do vetor Vet1
		la $a0, Vet2			#passando a mensagem que estava na memoria na variavel "Vet2" para o registrador de argumento $a0 (string a ser escrita)
		li $v0, 4				#usando o codigo SysCall para escrever strings
		syscall					#vai imprimir a mensagem que esta em $a0
		move $a0, $a2			#move para $a0 o endereco do vetor Vet2
		jal escrita_Vet			#escreve os elementos do vetor Vet2
		li $v0, 10				#codigo para finalizar o programa
		syscall					#finaliza o programa

		
	leitura_Vet:
		mul $a0, $s0, 4         		#guardando em $a0 N*4 bytes
        li $v0, 9               		#codigo de alocação dinamica help
        syscall                 		#aloca um vetor de N*4 bytes (endereço em $v0)
        move $a3, $v0           		#move endereco de Vet1 para $a3
		li $v0, 9               		#codigo de alocação dinamica help
        syscall   						#aloca um vetor de N*4 bytes (endereço em $v0)
        move $a2, $v0           		#move endereco de Vet2 para $a2
		li $t0, 0						#inicia indice i com 0
	L:
		bge $t0, $s0, RetornaLeitura	#caso o indice i for >= N, va para RetornaLeitura
		mul $t1, $t0, 4					#guarda i*4 em $t1, para calcular o endereco atual
		add $t9, $a3, $t1				#guarda endereco de Vet1 + bytes calculados para ir para a posicao de indice i
		la $a0, Ent1					#passando a mensagem que estava na memoria na variavel "Ent1" para o registrador de argumento $a0 (string a ser escrita)
		li $v0, 4						#usando o codigo SysCall para escrever strings
		syscall							#vai imprimir a mensagem que esta em $a0
		move $a0, $t0					#valor de i para a impressão
		li $v0, 1						#codigo de impressão de inteiro
		syscall							#imprime i
		la $a0, Ent2					#passando a mensagem que estava na memoria na variavel "Ent2" para o registrador de argumento $a0 (string a ser escrita)
		li $v0, 4						#usando o codigo SysCall para escrever strings
		syscall							#vai imprimir a mensagem que esta em $a0
		li $v0, 5						#codigo de leitura de inteiro
		syscall							#leitura do valor (retorna em $v0)
		sw $v0, ($t9)					#armazena valor lido na posicao do vetor atual
		addi $t0, $t0, 1				#incrementa o indice i em 1
		j L								#pula para L novamente
	RetornaLeitura:
		jr $ra							#retorna para a instrucao que chamou a funcao leitura_Vet:


	inverte_vetor:
		li $t0, 0							#inicia indice i com 0
		move $t2, $s0						#guarda em $t2 o tamanho dos vetores Vet1 e Vet2
		addi $t2, $t2, -1					#inicia indice j com N-1
		inverte_i_j:
			bge $t0, $s0, RetornaInverteVet	#caso o indice i for >= N, va para RetornaInverteVet
			mul $t1, $t0, 4					#guarda i*4 em $t1, para calcular o endereco atual
			add $t9, $a3, $t1				#guarda endereco de Vet1 + bytes calculados para ir para a posicao de indice i
			lw $t3, ($t9)					#carrega o inteiro da posicao Vet1[i] em t3
			mul $t1, $t2, 4					#guarda j*4 em $t1, para calcular o endereco atual
			add $t9, $a2, $t1				#guarda endereco de Vet2 + bytes calculados para ir para a posicao de indice j
			sw $t3, ($t9)					#guarda o inteiro da posicao Vet1[i] em $t3 na posicao Vet2[j] em $t9
			addi $t2, $t2, -1				#decrementa o indice j
			addi $t0, $t0, 1				#incrementa o indice i
			j inverte_i_j					#pula para inverte_i_j novamente
		RetornaInverteVet: 
			jr $ra							#retorna para a instrucao que chamou a funcao inverte_vetor


	escrita_Vet:
		li $t0, 0                   	#inicia indice i com 0
		move $a1, $a0               	#guarda em $a1 o endereco do vetor em $a0
	E:
		bge $t0, $s0, RetornaEscrita	#caso o indice i for >= N, va para RetornaEscrita
		mul $t1, $t0, 4					#guarda i*4 em $t1, para calcular o endereco atual
		add $t9, $a1, $t1				#guarda endereco do vetor + bytes calculados para ir para a posicao de indice i
		lw $a0, ($t9)               	#carrega o inteiro da posicao Vet[i] em $a0
		li $v0, 1                   	#codigo de impressão de inteiro       
		syscall                    	 	#imprime o inteiro em $a0
		li $a0, 32                  	#codigo syscall de ASCII para escrever espaco
		li $v0, 11                  	#codigo syscall para imprimir caracteres
		syscall                     	#imprime o espaco
		add $t0, $t0, 1             	#incrementa o indice i
		j E								#pula para E novamente
	RetornaEscrita: 
		jr $ra							#retorna para a instrucao que chamou a funcao escrita_Vet

	Erro:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        j N                     #vai pular para o bloco N novamente
        
	