.data 
        entrada: .asciiz "Entre com o valor de Vet["                              #criando uma variavel na memoria que ira guardar o texto de entrada de Vet
        fim_vet: .asciiz "]:"                                                     #criando uma variavel na memoria que ira guardar o texto de fechamento de Vet
        entradaN: .asciiz "Entre com o valor PAR inteiro de N (N>1). "            #criando uma variavel na memoria que ira guardar o texto de entrada N
        msg_erro: .asciiz "O valor digitado tem que ser um PAR inteiro e maior que 0. "  #criando uma variavel na memoria que ira guardar o texto de erro caso o numero digitado seja 0, negativo, quebrado ou impar
.align 2
vet: .space 150

.text

.main: 
    N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        ble $v0, 0, Erro        #caso o valor digitado que esta no registrador de valor $v0 for menor ou igual ao inteiro "0", vai para Erro
        li $s1, 2               #inicio $s2 com 2
        div $v0, $s1            #divido N por 2 para verificar se é par
        mfhi $s2                #guardo o resto da divisão em hi
        bne $s2, 0, Erro        #se não for par, vá para Erro
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0

    Estrutura:
        jal Leitura         #le o vetor vet
        move $a0, $v0       #Coloca o endereco do vetor retornado da funcao "Leitura" em $a0
        jal Ordena_Vet_Crescente #ordena o vetor vet em ordem crescente
        move $a0, $v0       #Coloca o endereco do vetor retornado da funcao "Ordena_Vet_Crescente" em $a0
        jal Ordena_Vet_Decrescente #ordena o vetor vet em ordem decrescente
        move $a0, $v0       #Coloca o endereco do vetor retornado da funcao "Ordena_Vet_Crescente" em $a0
        jal escrita         #printa o vetor vet
        li $v0, 10          #Codigo usado para finalizar o programa
        syscall             #Finaliza o programa

    Leitura:
        mul $s1, $s0, 4      #guardando em $s1 N*4 bytes
        move $a0, $s1        #passando N*4 bytes guardados em $s1 para o registrador de argumento $a0
        li $v0, 9            #codigo de alocação dinamica help
        syscall              #aloca N*4 bytes (endereço em $v0)
        move $t0, $v0        #move para $t0
        move $t1, $t0        #guarda o endereco do Vetor em $t1
        li $s2, 0            #inicia o indice i do vetor com 0
    L:  la $a0, entrada      #carrega a informacao armazenada no endereco da string entrada
        li $v0, 4            #usando o codigo SysCall para escrever strings
        syscall              #escrevendo a string
        move $a0, $s2        #carrega o indice i do vetor
        li $v0, 1            #usando o codigo SysCall para escrever inteiros
        syscall              #escrevendo o inteiro
        la $a0, fim_vet      #carrega a informacao armazenada no endereco da string fim_vet
        li $v0, 4            #usando o codigo SysCall para escrever strings
        syscall              #escrevendo a string
        li $v0, 5            #usando o codigo SysCall para ler inteiros
        syscall              #lendo o inteiro
        sw $v0, ($t1)        #guarda o inteiro lido em Vetor[i]
        add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de Vetor[i+1]
        addi $s2, $s2, 1     #incrementa o indice i do vetor em 1
        blt $s2, $s0, L      #se i < N em $s0, va para L
        move $v0, $t0        #devolve endereco de vet para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura

    Ordena_Vet_Crescente:
        move $t0, $a0                   #guarda o endereco base de vet em $t0
        add $t3, $s0, 0                 #passando o tamanho N do vetor para registrador temporario $t3
        subi $t3, $t3, 1                #decrementando o valor de $t3(indice j) em 1 para iniciar o laco
        Percorre_Elemento1:             #é a primeira estrutura de repeticao for, funciona como: for(j = N-1 ; j>=1 ; j--)
            li $t2, 0                   #inicia o indice i do vetor com 0
            beq	$t2, $t3, Retorna	    #se i == j entao va para a funcao Retorna
            move $t1, $t0               #guarda o endereco de vet em $t1
            move $t4, $t0               #guarda o endereco de vet em $t4
            add $t4, $t4, 4             #o registrador temporario $t4 recebe o endereco de vet[i+1]
            Percorre_Elemento2:         #é a segunda estrutura de repeticao for, funciona como: for(i = 0 ; i<j ; i++)
                lw $s1, ($t1)           #o registrador $s1 recebe o valor armazenado no endereco $t1, ou seja, vet[i]
                lw $s2, ($t4)           #o registrador $s2 recebe o valor armazenado no endereco $t4, ou seja, vet[i+1]
                ble	$s1, $s2, Proximo_Laco	#se vet[i] <= vet[i+1] entao va para a funcao Proximo_Laco, pois não precisaremos trocar os numeros de lugar                 
                    sw $s2, ($t1)       #guarda o inteiro que estava em $t4(vet[i+1]) em $t1(vet[i])
                    sw $s1, ($t4)       #guarda o inteiro que estava em $t1(vet[i]) em $t4(vet[i+1])
           
               
                Proximo_Laco:
                    add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de vet[i+1]
                    add $t4, $t4, 4      #o registrador temporario $t4 recebe o endereco de vet[i+2]
                    addi $t2, $t2, 1     #incrementa o indice i do vetor em 1
                    blt	$t2, $t3, Percorre_Elemento2	#se $t2 < $t3, ou seja, se i < j, então va para Percorre_Elemento2
                    
            subi $t3, $t3, 1             #decrementa o indice j do vetor em 1
            bge $t3, 1, Percorre_Elemento1 # se j >= 1 va para a funcao Percorre_Elemento1
        Retorna:
            move $v0, $t0                #devolve endereco de vet para retorno da funcao
            jr $ra                       #retorna para a funcao main Estrutura

    Ordena_Vet_Decrescente:
        move $t0, $a0        #guarda o endereco base de vet em $t0
        move $t1, $t0        #guarda o endereco do Vetor em $t1
        move $t2, $t0        #guarda o endereco do Vetor em $t2
        subi $s2, $s0, 1     #passando o tamanho N-1 do vetor para registrador $s2, será o indice j(ultimo indice do vetor)
        mul $s3, $s2, 4      #(N-1)*4
        add $t2, $t2, $s3    #o registrador temporario $t2 recebe o endereco do ultimo elemento do Vetor (Vet[j])
        li $s4, 2            #inicio registrador $s4 com 2
        div $s0, $s4         #divido N por 2
        mflo $s5             #guardo o resultado da divisão em $s5, será o indice i
        mul $s4, $s5, 4      #(N/2)*4
        add $t1, $t1, $s4    #o registrador temporario $t1 recebe o endereco do ultimo elemento do Vetor (Vet[j])
    Ord_Dec: 
        lw $s1, ($t1)           #o registrador $s1 recebe o valor armazenado no endereco $t1, ou seja, vet[i]
        lw $s3, ($t2)           #o registrador $s3 recebe o valor armazenado no endereco $t2, ou seja, vet[j]                
        sw $s1, ($t2)           #guarda o inteiro que estava em $t1(vet[i]) em $t2(vet[j])
        sw $s3, ($t1)           #guarda o inteiro que estava em $t2(vet[j]) em $t1(vet[i])
        add $t1, $t1, 4         #o registrador temporario $t1 recebe o endereco de Vetor[i+1]
        sub $t2, $t2, 4         #o registrador temporario $t2 recebe o endereco de Vetor[j-1]
        lw $s1, ($t1)           #o registrador $s1 recebe o valor armazenado no endereco $t1, ou seja, vet[i]
        lw $s3, ($t2)           #o registrador $s3 recebe o valor armazenado no endereco $t2, ou seja, vet[j] 
        subi $s2, $s2, 1        # i = i - 1
        addi $s5, $s5, 1        # j = j + 1
        blt $s5, $s2, Ord_Dec      #se i < j  va para Ord_Dec        
        move $v0, $t0        #devolve endereco de vet para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura


    escrita:
        move $t0, $a0        #guarda o endereco base de vet
        move $t1, $t0        #guarda o endereco de vet em $t1
        li $t2, 0            #inicia o indice i do vetor com 0
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
