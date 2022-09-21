.data 
        entrada: .asciiz "Entre com o valor do Vetor["                            #criando uma variavel na memoria que ira guardar o texto de entrada do Vetor
        fim_vet: .asciiz "]:"                                                     #criando uma variavel na memoria que ira guardar o texto de fechamento de Vet
        entradaN: .asciiz "Entre com o valor inteiro de N (N>1). "                #criando uma variavel na memoria que ira guardar o texto de entrada N
        Vet_Comp: .asciiz "\n\nVetcomp:\n\n"                                      #criando uma variavel na memoria que ira guardar o texto de Vetcomp

        msg_erro: .asciiz "O valor digitado tem que ser inteiro e maior que 1. "  #criando uma variavel na memoria que ira guardar o texto de erro caso o numero digitado seja 0 ou negativo
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
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0

    Estrutura:
        jal leitura         #le o vetor Vet
        move $a0, $v0       #Coloca o endereco do vetor retornado da funcao "leitura" em $a0
        jal Compacta_Vet    #compacta o vetor Vet
        move $a0, $v0       #Coloca o endereco do vetor retornado da funcao "Compacta_Vet" em $a0
        jal escrita         #printa o vetor Vet
        li $v0, 10          #Codigo usado para finalizar o programa
        syscall             #Finaliza o programa

    leitura:
        mul $s1, $s0, 4      #guardando em $s1 N*4 bytes
        move $a0, $s1        #passando N*4 bytes guardados em $s1 para o registrador de argumento $a0
        li $v0, 9            #codigo de alocação dinamica help
        syscall              #aloca N*4 bytes (endereço em $v0)
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
        sw $v0, ($t1)        #guarda o inteiro lido em Vet[i]
        add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de Vet[i+1]
        addi $t2, $t2, 1     #incrementa o indice i do vetor em 1
        blt $t2, $s0, L      #se i < N em $s0, va para L
        move $v0, $t0        #devolve endereco de vet para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura

    Compacta_Vet:
        move $t0, $a0        #guarda o endereco base de vet
        move $t1, $t0        #guarda o endereco do Vet em $t1
        beq $s0, 1, Retorna  #se Vet[i] tiver apenas um elemento, não precisará compactar
        li $s1, 0            #inicia o registrador $s1 com 0
        li $s4, 0            #inicia o registrador $s4 com 0
    Decrementa_Posicao:
            lw $s4, ($t1)                   #guardo o valor de Vet[i] em $s4
            bne	$s4, 0, Proxima_Iteracao    #se valor em $s4(Vet[i]) != 0 então vá para Proxima_Iteracao pois ainda não encontramos um 0
            li $s2, 0                       #inicia o registrador $s2 com 0, será o indice j
            addi $s2, $s1, 1                #$s2 -> j = i + 1 
            move $t2, $t1                   #guarda o endereco do Vet[i] em $t2   
            add $t2, $t2, 4                 #o registrador temporario $t2 recebe o endereco de Vet[i+1]
            Procura_Elemento:
                lw $s4, ($t2)         #guardo o valor de Vet[j] em $s4
                beq	$s4, 0, Proxima_Iteracao_Procura_Elemento    #se valor em $s4(Vet[j]) == 0 então vá para Proxima_Iteracao_Procura_Elemento pois ainda não encontramos um valor diferente de 0
                lw $s3, ($t2)         #guardo o valor de Vet[j] em $s3
                sw $s3, ($t1)		  #armazeno o valor em $s3 de Vet[j] em Vet[i] 
                li $s4, 0             #inicia o registrador $s4 com 0
                sw $s4, ($t2)         #vou zerar a posição Vet[j] que o elemento estava
                j Proxima_Iteracao    #pulo para Proxima_Iteracao
            Proxima_Iteracao_Procura_Elemento:
                add $t2, $t2, 4                   #o registrador temporario $t2 recebe o endereco de Vet[j+1]
                addi $s2, $s2, 1                  #incrementa o indice j do vetor em 1
                blt	$s2, $s0, Procura_Elemento	  #se  $s2(indice j) < $s0(N) então Procura_Elemento
            j Retorna                             #se chegou aqui então o resto do vetor é apenas 0 após o 0 armazenado em $t1  
    Proxima_Iteracao:
        add $t1, $t1, 4                       #o registrador temporario $t1 recebe o endereco de Vet[i+1]
        addi $s1, $s1, 1                      #incrementa o indice i do vetor em 1
        blt	$s1, $s0, Decrementa_Posicao	  #se  $s1(indice i) < $s0(N) então Decrementa_Posicao
    Retorna:
        move $v0, $t0                 #devolve endereco de VetE para retorno da funcao
        jr $ra                        #retorna para a funcao main Estrutura


    escrita:
        move $t0, $a0        #guarda o endereco base de Vet
        move $t1, $t0        #guarda o endereco de Vet em $t1
        li $t2, 0            #inicia o indice i do vetor com 0
        la $a0, Vet_Comp     #carrega a informacao armazenada no endereco da string Vet_Comp
        li $v0, 4            #usando o codigo SysCall para escrever strings
        syscall              #escrevendo a string
    E:  lw $a0, ($t1)        #carrega o valor do inteiro armazenado na posicao Vet[i]
        li $v0, 1            #usando o codigo SysCall para escrever inteiros        
        syscall              #escrevendo o inteiro
        li $a0, 32           #usando o codigo SysCall de ASCII para escrever espaco
        li $v0, 11           #usando o codigo SysCall para imprimir caracteres
        syscall              #escrevendo o espaco
        add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de Vet[i+1]
        addi $t2, $t2, 1     #incrementa o indice i do vetor em 1
        blt $t2, $s0, E      #se i < N em $s0, va para E
        move $v0, $t0        #devolve endereco de vet para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura

        Erro:
            li $v0, 4               # usando o codigo SysCall para escrever strings      
            la $a0, msg_erro        # passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
            syscall                 # vai imprimir a mensagem que esta em $a0
            jr $ra                  # vai pular para o bloco que o chamou