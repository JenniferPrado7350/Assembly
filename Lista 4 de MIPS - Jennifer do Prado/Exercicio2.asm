.data
Mat: .space 144
entradaN: .asciiz "Entre com o valor inteiro de N (N>1) que será a dimensão da matriz quadrada: "               
msg_erro: .asciiz "O valor digitado tem que ser inteiro e maior que 1. "  
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
permutacao: .asciiz "A matriz é de permutação!"
naoPermutacao: .asciiz "A matriz NAO é de permutação!"

.text
main:   
    N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        ble $v0, 1, Erro        #caso o valor digitado que esta no registrador de valor $v0 for menor ou igual ao inteiro "1", vai para Erro
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0, é a dimensão da matriz
        subi $s1, $s0, 1        #guarda em $s1 o número digitado "N" - 1

    Estrutura:
        la $a0, Mat     #endereco base de mat
        jal leitura     #leitura(mat,dimensão)
        move $a0, $v0   #Endereço da matriz lida
        jal escrita     #escrita(mat,dimensão)
        move $a0, $v0   #Endereço da matriz retornada
        jal Verifica_Nulos_Linha     #Verifica_Nulos_Linha(mat,dimensão) vai verificar se é permutação nas linhas
        move $a0, $v0   #Endereço da matriz retornada
        jal Verifica_Nulos_Coluna    #Verifica_Nulos_Coluna(mat,dimensão) vai verificar se é permutação nas colunas
        li $v0, 10      #codigo para finalizar o programa
        syscall         #finaliza o programa

    indice:
        mul $v0, $t0, $s0 #i * ncol
        add $v0, $v0, $t1 #(i * ncol) + j
        sll $v0, $v0, 2   #[(i * ncol) + j] * 4 (inteiro)
        add $v0, $v0, $a1 #soma o endereço base de mat
        jr $ra            #retorna para o caller

    leitura:
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #salva o retorno para a main
        move $a1, $a0    #aux = endereço base de mat
    l:  la $a0, Ent1     #Carrega o endereço da String
        li $v0, 4        #Codigo de impressão da string
        syscall          #imprime a string
        move $a0, $t0    #valor de i para a impressão
        li $v0, 1        #codigo de impressão de inteiro
        syscall          #imprime i
        la $a0, Ent2     #Carrega o endereco da string
        li $v0, 4        #codigo de impressão de string
        syscall          #imprime a string
        move $a0, $t1    #valor de j para a impressão
        li $v0, 1        #codigo de impressão de inteiro
        syscall          #imprime j
        la $a0, Ent3     #carrega o endereço da string
        li $v0, 4        #Codigo de impressão da string
        syscall          #imprime a string
        li $v0, 5        #codigo de leitura de inteiro
        syscall          #leitura do valor (retorna em $v0)
        move $t2, $v0    #aux = valor lido
        jal indice       #calcula o endereço de mat[i][j]
        sw $t2, ($v0)    #mat [i][j] = aux
        addi $t1, $t1, 1 #j++
        blt $t1, $s0, l  #se (j < ncol) goto l
        li $t1, 0        #j = 0
        addi $t0, $t0, 1 #i++
        blt $t0, $s0, l  #se (i < nlin) goto l
        li $t0, 0        #i = 0
        lw $ra, ($sp)    #recupera o retorno para a main
        addi $sp, $sp, 4 #libera o espaço na pilha
        move $v0, $a1    #Endereço base da matriz para retorno
        jr $ra           #Retorna para a main

    escrita:
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
        move $a1, $a0    #aux = endereço base de mat
    e:  jal indice       #calcula o endereço de mat[i][j]
        lw $a0, ($v0)    #valor em mat[i][j]
        li $v0, 1        #codigo de impressão de inteiro
        syscall          #imprime [i][j]
        la $a0, 32       #codigo ASCII para espaço
        li $v0, 11       #codigo de impressão de caractere
        syscall          #imprime o espaço
        addi $t1, $t1, 1 #j++
        blt $t1, $s0, e  #se (j < ncol) goto e
        la $a0, 10       #codigo ASCII parea newline ('\n')
        syscall          #pula a linha
        li $t1, 0        #j = 0
        addi $t0, $t0, 1 #i++
        blt $t0, $s0, e  #se (i < nlin) goto e
        li $t0, 0        #i = 0
        la $a0, 10       #codigo ASCII parea newline ('\n')
        syscall          #pula a linha
        lw $ra, ($sp)    #recupera o retorno para a main
        addi $sp, $sp, 4 #libera o espaço na pilha
        move $v0, $a1    #endereço base da matriz para retorno
        jr $ra           #retorna pa a main

    Verifica_Nulos_Linha:
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
        move $a1, $a0    #aux = endereço base de mat
        li $s2, 0        #vai guardar a quantidade de 0 na linha
    VerL: jal indice     #calcula o endereço de mat[i][j]
        lw $s3, ($v0)    #valor em mat[i][j]
        bne $s3, $zero, Verifica_Se_Um_Linha  #se o valor diferente de 0 vai para Verifica_Se_Um_Linha 
        addi $s2, $s2, 1 #incrementa o numero de zeros da linha
        j Continua_Iteracao_Linha             #vá para Continua_Iteracao
        Verifica_Se_Um_Linha:  #vai verificar se valor =! de 0 é 1
            li $s4, 1    #inicio $s4 com 1
            bne $s3, $s4, Nao_Permutacao  #se o valor em $s3 for diferente de 1 vai para Nao_Permutacao 
        Continua_Iteracao_Linha:
            addi $t1, $t1, 1             #j++
            blt $t1, $s0, VerL           #se (j < ncol) goto VerL
            li $t1, 0                    #j = 0
            bne $s2, $s1, Nao_Permutacao #se a quantidade de 0 na linha não for n-1 vá para Nao_Permutacao
            li $s2, 0                    #reinicio $s2 com 0 para verificar os zeros da proxima linha
            addi $t0, $t0, 1             #i++
            blt $t0, $s0, VerL           #se (i < nlin) goto VerL
            li $t0, 0                    #i = 0
            lw $ra, ($sp)                #recupera o retorno para a main
            addi $sp, $sp, 4             #libera o espaço na pilha
            move $v0, $a1                #endereço base da matriz para retorno
            jr $ra                       #retorna para a main

    Verifica_Nulos_Coluna:
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
        move $a1, $a0    #aux = endereço base de mat
        li $s2, 0        #vai guardar a quantidade de 0 na coluna
    VerC: jal indice     #calcula o endereço de mat[i][j]
        lw $s3, ($v0)    #valor em mat[i][j]
        bne $s3, $zero, Verifica_Se_Um_Coluna  #se o valor diferente de 0 vai para Verifica_Se_Um_Coluna 
        addi $s2, $s2, 1                       #incrementa o numero de zeros da coluna
        j Continua_Iteracao_Coluna             #vá para Continua_Iteracao
        Verifica_Se_Um_Coluna:                 #vai verificar se valor =! de 0 é 1
            li $s4, 1                          #inicio $s4 com 1
            bne $s3, $s4, Nao_Permutacao       #se o valor em $s3 for diferente de 1 vai para Nao_Permutacao 
        Continua_Iteracao_Coluna:
            addi $t0, $t0, 1             #i++
            blt $t0, $s0, VerC           #se (i < nlin) goto VerC
            li $t0, 0                    #i = 0
            bne $s2, $s1, Nao_Permutacao #se a quantidade de 0 na coluna não for n-1 vá para Nao_Permutacao
            li $s2, 0                    #reinicio $s2 com 0 para verificar os zeros da proxima coluna
            addi $t1, $t1, 1             #j++
            blt $t1, $s0, VerC           #se (j < ncol) goto VerC
            li $t1, 0                    #j = 0
            li $v0, 4                    #usando o codigo SysCall para escrever strings      
            la $a0, permutacao           #passando a mensagem que estava na memoria na variavel "permutacao" para o registrador de argumento $a0 (string a ser escrita)
            syscall                      #vai imprimir a mensagem que esta em $a0
            lw $ra, ($sp)                #recupera o retorno para a main
            addi $sp, $sp, 4             #libera o espaço na pilha
            move $v0, $a1                #endereço base da matriz para retorno
            jr $ra                       #retorna para a main

    Nao_Permutacao:             #a matriz não é permutação
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, naoPermutacao   #passando a mensagem que estava na memoria na variavel "naoPermutacao" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 10              #codigo para finalizar o programa
        syscall                 #finaliza o programa
    
    Erro:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        jal N                   #vai pular para o bloco N novamente