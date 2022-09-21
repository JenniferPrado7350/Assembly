.data
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
entradaN: .asciiz "Entre com o valor inteiro de N (0 < N < 9) que será a dimensão da matriz quadrada: "               
msg_erro: .asciiz "O valor digitado tem que ser inteiro maior que 0 e menor que 9. "  
Resul_MatCodificada: .asciiz "\n\nMatriz codificada pelo Código de Cezar de Ordem 3:\n\n"


.text
main:  

    N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        blt $v0, 1, Erro        #caso o valor digitado que esta no registrador de valor $v0 for menor que o inteiro "1", vai para Erro
        bgt	$v0, 8, Erro	    #caso o valor digitado que esta no registrador de valor $v0 for maior que o inteiro "8", vai para Erro
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0

    Estrutura:
        move $s1, $s0                       #número de linhas
        move $s2, $s0                       #número de colunas
        jal leitura                         #le os elementos da matriz Mat
        move $a1, $v0                       #Coloca o endereco da matriz Mat retornado da funcao "leitura" em $a1
        jal escrita                         #escrita(Mat, nlin, ncol)
        move $a1, $v0                       #Coloca o endereco da matriz Mat retornado da funcao "escrita" em $a1
        jal CodigoDeCezar                   #vai codificar a matriz Mat
        move $a1, $v0                       #Coloca o endereco da matriz Mat retornado da funcao "CodigoDeCezar" em $a1
        li $v0, 4                           #usando o codigo SysCall para escrever strings
        la $a0, Resul_MatCodificada         #passando a mensagem que estava na memoria na variavel "Resul_MatCodificada" para o registrador de argumento $a0 (string a ser escrita)
        syscall                             #vai imprimir a mensagem que esta em $a0
        jal escrita                         #escrita(Mat, nlin, ncol)
        li $v0, 10                          #codigo para finalizar o programa
        syscall                             #finaliza o programa

    indice:
        mul $v0, $t0, $s2   #i * ncol
        add $v0, $v0, $t1   #(i * ncol) + j
        add $v0, $v0, $a3   #soma o endereço base de mat
        jr $ra              #retorna para o caller

    leitura:
        move $s3, $s0        #guardando em $s3 N bytes
        mul $s3, $s3, $s0    #guardando em $s3 N*N bytes, ja que vamos alocar uma matriz N*N
        move $a0, $s3        #passando N*N bytes guardados em $s3 para o registrador de argumento $a0
        li $v0, 9            #codigo de alocação dinamica help
        syscall              #aloca N*N bytes (endereço em $v0)
        move $a3, $v0        #move para $a3
        subi $sp, $sp, 4     #Espaço para 1 item na pilha
        sw $ra, ($sp)        #salva o retorno para a main
    l:  la $a0, Ent1         #Carrega o endereço da String
        li $v0, 4            #Codigo de impressão da string
        syscall              #imprime a string
        move $a0, $t0        #valor de i para a impressão
        li $v0, 1            #codigo de impressão de inteiro
        syscall              #imprime i
        la $a0, Ent2         #Carrega o endereco da string
        li $v0, 4            #codigo de impressão de string
        syscall              #imprime a string
        move $a0, $t1        #valor de j para a impressão
        li $v0, 1            #codigo de impressão de inteiro
        syscall              #imprime j
        la $a0, Ent3         #carrega o endereço da string
        li $v0, 4            #Codigo de impressão da string
        syscall              #imprime a string
        li $v0, 12           #codigo de leitura de caractere
        syscall              #leitura do valor (retorna em $v0)
        la $s3, ($v0)        #aux = valor lido
        jal indice           #calcula o endereço de mat[i][j]
        sb $s3, ($v0)        #mat [i][j] = aux
        addi $t1, $t1, 1     #j++
        blt $t1, $s2, l      #se (j < ncol) goto l
        li $t1, 0            #j = 0
        addi $t0, $t0, 1     #i++
        blt $t0, $s1, l      #se (i < nlin) goto l
        li $t0, 0            #i = 0
        lw $ra, ($sp)        #recupera o retorno para a main
        addi $sp, $sp, 4     #libera o espaço na pilha
        move $v0, $a3        #Endereço base da matriz para retorno
        jr $ra               #Retorna para a main

    escrita:
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
        move $a3, $a1    #aux = endereço base de mat
    e:  jal indice       #calcula o endereço de mat[i][j]
        lb $a0, ($v0)    #valor em mat[i][j]
        li $v0, 11       #codigo de impressão de caractere
        syscall          #imprime mat[i][j]
        la $a0, 32       #codigo ASCII para espaço
        li $v0, 11       #codigo de impressão de caractere
        syscall          #imprime o espaço
        addi $t1, $t1, 1 #j++
        blt $t1, $s2, e  #se (j < ncol) goto e
        la $a0, 10       #codigo ASCII parea newline ('\n')
        syscall          #pula a linha
        li $t1, 0        #j = 0
        addi $t0, $t0, 1 #i++
        blt $t0, $s1, e  #se (i < nlin) goto e
        li $t0, 0        #i = 0
        lw $ra, ($sp)    #recupera o retorno para a main
        addi $sp, $sp, 4 #libera o espaço na pilha
        move $v0, $a3    #endereço base da matriz para retorno
        jr $ra           #retorna para a main

    

    CodigoDeCezar:          
        subi $sp, $sp, 4                    #Espaço para 1 item na pilha
        sw $ra, ($sp)                       #Salva o retorno para a main
        move $a3, $a1                       #aux = endereço base de mat
    Muda_Caracteres:                        #laço para codificar a matriz
        li $s5, 3                           #inicio $s5 com 3
        jal indice                          #calcula o endereço de mat[i][j]
        lb $a0, ($v0)                       #valor em mat[i][j]
        bne $a0, 'x', X                     #verifica se o caractere em $a0 é diferente do caractere 'x'
            li $a0, 'a'                     #guardo em $a0 o ascii 'a'
            li $s5, 0                       #guardo em $s0 o valor que preciso adicionar a $a0 para chegar no char x codificado com Cezar
        X: bne $a0, 'X', y                  #verifica se o caractere em $a0 é diferente do caractere 'X'
            li $a0, 'A'                     #guardo em $a0 o ascii 'A'
            li $s5, 0                       #guardo em $s0 o valor que preciso adicionar a $a0 para chegar no char X codificado com Cezar
        y: bne $a0, 'y', Y                  #verifica se o caractere em $a0 é diferente do caractere 'y'
            li $a0, 'a'                     #guardo em $a0 o ascii 'a'
            li $s5, 1                       #guardo em $s0 o valor que preciso adicionar a $a0 para chegar no char y codificado com Cezar
        Y: bne $a0, 'Y', z                  #verifica se o caractere em $a0 é diferente do caractere 'Y'
            li $a0, 'A'                     #guardo em $a0 o ascii 'A'
            li $s5, 1                       #guardo em $s0 o valor que preciso adicionar a $a0 para chegar no char Y codificado com Cezar
        z: bne $a0, 'z', Z                  #verifica se o caractere em $a0 é diferente do caractere 'z'
            li $a0, 'a'                     #guardo em $a0 o ascii 'a'
            li $s5, 2                       #guardo em $s0 o valor que preciso adicionar a $a0 para chegar no char z codificado com Cezar
        Z: bne $a0, 'Z', Guarda_Caractere   #verifica se o caractere em $a0 é diferente do caractere 'Z'
            li $a0, 'A'                     #guardo em $a0 o ascii 'A'
            li $s5, 2                       #guardo em $s0 o valor que preciso adicionar a $a0 para chegar no char Z codificado com Cezar
        Guarda_Caractere:
            add $a0, $a0, $s5               #o codigo ascii em $a0 é adicionado com o valor em $s0 para codificar
            sb $a0, ($v0)                   #devolvo o caractere codificado para a matriz
            addi $t1, $t1, 1                #j++
            blt $t1, $s2, Muda_Caracteres   #se (j < ncol) goto Muda_Caracteres
            li $t1, 0                       #j = 0
            addi $t0, $t0, 1                #i++
            blt $t0, $s1, Muda_Caracteres   #se (i < nlin) goto Muda_Caracteres
            li $t0, 0                       #i = 0
            lw $ra, ($sp)                   #recupera o retorno para a main
            addi $sp, $sp, 4                #libera o espaço na pilha
            move $v0, $a3                   #endereço base da matriz para retorno
            jr $ra                          #retorna para a main

    Erro:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        jal N                   #vai pular para o bloco N novamente