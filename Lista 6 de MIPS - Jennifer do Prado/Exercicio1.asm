.data
 buffer: .asciiz " "
 Arquivo: .asciiz "dados1.txt"
 Maior: .asciiz "\n\na) Maior Valor: "
 Menor: .asciiz "\n\nb) Menor Valor: "
 Impares: .asciiz "\n\nc) Numero de Valores Impares: "
 Pares: .asciiz "\n\nd) Numero de Valores Pares: "
 Soma: .asciiz "\n\ne) Soma dos Valores: "
 Crescente: .asciiz "\n\nf) Os Valores em Ordem Crescente: "
 Decrescente: .asciiz "\n\ng) Os Valores em Ordem Decrescente: "
 Produto: .asciiz "\n\nh) Produto dos Valores: "  
 Nmr_Carac_Arq: .asciiz "\n\ni) Numero de Caracteres do Arquivo(com o caractere Space incluso): " 
 Erro: .asciiz "Arquivo nao encontrado!\n"
 .text
 main:
	li $t2, 0 #vai guardar o maior valor 
	li $t3, 999999999 #vai guardar o menor valor 
	li $t4, 0 #vai guardar o numero de elementos pares 
	li $t5, 0 #vai guardar o numero de elementos impares 
	li $t6, 1 #vai guardar o produto dos elementos  
	li $t7, 0 #vai guardar o numero de caracteres do arquivo
	li $s6, 0 #vai guardar a quantidade de numeros no arquivo
	li $s2, 0 #inicio o somatorio final com 0
 	li $s3, 0 #inicio o somatorio para os numeros
 	la $a0, Arquivo #Nome do arquivo
 	li $a1, 0 	#Somente leitura
 	jal abertura 	#Retorna file descriptor no sucesso
 	move $s0, $v0 	#Salva o file descriptor em $s0
 	jal Leitura 	#Retorna em $v0 o num. de carac.
 	li $v0, 16 	#Codigo para fechar o arquivo
 	move $a0, $s0 	#Parametro file descriptor
	syscall 	#Fecha o arquivo
	jal Arquivo_Para_Vetor   #vai ler o arquivo e guardar os numeros em um vetor
	move $a1, $v0 	#salva o vet retornado da funcao
	jal Impressao   #imprime os resultados
 	li $v0, 10 	#Codigo para finalizar o programa
 	syscall 	#Finaliza o programa
 	
 	
 Impressao:
 	subi $sp, $sp, 4     		#Espaço para 1 item na pilha
        sw $ra, ($sp)        		#salva o retorno para a main
 	Impressao_Maior:
 		la $a0, Maior  	     #carrega a informacao armazenada no endereco da string Maior
        	li $v0, 4            #usando o codigo SysCall para escrever strings
        	syscall              #escrevendo a string
 		move $a0, $t2	     #passo o maior valor para $a0
 		li $v0, 1	     #codigo para imprimir inteiro 
 		syscall              #imprime inteiro
 	Impressao_Menor:
 		la $a0, Menor  	     #carrega a informacao armazenada no endereco da string Menor
        	li $v0, 4            #usando o codigo SysCall para escrever strings
        	syscall              #escrevendo a string
 		move $a0, $t3	     #passo o menor valor para $a0
 		li $v0, 1	     #codigo para imprimir inteiro 
 		syscall              #imprime inteiro
 	Impressao_Impares:
 		la $a0, Impares      #carrega a informacao armazenada no endereco da string Impares
        	li $v0, 4            #usando o codigo SysCall para escrever strings
        	syscall              #escrevendo a string
 		move $a0, $t5	     #passo numero de Impares para $a0
 		li $v0, 1	     #codigo para imprimir inteiro 
 		syscall              #imprime inteiro
 	Impressao_Pares:
 		la $a0, Pares        #carrega a informacao armazenada no endereco da string Pares
        	li $v0, 4            #usando o codigo SysCall para escrever strings
        	syscall              #escrevendo a string
 		move $a0, $t4	     #passo numero de Pares para $a0
 		li $v0, 1	     #codigo para imprimir inteiro 
 		syscall              #imprime inteiro
 	Impressao_Soma:
		la $a0, Soma  	     #carrega a informacao armazenada no endereco da string Soma
        	li $v0, 4            #usando o codigo SysCall para escrever strings
        	syscall              #escrevendo a string
 		move $a0, $s2	     #passo a soma para $a0
 		li $v0, 1	     #codigo para imprimir inteiro 
 		syscall              #imprime inteiro
 	Impressao_Crescente:
		la $a0, Crescente    #carrega a informacao armazenada no endereco da string Crescente
        	li $v0, 4            #usando o codigo SysCall para escrever strings
        	syscall              #escrevendo a string
        	jal Ordena_Vet_Crescente #vai ordenar o vetor vet de forma crescente
		move $a1, $v0 	     #salva o vet retornado da funcao
		jal escrita	     #imprime o vetor crescente
		move $a1, $v0 	     #salva o vet retornado da funcao
	Impressao_Decrescente:
		la $a0, Decrescente  #carrega a informacao armazenada no endereco da string Decrescente
        	li $v0, 4            #usando o codigo SysCall para escrever strings
        	syscall              #escrevendo a string
        	jal Ordena_Vet_Decrescente #vai ordenar o vetor vet de forma decrescente
		move $a1, $v0 	     #salva o vet retornado da funcao
		jal escrita	     #imprime o vetor decrescente
		move $a1, $v0 	     #salva o vet retornado da funcao
 	Impressao_Produto:
		la $a0, Produto      #carrega a informacao armazenada no endereco da string Produto
        	li $v0, 4            #usando o codigo SysCall para escrever strings
        	syscall              #escrevendo a string
 		move $a0, $t6	     #passo o Produto para $a0
 		li $v0, 1	     #codigo para imprimir inteiro 
 		syscall              #imprime inteiro
 	Impressao_Nmr_Carac_Arq:
		la $a0, Nmr_Carac_Arq#carrega a informacao armazenada no endereco da string Nmr_Carac_Arq
        	li $v0, 4            #usando o codigo SysCall para escrever strings
        	syscall              #escrevendo a string
 		move $a0, $t7	     #passo o numero de caracteres do arquivo para $a0
 		li $v0, 1	     #codigo para imprimir inteiro 
 		syscall              #imprime inteiro
 	Retorna_Impressao:
 		lw $ra, ($sp)        #recupera o retorno para a main
        	addi $sp, $sp, 4     #libera o espaço na pilha
 		jr $ra 		     #Retorna para a main
 	
 		
 Leitura:
 	move $a0, $s0 		#Parametro file descriptor
 	la $a1, buffer 		#Buffer de entrada
 	li $a2, 1 		#1 caractere por leitura
 	li $v0, 14 		#Codigo de leitura de arquivo
 	syscall 		#Faz a leitura de 1 caractere
 	beqz $v0, Saida 	#if(ch != EOF) goto Saida
 	move $a0, $a1  		#recebe o caractere lido
    	li $v0, 4      		#codigo de impressao de caractere
    	syscall        		#imprime o espaco
    	lb $t1, ($a1)    	#passo o valor lido pata $t1
    	subi $t1, $t1, 48  	#converto em int
    	li $s1, -16     	#32(ASCII do espaco) - 48 = -16
    	Numero_Caracteres:
		addi $t7, $t7, 1 #incremento o numero de caracteres no arquivo
    	bne $t1, $s1, Multiplica #se o valor lido nao for o espaco va para Multiplica
    	beq $t1, $s1, Divide     #se for o espaco precisamos dividir o numero por 10, pois multiplicamos devido ao ultimo numero
    	Maior_valor:
			ble	$s3, $t2, Menor_valor	#se o valor lido entre espacos for <= que o maior valor em $t2 va para Menor_valor
			move $t2, $s3   		#$t2 recebe um novo maior valor 
		Menor_valor:
			bge	$s3, $t3, Numero_Impares#se o valor lido entre espacos for >= que o menor valor em $t3 va para Menor_valor
			move $t3, $s3   		#$t3 recebe um novo menor valor 
		Numero_Impares:
			li $s4, 2		#guardo 2 em $s4 para realizar a divisao
			div	$s3, $s4	#divido o numero lido entre parenteses para verificar se e impar
			mfhi $s5		#guardo o resto da divisao em $s5
			beq	$s5, 0, Numero_Pares	#se o resto da divisao em $s5  == 0 entao va para Numero_Pares
			addi $t5, $t5, 1 #incremento o numero de impares
			j Qtd_Numero_Arq
		Numero_Pares:
			addi $t4, $t4, 1 #incremento o numero de pares
		Qtd_Numero_Arq: 
			addi $s6, $s6, 1 #incremento a quantidade de numeros no arquivo
			li $s3, 0
			beqz $v0, Retorna# se for o final do arquivo, encerra laco	
			j Leitura
 	Saida:
 		j Divide   		 #vai fazer a verificaçao de maior, menor, produto, soma... com o ultimo valor
 		Retorna:
 			jr $ra 		 # Retorna para a main
 		
 Multiplica:
 	add $s3, $s3, $t1    #adiciono o(s) numero(s) entre os espacos
 	mul $s3, $s3, 10     #multiplico por 10 para aumentar uma  casa numerica (dezena, centena, milhar...)
 	j Leitura	
 	
 Divide:
 	div $s3, $s3, 10    #divido por 10 caso tenha apenas um numero entre os espacos ou caso o caractere seja o ultimo da sequencia
 	add $s2, $s2, $s3   #realizo a soma dos numeros ja convertidos em int e como unidade, dezena, centena, etc
 	mul $t6, $t6, $s3   #realizo o produto dos numeros ja convertidos em int e como unidade, dezena, centena, etc
 	j Maior_valor	
 	
 	
 Arquivo_Para_Vetor:
 	subi $sp, $sp, 4     		#Espaço para 1 item na pilha
        sw $ra, ($sp)        		#salva o retorno para a main
 	la $a0, Arquivo 		#Nome do arquivo
 	li $a1, 0 			#Somente leitura
 	jal abertura 			#Retorna file descriptor no sucesso
 	move $s0, $v0 			#Salva o file descriptor em $s0
 	mul $s1, $s6, 4         	#guardando em $s1 N*4 bytes
        move $a0, $s1           	#passando N*4 bytes guardados em $s1 para o registrador de argumento $a0
        li $v0, 9               	#Codigo SysCall de alocação dinamica
        syscall                 	#aloca N*4 bytes (endereço em $v0)
        move $t1, $v0           	#move vet para $t1
        move $t0, $t1           	#move vet em $t1 para $t0
     Leitura_Arq_Para_Vet:
 	move $a0, $s0 			#Parametro file descriptor
 	la $a1, buffer 			#Buffer de entrada
 	li $a2, 1 			#1 caractere por leitura
 	li $v0, 14 			#Codigo de leitura de arquivo
 	syscall 			#Faz a leitura de 1 caractere
 	beqz $v0, Saida_Vet 		#if(ch != EOF) goto Saida_Vet 
    	lb $t8, ($a1)    		#passo o valor lido pata $t8
    	subi $t8, $t8, 48  		#converto em int
    	li $s1, -16     		#32(ASCII do espaco) - 48 = -16
    	beq $t8, $s1, Divide_Num 	#se o valor lido for o espaco va para Divide_Num
    	add $s3, $s3, $t8    		#adiciono o(s) numero(s) entre os espacos
 	mul $s3, $s3, 10     		#multiplico por 10 para aumentar uma  casa numerica (dezena, centena, milhar...)
 	j Leitura_Arq_Para_Vet	
    Divide_Num:
    	div $s3, $s3, 10    #divido por 10 caso tenha apenas um numero entre os espacos ou caso o caractere seja o ultimo da sequencia
    	sw $s3, ($t0)	    #guardo o numero lido do arquivo no vetor vet[i]
    	addi $t0, $t0, 4    #$t0 aponta para a proxima posicao do vetor, vet[i+1]
    	li $s3, 0
	beqz $v0, Retorna_Vet  # se for o final do arquivo, encerra laco	
	j Leitura_Arq_Para_Vet
     Saida_Vet:
     	j Divide_Num
     	Retorna_Vet:
     		li $v0, 16	#Codigo para fechar o arquivo
 		move $a0, $s0 	#Parametro file descriptor
		syscall 	#Fecha o arquivo
 		move $v0, $t1 	#Move o vet resultado para retorno
 		lw $ra, ($sp)   #recupera o retorno para a main
        	addi $sp, $sp, 4#libera o espaço na pilha
 		jr $ra 		#Retorna para a main
 			
 Ordena_Vet_Crescente:
        move $t0, $a1                   #guarda o endereco base de vet em $t0
        add $s4, $s6, 0                 #passando o tamanho N do vetor para registrador temporario $s4
        subi $s4, $s4, 1                #decrementando o valor de $s4(indice j) em 1 para iniciar o laco
        Percorre_Elemento1:             #é a primeira estrutura de repeticao for, funciona como: for(j = N-1 ; j>=1 ; j--)
            li $s5, 0                   #inicia o indice i do vetor com 0
            beq	$s5, $s4, Retorna_Cresc	#se i == j entao va para a funcao Retorna_Cresc
            move $t1, $t0               #guarda o endereco de vet em $t1
            move $t9, $t0               #guarda o endereco de vet em $t9
            add $t9, $t9, 4             #o registrador temporario $t9 recebe o endereco de vet[i+1]
            Percorre_Elemento2:         #é a segunda estrutura de repeticao for, funciona como: for(i = 0 ; i<j ; i++)
                lw $s1, ($t1)           #o registrador $s1 recebe o valor armazenado no endereco $t1, ou seja, vet[i]
                lw $s2, ($t9)           #o registrador $s2 recebe o valor armazenado no endereco $t9, ou seja, vet[i+1]
                ble $s1, $s2, Proximo_Laco	#se vet[i] <= vet[i+1] entao va para a funcao Proximo_Laco, pois não precisaremos trocar os numeros de lugar                 
                    sw $s2, ($t1)       #guarda o inteiro que estava em $t9(vet[i+1]) em $t1(vet[i])
                    sw $s1, ($t9)       #guarda o inteiro que estava em $t1(vet[i]) em $t9(vet[i+1])
                Proximo_Laco:
                    add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de vet[i+1]
                    add $t9, $t9, 4      #o registrador temporario $t9 recebe o endereco de vet[i+2]
                    addi $s5, $s5, 1     #incrementa o indice i do vetor em 1
                    blt	$s5, $s4, Percorre_Elemento2	#se $s5 < $s4, ou seja, se i < j, então va para Percorre_Elemento2
                    
            subi $s4, $s4, 1             #decrementa o indice j do vetor em 1
            bge $s4, 1, Percorre_Elemento1 # se j >= 1 va para a funcao Percorre_Elemento1
        Retorna_Cresc:
            move $v0, $t0                #devolve endereco de vet para retorno da funcao
            jr $ra                       #retorna para a funcao main Estrutura
           
    Ordena_Vet_Decrescente:
        move $t0, $a1        #guarda o endereco base de vet em $t0
        move $t1, $t0        #guarda o endereco do Vetor em $t1
        move $t9, $t0        #guarda o endereco do Vetor em $t9
        subi $s5, $s6, 1     #passando o tamanho N-1 do vetor para registrador $s5, será o indice j(ultimo indice do vetor)
        mul $s2, $s5, 4      #(N-1)*4
        add $t9, $t9, $s2    #o registrador temporario $t9 recebe o endereco do ultimo elemento do Vetor (Vet[j])
        li $s4, 0            #inicio registrador $s4 com 1, será o indice i
    Ord_Dec: 
        lw $s1, ($t1)           #o registrador $s1 recebe o valor armazenado no endereco $t1, ou seja, vet[i]
        lw $s2, ($t9)           #o registrador $s2 recebe o valor armazenado no endereco $t9, ou seja, vet[j]                
        sw $s1, ($t9)           #guarda o inteiro que estava em $t1(vet[i]) em $t9(vet[j])
        sw $s2, ($t1)           #guarda o inteiro que estava em $t9(vet[j]) em $t1(vet[i])
        add $t1, $t1, 4         #o registrador temporario $t1 recebe o endereco de Vetor[i+1]
        sub $t9, $t9, 4         #o registrador temporario $t9 recebe o endereco de Vetor[j-1]
        lw $s1, ($t1)           #o registrador $s1 recebe o valor armazenado no endereco $t1, ou seja, vet[i]
        lw $s2, ($t9)           #o registrador $s3 recebe o valor armazenado no endereco $t9, ou seja, vet[j] 
        addi $s4, $s4, 1        # i = i + 1
        subi $s5, $s5, 1        # j = j - 1
        blt $s4, $s5, Ord_Dec      #se i < j  va para Ord_Dec        
        move $v0, $t0        #devolve endereco de vet para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura
 	
    escrita:
        move $t0, $a1        #guarda o endereco base de Vet
        move $t1, $t0        #guarda o endereco de Vet em $t4
        li $s0, 0            #inicia o indice i do vetor com 0
        addi $s0, $s0, 1     #incrementa o indice i do vetor em 1, para iniciar com 1
      E:lw $a0, ($t1)        #carrega o valor do inteiro armazenado na posicao Vet[i]
        li $v0, 1            #usando o codigo SysCall para escrever inteiros        
        syscall              #escrevendo o inteiro
        li $a0, 32           #usando o codigo SysCall de ASCII para escrever espaco
        li $v0, 11           #usando o codigo SysCall para imprimir caracteres
        syscall              #escrevendo o espaco
        add $t1, $t1, 4      #o registrador temporario $t4 recebe o endereco de Vet[i+1]
        addi $s0, $s0, 1     #incrementa o indice i do vetor em 1
        ble $s0, $s6, E      #se i <= N, va para E
        move $v0, $t0        #devolve endereco de Vet para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura
        
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

        
