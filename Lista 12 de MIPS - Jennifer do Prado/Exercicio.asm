.data 
        entrada: .asciiz "Vet["                              #criando uma variavel na memoria que ira guardar o texto de entrada de Vet
        fim_vet: .asciiz "]= "                                                     #criando uma variavel na memoria que ira guardar o texto de fechamento de Vet
        entradaN: .asciiz "Entre com o numero de elementos: "                     #criando uma variavel na memoria que ira guardar o texto de entrada N
        menorSoma: .asciiz "\na) O numero de elementos menores que a soma dos N elementos lidos e = "
        elementosImpares: .asciiz "\nb) O numero de elementos impares e = "
        NaoTemMenores: .asciiz "Nao ha elementos menores que o somatorio dos N elementos do no vetor! "
        NaoTemImpares: .asciiz "Nao ha elementos impares no vetor! "
        NaoTemPares: .asciiz "Nao ha elementos pares no vetor! "
        prodPosicao: .asciiz "\nc) O produto da posicao do menor elemento par do vetor com a posicao do maior elemento impar do vetor e = "
        vetDescres: .asciiz "\nd) O vetor ordenado de forma decrescente = "
        msg_erro: .asciiz "O valor digitado tem que ser inteiro e maior que 0. "  #criando uma variavel na memoria que ira guardar o texto de erro caso o numero digitado seja 0 ou negativo
.align 2

.text

.main: 
    N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        ble $v0, 0, Erro        #caso o valor digitado que esta no registrador de valor $v0 for menor ou igual ao inteiro "0", vai para Erro
        add $s0, $v0, $zero     #guarda em $s0 o n�mero digitado "N" que esta em $v0

    Estrutura:
        li $t5, 0           #vai guardar a qtd de numeros impares
        li $s6, 0           #vai guardar a posicao do menor elemento par do vetor
        li $s7, 0           #vai guardar a posicao do maior elemento impar do vetor
        li $t6, 3           #vai guardar o menor elemento par do vetor
        li $t7, 2           #vai guardar o maior elemento impar do vetor
        li $t8, 0           #vai guardar a soma dos N elementos
        li $t4, 0           #vai guardar a qntd de elementos menor que os N elementos lidos
        jal leitura         #le o vetor vet
        move $a1, $v0       #Coloca o endereco do vetor retornado da funcao "leitura" em $a1
        move $a0, $a1       #Coloca o endereco do vetor de $a1 em $a0
        jal VerificaMenoresSoma 
        jal Impressao       #vai imprimir o resultado   
        move $a0, $a1       #Coloca o endereco do vetor de $a1 em $a0
        jal proc_ord        #ordena o vetor vet em ordem descrescente
        move $a0, $v0       #Coloca o endereco do vetor retornado da funcao "ordena" em $a0
        jal escrita         #printa o vetor vet
        li $v0, 10          #Codigo usado para finalizar o programa
        syscall             #Finaliza o programa

    Impressao:
        Impressao_Nmr_Menor_Somatorio:
            la $a0, menorSoma               #carrega a informacao armazenada no endereco da string menorSoma
            li $v0, 4                       #usando o codigo SysCall para escrever strings
            syscall                         #escrevendo a string
            beq $t4, 0, NaoMenores
                move $a0, $t4	                #passo a quantidade de numeros menores que o somatorio
                li $v0, 1	                    #codigo para imprimir inteiro 
                syscall                         #imprime inteiro
                j Impressao_Impares
            NaoMenores:
                la $a0, NaoTemMenores           #carrega a informacao armazenada no endereco da string NaoTemMenores
                li $v0, 4                       #usando o codigo SysCall para escrever strings
                syscall                         #escrevendo a string
        Impressao_Impares:
            la $a0, elementosImpares        #carrega a informacao armazenada no endereco da string elementosImpares
            li $v0, 4                       #usando o codigo SysCall para escrever strings
            syscall                         #escrevendo a string
            beq $t5, 0, NaoHaImpar
                move $a0, $t5	                #passo numero de Impares para $a0
                li $v0, 1	                    #codigo para imprimir inteiro 
                syscall                         #imprime inteiro
                j Impressao_Produto
            NaoHaImpar:
                la $a0, NaoTemImpares           #carrega a informacao armazenada no endereco da string NaoTemImpares
                li $v0, 4                       #usando o codigo SysCall para escrever strings
                syscall                         #escrevendo a string
        Impressao_Produto:
            la $a0, prodPosicao        #carrega a informacao armazenada no endereco da string prodPosicao
            li $v0, 4                       #usando o codigo SysCall para escrever strings
            syscall                         #escrevendo a string
            beq $t6, 3, SemPares
            VerificaImpar:
            beq $t7, 2, SemImpares           
                mul $t8, $s7, $s6               #produto das posicao
                move $a0, $t8	                #passo o produto para $a0
                li $v0, 1	                    #codigo para imprimir inteiro 
                syscall                         #imprime inteiro
                j RetornaImp
            SemPares:
                la $a0, NaoTemPares             #carrega a informacao armazenada no endereco da string NaoTemPares
                li $v0, 4                       #usando o codigo SysCall para escrever strings
                syscall                         #escrevendo a string
                j VerificaImpar
            SemImpares:
                la $a0, NaoTemImpares           #carrega a informacao armazenada no endereco da string NaoTemImpares
                li $v0, 4                       #usando o codigo SysCall para escrever strings
                syscall                         #escrevendo a string
        RetornaImp:
            jr $ra                              #retorna para a funcao main Estrutura

    leitura:
    	mul $s1, $s0, 4      #guardando em $s1 N*4 bytes
        move $a0, $s1        #passando N*4 bytes guardados em $s1 para o registrador de argumento $a0
        li $v0, 9            #codigo de aloca��o dinamica help
        syscall              #aloca N*4 bytes (endere�o em $v0)
        move $t0, $v0        #move para $t0
        move $t1, $t0        #guarda o endereco do Vetor em $t1
        li $t2, 0            #inicia o indice i do vetor com 0
    L:  la $a0, entrada      #carrega a informacao armazenada no endereco da string entrada
        li $v0, 4            #usando o codigo SysCall para escrever strings
        syscall              #escrevendo a string
        move $a0, $t2        #carrega o indice i do vetor
        li $v0, 1            #usando o codigo SysCall para escrever inteiros
        syscall              #escrevendo o inteiro
        la $a0, fim_vet      #carrega a informacao armazenada no endereco da string fim_vet
        li $v0, 4            #usando o codigo SysCall para escrever strings
        syscall              #escrevendo a string
        li $v0, 5            #usando o codigo SysCall para ler inteiros
        syscall              #lendo o inteiro
        sw $v0, ($t1)        #guarda o inteiro lido em vet[i]
        move $s3, $v0        #numero lido em $s3
        add $t8, $t8, $s3    #somatorios dos N eleemntos
        proc_num_impar:     #funcao para analizar a qtd de impares
			li $s4, 2		#guardo 2 em $s4 para realizar a divisao
			div	$s3, $s4	#divido o numero lido entre parenteses para verificar se e impar
			mfhi $s5		#guardo o resto da divisao em $s5
			beq	$s5, 0, Par	#se o resto da divisao em $s5  == 0 entao va para Par 
            Impar:
                addi $t5, $t5, 1 #incremento o numero de impares
                bne	$s3, 2, NaoEPrimeiroImpar
                move $t7, $s3          #numero lido em $t7
                move $s7, $t2          #posicao do maior elemento impar em $s7
                j Proximo_Int
                NaoEPrimeiroImpar:
                    bgt $t7, $s3, Proximo_Int
                    move $t7, $s3          #numero lido em $t7
                    move $s7, $t2          #posicao do maior elemento impar em $s7
                    j Proximo_Int
            Par:
                bne	$s3, 3, NaoEPrimeiroPar
                move $t6, $s3          #numero lido em $t6
                move $s6, $t2          #posicao do menor elemento par em $s6
                j Proximo_Int
                NaoEPrimeiroPar:
                    blt $t6, $s3, Proximo_Int
                    move $t6, $s3          #numero lido em $t6
                    move $s6, $t2          #posicao do menor elemento par em $s6
    Proximo_Int:
        add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de vet[i+1]
        addi $t2, $t2, 1     #incrementa o indice i do vetor em 1
        blt $t2, $s0, L      #se i < N em $s0, va para L
        move $v0, $t0        #devolve endereco de vet para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura

    proc_ord:
        move $t0, $a0                   #guarda o endereco base de vet em $t0
        add $t3, $s0, 0                 #passando o tamanho N do vetor para registrador temporario $t3
        subi $t3, $t3, 1                #decrementando o valor de $t3(indice j) em 1 para iniciar o laco
        Percorre_Elemento1:             #� a primeira estrutura de repeticao for, funciona como: for(j = N-1 ; j>=1 ; j--)
            li $t2, 0                   #inicia o indice i do vetor com 0
            beq	$t2, $t3, Decresce      #se i == j entao va para a funcao Decresce
            move $t1, $t0               #guarda o endereco de vet em $t1
            move $t4, $t0               #guarda o endereco de vet em $t4
            add $t4, $t4, 4             #o registrador temporario $t4 recebe o endereco de vet[i+1]
            Percorre_Elemento2:         #� a segunda estrutura de repeticao for, funciona como: for(i = 0 ; i<j ; i++)
                lw $s1, ($t1)           #o registrador $s1 recebe o valor armazenado no endereco $t1, ou seja, vet[i]
                lw $s2, ($t4)           #o registrador $s2 recebe o valor armazenado no endereco $t4, ou seja, vet[i+1]
                ble	$s1, $s2, Proximo_Laco	#se vet[i] <= vet[i+1] entao va para a funcao Proximo_Laco, pois n�o precisaremos trocar os numeros de lugar                 
                    sw $s2, ($t1)       #guarda o inteiro que estava em $t4(vet[i+1]) em $t1(vet[i])
                    sw $s1, ($t4)       #guarda o inteiro que estava em $t1(vet[i]) em $t4(vet[i+1])          
                Proximo_Laco:
                    add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de vet[i+1]
                    add $t4, $t4, 4      #o registrador temporario $t4 recebe o endereco de vet[i+2]
                    addi $t2, $t2, 1     #incrementa o indice i do vetor em 1
                    blt	$t2, $t3, Percorre_Elemento2	#se $t2 < $t3, ou seja, se i < j, ent�o va para Percorre_Elemento2 
            subi $t3, $t3, 1             #decrementa o indice j do vetor em 1
            bge $t3, 1, Percorre_Elemento1 # se j >= 1 va para a funcao Percorre_Elemento1
        Decresce:
        	move $t9, $t0               #guarda o endereco de vet em $t1
        	move $t1, $t0               #guarda o endereco de vet em $t4    
        	subi $s5, $s0, 1     #passando o tamanho N-1 do vetor para registrador $s5, ser� o indice j(ultimo indice do vetor)
        	mul $s2, $s5, 4      #(N-1)*4
        	add $t9, $t9, $s2    #o registrador temporario $t9 recebe o endereco do ultimo elemento do Vetor (Vet[j])
        	li $s4, 0            #inicio registrador $s4 com 1, ser� o indice i
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
 	
    VerificaMenoresSoma:
        move $t0, $a0        #guarda o endereco base de vet
        move $t1, $t0        #guarda o endereco de vet em $t1
        li $t2, 0            #inicia o indice i do vetor com 0
    V:  
        lw $s1, ($t1)        #carrega o valor do inteiro armazenado na posicao vet[i]
        bge $s1, $t8, MaiorQueSomatorio     #se for maior que o somatorio dos N elementos, va para MaiorQueSomatorio
        addi $t4, $t4, 1     #incrementa $t4 a qtd de elementos menores que o somatorio
        MaiorQueSomatorio:
            add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de vet[i+1]
            addi $t2, $t2, 1     #incrementa o indice i do vetor em 1
            blt $t2, $s0, V      #se i < N em $s0, va para V
        move $v0, $t0        #devolve endereco de vet para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura


    escrita:
        move $t0, $a0        #guarda o endereco base de vet
        move $t1, $t0        #guarda o endereco de vet em $t1
        li $t2, 0            #inicia o indice i do vetor com 0
        li $v0, 4            #usando o codigo SysCall para escrever strings
        la $a0, vetDescres   #passando a mensagem que estava na memoria na variavel "vetDescres" para o registrador de argumento $a0 (string a ser escrita)
        syscall              #vai imprimir a mensagem que esta em $a0
    E:  lw $a0, ($t1)        #carrega o valor do inteiro armazenado na posicao vet[i]
        li $v0, 1            #usando o codigo SysCall para escrever inteiros        
        syscall              #escrevendo o inteiro
        li $a0, 32           #usando o codigo SysCall de ASCII para escrever espaco
        li $v0, 11           #usando o codigo SysCall para imprimir caracteres
        syscall              #escrevendo o espaco
        add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de vet[i+1]
        addi $t2, $t2, 1     #incrementa o indice i do vetor em 1
        blt $t2, $s0, E      #se i < N em $s0, va para E
        move $v0, $t0        #devolve endereco de vet para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura

    Erro:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        jal N                   #vai pular para o bloco N novamente
