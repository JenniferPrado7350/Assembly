
.data
	entradaN: .asciiz "Entre com o valor inteiro positivo de N: "
	strAlfabeto: .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	msg_erro: .asciiz "O valor digitado tem que ser inteiro maior que 0. "  

.text
main: 
	N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        blt $v0, 1, Erro        #caso o valor digitado que esta no registrador de valor $v0 for menor que o inteiro "1", vai para Erro
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0, sera o tamanho do vetor

	Estrutura:
		la $a0, strAlfabeto		#passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0
		move $a1, $s0			#passa para $a1 o valor N
		jal Descobre_Combinacoes#pula para a funcao Descobre_Combinacoes
		li $v0, 10				#codigo para finalizar o programa
		syscall 			 	#finaliza o programa
		

	Descobre_Combinacoes: 		
		addi $sp, $sp, -12		#abre 3 espacos na stack
		sw $s0, 0($sp)			#guarda o valor de N em $s0 na stack
		sw $s1, 4($sp)			#guarda o valor em $s1 na stack
		sw $ra, 8($sp)			#guarda o retorno para a main na stack
		add $s0, $a0, $a1 		#$s0 recebe endereco da string strAlfabeto em $a0 + indice i em $a1
		lb $s1, 0($s0)			#guarda em $s1 o caractere em $s0
		sb $zero, 0($s0) 		#guarda o caractere '\0' no lugar do caractere de indice i
		addi $a2, $a1, -1		#$a2 recebe valor em $a1 + (-1)
		li $a1, 0				#$a1 recebe 0
		jal ImprimeCombinacoes	#pula para a funcao ImprimeCombinacoes
		sb $s1, 0($s0)   		#guarda em $s0 o caractere do alfabeto que estava na posicao i.	
		lw $s0, 0($sp)  		#vai recuperar o valor de N na stack
		lw $s1, 4($sp)			#vai recuperar o caractere na stack
		lw $ra, 8($sp)			#vai recuperar o retorno para a main na stack
		addi $sp, $sp, 12		#vai liberar 3 espacos na stack
		jr $ra					#vai retornar para a instrucao que chamou a funcao Descobre_Combinacoes				
		ImprimeCombinacoes: 
			addi $sp, $sp, -20			#abre 5 espacos na stack
			sw $s0, 0($sp)				#guarda o valor de N em $s0 na stack
			sw $s1, 4($sp)				#guarda o valor em $s1 na stack
			sw $s2, 8($sp)				#guarda o valor em $s2 na stack
			sw $s3, 12($sp)				#guarda o valor em $s3 na stack
			sw $ra, 16($sp)				#guarda o retorno para a main na stack
			move $s0, $a0 				#vai guardar em s0 o endereco da string alfabeto
			move $s1, $a1				#vai guardar em s1 o indice do inicio da string
			move $s2, $a2				#vai guardar em s2 o indice do final da string
			bne $s1, $s2, CombinaLetras	#se o indice do inicio da string em $s1 for != do indice do final da string em $s2, va para CombinaLetras
			li $v0, 4               	#usando o codigo SysCall para escrever strings
			syscall						#vai escrever a string 
			li $a0, 10 					#inicia $a0 com o caractere de quebra de linha '\n'
			li $v0, 11					#codigo para imprimir caractere
			syscall 					#vai imprimir o caractere '\n'
	Retorna_Combinacoes:	
			lw $s0, 0($sp)				#vai recuperar o valor de N na stack
			lw $s1, 4($sp)				#vai recuperar o endereco da string na stack
			lw $s2, 8($sp)				#vai recuperar o indice inicial na stack
			lw $s3, 12($sp)				#vai recuperar o indice final na stack
			lw $ra, 16($sp)				#vai recuperar o retorno para a main na stack
			addi $sp, $sp, 20			#vai liberar 5 espacos na stack
			jr $ra						#vai retornar para a instrucao que chamou a funcao ImprimeCombinacoes			

	CombinaLetras:
		addi $s3, $s1, 0 				#$s3 vai receber o indice de inicio da string
		Permutacoes:
			add $a0, $s0, $s1			#guarda em $a0 a soma de $s0 + $s1, caractere
			add $a1, $s0, $s3			#guarda em $a1 a soma de $s0 + $s3, caractere
			jal Retorna_CombinaLetras 	#pula para a funcao Retorna_CombinaLetras
			move $a0, $s0				#passa para $a0 o endereco da string alfabeto em $s0
			addi $a1, $s1, 1			#incrementa $s1 em 1 o indice inicial e guarda em $a1
			move $a2, $s2				#passa para $a2 o indice final em $s2
			jal ImprimeCombinacoes		#pula para a funcao ImprimeCombinacoes
			add $a0, $s0, $s1			#$a0 recebe o endereco da string + valor em $s1
			add $a1, $s0, $s3			#$a1 recebe o endereco da string + valor em $s3
			jal Retorna_CombinaLetras  	#pula para a funcao Retorna_CombinaLetras
			addi $s3, $s3, 1 			#incrementa o indice i
			ble $s3, $s2, Permutacoes 	#se o indice i for <= indice final, va para  Permutacoes
			lw $s0, 0($sp)				#vai recuperar o valor de N na stack
			lw $s1, 4($sp)				#vai recuperar o endereco da string na stack
			lw $s2, 8($sp)				#vai recuperar o indice inicial na stack
			lw $s3, 12($sp)				#vai recuperar o indice final na stack
			lw $ra, 16($sp)				#vai recuperar o retorno para a main na stack
			addi $sp, $sp, 20			#vai liberar 5 espacos na stack
			jr $ra						#vai retornar para a instrucao que chamou a funcao ImprimeCombinacoes
	Retorna_CombinaLetras: 				
		addi $sp, $sp, -8				#abre 2 espacos na stack
		sw $s0, 0($sp)					#guarda o valor de $s0 na stack
		sw $s1, 4($sp)					#guarda o valor de $s1 na stack
		lb $s0, 0($a0)					#vai recuperar o valor de $a0 e guardar em $s0
		lb $s1, 0($a1)					#vai recuperar o valor de $a1 e guardar em $s1
		sb $s1, 0($a0)     				#guarda em $a0 o valor em $s1, inverte os caracteres
		sb $s0, 0($a1)					#guarda em $a1 o valor em $s0, inverte os caracteres
		lw $s0, 0($sp)  				#vai recuperar o endereco da string na stack
		lw $s1, 4($sp)					#vai recuperar o valor na stack e guardar em $s1
		addi $sp, $sp, 8				#vai liberar 2 espacos na stack
		jr $ra							#vai retornar para a instrucao que chamou a funcao ImprimeCombinacoes

	Erro:
	li $v0, 4               #usando o codigo SysCall para escrever strings      
	la $a0, msg_erro        #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
	syscall                 #vai imprimir a mensagem que esta em $a0
	j N                   	#vai pular para o bloco N novamente