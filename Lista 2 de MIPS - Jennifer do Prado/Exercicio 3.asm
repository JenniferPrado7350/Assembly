.data 
        entradaC: .asciiz "\n\nVetC\n"                            #criando uma variavel na memoria que ira guardar o texto de entrada de VetC
        entradaD: .asciiz "\n\nVetD\n"                            #criando uma variavel na memoria que ira guardar o texto de entrada de VetD
        entradaE: .asciiz "\n\nVetE\n"                            #criando uma variavel na memoria que ira guardar o texto de entrada de VetE
        entrada: .asciiz "Entre com o valor do Vetor["                            #criando uma variavel na memoria que ira guardar o texto de entrada dos Vetores
        fim_vet: .asciiz "]:"                                                     #criando uma variavel na memoria que ira guardar o texto de fechamento de Vet
        entradaN: .asciiz "Entre com o valor inteiro de N (N>1). "                #criando uma variavel na memoria que ira guardar o texto de entrada N
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
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0

    Estrutura:
        la $a0, entradaC    #carrega a informacao armazenada no endereco da string entradaC
        li $v0, 4           #usando o codigo SysCall para escrever strings
        syscall             #escrevendo a string
        jal Leitura         #le os elementos do vetor VetC
        move $a1, $v0       #Coloca o endereco do vetor VetC retornado da funcao "Leitura" em $a1
        la $a0, entradaD    #carrega a informacao armazenada no endereco da string entradaD
        li $v0, 4           #usando o codigo SysCall para escrever strings
        syscall             #escrevendo a string
        jal Leitura         #le os elementos do vetor VetD
        move $a2, $v0       #Coloca o endereco do vetor VetD retornado da funcao "Leitura" em $a2
        la $a0, entradaE    #carrega a informacao armazenada no endereco da string entradaE
        li $v0, 4           #usando o codigo SysCall para escrever strings
        syscall             #escrevendo a string
        jal Cria_VetE       #guarda os elementos de VetC e VetD em VetE 
        move $a0, $v0       #Coloca o endereco do vetor VetE retornado da funcao "Cria_VetE" em $a0       
        jal escrita         #printa o vetor VetE
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

    Cria_VetE:
        mul $s1, $s0, 8      #guardando em $s1 N*8 bytes, pois VetE terá o dobro de bytes de VetC e VetD
        move $a0, $s1        #passando N*8 bytes guardados em $s1 para o registrador de argumento $a0
        li $v0, 9            #codigo de alocação dinamica help
        syscall              #aloca N*8 bytes (endereço em $v0)
        move $t0, $v0        #move VetE para $t0
        move $t1, $t0        #guarda o endereco do VetE em $t1
        move $t2, $a1        #guarda o endereco do VetC em $t2
        move $t3, $a2        #guarda o endereco do VetD em $t3
        mul $s1, $s0, 2      #guardando em $s1 N*2, pois VetE terá o dobro de indices em relaçao a VetC e VetD        
        li $s2, 0            #inicia o registrador $s2 com 0
        addi $s2, $s2, 1     #incrementa o indice i do vetor em 1, para iniciar com 1
    Preenche_VetE:
        li $s4, 0                 #inicia o registrador $s4 com 0   
        addi $s4, $s4, 2          #guardo o numero 2 em $s4 para verificar os pares   
        div $s2, $s4              #Vamos dividir para verificar se o indice é par
        mfhi $s3                  #guardar o resto da divisão
        beq	$s3, 0, Par           #se o resto  da divisão for igual a zero, então o indice i é par, vá para Par
            lw $s3, ($t3)         #guardo o valor de VetD[j] em $s3
            sw $s3, ($t1)		  #armazeno o valor em $s3 de VetD[j] em VetE[i] 
            add $t3, $t3, 4       #o registrador temporario $t3 recebe o endereco de VetD[j+1]
            j Proxima_Iteracao    #pulo para a Proxima Iteracao
        Par:
            lw $s3, ($t2)             #guardo o valor de VetC[k] em $s3
            sw $s3, ($t1)		      #armazeno o valor em $s3 de VetC[k] em VetE[i] 
            add $t2, $t2, 4           #o registrador temporario $t2 recebe o endereco de VetC[k+1]
    Proxima_Iteracao:
        add $t1, $t1, 4               #o registrador temporario $t1 recebe o endereco de VetE[i+1]
        addi $s2, $s2, 1              #incrementa o indice i do vetor em 1
        ble	$s2, $s1, Preenche_VetE	  #se  $s2(indice i) <= $s1(N*2) então Preenche_VetE
    Retorna:
        move $v0, $t0                 #devolve endereco de VetE para retorno da funcao
        jr $ra                        #retorna para a funcao main Estrutura


    escrita:
        move $t0, $a0        #guarda o endereco base de VetE
        move $t4, $t0        #guarda o endereco de VetE em $t4
        li $s2, 0            #inicia o indice i do vetor com 0
        addi $s2, $s2, 1     #incrementa o indice i do vetor em 1, para iniciar com 1
    E:  lw $a0, ($t4)        #carrega o valor do inteiro armazenado na posicao VetE[i]
        li $v0, 1            #usando o codigo SysCall para escrever inteiros        
        syscall              #escrevendo o inteiro
        li $a0, 32           #usando o codigo SysCall de ASCII para escrever espaco
        li $v0, 11           #usando o codigo SysCall para imprimir caracteres
        syscall              #escrevendo o espaco
        add $t4, $t4, 4      #o registrador temporario $t4 recebe o endereco de VetE[i+1]
        addi $s2, $s2, 1     #incrementa o indice i do vetor em 1
        ble $s2, $s1, E      #se i <= N*2, va para E
        move $v0, $t0        #devolve endereco de VetE para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura

        Erro:
            li $v0, 4               # usando o codigo SysCall para escrever strings      
            la $a0, msg_erro        # passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
            syscall                 # vai imprimir a mensagem que esta em $a0
            jr $ra                  # vai pular para o bloco que o chamou