.data
 buffer: .asciiz " "
 Arquivo: .asciiz "vet.txt"
 entrada: .asciiz "Entre com o valor inteiro de N (N >= 0): "
 Erro: .asciiz "Arquivo nao encontrado!\n"
 .text
 main:
	li $t7, 0               #vai guardar o numero de caracteres do arquivo
	li $s6, 0               #vai guardar a quantidade de numeros no arquivo
 	li $s3, 0               #inicio o somatorio para os numeros
 	la $a0, Arquivo         #Nome do arquivo
 	li $a1, 0 	            #Somente leitura
 	jal abertura 	        #Retorna file descriptor no sucesso
 	move $s0, $v0 	        #Salva o file descriptor em $s0
    la $a0, entrada         #passando a string em entrada para $a0
    li $v0, 4               #vai imprimir a string em $a0
    syscall                 #imprime a string
    li $v0, 5               #codigo para ler inteiro
    syscall                 #le o inteiro
    blt $v0, 0, finaliza    #se N < 0 vá para finaliza
    move $t2, $v0           #guardo em $t2 o valor de N
 	jal Leitura 	        #Retorna em $v0 o num. de carac.
 	li $v0, 16 	            #Codigo para fechar o arquivo
 	move $a0, $s0 	        #Parametro file descriptor
	syscall 	            #Fecha o arquivo
	jal Arquivo_Para_Vetor  #vai ler o arquivo e guardar os numeros em um vetor
	move $a0, $v0 	        #endereco do vetor
	jal ImprimeVetor		#imprime mudanca
 	li $v0, 10 	            #Codigo para finalizar o programa
 	syscall 	            #Finaliza o programa
 	
 		
 Leitura:
 	move $a0, $s0 		        #Parametro file descriptor
 	la $a1, buffer 		        #Buffer de entrada
 	li $a2, 1 		            #1 caractere por leitura
 	li $v0, 14 		            #Codigo de leitura de arquivo
 	syscall 		            #Faz a leitura de 1 caractere
 	beqz $v0, Saida 	        #if(ch != EOF) goto Saida
 	move $a0, $a1  		        #recebe o caractere lido
    	lb $t1, ($a1)    	    #passo o valor lido pata $t1
    	subi $t1, $t1, 48  		#converto em int
    	li $s1, -16     		#32(ASCII do espaco) - 48 = -16
    	bne $t1, $s1, Multiplica#se o valor lido nao for o espaco va para Multiplica
    	beq $t1, $s1, Divide    #se for o espaco precisamos dividir o numero por 10, pois multiplicamos devido ao ultimo numero
		Qtd_Numero_Arq: 
			addi $s6, $s6, 1    #incremento a quantidade de numeros no arquivo
			li $s3, 0
			beqz $v0, Retorna   # se for o final do arquivo, encerra laco	
			j Leitura
 	Saida:
 		j Divide   		        #vai finalizar o ultimo valor do arquivo
 		Retorna:
 			jr $ra 		        # Retorna para a main
 		
 Multiplica:
 	add $s3, $s3, $t1    #adiciono o(s) numero(s) entre os espacos
 	mul $s3, $s3, 10     #multiplico por 10 para aumentar uma  casa numerica (dezena, centena, milhar...)
 	j Leitura	
 	
 Divide:
 	div $s3, $s3, 10    #divido por 10 caso tenha apenas um numero entre os espacos ou caso o caractere seja o ultimo da sequencia
 	j Qtd_Numero_Arq	
 	
 	
 Arquivo_Para_Vetor:
    li $t3, 0                       #inicio $t3 com 0
 	subi $sp, $sp, 4     		    #Espaco para 1 item na pilha
    sw $ra, ($sp)        		    #salva o retorno para a main
 	la $a0, Arquivo 		        #Nome do arquivo
 	li $a1, 0 			            #Somente leitura
 	jal abertura 			        #Retorna file descriptor no sucesso
 	move $s0, $v0 			        #Salva o file descriptor em $s0
 	mul $s1, $s6, 4         	    #guardando em $s1 N*4 bytes
        move $a0, $s1           	#passando N*4 bytes guardados em $s1 para o registrador de argumento $a0
        li $v0, 9               	#Codigo SysCall de alocacao dinamica
        syscall                 	#aloca N*4 bytes (endereco em $v0)
        move $t1, $v0           	#move vet para $t1
        move $t0, $t1           	#move vet em $t1 para $t0
     Leitura_Arq_Para_Vet:
 	move $a0, $s0 			    #Parametro file descriptor
 	la $a1, buffer 			    #Buffer de entrada
 	li $a2, 1 			        #1 caractere por leitura
 	li $v0, 14 			        #Codigo de leitura de arquivo
 	syscall 			        #Faz a leitura de 1 caractere
 	beqz $v0, Saida_Vet 		#if(ch != EOF) goto Saida_Vet 
    	lb $t8, ($a1)    		#passo o valor lido pata $t8
    	subi $t8, $t8, 48  		#converto em int
    	li $s1, -16     		#32(ASCII do espaco) - 48 = -16
    	beq $t8, $s1, Divide_Num#se o valor lido for o espaco va para Divide_Num
    	add $s3, $s3, $t8    	#adiciono o(s) numero(s) entre os espacos
 	mul $s3, $s3, 10     		#multiplico por 10 para aumentar uma  casa numerica (dezena, centena, milhar...)
 	j Leitura_Arq_Para_Vet	
    Divide_Num:
    	div $s3, $s3, 10            #divido por 10 caso tenha apenas um numero entre os espacos ou caso o caractere seja o ultimo da sequencia
        bne $t3, $t2, Nao_Posicao   #se o indice i(posicao atual no vetor) nao for a posicao N escolhida pelo usuario, va para Nao_Posicao
        addi $s3, $s3, 1            #incremento uma unidade na posicao escolhida pelo usuario
    Nao_Posicao:
    	sw $s3, ($t0)	            #guardo o numero lido do arquivo no vetor vet[i]
    	addi $t0, $t0, 4            #$t0 aponta para a proxima posicao do vetor, vet[i+1]
        addi $t3, $t3, 1            #incremento $t3 em 1, $t3 é o elemento i
    	li $s3, 0
	beqz $v0, Retorna_Vet           # se for o final do arquivo, encerra laco	
	j Leitura_Arq_Para_Vet
     Saida_Vet:
     	j Divide_Num
     	Retorna_Vet:
     		li $v0, 16	    #Codigo para fechar o arquivo
 		move $a0, $s0 	    #Parametro file descriptor
		syscall 	        #Fecha o arquivo
 		move $v0, $t1 	    #Move o vet resultado para retorno
 		lw $ra, ($sp)       #recupera o retorno para a main
        addi $sp, $sp, 4    #libera o espa�o na pilha
 		jr $ra 		        #Retorna para a main

	ImprimeVetor:
	move $t1, $a0           		#move vet para $t1
    move $t0, $t1           		#move vet em $t1 para $t0
    li $t3, 0                       #inicio $t3 com 0
 	subi $sp, $sp, 4     		    #Espaco para 1 item na pilha
    sw $ra, ($sp)        		    #salva o retorno para a main
 	la $a0, Arquivo 				#vai carrega o nome do arquivo
    li $a1, 1       				#somente escrita
    jal abertura    				#abre o arquivo de nome guardado em "Arquivo" ou cria caso não exista
    move $s0, $v0   				#parâmetro file descriptor
    ImprimeNumeroVet:
		lw $a0, ($t0)
		j ImprimeNumero
		Continua_Impressao:
			addi $t0, $t0, 4            #$t0 aponta para a proxima posicao do vetor, vet[i+1]
			addi $t3, $t3, 1
			bge $t3, $s6 RetornaNumeroVet       # se for o final do arquivo, encerra laco	
			j ImprimeNumeroVet

     	RetornaNumeroVet:
     		li $v0, 16	    	#Codigo para fechar o arquivo
			move $a0, $s0 	    #Parametro file descriptor
			syscall 	        #Fecha o arquivo
			lw $ra, ($sp)       #recupera o retorno para a main
			addi $sp, $sp, 4    #libera o espa�o na pilha
			jr $ra 		        #Retorna para a main
 	
    ImprimeNumero:
        move $a3, $a0                   #passo o numero que será impresso para $a3
        move $a0, $s0                   #carrego o file descriptor em $a0
        la $a1, buffer                  #carrego o buffer em $a1
        li $a2, 1                       #imprimir apenas um caractere
        bnez $a3, NumeroDiferenteDeZero #se o numero que for ser impresso for != de 0 vá para NumeroDiferenteDeZero
        li $v0, 15                      #codigo para escrever caractere
        li $s1, '0'                     #vai escrever o caractere 0
        sb $s1, ($a1)                   #vai armazenar o caractere 0 no buffer de escrita
        syscall                         #escreve o caractere no arquivo
        jr $ra                          #retorna para a função que a chamou

    NumeroDiferenteDeZero:
        li $s1, 0                   #inicio $s1 com 0
        li $s2, 10                  #inicio $s2 com 10
        bgtz $a3, IteracaoNumero    #se o numero for > 0 vá para IteracaoNumero
        li $t4, '-'                 #carrego o caractere - em $t4
        sb $t4, ($a1)               #amazeno este caractere no buffer de escrita
        li $v0, 15                  #codigo para escrever caractere
        syscall                     #escreve o caractere no arquivo
        mul $a3, $a3, -1            #multiplico valor em $a3 por -1
    IteracaoNumero: 
        subi $sp, $sp, 1            #espaco para 1 caractere na pilha
        addi $s1, $s1, 1            #incremento valor em $s1 com 1
        div $a3, $s2                #divido o numero por 10
        mfhi $t4                    #$t4 irá guardar o caractere de resto da divisão
        addi $t4, $t4, '0'          #adiciono ao caractere $t4 o caractere 0
        sb $t4, ($sp)               #guardo o caractere em $t4 na pilha
        mflo $a3                    #guardo em $a3 a parte inteira da divisão
        bgtz $a3, IteracaoNumero    #se o numero for > 0 vá para IteracaoNumero
    EscreveNumero:
        lb $t4, ($sp)               #vai carregar o caractere da pilha
        sb $t4, ($a1)               #irá armazenar o valor em $t4 no buffer de escrita
        li $v0, 15                  #codigo para escrever caractere
        syscall                     #escreve no arquivo o caractere
        addi $sp, $sp, 1            #irá liberar um espaco na pilha
        subi $s1, $s1, 1            #decremento o digito($s1) em 1
        bgtz $s1, EscreveNumero     #se o digito em $s1 for > 0 vá para EscreveNumero
        li $t4, ' '                 #carrego o espaço em $t4
        sb $t4, ($a1)               #armazeno o espaço no buffer de escrita
        li $v0, 15                  #codigo para escrever caractere
        syscall                     #vai escrever o caractere no arquivo
        j Continua_Impressao        #pula para Continua_Impressao
        
 abertura:
 	li $v0, 13 # Codigo de abertura de arquivo
 	syscall # Tenta abrir o arquivo
 	bgez $v0, a # if(file_descriptor >= 0) goto a
 	la $a0, Erro # else erro: carrega o endereco da string
 	li $v0, 4 # Codigo de impressao de string
 	syscall # Imprime o erro
 	li $v0, 10 # Codigo para finalizar o programa
 	syscall # Finaliza o programa
 	a: jr $ra # Retorna para a main

finaliza:
        move $a0, $s0       #file descriptor
        li $v0, 16          #codigo para fechar um arquivo
        syscall             #fecha o arquivo
        li $v0, 10          #codigo para finalizar o programa
        syscall             #finaliza o programa   

        
