.data
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
entradaN: .asciiz "Entre com o valor inteiro de N (0 < N) que será a dimensão da matriz quadrada: "               
msg_erro: .asciiz "O valor digitado tem que ser inteiro maior que 0. "  
Lin_maior_elemento_Imp: .asciiz "\n\nA linha do maior elemento impar da matriz e: "
Lin_menor_elemento: .asciiz "\n\nA linha do menor elemento da matriz e: "
Sem_Impar: .asciiz "\n\nNao ha numero impar na matriz! "

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
        li $t2, 0           #inicio $t2 com 0, ira guardar o menor valor
        li $t3, 0           #inicio $t3 com 0, ira guardar a linha do menor valor
        li $t4, 0           #inicio $t4 com 0, ira guardar o maior valor impar
        li $t5, 0           #inicio $t5 com 0, ira guardar a linha do maior valor impar
        li $s4, 0           #inicio $s4 com 0, sera o verificador para saber se ja leu o primeiro elemento 
        li $s5, 0           #inicio $s5 com 0, sera o verificador para saber se ja leu o primeiro elemento impar
        move $s1, $s0       #número de linhas
        move $s2, $s0       #número de colunas
        jal leitura         #le os elementos da matriz Mat
        move $a1, $v0       #Coloca o endereco da matriz Mat retornado da funcao "leitura" em $a1
        jal Imprime_Resultado   #vai para Imprime_Resultado
        li $v0, 10          #codigo para finalizar o programa
        syscall             #finaliza o programa

    indice:
        mul $v0, $t0, $s2 #i * ncol
        add $v0, $v0, $t1 #(i * ncol) + j
        sll $v0, $v0, 2   #[(i * ncol) + j] * 4 (inteiro)
        add $v0, $v0, $a3 # soma o endereço base de mat
        jr $ra            #retorna para o caller

    leitura:
        mul $s3, $s0, 4      #guardando em $s3 N*4 bytes
        mul $s3, $s3, $s0    #guardando em $s3 N*(N*4) bytes, ja que vamos alocar uma matriz N*N
        move $a0, $s3        #passando N*(N*4) bytes guardados em $s3 para o registrador de argumento $a0
        li $v0, 9            #codigo de alocação dinamica help
        syscall              #aloca N*(N*4) bytes (endereço em $v0)
        move $a3, $v0        #move para $a3
        subi $sp, $sp, 4     #Espaço para 1 item na pilha
        sw $ra, ($sp)        #salva o retorno para a main
    l:  la $a0, Ent1         #Carrega o endereço da String
        li $v0, 4            #Codigo de impressão da string
        syscall              #imprime a string
        move $a0, $t0        #valor de i para a impressão
        addi $a0, $a0, 1     #i+1
        li $v0, 1            #codigo de impressão de inteiro
        syscall              #imprime i
        la $a0, Ent2         #Carrega o endereco da string
        li $v0, 4            #codigo de impressão de string
        syscall              #imprime a string
        move $a0, $t1        #valor de j para a impressão
        addi $a0, $a0, 1     #j+1
        li $v0, 1            #codigo de impressão de inteiro
        syscall              #imprime j
        la $a0, Ent3         #carrega o endereço da string
        li $v0, 4            #Codigo de impressão da string
        syscall              #imprime a string
        li $v0, 5            #codigo de leitura de inteiro
        syscall              #leitura do valor (retorna em $v0)
        move $s3, $v0        #aux = valor lido
        jal indice           #calcula o endereço de mat[i][j]
        sw $s3, ($v0)        #mat [i][j] = aux
    VerificaMenor:
        bne $s4, 0, NaoEPrimeiro    #se $s4 nao for 0, significa que ja leu o primeiro, va para NaoEPrimeiro
        move $t2, $s3               #guardo o primeiro valor da matriz
        addi $t3, $t0, 1            #guardo a linha da primeira posicao +1
        li $s4, 1                   #set o verificador com 1, pois ja leu o primeiro elemento
        j VerificaMaiorImpar        #pula para VerificaMaiorImpar
        NaoEPrimeiro:
            bgt $s3, $t2, VerificaMaiorImpar
            move $t2, $s3               #guardo o menor valor da matriz em $t2
            addi $t3, $t0, 1            #guardo a linha do menor valor da matriz em $t3 +1
    VerificaMaiorImpar:
        li $s7, 2                       #inicia $s7 com 2
        div $s3, $s7                    #faco a divisao do numero lido por 2
        mfhi $s6                        #guardo o resto da divisao em $s6
        beq $s6, 0, ContinuaLeitura     #se o resto da divisao for 0, é par, va para ContinuaLeitura
        bne $s5, 0, NaoEPrimeiroImpar   #se $s5 nao for 0, significa que ja leu o primeiro impar, va para NaoEPrimeiroImpar
        move $t4, $s3                   #guardo o primeiro valor impar da matriz
        addi $t5, $t0, 1                #guardo a linha da primeira posicao impar +1
        li $s5, 1
        j ContinuaLeitura
        NaoEPrimeiroImpar:
            blt $s3, $t4, ContinuaLeitura   #se o valor lido for menor que o valor ja em $t4, va para ContinuaLeitura
            move $t4, $s3                   #guardo o maior valor impar da matriz em $t4
            addi $t5, $t0, 1                #guardo a linha do maior valor impar da matriz em $t5 +1
    ContinuaLeitura:
        addi $t1, $t1, 1     #j++
        blt $t1, $s2, l      #se (j < ncol) va para l
        li $t1, 0            #j = 0
        addi $t0, $t0, 1     #i++
        blt $t0, $s1, l      #se (i < nlin) va para l
        li $t0, 0            #i = 0
        lw $ra, ($sp)        #recupera o retorno para a main
        addi $sp, $sp, 4     #libera o espaço na pilha
        move $v0, $a3        #Endereço base da matriz para retorno
        jr $ra               #Retorna para a main
     

    Imprime_Resultado:
        LinhaMaiorImpar:
            beq $s5, 0, NaoTemimpar                 #se $s5 for 0, nao tem impar, va para NaoTemimpar      
            la $a0, Lin_maior_elemento_Imp          #Carrega o endereço da String Lin_maior_elemento_Imp
            li $v0, 4                               #Codigo de impressão da string
            syscall                                 #imprime a string
            move $a0, $t5                           #linha do maior valor impar para a impressão
            li $v0, 1                               #codigo de impressão de inteiro
            syscall                                 #imprime linha do maior valor impar
            j LinhaMenor                            #pula para LinhaMenor
        NaoTemimpar:
            la $a0, Sem_Impar                       #Carrega o endereço da String Sem_Impar
            li $v0, 4                               #Codigo de impressão da string
            syscall                                 #imprime a string
        LinhaMenor:
            la $a0, Lin_menor_elemento              #Carrega o endereço da String Lin_maior_elemento_Imp
            li $v0, 4                               #Codigo de impressão da string
            syscall                                 #imprime a string
            move $a0, $t3                           #linha do maior valor impar para a impressão
            li $v0, 1                               #codigo de impressão de inteiro
            syscall                                 #imprime linha do maior valor impar
        jr $ra                                      #Retorna para a main


    Erro:
        li $v0, 4               # usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        # passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 # vai imprimir a mensagem que esta em $a0
        j N                     #vai pular para o bloco N novamente