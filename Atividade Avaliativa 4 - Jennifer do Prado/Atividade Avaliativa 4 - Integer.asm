.data
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
Soma_Diag_Secun: .asciiz "\n\nA soma dos elementos da diagonal secundaria: "


.text
main:  
    Estrutura:
    	li $s0, 3			                #carrego $s0 com a ordem da matriz
        move $s1, $s0                       #numero de linhas
        move $s2, $s0                       #numero de colunas
        jal leitura                         #le os elementos da matriz Mat
        move $a1, $v0                       #Coloca o endereco da matriz Mat retornado da funcao "leitura" em $a1
        jal escrita                         #escrita(Mat, nlin, ncol)
        move $a1, $v0                       #Coloca o endereco da matriz Mat retornado da funcao "escrita" em $a1
        li $v0, 4                           #usando o codigo SysCall para escrever strings
        la $a0, Soma_Diag_Secun		        #passando a mensagem que estava na memoria na variavel "Soma_Diag_Secun" para o registrador de argumento $a0 (string a ser escrita)
        syscall                             #vai imprimir a mensagem que esta em $a0
        li $v0, 1			                #usando o codigo SysCall para escrever inteiros
        move $a0, $t2		                #valor do somatorio para a impressao
        syscall				                #imprime o inteiro
        li $v0, 10                          #codigo para finalizar o programa
        syscall                             #finaliza o programa

    indice:
        mul $v0, $t0, $s2   #i * ncol
        add $v0, $v0, $t1   #(i * ncol) + j
        sll $v0, $v0, 2     #[(i * ncol) + j] * 4 (inteiro)
        add $v0, $v0, $a3   #soma o endereco base de mat
        jr $ra              #retorna para o caller

    leitura:
    	li $t2, 0	         #vai guardar o somatorio dos elementos da diagonal secundaria		
        mul $s3, $s0, 4      #guardando em $s3 N*4 bytes
        mul $s3, $s3, $s0    #guardando em $s3 N*N*4 bytes, ja que vamos alocar uma matriz N*N
        move $a0, $s3        #passando N*N*4 bytes guardados em $s3 para o registrador de argumento $a0
        li $v0, 9            #codigo de alocacao dinamica help
        syscall              #aloca N*N*4 bytes (endereco em $v0)
        move $a3, $v0        #move para $a3
        subi $sp, $sp, 4     #Espaco para 1 item na pilha
        sw $ra, ($sp)        #salva o retorno para a main
    l:  la $a0, Ent1         #Carrega o endereco da String
        li $v0, 4            #Codigo de impressao da string
        syscall              #imprime a string
        move $a0, $t0        #valor de i para a impressao
        li $v0, 1            #codigo de impressao de inteiro
        syscall              #imprime i
        la $a0, Ent2         #Carrega o endereco da string
        li $v0, 4            #codigo de impressao de string
        syscall              #imprime a string
        move $a0, $t1        #valor de j para a impressao
        li $v0, 1            #codigo de impressao de inteiro
        syscall              #imprime j
        la $a0, Ent3         #carrega o endereco da string
        li $v0, 4            #Codigo de impressao da string
        syscall              #imprime a string
        li $v0, 5            #codigo de leitura de inteiro
        syscall              #leitura do valor (retorna em $v0)
        move $a0, $v0        #aux = valor lido
        move $s3, $a0        #guarda valor lido em $s3
        addi $s4, $s0, 1     #n+1
        add $s5, $t1, $t0    #$s5 recebe j-1 + i-1
        addi $s5, $s5, 2     #$s5 recebe j + i
        bne $s5, $s4, Continua #se j+i != de n+1, va para Continua
        add $t2, $t2, $s3    #faz o somatorio da diagonal secundaria
     Continua:
        jal indice           #calcula o endereco de mat[i][j]
        sw $s3, ($v0)        #mat [i][j] = aux
        addi $t1, $t1, 1     #j++
        blt $t1, $s2, l      #se (j < ncol) goto l
        li $t1, 0            #j = 0
        addi $t0, $t0, 1     #i++
        blt $t0, $s1, l      #se (i < nlin) goto l
        li $t0, 0            #i = 0
        lw $ra, ($sp)        #recupera o retorno para a main
        addi $sp, $sp, 4     #libera o espaco na pilha
        move $v0, $a3        #Endereco base da matriz para retorno
        jr $ra               #Retorna para a main

    escrita:
        subi $sp, $sp, 4 #Espaco para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
        move $a3, $a1    #aux = endereco base de mat
    e:  jal indice       #calcula o endereco de mat[i][j]
        lw $a0, ($v0)    #valor em mat[i][j]
        li $v0, 1        #codigo de impressao de inteiro
        syscall          #imprime mat[i][j]
        la $a0, 32       #codigo ASCII para espaco
        li $v0, 11       #codigo de impressao de caractere
        syscall          #imprime o espaco
        addi $t1, $t1, 1 #j++
        blt $t1, $s2, e  #se (j < ncol) goto e
        la $a0, 10       #codigo ASCII parea newline ('\n')
        syscall          #pula a linha
        li $t1, 0        #j = 0
        addi $t0, $t0, 1 #i++
        blt $t0, $s1, e  #se (i < nlin) goto e
        li $t0, 0        #i = 0
        lw $ra, ($sp)    #recupera o retorno para a main
        addi $sp, $sp, 4 #libera o espaco na pilha
        move $v0, $a3    #endereco base da matriz para retorno
        jr $ra           #retorna para a main

    

    