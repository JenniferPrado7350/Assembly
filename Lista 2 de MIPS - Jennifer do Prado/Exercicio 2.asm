.data 
        entrada: .asciiz "Entre com o valor do Vetor["                           #criando uma variavel na memoria que ira guardar o texto de entrada dos Vetores
        fim_vet: .asciiz "]:"                                                    #criando uma variavel na memoria que ira guardar o texto de fechamento de Vet
        entradaN: .asciiz "Entre com um valor inteiro de N (N>1). "              #criando uma variavel na memoria que ira guardar o texto de entrada N
        msg_erro: .asciiz "O valor digitado tem que ser inteiro e maior que 0. " #criando uma variavel na memoria que ira guardar o texto de erro caso o numero digitado seja 0 ou negativo
        msg_maior: .asciiz "\nMaior elemento do vetor: "                         #criando uma variavel na memoria que ira guardar o texto de maior elemento
        msg_menor: .asciiz "\nMenor elemento do vetor: "                         #criando uma variavel na memoria que ira guardar o texto de menor elemento
        msg_posicao: .asciiz " na posicao: "                                     #criando uma variavel na memoria que ira guardar o texto de posição dos elementos
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
        jal Leitura             #le os elementos do Vet
        move $a0, $v0           #Coloca o endereco do Vet retornado da funcao "Leitura" em $a0
        jal Escrita             #printa o vetor Vet
        li $v0, 10              #Codigo usado para finalizar o programa
        syscall                 #Finaliza o programa

    Leitura:
        li $s2, 0               #inicia o registrador $s2 com 0, que vai ser o maior valor
        li $s3, 0               #inicia o registrador $s3 com 0, que sera o menor valor
        li $t9, 0               #inicia o registrador $t9 com 0, que sera um verificador
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
        bne $t9, 0, Outros_Armazenamentos     #Se o verificador $t9 != 0, não é o primeiro armazenamento, vá para Outros_Armazenamentos 
            add $s2, $v0, $zero         #registrador $s2 recebe o primeiro valor, para podermos encontrar o maior valor
            add $s3, $v0, $zero         #registrador $s3 recebe o primeiro valor, para podermos encontrar o menor valor
            li $t8, 1                   #$t8 recebe 1 pois é a posicao do maior valor até o momento
            li $t7, 1                   #$t7 recebe 1 pois é a posicao do menor valor até o momento
            li $t9, 1                   #verificador $t9 recebe 1, pois ja foi o primeiro armazenamento
            j Insere_No_Vetor
            Outros_Armazenamentos:
                ble $v0, $s2, Verifica_Menor        #Se o valor lido $v0 <= $s2, vá para Verifica_Menor, pois não é maior que o valor já salvo   
                add $s2, $v0, $zero                 #$s2 recebe o valor lido que é maior que o valor anterior armazenado em $s2
                addi $t8, $t2, 0                    #$t8 recebe a posicao do valor atual            
                Verifica_Menor:
                    bge $v0, $s3, Insere_No_Vetor   #Se o valor lido $v0 >= $s3, vá para Insere_No_Vetor, pois não é menor que o valor já salvo   
                    add $s3, $v0, $zero             #$s3 recebe o valor lido que é menor que o valor anterior armazenado em $s3
                    addi $t7, $t2, 0                #$t8 recebe a posicao do valor atual              		
            Insere_No_Vetor:
                sw $v0, ($t1)                   #Armazena em Vet[i]($t1) o inteiro lido
                add $t1, $t1, 4                 #o registrador temporario $t1 recebe o endereco de Vet[i+1]
                addi $t2, $t2, 1                #incrementa o indice i do vetor em 1
                ble $t2, $s0, L                 #se i <= N em $s0, va para L
                move $v0, $t0                   #devolve endereco de Vet para retorno da funcao
                jr $ra                          #Retorna para a função Estrutura

    Escrita:
        move $t0, $a0               #guarda o endereco base de vet
        move $t1, $t0               #guarda o endereco de vet em $t1
        li $t2, 1                   #inicia o indice i do vetor com 1 
    E:  lw $a0, ($t1)               #carrega o valor do inteiro armazenado na posicao Vet[i]
        li $v0, 1                   #usando o codigo SysCall para escrever inteiros        
        syscall                     #escrevendo o inteiro
        li $a0, 32                  #usando o codigo SysCall de ASCII para escrever espaco
        li $v0, 11                  #usando o codigo SysCall para imprimir caracteres
        syscall                     #escrevendo o espaco
        add $t1, $t1, 4             #o registrador temporario $t4 recebe o endereco de Vet[i+1]
        addi $t2, $t2, 1            #incrementa o indice i do vetor em 1
        ble $t2, $s0, E             #se i <= N, va para E novamente
    Escrita_Maior_Valor:
        la $a0, msg_maior           #carrega a informacao armazenada no endereco da string msg_maior
        li $v0, 4                   #usando o codigo SysCall para escrever strings
        syscall                     #escrevendo a string
        move $a0, $s2               #registrador $a0 carrega $s2(maior valor)
        li $v0, 1                   #usando o codigo SysCall para escrever inteiros
        syscall                     #escrevendo o inteiro
        la $a0, msg_posicao         #carrega a informacao armazenada no endereco da string msg_posicao
        li $v0, 4                   #usando o codigo SysCall para escrever strings
        syscall                     #escrevendo a string
        move $a0, $t8               #registrador $a0 carrega $t8(indice do maior valor)
        li $v0, 1                   #usando o codigo SysCall para escrever inteiros
        syscall                     #escrevendo o inteiro
    Escrita_Menor_Valor:
        la $a0, msg_menor           #carrega a informacao armazenada no endereco da string msg_menor
        li $v0, 4                   #usando o codigo SysCall para escrever strings
        syscall                     #escrevendo a string
        move $a0, $s3               #registrador $a0 carrega $s3(menor valor)
        li $v0, 1                   #usando o codigo SysCall para escrever inteiros
        syscall                     #escrevendo o inteiro
        la $a0, msg_posicao         #carrega a informacao armazenada no endereco da string msg_posicao
        li $v0, 4                   #usando o codigo SysCall para escrever strings
        syscall                     #escrevendo a string
        move $a0, $t7               #registrador $a0 carrega $t7(indice do menor valor)
        li $v0, 1                   #usando o codigo SysCall para escrever inteiros
        syscall                     #escrevendo o inteiro
        move $v0, $t0               #devolve endereco de Vet para retorno da funcao
        jr $ra                      #retorna para a funcao Estrutura

    Erro:
        li $v0, 4               # usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        # passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 # vai imprimir a mensagem que esta em $a0
        jr $ra                  # vai pular para o bloco que o chamou