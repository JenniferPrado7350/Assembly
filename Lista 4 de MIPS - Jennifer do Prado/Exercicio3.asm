.data
Mat: .space 144
entradaN: .asciiz "Entre com o valor inteiro de N (N>0) que será a quantidade de colunas da matriz: "  
entradaM: .asciiz "Entre com o valor inteiro de M (M>0) que será a quantidade de linhas da matriz: "              
msg_erro: .asciiz "O valor digitado tem que ser inteiro e maior que 0. "  
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
nmrLinhas: .asciiz "O numero de linhas nulas da matriz é: "
nmrColunas: .asciiz "\n\nO numero de colunas nulas da matriz é: "

.text
main: 

    M: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaM        #passando a mensagem que estava na memoria na variavel "entradaM" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "M" foi lido e esta em $v0
        ble $v0, 0, ErroM       #caso o valor digitado que esta no registrador de valor $v0 for menor ou igual ao inteiro "0", vai para ErroM
        add $s0, $v0, $zero     #guarda em $s1 o número digitado "M" que esta em $v0, numero de linhas

    N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        ble $v0, 0, ErroN       #caso o valor digitado que esta no registrador de valor $v0 for menor ou igual ao inteiro "0", vai para ErroN
        add $s1, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0, numero de colunas

    Estrutura:
        la $a0, Mat     #endereco base de mat
        jal leitura     #leitura(mat,dimensão)
        move $a0, $v0   #Endereço da matriz lida
        jal escrita     #escrita(mat,dimensão)
        move $a0, $v0   #Endereço da matriz retornada
        jal Verifica_Linhas_Nulas     #Verifica_Linhas_Nulas(mat,M) vai verificar quantas linhas são nulas
        move $a0, $v0   #Endereço da matriz retornada
        jal Verifica_Colunas_Nulas    #Verifica_Colunas_Nulas(mat,N) vai verificar quantas colunas são nulas
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
        sw $t2, ($v0)    #mat[i][j] = aux
        addi $t1, $t1, 1 #j++
        blt $t1, $s1, l  #se (j < ncol) goto l
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
        blt $t1, $s1, e  #se (j < ncol) goto e
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

    Verifica_Linhas_Nulas:
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
        move $a1, $a0    #aux = endereço base de mat
        li $s2, 0        #vai ser verificador para analisar se todos elementos da linha são nulos
        li $t2, 0        #vai guardar a quantidade de linhas nulas
    VerL: jal indice     #calcula o endereço de mat[i][j]
        lw $s3, ($v0)    #valor em mat[i][j]
        bne $s3, $zero, Proxima_Linha  #se o valor diferente de 0 vai para Proxima_Linha 
        addi $s2, $s2, 1               #incrementa o numero de zeros da linha
        addi $t1, $t1, 1               #j++
        blt $t1, $s1, VerL             #se (j < ncol) goto VerL
        bne $s2, $s1, Proxima_Linha    #se a quantidade de 0 na linha não for ncol, vá para Proxima_Linha
        addi $t2, $t2, 1               #incrementa o numero de linhas nulas
        Proxima_Linha:
            li $t1, 0                    #j = 0
            li $s2, 0                    #reinicio $s2 com 0 para verificar os zeros da proxima linha
            addi $t0, $t0, 1             #i++
            blt $t0, $s0, VerL           #se (i < nlin) goto VerL
            li $t0, 0                    #i = 0
        RetornoL:
            li $v0, 4                    #usando o codigo SysCall para escrever strings      
            la $a0, nmrLinhas            #passando a mensagem que estava na memoria na variavel "nmrLinhas" para o registrador de argumento $a0 (string a ser escrita)
            syscall                      #vai imprimir a mensagem que esta em $a0
            move $a0, $t2                #valor do numeros de linhas nulas para a impressão
            li $v0, 1                    #codigo de impressão de inteiro
            syscall                      #imprime i
            lw $ra, ($sp)                #recupera o retorno para a main
            addi $sp, $sp, 4             #libera o espaço na pilha
            move $v0, $a1                #endereço base da matriz para retorno
            jr $ra                       #retorna para a main

    Verifica_Colunas_Nulas:
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
        move $a1, $a0    #aux = endereço base de mat
        li $s2, 0        #vai ser verificador para analisar se todos elementos da coluna são nulos
        li $t2, 0        #vai guardar a quantidade de colunas nulas
    VerC: jal indice     #calcula o endereço de mat[i][j]
        lw $s3, ($v0)    #valor em mat[i][j]
        bne $s3, $zero, Proxima_Coluna  #se o valor diferente de 0 vai para Proxima_Coluna 
        addi $s2, $s2, 1                #incrementa o numero de zeros da coluna
        addi $t0, $t0, 1                #i++
        blt $t0, $s0, VerC              #se (i < nlin) goto VerC
        bne $s2, $s0, Proxima_Coluna    #se a quantidade de 0 na coluna não for nlin, vá para Proxima_Coluna
        addi $t2, $t2, 1                #incrementa o numero de colunas nulas
        Proxima_Coluna:
            li $t0, 0                    #i = 0
            li $s2, 0                    #reinicio $s2 com 0 para verificar os zeros da proxima coluna
            addi $t1, $t1, 1             #j++
            blt $t1, $s1, VerC           #se (j < ncol) goto VerC
            li $t1, 0                    #j = 0
        RetornoC:
            li $v0, 4                    #usando o codigo SysCall para escrever strings      
            la $a0, nmrColunas           #passando a mensagem que estava na memoria na variavel "nmrColuna" para o registrador de argumento $a0 (string a ser escrita)
            syscall                      #vai imprimir a mensagem que esta em $a0
            move $a0, $t2                #valor do numeros de colunas nulas para a impressão
            li $v0, 1                    #codigo de impressão de inteiro
            syscall                      #imprime i
            lw $ra, ($sp)                #recupera o retorno para a main
            addi $sp, $sp, 4             #libera o espaço na pilha
            move $v0, $a1                #endereço base da matriz para retorno
            jr $ra                       #retorna para a main
    
    ErroN:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        jal N                   #vai pular para o bloco N novamente

    ErroM:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        jal M                   #vai pular para o bloco M novamente
