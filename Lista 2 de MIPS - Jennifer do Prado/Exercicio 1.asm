.data 
        entrada_vetA: .asciiz "\n\nVet A:\n"                                                                                                                  #criando uma variavel na memoria que ira guardar o texto de entrada de VetA
        entrada_vetB: .asciiz "\n\nVet B:\n"                                                                                                                  #criando uma variavel na memoria que ira guardar o texto de entrada de VetB
        entrada: .asciiz "Entre com o valor do Vetor["                                                                                                        #criando uma variavel na memoria que ira guardar o texto de entrada dos Vetores
        fim_vet: .asciiz "]:"                                                                                                                                 #criando uma variavel na memoria que ira guardar o texto de fechamento de Vet
        entradaN: .asciiz "Entre com um valor inteiro de N (N>1). "                                                                                           #criando uma variavel na memoria que ira guardar o texto de entrada N
        msg_erro: .asciiz "O valor digitado tem que ser inteiro e maior que 0. "                                                                              #criando uma variavel na memoria que ira guardar o texto de erro caso o numero digitado seja 0 ou negativo
        msg_saida: .asciiz "\n\nO somatório dos valores nas posicoes pares de Vet A menos o somatório dos valores nas posicoes impares do Vet B é igual a: "  #criando uma variavel na memoria que ira guardar o texto de saída
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
        li $s2, 0               #inicia o registrador $s2 com 0, pois irá guardar o somatorio das posicoes pares do VetA
        li $s3, 0               #inicia o registrador $s3 com 0, pois irá guardar o somatorio das posicoes impares do VetB
        li $t5, 0               #inicia o registrador temporario $t5 com 0, será a verificação para sabermos se esta lendo o VetA
        la $a0, entrada_vetA    #carrega a informacao armazenada no endereco da string entrada_vetA
        li $v0, 4               #usando o codigo SysCall para escrever strings
        syscall                 #escrevendo a string
        jal Leitura             #le os elementos do VetA
        move $a1, $v0           #Coloca o endereco do VetA retornado da funcao "Leitura" em $a1
        addi $t5, $t5, 1        #leu o vetor A, $t5(verificador) recebe 1
        la $a0, entrada_vetB    #carrega a informacao armazenada no endereco da string entrada_vetB
        li $v0, 4               #usando o codigo SysCall para escrever strings
        syscall                 #escrevendo a string
        jal Leitura             #le os elementos do VetB
        move $a2, $v0           #Coloca o endereco do VetB retornado da funcao "Leitura" em $a2
        la $a0, entrada_vetA    #$a0 recebe o endereco da mensagem entrada_vetA
        li $v0, 4               #usando o codigo SysCall para escrever strings
        syscall                 #escrevendo a string
        move $a0, $a1           #Move para $a0 o endereco do VetA
        jal Escrita             #printa o vetor VetA
        la $a0, entrada_vetB    #$a0 recebe o endereco da mensagem entrada_vetB
        li $v0, 4               #usando o codigo SysCall para escrever strings
        syscall                 #escrevendo a string
        move $a0, $a2           #Move para $a0 o endereco do VetB
        jal Escrita             #printa o vetor VetB
        la $a0, msg_saida       #$a0 recebe o endereco da mensagem de saida
        li $v0, 4               #usando o codigo SysCall para escrever strings
        syscall                 #escrevendo a string
        sub $a0, $s2, $s3       #$a0 recebe $s2 - $s3, ou seja, Somatorio dos valores em posicoes pares de VetA - Somatorio dos valores em posicoes impares de VetB
        li $v0, 1               #usando o codigo SysCall para escrever inteiros
        syscall                 #escrevendo o inteiro
        li $v0, 10              #Codigo usado para finalizar o programa
        syscall                 #Finaliza o programa

    Leitura:
        mul $s1, $s0, 4         #guardando em $s1 N*4 bytes
        move $a0, $s1           #passando N*4 bytes guardados em $s1 para o registrador de argumento $a0
        li $v0, 9               #Codigo SysCall de alocação dinamica
        syscall                 #aloca N*4 bytes (endereço em $v0)
        move $t0, $v0           #move para $t0
        move $t1, $t0           #guarda o endereco do Vetor em $t1
        li $t2, 1               #inicia o indice i do vetor com 1
    L:  la $a0, entrada         #carrega a informacao armazenada no endereco da string entrada
        li $v0, 4               #usando o codigo SysCall para escrever strings
        syscall                 #escrevendo a string
        move $a0, $t2           #carrega o indice i do vetor
        li $v0, 1               #usando o codigo SysCall para escrever inteiros
        syscall                 #escrevendo o inteiro
        la $a0, fim_vet         #carrega a informacao armazenada no endereco da string fim_vet
        li $v0, 4               #usando o codigo SysCall para escrever strings
        syscall                 #escrevendo a string
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #lendo o inteiro
        li $t6, 2               #guardo o numero 2 em $t6 para verificar os pares
        div $t2, $t6            #Divide $t2 por $t6, ou seja, (indice i)/2 para verificar se o indice é par
        mfhi $t3                #$t3 recebe o resto da divisão acima
        bne $t5, $zero, Impares             #Se $t5 for != 0, esta realizando a leitura do vetor B, entao vá para Impares
        bne $t3, $zero, Insere_No_Vetor     #Se o $t3(resto da divisão) != 0, a posicao do VetA[i] é impar, entao não somamos, vá para Insere_No_Vetor
        add $s2, $s2, $v0                   #Soma em $s2 o valor da posicao par atual
        Impares:
            beq $t3, $zero, Insere_No_Vetor #estamos lendo o vetor B, entao comparamos, se o resto da divisao em $t3 for == a 0, é par, não somamos, vá para Insere_No_Vetor
            add $s3, $s3, $v0               #Soma em $s3 o valor da posicao impar atual
        Insere_No_Vetor:
            sw $v0, ($t1)                   #Armazena em Vet[i]($t1) o inteiro lido
            add $t1, $t1, 4                 #o registrador temporario $t1 recebe o endereco de Vet[i+1]
            addi $t2, $t2, 1                #incrementa o indice i do vetor em 1
            ble $t2, $s0, L                 #se i <= N em $s0, va para L
            move $v0, $t0                   #devolve endereco de Vet para retorno da funcao
            jr $ra                          #Retorna para a função Estrutura

    Escrita:
        move $t0, $a0               #guarda o endereco base de vet
        move $t4, $t0               #guarda o endereco de vet em $t4
        li $t2, 1                   #inicia o indice i do vetor com 1
    E:  lw $a0, ($t4)               #carrega o valor do inteiro armazenado na posicao Vet[i]
        li $v0, 1                   #usando o codigo SysCall para escrever inteiros        
        syscall                     #escrevendo o inteiro
        li $a0, 32                  #usando o codigo SysCall de ASCII para escrever espaco
        li $v0, 11                  #usando o codigo SysCall para imprimir caracteres
        syscall                     #escrevendo o espaco
        add $t4, $t4, 4             #o registrador temporario $t4 recebe o endereco de Vet[i+1]
        addi $t2, $t2, 1            #incrementa o indice i do vetor em 1
        ble $t2, $s0, E             #se i <= N, va para E novamente
        move $v0, $t0               #Move para $a0 o endereco base do vetor
        jr $ra                      #retorna para a funcao Estrutura

    Erro:
        li $v0, 4               # usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        # passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 # vai imprimir a mensagem que esta em $a0
        jr $ra                  # vai pular para o bloco que o chamou